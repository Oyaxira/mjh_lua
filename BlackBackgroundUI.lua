BlackBackgroundUI = class("BlackBackgroundUI",BaseWindow)

local showColor = DRCSRef.Color(0, 0, 0, 1)
local hideColor = DRCSRef.Color(0, 0, 0, 0)

function BlackBackgroundUI:ctor()
end

function BlackBackgroundUI:Create()
	local obj = LoadPrefabAndInit("EffectUI/BlackBackgroundUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BlackBackgroundUI:Init()
    self.comBlackImage = self:FindChildComponent(self._gameObject, "Black", "Image")
    self.objBackground = self:FindChild(self._gameObject, 'Background')
end

function BlackBackgroundUI:OnDestroy()
    self.isShow = false
end

function BlackBackgroundUI:RefreshUI(actionInfo)
    local isShow = actionInfo.isShow
    local duration = actionInfo.duration
    local waitAnimEnd = actionInfo.waitAnimEnd
    self:PlayAnim(isShow, duration, waitAnimEnd)
    self.isShow = isShow
end

function BlackBackgroundUI:PlayAnim(isShow, duration, waitAnimEnd)
    if g_skipAllUselessAnim then 
        duration = 0
    end
    local duration = duration / 1000
    if isShow then 
        if duration ~= 0 then 
            local tween = self.comBlackImage:DOFade(1, duration)
            if waitAnimEnd then 
                tween:OnComplete(DisplayActionEnd)
            end
        else
            if waitAnimEnd then 
                DisplayActionEnd()
            end
        end
    else
        local endCallback
        if waitAnimEnd then 
            endCallback = function()
                local blackBackgroundUI = GetUIWindow('BlackBackgroundUI')
                if blackBackgroundUI then 
                    blackBackgroundUI.isShow = false
                end
                RemoveWindowImmediately('BlackBackgroundUI')
                DisplayActionEnd()
            end
        else
            endCallback = function()
                local blackBackgroundUI = GetUIWindow('BlackBackgroundUI')
                if blackBackgroundUI then 
                    blackBackgroundUI.isShow = false
                end
                RemoveWindowImmediately('BlackBackgroundUI')
            end
        end
        if duration ~= 0 then 
            local tween = self.comBlackImage:DOFade(0, duration)
            tween:OnComplete(endCallback)
        else
            endCallback()
        end
    end
    if not waitAnimEnd then 
        DisplayActionEnd()
    end
end

function BlackBackgroundUI:IsShow()
    return self.isShow
end

function BlackBackgroundUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function BlackBackgroundUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

return BlackBackgroundUI