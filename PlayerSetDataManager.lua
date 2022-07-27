PlayerSetDataManager = class("PlayerSetDataManager")
PlayerSetDataManager._instance = nil
local dkJson = require("Base/Json/dkjson")

function PlayerSetDataManager:ctor()
    self.platBattleData = {};
    self.appearanceInfo = {}
    self.commonInfo = {}
    self.systemTipsData = {}
    self.storyWeekTakeOutNums = {}
    self.playerID = 0
    self.reNameNum = 0
    self.playerGold = 0
    self.playerSliver = 0
    self.playerCoin = 0
    self.playerPerfectPowder = 0
    self.martialSecretBook = 0
    self.playerRefinedIron = 0
    self.playerHeavenHammer = 0
    self.playerWangyoucao = 0
    self.creatRoleID = 0
    self.playerRefreshBall = 0
    -- 7天签到
    self.signInFlag = 0
    -- 掌门对决
    self.zmFreeTicket = 0
    self.zmTicket = 0
    self.zmNewFlag = false

    self.firstSetGold = true
    self.firstSetSliver = true
    self.firstSetCoin = true
    self.noGoldGetAnim = false
    self.bShowGoldTips = true
end

function PlayerSetDataManager:GetInstance()
    if PlayerSetDataManager._instance == nil then
        PlayerSetDataManager._instance = PlayerSetDataManager.new()
    end

    return PlayerSetDataManager._instance
end

-- 初始化配置数据
function PlayerSetDataManager:InitSingleFieldConfig()
    local kTBConfig = TableDataManager:GetInstance():GetTable("SingleFieldConfig")
    if not kTBConfig then
        return
    end
    local kType2Value = {}
    for index, kConfig in ipairs(kTBConfig) do
        kType2Value[kConfig.ConfigType] = kConfig.ConfigValue or 0
    end
    self.kSingleFieldConfig = kType2Value
end

-- 获取配置数据
function PlayerSetDataManager:GetSingleFieldConfig(eConfigType)
    if (not eConfigType) or (eConfigType == 0) then
        return 0
    end
    if not self.kSingleFieldConfig then
        self:InitSingleFieldConfig()
    end
    if not self.kSingleFieldConfig then
        return 0
    end
    return self.kSingleFieldConfig[eConfigType] or 0
end

function PlayerSetDataManager:InitPlayerInfo(kRetData)
    --初始化玩家数据
    G_UID = kRetData["defPlayerID"]
    if (not DEBUG_MODE) and G_UID <= 1 then 
        -- 提示检查 Steam 状态并重新登陆
        DRCSRef.LuaBehaviour.RemoveQuit()
        ForceQuitGame(-1, '连接失败', '获取steam账号数据失败，请尝试重启游戏。为了正确获取到账号信息，运行游戏时，请保持网络通畅。若游戏进行中频繁出现此问题可在官方Q群联系客服阿月。')
        return
    end
    if G_UID > 3 then
        local str_id = tostring(G_UID)
        local iNum = DRCSRef.LogicMgr:GetDLCInfoNum()
        local str = ""
        for i = 1, iNum do
            if DRCSRef.LogicMgr:GetInfo("dlc", i) == 1 then
                if i == iNum then
                    str = str.."dlc"..i
                else
                    str = str.."dlc"..i.."|"
                end
            end
        end
        local jsonStr = {
            ["dlc_list"] = str,
        }
        dkJson.encode(jsonStr)
        if DEBUG_CHEAT then
            local showContent = {
                ['title'] = '提示Dlc',
                ['text'] = str
            }
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COSTITEM_TIP, showContent, nil})
        end
        
        CS.DHTackHelper.login(str_id, "",jsonStr)
    end
    local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
    serverAndUIDUI:RefreshUI()
    self:SetPlayerID(2)
    self:SetReNameNum(kRetData["dwReNameNum"])
    self:SetLuckyValue(kRetData["dwLuckyValue"])
    self:SetPlayerSliver(kRetData["dwSilver"])
    self:SetPlayerDrinkMoney(kRetData["dwDrinkMoney"])
    self:SetPlayerPlatScore(kRetData["dwPlatScore"])
    self:SetPlayerActiveScore(kRetData["dwActiveScore"])
    self:SetPlayerSecondGold(kRetData["dwSecondGold"])
    self:SetChallengeOrderType(kRetData["dwChallengeOrderType"])
    self:SetLoginDayNum(kRetData["dwLoginDayNum"])
    self:SetSignInFlag(kRetData["dwSign_in_flag"])
    self:SetServerOpenTime(kRetData["dwServerOpenTime"])

    self:SetSex(kRetData["kCommInfo"]["dwSex"])
    self:SetRemainWordNum(kRetData["kCommInfo"]["dwRemainWordNum"])
    self:SetWeekRoundTotalNum(kRetData["kCommInfo"]["dwWeekRoundTotalNum"])
    self:SetALiveDays(kRetData["kCommInfo"]["dwALiveDays"])
    self:SetCreateTime(kRetData["kCommInfo"]["dwCreateTime"])
    self:SetChallengeWinTimes(kRetData["kCommInfo"]["dwChallengeWinTimes"])
    self:SetLastLogoutTime(kRetData["kCommInfo"]["dwLastLogoutTime"])

    self:SetNormalHighTowerMaxNum(kRetData["kCommInfo"]["dwNormalHighTowerMaxNum"])
    self:SetBloodHighTowerMaxNum(kRetData["kCommInfo"]["dwBloodHighTowerMaxNum"])
    self:SetRegimentHighTowerMaxNum(kRetData["kCommInfo"]["dwRegimentHighTowerMaxNum"])

    self:SetHoodleScore(kRetData["kCommInfo"]["dwHoodleScore"]) --玩家夺宝积分

    --设置玩家QQ或微信头像URL
    self:SetCharPictureUrl(kRetData["kCommInfo"]["charPicUrl"])
    
    self:SetAchieveTotalNum(kRetData["kFuncInfo"]["dwAchieveTotalNum"])
    self:SetMeridianTotalLvl(kRetData["kFuncInfo"]["dwMeridianTotalLvl"])
    self:SetLowInCompleteTextNum(kRetData["kFuncInfo"]["dwLowInCompleteTextNum"])
    self:SetMidInCompleteTextNum(kRetData["kFuncInfo"]["dwMidInCompleteTextNum"])
    self:SetHighInCompleteTextNum(kRetData["kFuncInfo"]["dwHighInCompleteTextNum"])
    self:SetLucyValue(kRetData["kFuncInfo"]["dwLuckyValue"])
    self:SetPlayerRefinedIron(kRetData["kFuncInfo"]["dwJingTieNum"])  -- 精铁
    self:SetPlayerHeavenHammer(kRetData["kFuncInfo"]["dwTianGongChui"]) --天工锤
    self:SetPlayerPerfectPowder(kRetData["kFuncInfo"]["dwPerfectFenNum"])  -- 完美粉
    self:SetPlayerWangyoucao(kRetData["kFuncInfo"]["dwWangYouCaoNum"])  -- 忘忧草
    self:SetPlayerRefreshBall(kRetData["kFuncInfo"]["dwRefreshBallNum"])
    self:SetPlayerDilatationNum(kRetData["kFuncInfo"]["dwDilatationNum"]) --设置仓库扩容带入格子
    LimitShopManager:GetInstance():SetBigmapActionFlag(kRetData["kFuncInfo"]["dwLimitShopBigmapAciton"]) -- 限时礼包标记
    LimitShopManager:GetInstance():SetFreeGiveBigCoinFlag(kRetData["kFuncInfo"]["dwFreeGiveBigCoin"]) --免费大金币赠送标记
	self:SetShopGoldRewadTime(kRetData["kFuncInfo"]["dwShopGoldRewardTime"]) --商店金锭打赏记录时间
    self:SetShopAdRewadTime(kRetData["kFuncInfo"]["dwShopAdRewardTime"]) --商店广告打赏记录时间
    self:SetDailyRewardState(kRetData["kFuncInfo"]["dwDailyRewardState"]) --每日奖励领取状态
    self:SetFundAchieveOpen(kRetData["kFuncInfo"]["dwFundAchieveOpen"]) --设置玩家完整版开通基金标记
    self:SetRedPacketGetTimes(kRetData["kFuncInfo"]["dwRedPacketGetTimes"]) --设置玩家红包领取次数
    self:SetBondPellet(kRetData["kFuncInfo"]["dwBondPelletNum"])

    self:SetResDropActivityFuncValue(1, kRetData["kFuncInfo"]["dwResDropActivityFuncValue1"])
    self:SetResDropActivityFuncValue(2, kRetData["kFuncInfo"]["dwResDropActivityFuncValue2"])
    self:SetResDropActivityFuncValue(3, kRetData["kFuncInfo"]["dwResDropActivityFuncValue3"])
    self:SetResDropActivityFuncValue(4, kRetData["kFuncInfo"]["dwResDropActivityFuncValue4"])
    self:SetResDropActivityFuncValue(5, kRetData["kFuncInfo"]["dwResDropActivityFuncValue5"])
    ResDropActivityDataManager:GetInstance():SetCurResDropCollectActivityID(kRetData["kFuncInfo"]["dwCurResDropCollectActivity"])

    self:SetTreasureExchangeValue(1, kRetData["kFuncInfo"]["dwTreaSureExchangeValue1"])
    self:SetTreasureExchangeValue(2, kRetData["kFuncInfo"]["dwTreaSureExchangeValue2"])

    self:SetFestivalValue(1, kRetData["kFuncInfo"]["dwFestivalValue1"])
    self:SetFestivalValue(2, kRetData["kFuncInfo"]["dwFestivalValue2"])

    self:SetTongLingYuValue(kRetData["kFuncInfo"]["dwTongLingYu"])
    
    self:SetPlayerName(kRetData["kAppearanceInfo"]["acPlayerName"])
    self:SetTitleID(kRetData["kAppearanceInfo"]["dwTitleID"])
    self:SetPaintingID(kRetData["kAppearanceInfo"]["dwPaintingID"])
    self:SetModelID(kRetData["kAppearanceInfo"]["dwModelID"])
    self:SetBackGroundID(kRetData["kAppearanceInfo"]["dwBackGroundID"])
    self:SetBGMID(kRetData["kAppearanceInfo"]["dwBGMID"])
    self:SetPoetryID(kRetData["kAppearanceInfo"]["dwPoetryID"])
    self:SetPedestalID(kRetData["kAppearanceInfo"]["dwPedestalID"])
    self:SetShowRoleID(kRetData["kAppearanceInfo"]["dwShowRoleID"])
    self:SetShowPetID(kRetData["kAppearanceInfo"]["dwShowPetID"])
    self:SetLoginWordID(kRetData["kAppearanceInfo"]["dwLoginWordID"])
    self:SetHeadBoxID(kRetData["kAppearanceInfo"]["dwHeadBoxID"])
    self:SetLandLadyID(kRetData["kAppearanceInfo"]["dwLandLadyID"])

    -- 掌门对决门票
    self:SetZmFreeTicket(kRetData["kFuncInfo"]["dwZmFreeTickets"])
    self:SetZmTicket(kRetData["kFuncInfo"]["dwZmTickets"])
    self:SetZmNewFlag(kRetData["kFuncInfo"]["bZmNewFlag"])
