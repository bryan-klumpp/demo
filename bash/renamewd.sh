wd="$(pwd)"
newname=$(underscore $*)
cd ..
mv "$wd" "$newname"
c "$newname"
