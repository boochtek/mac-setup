#!/bin/bash

## Install Nim via ASDF.
#asdf plugin update nim
#asdf install nim 1.4.2

# NOTE: I'd prefer to install via Mise, but it's hanging on install.
# NOTE: Tried `ASDF_NIM_REMOVE_TEMP=no ASDF_NIM_DEBUG=yes mise install nim@latest`
#mise install nim@latest
brew install nim

code --install-extension nimlang.nimlang
