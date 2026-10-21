#!/bin/bash

## Helper functions for macOS privacy permissions.

# Can this terminal read files that macOS protects with Full Disk Access?
has-full-disk-access() {
    head -c 1 '/Library/Application Support/com.apple.TCC/TCC.db' &>/dev/null
}

# Fail unless this terminal has Full Disk Access, which writing settings for
# Accessibility, Safari, and Mail requires. Opens System Settings to grant it.
require-full-disk-access() {
    has-full-disk-access && return
    echo "This terminal (${TERM_PROGRAM:-unknown}) needs Full Disk Access to change some settings." >&2
    echo "System Settings > Privacy & Security > Full Disk Access: ENABLE this terminal." >&2
    echo "While there, also ENABLE it in App Management (to update and unquarantine apps)." >&2
    echo "Then quit and reopen the terminal, and run this again." >&2
    open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
    return 1
}
