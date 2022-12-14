ItemIconUINew = class("ItemIconUINew", BaseWindow)

local lDarkColor = DRCSRef.Color(0.68, 0.68, 0.68, 1)
local lVec2Half = DRCSRef.Vec2(0.5, 0.5)

function ItemIconUINew:Create(kParent)
	local obj = LoadPrefabAndInit("Game/ItemIconUI",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ItemIconUINew:Init()
    self.imgFrame = self:FindChildComponent(self._gameObject, "Frame","Image")
    self.imgLighteffet = self:FindChildComponent(self._gameObject, "Lighteffet","Image")
    self.imgHeirloom = self:FindChildComponent(self._gameObject, "Heirloom","Image")
    self.objEffect = self:FindChild(self._gameObject, "Effect")
    if  self.objEffect  then
        self.imgEffect = self.objEffect:GetComponent("Image")
        self.transEffect = self.objEffect:GetComponent("Transform")
    end
    self.imgIcon = self:FindChildComponent(self._gameObject, "Icon", "Image")
    self.objIconex = self:FindChild(self._gameObject, "iconex")
    self.objCard  = self:FindChild(self._gameObject, "iconex/card")
    self.imgHead = self:FindChildComponent(self._gameObject, "iconex/card/head","Image")
    self.objFavor = self:FindChild(self._gameObject, "iconex/favor")
    self.imgFavorHead =  self:FindChildComponent(self._gameObject, "iconex/favor/head", "Image")
    self.objWish = self:FindChild(self._gameObject, "iconex/wish")
    self.imgWishHead =  self:FindChildComponent(self._gameObject, "iconex/wish/head", "Image")
    self.textNum = self:FindChildComponent(self._gameObject, "Num", "Text")
    self.objLock = self:FindChild(self._gameObject, "Lock")
    self.objFirstStory = self:FindChild(self._gameObject, "FirstStory")
    self.objTime = self:FindChild(self._gameObject, "Time")
    self.objClan = self:FindChild(self.objIconex, "clan")
    self.textClan = self:FindChildComponent(self.objClan, "text", "Text")
    self.objCity = self:FindChild(self.objIconex, "city")
    self.textCity = self:FindChildComponent(self.objCity, "text", "Text")
    self.objHeart = self:FindChild(self.objIconex, "heart")
    self.objDeleteSign = self:FindChild(self._gameObject, "DeleteSign")
    self.comRectTran = self._gameObject:GetComponent('RectTransform')
    self.objExtraName = self:FindChild(self._gameObject, "ExtraName")
    if self.objExtraName then
        self.textExtraName = self.objExtraName:GetComponent("Text")
    end
    self.objGotReward = self:FindChild(self._gameObject, "GotReward")
    self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))

    self:SetDefaultClickListener()
end

function ItemIconUINew:ResetAnchors()
    if  self.comRectTran then
        self.comRectTran.pivot = lVec2Half
        self.comRectTran.anchorMin  = lVec2Half
        self.comRectTran.anchorMax = lVec2Half
        self.comRectTran.anchoredPosition = DRCSRef.Vec2Zero
    end
end

-- ?????????????????????????????????
function ItemIconUINew:SetItemNum(iNum, hide)
    if not iNum then 
        return 
    end
    if self.textNum then
        if hide then
            self.textNum.gameObject:SetActive(false)
        else   
            self.textNum.gameObject:SetActive(true)
            self.textNum.text = iNum
        end
    end
end

function ItemIconUINew:SetFirstStory(enable)
    if self.objFirstStory then
        self.objFirstStory:SetActive(enable)
    end
end

