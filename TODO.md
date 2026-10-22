# TODO - Mac Setup

## Top Priority

- test on MacOS 27 before I upgrade
- custom icons for top-level (from ~) directories
    - at least the ones in the Finder sidebar
- more settings
    - use `plist` to see what settings get changed
    - Safari
- hardware/printer.sh
    - I have a Brother HL-8360CDW color laser printer, with duplex
    - It's on my home network
    - Last I checked, there was no Homebrew formula/cask for the drivers
        - IIRC, I downloaded and installed them directly from Brother
- what do I have installed that didn't get documented/automated here?
- What am I having to do manually that could be automated?
- What should I add?
- What should I remove?

## Packages Gone Away

Found by a VM test run; each one aborts its script.

- `gemini-cli` is deprecated (to be disabled 2026-12-18).

## Script Robustness

Found by a VM test run. Each aborts the rest of its script via the ERR trap.

- `killall` fails when the process isn't running: `os/ui.sh` (SystemUIServer)
  and `os/desktop.sh` (Finder). Should tolerate a missing process.
- Installing the 1Password CLI cask can't write its zsh completions:
  `Operation not permitted @ dir_s_mkdir - /opt/homebrew/share/zsh`.
- macOS Bash 3.2 runs the ERR trap for `$(cmd 2>/dev/null)` used as an `if`
  condition, even though the script handles the failure, so a deliberate probe
  logs a misleading `Error on line N` (`os/desktop.sh`). Bash 5 does not.
  Makes logs hard to triage; find a form that stays quiet on 3.2.

## Keyboard Mappings

These may be in Karabiner, or maybe just Mac key bindings.

- Map `Command`+`Shift`+`,` to open System Settings.
    - Because Command+, is the standard keystroke to open Preferences in applications.
    - open "/Applications/System Settings.app"
    - another app is wanting to use the same key binding
        - I think `Esc`+`,` would maybe be a better idea
            - `Esc` as modifier means "SYSTEM".
- Make Ctrl+Tab, Ctrl+PageDown cycle through tabs.
    - Probably Command+Right (or Option or Ctrl) too.
    - And corresponding key binding for reverse cycling.
- Make Ctrl+Enter, Command+Enter send email (in Mail, Thunderbird, and all other email programs).
- Do magic to make Finder opening and renaming more sane.
- Switch iTerm to "Load preferences from a custom folder or URL" (iTerm Settings
  → General), pointing it at a committed `com.googlecode.iterm2.plist`, so ALL
  iTerm settings and key bindings reproduce on a fresh Mac. Today only the
  Cmd+Shift+P → Open Quickly App Shortcut is scripted (`shell/iterm2.sh`); these
  other custom `GlobalKeyMap` bindings are captured nowhere:
    - Ctrl+Tab → next tab; Ctrl+Shift+Tab → previous tab
    - Cmd+← → Ctrl-A (line start); Cmd+→ → Ctrl-E (line end)
    - Shift+Return → newline; Cmd+Z → hex 0x1f

## Utilities

- Write a program to determine changes to `defaults` (and other config).
    - Just use `plist` command I installed via Homebrew
    - Probably make it a new sub-command of defaults+ command.
    - Start the program up.
    - Make your changes using your GUI.
    - Stop the program.
        - It'd be better to monitor in real-time, if possible.
    - The program will tell you what's been changed.
        - Will read changes to `defaults -currentHost read -g`.
        - Will read changes to `defaults -currentHost read`.
        - Will read changes to `defaults read -g`.
        - Will read changes to `defaults read`.
    - Revert your changes using your GUI.
    - Add the changes via a script, using `defaults`.

## User-Specific

- Decide whether `~/.config/homebrew/` (it holds `brew trust`'s `trust.json`)
  should be committed to the config files repo, or ignored.
- `defaults+` segfaults when reading a top-level (non-nested) key.
- Earlier runs of `os/defaults+.sh` made `/usr/local/bin` group-writable
  (`root:staff g+w`), so anything in the staff group can replace `karabiner`
  there. It no longer does; on a Mac that ran the old version, undo it with
  `sudo chmod g-w /usr/local/bin`.
- `HOMEBREW_NO_ASK` is also set for interactive shells (config files), so typos
  in `brew install` no longer get a confirmation prompt.
- Figure out how to restore from backups.
- Pull config_files.PRIVATE from wherever it belongs.
