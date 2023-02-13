echo -n '' > /tmp/tomast.sh
cd /mnt/64gsd/sd &&
f | bxargs 'test -f {} && ! test -e /b/sd/{} && echo "cp $(pwd)/{} /b/sd/{}" >> /tmp/tomast.sh && echo "tomast: "{}' 
clip '. /tmp/tomast.sh'
echo 'see /tmp/tomast.sh (exec command on clipboard)'

#mall
#bakdb && brs /mnt/64gsd/sd /b
#clip 'brs /mnt/64gsd/sd /b/sd commit'
#echo 'commit sync command is on clipboard'