end

function PlayerSetDataManager:ModifyPlayerAppearance(kRetData)
    local type = kRetData["eModifyType"]
    if type == SMPAT_NAME then
        self:SetPlayerName(kRetData["acChangeParam"])
    elseif type == SMPAT_TITLE then
        self:SetTitleID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_PAINTING then
        self:SetPaintingID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_MODEL then
        self:SetModelID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_BACKGROUND then
        self:SetBackGroundID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_BGM then
        self:SetBGMID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_POETRY then
        self:SetPoetryID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_PEDESTAL then
        self:SetPedestalID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_SHOWROLE then
        self:SetShowRoleID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_LOGINWORD then
        self:SetLoginWordID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_HEADBOX then
        self:SetHeadBoxID(tonumber(kRetData["acChangeParam"]))
    elseif type == SMPAT_LANDLADY then
        self:SetLandLadyID(tonumber(kRetData["acChangeParam"]))
    else
        dprint("无效修改"..type)
    end
end

function PlayerSetDataManager:getCurrencyToast(type,offset)
    local CurrencyName = {
        [STLMT_GOLD] = '金锭',
        [STLMT_SILVER] = '银锭',
        [STLMT_DRINK] = '擂台币',
        [STLMT_PLATFORMSCORE] = '平台积分',
        [STLMT_ACTIVEFORMSCORE] = '活动积分',
        [STLMT_TREASURE] = '百宝书残页',
        [STLMT_SECONDGOLD] = '旺旺币',
        [STLMT_HOODLESCORE] = '恶霸头巾',
    }
    local strText = '';
    if offset ~= 0 and CurrencyName[type] then
        strText = CurrencyName[type] .. (offset > 0 and ' +' or ' -') .. math.abs(offset);
    end
    return strText;
end

function PlayerSetDataManager:setIsShowGoldTips(bShow)
    self.bShowGoldTips = bShow;
end

function PlayerSetDataManager:UpdateCurrency(kRetData)
    local offset = 0;
    local type = kRetData["eMoneyType"]
    if type == STLMT_GOLD then
        offset = kRetData.dwCurNum - self:GetPlayerGold();
        self:SetPlayerGold(kRetData["dwCurNum"])
    elseif type == STLMT_SILVER then
        offset = kRetData.dwCurNum - self:GetPlayerSliver();
        self:SetPlayerSliver(kRetData["dwCurNum"])
    elseif type == STLMT_DRINK then
        offset = kRetData.dwCurNum - self:GetPlayerDrinkMoney();
        self:SetPlayerDrinkMoney(kRetData["dwCurNum"])
    elseif type == STLMT_PLATFORMSCORE then
        offset = kRetData.dwCurNum - self:GetPlayerPlatScore();
        self:SetPlayerPlatScore(kRetData["dwCurNum"])
    elseif type == STLMT_ACTIVEFORMSCORE then
        offset = kRetData.dwCurNum - self:GetPlayerActiveScore();
        self:SetPlayerActiveScore(kRetData["dwCurNum"])
    elseif type == STLMT_SECONDGOLD then
        offset = kRetData.dwCurNum - self:GetPlayerSecondGold();
        self:SetPlayerSecondGold(kRetData["dwCurNum"])
        LuaEventDispatcher:dispatchEvent("UPDATE_LIMITSHOP_BUTTON")
    elseif type == STLMT_TREASURE then
        local baseInfo = TreasureBookDataManager:GetInstance():GetTreasureBookBaseInfo() or {};
        offset = kRetData.dwCurNum - baseInfo.iMoney or 0;
    elseif type == STLMT_HOODLESCORE then
        offset = kRetData.dwCurNum - self:GetHoodleScore();
        self:SetHoodleScore(kRetData["dwCurNum"])
    end

    local showTips = true;
    if type == STLMT_GOLD then
        showTips = self.bShowGoldTips;
        self.bShowGoldTips = true;
    end

    local strText = self:getCurrencyToast(type,offset)
    if showTips and strText ~= '' then
        SystemUICall:GetInstance():Toast(strText, false);
    end
end

function PlayerSetDataManager:GetResourcePictureTB()
    local tbl_PlayerInfoPicture = TB_PlayerInfoData[PlayerInfoType.PIT_PAINT][self.appearanceInfo.paintingID]
    if tbl_PlayerInfoPicture and tbl_PlayerInfoPicture.ResourceID then
        return TableDataManager:GetInstance():GetTableData("ResourceRolePicture",tbl_PlayerInfoPicture.ResourceID)
    end

    return nil
end

function PlayerSetDataManager:GetRescouceModelTB()
    local tbl_PlayerInfoModel = TB_PlayerInfoData[PlayerInfoType.PIT_MODEL][self.appearanceInfo.modelID]
    if tbl_PlayerInfoModel and tbl_PlayerInfoModel.ResourceID then
        return TableDataManager:GetInstance():GetTableData("ResourceRoleModel",tbl_PlayerInfoModel.ResourceID)
    end

    return nil
