co $1 'usb-' || { echo 'use by-id; and only works on USBdevice'; return 32; }
sd badblocks -svw -t 0x00 "$1"