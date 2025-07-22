scanfilename="$(underscore $*)".pdf
epsonscan2 --scan $(shpath)/EpsonScan2SettingFileADF.sf2 &&
mv ${HOME}/l/889/* "$scanfilename" &&   #yes I am assuming just one file in the directory, that directory should not be used for any other scripts or uses
o "$scanfilename"
