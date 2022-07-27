RandomRollUI = class("RandomRollUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

local RandomState = {
    ['PrepateItems'] = 1,
    ['StartRoll'] = 2,
    ['Rolling'] = 3,
    ['SlowDown'] = 4,
    ['Select'] = 5,
    ['GetAnime'] = 6,
    ['AnimeEnd'] = 7,
}

local NPCInteractToPlayerBehaviorType = {
    [NPCIT_COMPARE] = PlayerBehaviorType.PBT_QieCuo,
    [NPCIT_BEG] = PlayerBehaviorType.PBT_QiTao,
    [NPCIT_STEAL_GIFT] = PlayerBehaviorType.PBT_TouXue,
    [NPCIT_CONSULT_GIFT] = PlayerBehaviorType.PBT_QingJiao,
    [NPCIT_STEAL_MARTIAL] = PlayerBehaviorType.PBT_TouXue,
    [NPCIT_CONSULT_MARTIAL] = PlayerBehaviorType.PBT_QingJiao,
    [NPCIT_CALLUP] = PlayerBehaviorType.PBT_CallUp,
    [NPCIT_PUNISH] = PlayerBehaviorType.PBT_Punish,
    [NPCIT_INQUIRY] = PlayerBehaviorType.PBT_INQUIRY,
}

local MaxSpeed = 800
local StartTime = 0.5
local RollingTime = 0.8
local SlowDownCount = 10
local GetAnimeTime = 0.5

function RandomRollUI:ctor()
    
end

function RandomRollUI:Create()
	local obj = LoadPrefabAndInit("Game/RandomRollUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function RandomRollUI:Init()
    PlayerSetDataManager:GetInstance():DisableCoinAnim()
    self.ItemIconUI = ItemIconUI.new()
    self.space = 60
    self.startx =  self.space * -4
    self.itemIdx = 0
    self.lightRotate = 0

	local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    if shareGroupUI then
        if not MSDKHelper:IsPlayerTestNet() then

            local _callback = function(bActive)
                local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
                if serverAndUIDUI and serverAndUIDUI._gameObject then
                    serverAndUIDUI._gameObject:SetActive(bActive);
                end

                local objText = self:FindChild(self._gameObject, 'Tips_Text');
                if objText then
                    objText:SetActive(bActive);
                end
            end

            self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
            self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.WUPING, _callback);

            local canvas = shareGroupUI:GetComponent('Canvas');
            if canvas then
                canvas.sortingOrder = 1401;
            end
        else
            shareGroupUI:SetActive(false);
        end
	end
    
    self.objRoot = self:FindChild(self._gameObject, "G_Root")
    self.comToucheButton = self:FindChildComponent(self._gameObject, 'G_Close', 'Button')
    self.comRuleButton = self:FindChildComponent(self._gameObject, 'TransformAdapt_node_right/Rule_Btn', 'Button')
    self.objRuleButton = self:FindChild(self._gameObject,'TransformAdapt_node_right/Rule_Btn')
    self.objItemIconGet = self:FindChild(self._gameObject,'ItemIconGet')
    self.objArray = {}
    self.objTipsText = self:FindChild(self._gameObject, 'Tips_Text')
    self.objFrameIcon = self:FindChild(self._gameObject, 'Frame/Icon')

    self.rootTransform = self.objRoot.transform

    self:AddButtonClickListener(self.comToucheButton, function()
        if self.state == RandomState.Select and self.uiItemTypeID > 0 then
            local scWidth = CS.UnityEngine.Screen.width
            local scHeight = CS.UnityEngine.Screen.height
            self.state = RandomState.GetAnime
            self.objItemIconGet:SetActive(true)
            self.animeStartPos = self.objItemIconGet.transform.localPosition
            self.animeTargetPos = DRCSRef.Vec3(self.animeStartPos.x + 0.7 * scWidth, self.animeStartPos.y - 150)
            self.getAnimeTime = 0
            
            -- local objLock = self:FindChild(self.finalObj, "Lock")
            -- local objNum = self:FindChild(self.finalObj, "Num")
            -- local objHeirloom = self:FindChild(self.finalObj, "Heirloom")
            -- local objIcon = self:FindChild(self.finalObj, "Icon")
            -- local objLighteffetImage = self:FindChild(self.finalObj, "Lighteffet")    
            -- local objEffect = self:FindChild(self.finalObj, "Effect")

            local objLock = self:FindChild(self.objFrameIcon, "Lock")
            local objNum = self:FindChild(self.objFrameIcon, "Num")
            local objHeirloom = self:FindChild(self.objFrameIcon, "Heirloom")
            local objIcon = self:FindChild(self.objFrameIcon, "Icon")
            local objLighteffetImage = self:FindChild(self.objFrameIcon, "Lighteffet")    
            local objEffect = self:FindChild(self.objFrameIcon, "Effect")
           
            objEffect:SetActive(false)
            objLock:SetActive(false)
            objNum:SetActive(false)
            objIcon:SetActive(false)
            objHeirloom:SetActive(false)
            objLighteffetImage:SetActive(false)
        elseif self.state == RandomState.Select then
            local bNeedDisplayEnd = self.bNeedDisplayEnd
            RemoveWindowImmediately("RandomRollUI", false)
            LuaEventDispatcher:dispatchEvent("ONEVENT_REF_CONSULTUI_DETAIL")
            DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
            if bNeedDisplayEnd then
                self.bNeedDisplayEnd = false
                DisplayActionEnd()
            end
        end  
    end)

    self:AddButtonClickListener(self.comRuleButton, function()
        local desid = self:GetDesID()
        if desid then
            
            local info = {
                desid = desid,
                pivotx = 1,
                pivoty = 0,
                posx = self.objRuleButton.transform.position.x,
                posy = self.objRuleButton.transform.position.y
            }

            OpenWindowImmediately("RulePopUI", info)
        end
    end)

    self.comRoleCGImg = self:FindChildComponent(self._gameObject, 'CG', 'Image')
end

function RandomRollUI:GetDesID()
    if (not self.eInteractType) or (not NPCInteractToPlayerBehaviorType[self.eInteractType]) then
        return 0
    end
    local TB_InteractLimit = TableDataManager:GetInstance():GetTable("InteractLimit")
    for i=1, #TB_InteractLimit do
        if TB_InteractLimit[i].PlayerBehavior == NPCInteractToPlayerBehaviorType[self.eInteractType] then
            if TB_InteractLimit[i].DesID ~= 0 then
                return TB_InteractLimit[i].DesID
            end
            return 0
        end
    end
    return 0
end


function RandomRollUI:GetDisplayData(uiTypeID)
    if self.eInteractType == NPCIT_STEAL_GIFT or self.eInteractType == NPCIT_CONSULT_GIFT then
        local itemid = ItemDataManager:GetInstance():GetGiftItemByGift(uiTypeID) 
        local martialTypeData = TableDataManager:GetInstance():GetTableData("Item",itemid)
        return martialTypeData
    elseif self.eInteractType == NPCIT_STEAL_MARTIAL or self.eInteractType == NPCIT_CONSULT_MARTIAL then
        local itemid = ItemDataManager:GetInstance():GetBookItemByMartial(uiTypeID) 
        local martialTypeData = TableDataManager:GetInstance():GetTableData("Item",itemid)
        return martialTypeData
    else
        local itemData = nil
        local itemTypeData = nil

        -- 若得到了此物品,则从最近主角获得的道具中获取实例数据
        if uiTypeID == self.uiItemTypeID then
            local itemID = ItemDataManager:GetInstance():GetMainRoleNewItemID(uiTypeID)
            if itemID then
                itemData = ItemDataManager:GetInstance():GetItemData(itemID)
            end
        end
            
        itemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiTypeID)

        return itemTypeData, itemData
    end
