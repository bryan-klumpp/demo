lynx -dump 'https://www.google.com/search?q='$(urlencode 'world government U.S.')'&tbm=nws' | pipedisk | less -R