end

function PlayerSetDataManager:GetRescouceCGTB()
    local tbl_PlayerInfoCG = TB_PlayerInfoData[PlayerInfoType.PIT_CG][self.appearanceInfo.backGroundID]
    if tbl_PlayerInfoCG and tbl_PlayerInfoCG.ResourceID then
        return TableDataManager:GetInstance():GetTableData("ResourceCG",tbl_PlayerInfoCG.ResourceID)
    end

    return nil
end

function PlayerSetDataManager:SetPlayerName(PlayerName)
    self.strRawName = PlayerName
    if (not self.reNameNum) or (self.reNameNum == 0) then
        self.appearanceInfo.playerName = string.format("%s%d", STR_ACCOUNT_DEFAULT_PREFIX or "", self.playerID or 0)
    else
        self.appearanceInfo.playerName = PlayerName
    end
    -- 如果当前在酒馆, 刷新一下酒馆的名字
    local houseWin = GetUIWindow("HouseUI")
    if houseWin then
        houseWin:UpdateRoleName()
    end
    -- 改名成功后需要重新登录讨论社区更改昵称
    if DiscussDataManager:GetInstance():DiscussAreaOpen() then
        DiscussDataManager:GetInstance():ReLogin()
    end
end

function  PlayerSetDataManager:GetPlayerName(bIsRaw)
    local retName = nil
    if bIsRaw then
        retName = self.strRawName
    elseif self.appearanceInfo then
        retName = self.appearanceInfo.playerName
    end
    
    if (not retName) or (retName == "") then
        retName = string.format("%s%d", STR_ACCOUNT_DEFAULT_PREFIX or "", self.playerID or 0)
    end

    return retName
end

function PlayerSetDataManager:SetTitleID(TitleID)
    self.appearanceInfo.titleID = TitleID
end

function PlayerSetDataManager:SetPaintingID(PaintingID)
    self.appearanceInfo.paintingID = PaintingID
end

function PlayerSetDataManager:SetModelID(ModelID)
    self.appearanceInfo.modelID = ModelID
end

function PlayerSetDataManager:SetTencentCreditScore(TencentCreditScore)
    self.appearanceInfo.TencentCreditScore = TencentCreditScore
end

function PlayerSetDataManager:SetTXCreditSceneLimit(bresult)
    self.appearanceInfo.TXCreditSceneLimit = bresult
end
function PlayerSetDataManager:GetTXCreditSceneLimit(eType)
    -- TencentCreditScoreSceneLimitSystem 
    -- TCSSLS_WORLD_CHAT = 1                   --世界聊天
    -- TCSSLS_PRIVATE_CHAT = 2                 --私聊
    -- TCSSLS_APPLY_FRIENDS = 3                --申请加他人为好友
    -- TCSSLS_CHALLENGE = 4                    --切磋
    -- TCSSLS_ARENA_SIGNUP = 5                 --报名擂台赛
    -- TCSSLS_RANKLIST = 6                     --上排行榜


    -- true 允许/信用分够 false 不允许/信用分不够 
    if self.appearanceInfo.TXCreditSceneLimit then 
        for i,item in pairs(self.appearanceInfo.TXCreditSceneLimit) do 
            if eType == item.uiKey then 
                return item.uiValue == 1 
            end 
        end 
    end  
    return true 
end
function PlayerSetDataManager:GetTencentCreditScore()
    if not self.appearanceInfo.TencentCreditScore or self.appearanceInfo.TencentCreditScore == 0 then 
        RequestTencentCreditScore()
        return 0
    end 
    return self.appearanceInfo.TencentCreditScore
end

function PlayerSetDataManager:GetModelID()
    if not self.appearanceInfo then
        return 0
    end
    return self.appearanceInfo.modelID or 0
end

function PlayerSetDataManager:SetBackGroundID(BackGroundID)
    self.appearanceInfo.backGroundID = BackGroundID
end

function PlayerSetDataManager:SetBGMID(BGMID)
    self.appearanceInfo.bgmID = BGMID
end

function PlayerSetDataManager:SetPoetryID(PoetryID)
    self.appearanceInfo.poetryID = PoetryID
end

function PlayerSetDataManager:SetPedestalID(PedestalID)
    PedestalID = PedestalID == 0 and 10060001 or PedestalID;
    self.appearanceInfo.pedestalID = PedestalID
end

function PlayerSetDataManager:SetShowRoleID(ShowRoleID)
    self.appearanceInfo.showRoleID = ShowRoleID
end

function PlayerSetDataManager:SetShowPetID(ShowPetID)
    self.appearanceInfo.showPetID = ShowPetID
end

function PlayerSetDataManager:SetLoginWordID(LoginWordID)
    self.appearanceInfo.loginWordID = LoginWordID
end

function PlayerSetDataManager:SetLandLadyID(LandLadyID)
    self.appearanceInfo.LandLadyID = LandLadyID
    LuaEventDispatcher:dispatchEvent("UPDATE_LANDLADY")
end
function PlayerSetDataManager:GetLandLadyID()
    return self.appearanceInfo.LandLadyID or 1
end

function PlayerSetDataManager:SetHeadBoxID(HeadBoxID)
    self.appearanceInfo.HeadBoxID = HeadBoxID
    LuaEventDispatcher:dispatchEvent("UPDATE_HEADBOX")
end

function PlayerSetDataManager:GetHeadBoxID()
    return self.appearanceInfo.HeadBoxID or 0 
end
function PlayerSetDataManager:SetCreateTime(createTime)
    self.appearanceInfo.createTime = createTime
end

function PlayerSetDataManager:GetCreateTime()
    return self.appearanceInfo.createTime;
end

function PlayerSetDataManager:SetLastLogoutTime(lastLogoutTime)
    self.appearanceInfo.lastLogoutTime = lastLogoutTime
end

function PlayerSetDataManager:GetLastLogoutTime()
    return self.appearanceInfo.lastLogoutTime;
end

function PlayerSetDataManager:SetChallengeWinTimes(challengeWinTimes)
    self.commonInfo.challengeWinTimes = challengeWinTimes
end

function PlayerSetDataManager:SetSex(Sex)
    self.commonInfo.sex = Sex
end

function PlayerSetDataManager:SetRemainWordNum(RemainWordNum)
    self.commonInfo.remainWordNum = RemainWordNum
end

function PlayerSetDataManager:SetCharPictureUrl(charPicUrl)
    self.commonInfo.charPicUrl = charPicUrl
end

function PlayerSetDataManager:GetCharPictureUrl()
    return self.commonInfo.charPicUrl
end

function PlayerSetDataManager:SetMeridianTotalLvl(MeridianTotalLvl)
    self.commonInfo.meridianTotalLvl = MeridianTotalLvl
end

function PlayerSetDataManager:GetMeridianTotalLvl()
    return self.commonInfo.meridianTotalLvl or 0
end

function PlayerSetDataManager:SetWeekRoundTotalNum(WeekRoundTotalNum)
    self.commonInfo.weekRoundTotalNum = WeekRoundTotalNum
end

function PlayerSetDataManager:SetAchieveTotalNum(AchieveTotalNum)
    self.commonInfo.achieveTotalNum = AchieveTotalNum
end

function PlayerSetDataManager:SetALiveDays(ALiveDays)
    self.commonInfo.aLiveDays = ALiveDays
end

function PlayerSetDataManager:GetALiveDays()
    if not self.commonInfo then
        return 0
    end
    return self.commonInfo.aLiveDays or 0
end

function PlayerSetDataManager:SetNormalHighTowerMaxNum(value)
    self.commonInfo.dwNormalHighTowerMaxNum = value
end

function PlayerSetDataManager:SetBloodHighTowerMaxNum(value)
    self.commonInfo.dwBloodHighTowerMaxNum = value
end

function PlayerSetDataManager:SetRegimentHighTowerMaxNum(value)
    self.commonInfo.dwRegimentHighTowerMaxNum = value
end

function PlayerSetDataManager:SetPlayerID(PlayerID)
    self.playerID = PlayerID
end

