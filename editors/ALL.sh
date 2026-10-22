#!/bin/bash

# Run from this script's own directory so each sub-script's relative paths resolve.
cd "$(dirname "$0")" || exit 1

./vscode.sh
./cursor.sh
./zed.sh
./neovim.sh
./vim.sh
./emacs.sh
./rubymine.sh
./obsidian.sh
./markdown.sh
./draw.io.sh
./hex.sh
