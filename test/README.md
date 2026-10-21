# VM Test Harness

Run the setup scripts against a disposable macOS VM to verify a fresh-Mac setup
before it matters on real hardware — and to test an OS upgrade before committing
to it. Design rationale lives in [../docs/vm-test-harness-prd.md](../docs/vm-test-harness-prd.md).

## Quick start

A root `Makefile` wraps everything (`make help` lists all targets):

```sh
make setup        # one-time: install host dependencies (tart)
make image        # one-time: build the VM image (then steps below)
make test         # run the full suite on a fresh clone
make help         # list every target
```

## Disk space

**Budget ~40 GB for the first image, ~20 GB per image after that.** Everything
lives under `~/.tart/`:

| What | Size | Cleanup |
|------|------|---------|
| Each VM image (`~/.tart/vms/`) | **~20–25 GB** | `make clean-image` |
| Downloaded IPSW, cached by tart (`~/.tart/cache/IPSWs/`) | **~20 GB each** | `make clean-cache` |
| Per-run clones | copy-on-write — near-zero at first, grows as the run writes | `make clean` |

**tart does not delete the IPSW after building an image** — it keeps it cached so
a rebuild skips the ~20 GB download. That's usually what you want, but the cache
holds one file *per macOS version you've built*, so purge it with `make
clean-cache` when you're done with a version (it re-downloads on demand).

Check real free space with `df -h ~`, not Finder — Finder counts purgeable local
Time Machine snapshots as available. If `df` looks tight, reclaim them with
`sudo tmutil thinlocalsnapshots / 100000000000 4`.

## Tooling

[`tart`](https://tart.run) — a CLI-first macOS VM manager on Apple's
Virtualization.framework. Chosen for **instant copy-on-write clones**, so each
test run resets to a pristine state in seconds. Install it with `make install-tools`.

## One-time: build the VM image

Run everything from the repo root — each step is a `make` target, no `cd` needed.
Steps marked 🖥️ are manual inside the VM; the rest run on your host.

1. **`make image`** — downloads the IPSW and installs macOS into a fresh VM disk
   (~30–60 min). *(Run `make setup` first if tart isn't installed.)*

   The image is named for **this Mac's** macOS version (`mac-setup-26.6` on a
   26.6 host), so you normally don't pass `IMAGE` at all. Override it — with a
   matching `IPSW` — only to build a different version, e.g. a beta:
   `make image IMAGE=mac-setup-27b2 IPSW=<beta-ipsw-url>`. Because the IPSW
   defaults to the newest Apple publishes, pin `IPSW` if your Mac is behind, so
   the image's name still matches its contents.

2. **`make boot`** — opens the image window.

3. 🖥️ **Setup Assistant (manual, ~2 min).** Click through it yourself and create
   an admin account with a password. Name it to match your Mac's login (that's
   the default the harness assumes) or pass `VM_USER=<name>` to the steps below.
   Do it manually — scripted typing trips macOS's press-and-hold accent picker,
   and you must be present for the password anyway. Skip Apple ID; decline
   FileVault, Location, and Analytics.

4. 🖥️ **Enable Remote Login.** System Settings → General → Sharing → **Remote
   Login** ON. Click its (ⓘ) and turn ON **Allow full disk access for remote
   users** — `init.sh` stops without Full Disk Access.

   Also allow your **terminal app** to reach the local network (System Settings →
   Privacy & Security → **Local Network**). If the app isn't listed, **quit and
   reopen System Settings** — the list is stale until then; failing that, run the
   next step from a terminal that already has the permission.

5. **`make access`** — installs the automation SSH key + passwordless sudo
   via `ssh-copy-id` (prompts for the VM password, which the AI never sees). No
   pasting into the VM window — host↔guest clipboard is unreliable.

   Add `VM_USER=<name>` if the VM's admin account isn't your Mac's login name —
   e.g. `make access VM_USER=admin`. The same applies to `make test`.

6. **`make freeze`** — shuts the VM down, freezing it as the pristine base.

Never run tests on the image directly; `make test` clones it.

> **Runs are host-driven.** `run.sh` SSHes into the VM from your terminal, which
> reaches the VM's private subnet; an AI agent's sandbox typically cannot. So
> **you** run `make test`; the AI reads the captured `test/logs/` to help fix
> failures. `tart ip` is unreliable on macOS 26, so `run.sh` resolves the VM's
> IP via `test/lib/vm-ip` (MAC → DHCP lease).

## Keeping more than one image

Images are cheap to derive from each other (`make clone NEW=…`) and each answers
a different question, so it is worth keeping a few:

| Image | Contains | Answers |
|-------|----------|---------|
| `mac-setup-26.6` | pristine macOS | "Does this work on a brand-new Mac?" — the real question |
| `mac-setup-26.6-clt` | pristine + Command Line Tools | the same, minus a ~1 GB download every run |
| `mac-setup-26.6-warm` | a finished (or half-finished) run | "Is a re-run idempotent?" — fastest, lowest fidelity |

Build a `-clt` image once — `make clone NEW=mac-setup-26.6-clt`, `make boot
IMAGE=…`, run `xcode-select --install` inside the VM, `make freeze IMAGE=…` — and
iterate against it. A `-warm` image is just a run clone you kept (rename it out
of `mac-setup-run-*`, which `make clean` deletes).

Treat results on the derived images as provisional: they start from a machine
that is no longer new, so they can hide a bug that only a clean install would
show. Confirm anything important against the pristine image before believing it.

## Testing a macOS upgrade

To vet an OS update before applying it to your real Mac:

1. **`make clone NEW=mac-setup-26.7`** — duplicate the current image under the
   version you're upgrading *to*, leaving the original intact to fall back on.
   (Add `FROM=<image>` to copy something other than the default `IMAGE`.)
2. **`make boot IMAGE=mac-setup-26.7`**.
3. 🖥️ In the VM, run **Software Update** to install the new macOS.
4. **`make freeze IMAGE=mac-setup-26.7`**.
5. **`make test IMAGE=mac-setup-26.7`** — runs the suite on the upgraded image.

Each OS version keeps its own frozen image, so comparing or rolling back is just
a change of `IMAGE`. The same flow covers betas —
`make clone NEW=mac-setup-27b2`, upgrade, freeze, test. Mind the disk cost: each
image is ~20 GB, and a clone diverges from its parent as the upgrade writes.

## Per run

```sh
make test                        # clone → run full suite → log → delete clone
make test KEEP=true              # keep the clone afterward, to inspect it
make test HEADLESS=true          # no VM window
RUN_GROUPS='os shell' make test  # only some ALL.sh groups (faster iteration)
```

Each run clones the image, delivers the **working tree** (via `rsync`, so
uncommitted edits are tested), installs the `mas` shim and a VM-specific
`ENV.sh`, runs the suite, and writes a log to `test/logs/`. The clone is deleted
afterward unless `KEEP` is set.

`VM_USER` names the VM's admin account and defaults to your Mac's login name; if
you named the VM account differently, pass `VM_USER=<name>` to `make access` and
`make test`.

Flags accept any spelling: only `false`, `no`, `off`, `0`, and empty are false
(case-insensitive) — anything else is true. Runs show a VM window by default; a
blocking GUI prompt is indistinguishable from a hang in a headless log, which
matters while the suite is still being debugged. Once runs are reliably green,
flip `HEADLESS ?= false` in the Makefile to make headless the default.

## Watching a run

A full run takes a while and the interesting parts happen inside the VM, so it's
usually worth having a second shell open:

```sh
make follow-logs   # tail the current run's log live
make logs          # print the newest run's log (after it finishes)
make ssh           # shell into the running clone (falls back to the image)
```

Some steps report nothing until they finish — notably the Command Line Tools
download (~1 GB, several minutes). It is easy to mistake for a hang. From
`make ssh`, watch the packages arrive:

```sh
tail -f /var/log/install.log | grep -E 'Starting download|Verifying'
```

Don't watch `/Library/Updates` — `softwareupdate` downloads into root's darwin
cache and only moves finished packages there, so that directory sits unchanged
for the whole download.

Runs also show a VM window by default (`HEADLESS=true` turns it off), which is
the quickest way to spot a step that's blocked on a GUI prompt.

## What is and isn't tested

- **Run:** `init.sh` then each `<group>/ALL.sh` in README order.
- **Serial gate:** `test/vm-env.sh` sets `SYSTEM_SERIAL_NUMBER` to the VM's own
  serial, so the machine-guard passes as designed.

### The App Store gap

A VM can't sign in to an Apple ID, so `mas` can't install anything.
`test/lib/mas` is a no-op shim that keeps the scripts moving. It lives in
`~/bin`, which [run.sh](run.sh) keeps ahead of Homebrew on `PATH` — `mas` is
itself a Homebrew formula, and the real binary hangs where the shim returns.
**Exactly four app
installs go untested** — Bear and Firetask ([os/app_store.sh](../os/app_store.sh)),
1Password for Safari ([os/1password.sh](../os/1password.sh)), and VirtualOS
([os/virtualization.sh](../os/virtualization.sh)) — plus `mas upgrade` and the
login-item registration for those apps.

Everything else in those same scripts **is** tested, including every Homebrew
install (the 1Password app and CLI, UTM, `mas` itself), the `defaults` writes,
the dock changes, and the 1Password biometric-unlock config.

One consequence to expect in logs: with an app absent, the following
`open -a <App>` fails, and the script's `trap … ERR` exits it there — in
`os/app_store.sh` that skips the rest of the file (Firetask, the App Store dock
removal, `mas upgrade`). These aborts are expected — report them as App-Store
gaps, never as passes.

## Files

| File | Purpose |
|------|---------|
| `install-tools.sh` | Install `tart` (host-side). |
| `create-image.sh` | One-time: download IPSW + install macOS into the VM image. |
| `setup-access.sh` | One-time (host): `ssh-copy-id` the key + passwordless sudo. |
| `run.sh` | Per-run driver: clone → deliver → run → log → teardown. |
| `vm-env.sh` | VM-specific `ENV.sh` (real-serial, no exit gate). |
| `lib/mas` | No-op `mas` shim. |
| `lib/vm-ip` | Resolve a VM's IP (MAC → DHCP lease; works around `tart ip`). |
| `logs/` | Captured per-run output. |
