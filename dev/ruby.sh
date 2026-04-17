#!/bin/bash

RUBY_VERSION="${RUBY_VERSION:-4.0.1}"

# Dependencies: `mise`

# Install dependencies required to build Ruby. See https://github.com/rbenv/ruby-build/wiki#macos.
brew install openssl@3 readline libyaml gmp autoconf


## Install and configure various versions of Ruby.
mise install ruby "$RUBY_VERSION"
# TODO: See if there are any old versions we want to get rid of. Maybe ask?
#           Use `mise uninstall ruby 2.7.1`
#           Maybe set an `at` to remind you to run the script again?


## Gems

# NOTE: The mise Ruby plugin installs all the gems listed in `~/.default-gems`
# Install some gems for every version of Ruby. These are either for irb or for the commands they provide,
GEMS_TO_INSTALL='bundler amazing_print hirb wirble pry railties rubocop debug'
ALL_RUBY_VERSIONS="$(mise list ruby | tr -d '\n')"
CURRENT_RUBY_VERSION="$(mise current ruby | awk '{print $2}' | tr -d '\n')"
if [[ -z "$CURRENT_RUBY_VERSION" ]]; then
    CURRENT_RUBY_VERSION='system'
fi
for ruby_version in $ALL_RUBY_VERSIONS ; do
    mise shell ruby $ruby_version
    echo "Installing gems into $ruby_version: $GEMS_TO_INSTALL"
    gem update --system
    gem update bundler
    gem install $GEMS_TO_INSTALL
done

# Install some gems for ONLY the latest Ruby.
mise shell ruby $CURRENT_RUBY_VERSION
brew install --quiet --cask wkhtmltopdf
gem install kramdown
gem install rsense
gem install ruby-beautify
gem install herb
gem install erb-formatter
gem install middleman
gem install railties
gem install rubocop rubocop-rspec rubocop-performance rubocop-rails
# gem install solargraph

# Install Ruby LSP server.
gem install ruby-lsp
mkdir "$HOME/.ruby-lsp"
cat "$HOME/.ruby-lsp/Gemfile" << RUBY_LSP
source 'https://rubygems.org'
ruby "$CURRENT_RUBY_VERSION"
gem 'ruby-lsp'
RUBY_LSP
BUNDLE_GEMFILE="$HOME/.ruby-lsp/Gemfile" bundle

# Install rubyfmt.
brew install --quiet rubyfmt
