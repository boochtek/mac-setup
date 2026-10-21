#!/bin/bash

# One-time (host-side): grant the automation SSH key access to the VM image and
# enable passwordless sudo — so every later run is unattended.
#
# Run this from YOUR Mac's terminal (not inside the VM) AFTER you've enabled
# Remote Login in the VM (System Settings → General → Sharing → Remote Login),
# including its "Allow full disk access for remote users" (init.sh needs it).
# It prompts for the VM account password a couple of times; the AI never sees
# it. This avoids pasting into the VM window (host↔guest clipboard is flaky).
#
# Usage: ./test/setup-access.sh [vm-ip]

set -uo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

VM_USER="${VM_USER:-$(id -un)}"
KEY="${SSH_KEY:-$HOME/.ssh/mac-setup-vm}"
IMAGE="${IMAGE:-mac-setup-$(sw_vers -productVersion)}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

IP="${1:-$("$REPO/test/lib/vm-ip" "$IMAGE")}"
ssh_opts=(-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR)
echo "VM $IMAGE at $IP (account: $VM_USER)"

# Echo make commands back with IMAGE= only when it isn't the default, so the
# suggestions can be pasted as-is.
make_image_arg=""
[[ "$IMAGE" != "mac-setup-$(sw_vers -productVersion)" ]] && make_image_arg=" IMAGE=$IMAGE"

# 0) Pre-flight: SSH must be reachable, or the errors below are cryptic. The two
#    failure modes look identical to ssh but have very different fixes.
if ! nc -z -G 5 "$IP" 22; then
    echo "ERROR: cannot reach $IP port 22."
    if ping -c 2 -t 3 "$IP" >/dev/null; then
        echo "  The VM answers ping, so sshd isn't listening: enable Remote Login"
        echo "  in the VM (System Settings > General > Sharing > Remote Login)."
    else
        echo "  The VM doesn't answer ping either. Most likely this terminal lacks"
        echo "  macOS Local Network permission — since macOS 15, each app needs it"
        echo "  to reach private IPs, and without it connections fail exactly like"
        echo "  this. Grant it in System Settings > Privacy & Security > Local"
        echo "  Network (enable your terminal app), then re-run."
        echo "  Also confirm the VM is running: make list-vms"
    fi
    exit 1
fi

# 1) Install the automation public key (enter the VM password once).
ssh-copy-id -i "$KEY.pub" "${ssh_opts[@]}" "$VM_USER@$IP"

# 2) Enable passwordless sudo (enter the VM password once more; -t for the prompt).
#    sudoers.d ignores filenames containing a dot, so dots become dashes.
ssh -t -i "$KEY" "${ssh_opts[@]}" "$VM_USER@$IP" \
    "echo '$VM_USER ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/${VM_USER//./-}"

# 3) Verify key + passwordless sudo with no prompts.
echo "Verifying:"
ssh -i "$KEY" -o BatchMode=yes "${ssh_opts[@]}" "$VM_USER@$IP" 'echo "  ssh key OK as $(whoami)"; echo "  sudo -> $(sudo -n whoami)"'
echo "Access configured. Freeze the image with: make freeze$make_image_arg"
