gsettings set org.gnome.desktop.media-handling automount false
bbif="$1"; shift 1
dd if="$bbif" bs=MiB "$@"
