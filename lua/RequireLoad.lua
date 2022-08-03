function reloadGameModules()
    --------base
    profiler = reloadModule("perf/profiler")
    reloadModule("Base/DRCSRef")
    reloadModule("Base/Coroutine")
    reloadModule("Base/UIManager/BaseWindow")
    reloadModule("Base/UIManager/WindowsManager")
    reloadModule("Base/StringDecoder")
    reloadModule("Base/Event")
    reloadModule("Base/Timer")
    reloadModule("Base/Json/dkjson")
    reloadModule("Base/ResourcesMgr")
    reloadModule("Base/DataCenter")
    reloadModule("Base/LuaMemorySnapshotDump")
    
    -------- base/Box
    reloadModule('Base/Box/BoxPoolManager')
    reloadModule('Base/Box/BaseBox')
    reloadModule('Base/Box/BoxHelper')


    --------net
    reloadModule("Net/NetLoginMsg")
    reloadModule("Net/NetGameMsg")
    reloadModule("Net/NetCmdGenerate")
    reloadModule("Net/UPSMgr")
    reloadModule("Net/ClientConfigHelper")
    
    --------data / 按首字母排序
    package.loaded["common"] = require("Data/common")  --一个优化 防止在生成的datga文件里 多次加载

    MSDKHelper = reloadModule("MSDKHelper")
    MidasHelper = reloadModule("MidasHelper")
    GVoiceHelper = reloadModule("GVoiceHelper")
    TB_PlayerInfoData           = nil;

    TB_Role =                   reloadModule("Data/Role")
    -- 大于50个字段需要排查的
    TB_Clan =                   reloadModule("Data/Clan")

    reloadModule("Enum")
    reloadModule("Net/NetCommonSDK/NetCommonService")
    reloadModule("UI/CommonUI/TableDataManager")

    --
    reloadModule("UI/Friends/SocialDataManager")
    reloadModule("UI/Meridians/MeridiansDataManager")
    reloadModule("UI/RankUI/RankDataManager")
    reloadModule("UI/ArenaUI/ArenaDataManager")
    reloadModule("UI/TownUI/ShoppingDataManager")
    reloadModule("UI/Interactive/ChatBoxUIDataManager")
    reloadModule("UI/CollectionUI/CollectionDataManager")
    reloadModule("UI/MoneyPacketUI/MoneyPacketDataManager")

    reloadModule("UI/ItemUI/ItemPool")
    reloadModule("UI/ItemUI/LuaClassFactory")
    reloadModule("UI/Toast/DisplayToast")
    reloadModule('UI/CheatUI/CheatDataManager')
    reloadModule('UI/TipsUI/TipsDataManager')
    reloadModule('UI/Unlock/UnlockDataManager')
    reloadModule('UI/Plot/PlotDataManager')

    reloadManagerModule()
    
    reloadModule("UI/GuideUI/GuideDataManager")
    reloadModule("UI/Achieve/AchieveDataManager")
    reloadModule("UI/Create/StorageDataManager")
    reloadModule("UI/PlayerSet/PlayerSetDataManager")
    reloadModule("UI/Misc/StringHelper")
    reloadModule("UI/System/SystemUICall")
    reloadModule("UI/TownUI/TreasureBookDataManager")
    reloadModule("UI/TownUI/Day3SignInDataManager")
    reloadModule("UI/Drop/DropDataManager")
    reloadModule("UI/TownUI/PinballDataManager")
    reloadModule("UI/LimitShopUI/LimitShopManager")
    reloadModule("UI/DiscussUI/DiscussDataManager")

    reloadModule("UI/PlayerSet/PlayerSetUI")
    reloadModule("UI/PlayerSet/AccountInfoUI")
    reloadModule("UI/PlayerSet/SystemSettingUI")
    reloadModule("UI/PlayerSet/AccountSettingUI")
    reloadModule("UI/PlayerSet/PoemShowUI")

    -- Res Drop Activity
    reloadModule("UI/ResDropActivityUI/ResDropActivityDataManager")
    
    reloadModule("UI/Mod/ModUI")

    --------Activity
    reloadModule("UI/Activity/ActivityHelper")

    --------UI
    reloadModule("UI/UIRegister")
    reloadModule("UI/CommonUI/BubblePlotUI")

    --------Battle
    reloadModule("Logic/Unit/UnitData")
    reloadModule("Logic/Unit/Unit")
    reloadModule("Logic/Unit/UnitAssist")
    reloadModule("Logic/Unit/UnitLifeBar")
    reloadModule("Logic/Unit/UnitDamageNum")
    reloadModule("Logic/Unit/UnitMgr")
    reloadModule("Logic/LogicMain")
    reloadModule("Logic/BattleHelperFunction")
    reloadModule("Logic/PathFinder/Grid")
    reloadModule("Logic/PathFinder/PathFinder")

    reloadModule("Logic/Effect/EffectMgr")
    reloadModule("Logic/BattleMartial/BattleMartialData")
    reloadModule("Logic/BattleTreasureBox/BattleTreasureBox")
    reloadModule("Logic/BattleTreasureBox/BattleTreasureBoxMgr")

    reloadModule("Logic/TeamCondition/TeamCondition")

    reloadModule("UI/Animation/AnimationMgr")
    reloadModule("UI/Animation/BattleSceneAnimation")
    reloadModule("Animation/TimeLineHelper")
    reloadModule("UI/Animation/Object")
    -- Animation 
    reloadModule("Animation/AnimationFunc")
    reloadModule("Animation/Track/BaseTrack")
    reloadModule("Animation/Track/UnitFunctionTrack")
    reloadModule("Animation/Track/FunctionTrack")
    reloadModule("Animation/Track/LambdaTrack")
    reloadModule("Animation/Track/SoundTrack")
    reloadModule("Animation/Track/ObjAnimationTrack")
    reloadModule("Animation/Track/TweenerTrack")
    reloadModule("Animation/Track/UnitAnimationTrack")
    reloadModule("Animation/Buff/BuffObjectManager")

    -- class
    reloadModule("UI/Role/RoleClass/BaseRole")
    reloadModule("UI/Role/RoleClass/NPCRole")
    reloadModule("UI/Role/RoleClass/InstRole")
    reloadModule("UI/Role/RoleClass/BattleRole")
    reloadModule("UI/Role/RoleClass/ZmRole")
    reloadModule("UI/Role/RoleClass/HouseRole")

    
    --CreateFace
    reloadModule('UI/CreateFace/CreateFaceManager')

    -- PK
    reloadModule('UI/PKUI/PKManager')

    reloadModule('UI/TileMap/TileFindPathManager')
    --
    PlayerSetDataManager:GetInstance():InitPlayerInfoData();
    MartialDataManager:GetInstance():InitAoYiTable();
