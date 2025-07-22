val={}; num=$(echo {} | sed --regexp-extended "s@.*/b([0-9]*)_.*@\1@g"); 
test -e ${HOME}/l/$num && { echo 'duplicate bln: '$num; exit 88; }
ln -s {} ${HOME}/l/$num; 




