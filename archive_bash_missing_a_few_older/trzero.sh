tr '\n' '\000'
#sed --null-data s/'\r\|\n/'$'\000'/g  #howto tricky fancy finally got it working with sed and even compatible regex without using -r for extended regex