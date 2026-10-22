# This file is sourced to configure various system settings.

# This should work in Bash or Zsh (maybe others), but tell shellcheck it's Bash:
# shellcheck shell=bash

# To get the serial number, run `system_profiler SPHardwareDataType | awk -F ': ' '/Serial Number/ {print $2}'`.
export SYSTEM_SERIAL_NUMBER='HD92KMVMMV'

# Abort if the serial number is not the one we expect.
ACTUAL_SERIAL_NUMBER="$(system_profiler SPHardwareDataType | awk -F ': ' '/Serial Number/ {print $2}')"
if [[ "$SYSTEM_SERIAL_NUMBER" != "$ACTUAL_SERIAL_NUMBER" ]]; then
    echo "Expected serial number $SYSTEM_SERIAL_NUMBER, but it's actually $ACTUAL_SERIAL_NUMBER."
    # This file is sourced (by init.sh), so `exit` would close the shell.
    return 127
fi

# System name and hostname.
export SYSTEM_NAME='Our Flag Means Death'
export HOSTNAME='our-flag'

# Extra groups to install.
export INSTALL_GROUPS='mac workstation dev'

# Where to download config files from. NOTE: Be sure to use HTTPS if you don't have SSH configured yet.
export CONFIG_FILES_URL='https://github.com/booch/config_files.git'
export CONFIG_FILES_BRANCH='master'

# Hardware-specific settings.
export HAS_TOUCH_ID="$([[ -e '/usr/local/bin/bioutil' ]] && echo 1 || echo 0)"
export HAS_TOUCH_BAR="$(ps auxw | grep 'TouchBarServer' | grep -v grep && echo 1 || echo 0)"
export HAS_APPLE_SILICON="$([[ $(arch) == 'arm64' ]] && echo 1 || echo 0)"
export HAS_INTEL_CPU="$([[ $(arch) == 'i386' ]] && echo 1 || echo 0)"

