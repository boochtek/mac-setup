#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/privacy.sh"
require-full-disk-access

# mail.sh

## Applications / Mail

defaults write com.apple.mail 'PreferPlainText' -bool true
defaults write com.apple.mail 'DisableReplyAnimations' -bool true
defaults write com.apple.mail 'DisableSendAnimations' -bool true

# Don't mark a message as read until its been selected for 10 seconds. (Does not work in Monterey and newer.)
defaults write com.apple.mail 'MarkAsReadDelay' 10
