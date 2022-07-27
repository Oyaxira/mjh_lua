ArenaUIHuaShanFinalJoinNames = class('ArenaUIHuaShanFinalJoinNames', BaseWindow);

REQUEST_WEIWANG_COUNT = 9;

local Type = {
    Pending = 1,
    Finally = 2,
}

local rankMemberCount = 32;

function ArenaUIHuaShanFinalJoinNames:ctor(info)
    self.type = Type.Pending;
    self.bindBtnTable = {};
end

function ArenaUIHuaShanFinalJoinNames:Create()
	local obj = LoadPrefabAndInit("ArenaUI/HuaShanFinalJoinNames",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ArenaUIHuaShanFinalJoinNames:Init()
    self.RankDataManager = RankDataManager:GetInstance();
    self.ArenaDataManager = ArenaDataManager:GetInstance();
    self.TableDataManager = TableDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();

    --
    self.objImageMask = self:FindChild(self._gameObject, 'Image_Mask');
    self.objPending = self:FindChild(self._gameObject, 'Pending_node');
    self.objFinally = self:FindChild(self._gameObject, 'Finally_node');
    self.objCloseBtn = self:FindChild(self._gameObject, 'PopUpWindow_3/Board/Button_close');
    
    self.objPendingSCNames = self:FindChild(self.objPending, 'SC_Names');
    self.objPendingSCNamesContent = self:FindChild(self.objPendingSCNames, 'Viewport/Content');
    
    self.objFinallySCNames = self:FindChild(self.objFinally, 'SC_Names');
    self.objFinallySCNamesContent = self:FindChild(self.objFinallySCNames, 'Viewport/Content');
    
    self.objContentRuwei = self:FindChild(self.objPendingSCNamesContent, 'Content_ruwei');
    self.objContentHoubu = self:FindChild(self.objPendingSCNamesContent, 'Content_houbu');
    
    --
    table.insert(self.bindBtnTable, self.objImageMask);
    table.insert(self.bindBtnTable, self.objCloseBtn);

    self:BindBtnCB();

end

function ArenaUIHuaShanFinalJoinNames:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIHuaShanFinalJoinNames:OnclickBtn(obj, boolHide)
    if obj == self.objImageMask or obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);
    end
end

function ArenaUIHuaShanFinalJoinNames:OnClickCloseBtn(obj)
    RemoveWindowImmediately("ArenaUIHuaShanFinalJoinNames")
end

function ArenaUIHuaShanFinalJoinNames:OnRefPending(info)
    
    local tempTable = {};
    local tbMatchData = self.ArenaDataManager:GetTBMatchData() or {};
    for k, v in pairs(tbMatchData) do
        if v.ClanRankID > 0 then
            table.insert(tempTable, v);
        end
    end
    
    table.sort(tempTable, function(a, b)
        return a.BaseID < b.BaseID;
    end)
    
    local matchTable = {}
    for i = 1, #(info) do
        -- 没有指定门派的, 直接放在丐帮
        if (not info[i].dwMatchType) or (info[i].dwMatchType == 0) then
            info[i].dwMatchType = 4001
        end
        if not matchTable[info[i].dwMatchType] then
            matchTable[info[i].dwMatchType] = {};
        end
        table.insert(matchTable[info[i].dwMatchType], info[i]);
    end
    
    self:RemoveAllChildToPool(self.objContentRuwei.transform);
    for i = 1, #(tempTable) do
        if matchTable[tempTable[i].BaseID] then
            local objItem = self:LoadPrefabFromPool('ArenaUI/Item_ClanList_final', self.objContentRuwei.transform, true);
            if objItem then
                local tbClanData = self.TableDataManager:GetTableData('Clan', tempTable[i].clan);
                local comText = self:FindChildComponent(objItem, 'Text', 'Text');
                comText.text = string.format('%s入围：', tbClanData.ClanAbbreviation);
    
                local objNameList = self:FindChild(objItem, 'name_list');
                self:RemoveAllChildToPool(objNameList.transform);
                for j = 1, #(matchTable[tempTable[i].BaseID]) do
                    local objItem = self:LoadPrefabFromPool('ArenaUI/Item_Name', objNameList.transform, true);
                    local comText = objItem:GetComponent('Text');
                    comText.text = matchTable[tempTable[i].BaseID][j].acPlayerName;
                end
            end
        end
    end

    ReBuildRect(self.objContentRuwei);
end

