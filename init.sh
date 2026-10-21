# This file is sourced to prepare to set up the Mac.

# This should work in Bash or Zsh (maybe others), but tell shellcheck it's Bash:
# shellcheck shell=bash

# Fail early if the terminal lacks Full Disk Access, which later scripts need.
if source ./ENV.sh && source ./util/privacy.sh && require-full-disk-access; then
    source ./init/shared-functions.sh
    # Before anything that needs sudo, so the rest authenticates by fingerprint.
    source ./init/touch-id.sh
    source ./init/command-line-tools.sh
    source ./init/homebrew.sh
    source ./init/config-files.sh
else
    return 1
fi
