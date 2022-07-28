WeaponUI = class("WeaponUI", BaseWindow)
local NAME_WEAPON = "WEAPON"

local TYPE_WEAPON = 
{
    None = 0,
    Image_Weapon = 1,
    Onehanded_Weapons = 2,
    Twohanded_Weapons = 3,
}
local WEAPON_SPRITE_NAME = "[WEAPON_SPRITE]"

local  EFFECT_WEAPON_STRENG = {
    ["path"] =  "Effect/Ui_eff/eff_weaponglow/",
    [10] = 
    {
       ["name"] = "eff_weaponglow01",
       ['pos'] = DRCSRef.Vec3(1, 0, 0),
       ['rotation'] = DRCSRef.Vec3(0, 0, 90),
       ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    },
    [15] = {
        ["name"] = "eff_weaponglow02",
        ['pos'] = DRCSRef.Vec3(1, 0, 0),
        ['rotation'] = DRCSRef.Vec3(0, 0, 90),
        ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    },
    [20] = {
        ["name"] = "eff_weaponglow03",
        ['pos'] = DRCSRef.Vec3(1, 0, 0),
        ['rotation'] = DRCSRef.Vec3(0, 0, 90),
        ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    },
    -- [20] = {
    --     ["name"] = "eff_weaponglow03",
    --     ['pos'] = DRCSRef.Vec3(1, 0, 0),
    --     ['rotation'] = DRCSRef.Vec3(0, 0, -90),
    --     ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    -- },
}


local  EFFECT_TWOHAND_WEAPON_STRENG = {
    ["path"] =  "Effect/Ui_eff/eff_weaponglow/",
    [10] = 
    {
       ["name"] = "eff_fist_glow01",
       ['pos'] = DRCSRef.Vec3(0, 0, 0),
       ['rotation'] = DRCSRef.Vec3(0, 0, 90),
       ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    },
    [15] = {
        ["name"] = "eff_fist_glow02",
        ['pos'] = DRCSRef.Vec3(0, 0, 0),
        ['rotation'] = DRCSRef.Vec3(0, 0, 90),
        ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    },
    [20] = {
        ["name"] = "eff_fist_glow03",
        ['pos'] = DRCSRef.Vec3(0, 0, 0),
        ['rotation'] = DRCSRef.Vec3(0, 0, 90),
        ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    },
    -- [20] = {
    --     ["name"] = "eff_weaponglow03",
    --     ['pos'] = DRCSRef.Vec3(1, 0, 0),
    --     ['rotation'] = DRCSRef.Vec3(0, 0, -90),
    --     ['scale'] = DRCSRef.Vec3(1.5, 1.5, 1)
    -- },
}

function WeaponUI:ctor()
    self.Scale = DRCSRef.Vec3One
    self.boneName = ""
    self.weaponPerfabTable = {}
    self.eWeaponType = TYPE_WEAPON.None
    self.uiEnhanceGrade = 0
    self.eItemTypeDetail = ItemTypeDetail.ItemType_Null
    self.func_UpdateWeapon = {
        [1] = {
            ["Update"] = function(itemTypeData) self:_UpdateImageWeapon(itemTypeData) end,
            ["Reset"] = function() self:_ResetImageWeapon() end,
        },
        [2] = {
            ["Update"] = function(itemTypeData) self:_UpdateOneHandWeapon(itemTypeData) end,
            ["Reset"] = function() self:_ResetOneHandWeapon() end,
        },
        [3] = {
            ["Update"] = function(itemTypeData) self:_UpdateTwohandedWeapons(itemTypeData) end,
            ["Reset"] = function() self:_ResetTwohandedWeapons() end,
        }
    }
end

