#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -Euo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

# Convert HTML+CSS to PDF from the command line. (Replaces the archived wkhtmltopdf.)
# Usage: weasyprint in.html out.pdf [-s extra.css]
# Page size and margins come from CSS (`@page { size: Letter; margin: 0.5in; }`), not command-line options.
# No JavaScript support, and flexbox/grid support is less complete than a browser's.
brew install --quiet weasyprint
