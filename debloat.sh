#!/bin/sh
#
# v6.1b, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  case "$HOSTNAME" in
  DX340 | DX180) ;;
  *)
    echo 'Your device is not compatible with this version.' >&2
    exit 1
    ;;
  esac

  echo '[ Debloating & Optimization ]'

  _uninst() {
    printf '%s: ' "$1"
    cmd package uninstall --user 0 "$1"
  }

  echo '> Removing preinstalled apps...'

  _uninst cm.aptoide.pt           # Aptoide (app store)
  _uninst com.android.calculator2 # Calculator
  _uninst com.android.deskclock   # Clock
  _uninst com.android.gallery3d   # Gallery
  _uninst com.wandoujia.phoenix2  # Wandoujia (Chinese app store)
  # cmd package install-existing --user 0 com.android.gallery3d

  echo '> Removing/disabling Google apps...'

  cmd package disable-user --user 0 com.google.android.apps.restore # Switch (Added by GMS)
  _uninst com.google.android.inputmethod.latin                      # Google Keyboard
  cmd package disable-user --user 0 com.google.android.partnersetup # Google Partner Setup
  _uninst com.google.android.safetycore                             # (Added by GMS)

  [ "${nochrome:-0}" -eq 1 ] && {
    echo '> Disabling Chrome...'
    cmd package disable-user --user 0 com.android.chrome
  }

  [ "${noplay:-0}" -eq 1 ] && {
    echo '> Disabling Play services/store...'
    cmd package disable-user --user 0 com.android.vending
    cmd package disable-user --user 0 com.google.android.gms
    # cmd package enable --user 0 com.google.android.gms && cmd package enable --user 0 com.android.vending
  }

  echo '> Removing other packages...'

  _uninst com.android.managedprovisioning
  _uninst com.android.musicfx # Firmware < v1.04.440
  _uninst com.android.remoteprovisioner
  _uninst com.android.traceur # System Tracing
  _uninst com.google.android.onetimeinitializer
  _uninst com.google.android.syncadapters.calendar

  ## https://forum.fairphone.com/t/telemetry-spyware-list-of-privacy-threats-on-fp3-android-9/55179
  _uninst com.qualcomm.qti.qms.service.connectionsecurity

  echo '> Optimizing settings...'

  # Global settings
  settings put global google_core_control 0                     # null (Reduce GMS wakelocks)
  settings put global mobile_data_always_on 0                   # 1
  settings put global mobile_signal_detector 0                  # 1
  settings put global wifi_networks_available_notification_on 0 # 1

  [ "${nonoise:-0}" -eq 1 ] && sec=1 || sec=120
  settings put global wifi_power_save "$sec"

  # Remove animations
  settings put global animator_duration_scale 0    # null
  settings put global transition_animation_scale 0 # 1.0
  settings put global window_animation_scale 0     # 1.0

  # Secure settings
  settings put secure location_mode 0        # 3
  settings put secure notification_bubbles 0 # 1
  settings put secure ui_night_mode 2        # null

  # System settings
  settings put system screen_brightness 81     # 102
  settings put system screen_off_timeout 15000 # 60000

  # Security & privacy
  settings put global activity_starts_logging_enabled 0 # 1
  settings put global app_install_optimise_enabled 0    # null
  settings put global bug_report 0                      # 1
  settings put global multi_cb 0                        # 2 (Usage & diagnostics)
  settings put secure send_action_app_error 0           # 1
  settings put system send_security_reports 0           # null

  echo '> Compiling packages...'

  ## https://source.android.com/docs/core/runtime/configure#compiler_filters
  cmd package compile -a -m speed-profile

  echo '> Trimming caches...'
  cmd package trim-caches 999G

  echo '> Done!'

  echo "> Rebooting..."
  reboot
}
