find * \
      | grep -E '(Greed[1-9]|Moth[1-9])' \
      | sort --reverse \
      | tr '\n' '\0' \
      | esc \
      | xargs -i -r -0 sh -c '{ 
           test -f {} && rm {} && bex;
           test -d {} && rmdir {} && bex;
           echo "keeping "{}
      }'
