AdvLootUI = class("AdvLootUI", BaseWindow)

local RANK_ANI = {
    -- [0] = nil,          -- RT_RankTypeNull
    -- [1] = "",           -- RT_White
       [2] = "animation6", -- RT_Green
       [3] = "animation5", -- RT_Blue
       [4] = "animation4", -- RT_Purple
       [5] = "animation3", -- RT_Orange
       [6] = "animation2", -- RT_Golden
       [7] = "animation1", -- RT_DarkGolden
       [8] = "animation1", -- RT_MultiColor
       [9] = "animation1", -- RT_ThirdGearDarkGolden
}

function AdvLootUI:ctor()
    self.array_AdvlootObj = {}
end

function AdvLootUI:Create(kParent)
    local obj = LoadPrefabAndInit("Game/adv_loot",kParent,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function AdvLootUI:Init()
    self:InitNode()
    self:InitEventListener()
end

function AdvLootUI:InitNode()
    self._gameObject:SetActive(true)
    self.Icon =  self:FindChildComponent(self._gameObject, "icon", "Image")
    self.objEffect = self:FindChild(self._gameObject,"spine_rank")
    self.comButton = self._gameObject.transform:GetComponent('Button')
    self.comNameText = self:FindChildComponent(self._gameObject, "Name", "Text")
    self.comRectTran = self._gameObject:GetComponent('RectTransform')
    self.objTrail_Effect = self:FindChild(self._gameObject,"ef_goods_glow1")
        self.trailEffect1 = self.objTrail_Effect:GetComponent("TrailRenderer")
        self.trailEffect2 = self:FindChildComponent(self.objTrail_Effect,"wenli","TrailRenderer")
    -- self.ParticleSystem = self.objTrail_Effect:GetComponent("ParticleSystem")
    self.objTrail_Effect:SetActive(true)
    self.comCanvas = self._gameObject:GetComponent("Canvas")
    self.comCanvasGroup = self._gameObject:GetComponent('CanvasGroup')

    self.comCanvas.sortingOrder = Maze_OrderinLayer["DynamicADVLOOT"]
    self:ClearTrailRenderer()

    --使用UGUI的eventTrigger检测
    self.eventTrigger = self._gameObject:GetComponent("EventTrigger")
	if self.eventTrigger then
        local callBack = function(eventData)
            if CS.UnityEngine.Input.GetButton("MouseLeftButton") then
                self:PickUp()
            end
        end
        --鼠标左键按下拾取物品
        local clickDownEntry = DRCSRef.EventTrigger.Entry()
        clickDownEntry.eventID = DRCSRef.EventTriggerType.PointerDown
        clickDownEntry.callback:AddListener(callBack)
        self.eventTrigger.triggers:Add(clickDownEntry)
        --鼠标左键按住滑动拾取物品
        local entry = DRCSRef.EventTrigger.Entry()
        entry.eventID = DRCSRef.EventTriggerType.PointerEnter
        entry.callback:AddListener(callBack)
        self.eventTrigger.triggers:Add(entry)
    end

end

function AdvLootUI:PickUp()
    self.comButton.interactable = false
    self:PickUpAdvLootAnim(self.uiSiteType, self.uiLootType, self.uiID)
end

function AdvLootUI:RemoveAdvLoot()
    if self.deleteFunc then
        self.isMazeLoot = false
        self:deleteFunc()
    end
    
    self.uiID = nil
end

function AdvLootUI:InitEventListener()
    self:AddEventListener("UPDATE_CURRENT_MAP_ADVLOOT", function(data)
        --DRCSRef.Log("收到事件"..data.uiID)
        if self.uiID and data and data.uiID == self.uiID and data.siteType == self.uiSiteType then
            if data.uiNum and data.uiNum <= 0 then
                self:RemoveAdvLoot()
            end
        end
    end, nil, nil, nil, true)
end

function AdvLootUI:OnDestroy()
    if self.comButton ~= nil then
        self:RemoveButtonClickListener(self.comButton)
    end
end

function AdvLootUI:ResetAnchor()
    if self.comButton then
        self.comButton.interactable = true
    end

    if  self.comRectTran then
        self.comRectTran.pivot = DRCSRef.Vec2(0.5, 0.5)
        self.comRectTran.anchorMin  = DRCSRef.Vec2Zero
        self.comRectTran.anchorMax = DRCSRef.Vec2Zero
    end

    if self.Tween then
        self.Tween:Pause()
    end
end

function AdvLootUI:StopBezierTwn()
    if self.twn_Bezier then
        self.twn_Bezier:Pause()
    end
end

function AdvLootUI:ResetEffect()
    self:ClearTrailRenderer()
    self.objEffect.gameObject:SetActive(false)
    self._gameObject:SetActive(true)
    if self.comCollisionItem then
        self.comCollisionItem.isTriggerEnter = false
    end
end

function AdvLootUI:SetCanvasLayer(iLayer)
    if self.comCanvas then
        self.comCanvas.sortingOrder = iLayer
    end
end

function AdvLootUI:GetPos(uiID, eType)
    local Lootpx,Lootpy,isFirstUpdate = 0,0,false
    if uiID == nil or eType == nil then
        return Lootpx,Lootpy
    end

    if eType == ADVLOOT_SITE.ADV_CITY then
         Lootpx, Lootpy = AdvLootManager:GetInstance():GetPos(uiID)
    elseif eType == ADVLOOT_SITE.ADV_CITY_DYNAC then
        Lootpx, Lootpy, isFirstUpdate = AdvLootManager:GetInstance():GetPos(uiID, ADVLOOT_SITE.ADV_CITY_DYNAC)
    end
    
    return Lootpx, Lootpy, isFirstUpdate
end

function AdvLootUI:SetAdvlootUIData(uiSiteType, uiID, uiLootType, deleteFunc)
    self.uiID = uiID
    self.uiSiteType = uiSiteType
    self.uiLootType = uiLootType
    self.deleteFunc = deleteFunc
end

function AdvLootUI:UpdateMapAdvLoot(uiID, buildAdvLootBaseID, mapID, deleteFunc)
    self:ResetEffect()
    self:ResetAnchor()
    self:StopBezierTwn()
    self._gameObject.name = 'ADVLOOT_' .. buildAdvLootBaseID
    self:SetCanvasLayer(Maze_TeammatesOrderinLayer[0] + 5)
    local Lootpx,Lootpy  = AdvLootManager:GetInstance():GetPos(uiID)
    local _buildingAdvLoot = TableDataManager:GetInstance():GetTableData("BuildingAdvLoot", buildAdvLootBaseID)
    local advLootBaseID,itemType = 0,0
    if _buildingAdvLoot ~= nil then
        Lootpx = _buildingAdvLoot.Lootpx
        Lootpy = _buildingAdvLoot.Lootpy
        advLootBaseID = _buildingAdvLoot.AdvLootID
        local advlootData = TableDataManager:GetInstance():GetTableData("AdvLoot", advLootBaseID)
        if advlootData ~= nil then
            if self.Icon ~= nil then
                self.Icon.sprite = GetAtlasSprite("CommonAtlas", advlootData.Icon)
            end
            itemType = advlootData.Type
        end
    end
    
    self:UpdateAdvLootName(advLootBaseID, nil, nil, uiID)
    self:SetAnchoredPos(Lootpx, Lootpy)
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_CITY, uiID, itemType ,deleteFunc)
end