function PlayerSetDataManager:SetReNameNum(ReNameNum)
    self.reNameNum = ReNameNum
end

function PlayerSetDataManager:SetLuckyValue(value)
    self.luckyvalue = value
end

function PlayerSetDataManager:SetLowInCompleteTextNum(Num)
    self.lowInCompleteTextNum = Num;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetLowInCompleteTextNum()
    return self.lowInCompleteTextNum or 0;
end

function PlayerSetDataManager:SetMidInCompleteTextNum(Num)
    self.midInCompleteTextNum = Num;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetMidInCompleteTextNum()
    return self.midInCompleteTextNum or 0;
end

function PlayerSetDataManager:SetHighInCompleteTextNum(Num)
    self.highInCompleteTextNum = Num;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:SetLucyValue(num)
    self.luckyvalue = num or 0
end
function PlayerSetDataManager:GetLuckyValue(uiStoryID)
    if (not uiStoryID or uiStoryID == 0) then
      return self.luckyvalue or 0
    end
    local playerinfo = globalDataPool:getData("PlayerInfo")
    if not playerinfo then return 0 end	-- 单机没有 info 数据
    for i = 0, playerinfo.iSize - 1 do
      if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
        if (playerinfo.kUnlockScriptInfos[i].acMainRoleName == nil) or (playerinfo.kUnlockScriptInfos[i].eStateType == SSS_NULL) then
          return self.luckyvalue or 0
        else
          return playerinfo.kUnlockScriptInfos[i]["dwScriptLucyValue"] or self.luckyvalue or 0
        end
        
      end
    end	

    return self.luckyvalue or 0
end

function PlayerSetDataManager:GetHighInCompleteTextNum()
    return self.highInCompleteTextNum or 0;
end

-- 金砖
function PlayerSetDataManager:SetPlayerGold(PlayerGold)
    if not self.firstSetGold and PlayerGold > self.playerGold then 
        SystemUICall:GetInstance():PlayGoldAnim(self.playerGold, PlayerGold, GOLD_ANIM.GOLD)
    end
    self.firstSetGold = false
    self.playerGold = PlayerGold

    LuaEventDispatcher:dispatchEvent("UPDATE_PLAYER_GOLD")
end

-- 银锭
function PlayerSetDataManager:SetPlayerSliver(PlayerSliver)
    local iOldSliverNum = self.playerSliver
    self.playerSliver = PlayerSliver
    self.firstSetSliver = false
    -- 如果有地方设置跳过, 那么不显示动画
    if (not self.firstSetSliver) and (PlayerSliver > iOldSliverNum) then 
        if self.bSkipGoldAnim == true then
            self.bSkipGoldAnim = nil
            return
        end
        SystemUICall:GetInstance():PlayGoldAnim(iOldSliverNum, PlayerSliver, GOLD_ANIM.SLIVER)
    end
end

function PlayerSetDataManager:SetPlayerDrinkMoney(value)
    self.playerDrinkMoney = value;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:SetPlayerPlatScore(value)
    self.playerPlatScore = value;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:SetPlayerActiveScore(value)
    self.playerActiveScore = value;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:SetPlayerSecondGold(value)
    self.playerSecondGold = value;
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end
function PlayerSetDataManager:SetChallengeOrderType(value)
    self.challengeOrderType = value;
end

function PlayerSetDataManager:SetLoginDayNum(value)
    self.loginDayNum = value;
end

function PlayerSetDataManager:GetPlayerDrinkMoney()
    return self.playerDrinkMoney;
end

function PlayerSetDataManager:GetPlayerPlatScore()
    return self.playerPlatScore;
end

function PlayerSetDataManager:GetPlayerActiveScore()
    return self.playerActiveScore;
end

function PlayerSetDataManager:GetPlayerSecondGold()
    return self.playerSecondGold or 0;
end

function PlayerSetDataManager:GetChallengeOrderType()
    return self.challengeOrderType
end

function PlayerSetDataManager:GetLoginDayNum()
    return self.loginDayNum
end

function PlayerSetDataManager:IsChallengeOrderUnlock()
    return true
end

function PlayerSetDataManager:GetCommonInfo()
    return self.commonInfo
end

function PlayerSetDataManager:GetAppearanceInfo()
    return self.appearanceInfo
end

function PlayerSetDataManager:GetPlayerID()
    return self.playerID
end

function PlayerSetDataManager:GetReNameNum()
    return self.reNameNum
end

function PlayerSetDataManager:GetPlayerGold()
    return self.playerGold
end

function PlayerSetDataManager:GetPlayerSliver()
    return self.playerSliver
end

function PlayerSetDataManager:DisableCoinAnim()
    self.noGoldGetAnim = true
end

function PlayerSetDataManager:EnableCoinAnim()
    self.noGoldGetAnim = false
end

-- 铜币
function PlayerSetDataManager:SetPlayerCoin(coin)
    --TODO: 将增多和减少统一为一个
    -- 铜币增多 播放UI动画
    if not self.firstSetCoin and coin > self.playerCoin and self.noGoldGetAnim == false then 
        SystemUICall:GetInstance():PlayGoldAnim(self.playerCoin, coin, GOLD_ANIM.COIN)
    end
    --铜币减少 播放UI动画
    if  coin < self.playerCoin then
        local toptitle = GetUIWindow("ToptitleUI")
        if toptitle then
            toptitle:PlayTongbiAnim(self.playerCoin, coin)
        end
    end
    self.playerCoin = coin
    self.firstSetCoin = false
end

function PlayerSetDataManager:GetPlayerCoin()
    return self.playerCoin;
end

-- 完美粉
function PlayerSetDataManager:SetPlayerPerfectPowder(iCount)
    self.playerPerfectPowder = iCount or 0
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetPlayerPerfectPowder(iCount)
    return self.playerPerfectPowder
end

-- 精铁
function PlayerSetDataManager:SetPlayerRefinedIron(iCount)
    self.playerRefinedIron = iCount or 0
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetPlayerRefinedIron(iCount)
    return self.playerRefinedIron
end

-- 天工锤
function PlayerSetDataManager:SetPlayerHeavenHammer(iCount)
    self.playerHeavenHammer = iCount or 0
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetPlayerHeavenHammer()
    return self.playerHeavenHammer 
end

-- 忘忧草
function PlayerSetDataManager:SetPlayerWangyoucao(iCount)
    self.playerWangyoucao = iCount or 0
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetPlayerWangyoucao()
    -- 获取背包主角背包中忘忧草数量
    return ItemDataManager:GetInstance():GetItemNumByTypeID(9626)
    --return self.playerWangyoucao or 0
end

-- 掌门对决门票
function PlayerSetDataManager:SetZmFreeTicket(iCount)
    self.zmFreeTicket = iCount
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end
function PlayerSetDataManager:GetZmFreeTicket()
    return self.zmFreeTicket or 0
end
function PlayerSetDataManager:SetZmTicket(iCount)
    self.zmTicket = iCount
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end
function PlayerSetDataManager:GetZmTicket()
    return self.zmTicket or 0
end
function PlayerSetDataManager:SetZmNewFlag(bFlag)
    self.zmNewFlag = bFlag == 1
end
function PlayerSetDataManager:GetZmNewFlag()
    return self.zmNewFlag or false
end
-- 武学空白书
function PlayerSetDataManager:SetMakeMartialSecretBook(iCount)
    self.martialSecretBook = iCount or 0
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetMakeMartialSecretBook()
    return self.martialSecretBook or 0
end
-- 
function PlayerSetDataManager:SetNormalStage(iCount)
    self.normalStage = iCount or 0;
end

function PlayerSetDataManager:GetNormalStage()
    return self.normalStage or 0;
end

-- 
function PlayerSetDataManager:SetBloodStage(iCount)
    self.bloodStage = iCount or 0;
end

function PlayerSetDataManager:GetBloodStage()
    return self.bloodStage or 0;
end

-- 
function PlayerSetDataManager:SetRegimentStage(iCount)
    self.regimentStage = iCount or 0;
end

function PlayerSetDataManager:GetRegimentStage()
    return self.regimentStage or 0;
end

