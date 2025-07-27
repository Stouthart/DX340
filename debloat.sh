#!/bin/sh
# shellcheck disable=SC2154
#
# v6.0b, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC2166,SC3028
  [ "$HOSTNAME" = DX340 -o "$HOSTNAME" = DX180 ] || {
    echo '🚸 Your device is not compatible with this version.'
    exit 1
  }

  echo '[ Debloating & Optimization ]'
  echo '🌱 Debloating...'

  _uninst() {
    # shellcheck disable=SC3037
    echo -n "${1}: "
    cmd package uninstall --user 0 "$1"
  }

  # Apps
  _uninst cm.aptoide.pt
  _uninst com.android.calculator2
  _uninst com.android.deskclock
  _uninst com.android.gallery3d
  _uninst com.wandoujia.phoenix2
  # cmd package install-existing --user 0 com.android.gallery3d

  # Google
  cmd package disable-user --user 0 com.google.android.apps.restore # Switch (Added by GMS)
  _uninst com.google.android.inputmethod.latin
  cmd package disable-user --user 0 com.google.android.partnersetup
  _uninst com.google.android.safetycore # (Added by GMS)

  [ "$nochrome" -eq 1 ] && cmd package disable-user --user 0 com.android.chrome

  [ "$noplay" -eq 1 ] && {
    cmd package disable-user --user 0 com.android.vending
    cmd package disable-user --user 0 com.google.android.gms
    # cmd package enable --user 0 com.google.android.gms && cmd package enable --user 0 com.android.vending
  }

  # Debloat other (only running packages)
  _uninst com.android.managedprovisioning
  _uninst com.android.musicfx # Firmware < v1.04.440
  _uninst com.android.remoteprovisioner
  _uninst com.android.traceur
  _uninst com.google.android.onetimeinitializer
  _uninst com.google.android.syncadapters.calendar

  ## https://forum.fairphone.com/t/telemetry-spyware-list-of-privacy-threats-on-fp3-android-9/55179
  _uninst com.qualcomm.qti.qms.service.connectionsecurity

  echo '🌱 Optimizing settings...'

  # Global settings
  settings put global bug_report 0                              # 1
  settings put global data_roaming 0                            # 1
  settings put global google_core_control 0                     # null (Reduce GMS wakelocks)
  settings put global mobile_data_always_on 0                   # 1
  settings put global mobile_signal_detector 0                  # 1
  settings put global multi_cb 0                                # 2 (Usage & diagnostics)
  settings put global wifi_networks_available_notification_on 0 # 1

  [ "$nonoise" -eq 1 ] && settings put global wifi_power_save 1 # 120

  if [ "$nozram" -eq 1 ]; then
    settings put global zram_enabled 0
    setprop persist.sys.zram_enabled 0
  else
    settings put global zram_enabled 1
    setprop persist.sys.zram_enabled 1
  fi

  # Remove animations
  settings put global animator_duration_scale 0    # null
  settings put global remove_animations 1          # 0
  settings put global transition_animation_scale 0 # 1.0
  settings put global window_animation_scale 0     # 1.0

  # Secure settings
  settings put secure location_mode 0         # 3
  settings put secure notification_bubbles 0  # 1
  settings put secure send_action_app_error 0 # 1
  settings put secure ui_night_mode 2         # null

  # System settings
  settings put system screen_brightness 81     # 102
  settings put system screen_off_timeout 15000 # 60000

  echo '🌱 Compiling packages...'

  ## https://source.android.com/docs/core/runtime/configure#compiler_filters
  cmd package compile -a -m speed-profile

  echo '🌱 Trimming caches...'
  cmd package trim-caches 999G

  echo '✨ Done'

  echo '🔨 Rebooting...'
  reboot
}
