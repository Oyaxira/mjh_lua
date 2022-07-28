MazeGridUI = class("MazeGridUI",BaseWindow)
local CityRoleUI = require 'UI/MapUI/CityRoleUI'
local AdvLootUI = require 'UI/MazeUI/AdvLootUI'

function MazeGridUI:ctor()
    self.AdvlootList = {}
end

function MazeGridUI:Create()
    
end

function MazeGridUI:Init(objGrid)
    self.objGrid = objGrid
    self.mazeDataManagerInstance = MazeDataManager:GetInstance()
    self:InitNode()
end

function MazeGridUI:InitEventListener()
end

function MazeGridUI:OnEnable()
end

function MazeGridUI:OnDisnpcable()
end

function MazeGridUI:OnDestroy()    
    self:ResetAdvloot()
    if self.cityRole then
        self.cityRole:Close()
    end
end

function MazeGridUI:InitNode()
    self.comTitleText = self:FindChildComponent(self.objGrid, "CardName", "Text")
    self.comBgImage = self:FindChildComponent(self.objGrid, 'Mask/BG', 'Image')
    self.comGridWindowImage = self:FindChildComponent(self.objGrid, "CardFrame", "Image")
    self.objRole = self:FindChild(self.objGrid, 'Role')
    self.cityRole = CityRoleUI.new()
    -- self.cityRole:SetGameObject(self.objRole)
    self.cityRole:SetDefaultScale(MAZE_SPINE_SCALE)
    self.comRoleTransform = self.objRole.transform
    self.comGridMarkImage = self:FindChildComponent(self.objGrid, 'TaskMark', 'Image')
    self.comUIAction = self.objGrid:GetComponent('LuaUIAction')
    self.objLockSpineRoot = self:FindChild(self.objGrid, 'LockSpine')
    self.comEscapeEff = self:FindChildComponent(self.objGrid, 'RoleEscapeEffect', 'ParticleSystem')
    self.comCanvasGroup = self.objGrid:GetComponent('CanvasGroup')
    self.comFrontMaskCanvasGroup = self:FindChildComponent(self.objGrid, 'Mask_Front', 'CanvasGroup')
    self.objGround = self:FindChild(self.objGrid, 'Mask_back')
    self.objMoveTip = self:FindChild(self.objGrid, 'MoveTip')
    self:AddEventListener("CLEAR_CURRENT_MAZE_ADVLOOT", function(mazeGridID)
        self:ResetAdvloot()
	end)
end

function MazeGridUI:GetFrontMaskAlpha()
    return self.comFrontMaskCanvasGroup.alpha
end

function MazeGridUI:GetCanvasGroupAlpha()
    return self.comCanvasGroup.alpha
end

function MazeGridUI:UpdateGridData(row, column)
    self.row = self.mazeDataManagerInstance:FormatRow(self.mazeID, self.areaIndex, row)
    self.column = column
    self.gridData = self.mazeDataManagerInstance:GetCurAreaMazeGridData(self.row, self.column)
    self.mazeID = self.mazeDataManagerInstance:GetCurMazeID() or 0
    self.areaIndex = self.mazeDataManagerInstance:GetCurAreaIndex() or 0
    self.mazeTypeID = self.mazeDataManagerInstance:GetCurMazeTypeID()
    self.areaTypeID = self.mazeDataManagerInstance:GetCurMazeAreaTypeID()
    self.cardData = self.mazeDataManagerInstance:GetCurAreaMazeCardData(self.row, self.column)
end