end

function RandomRollUI:GetItemData()
    if not self.uiItemTypeID then
        return 'error'
    end

    if self.eInteractType == NPCIT_STEAL_GIFT or self.eInteractType == NPCIT_CONSULT_GIFT then
        local martialTypeData = TableDataManager:GetInstance():GetTableData("Gift",self.uiItemTypeID)
        return martialTypeData
    elseif self.eInteractType == NPCIT_STEAL_MARTIAL or self.eInteractType == NPCIT_CONSULT_MARTIAL then
        local martialTypeData = GetTableData("Martial",self.uiItemTypeID) 
        return martialTypeData
    else
        local martialTypeData = TableDataManager:GetInstance():GetTableData("Item",self.uiItemTypeID)
        return martialTypeData
    end 
end

function RandomRollUI:GetItemName()
    if not self.uiItemTypeID then
        return 'error'
    end

    if self.eInteractType == NPCIT_STEAL_GIFT or self.eInteractType == NPCIT_CONSULT_GIFT then
        local martialTypeData = TableDataManager:GetInstance():GetTableData("Gift",self.uiItemTypeID)
        if not martialTypeData then
            return "error"
        end
        return GetLanguageByID(martialTypeData.NameID)
    elseif self.eInteractType == NPCIT_STEAL_MARTIAL or self.eInteractType == NPCIT_CONSULT_MARTIAL then
        local martialTypeData = GetTableData("Martial",self.uiItemTypeID) 
        if not martialTypeData then
            return "error"
        end
        return GetLanguageByID(martialTypeData.NameID)
    else
        return ItemDataManager:GetInstance():GetItemName(nil, self.uiItemTypeID)
    end 
