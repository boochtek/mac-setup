#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

sudo_add_line_to_file() {
    local line="$1"
    local file="$2"

    # Create file if it doesn't exist.
    [[ -f "$file" ]] || sudo touch "$file"
    # Append line if it doesn't exist.
    if ! sudo grep -F -q --line-regexp "$line" "$file"; then
        echo "$line" | sudo tee -a "$file" >/dev/null
    fi
}

# Enable Touch ID for `sudo` on Macs with Touch ID.
sudo_add_line_to_file 'auth       sufficient     pam_tid.so' /etc/pam.d/sudo_local

# Per https://github.com/termstandard/colors:
# TODO: Add COLORTERM to SendEnv list in /etc/ssh/ssh_config.
# TODO: Add COLORTERM to AcceptEnv list in /etc/ssh/sshd_config.
# TODO: Add COLORTERM to env_keep list in /etc/sudoers.
# TODO: Add these to private_config, server_config, openwrt_config.
# TODO: Add these to the `env_keep` list in `/etc/sudoers`.


# Haven't tried this "SSH manager" TUI yet.
brew install --quiet lazyssh
