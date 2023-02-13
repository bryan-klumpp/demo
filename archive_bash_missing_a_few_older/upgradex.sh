#echo 'make sure you are connected to US Cellular or Ctrl+C now'; sleep 5 || return 32; 
#/usr/bin/sudo 
#sudo apt -o Acquire::http::AllowRedirect=false dist-upgrade; /usr/bin/sudo -K
sudo apt dist-upgrade; /usr/bin/sudo -K
#test -e $(b 8064) || return 34
echo -n 'please run (copied to clipboard) ' ; 
echo -n 'brs /var/cache/apt/archives $(b 8064)' | tee >(xclip -i -selection clipboard) ; 
echo