function WeaponUI:UpdateWeapon(itemID,uiEnhanceGrade, objWeaponNode, boneName, scale)
    self:ResetPerfabWeapon()
    self:ResetBoneFollower(objWeaponNode)

    if scale ~= nil then
        -- 根据角色来改变大小
        self.Scale = scale
    end

    if uiEnhanceGrade == nil then
        uiEnhanceGrade = 0
    end
    
    if itemID == nil or objWeaponNode == nil then
        return
    end
   
    local itemTypeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemID)
    if itemTypeData == nil then
        return
    end

    -- 去掉暗器
    if itemTypeData.ItemType == ItemTypeDetail.ItemType_HiddenWeapon then
        return
    end

    self.boneName = boneName or DEFAULT_SPINE_WEAPON_BONE
    self.objWeaponNode = objWeaponNode
    self.objSpine = self.objWeaponNode.transform.parent
    if self.objSpine then
        self.skeletonRenderer = self.objSpine.transform:GetComponent("SkeletonRenderer")
    end

    self.eWeaponType = TYPE_WEAPON.None
    self.modelPath = itemTypeData.Model
    if self.modelPath ~= nil and self.modelPath ~= ""  then
        if WEAPON_NODE and WEAPON_NODE[itemTypeData.ItemType] then
            self.eWeaponType = TYPE_WEAPON.Twohanded_Weapons
        else
            self.eWeaponType = TYPE_WEAPON.Onehanded_Weapons
        end
    else
        self.eWeaponType = TYPE_WEAPON.Image_Weapon
    end
    
    self.func_UpdateWeapon[self.eWeaponType]["Update"](itemTypeData)
    self:SetWeaponEnhanceGrade(uiEnhanceGrade,itemTypeData.ItemType)
end

-- 设置角色武器强化等级
function WeaponUI:SetWeaponEnhanceGrade(uiEnhanceGrade,eItemTypeDetail)
    self.uiEnhanceGrade = uiEnhanceGrade
    if eItemTypeDetail ~= nil then 
        self.eItemTypeDetail = eItemTypeDetail
    end

    if self.eItemTypeDetail == ItemTypeDetail.ItemType_Knife 
    or self.eItemTypeDetail == ItemTypeDetail.ItemType_Sword
    or self.eItemTypeDetail == ItemTypeDetail.ItemType_Rod then
        self:_UpdateWeaponEnhanceGradeEffect()
    elseif self.eItemTypeDetail == ItemTypeDetail.ItemType_Fist then
    --or self.eItemTypeDetail == ItemTypeDetail.ItemType_Cane then
        self:_UpdateTwoHandWeaponEnhanceGradeEffect()
    end
end

function WeaponUI:SetWeaponScale(vec3Scale)
    if self.eWeaponType == TYPE_WEAPON.None then
        return
    end

    if IsValidObj(self.weaponPerfab) then
        self.weaponPerfab.transform.localScale = vec3Scale
    end
    
    if self.eWeaponType == TYPE_WEAPON.Image_Weapon then
        if IsValidObj(self.weaponSprite) then
            self.weaponSprite:SetActive(true)
        end
    elseif self.eWeaponType == TYPE_WEAPON.Onehanded_Weapons then
        if IsValidObj(self.weaponPerfab) then
            self.weaponPerfab.transform.localScale = vec3Scale
        end
    elseif self.eWeaponType == TYPE_WEAPON.Twohanded_Weapons  then
        for index = 1, #self.weaponPerfabTable do
            local tempWeapon = self.weaponPerfabTable[index]
            if IsValidObj(tempWeapon) then
                tempWeapon.transform.localScale = vec3Scale
            end
        end
    end
end

function WeaponUI:ResetPerfabWeapon()
    if self.eWeaponType == TYPE_WEAPON.None then
        self:_ResetImageWeapon()
        self:_ResetOneHandWeapon()
        self:_ResetTwohandedWeapons()
        return
    end

    if self.effect_EnhanceGrade then
        ReturnObjectToPool(self.effect_EnhanceGrade, false)
        self.effect_EnhanceGrade = nil
    end

    self.func_UpdateWeapon[self.eWeaponType]["Reset"]()
    self.eWeaponType = TYPE_WEAPON.None
end

function WeaponUI:_ResetImageWeapon()
    if IsValidObj(self.weaponSprite) then
        self.weaponSprite:SetActive(false)
    end