function MazeGridUI:UpdateGridUI(canInteract)
    -- TODO: 迷宫格会变, 需要更新
    self.comFrontMaskCanvasGroup.alpha = 0
    self.gridData = self.mazeDataManagerInstance:GetCurAreaMazeGridData(self.row, self.column)
    self.canInteract = canInteract
    if self.gridData == nil then 
        self:ResetAdvloot()
        self.objGrid:SetActive(false)
        return 
    end

    if self.uiID == nil or self.uiID ~= self.gridData.uiID then
        self.uiID = self.gridData.uiID
        self:ResetAdvloot()
	end
  
    if self.gridData.eFirstType == MazeCardFirstType.MCFT_EMPTY then 
        self.objGrid.gameObject:SetActive(false)
        return
    end
    self.cardData = self.mazeDataManagerInstance:GetCurAreaMazeCardData(self.row, self.column)
    if self.cardData == nil then 
        self.objGrid.gameObject:SetActive(false)
        return
    end
    self.objGrid.gameObject:SetActive(true)
    
    if self.canInteract then 
        self.comFrontMaskCanvasGroup.alpha = 0
    else
        self.comFrontMaskCanvasGroup.alpha = 0.6
    end
    self:UpdateGridFrame()
    self:UpdateCard()
    self:UpdateRole()
    self:UpdateTaskMark()
    self:UpdateEventTrigger()
    self:UpdateMazeAdvLoot()
    self:UpdateLockSpine()
end

function MazeGridUI:CanGridShow()
    if self.gridData == nil then 
        return false
    end
    if self.gridData == nil or self.gridData.eFirstType == MazeCardFirstType.MCFT_NULL or self.gridData.eFirstType == MazeCardFirstType.MCFT_EMPTY or self.gridData.eFirstType == MazeCardFirstType.MCFT_END then 
        return false
    end
    if self.cardData == nil then 
        return false
    end
    return true
end

function MazeGridUI:UpdateGridFrame()
    local firstType
    if self.gridData.bHasTriggered ~= 0 and self.mazeDataManagerInstance:IsTriggerHideGrid(self.gridData) then 
        firstType = MazeCardFirstType.MCFT_ROAD
    elseif self.mazeDataManagerInstance:GetCurAreaEventRole(self.row, self.column) ~= 0 then
        firstType = MazeCardFirstType.MCFT_TASK
    else
        firstType = self.gridData.eFirstType
    end
    local imagePath = MazeGridFrameTypeImgDict[firstType] or MazeGridFrameTypeImgDict[MazeCardFirstType.MCFT_ROAD]
    if self.comGridWindowImage ~= nil and imagePath ~= nil then 
        local frameSprite = GetAtlasSprite("MazeCardAtlas",imagePath)
        if (frameSprite ~= nil) then
            self.comGridWindowImage.sprite = frameSprite
        end
        if frameSprite == nil then 
            derror('迷宫格边框UI图片丢失, 请联系策划检查图片资源: ' .. tostring(firstType) .. '  ' .. imagePath)
        end
    elseif imagePath == nil then
        derror('无法找到迷宫格边框UI图片配置, 请联系策划检查配置: ' .. tostring(firstType))
    end
end

function MazeGridUI:UpdateCard()
    self:UpdateCardName()
    self:UpdateCardBG()
end

function MazeGridUI:UpdateCardName()
    local cardName = '无'
    if self.cardData  then 
        local nameID = self.cardData.NameID
        cardName = GetLanguageByID(nameID, self.cardData.TaskID)
    end
    if self.comTitleText then
        self.comTitleText.text = cardName
    end
    -- comTitleText.text = cardName .. ' (' .. self:GetGridTypeName(row, column) .. ')'
end

function MazeGridUI:UpdateCardBG()
    if self.cardData == nil then
        return
    end
    local cardArtData = self.mazeDataManagerInstance:GetCardArtData(self.cardData.BaseID)
    if cardArtData == nil then 
        return
    end
    local cardBgPath = cardArtData.CardBG
    local cardBgSprite = GetSprite(cardBgPath)
    if self.comBgImage ~= nil and cardBgSprite ~= nil then 
        self.comBgImage.sprite = cardBgSprite
    end
end

function MazeGridUI:SetRoleActive(isShow)
    if self.objRole == nil then 
        dprint(self.objGrid.gameObject.name)
        return
    end
    local roleSpineAlpha = 0
    if isShow then 
        roleSpineAlpha = 1
    end
    self.objGround:SetActive(isShow)    
    self.cityRole:SetActive(isShow)

    if self.objRoleSpine ~= nil then 
        changeShapsAlpha(self.objRoleSpine, roleSpineAlpha)
    end
end

function MazeGridUI:ClearRoleData()
    self.cardEventRoleID = nil
    self.cardRoleID = nil
