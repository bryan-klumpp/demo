#bxargs 'echo {}'
files | bxargs 'sudo grep -v -L --silent "sudo" {} && { echo "does not contain sudo: "{}; sudo chown "root:b" {}; sudo chmod 770 {}; } || exit 0'
