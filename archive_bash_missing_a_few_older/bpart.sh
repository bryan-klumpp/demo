return
#######################3

--align optimal

echo 'see script file edit'; return
b@h:~$ sudo parted /dev/sdb
GNU Parted 3.2
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) unit MiB                                                         
(parted) mkpart primary 256 14847
(parted) mkpart primary 14848 29183
(parted) mkpart primary 29184 458751
(parted) mkpart primary 458752 983039
(parted) mkpart primary 983040 2752511
(parted) unit GB
(parted) print
Model: Toshiba External USB 3.0 (scsi)
Disk /dev/sdb: 3001GB
Sector size (logical/physical): 4096B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name     Flags
 1      0.27GB  15.6GB  15.3GB               primary
 2      15.6GB  30.6GB  15.0GB               primary
 3      30.6GB  481GB   450GB                primary
 4      481GB   1031GB  550GB                primary
 5      1031GB  2886GB  1855GB               primary

(parted)

