#!/bin/sh
#
# v5.7, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC2166,SC3028
  [ "$HOSTNAME" = DX340 -o "$HOSTNAME" = DX180 ] || {
    echo '🚸 Your device is not compatible with this version.'
    exit 1
  }

  echo '[ Doze & App Standby ]'
  echo '🌱 Whitelisting apps...'

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

  p3=$(cmd package list packages -3 | sed 's,package:,,g')
  wl=$(printf '%s\n' "$@" "$p3" | LC_ALL=C sort | uniq -d | sed 's,^,+,')

  # shellcheck disable=SC2086
  dumpsys deviceidle whitelist +com.ibasso.music $wl

  echo '✨ Done'
}
