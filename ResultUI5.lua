ResultUI5 = class('ResultUI5', BaseWindow)

local ResultUI6 = require 'UI/ResultUI/ResultUI6'
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function ResultUI5:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI5;
    self.ItemIconUI = ItemIconUI.new();

    self.bindBtnTable = {};
    self.outTable = {};
    self.recycleTable = {};
end

function ResultUI5:Init()
    self.ResultUI6 = ResultUI6.new(self._scriptUI);

    self.objTextScore = self:FindChild(self._gameObject, 'Text_Score');
    self.objOutAllBtn = self:FindChild(self._gameObject, 'Button_OutAll');
    self.objCovAllBtn = self:FindChild(self._gameObject, 'Button_CovAll');
    self.objGoToTapTapBtn = self:FindChild(self._gameObject, 'Button_GoToTapTap');
    self.objGoToTownBtn = self:FindChild(self._gameObject, 'Button_GoToTown');
    self.objLayoutScoreAward = self:FindChild(self._gameObject, 'Layout_ScoreAward');
    self.objLayoutScriptAward = self:FindChild(self._gameObject, 'Layout_ScriptAward');
    self.objLayoutScriptOut = self:FindChild(self._gameObject, 'Layout_ScriptOut');
    self.objLayoutScriptCov = self:FindChild(self._gameObject, 'Layout_ScriptCov');
    self.objItemIconUIRight = self:FindChild(self.objLayoutScriptCov, 'ItemIconUI_Right');
    self.objImageMeridians = self:FindChild(self._gameObject, 'Image_BG')
    self.objMaxScore = self:FindChild(self._gameObject, "Text_MaxScore")

    self.objImageEmpty1 = self:FindChild(self._gameObject, 'Image_Empty/Empty_1')
    self.objImageEmpty2 = self:FindChild(self._gameObject, 'Image_Empty/Empty_2')
    self.objImageEmpty3 = self:FindChild(self._gameObject, 'Image_Empty/Empty_3')
    self.objImageEmpty4 = self:FindChild(self._gameObject, 'Image_Empty/Empty_4')

    if self.objGoToTapTapBtn then
        self.objGoToTapTapBtn:SetActive(false)
    end

    table.insert(self.bindBtnTable, self.objOutAllBtn);
    table.insert(self.bindBtnTable, self.objCovAllBtn);
    -- table.insert(self.bindBtnTable, self.objGoToTapTapBtn);
    table.insert(self.bindBtnTable, self.objGoToTownBtn);

    self:BindBtnCB();

    self:InitShareUI()
    self.akItemUIClass = {}
end

function ResultUI5:ReturnAllIcons()
	if self.akItemUIClass and (#self.akItemUIClass > 0) then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
	end
end

function ResultUI5:CreateIcon(kInstItemData, kItemTypeData, iNum, kTransParent)
	if not kTransParent then
		return
	end
    local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent)
    if kInstItemData then
        kIconBindData:UpdateUIWithItemInstData(kInstItemData)
    elseif kItemTypeData then
        kIconBindData:UpdateUIWithItemTypeData(kItemTypeData)
    end
    if iNum then
        kIconBindData:SetItemNum(iNum, iNum == 1)
    end
	self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
	return kIconBindData
end

