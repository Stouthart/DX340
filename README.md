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
> Make sure to manually disable "Enhanced notifications" via Settings > Notifications (last option)

## Advanced Tweaking

**Run the following lines from a Command prompt, or Terminal window on Mac:**

    adb root
    adb remount
    adb shell

> [!NOTE]
>
> - Rooting is NOT required
> - "adb remount" may take 15-30 secs on 1st run, you can safely ignore any output

**From the DX340 prompt, run:**

    curl -fs https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/tweak.sh | sh

Your device will reboot immediately.

**Undo is just as easy:**

    adb root
    adb remount
    adb shell rm -f /etc/init/custom.rc /etc/rc.local
    adb reboot

Enjoy the improvements!

> [!TIP]
>
> Follow the discussion about the iBasso DX340 on [Head-Fi]

## Recovery Mode

**Method 1:**

- With device powerd on, press Power button and select "Restart"
- Immediately press "Next" button (above Play) and hold until iBasso Audio logo appears
<!-- https://www.head-fi.org/threads/dx320-rohm-dac-chips-android-11-amp11mk2s-new-fw-2-07.962274/page-188#post-17009540 -->

**Method 2:**

- With device powerd off, press AND hold "Next" button
- Plug in USB-C charger cable
- Release button when iBasso Audio logo appears
<!-- https://www.head-fi.org/threads/ibasso-dx300-qualcomm-snapdragon-660-octa-core-6gb-ram-new-firmware-2-00-android-11.943221/page-353#post-16285599 -->

> [!TIP]
>
> - Use the Volume wheel to navigate between items
> - Press Power button to confirm a selection
> - Make sure perform a "Factory reset" after every firmware update

[iBasso DX340]: https://ibasso.com/wp-content/uploads/2024/12/2024-12-24469.webp
[Android SDK Platform-Tools]: https://developer.android.com/tools/releases/platform-tools
[Homebrew]: https://formulae.brew.sh/cask/android-platform-tools
[Head-Fi]: https://www.head-fi.org/threads/dx340-ibasso-developed-discret-dac-easily-replaceable-batteries-amp-modules-new-firmware-on-1st-page-v1-01-local-update.974099/

<!-- v2.1, Copyright (c) 2025, Stouthart. All rights reserved. -->
