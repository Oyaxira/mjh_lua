LuckItemIconUI = class("LuckItemIconUI", ItemIconUINew)

function LuckItemIconUI:Create(kParent)
	local obj = LoadPrefabAndInit("LuckyUI/LuckItem",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function LuckItemIconUI:Init()
    self.Img_icon =  self:FindChildComponent(self._gameObject, "Icon","Image")
    self.Obj_AlreadyGet = self:FindChild(self._gameObject, "Mask")
    self.Obj_Lock = self:FindChild(self._gameObject,"Lock")
    self.Obj_Nums = self:FindChild(self._gameObject,"Num")
	self.Obj_Nums:SetActive(false)
    self.imgFrame = self:FindChildComponent(self._gameObject, "Frame","Image")
    self.imgHeirloom = self:FindChildComponent(self._gameObject, "Heirloom","Image")
    self.objEffect = self:FindChild(self._gameObject, "Effect")
    self.imgEffect = self.objEffect:GetComponent("Image")
    self.transEffect = self.objEffect:GetComponent("Transform")
	self:SetDefaultClickListener()
end



function LuckItemIconUI:UpdateIcon(TB_data, isfinish, hideLock, curStoryID)
    if (isfinish == true) then
        self.Obj_AlreadyGet:SetActive(true)
        self.Obj_Lock:SetActive(false)
    else
        self.Obj_AlreadyGet:SetActive(false)
        if (not hideLock) then
            self.Obj_Lock:SetActive(true)
        end
    end

    self.Tips = nil

    local data = self:_GetDiffDropItemData(TB_data,curStoryID)
    if( data.Icon ) then
        self.Img_icon.sprite = GetSprite(data.Icon)
    end

    if (data.Rank) then
        self:UpdateIconFrame(data.Rank)
    end
  self.kData = TB_data
  self.curStoryID = curStoryID
  
end

-- 默认点击icon为弹出tips
function LuckItemIconUI:SetDefaultClickListener() 
    local comButton = self._gameObject:GetComponent("Button")
    if not comButton then
        return
    end

	local fun = function()
		if self.Tips == nil then
			self.Tips =  self:_GetDiffDropItemData(self.kData,self.curStoryID)["Tips"]
		end
		if self.Tips then
			OpenWindowImmediately("TipsPopUI", self.Tips)
		end
    end
    self:AddButtonClickListener(comButton, fun)
end

-- 根据当前幸运值和表，获取到图标
function LuckItemIconUI:_GetDiffDropItemData(TB_Data,curStoryID)
    local retData = {}

    -- 首先获取幸运值
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
    local Luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue(curStoryID)
    local rewardData = AchieveDataManager:GetInstance():GetDiffDropRewordByLucky(TB_Data,Luckyvalue)
    if (not rewardData) then
        return retData
    end
    local itemValue = rewardData.Value
    local itemType = rewardData.Type

    local strDec = TB_Data.Desc
    
    if (itemType == StoryDiffDropRewardType.SDDRT_Item) then
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemValue)
        retData["Icon"] = itemTypeData.Icon
        local itemTipInfo = TipsDataManager:GetInstance():GetItemTips(nil,itemValue)
        itemTipInfo["content"] = (strDec .. "\n" .. itemTipInfo["content"])
        retData["Tips"] = itemTipInfo
        retData["Rank"] = itemTypeData.Rank
    elseif (itemType == StoryDiffDropRewardType.SDDRT_Canzhang) then
        retData = TaskDataManager:GetInstance():GetMartialPageItem(itemValue,1)
        local depart = retData['Depart']
        local data = TableDataManager:GetInstance():GetTableData("Kftype",depart)
        local rank = retData['Rank']
        if (data) then
            retData['Icon'] = data.IncompleteBookIcon
        else
            local a = 0
        end
        local itemStaticData = ItemDataManager:GetInstance():GetItemTypeDataByItemTypeAndKey(retData['ItemType'], itemValue)
        retData["Tips"] = TipsDataManager:GetInstance():GetItemTipsByData(nil, itemStaticData)
        -- retData["Tips"] = {["content"] = retData['Desc'], ["title"] = retData["Name"], ["titlecolor"] = getRankColor(rank)} 
    elseif (itemType == StoryDiffDropRewardType.SDDRT_Miji) then
        retData = TaskDataManager:GetInstance():GetMartialBookItem(itemValue,1)
        local depart = retData['Depart']
        local rank = retData['Rank']
        local TB_RankSecretBookIcon = TableDataManager:GetInstance():GetTable("RankSecretBookIcon")
        for index, data in ipairs(TB_RankSecretBookIcon) do
            if (data.Rank == rank) and (data.Kftype == depart) then
                retData['Icon'] = data.SecretBookIcon
                break
            end
        end
        local itemStaticData = ItemDataManager:GetInstance():GetItemTypeDataByItemTypeAndKey(retData['ItemType'], itemValue)
        retData["Tips"] = TipsDataManager:GetInstance():GetItemTipsByData(nil, itemStaticData)
        -- retData["Tips"] = {["content"] = retData['Desc'], ["title"] = retData["Name"], ["titlecolor"] = getRankColor(rank)} 
    end

    return retData
end


return LuckItemIconUI