find /b > /b/f

return ###############################################################3

#find -type f "$@"
#find /4 > /4/f

for mp in $(cat /l/8/setup/mountpoints.txt); do {
  sd find /b/$mp > /l/8/file_list/$mp.txt
} done


return  ##below is alternate old usage


ff1 /media/b/6 media6
return   #make it simple stupid
###############################

{

ff1 / root '/(media|mnt)/' 
for drv in $(ls /media/b); do {
  ff1 /media/b/$drv $drv
} done
for drv in $(ls /mnt); do {
  ff1 /mnt/$drv $drv /mnt/sd/50_128g   #temp omit 4t
} done
echo 'done updating find cache for use by fc'

} &    #note we can run in background if ff1 is not using pv


###############
#bupdatedb && echo 'bupdate db done; starting old ff logic with modified dates'
#a cp -a /t/f /b;   #grep -vE '/.ecryptfs/|/.cache/mozilla|/proc' 
