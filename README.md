# MacOS Setup

These scripts will set up MacOS the way we want, including:

- Configuring OS preferences
- Installing applications
- Configuring applications

These scripts currently support macOS 26 (Tahoe).
They have existed since at least MacOS 10.9 (Mavericks).

The scripts _should_ all be idempotent.
(That means that you can run them as many times as you want.)

You will likely be prompted for your password several times.
This is because many of the scripts use `sudo` to install various programs and settings.

## Usage

0. Open a Terminal window.

1. Make sure git is installed.

~~~ shell
git --version 2>/dev/null || echo 'Follow prompts to install command line developer tools. When it finishes, continue with the next step.'
~~~

2. Download the repo.
    - Use the HTTPS URL if SSH is not set up yet.
        - You'll want to switch to SSH if you want to commit changes.
            - Edit `.git/config` to change `https://github.com/` to `git@github.com:`.

~~~ shell
git clone https://github.com/boochtek/mac-setup.git
cd mac-setup
~~~

3. Edit `ENV.sh` to define various settings.
    - Be sure to read through and change any settings, as appropriate.
    - You can use `vi` or TextEdit instead of `nano`.
        - macOS has `nano` as a soft link to `pico`.

~~~ shell
nano ENV.sh
~~~

4. Run the initialization.
    - This will install CLT, Homebrew, and my config files.
    - The terminal app needs Full Disk Access (and App Management) first:
      System Settings > Privacy & Security. If it lacks it, this says so, opens
      System Settings, and stops; quit and reopen the terminal after granting it.
    - On a Mac with Touch ID, it first enables Touch ID for `sudo`, so the one
      password prompt it takes to set that up is the only one you'll need.

~~~ shell
source ./init.sh
~~~

5. Set up the OS, hardware, and shell.

~~~ shell
./os/ALL.sh
./hardware/ALL.sh
./shell/ALL.sh
~~~

6. Install web tools.

~~~ shell
./web/ALL.sh
~~~

   Firefox extensions are installed via Enterprise Policies written into the app bundle.
   **Restart Firefox after this step** to trigger extension installation.
   Re-run `web/firefox.sh` after any Firefox update (Homebrew reinstalls the app bundle).

7. Install tools for development work.

~~~ shell
./editors/ALL.sh
./dev/ALL.sh
~~~

8. Install the rest.

~~~ shell
./email/ALL.sh
./misc/ALL.sh
./personal/ALL.sh
~~~

## OLD!

Next, edit the config files:

- inventory_for_mac_serial_number.sh - add your computer to the list
- appstore_apps_to_install.yml - list of App Store apps to be installed

Theoretically, any of these scripts could be run independently.
(Except for the `util` directory, which contains shared code imported by other scripts.)
However, there are some (likely not adequately documented) dependencies.
This order should work:

~~~ shell
os/ALL.sh
hardware/ALL.sh
shell/ALL.sh
editors/ALL.sh
email/ALL.sh
web/ALL.sh
dev/ALL.sh
~~~

Many scripts will prompt for your password, as they require `sudo` to install various programs and settings.
Others might ask for other passwords, for example your Mac App Store ID and password.
You can just hit **Enter** on the Mac App store prompts, if you won't be installing anything from the Mac App Store.

Note that some of the scripts might take a while to run.
For example, installing Xcode may take over an hour.
The entire set of scripts will take several hours to run;
many packages will be downloaded and compiled.
Even if nothing new needs to be installed, the scripts could take about 8 minutes to run.

Note that some scripts will kill the Terminal.

## Manual Steps

See [MANUAL.md](MANUAL.md) for steps that have not (yet) been automated.

## Bash 3.2

Keep in mind that macOS ships with Bash 3.2.
MacOS will likely never ship with anything newer, due to Apple's dislike of GPLv3.
So we can't use any features introduced in Bash 4 or later:

- Associative arrays
- Case-modification operators for parameter substitution
- Globbing with `**` to match recursively
- Escape codes in strings with `\u` and `\U` to represent Unicode characters
- Negative array indices

