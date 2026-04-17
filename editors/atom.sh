#!/bin/bash

## Install and configure Atom Editor.

## NOTE: Most configuration will happen in user-specific config files.


source 'homebrew.sh'
source 'dockutil.sh'


# Install Atom Editor.
brew install --quiet --cask atom


# Install extensions.
apm install unity-ui
apm install soda-light-ui
apm install solarized-light-syntax-modified
apm install base16-light-syntax
apm install fonts

apm install pigments
apm install color-picker

apm install highlight-line
apm install trailing-spaces

apm install linter
apm install semanticolor
apm install atom-beautify
apm install pretty-json

apm install minimap
apm install minimap-autohide
apm install minimap-selection
apm install minimap-pigments
apm install minimap-find-and-replace
apm install minimap-git-diff
apm install minimap-highlight-selected

apm install auto-indent
apm install autocomplete-plus
apm install autocomplete-paths
apm install autocomplete-snippets
apm install autocomplete-ctags
apm install bracket-matcher

apm install sort-lines
apm install wordcount

apm install open-recent
apm install seti-icons

apm install git-log
apm install git-blame
apm install tree-view-git-status
apm install merge-conflicts

apm install atom-pair

apm install tag
apm install autoclose-html
apm install autocomplete-sass
apm install linter-csslint
apm install linter-xmllint
apm install xml-formatter

apm install autocomplete-ruby
apm install ruby-test
apm install ruby-block
apm install linter-rubocop
apm install rails-snippets
apm install rspec-snippets
apm install language-gherkin
apm install capybara-snippets
apm install language-rspec
apm install language-slim
apm install language-haml
apm install html2haml

apm install linter-jshint
apm install linter-jscs
apm install language-javascript-jsx
apm install language-javascript-semantic
apm install javascript-snippets
apm install linter-coffeelint

apm install language-crystal-actual
apm install linter-crystal

apm install language-racket


# Add an icon to the Dock.
dockutil --add  '~/Applications/Atom.app' --replacing 'Atom'
