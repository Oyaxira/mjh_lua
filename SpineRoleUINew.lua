SpineRoleUINew = class("SpineRoleUINew", BaseWindow)
local WeaponUI = require 'UI/Role/WeaponUI'

local WeaponName = "WEAPON"
local l_DRCSRef_Type = DRCSRef_Type
function SpineRoleUINew:ctor(bNeedCanvas,bNeedSortingGroup)
    self.iOldModelID = 0
    if bNeedCanvas == nil then 
        bNeedCanvas = true
    end
    if bNeedSortingGroup == nil then 
        bNeedSortingGroup = true
    end
    self.bNeedCanvas = bNeedCanvas
    self.bNeedSortingGroup = bNeedSortingGroup
end

function SpineRoleUINew:Create()

end

function SpineRoleUINew:SetDefaultScale(int_scale)
    self.defaultScale = int_scale or 1
    
end

function SpineRoleUINew:SetScale(int_scale)
    if self.objSpine_transform then
        self.objSpine_transform.localScale = self.objSpine_transform.localScale * int_scale
    end 
end

function SpineRoleUINew:SetSpine(objSpine,bInitPos)
    if objSpine then
        self.objSpine = objSpine
        self.objSpine_transform = self.objSpine.transform
        if bInitPos == nil then 
            self.objSpine_transform.localPosition = DRCSRef.Vec3Zero
        end
        self.objWeaponNode = self:FindChild(self.objSpine, 'weapon_Node')
        if self.objWeaponNode then
            self.objWeaponNode_transform = self.objWeaponNode.transform
        end
        self.skeletonAnimation = self.objSpine:GetComponent(l_DRCSRef_Type.SkeletonAnimation)
        
        self.skeletonRenderer = self.objSpine_transform:GetComponent(l_DRCSRef_Type.SkeletonRenderer)

        if self.skeletonAnimation then 
            self.skeletonAnimation:ClearState()
        end

        self:ClearItemSpine()
        self:ClearItemPerfab()
        self:ResetBoneFollower()
    end
end



function SpineRoleUINew:GetSkeletonRenderer()
    return self.skeletonRenderer
end
function SpineRoleUINew:SetGameObject(gameObject,objSpine,bInitPos)
    self.gameObject = gameObject
    if gameObject then 
        self.transform = gameObject.transform
        self.SortingGroup = gameObject:GetComponent(l_DRCSRef_Type.SortingGroup);
        if self.SortingGroup == nil and self.bNeedSortingGroup then 
            self.SortingGroup = gameObject:AddComponent(l_DRCSRef_Type.SortingGroup)
        end
        self.cavans = gameObject:GetComponent(l_DRCSRef_Type.Canvas)
        if self.cavans == nil and self.bNeedCanvas then 
            self.cavans = gameObject:AddComponent(l_DRCSRef_Type.Canvas)
            self.cavans.overrideSorting = true

        end
    end
    self:SetSpine(objSpine,bInitPos)
end

function SpineRoleUINew:SetSortingOrder(int_SortingOrder)
	if self.SortingGroup then 
		self.SortingGroup.sortingOrder = int_SortingOrder or 0
    end
    if self.cavans then 
        self.cavans.sortingOrder = (int_SortingOrder or 0) + 6
    end
    if self.bubblePlotUiInst then 
        self.bubblePlotUiInst:SetDepth(int_SortingOrder+6)
    end
end

function SpineRoleUINew:SetRoleDataByUID(roleID)
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if roleData == nil then 
        roleData = RoleDataManager:GetInstance():GetRoleBaseDataByTypeID(roleID)
    end
    return self:SetRoleData(roleData)
end

function SpineRoleUINew:SetRoleDataByBaseID(roleBaseID)
    local roleData = RoleDataManager:GetInstance():GetRoleBaseDataByTypeID(roleBaseID)
    return self:SetRoleData(roleData)
end

function SpineRoleUINew:SetRoleData(baseRole)
    self.scale = DRCSRef.Vec3One
    self.roleData = baseRole
    self.iOldModelID = self.modelID
    if self.roleData.roleType then 
        self.modelID = self.roleData:GetModelID()
    else
        self.modelID = 1
    end
    return true
end

