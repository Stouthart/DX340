#!/bin/sh
# shellcheck disable=SC2154
#
# v4.6, Copyright (C) 2025 Stouthart. All rights reserved.
{
  # shellcheck disable=SC3028
  [ "$HOSTNAME" = DX340 ] || {
    echo 'Your device is not compatible with this version.'
    exit 1
  }

  echo '> Debloating...'

  ## https://xdaforums.com/t/cmd-package-install-existing-user-user-package-vs-pm-install-existing-user-user-package.4553257/

  # Apps
  cmd package uninstall --user 0 cm.aptoide.pt
  cmd package uninstall --user 0 com.android.calculator2
  cmd package uninstall --user 0 com.android.deskclock
  cmd package uninstall --user 0 com.android.gallery3d
  cmd package uninstall --user 0 com.wandoujia.phoenix2

  # Google
  cmd package disable-user --user 0 com.android.chrome
  cmd package uninstall --user 0 com.google.android.inputmethod.latin
  cmd package disable-user --user 0 com.google.android.partnersetup

  ## https://9to5google.com/2024/11/25/november-2024-google-system-updates/
  cmd package list packages | LC_ALL=C grep -Fq 'com.google.android.safetycore' && {
    cmd package uninstall --user 0 com.google.android.safetycore
  }

  [ "$noplay" = 1 ] && {
    cmd package disable-user --user 0 com.android.vending
    cmd package disable-user --user 0 com.google.android.gms
  }

  # Debloat other (only running packages)
  cmd package uninstall --user 0 com.android.managedprovisioning
  cmd package uninstall --user 0 com.android.musicfx
  cmd package uninstall --user 0 com.android.remoteprovisioner
  cmd package uninstall --user 0 com.android.traceur
  cmd package uninstall --user 0 com.google.android.onetimeinitializer
  cmd package uninstall --user 0 com.google.android.syncadapters.calendar

  ## https://forum.fairphone.com/t/telemetry-spyware-list-of-privacy-threats-on-fp3-android-9/55179
  cmd package uninstall --user 0 com.qualcomm.qti.qms.service.connectionsecurity

  ## https://android.stackexchange.com/questions/215313/how-to-reinstall-an-uninstalled-system-app-through-adb/215316#215316
  # cmd package install-existing com.android.gallery3d
  # cmd package enable com.google.android.gms && cmd package enable com.android.vending

  echo '> Optimizing settings...'

  ## https://www.reddit.com/r/tasker/comments/fbi5ai/psa_you_can_use_adb_to_find_all_the_settings_that/
  ## https://github.com/ionuttbara/melody_android
  ## https://technastic.com/adb-commands-improve-performance-android/

  # Global settings
  settings put global fstrim_mandatory_interval 1
  settings put global mobile_data_always_on 0
  settings put global mobile_signal_detector 0
  settings put global ota_disable_automatic_update 1
  settings put global wifi_networks_available_notification_on 0

  [ "$nonoise" = 1 ] && {
    # Default value: 120
    settings put global wifi_power_save 1
  }

  # Remove animations
  settings put global animator_duration_scale 0.0
  settings put global transition_animation_scale 0.0
  settings put global window_animation_scale 0.0

  # Secure settings
  settings put secure location_mode 0
  settings put secure notification_bubbles 0
  settings put secure ui_night_mode 2

  # System settings
  settings put system multicore_packet_scheduler 1
  settings put system screen_brightness 81
  settings put system screen_off_timeout 15000

  echo '> Compiling packages...'

  ## https://source.android.com/docs/core/runtime/configure#compiler_filters
  cmd package compile -a -m speed-profile
  cmd package bg-dexopt-job

  ## https://www.reddit.com/r/AndroidQuestions/comments/s1vk4z/does_anyone_know_how_to_clear_all_app_caches_at/
  cmd package trim-caches 256G

  echo '> Rebooting...'
  reboot
}
