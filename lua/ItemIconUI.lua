ItemIconUI = class("ItemIconUI", BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

-- ItemIcon设计为只允许传入Item数据来初始化ui, 不再允许使用传入id和类型的表意不明的方法来动态获取数据

-- FIXME 某些ui不需要将委托保存在这里, 所有有了这个临时方法
function ItemIconUI:SetCanSaveButton(canSaveBtn)
    self.canSaveBtn = canSaveBtn
end

-- 使用物品实例数据来初始化ui
function ItemIconUI:UpdateUIWithItemInstData(obj, kItemData, showLockState)
    if not (obj and kItemData) then
        return
    end

    local itemID = kItemData.uiID
    local uiTypeID = kItemData.uiTypeID
    local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiTypeID)
    self.kItemData = kItemData
    self.kItemTypeData = kItemTypeData

    self:UpdateItemIcon(obj, kItemTypeData)
    self:UpdateItemCount(obj, kItemData)
    self:SetIconState(obj, nil)
    self:SetDefaultClickListener(obj, kItemData, kItemTypeData)
    local isLock = false
    if showLockState then
        isLock = ItemDataManager:GetInstance():GetItemLockState(itemID)
    end
    self:UpdateLockState(obj, isLock)
end

-- 使用物品静态数据来初始化ui
function ItemIconUI:UpdateUIWithItemTypeData(obj, kItemTypeData)
    if not (obj and kItemTypeData) then
        return
    end
    self.kItemData = nil
    self.kItemTypeData = kItemTypeData
    self:UpdateItemIcon(obj, kItemTypeData)
    self:UpdateItemCount(obj)
    self:UpdateLockState(obj, false)
    self:SetIconState(obj, nil)
    self:SetDefaultClickListener(obj, nil, kItemTypeData)
end

-- 默认点击icon为弹出tips
function ItemIconUI:SetDefaultClickListener(obj, kItemData, kItemTypeData)
    if not (obj and kItemTypeData) then
        return
    end

    local comButton = obj:GetComponent(l_DRCSRef_Type.Button)
    if not comButton then
        return
    end

    self:RemoveButtonClickListener(comButton)
    local fun = function()
        local tips = TipsDataManager:GetInstance():GetItemTipsByData(kItemData, kItemTypeData)
        OpenWindowImmediately("TipsPopUI", tips)
    end
    self:AddButtonClickListener(comButton, fun, self.canSaveBtn)
end

-- 为 obj 的 icon 添加不同的监听，可以覆盖默认监听
function ItemIconUI:AddClickFunc(obj, func_icon, itemID)
    if not obj then return end
    local comButton = obj:GetComponent(l_DRCSRef_Type.Button)
    if not comButton then return end
    self:RemoveButtonClickListener(comButton)
    if func_icon then
        self:AddButtonClickListener(comButton, function()
            func_icon(obj, itemID)
        end, self.canSaveBtn)
    end
end

-- 移除icon监听
function ItemIconUI:RemoveClickFunc(obj)
    if not obj then return end
    local comButton = obj:GetComponent(l_DRCSRef_Type.Button)
    if not comButton then return end
    self:RemoveButtonClickListener(comButton)
end

------------------------------------------------------
function ItemIconUI:UpdateStroyReward(obj, DropData)
    if not (obj and DropData) then return end

    local itemID = DropData['ItemID']
    local itemData = ItemDataManager:GetInstance():GetItemData(itemID)
    if not itemData then
        return
    end

    local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemData.uiTypeID)
    self:UpdateItemIcon(obj, kItemTypeData)

    local comCountText = self:FindChildComponent(obj, "Num", l_DRCSRef_Type.Text)
    if comCountText and DropData['ItemCountMin'] and DropData['ItemCountMax'] then
        local itemCount = 0
        if DropData['ItemCountMin'] == DropData['ItemCountMax'] then
            itemCount = DropData['ItemCountMax']
            if itemCount > 1 then 
                comCountText.text = tostring(itemCount)
            elseif itemCount == 1 then
                comCountText.text = ""
            end
        else
            comCountText.text = string.format("%d~%d",DropData['ItemCountMin'], DropData['ItemCountMax'])
        end
    end
