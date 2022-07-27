-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum TBoolean
require("common");


local CouponDefault = {CostSilver=0,AutoUse=TBoolean.BOOL_YES,}
local Coupon= {
  [1]={BaseID=1,NameID=600001,CostGold=178,ItemInclude={250601701,},ItemNum={1,},DescID=600101,},
  [2]={BaseID=2,NameID=600002,CostGold=488,ItemInclude={250601706,},ItemNum={1,},DescID=600102,},
  [3]={BaseID=3,NameID=600003,CostGold=888,ItemInclude={250601705,},ItemNum={1,},DescID=600103,},
  [4]={BaseID=4,NameID=600004,CostGold=1388,ItemInclude={250601702,},ItemNum={1,},DescID=600104,},
  [5]={BaseID=5,NameID=600005,CostGold=300,ItemInclude={250601704,},ItemNum={1,},DescID=600105,},
  [6]={BaseID=6,NameID=600006,CostGold=800,ItemInclude={250601703,},ItemNum={1,},DescID=600106,},
  [7]={BaseID=7,NameID=600007,CostGold=28,ItemInclude={250601733,},ItemNum={1,},DescID=600107,},
  [8]={BaseID=8,NameID=600008,CostGold=98,ItemInclude={250601734,},ItemNum={1,},DescID=600108,},
  [9]={BaseID=9,NameID=600009,CostGold=188,ItemInclude={250601735,},ItemNum={1,},DescID=600109,},
  [10]={BaseID=10,NameID=600010,CostGold=288,ItemInclude={250601736,},ItemNum={1,},DescID=600110,},
  [11]={BaseID=11,NameID=600011,CostGold=588,ItemInclude={250601737,},ItemNum={1,},DescID=600111,},
  [12]={BaseID=12,NameID=600012,CostGold=888,ItemInclude={250601738,},ItemNum={1,},DescID=600112,},
  [13]={BaseID=13,NameID=600013,CostGold=1288,ItemInclude={250601739,},ItemNum={1,},DescID=600113,},
}
for k,v in pairs(Coupon) do
    setmetatable(v, {['__index'] = CouponDefault})
end

-- export table: Coupon
return Coupon
