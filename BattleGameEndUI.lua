BattleGameEndUI = class("BattleGameEndUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

local scroeTxtBase = 270001 
--这个UI 不要做缓存操作
function BattleGameEndUI:ctor()
end

function BattleGameEndUI:Create()
	local obj = LoadPrefabAndInit("Battle/BattleGameEndUI",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end



function BattleGameEndUI:Init()
    -- self.objContentBox = self:FindChild(self._gameObject, 'content_box')
    -- self.comContentText = self:FindChildComponent(self.objContentBox, 'Text', 'Text')
    self.ItemIconUIHelper = ItemIconUI.new()
    self.objDefeat_Node = self:FindChild(self._gameObject, 'Defeat_Node')
    self.objVictory_Node = self:FindChild(self._gameObject, 'Victory_Node')
    self.objCreateCGParent = self:FindChild(self._gameObject, 'CreateCG')
    self:InitDefeatNode()
    self:InitVictoryNode()
    self:AddEventListener("UPDATE_TASKTAG_DATA", function()
		self:RefreshCallHelpButton()
    end)
    self.hasClick = false
end

function BattleGameEndUI:Update()
    if GetKeyDownByFuncType(FuncType.CloseBattleEnd) then
        if HasValue(self.eState, SE_VICTORY) then
            self:OnClick_Win()
        end
    end 
end

function BattleGameEndUI:RefreshCallHelpButton()
    self.iCost = 0
    if TaskTagManager:GetInstance():IsNewVillageState() then
        if IsValidObj(self.objGiveUp_Button) then
         self.objGiveUp_Button.interactable = false
         setUIGray(self.objGiveUp_Button:GetComponent('Image'), true);
        end
        self.iCost = 0
    else
        self.iCost = 100
    end
    self.objCallHelp_Text.text = string.format( "%d",self.iCost )
end

function BattleGameEndUI:OnDestroy()
    if self.scrollRectVictory_Score then
        self.scrollRectVictory_Score:RemoveListener()
    end
    if self.scrollRectVictory_Award then
        self.scrollRectVictory_Award:RemoveListener()
    end
    if self.objVectorBG then
        RemoveEventTrigger(self.objVectorBG)
    end

    --DisplayActionEnd()
end

function BattleGameEndUI:SetDefeatButtonVisible(eFlag,iTypeID)
    local iBattleTypeID = iTypeID
    self.objCallHelp:SetActive(false)
    if iBattleTypeID and iBattleTypeID > 0 then 
        local battleData = TableDataManager:GetInstance():GetTableData("Battle", iBattleTypeID)
        if battleData.NoCallfriend==TBoolean.BOOL_YES then 
            self.objCallHelp:SetActive(false)
        end
        if HasValue(eFlag, SE_ONLYSHOWGIVEUP) or (battleData and battleData.HideGameEndButton and battleData.HideGameEndButton > 0) then
            self.objChallengeAgain:SetActive(true)--再次挑战和呼叫高手一直显示
            self.objReturnBeforeBattle:SetActive(false)
            return
        end
    end
    self.objChallengeAgain:SetActive(true)
    self.objReturnBeforeBattle:SetActive(true)
end

local map2array = function(retStreamData,attr)
    local s = retStreamData[attr]
    retStreamData[attr] = {}
    for k,v in pairs(s) do
        retStreamData[attr][tonumber(k)] = v
    end
end

function BattleGameEndUI:RefreshUI(retStream)
    -- 数据存到本地文件
    -- 需要记录剧本和玩家ID

    if HasValue(retStream.akEndData.eFlag, SE_AUTOBATTLEAGAIN) then
        self:OnClickChallengeAgain()
        return
    end

    local scriptID = GetCurScriptID()
    if HasValue(retStream.akEndData.eFlag, SE_ISLOAD) then
        local info = GetConfig("BettleEndMsg" .. scriptID)
        if info and info.script == scriptID and info.player == PlayerSetDataManager:GetInstance():GetPlayerID() then 
            retStream = info.data
        end
        -- 转ID
        local rd = retStream.akEndData
        map2array(rd,"aiScoreType")
        map2array(rd,"aiScoreCount")
        map2array(rd,"aiScore")
        map2array(rd,"asAward")

        self.objBattleReplay:SetActive(false)
    elseif scriptID ~= 0 then 
        LogicMain:GetInstance():SaveBattleEndInfo(retStream)
        self.objBattleReplay:SetActive(true)
    end

    self.hasClick = false
    StopMusic()
    G_Last_city_bgmID = nil
    RemoveWindowImmediately("GeneralBoxUI")
    local scoreInfo = retStream.akEndData   
    local iTypeID = scoreInfo.iTypeID
    local iEndScore = scoreInfo.iEndScore   --评价总分
    local eFlag = scoreInfo.eFlag
    self.eState = scoreInfo.eFlag
    local iScoreNum = scoreInfo.iScoreNum
    local uiTeamExp = scoreInfo.uiTeamExp   --队伍经验
    local uiMartialExp = scoreInfo.uiMartialExp --武学经验
    local aiScoreType = scoreInfo.aiScoreType
    local aiScoreCount = scoreInfo.aiScoreCount
    local aiScore = scoreInfo.aiScore
    local asAwards = BattleDataManager:GetInstance():GetAwardInfos(scoreInfo.iAwardNum,scoreInfo.asAward)
    local isDefeat = false
    local isVictory = false

    if HasValue(eFlag, SE_DEFEAT) then
        PlayButtonSound("EventBattleLose")
        self.bSpecialPlot = HasValue(eFlag, SE_SPECIALPLOT)
        self.objDefeat_Node:SetActive(true)
        self.objVictory_Node:SetActive(false)
        -- 一个是认输  bSpecialPlot = false  新手 认输不让点
        -- 一个是继续  bSpecialPlot = true
        self:SetDefeatButtonVisible(eFlag,iTypeID)
        if self.bSpecialPlot then
            self.objGiveUp_Button.gameObject:SetActive(false)
            self.Continue_Button.gameObject:SetActive(true)
        else
            self.objGiveUp_Button.gameObject:SetActive(true)
            self.Continue_Button.gameObject:SetActive(false)
        end
		self:RefreshCallHelpButton()
    else
        if scoreInfo.uiLevelAddExp and scoreInfo.uiLevelAddExp ~= 0 then 
            LogicMain:GetInstance():RecordAwardInfo(string.format("<color=red>低等级碾压 经验-%.0f%%</color>",scoreInfo.uiLevelAddExp/100))
        end
        UnitMgr:GetInstance():GetPetInfo()
        PlayButtonSound("EventBattleWin")
        self.objDefeat_Node:SetActive(false)
        self.objVictory_Node:SetActive(true)
        self:CreateVictoryScroeEvaluate(iEndScore,iScoreNum,aiScoreType,aiScoreCount,aiScore,scoreInfo)
        self:CreateVictoryAwards(uiTeamExp,uiMartialExp,#asAwards,asAwards)
        if IsValidObj(self.imgVectory_LiHui) then
            -- 在所有上阵角色中随机一个
            local role_list = UnitMgr:GetInstance():GetAllUnit()
            local showunit = {}
            for i,role in ipairs(role_list) do 
                if role and role.iCamp ~= SE_CAMPB then 
                    table.insert(showunit,role)
                end
            end 
            local artData
            if #showunit > 0 then 
                local unit = showunit[math.random(1,#showunit)]
                -- 捏脸22 立绘 战斗里都使用服务器下发的捏脸数据
                local kRoleFaceData = unit['kRoleFaceData'] 
                if kRoleFaceData then
                    if self.objCreateCG then
                        self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImageByData(kRoleFaceData, self.objCreateCGParent, self.objCreateCG)
                        self.objCreateCG:SetActive(true)
                    else
                        self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImageByData(kRoleFaceData, self.objCreateCGParent)
                    end
                    self.imgVectory_LiHui.gameObject:SetActive(false)
                else
                    if self.objCreateCG then
                        self.objCreateCG:SetActive(false)
                    end
                    self.imgVectory_LiHui.gameObject:SetActive(true)
                    artData = unit:GetModelData()
                end
            end
            if artData == nil then 
                artData = RoleDataManager:GetInstance():GetMainRoleArtData()
            end
            if artData and artData.Drawing then
                local sprite = GetSprite(artData.Drawing)
                if sprite then
                    self.imgVectory_LiHui.sprite = sprite
                end
            end
        end
    end

    --
    self:RefPrivilegeUI();
end

function BattleGameEndUI:ReturnBattleState()
    return self.eState or SE_DEFEAT
end

function BattleGameEndUI:RefPrivilegeUI()
    self.objPrivilegeRewardIcon:SetActive(false);
    self.objImageQQ:SetActive(false);
    self.objImageWX:SetActive(false);

    if MSDKHelper:IsLoginQQ() then
        if MSDKHelper:IsOpenQQPrivilege() then
            self.objPrivilegeRewardIcon:SetActive(true);
            self.objImageQQ:SetActive(true);
            self.objImageWX:SetActive(false);
            self.comText.text = 'QQ游戏中心 经验+5%';
        end
    elseif MSDKHelper:IsLoginWeChat() then
        if MSDKHelper:IsOpenWXPrivilege() then
            self.objPrivilegeRewardIcon:SetActive(true);
            self.objImageQQ:SetActive(false);
            self.objImageWX:SetActive(true);
            self.comText.text = '微信游戏中心 经验+5%';
        end
    end
end

function BattleGameEndUI:InitVictoryNode()
    self.objVectorBG = self:FindChild(self._gameObject,"Victory_Node/BG")
    self.imgVectory_LiHui = self:FindChildComponent(self.objVictory_Node,"CG","Image")
    self.objVictory_ScoreNode = self:FindChild(self.objVictory_Node,"Score_Node")
    self.tXtVictory_TotalScore = self:FindChildComponent(self.objVictory_ScoreNode,"Score_Text","Text")
    self.btnVictory_ScoreQuestion = self:FindChildComponent(self.objVictory_ScoreNode,"Score_Button_question","Button") 
    self.scrollRectVictory_Score = self:FindChildComponent(self.objVictory_ScoreNode,"ScoreLoopScrollView","LoopVerticalScrollRect")
    self.objVictory_AwardNode = self:FindChild(self.objVictory_Node,"RewardNode")
    self.objVictoryImage_Node = self:FindChild(self.objVictory_Node,"VictoryImage_Node")
    self.objVictory_TeamExperience = self:FindChild(self.objVictory_AwardNode,"teamExperience")
    self.objVictory_MartialExperience = self:FindChild(self.objVictory_AwardNode,"martialExperience")
    --self.txtVictory_TeamExperience_Title = self:FindChildComponent(self.objVictory_TeamExperience,"Text_1","Text")
    self.txtVictory_TeamExperience_Score = self:FindChildComponent(self.objVictory_TeamExperience,"Text_2","Text")
    --self.txtVictory_MartialExperience_Title = self:FindChildComponent(self.objVictory_MartialExperience,"Text_1","Text")
    self.txtVictory_MartialExperience_Score = self:FindChildComponent(self.objVictory_MartialExperience,"Text_2","Text")
    self.btnVictory_AwardQuestion = self:FindChildComponent(self.objVictory_AwardNode,"Reward_Button_question","Button")
    self.scrollRectVictory_Award = self:FindChildComponent(self.objVictory_AwardNode,"RewardLoopScrollView","LoopVerticalScrollRect")

    self.btnBattleStatistical = self:FindChildComponent(self._gameObject,"TransformAdapt_node_left/Button_BattleData","Button")
    if (self.btnBattleStatistical) then
        self:RemoveButtonClickListener(self.btnBattleStatistical)
		self:AddButtonClickListener(self.btnBattleStatistical, function ()
            OpenWindowImmediately("BattleStatisticalDataUI")       
        end)
    end


    self.objBattleReplay = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_replay")
    self.btnBattleReplay = self:FindChildComponent(self._gameObject,"TransformAdapt_node_left/Button_replay","Button")
    if (self.btnBattleReplay) then
        self:RemoveButtonClickListener(self.btnBattleReplay)
        self:AddButtonClickListener(self.btnBattleReplay, function ()
            if LogicMain:GetInstance()._Replaying ~= true then 
                RemoveWindowImmediately("BattleGameEndUI")
                LogicMain:GetInstance():Clear()
                LogicMain:GetInstance():Replay()
            end
        end)
    end



    if IsValidObj(self.scrollRectVictory_Score) then
        local fun_VictoryScoreChange = function(transform, idx)
            self:OnVictoryScoreScrollChanged(transform, idx)
        end
        self.scrollRectVictory_Score:AddListener(fun_VictoryScoreChange)
        self.scrollScrollViewClick = self:FindChildComponent(self.objVictory_ScoreNode,"ScoreLoopScrollView","ScrollViewClick")
        if self.scrollScrollViewClick then
            self.scrollScrollViewClick:SetLuaFunction(function ()
                self:OnClick_Win()
            end)
        end

    end

    if IsValidObj(self.scrollRectVictory_Award) then
        local fun_VictoryAwardChange = function(transform, idx)
            self:OnVictoryAwardcrollChanged(transform, idx)
        end
        self.scrollRectVictory_Award:AddListener(fun_VictoryAwardChange)
        self.scrollRewardLoopScrollView = self:FindChildComponent(self.objVictory_AwardNode,"RewardLoopScrollView","ScrollViewClick")
        if self.scrollRewardLoopScrollView then
            self.scrollRewardLoopScrollView:SetLuaFunction(function ()
                self:OnClick_Win()
            end)
        end
    end

    if IsValidObj(self.btnVictory_ScoreQuestion) then
        self:AddButtonClickListener(self.btnVictory_ScoreQuestion,function() 
            local tips = TipsDataManager:GetInstance():GetBattleScoreEvaluate()
            OpenWindowImmediately("TipsPopUI",tips)
        end)
    end
    if IsValidObj(self.btnVictory_AwardQuestion) then
        self:AddButtonClickListener(self.btnVictory_AwardQuestion,function() 
            local tips = TipsDataManager:GetInstance():GetBattleAwardAdditionTips()
            OpenWindowImmediately("TipsPopUI",tips) 
        end)
    end
    AddEventTrigger(self.objVectorBG,function() self:OnClick_Win() end)

    --
    self.objPrivilegeRewardIcon = self:FindChild(self.objVictory_AwardNode,"PrivilegeRewardIcon")
    self.objPrivilegeRewardIcon:SetActive(false);
    self.objImageQQ = self:FindChild(self.objPrivilegeRewardIcon,"Image_QQ")
    self.objImageWX = self:FindChild(self.objPrivilegeRewardIcon,"Image_WX")
    self.comText = self:FindChildComponent(self.objPrivilegeRewardIcon,"Text","Text")
end

function BattleGameEndUI:OnVictoryScoreScrollChanged(item, idx)
    if not IsValidObj(item) then
        return
    end

    local type = self.ScroeEvaluateTypeArray[idx]
    local count = self.ScroeEvaluateCount[idx]
    local score = self.ScroeEvaluateNumArray[idx]

    local txt_Title = self:FindChildComponent(item.gameObject,"Text_1","Text")
    local txt_score = self:FindChildComponent(item.gameObject,"Text_2","Text")
    
    local language = GetLanguageByID(scroeTxtBase + type)
    if language and IsValidObj(txt_Title) and IsValidObj(txt_score) then
        local isMatch = string.gmatch(language,"%%s") ~= ""
        local color = score > 0 and COLOR_VALUE[COLOR_ENUM.Green] or COLOR_VALUE[COLOR_ENUM.Red]
        txt_Title.text = isMatch and string.format(language,count) or language
        txt_score.text = score > 0 and "+"..tostring(score) or score
        txt_Title.color = color
        txt_score.color = color
    end
end

function BattleGameEndUI:CreateVictoryScroeEvaluate(totalScroe,count,scoreTypeArray,scoreCountArray,scoreNumArray,scoreInfo)
    if not IsValidObj(self.scrollRectVictory_Score) then
        return
    end

    if IsValidObj(self.tXtVictory_TotalScore) then
        self.tXtVictory_TotalScore.text = totalScroe
    end
    local int_level = 1
    for int_i, int_val in ipairs(BATTLE_VICTORY_SCORE) do
        if totalScroe >= int_val then
            int_level = int_i
        else
            break
        end
    end
    if  scoreInfo.uiResultAddExp and scoreInfo.uiResultAddExp ~= 0 then 
        local tag = "+"
        if scoreInfo.uiResultAddExp < 0 then 
            tag = '-'
        end
        LogicMain:GetInstance():RecordAwardInfo(string.format("%s加成   经验%s%.0f%%",BATTLE_VICTORY_SCORE_DESC[int_level],tag,scoreInfo.uiResultAddExp/100))
    end
    for i=1,4 do
        local bActive = false
        if i == int_level then 
            bActive = true
        end
        self:FindChild(self.objVictoryImage_Node,"Victory_" .. i):SetActive(bActive)
    end
    self.scrollRectVictory_Score:ClearCells()
    self.ScroeEvaluateTypeArray = scoreTypeArray
    self.ScroeEvaluateNumArray = scoreNumArray
    self.ScroeEvaluateCount = scoreCountArray -- 次数
    self.ScroeEvaluateValidCount = count

    self.scrollRectVictory_Score.totalCount = self.ScroeEvaluateValidCount
    self.scrollRectVictory_Score:RefillCells()
end

function BattleGameEndUI:OnVictoryAwardcrollChanged(item, idx)
    if not IsValidObj(item) then
        return
    end

    local awardObj = self.AwardArray[idx + 1]
    if awardObj == nil then 
        return 
    end
    local img_Icon = self:FindChildComponent(item.gameObject,"Icon","Image")
    local txt_Num = self:FindChildComponent(item.gameObject,"Num","Text")
    local obj_Lock = self:FindChild(item.gameObject,"Lock")
    if awardObj.nameID then 
        self.ItemIconUIHelper:UpdateUIWithItemTypeData(item.gameObject,TableDataManager:GetInstance():GetTableData("Item",awardObj.nameID))
        self.ItemIconUIHelper:SetItemNum(item.gameObject,awardObj.num,awardObj.num == 1)
    end

    -- if IsValidObj(img_Icon) then
    --     img_Icon.sprite = GetSprite(awardObj.icon)
    -- end

    -- if IsValidObj(txt_Num) then
    --     txt_Num.text = awardObj.num
    -- end

    -- if IsValidObj(obj_Lock) then
    --     obj_Lock:SetActive(false)
    -- end
end

function BattleGameEndUI:CreateVictoryAwards(teamExp,martialExp,count,awardArray)
    if not IsValidObj(self.scrollRectVictory_Award) then
        return
    end
    self.info = globalDataPool:getData("MainRoleInfo");
    if IsValidObj(self.txtVictory_TeamExperience_Score) then
        -- TODO 成就带入
        local coef = 1;
        if self.info then
            coef = coef + self.info.MainRole[MainRoleData.MRD_EXTRA_ROLEEXP] / 10000;
        end
        self.txtVictory_TeamExperience_Score.text = math.floor(teamExp * coef);
    end
    if IsValidObj(self.txtVictory_MartialExperience_Score) then
        -- TODO 成就带入
        local coef = 1;
        if self.info then
            coef = coef + self.info.MainRole[MainRoleData.MRD_EXTRA_MARITAL] / 10000;
        end
        self.txtVictory_MartialExperience_Score.text = math.floor(martialExp * coef);
    end

    self.scrollRectVictory_Award:ClearCells()
    self.AwardArray = awardArray
    self.AwardsCount = count
    


    self.scrollRectVictory_Award.totalCount = self.AwardsCount
    self.scrollRectVictory_Award:RefillCells()
end

function BattleGameEndUI:InitDefeatNode()
    self.objChallengeAgain = self:FindChild(self.objDefeat_Node,"ChallengeAgain_Button") 
    self.objReturnBeforeBattle = self:FindChild(self.objDefeat_Node,"ReturnBattle_Button") 
    self.objCallHelp = self:FindChild(self.objDefeat_Node,"CallHelp_Button") 

    self.objChallengeAgain_Button = self:FindChildComponent(self.objDefeat_Node,"ChallengeAgain_Button","Button") 
    if IsValidObj(self.objChallengeAgain_Button) then
        self:AddButtonClickListener(self.objChallengeAgain_Button,function() self:OnClickChallengeAgain() end)
    end

    self.objReturnBeforeBattle_Button= self:FindChildComponent(self.objDefeat_Node,"ReturnBattle_Button","Button") 
    if IsValidObj(self.objReturnBeforeBattle_Button) then
        self:AddButtonClickListener(self.objReturnBeforeBattle_Button,function() self:OnClick_ReturnButton() end)
    end

    self.objCallHelp_Button = self:FindChildComponent(self.objDefeat_Node,"CallHelp_Button","Button")
    self.objCallHelp_Text = self:FindChildComponent(self.objCallHelp_Button.gameObject,"Spend_Text","Text")
   
    if IsValidObj(self.objCallHelp_Button) then
        self:AddButtonClickListener(self.objCallHelp_Button,function() self:OnClick_CallHelpButton() end)
    end

    self.objGiveUp_Button = self:FindChildComponent(self.objDefeat_Node,"GiveUp_Button","Button")
    if IsValidObj(self.objGiveUp_Button) then
        self:AddButtonClickListener(self.objGiveUp_Button,function() self:OnClick_GiveUpButton() end)
    end

    self.Continue_Button = self:FindChildComponent(self.objDefeat_Node,"Continue_Button","Button")
    if IsValidObj(self.Continue_Button) then
        self:AddButtonClickListener(self.Continue_Button,function() self:OnClick_GiveUpButton() end)
    end

    
end

function BattleGameEndUI:OnClickChallengeAgain()
    --OpenWindowImmediately("LoadingUI")
    LogicMain:GetInstance():Clear()
    RemoveWindowImmediately("BattleGameEndUI")
    -- DisplayActionEnd()
    local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BATTLE_AGAIN,iSize,data)
    LogicMain:GetInstance():ClearStatisticalData()
    LogicMain:GetInstance():ClearReplayInfo()
end


function BattleGameEndUI:OnClick_Win()
    if self.hasClick then 
        return
    end
    self.hasClick = true
    local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BATTLE_WIN,iSize,data)
    self:BackToTownScene()
    DisplayActionEnd()
    LogicMain:GetInstance():ClearStatisticalData()
    LogicMain:GetInstance():ClearReplayInfo()

    -- TODO 数据上报
    MSDKHelper:SetQQAchievementData('battlewin', 1);
    MSDKHelper:SendAchievementsData('battlewin');
end

function BattleGameEndUI:OnClick_ReturnButton()
    local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BATTLE_RETURN_PREBATTLE,iSize,data)
    self:BackToTownScene()
    DisplayActionEnd()
    LogicMain:GetInstance():ClearStatisticalData()
    LogicMain:GetInstance():ClearReplayInfo()
end

function BattleGameEndUI:OnClick_CallHelpButton()
    dprint("求救")
    callback = function()
        -- self:QuickCost(self.iCost)
        LogicMain:GetInstance():Clear()
        local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
        local iSize = data:GetCurPos()
        NetGameCmdSend(SGC_CLICK_BATTLE_CALL_HELP,iSize,data)
        LogicMain:GetInstance():ClearStatisticalData()
        LogicMain:GetInstance():ClearReplayInfo()
    end
    if (self.iCost == 0) then
        callback()
    else 
        PlayerSetDataManager.GetInstance():RequestSpendSilver(self.iCost,callback)
    end
end

function BattleGameEndUI:OnClick_GiveUpButton()
    if  self.bSpecialPlot then
        -- 左边“继续”红色，右边“再想想”绿色。
        local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
        local iSize = data:GetCurPos()
        NetGameCmdSend(SGC_CLICK_BATTLE_GIVEUP,iSize,data)
        self:BackToTownScene()
        DisplayActionEnd()
        LogicMain:GetInstance():ClearStatisticalData()
        LogicMain:GetInstance():ClearReplayInfo()
    -- local showContent = {
        --     ['title'] = '提示',
        --     ['text'] = '点击“继续剧情”后可以继续剧情，但可能会错过部分奖励与结局，是否继续？',
        --     ['leftBtnText'] = '继续剧情',
        --     ['rightBtnText'] = '再想想',
        --     ['leftBtnFunc'] = function()
        --         local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
        --         local iSize = data:GetCurPos()
        --         NetGameCmdSend(SGC_CLICK_BATTLE_GIVEUP,iSize,data)
        --         self:BackToTownScene()
        --         DisplayActionEnd()
        --     end
        -- }
        -- OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, showContent, nil})

        
    else
        --再想想 绿色 右 认输 红色 左
        local showContent = {
            ['title'] = '提示',
            ['text'] = '认输将以失败结局结算当前游戏，剧情进度重置，<color=red>金色及以上品质物品将会保留</color>。结算游戏并非游戏结束，可以更强的初始能力再次开启新的游戏。此操作无法反悔，是否要继续认输？',
            ['leftBtnText'] = '认输',
            ['rightBtnText'] = '再想想',
            ['leftBtnFunc'] = function()
                dprint("删档重来")
                local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
                local iSize = data:GetCurPos()
                NetGameCmdSend(SGC_CLICK_BATTLE_GIVEUP,iSize,data)
                self:BackToTownScene()
                DisplayActionEnd()
                LogicMain:GetInstance():ClearStatisticalData()
                LogicMain:GetInstance():ClearReplayInfo()
            end
        }

        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.BATTLE_DEFEATED, showContent, nil})
    end
end

function BattleGameEndUI:OnDisable()
    
end

-- 回到town scene
function BattleGameEndUI:BackToTownScene()
    RemoveWindowImmediately("BattleGameEndUI")
    LogicMain:GetInstance():ReturnToTown(true)
    RoleDataManager:GetInstance():CheckAndShowLevelUp()
    local info = globalDataPool:getData("GameData") or {}
    local curState = info['eCurState']
    if curState == GS_BIGMAP then
        PlayMusic(BGMID_MAP)
    end
end

return BattleGameEndUI