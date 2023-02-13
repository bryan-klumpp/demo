nwddelay=10
#echo 'should be run from separate old-fashioned terminal window; will shutdown network after '$nwddelay' minutes'
ifc|grep -Eo '^(\w)*'|bxargs 'sudo ifconfig {} up'

#for bandwidth and time management, shut down automatically after 10 minutes
a nwddelay $nwddelay
