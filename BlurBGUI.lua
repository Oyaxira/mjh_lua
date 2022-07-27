BlurBGUI = class("BlurBGUI",BaseWindow)

-- 由外部创建好窗口，然后，需要自己调用 Init
function BlurBGUI:ctor()
end

function BlurBGUI:Create()
	local obj = LoadPrefabAndInit("CommonUI/BlurBGUI", UI_UILayer, true)
	if obj then
		self:SetGameObject(obj)
	end
end


function BlurBGUI:Init()
	self.UI_BlackBG = DRCSRef.FindGameObj("UILayerRoot/DontChange")

	self.comUIEffect = self._gameObject:GetComponent("UIEffect")
	self.comBlurBGImg = self._gameObject:GetComponent("Image")
	self.objBlack = self:FindChild(self._gameObject, "Black")

	self.objBackgroundEffect = self:FindChild(self._gameObject,"BackgroundEffectUI")
	MapEffectManager:GetInstance():InitBackgroundEffect(self.objBackgroundEffect)

	if (MSDK_OS == 2) then
		local comBlur = self._gameObject:GetComponent("CommandBufferBlur")
		if (comBlur) then
			comBlur.enabled = false
		end

		self.comBlurBGImg.color = COLOR_VALUE[COLOR_ENUM.White]
	end
end
function BlurBGUI:OnEnable()
	local comBlur = self._gameObject:GetComponent("CommandBufferBlur")
	if MSDK_OS ~= 2 and  comBlur and comBlur.isFade then 
		comBlur.isFade=false		
	end
end
function BlurBGUI:ScaleAndBlurAnim()
	local comBlur = self._gameObject:GetComponent("CommandBufferBlur")
	if MSDK_OS ~= 2 and comBlur then 
		comBlur:OnEnable()
		comBlur.isFade=true

		local endLevel=0.5
		local curLevel=0

		self.twnBlur = DRCSRef.DOTween.To(function(iCurValue)
			if comBlur then
				comBlur.blurLevel=iCurValue
				comBlur:SetCommandBuffer()
			end
		end, curLevel, endLevel, 3*1/comBlur.fadeSpeed)

	end

	-- self._gameObject.transform:DOScale(DRCSRef.Vec3(1.12,1.12,1),0.4):From():SetEase(DRCSRef.Ease.OutSine)

end
function BlurBGUI:RefreshUI()
	if not self._gameObject then
		return
	end

    if not self.comBlurBGImg then
        return
	end
	
	self._gameObject:SetActive(true)
	if self.UI_BlackBG then
		self.UI_BlackBG.gameObject:SetActive(false)
	end

	if IsBattleSceneReady() then
		self._gameObject:SetActive(false)
		return
	end

	if not self.objBackgroundEffect.activeSelf then
		self.objBackgroundEffect:SetActive(true)
	end
	MapEffectManager:GetInstance():UpdateBackgroundEffect(self.objBackgroundEffect)

	local blackBackgroundUI = GetUIWindow('BlackBackgroundUI')
	if MSDK_OS ~= 2 and blackBackgroundUI and blackBackgroundUI:IsShow() then
		self.comBlurBGImg.color = COLOR_VALUE[COLOR_ENUM.Black]
		if self.comUIEffect then
			self.comUIEffect.enabled = false
		end
		return
	else
		self.comBlurBGImg.color = COLOR_VALUE[COLOR_ENUM.White]
	end

	-- 漫画
	local comicPlotUI = GetUIWindow('ComicPlotUI')
	if comicPlotUI and comicPlotUI:IsShow() then 
		if self.comUIEffect then
			self.comUIEffect.enabled = false
		end
		local bgImg = BlurBackgroundManager:GetInstance():GetBgImg()
		if bgImg ~= nil then 
			self.comBlurBGImg.sprite = GetSprite(bgImg)
		end

		self.objBackgroundEffect:SetActive(false)
		return 
	end
	
	-- 显示临时背景
	local tempBGInfo = BlurBackgroundManager:GetInstance():GetTempBackgroundInfo()
	if tempBGInfo then
		if tempBGInfo.bIsBigMap == true then
			self:ShowBigMapBG()
		elseif tempBGInfo.uiMapTypeID and tempBGInfo.uiMapTypeID ~= 0 then
			self:ShowNormalMapBG(tempBGInfo.uiMapTypeID)
		elseif tempBGInfo.uiMazeTypeID and tempBGInfo.uiMazeTypeID ~= 0 then
			self:ShowMazeBG(nil, tempBGInfo.uiMazeTypeID)
		end
		return
	end

	-- 查找游戏状态结束记录
	local gameStateEndRecord = ShowDataRecordManager:GetInstance():GetEndRecord(SDRT_GAMESTATE, 0)
	if gameStateEndRecord then
		local eGameState = gameStateEndRecord.value1
		if eGameState == GS_BIGMAP then		-- 大地图状态
			self:ShowBigMapBG()
			return
		elseif eGameState == GS_NORMALMAP then		        -- 普通地图状态
			local mapTypeID = gameStateEndRecord.value2
			self:ShowNormalMapBG(mapTypeID)
			return
		elseif eGameState == GS_MAZE then		 -- 迷宫状态
			local mazeID = gameStateEndRecord.value2
			self:ShowMazeBG(mazeID)
			return
		end
	end
	
	-- 当前游戏状态
    local info = globalDataPool:getData("GameData") or {}
    local curState = info['eCurState']
	if (curState == GS_NORMALMAP) then              -- 普通地图状态
		local mapID = MapDataManager:GetInstance():GetCurMapID()
		self:ShowNormalMapBG(mapID)
	elseif (curState == GS_MAZE) then               -- 迷宫状态
		local curMazeID = MazeDataManager:GetInstance():GetCurMazeID()
		self:ShowMazeBG(curMazeID)
	elseif (curState == GS_BIGMAP) then             -- 大地图状态
		self:ShowBigMapBG()
	else
		if self.comUIEffect then
			self.comUIEffect.enabled = false
		end
		local bgImg = BlurBackgroundManager:GetInstance():GetBgImg()
		if bgImg ~= nil then 
			self.comBlurBGImg.sprite = GetSprite(bgImg)
		end

		self.objBackgroundEffect:SetActive(false)
	end

	-- if self.bshowBlur then
	-- 	self.bshowBlur = false
	-- 	self:GradientBlur()
	-- end
