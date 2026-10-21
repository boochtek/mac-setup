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

# Preview source code files with syntax highlighting.
# TODO: Customize. See https://github.com/sbarex/SourceCodeSyntaxHighlight#install-with-homebrew-cask.
brew-install-cask syntax-highlight

# Preview plain text files without a file extension (README, CHANGELOG, etc.).
brew-install-cask qlstephen
# Have QLStephen handle plist files.
plutil -insert CFBundleDocumentTypes.0.LSItemContentTypes.0 -string 'com.apple.property-list' "$HOME/Library/QuickLook/QLStephen.qlgenerator/Contents/Info.plist"
# Don't let QLColorCode handle plist files.
cp "$HOME/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist" "$HOME/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist.BAK"
index=$(plutil -convert json -r "$HOME/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist" -o - | jq '.CFBundleDocumentTypes[0].LSItemContentTypes | index("com.apple.property-list")')
plutil -remove "CFBundleDocumentTypes.0.LSItemContentTypes.$index" "$HOME/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist"

# Preview source code files for various programming languages, with syntax highlighting.
brew-install-cask qlcolorcode

# Preview JSON files.
brew-install-cask quicklook-json

# Preview CSV files.
brew-install-cask quicklook-csv

# Preview diffs.
brew-install-cask qlprettypatch

# Preview archives (ZIP, tar, gzip, bzip2, ARJ, LZH, ISO, etc.).
brew-install-cask betterzip

# Preview SSL/X509 certificate files (CRT, PEM, DER, etc.). (No longer available via Homebrew.)
#brew-install-cask cert-quicklook

# Preview WEBP images.
brew-install-cask webpquicklook

# Preview most video formats.
brew-install-cask qlvideo

# Preview AVIF images.
brew-install-cask avifquicklook

# Inspect the contents of .pkg installer packages before running them.
brew-install-cask suspicious-package

# Reload QuickLook daemon, so new plugins will work.
qlmanage -r

# Enable text selection in QuickLook views.
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
killall Finder
