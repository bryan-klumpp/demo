{ while true; do { echo "$(date)" >> /b/tmp/keepalive.txt; sleep 55; }; done; } &