end

function ItemIconUI:setFirstStory(obj, enable)
    local objFirstStory = self:FindChild(obj, "FirstStory")
    objFirstStory:SetActive(enable)
end
-----------------------------------------------------

function ItemIconUI:setEmpty(obj, enable)
    local objLock = self:FindChild(obj, "Lock")
    local objNum = self:FindChild(obj, "Num")
    local objIcon = self:FindChild(obj, "Icon")
    
    objLock:SetActive(not enable)
    objNum:SetActive(not enable)
    objIcon:SetActive(not enable)

    local objFrame = self:FindChild(obj, "Frame")
    local objHeirloom = self:FindChild(obj, "Heirloom")
    local objEffect = self:FindChild(obj, "Effect")
    local objTime = self:FindChild(obj, "Time")
    objFrame:SetActive(true)
    objHeirloom:SetActive(false)
    objEffect:SetActive(false)
    objTime:SetActive(false)
    
    local comFrameImage = self:FindChildComponent(obj, "Frame",l_DRCSRef_Type.Image)
    comFrameImage.sprite = GetAtlasSprite('CommonAtlas','pc_kongzhi')
end

function ItemIconUI:setEmptyGift(obj, enable)
    local objLock = self:FindChild(obj, "Lock")
    local objNum = self:FindChild(obj, "Num")
    local objIcon = self:FindChild(obj, "Icon")
    
    objLock:SetActive(not enable)
    objNum:SetActive(not enable)
    objIcon:SetActive(not enable)

    local objFrame = self:FindChild(obj, "Frame")
    local objHeirloom = self:FindChild(obj, "Heirloom")
    local objEffect = self:FindChild(obj, "Effect")
    local objTime = self:FindChild(obj, "Time")
    objFrame:SetActive(true)
    objHeirloom:SetActive(false)
    objEffect:SetActive(false)
    objTime:SetActive(false)
    
    local comFrameImage = self:FindChildComponent(obj, "Frame",l_DRCSRef_Type.Image)
    comFrameImage.sprite = GetSprite('icon_eauip_tianfushu_0001')
end

function ItemIconUI:setAlpha(obj, value)
    local comFrameImage = self:FindChildComponent(obj, "Frame",l_DRCSRef_Type.Image)
    local comIconImage = self:FindChildComponent(obj, "Icon",l_DRCSRef_Type.Image)
    local comHeirloomImage = self:FindChildComponent(obj, "Heirloom",l_DRCSRef_Type.Image)
    local comLighteffetImage = self:FindChildComponent(obj, "Lighteffet",l_DRCSRef_Type.Image)
    comFrameImage.color = DRCSRef.Color(1.0, 1.0, 1.0, value)
    comIconImage.color = DRCSRef.Color(1.0, 1.0, 1.0, value)
    comHeirloomImage.color = DRCSRef.Color(1.0, 1.0, 1.0, value)
    comLighteffetImage.color = DRCSRef.Color(1.0, 1.0, 1.0, value)
end

