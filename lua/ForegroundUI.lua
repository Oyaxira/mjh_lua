ForegroundUI = class("ForegroundUI",BaseWindow)

function ForegroundUI:ctor()
end

function ForegroundUI:Create()
	local obj = LoadPrefabAndInit("EffectUI/ForegroundUI",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end


function ForegroundUI:Init()
	self.comforeground_Transform = self:FindChildComponent(self._gameObject, "foregroundList", "Transform")

	self.foregroundMap = {}

	DontDestroyWindow("ForegroundUI")
end

function ForegroundUI:OnDestroy()
	local comCameraEffect = UI_Camera:GetComponent("ForegroundEffect")
	if comCameraEffect then
		comCameraEffect.enabled = false
	end
end

local function ResetEffectRendererOrder(objEffect, order)
	if not objEffect then
		return
	end

	local comParticleSystemList = objEffect:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
	if comParticleSystemList then
		comParticleSystemList = ArrayToTable(comParticleSystemList)
		for index = 1, #comParticleSystemList do
			local comParticleSystem = comParticleSystemList[index]
			local comRenderer = comParticleSystem:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer))

			if comRenderer then
				comRenderer.sortingOrder = order
			end
		end
	end
end

function ForegroundUI:Update()
	-- 非剧本中直接移除前景
	if GetGameState() == -1 then
		self:Clear()
	end
end

local deltaTime = 1.0
function ForegroundUI:Clear()
	for index, objMapEffect in pairs(self.foregroundMap) do
			self:FadeOut(objMapEffect,nil,function()
					objMapEffect:SetActive(false) 
			end)
	end

	local TB_MapEffect = TableDataManager:GetInstance():GetTable("MapEffect")
	for id, mapEffectData in pairs(TB_MapEffect) do
		if mapEffectData["UIName"] and mapEffectData["UIName"] ~= "" then
			RemoveWindowImmediately(mapEffectData["UIName"])
		end
	end

	local comCameraEffect = UI_Camera:GetComponent("ForegroundEffect")
	if comCameraEffect then
		comCameraEffect.enabled = false
	end
end

local EffectMaxRateOverTime = {}
local SpriteMaxAlpha = {}
function ForegroundUI:FadeIn(objMapEffect,OnBeforeStartCallBack,OnFinishedCallBack)
	local particleSysParent = objMapEffect.transform:GetChild(0)
	for i = 0,particleSysParent.childCount-1 do
		local transform = particleSysParent:GetChild(i)
		local particleSys = transform:GetComponent("ParticleSystem")
		local kSpriteRenderer= transform:GetComponent("SpriteRenderer")

		if particleSys then
			local emission = particleSys.emission
			if not EffectMaxRateOverTime[transform] then
				EffectMaxRateOverTime[transform] = emission.rateOverTime.constant		
			end
			local maxRateOverTime = EffectMaxRateOverTime[transform]
			-- 开始前的回调
			if OnBeforeStartCallBack then
				OnBeforeStartCallBack()
			end
			CS_Coroutine.start(function()
				local rateOverTime = 0
				emission.rateOverTime = 0
				self.fadeState = "fadeIn"
				while maxRateOverTime>0 and rateOverTime<maxRateOverTime and self.fadeState == "fadeIn" do
					rateOverTime = rateOverTime + maxRateOverTime/FADEIN_TIME
					emission.rateOverTime = CS.UnityEngine.ParticleSystem.MinMaxCurve(rateOverTime)
					coroutine.yield(CS.UnityEngine.WaitForSeconds(deltaTime))
				end
				if maxRateOverTime>0 and rateOverTime >= maxRateOverTime and self.fadeState == "fadeIn"  then
					-- 完成时的回调
					if OnFinishedCallBack then
						OnFinishedCallBack()
					end
				end
			end)
		elseif kSpriteRenderer then
			local color = kSpriteRenderer.color
			if not SpriteMaxAlpha[transform] then
				SpriteMaxAlpha[transform] = color.a
			end
			local maxAlpha = SpriteMaxAlpha[transform]
			kSpriteRenderer.color = DRCSRef.Color(color.r,color.g,color.b,0)
			-- 开始前的回调
			if OnBeforeStartCallBack then
				OnBeforeStartCallBack()
			end
			CS_Coroutine.start(function()
				local alpha = 0
				self.fadeState = "fadeIn"
				while alpha<maxAlpha and self.fadeState == "fadeIn" do
					alpha = alpha + maxAlpha/FADEIN_TIME
					kSpriteRenderer.color = DRCSRef.Color(color.r,color.g,color.b,alpha)
					coroutine.yield(CS.UnityEngine.WaitForSeconds(deltaTime))
				end
				if alpha >= maxAlpha and self.fadeState == "fadeIn"  then
					kSpriteRenderer.color = DRCSRef.Color(color.r,color.g,color.b,maxAlpha)
					-- 完成时的回调
					if OnFinishedCallBack then
						OnFinishedCallBack()
					end
				end
			end)
		else
			-- 开始前的回调
			if OnBeforeStartCallBack then
				OnBeforeStartCallBack()
			end
			-- 完成时的回调
			if OnFinishedCallBack then
				OnFinishedCallBack()
			end
		end
	end
