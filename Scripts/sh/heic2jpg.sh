#ls IMG_1166.HEIC | bxargs 'mogrify -format jpg {}'
bxargs 'heif-convert -q '$1' {} {}.jpg ; exit 0'
