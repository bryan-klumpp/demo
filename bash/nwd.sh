ifc|grep -Eo '^(\w)*'|ug '^lo$'|bxargs 'sudo ifconfig {} down'
