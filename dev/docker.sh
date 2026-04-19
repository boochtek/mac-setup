# TODO: Try Docker replacements: podman, colima, etc.


# Install Docker Desktop, unless it's already installed.
# Keeping it idempotent.
if ! brew list --cask docker &>/dev/null; then
    # NOTE: This will install the Cask version.
    #       The non-Cask version is not as up-to-date, and harder to get running.
    # NOTE: The Cask version now includes Docker Compose.
    echo "${BLUE}TODO: I want to stop using Docker Engine.${RESET}"
    echo "${BLUE}It's quicker to get the server running using Docker Desktop.${RESET}"
    echo "${BLUE}You may be prompted to agree to allow `sudo`.${RESET}"
    brew install --quiet --cask docker
    echo "${BLUE}Walk through the Docker Desktop setup.${RESET}"
    echo "${BLUE}You may be prompted for your password.${RESET}"
    open -a Docker.app
fi

# NOTE: Trying to use the non-Cask version again.
# NOTE: Make sure `~/.docker/config.json` includes `/opt/homebrew/lib/docker/cli-plugins` in `cliPluginsExtraDirs`.
# brew install --quiet docker
# brew install --quiet docker-compose

# Lazydocker provides a nice TUI for Docker and Docker Compose.
# NOTE: If you want newer versions, use `jesseduffield/lazydocker/lazydocker`.
brew install --quiet lazydocker

# Install Kubernetes CLI tool.
brew install --quiet kubernetes-cli

# Install kubectx and kubens to switch between Kubernetes contexts and namespaces.
brew install --quiet kubectx

# Install some TUI apps to get info on Kubernetes clusters.
brew install --quiet vladimirvivien/oss-tools/ktop
brew install --quiet kdash-rs/kdash/kdash

# NOTE: I installed these extensions in Docker Desktop:
    # Disk Usage
    # Docker MCP Toolkit
    # Dockerfile Diff
    # Labs VS Code Installer
    # Live Charts
    # Log Lens
    # Logs Explorer
    # Port Navigator
    # Resource Usage
    # Selenium
    # Snyk
# NOTE: I configured Docker Desktop:
    # General
        # ENABLE Start Docker Desktop when you sign in
    # Resources
        # Disk Usage: 128 GB
    # Features in Development
        # ENABLE Dev Environments (hoping to enable VS Code Installer)
        # ENABLE Wasm