-- 决斗掉落
function AdvLootUI:UpdateDynacMapLoot(mapID, uiID, ItemID, deleteFunc)
    self:StopBezierTwn()
    self:ResetEffect()
    self:ResetAnchor()
    self:SetCanvasLayer(Maze_TeammatesOrderinLayer[0] + 5)
    local itemBaseID = ItemDataManager:GetInstance():GetItemTypeID(ItemID)
    self._gameObject.name = 'ADVLOOT_' .. itemBaseID
    self:DynamicAdvloot_RankAnim(itemBaseID)

    local Lootpx, Lootpy, isFirstUpdate = AdvLootManager:GetInstance():GetPos(uiID, ADVLOOT_SITE.ADV_CITY_DYNAC, mapID)
    local advLootPos = DRCSRef.Vec3(Lootpx, Lootpy, 0)
    if isFirstUpdate then 
        self:SetAnchoredPos(125, 80)
        self:Move_Bezier(advLootPos)
    else
        self:SetAnchoredPos(Lootpx, Lootpy)
    end

    -- 防止出错 先赋值数据一遍
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_CITY_DYNAC, uiID, ItemTypeDetail.ItemType_Consume, deleteFunc)

    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item", itemBaseID)
    if  itemTypeData == nil then
        return
    end

    local itemType = itemTypeData.ItemType
    local typedata = TableDataManager:GetInstance():GetTableData("ItemType", itemType)
    if  typedata == nil then
        self._gameObject:SetActive(false)
        return
    end
   
    local advTypeID = 0
    advTypeID = AdvLootManager:GetInstance():GetSpecialShowItemAdvType(itemBaseID)

    if not advTypeID then
        advTypeID = typedata.AdvType
        if advTypeID == nil or advTypeID > 24 then 
            return
        end
    end
    local advLootTypeData = TableDataManager:GetInstance():GetTableData("AdvLootTypeTable", advTypeID)
    if advLootTypeData == nil then
        return
    end

    if self.Icon ~= nil then
        self.Icon.sprite = GetAtlasSprite("CommonAtlas",advLootTypeData.Icon)
    end

    self:UpdateAdvLootName(nil, itemBaseID, nil, uiID)
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_CITY_DYNAC, uiID, itemType ,deleteFunc)
end

