#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# VLC is the old tried and true general-purpose video player.
brew-install-cask vlc

# IINA is a newer Mac-only video player.
brew-install-cask iina

# MPV is a minimal, scriptable video player. (Homebrew disabled the stolendata-mpv cask.)
brew install --quiet mpv

# Note that there's an outdated non-cask version of HandBrake.
brew-install-cask handbrake

## Meeting apps

# Note that there's also webex-meetings, but that's a different app.
brew-install-cask webex

# Zoom is the most popular meeting app.
brew-install-cask zoom


# Download content from YouTube and many other video sites.
brew install --quiet yt-dlp

yt-dlp --list-impersonate-targets --no-playlist --impersonate="chrome:windows-10" --preset-alias mkv https://xhamster.com/videos/woman-s-guide-first-time-with-bbc-7576435
