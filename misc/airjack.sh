#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

source "${BASH_SOURCE%/*}/../util/apps.sh"

# AirJack — WiFi handshake capture + cracking, for auditing your OWN networks.
# https://github.com/rtulke/AirJack
# Opt-in: deliberately NOT wired into misc/ALL.sh. Run it by hand when you want it.

BLUE="$(tput setaf 4 2>/dev/null || true)"
YELLOW="$(tput setaf 3 2>/dev/null || true)"
RESET="$(tput sgr0 2>/dev/null || true)"

# Pin to a reviewed commit; bump deliberately after reading upstream's changes.
AIRJACK_REPO="https://github.com/rtulke/AirJack.git"
AIRJACK_COMMIT="a6f88ef9f626db8aff6f45d6c6c4445168d705fa"
AIRJACK_DIR="$HOME/.local/share/airjack"

# Capture/crack backends. AirSnare is AirJack's recommended capture backend (its
# own tap); hashcat + hcxtools are in homebrew-core. (zizzania is a source-built
# alternative backend — build it by hand from https://github.com/cyrus-and/zizzania
# only if you need it.)
#
# Homebrew refuses to run a third-party tap's formula code until it's trusted.
# The airsnare formula is a checksummed tarball build (reviewed before adding this).
brew tap rtulke/airsnare
brew-trust --tap rtulke/airsnare
brew install --quiet airsnare hashcat hcxtools

# Fetch AirJack's source at the pinned commit. Idempotent: clone once, then sync.
if [[ -d "$AIRJACK_DIR" && ! -d "$AIRJACK_DIR/.git" ]]; then
    echo "$0: $AIRJACK_DIR exists but is not a git clone; remove it and re-run." >&2
    exit 1
fi
if [[ -d "$AIRJACK_DIR/.git" ]]; then
    git -C "$AIRJACK_DIR" fetch --quiet origin
else
    git clone --quiet "$AIRJACK_REPO" "$AIRJACK_DIR"
fi
git -C "$AIRJACK_DIR" checkout --quiet "$AIRJACK_COMMIT"

# macOS 15+ breaks Location Services inside a virtualenv, so AirJack runs under
# system Python. Install its dependencies for that same interpreter.
airjack_python() {
    local macos_major
    macos_major="$(sw_vers -productVersion | cut -d. -f1)"
    if [[ "$macos_major" -ge 15 ]] && command -v /usr/bin/python3 &>/dev/null; then
        echo "/usr/bin/python3"
    else
        echo "python3"
    fi
}
PYTHON="$(airjack_python)"

# --user keeps these out of the system site-packages; the --break-system-packages
# retry satisfies PEP 668 "externally managed" interpreters. requirements.txt
# already includes scapy, so the airdetect.py passive scanner works too.
#
# --only-binary forces prebuilt wheels: macOS system Python is 3.9, and the newest
# pyobjc (12+) ships no cp39 wheel, so a plain install tries to COMPILE it — which
# fails under current clang (-Werror on -Wdefault-const-init-var-unsafe). Wheels
# resolve to pyobjc 11.1 (the last cp39 wheel) and skip the broken source build.
pip_install=(-m pip install --user --only-binary=:all: -r "$AIRJACK_DIR/requirements.txt")
"$PYTHON" "${pip_install[@]}" || "$PYTHON" "${pip_install[@]}" --break-system-packages

# Fail loudly if the wheel install above silently went wrong — these are exactly
# the imports that break when pyobjc compiles from source instead of using wheels.
"$PYTHON" -c 'import CoreWLAN, CoreLocation, scapy'

# Put `airjack` on PATH. The launcher locates airjack.py beside itself, so a bare
# symlink wouldn't resolve; a wrapper that execs the pinned launcher does.
mkdir -p "$HOME/.local/bin"
chmod +x "$AIRJACK_DIR/airjack"
cat >"$HOME/.local/bin/airjack" <<EOF
#!/bin/bash
exec "$AIRJACK_DIR/airjack" "\$@"
EOF
chmod +x "$HOME/.local/bin/airjack"

# Man page, in the user manpath.
mkdir -p "$HOME/.local/share/man/man1"
ln -sf "$AIRJACK_DIR/airjack.1" "$HOME/.local/share/man/man1/airjack.1"

# Seed a default config so AirJack works out of the box. Its own path detection is
# unreliable for airsnare (it can write a non-existent ~/airsnare/src path), so pin
# both backends to the binaries installed above. Call the launcher by absolute path
# — ~/.local/bin may not be on PATH during this run. Never clobber a user's config.
if [[ ! -f "$HOME/.airjack.conf" ]]; then
    "$AIRJACK_DIR/airjack" -C "$HOME/.airjack.conf" >/dev/null
    hashcat_bin="$(command -v hashcat)"
    airsnare_bin="$(command -v airsnare)"
    sed -i '' \
        -e "s|^hashcat_path = .*|hashcat_path = ${hashcat_bin}|" \
        -e "s|^airsnare_path = .*|airsnare_path = ${airsnare_bin}|" \
        "$HOME/.airjack.conf"
    # A future pin bump could rename this key and silently defeat the fix above.
    grep -qx "airsnare_path = ${airsnare_bin}" "$HOME/.airjack.conf" ||
        echo "$0: warning: could not pin airsnare_path in ~/.airjack.conf" >&2
fi

echo "${BLUE}AirJack installed.${RESET} Run it as your normal user: ${BLUE}airjack --help${RESET}"
echo "${YELLOW}Only use AirJack on networks you own or are explicitly authorized to test.${RESET}"
echo "${YELLOW}On the first real run, grant Location Services to your terminal/Python when${RESET}"
echo "${YELLOW}prompted (System Settings > Privacy & Security > Location Services); captures need sudo.${RESET}"
