# This file is sourced. Tell shellcheck it's Bash:
# shellcheck shell=bash

## Helper functions for macOS privacy permissions.

# Can this terminal read files that macOS protects with Full Disk Access?
# (Only Full Disk Access allows reading TCC.db.)
has-full-disk-access() {
    head -c 1 '/Library/Application Support/com.apple.TCC/TCC.db' &>/dev/null
}

# How to give a terminal app the permissions that setup needs.
explain-terminal-permissions() {
    echo "System Settings > Privacy & Security > Full Disk Access: ENABLE $1"
    echo "System Settings > Privacy & Security > App Management: ENABLE $1 (to update and unquarantine apps)"
}

# Fail unless this terminal has Full Disk Access, which writing settings for
# Accessibility, Safari, and Mail requires. Opens System Settings to grant it.
require-full-disk-access() {
    has-full-disk-access && return
    {
        echo "This terminal (${TERM_PROGRAM:-unknown}) needs Full Disk Access to change some settings."
        explain-terminal-permissions 'this terminal'
        echo "Then quit and reopen the terminal, and run this again."
    } >&2
    open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
    return 1
}
