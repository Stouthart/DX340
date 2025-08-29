<!-- v6.3 - Copyright © 2025 Stouthart. All rights reserved. -->

![iBasso DX340]

# iBasso DX340 Debloating & Tweaking Playbook

This GitHub repository provides a playbook for debloating and tweaking the iBasso DX340 digital audio player. All scripts should also be compatible with the DX180, though not fully tested.

> [!IMPORTANT]
>
> 1. Download and install [Android SDK Platform-Tools] on your PC (or install via [Homebrew] on Mac)
> 2. If not already done, enable "Developer options" (Settings > About device and tap “Build number” 7 times)
> 3. Enable "USB debugging" (Settings > System > Developer options)
> 4. Make sure your device's Internet/Wi-Fi is **on**
> 5. Check the [release notes] for changes and additional options

**Contents:**

- [Debloating & Optimization]
- [Advanced Tweaking]
- [Doze & App Standby](#doze--app-standby)
- [Recovery Mode](#recovery-mode)
- [License](#license)

## Debloating & Optimization

_Remove non-essential Android apps and packages ("debloat") and optimize common settings for performance, privacy, and battery life, all without requiring rooting._

**Run the following line from a Command prompt, or Terminal window on Mac:**

```
adb shell
```

**From the DX340 prompt, run the following:**

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | sh
```

The script takes ±2 minutes to finish. Your device will reboot automatically.

> [!TIP]
>
> - Make sure to manually disable "Enhanced notifications" via Settings > Notifications (last option)
> - It is recommended to apply [Debloating & Optimization] before [Advanced Tweaking]

## Advanced Tweaking

_Tune the core behavior of the device for low-latency audio playback, by automating kernel & OS tweaks that would otherwise require manual editing of system files._

**Run the following lines from a Command prompt, or Terminal window on Mac:**

```
adb root
adb remount
adb shell
```

> [!NOTE]
>
> - Rooting is NOT required
> - "adb remount" takes ±30 seconds on 1st run, you can safely ignore any output

**From the DX340 prompt, run the following:**

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/install.sh | sh
```

Your device will reboot immediately. Enjoy the improvements!

> [!TIP]
> Follow the discussion about the iBasso DX340 digital audio player on [Head-Fi]

**Undoing/reversing is just as easy:**

```
adb root
adb remount
adb shell rm -f /etc/init/custom.rc
adb reboot
```

## Doze & App Standby

_Add 3rd-party music apps (and MangoPlayer) to the "Doze whitelist", so they won't be restricted by Android's battery-saving feature._

**Run the following line from a Command prompt, or Terminal window on Mac:**

```
adb shell
```

**From the DX340 prompt, run the following:**

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/whitelist.sh | sh
```

> [!TIP]
>
> It is recommended to (re-)apply this script after installing any third-party music apps

## Recovery Mode

**Method 1:**

- With the device powered **on**, press Power button and select "Restart"
- Immediately press Next button (above Play) and hold until the iBasso Audio logo appears
<!-- https://www.head-fi.org/threads/dx320-rohm-dac-chips-android-11-amp11mk2s-new-fw-2-07.962274/page-188#post-17009540 -->

**Method 2:**

- While the device is **off**, press and hold Next button
- Connect the USB-C charger cable
- Release button when the iBasso Audio logo appears
<!-- https://www.head-fi.org/threads/ibasso-dx300-qualcomm-snapdragon-660-octa-core-6gb-ram-new-firmware-2-00-android-11.943221/page-353#post-16285599 -->

> [!TIP]
>
> - Use the Volume wheel to navigate between items
> - Press the Power button to confirm a selection
> - It's a good habit to perform "Wipe data/factory reset" after every firmware update
> - Re-apply [Debloating & Optimization] and/or [Advanced Tweaking] after a factory reset

## License

Copyright © 2025 Stouthart. All rights reserved.

_The scripts in this repository are free for personal use. However, they are NOT published under a software license. This implies - as stated in the [GitHub Docs] - that standard copyright law applies, meaning the owner retains all rights to the source code and no one may reproduce, distribute, or create derivative works from this work._

[iBasso DX340]: https://ibasso.com/wp-content/uploads/2024/12/2024-12-24469.webp
[Android SDK Platform-Tools]: https://developer.android.com/tools/releases/platform-tools
[Homebrew]: https://formulae.brew.sh/cask/android-platform-tools
[release notes]: https://github.com/Stouthart/DX340/blob/main/RELEASE.md
[Debloating & Optimization]: #debloating--optimization
[Advanced Tweaking]: #advanced-tweaking
[Head-Fi]: https://www.head-fi.org/threads/dx340-ibasso-developed-discret-dac-easily-replaceable-batteries-amp-modules-new-firmware-on-1st-page-v1-01-local-update.974099/
[GitHub Docs]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository
