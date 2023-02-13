t=$1; shift 1
parm=$(clipdef "$*")
{ test -$t "$parm" && echo "$parm"; }                              ||
{ test -$t $(underscore "$parm") && echo $(underscore "$parm"); }  ||
{       star=$(echo *"$parm"*|sort|h1)
  test -$t "$star" && echo "$star"; }                              ||
{       staru=$(echo *"$(underscore "$parm")"*|sort|h1) 
  test -$t "$staru" && echo "$(underscore "$staru")"; }            ||
find|grep -iE "$parm"                                    |sort|h1  ||
find|grep -iE  $(underscore "$parm")                     |sort|h1 