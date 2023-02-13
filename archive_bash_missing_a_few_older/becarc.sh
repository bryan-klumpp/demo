test -e /mnt/bec/Documents || { echo 'ERROR - please mntbec'; return 111; }
becarcd=$(b 97); newbart=$becarcd/$(btime)_becarc; lastbart=$becarcd/last
mkdir $newbart && 
rsync -a --compare-dest=$lastbart /mnt/bec/Documents $newbart &&
sudo rm -R $lastbart &&
cp -a $newbart $lastbart &&
echo 'wow it finished!'
