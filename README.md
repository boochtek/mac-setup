# MacOS Setup

These scripts will set up MacOS the way we want, including:

* Configuring OS preferences
* Installing applications
* Configuring applications

These scripts currently support macOS 26 (Tahoe).
They have existed since at least MacOS 10.9 (Mavericks).

The scripts _should_ all be idempotent.
(That means that you can run them as many times as you want.)

You will likely be prompted for your password several times.
This is because many of the scripts use `sudo` to install various programs and settings.

## Usage

0. Open a Terminal window.

1. Make sure git is installed.

~~~ shell
git --version 2>/dev/null || echo 'Follow prompts to install command line developer tools. When it finishes, continue with the next step.'
~~~

2. Download the repo.
    * Use the HTTPS URL if SSH is not set up yet.
        * You'll want to switch to SSH if you want to commit changes.
            * Edit `.git/config` to change `https://github.com/` to `git@github.com:`.

~~~ shell
git clone https://github.com/boochtek/mac-setup.git
cd mac-setup
~~~

3. Edit `ENV.sh` to define various settings.
    * Be sure to read through and change any settings, as appropriate.
    * You can use `vi` or TextEdit instead of `nano`.
        * macOS has `nano` as a soft link to `pico`.

~~~ shell
nano ENV.sh
~~~

4. Run the initialization.
    * This will install CLT, Homebrew, and my config files.

~~~ shell
source ./init.sh
~~~

5. Set up the OS, hardware, and shell.

~~~ shell
./os/ALL.sh
./hardware/ALL.sh
./shell/ALL.sh
~~~

6. Install web tools.

~~~ shell
./web/ALL.sh
~~~

7. Install tools for development work.

~~~ shell
./editors/ALL.sh
./dev/ALL.sh
~~~

8. Install the rest.

~~~ shell
email/ALL.sh
work/ALL.sh
~~~

## OLD!

Next, edit the config files:
* inventory_for_mac_serial_number.sh - add your computer to the list
* appstore_apps_to_install.yml - list of App Store apps to be installed

Theoretically, any of these scripts could be run independently.
(Except for the `util` directory, which contains shared code imported by other scripts.)
However, there are some (likely not adequately documented) dependencies.
This order should work:

~~~ shell
os/ALL.sh
hardware/ALL.sh
shell/ALL.sh
editors/ALL.sh
email/ALL.sh
web/ALL.sh
dev/ALL.sh
~~~

Many scripts will prompt for your password, as they require `sudo` to install various programs and settings.
Others might ask for other passwords, for example your Mac App Store ID and password.
You can just hit **Enter** on the Mac App store prompts, if you won't be installing anything from the Mac App Store.

Note that some of the scripts might take a while to run.
For example, installing Xcode may take over an hour.
The entire set of scripts will take several hours to run;
many packages will be downloaded and compiled.
Even if nothing new needs to be installed, the scripts could take about 8 minutes to run.

Note that some scripts will kill the Terminal.


## Manual Steps

See [MANUAL.md](MANUAL.md) for steps that have not (yet) been automated.


## Bash 3.2

Keep in mind that macOS ships with Bash 3.2.
MacOS will likely never ship with anything newer, due to Apple's dislike of GPLv3.
So we can't use any features introduced in Bash 4 or later:
* Associative arrays
* Case-modification operators for parameter substitution
* Globbing with `**` to match recursively
* Escape codes in strings with `\u` and `\U` to represent Unicode characters
* Negative array indices


## TODO: Downloading and Installing MacOS Sonoma

diskutil list external physical
diskutil info -all

DEVICE='device-name-found-above'
diskutil partitionDisk "$DEVICE" GPT JHFS+ 'Sonoma Installer'

~~~ shell
softwareupdate --fetch-full-installer
sudo '/Applications/Install macOS Monterey.app/Contents/Resources/createinstallmedia' \
  --volume '/Volumes/Sonoma Installer'
~~~


## Using VirtualOS to Test

I found [VirtualOS](https://github.com/yep/virtualOS), which will run MacOS inside a VM.
This is great for testing these scripts.

You won't need to dedicate a lot of CPU to the VM,
but you'll need a lot of disk space.
You'll need at least 50 GB to install the OS, developer tools, and apps.
You should be fine with 16 GB of RAM, maybe less.
I'm currently working with 4 CPUs, 16 GB RAM, and 60 GB disk.
