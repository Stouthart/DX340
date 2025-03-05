![iBasso DX340]

# iBasso DX340 Debloating & Tweaking Guide

> [!IMPORTANT]
>
> - Download and install [Android SDK Platform-Tools], or via [Homebrew] for Mac
> - Make sure your device has WiFi turned on
> - Enable USB debugging (Developer options)

## Debloating & Optimization

**Run the following line from a Command prompt, or Terminal window on Mac:**

    adb shell

**From the DX340 prompt, run:**

    curl -fs https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | sh

It will take 1-2 mins to finish. Your device will reboot automatically.

> [!TIP]
>
> Make sure to manually disable Enhanced notifications via Settings > Notifications

## Advanced Tweaking

**Run the following lines from a Command prompt, or Terminal window on Mac:**

    adb root
    adb remount
    adb shell

> [!NOTE]
>
> - Rooting is NOT required
> - adb remount may take 15-30 secs on 1st run, you can safely ignore any output

**From the DX340 prompt, run:**

    curl -fs https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/tweak.sh | sh

Your device will reboot immediately.

**Undo is just as easy:**

    adb root
    adb remount
    adb shell rm -f /etc/init/custom.rc /etc/rc.local
    adb reboot

Follow the discussion on [Head-Fi]. Enjoy the music!

[iBasso DX340]: https://ibasso.com/wp-content/uploads/2024/12/2024-12-24469.webp
[Android SDK Platform-Tools]: https://developer.android.com/tools/releases/platform-tools
[Homebrew]: https://formulae.brew.sh/cask/android-platform-tools
[Head-Fi]: https://www.head-fi.org/threads/dx340-ibasso-developed-discret-dac-easily-replaceable-batteries-amp-modules-new-firmware-on-1st-page-v1-01-local-update.974099/

<!-- v2.0, Copyright (c) 2025, Stouthart. All rights reserved. -->
