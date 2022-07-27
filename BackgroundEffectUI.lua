BackgroundEffectUI = class("BackgroundEffectUI",BaseWindow)

-- 不要手动创建,通过MapEffectManager:InitBackgroundEffect
function BackgroundEffectUI:ctor(obj)
	self:SetGameObject(obj)
    self:Init()
end

function BackgroundEffectUI:Init()
	self.comContent_Transform = self._gameObject.transform

	self.effectObjsDict = {}
end

function BackgroundEffectUI:Clear()
	for index, objMapEffect in pairs(self.effectObjsDict) do
		objMapEffect:SetActive(false)
	end
end

function BackgroundEffectUI:UpdateEffect(effectList)
	local effectShowFlag = {}
	for mapEffectID, objMapEffect in pairs(self.effectObjsDict) do
		effectShowFlag[mapEffectID] = false
	end

	if effectList then
		for index ,mapEffectID in ipairs(effectList) do
			effectShowFlag[mapEffectID] = true
			local objMapEffect = self.effectObjsDict[mapEffectID]

			if not objMapEffect then
				local mapEffectData = TableDataManager:GetInstance():GetTableData("MapEffect",mapEffectID)
				if mapEffectData then
					-- 预制体
					local objMapEffect = self.effectObjsDict[mapEffectID]
					if not objMapEffect and mapEffectData.BackgroundPrefab and mapEffectData.BackgroundPrefab ~= "" then
						local prefabMapEffect = LoadPrefab(mapEffectData.BackgroundPrefab, typeof(CS.UnityEngine.GameObject))
						if prefabMapEffect then
							objMapEffect = DRCSRef.ObjInit(prefabMapEffect, self.comContent_Transform)
							self.effectObjsDict[mapEffectID] = objMapEffect
						end
					end
				end
			end
			
		end
	end

	for mapEffectID, objMapEffect in pairs(self.effectObjsDict) do
		if effectShowFlag[mapEffectID] ~= objMapEffect.activeSelf then
			objMapEffect:SetActive(effectShowFlag[mapEffectID])
		end
	end
end

return BackgroundEffectUI