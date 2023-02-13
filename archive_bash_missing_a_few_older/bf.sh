find -L "$1" -print0 \
      | /b/sh/esc.sh \
      | xargs -i -r -0 sh -c ' {
	   filename={}  
           echo -n "$filename " ; stat --printf="%s " "$filename" ; echo
           
      }'