end

function WeaponUI:_ResetOneHandWeapon()
    if IsValidObj(self.weaponPerfab) then
        local boneFollower = self.weaponPerfab.transform:GetComponent("BoneFollower")
        if boneFollower ~= nil then
            boneFollower.enabled = false
        end
        self:ReturnWeaponToPool(self.weaponPerfab.gameObject, false)
        self.weaponPerfab = nil
    end
end

function WeaponUI:_ResetTwohandedWeapons()
    for index = 1, #self.weaponPerfabTable do
        if IsValidObj(self.weaponPerfabTable[index]) then
            local boneFollower = self.weaponPerfabTable[index].transform:GetComponent("BoneFollower")
            if boneFollower ~= nil then
                boneFollower.boneName = ""
                boneFollower.enabled = false
            end
            self:ReturnWeaponToPool(self.weaponPerfabTable[index], false)
        end
    end
    self.weaponPerfabTable = {}
end

function WeaponUI:UpdatePerfabWeapon()
    if self.objWeaponNode then
        self.objWeaponNode.gameObject:SetActive(true)
    end

    if self.weaponPerfab == nil then
        self.weaponPerfab = self:CreateWeaponPerfab(self.objWeaponNode)
    else
        self:ReturnWeaponToPool(self.weaponPerfab.gameObject, false)
        self.weaponPerfab = self:CreateWeaponPerfab(self.objWeaponNode)
    end
end

function WeaponUI:CreateWeaponPerfab(comParent)
    local weaponPerfab = LoadPrefabFromPool("Weapon/"..self.modelPath, comParent.transform, true)
    if not IsValidObj(weaponPerfab) then
        return
    end

    weaponPerfab.gameObject.name = self.modelPath
    weaponPerfab.gameObject:SetActive(true)
    weaponPerfab.transform.localPosition = DRCSRef.Vec3Zero
    weaponPerfab.transform.localEulerAngles = DRCSRef.Vec3(-180, 0, 90)
    weaponPerfab.transform.localScale = self.Scale
    local trail01 = self:FindChild(weaponPerfab, "trail01")
    if trail01 ~= nil then
        local trailEffect01 = trail01:GetComponent("TrailRenderer")
        if trailEffect01 ~= nil then
            trailEffect01:Clear()
        end
    end
    return weaponPerfab
end


function WeaponUI:UpdateImageWeapon(itemImg)
    if itemImg == nil then
        return
    end

    if itemImg == "" then
        return
    end

    -- TODO: 更新装备的 spine, 暂时只更新武器 spine
    local itemSprite = GetSprite(itemImg)

    self:CheckActiveSpineNode()

    if self.comSpriteRenderer and itemSprite then 
        self.comSpriteRenderer.sprite = itemSprite
        self.comSpriteRenderer.flipX = true
    end
    -- mark: 去掉 0。85 缩放，
    self.weaponSprite.transform.localScale = self.Scale
end

function WeaponUI:ResetBoneFollower(objWeaponNode)
    if not IsValidObj(objWeaponNode) then
        return
    end

    local boneFollower = objWeaponNode:GetComponent("BoneFollower")
    if boneFollower then
        boneFollower.enabled = false
    end
end

function WeaponUI:UpdateBoneFollower()
    local boneFollower = self.objWeaponNode:GetComponent("BoneFollower")
    self.sortingGroup = self.objWeaponNode:GetComponent("SortingGroup")
    if self.sortingGroup == nil then 
        self.sortingGroup = self.objWeaponNode:AddComponent(typeof(DRCSRef.SortingGroup))
    end
    self.boneName = self.boneName or DEFAULT_SPINE_WEAPON_BONE
    local skeletonRenderer = self.objSpine.transform:GetComponent("SkeletonRenderer")
    if boneFollower and self.skeletonRenderer and self.skeletonRenderer.skeleton:FindBone(self.boneName) then 
        boneFollower.followLocalScale = true
        boneFollower.enabled = true
        boneFollower:SetBone(self.boneName)
    end
    local Layout = -1
    if self.boneName == DEFAULT_SPINE_WEAPON_BONE then 
        Layout = 0
    end
    if self.sortingGroup then 
        self.sortingGroup.sortingOrder = Layout
    end
