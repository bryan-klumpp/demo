find | ug 'b322_.*(ogg|mp3|wav)|devices.*bigpatch' |
    bxargs 'test -f {} && cp --no-clobber --parents {} '$imgd' || true'
