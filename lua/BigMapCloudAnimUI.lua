BigMapCloudAnimUI = class("BigMapCloudAnimUI",BaseWindow)

function BigMapCloudAnimUI:Create()
	local obj = LoadPrefabAndInit("Game/BigMapCloudAnimUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BigMapCloudAnimUI:ctor()
	
end

function BigMapCloudAnimUI:RefreshUI(isOpenAnim)
	if isOpenAnim == true then
		self.objAnimation:PlayBack("cloud_move")
	elseif isOpenAnim == false then
		self.objAnimation:DR_Play("cloud_move")
	end
end

function BigMapCloudAnimUI:Init()
	self.objAnimation = self._gameObject:GetComponent("Animation")
end

function BigMapCloudAnimUI:Update()
	if self.objAnimation.isPlaying == false then
		RemoveWindowImmediately("BigMapCloudAnimUI")
	end
end

return BigMapCloudAnimUI