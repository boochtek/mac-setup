# macOS 27.0.1 Fresh-Install Issues (2026-10-14)

Screenshots are in `~/Desktop`, numbered `01`–`59` in capture order.
Note: the filenames contain a narrow no-break space (U+202F) before AM/PM.

Status key: **FIXED** = already fixed (committed or in the working tree),
**INFO** = not a problem, **?** = need more info from Craig.

## Cross-Cutting Root Causes

These explain most of the failures.
Fixing them first will make the remaining issues much easier to find.

### A. Homebrew 7 asks before every install

- **#10**: `Do you want to proceed with the installation? [y/n]`.
  Homebrew 7 asks for confirmation by default.
- **Fix**: `export HOMEBREW_NO_ASK=1` in `init/homebrew.sh`, next to
  `HOMEBREW_NO_AUTO_UPDATE`. Also add it to the VM test harness.
- **Decision (Craig)**: never prompt for dependencies, interactively too.
  So also export it in the dotfiles' `~/.config/sh/00_homebrew.sh`;
  make a commit for that change in the dotfiles repo.

### A2. Gatekeeper "downloaded from the Internet" prompts

- **#05** (and many more not captured). Homebrew 7 removed
  `--no-quarantine` entirely (no option or env var in `man brew`).
- **Proposal**: an `install_cask` helper that runs `brew install --cask` and
  then removes the `com.apple.quarantine` xattr from the app(s) it installed.
  Also do a one-time sweep of casks already installed.
- **Risk**: this skips Gatekeeper's first-launch check. For official
  `homebrew/cask` casks that's low (Homebrew now disables casks that fail
  Gatekeeper, and the dialog says Apple already scanned the app).
  It's higher for third-party taps.
- **Decision (Craig)**: I don't want these prompts.
  I accept the proposal, but use `brew-install-cask` as the helper name.


### B. ERR trap aborts the whole script at the first failure

- Nearly every "Error on line N" means the rest of that script never ran.
  So we don't yet know what is broken *after* each failure.
- **Proposal**: add a helper to `init/shared-functions.sh` (e.g. `try`) for
  non-critical steps. It warns, records the failure, and continues.
  Have `init.sh` print a summary of all failures at the end.
  Keep strict mode for everything else.
- **Decision (Craig)**: I'll live with this. I won't always be running via `init.sh`.

### C. Tools used before they're installed

| # | Missing | Used in | Installed in |
| --- | --- | --- | --- |
| 09, 13 | `mas` | `os/1password.sh:36` | `os/app_store.sh:15` (later) |
| 20 | `wget` | `os/virtualization.sh:15,27,31,32` | `web/tools.sh:18` (later) |
| 54 | `code` | `misc/voice.sh:39` | `editors/vscode.sh` (later) |
| 47 | `claude` | `email/sluug.sh:90` | `misc/ai.sh` (later) |
| — | `git-lfs` | `os/fonts.sh` tap | `dev/` (later; see `TODO.md`) |

- **Fix**: install the bootstrap tools (`mas`, `dockutil`, `git-lfs`) in
  `init/`. Replace `wget` with `curl -fL -o` (and use the `crystalfetch` cask).
  Guard optional CLIs with `command -v`.
- **Decision (Craig)**: Install the tools, plus `wget`, during bootstrap.
  Ignore `crystalfetch` --- it seems irrelevant. Use the `command -v` guard,
  possibly via a `command-exists` alias set up during init.

### D. `open -a Name` right after a cask install

- **#12** (Hidden Bar), **#52** (Hammerspoon): `Unable to find application`.
  LaunchServices hasn't registered the new app yet.
- The same pattern appears in ~12 more places (`misc/ai.sh`, `misc/raycast.sh`,
  `misc/paletro.sh`, `misc/setapp.sh`, `misc/voice.sh`, `hardware/pedals.sh`,
  `web/browsers.sh`, `editors/cursor.sh`, `email/mimestream.sh`,
  `os/desktop.sh`, `os/virtualization.sh`).
- **Fix**: an `open_app` helper that opens `/Applications/<Name>.app` by path
  (as `shell/ghostty.sh:32` already does).
- **Decision (Craig)**: as proposed.

### E. Privacy-protected `defaults` domains (Full Disk Access)

- **#21**, **#24**: `com.apple.universalaccess` (`hardware/display.sh:19`,
  `hardware/trackpad.sh:34`).
- **#34**: Safari container (`web/safari.sh:11`).
- **#46**: Mail container (`email/mail.sh:12`).
- **Fix**: a preflight check in `init.sh` that detects whether the terminal
  has Full Disk Access. If not, print where to grant it, then stop.
- Also: `sudo defaults write` in `hardware/display.sh:16,23` and `os/ui.sh:16`
  writes *root's* prefs, not the user's. That's probably a latent bug.
- **Decision (Craig)**: as proposed. Note that the root prefs *may* be by design
  for hardware devices.

### F. Packages disabled or renamed upstream

