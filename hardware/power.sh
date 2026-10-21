#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
# Pre-authorize sudo. Skip the prompt when sudo is already passwordless, so
# unattended runs (such as the VM test harness over SSH) do not fail here.
sudo -n true 2>/dev/null || sudo -v

# TODO: Make these idempotent. Use output of `pmset -g custom`.

## Power-saving settings. Times are in minutes.
## System Settings > Energy Saver

# NOTE: For `pmset`, `-b` = "on battery", `-c` = "charging", `-a` = "always".

# Wake when opening the lid.
sudo pmset -a lidwake 1

# On battery, power down completely (persist to disk) when sleeping.
# When plugged in, maintain power to RAM when sleeping, but persist to disk.
sudo pmset -b hibernatemode 25
sudo pmset -c hibernatemode 3

# Make sure we don't have sleep completely disabled.
sudo pmset -a disablesleep 0

# Set energy-saving features (on battery).
sudo pmset -b displaysleep 5 sleep 10

# Set energy-saving features (plugged in).
sudo pmset -c displaysleep 15 sleep 30

### Put the hard disk(s) to sleep when possible: 10 min
sudo pmset -b disksleep 10
sudo pmset -c disksleep 10

### Slightly dim the display when on battery
sudo pmset -b lessbright 0

### Automatically reduce brightness before display goes to sleep
sudo pmset -b halfdim 0
sudo pmset -c halfdim 0

### Wake for network access
sudo pmset -c womp 1

### Start up automatically after a power failure
sudo pmset -c autorestart 1
