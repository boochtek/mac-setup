#!/bin/bash

# Enable strict mode + error trap only when run directly, not when sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -Euo pipefail
    IFS=$'\n\t'
    [[ -n "${DEBUG+unset}" ]] && set -x
    trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
fi

# Make sure we have latest defaults+.

sudo chown root:staff /usr/local/bin
sudo chmod g+w /usr/local/bin
curl --silent --fail -o /usr/local/bin/defaults+ https://raw.githubusercontent.com/boochtek/defaults_plus/master/defaults+
# Run it as a uv script, so uv provides Python and PyObjC (for `CoreFoundation`).
# (pip refuses to install packages into Homebrew's Python.)
uv add --quiet --script /usr/local/bin/defaults+ pyobjc-framework-Cocoa
# Lock the dependency versions now, rather than resolving them on every run.
uv lock --quiet --script /usr/local/bin/defaults+
sed -i '' '1s|.*|#!/usr/bin/env -S uv run --quiet --script|' /usr/local/bin/defaults+
chmod a+x /usr/local/bin/defaults+
hash -r
