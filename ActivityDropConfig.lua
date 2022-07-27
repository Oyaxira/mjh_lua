-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum ResDropActivityTarScene
-- enum ResDropActivityTarSubScene
require("common");


local ActivityDropConfigDefault = {ResDropDayLimit=20,ActivityID=0,TargetM=0,ResRecMeridianExp=10,}
local ActivityDropConfig= {
  [10001]={BaseID=10001,TargetP={1200,6000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={60111,60112,},ResDropDayLimit=15,},
  [10002]={BaseID=10002,TargetP={1080,5400,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={60121,60122,},ResDropDayLimit=18,},
  [10003]={BaseID=10003,TargetP={1200,6000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={60131,60132,},ResDropDayLimit=15,},
  [10004]={BaseID=10004,TargetP={1080,5400,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={60141,60142,},ResDropDayLimit=18,},
  [10005]={BaseID=10005,TargetP={1080,5400,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={60151,60152,},ResDropDayLimit=18,},
  [10006]={BaseID=10006,TargetP={1080,5400,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={60161,60162,},ResDropDayLimit=15,},
  [20001]={BaseID=20001,TargetScenes={ResDropActivityTarScene.RDATS_NormalMazeFight,ResDropActivityTarScene.RDATS_NormalMazeBox,ResDropActivityTarScene.RDATS_TaskReward,ResDropActivityTarScene.RDATS_TreasureMazeFight,ResDropActivityTarScene.RDATS_TreasureMazeBox,ResDropActivityTarScene.RDATS_TowerBox,},ResDropDayLimit=0,TargetSubScenes={ResDropActivityTarSubScene.RDATSS_RoleExp,ResDropActivityTarSubScene.RDATSS_MartialExp,ResDropActivityTarSubScene.RDATSS_Coin,ResDropActivityTarSubScene.RDATSS_Material,ResDropActivityTarSubScene.RDATSS_Equip,},TargetM=20000,ResRecMeridianExp=0,},
  [30001]={BaseID=30001,TargetP={800,4000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={8911,8912,},EnableScripts={2,6,7,},ActivityID=10301,ResRecMeridianExp=0,},
  [30002]={BaseID=30002,TargetP={800,4000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={8921,8922,},EnableScripts={2,6,7,},ActivityID=10302,ResRecMeridianExp=0,},
  [30003]={BaseID=30003,TargetP={800,4000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={8931,8932,},EnableScripts={2,6,7,},ActivityID=10303,ResRecMeridianExp=0,},
  [30004]={BaseID=30004,TargetP={800,4000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={8941,8942,},EnableScripts={2,6,7,},ActivityID=10304,ResRecMeridianExp=0,},
  [30005]={BaseID=30005,TargetP={800,4000,},TargetScenes={ResDropActivityTarScene.RDATS_FightWithEndUI,ResDropActivityTarScene.RDATS_NormalMazeBox,},TargetDrop={8951,8952,},EnableScripts={2,6,7,10,},ActivityID=10305,ResRecMeridianExp=0,},
}
for k,v in pairs(ActivityDropConfig) do
    setmetatable(v, {['__index'] = ActivityDropConfigDefault})
end

-- export table: ActivityDropConfig
return ActivityDropConfig
