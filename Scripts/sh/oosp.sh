receipt $oosp "$@"

return ####################################


oospdir=$(bdate)_outofstatepurchase_"$(underscore "$*")"
md "$oospdir"
grabcheese
