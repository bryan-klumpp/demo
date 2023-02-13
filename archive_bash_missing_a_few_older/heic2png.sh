#ls IMG_1166.HEIC | bxargs 'mogrify -format jpg {}'
bxargs 'heif-convert {} {}.png ; exit 0'
