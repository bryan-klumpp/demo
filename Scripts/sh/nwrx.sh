procid=''; procid=$(ps aux|grep -oE '^usbmux *[0-9]*'|grep -oE '[0-9]*')
test -z $procid || sudo kill -9 $procid
sudo usbmuxd -u -U usbmux

#sudo /etc/init.d/networking restart

#nwd
#nwu
#nw