-- 刷新球
function PlayerSetDataManager:SetPlayerRefreshBall(iCount)
    self.playerRefreshBall = iCount or 0
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function PlayerSetDataManager:GetPlayerRefreshBall()
    -- 获取背包主角背包中刷新球数量
    return ItemDataManager:GetInstance():GetItemNumByTypeID(9698)
    --return self.playerRefreshBall or 0
end

-- 夺宝积分
function PlayerSetDataManager:SetHoodleScore(iScore)
    self.playerHoodleScore = iScore or 0
    LuaEventDispatcher:dispatchEvent("UPDATE_HOODLE_SERVER_PLAY_SCORE")
end

function PlayerSetDataManager:GetHoodleScore()
    return self.playerHoodleScore or 0
end

-- 设置仓库扩容带入格子
function PlayerSetDataManager:SetPlayerDilatationNum(iCount)
    self.playerDilatationNum = iCount or 0
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_BUYTAKE');
end

function PlayerSetDataManager:GetPlayerDilatationNum()
    return self.playerDilatationNum or 0
end

-- 商店金锭打赏记录时间
function PlayerSetDataManager:SetShopGoldRewadTime(iTime)
    self.ShopGoldRewadTime = iTime or 0
end

function PlayerSetDataManager:GetShopGoldRewadTime()
    return self.ShopGoldRewadTime or 0
end

-- 羁绊丹
function PlayerSetDataManager:SetBondPellet(iCount)
    self.iBondPellet = iCount or 0
end

function PlayerSetDataManager:GetBondPellet()
    return self.iBondPellet or 0
end
-- 商店广告打赏记录时间
function PlayerSetDataManager:SetShopAdRewadTime(iTime)
    self.ShopAdRewadTime = iTime or 0
end

function PlayerSetDataManager:GetShopAdRewadTime()
    return self.ShopAdRewadTime or 0
end
-- 获取当前开启的最高难度，和单一玩家无关
-- 遍历剧本表，找出最高的开启难度，用于平台统一使用
function PlayerSetDataManager:GetDifficultOpenMax()
    if not self.iDifficultMax then 
        local iMaxDiff = 0
        local TB_Story = TableDataManager:GetInstance():GetTable("Story")
        for iIndex,story in pairs(TB_Story) do
            iMaxDiff = math.max(iMaxDiff,story.DifficultMax)
        end 
        self.iDifficultMax = iMaxDiff 
    end 
    return self.iDifficultMax
end

--设置玩家完整版开通基金标记
function PlayerSetDataManager:SetFundAchieveOpen(iValue)
    self.FundAchieveOpen = iValue or 0
end

function PlayerSetDataManager:GetFundAchieveOpen()
    return self.FundAchieveOpen or 0
end

--设置玩家红包领取次数
function PlayerSetDataManager:SetRedPacketGetTimes(iValue,bShowToast)
    self.RedPacketGetTimes = iValue or 0
    if bShowToast and self.RedPacketGetTimes > 0 then
        local msg = string.format("这是今天第[%d]次抢红包，每日最多%d次", self.RedPacketGetTimes,SSD_MAX_GETREDPACKETTIMES);
        SystemUICall:GetInstance():Toast(msg);
    end
end

function PlayerSetDataManager:GetRedPacketGetTimes()
    return self.RedPacketGetTimes or 0
end

function PlayerSetDataManager:SetDailyRewardState(iState)
    self.dailyRewardState = iState or 0
end

function PlayerSetDataManager:GetDailyRewardState(iState)
    return self.dailyRewardState or 0
end

function PlayerSetDataManager:SetCreatRoleID(RoleID)
    self.creatRoleID = RoleID or 0
end

function PlayerSetDataManager:GetCreatRoleID()
    return self.creatRoleID or 0
end

function PlayerSetDataManager:SetPlayerForbidInfo(bAdd,data,iNum)
    if bAdd > 0 then
        self.forBidInfo = self.forBidInfo or {}
        local bFind = false;
        for index = 1, #self.forBidInfo do
            if self.forBidInfo[index].eSeForBidType == data[0].eSeForBidType then
                self.forBidInfo[index] = data[0];
                bFind = true;
                break
            end
        end

        if not bFind then
            table.insert(self.forBidInfo,data[0]);
        end
    else
        self.forBidInfo = {}
        for index = 1, iNum do
            table.insert(self.forBidInfo,data[index-1]);
        end
    end
end

function PlayerSetDataManager:GetForbidByType(forbidType)
    if not self.forBidInfo then
        return nil;
    end
    for index = 1, #self.forBidInfo do
        local info = self.forBidInfo[index]
        if info and info.eSeForBidType == forbidType then
            return info
        end
    end
    return nil
end


-- 解锁返回酒馆功能
function PlayerSetDataManager:SetUnlockHouseState(iState, iRenameTimes)
    self.bRetuenHouseUnlock = (iState == 1 or iRenameTimes > 0)
end

function PlayerSetDataManager:GetUnlockHouseState()
    return (self.bRetuenHouseUnlock == true)
end

-- 引导模式标记
function PlayerSetDataManager:SetGuideModeFlag(bIsGuideMode)
    self.bIsGuideMode = (bIsGuideMode == true)
end

function PlayerSetDataManager:GetGuideModeFlag()
    return (self.bIsGuideMode == true)
end

-- 新门派签到活动标记
function PlayerSetDataManager:SetSignInFlag(signInFlag)
    self.signInFlag = signInFlag
end

function PlayerSetDataManager:GetSignInFlag()
    return self.signInFlag
end

function PlayerSetDataManager:SetServerOpenTime(openTime)
    self.openTime = openTime;
end

function PlayerSetDataManager:GetServerOpenTime()
    if self.openTime and self.openTime > 0 then
        return self.openTime;
    end
    return os.time();
end

-- 开启金锭消费保护
function PlayerSetDataManager:OpenBanSpendGoldAction(uiSecs)
    self.bBanSpendGoldAction = true
    local uiBanTimeSec = uiSecs or 3  -- 默认冷却时间: 3s
    self.uiBanSpendGoldActionStamp = os.time() + uiBanTimeSec
    if self.iBanSpendGoldTimer then
        globalTimer:RemoveTimer(self.iBanSpendGoldTimer)
        self.iBanSpendGoldTimer = nil
    end
    self.iBanSpendGoldTimer = globalTimer:AddTimer(uiBanTimeSec * 1000, function()
        PlayerSetDataManager:GetInstance().bBanSpendGoldAction = false
        PlayerSetDataManager:GetInstance().uiBanSpendGoldActionStamp = nil
    end)
end

-- 关闭金锭消费保护
function PlayerSetDataManager:CloseBanSpendGoldAction()
    self.bBanSpendGoldAction = false
    if self.iBanSpendGoldTimer then
        globalTimer:RemoveTimer(self.iBanSpendGoldTimer)
        self.iBanSpendGoldTimer = nil
    end
    self.uiBanSpendGoldActionStamp = nil
end

-- 检查就金锭消费保护状态
function PlayerSetDataManager:CheckBanSpendGoldAction(bToast)
    if self.bBanSpendGoldAction ~= true then
        return true
    end
    if bToast ~= false then
        local strMsg = "消费操作冷却中, "
        local iTimeStampOffset = 0
        if self.uiBanSpendGoldActionStamp and (self.uiBanSpendGoldActionStamp > 0) then
            iTimeStampOffset = self.uiBanSpendGoldActionStamp - os.time()
        end
        if iTimeStampOffset > 0 then
            strMsg = strMsg .. string.format("请于%s秒后再试", tostring(iTimeStampOffset))
        else
            strMsg = strMsg .. "请稍后再试"
        end
        SystemUICall:GetInstance():Toast(strMsg)
    end
    return false
end

