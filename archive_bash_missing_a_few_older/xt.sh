findroot=/b/sh
find -L "$findroot" -print0 \
      | grep -viE --null-data -f /b/text_search_patterns_to_exclude_extended.txt \
      | /b/sh/esc.sh \
      | xargs -i -r -0 sh -c ' {
	   echo processing "{}"
      }'
