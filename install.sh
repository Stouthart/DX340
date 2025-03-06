#!/bin/sh
{
	# v3.0, Copyright (c) 2025, Stouthart. All rights reserved.

	file=/etc/rc.local

	if ! touch $file 2>/dev/null; then
		echo 'Read-only file system. Try "adb remount" first.'
		exit 1
	fi

	echo 'Installing...'

	curl -so $file https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/rc.local
	chmod +x $file

	file=/etc/init/custom.rc
	curl -so $file https://raw.githubusercontent.com/Stouthart/DX340/refs/heads/main/custom.rc

	## https://android.stackexchange.com/questions/217495/how-can-proc-sys-values-be-changed-at-boot-sysctl-conf-does-this-on-normal-lin
	chmod 0644 $file
	chcon u:object_r:system_file:s0 $file

	# Remove system-wide tracing files, will be fixed in next firmware, confirmed by @Paul - iBasso
	rm -f /etc/init/atrace.rc /etc/init/atrace_userdebug.rc 2>/dev/null

	echo 'Rebooting...'
	reboot
}
