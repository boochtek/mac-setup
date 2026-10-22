#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# TODO: Install via ASDF.

## Racket
## Racket is a superset of Scheme, that allows defining other languages (per module).

# Install only the `racket` and `raco` executables; no DrRacket IDE.
brew install --quiet minimal-racket

# Install extended REPL library, so we can use Readline.
# NOTE: You'll want `(require xrepl)` in your `~/.racketrc` file to enable this.
raco pkg install --auto xrepl

# TODO: Install Swindle, to get a better object system, more like CLOS.
