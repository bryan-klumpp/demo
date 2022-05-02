searchpat='.'
isval $1 && { searchpat="$1"; shift 1; } 
ls -al --sort=time "$@" | grep -vE ' \.?\.$' | grep -iE "$searchpat" | 
   tac | grep -E --color=always '^[^d]|^d.*$' ##### | tail -n 25
#pwd #needed now that we are not showing full dir name in prompt
#PS1=$(echo -n "$(pwd)" | sed --regexp-extended 's#[^/]{1,}([^/]{10}(/|$))#..\1#g')'> ' 
#     #why no worky?  | sed --regexp-extended 's#(b(1024|512|256|128|64|32|16)_/){1,}#(b8_)#..b8_#g'

#--group-directories-first

#  grep -oE '^.{,110}' | #shorten to prevent wrapping
#/home/b/b/4_add/b122_grab_web_pages_fairuse_before_censorship/vaccines/+Vaccines/interesting_note_reference_to_David_and_shewbread_not_lawful
