isempty /deb/1 && { . /l/1030/mount.sh || return 89; }
sd apt-get -o Acquire::http::AllowRedirect=false install "$@"
