#!/bin/sh
#
# Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  [ "$HOSTNAME" = "DX340" ] || {
    echo 'Your device is not compatible with this version.' >&2
    exit 1
  }

  [ -w /etc/init ] || {
    echo 'Read-only file system. Try "adb remount" first.' >&2
    exit 1
  }

  echo '[ BATFET_DIS ]'

  file1=/data/adb/batfet.sh
  file2=/etc/init/batfet.rc

  echo "> Writing $file1..."

  cat >$file1 <<'EOF'
#!/bin/sh
#
# Copyright (C) 2025 Stouthart. All rights reserved.

[ -t 1 ] || {
  exec >>"${0%.sh}.log" 2>&1
  date '+%Y/%m/%d %H:%M:%S'
}

A_BUS=3
A_ADR=0x6b
A_REG=0x07

D_BUS=4
D_ADR=0x6a
D_REG=0x09

MSK=0x20 # bit 5

bq24192() {
  i2cset -f -y "$A_BUS" "$A_ADR" "$A_REG" "$1" b
}

bq25890() {
  i2cset -f -y "$D_BUS" "$D_ADR" "$D_REG" "$1" b
}

A_VAL=$(i2cget -f -y $A_BUS $A_ADR $A_REG)
D_VAL=$(i2cget -f -y $D_BUS $D_ADR $D_REG)

case $1 in
disable)
  case $(($(i2cget -f -y $D_BUS $D_ADR 0x0B) >> 5 & 0x07)) in
  2 | 3 | 4) ;;
  *)
    echo 'No USB charger detected'
    exit 2
    ;;
  esac

  bq25890 $((D_VAL | MSK))
  bq24192 $((A_VAL | MSK))
  echo 'Desktop mode (BATFET disabled)'
  ;;
reset)
  bq24192 $((A_VAL & ~MSK))
  bq25890 $((D_VAL & ~MSK))
  echo 'Portable mode (BATFET resetted)'
  ;;
*)
  echo "Usage: ${0##*/} disable|reset"
  exit 1
  ;;
esac

## https://www.ti.com/lit/ds/symlink/bq24192.pdf
## https://www.ti.com/lit/ds/symlink/bq25890.pdf
EOF

  chmod +x $file1

  echo "> Writing $file2..."

  cat >$file2 <<EOF
# Device model: DX340
#
# Copyright (C) 2025 Stouthart. All rights reserved.

on property:sys.boot_completed=1
  exec_background -- $file1 disable

on shutdown
  exec -- $file1 reset
EOF

  chmod 0644 $file2
  chcon u:object_r:system_file:s0 $file2

  echo '> Done!'

  [ "${noboot:-0}" -eq 1 ] || {
    echo "> Rebooting..."
    reboot
  }
}
