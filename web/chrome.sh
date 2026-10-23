#!/bin/bash

set -Euo pipefail
IFS=$'\n\t'
[[ -n "${DEBUG+unset}" ]] && set -x
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" >&2 ; exit $RC' ERR

source "${BASH_SOURCE%/*}/../util/apps.sh"

## Install Chrome browser and extensions.

# Install Chrome browser.
brew-install-cask google-chrome
dockutil --add '/Applications/Google Chrome.app' --replacing 'Google Chrome' --before 'Safari'

# Chrome TODO (manual):
#   * Make sure 1Password works properly. FIXME: Need cask apps deployed into /Applications instead of locally.

## Install Chromium browser.
#brew-install-cask chromium
#dockutil --add '/Applications/Chromium.app' --replacing 'Chromium' --after 'Google Chrome'

# Install `extension` utility to install Chrome (or Edge or Arc) extensions from CLI.
# NOTE: Use `extension listen chrome` to listen for config changes.
brew-trust --formula 8ta4/extension/extension
brew install --quiet 8ta4/extension/extension

# Install Chrome extensions.
# NOTE: You may be prompted for your password.
# NOTE: You may need to restart Chrome to see the extensions.
# NOTE: You may need to enable the extensions in Chrome.
# NOTE: You may need to configure the extensions.
# NOTE: You may need to log in to the extensions.

# `extension` fails if Chrome has never run, because this directory does not exist yet.
mkdir -p "$HOME/Library/Application Support/Google/Chrome/External Extensions"

# uBlock Origin
extension install chrome cjpalhdlnbpafiamejdnhcphjbkeiagm

# 1Password
extension install chrome aeblfdkhhhdcdjpifhhbdiojplfjncoa

# OneTab
extension install chrome chphlpgkkbolifaimnlloiipkdnihall

# [Tab Session Manager](https://chromewebstore.google.com/detail/tab-session-manager/iaiomicjabeggjcfkbimgmglanimpnae)
extension install chrome iaiomicjabeggjcfkbimgmglanimpnae

# [Web Developer](https://chromewebstore.google.com/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm)
extension install chrome bfbameneiokkgbdmiekhjnmfkcnldhhm

# [React Developer Tools](https://chromewebstore.google.com/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)
extension install chrome fmkadmapgofadopljbjfkapdkoienihi

# [Lighthouse](https://chromewebstore.google.com/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk)
extension install chrome blipmdconlkpinefehnmjammfjpmpbjk

# [Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)
extension install chrome clngdbkpkpeebahjckkjfobafhncgmne

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

# [Raindrop.io](https://chromewebstore.google.com/detail/raindropio/ldgfbffkinooeloadekpmfoklnobpien)
extension install chrome ldgfbffkinooeloadekpmfoklnobpien

# [Video DownloadHelper](https://chromewebstore.google.com/detail/video-downloadhelper/lmjnegcaeklhafolokijcfjliaokphfk)
extension install chrome lmjnegcaeklhafolokijcfjliaokphfk

# [Terms of Service; Didn't Read](https://chromewebstore.google.com/detail/terms-of-service-didnt-re/hlifkpholllijblknnmbfagnkjneagid)
extension install chrome hlifkpholllijblknnmbfagnkjneagid

# [SponsorBlock](https://chromewebstore.google.com/detail/sponsorblock-for-youtube/mnjggcdmjocbbbhaepdhchncahnbgone)
extension install chrome mnjggcdmjocbbbhaepdhchncahnbgone

# [Tampermonkey](https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)
extension install chrome dhdgffkkebhmkfjojejmpbldmpobfkfo
