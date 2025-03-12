#!/bin/sh
# shellcheck disable=SC2154
#
# v4.5, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  [ "$HOSTNAME" = DX340 ] || {
    echo 'Your device is not compatible with this version.'
    exit 1
  }

  [ -w /etc ] || {
    echo 'Read-only file system. Try "adb remount" first.'
    exit 1
  }

  echo '> Installing...'

  file=/etc/init/custom.rc

  curl -so $file https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/custom.rc
  chmod 0644 $file
  chcon u:object_r:system_file:s0 $file

  [ "$noidle" = 1 ] && {
    LC_ALL=C sed -i 's,### noidle$,exec_background -- /system/bin/dumpsys deviceidle disable all,' $file
  }

  [ "$stmax" = 1 ] && {
    sed -i -E 's,foreground/schedtune.boost [0-9]+$,foreground/schedtune.boost 30,' $file
    sed -i -E 's,top-app/schedtune.boost [0-9]+$,top-app/schedtune.boost 40,' $file
  }

  [ -f /etc/rc.local ] && {
    LC_ALL=C sed -i 's,### rclocal$,exec_background -- /etc/rc.local,' $file
  }

  # Remove "system-wide tracing" files, will be fixed in next firmware, confirmed by @Paul - iBasso
  rm -f /etc/init/atrace.rc /etc/init/atrace_userdebug.rc 2>/dev/null

  echo '> Rebooting...'
  reboot
}
