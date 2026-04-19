#!/bin/bash

# Xcode CLI Tools will have already installed git, but we want to stay more up-to-date.
# This was especially important for the CVE-2014-9390 vulnerability.
brew install --quiet git
brew link git

# Git-Crypt allows encrypting some of the files in your repository. See https://www.agwa.name/projects/git-crypt/.
brew install --quiet git-crypt

# Git-LFS allows storing larger files. See https://git-lfs.com/.
# GitHub limits files to 100 MB. You can add LFS for $5/month for 50 GB, with a file size limit of 2 GB.
brew install --quiet git-lfs
git lfs install

# LazyGit provides a TUI that makes some git operations easier.
brew install --quiet lazygit

# Install some credential helpers. NOTE: Prompts for sudo password.
brew install --quiet --cask git-credential-manager
brew install --quiet git-credential-oauth

# Suggested by Olivier Lacan https://twitter.com/olivierlacan/status/646741176922587141
git config --global credential.helper osxkeychain

# Semantic merge drivers reduce merge conflicts by understanding code structure.
# Weave (tree-sitter based) is preferred; mergiraf as fallback.
# A wrapper script tries weave first, then mergiraf, then git's built-in merge.
brew install --quiet weave
brew install --quiet mergiraf
git config --global merge.conflictStyle zdiff3
mkdir -p ~/.local/bin
cat > ~/.local/bin/git-semantic-merge-driver << 'SCRIPT'
#!/bin/sh
# Semantic merge driver for git.
# Tries weave, then mergiraf, then falls back to git's built-in line-based merge.
# Arguments from git: %O %A %B %L %P
BASE="$1" OURS="$2" THEIRS="$3" MARKER_SIZE="$4" PATH_NAME="$5"

if command -v weave-driver >/dev/null 2>&1; then
    weave-driver "$BASE" "$OURS" "$THEIRS" "$MARKER_SIZE" "$PATH_NAME"
    exit $?
fi

if command -v mergiraf >/dev/null 2>&1; then
    mergiraf merge --git "$BASE" "$OURS" "$THEIRS" -p "$PATH_NAME" -l "$MARKER_SIZE"
    exit $?
fi

# Fall back to git's built-in 3-way merge.
git merge-file -L ours -L base -L theirs --marker-size="$MARKER_SIZE" "$OURS" "$BASE" "$THEIRS"
exit $?
SCRIPT
chmod +x ~/.local/bin/git-semantic-merge-driver
git config --global merge.semantic.name "Semantic merge (weave/mergiraf)"
git config --global merge.semantic.driver 'git-semantic-merge-driver %O %A %B %L %P'

# Add catch-all merge driver to global gitattributes (idempotent).
GITATTRIBUTES="${XDG_CONFIG_HOME:-$HOME/.config}/git/attributes"
if ! grep -q 'merge=semantic' "$GITATTRIBUTES" 2>/dev/null; then
    # so file-specific entries (e.g. Gemfile.lock) that appear later will take precedence.
    sed -i '' '1i\
# Use semantic merge driver (weave/mergiraf) for all files, unless overridden.\
# This MUST be near the top — later matches (eg. Gemfile.lock) override earlier lines.\
* merge=semantic\
' "$GITATTRIBUTES"
fi

# Make diffs more human-readable.
brew install --quiet diff-so-fancy
brew install --quiet git-delta
brew install --quiet difftastic
