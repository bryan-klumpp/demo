test -e /b_local || sudo mkdir /b_local && sudo chown klumpb:klumpb /b_local
mkdir -p /b_local/setup/log
echo "$*" >> /b_local/setup/log/aptinstalled.log && {
sudo /usr/bin/apt install "$@"
}

#isempty /deb/1 && { . /l/1030/mount.sh || return 89; }
#sd apt-get -o Acquire::http::AllowRedirect=false install "$@"