end

function RandomRollUI:UpdateRoleImg()
    local strCG = nil
    if self.strDrawing then
        strCG = self.strDrawing
    elseif self.uiRoleID and (self.uiRoleID > 0) then
        local roleData = RoleDataManager:GetInstance():GetRoleData(self.uiRoleID)
        if roleData then
            local roleTypeID = roleData.uiTypeID
            
            local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
            if artData == nil then 
                return
            end
            strCG = artData.Drawing 
        end
    end
    if (not strCG) or (strCG == "") or (not self.comRoleCGImg) then
        return
    end 
    self.comRoleCGImg.gameObject:SetActive(true)
    self.comRoleCGImg.sprite = GetSprite(strCG)
    self.comRoleCGImg:SetNativeSize()
end

function RandomRollUI:RefreshUI(kNPCInteractRandomItems)
    if not kNPCInteractRandomItems then
        return
    end

    self.bNeedDisplayEnd = (kNPCInteractRandomItems['bNeedDisplayEnd'] == true)
    -- 如果交互类型是 盘查, 那么客户端填充相应的税局
    if kNPCInteractRandomItems.eInteractType == NPCIT_INQUIRY then
        -- 填充物品数据
        kNPCInteractRandomItems.auiRoleItem = {
            [0] = 801004,
            [1] = 801005,
        }
        -- 填充目标物品
        local eRes2TarItem = {
            [IRT_SAFE] = 0,
            [IRT_DOUBT] = 801005,
            [IRT_GUILT] = 801004,
        }
        if not kNPCInteractRandomItems.uiItemID then
            kNPCInteractRandomItems.uiItemID = IRT_SAFE
        end
        kNPCInteractRandomItems.uiItemID = eRes2TarItem[kNPCInteractRandomItems.uiItemID] or 0
    end
    
    self.iItemP = kNPCInteractRandomItems.iItemP or 0
    dprint("================ 概率 start =============")
    dprint(self.iItemP)
    dprint(kNPCInteractRandomItems.uiItemID)
    dprint("================ 概率 end =============")
    if self.iItemP <= 0 then
        self.iItemP = 20
    elseif self.iItemP >= 100 then
        self.iItemP = 60
    end

    -- 这三个字段只有在和玩家切磋完毕roll奖的时候才会传入
    self.strRoleName = kNPCInteractRandomItems.strName
    self.strDrawing = kNPCInteractRandomItems.strDrawing
    self.bIsPlayerFight = kNPCInteractRandomItems.bIsPlayerFight

    self.state = RandomState.PrepateItems
    self.auiItemTypeIDs = kNPCInteractRandomItems.auiRoleItem
    self.uiItemTypeID = kNPCInteractRandomItems.uiItemID
    self.uiRoleID = kNPCInteractRandomItems.uiRoleID
    self.eInteractType = kNPCInteractRandomItems.eInteractType
    self.iNum = kNPCInteractRandomItems.iNum
    if self.uiItemTypeID > 0 then
        self.itemTypeData = self:GetItemData()
    end

    self.objItemIconGet:SetActive(false)
    self:UpdateIcon(self.objItemIconGet, self.uiItemTypeID)
    self:UpdateIcon(self.objFrameIcon, self.uiItemTypeID)
    self.itemWeights = {}
    
    for i=0, getTableSize(self.auiItemTypeIDs) - 1 do
        self.itemWeights[i] = 1
    end

    self.speedx = 0
    self.rollDur = 0
    self.treasureCount = 0

    if self.objRoot then
        
        for i=1, #self.objArray do
            local comButton = self.objArray[i]:GetComponent(DRCSRef_Type.Button)
            self.ItemIconUI:RemoveButtonClickListener(comButton)
        end
        
        RemoveAllChildren(self.objRoot)

        for i=1,10 do
            local typeid = self:GenRanDomTypeID()
            local objIconItem = LoadPrefabAndInit("Game/ItemIconUI",self.objRoot,true)
            if (objIconItem ~= nil) then
                objIconItem.transform.localPosition = DRCSRef.Vec3(self.startx + self.itemIdx * self.space,0,0)      
                self.objArray[i] = objIconItem
                self:UpdateIcon(objIconItem, typeid)
                self.itemIdx = self.itemIdx + 1
                if self.itemIconWidth == nil then 
                    self.itemIconWidth = objIconItem.transform.width
                end
            end
        end
        
        local siblingIndexs = {2,4,6,8,9,7,5,3,1,0}
        for i=1, 10 do
            self.objArray[i].transform:SetSiblingIndex(siblingIndexs[i])
        end
    end

    self.state = RandomState.StartRoll
    self.needToCheck = 1
    self.lastIdx = 10
    self.moveDis = 0
    self.geziDis = 0
    
    if self.uiRoleID or self.strDrawing then
        self:UpdateRoleImg()
    end

    self.objTipsText:SetActive(false)
    self.objFrameIcon:SetActive(false)
    -- 判断是否有介绍, 没有的话不显示介绍按钮
    if dnull(self:GetDesID()) then 
        self.objRuleButton:SetActive(true)
    else
        self.objRuleButton:SetActive(false)
    end