end

function ForegroundUI:FadeOut(objMapEffect,OnBeforeStartCallBack,OnFinishedCallBack)
	local particleSysParent = objMapEffect.transform:GetChild(0)
	for i = 0,particleSysParent.childCount-1 do
		local transform = particleSysParent:GetChild(i)
		local particleSys = transform:GetComponent("ParticleSystem")
		local kSpriteRenderer= transform:GetComponent("SpriteRenderer")
		if particleSys then
			local emission = particleSys.emission
			local maxRateOverTime = EffectMaxRateOverTime[transform]
			-- 开始前的回调
			if OnBeforeStartCallBack then
				OnBeforeStartCallBack()
			end
			CS_Coroutine.start(function()
				local rateOverTime = emission.rateOverTime.constant
				self.fadeState = "fadeOut"
				while rateOverTime > 0 and self.fadeState == "fadeOut" do
					rateOverTime = rateOverTime - maxRateOverTime/FADEOUT_TIME
					emission.rateOverTime = CS.UnityEngine.ParticleSystem.MinMaxCurve(rateOverTime)
					coroutine.yield(CS.UnityEngine.WaitForSeconds(deltaTime))
				end
				if maxRateOverTime > 0 and rateOverTime <= 0 and self.fadeState == "fadeOut"  then
					emission.rateOverTime = 0
					-- 完成时的回调
					if OnFinishedCallBack then
						OnFinishedCallBack()
					end
				end
			end)

		elseif kSpriteRenderer then
			local color = kSpriteRenderer.color
			local maxAlpha = SpriteMaxAlpha[transform]
			-- 开始前的回调
			if OnBeforeStartCallBack then
				OnBeforeStartCallBack()
			end
			CS_Coroutine.start(function()
				local alpha = color.a
				self.fadeState = "fadeOut"
				while alpha>0 and self.fadeState == "fadeOut" do
					alpha = alpha - maxAlpha/FADEOUT_TIME
					kSpriteRenderer.color = DRCSRef.Color(color.r,color.g,color.b,alpha)
					coroutine.yield(CS.UnityEngine.WaitForSeconds(deltaTime))
				end
				if alpha <= 0 and self.fadeState == "fadeOut"  then
					kSpriteRenderer.color = DRCSRef.Color(color.r,color.g,color.b,0)
					-- 完成时的回调
					if OnFinishedCallBack then
						OnFinishedCallBack()
					end
				end
			end)
		else
			-- 开始前的回调
			if OnBeforeStartCallBack then
				OnBeforeStartCallBack()
			end
			-- 完成时的回调
			if OnFinishedCallBack then
				OnFinishedCallBack()
			end
		end
	end
end

function ForegroundUI:RefreshUI(effectList)
	if not effectList then
		return
	end

	local sortingOrder = 500
	local cameraEffectMaterial = nil

	self:Clear()

	for index = 1, #effectList do
		mapEffectID = effectList[index]
		local mapEffectData = TableDataManager:GetInstance():GetTableData("MapEffect",mapEffectID)

		if mapEffectData then
			-- 预制体
			local objMapEffect = self.foregroundMap[mapEffectID]
			if not objMapEffect and mapEffectData["Prefab"] and mapEffectData["Prefab"] ~= "" then
				local prefabMapEffect = LoadPrefab(mapEffectData.Prefab, typeof(CS.UnityEngine.GameObject))
				if prefabMapEffect then
					objMapEffect = DRCSRef.ObjInit(prefabMapEffect, self.comforeground_Transform)
					--local particleSys = objMapEffect.transform:GetChild(0):GetChild(0):GetComponent("ParticleSystem")
					self:FadeIn(objMapEffect)
					self.foregroundMap[mapEffectID] = objMapEffect
				end
			end
			if objMapEffect then
				ResetEffectRendererOrder(objMapEffect, sortingOrder + index)
				self:FadeIn(objMapEffect,function() objMapEffect:SetActive(true) end)
			end

			-- 界面
			if mapEffectData["UIName"] and mapEffectData["UIName"] ~= "" then
				OpenWindowImmediately(mapEffectData["UIName"])
			end

			-- 相机效果
			if not cameraEffectMaterial then
				if mapEffectData.Material and mapEffectData.Material ~= "" then
					local material = LoadPrefab(mapEffectData.Material, typeof(CS.UnityEngine.Material))
					if material then
						cameraEffectMaterial = material
					end
				end
			end
		end

	end

	-- 显示相机效果
	local comCameraEffect = UI_Camera:GetComponent("ForegroundEffect")
	if  comCameraEffect then
		if cameraEffectMaterial then
			comCameraEffect.material = cameraEffectMaterial
			comCameraEffect.enabled = true
		else
			comCameraEffect.enabled = false
		end
	end
end

return ForegroundUI