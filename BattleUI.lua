BattleUI = class("BattleUI", BaseWindow)
local SkillIconUI = require 'UI/Skill/SkillIconUI'
local MenuPanelUI = require "UI/MenuPanelUI"
--这个UI 不要做缓存操作
local lTB_RoleModel = TableDataManager:GetInstance():GetTable("RoleModel")
local PAGE_SKILL_COUNT = 7 --一排7个 按钮
local POINT_INTERVAL = 0.5

BattleCamera = nil
function BattleUI:ctor()
    self.Battle_Camera = nil
    self.LuaBehaviour = nil

    self.objBattleGrid = nil
    self.objBattleGridBG = nil
    self._canMoveGridPos = {} -- {[1] = {[1] = 1,[2] = [1]}} 逻辑中传过来 当前单位可移动的位置

    self.objSkills = {}
    self.iCurPage = 1
    self.iMaxPage = 1

    self.akMartialData = {} --技能信息  -1存了奥义 大于等于1开始 存了正常的技能
    self.iAoYIIndex = -1
    setmetatable(self.akMartialData, {__mode = "kv"})
    self.iCurChooseSkillIndex = 0 -- -1为选择奥义 大于1为选择普通技能
    self.objComboSkills = {} --存放所有combo

    self.bShowBattleLogState = false
    self.comBattleLogTween = nil
    --self.objCloneBattleLogText = nil
    self.pointTime = 0
    self._coroutine = {}
    self.isPointerUp = false
    self.battleLog = {}
    self.simpleBattleLog = {} --这里只记索引
    self.BattleBeginUI = nil
    self.bossUI = nil
    self._objUnitIndex2MoveIcon ={}--移动条头像缓存
    self.iMoveIconCount = 0
    self.SkillIconUI = SkillIconUI.new()
    self.unitAction = false

    self.bSimpleMode = GetConfig("BattleLogMode")
    if self.bSimpleMode == nil then
        self.bSimpleMode = false
        SetConfig("BattleLogMode", false)
    end

    --指示对象相关数据
    self.uiZhiShiModleID = 0
    self.SortingGroup = nil
    self.zhiShiSkeletonAnimation = nil
end