function ArenaUIHuaShanFinalJoinNames:OnRefPendingHouBu(info)
    
    local _getMatchData = function(clanRankID)
        local tbMatchData = self.ArenaDataManager:GetTBMatchData();
        for k, v in pairs(tbMatchData) do
            if v.ClanRankID == tonumber(clanRankID) then
                return v;
            end
        end
        return nil;
    end

    local dataTable = {};
    local rankData = self.RankDataManager:GetRankData();
    for k, v in pairs(rankData) do
        for kk, vv in pairs(v.members) do
            local matchData = _getMatchData(k);
            if matchData then
                local tbClanData = self.TableDataManager:GetTableData('Clan', matchData.clan);
                if tbClanData then
                    vv.clanName = tbClanData.ClanAbbreviation;
                    table.insert(dataTable, vv);
                end
            end
        end
    end

    local tempTable = {}
    for i = 1, #(dataTable) do
        if not tempTable[dataTable[i].name] then
            tempTable[dataTable[i].name] = dataTable[i];
        else
            if dataTable[i].score[1] > tempTable[dataTable[i].name].score[1] then
                tempTable[dataTable[i].name] = dataTable[i];
            end
        end
    end

    local sortTable = {};
    for k, v in pairs(tempTable) do
        table.insert(sortTable, v);
    end

    table.sort(sortTable, function(a, b)
        return a.score[1] > b.score[1];
    end);

    self:RemoveAllChildToPool(self.objContentHoubu.transform);
    for i = 1, 15 do
        if sortTable[i] then
            local objItem = self:LoadPrefabFromPool('ArenaUI/Item_Name', self.objContentHoubu.transform, true);
            if objItem then
                local comText = objItem:GetComponent('Text');
                comText.text = string.format('%s(%s%d)', sortTable[i].metadata, sortTable[i].clanName, sortTable[i].score[1]);
            end
        end
    end

    ReBuildRect(self.objContentHoubu);
end

function ArenaUIHuaShanFinalJoinNames:OnRefFinally(info)

    local tempTable = {};
    local tbMatchData = self.ArenaDataManager:GetTBMatchData() or {};
    for k, v in pairs(tbMatchData) do
        if v.ClanRankID > 0 then
            table.insert(tempTable, v);
        end
    end
    
    table.sort(tempTable, function(a, b)
        return a.BaseID < b.BaseID;
    end)
    
    local matchTable = {}
    for i = 1, #(info) do
        -- 没有指定门派的, 直接放在丐帮
        if (not info[i].dwMatchType) or (info[i].dwMatchType == 0) then
            info[i].dwMatchType = 4001
        end
        if not matchTable[info[i].dwMatchType] then
            matchTable[info[i].dwMatchType] = {};
        end
        table.insert(matchTable[info[i].dwMatchType], info[i]);
    end

    self:RemoveAllChildToPool(self.objFinallySCNamesContent.transform);
    for i = 1, #(tempTable) do
        if matchTable[tempTable[i].BaseID] then
            local objItem = self:LoadPrefabFromPool('ArenaUI/Item_ClanList_final', self.objFinallySCNamesContent.transform, true);
            if objItem then
                local tbClanData = self.TableDataManager:GetTableData('Clan', tempTable[i].clan);
                local comText = self:FindChildComponent(objItem, 'Text', 'Text');
                comText.text = string.format('%s入围：', tbClanData.ClanAbbreviation);
                
                local objNameList = self:FindChild(objItem, 'name_list');
                self:RemoveAllChildToPool(objNameList.transform);
                for j = 1, #(matchTable[tempTable[i].BaseID]) do
                    local objItem = self:LoadPrefabFromPool('ArenaUI/Item_Name', objNameList.transform, true);
                    local comText = objItem:GetComponent('Text');
                    comText.text = matchTable[tempTable[i].BaseID][j].acPlayerName;
                end
            end
        end
    end
end

function ArenaUIHuaShanFinalJoinNames:RefreshUI()

    self.huaShanMatchData = self.ArenaDataManager:GetCurMatchData(ARENA_TYPE.HUA_SHAN);
    if self.huaShanMatchData then
        local bNone = self.huaShanMatchData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_NONE
        self.type = bNone == true and Type.Pending or Type.Finally;
    end

    if self.type == Type.Pending then
        self.objPending:SetActive(true);
        self.objFinally:SetActive(false);
    elseif self.type == Type.Finally then
        self.objPending:SetActive(false);
        self.objFinally:SetActive(true);
    end

    SendRequestArenaMatchOperate(ARENA_REQUEST_HUASHANTOPMEMBER);
end

function ArenaUIHuaShanFinalJoinNames:RequstWeiWang()
    local tbRankData = self.RankDataManager:GetTBRankData() or {};
    local rankTypeTable = {};
    for k, v in pairs(tbRankData) do
        if tbRankData[k] and tbRankData[k].Show == TBoolean.BOOL_YES and tbRankData[k].BaseID > 100 then
            table.insert(rankTypeTable, tbRankData[k])
        end
    end

    -- 奇怪的逻辑开始了
    REQUEST_WEIWANG_COUNT = #(rankTypeTable);
    for i = 1, #(rankTypeTable) do
        NetCommonRank:QueryRank(tostring(rankTypeTable[i].BaseID), 1, rankMemberCount);
    end
end

function ArenaUIHuaShanFinalJoinNames:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_WEIWANG');
    self:RemoveEventListener('ONEVENT_REF_HUASHAN_NAME');
end

function ArenaUIHuaShanFinalJoinNames:OnEnable()
    self:AddEventListener('ONEVENT_REF_WEIWANG', function(info)
        self:OnRefPendingHouBu();
    end);
    self:AddEventListener('ONEVENT_REF_HUASHAN_NAME', function(info)
        self:OnRefNames(info);
        self:RequstWeiWang();
    end);
end

function ArenaUIHuaShanFinalJoinNames:OnRefNames(info)
    if self.type == Type.Pending then
        self:OnRefPending(info);
    elseif self.type == Type.Finally then
        self:OnRefFinally(info);
    end
end

function ArenaUIHuaShanFinalJoinNames:OnDestroy()

end

return ArenaUIHuaShanFinalJoinNames;