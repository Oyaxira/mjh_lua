ArenaBattleEndUI = class("ArenaBattleEndUI",BaseWindow)

local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

local scroeTxtBase = 270001 
--这个UI 不要做缓存操作
function ArenaBattleEndUI:ctor(info)
    self.info = info;
end

function ArenaBattleEndUI:Create()
	local obj = LoadPrefabAndInit("Battle/ArenaBattleEndUI",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ArenaBattleEndUI:Init()

    local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    if shareGroupUI then
        if not MSDKHelper:IsPlayerTestNet() then

            local _callback = function(bActive)
                local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
                if serverAndUIDUI and serverAndUIDUI._gameObject then
                    serverAndUIDUI._gameObject:SetActive(bActive);
                end

                local objNode = self:FindChild(self._gameObject, 'TransformAdapt_node_left');
                if objNode then
                    objNode:SetActive(bActive);
                end
            end

            self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
            self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.QIECUO, _callback);

            local canvas = shareGroupUI:GetComponent('Canvas');
            if canvas then
                canvas.sortingOrder = 1272;
            end
        else
            shareGroupUI:SetActive(false);
        end
    end

    self.objVectorBG = self:FindChild(self._gameObject,"BG")
    self.objvcg = self:FindChildComponent(self._gameObject, 'vcg',"Image")
    self.objdcg = self:FindChildComponent(self._gameObject, 'dcg',"Image")
    self.objvname = self:FindChildComponent(self._gameObject, 'vname',"Text")
    self.objdname = self:FindChildComponent(self._gameObject, 'dname',"Text")
    self.objVic1 = self:FindChild(self._gameObject, 'Victory_1')
    self.objDef1 = self:FindChild(self._gameObject, 'Defeat_1')
    self.objVic2 = self:FindChild(self._gameObject, 'Victory_2')
    self.objDef2 = self:FindChild(self._gameObject, 'Defeat_2')
    self.objButton_replay = self:FindChild(self._gameObject, "TransformAdapt_node_left/Button_replay")
    self.comButton_replay = self.objButton_replay:GetComponent("DRButton")
    if self.comButton_replay then
        -- if LogicMain:GetInstance():GetBattleTypeID() == 0 then -- 玩家切磋
            self.objButton_replay:SetActive(true)
            self:AddButtonClickListener(
                self.comButton_replay,
                function()
                    if LogicMain:GetInstance()._Replaying ~= true then 
                        -- FIXME: 随便上行一个东西触发一下下行, 矫正 DisplayBegin DisplayEnd 时序
                        SendClearInteractInfoCMD()
                        RemoveWindowImmediately("ArenaBattleEndUI")
                        LogicMain:GetInstance():Clear()
                        LogicMain:GetInstance():Replay()
                    end
                end
            )
        -- end
    end

    self.btnBattleStatistical = self:FindChildComponent(self._gameObject,"TransformAdapt_node_left/Button_BattleData","Button")
    if (self.btnBattleStatistical) then
        self:RemoveButtonClickListener(self.btnBattleStatistical)
		self:AddButtonClickListener(self.btnBattleStatistical, function ()
            OpenWindowImmediately("BattleStatisticalDataUI")       
        end)
    end
    self.objBattleRecord = self:FindChild(self._gameObject,"TencentShareButtonGroupUI/TransformAdapt_node/BattleRecordButton")

    self.BtnBattleRecord = self:FindChildComponent(self._gameObject,"TencentShareButtonGroupUI/TransformAdapt_node/BattleRecordButton","Button")
    if self.BtnBattleRecord then 
        self.objBattleRecord:SetActive(true)
        self:AddButtonClickListener(self.BtnBattleRecord, function ()
            OpenWindowImmediately("BattleReportUI")       
        end)
    end
    self.vcgSprite = self.objvcg.sprite
    self.dcgSprite = self.objdcg.sprite
    AddEventTrigger(self.objVectorBG,function() self:OnClick_Over() end)

    self.mColorV = self.objvname.color
    self.mColorD = self.objdname.color
end

function ArenaBattleEndUI:OnClick_Over()
    ARENA_PLAYBACK_DATA = nil;
    self:BackToTownScene()
end

function ArenaBattleEndUI:OnDestroy()
    if self.scrollRectVictory_Score then
        self.scrollRectVictory_Score:RemoveListener()
    end
    if self.scrollRectVictory_Award then
        self.scrollRectVictory_Award:RemoveListener()
    end
    if self.objVectorBG then
        RemoveEventTrigger(self.objVectorBG)
    end
    self:BackToTownScene()
