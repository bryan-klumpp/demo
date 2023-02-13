dpkg --print-architecture | grep 386 && return
dpkg --print-foreign-architectures | grep 386 && return
sudo dpkg --add-architecture i386
sudo apt update || echo { 'update failure'; return 92; }
sudo apt install wine wine32 wine64 libwine libwine:i386 fonts-wine  #Greed on fonts-wine?
