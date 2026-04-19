#!/bin/bash

## Install and configure web browsers.

# We'll use [Finicky](https://github.com/johnste/finicky) to use different browsers for different sites and web apps.
# Alternatives: [Choosy](https://www.choosyosx.com/), Browser Fairy, Browserosaurus, OpenIn, Browser ChooserX
brew install --quiet --cask finicky
# WARNING: You'll be prompted to change your default browser to Finicky. Click **Use "Finicky"**.
open -a Finicky

# TODO: Make sure Finicky starts at login.
#   Manual: System Settings / General / Login Items / + `/Applications/Finicky.app`

# Install Chrome browser.
brew install --quiet --cask google-chrome
dockutil --add '/Applications/Google Chrome.app' --replacing 'Google Chrome' --before 'Safari'

# Chrome TODO (manual):
#   * Make sure 1Password works properly. FIXME: Need cask apps deployed into /Applications instead of locally.
#   * Install AdBlocker Ultimate extension.
#   * Install OneTab (recommended by Mikhail).

# Install `extension` utility to install Chrome (or Edge or Arc) extensions from CLI.
# NOTE: Use `extension listen chrome` to listen for config changes.
brew install --quiet 8ta4/extension/extension

# Install Chrome extensions.
# NOTE: You may be prompted for your password.
# NOTE: You may need to restart Chrome to see the extensions.
# NOTE: You may need to enable the extensions in Chrome.
# NOTE: You may need to configure the extensions.
# NOTE: You may need to log in to the extensions.

# uBlock Origin
extension install chrome cjpalhdlnbpafiamejdnhcphjbkeiagm

# 1Password
extension install chrome aeblfdkhhhdcdjpifhhbdiojplfjncoa

# OneTab
# TODO: Consider alternatives: [Session Buddy](https://chromewebstore.google.com/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko)
extension install chrome chphlpgkkbolifaimnlloiipkdnihall

# [Web Developer](https://chromewebstore.google.com/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm)
extension install chrome bfbameneiokkgbdmiekhjnmfkcnldhhm

# [React Developer Tools](https://chromewebstore.google.com/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)
extension install chrome fmkadmapgofadopljbjfkapdkoienihi

# [Lighthouse](https://chromewebstore.google.com/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk)
extension install chrome blipmdconlkpinefehnmjammfjpmpbjk

# [Next Experience Developer Tools](https://chromewebstore.google.com/detail/next-experience-developer/ilkodijinjhpdnnfpccijledlapkfmhc)
extension install chrome ilkodijinjhpdnnfpccijledlapkfmhc

# Stylish
# TODO: Consider alternatives: [Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)
extension install chrome fjnbnpbmkenffdnngjfgmeleoegfcffe

# [GitHub Code Folding](https://chromewebstore.google.com/detail/github-code-folding/lefcpjbffalgdcdgidjdnmabfenecjdf)
extension install chrome lefcpjbffalgdcdgidjdnmabfenecjdf

# [Obsidian Web Clipper](https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf)
extension install chrome cnjifjpddelmedmihgijeibhnjfabmlf

# Official [Wayback Machine](https://chromewebstore.google.com/detail/wayback-machine/fpnmgdkabkmnadcjpehmlllkndpkmiak)
extension install chrome fpnmgdkabkmnadcjpehmlllkndpkmiak

# [Web Archives](https://chromewebstore.google.com/detail/web-archives/hkligngkgcpcolhcnkgccglchdafcnao)
extension install chrome hkligngkgcpcolhcnkgccglchdafcnao

# [Internet Archive Assistant](https://chromewebstore.google.com/detail/internet-archive-assistan/behpdfoepanebmpljobdjgbkkekidhfh)
extension install chrome behpdfoepanebmpljobdjgbkkekidhfh

# [Save ChatGPT to Obsidian](https://chromewebstore.google.com/detail/save-chatgpt-to-obsidian/bdkpamdmcgamabdeaeehfmaiaejcdfko)
extension install chrome bdkpamdmcgamabdeaeehfmaiaejcdfko

