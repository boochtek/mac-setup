# This file is sourced to prepare to set up the Mac.

# This should work in Bash or Zsh (maybe others), but tell shellcheck it's Bash:
# shellcheck shell=bash

## Install Homebrew.

# Determine if on Apple Silicon or Intel. Homebrew gets installed different places for each.
if [[ $(arch) == 'i386' ]]; then
    export HOMEBREW_ARCH='x86_64'
    export HOMEBREW_PREFIX='/usr/local'
else
    export HOMEBREW_ARCH='arm64e'
    export HOMEBREW_PREFIX='/opt/homebrew'
fi
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_AUTO_UPDATE=1
# Homebrew 7 asks before installing anything; don't stop to ask.
export HOMEBREW_NO_ASK=1
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

# Install Homebrew itself, if it's not already installed.
# Non-interactive, based on [https://github.com/Homebrew/homebrew/blob/go/install].
if ! command-exists "${HOMEBREW_PREFIX}/bin/brew"; then

    # Prefer the non-interactive check: when sudo is already passwordless (or the
    # credentials are still cached) `sudo -v` would otherwise try to prompt, which
    # fails outright in a non-interactive session such as an SSH-driven test run.
    if ! sudo -n true 2>/dev/null && ! sudo -v; then
        echo 'You need sudo access to install Homebrew!' >&2
        return 1
    fi

    echo 'Installing Homebrew.'

    # Create destination directory for Homebrew, and set permissions.
    sudo mkdir -p $HOMEBREW_PREFIX $HOMEBREW_PREFIX/include $HOMEBREW_PREFIX/share
    sudo chown "${USER}:admin" $HOMEBREW_PREFIX
    sudo chmod g+rwx $HOMEBREW_PREFIX
    sudo chown "${USER}:admin" $HOMEBREW_PREFIX/include
    sudo chmod g+rwx $HOMEBREW_PREFIX/include
    sudo chown "${USER}:admin" $HOMEBREW_PREFIX/share
    sudo chmod g+rwx $HOMEBREW_PREFIX/share

    # Create cache directory for Homebrew, and set permissions.
    sudo mkdir -p /Library/Caches/Homebrew
    sudo chmod g+rwx /Library/Caches/Homebrew

    # Tell git that it's OK for us to install to the directory.
    if ! git config --global --get-all safe.directory | grep -q "^$HOMEBREW_PREFIX$"; then
        git config --global --add safe.directory "$HOMEBREW_PREFIX"
    fi

    # Download the latest version of Homebrew using git.
    (
        cd "$HOMEBREW_PREFIX" || exit 1
        git init -q
        git remote add origin https://github.com/Homebrew/brew
        git fetch origin main:refs/remotes/origin/main -n
        git reset --hard origin/main
    )

    # NOTE: If none of this works, try:
    #   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/main/install.sh)"
else
    brew update
fi

# Check for configuration issues.
brew doctor

# Install tools that setup scripts use before the script that installs them runs:
# `mas` (App Store), `dockutil` (Dock), `git-lfs` (some taps), `wget` (downloads),
# and `uv` (Python). (The config files configure git to use git-lfs.)
brew install --quiet mas dockutil git-lfs wget uv

## Fix permissions on Homebrew share directory, so Zsh completion doesn't complain.
chmod g-w /opt/homebrew/share
