#!/bin/bash

brew install --quiet fontconfig
brew install --quiet svn # required to install some fonts

## Install additional fonts.
brew install --quiet --cask niksy/pljoska/font-microsoft-cleartype-family
brew install --quiet --cask font-comic-mono
brew install --quiet font-jetbrains-mono
brew install --quiet font-fira-code
brew install --quiet --cask font-anonymous-pro
brew install --quiet --cask font-fira-mono
brew install --quiet --cask font-fira-sans
brew install --quiet --cask font-awesome-terminal-fonts
brew install --quiet --cask font-bitstream-vera
brew install --quiet --cask font-courier-prime
brew install --quiet --cask font-courier-prime-code
brew install --quiet --cask font-courier-prime-medium-and-semi-bold
brew install --quiet --cask font-courier-prime-sans
brew install --quiet --cask font-dejavu
brew install --quiet --cask font-dm-mono
brew install --quiet --cask font-dm-sans
brew install --quiet --cask font-dm-serif-display
brew install --quiet --cask font-dm-serif-text
brew install --quiet --cask font-fantasque-sans-mono
brew install --quiet --cask font-gnu-unifont
brew install --quiet --cask font-go
brew install --quiet --cask font-hack
brew install --quiet --cask font-hasklig
brew install --quiet --cask font-ia-writer-duo
brew install --quiet --cask font-ia-writer-mono
brew install --quiet --cask font-ia-writer-quattro
brew install --quiet --cask font-ibm-plex-mono
brew install --quiet --cask font-ibm-plex-sans
brew install --quiet --cask font-ibm-plex-serif
brew install --quiet --cask font-inconsolata
brew install --quiet --cask font-inria
brew install --quiet --cask font-inria-sans
brew install --quiet --cask font-inria-serif
# Iosevka - sans-serif + slab-serif, monospace + quasi‑proportional, designed for code & terminals, ligatures. Variants mimic other fonts.
brew install --quiet --cask font-iosevka
brew install --quiet --cask font-iosevka-ss01
brew install --quiet --cask font-iosevka-ss02
brew install --quiet --cask font-iosevka-ss03
brew install --quiet --cask font-iosevka-ss04
brew install --quiet --cask font-iosevka-ss05
brew install --quiet --cask font-iosevka-ss06
brew install --quiet --cask font-iosevka-ss07
brew install --quiet --cask font-iosevka-ss08
brew install --quiet --cask font-iosevka-ss09
brew install --quiet --cask font-iosevka-ss10
brew install --quiet --cask font-iosevka-ss11
brew install --quiet --cask font-iosevka-ss12
brew install --quiet --cask font-iosevka-ss13
brew install --quiet --cask font-iosevka-ss14
brew install --quiet --cask font-iosevka-ss15
brew install --quiet --cask font-iosevka-ss16
brew install --quiet --cask font-iosevka-ss17
brew install --quiet --cask font-iosevka-ss18
brew install --quiet --cask font-latin-modern
brew install --quiet --cask font-latin-modern-math
brew install --quiet --cask font-lavishly-yours
brew install --quiet --cask font-league-gothic
brew install --quiet --cask font-league-mono
brew install --quiet --cask font-league-script
brew install --quiet --cask font-league-spartan
brew install --quiet --cask font-lexend
brew install --quiet --cask font-liberation
brew install --quiet --cask font-linux-biolinum
brew install --quiet --cask font-linux-libertine
brew install --quiet --cask font-luxurious-script
brew install --quiet --cask font-monoid
# Mononoki is a font "for programming and code review".
brew install --quiet --cask font-mononoki
brew install --quiet --cask font-noto-mono
brew install --quiet --cask font-noto-music
brew install --quiet --cask font-noto-sans
brew install --quiet --cask font-noto-sans-display
brew install --quiet --cask font-noto-sans-mono
brew install --quiet --cask font-noto-serif
# NOTE: Following failed to install due to missing `svn` package.
brew install --quiet --cask font-open-sans
brew install --quiet --cask font-overpass
brew install --quiet --cask font-overpass-mono
brew install --quiet --cask font-oxygen-mono
brew install --quiet --cask font-pt-mono
brew install --quiet --cask font-pt-sans
brew install --quiet --cask font-pt-sans-caption
brew install --quiet --cask font-pt-sans-narrow
brew install --quiet --cask font-pt-serif
brew install --quiet --cask font-pt-serif-caption
brew install --quiet --cask font-quattrocento
brew install --quiet --cask font-quattrocento-sans
brew install --quiet --cask font-recursive-code
brew install --quiet --cask font-red-hat-display
brew install --quiet --cask font-red-hat-mono
brew install --quiet --cask font-red-hat-text
brew install --quiet --cask font-roboto-flex
brew install --quiet --cask font-roboto-mono
brew install --quiet --cask font-roboto-serif
brew install --quiet --cask font-roboto-slab
# SF and New York fonts are from Apple. May require sudo access.
brew install --quiet --cask font-sf-mono
brew install --quiet --cask font-sf-pro
brew install --quiet --cask font-new-york
brew install --quiet --cask font-sometype-mono
brew install --quiet --cask font-source-code-pro
brew install --quiet --cask font-source-sans-3
brew install --quiet --cask font-source-sans-pro
brew install --quiet --cask font-source-serif-4
brew install --quiet --cask font-source-serif-pro
brew install --quiet --cask font-stix
brew install --quiet --cask font-stix-two-math
brew install --quiet --cask font-stix-two-text
brew install --quiet --cask font-sudo
brew install --quiet --cask font-terminus
brew install --quiet --cask font-times-newer-roman
brew install --quiet --cask font-tinos
brew install --quiet --cask font-titillium-web
brew install --quiet --cask font-tt2020
brew install --quiet --cask font-ubuntu
brew install --quiet --cask font-ubuntu-condensed
brew install --quiet --cask font-ubuntu-mono
brew install --quiet --cask font-victor-mono
brew install --quiet --cask font-vt323
brew install --quiet --cask font-work-sans

# Icon fonts.
brew install --quiet --cask font-fontawesome
brew install --quiet --cask font-powerline-symbols
brew install --quiet font-noto-color-emoji
brew install --quiet --cask font-twitter-color-emoji
brew install --quiet --cask font-ligature-symbols
brew install --quiet --cask font-codicon   # from MS VS Code
brew install --quiet --cask font-devicons
brew install --quiet --cask font-foundation-icons # from Zurb Foundation
brew install --quiet --cask font-open-iconic

# Flow is meant to be used in creating wireframes.
brew install --quiet --cask font-flow-block
brew install --quiet --cask font-flow-circular
brew install --quiet --cask font-flow-rounded

# Humor Sans is meant to look like the font used in XKCD.
brew install --quiet --cask font-humor-sans