end

function reloadManagerModule()
    reloadSingleManagerModule('UI/MapUI/MapDataManager', 'MapDataManager')
    reloadSingleManagerModule('UI/MapUI/CityDataManager', 'CityDataManager')
    reloadSingleManagerModule('UI/Martial/MartialDataManager', 'MartialDataManager')
    reloadSingleManagerModule('UI/ItemUI/ItemDataManager', 'ItemDataManager')
    reloadSingleManagerModule('UI/Store/ShopDataManager', 'ShopDataManager')
    reloadSingleManagerModule('UI/Role/RoleDataManager', 'RoleDataManager')
    reloadSingleManagerModule('UI/Role/BattleAIDataManager', 'BattleAIDataManager')
    reloadSingleManagerModule('UI/Gift/GiftDataManager', 'GiftDataManager')
    reloadSingleManagerModule('UI/WishTask/WishTaskDataManager', 'WishTaskDataManager')    
    reloadSingleManagerModule('UI/CardsUpgradeUI/CardsUpgradeDataManager', 'CardsUpgradeDataManager')

    reloadSingleManagerModule('UI/MazeUI/MazeDataManager', 'MazeDataManager')
    reloadSingleManagerModule('UI/Role/EvolutionDataManager', 'EvolutionDataManager')
    reloadSingleManagerModule('UI/Evolution/EvolutionShowManager', 'EvolutionShowManager')
    reloadSingleManagerModule('UI/Task/TaskDataManager', 'TaskDataManager')
    reloadSingleManagerModule('UI/Task/TaskTagManager', 'TaskTagManager')
    reloadSingleManagerModule('UI/Clan/ClanDataManager', 'ClanDataManager')
    reloadSingleManagerModule('UI/Battle/BattleDataManager', 'BattleDataManager')
    reloadSingleManagerModule('UI/DisplayActionManager', 'DisplayActionManager')
    reloadSingleManagerModule('UI/Interactive/BlurBackgroundManager', 'BlurBackgroundManager')
    reloadSingleManagerModule('UI/TipsUI/SystemTipManager', 'SystemTipManager')
    reloadSingleManagerModule('UI/EffectUI/MapEffectManager', 'MapEffectManager')
    reloadSingleManagerModule('UI/FinalBattle/FinalBattleDataManager', 'FinalBattleDataManager')
    reloadSingleManagerModule('UI/Interactive/ShowDataRecordManager', 'ShowDataRecordManager')
    reloadSingleManagerModule('UI/MazeUI/AdvLootManager', 'AdvLootManager')
    reloadSingleManagerModule('UI/HighTower/HighTowerDataManager', 'HighTowerDataManager')
    reloadSingleManagerModule('UI/ArenaUI/ArenaScriptDataManager', 'ArenaScriptDataManager')
    reloadSingleManagerModule('UI/Story/StoryDataManager', 'StoryDataManager')

    reloadSingleManagerModule('UI/Game/DialogRecordDataManager', 'DialogRecordDataManager')

    reloadSingleManagerModule('UI/CommonUI/SaveFileDataManager', 'SaveFileDataManager')
end

function reloadSingleManagerModule(path, managerName)
    local manager = _G[managerName]
    if manager == nil then 
        reloadModule(path)
    else
        local managerInstance = manager:GetInstance()
        if managerInstance ~= nil and type(managerInstance) == 'function' then 
            managerInstance:ResetManager()
        else
            reloadModule(path)
        end
    end
end