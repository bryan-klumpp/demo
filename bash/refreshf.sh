function refreshff() {
  test -d "$1" && find "$1" | sort --reverse > "$1"/f
  echo 'done refreshing f for '"$1"
}

refreshff /media/b/4t &
refreshff /home/b/b   &