end

function MazeGridUI:UpdateRole()
    local mazeUI = GetUIWindow('MazeUI')
    if mazeUI == nil then 
        return
    end
    local index_rootName = self.objGrid.transform.parent.gameObject.name
    local eventRoleID = self.mazeDataManagerInstance:GetCurAreaEventRole(self.row, self.column)
    local canShowRole = self:CanShowRole(eventRoleID)
    local bForceShowMoveTips = false
    if canShowRole and self.objRoleSpine == nil then 
        self.objChild,self.objRoleSpine = mazeUI:GetRoleSpineFromPool(self.comRoleTransform)
        self.cityRole:SetGameObject(self.objChild)
        self.cityRole:SetSpine(self.objRoleSpine)
        self.cityRole:ResetPerfabWeapon(self.objRoleSpine)

        self.cityRole:SetActive(true)
        self.comRoleMarkImage = self:FindChildComponent(self.objChild, 'head_Node/scale/role_mark', 'Image')
    elseif not canShowRole then
        self:ClearRoleData()
        self:SetRoleActive(false)
        self.objMoveTip:SetActive(self.canInteract)
        return
    end
    if self.cardData == nil then
        canShowRole = false
    elseif eventRoleID ~= 0 then
        self.cityRole:SetRoleDataByUID(eventRoleID)
        self.cityRole:UpdateCityRole()
        self.cityRole:SetSortingOrder(Maze_OrderinLayer[tostring(index_rootName)] + 1)
        self.cardRoleID = nil
    elseif self.cardData.RoleID ~= nil and self.cardData.RoleID ~= 0 then 
        if self.cardRoleID ~= self.cardData.RoleID then 
            self.cardRoleID = self.cardData.RoleID
            self.cityRole:SetRoleDataByBaseID(self.cardRoleID)
            self.cityRole:UpdateCityRole()
            self.cityRole:SetSortingOrder(Maze_OrderinLayer[tostring(index_rootName)] + 1)
        end
    elseif self:IsCardItemAvaliable(self.cardData.CardItem) then
        local nameID = self.cardData.CardItem.NameID
        local modelID = self.cardData.CardItem.ModelID
        local AnimationName
        local firstType = self.gridData.eFirstType
        local hasTriggered = self.gridData.bHasTriggered
        local isLoop = false
        if firstType == MazeCardFirstType.MCFT_TREASURE and hasTriggered ~= 0 then
            bForceShowMoveTips = true
            AnimationName = SPINE_ANIMATION.BOX_DISAPPEAR
        else
            AnimationName = AnimEnumNameMap[SpineAnimType.SPT_IDLE]
            isLoop = true
        end
        local customData = {NameID = nameID, ArtID = modelID, AnimationName = AnimationName}
        self.cityRole:UpdateCityRoleByCustomData(customData)
        self.cityRole:SetAction(AnimationName,isLoop)
        self.cityRole:SetSortingOrder(Maze_OrderinLayer[tostring(index_rootName)] + 1)
        self.cityRole:ResetPerfabWeapon()
        self.cardRoleID = nil
    else
        canShowRole = false
    end
    self:SetRoleActive(canShowRole and self.canInteract)
    self.objMoveTip:SetActive(bForceShowMoveTips or ((not canShowRole) and self.canInteract))
    self.cityRole:SetNameTextSize(24)   --因为cityUI和mazeUI共用了cityRoleUI,并且两边名字的字号要求不同
end

function MazeGridUI:CanShowRole(eventRoleID)
    local canShowRole = false
    if self.cardData == nil then
        canShowRole = false
    elseif eventRoleID ~= nil and eventRoleID ~= 0 then
        canShowRole = true
    elseif self.cardData.RoleID ~= nil and self.cardData.RoleID ~= 0 then 
        canShowRole = true
    elseif self:IsCardItemAvaliable(self.cardData.CardItem) then
        canShowRole = true
    else
        canShowRole = false
    end
    return canShowRole
end

function MazeGridUI:IsCardItemAvaliable(cardItem)
    return cardItem ~= nil and cardItem.NameID ~= 0 and cardItem.ModelID ~= 0