function ResultUI5:RefreshUI(info)
    self.info = info;
    local curScriptID = info.uiCurScriptID or 1;
    local awardItem = info.kAwardItem or {};
    local ended = info.uiEndType or 1;
    local tempItemPool = globalDataPool:getData("TempItemPool") or {}
    self.endShowType = info.uiEndShowType or 0;
    self.dontTakeOut = (info.uiDontTakeOut == 0)

    local comText = self.objTextScore:GetComponent('Text');
    comText.text = info.uiTotalScore or 0
    --self._scriptUI.sumScore;

    self:ReturnAllIcons()
    
    --
    local normalAward = {};
    local scriptAward = {};
    if awardItem then
        for k, v in pairs(awardItem) do
            if v.uiRewardType == WeekEndDataEnum.WE_NormalReward then
                table.insert(normalAward, v);
            elseif v.uiRewardType == WeekEndDataEnum.WE_ScriptReward then
                table.insert(scriptAward, v);
            end
        end
    end

    local kTransLayoutScoreAward = self.objLayoutScoreAward.transform
    for i = 1, #(normalAward) do
        local tempData = normalAward[i]
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",tempData.uiBaseID)
        self:CreateIcon(nil, itemTypeData, tempData.uiNum, kTransLayoutScoreAward)
    end
    self.objImageEmpty1:SetActive(#normalAward == 0)

    local kTransLayoutScriptAward = self.objLayoutScriptAward.transform
    for i = 1, #(scriptAward) do
        local tempData = scriptAward[i];
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",tempData.uiBaseID)
        self:CreateIcon(nil, itemTypeData, tempData.uiNum, kTransLayoutScriptAward)
    end
    self.objImageEmpty2:SetActive(#scriptAward == 0)

    --
    self.outTable = {};
    self.recycleTable = {};
    local itemMgr = ItemDataManager:GetInstance();
    local roleDataManager = RoleDataManager:GetInstance()

    local kTransLayoutScriptOut = self.objLayoutScriptOut.transform;
    if curScriptID ~= 1 and not self.dontTakeOut then
        local mainRoleData = roleDataManager:GetMainRoleData();
        local mainRoleInfo = globalDataPool:getData("MainRoleInfo") or {}
        local uiMainRoleID = mainRoleInfo.iMainRoleID or 0
        local teammates = globalDataPool:getData("GameData") or {}
        teammates = teammates['RoleInfos'] or {}
        if mainRoleData then
            local luaTable = {}
            local kItemMgr = ItemDataManager:GetInstance()
            local kTableMgr = TableDataManager:GetInstance()
            -- 道具带出规则:
            -- 1. 归属于主角的装备
            -- 2. 不归属于主角, 但是强化+5及以上
            -- 3. 不归属于主角, 但是拥有重铸记录(装备上记录有通灵玉, 完美粉与精铁)
            local itemPool = globalDataPool:getData("ItemPool") or {}
            for id,iteminfo in pairs(itemPool) do
                if iteminfo then 
                    if (iteminfo.bBelongToMainRole == 1)
                    or ((iteminfo.uiSpendTongLingYu or 0) > 0) 
                    or ((iteminfo.uiPerfectPower or 0) > 0) 
                    or ((iteminfo.uiSpendIron or 0) > 0) then
                        table.insert( luaTable, id )
                    end
                end
            end
            -- 主角身上所有非装备物品
            for index,id in pairs(mainRoleData.auiRoleItem) do
                local iteminfo = itemPool[id]
                if iteminfo and iteminfo.bBelongToMainRole ~= 1 then 
                    table.insert( luaTable, id )
                end
            end
            -- instrole身上的秘籍
            for roleID, roleData in pairs(teammates) do 
                if roleData.akEquipItem then 
                    for _, id in pairs(roleData.akEquipItem) do
                        local kInstItem = kItemMgr:GetItemDataInItemPool(id) or {}
                        if kInstItem and kInstItem.uiTypeID and (kInstItem.uiTypeID > 0) then
                            local kBaseItem = kTableMgr:GetTableData("Item", kInstItem.uiTypeID)
                            if kBaseItem and kBaseItem.ItemType == ItemTypeDetail.ItemType_SecretBook then
                                table.insert( luaTable, id )
                            end
                        end
                    end
                end
            end

            -- 临时背包物品处理
            -- tempItemPool里面只记录了临时背包物品的id, 实际物品的数据还是存在itempool里面的
            -- 所以, 在上面带出itempool中所有主角能带出的装备的过程中, 临时背包中的装备也检查到了
            -- 这里只需要将临时背包中的所有非装备物品加入到带出带出列表中即可
            local aiTempItemIds = tempItemPool.array or {}
            for index, id in ipairs(aiTempItemIds) do
                local kInstData = itemPool[id]
                if kInstData 
                and kInstData.uiTypeID 
                and (kItemMgr:IsEquip(kInstData.uiTypeID) ~= true) then
                    table.insert(luaTable, id)
                end
            end
            
            local uiMainRoleID = mainRoleInfo.iMainRoleID
            local kItemMgr = ItemDataManager:GetInstance()
            local kItemDBData = TableDataManager:GetInstance():GetTable("Item") or {}
            for i = 1, #(luaTable) do
                local tempData = luaTable[i];
                local data = kItemMgr:GetItemData(tempData);
                local itemData = kItemDBData[data.uiTypeID]
                if data and itemData then
                    local tempInfo = {};
                    tempInfo.itemData = itemData;
                    tempInfo.itemUID = data.uiID;
                    tempInfo.itemCount = data.uiItemNum;
            
                    local itemFeature = itemData.Feature;
                    local bCanOut = itemData.ItemType ~= ItemTypeDetail.ItemType_Task  -- 任务物品不能被带出
                    if bCanOut and itemFeature and #(itemFeature) > 0 then
                        for k, v in pairs(itemFeature) do
                            if v == ItemFeature.IF_CantInherit then
                                bCanOut = false;
                                break;
                            end
                        end
                    end
                    -- 如果物品有不可继承的特性, 或者品质为紫色及以下, 将被会回收为经脉经验而不会被带出
                    -- 但是如果这件物品作为装备, 有记录消耗的精铁或完美粉或通灵玉的时候
                    -- 为了不让用户的资产收到损失, 这件物品也要被带出
                    local bAssetProtect = ((data.uiEnhanceGrade or 0) >= SSD_ITEM_PROTECT_ENHANCE_GRADE) 
                                        or ((data.uiSpendTongLingYu or 0) > 0) 
                                        or ((data.uiPerfectPower or 0) > 0) 
                                        or ((data.uiSpendIron or 0) > 0)
                    local bShouldBeRec = (itemData.PersonalTreasure == 0) 
                                    and (itemData.ClanTreasure == 0) 
                                    and ((bCanOut ~= true) or (itemData.Rank <= RankType.RT_Orange))
                    if (bAssetProtect == true) or (bShouldBeRec == false) then
                        table.insert(self.outTable, tempInfo);
                    else
                        table.insert(self.recycleTable, tempInfo);
                    end
                    -- 如果一件物品是属于资产保护的, 那么在客户端加上物品的锁定状态
                    if bAssetProtect == true then
                        ItemDataManager:GetInstance():SetItemLockState(data.uiID, true)
                    end
                end
            end
        end
    end
    
    self.objImageEmpty3:SetActive( #self.outTable == 0)

        

    local _sort = function(a, b)
        if a.itemData.Rank > b.itemData.Rank then
            return true;
        end
        return false;
    end
    table.sort(self.outTable, _sort)
    local bOver = #(self.outTable) > 8;
    local count = bOver and 7 or #(self.outTable);
    if bOver then
        self.objOutAllBtn:SetActive(true);
    end
    for i = 1, count do
        local tempData = self.outTable[i];
        local itemData = itemMgr:GetItemData(tempData.itemUID)
        self:CreateIcon(itemData, nil, nil, kTransLayoutScriptOut)
    end

    --
    local kTransLayoutScriptCov = self.objLayoutScriptCov.transform
    table.sort(self.recycleTable, _sort)
    bOver = #(self.recycleTable) > 6;
    count = bOver and 5 or #(self.recycleTable);
    if bOver then
        self.objCovAllBtn:SetActive(true);
    end
    for i = 1, count do
        local tempData = self.recycleTable[i];
        local itemData = itemMgr:GetItemData(tempData.itemUID)
        self:CreateIcon(itemData, nil, nil, kTransLayoutScriptCov)
    end

    local index = 1;
    local maxScore = 0;
    local recycleSumScore = 0;
    for i = 1, #(self.recycleTable) do
        local tempData = self.recycleTable[i];
        local score = self:GetRecycleItemExp(tempData.itemData, tempData.itemCount);
        recycleSumScore = recycleSumScore + score;

        if score > maxScore then
            index = i;
            maxScore = score;
        end
    end

    local  bVis4 = #self.recycleTable == 0 or info.uiItemConvertMeridians <= 0
    self.objImageEmpty4:SetActive(bVis4)
    self.objImageMeridians:SetActive(false)
    self.objLayoutScriptCov:SetActive(not bVis4)

    if next(self.recycleTable) and info.uiItemConvertMeridians > 0 then
        local transItemIconRight = self.objItemIconUIRight.transform
        local itemTypeData = itemMgr:GetItemTypeDataByTypeID(9616);
        recycleSumScore = info.uiItemConvertMeridians
        self.objMaxScore:SetActive(false)
        local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
        if recycleSumScore >= commonConfig.WeekEndRecycleMeridiansMax then
            self.objMaxScore:SetActive(true)
        end
        self:CreateIcon(nil, itemTypeData, recycleSumScore, transItemIconRight)

        self.objLayoutScriptCov:SetActive(true);
    else
        self.objCovAllBtn:SetActive(false);
    end

    --
    if self.endShowType and self.endShowType > 0 and curScriptID == 1 then
        local objText = self:FindChild(self.objGoToTownBtn, 'Text');
        objText:GetComponent('Text').text = '下一步';
        PlayerSetDataManager:GetInstance():SetChangingScript(2);
    end
end

function ResultUI5:GetRecycleItemExp(itemData, itemCount)
    local TB_ItemRecycleExp = TableDataManager:GetInstance():GetTable("ItemRecycleExp")
    for i = 1, #(TB_ItemRecycleExp) do
        local itemRecycle = TB_ItemRecycleExp[i];
        if ItemDataManager:GetInstance():IsTypeEqual(itemData.ItemType, itemRecycle.RecycleType) then
            if itemRecycle.ItemRank[itemData.Rank] then
                return itemRecycle.RecycleExp[itemData.Rank] * itemCount;
            end                                           
        end
    end

    return 0;
end

function ResultUI5:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI5:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent('Button');
    local tog = gameObject:GetComponent('Toggle');
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback);

    end
end

function ResultUI5:OnclickBtn(obj, boolHide)
    if obj == self.objOutAllBtn then
        self:OnClickOutAllBtn(obj);

    elseif obj == self.objCovAllBtn and self.objCovAllBtn.activeSelf then
        self:OnClickCovAllBtn(obj);

    elseif obj == self.objGoToTapTapBtn then
        self:OnClickGoToTapTapBtn(obj);

    elseif obj == self.objGoToTownBtn then
        self:OnClickGoToTownBtn(obj);

    end
end

function ResultUI5:OnClickOutAllBtn(obj)
    
    local info = {
        type = 1,
        data = self.outTable,
    }
    self.ResultUI6:OnCreate(info);
    self._scriptUI.objResultUI6:SetActive(true);
end

function ResultUI5:OnClickCovAllBtn(obj)

    local info = {
        type = 2,
        data = self.recycleTable,
    }
    self.ResultUI6:OnCreate(info);
    self._scriptUI.objResultUI6:SetActive(true);
end

function ResultUI5:OnClickGoToTapTapBtn(obj)
    CS.UnityEngine.Application.OpenURL("https://www.taptap.com/app/172652");
end

function ResultUI5:OnClickGoToTownBtn(obj)
    if self.endShowType and self.endShowType > 0 then
        SendWeekEndGameOver(self._scriptUI.iFinalChoseBaby or 0);
        SendClickQuitStoryCMD();

        -- TODO 数据上报
        if self.info then
            MSDKHelper:SetQQAchievementData('scriptend', self.info.uiEndType);
            MSDKHelper:SendAchievementsData('scriptend');
        end
    else
        local _callback = function()
            self._scriptUI.objResultUI7:SetActive(true);
            SendWeekEndGameOver(self._scriptUI.iFinalChoseBaby or 0);
            SendClickQuitStoryCMD();

            -- TODO 数据上报
            if self.info then
                MSDKHelper:SetQQAchievementData('scriptend', self.info.uiEndType);
                MSDKHelper:SendAchievementsData('scriptend');
            end

            -- 结局物品统计开始
            StorageDataManager:GetInstance():StartRecordStoryEndItems()
        end
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '确认返回标题画面?', _callback });
    end
end

function ResultUI5:OnEnable()
end

function ResultUI5:OnDisable()
end

function ResultUI5:OnDestroy()
    self.ItemIconUI:Close();
    self.ResultUI6:Close();
end

function ResultUI5:InitShareUI()
    -- local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    -- if shareGroupUI then
    --     if not MSDKHelper:IsPlayerTestNet() then

    --         local _callback = function(bActive)
    --             local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
    --             if serverAndUIDUI and serverAndUIDUI._gameObject then
    --                 serverAndUIDUI._gameObject:SetActive(bActive);
    --             end

    --             local objImage = self:FindChild(self._gameObject, 'Image');
    --             if objImage then
    --                 objImage:SetActive(bActive);
    --             end
    --         end

    --         self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
    --         self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.JIESUAN, _callback, true);

    --         local canvas = shareGroupUI:GetComponent('Canvas');
    --         if canvas then
    --             canvas.sortingOrder = 1301;
    --         end
    --     else
    --         shareGroupUI:SetActive(false);
    --     end
    -- end
end

return ResultUI5