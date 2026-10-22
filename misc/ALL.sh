#!/bin/bash

# Run from this script's own directory so each sub-script's relative paths resolve.
cd "$(dirname "$0")" || exit 1

./ai.sh
./audio.sh
./emulators.sh
./files.sh
./google-workspace.sh
./hammerspoon.sh
./images.sh
./markdown-oxide.sh
./ms-office.sh
./paletro.sh
./pandoc.sh
./pdf.sh
./raycast.sh
./search.sh
./setapp.sh
./video.sh
./voice.sh
./email-sweep-schedule.sh
