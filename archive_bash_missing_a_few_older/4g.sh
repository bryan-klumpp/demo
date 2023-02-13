onlymaster | 
grep -E '(^|/)(fb/|b(644|32|50)_)' |
grep -viE '\.(wav|mp4|zip|mp3|iso|7z|deb)$' |  #note: keeping jpg, etc
sort     #helps with file copying
