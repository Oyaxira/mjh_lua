EffectMgr = class("EffectMgr")
EffectMgr._instance = nil
function EffectMgr:ctor()
    self.objActorChooseEffect = {} -- 当前选择角色 脚下特效 静态的
end

function EffectMgr:GetInstance()
    if EffectMgr._instance == nil then
        EffectMgr._instance = EffectMgr.new()
        EffectMgr._instance:BeforeInit()
    end
    return EffectMgr._instance
end

function EffectMgr:BeforeInit()

end

function EffectMgr:InitEffect()
    self.objActorChooseEffect[SE_CAMPA] = DRCSRef.FindGameObj("frames_self_choose")
    if IsValidObj(self.objActorChooseEffect[SE_CAMPA]) then
        local comSpriteRenderer = self.objActorChooseEffect[SE_CAMPA]:GetComponent("SpriteRenderer")
        if comSpriteRenderer then
            comSpriteRenderer.sortingOrder = 7
        end
    end

    self.objActorChooseEffect[SE_CAMPA]:SetActive(false)
    self.objActorChooseEffect[SE_CAMPB] = DRCSRef.FindGameObj("frames_enemy_choose")
    self.objActorChooseEffect[SE_CAMPB]:SetActive(false)
end

function EffectMgr:Clear()
    self.objActorChooseEffect[SE_CAMPA] = nil
    self.objActorChooseEffect[SE_CAMPB] = nil
end

function EffectMgr:SetActorChooseEffectPos(gridX,gridY,iCamp)
    if iCamp == nil or iCamp == 0 then return end
    if iCamp == SE_CAMPC then iCamp = SE_CAMPA end
    self.objActorChooseEffect[iCamp].transform.localPosition = GetPosByGrid(gridX,gridY)
end

function EffectMgr:SetActorChooseEffecVisible(iCamp,bShow)
    if iCamp == nil or iCamp == 0 then return end
    if iCamp == SE_CAMPC then iCamp = SE_CAMPA end
    self.objActorChooseEffect[iCamp]:SetActive(bShow)
end

function EffectMgr:OnDestroy()
    self:Clear()
end

--残影表现
function EffectMgr:addCanYing(objA,objB,endPos,canying,disable, sameTargetTimes, onComplete)
    if not objA or (not objB and not endPos) then
        return nil
    end

    local srcPos = endPos or objB and objB.transform.localPosition
    objA:addSkeletonGhost(canying)
    local factor = canying and canying.speedfactor or 1

    local twn = objA.transform:DOLocalMove(srcPos, SPEND_TIME_CANYING_F * factor):SetEase(DRCSRef.Ease.Linear):OnComplete(function()
        if disable then
            objA:disableSkeletonGhost()
        end

        if onComplete then
            onComplete()    
        end
    end)
    return twn
end