function AdvLootUI:UpdateCustomAdvLoot(customAdvLoot, deleteFunc)
    if customAdvLoot == nil then 
        return
    end
    self:ResetEffect()
    self:ResetAnchor()
    self:StopBezierTwn()
    local taskEventID = customAdvLoot.taskEventID 
    self._gameObject.name = 'CUSTOM_ADVLOOT_' .. taskEventID
    self:SetCanvasLayer(Maze_TeammatesOrderinLayer[0] + 5)
    local posX = customAdvLoot.x
    local posY = customAdvLoot.y
    self.comNameText.text = customAdvLoot.name or ''
    self.Icon.sprite = GetAtlasSprite("CommonAtlas", customAdvLoot.icon)
    self:SetAnchoredPos(posX, posY)
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_CUSTOM, taskEventID, 0 ,deleteFunc)
end

function AdvLootUI:UpdateMazeAdvlootData(objGrid, uiID, mazeAdvLootSetID, deleteFunc)
    self:ResetEffect()
    self:ResetAnchor()
    self:StopBezierTwn()
    local root = self:FindChild(objGrid,"adv_loot_Root")
    self._gameObject.transform:SetParent(root.transform)
    self._gameObject.transform.localScale = DRCSRef.Vec3One
    self:ClearTrailRenderer()
    self.Lootpx,self.Lootpy = AdvLootManager:GetInstance():GetPos(uiID,ADVLOOT_SITE.ADV_MAZE,0)
    self:SetAnchoredPos(self.Lootpx, self.Lootpy)
    self._gameObject.name = 'ADVLOOT_' .. mazeAdvLootSetID
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_MAZE, uiID, ItemTypeDetail.ItemType_Consume, deleteFunc)

    local MazeAdvLootSetting = TableDataManager:GetInstance():GetTableData("MazeAdvLootSetting",mazeAdvLootSetID)
    if MazeAdvLootSetting == nil then
        self._gameObject:SetActive(false)
        return
    end

    local advLootTypeTableData = self:GetTypeTableData(MazeAdvLootSetting.AdvLootType)
    local itemBaseID = MazeAdvLootSetting.ItemID
    if advLootTypeTableData and self.Icon then
        self.Icon.sprite = GetAtlasSprite("CommonAtlas",advLootTypeTableData.Icon)
    end

    self:UpdateAdvLootName(nil, itemBaseID, nil, uiID)
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_MAZE, uiID, MazeAdvLootSetting.AdvLootType ,deleteFunc)
    self:DynamicAdvloot_RankAnim(itemBaseID)
end

