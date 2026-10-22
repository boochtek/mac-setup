#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Configure QuickLook to handle more file types.

## CREDITS:
##  Most of these were recommended by https://github.com/sindresorhus/quick-look-plugins
##  Text selection feature recommended by http://lifehacker.com/5874280/copy-text-from-quick-look-previews-with-a-terminal-hack

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
# Pre-authorize sudo. Skip the prompt when sudo is already passwordless, so
# unattended runs (such as the VM test harness over SSH) do not fail here.
sudo -n true 2>/dev/null || sudo -v

# Preview Markdown files.
# brew-install-cask qlmarkdown
brew trust --cask xykong/tap/flux-markdown
brew-install-cask xykong/tap/flux-markdown

# Preview source code (and JSON, plist, and more) with syntax highlighting.
# TODO: Customize. See https://github.com/sbarex/SourceCodeSyntaxHighlight#install-with-homebrew-cask.
brew-install-cask syntax-highlight

# Preview archives (ZIP, tar, gzip, bzip2, ARJ, LZH, ISO, etc.).
brew-install-cask betterzip

# Preview most video formats.
brew-install-cask quicklook-video

# NOTE: macOS 15+ no longer loads old-style Quick Look generators (`.qlgenerator`),
# and Homebrew disabled their casks: qlstephen, qlcolorcode, quicklook-json,
# quicklook-csv, qlprettypatch, webpquicklook, avifquicklook. The apps above use
# Quick Look extensions instead.

# Inspect the contents of .pkg installer packages before running them.
brew-install-cask suspicious-package

# Reload QuickLook daemon, so new plugins will work.
qlmanage -r

# Enable text selection in QuickLook views.
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
killall Finder
