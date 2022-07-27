RoleTeamOutUI = class('RoleTeamOutUI', BaseWindow);

local whiteColor = DRCSRef.Color(1, 1, 1, 1);
local blackColor = DRCSRef.Color(0, 0, 0, 1);
local maxNum = 20;

function RoleTeamOutUI:ctor()
    self.bindBtnTable = {};
    self.btnTable = {};
    self.bIsClickCopyTeamBtn = false;
    self.scriptID = OUT_SCRIPT_ID[2];
    self.bCanCopyTeam = true;
end

function RoleTeamOutUI:Create()
	local obj = LoadPrefabAndInit('Role/RoleTeamOutUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function RoleTeamOutUI:Init()

    self.RoleDataManager = RoleDataManager:GetInstance();

    self.objNetMask = self:FindChild(self._gameObject, 'Image_NetMask');
    self.objLeft = self:FindChild(self._gameObject, 'Left');
    self.objRight = self:FindChild(self._gameObject, 'Right');
    self.objTips = self:FindChild(self._gameObject, 'Tips');
    self.objNetMask:SetActive(false);
    
    --
    self.objUpdateTimeLeft = self:FindChild(self.objLeft, 'Text_UpdateTime');
    self.objTextTips = self:FindChild(self.objLeft, 'Text_Tips');
    self.objSCLeft = self:FindChild(self.objLeft, 'SC_Left');
    self.objSCLeftContent = self:FindChild(self.objSCLeft, 'Viewport/Content');
    self.objTextTips:SetActive(false);
    
    self.objUpdateTimeRight = self:FindChild(self.objRight, 'Text_UpdateTime');
    self.objSCRight = self:FindChild(self.objRight, 'SC_Right');
    self.objSCRightContent = self:FindChild(self.objSCRight, 'Viewport/Content');

    --
    self.objOverTeamBtn = self:FindChild(self._gameObject, 'Button_OverTeam');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objButton1 = self:FindChild(self.objLeft, 'Image_ToggleGroup/Button1');
    self.objButton2 = self:FindChild(self.objLeft, 'Image_ToggleGroup/Button2');
    self.objButton3 = self:FindChild(self.objLeft, 'Image_ToggleGroup/Button3');
    

    --
    table.insert(self.bindBtnTable, self.objOverTeamBtn);
    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objButton1);
    table.insert(self.bindBtnTable, self.objButton2);
    table.insert(self.bindBtnTable, self.objButton3);
    table.insert(self.bindBtnTable, self.objNetMask);
    
    --
    table.insert(self.btnTable, self.objButton1);
    table.insert(self.btnTable, self.objButton2);
    table.insert(self.btnTable, self.objButton3);

    self:BindBtnCB();

end

function RoleTeamOutUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function RoleTeamOutUI:OnclickBtn(obj, boolHide)

    local _func = function(str)
        self.bClickBtn1 = str == 'btn1';
        self.bClickBtn2 = str == 'btn2';
        self.bClickBtn3 = str == 'btn3';
    end 

    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);
    
    elseif obj == self.objOverTeamBtn then
        self:OnClickOverTeamBtn(obj);
        
    elseif obj == self.objButton1 then
        if not self.bClickBtn1 then
            _func('btn1');
            self:OnClickBtn1(obj);
        end

    elseif obj == self.objButton2 then
        if not self.bClickBtn2 then
            _func('btn2');
            self:OnClickBtn2(obj);
        end

    elseif obj == self.objButton3 then
        if not self.bClickBtn3 then
            _func('btn3');
            self:OnClickBtn3(obj);
        end

    elseif obj == self.objNetMask then
        self.objNetMask:SetActive(false);

    end
end

function RoleTeamOutUI:OnClickCloseBtn(obj)
    if self.bIsClickCopyTeamBtn then
        self.bIsClickCopyTeamBtn = false;

        self.scriptID = OUT_SCRIPT_ID[1];
        SendQueryPlatTeamInfo(SPTQT_PLAT, self.scriptID);
    end

    if self.callback then
        self.callback();
        self.callback = nil;
    end

    RemoveWindowImmediately('RoleTeamOutUI', true);
end

