#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# MacOS 13 (Ventura) comes with Bash 3.2. This will upgrade that to Bash 5.2.
# Apple will likely never upgrade Bash; they'll stick with the last GPL 2 version.
brew install --quiet bash

# Install Bash command-line completion. (Version 2 is for Bash 4.2+; plain bash-completion is for Bash 3.)
brew install --quiet bash-completion@2

# Allow Homebrew version of Bash to be used as login shell.
# sudo ansible localhost -m lineinfile -a "dest=/etc/shells line=/usr/local/bin/bash"
if ! grep "$(brew --prefix)/bin/bash" /etc/shells >/dev/null; then
    sudo sh -c "echo '$(brew --prefix)/bin/bash' >> /etc/shells"
fi

# Use newer Bash from Homebrew if we're using the system Bash.
if [[ "$(dscl . -read ~ UserShell | sed 's/UserShell: //')" == '/bin/bash' ]]; then
    chsh -s "$(brew --prefix)/bin/bash" "$USER"
fi
