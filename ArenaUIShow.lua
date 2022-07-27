ArenaUIShow = class('ArenaUIShow', BaseWindow);

local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

local singleBaseID = 5;
local teamBaseID = 6;
local historyTitleDec = {'本届', '往届1', '往届2', '往届3', '往届4'};
local TYPE = {
    SINGLE = 1,
    TEAM = 2,
}
local MATCH_BASEID = {
	SINGLE = 5,
	TEAM = 6
}

function ArenaUIShow:ctor(info)
    self._script = info;
    self.bindBtnTable = {};
    self.showIndex = 1;
    self.showSingle = true;
    self.requestSingleHistoryMatchIDs = {};
    self.requestTeamHistoryMatchIDs = {};
    self.requestType = singleBaseID;

    self:SetGameObject(info.objShow);
    self:OnCreate(info.objShow);
end

function ArenaUIShow:Create()

end

function ArenaUIShow:Init()

    self.ArenaDataManager = ArenaDataManager:GetInstance();

	local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    if shareGroupUI then
        if not MSDKHelper:IsPlayerTestNet() then

            local _callback = function(bActive)
                local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
                if serverAndUIDUI and serverAndUIDUI._gameObject then
                    serverAndUIDUI._gameObject:SetActive(bActive);
                end
            end

            self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
            self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.LEITAI, _callback);

            local canvas = shareGroupUI:GetComponent('Canvas');
            if canvas then
                canvas.sortingOrder = 1121;
            end
        else
            shareGroupUI:SetActive(false);
        end
	end

    --
    self.objLeftBtn = self:FindChild(self._gameObject, 'Button_Left');
    self.objRightBtn = self:FindChild(self._gameObject, 'Button_Right');
    self.objChangeBtn = self:FindChild(self._gameObject, 'Button_Change');
    self.objImageMask = self:FindChild(self._gameObject, 'Image_Mask');

    --
    self.objShowModSingle = self:FindChild(self.objImageMask, 'Show_Mod_Single');
    self.objShowModTeam = self:FindChild(self.objImageMask, 'Show_Mod_Team');
 
    -- QC: 这里多个节点都是重复操作, 直接成一个初始化接口
    -- 目前看到有 single 和 team, 但是 team 没在用, 所以暂时先写single的
    self.kSpineNodeInfo = {}
    self.kSpineNodeInfo["Single"] = self:GenSpineNodeInfo(self.objShowModSingle, {"Left", "Mind", "Right"})
    --
    self.objModTopSingle = self:FindChild(self.objShowModSingle, 'Top')
    self.objTextTimeSingle = self:FindChild(self.objModTopSingle, 'Text_Time');
    self.objDropdownSingle = self:FindChild(self.objModTopSingle, 'Dropdown');

    self.objModBotSingle = self:FindChild(self.objShowModSingle, 'Bot')
    self.objTextRankSingle = self:FindChild(self.objModBotSingle, 'Text_Rank');
    self.objTextBetSingle = self:FindChild(self.objModBotSingle, 'Text_Bet');
    
    --
    self.objModLeftTeam = self:FindChild(self.objShowModTeam, 'Left');
    self.objModMindTeam = self:FindChild(self.objShowModTeam, 'Mind');
    self.objModRightTeam = self:FindChild(self.objShowModTeam, 'Right');
    self.objModTopTeam = self:FindChild(self.objShowModTeam, 'Top');
    self.objModBotTeam = self:FindChild(self.objShowModTeam, 'Bot');
    
    --
    self.objModSKLeftTeam = self:FindChild(self.objModLeftTeam, 'SkeletonGraphic_Mod');
    self.objModSKMindTeam = self:FindChild(self.objModMindTeam, 'SkeletonGraphic_Mod');
    self.objModSKRightTeam = self:FindChild(self.objModRightTeam, 'SkeletonGraphic_Mod');
    self.objModSKLeftTeam:SetActive(false);
    self.objModSKMindTeam:SetActive(false);
    self.objModSKRightTeam:SetActive(false);
    
    --
    self.objTextTimeTeam = self:FindChild(self.objModTopTeam, 'Text_Time');
    self.objDropdownTeam = self:FindChild(self.objModTopTeam, 'Dropdown');
    self.objTextRankTeam = self:FindChild(self.objModBotTeam, 'Text_Rank');
    self.objTextBetTeam = self:FindChild(self.objModBotTeam, 'Text_Bet');

    --
    table.insert(self.bindBtnTable, self.objLeftBtn);
    table.insert(self.bindBtnTable, self.objRightBtn);
    table.insert(self.bindBtnTable, self.objChangeBtn);

    self:BindBtnCB();

    self:AddEventListener('UI_OPEN', function(strName)
        if strName ~= "PlayerSetUI" then
            return
        end
        local bImageMaskOn = self.objImageMask.activeSelf
        if bImageMaskOn ~= true then
            return
        end
        self.bObjImageMaskStateCache = bImageMaskOn
        self.objImageMask:SetActive(false)
    end)
    self:AddEventListener('UI_CLOSE', function(strName)
        if strName ~= "PlayerSetUI" then
            return
        end
        if self.bObjImageMaskStateCache == true then
            self.bObjImageMaskStateCache = nil
            self.objImageMask:SetActive(true)
        end
    end)