end

function RandomRollUI:GenRanDomTypeID()
    
    if self.state == RandomState.SlowDown then
        self.slowDownCount = self.slowDownCount - 1
        dprint(self.slowDownCount)
        if self.slowDownCount == 0 then
            -- self.finalObj = self.objArray[self.needToCheck]
            return self.uiItemTypeID
        end
    end

    if self.auiItemTypeIDs then
        if not self.iItemP then
            self.iItemP = 20 
        end
        local randomNum = math.random(1, self.iItemP + 10)
        if randomNum <= self.iItemP then
            local randomidx = self:RandomWithWeight(self.itemWeights)
            for i=0, getTableSize(self.itemWeights)-1 do
                self.itemWeights[i] = self.itemWeights[i] + 1
            end

            self.itemWeights[randomidx] = 0
            local istre = self:IsTreasure(self.auiItemTypeIDs[randomidx])
            
            if self.treasureCount < 1 and istre and self.state ~= RandomState.SlowDown then
                self.treasureCount = self.treasureCount + 1
                return self.auiItemTypeIDs[randomidx]
            elseif not istre then
                return self.auiItemTypeIDs[randomidx]
            end

        end
    end
end

local DONT_SHOW_TOAST_INTERACT = 
{
    [NPCIT_INQUIRY] = true,
    [NPCIT_CALLUP] = true,
    [NPCIT_STEAL_GIFT] = true,
    [NPCIT_STEAL_MARTIAL] = true,
    [NPCIT_CONSULT_GIFT] = true,
    [NPCIT_CONSULT_MARTIAL] = true,
}

