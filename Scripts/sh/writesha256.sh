tfn="$(underscore "$*")"
tee >(sha256sum - | grep -E '^[A-Za-z0-9]*' > /tmp/writesha256) "$tfn" > /dev/null || return 45
mv "$tfn" sha256_$(cat /tmp/writesha256)_"$tfn"
