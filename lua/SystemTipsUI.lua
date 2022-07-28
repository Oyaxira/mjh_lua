SystemTipsUI = class("SystemTipsUI",BaseWindow)

-- 现在没有缓存 只有一个
function SystemTipsUI:ctor()
	self.objTips_Text = nil
	self.iHideTimerIndex = 0
end

function SystemTipsUI:Create()
	local obj = LoadPrefabAndInit("TipsUI/SystemTipsUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SystemTipsUI:OnEnable()
	local function Hide()
		self:OnClick_BlackBG()
	end
	self.iHideTimerIndex = self:AddTimer(2000,Hide)
end

function SystemTipsUI:OnDisable()
	self:RemoveTimer(self.iHideTimerIndex)
end

function SystemTipsUI:Init()
	self.objTips_Text = self:FindChildComponent(self._gameObject,"Tips_Text","Text")

	local objBlack = self:FindChild(self._gameObject,"Black_BG")
	local function Hide()
		self:OnClick_BlackBG()
	end
	AddEventTrigger(objBlack.transform,Hide)
end

function SystemTipsUI:OnClick_BlackBG()
	RemoveWindowImmediately("SystemTipsUI",true)
end

function SystemTipsUI:RefreshUI(info)
	local sTips = info and info or self.info
	self.objTips_Text.text = sTips 
end

function SystemTipsUI:OnDestroy()
	
end

return SystemTipsUI