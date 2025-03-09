#!/bin/sh
#
# v4.1, Copyright (c) 2025 Stouthart. All rights reserved.
{
  [ -w /etc ] || {
    echo 'Read-only file system. Try "adb remount" first.'
    exit 1
  }

  echo '> Installing...'

  file=/etc/init/custom.rc
  curl -so $file https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/custom.rc

  ## https://android.stackexchange.com/questions/217495/how-can-proc-sys-values-be-changed-at-boot-sysctl-conf-does-this-on-normal-lin
  chmod 0644 $file
  chcon u:object_r:system_file:s0 $file

  # shellcheck disable=SC2154
  [ "$tune" = max ] && {
    sed -i -E 's,foreground/schedtune.boost [0-9]+$,foreground/schedtune.boost 30,' $file
    sed -i -E 's,top-app/schedtune.boost [0-9]+$,top-app/schedtune.boost 40,' $file
  }

  # Remove system-wide tracing files, will be fixed in next firmware, confirmed by @Paul - iBasso
  rm -f /etc/init/atrace.rc /etc/init/atrace_userdebug.rc 2>/dev/null

  echo '> Rebooting...'
  reboot
}
