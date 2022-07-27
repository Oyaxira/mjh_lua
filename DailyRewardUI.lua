DailyRewardUI = class("DailyRewardUI",BaseWindow)

function DailyRewardUI:ctor()

end

function DailyRewardUI:Create()
	local obj = LoadPrefabAndInit("TownUI/DailyRewardUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DailyRewardUI:Init()
    self.comNormalContent_Transform = self:FindChild(self._gameObject, "Reward_Normal/content").transform
    self.comSuperContent_Transform = self:FindChild(self._gameObject, "Reward_Super/content").transform
    self.objSuperBG = self:FindChild(self._gameObject,"Reward_Super/bg")
    self.objSuperLock = self:FindChild(self._gameObject,"Reward_Super/panel_lock")
    self.comChallengeOrder_Button = self:FindChildComponent(self._gameObject, "Reward_Super/panel_lock/Button_ChallengeOrderLock","DRButton")

    self.comSubmit_Button = self:FindChildComponent(self._gameObject, "Button_submit","DRButton")
    self.comClose_Button = self:FindChildComponent(self._gameObject, "PopUpWindow_3/Board/Button_close","DRButton")
    self.comClose_Button2 = self:FindChildComponent(self._gameObject, "PopUpWindow_3/Black","DRButton")

    self.akItemUIClass = {}

    self:AddButtonClickListener(self.comChallengeOrder_Button,function()
        OpenWindowImmediately("ChallengeOrderUI")
    end)

    self:AddButtonClickListener(self.comSubmit_Button,function()
        SendRequestGetDailyReward()
        RemoveWindowImmediately("DailyRewardUI")
    end)

    self:AddButtonClickListener(self.comClose_Button,function()
        RemoveWindowImmediately("DailyRewardUI")
    end)

    self:AddButtonClickListener(self.comClose_Button2,function()
        RemoveWindowImmediately("DailyRewardUI")
    end)

    self:AddEventListener("CHALLENGEORDER_UNLOCK", function() self.bNeedRefresh = true end)
end

function DailyRewardUI:Update()
    if self.bNeedRefresh then
        bNeedRefresh = false
        self:RefreshUI()
    end
end

function DailyRewardUI:ReturnUIClass()
	if #self.akItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

function DailyRewardUI:RefreshUI()
    local state = PlayerSetDataManager:GetInstance():GetDailyRewardState()
    local eType = PlayerSetDataManager:GetInstance():GetChallengeOrderType()
    local bUnlockOrder = (eType and eType ~= COT_FREE)

    self:ReturnUIClass()

    if state == DRS_NULL then
        self:ShowRewardContent(self.comNormalContent_Transform, self:GetRewardInfos(false), false)
    else
        self:ShowRewardContent(self.comNormalContent_Transform, self:GetRewardInfos(false), true)
    end
    if state == DRS_ALL then
        self:ShowRewardContent(self.comSuperContent_Transform, self:GetRewardInfos(true), true)
    else
        self:ShowRewardContent(self.comSuperContent_Transform, self:GetRewardInfos(true), false)
    end

    self.objSuperLock:SetActive(not bUnlockOrder)
    self.objSuperBG:SetActive(bUnlockOrder)

    if state == DRS_NULL or (state == DRS_FREE and bUnlockOrder) then
        self.comSubmit_Button.gameObject:SetActive(true)
    else
        self.comSubmit_Button.gameObject:SetActive(false)
    end
end

function DailyRewardUI:ShowRewardContent(contentTrans, rewardInfos, isGot)
    if not rewardInfos then
        return
    end

    local ItemDataMgrInst = ItemDataManager:GetInstance()

    for index, rewardInfo in ipairs(rewardInfos) do
        local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, contentTrans)
        local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(rewardInfo.BaseID)
        local itemNums = rewardInfo.Num
        kItem:UpdateUIWithItemTypeData(itemTypeData)
        kItem:SetItemNum(itemNums, itemNums == 1)
        kItem:ShowGotReward(isGot)
        self.akItemUIClass[#self.akItemUIClass+1] = kItem
    end
end

function DailyRewardUI:GetRewardInfos(isSuper)
    local level = MeridiansDataManager:GetInstance():GetSumLevel() or 0

    local datas = TableDataManager:GetInstance():GetTable("DailyReward")
    if not datas then
        return {}
    end
    local iLandLadyID = ActivityHelper:GetInstance():GetCurActiveLandLady()
    local rewardData = nil
    for id, data in pairs(datas) do
        if level >= data.MeridiansLvlMin and level <= data.MeridiansLvlMax and data.WaiterID == iLandLadyID then
            rewardData = data
            break
        end
    end

    if not rewardData then
        return {}
    end

    local itemIDs = {}
    local itemNums = {}
    if not isSuper then
        itemIDs = rewardData.FreeRewards or {}
        itemNums = rewardData.FreeRewardsNum or {}
    else
        itemIDs = rewardData.ChallengeRewards or {}
        itemNums = rewardData.ChallengeRewardsNum or {}
    end

    local rewardInfos = {}
    for index, itemTypeID in ipairs(itemIDs) do
        local itemNum = itemNums[index] or 0

        if itemTypeID ~= 0 and itemNum ~= 0 then
            local reward = {
                ['BaseID'] = itemTypeID,
                ['Num'] = itemNum,
            }
            table.insert(rewardInfos, reward)
        end
    end

    return rewardInfos
end

return DailyRewardUI