function RoleTeamOutUI:OnClickOverTeamBtn(obj)

    if not self.bCanCopyTeam then
        SystemUICall:GetInstance():Toast('剧本无数据，无法复制阵容！')
        return;
    end

    local dataType = 'ScriptTeamInfo' .. self.scriptID;
    if not globalDataPool:getData(dataType) then
        SystemUICall:GetInstance():Toast('请先进入一次剧本，才可更新阵容！')
        return;
    end

    if not self.bClickkOverTeamBtn then
        self.bClickkOverTeamBtn = true;
    else
        SystemUICall:GetInstance():Toast('获取剧本阵容比较慢，请等待5秒再次尝试');
        return;
    end

    local wait = CS.UnityEngine.WaitForSeconds(5);
    CS_Coroutine.start(function()
        coroutine.yield(wait);
        self.bClickkOverTeamBtn = false;
    end)

    local showContent = {
        ['title'] = '提示',
        ['text'] = "将等级、品质最高的20个角色，从剧本阵容带到酒馆阵容。\n原有酒馆阵容将会消失，并完全被新阵容覆盖。建议在新阵容比较强时更新。",
        ['leftBtnText'] = '取消',
        ['rightBtnText'] = '确定',
    }
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, showContent, function()  
        CHANGE_TEAM_BATTLE = true;
        self.bIsClickCopyTeamBtn = true;
        SendCopyTeamInfo(self.scriptID);
    end})

end

function RoleTeamOutUI:RefGameTeam()
    
    local _func = function()
        if not PlayerSetDataManager:GetInstance():IsEmptyScript(self.scriptID) then
            SendQueryPlatTeamInfo(SPTQT_SCRIPT, self.scriptID);
        else
            self.bCanCopyTeam = false;
            if self.objTextTips then
                self.objTextTips:SetActive(true);
                self.objTextTips:GetComponent('Text').text = '剧本无数据！';
            end
        end
    end
    
    self.bCanCopyTeam = true;
    local dataType = 'ScriptTeamInfo' .. self.scriptID;
    local info = globalDataPool:getData(dataType);
    if (not info) then
        -- SendQueryPlatTeamInfo(SPTQT_SCRIPT, self.scriptID);
        _func();
    else
        self.bCanCopyTeam = false;
        if self.objTextTips then
            self.objTextTips:SetActive(true);
            self.objTextTips:GetComponent('Text').text = '剧本无数据！';
        end
	end
end

function RoleTeamOutUI:OnClickBtn1(obj)
    self:SetBtnState(obj);

    self.scriptID = OUT_SCRIPT_ID[2];
    self:OnRefListLeft(true);
    local dataType = 'ScriptTeamInfo' .. self.scriptID;
    local info = globalDataPool:getData(dataType);
    if not info then
        SendQueryPlatTeamInfo(SPTQT_SCRIPT, self.scriptID);
        -- self:RefGameTeam();
    else
        if self.objTextTips then
            self.objTextTips:SetActive(false);
        end
        self:OnRefListLeft();
    end
end

function RoleTeamOutUI:OnClickBtn2(obj)
    self:SetBtnState(obj);

    self.scriptID = OUT_SCRIPT_ID[3];
    self:OnRefListLeft(true);
    local dataType = 'ScriptTeamInfo' .. self.scriptID;
    local info = globalDataPool:getData(dataType);
    if not info then
        SendQueryPlatTeamInfo(SPTQT_SCRIPT, self.scriptID);
        -- self:RefGameTeam();
    else
        if self.objTextTips then
            self.objTextTips:SetActive(false);
        end
        self:OnRefListLeft();
    end
end

function RoleTeamOutUI:OnClickBtn3(obj)
    self:SetBtnState(obj);

    self.scriptID = OUT_SCRIPT_ID[4];
    self:OnRefListLeft(true);
    local dataType = 'ScriptTeamInfo' .. self.scriptID;
    local info = globalDataPool:getData(dataType);
    if not info then
        SendQueryPlatTeamInfo(SPTQT_SCRIPT, self.scriptID);
        -- self:RefGameTeam();
    else
        if self.objTextTips then
            self.objTextTips:SetActive(false);
        end
        self:OnRefListLeft();
    end
end

function RoleTeamOutUI:SetBtnState(obj)
    for i = 1, #(self.btnTable) do
        local objImage = self:FindChild(self.btnTable[i], 'Image');
        local comText = self:FindChildComponent(self.btnTable[i], 'Text', 'Text');

        if obj == self.btnTable[i] then
            objImage:SetActive(true);
            comText.color = whiteColor;
        else 
            objImage:SetActive(false);
            comText.color = blackColor;
        end 
    end
