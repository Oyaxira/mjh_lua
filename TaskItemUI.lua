TaskItemUI = class("TaskItemUI", BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function TaskItemUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function TaskItemUI:OnDestroy()
    self.ItemIconUI:Close()
end

function TaskItemUI:UpdateUI(obj, reward)
    self:UpdateItemIcon(obj, reward)
    self:UpdateListener(obj, reward)
end

-- 先用物品UI渲染，然后根据其他数据，动态修改物品的描述、品质、数量、图标、类型、特殊图标、爱心图标等等。
function TaskItemUI:UpdateItemIcon(obj, reward)
    if not (obj and reward) then return end
    local comFrameImage = self:FindChildComponent(obj, "Frame", "Image")
    local comIconImage = self:FindChildComponent(obj, "Icon","Image")
    local comCountText = self:FindChildComponent(obj, "Num", "Text")
    if not (comIconImage and comCountText) then return end

    local objIconEx = self:FindChild(obj, "iconex")
    local objFavor = self:FindChild(objIconEx, "favor")
    local comFavorHead = self:FindChildComponent(objFavor, "Mask/head", "Image")
    local objCard = self:FindChild(objIconEx, "card")
    local objClan = self:FindChild(objIconEx, "clan")
    local comClanText = self:FindChildComponent(objClan, "text", "Text")
    local objHeart = self:FindChild(objIconEx, "heart")
    local objTick = self:FindChild(obj, "Tick")

    local objDiffDropGet = self:FindChild(obj,"GetMark")

    -- 初始化
    comFrameImage.gameObject:SetActive(true)
    comIconImage.gameObject:SetActive(true)
    objFavor:SetActive(false)
    objCard:SetActive(false)
    objClan:SetActive(false)
    objHeart:SetActive(false)
    objTick:SetActive(false)

    -- 传入模板id的物品显示
    local baseID =  reward['BaseID']
    local data = TableDataManager:GetInstance():GetTableData("Item",baseID)
    if baseID and data then
        local itemTypeData = data
        self.ItemIconUI:UpdateUIWithItemTypeData(obj, itemTypeData)
    end
    -- 传入了门派id的物品显示
    if reward['ClanTypeID'] then
        local iClanTypeID = reward['ClanTypeID']
        local kClanTypeData = TB_Clan[iClanTypeID]
        if kClanTypeData then
            objIconEx:SetActive(true)
            comFrameImage.gameObject:SetActive(false)
            comIconImage.gameObject:SetActive(false)
            objClan:SetActive(true)
            local strShowName = kClanTypeData.ClanAbbreviation
            if (not strShowName) or (strShowName == "") then
                local strClanName = GetLanguageByID(kClanTypeData.NameID)
                local iMaxWordCount = 2
                if string.utf8len(strClanName) > iMaxWordCount then
                    strShowName = string.utf8sub(strClanName, 1, iMaxWordCount)
                end
            end
            comClanText.text = strShowName
        end
    end
    -- 传入了物品类型的物品显示
    if reward['ItemType'] then
        local itemType = reward['ItemType']
        local depart = reward['Depart']
        local rank = reward['Rank']
        -- 获取icon数据
        if itemType == ItemTypeDetail.ItemType_SecretBook then
            local TB_RankSecretBookIcon = TableDataManager:GetInstance():GetTable("RankSecretBookIcon")
            for index, data in ipairs(TB_RankSecretBookIcon) do
                if (data.Rank == rank) and (data.kftype == depart) then
                    reward['Icon'] = data.SecretBookIcon
                    break
                end
            end
        elseif itemType == ItemTypeDetail.ItemType_IncompleteBook then
            local data = TableDataManager:GetInstance():GetTableData("Kftype",depart)
            reward['Icon'] = data.IncompleteBookIcon
        elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
            local TB_RankMsg = TableDataManager:GetInstance():GetTable("RankMsg")
            for index, data in ipairs(TB_RankMsg) do
                if data.Rank == rank then
                    reward['Icon'] = data.HeavenBookIcon
                    break
                end
            end
        end
        self.ItemIconUI:UpdateIconFrame(obj, rank)  -- 覆盖边框
    end
    -- 角色好感度的显示，隐藏 边框 和 图标，使用角色头像框
    if reward['RoleTypeID'] then
        local roleTypeID = reward['RoleTypeID']
        local roleDataMgr = RoleDataManager:GetInstance()
        local roleArtData = roleDataMgr:GetRoleArtDataByTypeID(roleTypeID)
        if roleArtData then
            -- reward['Icon'] = roleArtData.Head
            objIconEx.gameObject:SetActive(true)
            comFrameImage.gameObject:SetActive(false)
            comIconImage.gameObject:SetActive(false)
            objFavor:SetActive(true)
            comFavorHead.sprite = GetSprite(roleArtData.Head)
        end
    end
    -- 设置图标/数量
    if reward['Icon'] then
        comIconImage.sprite = GetSprite(reward['Icon'])
    end

    if reward['Num'] then
        comCountText.gameObject:SetActive(true)
        if reward['Num'] > 1 then 
            comCountText.text = reward['Num']
        elseif reward['Num'] == 1 then
            comCountText.text = ""
        end
    else
        comCountText.gameObject:SetActive(false)
    end

    -- 如果是全局难度幸运值掉落控制的，需要显示是否已经获得
    if objDiffDropGet then
        if (reward["DiffDropGet"]) then
            objDiffDropGet:SetActive(true)
        else
            objDiffDropGet:SetActive(false)
        end
    end
end

-- TODO：需要对 Listener 进行覆盖的，目前先只做角色卡
-- 如果描述修改了，监听要自己做覆盖，用自己组装的描述。
function TaskItemUI:UpdateListener(obj, reward)
    if not (obj and reward) then return end
    local comButton = obj:GetComponent("Button")
    if comButton and reward['Desc'] then
        local fun = function()
            local tips = {}
            tips.title = reward['Name']
            tips.content = reward['Desc']
            OpenWindowImmediately("TipsPopUI", tips)
        end
        self.ItemIconUI:AddClickFunc(comButton, fun)
    end

end


return TaskItemUI