end

-- QC: 初始化华山论剑玩家模型节点
function ArenaUIShow:GenSpineNodeInfo(objNodeRoot, asKeys)
    if (not objNodeRoot) or (not asKeys) then
        return
    end

    local kGenInfo = {}

    for _, strKry in ipairs(asKeys) do
        local objModelRoot = self:FindChild(objNodeRoot, strKry)
        local objSpineRoot = nil
        local objSpine = nil
        local textName = nil
        local btnSpine = nil
        if objModelRoot then
            objSpineRoot = self:FindChild(objModelRoot, "SkeletonGraphic_Mod")
            textName = self:FindChildComponent(objModelRoot, "Text_Name", "Text")
            btnSpine = self:FindChildComponent(objModelRoot, "Btn", "Button")
        end
        if objSpineRoot then
            objSpine = self:FindChild(objSpineRoot, "Spine")
            objSpineRoot:SetActive(false)
        end
        if btnSpine then
            self:RemoveButtonClickListener(btnSpine)
            self:AddButtonClickListener(btnSpine, function()
                self:OnClickSpine(objSpine)
            end)
        end
        kGenInfo[strKry] = {
            ["objModelRoot"] = objModelRoot,
            ["objSpineRoot"] = objSpineRoot,
            ["objSpine"] = objSpine,
            ["textName"] = textName,
            ["btnSpine"] = btnSpine,
        }
    end

    return kGenInfo
end

function ArenaUIShow:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIShow:OnclickBtn(obj, boolHide)
    if obj == self.objLeftBtn then
        self:OnClickLeftBtn(obj);
    
    elseif obj == self.objRightBtn then
        self:OnClickRightBtn(obj);
    
    elseif obj == self.objChangeBtn then
        self:OnClickChangeBtn(obj);

    end

end

function ArenaUIShow:OnClickLeftBtn(obj)
    
    if self.showIndex > 1 then
        self.showIndex = self.showIndex - 1;
        self.objShowModSingle.transform:DR_DOLocalMoveX(0, 1);
        self.objShowModTeam.transform:DR_DOLocalMoveX(1030, 1);
    end

end

function ArenaUIShow:OnClickRightBtn(obj)

    if self.showIndex < 2 then
        self.showIndex = self.showIndex + 1;
        self.objShowModSingle.transform:DR_DOLocalMoveX(-1030, 1);
        self.objShowModTeam.transform:DR_DOLocalMoveX(0, 1);
    end

end

function ArenaUIShow:OnClickChangeBtn(obj)

    local durTime = 0.5;

    if self.showSingle then
        self.showSingle = false;
        if self.showIndex < 2 then
            self.showIndex = self.showIndex + 1;
            self.objShowModSingle.transform:DR_DOLocalMoveX(-1030, durTime);
            self.objShowModTeam.transform:DR_DOLocalMoveX(0, durTime);
        end
    else
        self.showSingle = true;
        if self.showIndex > 1 then
            self.showIndex = self.showIndex - 1;
            self.objShowModSingle.transform:DR_DOLocalMoveX(0, durTime);
            self.objShowModTeam.transform:DR_DOLocalMoveX(1030, durTime);
        end
    end

end

function ArenaUIShow:RefreshUI()
    self:OnRefHistoryData();
    
end

function ArenaUIShow:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_HISTORYDATA');

end

function ArenaUIShow:OnEnable()
    self:AddEventListener('ONEVENT_REF_HISTORYDATA', function(info)
        self:OnRefHistoryData(info);
    end);

end

