-- Auto generated by TableTool, Copyright ElectronicSoul@2017


local TempleDefault = {Condition=0,DispositionLimit=50,}
local Temple= {
  [1]={BaseID=1,NameID=3610001,Maps={1422,},Role=1070322001,Introduce=3620001,Price=3000,TargetCity=28,TargetClan=0,GoodEvilLimit=45,},
  [2]={BaseID=2,NameID=3610002,Maps={458,459,},Role=1130114001,Introduce=3620002,Price=5000,TargetCity=27,TargetClan=0,GoodEvilLimit=50,},
  [3]={BaseID=3,NameID=3610003,Maps={1020,},Role=1050114007,Introduce=3620003,Price=5000,TargetCity=25,TargetClan=0,GoodEvilLimit=50,},
  [4]={BaseID=4,NameID=3610004,Maps={1387,},Role=1060114005,Introduce=3620004,Price=8000,TargetCity=26,TargetClan=0,GoodEvilLimit=55,},
  [5]={BaseID=5,NameID=3610005,Maps={703,},Role=1150322003,Introduce=3620005,Price=12000,TargetCity=0,TargetClan=10,GoodEvilLimit=55,},
}
for k,v in pairs(Temple) do
    setmetatable(v, {['__index'] = TempleDefault})
end

-- export table: Temple
return Temple
