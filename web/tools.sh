#! /bin/bash

# Cache the sudo password.
echo "$(tput setaf 4)You may be prompted for your sudo password.$(tput sgr0)"
sudo -v

# Siege is an HTTP load testing and benchmarking tool.
brew install --quiet siege

# WGet is similar to Curl, but has some different options.
brew install --quiet wget

# HTTPie is like cURL, but better for working with APIs.
# NOTE: HTTPie also has a GUI front-end, available as a cask.
brew install --quiet httpie

# Curlie is like HTTPie, using Curl as backend.
brew install --quiet curlie

# XH is another modern replacement for HTTPie.
brew install --quiet xh

# Convert from HTML to Markdown. See https://html-to-markdown.com/.
# TODO: Also consider [Breakdance](https://breakdance.github.io/breakdance/docs.html).
brew install --quiet html2markdown
