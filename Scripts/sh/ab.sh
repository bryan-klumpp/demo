abdir="$(b 6)"
c $abdir
#timetrack spirit:bible:audio /usr/bin/vlc $(find -L "$abdir"|grep mp3|sort --sort=random|head -n 15) &
a /usr/bin/vlc $(find -L "$abdir"|grep mp3|sort --sort=random|head -n 15)


