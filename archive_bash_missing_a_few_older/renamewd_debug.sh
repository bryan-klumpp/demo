echo 'see log in script - buggy with links'
return



log:
b@pc:/l/2274$ pwd
/media/b/a933121a-597f-4272-903e-cbedf53847cb/30_32g/b100_stuff/b204_W_wire_shelves/b2274_tote_15qt_homo_bulk_underwear_undershirts_socks
b@pc:/l/2274$ renamewd b2274_lots_of_extra_stuff_TODO_major_inventory
created directory 'b2274_lots_of_extra_stuff_TODO_major_inventory'
created directory 'b2274_lots_of_extra_stuff_TODO_major_inventory/solar-powered_flashlight'
removed directory '/media/b/a933121a-597f-4272-903e-cbedf53847cb/30_32g/b100_stuff/b204_W_wire_shelves/b2274_tote_15qt_homo_bulk_underwear_undershirts_socks/solar-powered_flashlight'
removed directory '/media/b/a933121a-597f-4272-903e-cbedf53847cb/30_32g/b100_stuff/b204_W_wire_shelves/b2274_tote_15qt_homo_bulk_underwear_undershirts_socks'
b2274_lots_of_extra_stuff_TODO_major_inventory
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ b 2274
/l/b2274_lots_of_extra_stuff_TODO_major_inventory
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ esh renamewd
trying to copy
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ esh renamewd
trying to copy
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ c 2274
drwxr-xr-x 2 b b    4096 May  4 20:28 solar-powered_flashlight
total 12
b@pc:/l/2274$ d
drwxr-xr-x 2 b b    4096 May  4 20:28 solar-powered_flashlight
total 12
b@pc:/l/2274$ cd ../b2274*
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ cd ..
b@pc:/l$ cd ../b2274*
bash: cd: ../b2274*: No such file or directory
b@pc:/l$ cd ./b2274*
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ n
b@pc:/l/b2274_lots_of_extra_stuff_TODO_major_inventory$ 



wd="$(pwd)"
newname="$(underscore "$*")"
cd ..
mv "$wd" "$newname"
cd "$newname"