function SpineRoleUINew:OnlySetModelID(modelID)
    if self.modelID == modelID then 
        self:UpdateEquipItemSpine()
        return
    end
    self.iOldModelID = self.modelID
    self.modelID = modelID
    self.roleData = nil
    self:UpdateRoleSpine()
end

function SpineRoleUINew:Init(baseRole,gameObject,objSpine)
    self:SetRoleData(baseRole)
    self:SetGameObject(gameObject,objSpine)
end

function SpineRoleUINew:OnDestroy()
    if self.bubblePlotUiInst then 
        self.bubblePlotUiInst:Clear()
    end
end

function SpineRoleUINew:UpdateRoleSpine()
    self:ResetWeapon()
    self:UpdateBaseSpine()
    self:UpdateEquipItemSpine()
end

function SpineRoleUINew:UpdateBaseSpineByRoleID()
    self:UpdateBaseSpine()
end

function SpineRoleUINew:UpdateBaseSpine()
    if not (IsValidObj(self.objSpine)) or self.objSpine_transform == nil or self.iOldModelID == self.modelID then 
        return
    end
    local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.modelID)
    local spine = nil
    local spineTexture = nil
    if roleModelData ~= nil then 
        spine = roleModelData.Model
        spineTexture = roleModelData.Texture
    end
    if (spine == nil or spine == "")then
        spine = MODEL_DEFAULT_SPINE
    end
    if (spineTexture == nil or spineTexture == "") then
        spineTexture = MODEL_DEFAULT_TEXTURE
    end
    DRCSRef.Log("更新"..spine)

    DynamicChangeSpine(self.objSpine, spine)

    local scale = self:GetRoleScale(roleModelData)
    self.objSpine_transform.localScale = scale * (self.defaultScale or 1)
    
    if spineTexture then 
        self.objSpine_Textrue = ChnageSpineSkin(self.objSpine, spineTexture)
    end
    self.curAnima = nil
end

function SpineRoleUINew:GetAnimInfoByName(animName,modelID,spineActionData)
    local st = string.split( animName, '_' )
    spineaniminfo = {
        ['oldActionName'] = animName,
        ["action"] = st[1],
    }
    if st[2] then 
        spineaniminfo["type"] = SPINE_ATTACK_TYPE_INDEX_Revert[st[2]]
        if st[1] ~= "prepare" then 
            local prepareName = "prepare_" .. st[2]
            if spineActionData then
                if spineActionData["prepareName"] == 0  then
                    prepareName = "prepare"
                end
            elseif getActionFrameTime(modelID,prepareName) == 0 then 
                prepareName = "prepare"
            end
            spineaniminfo['prepare'] = prepareName
        end
        if st[3] then 
            spineaniminfo["num"] = tonumber(st[3])
        end
    end
    return spineaniminfo
end
-- 播放动作之前调用，根据不同的动作将武器挂在不同骨骼上
function SpineRoleUINew:SetEquipItemEX(itemID,uiEnhanceGrade, spineaniminfo)
    local string_name = getAttackAction(self.modelID,spineaniminfo)
    local itemData 
    if itemID then 
        itemData = TableDataManager:GetInstance():GetTableData("Item",itemID)
    end
    if itemData ~= nil then 
        local itemTypeName = ItemTypeMap[itemData.ItemType]
        if spineaniminfo.action == "prepare" then -- 对prepare特殊处理
            if itemData.ItemType == ItemTypeDetail.ItemType_Knife then 
                spineaniminfo.type = 1 -- 刀
            end
        end
        if spineaniminfo.type then
            if SPINE_ATTACK_TYPE[spineaniminfo.type] ~= itemTypeName then 
                self:SetEquipItem(itemID,uiEnhanceGrade,IDEL_SPINE_WEAPON_BONE)
                return
            end
            -- 武器放到对应动作位置
            self:SetEquipItem(itemID,uiEnhanceGrade)
        else
            -- 武器放到闲置挂点
            -- 扇子 待机不要
            if itemData.ItemType == ItemTypeDetail.ItemType_Fan then
                self:ResetWeapon()
            else
                self:SetEquipItem(itemID,uiEnhanceGrade, IDEL_SPINE_WEAPON_BONE)
            end
        end
    else
        self:ClearItemSpine()
        self:ClearItemPerfab()
    end
