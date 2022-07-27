RewardItemIconUI = class("RewardItemIconUI", ItemIconUINew)



function RewardItemIconUI:Create(kParent)
	local obj = LoadPrefabAndInit("TownUI/RewardItemIconUI",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end


return RewardItemIconUI