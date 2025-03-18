#!/bin/sh
# shellcheck disable=SC2154
#
# v5.1b, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  [ "$HOSTNAME" = DX340 ] || {
    echo 'Your device is not compatible with this version.'
    exit 1
  }

  [ -w /etc/init ] || {
    echo 'Read-only file system. Try "adb remount" first.'
    exit 1
  }

  echo '> Installing...'

  file=/etc/init/custom.rc

  curl -so $file https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/custom.rc
  chmod 0644 $file
  chcon u:object_r:system_file:s0 $file

  [ "$pmax" = 1 ] && { # "Performance MAX"
    LC_ALL=C sed -i 's,### noidle$,exec_background -- /system/bin/dumpsys deviceidle disable,' $file
    minfreq=1401600
  }

  case "$minfreq" in
  652800 | 902400 | 1401600)
    cmd="sleep 1; echo -n ${minfreq} >/sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq"
    LC_ALL=C sed -i "s,### minfreq$,exec_background -- ${SHELL} -c \"${cmd}\"," $file
    ;;
  esac

  [ "$stmax" = 1 ] && { # "MAX by Whitigir" scheduler tuning
    sed -i -E 's,(foreground/schedtune.boost) [0-9]+$,\1 30,' $file
    sed -i -E 's,(top-app/schedtune.boost) [0-9]+$,\1 40,' $file
  }

  [ -x /etc/rc.local ] && {
    LC_ALL=C sed -i 's,### debug$,exec_background -- /etc/rc.local,' $file
  }

  sed -i -E "s,### printk ([a-z]+)$,write /dev/kmsg \"${file##*/}: \1\",g" $file
  sed -i -E 's,### [a-z]+$,# N/A,g' $file

  # Remove "system-wide tracing" files, will be fixed in next firmware, confirmed by @Paul - iBasso
  # rm -f /etc/init/atrace.rc /etc/init/atrace_userdebug.rc 2>/dev/null

  echo '> Rebooting...'
  reboot
}
