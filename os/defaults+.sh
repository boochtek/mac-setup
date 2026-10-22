#!/bin/bash

# Enable strict mode + error trap only when run directly, not when sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -Euo pipefail
    IFS=$'\n\t'
    [[ -n "${DEBUG+unset}" ]] && set -x
    trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
fi

# Make sure we have latest defaults+.
bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
defaults_plus="$bin_dir/defaults+"
mkdir -p "$bin_dir"
curl --silent --fail -o "$defaults_plus" https://raw.githubusercontent.com/boochtek/defaults_plus/master/defaults+
# Run it as a uv script, so uv provides Python and PyObjC (for `CoreFoundation`).
# (pip refuses to install packages into Homebrew's Python.)
uv add --quiet --script "$defaults_plus" pyobjc-framework-Cocoa
# Lock the dependency versions now, rather than resolving them on every run.
uv lock --quiet --script "$defaults_plus"
sed -i '' '1s|.*|#!/usr/bin/env -S uv run --quiet --script|' "$defaults_plus"
chmod a+x "$defaults_plus"
# Shells from before the config files were installed may not have it on PATH yet.
case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) export PATH="$bin_dir:$PATH" ;;
esac
hash -r