| # | Package | Script | Replacement (verified in Homebrew) |
| --- | --- | --- | --- |
| 11 | `mysides` | `os/finder.sh:82` | none known; **?** |
| 14 | `rar` cask | `os/misc.sh:89` | `unar` formula (or `sevenzip`) |
| 53 | `stolendata-mpv` cask | `misc/video.sh:15` | `mpv` formula, or drop (IINA covers it) |
| 58 | `codex-cli` | `misc/ai.sh:39` | `codex` cask (0.163.0) |
| 51 | `--no-quarantine` flag | `misc/ai.sh:10` | **FIXED** (working tree) |

- **Decision (Craig)**: use unar, mpv, codex names. Find an updated version of mysides to use.

### G. Homebrew tap trust is split across two files

- **#25**: five taps are reported untrusted, even though the scripts run
  `brew trust`.
- `brew trust` writes to `$XDG_CONFIG_HOME/homebrew/trust.json` when that
  variable is set, and to `~/.homebrew/trust.json` otherwise. **Both files
  exist** on this Mac, written at different times (12:08 and 23:17).
- So some runs had `XDG_CONFIG_HOME` set and others didn't, and each run saw
  only half of the trust entries.
- **Fix**: export `XDG_CONFIG_HOME` early (in `init/homebrew.sh` or
  `ENV.sh`), and merge the two files once.
  `~/.config/homebrew/` is currently untracked in the dotfiles repo; **?**
- **Decision (Craig)**: as proposed.

### H. mise misuse in scripts

- **#57** (`dev/python.sh:15`), **#44** (`dev/ruby.sh:33,42`):
  `mise shell` only works in an activated interactive shell. It also needs
  `tool@version`, not `tool version`.
- **#42**: `mise install` doesn't activate; deno/node aren't on PATH.
- **#37**: `dev/mise.sh:16` has `$MISE_SHELL` unbound under `set -u`.
  Line 19's echo also expands `$(mise activate)` instead of printing it.
- **#39**, **#40**: the global mise `postinstall = ['bundle install']` hook
  in `~/.config/mise/config.toml` runs in `$HOME` (no Gemfile) on every
  `mise install`.
- **Fix**: `mise use --global tool@version`, and run
  `mise exec tool@version -- cmd` for per-version work.
  Move the bundle hook to per-project config, or guard it with
  `[ -f Gemfile ]`.
- `dev/ruby.sh:28`: `mise list ruby | tr -d '\n'` mashes all versions into
  one word.
- **Decision (Craig)**: as proposed. Guard the bundle hook with a Gemfile check.

### I. Python is externally managed (PEP 668)

- **#28**, **#29**: `python3 -m pip install pyobjc` is refused
  (`os/defaults+.sh:17`, reached via `shell/terminal.sh`).
  `dev/python.sh:22-32` and `misc/files.sh:35` will hit the same thing.
- `pyobjc` is not in Homebrew.
- **Fix**: use `pipx` (or `uv tool`) for CLI apps (black, flake8, pylint,
  markitdown). For `defaults+`, use a dedicated venv, or a `uv` script with
  inline dependencies. **?**
- **Decision (Craig)**: Use `uv` as proposed.

### J. Dock item removal

- **#16**, **#29**, **#56**: `dockutil --remove` fails for items not in the
  Dock. `shell/iterm2.sh` and `shell/ghostty.sh` hit it too, because they
  `source os/dock.sh`.
- **FIXED** in the working tree (`|| true`).
- Still open: `os/app_store.sh:36` has an unguarded `dockutil --remove`.
  Sourcing all of `dock.sh` from terminal scripts re-runs every Dock setting.
- **Decision (Craig)**: Fix as proposed.

## Single-Script Bugs

| # | File | Problem | Fix | Confidence |
| --- | --- | --- | --- | --- |
| 02 | `~/.config/install.sh:260` | `~/.local/bin` doesn't exist yet | `mkdir -p` in `link_file` | high |
| 03, 04 | `init/homebrew.sh:57` | `master` branch | **FIXED** (8430a12) | high |
| 12 | `os/menubar.sh:13` | `open -a 'Hidden Bar'` | see D | high |
| 15 | `os/quicklook.sh:23` | flux-markdown installer: "Registration failed" | **?** retry; check upstream | low |
| 17 | `os/fonts.sh:33` | `font-go` HTTP 429 | transient; see B | high |
| 19 | `os/app_store.sh:29` | `mas lucky 'Firetask'`: "No downloads initiated" | **?** install by ID | low |
| 22 | `hardware/keyboard.sh:51` | `$(ⓘ)` ran as a command | **FIXED** (working tree) | high |
| 23 | `hardware/power.sh:50-51` | `pmset panicrestart` gone since macOS 12 | delete lines | high |
| 27 | `shell/bash.sh:13` | `bash-completion` is for Bash 3 | `bash-completion@2` | high |
| 30, 31 | `web/chrome.sh:34` | `External Extensions` dir missing | `mkdir -p` first | medium-high |
| 38 | `dev/github.sh:23` | `gh-copilot` install fails (stderr hidden) | likely retired; drop or replace | medium |
| 41 | `dev/ruby.sh:56-62` | bare `bundle`; `cat` missing `>`; `mkdir` not `-p` | fix all three | high |
| 45 | `dev/docker.sh:17-19` | `BLUE` unbound (colors not sourced); backticks run `sudo` | source `util/colors.sh`; quote | high |
| 49 | `misc/paletro.sh:45` | `brew uninstall` should be `install` | typo | high |
| 50 | `misc/setapp.sh`? | `brew install` usage error after fdupes | **?** need the error line | low |
| 54 | `misc/voice.sh:25` | `~/.config/talon/user` doesn't exist | `mkdir -p`; idempotent clones | high |

