file=$(echo -n /b/javadoc/openjdk-7/**/$1.html | sed 's!/b/javadoc/openjdk-7/!!' )
a firefox file:///b/javadoc/openjdk-7/index.html?$file ;  #file:///b/javadoc/openjdk-7/index.html?java/$1.html used to work to keep frames, not sure why not working
#a konqueror file:///b/javadoc/openjdk-7/$file ;