-- 申请消费金锭
function PlayerSetDataManager:RequestSpendGold(iGoldNum, callback, bSecondCofirm, confirmMsg, uiAotoCloseProtectSecs)
    -- 消费冷却
    if not self:CheckBanSpendGoldAction(true) then
        return
    end
    -- 开启冷却计时器
    self:OpenBanSpendGoldAction(uiAotoCloseProtectSecs)
    -- 消费逻辑
    iGoldNum = math.max(iGoldNum or 0, 0)  -- 需要花费的金锭数
    local iGoldRemain = self:GetPlayerGold() or 0  -- 金锭剩余
    local iGoldOutOfPhase = iGoldNum - iGoldRemain  -- 金锭不够的部分
    if iGoldOutOfPhase > 0 then
        local msg = string.format("账户余额不足, 还差%d金锭, 点击确定前往充值界面", iGoldOutOfPhase)
        local boxCallback = function()
            OpenWindowImmediately("ShoppingMallUI")
            local win = GetUIWindow("ShoppingMallUI")
            if win then 
                win:SetPayTag()
            end
            --SystemUICall:GetInstance():Toast("暂未开放充值!")
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
        return
    end
    -- 执行操作
    local boxCallback2 = function()
        if not callback then
            return
        end
        callback()
    end
    -- 二次确认框
    if (bSecondCofirm) then
        local msg2 = confirmMsg or string.format("点击确认扣除%d金锭", iGoldNum)
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg2, boxCallback2})
    else
        boxCallback2()
    end

end

-- 申请消费银锭
function PlayerSetDataManager:RequestSpendSilver(iSilverNum, callback)
    iSilverNum = math.max(iSilverNum or 0, 0)  -- 需要花费的银锭数
    local iSilverRemain = self:GetPlayerSliver() or 0  -- 银锭剩余
    local iSilverOutOfPhase = iSilverNum - iSilverRemain  -- 银锭不够的部分
    if iSilverOutOfPhase > 0 then
        local iGoldNeedToExchange = math.ceil(iSilverOutOfPhase / 10)  -- 用于转化银锭的金锭数
        local iSilverMorePartAfterExchange = iGoldNeedToExchange * 10 - iSilverOutOfPhase  -- 金锭换银锭之后多出的部分
        local msg = string.format("银锭不足, 还差%d银锭,\n是否使用%d金锭代替?", iSilverOutOfPhase, iGoldNeedToExchange)
        if iSilverMorePartAfterExchange > 0 then
            msg = msg..string.format("\n(额外兑换的%d银锭会进入帐号)", iSilverMorePartAfterExchange)
        end
        local requestSpendGoldCallback = function()
            -- the callback will be run and cleared as soon as cmd <gold -> silver> is over
            self.silverExchangeCacheCallBack = callback
            self.bSkipGoldAnim = true  -- 跳过金锭转银锭动画
            SendExchangeGoldToSilver(iGoldNeedToExchange)
        end
        local boxCallback = function()
            PlayerSetDataManager:GetInstance():RequestSpendGold(iGoldNeedToExchange, requestSpendGoldCallback)
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
        return
    end
    -- 执行操作
    if callback then
        callback()
    end
end

-- 申请消费银锭, 带有金锭转化不再提示检查框
function PlayerSetDataManager:RequestSpendSilverWithTransCheckBox(iSilverNum, strCheckKey, callback)
    if (not strCheckKey) or (strCheckKey == "") then
        return
    end
    iSilverNum = math.max(iSilverNum or 0, 0)  -- 需要花费的银锭数
    local iSilverRemain = self:GetPlayerSliver() or 0  -- 银锭剩余
    local iSilverOutOfPhase = iSilverNum - iSilverRemain  -- 银锭不够的部分
    if iSilverOutOfPhase > 0 then
        local iGoldNeedToExchange = math.ceil(iSilverOutOfPhase / 10)  -- 用于转化银锭的金锭数

        local requestSpendGoldCallback = function()
            -- the callback will be run and cleared as soon as cmd <gold -> silver> is over
            self.silverExchangeCacheCallBack = callback
            self.bSkipGoldAnim = true  -- 跳过金锭转银锭动画
            SendExchangeGoldToSilver(iGoldNeedToExchange)
        end

        local bDontNoticeLater = GetConfig(strCheckKey) == true
        if bDontNoticeLater then
            PlayerSetDataManager:GetInstance():RequestSpendGold(iGoldNeedToExchange, requestSpendGoldCallback)
            return
        end

        local iSilverMorePartAfterExchange = iGoldNeedToExchange * 10 - iSilverOutOfPhase  -- 金锭换银锭之后多出的部分
        local msg = string.format("银锭不足, 还差%d银锭,\n是否使用%d金锭代替?", iSilverOutOfPhase, iGoldNeedToExchange)
        if iSilverMorePartAfterExchange > 0 then
            msg = msg..string.format("\n(额外兑换的%d银锭会进入帐号)", iSilverMorePartAfterExchange)
        end
        local content = {
            ['title'] = "银锭不足",
            ['text'] = msg,
            ['checkBox'] = "以后不再提醒",
            ['bCheckBox'] = false,
            ['btnType'] = "gold",
            ['btnText'] = "使用金锭",
            ['num'] = iGoldNeedToExchange,
        }
        local boxCallback = function()
            PlayerSetDataManager:GetInstance():RequestSpendGold(iGoldNeedToExchange, requestSpendGoldCallback)
            -- 记录 以后不再提示
            local win = GetUIWindow("GeneralBoxUI")
            if not win then
                return
            end
            local bDontNoticeLater = win:GetCheckBoxState() == true
            SetConfig(strCheckKey, bDontNoticeLater)
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.Pay_TIP, content, boxCallback})
        return
    end
    -- 执行操作
    if callback then
        callback()
    end
end

function PlayerSetDataManager:ClearSilverExchangeCallBack()
    self.silverExchangeCacheCallBack = nil
end

function PlayerSetDataManager:DoSilverExchangeCallBack()
    if not self.silverExchangeCacheCallBack then
        return
    end
    self.silverExchangeCacheCallBack()
    self.silverExchangeCacheCallBack = nil
end

--
function PlayerSetDataManager:InitPlayerInfoData()
    TB_PlayerInfoData = {}
    local TB_PlayerInfo = TableDataManager:GetInstance():GetTable("PlayerInfo")

    for k, v in pairs(TB_PlayerInfo)do
        if not TB_PlayerInfoData[v.Type] then
            TB_PlayerInfoData[v.Type] = {};
        end

        TB_PlayerInfoData[v.Type][v.BaseID] = v;
    end
end

function PlayerSetDataManager:GetPlayerInfoData(type, id)
    if TB_PlayerInfoData then
        for k, v in pairs(TB_PlayerInfoData[type]) do
            if v.UnlockID == tonumber(id) then
                return v;
            end
        end
    end

    return nil;
end

-- 设置当前状态为正在跳转剧本
function PlayerSetDataManager:SetChangingScript(iTarScriptID)
    self.iChangingScript = iTarScriptID
end

-- 当前是否正在跳转剧本
function PlayerSetDataManager:GetChangingScript()
    local bIsChanging = (self.iChangingScript ~= nil)
    return bIsChanging, self.iChangingScript
end

-- 标记登录标记
function PlayerSetDataManager:SetLoginFlag(bOn)
    self.bLoginFlagOn = (bOn == true)
end

-- 获取登录标记
function PlayerSetDataManager:GetLoginFlag()
    return (self.bLoginFlagOn == true)
end

-- 记录用户登录失败
function PlayerSetDataManager:RecordLoginFail()
    self.iCurLoginFailTime = (self.iCurLoginFailTime or 0) + 1
    local iAllowLoginTimeStamp = nil
    local iCurTimeStame = os.time()
    -- 连续登录失败六次, 5min后重试
    if self.iCurLoginFailTime >= 6 then
        iAllowLoginTimeStamp = iCurTimeStame + 5 * 60
        -- 5分钟后, 如果还是登录失败, 那么算第三次
        self.iCurLoginFailTime = 2
    -- 连续登录失败三次, 10s后重试
    elseif self.iCurLoginFailTime >= 3 then
        iAllowLoginTimeStamp = iCurTimeStame + 10
    end
    if iAllowLoginTimeStamp and (iAllowLoginTimeStamp > 0) then
        self:SetForbidLoginState(iAllowLoginTimeStamp)
    end
end

