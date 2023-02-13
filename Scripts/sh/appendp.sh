test -e "$(paste)" && ! test -L "$(paste)" && mvp "$(paste)_$(underscore "$*")"
