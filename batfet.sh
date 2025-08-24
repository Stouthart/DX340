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
    echo 'Script must be run as root. Try "adb root" first.' >&2
    exit 1
  }

  echo '[ F_BATFET_DIS ]'

  reg=$(i2cget -f -y 4 0x6a 0x09)

  _i2cset() {
    i2cset -f -y 4 0x6a 0x09 "$1" b
  }

  # shellcheck disable=SC3006
  if (((reg & (1 << 5)) == 0)); then
    if (($((reg & (1 << 2))) == 0)); then
      echo '> Not USB powered. Abort.'
      exit 2
    fi
    echo '> Disabling BATFET...'
    _i2cset $((reg | (1 << 5) | (1 << 3)))
  else
    echo '> Enabling BATFET...'
    _i2cset $((reg & ~((1 << 5) | (1 << 3))))
  fi

  echo '> Done!'
}
