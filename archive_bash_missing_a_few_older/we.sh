#fire 'http://forecast.weather.gov/MapClick.php?lat=41.3633&lon=-92.0512&unit=0&lg=english&FcstType=text&TextType=2'
#fox 'http://forecast.weather.gov/MapClick.php?lat=41.1196&lon=-89.7061' #castleton
fox http://weather.gov/61615
return


{ wd "http://forecast.weather.gov/MapClick.php?lat=41.3633&lon=-92.0512&unit=0&lg=english&FcstType=text&TextType=1"|g 9999 '(^|precip|accum|snow|rain|drizzle| ice|sleet)'
echo '################################################################'
echo '################################################################'
wd "http://forecast.weather.gov/MapClick.php?lat=41.1167&lon=-89.7&unit=0&lg=english&FcstType=text&TextType=1"|g 9999 '(^|precip|accum|snow|rain|drizzle| ice|freez|fog|hail|sleet)'
} | l
#wd "http://forecast.weather.gov/MapClick.php?CityName=Castleton&state=IL&site=ILX&unit=0&lg=english&FcstType=text&TextType=1"|g 9999 '(precip|accum|snow|rain|drizzle| ice|sleet)'
#?CityName=Castleton&state=IL&site=ILX