# [Claude to Obsidian](https://chromewebstore.google.com/detail/claude-to-obsidian/ehacefdknbaacgjcikcpkogkocemcdil)
extension install chrome ehacefdknbaacgjcikcpkogkocemcdil

# [JSON Formatter](https://chromewebstore.google.com/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa)
extension install chrome bcjindcccaagfpapjjmafapmmgkkhgoa

# [Wappalyzer](https://chromewebstore.google.com/detail/wappalyzer/gppongmhjkpfnbhagpmjfkannfbllamg)
extension install chrome gppongmhjkpfnbhagpmjfkannfbllamg

# [OCR Image Reader](https://chromewebstore.google.com/detail/ocr-image-reader/bhbhjjkcoghibhibegcmbomkbakkpdbo)
extension install chrome bhbhjjkcoghibhibegcmbomkbakkpdbo

# [Copy as Markdown](https://chromewebstore.google.com/detail/copy-as-markdown/nlaionblcaejecbkcillglodmmfhjhfi)
extension install chrome nlaionblcaejecbkcillglodmmfhjhfi

# [Consent-O-Matic](https://chromewebstore.google.com/detail/consent-o-matic/mdjildafknihdffpkfmmpnpoiajfjnjd)
extension install chrome mdjildafknihdffpkfmmpnpoiajfjnjd

# [Just Read](https://chromewebstore.google.com/detail/just-read/dgmanlpmmkibanfdgjocnabmcaclkmod)
extension install chrome dgmanlpmmkibanfdgjocnabmcaclkmod


# Install Microsoft Edge.
# NOTE: You'll be prompted for your password.
echo 'Installing Microsoft Edge... You may be prompted for your password.'
brew install --quiet --cask microsoft-edge
dockutil --add '/Applications/Microsoft Edge.app' --replacing 'Microsoft Edge' --after 'Safari'

# Install Firefox browser.
brew install --quiet --cask firefox
dockutil --add '/Applications/Firefox.app' --replacing 'Firefox' --after 'Microsoft Edge'

# Firefox TODO (manual):
#   * View / Toolbars / CHECK Bookmarks Toolbar
#   * Addons
#   * Make sure 1Password works properly.

# Install Firefox Developer Edition.
brew install --quiet --cask firefox@developer-edition
dockutil --add '/Applications/Firefox Developer Edition.app' --replacing 'Firefox Developer Edition' --after 'Firefox'

# Create a folder for extra browsers, add it to the Dock.
mkdir -p /Applications/Browsers
ln -s '/Applications/Google Chrome.app' '/Applications/Browsers/Google Chrome.app'
ln -s '/Applications/Microsoft Edge.app' '/Applications/Browsers/Microsoft Edge.app'
ln -s '/Applications/Safari.app' '/Applications/Browsers/Safari.app'
ln -s '/Applications/Firefox.app' '/Applications/Browsers/Firefox.app'
ln -s '/Applications/Firefox Developer Edition.app' '/Applications/Browsers/Firefox Developer Edition.app'
dockutil --add '/Applications/Browsers' --replacing 'Browsers' --after 'Google Chrome' --display folder --view grid --sort name &> /dev/null
# NOTE: Due to OS limitation, dockutil `--view grid` only works if adding to `--section others`.
# TODO: AUTOMATE: Give the folder a nice icon. See https://apple.stackexchange.com/questions/20262/how-can-i-specify-a-custom-icon-for-a-dock-stack.
#   Created a folder with the desired icon, using https://folderart.christianvm.dev/ and the Font Awesome icon for "globe" (classic regular).
#   Followed these instructions to set the folder icon: https://support.apple.com/en-au/guide/mac-help/mchlp2313/mac.
#   Also consider https://macosicons.com/, https://github.com/kfreitag1/FancyFolders, and https://thisdevbrain.com/how-to-create-a-custom-macos-folder-icon/.

# Terminal-based web browsers.
brew install --quiet lynx
brew install --quiet links
brew install --quiet w3m