end

function MazeGridUI:GetGridTypeName(row, column)
    if not self.gridData then 
        return ''
    end
    for name, value in pairs(MazeCardFirstType_Revert) do 
        if value == self.gridData.eFirstType then 
            if self.gridData.eFirstType == MazeCardFirstType.MCFT_TREASURE and self.gridData.bHasTriggered ~= 0 then 
                return '宝箱(开)'
            end
            return name
        end
    end
    return ''
end

function MazeGridUI:UpdateEventTrigger()
    local mazeUI = GetUIWindow('MazeUI')
    local uiCurPosRow,uiCurPosColumn = self.mazeDataManagerInstance:GetCurPos()
    local PointerClickCallback = function(obj, eventData) 
        if self and next(self) then
            self:OnPointerClick(obj, eventData)
        end
    end
    if not (self.objGrid and self.row and self.column and self.canInteract) then 
        self.comUIAction:SetPointerClickAction(nil)
		return 
	end

	if self.comUIAction == nil then
		return
    end
    
    if self.row == uiCurPosRow % mazeUI.totalRow + 1 then
        if self.column ==  uiCurPosColumn - 1 then 
            mazeUI.pressNumCallback[1]=PointerClickCallback
        elseif self.column == uiCurPosColumn then 
            mazeUI.pressNumCallback[2]=PointerClickCallback
        elseif self.column == uiCurPosColumn + 1 then 
            mazeUI.pressNumCallback[3]=PointerClickCallback
        end
    end
	self.comUIAction:SetPointerClickAction(PointerClickCallback)
end

function MazeGridUI:OnPointerClick(objGrid, eventData)
    -- 等待下行时不允许点击
    if g_isWaitingDisplayMsg then 
        return
    end
    -- 当前显示队列没结束不允许点击
    if DisplayActionManager._instance:GetActionListSize() > 0 then 
        return
    end
    -- 掉落没有完全爆出来之前不允许点击
    if g_mazeGridAdvLootUpdateTimer and globalTimer:GetTimer(g_mazeGridAdvLootUpdateTimer) then 
        return
    end
    local mazeUI = GetUIWindow('MazeUI')
    if mazeUI == nil or mazeUI:IsMoving() then 
        return
    end
    if self.cardData==nil then
        return 
    end

    local uiCurPosRow,uiCurPosColumn = self.mazeDataManagerInstance:GetCurPos()
    self.mazeDataManagerInstance:RecordOldPos(uiCurPosRow,uiCurPosColumn)

    -- 点击迷宫卡片的时候, 关闭快进对话模式
	DialogRecordDataManager:GetInstance():SetFastChatState(false)

    local row = self.row
    local column = self.column
    local curMazeID = self.mazeDataManagerInstance:GetCurMazeID()
    local curAreaIndex = self.mazeDataManagerInstance:GetCurAreaIndex()
    local eventRoleID = self.mazeDataManagerInstance:GetCurAreaEventRole(row, column)
    self.mazeDataManagerInstance:SetCurClickInfo(curMazeID, curAreaIndex, row, column)
    local lockGiftType = self.mazeDataManagerInstance:GetCurAreaMazeCardLockGiftType(row, column)
    local isUnlock = self.mazeDataManagerInstance:IsCurAreaGridUnlock(row, column)
    if (isUnlock or lockGiftType == nil or lockGiftType == 0) and eventRoleID ~= 0 then
        -- 事件角色交互逻辑
        local selectInfo = self:GetSelectInfo(row, column)
        local funClick = function ()
            -- 位置随便给一个不存在的位置
            RoleDataManager:GetInstance():TryInteract(selectInfo.roleID, 100000, selectInfo.mazeTypeID, selectInfo.mazeAreaIndex, selectInfo.mazeRow, selectInfo.mazeColumn, selectInfo.mazeCardBaseID, nil)
        end
        if (self:IsTreasureMazeGrid(selectInfo.mazeCardBaseID)) then
          OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, "藏宝洞穴只能进入一次，确定是否进入？", funClick})
        else
          funClick()
        end
    else
        -- 点击卡片响应逻辑
        local funClick = function ()
          LuaEventDispatcher:dispatchEvent("ANIMATION_UPDATE_MAZE_GRID_DATA")
          SendClickMaze(CMAT_CLICKGRID, row, column)
        end
        local selectInfo = self:GetSelectInfo(row, column)
        if (self:IsTreasureMazeGrid(selectInfo.mazeCardBaseID)) then
          OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, "藏宝洞穴只能进入一次，确定是否进入？", funClick})
        else
          funClick()
        end
    end
