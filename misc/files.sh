#!/bin/bash

## Tools to work with files and file formats.

# Midnight Commander (mc) is a visual (TUI) file manager, a clone of Norton Commander.
brew install midnight-commander

# NNN is another TUI file manager, but with a different design philosophy.
brew install --quiet nnn

# Ranger is a TUI file manager with VI key bindings.
brew install --quiet ranger


# Installs `pdfinfo`, `pdftotext`, and `pdftohtml`, among others.
# Forked from xpdf, but has a different (large, including X11 libs) set of dependencies that I find preferable.
brew install --quiet poppler

# Coherent PDF Command Line Tools.
brew install --quiet cpdf

# PDF viewer for terminals that support images. Hot reloads on file changes.
# NOTE: This package has a **lot** of dependencies, including X11.
brew install --quiet fancy-cat

# NOTE: Requires Java (installs openjdk) but can do OCR and convert "thousands" of file types.
brew install --quiet tika

# MarkItDown is a tool from Microsoft that converts Word, PowerPoint, Excel, PDF, HTML and other files to Markdown.
pip install --quiet markitdown
