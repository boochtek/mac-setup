#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR

brew install --quiet --cask visual-studio-code

dockutil --add '/Applications/Visual Studio Code.app' --replacing 'Visual Studio Code' --after 'iTerm' &>/dev/null

# TODO: Move this list of extensions into a config file.
# The `code` command throws SIGPIPE when `grep --quiet` quits upon finding the first match.
# So we use a temp file. And we clean up after ourselves, even on an early exit.
# I also tried running the output through `tee`, but that only _reduced_ the errors.
extension_list="$(mktemp)"
trap 'rm $extension_list' EXIT
code --list-extensions >"$extension_list"

# Check before trying to install each extension, to see if it's already installed.
install-code-extension() {
    local extension_id="$1"
    if ! grep --quiet --ignore-case -F "$extension_id" "$extension_list"; then
        code --install-extension "$extension_id"
    fi
}

# AI
install-code-extension github.copilot # Requires a Copilot account in GitHub. Must sign into GitHub through VS Code.
install-code-extension supermaven.supermaven # NOTE: Conflicts with Copilot. Requires a Supermaven account.
install-code-extension Google.geminicodeassist # NOTE: Conflicts with Copilot.
install-code-extension Codeium.codeium # AKA Windsurf. NOTE: Conflicts with Copilot.
install-code-extension augment.vscode-augment # NOTE: Conflicts with Copilot. Requires an Augment account.

# Voice
install-code-extension pokey.cursorless
install-code-extension ms-vscode.vscode-speech

# Misc.
install-code-extension editorconfig.editorconfig
install-code-extension pdconsec.vscode-print # Better of the 2 printing extensions.
install-code-extension streetsidesoftware.code-spell-checker
install-code-extension Tyriar.sort-lines
install-code-extension christian-kohler.path-intellisense
install-code-extension lostintangent.vsls-whiteboard
install-code-extension formulahendry.code-runner
install-code-extension wmaurer.change-case
install-code-extension aaron-bond.better-comments
install-code-extension albert.tabout           # Tab out of quotes, brackets, etc.
install-code-extension mrmlnc.vscode-duplicate # Duplicate a file or directory from left Explorer side bar.
install-code-extension robole.snippets-ranger
install-code-extension yatki.vscode-surround
install-code-extension rebornix.toggle                        # Toggle any setting and bind to a keystroke.
install-code-extension visualstudioexptteam.vscodeintellicode # IntelliCode for JavaScript, Python, Java, and SQL.
install-code-extension deerawan.vscode-faker
install-code-extension alefragnani.Bookmarks
install-code-extension tomoki1207.pdf # Display (read-only) PDFs in the editor.
install-code-extension oderwat.indent-rainbow
install-code-extension wayou.vscode-todo-highlight
install-code-extension Gruntfuggly.todo-tree
install-code-extension esbenp.prettier-vscode
install-code-extension ms-vscode.makefile-tools
install-code-extension bun913.easy-date-insert # Insert today's date.
install-code-extension iliazeus.vscode-ansi # ANSI Text: Open Preview to display ANSI colors.
install-code-extension orepor.color-tabs-vscode-ext # Editor tabs get colors based on categories.
install-code-extension IBM.output-colorizer # Colorize output panels.

# Themes
install-code-extension akamud.vscode-theme-onelight
install-code-extension vscode-icons-team.vscode-icons

# Terminal
install-code-extension flyfly6.terminal-in-status-bar

# Git, GitHub, and GitLab
install-code-extension codezombiech.gitignore
install-code-extension donjayamanne.git-extension-pack
install-code-extension GitHub.vscode-pull-request-github
install-code-extension mhutchie.git-graph
install-code-extension GitLab.gitlab-workflow
install-code-extension github.vscode-github-actions
install-code-extension waderyan.gitblame

# Markdown
install-code-extension bierner.github-markdown-preview
install-code-extension DavidAnson.vscode-markdownlint
install-code-extension shd101wyy.markdown-preview-enhanced
install-code-extension budparr.language-hugo-vscode # Syntax highlighting and snippets for Hugo
install-code-extension rusnasonov.vscode-hugo       # Build and serve Hugo sites
install-code-extension FelixZeller.markdown-oxide   # Obsidian-like features for Markdown files. WARNING: Set `hover = false` in `~/.config/moxide/settings.toml`!
# Markdown Extended suggests `bierner.markdown-mermaid`, `bierner.markdown-preview-github-styles`, and `goessner.mdmath`.
install-code-extension jebbs.markdown-extended      # Uses Markdown-it for additional features, like ==highlight mark==
                            # TODO: Consider disabling extensions w/ `"markdownExtended.disabledPlugins": ["toc", "container"]`
                            # `"markdownExtended.pdfFormat": "US Letter"`
