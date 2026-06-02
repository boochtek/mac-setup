# Generate SSH key

# NOTE: Interactive (unless you already have an SSH key):
#     - asks for a passphrase
#     - copies public key contents to clipboard
#     - opens browser to SSH pages on GitHub and GitLab (assuming you're logged in)
# WARNING: Updates shell startup scripts to start SSH agent (unless the agent is already running).

KEY_TYPE='ed25519'
SSH_KEY="$HOME/.ssh/id_$KEY_TYPE"

main() {
    create_ssh_dir
    create_ssh_config
    generate_ssh_key
    update_shell_startup_scripts
    start_ssh_agent
    add_key_to_agent
}

create_ssh_dir() {
    if [[ ! -d ~/.ssh ]]; then
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
    fi
}

create_ssh_config() {
    if [[ ! -f ~/.ssh/config ]]; then
        touch ~/.ssh/config
        chmod 600 ~/.ssh/config
    fi
}

generate_ssh_key() {
    if [[ ! -e "$SSH_KEY" ]]; then
        if [[ -z "$USER_EMAIL_ADDRESS" ]]; then
            echo 'Please set $USER_EMAIL_ADDRESS for SSH key generation.'
            exit_or_return 1
        else
            SERIAL_NUMBER="$(system_profiler SPHardwareDataType | awk -F ': ' '/Serial Number/ {print $2}')"
            HOSTNAME="${HOSTNAME:-$SERIAL_NUMBER}"
            KEY_COMMENT="${USER_EMAIL_ADDRESS} (${HOSTNAME})"

            echo "Creating SSH key pair. You will be prompted for a passphrase."
            echo "Be sure to save your passphrase in your password manager."

            # NOTE: The `-a 100` (default is 16) increases number of KDF rounds for encrypting private key.
            # This makes brute-force attacks slower, with little difference to humans.
            ssh-keygen -t ed25519 -C "$KEY_COMMENT" -f "$SSH_KEY" -a 100

            echo "SSH key pair created at $SSH_KEY"

            # Add SSH config to GitHub, GitLab, etc.
            pbcopy < "$SSH_KEY.pub"
            echo "Opening GitHub and GitLab SSH keys pages in your browser."
            echo "Your public SSH key has been copied to your clipboard."
            echo "Paste it into your SSH keys pages on GitHub, GitLab, etc."
            open https://github.com/settings/keys
            open https://gitlab.com/-/user_settings/ssh_keys
        fi
    fi
}

start_ssh_agent() {
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        echo "Starting SSH agent."
        eval "$(ssh-agent -s)"
    fi
}

update_shell_startup_scripts() {
    # Bash
    if [ -f ~/.bash_profile ] && ! grep -q 'ssh-agent' ~/.bash_profile; then
        echo 'eval "$(ssh-agent -s)"' >> ~/.bash_profile
        echo "ssh-add $SSH_KEY" >> ~/.bash_profile
        echo "Added SSH agent to your \`~/.bash_profile\`."
    fi
    # Zsh
    if [ -f ~/.zshrc ] && ! grep -q 'ssh-agent' ~/.zshrc; then
        echo 'eval "$(ssh-agent -s)"' >> ~/.zshrc
        echo "ssh-add $SSH_KEY" >> ~/.zshrc
        echo "Added SSH agent to your \`~/.zshrc\`."
    fi
    # Fish
    if [ -f ~/.config/fish/config.fish ] && ! grep -q 'ssh-agent' ~/.config/fish/config.fish; then
        echo 'eval (ssh-agent -c)' >> ~/.config/fish/config.fish
        echo "ssh-add $SSH_KEY" >> ~/.config/fish/config.fish
        echo "Added SSH agent to your \`~/.config/fish/config.fish\`."
    fi
}

add_key_to_agent() {
    ssh-add "$SSH_KEY"
}

# Return if running via `source`, so we don't exit parent shell. Otherwise, exit.
exit_or_return() {
    # If $BASH_SOURCE[0] != $0, the script is being sourced.
    if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
        return "$1"
    else
        exit "$1"
    fi
}

main "$@"
