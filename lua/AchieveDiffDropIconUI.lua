AchieveDiffDropIconUI = class("AchieveDiffDropIconUI", BaseWindow)

-- ItemInfoUI设计为只允许传入Item数据来初始化ui, 不再允许使用传入id和类型的表意不明的方法来动态获取数据

function AchieveDiffDropIconUI:ctor()
    
end

function AchieveDiffDropIconUI:OnDestroy()
    
end

function AchieveDiffDropIconUI:UpdateIcon(obj, TB_data, isfinish, hideLock, curstoryid, curdiff)
    self.Obj_icon = self:FindChild(obj,"Icon")
    self.Img_icon =  self:FindChildComponent(obj, "Icon","Image")
    self.Obj_AlreadyGet = self:FindChild(obj, "Mask")
    self.Obj_Question = self:FindChild(obj,"Question")
    self.Obj_Lock = self:FindChild(obj,"Lock")
    self.Obj_Lock:SetActive(false)
    self.Obj_Nums = self:FindChild(obj,"Num")
    self.Obj_Frame = self:FindChild(obj, "Frame")
    self.Obj_Nums:SetActive(false)
    self.curstoryid = curstoryid

    if (TB_data.WeekUnique==TBoolean.BOOL_YES) then
        -- self.Obj_Lock:SetActive(true)
    else
        -- self.Obj_Lock:SetActive(false)
    end
    local alreadyGetInfo = AchieveDataManager:GetInstance():GetDiffDropDataByTypeID(TB_data.BaseID,curstoryid, curdiff)
    local iget =  alreadyGetInfo and alreadyGetInfo.uiRoundFinish or 0
    local iLimitNum = TB_data.NumLimit 
    if (iLimitNum ~=0 and iLimitNum ~= 1) then 
        iget = iLimitNum - iget
        self.Obj_Nums:SetActive(true)
        local comnum = self.Obj_Nums:GetComponent('Text')
        if iget <= 0 then
            comnum.text = 0 .. '/' .. iLimitNum
        else
            comnum.text = iget .. '/'..iLimitNum
        end
    end 

    if (isfinish == true) then
        self.Obj_AlreadyGet:SetActive(true)
    else
        self.Obj_AlreadyGet:SetActive(false)
        if (not hideLock) then
        end
    end

    local data = self:_GetDiffDropItemData(TB_data)
    if( data.Icon ) then
        self.Img_icon.sprite = GetSprite(data.Icon)
    end

    if (data.Rank) then
        local rankMsgData = TableDataManager:GetInstance():GetTableData("RankMsg",data.Rank)
        if rankMsgData then 
            local comFrameImage = self:FindChildComponent(obj, "Frame","Image")
            self:SetSpriteAsync(rankMsgData.IconFrame,comFrameImage)
            self:SetFrameAnimation(obj, data.Rank)
        end
    end

    self:SetDefaultClickListener(obj,data)
end

local IconFrameAnimation = {
    [RankType.RT_Golden] = "animation",
    [RankType.RT_DarkGolden] = "animation2",
    [RankType.RT_MultiColor] = "animation2",
    [RankType.RT_ThirdGearDarkGolden] = "animation2",
    ['Heirloom'] = "animation4",
}

-- 设置物品框特效
function AchieveDiffDropIconUI:SetFrameAnimation(obj, key)
    local objEffect = self:FindChild(obj, "Effect")
    if not objEffect then
        return
    end
    local imgEffect = objEffect:GetComponent("Image")
    local kEffectData = ItemDataManager:GetInstance():GetItemFrameEffectData(key)
    if not (imgEffect and kEffectData) then
        objEffect:SetActive(false)
        return
    end
    imgEffect.sprite = kEffectData.sprite
    imgEffect.material = kEffectData.material
    objEffect:GetComponent("Transform").localScale = kEffectData.scale
    objEffect:SetActive(true)
end

-- 默认点击icon为弹出tips
function AchieveDiffDropIconUI:SetDefaultClickListener(obj, data, isfinish) 
    if not (obj) then
        return
    end

    -- local comButton = obj:GetComponent("Button")
    -- if not comButton then
    --     return
    -- end

    -- self:RemoveButtonClickListener(comButton)
    -- local fun = function()
    --     if (data and data["Tips"]) then
    --         OpenWindowImmediately("TipsPopUI", data["Tips"])
    --     end
    -- end
    -- self:AddButtonClickListener(comButton, fun)
    local comReturnUIAction = obj:GetComponent("LuaUIAction")
    if comReturnUIAction then
        local fun = function()
            if (data and data["Tips"]) then
                data["Tips"]['isSkew'] = true
                OpenWindowImmediately("TipsPopUI",data["Tips"])
            end
        end
        comReturnUIAction:SetPointerEnterAction(function()
            fun()
        end)

        comReturnUIAction:SetPointerExitAction(function()
            RemoveWindowImmediately("TipsPopUI")
        end)
    end
end

-- 根据当前幸运值和表，获取到图标
function AchieveDiffDropIconUI:_GetDiffDropItemData(TB_Data)
    local retData = {}

    -- 首先获取幸运值
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo");
    local Luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.curstoryid)
    local rewardData = AchieveDataManager:GetInstance():GetDiffDropRewordByLucky(TB_Data,Luckyvalue)
    if (not rewardData) then
        return retData
    end
    local itemValue = rewardData.Value
    local itemType = rewardData.Type

    local strDec = TB_Data.Desc
    
    if (itemType == StoryDiffDropRewardType.SDDRT_Item) then
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemValue)
        if (not itemTypeData) then
            return retData
        end
        retData["Icon"] = itemTypeData.Icon
        local itemTipInfo = TipsDataManager:GetInstance():GetItemTips(nil,itemValue)
        itemTipInfo["content"] = (strDec .. "\n\n" .. itemTipInfo["content"])
        retData["Tips"] = itemTipInfo
        retData["Rank"] = itemTypeData.Rank
    elseif (itemType == StoryDiffDropRewardType.SDDRT_Canzhang) then
        retData = TaskDataManager:GetInstance():GetMartialPageItem(itemValue,1)
        local depart = retData['Depart']
        local data = TableDataManager:GetInstance():GetTableData("Kftype",depart)
        local rank = retData['Rank']
        if (data) then
            retData['Icon'] = data.IncompleteBookIcon
        end
        
        retData["Tips"] = {["content"] =  (strDec .. "\n\n" .. retData['Desc']), ["title"] = retData["Name"], ["titlecolor"] = getRankColor(rank)} 
    elseif (itemType == StoryDiffDropRewardType.SDDRT_Miji) then
        retData = TaskDataManager:GetInstance():GetMartialBookItem(itemValue,1)
        local itemType = retData['ItemType']
        local depart = retData['Depart']
        local rank = retData['Rank']
        local TB_RankSecretBookIcon = TableDataManager:GetInstance():GetTable("RankSecretBookIcon")
        for index, data in ipairs(TB_RankSecretBookIcon) do
            if (data.Rank == rank) and (data.kftype == depart) then
                retData['Icon'] = data.SecretBookIcon
                break
            end
        end
        retData["Tips"] = {["content"] = (strDec .. "\n\n" .. retData['Desc']), ["title"] = retData["Name"], ["titlecolor"] = getRankColor(rank)} 
    end

    return retData
end

return AchieveDiffDropIconUI