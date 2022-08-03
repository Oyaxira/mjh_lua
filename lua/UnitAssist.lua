UnitAssist = class("UnitAssist")
function UnitAssist:ctor()
    self.skeletonAnimation = nil
    self.SkeletonRenderSeparator = nil
    self.gameObject = nil
    self.transform = nil
    self.kUnitLifeBar = nil
end

function UnitAssist:OnDestroy()
end

function UnitAssist:Clear()
    if self.kUnitLifeBar then
        self.kUnitLifeBar:Clear()
    end

    if self.gameObject then
        ReturnObjectToPool(self.gameObject)
        self.gameObject = nil
    end

	for k, v in pairs(self) do
        self[k] = nil;
    end
end

function UnitAssist:Init(kParent,uiTypeID,bpet,camp,pos,uiLevel,depth,model)
    self.kParent = kParent
    self.uiTypeID = uiTypeID
    self.bpet = bpet
    self.uiModleID = model
    self.iCamp = camp
    self.uiLevel = uiLevel or 0
    if self.bpet > 0 then
        local petData = TableDataManager:GetInstance():GetTableData("Pet",self.uiTypeID)
        if petData then
            self.uiModleID = petData.ArtID
        end
    else
        if model == 0 then
            local roleData = TB_Role[uiTypeID]
            if roleData then
                self.uiModleID = roleData.ArtID
            end
        end
    end
    self:LoadSpineCharacter(pos[1],pos[2])
    self.kUnitLifeBar = UnitLifeBar.new()
    self.kUnitLifeBar:Init(self.skeletonAnimation)
    -- self.kUnitLifeBar:SetPercent_MP(1)
    -- self.kUnitLifeBar:SetPercent_HP(1)
    self.kUnitLifeBar:SetPetName(self:GetName(self.bpet))
    self.kUnitLifeBar:SetCamp(self.iCamp)
    self.kUnitLifeBar:HideLife(true)
    local baseDepth = depth
    self.SortingGroup.sortingOrder = baseDepth
    self.gameObject:GetComponent('MeshRenderer').sortingOrder = baseDepth
    self.kUnitLifeBar:SetDepth(baseDepth)
    self.transform.localScale = self.transform.localScale * 0.4
    self:fadeOutShaps(self.gameObject,1.5,false)
end

function UnitAssist:fadeOutShaps(shapeObj,fadeTime,fadeType)
    --头顶血条
    self.kUnitLifeBar:FadeOut(fadeTime,fadeType)
    --模型spine
    FadeInOutShaps(shapeObj,fadeTime,fadeType)
end

function UnitAssist:GetName(bpet)
    if bpet == 0 then
        local roleData = TB_Role[self.uiTypeID]
        if roleData then
            return GetLanguageByID(roleData.NameID)
        end
    else
        local petData = TableDataManager:GetInstance():GetTableData("Pet",self.uiTypeID)
        if petData then
            return GetLanguageByID(petData.NameID)
        end
    end
end

function UnitAssist:GetModelPath()
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
    return typeData and typeData.Model or "role_xiaobangzhu"
end


function UnitAssist:GetSkinPath()
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
    return typeData and typeData.Texture or "role_xiaobangzhu"
end

function UnitAssist:SetUnitAction(actionName,loop)
	if loop == nil then
		loop = false
    end
	if self.skeletonAnimation == nil or self.skeletonAnimation.AnimationState == nil or not IsValidObj(self.skeletonAnimation.gameObject) then
        return
    end
    self.skeletonAnimation.AnimationState:SetAnimation(0, actionName, loop)
    if self._idleAnim then 
        self.skeletonAnimation.AnimationState:AddAnimation(0,self._idleAnim,true,0)
    end
end

function UnitAssist:SetIdle(actionName)
    self._idleAnim = actionName
	if self.skeletonAnimation == nil or self.skeletonAnimation.AnimationState == nil or not IsValidObj(self.skeletonAnimation.gameObject) then
        return
    end
    self.skeletonAnimation.AnimationState:SetAnimation(0, actionName, true)
end

function UnitAssist:LoadSpineCharacter(gridX,gridY)
    local strPath = self:GetModelPath()
    if not IsValidObj(self.kParent) then
        dprint("kParent is nil")
        return
    end

    self.kParent:SetActive(true)

    self.gameObject = LoadSpineFromPool(strPath,self.kParent)
    if self.gameObject == nil then
        dprint("load "..strPath.."is nil")
        self.uiModleID = 35
        self.gameObject = LoadSpineFromPool("role_nan",self.kParent)
    end
    self.gameObject_Texture = ChnageSpineSkin(self.gameObject, self:GetSkinPath())
    
    self.transform = self.gameObject.transform
    if self.iCamp == SE_CAMPB then 
        gridX = gridX + 4
    end
    self.transform.localPosition = GetAssistPosByGrid(gridX,gridY,1)
    self.skeletonAnimation = self.gameObject:GetComponent("SkeletonAnimation")
    self.SkeletonRenderSeparator = self.gameObject:GetComponent("SkeletonRenderSeparator");
    self.SortingGroup = self.gameObject:GetComponent("SortingGroup");
    if self.SortingGroup == nil then 
        self.SortingGroup = self.gameObject:AddComponent(typeof(DRCSRef.SortingGroup))
    end

    self.gameObject.layer = 9
    local iNum = self.transform.childCount
	for i = 0, iNum -1  do
		local kChild = self.transform:GetChild(i)
		kChild.gameObject.layer = 9
    end

    self.skeletonAnimation.loop = false
    if self.bpet then
        self:SetIdle(ROLE_SPINE_DEFAULT_ANIM)
    else
        self:SetIdle(SPINE_ANIMATION.BATTLE_IDEL)
    end
    if self.iCamp == SE_CAMPB then
        self.skeletonAnimation.skeleton.ScaleX = -1;
    else
        self.skeletonAnimation.skeleton.ScaleX = 1;
    end
end