end

function SpineRoleUINew:GetRoleScale(roleModelData)
    if roleModelData  == nil then
        return DRCSRef.Vec3One
    end

    local ResourcesModeID = roleModelData.ModelID or 0
    local _specialScale = 1
    
    if  ResourcesModeID ~= 0 then
        local res = TableDataManager:GetInstance():GetTableData("ResourceRoleModel",ResourcesModeID)
        if res and SpecialBigSpine[res.ModelPath] then 
            _specialScale = SpecialScaleValue
        end
        if  res and res.RoleScale then
            if res.RoleScale.X <= 0  then
                res.RoleScale.X = 100
            end
            if res.RoleScale.Y <= 0  then
                res.RoleScale.Y = 100
            end
            if res.RoleScale.Z <= 0  then
                res.RoleScale.Z = 100
            end
            
            local X = res.RoleScale.X / 100
            local Y = res.RoleScale.Y / 100
            local Z = res.RoleScale.Z / 100
            --local scale = DRCSRef.Vec3(X, Y, Z)
            self.scale = DRCSRef.Vec3(X, Y, Z)
            return self.scale * _specialScale
        end
    end
    self.scale = DRCSRef.Vec3One 
    return self.scale * _specialScale
end

function SpineRoleUINew:GetRoleWeaponScale()
    local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.modelID)
    if roleModelData == nil then 
        return DRCSRef.Vec3One
    end
    local ResourcesModeID = roleModelData.ModelID
    if  ResourcesModeID and ResourcesModeID >= 0 then
        local res = TableDataManager:GetInstance():GetTableData("ResourceRoleModel",ResourcesModeID)
        if  res and res.WeaponScale then
            if res.WeaponScale.X <= 0  then
                res.WeaponScale.X = 100
            end
            if res.WeaponScale.Y <= 0  then
                res.WeaponScale.Y = 100
            end
            if res.WeaponScale.Z <= 0  then
                res.WeaponScale.Z = 100
            end
            local X = res.WeaponScale.X / 100
            local Y = res.WeaponScale.Y / 100
            local Z = res.WeaponScale.Z / 100
            return DRCSRef.Vec3(X,Y,Z)
        end
    end
    return DRCSRef.Vec3One
end

-- 自定义装备结构,方便后续拓展
-- itemCustomData = {
--    [itemID] = itemTypeID,
--    [uiEnhanceGrade] = uiEnhanceGrade,}
function SpineRoleUINew:SetEquipItem(itemID,uiEnhanceGrade, boneName)
    -- self:ClearItemSpine()
    -- self:ClearItemPerfab()
    local scale = self:GetRoleWeaponScale()
    if itemID and itemID > 0 then 
        if self.WeaponUI == nil then
            self.WeaponUI = WeaponUI.new()
        end
        self.objWeaponNode.gameObject:SetActive(true)
        self.WeaponUI:UpdateWeapon(itemID,uiEnhanceGrade, self.objWeaponNode, boneName, scale)
    end
end

function SpineRoleUINew:UpdateEquipItemSpine(animation)
    local itemID = nil
    local uiEnhanceGrade = 0
    if self.roleData then
        itemID = self.roleData:GetWeaponTypeID()
        uiEnhanceGrade = self.roleData:GetEnchanceGrade()
    end

    self:UpdateEquipItemSpineByID(itemID, uiEnhanceGrade, animation)
end

function SpineRoleUINew:UpdateEquipItemSpineByID(itemID, uiEnhanceGrade, animation)
    self.itemID = itemID
    if itemID and itemID > 0 then 
        animation = animation or self.roleData:GetIdleAnimName()
        local spineaniminfo = self:GetAnimInfoByName(animation,self.modelID)
        self:SetEquipItemEX(itemID,uiEnhanceGrade, spineaniminfo)
    else
        self:ResetWeapon()
    end
end

function SpineRoleUINew:ResetWeapon()
    self:ClearItemSpine()
    self:ClearItemPerfab()
    self:ResetBoneFollower()
end