-- ????????????????????????
function ItemIconUINew:SetIconState(strState)
    -- ??????Image??????
    local coms = {}
    if self.imgFrame then 
        coms[#coms + 1] = self.imgFrame 
    end
    if self.imgHeirloom then
        coms[#coms + 1] = self.imgHeirloom 
    end
    if self.imgIcon then 
        coms[#coms + 1] = self.imgIcon 
    end
    -- ????????????
    --[TODO] ??????????????????SetPropertyBlock
    for index, com in ipairs(coms) do
        if strState == "gray" then
            com.material = self.grayMat
        elseif strState == "dark" then
            com.color = lDarkColor
        else
            com.color = DRCSRef.Color.white
            com.material = nil
        end
    end
end

-- ??????????????????
function ItemIconUINew:UpdateLockState(bActive)
    if self.objLock then
        self.objLock:SetActive(bActive == true)
    end
end

function ItemIconUINew:UpdateItemCount(kItemData)
    local itemCount = 1
    if kItemData then
        itemCount = ItemDataManager:GetInstance():GetItemNum(kItemData.uiID)
    end
    local strCount = (itemCount and (itemCount > 1)) and tostring(itemCount) or ""
    self:SetItemNum(strCount)
end

-- ??????????????????
function ItemIconUINew:UpdateItemIcon(kItemTypeData)
    if not (kItemTypeData) then 
        return 
    end
    -- ?????????????????????,????????????????????????
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
            if self.objIconex then
                self.objIconex:SetActive(true)
            end
            if self.objCard then
                self.objCard:SetActive(true)
            end
            if self.imgIcon then
                self.imgIcon.gameObject:SetActive(false)
            end
            if self.imgHead then
                self:SetSpriteAsync(itemIcon,self.imgHead)
            end
        end
    else
        local itemIcon = kItemTypeData.Icon
        if itemIcon then 
            if self.objIconex then
                self.objIconex:SetActive(false)
            end
            if self.imgIcon then
                self.imgIcon.gameObject:SetActive(true)
                self:SetSpriteAsync(itemIcon,self.imgIcon)
            end
        end
    end

    local rank = kItemTypeData.Rank
    -- ?????????????????? ??? ??????
    if (kItemTypeData.PersonalTreasure ~= 0) or (kItemTypeData.ClanTreasure ~= 0)or (kItemTypeData.NoneTreasure == TBoolean.BOOL_YES) then
        self:SetHeirloom()
    else
        self:UpdateIconFrame(rank)
    end

    if self.objTime then
        if kItemTypeData.DueTimeValue and kItemTypeData.DueTimeValue > 0 then
            self.objTime:SetActive(true);
        else
            self.objTime:SetActive(false);
        end
    end


    if self.objDeleteSign then
        self.objDeleteSign:SetActive(false)
    end

    self:ShowExtraName(false)
    self:SetFirstStory(false)
    self:ShowGotReward(false)
end

-- ????????????????????????
function ItemIconUINew:SetHeirloom()
    if self.imgFrame then
        self.imgFrame.gameObject:SetActive(false)
    end

    if self.imgHeirloom then
        self.imgHeirloom.gameObject:SetActive(true)
    end

    self:SetFrameAnimation("Heirloom")
end

-- ????????????????????????
function ItemIconUINew:UpdateIconFrame(rank, bImmediately)
    local data = TableDataManager:GetInstance():GetTableData("RankMsg",rank)
    if not data then return end
    if self.imgFrame then
        self.imgFrame.gameObject:SetActive(true)
        if bImmediately == true then
            self.imgFrame.sprite = GetSprite(data.IconFrame)
        else
            self:SetSpriteAsync(data.IconFrame,self.imgFrame)
        end
    end
    if self.imgHeirloom then
        self.imgHeirloom.gameObject:SetActive(false)
    end
    self:SetFrameAnimation(rank)
end

-- ?????????????????????
function ItemIconUINew:SetFrameAnimation(key)
    if not (self.objEffect and self.transEffect) then
        return
    end
    local kEffectData = ItemDataManager:GetInstance():GetItemFrameEffectData(key)
    if not (self.imgEffect and kEffectData) then
        self.objEffect:SetActive(false)
        return
    end
    self.imgEffect.sprite = kEffectData.sprite
    self.imgEffect.material = kEffectData.material
    self.transEffect.localScale = kEffectData.scale
    self.objEffect:SetActive(true)
end

function ItemIconUINew:SetDefaultClickListener()
    local comButton = self._gameObject:GetComponent("Button")
    if not comButton then
        return
    end

    local fun = function()
        if self.onClick then
            self.onClick()
            return
        end

        if self.tips == nil then
            self:ResetClickData()
        end
        if self.tips ~= nil then
            OpenWindowImmediately("TipsPopUI", self.tips)        
        end
    end
    self:AddButtonClickListener(comButton, fun, self.canSaveBtn)
end


function ItemIconUINew:SetClickFunc(func)
    self.onClick = func
end
-- ????????????????????????????????????ui
function ItemIconUINew:UpdateUIWithItemTypeData(kItemTypeData,bHideNum)
    self.onClick = nil

    if not (kItemTypeData) then
        if self.imgHead then
            self.imgHead.sprite = nil
        end
        if self.imgIcon then
            self.imgIcon.sprite = nil
        end
        return
    end
    self:UpdateItemIcon(kItemTypeData)
    if bHideNum then
        self:HideItemNum()
    else
        self:UpdateItemCount()
    end
    self:UpdateLockState( false)
    self:SetIconState(nil)
    self:SetData(nil,kItemTypeData,nil)
end

-- ????????????????????????????????????ui
function ItemIconUINew:UpdateUIWithItemInstData(kItemData, showLockState,bHideNum)
    self.onClick = nil

    if not (kItemData) then
        if self.imgHead then
            self.imgHead.sprite = nil
        end
        if self.imgIcon then
            self.imgIcon.sprite = nil
        end
        return
    end

    local itemID = kItemData.uiID
    local uiTypeID = kItemData.uiTypeID
    local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiTypeID)

    self:UpdateItemIcon(kItemTypeData)
    if bHideNum then
        self:HideItemNum()
    else
        self:UpdateItemCount(kItemData)
    end
    self:SetIconState(nil)
    --self:SetDefaultClickListener(kItemData, kItemTypeData, showLockState)
    local isLock = false
    if showLockState then
        isLock = ItemDataManager:GetInstance():GetItemLockState(itemID)
    end
    self:UpdateLockState(obj, isLock)
    self:SetData(kItemData,kItemTypeData,showLockState)
end

-- ???????????????icon???name???????????????ui
function  ItemIconUINew:UpdateUIWithIconData(icon, name, tip)
    self:UpdateUIWithItemTypeData({
        Icon = icon,
        Rank = RankType.RT_White,
    }, true)

    self.textExtraName.text = name
    self.objExtraName:SetActive(true)

    self.tips =  {
        ['kind'] = 'normal',
        ['title'] = name,
        ['titlecolor'] = DRCSRef.Color.white,
        ['content'] = tip,
     }
end

-- ?????????????????????ID????????????UI
function  ItemIconUINew:UpdateUIWithRoleData(roleID, head, name)
    self:UpdateUIWithItemTypeData({
        Icon = head,
        Rank = RankType.RT_White,
    }, true)

    self.textExtraName.text = name
    self.objExtraName:SetActive(true)
    
    self.onClick = function ()
        if roleID > 0 then
            CardsUpgradeDataManager:GetInstance():DisplayRoleCardInfoObserve(roleID)
        end
    end
end
function ItemIconUINew:SetData(kItemData,kItemTypeData,showLockState)
    self.kItemData = kItemData 
    self.kItemTypeData = kItemTypeData
    self.showLockState = showLockState
    self.tips = nil
end

function ItemIconUINew:HideItemNum()
    if self.textNum then 
        self.textNum.gameObject:SetActive(false)
    end
end

function ItemIconUINew:GetIntValue()
    return self.intValue 
end

function ItemIconUINew:SetIntValue(iValue)
    self.intValue = iValue
end

function ItemIconUINew:ResetClickData()
    self.tips = TipsDataManager:GetInstance():GetItemTipsByData(self.kItemData, self.kItemTypeData)
    if self.showLockState and self.kItemData ~= nil then 
        local itemID = self.kItemData.uiID
        -- ????????????????????????????????????????????????
        if not ItemDataManager:GetInstance():ItemHasLockFeature(itemID) then
            local btnName = nil
            local btnFunc = nil
            if ItemDataManager:GetInstance():GetItemLockState(itemID) then
                btnName = "??????"
                btnFunc = function()
                    ItemDataManager:GetInstance():SetItemLockState(itemID, false)
                end
            else
                btnName = "??????"
                btnFunc = function()
                    ItemDataManager:GetInstance():SetItemLockState(itemID, true)
                end
            end
            self.tips.buttons = {
                {
                    ['name'] = btnName,
                    ['func'] = btnFunc
                }
            }
        end
    end
end

function ItemIconUINew:SetDeleteSign(bOn)
    if not self.objDeleteSign then
        return
    end
    self.objDeleteSign:SetActive(bOn == true)
end

function ItemIconUINew:ShowExtraName(bOn)
    if not (self.objExtraName and self.textExtraName) then
        return
    end
    bOn = (bOn == true)
    self.objExtraName:SetActive(bOn)
    if not bOn then
        self.textExtraName.text = ""
        return
    end
    local itemID, itemTypeID = nil, nil
    if self.kItemData then
        itemID = self.kItemData.uiID
    end
    if self.kItemTypeData then
        itemTypeID = self.kItemTypeData.BaseID
    end
    self.textExtraName.text = ItemDataManager:GetInstance():GetItemName(itemID, itemTypeID)
end

function ItemIconUINew:ShowGotReward(bOn)
    if self.objGotReward then
        self.objGotReward:SetActive(bOn == true)
    end
end

return ItemIconUINew