-- Auto generated by TableTool, Copyright ElectronicSoul@2017


local CityWeatherDefault = {WeatherID=7,Weigth=20,}
local CityWeather= {
  [1]={BaseID=1,City=31,Month={1,2,3,4,5,6,7,8,9,10,11,12,},Weigth=1000,},
  [2]={BaseID=2,City=28,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [3]={BaseID=3,City=28,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=2,},
  [4]={BaseID=4,City=26,Month={6,7,8,9,10,},WeatherID=5,},
  [5]={BaseID=5,City=32,Month={6,7,8,9,10,},WeatherID=5,},
  [6]={BaseID=6,City=11,Month={6,7,8,9,10,},WeatherID=5,},
  [7]={BaseID=7,City=34,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=5,},
  [8]={BaseID=8,City=38,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=5,},
  [9]={BaseID=9,City=5,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=5,},
  [10]={BaseID=10,City=37,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=5,},
  [11]={BaseID=11,City=40,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=5,},
  [12]={BaseID=12,City=34,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [13]={BaseID=13,City=38,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [14]={BaseID=14,City=5,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [15]={BaseID=15,City=37,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [16]={BaseID=16,City=40,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [17]={BaseID=17,City=34,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=2,Weigth=30,},
  [18]={BaseID=18,City=34,Month={1,2,3,11,},Weigth=30,},
  [19]={BaseID=19,City=13,Month={1,2,3,4,10,11,12,},},
  [20]={BaseID=20,City=36,Month={1,2,3,4,10,11,12,},},
  [21]={BaseID=21,City=35,Month={1,2,3,4,10,11,12,},},
  [22]={BaseID=22,City=25,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=5,Weigth=25,},
  [23]={BaseID=23,City=17,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=3,},
  [24]={BaseID=24,City=17,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=2,},
  [25]={BaseID=25,City=33,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=1,Weigth=50,},
  [26]={BaseID=26,City=15,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=4,},
  [27]={BaseID=27,City=26,Month={1,},Weigth=5,},
  [28]={BaseID=28,City=26,Month={2,3,4,5,6,7,8,9,10,11,12,},Weigth=0,},
  [29]={BaseID=29,City=32,Month={1,},Weigth=5,},
  [30]={BaseID=30,City=32,Month={2,3,4,5,6,7,8,9,10,11,12,},Weigth=0,},
  [31]={BaseID=31,City=2,Month={1,2,3,4,5,6,7,8,9,10,11,12,},WeatherID=1,Weigth=50,},
}
for k,v in pairs(CityWeather) do
    setmetatable(v, {['__index'] = CityWeatherDefault})
end

-- export table: CityWeather
return CityWeather
