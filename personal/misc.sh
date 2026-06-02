#!/bin/bash

# These are some miscellaneous tools I have written for myself.


# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x


brew tap boochtek/tap

brew install --quiet boochtek/tap/path
brew install --quiet boochtek/tap/lessfilter
brew install --quiet boochtek/tap/terminal