end

function MazeGridUI:GetSelectInfo(row, column)
    local curMazeID = self.mazeDataManagerInstance:GetCurMazeID()
    local mazeTypeID = self.mazeDataManagerInstance:GetMazeTypeID(curMazeID)
    local curAreaIndex = self.mazeDataManagerInstance:GetCurAreaIndex()
    local roleID = self.mazeDataManagerInstance:GetCurAreaEventRole(row, column)
    local cardTypeID = self.cardData.BaseID
    return {
        roleID = roleID,
        mazeTypeID = mazeTypeID,   
        mazeAreaIndex = curAreaIndex,
        mazeCardBaseID = cardTypeID,
        mazeRow = row,
        mazeColumn = column
    }
end

function MazeGridUI:IsTreasureMazeGrid(typeid)
  -- 暂时写死，后续应该改成类型判定
  return typeid == 600 or typeid == 601 or typeid == 602 or typeid == 929 or typeid == 2000100012 or typeid == 2000075012 or typeid == 2000075013 or typeid == 2000075014
end

function MazeGridUI:IsSamePosition(row, column)
    return self.row == row and self.column == column
end

function MazeGridUI:PlayRoleAnim(objGrid, animName, isLoop, needRecover)
    --local objRole = self:FindChild(objGrid, 'Role')
    if not self.objRole then 
        return 0
    end
    if needRecover then 
        -- TODO:添加计时器，播放idle
    end
    return self.cityRole:SetAction(animName, isLoop)
end

function MazeGridUI:PlayRoleEscapeAnim(objGrid, dispatchEndEvent)
    if not (self.objRole and self.objRole.activeSelf) then 
        if dispatchEndEvent then 
			DisplayActionEnd()
		end
        return nil
    end
    self.cityRole:SetNameActive(false)
    local pos = self.objRole.transform.localPosition
    local moveTween = self.objRole.transform:DOLocalMoveX(128, MazeEnemyEscapeAnimTime);
    moveTween:SetEase(DRCSRef.Ease.OutQuart)
    moveTween.onComplete = function()
        self.objRole.transform.localPosition = pos
        changeShapsAlpha(self.objRoleSpine, 1)
        self.cityRole:SetNameActive(true)
        if dispatchEndEvent then 
            DisplayActionEnd(self.objRoleSpine, 0, false)
        end
    end
    self:AddTimer((MazeEnemyEscapeAnimTime - MazeEnemyEscapeSpineFadeTime) * 1000, function()
        FadeInOutShaps(self.objRoleSpine, MazeEnemyEscapeSpineFadeTime, true)
	end, 1)
    self.comEscapeEff:Play()
end

function MazeGridUI:ResetAdvloot()
    self.AdvlootList = self.AdvlootList or {}
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.AdvlootList)
    self.AdvlootList = {}
end

function MazeGridUI:Update(deltaTime)
    if self.iUpdateAdvlootFlag then
        if not CanUpdateMazeUI() then 
			return
		end
        self.iUpdateAdvlootFlag = false
        self:UpdateAdvLoot()
    end
end

