#!/bin/sh
# shellcheck disable=SC2154
#
# v5.4, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC2166,SC3028
  [ "$HOSTNAME" = DX340 -o "$HOSTNAME" = DX180 ] || {
    echo '🚸 Your device is not compatible with this version.'
    exit 1
  }

  echo '[ Debloating & Optimization ]'
  echo '🌱 Debloating...'

  _uninstall() {
    # shellcheck disable=SC3037
    echo -n "${1}: "
    cmd package uninstall --user 0 "$1"
  }

  # Apps
  _uninstall cm.aptoide.pt
  _uninstall com.android.calculator2
  _uninstall com.android.deskclock
  _uninstall com.android.gallery3d
  _uninstall com.wandoujia.phoenix2
  # cmd package install-existing --user 0 com.android.gallery3d

  # Google
  cmd package disable-user --user 0 com.google.android.apps.restore # Switch - added by GMS
  _uninstall com.google.android.inputmethod.latin
  cmd package disable-user --user 0 com.google.android.partnersetup
  _uninstall com.google.android.safetycore # Added by GMS

  [ "$nochrome" -eq 1 ] && cmd package disable-user --user 0 com.android.chrome

  [ "$noplay" -eq 1 ] && {
    cmd package disable-user --user 0 com.android.vending
    cmd package disable-user --user 0 com.google.android.gms
    # cmd package enable --user 0 com.google.android.gms && cmd package enable --user 0 com.android.vending
  }

  # Debloat other (only running packages)
  _uninstall com.android.managedprovisioning
  _uninstall com.android.musicfx
  _uninstall com.android.remoteprovisioner
  _uninstall com.android.traceur
  _uninstall com.google.android.onetimeinitializer
  _uninstall com.google.android.syncadapters.calendar

  ## https://forum.fairphone.com/t/telemetry-spyware-list-of-privacy-threats-on-fp3-android-9/55179
  _uninstall com.qualcomm.qti.qms.service.connectionsecurity

  echo '🌱 Optimizing settings...'

  # Global settings
  settings put global mobile_data_always_on 0
  settings put global mobile_signal_detector 0
  settings put global ota_disable_automatic_update 1
  settings put global wifi_networks_available_notification_on 0

  [ "$nonoise" -eq 1 ] && settings put global wifi_power_save 1 # Default 120

  # Remove animations
  settings put global animator_duration_scale 0
  settings put global transition_animation_scale 0
  settings put global window_animation_scale 0

  # Secure settings
  settings put secure location_mode 0
  settings put secure notification_bubbles 0
  settings put secure ui_night_mode 2

  # System settings
  settings put system multicore_packet_scheduler 0 # Prevent spurious interrupts
  settings put system screen_brightness 81
  settings put system screen_off_timeout 15000

  echo '🌱 Compiling packages...'

  ## https://source.android.com/docs/core/runtime/configure#compiler_filters
  cmd package compile -a -m speed-profile

  echo '🌱 Trimming caches...'
  cmd package trim-caches 999G

  echo '✨ Done'

  echo '🔨 Rebooting...'
  reboot
}
