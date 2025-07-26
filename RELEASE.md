<!-- Copyright (C) 2025 Stouthart. All rights reserved. -->

# v5.7 - Latest

### Debloating & Optimization

- New option **nozram=1** to disable zRam (compressed block of memory in RAM used as swap device):

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nozram=1 sh
```

- This can be combined with other options, e.g.:

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nochrome=1 noplay=1 nozram=1 sh
```

### General

- Various code improvements

## v5.6

### Debloating & Optimization

- Added **google_core_control** setting, to reduce wakelocks of Google Play Services (GMS)

### General

- Default values ​​added as comments for changed settings (where applicable)
- Various code improvements

## v5.5

### Advanced Tweaking

- Instead of running the Qualcomm Connectivity SubSystem diagnostic tool at low priority, this resource-intensive service (**cnss_diag**) is now gracefully stopped at startup

### General

- Various code improvements

## v5.4

### Debloating & Optimization

- Added **com.google.android.apps.restore** (Switch) to list of disabled packages
- New option **nochrome=1** to disable Chrome as well (not done automatically since [v5.3](#v53)):

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nochrome=1 sh
```

- This can be combined with option to disable Play Services/Store (**noplay=1**, see [v4.0](#v40)):

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nochrome=1 noplay=1 sh
```

### Advanced Tweaking

- ~~Decreased priority (nice level +5) of diagnosis tool for the Qualcomm ConNectivity SubSystem (**cnss_diag**)~~
- Increased priority (from -5 to -10) of IRQ balancer (**msm_irqbalance**)

## v5.3

### Debloating & Optimization

- Changed value of **multicore_packet_scheduler** to **0** (=disabled), to prevent spurious interrupts
- Chrome is no longer disabled automatically, as it may be needed for sign-in purposes and subscription management (thanks for the feedback **pmichaelro**)

### Advanced Tweaking

- Reimplemented **vm.swappiness=10** setting (removed in [v4.1](#v41)) to reduce the kernel's tendency to move processes from physical memory to the swap disk (as a safeguard)
- Instead of stopping "logd" service - which might cause compatibility issues - logging of system messages is now reduced via a persistent property (**persist.log.tag=W**)
- Instead of stopping tracing services at runtime, these services are now disabled during installation (via properties **persist.traced.enable** and **persist.debug.perfetto.boottrace**)

### General

- All scripts should now also be compatible with DX180 (although not fully tested)
- Various code improvements

## v5.2

### Advanced Tweaking

- New "Power SAVE 🌱" option (**psave=1**) for the battery conscious. This provides most improvements while reducing battery consumption (decreases minimum scaling frequency from 1056.0MHz to 902.4MHz, applies less aggressive scheduler tuning):

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/install.sh | psave=1 sh
```

- "Scheduler tuning by Whitigir" merged with option **pmax=1** (aka "Performance MAX ✨", see [v5.0](#v50))

### General

- Moved release notes to RELEASE.md (easier to maintain)
- Various code improvements

## v5.1

### General

- Fixed a compatibility issue with Apple Music in **Advanced Tweaking** (thanks for reporting **Paul - iBasso**)
- Various code optimizations

## v5.0

### Debloating & Optimization

- Improved visibility of packages removed during debloating
- Reminder: option **nonoise=1** was introduced in [v4.5](#v45) to reduce WiFi-related noise with **AMP14** card:

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nonoise=1 sh
```

- This can be combined with option to disable Play Services/Store (**noplay=1**, see [v4.0](#v40)):

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nonoise=1 noplay=1 sh
```

### Advanced Tweaking

- New option **pmax=1** (aka "Performance MAX ✨") to get absolute maximum performance out of the DX340:

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/install.sh | pmax=1 sh
```

- Special thanks to users **quaddac** and **Whitigir** for the many hours of testing!

> [!NOTE]
>
> Option **pmax=1** replaces option **noidle=1** (deprecated). In addition to disabling "Doze & App Standby" (deviceidle), the minimum scaling frequency is increased from 1056.0 MHz to 1401.6 MHz. This may cause "Performance MAX ✨" to have an impact on battery life (although results may vary).

## v4.7

### General

- Various code optimizations

## v4.6

### General

- New: reduced debug information to the console (**printk**) in **Advanced Tweaking**
- Various code optimizations

## v4.5

### Debloating & Optimization

- New option **nonoise=1** to reduce WiFi-related noise with **AMP14** card:

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | nonoise=1 sh
```

> [!IMPORTANT]
>
> 🚸 Be careful with this option, as it may break the network connection for some apps (e.g., Apple Music, thanks for reporting **altomo**). That's why this setting is no longer enabled by default.

### Advanced Tweaking

- Reverted change of **dirty_ratio** & **dirty_background_ratio** values (from [v4.2](#v42)), due to impact on sound quality (thanks for reporting **quaddac**)
- Slightly improved boot time, by performing some tweaks in parallel/background

## v4.4

### General

- Various code optimizations

## v4.3

- Added **com.google.android.safetycore** package to **Debloating & Optimization**
- Implemented device model checks
- Various code optimizations

## v4.2

### Advanced Tweaking

- ~~Optimized **dirty_ratio** & **dirty_background_ratio** for troughput instead of latency (reduced disk I/O)~~
- ~~New option **noidle=1** to disable "Doze & App Standby" (deviceidle), similar to setting apps to "Unrestricted", but for the entire device~~

## v4.1

### General

- ~~Added **wifi_power_save** setting to **Debloating & Optimization** (reduced WiFi-related noise with **AMP14** card)~~
- ~~Removed **vm.swappiness** setting from **Advanced Tweaking** (no measurable impact)~~
- Various code optimizations

## v4.0

### Debloating & Optimization

- Optimized compilation of packages
- Removed compilation of overlays (no measurable impact)
- New option **noplay=1** to disable Play Services/Store as well:

```
curl -sS https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/debloat.sh | noplay=1 sh
```

> [!NOTE]
>
> 🔨 MangoPlayer app seems to store thumbnails of images in the cache folder. Since **Debloating & Optimization** clears all caches, it may be necessary to rescan music & media.

### Advanced Tweaking

- Moved all tweaks to a single file (/etc/init/custom.rc)
- Disabled log & trace daemons
- Optimized disk performance (**nr_requests** increased to 256 for SDA block device)
- ~~In addition to default preset (a.k.a. "ECO"), introduced "MAX by Whitigir" scheduler tuning (**stmax=1**)~~
