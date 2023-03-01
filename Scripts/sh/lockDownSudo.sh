files | bxargs 'sudo grep -l --silent "sudo" {} && { echo "contains sudo: "{} && sudo chown "root:b" {}; sudo chmod 750 {}; } || exit 0'