function BattleUI:Create()
    local obj = LoadPrefabAndInit("Battle/BattleUI", UI_MainLayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function BattleUI:ShowSkillInfo(boolean_show)
    -- self.objSkillInfo:SetActive(boolean_show)
    self:ShowSkillUI(boolean_show)
    self.unitAction = boolean_show
    -- if boolean_hide == false then
    --     LogicMain:GetInstance():ClearGridColor()
    -- end
end
function BattleUI:Init_TopObject()
    self.TopObject = self:FindChild(self._gameObject, "TopObject")
    self.TopObject_Pos = self.TopObject.transform.localPosition
    self.objReturn_Button = self:FindChild(self.TopObject, "TransformAdapt_node_left/Return_Button")
    self.objReturnTips = self:FindChild(self.objReturn_Button, "Tips")
    self.comReturn_Button = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/Return_Button", "Button")
    self.comReturnUIAction = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/Return_Button", "LuaUIAction")
    if self.comReturn_Button then
        local fun = function()
            self:OnClick_ReturnButton()
        end
        self:AddButtonClickListener(self.comReturn_Button, fun)
    end
    if self.comReturnUIAction then
        self.comReturnUIAction:SetPointerEnterAction(function()
            self.objReturnTips:SetActive(true)
        end)

        self.comReturnUIAction:SetPointerExitAction(function()
            self.objReturnTips:SetActive(false)
        end)
    end
    self.SpeedBattle_Button = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/Speed_Button", "Button")
    self.SpeedBattle_Text = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/Speed_Button/Text", "Text")
    if self.SpeedBattle_Button then
        self:AddButtonClickListener(
            self.SpeedBattle_Button,
            function()
                if GetSpeed(SPEED_TYPE.BATTLE) == 1 then
                    SetSpeed(SPEED_TYPE.BATTLE,0)
                    SetConfig("BattleSpeed", false)
                else
                    SetSpeed(SPEED_TYPE.BATTLE,1)
                    SetConfig("BattleSpeed", true)
                end
                self.SpeedBattle_Button:InitImageSprite()
                if GetConfig("BattleSpeed") then
                    self.SpeedBattle_Button:ChangeShowSprite()
                end
            end
        )
    end
    self.AutoBattle_Button = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/AutoBattle_Button", "DRButton")
    self.AutoBattle_Text = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/AutoBattle_Button/Text", "Text")
    if self.AutoBattle_Button then
        self:AddButtonClickListener(
            self.AutoBattle_Button,
            function()
                LuaEventDispatcher:dispatchEvent("BATTLE_CLICK_BATTLE_AUTO")
                if self.AutoBattle_Text.text == "自动" then
                    self.AutoBattle_Text.text = "自动中"
                else
                    self.AutoBattle_Text.text = "自动"
                end
                self:RefreshAutoBattleUI()
            end
        )
    end

    self.Pause_Button = self:FindChildComponent(self.TopObject, "TransformAdapt_node_left/Pause_Button", "DRButton")
    if self.Pause_Button then
        self:AddButtonClickListener(
            self.Pause_Button,
            function()
                if LogicMain:GetInstance():IsPauseAreanReplay() then
                    LogicMain:GetInstance():PlayAreanReplay()
                else
                    LogicMain:GetInstance():PauseAreanReplay()
                end
            end
        )
    end
    self.Pause_Button.gameObject:SetActive(false)

    self.objComboNode = self:FindChild(self.TopObject, "Combo_Node")
    self.ArenaName = self:FindChild(self.TopObject, "ArenaName")
    self.ArenaName_self = self:FindChildComponent(self.ArenaName, "self","Text")
    self.ArenaName_enemy = self:FindChildComponent(self.ArenaName, "enemy","Text")
end

function BattleUI:ShowArenaName()
    if ARENA_PLAYBACK_DATA and ARENA_PLAYBACK_DATA.kPly1Data and ARENA_PLAYBACK_DATA.kPly2Data and self.ArenaName then
        self.ArenaName:SetActive(true)
        self.ArenaName_self.text = ARENA_PLAYBACK_DATA.kPly1Data.acPlayerName;
        self.ArenaName_enemy.text = ARENA_PLAYBACK_DATA.kPly2Data.acPlayerName;

        local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
        if ARENA_PLAYBACK_DATA.kPly2Data.defPlayerID == ownerID then
            self.ArenaName_self.color = self.mEnemyNameColor
            self.ArenaName_enemy.color = self.mSelfNameColor
        else
            self.ArenaName_self.color = self.mSelfNameColor
            self.ArenaName_enemy.color = self.mEnemyNameColor
        end
    end
end


function BattleUI:InitSkillButton()
    for i = 1, PAGE_SKILL_COUNT do
        local obj = self:FindChild(self._gameObject, "SkillInfo/DownPanel/" .. i)
        self.objSkills[i] = obj
        self:RegisterHandler(obj,"Icon",function() self:OnHandlePointerDown(i) end,function() self:OnHandlePointerUp(i) end,
        function() self:OnHandlePointerEnter(i) end,function() self:OnHandlePointerExit(i) end)
    end
    self.objSkills[-1] = self:FindChild(self._gameObject, "SkillInfo/DownPanel/UniqueSKill")
    self.objSkills[-1]:SetActive(false)
    self:RegisterHandler(self.objSkills[-1],"Icon",function() self:OnHandlePointerDown(-1) end,function() self:OnHandlePointerUp(-1) end,
    function() self:OnHandlePointerEnter(-1) end,function() self:OnHandlePointerExit(-1) end)
    self:InitSkillPageButton()
end

function BattleUI:Init_SkillInfo()
    self.objSkillInfo = self:FindChild(self._gameObject, "SkillInfo")
    self.objSkillInfo_Pos = self.objSkillInfo.transform.localPosition

    --self.objTurn_Button = self:FindChild(self.objSkillInfo, "TransformAdapt_node_left/EndTurn_Button")
    self.objTurn_Tips = self:FindChild(self.objSkillInfo, "DownPanel/EndTurn/Tips")
    self.objTurn_Button = self:FindChild(self.objSkillInfo, "DownPanel/EndTurn/EndTurn_Button")
    self.EndTurn_Button = self.objTurn_Button:GetComponent("Button")
    self.UIAction = self.objTurn_Button:GetComponent("LuaUIAction")
    if self.UIAction then
        self.UIAction:SetPointerEnterAction(function()
            local tips={
                title = '结束回合',
                content = '移动到当前所选位置,并结束本次行动',
                movePositions = {
                    x = 0,
                    y = 120
                },
                isSkew = true,
            }
            OpenWindowImmediately("TipsPopUI",tips)
            --self.objTurn_Tips:SetActive(true)
        end)
        self.UIAction:SetPointerExitAction(function()
            RemoveWindowImmediately("TipsPopUI")
            --self.objTurn_Tips:SetActive(false)
        end)
    end
    if self.EndTurn_Button then
        self:AddButtonClickListener(
            self.EndTurn_Button,
            function()
                self:OnClick_EndTurnButton()
            end
        )
    end

    self.objReselectPos_Button = self:FindChild(self.objSkillInfo, "TransformAdapt_node_left/ReselectPos_Button")
    self.ReselectPos_Button = self:FindChildComponent(self.objSkillInfo, "TransformAdapt_node_left/ReselectPos_Button", "Button")
    self.ReselectPos_UIAction = self:FindChildComponent(self.objSkillInfo, "TransformAdapt_node_left/ReselectPos_Button", "LuaUIAction")
    self.objReselectPosTips = self:FindChild(self.objReselectPos_Button, "Tips")
    if self.ReselectPos_Button then
        self:AddButtonClickListener(
            self.ReselectPos_Button,
            function()
                self:OnClick_ReselectPosButton()
                self.objReselectPos_Button:SetActive(false)
            end
        )
    end
    if self.ReselectPos_UIAction then
        self.ReselectPos_UIAction:SetPointerEnterAction(function()
            self.objReselectPosTips:SetActive(true)
        end)
        self.ReselectPos_UIAction:SetPointerExitAction(function()
            self.objReselectPosTips:SetActive(false)
        end)
    end

    self.objReselectPos_Button:SetActive(false)
    self:InitSkillButton()
end

function BattleUI:Init_RightObject()
    --菜单面板
	self.objMenuPanel = self:FindChild(self._gameObject,"RightObject/menuPanel")
    if self.objMenuPanel then
		self.MenuPanelUI = MenuPanelUI.new()
		self.MenuPanelUI:SetGameObject(self.objMenuPanel)
		self.MenuPanelUI:Init()
	end
    self.RightObject = self:FindChild(self._gameObject, "RightObject")
    self.RightObject_Pos = self.RightObject.transform.localPosition
    self.roundBG = self:FindChild(self.RightObject, "Round_BG")
    --self.objRoundButton = self:FindChild(self.RightObject, "TransformAdapt_node_right/Round_Button")
    self.objRoundButton = self:FindChild(self._gameObject, "TopObject/TransformAdapt_node_left/Round_Button")
    self.comLuaAction = self.objRoundButton:GetComponent('LuaUIAction')
    --self.Round_Button = self.objRoundButton:GetComponent("Button")
    if self.comLuaAction then
        self.comLuaAction:SetPointerEnterAction(function()
            self:OnClick_Round_Button()
        end )
        self.comLuaAction:SetPointerExitAction(function()
            RemoveWindowImmediately("TipsPopUI")
        end )
    end

    self.objRoundButtonRedBG = self:FindChild(self.objRoundButton, "redBG")
    self.objRoundText_18 = self:FindChild(self.objRoundButton, "18")
    self.objRoundText_19 = self:FindChild(self.objRoundButton, "19")
    self.objRoundText_20 = self:FindChild(self.objRoundButton, "20")
    self.objRoundText = self:FindChild(self.objRoundButton, "Text")
    self.objRoundButtonRedBG:SetActive(false)
    self.comRoundText = self:FindChildComponent(self.objRoundButton, "Text", "Text")
    self.objRound_IconStartNode = self:FindChild(self.roundBG, "Round_IconStartNode")

    self.Round_tip = self:FindChild(self.RightObject, "TransformAdapt_node_right/Round_tip")
    self.Round_tip_title = self:FindChildComponent(self.Round_tip, "Title", "Text")
    self.Round_tip_desc = self:FindChildComponent(self.Round_tip, "desc", "Text")
    self.Round_tipGroup = self.Round_tip:GetComponent("CanvasGroup")
    self.Round_tip:SetActive(false)
end

function BattleUI:Init_BattleLog()
    self.objBattleLog = self:FindChild(self._gameObject, "TransformAdapt_node_left/Battle_Log")
    -- self.comUIAction = self:FindChildComponent(self.objBattleLog, "HideNode/BG_Image","LuaUIAction")
    -- if self.comUIAction then
    --     self.comUIAction:SetPointerEnterAction(function()
    --         derror("pointer enter")
    --     end)
    --     self.comUIAction:SetPointerExitAction(function()
    --         derror("pointer exit")
    --     end)
    --     derror("SetPointerEnterAction and SetPointerExitAction")
    -- else
    --     derror("BattleUI not found comUIAction")
    -- end

    self.objBattleHideNode = self:FindChildComponent(self.objBattleLog, "HideNode","CanvasGroup")
    self.objBattleHideNode.alpha = 1.0
    self.comUIAction = self:FindChildComponent(self.objBattleLog, "HideNode/Scroll View","LuaUIAction")
    if self.comUIAction then
        self.comUIAction:SetPointerEnterAction(function()
            g_CanSwitchSkill = false
        end)
        self.comUIAction:SetPointerExitAction(function()
            g_CanSwitchSkill = true
        end)
    else
        derror("BattleUI not found comUIAction")
    end
    self.objBattleLog_Pos = self.objBattleLog.transform.localPosition
    self.BattleLog_Button = self:FindChildComponent(self.objBattleLog, "Button", "Button")
    if self.BattleLog_Button then
        self:AddButtonClickListener(
            self.BattleLog_Button,
            function()
                self:OnClick_BattleLogButton()
            end
        )
    end

    self.ChnageMode_Button = self:FindChildComponent(self.objBattleLog, "dotween/HideNode/ChangeMode_Button", "Button")
    if self.ChnageMode_Button then
        self:AddButtonClickListener(
            self.ChnageMode_Button,
            function()
                self:OnClick_ChnageModeButton()
            end
        )
    end
    -- self.img_Modedetail = self:FindChild(self.objBattleLog, "Mode_detail")
    -- self.img_Modesimple = self:FindChild(self.objBattleLog, "Mode_simple")
    self.objBattleLogDotween = self:FindChild(self.objBattleLog, "dotween")
    self.comBattleLogTween = self:FindChildComponent(self.objBattleLog, "dotween", "DOTweenAnimation")

    self.comBattleLogTween.tween.onRewind = function()
        self.objBattleHideNode.alpha = 0
    end

    self.LoopVerticalScrollRect = self:FindChildComponent(self.objBattleLog, "dotween/HideNode/Scroll View","LoopVerticalScrollRect")
    self.LoopVerticalScrollBar = self:FindChildComponent(self.objBattleLog, "dotween/HideNode/Scroll View/Scrollbar","Scrollbar")
    if self.LoopVerticalScrollRect then
        self.LoopVerticalScrollRect:ClearCells()
        local fun_BattleLog = function(transform, idx)
            self:OnBattleLogChanged(transform, idx)
        end
        self.LoopVerticalScrollRect:AddListener(fun_BattleLog)
    end
end

function BattleUI:Init_BossInfo()
    self.objBoss_Info = self:FindChild(self._gameObject, "BOSS_Info")
    self.objBoss_Info_Name = self:FindChildComponent(self.objBoss_Info, "name","Text")
    self.objBoss_Info_Hudun = self:FindChildComponent(self.objBoss_Info, "hudun","Slider")
    self.objBoss_Info_Life = self:FindChildComponent(self.objBoss_Info, "life","Slider")
    self.objBoss_Info_Lifeother = self:FindChildComponent(self.objBoss_Info, "lifeother","Slider")
    self.objBoss_Info_head = self:FindChildComponent(self.objBoss_Info, "head","Image")
    self.objBoss_Info_lifenum = self:FindChildComponent(self.objBoss_Info, "lifenum","Text")
    self.objBoss_Info:SetActive(false)
end
function BattleUI:Init()
    g_CanSwitchSkill = true
    self:Init_TopObject()
    self:Init_SkillInfo()
    self:Init_RightObject()
    self:Init_BattleLog()
    self:Init_BossInfo()

    local root = DRCSRef.FindGameObj("UIBase")
    self.LuaBehaviour = root:GetComponent("LuaBehaviour")
    self.LuaBehaviour.CheckClickScreen = true

    self:AddEventListener(
        "BATTLE_CREATE_UNIT",
        function(iUnitIndex)
            self:CreateUnit(iUnitIndex)
        end
    )

    self:AddEventListener(
        "BATTLE_DELETE_UNIT",
        function(iUnitIndex)
            self:DeleteUnit(iUnitIndex)
        end
    )

    self:AddEventListener(
        "BATTLE_OPTOVER",
        function()
            self:ShowSkillInfo(false)
            self.objReselectPos_Button:SetActive(false)
        end
    )

    self:AddEventListener(
        "BATTLE_UPDATE_ROUND",
        function(iCurRound)
            self:UpdateRound(iCurRound)
        end
    )
    self:AddEventListener(
        "BATTLE_SHOW_MOVE_ICON_QUEUE",
        function(data)
            self:UpdateMoveIconQueue(data)
        end
    )
    self:AddEventListener(
        "BATTLE_REFRESH_SKILL_UI",
        function(tb)
            self:RefreshSkillUI(tb[1], tb[2])
        end
    )
    self:AddEventListener(
        "BATTLE_REFRESH_SKILL_MAP_LOCKSTATE",
        function(tb)
            self:RefreshSkillButton()
        end
    )
    self:AddEventListener(
        "Battle_GameEnd",
        function(retStream)
            self:GameEnd(retStream)
        end
    )
    self:AddEventListener(
        "BATTLE_SHOW_COMBO",
        function(aiComboBaseID)
            self:ShowCombo(aiComboBaseID)
        end
    )
    self:AddEventListener(
        "BATTLE_ADD_LOG",
        function(strData)
            self:AddBattleLog(strData)
        end
    )

    self:AddEventListener(
        "BATTLE_CLICK_GRID_MOVE",
        function(strData)
            self.objReselectPos_Button:SetActive(true)
        end
    )

    self:InitGridListener()

    self.mSelfNameColor = self.ArenaName_self.color
    self.mEnemyNameColor = self.ArenaName_enemy.color

    if DEBUG_MODE then
        self.TestInfo = self:FindChild(self._gameObject, "TestInfo")
        self.TestInfo_text = self:FindChildComponent(self._gameObject, "TestInfo","Text")
        self.TestInfo:SetActive(true)
        self.TestInfo_close = self:FindChildComponent(self.TestInfo, "Button_close", "Button")
        self:AddButtonClickListener(
            self.TestInfo_close,
            function()
                self.TestInfo:SetActive(false)
            end
        )
    end
    LogicMain:GetInstance().BattleUI=self
end

function BattleUI:ShowSkillUI(bool_show)
    if bool_show then
        self.objSkillInfo.transform:DOLocalMoveY(self.objSkillInfo_Pos.y,1)
    else
        -- self.objSkillInfo.transform.localPosition = self.objSkillInfo_Pos + DRCSRef.Vec3(0,-150,0)
        self.objSkillInfo.transform:DOLocalMoveY(self.objSkillInfo_Pos.y - 250,0.5)
    end
    self:AddTimer(bool_show and 1000 or 500,function()
        GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_AnimEnd,'BattleUI')
    end )
