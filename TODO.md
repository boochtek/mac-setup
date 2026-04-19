# TODO - Mac Setup

## Top Priority

- COMMITS!!!
- rename as mac-setup
- install Chrome extensions
    - DOCUMENT installation
    - 1Password ✔️
    - OneTab
    - tabs full of 'em
- custom icons for top-level directories
    - at least the ones in the Finder sidebar
- more settings
    - use `plist` to see what settings get changed
    - Safari
- replace Bartender with [Hidden Bar](https://github.com/dwarvesf/hidden)
    - or [Vanilla](https://matthewpalmer.net/vanilla/)
    - or [Dozer](https://github.com/matthewpalmer/Dozer)
- hardware/printer.sh
- See what's missing from the Ansible branch.

## Keyboard Mappings

These may be in Karabiner, or maybe just Mac key bindings.

- Map Command+Shift+, to open System Preferences.
    - Because Command+, is the standard keystroke to open Preferences in applications.
    - open "/Applications/System Preferences.app"
- Make Ctrl+Tab, Ctrl+PageDown cycle through tabs.
    - Probably Command+Right (or Option or Ctrl) too.
    - And corresponding key binding for reverse cycling.
- Make Ctrl+Enter, Command+Enter send email (in Mail, Thunderbird, and all other email programs).
- Do magic to make Finder opening and renaming more sane.

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

- Figure out how to restore from backups.
- Pull config_files from GitHub.
- Pull config_files.PRIVATE from wherever it belongs.

## Probably really old stuff

- Fix sublime setup
    - Add more plugins
        - AdvancedNewFile with show_files enabled.
- Fix keyboard setup
- Remove dock items
- Prompt for hostname and set it
    - Also hard drive name
- Have it download and install Config Files
    - Prompt for github user/repo if not installed, and not in git config
- Yosemite updates
- Check that everything worked as expected
- brew install --quiet --cask macs-fan-control # (or smcfancontrol)
