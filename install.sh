#!/bin/sh
#
# v6.1b, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  case "$HOSTNAME" in
  DX340 | DX180) ;;
  *)
    echo 'Your device is not compatible with this version.'
    exit 1
    ;;
  esac

  [ -w /etc/init ] || {
    echo 'Read-only file system. Try "adb remount" first.'
    exit 1
  }

  echo '[ Advanced Tweaking ]'

  url=https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/custom.rc
  file=/etc/init/${url##*/}

  echo '> Downloading custom init file...'
  curl -sfo "$file" "$url" || {
    echo 'Failed to download configuration file.'
    exit 2
  }

  chmod 0644 "$file"
  chcon u:object_r:system_file:s0 "$file"

  # Helper functions

  _execbkg() {
    _replace "$1" "exec_background -- $SHELL -c \"sleep 2; ${2}\""
  }

  _minfreq() {
    _execbkg minfreq "echo $1 >/sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq"
  }

  _replace() {
    sed -i "s,### ${1}$,$2," "$file"
  }
  _sedregx() {
    sed -i -E "s,($1) [0-9]+$,\1 $2," "$file"
  }

  _stboost() {
    _sedregx "stune/${1}schedtune.boost" "$2"
  }

  echo '> Applying performance mode...'
  if [ "${pultra:-0}" -eq 1 ]; then # Performance ULTRA
    _replace tmrmig 'write /proc/sys/kernel/timer_migration 0'
    _minfreq 1401600 # 1536000 ?
    _stboost '' 20
    _stboost foreground/ 30
    _stboost top-app/ 40            # Scheduler tuning by Whitigir
  elif [ "${pmax:-0}" -eq 1 ]; then # Performance MAX
    _minfreq 1401600
    _stboost top-app/ 40             # Scheduler tuning by Whitigir
  elif [ "${psave:-0}" -eq 1 ]; then # Power SAVE
    _minfreq 652800
    _stboost '' 8
    _stboost foreground/ 12
  fi

  [ "${nozram:-0}" -eq 1 ] && {
    echo '> Disabling zRAM...'
    _execbkg nozram 'swapoff /dev/block/zram0; echo 1 >/sys/block/zram0/reset'
  }

  [ "$(awk '/MemTotal/ {print $2}' /proc/meminfo)" -gt 4194304 ] && {
    echo '> Tuning for >4GB RAM...'
    _sedregx sda/queue/nr_requests 512
    _sedregx sda/queue/read_ahead_kb 2048
    _execbkg tdswap 'echo 10 >/proc/sys/vm/swappiness'
  }

  # Debugging & testing
  [ -x /etc/rc.local ] && _execbkg rclocal /etc/rc.local

  echo '> Final cleanup & tweaks...'
  sed -i -E 's,### [a-z]+$,# N/A,g' "$file" # Cleanup

  # Reduce logging of system messages (logcat)
  setprop persist.log.tag W # I

  # Disable tracing services (perfetto.rc)
  setprop persist.traced.enable 0 # 1

  echo '> Done!'

  echo "> Rebooting..."
  reboot
}
