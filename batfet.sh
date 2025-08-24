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

  [ -w /etc/init ] || {
    echo 'Read-only file system. Try "adb remount" first.' >&2
    exit 1
  }

  echo '[ F_BATFET_DIS ]'

  file1=/etc/batfet.sh
  file2=/etc/init/batfet.rc

  echo "> Writing $file1..."

  cat >$file1 <<'EOF'
#!/bin/sh

[ "$(id -u)" = 0 ] || {
  echo 'Script must be run as root. Try "adb root" first.' >&2
  exit 1
}

reg=$(i2cget -f -y 4 0x6a 0x09)

_i2cset() {
  i2cset -f -y 4 0x6a 0x09 "$1" b
}

if (((reg & (1 << 5)) == 0)); then
  if (($((reg & (1 << 2))) == 0)); then
    echo 'Not USB powered.'
    exit 2
  fi
  _i2cset $((reg | (1 << 5) | (1 << 3)))
  echo 'BATFET disabled.'
else
  _i2cset $((reg & ~((1 << 5) | (1 << 3))))
  echo 'BATFET enabled.'
fi

exit 0
EOF

  chmod +x $file1

  echo "> Writing $file2..."

  cat >>$file2 <<EOF
# Device model: DX340

on property:sys.boot_completed=1
  exec -- $file1

on property:sys.powerctl=*
  exec -- /bin/sh -c "$file1; sleep 2" 
EOF

  chmod 0644 "$file2"
  chcon u:object_r:system_file:s0 "$file2"

  echo '> Done!'

  [ "${noboot:-0}" -eq 1 ] || {
    echo "> Rebooting..."
    reboot
  }
}
