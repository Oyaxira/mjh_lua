
function RegisterUIWindows()

	-- Achieve 成就 --
	WindowsManager:GetInstance():RegisterWindowCreate("AchievementAchieveUI",require "UI/Achieve/AchievementAchieveUI")
	WindowsManager:GetInstance():RegisterWindowCreate("AchieveRewardUI",require "UI/Achieve/AchieveRewardUI")
	-- WindowsManager:GetInstance():RegisterWindowCreate("Teammate_infoUI",require "UI/Achieve/Teammate_infoUI")
	WindowsManager:GetInstance():RegisterWindowCreate("AchievementTipUI",require "UI/Achieve/AchievementTipUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PlayerReturnTipUI",require "UI/Activity/PlayerReturnTipUI")
	WindowsManager:GetInstance():RegisterWindowCreate("AchieveDiffDropUI", require"UI/Achieve/AchieveDiffDropUI")

	WindowsManager:GetInstance():RegisterWindowCreate("PetCardsUpgradeUI",require "UI/CardsUpgradeUI/PetCardsUpgradeUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RoleCardsUpgradeUI",require "UI/CardsUpgradeUI/RoleCardsUpgradeUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureExchangeUI",require "UI/Activity/TreasureExchangeUI")
	WindowsManager:GetInstance():RegisterWindowCreate("FundUI",require "UI/Activity/FundUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureExchangePopWindowUI",require "UI/Activity/TreasureExchangePopWindowUI")
	
	WindowsManager:GetInstance():RegisterWindowCreate("CollectionFormulaUI",require "UI/CollectionUI/CollectionFormulaUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CollectionHeirloomUI",require "UI/CollectionUI/CollectionHeirloomUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CollectionComicUI",require "UI/CollectionUI/CollectionComicUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CollectionCGUI",require "UI/CollectionUI/CollectionCGUI")

	-- Battle 战斗 --
	WindowsManager:GetInstance():RegisterWindowCreate("BattleUI",require "UI/Battle/BattleUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BattleGameEndUI",require "UI/Battle/BattleGameEndUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaBattleEndUI",require "UI/Battle/ArenaBattleEndUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BattleStatisticalDataUI",require "UI/Battle/BattleStatisticalDataUI")

	WindowsManager:GetInstance():RegisterWindowCreate("BigMapUI",require "UI/BigMapUI/BigMapUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ClanUI",require "UI/Clan/ClanUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ClanCardUI",require "UI/Clan/ClanCardUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ClanEliminateUI",require "UI/Clan/ClanEliminateUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ClanBranchEliminateUI",require "UI/Clan/ClanBranchEliminateUI")

	-- Common 通用 --
	WindowsManager:GetInstance():RegisterWindowCreate("MemoriesUI",require "UI/CommonUI/MemoriesUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BarrageUI",require "UI/CommonUI/BarrageUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GeneralBoxUI",require "UI/CommonUI/GeneralBoxUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GeneralRefreshBoxUI",require "UI/CommonUI/GeneralRefreshBoxUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BlackBackgroundUI",require "UI/EffectUI/BlackBackgroundUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ForegroundUI",require "UI/EffectUI/ForegroundUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BackgroundEffectUI",require "UI/EffectUI/BackgroundEffectUI")
	WindowsManager:GetInstance():RegisterWindowCreate("DisguiseUI",require "UI/DisguiseUI/DisguiseUI")
	
	-- 红包
	WindowsManager:GetInstance():RegisterWindowCreate("MoneyPacketUI",require "UI/MoneyPacketUI/MoneyPacketUI")
	WindowsManager:GetInstance():RegisterWindowCreate("LittlePacketUI",require "UI/MoneyPacketUI/LittlePacketUI")

	-- Create 创角 --
	WindowsManager:GetInstance():RegisterWindowCreate("DifficultyUI",require "UI/Create/DifficultyUI")
	WindowsManager:GetInstance():RegisterWindowCreate("StorageUI",require "UI/Create/StorageUI")
	WindowsManager:GetInstance():RegisterWindowCreate("StorageInUI",require "UI/Create/StorageInUI")
	
	WindowsManager:GetInstance():RegisterWindowCreate("ForgeUI",require "UI/Forge/ForgeUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CreateFaceUI",require "UI/CreateFace/CreateFaceUI")

	-- Game 游戏 --
	WindowsManager:GetInstance():RegisterWindowCreate("CreateRoleUI",require "UI/Game/CreateRoleUI")
	WindowsManager:GetInstance():RegisterWindowCreate("NavigationUI",require "UI/Game/NavigationUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RandomRollUI",require "UI/Game/RandomRollUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ToptitleUI",require "UI/Game/ToptitleUI")
	WindowsManager:GetInstance():RegisterWindowCreate("WindowBarUI",require "UI/Game/WindowBarUI")
	WindowsManager:GetInstance():RegisterWindowCreate("IncompleteBoxUI",require "UI/Game/IncompleteBoxUI")
	WindowsManager:GetInstance():RegisterWindowCreate("EvolutionUI",require "UI/Evolution/EvolutionUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BatchChooseUI",require "UI/Game/BatchChooseUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BigMapCloudAnimUI",require "UI/Game/BigMapCloudAnimUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BornChooseUI", require "UI/Game/BornChooseUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ItemRewardChooseUI", require "UI/ItemUI/ItemRewardChooseUI")
	WindowsManager:GetInstance():RegisterWindowCreate("Gold2SilverUI", require "UI/Game/Gold2SilverUI")
	WindowsManager:GetInstance():RegisterWindowCreate("Gold2SecondGoldUI", require "UI/Game/Gold2SecondGoldUI")
	WindowsManager:GetInstance():RegisterWindowCreate("DialogRecordUI",require "UI/Game/DialogRecordUI")
	WindowsManager:GetInstance():RegisterWindowCreate("DialogControlUI",require "UI/Game/DialogControlUI")

	-- Gift --
	WindowsManager:GetInstance():RegisterWindowCreate("PickGiftUI",require "UI/Gift/PickGiftUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GiftTipsUI",require "UI/Gift/GiftTipsUI")

	-- Shop --
	WindowsManager:GetInstance():RegisterWindowCreate("ShoppingMallUI",require "UI/TownUI/ShoppingMallUI")

	-- Interactive 交互 --
	WindowsManager:GetInstance():RegisterWindowCreate("DialogChoiceUI",require "UI/Plot/DialogChoiceUI")
	WindowsManager:GetInstance():RegisterWindowCreate("DialogueUI",require "UI/Interactive/DialogueUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ObserveUI",require "UI/Interactive/ObserveUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RoleShowUI",require "UI/Interactive/RoleShowUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SelectUI",require "UI/Interactive/SelectUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TitleSelectUI",require "UI/Interactive/TitleSelectUI")
	WindowsManager:GetInstance():RegisterWindowCreate("InteractUnlockUI",require "UI/Interactive/InteractUnlockUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ObsBabyUI",require "UI/Interactive/ObsBabyUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BlurBGUI",require "UI/Interactive/BlurBGUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SpecialRoleIntroduceUI",require "UI/Interactive/SpecialRoleIntroduceUI")
	
	WindowsManager:GetInstance():RegisterWindowCreate("LoadingUI",require "UI/LoadingUI/LoadingUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MiniLoadingUI",require "UI/LoadingUI/MiniLoadingUI")
	WindowsManager:GetInstance():RegisterWindowCreate("LoginUI",require "UI/LoginUI/LoginUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ServerListUI",require "UI/LoginUI/ServerListUI")
	WindowsManager:GetInstance():RegisterWindowCreate("FriendListUI",require "UI/LoginUI/FriendListUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BattleLoadingUI",require "UI/LoadingUI/BattleLoadingUI")
	WindowsManager:GetInstance():RegisterWindowCreate("LoginAggrementUI",require "UI/LoginUI/LoginAggrementUI")

	-- Map 地图 --
	WindowsManager:GetInstance():RegisterWindowCreate("CityUI",require "UI/MapUI/CityUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CityAnimUI",require "UI/MapUI/CityAnimUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CityBuildingUI",require "UI/MapUI/CityBuildingUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CityRoleListUI",require "UI/MapUI/CityRoleListUI")

	-- Martial 武学 --
	WindowsManager:GetInstance():RegisterWindowCreate("ClanMartialUI",require "UI/Martial/ClanMartialUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MazeUI",require "UI/MazeUI/MazeUI")
	WindowsManager:GetInstance():RegisterWindowCreate("NpcConsultUI",require "UI/Martial/NpcConsultUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ChoiceUI",require "UI/Plot/ChoiceUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CartoonUI",require "UI/Plot/CartoonUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MazeEntryUI",require "UI/MazeUI/MazeEntryUI")

	-- Role 角色 --
	WindowsManager:GetInstance():RegisterWindowCreate("CharacterUI",require "UI/Role/CharacterUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GiveGiftDialogUI",require "UI/Role/GiveGiftDialogUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RoleEmbattleUI",require "UI/Role/RoleEmbattleUI")
	--WindowsManager:GetInstance():RegisterWindowCreate("PlatformRoleEmbattleUI",require "UI/Platform/PlatformRoleEmbattleUI")
	
	WindowsManager:GetInstance():RegisterWindowCreate("RoleTeamOutUI",require "UI/Role/RoleTeamOutUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ShowBackpackUI",require "UI/Role/ShowBackpackUI")

	WindowsManager:GetInstance():RegisterWindowCreate("StoreUI",require "UI/Store/StoreUI")	
	WindowsManager:GetInstance():RegisterWindowCreate("ToastUI",require "UI/System/ToastUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GoldAnimUI",require "UI/System/GoldAnimUI")
	WindowsManager:GetInstance():RegisterWindowCreate("LevelUPUI",require "UI/System/LevelUPUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MartialStrongUI",require "UI/Martial/MartialStrongUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GetBabyUI",require "UI/Role/GetBabyUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ForgetMartialGiftUI",require "UI/Role/ForgetMartialGiftUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MarryUI",require "UI/Role/MarryUI")	
	WindowsManager:GetInstance():RegisterWindowCreate("MartialSelectUI", require"UI/Role/MartialSelectUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SwornUI",require "UI/Role/SwornUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SetNicknameUI",require "UI/Role/SetNicknameUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SetNicknameTip",require "UI/Role/SetNicknameTip")
	
	-- Task 任务 --
	WindowsManager:GetInstance():RegisterWindowCreate("TaskUI",require "UI/Task/TaskUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TaskCompleteUI",require "UI/Task/TaskCompleteUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TaskTipsUI",require "UI/Task/TaskTipsUI")

	-- TestGraphic 画面测试 --
	WindowsManager:GetInstance():RegisterWindowCreate("TestGraphicUI",require "UI/TestGraphicUI/TestGraphicUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TestSpine",require "UI/TestGraphicUI/TestSpine")

	-- Tips 提示 --
	WindowsManager:GetInstance():RegisterWindowCreate("NoticeDialogUI",require "UI/TipsUI/NoticeDialogUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RollTipUI",require "UI/TipsUI/RollTipUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RulePopUI",require "UI/TipsUI/RulePopUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SystemTipsUI",require "UI/TipsUI/SystemTipsUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TipsPopUI",require "UI/TipsUI/TipsPopUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BuffTipsUI",require "UI/TipsUI/BuffTipsUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PopUpWindowUI",require "UI/TipsUI/PopUpWindowUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ActivityTipsUI",require "UI/TipsUI/ActivityTipsUI")
	-- Town 城镇 --
	WindowsManager:GetInstance():RegisterWindowCreate("FPSUI",require "UI/TownUI/FPSUI")
	WindowsManager:GetInstance():RegisterWindowCreate("HouseUI",require "UI/TownUI/HouseUI")
	WindowsManager:GetInstance():RegisterWindowCreate("StoryUI",require "UI/TownUI/StoryUI")
	WindowsManager:GetInstance():RegisterWindowCreate("DreamStoryUI",require "UI/TownUI/DreamStoryUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ChooseLuckyUI",require "UI/TownUI/ChooseLuckyUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SystemAnnouncementUI", require "UI/TownUI/SystemAnnouncementUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BugReportUI", require "UI/TownUI/BugReportUI")
	WindowsManager:GetInstance():RegisterWindowCreate("BattleReportUI", require "UI/TownUI/BattleReportUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SystemCrashUI", require "UI/TownUI/SystemCrashUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PlayerMsgMiniUI", require "UI/TownUI/PlayerMsgMiniUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PlayerReportOnUI", require "UI/TownUI/PlayerReportOnUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TownPlayerListUI", require "UI/TownUI/TownPlayerListUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureBookUI", require "UI/TownUI/TreasureBookUI")	
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureBookAdUI", require "UI/TownUI/TreasureBookAdUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureBookActivityAdUI", require "UI/TownUI/TreasureBookActivityAdUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureBookEarlyBuyUI", require "UI/TownUI/TreasureBookEarlyBuyUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TreasureBookWarningBoxUI", require "UI/TownUI/TreasureBookWarningBoxUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ChatBubble", require "UI/TownUI/ChatBubble")
	WindowsManager:GetInstance():RegisterWindowCreate("PinballGameUI", require "UI/TownUI/PinballGameUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PinballServerPlayRecordUI", require "UI/TownUI/PinballServerPlayRecordUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CouponUI", require "UI/TownUI/CouponUI")
	WindowsManager:GetInstance():RegisterWindowCreate("Day3SignInUI", require "UI/TownUI/Day3SignInUI")
	WindowsManager:GetInstance():RegisterWindowCreate("Day7TaskUI", require "UI/TownUI/Day7TaskUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ChallengeOrderUI", require "UI/TownUI/ChallengeOrderUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ItemRecycleUI", require "UI/TownUI/ItemRecycleUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GiftBagResultUI", require "UI/TownUI/GiftBagResultUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ActivitySignUI", require "UI/TownUI/ActivitySignUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ActivitySignMallUI", require "UI/TownUI/ActivitySignMallUI")
	WindowsManager:GetInstance():RegisterWindowCreate("DailyRewardUI", require "UI/TownUI/DailyRewardUI")

	WindowsManager:GetInstance():RegisterWindowCreate("PickWishRewardsUI",require "UI/WishTask/PickWishRewardsUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ShareUI",require "UI/TownUI/ShareUI")
	
	-- 社交(邮件/好友) --
	WindowsManager:GetInstance():RegisterWindowCreate("SocialUI",require "UI/Friends/SocialUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ChatBoxUI",require "UI/Interactive/ChatBoxUI")

	-- 跑马灯
	WindowsManager:GetInstance():RegisterWindowCreate("SysTipsUI",require "UI/TownUI/SysTipsUI")

	-- UID
	WindowsManager:GetInstance():RegisterWindowCreate("ServerAndUIDUI",require "UI/CommonUI/ServerAndUIDUI")

	-- 经脉 --
	WindowsManager:GetInstance():RegisterWindowCreate("MeridiansUI",require "UI/Meridians/MeridiansUI")

	-- 结束周目
	WindowsManager:GetInstance():RegisterWindowCreate("ResultUI",require "UI/ResultUI/ResultUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ResultUIGuide",require "UI/ResultUI/ResultUIGuide")

	-- 选择角色UI
	WindowsManager:GetInstance():RegisterWindowCreate("ChooseRoleUI",require "UI/ResultUI/ChooseRoleUI")
	
	-- 排行榜
	WindowsManager:GetInstance():RegisterWindowCreate("RankUI",require "UI/RankUI/RankUI")
	WindowsManager:GetInstance():RegisterWindowCreate("HuaShanRankUI",require "UI/RankUI/HuaShanRankUI")
	
	-- 擂台
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUI",require "UI/ArenaUI/ArenaUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUIMatch",require "UI/ArenaUI/ArenaUIMatch")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUIBet",require "UI/ArenaUI/ArenaUIBet")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUIClanTips",require "UI/ArenaUI/ArenaUIClanTips")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUIMatchRecode",require "UI/ArenaUI/ArenaUIMatchRecode")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUIFinalJoinNames",require "UI/ArenaUI/ArenaUIFinalJoinNames")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaUIHuaShanFinalJoinNames",require "UI/ArenaUI/ArenaUIHuaShanFinalJoinNames")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaScriptMatchUI",require "UI/ArenaUI/ArenaScriptMatchUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ArenaPlayerCompareUI",require "UI/ArenaUI/ArenaPlayerCompareUI")

	-- 收藏系统
	WindowsManager:GetInstance():RegisterWindowCreate("CollectionUI",require "UI/CollectionUI/CollectionUI")
	WindowsManager:GetInstance():RegisterWindowCreate("CollectionMartialUI",require "UI/CollectionUI/CollectionMartialUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MartialScreenUI",require "UI/CollectionUI/MartialScreenUI")

	-- 更新测试
	WindowsManager:GetInstance():RegisterWindowCreate("UpdateUI",require "UI/LoginUI/UpdateUI")
	
	-- 动漫界面
	WindowsManager:GetInstance():RegisterWindowCreate("ComicPlotUI",require "UI/CommonUI/ComicPlotUI")

	-- 设置界面
	WindowsManager:GetInstance():RegisterWindowCreate("PlayerSetUI",require "UI/PlayerSet/PlayerSetUI")
	WindowsManager:GetInstance():RegisterWindowCreate("AccountInfoUI",require "UI/PlayerSet/AccountInfoUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SystemSettingUI",require "UI/PlayerSet/SystemSettingUI")
	WindowsManager:GetInstance():RegisterWindowCreate("AccountSettingUI",require "UI/PlayerSet/AccountSettingUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PoemShowUI",require "UI/PlayerSet/PoemShowUI")
	WindowsManager:GetInstance():RegisterWindowCreate("RenameBoxUI",require "UI/PlayerSet/RenameBoxUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ExchangeCodeUI",require "UI/PlayerSet/ExchangeCodeUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ModUI",require "UI/Mod/ModUI")
	WindowsManager:GetInstance():RegisterWindowCreate("SystemPowerUI",require "UI/PlayerSet/SystemPowerUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PrivateMessageUI",require "UI/PlayerSet/PrivateMessageUI")

	-- 视频播放
	WindowsManager:GetInstance():RegisterWindowCreate("VideoPlayerUI",require "UI/System/VideoPlayerUI")

	WindowsManager:GetInstance():RegisterWindowCreate("ZywTest",require "UI/Test/ZywTest")

	-- 大决战
	WindowsManager:GetInstance():RegisterWindowCreate("FinalBattleUI",require "UI/FinalBattle/FinalBattleUI")
	WindowsManager:GetInstance():RegisterWindowCreate("FinalBattleCityInfoUI",require "UI/FinalBattle/FinalBattleCityInfoUI")

	-- 千层塔
	WindowsManager:GetInstance():RegisterWindowCreate("HighTowerRewardUI",require "UI/HighTower/HighTowerRewardUI")

	-- 引导
	WindowsManager:GetInstance():RegisterWindowCreate("GuideUI",require "UI/GuideUI/GuideUI")
	-- Debug
	WindowsManager:GetInstance():RegisterWindowCreate("CheatUI",require "UI/CheatUI/CheatUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ActionDebugUI",require "UI/DebugUI/ActionDebugUI")
	WindowsManager:GetInstance():RegisterWindowCreate("UiLayerDebugUI",require "UI/DebugUI/UiLayerDebugUI")
	WindowsManager:GetInstance():RegisterWindowCreate("TagDebugUI",require "UI/DebugUI/TagDebugUI")

	--Privilege
	WindowsManager:GetInstance():RegisterWindowCreate("WXPrivilegeBox",require "UI/PrivilegeUI/WXPrivilegeBox")
	WindowsManager:GetInstance():RegisterWindowCreate("QQPrivilegeBox",require "UI/PrivilegeUI/QQPrivilegeBox")
	WindowsManager:GetInstance():RegisterWindowCreate("SystemScreenShotShareTipUI",require "UI/PrivilegeUI/SystemScreenShotShareTipUI")

	-- PK
	WindowsManager:GetInstance():RegisterWindowCreate("PKUI",require "UI/PKUI/PKUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PKRoleUI",require "UI/PKUI/PKRoleUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PKRankUI",require "UI/PKUI/PKRankUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PKMatchUI",require "UI/PKUI/PKMatchUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PKTipUI",require "UI/PKUI/PKTipUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PKShopUI",require "UI/PKUI/PKShopUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PKSelectUI",require "UI/PKUI/PKSelectUI")

	WindowsManager:GetInstance():RegisterWindowCreate("ShowAllChooseGoodsUI",require "UI/CommonUI/ShowAllChooseGoodsUI")

	WindowsManager:GetInstance():RegisterWindowCreate("LimitShopUI",require "UI/LimitShopUI/LimitShopUI")
	WindowsManager:GetInstance():RegisterWindowCreate("LimitShopActionPanalUI",require "UI/LimitShopUI/LimitShopActionPanalUI")
	WindowsManager:GetInstance():RegisterWindowCreate("LimitShopDiscountPanalUI",require "UI/LimitShopUI/LimitShopDiscountPanalUI")
	WindowsManager:GetInstance():RegisterWindowCreate("GuessCoinUI",require "UI/LimitShopUI/GuessCoinUI")
	WindowsManager:GetInstance():RegisterWindowCreate("ClickDiscountUI",require "UI/LimitShopUI/ClickDiscountUI")

	--
	WindowsManager:GetInstance():RegisterWindowCreate("TakeExtraUI",require "UI/Store/TakeExtraUI")

	-- 资源掉落活动
	WindowsManager:GetInstance():RegisterWindowCreate("CollectActivityUI",require "UI/ResDropActivityUI/CollectActivityUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MultDropActivityUI",require "UI/ResDropActivityUI/MultDropActivityUI")
	
	--主题讨论
	WindowsManager:GetInstance():RegisterWindowCreate("DiscussUI",require "UI/DiscussUI/DiscussUI")

	WindowsManager:GetInstance():RegisterWindowCreate("ActivityUI",require "UI/Activity/ActivityUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PlayerReturnUI",require "UI/Activity/PlayerReturnUI")
	WindowsManager:GetInstance():RegisterWindowCreate("PlayerReturnTaskUI",require "UI/Activity/PlayerReturnTaskUI")
	WindowsManager:GetInstance():RegisterWindowCreate("FestivalUI",require "UI/Activity/FestivalUI")
	WindowsManager:GetInstance():RegisterWindowCreate("AllRewardWindowUI",require "UI/Activity/AllRewardWindowUI")
	
	-- UID
	WindowsManager:GetInstance():RegisterWindowCreate("TileBigMap",require "UI/TileMap/TileBigMap")
	WindowsManager:GetInstance():RegisterWindowCreate("MiniMapUI",require "UI/MiniMapUI/MiniMapUI")
	WindowsManager:GetInstance():RegisterWindowCreate("MapUnfoldUI",require "UI/MiniMapUI/MapUnfoldUI")

end
