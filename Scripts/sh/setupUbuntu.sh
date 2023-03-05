mynewhome=/b
mygeneratedlnkdir=/l
mygitusername=bryan-klumpp
mygitemail=klumpp6@gmail.com
myusername=b
myDefaultArchiveDir=/b/b22_archive
shlnk=/sh
mycodedir=${mynewhome}/b8_/code
shdir="${mycodedir}/github_demo/Scripts/sh"

set -x

test -e ~/Downloads/vscode.deb || { wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O ~/Downloads/vscode.deb &&
     sudo apt install ~/Downloads/vscode.deb &&
     echo 'NOTE if desired you will need to install gitlens manually from inside vscode: ext install eamodio.gitlens'
} &&
sudo apt install git curl chromium-browser xclip openjdk-8-jre-headless konsole kate p7zip-full &&
#TODO, ~/.local/share/kxmlgui5/konsole/sessionui.rc is where to edit konsole keyboard shortcuts etc.
git config --global user.name $mygitusername &&
git config --global user.email $mygitemail &&
test -e ${mynewhome} || { sudo mkdir /b; sudo chown ${myusername}:${myusername} ${mynewhome}; } &&
sudo chown ${myusername}:${myusername} ${mynewhome} &&
chmod 755 ${mynewhome} &&
mkdir ${mycodedir} &&
test -e "${mycodedir}/github_demo" || { git clone https://github.com/bryan-klumpp/demo ${mycodedir} github_demo; } &&
     chmod -R 755             $shdir &&
sudo chown -R ${myusername}:${myusername} $shdir &&
sudo ln -s $shdir $shlnk &&
test -e ~/.bash_aliases || { echo ". ${shlnk}/b13_.bash_aliases.sh" > ~/.bash_aliases;
                             echo "c /b"                           >> ~/.bash_aliases;
} &&
test -e ${myDefaultArchiveDir} || { sudo mkdir ${myDefaultArchiveDir}; sudo chown ${myusername}:${myusername} ${myDefaultArchiveDir}; } &&

#Sublime installation as per https://www.sublimetext.com/docs/linux_repositories.html
#note, this part of the script may prompt for gpg password(s)
sudo apt-get install sublime-text || {
     test -e /etc/apt/trusted.gpg.d/sublimehq-archive.gpg || { curl -s https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null; } &&
     echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list &&
     sudo apt-get update &&
     sudo apt-get install sublime-text
} &&

test -e /mnt || { sudo mkdir /mnt; } &&
test -e /mnt/hgfs || { sudo mkdir /mnt/hgfs; } 

#TODO https://www.golinuxcloud.com/set-up-visual-studio-code-remote-ssh-github/
