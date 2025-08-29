#!/bin/sh
#
# Copyright © 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  [ "$HOSTNAME" = "DX340" ] || {
    echo 'Your device is not compatible with this version.' >&2
    exit 1
  }

  url=https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/batfet.sh
  file1=/data/adb/${url##*/}
  file2=/etc/init/batfet.rc

  [ -w "${file1%/*}" ] && [ -w "${file2%/*}" ] || {
    echo 'Read-only file system. Try "adb remount" first.' >&2
    exit 1
  }

  echo '[ Desktop Mode ]'

  echo "> Downloading template.."
  curl -sSfo "$file1" $url || {
    echo 'Failed to download template.' >&2
    exit 2
  }

  chmod +x "$file1"

  [ "${nocheck:-0}" -eq 1 ] && {
    # shellcheck disable=SC2016
    sed -i '37,38c\  case "$(cat /sys/class/power_supply/bq25890/online)" in\n  1) ;;' "$file1"
  }

  echo "> Creating init file..."

  cat >$file2 <<EOF
# Device model: DX340
# 
# Copyright © 2025 Stouthart. All rights reserved.

on property:sys.boot_completed=1
  exec_background -- $file1 disable

on shutdown
  exec -- $file1 enable
EOF

  chmod 0644 $file2
  chcon u:object_r:system_file:s0 $file2

  echo '> Done!'

  [ "${noboot:-0}" -eq 1 ] || {
    echo "> Shutdown..."
    reboot -p
  }
}
