#!/bin/sh
# shellcheck disable=SC2154
#
# v5.2b, Copyright (C) 2025 Stouthart. All rights reserved.
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
    minfreq=1401600
    sed -i 's,### noidle$,exec_background -- /system/bin/dumpsys deviceidle disable,' $file
  }

  [ "$psave" = 1 ] && minfreq=902400 # "Power SAVE"

  case "$minfreq" in
  902400 | 1401600)
    cmd="sleep 1; echo -n ${minfreq} >/sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq"
    sed -i "s,### minfreq$,exec_background -- ${SHELL} -c \"${cmd}\"," $file
    ;;
  esac

  [ "$stmax" = 1 ] && { # "MAX by Whitigir" scheduler tuning
    sed -i -E 's,(foreground/schedtune.boost) [0-9]+$,\1 30,' $file
    sed -i -E 's,(top-app/schedtune.boost) [0-9]+$,\1 40,' $file
  }

  [ -x /etc/rc.local ] && sed -i 's,### debug$,exec_background -- /etc/rc.local,' $file

  sed -i -E "s,### printk ([a-z]+)$,write /dev/kmsg \"${file##*/}: \1\",g" $file
  sed -i -E 's,### [a-z]+$,# N/A,g' $file

  echo '> Rebooting...'
  reboot
}