function MazeGridUI:UpdateAdvLoot()
    self:ResetAdvloot()
    if self.gridData == nil then 
        dprint("[MazeGridUI] gridData is nil")
        return 
    end
    local auiAdvLoots =  AdvLootManager:GetInstance():GetMazeAdvlootList(self.gridData.uiID)
    if auiAdvLoots == nil then
		return
    end
    DRCSRef.Log(string.format( "[MazeGridUI] UpdateAdvLoot ID:%d, gameobject name :%s ,parent name :%s", self.gridData.uiID,self.objGrid.gameObject.name,self.objGrid.transform.parent.name))
    local delayTimer = 0
	for uiID, advLootData in pairs(auiAdvLoots) do
        if advLootData ~= nil and advLootData.uiNum > 0 then
            if advLootData.row == self.row and advLootData.column == self.column then
                if advLootData.uiSiteType == ADVLOOT_SITE.ADV_MAZEGRID then 
                    if AdvLootManager:GetInstance():IsMazeDynamicAdvLootFirstUpdate(uiID) then 
                        g_mazeGridAdvLootUpdateTimer = globalTimer:AddTimer(delayTimer, function()
                            self:AddNewAdvLoot(uiID, advLootData, true)
                        end)
                        delayTimer = delayTimer + math.random(50, 100)
                    else
                        self:AddNewAdvLoot(uiID, advLootData, true)
                    end
                else
                    self:AddNewAdvLoot(uiID, advLootData, false)
                end
            end
		end
    end
end

function MazeGridUI:AddNewAdvLoot(uiID, advLootData, isDynamicAdvLoot)
    if not self.gridData then 
        return
    end
    self.AdvlootList =  self.AdvlootList or {}
    if self.AdvlootList[uiID] == nil then
        self.AdvlootList[uiID] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.AdvlootUI, self.objGrid.transform)
    end
    local advLootUI = self.AdvlootList[uiID]
    advLootUI.isMazeLoot = true
    local fun_delete = function()
        self.AdvlootList = self.AdvlootList or {}
        local delAdvLootUI = self.AdvlootList[uiID]
        self.AdvlootList[uiID] = nil
        LuaClassFactory:GetInstance():ReturnUIClass(delAdvLootUI)
    end
    
    if isDynamicAdvLoot then
        advLootUI:UpdateDynamicAdvLoot(self.objGrid, advLootData.uiID, advLootData.uiAdvLootID, self.gridData.uiID,fun_delete)
    else
        advLootUI:UpdateMazeAdvlootData(self.objGrid, advLootData.uiID, advLootData.uiAdvLootID,fun_delete) 
    end
end

function MazeGridUI:UpdateMazeAdvLoot()
    if self.iUpdateAdvlootFlag or not self.canInteract then 
        return
    end

    if self.gridData == nil or self.gridData.eFirstType == MazeCardFirstType.MCFT_EMPTY then 
        return
    end

    local auiAdvLoots =  AdvLootManager:GetInstance():GetMazeAdvlootList(self.gridData.uiID)
    if auiAdvLoots == nil then
		return
    end

    self.iUpdateAdvlootFlag = true
end

function MazeGridUI:UpdateLockSpine()
    self:ResetLockSpine()
    if self.mazeDataManagerInstance:IsCurAreaGridUnlock(self.row, self.column) then 
        return 
    end
    local lockGiftType = self.mazeDataManagerInstance:GetCurAreaMazeCardLockGiftType(self.row, self.column)
    if lockGiftType == nil then 
        return
    end
    local objLockSpineParent = self:FindChild(self.objGrid, 'LockSpine/' .. tostring(lockGiftType))
    if objLockSpineParent ~= nil then 
        self.objEnableLockSpine = objLockSpineParent.gameObject
        objLockSpineParent.gameObject:SetActive(self.canInteract)
        if self.canInteract then 
            local objLockSpine = self:FindChild(self.objGrid, 'LockSpine/' .. tostring(lockGiftType) .. '/Spine')
            if objLockSpine then 
                objLockSpine.gameObject:SetActive(true)
            end
        end
    end
end

function MazeGridUI:ResetLockSpine()
    self.objEnableLockSpine = nil
    local childCount = self.objLockSpineRoot.transform.childCount
    for i = 1, childCount do 
        local objLockSpine = self.objLockSpineRoot.transform:GetChild(i - 1)
        if objLockSpine then 
            objLockSpine.gameObject:SetActive(false)
        end
    end
end

function MazeGridUI:PlayUnlockGridAudio(lockGiftType)
    local audioID = nil
    if lockGiftType == AdventureType.AT_JiGuan then 
        audioID = 4018
    elseif lockGiftType == AdventureType.AT_SuiYan then 
        audioID = 4034
    end
    PlaySound(audioID)
