#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x


# GitHub command line tool.
brew install --quiet gh

# NOTE: This will hang until you enter the one-time code in GitHub.
# Authenticate with GitHub, if we have not already.
if ! gh auth status > /dev/null 2>&1 ; then
    gh config set prompt disabled
    open https://github.com/login/device &
    gh auth login
fi

# GitHub Copilot CLI (`copilot`). It replaced the retired `gh copilot` extension.
# NOTE: It requires a Copilot subscription; log in with `/login` on first run.
brew install --quiet --cask copilot-cli
