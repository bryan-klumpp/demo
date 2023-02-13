brm /t/nomoney
bmkdir /t/nomoney
cp "$@" /t/nomoney
sed -i 's/\$[0-9]*//g' /t/nomoney/*
7z a -r -tzip /t/nomoney/$(bdate)_Bryan_files_cumulative.zip /t/nomoney/*