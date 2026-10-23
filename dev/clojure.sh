#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

# TODO: Install via ASDF.

## Clojure
brew install --quiet leiningen
# TODO: follow the tutorial: https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md
# TODO: To play around with Clojure run `lein repl` or `lein help`.