function RandomRollUI:Update(dt)
    dt = dt/1000
    self.lightRotate = self.lightRotate + dt * 15
    --dprint(dt)
    if self.state == RandomState.StartRoll then
        self.speedx = MaxSpeed * (self.rollDur/StartTime)
        self.moveDis = self.moveDis + self.speedx * dt
        self.rootTransform.localPosition = self.rootTransform.localPosition - DRCSRef.Vec3(self.speedx * dt,0,0)
        self.rollDur = self.rollDur + dt

        self.geziDis = self.geziDis + self.speedx * dt
        if self.geziDis > 80 then 
            PlayButtonSound("EventRoll")
            self.geziDis = self.geziDis % 80
        end

        if self.rollDur >= StartTime then
            self.state = RandomState.Rolling
            self.rollDur = 0
        end
    elseif self.state == RandomState.Rolling then
        self.speedx = MaxSpeed
        self.moveDis = self.moveDis + self.speedx * dt
        self.rootTransform.localPosition = self.rootTransform.localPosition - DRCSRef.Vec3(self.speedx * dt,0,0)
        self.rollDur = self.rollDur + dt
        self.geziDis = self.geziDis + self.speedx * dt
        if self.geziDis > 80 then 
            PlayButtonSound("EventRoll")
            self.geziDis = self.geziDis % 80
        end

        if self.rollDur >= RollingTime then
            self.state = RandomState.SlowDown
            self.slowDownRoll = 0
            self.slowDownCount = SlowDownCount - 5
            if self.moveDis > self.space then
                self.slowDownCount = self.slowDownCount + 1
            end
            self.slowDownTargetX = -(math.floor(-self.rootTransform.localPosition.x/self.space) + SlowDownCount) * self.space
            self.slowDownDistance = math.abs(self.slowDownTargetX - self.rootTransform.localPosition.x)
        end
    elseif self.state == RandomState.SlowDown then
        
        self.speedx = math.max(MaxSpeed * (1 - (self.slowDownRoll/self.slowDownDistance)), 80)
        self.moveDis = self.moveDis + self.speedx * dt
        self.slowDownRoll = self.slowDownRoll + self.speedx * dt

        self.rootTransform.localPosition = self.rootTransform.localPosition - DRCSRef.Vec3(self.speedx * dt,0,0)
        self.geziDis = self.geziDis + self.speedx * dt
        if self.geziDis > 80 then 
            PlayButtonSound("EventRoll")
            self.geziDis = self.geziDis % 80
        end
        if self.rootTransform.localPosition.x <=  self.slowDownTargetX then
            self.speedx = 0
            self.state = RandomState.Select
            self.rootTransform.localPosition.x = self.slowDownTargetX
            self.objTipsText:SetActive(true)
            self.objFrameIcon:SetActive(true)
            -- self.finalObj.transform:SetAsLastSibling()
        end

    elseif self.state == RandomState.GetAnime then
        self.geziDis = 0
        local dx = self.animeTargetPos.x - self.animeStartPos.x
        local dy = self.animeTargetPos.y - self.animeStartPos.y
        local valuex = dx * self.getAnimeTime/GetAnimeTime
        local valuey = dy * (self.getAnimeTime * self.getAnimeTime)/GetAnimeTime
   
        self.objItemIconGet.transform.localPosition = DRCSRef.Vec3(self.animeStartPos.x + valuex, self.animeStartPos.y + valuey, 0)
        
        self.getAnimeTime = self.getAnimeTime + dt
        if self.getAnimeTime > GetAnimeTime then
            if self.itemTypeData and self.itemTypeData.PersonalTreasure ~= 0 then 
                PlayButtonSound("EventRollTreasure")
            end
            --判断背包是否满格，可以进入临时背包
            local tempItemsize = RoleDataHelper.GetTempBackpackItemsSize()
            local bDestoryItem = false
            local roleInfo = globalDataPool:getData("MainRoleInfo") or {}
            local mainRoleInfo = roleInfo["MainRole"]
            local backpackSizeLimit = 0
            if mainRoleInfo then
                backpackSizeLimit = mainRoleInfo[MRIT_BAG_ITEMNUM] or 0
            end
            -- 当前背包物品数量
            local iCurBagNum = RoleDataHelper.GetMainRoleBackpackSize()
            if (iCurBagNum == backpackSizeLimit or tempItemsize > 0) and self.itemTypeData.Rank < 6 and 
                self.itemTypeData.ItemType ~= ItemTypeDetail.ItemType_Task then
                bDestoryItem = true
            end

            self.state = RandomState.AnimeEnd
            self.objItemIconGet:SetActive(false)

            if self.itemTypeData and not DONT_SHOW_TOAST_INTERACT[self.eInteractType] then
                local itemName = self.itemTypeData.ItemName or ''
                local rolename = nil
                if self.strRoleName and (self.strRoleName ~= "") then
                    rolename = self.strRoleName
                elseif self.uiRoleID and (self.uiRoleID > 0) then
                    rolename =  RoleDataHelper.GetNameByID(self.uiRoleID)
                end
                if rolename and (rolename ~= "") then
                    local customStr = '从' .. rolename .. '那里获得了' .. itemName
                    if itemName == "铜币" then
                        customStr = customStr.."x"..self.iNum
                    end
                    if bDestoryItem then
                        customStr = customStr..",背包已满，该物品消失"
                    end
                    SystemUICall:GetInstance():Toast(customStr, nil, nil, "RANDOMROLL")
                end
            end
            self:DisplayGetChuanJiaBao()

            -- 如果玩家切磋并且获得了优惠券物品, 那么直接打开优惠券界面
            if self.bIsPlayerFight and self.itemTypeData 
            and (self.itemTypeData.EffectType == EffectType.ETT_Item_UseItem_Coupon) then
                local kTryGetInstData = StorageDataManager:GetInstance():GetItemDataByTypeID(self.uiItemTypeID)
                if kTryGetInstData then
                    OpenWindowImmediately("CouponUI", kTryGetInstData.uiID)
                end
            end

            local bNeedDisplayEnd = self.bNeedDisplayEnd
            RemoveWindowImmediately("RandomRollUI", false)
            LuaEventDispatcher:dispatchEvent("ONEVENT_REF_CONSULTUI_DETAIL")
            DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
            if bNeedDisplayEnd then
                self.bNeedDisplayEnd = false
                DisplayActionEnd()
            end
            return
        end 
    end

    local checkObj = self.objArray[self.needToCheck]
    if self.moveDis > self.space then
        self.moveDis = self.moveDis - self.space
        local typeid = self:GenRanDomTypeID()
        self:UpdateIcon(checkObj, typeid)
        local right = self.objArray[self.lastIdx].transform.localPosition
        local left = checkObj.transform.localPosition
        left.x = right.x + self.space
        checkObj.transform.localPosition = left
        checkObj.transform:SetAsFirstSibling()

        self.lastIdx = self.needToCheck
        self.needToCheck = self.needToCheck + 1
        if self.needToCheck > 10 then
            self.needToCheck = 1
        end

        local centerIdx = self.needToCheck + 5
        if centerIdx > 10 then
            centerIdx = centerIdx - 10
        end
        self.objArray[centerIdx].transform:SetAsLastSibling()
    end

    self:UpdateScale()
