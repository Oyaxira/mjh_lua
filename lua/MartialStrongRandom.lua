-- Auto generated by TableTool, Copyright ElectronicSoul@2017


local MartialStrongRandomDefault = {level=1,Success=100,}
local MartialStrongRandom= {
  [32769]={Rank=1,},
  [32770]={level=2,Rank=1,Success=80,},
  [32771]={level=3,Rank=1,Success=50,},
  [32772]={level=4,Rank=1,Success=25,},
  [65537]={Rank=2,},
  [65538]={level=2,Rank=2,Success=80,},
  [65539]={level=3,Rank=2,Success=50,},
  [65540]={level=4,Rank=2,Success=25,},
  [98305]={Rank=3,},
  [98306]={level=2,Rank=3,Success=80,},
  [98307]={level=3,Rank=3,Success=50,},
  [98308]={level=4,Rank=3,Success=25,},
  [131073]={Rank=4,},
  [131074]={level=2,Rank=4,Success=70,},
  [131075]={level=3,Rank=4,Success=30,},
  [131076]={level=4,Rank=4,Success=20,},
  [163841]={Rank=5,},
  [163842]={level=2,Rank=5,Success=60,},
  [163843]={level=3,Rank=5,Success=30,},
  [163844]={level=4,Rank=5,Success=20,},
  [196609]={Rank=6,},
  [196610]={level=2,Rank=6,Success=50,},
  [196611]={level=3,Rank=6,Success=30,},
  [196612]={level=4,Rank=6,Success=20,},
  [229377]={Rank=7,},
  [229378]={level=2,Rank=7,Success=50,},
  [229379]={level=3,Rank=7,Success=25,},
  [229380]={level=4,Rank=7,Success=15,},
}
for k,v in pairs(MartialStrongRandom) do
    setmetatable(v, {['__index'] = MartialStrongRandomDefault})
end

-- export table: MartialStrongRandom
return MartialStrongRandom