end

function WeaponUI:CheckActiveSpineNode()
    if self.weaponSprite == nil or self.weaponSprite.gameObject == nil or self.weaponSprite.gameObject.activeSelf == false then
        self:CreateSpineNodeObject()
    end
    if  self.weaponSprite == nil then return end
    self.weaponSprite:SetActive(true)
    self.comSpriteRenderer = self.weaponSprite:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

function WeaponUI:CreateSpineNodeObject()
    if self.weaponSprite then return end
    if self.objWeaponNode == nil then return end
    local childCount = self.objWeaponNode.transform.childCount
    if  childCount > 0 then
        self.weaponSprite = self:FindChild(self.objWeaponNode, WEAPON_SPRITE_NAME)
    end
    
    if self.weaponSprite == nil then
        self.weaponSprite = DRCSRef.GameObject()
        self.weaponSprite.name = WEAPON_SPRITE_NAME
        self.weaponSprite.transform:SetParent(self.objWeaponNode.transform) 
        self.weaponSprite.transform.localPosition = DRCSRef.Vec3(0, 0, 0)
        self.weaponSprite.transform.localScale = DRCSRef.Vec3(1, 1, 1)
        self.weaponSprite.transform.localEulerAngles = DRCSRef.Vec3(0, 0, 90)
        self.comSpriteRenderer = self.weaponSprite:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        self.comSpriteRenderer.sortingOrder = 40
        self.sortingGroup = self.objWeaponNode:GetComponent("SortingGroup")
        if  self.sortingGroup == nil then
            self.sortingGroup = self.objWeaponNode:AddComponent(typeof(DRCSRef.SortingGroup))
        end
        self.sortingGroup.sortingOrder = 1
    end
end

function WeaponUI:GetRoleWeaponScale(modelID)
    local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", modelID)
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

function WeaponUI:_UpdateWeaponEnhanceGradeEffect()
    if self.uiEnhanceGrade == nil then
        return
    end

    local data = {}
    if self.uiEnhanceGrade >= 20 then
        data = EFFECT_WEAPON_STRENG[20]
    elseif self.uiEnhanceGrade >= 15 then
        data = EFFECT_WEAPON_STRENG[15]
    elseif self.uiEnhanceGrade >= 10 then
        data = EFFECT_WEAPON_STRENG[10]
    else
        return
    end

    if self.effect_EnhanceGrade then
        ReturnObjectToPool(self.effect_EnhanceGrade, false)
        self.effect_EnhanceGrade = nil
    end

    local effectPath = EFFECT_WEAPON_STRENG["path"] ..data["name"]
    self.effect_EnhanceGrade = LoadPrefabFromPool(effectPath, self.objWeaponNode.gameObject,true)
    self.effect_EnhanceGrade.gameObject.name = self.uiEnhanceGrade
    self.effect_EnhanceGrade.gameObject:SetActive(true)
    if self.eItemTypeDetail == ItemTypeDetail.ItemType_Rod then
        local scale = data["scale"] 
        self.effect_EnhanceGrade.transform.localScale = DRCSRef.Vec3(scale.x,scale.y + 1, scale.z)
    else
        self.effect_EnhanceGrade.transform.localScale = data["scale"]
    end
    self.effect_EnhanceGrade.transform.localPosition = data["pos"]
    self.effect_EnhanceGrade.transform.localEulerAngles = data["rotation"]
end


