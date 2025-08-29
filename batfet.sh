#!/bin/sh
#
# Copyright © 2025 Stouthart. All rights reserved.

[ -t 1 ] || {
  exec >>"${0%.sh}.log" 2>&1
  date '+%Y/%m/%d %H:%M:%S'
}

# bq24192
A_BUS=3
A_ADR=0x6b
A_REG=0x07

# bq25890
D_BUS=4
D_ADR=0x6a
D_REG=0x09

MSK=32 # bit 5

_status() {
  printf "%-17s: BATFET %s\n" "$1" "$([ $(($2 & MSK)) -eq 0 ] && echo enabled || echo disabled)"
}

bq24192() {
  i2cset -f -y $A_BUS $A_ADR $A_REG "$1" b
}

bq25890() {
  i2cset -f -y $D_BUS $D_ADR $D_REG "$1" b
}

A_VAL=$(i2cget -f -y $A_BUS $A_ADR $A_REG)
D_VAL=$(i2cget -f -y $D_BUS $D_ADR $D_REG)

case $1 in
disable)
  case $(($(i2cget -f -y $D_BUS $D_ADR 0x0B) >> 5 & 0x07)) in
  2 | 3 | 4) ;; # USB CDP (1.5A) | USB DCP (3.25A) | Adjustable High Voltage DCP (MaxCharge)
  *)
    echo 'No USB charger detected' >&2
    exit 2
    ;;
  esac

  bq25890 $((D_VAL | MSK))
  bq24192 $((A_VAL | MSK))
  echo 'Desktop mode (BATFET disabled)'
  ;;
enable)
  bq24192 $((A_VAL & ~MSK))
  bq25890 $((D_VAL & ~MSK))
  echo 'Portable mode (BATFET enabled)'
  ;;
status)
  _status "bq24192 (analog)" "$A_VAL"
  _status "bq25890 (digital)" "$D_VAL"
  ;;
*)
  echo "Usage: ${0##*/} disable|enable|status" >&2
  exit 2
  ;;
esac

## https://www.ti.com/lit/ds/symlink/bq24192.pdf
## https://www.ti.com/lit/ds/symlink/bq25890.pdf