function SpineRoleUINew:ResetBoneFollower()
    if not IsValidObj(self.objWeaponNode) then
        return
    end
    local boneFollower = self.objWeaponNode:GetComponent(l_DRCSRef_Type.BoneFollower)

    if boneFollower then
        boneFollower.boneName = ""
        boneFollower.enabled = false
    end
end

function SpineRoleUINew:ClearItemPerfab()
    if self.WeaponUI then 
        self.WeaponUI:ResetPerfabWeapon()
    else
        -- 单手
        local weaponPerfab = self:FindChild(self.objSpine, WeaponName)
        if weaponPerfab then
            ReturnObjectToPool(weaponPerfab.gameObject)
        end
        -- 双手
        local weaponPerfab = self:FindChild(self.objSpine, WeaponName)
        if weaponPerfab then
            ReturnObjectToPool(weaponPerfab.gameObject)
        end
    end
end


function SpineRoleUINew:ClearItemSpine()
    local objWeaponNode_transform = self.objWeaponNode_transform
    if objWeaponNode_transform == nil then
        if self.objSpine then
            objWeaponNode_transform = self:FindChild(self.objSpine, 'weapon_Node')
        end
    end

    if objWeaponNode_transform == nil then
        return
    end

    if self.WeaponUI then 
        self.WeaponUI:ResetPerfabWeapon()
        objWeaponNode_transform.gameObject:SetActive(false)
    else
        local childCount = objWeaponNode_transform.childCount
        for i = 1, childCount do  
            local objChild = objWeaponNode_transform:GetChild(i - 1)
            objChild.gameObject:SetActive(false)
        end

        objWeaponNode_transform.gameObject:SetActive(false)
    end
end

function SpineRoleUINew:GetAvailableChild()
    local childCount = self.objWeaponNode_transform.childCount
    for i = 1, childCount do 
        local objChild = self.objWeaponNode_transform:GetChild(i - 1)
        if not objChild.gameObject.activeSelf then 
            objChild.transform.localEulerAngles = DRCSRef.Vec3(0, 0, 90)
			return objChild.gameObject
		end
    end
    return self:CreateSpineNodeObject()
end

function SpineRoleUINew:CreateSpineNodeObject()
    local objSprite = DRCSRef.GameObject()
    objSprite.transform:SetParent(self.objWeaponNode_transform) 
    objSprite.transform.localPosition = DRCSRef.Vec3(0, 0, 0)
    objSprite.transform.localScale = DRCSRef.Vec3(1, 1, 1)
    objSprite.transform.localEulerAngles = DRCSRef.Vec3(0, 0, 90)
    local comSpriteRenderer = objSprite:AddComponent(l_DRCSRef_Type.SpriteRenderer)
    comSpriteRenderer.sortingOrder = 40
    return objSprite
end

function SpineRoleUINew:GetRoleModelDefaultWeapon()
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByID(self.roleData.uiID)
    if artData == nil then
        return 0
    end
    return artData.InitWeapom
end

function SpineRoleUINew:GetRoleEquipItemsModelInfo()
    local hasWeapon = false
    local roleEquipItemDict = {}
    local roleData = self.roleData
    local akEquipItem = roleData:GetEquipItems()
    for type, itemID in pairs(akEquipItem) do
        if itemID ~= 0 then 
            if type == REI_WEAPON then 
                hasWeapon = true
            end
            roleEquipItemDict[type] = {itemID = ItemDataManager:GetItemTypeID(itemID),uiEnhanceGrade = ItemDataManager:GetItemEnhanceGrade(itemID)}
        end
    end
    if not hasWeapon then 
        local defaultWeapon = self:GetRoleModelDefaultWeapon()
        roleEquipItemDict[REI_WEAPON] = {itemID = defaultWeapon}
    end
    return roleEquipItemDict
end

function SpineRoleUINew:IsLive()
    if IsValidObj(self.skeletonAnimation) then 
        return true
    end
    return false
end

