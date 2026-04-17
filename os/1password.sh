#!/bin/bash

## 1Password

# Install 1Password app and CLI.
brew install --quiet --cask 1password
brew install --quiet 1password-cli

# Verify CLI installation.
if command -v op &> /dev/null; then
    echo "1Password CLI installed: $(op --version)"
else
    echo "WARNING: 1Password CLI (op) not found in PATH after installation."
    echo "  You may need to restart your shell or add Homebrew to PATH."
fi

# Enable Touch ID for CLI (requires 1Password app with Touch ID already enabled).
# See: https://developer.1password.com/docs/cli/about-biometric-unlock/
OP_BIOMETRIC_UNLOCK_ENABLED_FILE="$HOME/.config/op/biometric_unlock_enabled"
if [[ ! -f "$OP_BIOMETRIC_UNLOCK_ENABLED_FILE" ]]; then
    mkdir -p "$HOME/.config/op"
    echo "true" > "$OP_BIOMETRIC_UNLOCK_ENABLED_FILE"
    echo "Enabled biometric unlock for 1Password CLI."
    echo "  Make sure Touch ID is enabled in 1Password app: Settings > Security > Touch ID."
fi

# TODO: Use this for virtualOS too.
mas_install() {
    local app_name="$1"
    local app_id
    app_id="$(mas search "${app_name}" | grep "${app_name}" | awk '{ print $1 }')"
    mas purchase "${app_id}"
    mas install "${app_id}"
}

mas_install '1Password for Safari'

# TODO: Install other browser extensions.
# TODO: Document using 1Password's SSH agent.
# See: https://developer.1password.com/docs/ssh/