-- 设置禁止登录状态
function PlayerSetDataManager:SetForbidLoginState(iReOpenLoginTime)
    if (not iReOpenLoginTime) or (iReOpenLoginTime <= 0) then
        return
    end
    self.iReopenLoginTime = iReOpenLoginTime
    -- 将时间存一下Config, 重登回来也要恢复
    SetConfig("ReopenLoginTime", iReOpenLoginTime, true)
end

-- 清空禁止登录数据, 只能在登录成功时候调用
function PlayerSetDataManager:ClearForbidLoginData()
    self.iReopenLoginTime = nil
    SetConfig("ReopenLoginTime", 0, true)
end

-- 检查是否可登录
function PlayerSetDataManager:CheckIfCanLogin()
    if (not self.iReopenLoginTime) or (self.iReopenLoginTime == 0) then
        self.iReopenLoginTime = (GetConfig("ReopenLoginTime") or 0)
    end
    local iCurStamp = os.time()
    local iDelta = self.iReopenLoginTime - iCurStamp
    if iDelta <= 0 then
        return true
    end

    -- 如果是需要等待的, 关闭掉登录中动画
    local winLogin = GetUIWindow("LoginUI")
    if winLogin then
        winLogin:SetWaitingAnimState(false)
    end

    local errorMsg = ""
    local iMin = math.floor(iDelta / 60)
    if iMin > 0 then
        errorMsg = errorMsg .. string.format("%d分", iMin)
    end
    iDelta = iDelta - 60 * iMin
    if iDelta > 0 then
        errorMsg = errorMsg .. string.format("%d秒", iDelta)
    end
    
    return false, string.format("请于%s后重新尝试", errorMsg)
end

function PlayerSetDataManager:Destroy()

end

--=================================================================
function PlayerSetDataManager:SetObserveOtherPlayerData()
	local info = globalDataPool:getData('ObserveInfo');
    self.platBattleData[OBSERVE_OTHER_PLAYER_ID] = info;
end

function PlayerSetDataManager:GetObserveOtherPlayerData(otherPlayerID)
    return self.platBattleData[otherPlayerID];
end 

function PlayerSetDataManager:AddSystemTipsData(data)
    table.insert(self.systemTipsData, data);
    OpenWindowImmediately('SysTipsUI');
    LuaEventDispatcher:dispatchEvent("ONEVENT_REF_SYSTEM_TIPS_UI");
end

function PlayerSetDataManager:GetSystemTipsData()
    return self.systemTipsData;
end

-- 设置当前举报场景
function PlayerSetDataManager:SetCurReportScene(eReportScene, strContent)
    if (eReportScene == RLAYER_REPORTON_SCENE.WordChat)
    or (eReportScene == RLAYER_REPORTON_SCENE.HouseChat)
    or (eReportScene == RLAYER_REPORTON_SCENE.PrivateChat) then
        self.strReportChatContent = strContent
    else
        self.strReportChatContent = nil
    end
    self.eReportScene = eReportScene
end

-- 获取当前举报场景
function PlayerSetDataManager:GetCurReportScene()
    return (self.eReportScene or RLAYER_REPORTON_SCENE.UserBoard), (self.strReportChatContent or "")
end

-- 判断一个剧本是否没有玩过
function PlayerSetDataManager:IsEmptyScript(uiStoryID)
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return true end	-- 单机没有 info 数据
	for i = 0, playerinfo.iSize - 1 do
		if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
			if (playerinfo.kUnlockScriptInfos[i].acMainRoleName == nil) or (playerinfo.kUnlockScriptInfos[i].eStateType == SSS_NULL) then
				return true
			else
				return false
			end
		end
	end	

	return true
end

function PlayerSetDataManager:IsScriptLuckyValueEnough(uiStoryID)
    local luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue()
    local storyData = TableDataManager:GetInstance():GetTableData("Story", uiStoryID)
    if (not luckyvalue or not storyData or not storyData.LuckeyCost) then
        return false
    end

    return luckyvalue >= storyData.LuckeyCost
end

function PlayerSetDataManager:GetScriptLuckyCost(uiStoryID)
    local storyData = TableDataManager:GetInstance():GetTableData("Story", uiStoryID)
    if (not storyData or not storyData.LuckeyCost) then
        return 0
    end

    return storyData.LuckeyCost or 0
end

function PlayerSetDataManager:GetStoryUnlockDiff(uiStoryID)
	local curDiff = 1
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return curDiff end
	for i = 0, playerinfo.iSize - 1 do
		if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
			curDiff = playerinfo.kUnlockScriptInfos[i]["dwUnlockMaxDiff"]
			break
		end
    end	
    
    return curDiff
end

function PlayerSetDataManager:GetMaxStoryUnlockDiff()
    local curDiff = 1
    local maxDiff = 1
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return curDiff end
	for i = 0, playerinfo.iSize - 1 do
        local curDiff = playerinfo.kUnlockScriptInfos[i]["dwUnlockMaxDiff"]
        if curDiff > maxDiff then
            maxDiff = curDiff
        end
    end	
    
    return maxDiff
end

-- 判断一个剧本是否解锁
function PlayerSetDataManager:IsUnlockStory(uiStoryID)
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return true end	-- 单机没有 info 数据

    -- 先判断完整版解锁
	if self:IsChallengeOrderLock(uiStoryID) then
		return false
	end

	local storyData = TableDataManager:GetInstance():GetTableData("Story", uiStoryID)
	if (storyData == nil) then
		return false
    end
    
    -- 判断是否解锁了剧本所需的最低难度
    local unlockDiff = self:GetMaxStoryUnlockDiff()
    if unlockDiff < storyData.DifficultMin then
        return false
    end

    -- 判断剧本解锁方式
    if storyData.UnlockType == StoryUnlockType.SUT_UNLOCKED then
        return true
    elseif storyData.UnlockType == StoryUnlockType.SUT_ACHIEVE then
        if not storyData.NeedAchieve or #storyData.NeedAchieve == 0 then
            return true
        end
        for i, achieveID in ipairs(storyData.NeedAchieve) do
            if AchieveDataManager:GetInstance():IsAchieveMade(achieveID) then
                return true
            end
        end
    elseif storyData.UnlockType == StoryUnlockType.SUT_FLAG then
        for i = 0, playerinfo.iSize - 1 do
            if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
                return true
            end
        end	
    end
    
	return false
end

-- 完整版锁定剧本
function PlayerSetDataManager:IsChallengeOrderLock(uiStoryID)
	local TB_PlusEditionConfig = TableDataManager:GetInstance():GetTable("PlusEditionConfig")
	if not TB_PlusEditionConfig then
		return true
	end

	if self:IsChallengeOrderUnlock() then
		return false
	end

	local plusEditionConfig = TB_PlusEditionConfig[1]
	for index, lockStoryID in ipairs(plusEditionConfig.LockStorys) do
		if lockStoryID == uiStoryID then
			return true
		end
	end

	return false
end

-- 设置切磋Roll奖信息
function PlayerSetDataManager:SetPlayerCompareResInfo(kInfo)
    self.kPlayerCompareResInfo = kInfo
end

-- 获取切磋Roll奖信息
function PlayerSetDataManager:GetPlayerCompareResInfo()
    local kInfo = self.kPlayerCompareResInfo
    self.kPlayerCompareResInfo = nil
    return kInfo
end

-- 设置自动对话等待时间
function PlayerSetDataManager:SetAutoChatWaitTimePercent(fPercent)
    self.fAutoChatWaitTimePercent = fPercent or 0.5
    SetConfig("confg_AutoChatSpeed", self.fAutoChatWaitTimePercent)
    -- 重新计算等待时间
    local fFactor = 1 - self.fAutoChatWaitTimePercent
    if fFactor < 0 then fFactor = 0 end
    self.uiAutoChatWaitTime = math.floor(MIN_AUTOCHAT_WAIT_TIME + (MAX_AUTOCHAT_WAIT_TIME - MIN_AUTOCHAT_WAIT_TIME) * fFactor)
end

