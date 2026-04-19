#!/bin/bash

# I'd really rather not install this.
return 0;

## Pandoc -- universal document converter

# Install Pandoc.
brew install --quiet pandoc

# Pandoc requires LaTeX for PDF output.
# NOTE: This will install several dependencies:
#   jbig2dec, leptonica, libb2, libarchive, libidn, tesseract, ghostscript
# NOTE: This installs several applications into `/Applications/TeX/`.
brew install --quiet --cask mactex

# Install Pandoc templates.
# The Eisvogel template seems to be "the one to get".
mkdir -p ~/.local/share/pandoc/templates
cd ~/.local/share/pandoc/templates
wget https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v3.0.0/Eisvogel.tar.gz
tar xfz Eisvogel.tar.gz
rm Eisvogel.tar.gz
mv Eisvogel-3.0.0/* .
rmdir Eisvogel-3.0.0
cd -
