#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Install Emacs (GUI and CLI).
brew-install-cask emacs

# Install "Noto Color Emoji" font, which will be used if no emojis can be found in other fonts.
brew install --cask --quiet font-noto-color-emoji

# Add icon to Dock.
dockutil --add  '/Applications/Emacs.app' --replacing 'Emacs' --after 'Visual Studio Code'

# Spacemacs uses Source Code Pro by default.
brew install --quiet --cask font-source-code-pro

# Install Spacemacs (which is just )
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# TODO: Install Spacemacs.
# To enable it, add these 2 lines to your `~/.emacs.d/init.el`:
# ~~~
# (setq spacemacs-start-directory "/usr/local/share/spacemacs/")
# (load-file (concat spacemacs-start-directory "init.el"))
# ~~~
