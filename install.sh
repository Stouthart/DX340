#!/bin/sh
# shellcheck disable=SC2154
#
# v5.3b2, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  [ "$HOSTNAME" = DX340 ] || {
    echo '🚸 Your device is not compatible with this version.'
    exit 1
  }

  [ -w /etc/init ] || {
    echo '🚸 Read-only file system. Try "adb remount" first.'
    exit 1
  }

  echo '[ Advanced Tweaking ]'
  echo '🌱 Installing...'

  file=/etc/init/custom.rc

  curl -so $file https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/custom.rc
  chmod 0644 $file
  chcon u:object_r:system_file:s0 $file

  _execbkg() {
    LC_ALL=C sed -i "s,### ${1}$,exec_background -- ${SHELL} -c \"sleep 2; ${2}\"," $file
  }

  _minfreq() {
    _execbkg 'minfreq' "echo -n ${1} >/sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq"
  }

  _stboost() {
    sed -i -E "s,(stune/${1}schedtune.boost) [0-9]+$,\1 ${2}," $file
  }

  if [ "$pmax" -eq 1 ]; then # Performance MAX
    _minfreq 1401600
    _stboost 'top-app/' 40 # Scheduler tuning by Whitigir
    _execbkg 'noidle' 'dumpsys deviceidle disable'
  elif [ "$psave" -eq 1 ]; then # Power SAVE
    _minfreq 902400
    _stboost '' 8
    _stboost 'foreground/' 12
  fi

  [ "$noswap" -eq 1 ] && _execbkg 'noswap' 'swapoff /dev/block/zram0'

  [ -x /etc/rc.local ] && _execbkg 'rclocal' '/etc/rc.local'

  sed -i -E 's,### [a-z]+$,# N/A,g' $file # Cleanup

  # Reduce logging of system messages (logcat)
  setprop persist.log.tag E

  # Disable tracing services (perfetto.rc)
  setprop persist.traced.enable 0

  echo '✨ Done'

  echo '🔨 Rebooting...'
  reboot
}
