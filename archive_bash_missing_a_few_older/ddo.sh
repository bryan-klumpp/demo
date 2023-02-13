gsettings set org.gnome.desktop.media-handling automount false
mount |grep -E "$1" && { echo 'ERROR - ALREADY MOUNTED'; return 43; exit 34; }
bbof="$1"; shift 1
#{ proc ' pv ' > /dev/null; } && { dd of="$bbof" bs=MiB "$@"; return; }  #need more sophisticated check
                             pv | dd of="$bbof" bs=MiB "$@"
