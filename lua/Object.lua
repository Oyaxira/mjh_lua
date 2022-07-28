Object = class("Object")

function Object:ctor(sPath,parent)
    self.prefabPath =sPath
    self.gameObject = LoadEffectAndInit(sPath,parent) -- 特效均添加到角色层
    if self.gameObject == nil then 
        dprint("object is nil!" .. sPath)
        return
    end
    self.transform = self.gameObject.transform
    self.SkeletonAnimation = self.gameObject:GetComponent("SkeletonAnimation")
    if self.SkeletonAnimation then 
        self.SkeletonRenderSeparator = self.gameObject:GetComponent("SkeletonRenderSeparator")
        self.type = "spine"
    else
        self.ParticleSystem = self.gameObject:GetComponent("ParticleSystem")
        if self.ParticleSystem then 
            self.ParticleSystemRenderer = self.gameObject:GetComponent("ParticleSystemRenderer")
            self.type = "particle"
        else
            self.SpriteRenderer = self.gameObject:GetComponent("SpriteRenderer")
            if self.SpriteRenderer then 
                self.type = "sprite"
            end
        end
    end
    self.SortingGroup = self.gameObject:GetComponent("SortingGroup")
    if self.SortingGroup == nil then 
        self.SortingGroup = self.gameObject:AddComponent(typeof(DRCSRef.SortingGroup))
    end
    if self.type == nil then 
        dprint("object type is error!" .. sPath)
    end
    self.flipX = 1
    
end

function Object:InitFailed()
    if self.gameObject == nil then 
        return true
    end 
end
function Object:SaveScale()
    self.scaleInit = self.transform.localScale 
    self.eulerAnglesInit = self.transform.eulerAngles 
end
function Object:RestoreScale()
    self.flipX = 1
    self.transform.localScale = self.scaleInit
    self.transform.eulerAngles = self.eulerAnglesInit
end
function Object:Destroy()
    if self.gameObject then 
        DRCSRef.ObjDestroy(self.gameObject)
        self.gameObject = nil
    end
end

function Object:SetPostion(WorldX,WorldY,WorldZ)
    if self.transform then 
        self.transform.localPosition = DRCSRef.Vec3(WorldX or 0,WorldY or 0,WorldZ or 0)
    end
end

function Object:GetPositionZ()
    return self.transform.localPosition.z
end
function Object:GetPositionY()
    return self.transform.localPosition.y
end
function Object:GetPositionX()
    return self.transform.localPosition.x
end

function Object:GetType()
    return self.type
end

function Object:SetSortingOrder_spine(layer)
    if self.SkeletonRenderSeparator then
        local iCount = self.SkeletonRenderSeparator.partsRenderers.Count - 1
        for i = 0,iCount do
            self.SkeletonRenderSeparator.partsRenderers[i].MeshRenderer.sortingOrder = layer + i     
        end
    elseif self.SkeletonAnimation then
        self.gameObject:GetComponent("MeshRenderer").sortingOrder = layer
    end
end

function Object:SetSortingOrder_sprite(layer)
    if self.SpriteRenderer then 
        self.SpriteRenderer.sortingOrder = layer
    end
end

function Object:SetSortingOrder_particle(layer)
    if self.ParticleSystem then 
        self.ParticleSystemRenderer.sortingOrder = layer
    end
end

function Object:SetSortingOrder(layer)
    if self.SortingGroup then 
        self.SortingGroup.sortingOrder = layer
    elseif self.type then 
        self['SetSortingOrder_' .. self.type](self,layer)
    end
end

function Object:FollowerBone(boneName,skeletonRenderer)
    if self.gameObject == nil or boneName == nil then return end
    local boneFollower = self.gameObject:GetComponent("BoneFollower")   
    if boneFollower == nil then 
        boneFollower = self.gameObject:AddComponent(typeof(CS.Spine.Unity.BoneFollower))
    end
    if skeletonRenderer then 
        if skeletonRenderer.skeleton:FindBone(boneName) then 
            boneFollower.skeletonRenderer = skeletonRenderer
            boneFollower.followSkeletonFlip = true
        end
        boneFollower.boneName = boneName
    end
end

function Object:SetFollowerBoneNotFilp(boneName,skeletonRenderer)
    if self.gameObject == nil or boneName == nil then return end
    local boneFollower = self.gameObject:GetComponent("BoneFollower")   
    if boneFollower and skeletonRenderer then 
        if skeletonRenderer.skeleton:FindBone(boneName) then 
            boneFollower.followSkeletonFlip = false
            boneFollower.followBoneRotation = false
        end
    end
