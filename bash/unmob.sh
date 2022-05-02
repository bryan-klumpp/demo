sleep 3
test -L /b && { echo '/b cannot be symbolic link, dangerous' ; return 111; }

brs /b /media/b/bd128 "$@"
shopt -s globstar && brs /sh /media/b/bd128/sd/b1_sh "$@"

#f | grep -iEv "$excludebig" | bxargs 'test -f {} && cp -d --preserve=all --verbose --parents {} /bmob || true'
#brs $(pwd) /bmob /l/ /big/ wav mp4 archive backup copy Moth1 Moth2 Moth3 Moth4 Moth5 Moth6 Moth7 Moth8 Moth9 "$@"