function SpineRoleUINew:SetAction(animName, isLoop,spineAnimInfo)
    if animName == nil or HasActionFrameTime(self.modelID,animName) == false then 
        return 
    end
    if isLoop == nil then
        isLoop = false
    end

    if self.curAnima == animName and self.curLoop == isLoop and isLoop then 
        return 
    end
    if not self:IsLive() then 
        return
    end

    spineAnimInfo = spineAnimInfo or self:GetAnimInfoByName(animName,self.modelID)
    local weaponID = nil
    local uiEnhanceGrade = nil
    
    if self.roleData then
        weaponID = self.roleData:GetWeaponTypeID(spineAnimInfo)
        uiEnhanceGrade = self.roleData:GetEnchanceGrade() or 0
    end

    self:SetActionWithWeapon(animName, weaponID, uiEnhanceGrade, isLoop, spineAnimInfo)
end

function SpineRoleUINew:SetActionWithWeapon(animName, weaponID, uiEnhanceGrade, isLoop, spineAnimInfo)
    if isLoop == nil then
        isLoop = false
    end

    spineAnimInfo = spineAnimInfo or self:GetAnimInfoByName(animName,self.modelID)
    if weaponID and uiEnhanceGrade then
        self:SetEquipItemEX(weaponID,uiEnhanceGrade,spineAnimInfo)
        -- self.skeletonAnimation.loop = isLoop
        -- self.skeletonAnimation.AnimationName = animName
        self.roleData:SetOldWeapon(weaponID)
    end
    if isLoop then 
        self.skeletonAnimation:ClearState()
    end
    local trackEntry = self.skeletonAnimation.AnimationState:SetAnimation(0, animName, isLoop)
    self.curAnima = animName
    self.curLoop = isLoop
    return trackEntry
end


function SpineRoleUINew:SetIdleAction()
    local animName = self.roleData:GetIdleAnimName()
    self:SetAction(animName,true)
end

function SpineRoleUINew:DirPlayAnim(actionName,loop)
    if getActionFrameTime(self.modelID,actionName) == 0 then 
        return 
    end
    if self.curAnima == actionName then 
        return 
    end
    if loop == nil then
		loop = false
    end
    self.curAnima = actionName
    self.curLoop = loop
    -- self.skeletonAnimation.loop = isLoop
    -- self.skeletonAnimation.AnimationName = animName
    -- self.skeletonAnimation:ClearState()
    self.skeletonAnimation.AnimationState:SetAnimation(0, actionName, loop)
end

function SpineRoleUINew:GetBoneWorldXY(boneName)
    if self.scale == nil then 
        self.scale = DRCSRef.Vec3One
    end
    if self.skeletonAnimation then 
        local bone = self.skeletonAnimation.skeleton:FindBone(boneName)
        if bone then 
            return bone.WorldX * self.scale.x,bone.WorldY*self.scale.y
        end
    end
    return 0,0
end

function SpineRoleUINew:GetOverheadWorldXY()
    return self:GetBoneWorldXY("ref_overhead")
end

function SpineRoleUINew:SetFace(scaleX)
    if self.skeletonAnimation and scaleX then 
        self.skeletonAnimation.skeleton.ScaleX = scaleX
    end
end

function SpineRoleUINew:SetTimeScale(timeScale)
    if self.skeletonAnimation and timeScale then 
        self.skeletonAnimation.timeScale = timeScale
    end
end

-- 设置spine停在某个动作的某个时间点
function SpineRoleUINew:SetPose(animationName,time)
    self:SetTimeScale(0)
    if self.skeletonAnimation and time then 
        local skeleton = self.skeletonAnimation.skeleton
        skeleton:SetToSetupPose()--回到起始状态
        if skeleton.PoseWithAnimation then 
            skeleton:PoseWithAnimation(animationName,time)--设置姿势
        end
    end
end

function SpineRoleUINew:GetXYByMountName(mount1Name,mount2Name,isOnRole,SeBattle_HurtInfo)
    return getXYByMountName(mount1Name,mount2Name,self.objSpine,isOnRole,SeBattle_HurtInfo)
end

function SpineRoleUINew:SetCanyinSkill(skillID)
    self._canyingSkillOld = self._canyingSkill
    self._canyingSkill = skillID
end

