#!/bin/bash

# Dependencies: `mise`

## Install and configure latest version of Bun.
mise install bun@latest

# TODO: See if there are any old versions we want to get rid of. Maybe ask?
#           Use `mise uninstall bun 1.2.3`
#           Maybe set an `at` to remind you to run the script again?

## Install and configure latest version of Deno.
mise install deno@latest

## Install and configure latest version of Node.
mise install node@latest
