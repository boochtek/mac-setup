#!/bin/bash

# Google Workspace CLI — agentic access to Gmail, Calendar, Drive, Sheets,
# Docs, Chat, Tasks, Meet, and Admin Reports from the command line.
#
# Used by Claude Code (and other AI tooling) as the local fallback when
# Claude.ai's hosted Gmail MCP only has read-only scope. See the email-sweep
# skill (~/.claude/skills/email-sweep/SKILL.md) for the daily inbox cleanup
# that depends on this.
#
# Naming note — Homebrew package vs installed binary:
#   * Package:  googleworkspace-cli   (Google's official Workspace CLI)
#   * Binary:   gws                   (what gets installed onto $PATH)
# There is a separate, unrelated Homebrew formula also named `gws` that's a
# git-workspace manager by streakycobra. They CONFLICT — both ship a /gws
# binary. Always install via the full formula name `googleworkspace-cli`,
# NEVER `brew install gws` (you'd get the wrong tool).
brew install --quiet googleworkspace-cli

# Authentication setup is interactive and one-time. The steps below are
# documented here rather than scripted because they require a browser and
# GCP Console clicks. Run them after `brew install` completes:
#
#   1. Create a personal GCP project + OAuth client. This needs gcloud first:
#        brew install --quiet --cask google-cloud-sdk
#        gcloud init                     # log in with your personal Google account
#        gws auth setup --project gws-cli-craigbuchek --login
#
#      `gws auth setup` will:
#        * Create the GCP project if it doesn't exist
#        * Enable the required Workspace APIs
#        * Create an OAuth 2.0 client with `redirect_uri=http://localhost`
#        * Write `client_secret.json` to ~/.config/gws/
#        * Optionally trigger `gws auth login` immediately (the `--login` flag)
#
#   2. Configure the OAuth consent screen in GCP Console:
#        https://console.cloud.google.com/auth/audience?project=gws-cli-craigbuchek
#      For a personal gmail.com address (no Workspace org), settings MUST be:
#        * User type:        External
#        * Publishing status: Testing  (NOT "In production" — that requires
#                                       Google's app verification process)
#        * Test users:       add your own gmail address explicitly
#
#      Why External + Testing? Google's OAuth model offers two audience types:
#      Internal (Workspace-org-only, doesn't apply to consumer gmail) and
#      External (any Google account). For personal use, External in Testing
#      mode keeps the app private — only you can grant consent — and skips
#      Google's weeks-long verification review.
#
#   3. Log in, requesting only the scopes you need (principle of least
#      privilege). For just the email-sweep workflow:
#        gws auth login --scopes "https://www.googleapis.com/auth/gmail.modify"
#
#      For broader access (Calendar, Drive, etc.):
#        gws auth login --services gmail,calendar,drive
#
#      Or all available scopes:
#        gws auth login --full
#
#      On the consent screen:
#        * Click past the "Google hasn't verified this app" warning via
#          Advanced → Continue to GWS CLI (unsafe) — this is normal for
#          unverified personal-use apps in Testing mode
#        * On the scopes page, **explicitly check the gmail.modify (or other
#          requested) checkbox** — Google's consent UI now allows users to
#          decline individual scopes while still completing the flow with
#          "success", so unchecked = quietly denied
#
#   4. VERIFY the scopes actually granted (the "OAuth success" message is
#      not proof of capability — see ~/.local/share/ai/memory/oauth-scope-verification.md):
#        gws auth status                 # check "scopes" array
#        gws gmail users threads trash \
#          --params '{"userId":"me","id":"<known-test-thread-id>"}'
#        # 200 OK = scope is real; 403 insufficientPermissions = re-do auth
#
# Credentials, once granted, are stored AES-256-GCM-encrypted at
# ~/.config/gws/credentials.enc, with the encryption key in macOS Keychain
# (service `gws`). A refresh token is included, so the OAuth flow doesn't
# need to be re-run between sessions.

# Re-auth shortcuts (no install needed, just here for reference):
#   gws auth logout                    # clear all credentials
#   gws auth login --scopes "..."      # re-grant
#   gws auth status                    # inspect current state
