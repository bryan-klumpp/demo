cat /etc/apt/sources.list|grep non-free && { echo 'already non-free'; return;  }
sudo sed --in-place -r 's/ main/ main non-free/' /etc/apt/sources.list &&
  sudo apt-get update
