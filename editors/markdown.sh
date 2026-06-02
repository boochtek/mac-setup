#!/bin/bash

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR


# Markdown support

# [Marksman](https://github.com/artempyanykh/marksman) is an LSP that supports completion, hover, goto definition/references, creating a Zettelkasten-like system
brew install marksman
