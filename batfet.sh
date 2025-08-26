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

  file1=/data/adb/batfet.sh
  file2=/etc/init/batfet.rc

  echo "> Writing $file1..."

  cat >$file1 <<'EOF'
#!/bin/sh
#
# Copyright (C) 2025 Stouthart. All rights reserved.

[ -t 1 ] || {
  exec >>"${0%.*}.log" 2>&1
  echo "$(date '+%Y/%m/%d %H:%M:%S') ${1:-null}"
}

echo '[ BQ25890 ]'

BUS=4
ADR=0x6a
REG=0x09
MSK=0x20 # Bit 5

val=$(i2cget -f -y $BUS $ADR $REG)

if [ $((val & MSK)) -eq 0 ]; then
  if [ "${1:-}" ] || [ $((val & 0x04)) -eq 0 ]; then # Bit 2
    echo '> Exit due to system status or no USB power.'
    exit 2
  fi
  echo '> Disabling BATFET (Desktop mode)...'
else
  echo '> Enabling BATFET (Portable mode)...'
fi

i2cset -f -y "$BUS" "$ADR" "$REG" $((val ^ MSK)) b

echo '> Done!'
exit 0
EOF

  chmod +x $file1

  echo "> Writing $file2..."

  cat >$file2 <<EOF
# Device model: DX340
#
# Copyright (C) 2025 Stouthart. All rights reserved.

on property:sys.boot_completed=1
    start batfet

on property:sys.powerctl=*
    exec_start batfet \${sys.powerctl}

service batfet /system/bin/sh $file1
    class late_start
    oneshot
EOF

  chmod 0644 $file2
  chcon u:object_r:system_file:s0 $file2

  echo '> Done!'

  [ "${noboot:-0}" -eq 1 ] || {
    echo "> Rebooting..."
    reboot
  }
}
