wd="$(pwd)"
co "$wd" '^/media/b/4t' || { echo 'oops - not in valid dir'; return 34; }

function mmv1() {
  mirloc=$1; shift 1
  ### test -e "$mirloc"/backup || return #only do if this backup drive is present
  cd "$(echo -n "$wd" | sed --regexp-extended 's#^/media/b/4t/b#'"$mirloc"'/#')"        && 
  echo "attempting move in mirrored $mirloc location"                                    &&
  /bin/mv --verbose --no-clobber "$@";  #do not use mv directly as we don't want to mess with bln and extra stuff
}

mmv1 /home/b/b "$@" || return 82

cd "$wd" && { echo attempting move in original location
  mv "$@"
}
