#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

# Install ffmpeg. Note: It installs a lot of dependencies:
#   aribb24, dav1d, frei0r, libtasn1, nettle, p11-kit, libevent, libnghttp2, unbound, gnutls, lame, libunibreak, libass, libbluray, cjson, libmicrohttpd, mbedtls, librist, libsoxr, libssh, libvidstab, libvorbis, libvpx, opencore-amr, opus, rav1e, libsamplerate, mpg123, libsndfile, rubberband, sdl2, snappy, speex, srt, svt-av1, theora, x264, x265, xvid, libsodium, zeromq, zimg
brew install --quiet ffmpeg
