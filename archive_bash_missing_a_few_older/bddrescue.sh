safename=$(echo -n $1 | tr / _)
sudo ddrescue $1 "$safename".img "$safename".gddrescue.log
