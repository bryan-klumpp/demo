sudo sed --in-place -r 's/ main non-free/ main/' /etc/apt/sources.list &&
sudo apt-get update
cat /etc/apt/sources.list