## Strict Mode

Every executed script starts with a strict-mode header:

~~~ bash
set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
~~~

We use the `trap … ERR` handler (with `-E`/errtrace, so it also fires inside
functions and subshells) instead of `set -e`: it fails fast **and** reports the
script, line, and failing command. The diagnostic goes to **stderr**, so a script
whose stdout is captured as a value (`ip="$(some-script)"`) fails cleanly instead
of returning the error text. Run any script with `DEBUG=1` to trace it.

Sourced libraries (`util/`), the bootstrap entry points (`init.sh`, `ENV.sh`,
`init/`), and the `ALL.sh` orchestrators intentionally omit this header.
Dual-use scripts (sourced *and* executed) guard it behind
`[[ "${BASH_SOURCE[0]}" == "$0" ]]` so sourcing them can't exit the caller.

## Script Conventions

**A script with a shebang must be executable; a sourced file must not have one.**
The `ALL.sh` orchestrators run their scripts as `./name.sh`, which needs the
execute bit — and git tracks that bit, so a script committed without it fails
with "Permission denied" on every fresh clone even though it works on the machine
where it was written. Check with:

~~~ shell
find . -name '*.sh' -not -path './.git/*' ! -perm -u+x -exec head -1 {} \; -print | grep -B1 '^#!'
~~~

**Source other files relative to the script, not the working directory.** Use
`source "${BASH_SOURCE%/*}/../util/colors.sh"`; a bare `source 'colors.sh'` or a
`'../util/colors.sh'` resolves against whatever directory the caller happened to
be in, so it works only by luck.

**Install and open apps with the helpers in `util/apps.sh`.**
`brew-install-cask` (instead of `brew install --cask`) clears the quarantine
flag on apps from official casks, so they open without a Gatekeeper prompt.
`open-app` opens an app by its path, which works right after installing it.
`app-store-install` installs an App Store app by its ID, and `add-login-item`
starts an app at login. Tools that several scripts use (`mas`, `dockutil`,
`git-lfs`, `wget`, `uv`) are installed by `init/homebrew.sh`.

**A script that has nothing to do should `exit 0`, not `return`.** `return`
outside a function is an error in an executed script — it only works when the
file is sourced.

**A sourced file must not change the caller's working directory.** `init.sh` and
everything under `init/` are sourced, so a bare `cd` moves the shell for every
step that follows and relative paths quietly resolve somewhere else. Keep it in
a subshell: `(cd "$SOMEWHERE" && ./install.sh)`.

**Scripts must be able to run unattended.** The VM test harness (see
[test/README.md](test/README.md)) drives them over SSH, where nothing can answer
a prompt. In particular use `sudo -n true || sudo -v` rather than a bare
`sudo -v`: the latter tries to prompt and fails outright without a terminal,
while this form uses passwordless sudo when it is available and still prompts
interactively on real hardware. Steps that genuinely need a human belong in
[MANUAL.md](MANUAL.md).

## TODO: Downloading and Installing MacOS Sonoma

diskutil list external physical
diskutil info -all

DEVICE='device-name-found-above'
diskutil partitionDisk "$DEVICE" GPT JHFS+ 'Sonoma Installer'

~~~ shell
softwareupdate --fetch-full-installer
sudo '/Applications/Install macOS Monterey.app/Contents/Resources/createinstallmedia' \
  --volume '/Volumes/Sonoma Installer'
~~~


## Testing in a VM

These scripts can be run against a disposable macOS VM, so a fresh-Mac setup —
or a macOS upgrade — can be verified before it matters on real hardware:

~~~ shell
make setup   # one-time: install tart
make image   # one-time: build the VM image
make test    # run the suite on a throwaway clone
~~~

See [test/README.md](test/README.md) for the full workflow, and
[docs/vm-test-harness-prd.md](docs/vm-test-harness-prd.md) for why it is built
this way. Budget plenty of disk: each VM image runs about 20 GB.