-- 获取自动对话等待时间
function PlayerSetDataManager:GetAutoChatWaitTime()
    if self.uiAutoChatWaitTime then
        return self.uiAutoChatWaitTime
    end
    if not self.fAutoChatWaitTimePercent then
        self.fAutoChatWaitTimePercent = GetConfig("confg_AutoChatSpeed") or 0.5
    end
    local fFactor = 1 - self.fAutoChatWaitTimePercent
    if fFactor < 0 then fFactor = 0 end
    self.uiAutoChatWaitTime = math.floor(MIN_AUTOCHAT_WAIT_TIME + (MAX_AUTOCHAT_WAIT_TIME - MIN_AUTOCHAT_WAIT_TIME) * fFactor)
    return self.uiAutoChatWaitTime
end

-- 设置剧情对话速度
function PlayerSetDataManager:SetStoryChatSpeedPercent(fPercent)
    self.fStoryChatSpeedPercent = fPercent or 0.5
    SetConfig("confg_StoryChatSpeed", self.fStoryChatSpeedPercent)
    -- 重新计算打字速度
    local uiBase = math.floor(MIN_DIALOG_TYPE_SPEED_BASE + (MAX_DIALOG_TYPE_SPEED_BASE - MIN_DIALOG_TYPE_SPEED_BASE) * self.fStoryChatSpeedPercent)
    if uiBase == 0 then
        uiBase = (MIN_DIALOG_TYPE_SPEED_BASE + MAX_DIALOG_TYPE_SPEED_BASE) / 2
    end
    self.fStoryChatSpeed = (1 / uiBase)
end

-- 获取剧情对话打字时间
function PlayerSetDataManager:GetStoryChatSpeed()
    if self.fStoryChatSpeed then
        return self.fStoryChatSpeed
    end
    if not self.fStoryChatSpeedPercent then
        self.fStoryChatSpeedPercent = GetConfig("confg_StoryChatSpeed") or 0.5
    end
    local uiBase = math.floor(MIN_DIALOG_TYPE_SPEED_BASE + (MAX_DIALOG_TYPE_SPEED_BASE - MIN_DIALOG_TYPE_SPEED_BASE) * self.fStoryChatSpeedPercent)
    if uiBase == 0 then
        uiBase = (MIN_DIALOG_TYPE_SPEED_BASE + MAX_DIALOG_TYPE_SPEED_BASE) / 2
    end
    self.fStoryChatSpeed = (1 / uiBase)
    return self.fStoryChatSpeed
end

-- 设置资源掉落活动资产值
function PlayerSetDataManager:SetResDropActivityFuncValue(iIndex, iValue)
    if not self.kResDropActivityFuncValue then
        self.kResDropActivityFuncValue = {}
    end
    self.kResDropActivityFuncValue[iIndex] = iValue or 0
end

-- 获取资源掉落活动资产值
function PlayerSetDataManager:GetResDropActivityFuncValue(iIndex)
    if not self.kResDropActivityFuncValue then
        return 0
    end
    return (self.kResDropActivityFuncValue[iIndex] or 0)
end


-- 设置秘宝活动资产值
function PlayerSetDataManager:SetTreasureExchangeValue(iIndex, iValue)
    if not self.kTreasureEValue then
        self.kTreasureEValue = {}
    end
    iIndex = iIndex or 0
    self.kTreasureEValue[iIndex] = iValue or 0
    LuaEventDispatcher:dispatchEvent("UpdataTreasureExchange")
    local bForce = false 
    if GetUIWindow('TreasureExchangeUI') or GetUIWindow('TreasureExchangePopWindowUI') then 
        bForce = true 
    end
    SendRequestTreasureExchangeState(bForce)
end

-- 获取秘宝活动资产值
function PlayerSetDataManager:GetTreasureExchangeValue(iIndex)
    if not self.kTreasureEValue  then
        return 0
    end
    iIndex = iIndex or 0
    return (self.kTreasureEValue[iIndex] or 0)
end

-- 设置节日活动资产值
-- iFestivalValue1
-- iFestivalValue2
function PlayerSetDataManager:SetFestivalValue(iIndex, iValue)
    iIndex = iIndex or 0
    local str = 'iFestivalValue' .. iIndex
    if self then 
        self[str] = iValue or  0 
    end 
    LuaEventDispatcher:dispatchEvent("UPDATE_MAIN_ROLE_INFO")
end

-- 获取节日活动资产值
function PlayerSetDataManager:GetFestivalValue(iIndex)
    iIndex = iIndex or 0
    local str = 'iFestivalValue' .. iIndex
    return self and self[str] or 0 
end

-- 设置通灵玉数量
function PlayerSetDataManager:SetTongLingYuValue(iValue)
    self.playerTongLingYu = iValue or 0
end

-- 获取通灵玉数量
function PlayerSetDataManager:GetTongLingYuValue()
    return self.playerTongLingYu or 0
end

-- 设置当前已经开启的藏宝图数量
function PlayerSetDataManager:SetOpenTreasureMapTypes(num)
    self.OpenTreasureMapType = num or 0
end

function PlayerSetDataManager:GetOpenTreasureMapTypes()
    return self.OpenTreasureMapType or 0
end


-- 初始化服务器区名映射表
function PlayerSetDataManager:InitServerZoneNameMap()
    local kTBData = TableDataManager:GetInstance():GetTable("ServerZoneName")
    local kMap = {}
    for index, kData in pairs(kTBData or {}) do
        kMap[kData.ServerID] = kData.ZoneName
    end
    self.kServerZoneNameMap = kMap
end

function PlayerSetDataManager:GetServerZoneNameByServerID(strServerID)
    if not strServerID then
        return ""
    end
    if not self.kServerZoneNameMap then
        self:InitServerZoneNameMap()
    end
    return self.kServerZoneNameMap[strServerID] or (strServerID .. "区")
end


function PlayerSetDataManager:GetPlayerHeadBoxSprite(iPlayerid)
    local iPlayInfoID = 0
    if not iPlayerid then
        iPlayInfoID = self.appearanceInfo.HeadBoxID
    end
    local kSprite
    if iPlayInfoID ~= 0 then 
        local kTBData = TableDataManager:GetInstance():GetTableData('PlayerInfo',iPlayInfoID)
        if kTBData and kTBData.IconPath and kTBData.IconPath ~= '' then  
            kSprite = GetSprite(kTBData.IconPath)
        end 
    end

    return kSprite
end

-- 设置剧本周限制信息
function PlayerSetDataManager:SetStoryWeekTakeOutNum(uiStoryID, iTaskOutNum)
    self.storyWeekTakeOutNums = self.storyWeekTakeOutNums or {}
    self.storyWeekTakeOutNums[uiStoryID] = iTaskOutNum
end

-- 获得剧本周限制信息
function PlayerSetDataManager:GetStoryWeekTakeOutNum(uiStoryID)
    self.storyWeekTakeOutNums = self.storyWeekTakeOutNums or {}
    return self.storyWeekTakeOutNums[uiStoryID] or 0
end

function PlayerSetDataManager:Clear()
    self.platBattleData = {}
    self.appearanceInfo = {}
    self.commonInfo = {}
    self.systemTipsData = {}
    self.storyWeekTakeOutNums = {}
    
    self.playerID = 0
    self.reNameNum = 0
    self.playerGold = 0
    self.playerSliver = 0
    self.playerCoin = 0
    self.playerPerfectPowder = 0
    self.playerRefinedIron = 0
    self.playerHeavenHammer = 0
    self.playerWangyoucao = 0
    self.playerRefreshBall = 0
    self.luckyvalue = 0
    self.lowInCompleteTextNum = 0
    self.midInCompleteTextNum = 0
    self.highInCompleteTextNum = 0
    self.playerDrinkMoney = 0
    self.playerPlatScore = 0
    self.playerActiveScore = 0
    self.playerSecondGold = 0
    self.challengeOrderType = 0
    self.loginDayNum = 0
    self.creatRoleID = 0

    self.firstSetGold = true
    self.firstSetSliver = true
    self.firstSetCoin = true
    self.noGoldGetAnim = false
    self.bShowGoldTips = true
    self.bRetuenHouseUnlock = false
    self.bIsGuideMode = false

    self.eReportScene = nil
    self.kPlayerCompareResInfo = nil
    self.kResDropActivityFuncValue = nil

    self:CloseBanSpendGoldAction()
end

return PlayerSetDataManager