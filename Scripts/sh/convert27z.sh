gzip -cd 200GB_microSD_factory_format_zero_files.img.gz|tee >(md5sum - > 200GB.md5) | 7z a -si 200GB-3.img.7z
