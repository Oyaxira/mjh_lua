SpineRoleUI = class("SpineRoleUI", BaseWindow)

function SpineRoleUI:ctor()
    self.bubblePlotUiInst = BubblePlotUI.new()
end

function SpineRoleUI:Create()
end

function SpineRoleUI:Init()
end

function SpineRoleUI:OnDestroy()
    self.bubblePlotUiInst:Clear()
end

function SpineRoleUI:UpdateRoleSpine(objSpine, roleID,animationName)
	local RoleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
    if RoleTypeID then 
		local RoleData = RoleDataManager:GetInstance():GetInstRoleByTypeID(RoleTypeID)
        if RoleData then
            roleID = RoleData.uiID
        end
    end
    self:UpdateBaseSpineByRoleID(objSpine, roleID,animationName)
    self:UpdateEquipItemSpine(objSpine, roleID,animationName)
end

function SpineRoleUI:UpdateRoleSpineByCustomData(objSpine, customData)
    self:UpdateBaseSpineByCustomData(objSpine, customData)
end

function SpineRoleUI:UpdateBaseSpineByRoleID(objSpine, roleID,animationName)
    local roleModelID = self:GetRoleModelDataID(roleID)
    return self:UpdateBaseSpine(objSpine, roleModelID,animationName)
end

function SpineRoleUI:GetRoleModelResID(roleID)
    local roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if roleModelData == nil then 
        return 0
    end
    return roleModelData.ModelID
end

function SpineRoleUI:GetRoleModelDataID(roleID)
    local roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if roleModelData == nil then 
        return 0
    end
    return roleModelData.BaseID
end

function SpineRoleUI:UpdateBaseSpineByCustomData(objSpine, customData)
    local roleModelID = customData.ArtID
    local animationName = customData.AnimationName
    return self:UpdateBaseSpine(objSpine, roleModelID,animationName)
end

function SpineRoleUI:UpdateBaseSpine(objSpine, roleModelID,animationName)
    local texture = nil
    local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", roleModelID)
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

    if animationName == nil then
        animationName = ROLE_SPINE_DEFAULT_ANIM
    end
    local scale = GetRoleScale(roleModelData)
    objSpine.gameObject:SetObjLocalScale(scale.x, scale.y, scale.z)
    local curModelID = GetUIntDataInGameObject(objSpine,'ModelID')
    if curModelID == roleModelID then 
        if not IsSpinePlayAnim(objSpine, animationName) then 
            -- self:PlayAnim(objSpine, animationName, true)
            DynamicChangeSpine(objSpine, spine, animationName)
        end
        return
    end
    DynamicChangeSpine(objSpine, spine, animationName)
    
    if spineTexture then 
        texture = ChnageSpineSkin(objSpine, spineTexture)
    end
    SetUIntDataInGameObject(objSpine, 'ModelID', roleModelID)
    -- 初始化气泡
    local comSkeletonAnimation = objSpine:GetComponent("SkeletonAnimation")
    self.bubblePlotUiInst:Init(comSkeletonAnimation)
    return texture
end

