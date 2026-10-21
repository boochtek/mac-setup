# This file is sourced to prepare to set up the Mac.

# This should work in Bash or Zsh (maybe others), but tell shellcheck it's Bash:
# shellcheck shell=bash

# If `CONFIG_FILES_URL` is not set, abort.
if [[ -z "$CONFIG_FILES_URL" ]]; then
    echo 'CONFIG_FILES_URL is not set. Aborting.'
    return 1
fi

# Set `CONFIG_FILES_BRANCH` to `main` if it's not set.
CONFIG_FILES_BRANCH="${CONFIG_FILES_BRANCH:-main}"

# Install config files.
#
# This file is sourced, so the `cd` must stay in a subshell: a bare `cd` would
# move the caller for the rest of the setup.
#
# A clone that fails is not fatal: the rest of the setup still runs, just
# without the config files. `install.sh` needs the clone, so it is skipped.
if [[ ! -d "$HOME/.config" ]]; then
    if git clone "$CONFIG_FILES_URL" --branch="$CONFIG_FILES_BRANCH" "$HOME/.config"; then
        (cd "$HOME/.config" && ./install.sh)
    else
        echo "WARNING: Could not clone config files from $CONFIG_FILES_URL." >&2
        echo "         Continuing without them; re-run init.sh to retry." >&2
    fi
fi

# New shells get this from the config files; set it for this shell too.
# Otherwise `brew trust` saves to `~/.homebrew/` instead of `~/.config/homebrew/`,
# splitting the trusted taps across 2 files.
export XDG_CONFIG_HOME="$HOME/.config"
