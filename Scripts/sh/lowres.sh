ls *.jpg | bxargs 'convert -quality 1 {} {}.lowres.jpg'