end

function BlurBGUI:ShowBigMapBG()
	if not IsWindowOpen("TileBigMap") and ClanDataManager:GetInstance():GetTiGuanState() == 0 then
		OpenWindowImmediately("TileBigMap")
	end
	self._gameObject:SetActive(false)
end

function BlurBGUI:ShowNormalMapBG(mapTypeID)
	local mapData = nil

	if mapTypeID and mapTypeID ~= 0 then
		mapData = TableDataManager:GetInstance():GetTableData("Map",mapTypeID)
	end
	if mapData then
		local sceneBG = mapData.SceneImg
		local mapAttrChange = MapDataManager:GetInstance():GetMapAttrChange(mapTypeID)
		if (mapAttrChange ~= nil and mapAttrChange.SceneImg ~= nil and mapAttrChange.SceneImg ~= "" and mapAttrChange.SceneImg ~= "-") then
			sceneBG = mapAttrChange.SceneImg
		end

		if sceneBG then 
			self:SetBlurBGImg(GetSprite(sceneBG))
			self._gameObject:SetActive(true)
		end	
	end
end

function BlurBGUI:ShowMazeBG(mazeID, mazeTypeID)
	if mazeID then
		local mazeArtData = MazeDataManager:GetInstance():GetMazeArtDataByID(mazeID)
		if type(mazeArtData) == 'table' and mazeArtData.BGImg ~= nil then 
			self:SetBlurBGImg(GetSprite(mazeArtData.BGImg))
		end
	elseif mazeTypeID then
		local mazeArtData = MazeDataManager:GetInstance():GetMazeArtDataByTypeID(mazeTypeID)
		if type(mazeArtData) == 'table' and mazeArtData.BGImg ~= nil then 
			self:SetBlurBGImg(GetSprite(mazeArtData.BGImg))
		end
	end
end

function BlurBGUI:SetBlurBGImg(sprite)
	if not(sprite) then
		return
	end

	if not(self.comBlurBGImg) then
		return
	end

	if self.comBlurBGImg.sprite ~= sprite then
		self.bshowBlur = true
		self.comBlurBGImg.sprite = sprite
	end
end

function BlurBGUI:OnDisable(timer)
	if self.UI_BlackBG then
		self.UI_BlackBG.gameObject:SetActive(true)
	end
end

function BlurBGUI:OnDestroy()
	MapEffectManager:GetInstance():DestroyBackgroundEffect(self.objBackgroundEffect)
end

function BlurBGUI:GradientBlur()
	--self.UI_BlackBG.gameObject:SetActive(false)
	--self.comBlurBGImg:SetMatGradientBlur("_KernelSize", 0, 15, 0.7);
end


return BlurBGUI
