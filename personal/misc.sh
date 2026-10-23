#!/bin/bash

# These are some miscellaneous tools I have written for myself.

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

source "${BASH_SOURCE%/*}/../util/apps.sh"

brew tap boochtek/tap
brew-trust --tap boochtek/tap

brew install --quiet boochtek/tap/path
brew install --quiet boochtek/tap/lessfilter
brew install --quiet boochtek/tap/terminal-tool
