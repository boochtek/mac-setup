# TODO

## ASAP


## Soon


## Old

* Make `locate` usable:
    * sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
* hardware/printer.sh
* See what's missing from the Ansible branch.


## Really old stuff

* Fix sublime setup
  * Add more plugins
    * AdvancedNewFile with show_files enabled.
* Fix keyboard setup
* Remove dock items
* Prompt for hostname and set it
  * Also hard drive name
* Have it download and install Config Files
  * Prompt for github user/repo if not installed, and not in git config
* Yosemite updates
* Check that everything worked as expected
* brew install --quiet --cask --no-quarantine macs-fan-control # (or smcfancontrol)

## Utilities

- Write a program to determine changes to `defaults` (and other config).
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


User-Specific
-------------

- Figure out how to restore from backups.
- Pull config_files from GitHub.
- Pull config_files.PRIVATE from wherever it belongs.


Keyboard Mappings
-----------------

These may be in Karabiner, or maybe just Mac key bindings.

- Map Command+Shift+, to open System Preferences.
  - Because Command+, is the standard keystroke to open Preferences in applications.
  - open "/Applications/System Preferences.app"
- Make Ctrl+Tab, Ctrl+PageDown cycle through tabs.
  - Probably Command+Right (or Option or Ctrl) too.
  - And corresponding key binding for reverse cycling.
- Make Ctrl+Enter, Command+Enter send email (in Mail, Thunderbird, and all other email programs).
- Do magic to make Finder opening and renaming more sane.