-- QC: 使用玩家信息初始化一个华山论剑玩家模型
function ArenaUIShow:SetHuaShanSpine(strMode, strKry, kPlayerInfo)
    if (not strMode) or (not strKry) or (not kPlayerInfo) then
        return
    end
    if (not self.kSpineNodeInfo) or (not self.kSpineNodeInfo[strMode]) then
        return
    end
    local kNodeInfo = self.kSpineNodeInfo[strMode]
    if not kNodeInfo[strKry] then
        return
    end
    local kModeNodeInfo = kNodeInfo[strKry]
    local objSpineRoot = kModeNodeInfo["objSpineRoot"]
    local objSpine = kModeNodeInfo["objSpine"]
    local textName = kModeNodeInfo["textName"]
    -- 设置模型
    local kModelBaseData = nil
    if kPlayerInfo.dwModelID then
        kModelBaseData = TableDataManager:GetInstance():GetTableData("RoleModel", kPlayerInfo.dwModelID)
    end
    local bInitSpineSuc = false
    if kModelBaseData and objSpine then
        DynamicChangeSpine(objSpine, kModelBaseData.Model or 0)
        ChnageSpineSkin(objSpine, kModelBaseData.Texture or "")
        bInitSpineSuc = true
    end
    objSpineRoot:SetActive(bInitSpineSuc)
    -- 设置点击行为
    if not self.kClickSpineMap then
        self.kClickSpineMap = {}
    end
    if kPlayerInfo.defPlayerID and (kPlayerInfo.defPlayerID > 0) then
        self.kClickSpineMap[objSpine] = kPlayerInfo.defPlayerID
    else
        self.kClickSpineMap[objSpine] = nil
    end
    -- 设置名字
    textName.text = kPlayerInfo.acPlayerName or ""
end

-- QC: 华山论剑玩家模型点击行为
function ArenaUIShow:OnClickSpine(objSpine)
    if (not objSpine) 
    or (not self.kClickSpineMap) 
    or (not self.kClickSpineMap[objSpine]) then
        SystemUICall:GetInstance():Toast("暂无信息")
        return
    end
    local uiPlayerID = self.kClickSpineMap[objSpine]
    if uiPlayerID == 0 then
        SystemUICall:GetInstance():Toast("暂无信息")
        return
    end
    SendGetPlatPlayerDetailInfo(uiPlayerID, RLAYER_REPORTON_SCENE.UserBoard)	
end

function ArenaUIShow:OnRefHistoryData()

    local _func = function(data)

        local objDropdown = self.objDropdownSingle;
        local comDropdown = objDropdown:GetComponent('Dropdown');
        comDropdown.options:Clear();
        
        for i = 1, #(data) do
            local time = os.date('%m月%d日', data[i].dwMatchTime);
            comDropdown.options:Add(CS.UnityEngine.UI.Dropdown.OptionData(time));
        end
        comDropdown.value = 0;
    
        local _callback = function(index)
            local historyData = data[index + 1];
            if historyData then
                --
                local time = os.date('%m月%d日', historyData.dwMatchTime);
                local objRank = self.objTextRankSingle;
                local objBet = self.objTextBetSingle;
                local objTime = self.objTextTimeSingle;
                local strText = '华山论剑(' .. time .. ')';

                objTime:GetComponent('Text').text = strText;
                local dwPlace = historyData.dwPlace == 0 and '暂无' or historyData.dwPlace;
                objRank:GetComponent('Text').text = '我的排名：' .. dwPlace;
                objBet:GetComponent('Text').text = string.format('我的助威：%d胜 +%d擂台币', historyData.dwBetWinTimes, historyData.dwBetWinMoney);
        
                --
                for i = 1, #(historyData.akMemberHistoryData) do
                    local kMemData = historyData.akMemberHistoryData[i]
                    local uiPlace = kMemData.dwPlace or 0
                    -- QC: 修改这块代码之前就叫mind而不是middle, 估计是写错了, 保险起见不改命名
                    local strKry = (uiPlace == 1) and "Mind" or ((uiPlace == 2) and "Left" or "Right")
                    self:SetHuaShanSpine("Single", strKry, kMemData)
                end
            end
        end

        comDropdown.onValueChanged:RemoveAllListeners();
        comDropdown.onValueChanged:AddListener(_callback);
    end

    local huaShanData = self.ArenaDataManager:GetHistoryData(ARENA_TYPE.HUA_SHAN);
    if huaShanData then
		_func(huaShanData);
        local comDropdown = self.objDropdownSingle:GetComponent('Dropdown');
        comDropdown.onValueChanged:Invoke();
    else
        -- 默认展示数据
        self:SetHuaShanSpine("Single", "Left", {dwModelID = 983, acPlayerName = "霸道盟主"})
        self:SetHuaShanSpine("Single", "Mind", {dwModelID = 993, acPlayerName = "武林盟主"})
        self:SetHuaShanSpine("Single", "Right", {dwModelID = 579, acPlayerName = "张三丰"})
    end
end

function ArenaUIShow:OnDestroy()
    local comDropdown = self.objDropdownSingle:GetComponent('Dropdown');
    comDropdown.onValueChanged:RemoveAllListeners();
    comDropdown.onValueChanged:Invoke();

    local comDropdown1 = self.objDropdownTeam:GetComponent('Dropdown');
    comDropdown1.onValueChanged:RemoveAllListeners();
    comDropdown1.onValueChanged:Invoke();

    if self.TencentShareButtonGroupUI then
        self.TencentShareButtonGroupUI:Close();
    end
end

return ArenaUIShow;