function SpineRoleUI:GetAnimInfoByName(animName,modelID,spineActionData)
    local st = string.split( animName, '_' )
    local spineaniminfo = {
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
function SpineRoleUI:SetEquipItemEX(objSpine,roleModeID,itemCustomData,spineaniminfo,scale)
    if itemCustomData == nil then
        self:ClearItemSpine(objSpine)
        self:ClearItemPerfab(objSpine)
        return
    end

    if scale == nil then
        if roleModeID > 0 then
            local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", roleModeID)
            scale = self:GetRoleWeaponScale(roleModelData.ModelID)
        end
    end
    local string_name = getAttackAction(roleModeID,spineaniminfo)
 

    local itemID = itemCustomData.itemID
    if itemID then 
        itemData = TableDataManager:GetInstance():GetTableData("Item",itemID)
    end
    if itemData ~= nil then 
        local itemTypeName = ItemTypeMap[itemData.ItemType]
        if spineaniminfo.type then
            if SPINE_ATTACK_TYPE[spineaniminfo.type] ~= itemTypeName then 
                self:SetEquipItem(objSpine, itemCustomData,IDEL_SPINE_WEAPON_BONE,scale)
                return
            end
            -- 武器放到对应动作位置
            self:SetEquipItem(objSpine,itemCustomData,nil,scale)
        else
            -- 扇子不显示
            if itemData.ItemType == ItemTypeDetail.ItemType_Fan then
                --self:SetEquipItem(objSpine, itemCustomData,DEFAULT_SPINE_WEAPON_BONE,scale)
            else
                self:SetEquipItem(objSpine, itemCustomData,IDEL_SPINE_WEAPON_BONE,scale)
            end
        end
    else
        self:ClearItemSpine(objSpine)
        self:ClearItemPerfab(objSpine)
    end
end


--纯功能函数
function GetRoleScale(roleModelData)
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
            
            return DRCSRef.Vec3(X, Y, Z) * _specialScale
        end
    end
    return DRCSRef.Vec3One * _specialScale
end

function SpineRoleUI:GetRoleWeaponScale(ResourcesModeID)
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

local WeaponName = "WEAPON"

function SpineRoleUI:SetEquipItem(objSpine,itemCustomData,boneName,scale)
    if itemCustomData == nil then
        return
    end
    local itemID = itemCustomData.itemID
    local weaponNode = self:FindChild(objSpine, 'weapon_Node')
    local oldScale = self:GetRoleWeaponScale()
    local scale = DRCSRef.Vec3(oldScale.x * scale.x,oldScale.y * scale.y,oldScale.z * scale.z)
    if itemID and itemID > 0 then 
        if self.WeaponUI == nil then
            self.WeaponUI = WeaponUI.new()
        end
        self.WeaponUI:UpdateWeapon(itemCustomData.itemID, itemCustomData.uiEnhanceGrade, weaponNode, boneName, scale)
    end
    
end

function SpineRoleUI:UpdateEquipItemSpine(objSpine, roleID,animation)
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if not roleData then 
        return 
    end
    local scale = DRCSRef.Vec3One
    local roleModelResID = self:GetRoleModelResID(roleID)
    if roleModelResID > 0 then
        scale = self:GetRoleWeaponScale(roleModelResID)
    end
    local equipItemsModel = self:GetRoleEquipItemsModelInfo(roleID)
    local spine_1 = self:FindChild(objSpine, '0')
    local comSpriteRenderer = spine_1:GetComponent('MeshRenderer')
    local layer = 1001
    if comSpriteRenderer then 
        layer = comSpriteRenderer.sortingOrder
    end
    if equipItemsModel[REI_WEAPON] then 
        local itemID = equipItemsModel[REI_WEAPON]['itemID']
        local uiEnhanceGrade = equipItemsModel[REI_WEAPON]['uiEnhanceGrade'] or 0
        self.itemID = itemID
        if itemID and itemID > 0 then 
            animation = animation or ROLE_SPINE_DEFAULT_ANIM
            local spineaniminfo = self:GetAnimInfoByName(animation,roleData.uiModelID)
            self:SetEquipItemEX(objSpine,roleData.uiModelID,{itemID = itemID, uiEnhanceGrade = uiEnhanceGrade},spineaniminfo,scale)
        else
            self:ClearItemSpine(objSpine)
            self:ClearItemPerfab(objSpine)
        end
    end
end

function SpineRoleUI:SetSortingOrder(objSpine,int_SortingOrder)
    local comSpriteRenderer = objSpine:GetComponent('MeshRenderer')
    if comSpriteRenderer then 
        comSpriteRenderer.sortingOrder = int_SortingOrder
    end
    if self.bubblePlotUiInst then
        self.bubblePlotUiInst:SetDepth(int_SortingOrder)
    end
end

-- 设置角色武器层级
function SpineRoleUI:SetWeaponSortingOrder(objSpine,int_SortingOrder)
    local comWeaponParent = self:FindChild(objSpine,"weapon_Node")
    if comWeaponParent == nil then return end

    local comWeapon = self:FindChild(comWeaponParent,"New Game Object")
    if comWeapon == nil then return end

    local comWeaponSpriteRenderer = comWeapon.gameObject:GetComponent("SpriteRenderer") 
    if comWeaponSpriteRenderer then
        comWeaponSpriteRenderer.sortingOrder = int_SortingOrder
    end
end

-- 设置角色武器大小
function SpineRoleUI:SetWeaponScale(vec3Scale)
    if self.WeaponUI ~= nil then
        self.WeaponUI:SetWeaponScale(vec3Scale)
    end
end

-- 设置角色武器强化等级
function SpineRoleUI:SetWeaponEnhanceGrade(uiEnhanceGrade)
    if self.WeaponUI ~= nil then
        self.WeaponUI:SetWeaponEnhanceGrade(uiEnhanceGrade)
    end
end

-- 设置挂点节点
function SpineRoleUI:FollowerBone(objSpine,boneName,skeletonRenderer)
    local comWeaponParent = self:FindChild(objSpine,"weapon_Node")
    if comWeaponParent == nil then return end
    local boneFollower = comWeaponParent.gameObject:GetComponent("BoneFollower")   
    if boneFollower == nil then 
        boneFollower = self.gameObject:AddComponent(typeof(CS.Spine.Unity.BoneFollower))
    end
    boneFollower.enabled = true

    if skeletonRenderer then 
        boneFollower.skeletonRenderer = skeletonRenderer
        if skeletonRenderer.skeleton:FindBone(boneName) then 
            boneFollower.boneName = boneName
        end
    end

end

function SpineRoleUI:ClearItemPerfab(objSpine)
    local weaponPerfab = self:FindChild(objSpine, WeaponName)
    if weaponPerfab then
        ReturnObjectToPool(weaponPerfab.gameObject)
    end
end


function SpineRoleUI:ClearItemSpine(objSpine)
    -- TODO: 清理各个部位节点
    local weaponNode = self:FindChild(objSpine, 'weapon_Node')
    if weaponNode == nil then
        return
    end
    local boneFollower = weaponNode.gameObject:GetComponent("BoneFollower")   
    boneFollower.enabled = false
    local childCount = weaponNode.transform.childCount
	for i = 1, childCount do  
		local objChild = weaponNode.transform:GetChild(i - 1)
		objChild.gameObject:SetActive(false)
	end
end

function SpineRoleUI:GetAvailableChild(objSpineNode)
    local childCount = objSpineNode.transform.childCount
    for i = 1, childCount do 
        local objChild = objSpineNode.transform:GetChild(i - 1)
        if not objChild.gameObject.activeSelf then 
            objChild.transform.localEulerAngles = DRCSRef.Vec3(0, 0, 90)
			return objChild.gameObject
		end
    end
    return self:CreateSpineNodeObject(objSpineNode)
end

function SpineRoleUI:CreateSpineNodeObject(objSpineNode)
    local objSprite = DRCSRef.GameObject()
    objSprite.transform:SetParent(objSpineNode.transform) 
    objSprite.transform.localPosition = DRCSRef.Vec3(0, 0, 0)
    objSprite.transform.localScale = DRCSRef.Vec3(1, 1, 1)
    objSprite.transform.localEulerAngles = DRCSRef.Vec3(0, 0, 90)
    local comSpriteRenderer = objSprite:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
    comSpriteRenderer.sortingOrder = 40
    return objSprite
end

function SpineRoleUI:GetArtID(roleID)
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if artData == nil then 
        return 0
    end
    return artData.BaseID
end

function SpineRoleUI:GetRoleSpine(roleID)
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if artData == nil then 
        return nil
    end
    return artData.Model
end

function SpineRoleUI:GetRoleSpineTexture(roleID)
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if artData == nil then 
        return nil
    end
    return artData.Texture
end

function SpineRoleUI:GetRoleModelDefaultWeapon(roleID)
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if artData == nil then
        return 0
    end
    return artData.InitWeapom
end

function SpineRoleUI:GetRoleEquipItemsModelInfo(roleID)
    local hasWeapon = false
    local roleEquipItemDict = {}
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    for type, itemID in pairs(roleData.akEquipItem or {}) do
        if itemID ~= 0 then 
            if type == REI_WEAPON then 
                hasWeapon = true
            end
            roleEquipItemDict[type] = {itemID = ItemDataManager:GetItemTypeID(itemID),
            uiEnhanceGrade = ItemDataManager:GetItemEnhanceGrade(itemID)
        }
        end
    end
    if not hasWeapon then 
        local defaultWeapon = self:GetRoleModelDefaultWeapon(roleID)
        roleEquipItemDict[REI_WEAPON] = {itemID = defaultWeapon}
    end
    return roleEquipItemDict
end

function SpineRoleUI:PlayAnim(objSpine, animName, isLoop, needRecover)
    local comSkeletonAnimation = objSpine:GetComponent("SkeletonAnimation")
    if comSkeletonAnimation == nil then 
        return nil
    end
    local modelID = GetUIntDataInGameObject(objSpine, 'ModelID')
    if not HasAction(objSpine, animName) then 
        return nil
    end
	local roleID = GetUIntDataInGameObject(objSpine, 'roleID')
    self:UpdateEquipItemSpine(objSpine,roleID,animName)
    if comSkeletonAnimation.AnimationState == nil then
        return nil
    end
    local trackEntry = comSkeletonAnimation.AnimationState:SetAnimation(0, animName, isLoop)
    if needRecover ~= false then 
        comSkeletonAnimation.AnimationState:AddAnimation(0, ROLE_SPINE_DEFAULT_ANIM, true, 0)
    end
    return trackEntry
end

function SpineRoleUI:ShowBubble(objSpine, bubbleStr, showtime)
    local comSkeletonAnimation = objSpine.gameObject:FindChildComponent("Spine","SkeletonAnimation")
    self.bubblePlotUiInst:Init(comSkeletonAnimation)
    self.bubblePlotUiInst:ShowDoText(bubbleStr, showtime)
    self.bubblePlotUiInst:SetDepth(120)
end

return SpineRoleUI
