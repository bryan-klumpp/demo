find "$(b 100)" | g "$@"; return; ##################3

cd $(b 3)/dated
ts "[#<]stuff" | g "$*"

isint $1 && whereis $1 || {
	isval $1 || { sql "select * from b"; return; }
	sql "select * from b" | g "$*"
}  #j borg

find "$(can "$(b 100)")" | g "$*"