end

function RandomRollUI:OnDestroy()
    if self.ItemIconUI then
        self.ItemIconUI:Close()
    end
    if self.TencentShareButtonGroupUI then
		self.TencentShareButtonGroupUI:Close();
	end

    PlayerSetDataManager:GetInstance():EnableCoinAnim()
end

function RandomRollUI:RandomWithWeight(aWeight)
    local uiTotail = 0
    for i=0, getTableSize(aWeight)-1 do
        uiTotail = aWeight[i] + uiTotail
    end
    local random = math.random(0, uiTotail)

    local temp = 0
    for i=0, getTableSize(aWeight)-1 do
        temp = aWeight[i] + temp
        if temp >= random then
            return i
        end
    end

    return getTableSize(aWeight)-1
end

function RandomRollUI:UpdateScale()
    for i=1,10 do
        if self.objArray[i] then
            local transform = self.objArray[i].transform
            local offx = math.abs(self.startx) - math.abs(self.rootTransform.localPosition.x + transform.localPosition.x)
            offx = math.max(0, offx)
            transform.localPosition.z = offx
            local scale = 0.5 * offx/math.abs(self.startx) + 0.7
            transform.localScale= DRCSRef.Vec3(scale, scale, scale)
            self.ItemIconUI:setAlpha(self.objArray[i], offx/math.abs(self.startx) + 0.1)

            local objLight = self:FindChild(self.objArray[i], "Lighteffet")
            if objLight.activeSelf then
                objLight.transform.localEulerAngles = DRCSRef.Vec3(0,0,self.lightRotate)
            end
        end
    end