-- 更新物品图标
function ItemIconUI:UpdateItemIcon(obj, kItemTypeData)
    if not (obj and kItemTypeData) then 
        return 
    end
    
    local comFrameImage = self:FindChildComponent(obj, "Icon",l_DRCSRef_Type.Image)
    local iconex = self:FindChild(obj, "iconex")
    local card = self:FindChild(obj, "card")
    local head = nil
    if card then
        head = self:FindChildComponent(card.gameObject, "head",l_DRCSRef_Type.Image)
    end

    -- 如果是角色碎片,需要更改读取方式
    local iRoleTypeID 
    if kItemTypeData.ItemType == ItemTypeDetail.ItemType_RolePieces and kItemTypeData.FragmentRole > 0 then 
        iRoleTypeID = kItemTypeData.FragmentRole 
    elseif kItemTypeData.EffectType == EffectType.ETT_Unlock_MainRole and kItemTypeData.Value1 ~= '' then 
        local createdata = TableDataManager:GetInstance():GetTableData('CreateRole',tonumber(kItemTypeData.Value1))
        iRoleTypeID = createdata and createdata.OldRoleID 

    end 
    if iRoleTypeID and iRoleTypeID > 0 then
        local itemIcon
        local roleData = TB_Role[iRoleTypeID]
        if roleData then
            local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", roleData.ArtID)
            itemIcon = typeData and typeData.Head or ""
        end
        if itemIcon then 
            if iconex then
                iconex.gameObject:SetActive(true)
            end
            card.gameObject:SetActive(true)
            comFrameImage.gameObject:SetActive(false)
            if head then
                -- head.sprite = GetSprite(itemIcon)
                self:SetSpriteAsync(itemIcon,head)
            end
        end
    else
        local itemIcon = kItemTypeData.Icon
        if itemIcon then 
            if iconex then
                iconex.gameObject:SetActive(false)
            end
            comFrameImage.gameObject:SetActive(true)
            -- comFrameImage.sprite = GetSprite(itemIcon)
            self:SetSpriteAsync(itemIcon,comFrameImage)
        end
    end
   
    if num then
        local comCountText = self:FindChildComponent(obj, "Num", l_DRCSRef_Type.Text)
        comCountText.text = num;
    end
    local rank = kItemTypeData.Rank
    -- 设置图标底框 与 特效
    if (kItemTypeData.PersonalTreasure ~= 0)
    or (kItemTypeData.ClanTreasure ~= 0)
    or (kItemTypeData.NoneTreasure == TBoolean.BOOL_YES) then
        self:SetHeirloom(obj)
    else
        self:UpdateIconFrame(obj, rank)
    end

    --
    local objTime = self:FindChild(obj, "Time")
    if objTime then
        if kItemTypeData.DueTimeValue and kItemTypeData.DueTimeValue > 0 then
            objTime:SetActive(true);
        else
            objTime:SetActive(false);
        end
    end

    local objExtraName = self:FindChild(obj, "ExtraName")
    if objExtraName then
        objExtraName:SetActive(false)
    end
end

function ItemIconUI:UpdateItemCount(obj, kItemData)
    if not obj then 
        return 
    end
    local itemCount = 1
    if kItemData then
        itemCount = ItemDataManager:GetInstance():GetItemNum(kItemData.uiID)
    end
    local strCount = (itemCount and (itemCount > 1)) and tostring(itemCount) or ""
    local comCountText = self:FindChildComponent(obj, "Num", l_DRCSRef_Type.Text)
    self:SetItemNum(obj, strCount)
end

-- 隐藏物品图标数字
function ItemIconUI:HideItemNum(obj)
    if not obj then 
        return 
    end
    local objCountText = self:FindChild(obj, "Num")
    if objCountText then 
        objCountText:SetActive(false)
    end
end

-- 显示并设置物品图标数字
function ItemIconUI:SetItemNum(obj, iNum, hide)
    if not (obj and iNum) then 
        return 
    end
    local objCountText = self:FindChild(obj, "Num")
    objCountText:SetActive(true)
    local comCountText = objCountText:GetComponent(l_DRCSRef_Type.Text)
    if comCountText then 
        comCountText.text = tostring(iNum)
    end

    if (hide) then
        objCountText:SetActive(false)
    end
end

-- 更新锁定状态
function ItemIconUI:UpdateLockState(obj, bActive)
    local objLock = self:FindChild(obj, "Lock")
    if objLock then 
        objLock:SetActive(bActive == true)
    end
end