function SpineRoleUINew:AddSkeletonGhost(canying)
    if self.SkeletonRenderSeparator == nil then 
        self.SkeletonRenderSeparator = self.objSpine:GetComponent(l_DRCSRef_Type.SkeletonRenderSeparator)
        if self.SkeletonRenderSeparator == nil then 
            return 
        end
    end
    self.SkeletonRenderSeparator.enabled = false 
    if not self.SkeletonGhost then
        self.SkeletonGhost = self.objSpine:AddComponent(l_DRCSRef_Type.SkeletonGhost)
        self.SkeletonGhost.ghostShader = DRCSRef.Shader.Find('Spine/Special/SkeletonGhost')
    end
    if canying == nil or canying.ghostingEnabled ~= false then 
        self.SkeletonGhost.ghostingEnabled = true
    end
    if self._canyingSkillOld == self._canyingSkill then 
        return
    end
    if canying == nil then canying = {} end
    if canying.additive == nil then canying.additive = true end
    self.SkeletonGhost.spawnInterval = canying.spawnInterval or 0.03
    self.SkeletonGhost.maximumGhosts = canying.maximumGhosts or 5
    self.SkeletonGhost.fadeSpeed = canying.fadeSpeed or 3
    local color = DRCSRef.Color32(255,255,255,180)
    if canying.color then 
        color = ColorHex2RGB32(canying.color)
    end
    if canying.additive then 
        color.a = 0
    end
    self.SkeletonGhost.color = color
    self.SkeletonGhost.textureFade = canying.textureFade or 0
    self.SkeletonGhost.additive = canying.additive
    self.SkeletonGhost:Initialize(true)
end

function SpineRoleUINew:DisableSkeletonGhost()
    if self.SkeletonGhost then
        self.SkeletonGhost.ghostingEnabled = false
    end
    if self.SkeletonRenderSeparator then 
        self.SkeletonRenderSeparator.enabled = true
    end
end

function SpineRoleUINew:SetActive(bActive)
    if self.gameObject then 
        self.gameObject:SetActive(bActive)
    end
end

function SpineRoleUINew:IsActive()
    if self.gameObject then 
        return self.gameObject.activeSelf
    end
    return false
end

function SpineRoleUINew:ShowBubble(bubbleStr, showtime)
    if self.bubblePlotUiInst == nil then 
        self.bubblePlotUiInst = BubblePlotUI.new()
        if self.bubblePlotUiInst then 
            local boneX,boneY = self:GetOverheadWorldXY()
            -- 转换为屏幕坐标
            -- local pos = DRCSRef.Camera.main:WorldToScreenPoint(DRCSRef.Vec3(boneX,boneY,0)); 
            -- local _, localPointPos = CS.UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self.gameObject.transform, DRCSRef.Vec2(pos.x,pos.y), UI_Camera)
            self.bubblePlotUiInst:Init(self.objSpine,boneX,boneY)
            self.bubblePlotUiInst:AddCanvas()
            -- if self.SortingGroup then 
            --     local baseDepth = self.SortingGroup.sortingOrder
            --     self.bubblePlotUiInst:SetDepth(baseDepth)
            -- end
        end
    else
        local boneX,boneY = self:GetOverheadWorldXY()
        self.bubblePlotUiInst:SetPos(boneX,boneY)
    end
    if self.SortingGroup then 
        self.bubblePlotUiInst:SetDepth(self.SortingGroup.sortingOrder + 6)
    end
    self.bubblePlotUiInst:ShowDoText(bubbleStr, showtime)
end

function SpineRoleUINew:HideBubble()
    if self.bubblePlotUiInst then
        self.bubblePlotUiInst:Hide()
    end
end

function SpineRoleUINew:SetAlpha(fAlpha)
    if self.gameObject and fAlpha then 
        changeShapsAlpha(self.gameObject,fAlpha)
    end
end

function SpineRoleUINew:SetPosition(pos)
    if IsValidObj(self.transform) and pos then 
        self.transform.localPosition = pos
    end
end

function SpineRoleUINew:SetPositionXYZ(x,y,z)
    if IsValidObj(self.transform) and x and y and z then 
        self.transform.localPosition = DRCSRef.Vec3(x,y,z)
    end
end

function SpineRoleUINew:MoveTo(t,x,y,z)
    if IsValidObj(self.transform) and x and y and z then 
        self.transform:DOLocalMoveX(x,t)
        self.transform:DOLocalMoveY(y,t)
        self.transform:DOLocalMoveZ(z,t)
    end
end

return SpineRoleUINew