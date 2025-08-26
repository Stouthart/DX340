#!/bin/sh
#
# Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  case "$HOSTNAME" in
  DX340) ;;
  *)
    echo 'Your device is not compatible with this version.' >&2
    exit 1
    ;;
  esac

  [ -w /etc/init ] || {
    echo 'Read-only file system. Try "adb remount" first.' >&2
    exit 1
  }

  echo '[ BATFET_DIS ]'

  file1=/data/adb/bq25890.sh
  file2=/etc/init/bq25890.rc

  echo "> Writing $file1..."

  cat >$file1 <<'EOF'
#!/bin/sh
#
# Copyright (C) 2025 Stouthart. All rights reserved.

[ -t 1 ] || {
  exec >>"${0%.sh}.log" 2>&1
  printf '%s ' "$(date '+%Y/%m/%d %H:%M:%S')"
}

BUS=4
ADR=0x6a
REG=0x09
MSK=0x20 # bit 5

_i2cset() {
  i2cset -f -y "$BUS" "$ADR" "$REG" "$1" b
}

val=$(i2cget -f -y $BUS $ADR $REG)

case $1 in
disable)
  # Check bit 2
  [ "$(cat /sys/class/power_supply/bq25890/voltage_now)" -lt 300000000 ] && {
    _i2cset $((val & ~MSK))
    echo 'Insufficient power'
    exit 1
  }
  _i2cset $((val | MSK))
  echo 'Desktop mode (BATFET disabled)'
  ;;
enable)
  _i2cset $((val & ~MSK))
  echo 'Portable mode (BATFET enabled)'
  ;;
*)
  echo "Usage: ${0##*/} disable|enable"
  exit 1
  ;;
esac
EOF

  chmod +x $file1

  echo "> Writing $file2..."

  cat >$file2 <<EOF
# Device model: DX340
#
# Copyright (C) 2025 Stouthart. All rights reserved.

service bq25890_disable $SHELL $file1 disable
    class late_start
    user root
    oneshot
    disabled

on property:sys.boot_completed=1
    start bq25890_disable

service bq25890_enable $SHELL $file1 enable
    class core
    user root
    oneshot
    disabled

on property:sys.powerctl=*
    start bq25890_enable
EOF

  chmod 0644 $file2
  chcon u:object_r:system_file:s0 $file2

  echo '> Done!'

  [ "${noboot:-0}" -eq 1 ] || {
    echo "> Rebooting..."
    reboot
  }
}