install-code-extension bierner.markdown-preview-github-styles
install-code-extension bierner.markdown-mermaid

# Ruby
install-code-extension Shopify.ruby-lsp
install-code-extension Shopify.ruby-extensions-pack
install-code-extension bung87.rails
# install-code-extension castwide.solargraph
install-code-extension KoichiSasada.vscode-rdbg
install-code-extension karunamurti.haml
install-code-extension LoranKloeze.ruby-rubocop-revived
install-code-extension aki77.rails-partial
install-code-extension aliariff.auto-add-brackets
install-code-extension aki77.haml-lint # NOTE: Requires `gem install haml-lint`.
install-code-extension kaiwood.endwise
install-code-extension soutaro.rbs-syntax
install-code-extension soutaro.steep-vscode
install-code-extension manuelpuyol.erb-linter
install-code-extension aki77.rails-db-schema # Auto-complete model attributes, schema tables, etc.
install-code-extension aki77.rails-routes
install-code-extension bung87.vscode-gemfile # Easy access to gem docs.

# JavaScript, TypeScript, and related frameworks
install-code-extension robole.javascript-snippets
install-code-extension xabikos.JavaScriptSnippets
install-code-extension donjayamanne.jquerysnippets
install-code-extension dbaeumer.vscode-eslint
install-code-extension svelte.svelte-vscode
install-code-extension christian-kohler.npm-intellisense
install-code-extension wix.vscode-import-cost
install-code-extension mgmcdermott.vscode-language-babel
install-code-extension sburg.vscode-javascript-booster
install-code-extension steoates.autoimport
install-code-extension nicoespeon.abracadabra   # Refactoring.
install-code-extension wix.glean                # Refactoring of React code.
install-code-extension ms-playwright.playwright # End-to-end testing with Playwright.

# HTML
install-code-extension sidthesloth.html5-boilerplate
install-code-extension formulahendry.auto-close-tag
install-code-extension formulahendry.auto-rename-tag

# CSS, SASS, Stylus, etc.
install-code-extension syler.sass-indented
install-code-extension sysoev.language-stylus
install-code-extension stylelint.vscode-stylelint

# JSON, XML, YAML, TOML, etc.
install-code-extension DotJoshJohnson.xml
install-code-extension richie5um2.vscode-sort-json
install-code-extension redhat.vscode-yaml

# SVG
install-code-extension jock.svg
install-code-extension vitaliymaz.vscode-svg-previewer

# Python
install-code-extension ms-python.python
install-code-extension ms-python.flake8
install-code-extension ms-python.vscode-pylance
install-code-extension ms-toolsai.jupyter

# Elixir
install-code-extension mjmcloug.vscode-elixir

# Crystal
install-code-extension crystal-lang-tools.crystal-lang

# Nim
install-code-extension kosz78.nim

# MySQL
install-code-extension formulahendry.vscode-mysql

# Shell: BASH, ZSH, etc.
install-code-extension timonwong.shellcheck
install-code-extension DeepInThought.vscode-shell-snippets
install-code-extension foxundermoon.shell-format # NOTE: Requires `shfmt` command.

# DevOps
install-code-extension shanoor.vscode-nginx
install-code-extension ms-azuretools.vscode-docker
install-code-extension hashicorp.terraform
install-code-extension ms-vscode-remote.remote-ssh-edit # Syntax highlighting for SSH config files.

# C, C++
install-code-extension ms-vscode.cpptools-extension-pack
install-code-extension jbenden.c-cpp-flylint

# Java
install-code-extension redhat.java
install-code-extension vscjava.vscode-java-debug
install-code-extension vscjava.vscode-java-dependency
install-code-extension vscjava.vscode-java-pack

# TODO: Kotlin

# Haskell, Elm, OCAML/ReasonML
# install-code-extension ocamllabs.ocaml-platform
install-code-extension justusadam.language-haskell
install-code-extension elmtooling.elm-ls-vscode

# Lisp, Scheme, Racket
install-code-extension evzen-wybitul.magic-racket

# Swift
install-code-extension swiftlang.swift-vscode

# VimL
install-code-extension XadillaX.viml