end

function Object:AddTrail(time, distance, matpath, startWidth, endWidth, startColor,endColor)
    if self.gameObject == nil then return end
    local trail = self.gameObject:GetComponent("TrailRenderer")
    if not trail then
        trail = self.gameObject:AddComponent("TrailRenderer")
    end

    trail.time = time or 0.5
    trail.minVertexDistance = distance or 0.1
    matpath = matpath or "Effect/Tex/Materials/chongjibo00_a"
    local material = LoadPrefab(matpath, typeof(CS.UnityEngine.Material))
    if material then
        trail.materials[0] = material
    end

    trail.startColor = startColor or COLOR_VALUE.Red
    trail.endColor = endColor or COLOR_VALUE.Red
    trail.startWidth = startWidth or 0.5
    trail.endWidth = endWidth or 0.1
end

function Object:SetTimeScale_spine(timeScale)
    if self.SkeletonAnimation then 
        self.SkeletonAnimation.timeScale = timeScale
    end
end

function Object:SetTimeScale_particle(timeScale)
    self['SetTimeScale_' .. self.type](self,timeScale)
end

function Object:Scale(x)
    if x then 
        local scale = self.transform.localScale
        self.transform.localScale = DRCSRef.Vec3(scale.x * x * self.flipX,scale.y * x,scale.z)
    end
end

function Object:SetScale(x)
    if x then 
        self.transform.localScale = DRCSRef.Vec3(x,x,1)
    end
end

function Object:ScaleXY(x,y,time)
    if self.transform == nil then return end
    self.transform:DR_DOScaleX(x,time)
    self.transform:DR_DOScaleY(y,time)
end

function Object:MoveXY(x,y,time)
    if self.transform == nil then return end
    local tweenerX,tweenerY
    if x then 
        tweenerX = self.transform:DOLocalMoveX(x,time)
    end
    if y then 
        tweenerY = self.transform:DOLocalMoveY(y,time)
    end
    return tweenerX,tweenerY
end

function Object:FlipX()
    if self.flipX ~= -1 then 
        self.flipX = -1
        self:Scale(1)
        self.transform.eulerAngles = self.transform.eulerAngles * -1
    end
end

function Object:NoFlipX()
    if self.flipX == -1 then 
        self:Scale(1)
        self.flipX = 1
        self.transform.eulerAngles = self.transform.eulerAngles * -1
    end
end

function Object:FlipY()

end

function Object:PlayAnimation_spine(name,loop,trackTime)
    local waitTime = getActionFrameTime(self.prefabPath,name)
    if waitTime == 0 then return end
    if self.SkeletonAnimation then 
        loop = loop or false
        -- self.SkeletonAnimation:ClearState()
        -- self.SkeletonAnimation.AnimationName = name
        local track = self.SkeletonAnimation.AnimationState:SetAnimation(0,name,loop)
        if trackTime then
            track.TrackTime = trackTime
        end
    end
end

function Object:PlayAnimation_particle(name,loop,trackTime)
    if self.ParticleSystem then 
        if trackTime and trackTime ~= 0 then 
            self.ParticleSystem:Simulate(trackTime,true,false)
        else
            self.ParticleSystem:Play()
        end
    end
end

function Object:PlayAnimation(name,loop,trackTime)
    if self.type then 
        self['PlayAnimation_' .. self.type](self,name,loop,trackTime)
    end
end

function Object:SetActive(boolean_active)
    if IsValidObj(self.gameObject) then 
        self.gameObject:SetActive(boolean_active)
    end
end

function Object:Rotate(int_z)
    self.transform:Rotate(DRCSRef.Vec3(0,0,int_z))
end


function Object:SetRotate(int_z)
    self.transform.eulerAngles = DRCSRef.Vec3(0,0,int_z)
end

function Object:GetPlayTime(name)
    if self.type then 
        return self['GetPlayTime_' .. self.type](self,name)
    end
    return 0
end
function Object:GetPlayTime_spine(name)
    return getActionFrameTime(self.prefabPath,name)
end

function Object:GetPlayTime_particle(name)
    if self.ParticleSystem then 
        return self.ParticleSystem.main.duration * 1000
    end
    return 0
end