function WeaponUI:_UpdateTwoHandWeaponEnhanceGradeEffect()
    if self.uiEnhanceGrade == nil then
        return
    end

    local data = {}
    if self.uiEnhanceGrade >= 20 then
        data = EFFECT_TWOHAND_WEAPON_STRENG[20]
    elseif self.uiEnhanceGrade >= 15 then
        data = EFFECT_TWOHAND_WEAPON_STRENG[15]
    elseif self.uiEnhanceGrade >= 10 then
        data = EFFECT_TWOHAND_WEAPON_STRENG[10]
    else
        return
    end

    if self.effect_Left_EnhanceGrade then
        ReturnObjectToPool(self.effect_Left_EnhanceGrade, false)
        self.effect_Left_EnhanceGrade = nil
    end

    if self.effect_Right_EnhanceGrade then
        ReturnObjectToPool(self.effect_Right_EnhanceGrade, false)
        self.effect_Right_EnhanceGrade = nil
    end

    local func_Creat = function(transParent)
        if transParent == nil then
            return
        end

        local effectPath = EFFECT_WEAPON_STRENG["path"] ..data["name"]
        local objEffect = LoadPrefabFromPool(effectPath, transParent.gameObject,true)
        objEffect.gameObject.name = self.uiEnhanceGrade
        objEffect.gameObject:SetActive(true)
        objEffect.transform.localScale = data["scale"]
        objEffect.transform.localPosition = data["pos"]
        objEffect.transform.localEulerAngles = data["rotation"]
        return objEffect
    end

    self.effect_Left_EnhanceGrade = func_Creat(self.weaponPerfabTable[1])
    self.effect_Right_EnhanceGrade = func_Creat(self.weaponPerfabTable[2])
end

function WeaponUI:_UpdateImageWeapon(itemTypeData)
    if itemTypeData == nil then
        return
    end

    if self.objWeaponNode then
        self.objWeaponNode.gameObject:SetActive(true)
    end
    local itemImg = itemTypeData.ItemImg
    self:UpdateImageWeapon(itemImg)
    self:UpdateBoneFollower()
end

function WeaponUI:_UpdateOneHandWeapon(itemTypeData)
    if itemTypeData == nil then
        return
    end
    self:UpdatePerfabWeapon(itemTypeData.Model)
    self:UpdateBoneFollower()
end

function WeaponUI:ReturnWeaponToPool(weaponNode,bHide)
    local boneFollower = weaponNode.transform:GetComponent("BoneFollower")
    if boneFollower then 
        boneFollower.skeletonRenderer = nil
    end
    ReturnObjectToPool(weaponNode, false)
end

function WeaponUI:_UpdateTwohandedWeapons(itemTypeData)
    if itemTypeData == nil then
        return
    end

    local info = WEAPON_NODE[itemTypeData.ItemType]
    if info == nil then
        return
    end

    local count = info["Count"]
    local Node = info["Node"]
    if self.objSpine == nil then
        return
    end
    if self.weaponPerfabTable and #self.weaponPerfabTable == 0 then
        for index = 1, count do
            local weaponPerfab = self:CreateWeaponPerfab(self.objSpine)
            table.insert(self.weaponPerfabTable, weaponPerfab)
        end
    else
        for index = 1, count do
            self:ReturnWeaponToPool(self.weaponPerfabTable[index], false)
        end

        self.weaponPerfabTable = {}
         for index = 1, count do
            local weaponPerfab = self:CreateWeaponPerfab(self.objSpine)
            table.insert(self.weaponPerfabTable, weaponPerfab)
        end
    end

    for index = 1, count do
        local weaponPerfab = self.weaponPerfabTable[index]
        if weaponPerfab and self.skeletonRenderer and self.skeletonRenderer.skeleton:FindBone(Node[index]) then
            local boneFollower = weaponPerfab.transform:GetComponent("BoneFollower")
            if boneFollower == nil then
                boneFollower = weaponPerfab.gameObject:AddComponent(typeof(CS.Spine.Unity.BoneFollower))
            end
            if boneFollower then 
                boneFollower.followLocalScale = false
                boneFollower.enabled = true
                boneFollower.skeletonRenderer = self.skeletonRenderer
                boneFollower:SetBone(Node[index])
            end
        end
    end
end



return WeaponUI