-- 设置物品底框图片
function ItemIconUI:UpdateIconFrame(obj, rank, bImmediately)
    local data = TableDataManager:GetInstance():GetTableData("RankMsg",rank)
    if not data then
        return 
    end
    local objFrame = self:FindChild(obj, "Frame")
    local objHeirloom = self:FindChild(obj, "Heirloom")
    objFrame:SetActive(true)
    objHeirloom:SetActive(false)
    local comFrameImage = self:FindChildComponent(obj, "Frame",l_DRCSRef_Type.Image)
    if bImmediately == true then
        comFrameImage.sprite = GetSprite(data.IconFrame)
    else
        self:SetSpriteAsync(data.IconFrame,comFrameImage)
    end
    self:SetFrameAnimation(obj, rank)
end

-- 设置物品为传家宝
function ItemIconUI:SetHeirloom(obj)
    local objFrame = self:FindChild(obj, "Frame")
    local objHeirloom = self:FindChild(obj, "Heirloom")
    objFrame:SetActive(false)
    objHeirloom:SetActive(true)
    self:SetFrameAnimation(obj, "Heirloom" , true)
end

-- 设置物品框特效
function ItemIconUI:SetFrameAnimation(obj, key ,ingoreMode)
    --品质的序列帧特效 在粒子低的情况下 不显示
    local objEffect = self:FindChild(obj, "Effect")
    if not objEffect then
        return
    end

    local particleMode = GetConfig("confg_ParticleMode")
    if particleMode == 1 and ingoreMode ~= true then
        objEffect:SetActive(false)
        return
    end

    local imgEffect = objEffect:GetComponent(l_DRCSRef_Type.Image)
    local kEffectData = ItemDataManager:GetInstance():GetItemFrameEffectData(key)
    if not (imgEffect and kEffectData) then
        objEffect:SetActive(false)
        return
    end
    imgEffect.sprite = kEffectData.sprite
    imgEffect.material = kEffectData.material
    objEffect:GetComponent(l_DRCSRef_Type.Transform).localScale = kEffectData.scale
    objEffect:SetActive(true)
end

-- 设置物品图标状态
function ItemIconUI:SetIconState(obj, strState)
    -- 收集Image组件
    local coms = {}
    local frameMat = self:FindChildComponent(obj, "Frame", l_DRCSRef_Type.Image)
    if frameMat then coms[#coms + 1] = frameMat end
    local heirloomMat = self:FindChildComponent(obj, "Heirloom", l_DRCSRef_Type.Image)
    if heirloomMat then coms[#coms + 1] = heirloomMat end
    local iconMat = self:FindChildComponent(obj, "Icon", l_DRCSRef_Type.Image)
    if iconMat then coms[#coms + 1] = iconMat end
    -- 设置参数
    for index, com in ipairs(coms) do
        com.color = DRCSRef.Color.white
        com.material = nil
        if strState == "gray" then
            if not self.grayMat then
                self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
            end
            com.material = self.grayMat
        elseif strState == "dark" then
            if not self.darkColor then
                self.darkColor = DRCSRef.Color(0.68, 0.68, 0.68, 1)
            end
            com.color = self.darkColor 
        end
    end
end

function ItemIconUI:ShowExtraName(obj, bOn)
    if not obj then
        return
    end
    local objExtraName = self:FindChild(obj, "ExtraName")
    local textExtraName = nil
    if objExtraName then
        textExtraName = objExtraName:GetComponent(l_DRCSRef_Type.Text)
    end
    if not textExtraName then
        return
    end
    bOn = (bOn == true)
    objExtraName:SetActive(bOn)
    if not bOn then
        textExtraName.text = ""
        return
    end
    local itemID, itemTypeID = nil, nil
    if self.kItemData then
        itemID = self.kItemData.uiID
    end
    if self.kItemTypeData then
        itemTypeID = self.kItemTypeData.BaseID
    end
    textExtraName.text = ItemDataManager:GetInstance():GetItemName(itemID, itemTypeID)
end

return ItemIconUI