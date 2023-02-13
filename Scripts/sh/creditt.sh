jnl '<credit>'$(paste) $@'</credit>'
echo "$(paste)" | trim > "$(underscore $*)".url