-- 宝箱掉落
function AdvLootUI:UpdateDynamicAdvLoot(objGrid, uiID, uiDynamicAdvLootID,mazeGridID, deleteFunc)
    -- 1.爆开方式：随机找一个掉落点，自己模拟抛物线去掉落
    -- 2.爆开区域：额外加一层“宝箱掉落区域”层
    -- 3.爆开时间：搞一个队列，一个个出（要再调整，不能把流程弄得很拖）
    -- 4. 切西瓜 *
    self:ResetEffect()
    self:ResetAnchor()
    self:StopBezierTwn()
    local root = self:FindChild(objGrid,"adv_loot_Root")
    self._gameObject.transform:SetParent(root.transform)
    self._gameObject.transform.localScale = DRCSRef.Vec3One
    self._gameObject.name = 'DYNAMICADVLOOT_'..uiDynamicAdvLootID
    self:ClearTrailRenderer()
    local Lootpx, Lootpy, isFirstUpdate = AdvLootManager:GetInstance():GetMazeDynamicAdvLootPos(mazeGridID, uiID)

    local advLootPos = DRCSRef.Vec3(Lootpx, Lootpy, 0)
    if isFirstUpdate then 
        self:SetAnchoredPos(0, -140)
        self:Move_Bezier(advLootPos)
    else
        self:SetAnchoredPos(Lootpx, Lootpy)
    end

    local dynamicAdvLootData = AdvLootManager:GetInstance():GetMazeAdvlootDataByID(mazeGridID, uiID)
    local itemBaseID = 0
    local uiAdvLootType = 0
    if dynamicAdvLootData then
        local itemID = dynamicAdvLootData.uiAdvLootID
        itemBaseID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
        uiAdvLootType = dynamicAdvLootData.uiAdvLootType
        local advLootTypeTableData = self:GetTypeTableData(dynamicAdvLootData.uiAdvLootType)
        if advLootTypeTableData and self.Icon then
            self.Icon.sprite = GetAtlasSprite("CommonAtlas",advLootTypeTableData.Icon)
        end
        self:DynamicAdvloot_RankAnim(itemBaseID)
    else
        local advLootTypeTableData = self:GetTypeTableData(AdvLootType.ALT_ZAWU)
        if advLootTypeTableData and self.Icon then
            self.Icon.sprite = GetAtlasSprite("CommonAtlas",advLootTypeTableData.Icon)
        end
    end

    self:UpdateAdvLootName(nil, itemBaseID, nil, uiID)
    self:SetAdvlootUIData(ADVLOOT_SITE.ADV_MAZEGRID, uiID, uiAdvLootType ,deleteFunc)
end

function AdvLootUI:UpdateAdvLootName(advLootBaseID, itemBaseID, itemID, advLootID)
    if self.comNameText == nil then
        return
    end
    local name = AdvLootManager:GetInstance():GetSpecialShowItemName(itemBaseID)

    if not name then
        if type(itemBaseID) == 'number' or type(itemID) == 'number' then
            local itemName = ItemDataManager:GetInstance():GetItemName(itemID, itemBaseID)
            name = itemName or ''
        elseif type(advLootBaseID) == 'number' then
            local advLootBaseData = TableDataManager:GetInstance():GetTableData("AdvLoot",advLootBaseID)
            if advLootBaseData ~= nil then
                local advLootName = GetLanguageByID(advLootBaseData.NameID)
                name = advLootName or '' 
            end
        end
    end
    if DEBUG_MODE then 
        name = name .. '(' .. tostring(advLootID) .. ')'
    end
    self.comNameText.text = name
end

function AdvLootUI:SetAnchoredPos(Lootpx,Lootpy)
    self:ResetAnchor()

    if IsValidObj(self.comRectTran) then
        self.comRectTran:SetTransAnchoredPosition(Lootpx, Lootpy)
    end
    self:ClearTrailRenderer()
end

function AdvLootUI:SetMoveDelayTime(fTimer)
    self.delayTimer = fTimer
end

function AdvLootUI:GetMoveDelayTime()
    self.delayTimer = self.delayTimer or 0
    return self.delayTimer 
end

