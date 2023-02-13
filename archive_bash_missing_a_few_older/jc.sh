test -e $BCLASSPATH1 || { mkdir $BCLASSPATH1 && chown b $BCLASSPATH1; }
isval $1 && jfiles="$@" || 
 jfiles=/b/b/b32_/b8_/workspace/workspace1/bj/src/**/*.java
#/bin/rm -R $BCLASSPATH1/*  #DANGEROUS IF VARIABLE NOT SET
{ javac -nowarn -cp $BCLASSPATH -d $BCLASSPATH1 $jfiles 2>&1 ; javacreturn=$?; } \
  | grep --color=always -E -e 'error.*' -A 2  #|less -R #javac -Xlint:unchecked
return $javacreturn
