#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

## Configure Finder the way we want it.

## Many of these settings come from https://github.com/mathiasbynens/dotfiles/blob/master/.osx.
## Note that some of these settings also affect File Open and Save dialogs.

# Allow quitting Finder.
defaults write com.apple.finder QuitMenuItem -bool true

# When opening a new window, start in the home directory.
defaults write com.apple.finder NewWindowTarget -string 'PfHm'

# Keep folders on top when sorting by name. From https://github.com/sobolevn/dotfiles/blob/master/macos/settings.sh
defaults write com.apple.finder _FXSortFoldersFirst -bool TRUE

# Show file extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files.
defaults write com.apple.finder AppleShowAllFiles -bool true

# Don't warn about changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable window animations and Get Info animations in Finder.
defaults write com.apple.finder DisableAllAnimations -bool true

# Show Path Bar.
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar.
defaults write com.apple.finder ShowStatusBar -bool true

# Show Tab Bar.
defaults write com.apple.finder ShowTabView -bool true

# Display full path in window titles.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Don't clutter network volumes with .DS_Store files.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Warn before emptying the Trash.
defaults write com.apple.finder WarnOnEmptyTrash -bool true

# Empty Trash securely by default.
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Use list view in all Finder windows by default. Other view modes: 'icnv', 'clmv', 'Flwv'.
defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set sidebar icon size to medium.
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Enable spring loading for directories, with no delay.
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Expand General section in Info panels for files and directories.
defaults write com.apple.finder FXInfoPanesExpanded -dict-add MetaData -bool true
# Enable (but don't expand by default) Sharing & Permissions section in Info panels for files and directories.
defaults write com.apple.finder FXInfoPanesExpanded -dict-add Privileges -bool false

# Show Sidebar, but remove the Tags section.
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder ShowRecentTags -bool false

# Make the Sidebar a little wider, so our favorites fit.
defaults write com.apple.finder SidebarWidth -int 175
defaults write com.apple.finder FK_SidebarWidth -int 175

# Set the favorites in the side bar of Finder windows, as well as Open/Save dialogs.
# Homebrew disabled the original mysides; this is a maintained rewrite with the same commands.
brew trust --formula 7onnie/tap/mysides
brew install --quiet 7onnie/tap/mysides
# Oddly, AirDrop is named `/` here. Home is displayed with the username, not "Home".
# Removing an item that isn't in the sidebar fails, so ignore failures.
for item in / Recents Home Applications Utilities Desktop Documents Downloads Projects Pictures \
    Music Movies Screenshots Config Work Personal Developer Library; do
    mysides remove "$item" &>/dev/null || true
done

mysides add Home "file://$HOME/"
[[ -L "$HOME/Config Files" ]] || ln -s "$HOME/.config" "$HOME/Config Files"
mysides add 'Config Files' "file://$HOME/Config%20Files/"
# Adding a folder that doesn't exist fails.
if [[ -d "$HOME/Work" ]]; then
    [[ -L "$HOME/Developer" ]] || ln -s "$HOME/Work" "$HOME/Developer"
    mysides add Developer "file://$HOME/Developer/"
fi
[[ -d $HOME/Personal ]] && mysides add Personal "file://$HOME/Personal/"
mysides add Downloads "file://$HOME/Downloads/"
mysides add Pictures "file://$HOME/Pictures/"
mkdir -p "$HOME/Pictures/Screenshots"
mysides add Screenshots "file://$HOME/Pictures/Screenshots/"
mysides add Music "file://$HOME/Music/"
mysides add Library "file://$HOME/Library/"
mysides add Applications 'file:///Applications/'
mysides add Utilities 'file:///Applications/Utilities'
mysides add Recents 'file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch/'

# Prevent Time Machine from prompting to use new hard drives as backup volumes.
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Restart Finder so settings will take effect.
killall Finder