function AdvLootUI:Move_Bezier(targetPos)
    self:ResetAnchor()

    if targetPos == nil then
        if endfunc then
            endfunc()    
        end
    end
    local localPos = self.comRectTran.transform.localPosition
    -- self.ParticleSystem:Play()

    local OnComplete = function()  
        self:ClearTrailRenderer()
        if endfunc then
            endfunc()    
        end
    end
    local fDelayTimer = self:GetMoveDelayTime()
    local fDiff = math.random(100,500)
    local count = math.random(10,50)

    local fmoveTimer = 0.2 + (fDiff - 100) / 400 * 0.3
    DRCSRef.Log(fmoveTimer)
    --按bezier曲线路径移动
    --com 组件
    --beginPos 起始点
    --endPos 结束点
    --diff 曲线的幅度值
    --pointNum 曲线上样点个数
    --fDuration 移动总时间
    --seEase 速度样式
    --onComplete 移动结束回调
    self.twn_Bezier = Twn_Bezier(self.comRectTran,localPos,targetPos,fDiff,OnComplete,count,fmoveTimer,DRCSRef.Ease.Linear,fDelayTimer)
end

function AdvLootUI:DynamicAdvloot_MoveAnim(advLootPos)
    self:ResetAnchor()
    local vec2 = DRCSRef.Vec2(advLootPos.x, advLootPos.y)
    self.Tween = self.comRectTran.transform:DR_DOAnchoredMove(MazeDynamicAdvLootAnimDeltaTime, vec2, self:GetMoveDelayTime())
    self.Tween:OnComplete(function()  
        self:ClearTrailRenderer() end)
end

function AdvLootUI:PickUpAdvLootAnim(siteType, advLootType, uiID)
    if self.isPicked then 
        return
    end
    local uiMID = uiID
    self.isPicked = true
    if siteType == ADVLOOT_SITE_TYPE.ADVLOOT_SITE_MAP then 
        uiMID = MapDataManager:GetInstance():GetCurMapID()
    end
    -- 铜币特殊处理
    if advLootType == AdvLootType.ALT_TONGBI then
        self._gameObject:SetActive(false)
        self.isPicked = false
        AdvLootManager:GetInstance():PickUpAdvLoot(siteType, uiMID, uiID, uiID, uiID)
    else
        self:DynamicAdvloot_PickAnim(self.comRectTran,
        function()
            AdvLootManager:GetInstance():PickUpAdvLoot(siteType, uiMID, uiID, uiID, uiID)
            self._gameObject:SetActive(false)
            self.isPicked = false
        end)
    end
end

function AdvLootUI:DynamicAdvloot_RankAnim(itemBaseID)
    if type(itemBaseID) == 'number' then
        local typeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemBaseID)
        if typeData then
            local rank = AdvLootManager:GetInstance():GetSpecialShowItemRank(itemBaseID)
            if not rank then
                rank = typeData.Rank 
            end

            if self.objEffect then
                local comEffect = self.objEffect:GetComponent("SkeletonGraphic")
                self.objEffect:SetActive(true)
                if comEffect.AnimationState and RANK_ANI[rank] ~= nil then
                    comEffect.AnimationState:SetAnimation(0, RANK_ANI[rank], true)
                else
                    self.objEffect:SetActive(false)
                end
            end
        end
    end
end

function AdvLootUI:DynamicAdvloot_PickAnim(comRectTran,endfunc)
    self:ResetAnchor()

    local targetPos = AdvLootManager:GetInstance():GetBackpagPosition(comRectTran.transform.parent)
    if targetPos == nil then
        if endfunc then
            endfunc()    
        end
    end
    local localPos = comRectTran.transform.localPosition
    local OnComplete = function()  
        self:ClearTrailRenderer()
        if endfunc then
            endfunc()    
        end
    end
    Twn_Bezier(comRectTran,localPos,targetPos,240,OnComplete,30,0.6,DRCSRef.Ease.InQuart)
end

function AdvLootUI:GetTypeTableData(baseenum)
    return TableDataManager:GetInstance():GetTableData("AdvLootTypeTable",baseenum)
end

function AdvLootUI:OnTriggerEnter(collider, uiID)
    if self.fun_Btn ~= nil then
        self.fun_Btn()
    end
end

function AdvLootUI:ClearTrailRenderer()
    if IsValidObj(self.trailEffect1) then
        self.trailEffect1:Clear()
    end

    if IsValidObj(self.trailEffect2) then
        self.trailEffect2:Clear()
    end
end

return AdvLootUI