end

function RandomRollUI:DisplayGetChuanJiaBao()
    if (not self.uiRoleID) or (self.uiRoleID == 0) then
        return
    end
    local uiRoleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(self.uiRoleID) or 0

    if uiRoleTypeID ~= 0 and self.itemTypeData and self.itemTypeData.PersonalTreasure == uiRoleTypeID then    
        local itemName = self.itemTypeData.ItemName or ''
        local customStr = RoleDataManager:GetInstance():GetMainRoleName() .. '，我这件心爱的' .. itemName .. '就送给你了,你要好好保管和使用。'
        -- 特殊传家宝文本对话
        -- 包子
        if (uiRoleTypeID == 1020101004) then
            customStr = '汪！汪汪！'
        end
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false, uiRoleTypeID, customStr)
    end
end


function RandomRollUI:UpdateIcon(objIconItem, typeid)
    if typeid and typeid ~= 0 then
        self.ItemIconUI:setEmpty(objIconItem, false) 
        local itemTypeData, itemData = self:GetDisplayData(typeid)
        if itemData then
            self.ItemIconUI:UpdateUIWithItemInstData(objIconItem, itemData)
        else
            self.ItemIconUI:UpdateUIWithItemTypeData(objIconItem, itemTypeData)
        end

        if itemTypeData == nil then
            if self.eInteractType == NPCIT_STEAL_GIFT or self.eInteractType == NPCIT_CONSULT_GIFT then
                itemTypeData = self:GetDisplayData(803)
                self.ItemIconUI:UpdateItemIcon(objIconItem, itemTypeData)
            end
        end
        local objNum = self:FindChild(objIconItem, "Num")
        objNum:SetActive(false)
    else
        self.ItemIconUI:setEmpty(objIconItem, true)
    end

    local objHeirloom = self:FindChild(objIconItem, "Heirloom")
    local objLight = self:FindChild(objIconItem, "Lighteffet")
    if objLight.activeSelf == true and objHeirloom.activeSelf == false then
        self.treasureCount = self.treasureCount - 1
    end
    objLight:SetActive(objHeirloom.activeSelf)

    local objLock = self:FindChild(objIconItem, "Lock")
    if objLock then
        objLock:SetActive(false)
    end
end

function RandomRollUI:IsTreasure(itemTypeID)   
    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
    if not itemTypeData then 
        return 
    end

    if (itemTypeData.PersonalTreasure ~= 0)
    or (itemTypeData.ClanTreasure ~= 0)
    or (itemTypeData.NoneTreasure == TBoolean.BOOL_YES) then
        return true
    end
end

function RandomRollUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
    -- 开启Toast秘钥模式
    SystemUICall:GetInstance():SetKeyModel("RANDOMROLL")
end

function RandomRollUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
    -- 关闭Toast秘钥模式
    SystemUICall:GetInstance():CloseKeyModel()
end

return RandomRollUI