end

function BattleUI:HideUI(bAnim)
    if not self._showUI then return end
    self._showUI = false
    if bAnim then
        self.TopObject.transform:DOLocalMove(self.TopObject_Pos + DRCSRef.Vec3(0,100,0),1):SetId("BATTLEUI_TWEEN_UI")
        self.RightObject.transform:DOLocalMove(self.RightObject_Pos + DRCSRef.Vec3(150,0,0),1):SetId("BATTLEUI_TWEEN_UI")
        self.objBattleLog.transform:DOLocalMove(self.objBattleLog_Pos + DRCSRef.Vec3(-150,0,0),1):SetId("BATTLEUI_TWEEN_UI")
    else
        DRCSRef.DOTween.Kill("BATTLEUI_TWEEN_UI")
        self.TopObject.transform.localPosition = self.TopObject_Pos + DRCSRef.Vec3(0,100,0)
        self:ShowSkillUI(false)
        self.RightObject.transform.localPosition = self.RightObject_Pos + DRCSRef.Vec3(150,0,0)
        self.objBattleLog.transform.localPosition = self.objBattleLog_Pos + DRCSRef.Vec3(-150,0,0)
    end
end

function BattleUI:ShowUI(bAnim)
    if self._showUI then return end
    self._showUI = true
    if bAnim then
        self.TopObject.transform:DOLocalMove(self.TopObject_Pos,1):SetId("BATTLEUI_TWEEN_UI")
        self.RightObject.transform:DOLocalMove(self.RightObject_Pos,1):SetId("BATTLEUI_TWEEN_UI")
        self.objBattleLog.transform:DOLocalMove(self.objBattleLog_Pos,1):SetId("BATTLEUI_TWEEN_UI")
    else
        self.TopObject.transform.localPosition = self.TopObject_Pos
        self:ShowSkillUI(false)
        self.RightObject.transform.localPosition = self.RightObject_Pos
        self.objBattleLog.transform.localPosition = self.objBattleLog_Pos
    end
end

function BattleUI:RefreshAutoBattleUI()
    local l_LogicMain = LogicMain:GetInstance()
    self:setAutoButtonShow(l_LogicMain:IsUnLockAuto())
    self.AutoBattle_Button:InitImageSprite()
    self.AutoBattle_Text.text = "自动"
    if l_LogicMain:IsAutoBattle() then
        self.AutoBattle_Button:ChangeShowSprite()
        self.AutoBattle_Text.text = "自动中"
    end
end

function BattleUI:RefreshUI()
    BattleCamera =  UI_Camera--DRCSRef.FindGameObj("Battle_Camera"):GetComponent("Camera")
    self.iBattleID = nil
    local correction = 0.9
    if IS_WINDOWS then
        screen_radio = DRCSRef.Screen.width/DRCSRef.Screen.height -- PC上动态计算
    end
    if screen_radio > design_radio then
        -- self.roundBGHeight = DRCSRef.Screen.height / UI_CanavsScaler.referenceResolution.y * self.roundBG:GetComponent("RectTransform").rect.height
        self.roundBGHeight = self.roundBG:GetComponent("RectTransform").rect.height
        UI_Camera.transform:DOMoveZ(screen_radio/design_radio * CAMERA_POS.z * correction,1 )
    else
        self.roundBGHeight = self.roundBG:GetComponent("RectTransform").rect.height
    end

    if self.SpeedBattle_Button then
        self.SpeedBattle_Button:InitImageSprite()
        --self.SpeedBattle_Text.text = "加速X1"
        if GetConfig("BattleSpeed") then
            --self.SpeedBattle_Text.text = "加速X2"
            self.SpeedBattle_Button:ChangeShowSprite()
        end
    end

    if self.Pause_Button then
        self.Pause_Button:InitImageSprite()
    end
    local l_LogicMain = LogicMain:GetInstance()
    if l_LogicMain:IsReplaying() then
        self:setAutoButtonShow(false)
        self:ShowArenaName()
        if self.Pause_Button then
            self.Pause_Button.gameObject:SetActive(true)
        end
    else
        if self.ArenaName then
            self.ArenaName:SetActive(false)
        end
        if self.Pause_Button then
            self.Pause_Button.gameObject:SetActive(false)
        end
        self:RefreshAutoBattleUI()
    end

    self.objBoss_Info:SetActive(false)

    self:UpdateRound(1)
    self:SetModeText()
    self:ShowSkillInfo(false)
    self:HideUI()
    self:ClearHeadIcon()
    self:ShowCombo({})
    self.objReselectPos_Button:SetActive(false)
    -- 战斗开始的时候, 关闭快进对话模式
    DialogRecordDataManager:GetInstance():SetFastChatState(false)
