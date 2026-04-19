#!/usr/bin/env bash

# Virtualization

set -euo pipefail; IFS=$'\n\t'


# Install UTM system emulator and virtual machine.
brew install --quiet --cask utm
open -a UTM


# Use CrystalFetch to get latest Windows ISOs.
wget https://github.com/TuringSoftware/CrystalFetch/releases/latest/download/CrystalFetch.dmg
hdiutil attach CrystalFetch.dmg
cp -a /Volumes/CrystalFetch/CrystalFetch.app /Applications/
hdiutil detach /Volumes/CrystalFetch
rm CrystalFetch.dmg


# TO AUTOMATE:
# Warning: Your terminal does not have App Management permissions, so Homebrew will delete and reinstall the app.
# This may result in some configurations (like notification settings or location in the Dock/Launchpad) being lost.
# System Settings > Privacy & Security > App Management and add or enable your terminal.


# Download Ubuntu ARM64 ISO for latest LTS. Follow instructions at https://docs.getutm.app/guides/ubuntu/.
wget https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.3-live-server-arm64.iso


# Download Debian 12 ARM64 ISOs.
DEBIAN_MIRROR='http://la.mirrors.clouvider.net'
wget -P ~/Downloads/ $DEBIAN_MIRROR/debian-cd/current/arm64/iso-cd/debian-12.1.0-arm64-netinst.iso
wget -P ~/Downloads/ $DEBIAN_MIRROR/debian-cd/current/arm64/iso-dvd/debian-12.1.0-arm64-DVD-1.iso


# Install VirtualOS, which allows you to run MacOS VMs on your Mac.
virtualOS_ID="$(mas search virtualOS | grep virtualOS | awk '{ print $1 }')"
mas purchase "${virtualOS_ID}"
mas install "${virtualOS_ID}"


# Lume is a CLI for using Apple's Virtualization Framework. It's part of CUA (Computer Use Agent).
brew install --quiet lume
