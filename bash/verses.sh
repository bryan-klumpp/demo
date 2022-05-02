firsti=tru
grpsep='------------------------------------------------------------------'

for verse; do {

#is firsti tru && { firsti=fals; } || echo $grpsep  #broke?
echo $grpsep #just include first separator at top keep it simple
#sed removes incorrect line duplicates with no verse prefix
diatheke -b KJV -o n -k $verse | sed --null-data 's/\n:.*/\n/'

} done
