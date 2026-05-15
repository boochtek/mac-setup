#!/bin/bash

# Daily email sweep schedule — installs a launchd agent that runs
# Claude Code's `/email-sweep --auto` slash command every morning.
#
# Requires:
#   * googleworkspace-cli   — see misc/google-workspace.sh
#   * email-sweep skill     — ~/.claude/skills/email-sweep/SKILL.md
#   * email-sweep command   — ~/.claude/commands/email-sweep.md
#   * SLUUG setup           — email/sluug.sh
#
# The destructive MCP/Bash calls that /email-sweep uses are explicitly
# allowlisted in ~/.claude/settings.json so the unattended invocation runs
# without permission prompts:
#   * mcp__fastmail-mail__{search_email,list_folders,delete_email}
#   * Bash(gws auth status:*)
#   * Bash(gws gmail users threads list *)
#   * Bash(gws gmail users threads trash --params *)
# Without those rules, claude -p would block waiting on a TTY that isn't
# there and the launchd job would silently no-op.

# 1. Wrapper script (~/bin/email-sweep-daily) — what launchd actually runs.
#    Pre-flights gws auth, invokes claude -p, logs the run, fires a macOS
#    notification on failure.
mkdir -p "$HOME/bin"
cat > "$HOME/bin/email-sweep-daily" <<'WRAPPER'
#!/usr/bin/env bash
# Daily email sweep — runs the /email-sweep slash command via Claude Code in
# non-interactive mode and logs the result. Scheduled by:
#   ~/Library/LaunchAgents/com.boochtek.email-sweep.plist
# Setup script:
#   ~/mac-setup/misc/email-sweep-schedule.sh

set -uo pipefail

LOG_ROOT="$HOME/Personal/Email/sweep-log"
mkdir -p "$LOG_ROOT"
DATE="$(date +%Y-%m-%d)"
LOG="$LOG_ROOT/$DATE.md"

# launchd hands us a minimal PATH; restore the usual one.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/bin:$PATH"

{
    echo "# Email sweep — $DATE $(date +%H:%M:%S)"
    echo ""

    if ! gws auth status | grep -q 'gmail.modify'; then
        echo "Pre-flight FAILED: gws auth missing gmail.modify scope"
        echo "Re-run: gws auth login --scopes \"https://www.googleapis.com/auth/gmail.modify\""
        osascript -e 'display notification "gws auth needs re-consent — see ~/Personal/Email/sweep-log/" with title "Email sweep skipped"'
        exit 1
    fi

    claude -p "/email-sweep --auto" --output-format text || {
        rc=$?
        echo ""
        echo "claude -p exited $rc"
        osascript -e 'display notification "Email sweep failed — see today log" with title "Email sweep failed"'
        exit "$rc"
    }

    echo ""
    echo "Done $(date +%H:%M:%S)"
} | tee "$LOG"
WRAPPER
chmod +x "$HOME/bin/email-sweep-daily"

# 2. launchd agent plist (~/Library/LaunchAgents/com.boochtek.email-sweep.plist).
#    Fires daily at 06:30 local time. Does NOT run at load — first run is the
#    next 06:30 wall-clock occurrence.
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$HOME/Library/LaunchAgents/com.boochtek.email-sweep.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.boochtek.email-sweep</string>

    <key>ProgramArguments</key>
    <array>
        <string>$HOME/bin/email-sweep-daily</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>6</integer>
        <key>Minute</key>
        <integer>30</integer>
    </dict>

    <key>RunAtLoad</key>
    <false/>

    <key>WorkingDirectory</key>
    <string>$HOME</string>

    <key>StandardOutPath</key>
    <string>$HOME/Personal/Email/sweep-log/launchd.out</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Personal/Email/sweep-log/launchd.err</string>

    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>$HOME</string>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>

    <key>ProcessType</key>
    <string>Background</string>
</dict>
</plist>
PLIST

# 3. Bootstrap the agent (idempotent: bootout first, then bootstrap).
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.boochtek.email-sweep.plist" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.boochtek.email-sweep.plist"

# 4. Ensure log directory exists.
mkdir -p "$HOME/Personal/Email/sweep-log"

# Verify with:
#   launchctl print "gui/$(id -u)/com.boochtek.email-sweep"
# Force a test run with:
#   launchctl kickstart -k "gui/$(id -u)/com.boochtek.email-sweep"
# Disable temporarily:
#   launchctl bootout "gui/$(id -u)" ~/Library/LaunchAgents/com.boochtek.email-sweep.plist
