#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

# Dependencies: `mise`

# Install dependencies required to build Ruby. See https://github.com/rbenv/ruby-build/wiki#macos.
brew install --quiet openssl@3 readline libyaml gmp autoconf


## Install Ruby. (The version comes from the mise config in the config files.)
mise install ruby
# TODO: See if there are any old versions we want to get rid of. Maybe ask?
#           Use `mise uninstall ruby 2.7.1`
#           Maybe set an `at` to remind you to run the script again?


## Gems

# NOTE: The mise Ruby plugin installs all the gems listed in `~/.default-gems`
# Install some gems for every version of Ruby. These are either for irb or for the commands they provide,
# (`mise shell` only works in an interactive shell, so use `mise exec` instead.)
GEMS_TO_INSTALL=(bundler amazing_print hirb wirble pry railties rubocop debug)
for ruby_version in $(mise ls --installed --json ruby | jq -r '.[].version'); do
    echo "Installing gems into $ruby_version: ${GEMS_TO_INSTALL[*]}"
    mise exec ruby@"$ruby_version" -- gem update --system
    mise exec ruby@"$ruby_version" -- gem update bundler
    mise exec ruby@"$ruby_version" -- gem install "${GEMS_TO_INSTALL[@]}"
done

# Run a command with the global version of Ruby.
with-ruby() {
    mise exec ruby -- "$@"
}
RUBY_VERSION="$(with-ruby ruby -e 'print RUBY_VERSION')"

# Install some gems for ONLY the latest Ruby.
brew-install-cask wkhtmltopdf
with-ruby gem install kramdown
with-ruby gem install rsense
with-ruby gem install ruby-beautify
with-ruby gem install herb
with-ruby gem install erb-formatter
with-ruby gem install middleman
with-ruby gem install railties
with-ruby gem install rubocop rubocop-rspec rubocop-performance rubocop-rails
# with-ruby gem install solargraph

# Install Ruby LSP server.
with-ruby gem install ruby-lsp
mkdir -p "$HOME/.ruby-lsp"
cat > "$HOME/.ruby-lsp/Gemfile" << RUBY_LSP
source 'https://rubygems.org'
ruby "$RUBY_VERSION"
gem 'ruby-lsp'
RUBY_LSP
BUNDLE_GEMFILE="$HOME/.ruby-lsp/Gemfile" with-ruby bundle install

# Install rubyfmt.
brew install --quiet rubyfmt
