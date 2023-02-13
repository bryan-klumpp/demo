test -f /b/b.flag || { 
  echo 'please mount drive'
  cat ~/google/luks1 | xclip -selection clipboard
  nautilus
  . /b/sh/keepalive.sh
  }
. /b/sh/bashrc.sh
