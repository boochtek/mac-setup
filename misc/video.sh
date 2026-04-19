#!/bin/bash

# VLC is the old tried and true general-purpose video player.
brew install --quiet --cask vlc

# IINA is a newer Mac-only video player.
brew install --quiet --cask iina

# This is the go-to distribution of MPV for Mac.
brew install --quiet --cask stolendata-mpv

# Note that there's an outdated non-cask version of HandBrake.
brew install --quiet --cask handbrake

## Meeting apps

# Note that there's also webex-meetings, but that's a different app.
brew install --quiet --cask webex

# Zoom is the most popular meeting app.
brew install --quiet --cask zoom


# Download content from YouTube and many other video sites.
brew install --quiet yt-dlp

yt-dlp --list-impersonate-targets --no-playlist --impersonate="chrome:windows-10" --preset-alias mkv https://xhamster.com/videos/woman-s-guide-first-time-with-bbc-7576435
