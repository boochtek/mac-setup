#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
# Pre-authorize sudo. Skip the prompt when sudo is already passwordless, so
# unattended runs (such as the VM test harness over SSH) do not fail here.
sudo -n true 2>/dev/null || sudo -v

### TODO: sysdig/csysdig!!!
### TODO: slackcat

## Install some command-line utilities that we like to have.

# Ack is great for searching for things within a repo.
brew install --quiet ack

# The Silver Searcher (ag) is similar to Ack, newer and possibly better, but I still prefer Ack.
brew install --quiet the_silver_searcher

# HTop is a really nice replacement for top.
brew install --quiet htop
sudo chown root:wheel "$HOMEBREW_PREFIX"/Cellar/htop/*/bin/htop
sudo chmod u+s "$HOMEBREW_PREFIX"/Cellar/htop/*/bin/htop

# BTop is an even nicer replacement for top, with a more graphical interface.
brew install --quiet btop

# A couple other replacements for top. (Binary for `bottom` is `btm`.)
brew install --quiet glances
brew install --quiet bottom

# Tree is a nice tool to display a full directory hierarchy.
brew install --quiet tree

# [`eza`](https://eza.rocks) is a command to replace `ls`, with more useful features, including a tree view.
brew install --quiet eza

# LSD is another modern `ls` replacement, with a lot of features.
brew install --quiet lsd

# Pstree shows running processes as a tree, showing parent-child relationships.
brew install --quiet pstree

# Lesspipe is an input filter for `less`, allowing non-text files to be translated into text.
brew install --quiet lesspipe #--syntax-highlighting
# TODO: Make sure it's used by less automatically

# Lesspipe uses mdcat to "syntax highlight" Markdown files.
# Handles images (needs resvg for SVG), code highlighting, but not tables, footnotes, or HTML.
brew install --quiet mdcat
brew install --quiet resvg

# Mdless seems to be a bit better than mdcat.
# Handles images (including GIFs!), tables, footnotes.
# Requires chafa or imgcat (not in Homebrew) for images, and pygments for code highlighting.
brew install --quiet mdless
brew install --quiet chafa
brew install --quiet pygments

# Other Markdown viewers.
brew install --quiet glow

# `bat` is a tool like `cat`, but does syntax highlighting, git diffs, paging, etc.
# TODO: Use bat for (git) diff (`--diff`), ripgrep, man, less, .
brew install --quiet bat

# fzf is a great fuzzy file-finder.
brew install --quiet fzf

# Watch will continuously run a command.
#brew install watch # WARNING: Installation is currently broken.

# PV (Pipe Viewer) can be used in shell pipelines to show a progress bar.
brew install --quiet pv

# Occasionally we need to decompress FLAC and RAR files.
# (`unar` replaces the `rar` cask, which Homebrew disabled for failing Gatekeeper.)
brew install --quiet flac
brew install --quiet unar

# It's nice to occasionally show a fortune.
brew install --quiet fortune

# CLOC counts lines of code, broken down by language, with nice output.
brew install --quiet cloc

# Search inside (and pretty-print) JSON, YAML, XML, Markdown.
brew install --quiet jq yq xq mdq
# TUI playground for jq.
brew install --quiet jqp
# JSON viewer with paging, syntax highlighting, and interactive collapse/expand.
brew install --quiet jless
# Gron "flattens" JSON into discrete assignments, making it greppable (and un-grons back).
brew install --quiet gron

# Install some linting tools.
brew install --quiet proselint # English prose
brew install --quiet markdownlint-cli2
brew install --quiet libxml2 # xmllint
# npm install --global jsonlint
brew install --quiet yamllint
npm install --global eslint
brew install --quiet ansible-lint

# Install some newer tools that Mac OS X already has.
brew install --quiet diffutils
brew install --quiet colordiff
brew install --quiet nano
brew install --quiet grep
brew install --quiet less

# Sometimes we get DOS-style text files and want to strip out the carriage returns.
brew install --quiet dos2unix

## From https://github.com/ptb/Mac-OS-X-Lion-Setup/blob/master/setup.sh

# TODO: Don't need to keep track of recent documents, applications, or servers.
# NOTE: These seem to be lumped together in one setting now, under "General Preferences",
#osascript -e 'tell application "System Events" to tell "Appearance Preferences" to set "Recent applications limit" to 0'
#osascript -e 'tell application "System Events" to tell "Appearance Preferences" to set "Recent documents limit" to 0'
#osascript -e 'tell application "System Events" to tell "Appearance Preferences" to set "Recent servers limit" to 0'

## System Settings > Keyboard > Keyboard

### Automatically illuminate keyboard in low light: on
defaults write com.apple.BezelServices 'kDim' -bool true

### Turn off when computer is not used for: 5 mins
defaults write com.apple.BezelServices 'kDimTime' -int 300

## System Settings > Users & Groups

### Login Options > Display login window as: Name and password
sudo defaults write /Library/Preferences/com.apple.loginwindow 'SHOWFULLNAME' -bool true

## System Settings > Date & Time > Clock

### Time options: Display the time with seconds: on
### Date options: Show the day of the week: on
### Date options: Show date: on
#defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE MMM d   h:mm:ss a'

# Qt is a cross-platform UI toolkit.
#brew install qt
#brew install qt5

## Enable debugging menu in App Store (Not working for me in 10.10.5).
# sudo defaults write com.apple.appstore ShowDebugMenu -bool true

## TODO: Should we get (updated) GNU utilities?
# Yes! Coreutils includes `nproc`, which I've seen used in scripts.
brew install --quiet coreutils
# brew install findutils
# brew tap homebrew/dupes
# brew install homebrew/dupes/grep

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Prefsniff will show changes to preferences files, which can then be used with `defaults`.
#python3 -m pip install prefsniff
# TODO: I think `plist` is the better alternative now.

# Disable Liquid Glass tab styling.
defaults write -g NSSolariumWindowTabs -bool NO

# Make Zed the default app for text, code, markup, and data files. (Launch Services
# needs Zed registered, so this only takes effect once editors/zed.sh has installed it.)
# HTML files stay with the default web browser. Zed already claims some other types
# (like .rs, .go, .toml, .tsx) itself. TypeScript (.ts) files have the same type as
# MPEG-2 transport stream videos, so those open in Zed too.
if [[ -d "/Applications/Zed.app" ]]; then
    set-default-app dev.zed.Zed \
        public.plain-text public.source-code public.shell-script public.zsh-script \
        net.daringfireball.markdown public.xml public.json public.yaml public.patch-file \
        com.netscape.javascript-source public.python-script public.ruby-script \
        public.c-source public.c-header public.c-plus-plus-source org.lua.lua-source \
        public.css com.barebones.bbedit.scss-source com.microsoft.ini org.sbarex.conf \
        public.mpeg-2-transport-stream
fi

# Duti shows the default app for a file type, as in `duti -x md`.
brew install --quiet duti
