#!/bin/bash

# SLUUG email account (craig@buchek.com via mail.sluug.org) — agentic IMAP/SMTP
# access through @codefuturist/email-mcp.
#
# Used as the third email account in the email-sweep skill alongside Gmail
# (Craig.Buchek@gmail.com) and Fastmail (craig@boochtek.com). See:
#   ~/.claude/skills/email-accounts/SKILL.md
#   ~/.claude/skills/email-sweep/SKILL.md
#
# Architecture: an stdio MCP server registered with Claude Code, invoked
# through a Bash wrapper that injects credentials from macOS Keychain and
# the Let's Encrypt R12 intermediate cert (workaround for SLUUG's incomplete
# TLS chain — see notes below).

# Install @codefuturist/email-mcp globally. Requires Node.js (installed via
# mise; see dev/mise.sh).
npm install --global @codefuturist/email-mcp@latest

# The R12 intermediate certificate — needed because mail.sluug.org's TLS
# handshake ships only the leaf cert (*.sluug.org), omitting the Let's
# Encrypt R12 intermediate that browsers/Node.js need to complete the chain
# to the ISRG Root X1 CA. Downloading the intermediate explicitly and
# pointing NODE_EXTRA_CA_CERTS at it sidesteps the bug.
#
# When Let's Encrypt rotates intermediates (look for the warning
# "unable to verify the first certificate"), inspect the chain and update:
#   openssl s_client -connect mail.sluug.org:993 -showcerts </dev/null
# Identify the issuer CN of the leaf, then download the matching pem from
# https://letsencrypt.org/certs/ and replace the file below.
#
# Proper fix would be server-side: configure mail.sluug.org to serve the
# full chain. Until SLUUG admins do that, this workaround is required.
mkdir -p "$HOME/.config/email-mcp"
curl -fsSL https://letsencrypt.org/certs/2024/r12.pem \
    -o "$HOME/.config/email-mcp/lets-encrypt-r12.pem"

# Store the SLUUG IMAP password in macOS Keychain. The wrapper reads it
# via `security find-generic-password`.
#
# This step is interactive — run once and enter your password when prompted:
#   security add-generic-password -s sluug-mail-mcp -a craig@buchek.com -w
# Or non-interactively:
#   security add-generic-password -s sluug-mail-mcp -a craig@buchek.com -w "$YOUR_PASSWORD"

# Install the wrapper to ~/bin/sluug-mail-mcp. The wrapper:
#   * Pulls password from Keychain
#   * Sets MCP_EMAIL_* env vars expected by @codefuturist/email-mcp
#   * Critically: distinguishes From: address (craig@buchek.com) from IMAP
#     login username (booch@sluug.org). The vanity domain craigbuchek.com
#     forwards to the SLUUG account whose actual login name is booch@sluug.org
#   * Injects NODE_EXTRA_CA_CERTS pointing at the R12 intermediate
#   * Passes through any args (e.g., `test sluug` runs the IMAP+SMTP login probe)
mkdir -p "$HOME/bin"
cat > "$HOME/bin/sluug-mail-mcp" <<'WRAPPER'
#!/usr/bin/env bash
# Wrapper for @codefuturist/email-mcp — used for the SLUUG IMAP account.
# Credentials pulled from macOS Keychain. The R12 intermediate is needed
# because mail.sluug.org ships only the leaf cert (see email-accounts skill).
#
# Usage:
#   sluug-mail-mcp                  # default: run as MCP server over stdio
#   sluug-mail-mcp test sluug       # run @codefuturist/email-mcp's IMAP+SMTP test
#   sluug-mail-mcp <any-other-cmd>  # passed through to email-mcp

set -euo pipefail

MCP_EMAIL_PASSWORD="$(security find-generic-password -s sluug-mail-mcp -w)"
export MCP_EMAIL_PASSWORD
export MCP_EMAIL_ADDRESS=craig@buchek.com
# Login on mail.sluug.org is the SLUUG account name, not the From: address.
# If auth fails with this, try the bare local part: MCP_EMAIL_USERNAME=booch
export MCP_EMAIL_USERNAME=booch@sluug.org
export MCP_EMAIL_IMAP_HOST=mail.sluug.org
export MCP_EMAIL_SMTP_HOST=mail.sluug.org
export MCP_EMAIL_ACCOUNT_NAME=sluug
# Workaround for SLUUG's incomplete TLS chain (no R12 intermediate in handshake).
# Replace this file when Let's Encrypt rotates intermediates, or fix server-side.
export NODE_EXTRA_CA_CERTS="$HOME/.config/email-mcp/lets-encrypt-r12.pem"

exec email-mcp "${@:-stdio}"
WRAPPER
chmod +x "$HOME/bin/sluug-mail-mcp"

# Register the MCP server with Claude Code. Idempotent — re-running this
# replaces an existing registration of the same name.
claude mcp add --scope user sluug-mail "$HOME/bin/sluug-mail-mcp"

# Verify the wrapper can authenticate end-to-end (IMAP + SMTP):
#   ~/bin/sluug-mail-mcp test sluug
# Expected output ends with "All accounts OK ✅".
#
# SLUUG-specific gotchas captured in the email-accounts skill:
#   * Auth lockout: mail.sluug.org has fail2ban-style IP blocking on port 993.
#     After 2–3 failed logins, TCP itself is refused for 10 min to 1 hour.
#     NEVER spray-test credentials — confirm the exact password before retrying.
#   * MCP-handshake ≠ IMAP-login: `claude mcp list` reports "Connected" the
#     instant the stdio process starts, BEFORE any IMAP attempt. Always
#     verify the actual login with `~/bin/sluug-mail-mcp test sluug`.
#   * KNOWN ISSUE (2026-05-15): email-mcp's stdio mode (when invoked by
#     Claude Code as an MCP server) does not honor NODE_EXTRA_CA_CERTS the
#     same way `test` mode does — the wrapper authenticates fine via CLI but
#     fails with "unable to verify the first certificate" when used through
#     the MCP. Workaround pending; for now, prefer the Gmail/Fastmail MCPs
#     for agentic work on SLUUG-equivalent content, or shell out to
#     `~/bin/sluug-mail-mcp` directly from a Bash tool call.
