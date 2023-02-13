cat index.html | 
  sed --regexp-extended 's#<font.*>#<h2>#'   |  
  sed --regexp-extended 's#</font>#</h2>#'   |  
  sed --regexp-extended 's#larger print##' |
  dd of=m.html