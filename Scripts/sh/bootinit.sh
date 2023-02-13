#set -x

#	rm -R /tmp/* || { echo 'failed to blow away /tmp'; }
#        sudo mount -t tmpfs arbitrary /ram -o size=32M,mode=777 && 
echo -n '' > /ram/.bash_history
echo init_run > /ram/t.flag; mkdir /ram/filenamefindcache; mkdir /ram/var; 
bredshift
echo WHY IS INIT BEING CALLED????????????????

#sudo swapoff -a  #probably caused a crash recently
#        mall
        # ifc|grep -Eo '^w\w*'| bxargs 'sudo ifconfig {} down'   #shut down wireless
	#test -e /dev/disk/by-label/CARAUDIO && { sudo mount /dev/disk/by-label/CARAUDIO /mnt/caraudio && cp /mnt/caraudio/google /ram && echo 'copied to /ram/google' && sudo umount /mnt/caraudio; }
	# cat /media/b/bd128/Secure9/b4_google_Secure9/x1 > /ram/google
        #echo -n 'type password for /ram/google: '; dd 2>/dev/null | trim >> /ram/google
	#nano /ram/google2
bbg  #should invoke bredshift but seems to be failing to register anything permanently
        #cp -a $(b 19)/*txt /ram/filenamefindcache & disown;    #async launch copy filename cache to RAM
