web http://lite.cnn.io/en ; return

#alarm 5 || return 10
isval "$*" && cats=$@ || { fox 'https://news.google.com'; return; }
#t news'#'"$cats"
#blynx 'https://www.google.com/search?q='$(urlencode "$cats")'&tbm=nws' ; return
#lynx -dump -dont_wrap_pre 'https://www.google.com/search?q='$(urlencode "$cats")'&tbm=nws' > /t/news.html && less -r /t/news.html
fox 'https://www.google.com/search?q='$(urlencode "$cats")'&tbm=nws'
#wd news.google.com || return 40
