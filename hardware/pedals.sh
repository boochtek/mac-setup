#!/bin/bash

# Despite deciding on the Elgato foot pedals, I prefer using Better Touch Tool over the Stream Deck app.
# NOTE: You'll be prompted for your password.
# brew install --quiet --cask elgato-stream-deck

# NOTE: The app will open, and will likely prompt you to install an update.
# NOTE: You'll get a prompt that the app (from "Corsair") will run in the background.
# NOTE: Allow Elgato Stream Deck to have full Accessibility in Privacy & Security


# BetterTouchTool
brew install --quiet --cask bettertouchtool
open -a BetterTouchTool
# Manually:
#   Check for Updates
#   Hit OK when asked to control "Shortcut Events.app"
#   Hit *Continue* to confirm GDPR privacy statement
#   Hit the button to open System Preferences / Security & Privacy / Accessibility
#       Enable BetterTouchTool
#   Prompt "BetterTouchTool.app" would like to receive keystrokes from any application
#       Click on Open system Settings to open System Preferences / Security & Privacy / Input Monitoring
#           Hit the + and add BetterTouchTool.
#   Settings
#       Basic
#           CHECK Launch BetterTouchTool on startup
#           CHECK Allow crash log and anonymized usage data collection
#           CHECK Silently download & install updates on restart
