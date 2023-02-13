#a trickle -t 0.1 -s -u 100 -d 100 chromium "$@"

/usr/bin/google-chrome --disable-gpu --disable-software-rasterizer "$@"  #chromium-browser has sandbox error = security risk
