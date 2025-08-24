#!/bin/sh
#
# v6.2b, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  case "$HOSTNAME" in
  DX340) ;;
  *)
    echo 'Your device is not compatible with this version.' >&2
    exit 1
    ;;
  esac

  [ "$(id -u)" = 0 ] || {
    echo 'Must be run as root. Try "adb root" first.' >&2
    exit 1
  }

  echo '[ F_BATFET_DIS ]'

  old=$(i2cget -f -y 4 0x6a 0x09)

  # shellcheck disable=SC3006
  if (((old & (1 << 5)) != 0)); then
    new=$((old & ~((1 << 5) | (1 << 3))))
    echo '> Enabling BATFET...'
  else
    new=$((old | (1 << 5) | (1 << 3)))
    echo '> Disabling BATFET...'
  fi

  i2cset -f -y 4 0x6a 0x09 $new b

  echo '> Done!'
}
