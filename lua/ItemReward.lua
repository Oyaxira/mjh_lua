ItemReward = class("ItemReward", ItemIconUINew)

function ItemReward:Create(kParent)
	local obj = LoadPrefabAndInit("Game/ItemReward",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end


return ItemReward