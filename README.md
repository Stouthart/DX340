<!-- Copyright (C) 2025 Stouthart. All rights reserved. -->

![iBasso DX340]

# iBasso DX340 Debloating & Tweaking Playbook

[v5.1 - Latest 🌱](https://github.com/Stouthart/DX340/blob/main/RELEASE.md)

> [!IMPORTANT]
>
> 1. Download and install [Android SDK Platform-Tools] (or install via [Homebrew] on Mac)
> 2. Make sure your device's WiFi is **on**
> 3. Enable "USB debugging" (Settings > System > Developer options)

**Contents:**

- [Debloating & Optimization]
- [Advanced Tweaking]
- [Recovery Mode](#recovery-mode)
- [License](#license)

## Debloating & Optimization

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
>
> - Check the [release notes] for changes and additional options
> - Follow the discussion about the iBasso DX340 on [Head-Fi]

**Undo is just as easy:**

```
adb root
adb remount
adb shell rm -f /etc/init/custom.rc
adb reboot
```

## Recovery Mode

**Method 1:**

- With device powered **on**, press Power button and select "Restart"
- Immediately press Next button (above Play) & hold until the iBasso Audio logo appears
<!-- https://www.head-fi.org/threads/dx320-rohm-dac-chips-android-11-amp11mk2s-new-fw-2-07.962274/page-188#post-17009540 -->

**Method 2:**

- While the device is **off**, press & hold Next button
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

Copyright (C) 2025 Stouthart. All rights reserved.

The software in this repository is free for personal use. However, it is NOT published under a software license. This implies - as stated in the [GitHub Docs] - that default copyright laws apply, meaning that the owner retains all rights to the source code and no one may reproduce, distribute, or create derivative works from this work.

[iBasso DX340]: https://ibasso.com/wp-content/uploads/2024/12/2024-12-24469.webp
[Android SDK Platform-Tools]: https://developer.android.com/tools/releases/platform-tools
[Homebrew]: https://formulae.brew.sh/cask/android-platform-tools
[Debloating & Optimization]: #debloating--optimization
[Advanced Tweaking]: #advanced-tweaking
[release notes]: https://github.com/Stouthart/DX340/blob/main/RELEASE.md
[Head-Fi]: https://www.head-fi.org/threads/dx340-ibasso-developed-discret-dac-easily-replaceable-batteries-amp-modules-new-firmware-on-1st-page-v1-01-local-update.974099/
[GitHub Docs]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository
