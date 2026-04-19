#!/bin/bash

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
sudo -v

### TODO: sysdig/csysdig!!!
### TODO: slackcat

## Install some command-line utilities that we like to have.

# Ack is great for searching for things within a repo.
brew install ack

# The Silver Searcher (ag) is similar to Ack, newer and possibly better, but I still prefer Ack.
brew install the_silver_searcher

# HTop is a really nice replacement for top.
brew install htop
sudo chown root:wheel "$HOMEBREW_PREFIX"/Cellar/htop/*/bin/htop
sudo chmod u+s "$HOMEBREW_PREFIX"/Cellar/htop/*/bin/htop

# BTop is an even nicer replacement for top, with a more graphical interface.
brew install --quiet btop

# A couple other replacements for top. (Binary for `bottom` is `btm`.)
brew install --quiet glances
brew install --quiet bottom

# Tree is a nice tool to display a full directory hierarchy.
brew install tree

# [`eza`](https://eza.rocks) is a command to replace `ls`, with more useful features, including a tree view.
brew install --quiet eza

# LSD is another modern `ls` replacement, with a lot of features.
brew install --quiet lsd

# Pstree shows running processes as a tree, showing parent-child relationships.
brew install pstree

# Lesspipe is an input filter for `less`, allowing non-text files to be translated into text.
brew install lesspipe #--syntax-highlighting
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

# Pidof allows finding a process by name, similar to `pgrep` or `kill`.
brew install pidof

# Watch will continuously run a command.
#brew install watch # WARNING: Installation is currently broken.

# PV (Pipe Viewer) can be used in shell pipelines to show a progress bar.
brew install pv

# Midnight Commander (mc) is a visual (TUI) file manager, a clone of Norton Commander
brew install midnight-commander

# Occasionally we need to decompress FLAC and RAR files.
brew install flac
brew install rar

# It's nice to occasionally show a fortune.
brew install fortune

# Search inside (and pretty-print) JSON, YAML, XML, Markdown.
brew install --quiet jq yq xq mdq
# TUI playground for jq.
brew install --quiet jqp
# JSON viewer with paging, syntax highlighting, and interactive collapse/expand.
brew install --quiet jless

# Install some linting tools.
brew install proselint # English prose
npm install --global markdownlint-cli
brew install libxml2 # xmllint
npm install --global jsonlint jsonlint
brew install yamllint
npm install --global eslint
brew install ansible-lint

# Install some newer tools that Mac OS X already has.
brew install --quiet diffutils
brew install --quiet colordiff
brew install --quiet nano
brew install --quiet grep
brew install --quiet less

## From https://github.com/ptb/Mac-OS-X-Lion-Setup/blob/master/setup.sh

# TODO: Don't need to keep track of recent documents, applications, or servers.
# NOTE: These seem to be lumped together in one setting now, under "General Preferences",
#osascript -e 'tell application "System Events" to tell "Appearance Preferences" to set "Recent applications limit" to 0'
#osascript -e 'tell application "System Events" to tell "Appearance Preferences" to set "Recent documents limit" to 0'
#osascript -e 'tell application "System Events" to tell "Appearance Preferences" to set "Recent servers limit" to 0'

## System Preferences > Keyboard > Keyboard

### Automatically illuminate keyboard in low light: on
defaults write com.apple.BezelServices 'kDim' -bool true

### Turn off when computer is not used for: 5 mins
defaults write com.apple.BezelServices 'kDimTime' -int 300

## System Preferences > Users & Groups

### Login Options > Display login window as: Name and password
sudo defaults write /Library/Preferences/com.apple.loginwindow 'SHOWFULLNAME' -bool true

## System Preferences > Date & Time > Clock

### Time options: Display the time with seconds: on
### Date options: Show the day of the week: on
### Date options: Show date: on
defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE MMM d   h:mm:ss a'

# Qt is a cross-platform UI toolkit.
brew install qt
brew install qt5

## Enable debugging menu in App Store (Not working for me in 10.10.5).
sudo defaults write com.apple.appstore ShowDebugMenu -bool true

## TODO: Should we get (updated) GNU utilities?
# brew install coreutils
# brew install findutils
# brew tap homebrew/dupes
# brew install homebrew/dupes/grep

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Prefsniff will show changes to preferences files, which can then be used with `defaults`.
python3 -m pip install prefsniff