- **Decision (Craig)**: Fix as recommended.

## Manual Steps and Wording

- **#01**: dotfiles installer (`~/.config/install.sh:199-213`) prompts for
  git name/email/GitHub user. **Decision (Craig)**: derive them instead.
  All three are derivable right after the dotfiles clone:
    - name: `id -F` (macOS account full name)
    - email: the most frequent author email for that name in the dotfiles
      repo's own history (`git shortlog -se`)
    - GitHub user: the owner in the dotfiles repo's `origin` URL
    - fall back to prompting only if a value can't be derived
- **#05**: Gatekeeper prompts; see A2.
- **#06**: the System Settings pane looks like "Device Control and Data
  Access". Scripts say "Accessibility". **Decision (Craig)**: Use the new name.
- **#07**, **#08**: Rectangle's double-click-title-bar option conflicts with
  the macOS setting; "Green stoplight maximizes" is ON but not in the script.
  **Decision (Craig)**: Enable "Green stoplight maximizes". Make changes to avoid conflicts.
- **#22**, **#59**: scripts say "System Preferences"; it's "System Settings". **Decision (Craig)**: Fix.
- **#55**: `misc/setapp.sh` ends with a dangling "Install and configure
  Supercharge:". **?**

## Informational Only (No Action)

- **#18**: `mas list` "No installed apps found" (Spotlight not indexed yet).
- **#26**, **#59** (first line): the `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK`
  warning, from `~/.config/sh/00_homebrew.sh:27`.
- **#32**, **#33**: Firefox manual-step notices.
- **#35**: `lessfilter` tap formula has no checksum (warning only).
- **#36**: npm "new major version" notice.
- **#43**, **#48**: "already installed" warnings. `midnight-commander` is
  installed twice (`misc/files.sh:11`, `os/misc.sh:85`).

- **Decision (Craig)**: Remove midnight-commander from os/misc.

## Other Findings

- `misc/video.sh:32`: a stray `yt-dlp --list-impersonate-targets` debug line
  with a hard-coded URL. It probably shouldn't be in a setup script.
- `hardware/keyboard.sh`: the Karabiner wrapper uses unquoted `$@`.
- `dev/docker.sh:19`: backticks inside double quotes run `sudo`.

- **Decision (Craig)**: Fix these

## Status (2026-10-20)

Fixed on the `macos-27-fixes` branch, unless noted:

- **A** `HOMEBREW_NO_ASK`; **A2** `brew-install-cask` (and, by hand, a one-time
  sweep of the apps already installed); **C** bootstrap tools in `init/homebrew.sh`, plus
  `command -v` guards; **D** `open-app`; **E** Full Disk Access check;
  **F** replacements, including the `7onnie/tap/mysides` fork;
  **G** `XDG_CONFIG_HOME`; **H** mise tools come from the config files'
  mise config; **I** uv; **J** Dock.
- All rows in "Single-Script Bugs", except:
    - **#15** (flux-markdown): still unknown; retry it.
    - **#17** (font-go 429): transient; no change, per B.
    - **#50**: a manual `brew install` with no name; nothing to fix.
- **#01**, **#02**, **#39/#40**, and the interactive `HOMEBREW_NO_ASK`
  are in the config files repo.
- **#06**, **#07/#08**, **#22/#59**: fixed.
- **#55**: Setapp now starts at login via a script. The dangling "Install and
  configure Supercharge:" line is still there; it needs the actual steps.
- `wkhtmltopdf` was also dropped from `dev/ruby.sh` (no longer in Homebrew; upstream is archived).
  Replaced by WeasyPrint, installed in `misc/weasyprint.sh`.
- Rectangle: macOS's own double-click setting is left at its default.
- **G**: the 2 trust files were merged by hand into `~/.config/homebrew/trust.json`,
  and `~/.homebrew` is now a symlink to `~/.config/homebrew` (the config files'
  `install.sh` makes it on new Macs).
- Later decisions (2026-10-20): no more Sublime Text or Deno; `mise prune`
  removes old Ruby and Python versions; Siri AI goes in the Dock. A separate
  session is recommending a wkhtmltopdf replacement.
- More packages Homebrew no longer has are listed in `TODO.md`.