end

function ArenaBattleEndUI:RefreshUI()
    if self.info and self.info.akEndData then
    
        local arenaScriptDataManager = ArenaScriptDataManager:GetInstance();
        local tempTBData = arenaScriptDataManager:GetTempTBData();
        local dwCurStageID = arenaScriptDataManager:GetCurCacheStageID()
        local tempMatchData = arenaScriptDataManager:GetTempMatchData();
        if dwCurStageID then
            if tempMatchData[dwCurStageID] then
                ARENA_PLAYBACK_DATA = tempMatchData[dwCurStageID][1];
            else
                ARENA_PLAYBACK_DATA = tempMatchData[1] and tempMatchData[1][1];
            end
        end
    
        if not ARENA_PLAYBACK_DATA then
            return;
        end

        if not HasValue(self.info.akEndData.eFlag, SE_DEFEAT) then
            ARENA_PLAYBACK_DATA.defPlyWinner = ARENA_PLAYBACK_DATA.kPly1Data.defPlayerID;
        else
            ARENA_PLAYBACK_DATA.defPlyWinner = ARENA_PLAYBACK_DATA.kPly2Data.defPlayerID;
        end
    end

    if not ARENA_PLAYBACK_DATA then
        return;
    end

    self.objvname.text = ARENA_PLAYBACK_DATA.kPly1Data.acPlayerName;
    self.objdname.text = ARENA_PLAYBACK_DATA.kPly2Data.acPlayerName;

	local kModledata = TableDataManager:GetInstance():GetTableData("RoleModel", ARENA_PLAYBACK_DATA.kPly1Data.dwModelID)
    if kModledata then 
        self.objvcg.sprite = GetSprite(kModledata.Drawing)
    end

    kModledata = TableDataManager:GetInstance():GetTableData("RoleModel", ARENA_PLAYBACK_DATA.kPly2Data.dwModelID)
    if kModledata then 
        self.objdcg.sprite = GetSprite(kModledata.Drawing)
    end

    if ARENA_PLAYBACK_DATA.defPlyWinner == ARENA_PLAYBACK_DATA.kPly1Data.defPlayerID then
        self.objVic1:SetActive(true);
        self.objDef1:SetActive(false);
        self.objVic2:SetActive(false);
        self.objDef2:SetActive(true);
    else
        self.objVic1:SetActive(false);
        self.objDef1:SetActive(true);
        self.objVic2:SetActive(true);
        self.objDef2:SetActive(false);
    end

    local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
    if ARENA_PLAYBACK_DATA.kPly2Data.defPlayerID == ownerID then
        self.objvname.color = self.mColorD 
        self.objdname.color = self.mColorV 
    else
        self.objvname.color = self.mColorV 
        self.objdname.color = self.mColorD 
    end
    
    LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.PreSelect, false)
end

-- 回到town scene
function ArenaBattleEndUI:BackToTownScene()
    ArenaDataManager:GetInstance():ReplayerOver()

    -- 如果是切磋, 播放Roll奖
    if LogicMain:GetInstance():GetBattleTypeID() == 0 then -- 玩家切磋
        local kPlayerCompareRes = PlayerSetDataManager:GetInstance():GetPlayerCompareResInfo()
        if kPlayerCompareRes then
            if kPlayerCompareRes.bGotLimit == true then
                SystemUICall:GetInstance():Toast("切磋获胜, 获奖次数已达本日上限")
            elseif kPlayerCompareRes.bIsPlayerFight == true then
                OpenWindowImmediately("RandomRollUI", kPlayerCompareRes)
                local winBlur = GetUIWindow("BlurBGUI")
                if winBlur then
                    winBlur:SetBlurBGImg(GetSprite(HOUSE_FIGHT_ROLL_REWARD_BAC))
                end
            end
        end 
    end

    LogicMain:GetInstance():ReturnToTown(true)
    RemoveWindowImmediately("ArenaBattleEndUI")
    local arenaUI= GetUIWindow('ArenaUI')
    if arenaUI then
        arenaUI.DontDestroy = false
        arenaUI:SetAlpha(1)
    end
end

function ArenaBattleEndUI:OnDestroy()
    if self.TencentShareButtonGroupUI then
        self.TencentShareButtonGroupUI:Close();
    end
end

return ArenaBattleEndUI