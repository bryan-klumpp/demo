cd /mnt/64gsd/sd
f | bxargs '! test -e /b/sd/{} && { rm -Rf {} && echo removed {}; }'
cd /b/sd &&
f | files | bxargs 'test {} -nt /mnt/64gsd/sd/{} && cp -av --parents {} /mnt/64gsd/sd'  



return
######################
mall
bakdb
brs /b/sd /mnt/64gsd/sd commit DELETE_BEFORE_CAUTION
#find /mnt/64gsd/* | bxargs 'test -w {} && chmod 555 {}'  #not needed since we're only allowing new files in tomast
#f | bxargs 'test {} -nt /mnt/64gsd/sd/{} && cp -a --parents {} /mnt/64gsd/sd && test -f /mnt/64gsd/sd/{} && chmod -w /mnt/64gsd/sd/{}'