end

function MazeGridUI:PlayUnlockGridAnim()
    local lockGiftType = self.mazeDataManagerInstance:GetCurAreaMazeCardLockGiftType(self.row,  self.column)
    local objLockSpine = self:FindChild(self.objGrid, 'LockSpine/' .. tostring(lockGiftType) .. '/Spine')
    if objLockSpine == nil then 
        DisplayActionEnd()
        return
    end

    local comSkeletonGraphic = objLockSpine:GetComponent("SkeletonGraphic")
    if comSkeletonGraphic == nil then 
        DisplayActionEnd()
        return
    end
    if comSkeletonGraphic.AnimationState == nil then
        DisplayActionEnd()
        return 
    end
    self:PlayUnlockGridAudio(lockGiftType)

    -- 动画操作复制出来的 Spine
    objNewLockSpine = CloneObj(objLockSpine, objLockSpine.transform.parent.gameObject)
    objLockSpine.gameObject:SetActive(false)
    comSkeletonGraphic = objNewLockSpine:GetComponent("SkeletonGraphic")
    local trackEntry = comSkeletonGraphic.AnimationState:SetAnimation(0, UNLOCK_GRID_OPEN_ANIM_NAME, false)
    local animationTime = comSkeletonGraphic:GetSkeletonAnimationTime(UNLOCK_GRID_OPEN_ANIM_NAME)
    if trackEntry ~= nil and animationTime > 0 then 
        self:AddTimer(animationTime * 1000, function()
            DRCSRef.ObjDestroy(objNewLockSpine.gameObject)
            DisplayActionEnd()
        end)
    else
        DRCSRef.ObjDestroy(objNewLockSpine.gameObject)
        DisplayActionEnd()
    end
end

function MazeGridUI:IsEmptyGrid()
    return self.gridData == nil or self.gridData.eFirstType == MazeCardFirstType.MCFT_EMPTY
end

function MazeGridUI:UpdateTaskMark()
    if not self.canInteract then
        self.comGridMarkImage.gameObject:SetActive(false)
        return 
    end
	local maxWeightInfo = TaskDataManager:GetInstance():CheckMazeCardMark(self.cardData)
    if maxWeightInfo and maxWeightInfo.state then
        local comMarkImage = self.comGridMarkImage
        if (self.cardData.RoleID ~= nil and self.cardData.RoleID ~= 0) or (self.mazeDataManagerInstance:GetCurAreaEventRole(self.row, self.column) ~= 0) or (self:IsCardItemAvaliable(self.cardData.CardItem)) then 
            -- 有角色模型的显示在角色模型上
            comMarkImage = self.comRoleMarkImage
            self.comGridMarkImage.gameObject:SetActive(false)
        end
        if comMarkImage then 
            comMarkImage.gameObject:SetActive(true)
            local markSprite = GetAtlasSprite("CommonAtlas", maxWeightInfo.state)
            if (markSprite ~= nil) then
                comMarkImage.sprite = markSprite
            end
        -- else
        --     derror("[MazeGridUI]UpdateTaskMark->Cannot find task mark image!")
        end
	else
        self.comGridMarkImage.gameObject:SetActive(false)
        if self.comRoleMarkImage then 
            self.comRoleMarkImage.gameObject:SetActive(false)
        end
	end
end

function MazeGridUI:IsSameGridID(gridID)
    if self.gridData == nil then 
        return false
    end
    return self.gridData.uiID == gridID
end

function MazeGridUI:PlaySpineAlphaAnim(alphaBegin, alphaEnd, deltaTime)
    if self.objRoleSpine ~= nil then 
        FadeInOutShaps(self.objRoleSpine, deltaTime, nil, alphaBegin, alphaEnd)
        if  alphaEnd == 0 then
            self.cityRole:ResetPerfabWeapon(self.objRoleSpine)
        end
    end
    if self.objEnableLockSpine ~= nil then 
        FadeInOutShaps(self.objEnableLockSpine, deltaTime, nil, alphaBegin, alphaEnd)
    end
end

return MazeGridUI
