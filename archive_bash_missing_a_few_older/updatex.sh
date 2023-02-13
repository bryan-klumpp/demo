#echo 'make sure you are connected to US Cellular or Ctrl+C'; sleep 5 || return 88;
#sudo ifconfig | grep '192.168.0.5' || { echo 'make sure you are connected to US Cellular'; return 88; }
#sudo apt -o Acquire::http::AllowRedirect=false update 
sudo apt update 
apt list --upgradeable