end

function RoleTeamOutUI:OnRefListLeft(bReset)

    local dataType = 'ScriptTeamInfo' .. self.scriptID;
    local scriptInfo = globalDataPool:getData(dataType);
    
    local teamData = {};
    if scriptInfo and next(scriptInfo) and (not bReset) then
        self.RoleDataManager:SetFullArenaData(false, self);

        -- teamData = table_c2lua(scriptInfo.auiTeammates);
        teamData = table_c2lua(self.RoleDataManager:GetRoleTeammates(false, true));

        local comText = self.objUpdateTimeLeft:GetComponent('Text');
        local time = os.date('%Y-%m-%d %H:%M:%S', os.time());
        comText.text = '最后游戏时间' .. time;
        self.objUpdateTimeLeft:SetActive(true);
        self.objSCLeftContent:SetActive(true);

        self.countLeft = math.ceil(#(teamData) / 2);
        self.modLeft = #(teamData) % 2;
        self.teamDataLeft = teamData;
        self.infoLeft = scriptInfo;
        self.bOverLeft = true;

        local lvSC = self.objSCLeft:GetComponent('LoopListView2');
        local scrollRect = self.objSCLeft:GetComponent('ScrollRect');
        if lvSC then

            local _func = function(item, index)
                local obj = item:NewListViewItem('Item_Left');
                self:OnLeftSCChanged(obj.gameObject, index, true);
                ReBuildRect(obj)
                return obj;
            end
            
            if not self.inited1 then
                self.inited1 = true;
                lvSC:InitListView(self.countLeft, _func);
            else
                lvSC:SetListItemCount(self.countLeft, false);
                lvSC:RefreshAllShownItem();
            end 

            self.lvSCLeft = lvSC;
        end
    else
        self.objUpdateTimeLeft:SetActive(false);
        self.objSCLeftContent:SetActive(false);
    end
end

function RoleTeamOutUI:OnLeftSCChanged(gameObject, index, bLeft)
    gameObject:SetActive(true);

    local count = bLeft == true and self.countLeft or self.countRight;
    local mod = bLeft == true and self.modLeft or self.modRight;
    local info = bLeft == true and self.infoLeft or self.infoRight;
    local teamData = bLeft == true and self.teamDataLeft or self.teamDataRight;
    local bOver = bLeft == true and self.bOverLeft or self.bOverRight;

    self.RoleDataManager:SetFullArenaData(not bOver, self);

    local _func = function(child, i)
        local dataIndex = (index * 2) + (i + 1);
        local roleid = teamData[dataIndex];
        local roleData = info.RoleInfos[roleid];
        if roleData then
            local comNameText = self:FindChildComponent(child.gameObject, 'Name_Text', 'Text');
            local strTitle = self.RoleDataManager:GetRoleTitleStr(roleid);
            local strName = ""
            if roleData.uiFragment == 1 then
                strName = self.RoleDataManager:GetMainRoleName();
            else
                strName = self.RoleDataManager:GetRoleName(roleid, true);
            end
            if strTitle then
                strName = strTitle .. '·' .. strName;
            end
            
            local rank = self.RoleDataManager:GetRoleRank(roleid);
            comNameText.text = getRankBasedText(rank, strName);
            
            local modelData = self.RoleDataManager:GetRoleArtDataByTypeID(roleData.uiTypeID);
            if modelData then
                local comHeadImage = self:FindChildComponent(child.gameObject, 'head', 'Image');
                comHeadImage.sprite = GetSprite(modelData.Head or '');
            end
    
            --
            local objText1 = self:FindChild(child.gameObject, 'State_Text1');
            local objText2 = self:FindChild(child.gameObject, 'State_Text2');
            objText1:SetActive(false);
            objText2:SetActive(false);
            
            --
            local objLevelText = self:FindChild(child.gameObject, 'Level_Text');
            objLevelText:GetComponent('Text').text = getRankBasedText(rank, roleData.uiLevel .. "级");
        end
    end

    if index == (count - 1) then
        for i = 0, 1 do
            local child = gameObject.transform:GetChild(i);
            if mod == 0 or i < mod then
                _func(child, i);
                child.gameObject:SetActive(true);
            else
                child.gameObject:SetActive(false);
            end
        end
    else
        for i = 0, 1 do
            local child = gameObject.transform:GetChild(i);
            _func(child, i);
            child.gameObject:SetActive(true);
        end
    end

end

function RoleTeamOutUI:OnRefListRight(data, bOver)

    local info = globalDataPool:getData('PlatTeamInfo');
    if bOver then
        local dataType = 'ScriptTeamInfo' .. self.scriptID;
        info = globalDataPool:getData(dataType);
    end

    local teamData = {};
    if info and next(info) then
        self.RoleDataManager:SetFullArenaData(not bOver, self);

        teamData = table_c2lua(self.RoleDataManager:GetRoleTeammates(false, true));
        local tempT = {};
        if #(teamData) > maxNum then
            table.move(teamData, 1, maxNum, #(tempT) + 1, tempT);
            teamData = tempT;
        end

        local time = os.date('%Y-%m-%d %H:%M:%S', data.uiTime);
        local TB_Story = TableDataManager:GetInstance():GetTable("Story") or {};
        local nameID = TB_Story[data.dwScriptID] and TB_Story[data.dwScriptID].NameID or 0;
        local comText = self.objUpdateTimeRight:GetComponent('Text');
        comText.text = '保存于' .. time .. '《' .. GetLanguageByID(nameID) .. '》';
        self.objUpdateTimeRight:SetActive(true);

        self.countRight = math.ceil(#(teamData) / 2);
        self.modRight = #(teamData) % 2;
        self.teamDataRight = teamData;
        self.infoRight = info;
        self.bOverRight = bOver;
        
        local lvSC = self.objSCRight:GetComponent('LoopListView2');
        local scrollRect = self.objSCRight:GetComponent('ScrollRect');
        if lvSC then

            local _func = function(item, index)
                local obj = item:NewListViewItem('Item_Right');
                self:OnLeftSCChanged(obj.gameObject, index, false);
                ReBuildRect(obj)
                return obj;
            end
            
            if not self.inited2 then
                self.inited2 = true;
                lvSC:InitListView(self.countRight, _func);
            else
                lvSC:SetListItemCount(self.countRight, false);
                lvSC:RefreshAllShownItem();
            end 

            self.lvSCRight = lvSC;
        end
    else
        self.objUpdateTimeRight:SetActive(false);
    end
end

function RoleTeamOutUI:RefreshUI()

    self.bCanCopyTeam = true;
    self.bClickBtn1 = false;
    self.bClickBtn2 = false;
    self.bClickBtn3 = false;
    -- if self.objTextTips then
    --     self.objTextTips:SetActive(true);
    -- end

    local info = globalDataPool:getData('PlatTeamInfo');
    if info then
        self:OnRefListRight(info, false);
    else
        self:OnRefListRight();
    end
    self:OnClickBtn1(self.objButton1);

    -- if (PlayerSetDataManager:GetInstance():IsEmptyScript(8)) then
    --     self.objButton3:SetActive(false)
    -- else
    --     self.objButton3:SetActive(true)
    -- end
    -- self.objButton3:SetActive(false)
end

function RoleTeamOutUI:OnDisable()
    self.RoleDataManager:SetFullArenaData(true, self);
    self:RemoveEventListener('ONEVENT_COPYTEAM');
    self:RemoveEventListener('ONEVENT_REF_TEAMOUTUI');
end

function RoleTeamOutUI:OnEnable()
    self.RoleDataManager:SetFullArenaData(false, self);
    self:AddEventListener('ONEVENT_COPYTEAM', function(info)
        if self.objTextTips then
            self.objTextTips:SetActive(false);
        end
        self:OnRefListRight(info, true);
    end);
    self:AddEventListener('ONEVENT_REF_TEAMOUTUI', function(info)
        if self.objTextTips then
            self.objTextTips:SetActive(false);
        end
        self:OnRefListLeft(false);
    end);
end

function RoleTeamOutUI:OnDestroy()
    local scTable = {};
    table.insert(scTable, self.lvSCLeft);
    table.insert(scTable, self.lvSCRight);
    self:RemoveSuperSC2Listener(scTable);
end

function RoleTeamOutUI:SetCallBack(callback)
    self.callback = callback;
end

return RoleTeamOutUI;