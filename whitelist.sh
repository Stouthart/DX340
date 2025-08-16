#!/bin/sh
#
# v6.2b, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  case "$HOSTNAME" in
  DX340 | DX180) ;;
  *)
    echo 'Your device is not compatible with this version.' >&2
    exit 1
    ;;
  esac

  echo '[ Doze & App Standby ]'

  echo '> Comparing 3rd-party apps with whitelist...'

  set -- \
    au.com.shiftyjelly.pocketcasts \
    com.amazon.mp3 \
    com.apple.android.music \
    com.apple.android.music.classical \
    com.aspiro.tidal \
    com.bandcamp.android \
    com.bubblesoft.android.bubbleupnp \
    com.extreamsd.usbaudioplayerpro \
    com.foobar2000.foobar2000 \
    com.google.android.apps.youtube.music \
    com.hiby.music \
    com.jriver.mediacenter \
    com.maxmpz.audioplayer \
    com.neutroncode.mp \
    com.pandora.android \
    com.qobuz.music \
    com.roon.mobile \
    com.roon.onthego \
    com.soundcloud.android \
    com.spotify.music \
    com.zilideus.jukebox_new \
    de.battlestr1k3.radionerd \
    de.bluegaspode.squeezeplayer \
    deezer.android.app \
    tunein.player

  p3=$(cmd package list packages -3 | sed 's/^package://')
  wl=$(printf '%s\n' "$@" "$p3" | LC_ALL=C sort | uniq -d | sed 's/^/+/')

  echo '> Whitelisting apps...'
  printf '%s\n' +com.ibasso.music "$wl" | xargs dumpsys deviceidle whitelist

  echo '> Done'
}
