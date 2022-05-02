#declare -x -g BCLASSPATH1=/b/classes  #todo figure out wildcards - alternate /b/classes for command line compilation
#declare -x -g BCLASSPATH2=/b/lib/sqlite-jdbc/sqlite-jdbc-3.8.11.2.jar
#bc1=$(echo /l/10); export BCLASSPATH1=$bc1   #10=workspace bin classes dir
bc1=$(b 880); export BCLASSPATH1=$bc1   #10=workspace bin classes dir
bc2=$(b 11); export BCLASSPATH2=$bc2  #11=sqlite jar
bc=$(echo "$bc1":"$bc2"); export BCLASSPATH=$bc
echo "$bc" > /tmp/var/BCLASSPATH