end
function BattleUI:ShowTestInfo()
    if DEBUG_MODE then
        local str = {"speed:" ..  DRCSRef.Time.timeScale}
        str[#str+1] = " BATTLESpeed:" .. GetSpeed(SPEED_TYPE.BATTLE)
        str[#str+1] = " SKILLSpeed:" .. GetSpeed(SPEED_TYPE.SKILL)
        str[#str+1] = " ROUNDSpeed:" .. GetSpeed(SPEED_TYPE.ROUND)
        str[#str+1] = " NORMALSpeed:" .. GetSpeed(SPEED_TYPE.NORMAL)
        self.TestInfo_text.text = table.concat(str,'\n')
    end
end

function BattleUI:Update()
    self:ShowTestInfo()
end

function BattleUI:OnDestroy()
    --self.Camera.tag = "Untagged"
    --UI_Camera.tag = "MainCamera"
    -- self.SpineRoleUI:Close()
    self.comBattleLogTween.tween.onRewind = nil
    --RemoveEventTrigger(self.Round_Button)
    -- UI_Camera.clearFlags = CS.UnityEngine.CameraClearFlags.SolidColor
    self.LuaBehaviour.CheckClickScreen = false
    DRCSRef.Time.timeScale = 1
    UI_Camera.transform.position = CAMERA_POS
    BattleDataManager:GetInstance():clearRoundDescTips()
    -- DRCSRef.ObjDestroy(self.battlefile)
end


function BattleUI:setAutoButtonShow(bLock)
    --dprint('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',bLock)
    self.iBattleID = LogicMain:GetInstance():GetBattleTypeID()
    --临时处理，宇文庄初始战斗屏蔽自动战斗
    if not LogicMain:GetInstance():IsAutoBattle() and self.iBattleID == 1737 then
        bLock = false
    end
    self.AutoBattle_Button.gameObject:SetActive(bLock)
    -- 更新下按钮状态
    self.AutoBattle_Button:InitImageSprite()
    if LogicMain:GetInstance():IsAutoBattle() then
        self.AutoBattle_Button:ChangeShowSprite()
    end
end

function BattleUI:RefreshSkillUI(martialData, iChooseSkillIndex)
    self.iMartialCount = 0
    self.akMartialData = {}
    local temp = {}

    for i,v in pairs(martialData) do
        if v:IsEmbattle() then
            table.insert(temp,i)
        end
    end
    self.iCurChooseSkillIndex = 1
    table.sort(temp,function(a,b) return a < b end)
    for k, v in pairs(temp) do
        if martialData[v]:IsAoYi() then
            self.akMartialData[self.iAoYIIndex] = ReturnReadOnly(martialData[v])
            if v == iChooseSkillIndex then
                self.iCurChooseSkillIndex = -1
            end
        else
            self.iMartialCount = self.iMartialCount + 1
            self.akMartialData[self.iMartialCount] = martialData[v]
            if v == iChooseSkillIndex then
                self.iCurPage = (self.iMartialCount - 1) // PAGE_SKILL_COUNT + 1
                self.iCurChooseSkillIndex = self.iMartialCount
            end
        end
    end
    --skillIndex是界面上按钮的索引  跟实际武学技能的索引不一致
    if iChooseSkillIndex == 0 then
        local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
        if kMartialData then
            local iMartialIndex = kMartialData.iMartialIndex
            LuaEventDispatcher:dispatchEvent("UI_CHANGE_SKILL", iMartialIndex)
        end
    end

    self:RefreshPageButton()
    -- self:RefreshSkillButton()
    self:ShowSkillInfo(true)
end

function BattleUI:InitGridListener()

    self:AddEventListener(
        "BATTLE_SHOW_BOSS_INFO",
        function(unit)
            self:UpdateBossInfo(unit)
        end
    )
    self:AddEventListener(
        "BATTLE_SHOW_UI",
        function(boolean_show)
            self:ShowUI(boolean_show)
        end
    )
end



function BattleUI:RegisterHandler(obj,path,callBack1,callBack2,callBack3,callBack4)
    if IsValidObj(obj) and path then
        local comUIAction = self:FindChildComponent(obj, path, "LuaUIAction")
        if IsValidObj(comUIAction) then
            local PointerDownCallback = function(obj, eventData)
                if callBack1 then
                    callBack1()
                end
            end
            local PointerUpCallback = function(obj, eventData)
                if callBack2 then
                    callBack2()
                end
            end
            local PointerEnterCallback = function (obj, eventData)
                if callBack3 then
                    callBack3()
                end
            end
            local PointerExitCallback = function (obj, eventData)
                if callBack4 then
                    callBack4()
                end
            end
            --SetPointerExitAction
            --SetPointerEnterAction
            comUIAction:SetPointerDownAction(PointerDownCallback)
            comUIAction:SetPointerUpAction(PointerUpCallback)
            comUIAction:SetPointerEnterAction(PointerEnterCallback)
            comUIAction:SetPointerExitAction(PointerExitCallback)
        end
    end
end

function BattleUI:InitSkillPageButton()
    self.objSwitchPage = self:FindChild(self._gameObject, "SkillInfo/DownPanel/SwitchPage")
    self.objNextPageButton = self:FindChildComponent(self._gameObject, "SkillInfo/DownPanel/SwitchPage/NextPage_Button", "Button")
    if self.objNextPageButton then
        self:AddButtonClickListener(
            self.objNextPageButton,
            function()
                self:OnClick_PageButton(1)
            end
        )
    end
    self.objPrePageButton = self:FindChildComponent(self._gameObject, "SkillInfo/DownPanel/SwitchPage/PrePage_Button", "Button")
    if self.objPrePageButton then
        self:AddButtonClickListener(
            self.objPrePageButton,
            function()
                self:OnClick_PageButton(-1)
            end
        )
    end
    self.objPageText = self:FindChildComponent(self._gameObject, "SkillInfo/DownPanel/SwitchPage/Page_Text", "Text")
end

function BattleUI:RefreshPageButton()
    self.iMaxPage = math.ceil(self.iMartialCount / PAGE_SKILL_COUNT)
    self.objPageText.gameObject:SetActive(self.iMaxPage > 1)
    self.objSwitchPage:SetActive(self.iMaxPage > 1)
    self:OnClick_PageButton(0)
end

function BattleUI:RefreshSkillButton()
    local iStartIndex = (self.iCurPage - 1) * PAGE_SKILL_COUNT
    local iIndex = 0
    for i = 1, PAGE_SKILL_COUNT do
        iIndex = iStartIndex + i
        local info = self.akMartialData[iIndex]
        self:SetSkillButtonInfo(self.objSkills[i], info)
    end
    self.objSkills[-1]:SetActive(self.akMartialData[self.iAoYIIndex] ~= nil)
    if self.akMartialData[self.iAoYIIndex] then
        self:SetSkillButtonInfo(self.objSkills[self.iAoYIIndex], self.akMartialData[self.iAoYIIndex])
    end
end

function BattleUI:RefreshSkillMPLock()
    local iStartIndex = (self.iCurPage - 1) * PAGE_SKILL_COUNT
    local iIndex = 0
    for i = 1, PAGE_SKILL_COUNT do
        iIndex = iStartIndex + i
        local info = self.akMartialData[iIndex]
        self:RefreshMPLock(self.objSkills[i], info)
    end
    if self.akMartialData[self.iAoYIIndex] then
        self:RefreshMPLock(self.objSkills[self.iAoYIIndex], self.akMartialData[self.iAoYIIndex])
    end
end

function BattleUI:RefreshMPLock(objButton, kMartialData)
    if kMartialData and not kMartialData:isFengYin() and not kMartialData:isDizzy() then
        local curOpt = LogicMain:GetInstance():GetCurOptUnit()
        if curOpt then
            self.SkillIconUI:SetMPLock(objButton,(kMartialData.iCostMP or 0)>(curOpt.iMP or 0))
        end
    end
end
function BattleUI:SetSkillButtonInfo(objButton, kMartialData)
    objButton.gameObject:SetActive(kMartialData ~= nil)
    if kMartialData == nil then return end
    local bChoose = false
    if self.akMartialData[self.iCurChooseSkillIndex] then
        bChoose = kMartialData.iMartialIndex == self.akMartialData[self.iCurChooseSkillIndex].iMartialIndex
    end
    objButton.name = "martial"..kMartialData.iMartialID
    self.SkillIconUI:UpdateSkillIcon(objButton,kMartialData.skillID)
    self.SkillIconUI:SetChoose(objButton,bChoose)

    self.SkillIconUI:SetBannedLock(objButton,kMartialData:isFengYin() or kMartialData:isDizzy())
    if not kMartialData:isFengYin() and not kMartialData:isDizzy() then
        local curOpt = LogicMain:GetInstance():GetCurOptUnit()
        if curOpt then
            self.SkillIconUI:SetMPLock(objButton,(kMartialData.iCostMP or 0)>(curOpt.iMP or 0))
        end
    end

    self.SkillIconUI:SetLayer(objButton,kMartialData.iMartialLevel)
    local textTips = self:FindChildComponent(objButton, "Text_tips", "Text")
    if textTips then
        textTips.text = getRankBasedText(kMartialData.Rank,kMartialData["name"])
        textTips.gameObject:SetActive(bChoose)
    end

    local comColdTimeText = self:FindChildComponent(objButton, "ColdTime/Text", DRCSRef_Type.Text)
    if comColdTimeText then
        if kMartialData:isInColdTime() then
            comColdTimeText.gameObject:SetActive(true)
            comColdTimeText.text = tostring(kMartialData.coldTime)
        else
            comColdTimeText.gameObject:SetActive(false)
        end
    end
    local comColdTimeImage = self:FindChildComponent(objButton, "ColdTime/Mark", DRCSRef_Type.Image)
    if comColdTimeImage then
        if kMartialData:isInColdTime() then
            comColdTimeImage.gameObject:SetActive(true)
            local maxColdTime = MartialDataManager:GetInstance():GetMartialMaxColdTime(kMartialData.iMartialID)
            local percent = 1
            if maxColdTime > 0 then
                percent = kMartialData.coldTime / maxColdTime
            end
            comColdTimeImage.fillAmount = percent
        else
            comColdTimeImage.gameObject:SetActive(false)
        end
    end

    do return end
    -- objButton:UpdateLockState(nil,)
    local borderImage = self:FindChildComponent(objButton, "border", "Image")
    if borderImage then
        borderImage.sprite = GetAtlasSprite("SkillBorderAtlas",RANK_SKILL_BORDER[kMartialData.Rank])
    end
    local iconImage = self:FindChildComponent(objButton, "Icon", "Image")
    if iconImage then
        iconImage.sprite = GetSprite(kMartialData.Icon)
    end
    local objJueXue = self:FindChild(objButton, "juexue")
    if objJueXue then
        objJueXue:SetActive(kMartialData:IsJueZhao())
    end
    local objAoYi = self:FindChild(objButton, "aoyi")
    if objAoYi then
        objAoYi:SetActive(kMartialData:IsAoYi())
    end
    local objSkillChoose = self:FindChild(objButton, "skill_choose")
    if objSkillChoose then
        objSkillChoose:SetActive(bChoose)
    end
end

function BattleUI:UpdateRoundText(round)
    self.objRoundText_18:SetActive(false)
    self.objRoundText_19:SetActive(false)
    self.objRoundText_20:SetActive(false)

    if round == 18 then
        self.objRoundText_18:SetActive(true)
        self.objRoundButtonRedBG:SetActive(true)
        self.objRoundText:SetActive(false)
    elseif round == 19 then
        self.objRoundText_19:SetActive(true)
    elseif round == 20 then
        self.objRoundText_20:SetActive(true)
    else
        self.comRoundText.text = self.curRount
        self.objRoundText:SetActive(true)
        self.objRoundButtonRedBG:SetActive(false)
    end
end

function BattleUI:UpdateRound(iCurRound)
    if iCurRound > 20 then return end
    self.curRount = iCurRound
    self.comRoundText.text = self.curRount
    self:UpdateRoundText(iCurRound)
    --self:AddBattleLog({{string.format("-----第%d回合-----", iCurRound),TBoolean.BOOL_YES}})
    self:AddBattleLog({{string.format("<color=#FFFF00>第%d回合</color>", iCurRound),TBoolean.BOOL_YES}})
    if iCurRound == 1 then
        -- BattleDataManager:GetInstance():InitRoundDescTips()
        return
    end
    --若干回合后开始加速
    for i=#RoundSpeedInfo,1,-1 do
        if self.curRount >= RoundSpeedInfo[i][1] then
            SetSpeed(SPEED_TYPE.ROUND,RoundSpeedInfo[i][2])
            break
        end
    end
    local hurtupround = {
        ['5'] = 0.5,
        ['10'] = 1,
        ['12'] = 2,
        ['15'] = 4,
    }
    local hurtPercent = hurtupround[tostring(self.curRount)]
    if hurtPercent and self.curRount >= 5 then
        local t = {
            ['title'] = '速战速决',
            ['text'] = '基础伤害+' .. hurtPercent * 100 .. '%',
        }
        self:OnShowRoundInfoTip(t)
        t = {
            '速战速决',
            {'基础伤害+' .. hurtPercent * 100 .. '%'},
        }
        local list = {}
        list[#list+1] = t
        BattleDataManager:GetInstance():AddRoundDescTipsInfo(list,'other')
    end

    if self.curRount == 18 then
        local t = {
            ['title'] = '最后3回合',
            ['text'] = '20回合结束战斗',
        }
        self:OnShowRoundInfoTip(t)
    elseif self.curRount == 19 then
        local t = {
            ['title'] = '最后2回合',
            ['text'] = '20回合结束战斗',
        }
        self:OnShowRoundInfoTip(t)
    elseif self.curRount == 20 then
        local t = {
            ['title'] = '最后1回合',
            ['text'] = '20回合结束战斗',
        }

        self:OnShowRoundInfoTip(t)
    end
end

--行动条击退
function BattleUI:UpdateRepelMoveIcon(iUnitIndex,iPassTime)
    if iPassTime == nil then return end
    if iPassTime > 1 then iPassTime = 1 end
    local objMoveIcon = self._objUnitIndex2MoveIcon[iUnitIndex]
    if objMoveIcon ~= nil then
        local y = objMoveIcon.transform.localPosition.y
        local delta = self.roundBGHeight*iPassTime
        if y + delta < 0 then
            delta = -y
        end
        if delta ~= 0 then
            objMoveIcon.transform:DOLocalMoveY(delta,0.5):SetRelative()
        end
    end
end

function BattleUI:CreateUnit(iUnitIndex)
    local curUnit = UnitMgr:GetInstance():GetUnit(iUnitIndex)
    -- 创建头像
    local objMoveIcon = self._objUnitIndex2MoveIcon[iUnitIndex]
    if objMoveIcon == nil then
        objMoveIcon = self:LoadPrefabFromPool("Battle/Move_Icon", self.objRound_IconStartNode, true)
        objMoveIcon.transform.localScale = DRCSRef.Vec3One
        self._objUnitIndex2MoveIcon[iUnitIndex] = objMoveIcon
        ---头像
        local path = ""
        if curUnit.uiModleID ~= 0 then
            path = lTB_RoleModel[curUnit.uiModleID] and lTB_RoleModel[curUnit.uiModleID].Head or ""
        else
            local roleData = TB_Role[curUnit.uiRoleTypeID]
            if roleData then
                path = lTB_RoleModel[roleData.ArtID] and lTB_RoleModel[roleData.ArtID].Head or ""
            end
        end
        local imgHead = self:FindChildComponent(objMoveIcon, "Head", "Image")
        imgHead.sprite = GetSprite(path)

        --TODO 捏脸20 头像 用服务器下发数据判断
        local kRoleFaceData = curUnit.kRoleFaceData
        local objParent = self:FindChild(objMoveIcon, "CreateHead")
        local objCreateFace = self:FindChild(objMoveIcon, "CreateHead/Create_Head(Clone)")
        if kRoleFaceData then
            if objCreateFace then
                objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImageByData(kRoleFaceData, objParent, objCreateFace)
                objCreateFace:SetActive(true)
            else
                objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImageByData(kRoleFaceData, objParent)
            end
            imgHead.gameObject:SetActive(false)
        else
            if objCreateFace then
                objCreateFace:SetActive(false)
            end
            imgHead.gameObject:SetActive(true)
        end
        self:AddTimer(100,function ()
            -- body
            objMoveIcon.transform.localPosition = DRCSRef.Vec3Zero
        end)
    end
end
function BattleUI:ClearHeadIcon()
    for iUnitIndex,objMoveIcon in pairs(self._objUnitIndex2MoveIcon) do
        self:ReturnObjToPool(objMoveIcon)
    end
    self._objUnitIndex2MoveIcon = {}
end
function BattleUI:DeleteUnit(iUnitIndex)
    local curUnit = UnitMgr:GetInstance():GetUnit(iUnitIndex)
    -- 创建头像
    local objMoveIcon = self._objUnitIndex2MoveIcon[iUnitIndex]
    if objMoveIcon ~= nil then
        self:ReturnObjToPool(objMoveIcon)
        self._objUnitIndex2MoveIcon[iUnitIndex] = nil
    end
end

function BattleUI:processMoveIcons(showData)
    local PATHLENGTH = self.roundBGHeight
    for i = 1, #showData do
        local data = showData[i]
        local tarPos = (1 - data.fMovePercent) * PATHLENGTH
        data.tarPos = tarPos
    end
    local sort = function(kUnitA,kUnitB)
        if kUnitA.tarPos ~= kUnitB.tarPos then
            return  kUnitA.tarPos < kUnitB.tarPos
        end
        return kUnitA.iUnitIndex > kUnitB.iUnitIndex
    end
    table.sort(showData,sort)

    local iconWidth = 60
    local lMax = math.max
    local lMin = math.min
    -- 第一遍从头到尾
    for i = #showData,2,-1 do
        local data = showData[i]
        local data2 = showData[i-1]
        if data.tarPos - data2.tarPos < iconWidth then
            data2.tarPos = lMax(data.tarPos - iconWidth,0)
        end
    end

    -- 第二遍从尾到头
    for i = 1,#showData - 1 do
        local data = showData[i+1]
        local data2 = showData[i]
        if data.tarPos - data2.tarPos < iconWidth then
            data.tarPos = lMin(data2.tarPos + iconWidth,PATHLENGTH)
        end
    end

    -- 第三遍 如果还有则将重叠的平均分配
    local start_pos = 0
    local startPos = showData[#showData].tarPos
    for int_i=#showData,2,-1 do
        if startPos - showData[int_i-1].tarPos < iconWidth then
            if start_pos == 0 then
                start_pos = int_i
            end
            startPos = startPos - iconWidth
        elseif start_pos ~= 0 then
            local dis = showData[start_pos].tarPos - showData[int_i].tarPos
            local dis_per = dis / ( start_pos - int_i)
            for int_j = start_pos-1,int_i,-1 do
                showData[int_j].tarPos = math.max(showData[start_pos].tarPos - dis_per * (start_pos - int_j),0)
            end
            startPos = showData[start_pos].tarPos
            start_pos = 0
        end
    end

    if start_pos ~= 0 then
        local int_i = 1
        local dis = showData[start_pos].tarPos - showData[int_i].tarPos
        local dis_per = dis / (start_pos - int_i)
        for int_j = start_pos-1,int_i,-1 do
            showData[int_j].tarPos = math.max(showData[start_pos].tarPos - dis_per * (start_pos - int_j),0)
        end
    end
end

function BattleUI:UpdateMoveIconQueue(showData)
    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():SetCanUpdate(true)
    if showData == nil then return end
    local iDataCount = #showData
    local iOffsetY = BATTLE_MOVE_ICON_OFFSET_Y
    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():SetCanUpdate(true)
    self:processMoveIcons(showData)
    local minDelay = showData['minDelay'] or 1
    minDelay = minDelay * HEADICON_SPEED_RATIO
    for i = 1, #showData do
        local data = showData[i]
        local objMoveIcon = self._objUnitIndex2MoveIcon[data.iUnitIndex]
        if objMoveIcon == nil then
            self:CreateUnit(data.iUnitIndex)
            objMoveIcon = self._objUnitIndex2MoveIcon[data.iUnitIndex]
            if objMoveIcon == nil then
                return
            end
        end
        local kOldMoveUnit = LogicMain:GetInstance().kUnitMgr.kOldMoveUnit
        if kOldMoveUnit and kOldMoveUnit:GetUnitIndex() == data.iUnitIndex then
            objMoveIcon.transform.localPosition = DRCSRef.Vec3(0, -BATTLE_MOVE_ICON_OFFSET_Y  * 7.5, 0)
            LogicMain:GetInstance().kUnitMgr.kOldMoveUnit = nil
        -- else
        end
        local tarPos = data.tarPos
        if objMoveIcon.transform.localPosition.y > tarPos then
            objMoveIcon.transform.localPosition = DRCSRef.Vec3Zero
        end
        local twn = objMoveIcon.transform:DOLocalMoveY(tarPos,minDelay)
        AddTrackTweener(twn,0,minDelay)
        objMoveIcon.transform:SetSiblingIndex(i)
        self:FindChild(objMoveIcon, "Self_Camp_BG"):SetActive(data.iCamp ~= SE_CAMPB)
        self:FindChild(objMoveIcon, "Enemy_Camp_BG"):SetActive(data.iCamp == SE_CAMPB)
    end
    local kCurOptUnit = showData['unit']
    if kCurOptUnit then
        AddTrackUnitFunc(kCurOptUnit,minDelay*1000,"ShowBossInfo")
        AddTrackUnitFunc(kCurOptUnit,minDelay*1000,"RoundRestore")
        AddTrackUnitFunc(kCurOptUnit,minDelay*1000,"ShowComboUI")
        if not LogicMain:GetInstance():IsReplaying() and showData['skipRound'] == false  then
            if kCurOptUnit:CanControl() then
                -- AddTrackUnitFunc(kCurOptUnit,minDelay*1000,"ShowSkillUI")
                -- AddTrackUnitFunc(kCurOptUnit,minDelay*1000,"ShowCanMoveGrid")
            elseif kCurOptUnit:NotSelfCamp() then
                AddTrackLambda(minDelay*1000,function()
                    LogicMain:GetInstance():SendAutoCmd(kCurOptUnit:GetUnitIndex())
                end)
            end
        end
    end
    TimeLineHelper:GetInstance():AddExMaxTime(HEADICON_SPEED_PAUSE)
end

function BattleUI:PlayComboComplete(iColumn, iMaxRowCount)
    if self.objComboSkills[iColumn] then
        for i=1,#self.objComboSkills[iColumn] do
            local comboObj = self.objComboSkills[iColumn][i]
            SkillIconUIInst:SetChoose(self:FindChild(comboObj, "SkillIconUI"),true)
            comboObj:GetComponent("CanvasGroup"):DOFade(0,0.2):SetLoops(10, DRCSRef.LoopType.Yoyo);
        end
    end
end

function BattleUI:SetComboInfo(iMartialTypeID, iRow, iColumn, iMaxRowCount,iCount)
    if self.objComboSkills[iColumn] == nil then
        self.objComboSkills[iColumn] = {}
    end
    if self.objComboSkills[iColumn][iRow] == nil then
        self.objComboSkills[iColumn][iRow] = self:LoadPrefabFromPool("Battle/Battle_ComboSkill", self.objComboNode)
        self.objComboSkills[iColumn][iRow].transform.localPosition =
            DRCSRef.Vec3((iRow - 1) * 155, (iColumn - 1) * -80, 0)
    end
    local obj = self.objComboSkills[iColumn][iRow]
    obj:GetComponent("CanvasGroup").alpha = 1
    obj:SetActive(true)
    if iRow == 1 then
        self:FindChild(obj, "AddIcon"):SetActive(false)
        self:FindChild(obj, "EqualIcon"):SetActive(false)
    else
        self:FindChild(obj, "AddIcon"):SetActive(iRow ~= iMaxRowCount)
        self:FindChild(obj, "EqualIcon"):SetActive(iRow == iMaxRowCount)
    end
    --[todo]设置具体的icon 等
    local kMartialTable = GetTableData("Martial",iMartialTypeID)
    if kMartialTable and kMartialTable.MartMovIDs then
        local kMartialItemTable = TableDataManager:GetInstance():GetTableData("MartialItem", kMartialTable.MartMovIDs[1])
        if kMartialItemTable then
            local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", kMartialItemTable.SkillID1)
            local skillIconNode = self:FindChild(obj, "SkillIconUI")
            SkillIconUIInst:UpdateUI(skillIconNode,kMartialItemTable.SkillID1)
            SkillIconUIInst:SetTipsText(skillIconNode)
            SkillIconUIInst:SetLayer(skillIconNode)
            if iRow <= iCount + 1 then
                SkillIconUIInst:SetChoose(skillIconNode,true)
            end
        end
    else
        derror("SetComboInfo error : iMartialTypeID=" .. iMartialTypeID)
    end


end

--界面隐藏的时候 会调用
function BattleUI:OnDisable()
    if self.bShowBattleLogState then
        self:OnClick_BattleLogButton()
    end
    -- 清理log
    self.battleLog = {}
    self.simpleBattleLog = {}
    self:RefreshBattleLog()
    -- 清理头像
    self:ClearHeadIcon()
end

--打开的时候会调用
function BattleUI:OnEnable()
end

function BattleUI:ShowCombo(aiComboBaseID)
    if aiComboBaseID == nil then return end
    if aiComboBaseID and aiComboBaseID.hasComplete then
        aiComboBaseID = {}
    end
    local iMaxColumn = #aiComboBaseID
    local l_tb_Combo = TableDataManager:GetInstance():GetTable("Combo")
    for iColumn = 1, iMaxColumn do
        SeBattle_ComboRecord = aiComboBaseID[iColumn]
        local data = l_tb_Combo[SeBattle_ComboRecord.uiComboID]
        if data then
            local martialID = clone(data.MartialList)
            martialID[#martialID + 1] = data.TrigMartial
            local iMaxRowCount = #martialID

            for iRow = 1, iMaxRowCount do
                self:SetComboInfo(martialID[iRow], iRow, iColumn, iMaxRowCount,SeBattle_ComboRecord.iCount)
            end
            if SeBattle_ComboRecord.iCount + 2 == iMaxRowCount then
                self:PlayComboComplete(iColumn,iMaxRowCount)
                aiComboBaseID.hasComplete = true
            end

            for iRow = iMaxRowCount + 1, #self.objComboSkills[iColumn] do
                self.objComboSkills[iColumn][iRow]:SetActive(false)
            end
        end
    end
    for iColumn = iMaxColumn + 1, #self.objComboSkills do
        for iRow = 1, #self.objComboSkills[iColumn] do
            self.objComboSkills[iColumn][iRow]:SetActive(false)
        end
    end
end

local capacity = 0
function BattleUI:AddBattleLog(strData)
    --local oldvalue = self.LoopVerticalScrollBar.value
    if not IsValidObj(self.LoopVerticalScrollRect) then
        return
    end
    local iIndex = #self.battleLog
    for k, v in ipairs(strData) do
        iIndex = iIndex + 1
        self.battleLog[iIndex] = v[1]
        if v[2] == TBoolean.BOOL_YES then
            table.insert(self.simpleBattleLog,iIndex)
        end
    end
    self:RefreshBattleLog()
end

function BattleUI:RefreshBattleLog()
    local iOldCount = self.LoopVerticalScrollRect.totalCount
    local iNewCount = 0
    if self.bSimpleMode then
        iNewCount = #self.simpleBattleLog
    else
        iNewCount = #self.battleLog
    end

    if iOldCount == iNewCount then
        return
    end
    self.LoopVerticalScrollRect.totalCount = iNewCount
    --local offset = #self.battleLog - self.LoopVerticalScrollRect.totalCount
    if not self.init or self.LoopVerticalScrollRect.totalCount <= 8 then
        self.init = true
        self.LoopVerticalScrollRect:RefillCells()
    else
        --一旦移动了 就不让他自动滚到 最下面
        --移动到最上面的时候 ，默认有新的 也移动到最下面
        if self.bChangeLogMode or self.LoopVerticalScrollBar.value >= 0.99 or self.LoopVerticalScrollBar.value == 0.0 then
            if self.bChangeLogMode == true then
                self.LoopVerticalScrollRect.verticalNormalizedPosition = 0
            end
            -- if oldvalue == 1 then
                DRCSRef.DOTween.To(function(x)
                    local node = GetUIWindow("BattleUI")
                    if node and node.LoopVerticalScrollRect then
                        node.LoopVerticalScrollRect.verticalNormalizedPosition = x
                    end
                end, self.LoopVerticalScrollRect.verticalNormalizedPosition, 1, 0.2)
            -- end
            self.LoopVerticalScrollRect:RefillCellsFromEnd()
            self.bChangeLogMode = false
            -- self.LoopVerticalScrollRect:RefreshCells()
            -- self.LoopVerticalScrollRect:RefreshNearestCells()
        end
    end
end

function BattleUI:OnBattleLogChanged(item,idx)
    if not IsValidObj(item) then
        return
    end

    local iIndex = idx + 1
    if self.bSimpleMode then
        iIndex = self.simpleBattleLog[idx + 1]
    end

    local content = self.battleLog[iIndex]
    local text = self:FindChildComponent(item.gameObject,"Text","Text")
    --local text = item:GetComponent("Text")
    if content and IsValidObj(text) then
        text.text = content
        item.gameObject:SetActive(true)
    else
        item.gameObject:SetActive(false)
    end
end

function BattleUI:OnClick_PageButton(iAddPage)
    if self.iCurPage + iAddPage <= self.iMaxPage and self.iCurPage + iAddPage > 0 then
        self.iCurPage = self.iCurPage + iAddPage
        self.objNextPageButton.gameObject:SetActive(self.iCurPage < self.iMaxPage)
        self.objPrePageButton.gameObject:SetActive(self.iCurPage > 1)
        self.objPageText.text = self.iCurPage
        self:RefreshSkillButton()

        local l_curPageSkillCount = PAGE_SKILL_COUNT
        if self.iCurPage == self.iMaxPage then
            l_curPageSkillCount = (self.iMartialCount-1) % PAGE_SKILL_COUNT + 1 --计算当前页有几个技能
        end

        --检查是否所有技能不可用
        local l_AllSkillCantUse = true
        for i = 1,l_curPageSkillCount do
            if self:CheckSkill(i) == true then
                l_AllSkillCantUse = false
                self:OnClick_Skill(i)
            end
        end
        if l_AllSkillCantUse then
            self:AllSkillIsFengYin()
        end
    end
end

function BattleUI:OnHandlePointerDown(iIndex)
    self.isPointerUp = false
    self.pointTime = DRCSRef.Time.realtimeSinceStartup
    self:OnClick_Skill(iIndex)
    -- self._coroutine.pointerSkill = CS_Coroutine.start(function()
    --     while(not self.isPointerUp) do
    --         coroutine.yield(nil)
    --         if DRCSRef.Time.realtimeSinceStartup - self.pointTime > POINT_INTERVAL then
    --             self:OnClick_ShowSkillTip(iIndex)
    --             break
    --         end
    --     end
    -- end)
end

function BattleUI:OnHandlePointerUp(iIndex)
    self.isPointerUp = true
    --CS_Coroutine.stop(self._coroutine.pointerSkill)
    --RemoveWindowImmediately("TipsPopUI")
end

function BattleUI:OnHandlePointerEnter(iIndex)
    g_CanSwitchSkill=false
    self:OnClick_ShowSkillTip(iIndex)
    dprint("Hello")
end

function BattleUI:OnHandlePointerExit(iIndex)
    g_CanSwitchSkill=true
    RemoveWindowImmediately("TipsPopUI")
    -- dprint("Hello")
end

function BattleUI:OnClick_Skill(iIndex)
    local objIndex = iIndex
    local iSkillIndex = iIndex == -1 and iIndex or (self.iCurPage - 1) * PAGE_SKILL_COUNT + iIndex
    local kMartialData = self.akMartialData[iSkillIndex]
    local curUnit = LogicMain:GetInstance():GetCurOptUnit()
    if not kMartialData or not curUnit then
        return
    end
    if kMartialData:isInColdTime() then
        local coldTime = kMartialData:getColdTime()
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "武学冷却中，剩余" .. coldTime .. '回合')
        return
    end
    if kMartialData:isDizzy() then
        SystemUICall:GetInstance():Toast("角色被眩晕")
        return
    end
    if kMartialData:isFengYin() then
        SystemUICall:GetInstance():Toast("武学被封印")
        return
    end
    if (kMartialData.iCostMP or 0) > (curUnit.iMP or 0) then
        SystemUICall:GetInstance():Toast('真气不足 所需:' .. (kMartialData.iCostMP or 0) .. ' 现有:' .. (curUnit.iMP or 0))
        return
    end
    if self.iCurChooseSkillIndex ~= iSkillIndex then
        if kMartialData then
            local oldObjIndex = self.iCurChooseSkillIndex - (self.iCurPage - 1) * PAGE_SKILL_COUNT
            self.iCurChooseSkillIndex = iSkillIndex
            if self.objSkills[iIndex] then
                self:FindChild(self.objSkills[iIndex], "Text_tips"):SetActive(true)
                self:FindChild(self.objSkills[iIndex], "skill_choose"):SetActive(true)
            end
            if self.objSkills[oldObjIndex] then
                self:FindChild(self.objSkills[oldObjIndex], "Text_tips"):SetActive(false)
                self:FindChild(self.objSkills[oldObjIndex], "skill_choose"):SetActive(false)
            end
            local iMartialIndex = kMartialData.iMartialIndex

            LuaEventDispatcher:dispatchEvent("UI_CHANGE_SKILL", iMartialIndex)
        else
            derror("click nil skill Index " .. iSkillIndex)
        end
    end
end

function BattleUI:OnClick_ShowSkillTip(iIndex)
    dprint("click show Tips"..iIndex)
    local index = iIndex
    if iIndex >= 0 then 
        index = iIndex + (self.iCurPage - 1) * PAGE_SKILL_COUNT 
    end
    local tips = TipsDataManager:GetInstance():GetBattleSkillTips(self.akMartialData,index)
    if tips == nil then return end
    --标签偏移量向上移动120像素点
    tips.movePositions = {
        x = 0,
        y = 120
    }
    tips.isSkew = true
	OpenWindowImmediately("TipsPopUI", tips)
end

function BattleUI:OnClick_ReselectPosButton()
    LuaEventDispatcher:dispatchEvent("BattleUI_ReelectPos")
end

function BattleUI:OnClick_EndTurnButton()
    LuaEventDispatcher:dispatchEvent("BattleUI_UnitEndTurn", false)
end

function BattleUI:OnClick_ResetPosButton()
    if self.objReselectPos_Button.activeSelf then
        self.ReselectPos_Button.onClick:Invoke()
    end
end

function BattleUI:OnClick_BattleLogButton()
    if self.bShowBattleLogState then
        self.comBattleLogTween:DOPause()
        self.objBattleLogDotween.transform:DOLocalMoveX(0,1).OnComplete(function()
            self.objBattleHideNode.alpha = 0
        end)
    else
        self.comBattleLogTween:DOPause()
        self.objBattleLogDotween.transform:DOLocalMoveX(300,1)
        self.objBattleHideNode.alpha = 1
    end
    self.bShowBattleLogState = not self.bShowBattleLogState
end

function BattleUI:OnClick_ChnageModeButton()
    self.bSimpleMode = not self.bSimpleMode
    self.bChangeLogMode = true
    self:SetModeText()
    self:RefreshBattleLog()
    SetConfig("BattleLogMode", self.bSimpleMode)

end

function BattleUI:SetModeText()

    local bg = self:FindChild(self.ChnageMode_Button.gameObject, 'Image_BG')
    local lock = self:FindChild(self.ChnageMode_Button.gameObject, 'Image_Lock')
    local unlock = self:FindChild(self.ChnageMode_Button.gameObject, 'Image_Unlock')

    if self.bSimpleMode then
        bg:SetActive(true);
        lock:SetActive(false);
        unlock:SetActive(true);
    else
        bg:SetActive(false);
        lock:SetActive(true);
        unlock:SetActive(false);
    end
end

function BattleUI:OnClick_Round_Button()
    local tips = BattleDataManager:GetInstance():GetRoundDescTips()
    if tips == nil then return end
    tips.movePositions = {
        x = 60,
        y = 0
    }
    tips.isSkew = true
	OpenWindowImmediately("TipsPopUI", tips)
end

function BattleUI:OnShowRoundInfoTip(string_text, time, delayTime)
    time = time or 1
    delayTime = delayTime or 4500
    self.Round_tip_title.text = string_text.title
    self.Round_tip_desc.text = string_text.text
    self.Round_tip:SetActive(true)
    self.Round_tipGroup.alpha = 0
    self.Round_tipGroup:DR_DOFade(1,time)

    self:AddTimer(delayTime,function()
        if self.Round_tipGroup then
            self.Round_tipGroup:DR_DOFade(0,time)
        end
    end)
end

function BattleUI:OnClick_ReturnButton()
    PauseGame()
    if LogicMain:GetInstance():IsScriptArenaBattle() then
        OpenWindowImmediately("GeneralBoxUI", {GeneralBoxType.BATTLE_GIVEUP, "是否要退出战斗？中途退出默认失败！"})
    else
        OpenWindowImmediately("GeneralBoxUI", {GeneralBoxType.BATTLE_GIVEUP, "是否要退出战斗"})
    end
end


function BattleUI:UpdateBossInfo(unit_boss)
    self.objBoss_Info:SetActive(true)
    self.objBoss_Info_head.sprite = GetSprite(unit_boss:GetHead())
    self.objBoss_Info_Name.text = unit_boss:GetName()
    self.objBoss_Info_Hudun.value = 0
    local curHP = math.max(unit_boss.iHP or 0,0)
    local curHpPercent = curHP / (unit_boss.iMAXHP or 1)
    self.objBoss_Info_Life.value = curHpPercent
    self.objBoss_Info_Lifeother:DOValue(curHpPercent, 0.2):OnComplete(function()
        if curHP == 0 then
            self.objBoss_Info:SetActive(false)
        end
    end)
    self.objBoss_Info_lifenum.text = curHP .. '/' .. (unit_boss.iMAXHP or 0)
end

-- 仅显示战斗场地(用于战斗中对话)
local vec3Away = DRCSRef.Vec3(1000,0,0)
function BattleUI:OnlyShowBattlefield(boolean_flag)
    local objbattlefile = LogicMain:GetInstance().battlefile
    local objBattleActorNode = LogicMain:GetInstance().objActorNode
    if IsValidObj(objbattlefile) then
        -- objbattlefile:SetActive(not boolean_flag)
        if not boolean_flag then
            objbattlefile.transform.localPosition = DRCSRef.Vec3Zero
        else
            objbattlefile.transform.localPosition = vec3Away
        end
    end

    self._gameObject:SetActive(not boolean_flag)
    local curOpt = LogicMain:GetInstance():GetCurOptUnit()
    if curOpt then
        if boolean_flag then
            curOpt:HideChooseEffect()
        else
            curOpt:ShowChooseEffect()
        end
    end
end

function BattleUI:BossComingEffect(name,icon)
    if not self.bossUI then
        self.bossUI = self:LoadPrefabAndInit("UI/UIPrefabs/Battle/bossComingUI",TIPS_Layer,true)
        self.bossUI_Icon2 = self.bossUI:FindChildComponent("cg1","Image")
        self.bossUI_Icon = self.bossUI:FindChildComponent("cg2","Image")
        self.bossUI_bossName = self.bossUI:FindChildComponent("name", "Text")
        local AnimationData = self.bossUI:FindAnimation('animation')
    end
    local bossName = self.bossUI_bossName
    local nameTitle = self.bossUI_nameTitle
    self.bossUI:SetActive(true)

    self.bossUI_Icon2.sprite = GetSprite(icon)
    self.bossUI_Icon.sprite = GetSprite(icon)

    self.bossUI_Icon2.color = DRCSRef.Color(1,1,1,1)
    self.bossUI_Icon.color = DRCSRef.Color(1,1,1,0.5)


    bossName.transform.localPosition = DRCSRef.Vec3(-500,bossName.transform.localPosition.y,bossName.transform.localPosition.z)

    nameTitle.transform.localPosition = DRCSRef.Vec3(-800,nameTitle.transform.localPosition.y,nameTitle.transform.localPosition.z)

    bossName:DR_DOFade(0,0)
    bossName.text = name
    bossName:DR_DOFade(0.9,0.8)
    self.bossUI:SetActive(false)
end

function BattleUI:CheckSkill(iIndex)
    local iSkillIndex = iIndex == -1 and iIndex or (self.iCurPage - 1) * PAGE_SKILL_COUNT + iIndex
    local kMartialData = self.akMartialData[iSkillIndex]
    local curUnit = LogicMain:GetInstance():GetCurOptUnit()
    if not kMartialData or not curUnit then
        return false
    end
    if kMartialData:isInColdTime() then
        return false
    end
    if kMartialData:isDizzy() then
        return false
    end
    if kMartialData:isFengYin() then
        return false
    end
    if (kMartialData.iCostMP or 0) > (curUnit.iMP or 0) then
        return false
    end

    return true
end

function BattleUI:GetValidIndex(dir)
    if LogicMain:GetInstance():IsReplaying() then return nil,true end
    local l_curPageSkillCount = PAGE_SKILL_COUNT
    if self.iCurPage == self.iMaxPage then
        if self.iMartialCount then
             l_curPageSkillCount = (self.iMartialCount-1) % PAGE_SKILL_COUNT + 1
        end
    end

    --检查是否所有技能不可用
    local l_AllSkillCantUse = true
    for i = 1,l_curPageSkillCount do
        if self:CheckSkill(i) == true then
            l_AllSkillCantUse = false
        end
    end

    if dir == 1 then    
        -- 当前下标为最大下标时,特殊处理
        if self.iCurChooseSkillIndex % PAGE_SKILL_COUNT == 0 then 
            return PAGE_SKILL_COUNT,l_AllSkillCantUse
        end
        local l_startIndex = self.iCurChooseSkillIndex % PAGE_SKILL_COUNT + 1
        for i = l_startIndex,l_curPageSkillCount do
            if self:CheckSkill(i) == true then
                return i,l_AllSkillCantUse
            end
        end
    elseif dir==-1 then
        if self.iCurChooseSkillIndex % PAGE_SKILL_COUNT == 1 then 
            return 1,l_AllSkillCantUse
        end
        for i = (self.iCurChooseSkillIndex-1) % PAGE_SKILL_COUNT,1,-1 do 
            if self:CheckSkill(i) == true then
                return i,l_AllSkillCantUse
            end
        end
    end

    return self.iCurChooseSkillIndex,l_AllSkillCantUse
end

function BattleUI:ChooseNextSkill()
    local nextSkillIndex,allSkillCantUse = self:GetValidIndex(1)
    if allSkillCantUse then
        return
    end
    self:OnClick_Skill(nextSkillIndex)
    if LogicMain:GetInstance() ~= nil then
        LogicMain:GetInstance():IsChangingSkill()
    end
end

function BattleUI:ChoosePreSkill()
    local preSkillIndex,allSkillCantUse = self:GetValidIndex(-1)
    if allSkillCantUse then
        return
    end
    self:OnClick_Skill(preSkillIndex)
    if LogicMain:GetInstance() ~= nil then
        LogicMain:GetInstance():IsChangingSkill()
    end
end

function BattleUI:AllSkillIsFengYin()
        SystemUICall:GetInstance():Toast("武学被封印")
end

return BattleUI
