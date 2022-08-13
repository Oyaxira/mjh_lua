ToptitleUI = class("ToptitleUI",BaseWindow)
local dkJson = require("Base/Json/dkjson")
local TDM = require("UI/TileMap/TileDataManager")

function ToptitleUI:ctor()

end

function ToptitleUI:Create()
	local obj = LoadPrefabAndInit("Game/ToptitleUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ToptitleUI:Init()
	
	self.objNavLabel = self:FindChild(self._gameObject, "TransformAdapt_node_left/Nav_Label")
	self.objTips = self:FindChild(self._gameObject, "TransformAdapt_node_left/Nav_Label/Tips")
	self.comNavLabelText = self:FindChildComponent(self.objNavLabel,"Text","Text")
	self.comCityRoleListBtn = self:FindChildComponent(self.objNavLabel,"chengzhenBtn","DRButton")
	self.comUIAction = self:FindChildComponent(self.objNavLabel,"chengzhenBtn","LuaUIAction")
	self.objChengZhenNormal = self:FindChild(self.objNavLabel,"chengzhenBtn/chengzhenNormal")
	self.objChengZhenHover = self:FindChild(self.objNavLabel,"chengzhenBtn/chengzhenHover")
	if self.comCityRoleListBtn then
		self:AddButtonClickListener(self.comCityRoleListBtn,function()
			if IsWindowOpen("MazeUI") or IsWindowOpen("TileBigMap") then
				return
			end
			local win = GetUIWindow("CityRoleListUI")
			if not IsWindowOpen("CityRoleListUI") then
				OpenWindowImmediately("CityRoleListUI")
			end
			if win then
				win:OnClick_Button()
			end
		end)
	else
		derror("not found comCityRoleListBtn")
	end
	if self.comUIAction then
		self.comUIAction:SetPointerEnterAction(function()
			if IsWindowOpen("MazeUI") or IsWindowOpen("TileBigMap") or GetCurScriptID() == 1 then	--大地图或者宇文庄剧本中不显示tips
				return
			end
			self.objTips:SetActive(true)
			self.objChengZhenNormal:SetActive(false)
			self.objChengZhenHover:SetActive(true)
		end)
		self.comUIAction:SetPointerExitAction(function()
			self.objTips:SetActive(false)
			self.objChengZhenNormal:SetActive(true)
			self.objChengZhenHover:SetActive(false)
		end)
		
	end
	self.objDataPanel = self:FindChild(self._gameObject,"TransformAdapt_node_left/DataPanel")
	-- 日历部分
	self.objDate = self:FindChild(self._gameObject,"TransformAdapt_node_left/DataPanel/Date")
	-- shane部分
	self.comShaneText = self:FindChildComponent(self.objDataPanel,"Shane/Text","Text")
	--self.comShaneBtn = self:FindChildComponent(self.objDataPanel,"Shane/DRButton","DRButton")
	self.comShaneUIAction = self:FindChildComponent(self.objDataPanel,"Shane","LuaUIAction")
	self.objShaneTips = self:FindChild(self.objDataPanel,"Shane/Text/Tips")
	local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData then 
        self.comShaneText.text = mainRoleData["iGoodEvil"] or 0
    else
        self.comShaneText.text = 0
    end
	if self.comShaneUIAction and self.objShaneTips then
		self.comShaneUIAction:SetPointerEnterAction(function()
			self.objShaneTips:SetActive(true)
		end)

		self.comShaneUIAction:SetPointerExitAction(function()
			self.objShaneTips:SetActive(false)
		end)
	end
	self.comTongBiText = self:FindChildComponent(self.objDataPanel,"TongBi/Text","Text")
	--self.comTongBiBtn = self:FindChildComponent(self.objDataPanel,"TongBi/DRButton","DRButton")
	self.comTongBiUIAction = self:FindChildComponent(self.objDataPanel,"TongBi","LuaUIAction")
	self.objTongBiTips = self:FindChild(self.objDataPanel,"TongBi/Text/Tips")
	local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        self.comTongBiText.text = PlayerSetDataManager:GetInstance():GetPlayerCoin()
    else
        self.comTongBiText.text = 0
    end
	if self.comTongBiUIAction and self.objTongBiTips then
		self.comTongBiUIAction:SetPointerEnterAction(function()
			self.objTongBiTips:SetActive(true)
		end)
		self.comTongBiUIAction:SetPointerExitAction(function()
			self.objTongBiTips:SetActive(false)
		end)
	end

	self.objDataAnim = self:FindChild(self.objDate, "anim")									-- 日期 Anim obj
	self.comDataAnim = self.objDataAnim:GetComponent("DOTweenAnimation")						-- 日期 Anim
	--self.objCalendarData = self:FindChild(self.objDate,"Data")
	--self.rectTransCalendarData = self.objCalendarData:GetComponent('RectTransform')
	self.objDateLabel = self:FindChild(self.objDate, "Text_date")							-- 日期 obj
	self.comDateLabel = self.objDateLabel:GetComponent("Text")									-- 日期 Text
	self.com_btn = self.objDate:GetComponent("Button")
	self.comDateUIAction = self.objDate:GetComponent("LuaUIAction")
	self.objDateTips = self:FindChild(self.objDate,"Text_date/Tips")
	local comDateTipsText = self:FindChildComponent(self.objDateTips,"Text","Text")
	local fun = function()
		if EvolutionShowManager:GetInstance():IsOpenEvolute() then
			EvolutionShowManager:GetInstance():HistoryShow()
		end
	end
	self:AddButtonClickListener(self.com_btn, fun)

	if self.comDateUIAction and self.objDateTips then
		self.comDateUIAction:SetPointerEnterAction(function()
			if EvolutionShowManager:GetInstance():IsOpenEvolute() then
				RefreshTipsText(comDateTipsText,"演化记录",FuncType.OpenOrCloseEvolutionUI)
				self.objDateTips:SetActive(true)
			end
		end)

		self.comDateUIAction:SetPointerExitAction(function()
			self.objDateTips:SetActive(false)
		end)
	end

    --self.objWeather = self:FindChild(self.DataPanel, "Weather/weather")
	--self.comWeather = self.objWeather:GetComponent("Image")				-- 天气 Spine
	self.objWeather = self:FindChild(self.objDataPanel, "Weather")
	self.objWeatherText = self:FindChild(self.objDataPanel, "Weather/Text")
	self.comWeatherText = self.objWeatherText:GetComponent("Text")		-- 天气 Text
	self.comButtonWeather = self:FindChildComponent(self.objDataPanel, "Weather/Button_Weather", "DRButton")		-- 天气 Button

	self:AddButtonClickListener(self.comButtonWeather, function()
		if self.weatherID and self.weatherID ~= 0 then
			local weatherData = TableDataManager:GetInstance():GetTableData("Weather",self.weatherID)
			if weatherData and weatherData.EffectDescID ~= 0 then
				local tips = {
					['title'] = GetLanguageByID(weatherData.NameID),
					['content'] = GetLanguageByID(weatherData.EffectDescID)
				}
				OpenWindowImmediately("TipsPopUI", tips)
			end
		end
	end)


	-- 门派好感度
	--self.objClanFavor = self:FindChild(self._gameObject, "clan_favor_box")
	self.objClanFavor = self:FindChild(self._gameObject, "TransformAdapt_node_left/DataPanel/FavorBox")
	self.objDisposition = self:FindChild(self.objClanFavor, "Favor")
	self.comDispositionText = self.objDisposition:GetComponent('Text')
	-- self.comDisposition = self.objDisposition:GetComponent("Text")

	self.objDescription = self:FindChild(self._gameObject,"clan_favor_box/Level")
	self.objDescription:SetActive(false)
	self.comDescriptionText = self:FindChildComponent(self._gameObject, "clan_favor_box/Level",'Text')
	-- self.comDescription = self.objDescription:GetComponent("Text")

	self.objBackButton = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_back")
	self.comBackButton = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/Button_back","Button")
	self.comBackButtonText = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/Button_back/Text","Text")
	self.objBackButtonArrowMark = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_back/Mark/Arrow")
	self.objBackButtonReturnBigMapMark = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_back/Mark/Bigmap")
	self.objBackButtonExitMazeMark = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_back/Mark/Exit")
	self.objBackButtonBackMark = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_back/Mark/Back")

	-- 分享宝藏
	self.objShareTreasure = self:FindChild(self._gameObject, "TransformAdapt_node_left/TreasureShare")

	self:AddEventListener("UPDATE_CURRENT_MAP", function() 
		self:RefreshUI()
	end)
	self:AddEventListener("UPDATE_MAZE_DATA", function() 
		self:RefreshUI()
	end)
	self:AddEventListener("UPDATE_MAIL_DATA", function()
		self:RefreshUI()
	end)

	self:InitTreasureReceiveCount()
end

function ToptitleUI:OnEnable()
	self:AddEventListener("UPDATE_MAIN_ROLE_INFO",function()
		self:RefreshUIImmediately()
	end)
end

function ToptitleUI:OnDisable()
	self:RemoveEventListener("UPDATE_MAIN_ROLE_INFO")
end

function ToptitleUI:OnDestroy()
end
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local l_EvolutionKey = "t"
function ToptitleUI:Update()
	if IsNotInGuide() and not IsWindowOpen("TaskUI") and GetKeyDownByFuncType(FuncType.OpenOrCloseEvolutionUI) and not IsWindowOpen("DialogRecordUI") 
	and not IsWindowOpen("CharacterUI") then
		if IsWindowOpen("EvolutionUI") then
			local winUI = GetUIWindow("EvolutionUI")
			if winUI then
				winUI.comClose_Button.onClick:Invoke()
			end
		else
			self.com_btn.onClick:Invoke()
		end
	end


	if self.bNeedUpdate then 
		self:RefreshUIImmediately()
	end
end

function ToptitleUI:PlayTongbiAnim(before, after)
	self.comTongBiText.text = before   -- 初始化
    local tween = Twn_Number(nil, self.comTongBiText, before, after, 1, 0.3, function ()
		self.comTongBiText.text = after  
	end)
end

function ToptitleUI:OnPressESCKey()
	local wins = {
		"PlayerSetUI",
		"TaskUI",
		"DialogRecordUI",
		"CharacterUI",
		"GeneralBoxUI",
		"StoreUI",
		"ShowAllChooseGoodsUI",
		"StorageUI",
		"ForgeUI",
		"ClanMartialUI",
		"CollectionUI",
		"ClanUI",
		"ClanCardUI",
		"RoleEmbattleUI"
	}
    if self.objBackButton.activeSelf and self.comBackButton and not IsAnyWindowOpen(wins) then
	    self.comBackButton.onClick:Invoke()
    end
end

function ToptitleUI:RefreshUI(toptitleType)
	if toptitleType ~= nil then 
		self.toptitleType = toptitleType
	end
	self.bNeedUpdate = true
end

function ToptitleUI:RefreshUIImmediately()
	self:UpdateResource()
	self:UpdateNavLabel()
	self:UpdateBackButton()
	self:UpdateCalendar()
	self:UpdateWeather()
	self:UpdateTreasureShare()
	self:ReBuildDateDataUI()
	self.bNeedUpdate = false
end

function ToptitleUI:UpdateResource()
	--刷新仁义值
	local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData then 
        self.comShaneText.text = mainRoleData["iGoodEvil"] or 0
    else
        self.comShaneText.text = 0
    end
	--刷新铜币
	local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        self.comTongBiText.text = PlayerSetDataManager:GetInstance():GetPlayerCoin()
    else
        self.comTongBiText.text = 0
    end

end

function ToptitleUI:NeedRefresh(toptitleType)
	if self.toptitleType ~= toptitleType then 
		return true
	end
	-- TODO: 检查是否需要更新
	return false
end

function ToptitleUI:UpdateCalendar()
	-- 更新日历
	self.objDataAnim:SetActive(false)
	local iYear,iMonth,iDay,iHour = EvolutionDataManager:GetInstance():GetRivakeTimeYMD()
	self.comDateLabel.text = EvolutionDataManager:GetInstance():GetLunarDate(iYear,iMonth,iDay) or ""
	
	local new = {
		['iYear'] = iYear,
		['iMonth'] = iMonth,
		['iDay'] = iDay,
	}
	local old = globalDataPool:getData("DisplayCalendar")
	if DataIsEqual(old, new) == false then
		self.objDataAnim:SetActive(true)
		RewindSelfDoAnim(self.objDataAnim)
		self.comDataAnim:DOPlayAllById('anim')
		globalDataPool:setData("DisplayCalendar", new, true)
	end
end

function ToptitleUI:UpdateWeather()
	if not self.objWeather then
		return
	end

	local weatherID = 0
	if self.toptitleType == TOPTITLE_TYPE.TT_MAP or self.toptitleType == TOPTITLE_TYPE.TT_MAZE or self.toptitleType == TOPTITLE_TYPE.TT_BIGMAP then
		weatherID = CityDataManager:GetInstance():GetCurCityWeatherID()
	end


	self.weatherID = weatherID
	local weatherData = TableDataManager:GetInstance():GetTableData("Weather",weatherID)
	if weatherData and dnull(weatherData['IconAnim']) then 
		self.objWeather:SetActive(true)
		--self.comWeather.sprite = GetSprite("Weather/weatherofword_" .. weatherData['IconAnim'])

		-- self.comSpineWeather.loop = true
		-- self.comSpineWeather.AnimationName = weatherData['IconAnim']

		-- DynamicChangeSpineFullPath(self.comSpineWeather.gameObject, 'UI/UISpine/Weather/UI_weatherofword_SkeletonData', weatherData['IconAnim'])
		-- SetSkeletonAnimation(self.comSpineWeather, 0, weatherData['IconAnim'], true)
		local weatherName = GetLanguageByID(weatherData.NameID)
		self.comWeatherText.text = '气候:' .. weatherName

	else
		--self.objWeather:SetActive(false)
		self.objWeather:SetActive(false)
	end 
end

function ToptitleUI:ReBuildDateDataUI()
	if not self.rectTransCalendarData then
		return
	end
    DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransCalendarData)
end

function ToptitleUI:UpdateTreasureShare()
	local mails = SocialDataManager:GetInstance():GetMailData(SMAT_TREASUREMAZE)
	if (mails and #mails > 0) then
		self.objShareTreasure:SetActive(true)
	else
		self.objShareTreasure:SetActive(false)
	end
	
	for index = 1, 5 do
		local buttonName = string.format("Button_%d", index)
		local objButton = self:FindChild(self.objShareTreasure, buttonName)
		local comButton = self:FindChildComponent(self.objShareTreasure,buttonName, "Button")
		self:RemoveButtonClickListener(comButton)
		if (mails and #mails > 0 and index <= #mails and self:GetTreasureIsShow(mails[index]) and self:GetTreasureReceiveCount() < 5) then
			objButton:SetActive(true)
			self:AddButtonClickListener(comButton,function()
				if (self:GetTreasureReceiveCount() >= 5) then
					SystemUICall:GetInstance():Toast('每日最多只能领取5次藏宝图');
					return
                end
                
                if (PlayerSetDataManager:GetInstance():GetOpenTreasureMapTypes() == PCOTT_NO) then
                    SystemUICall:GetInstance():Toast('您当前已经开启的宝藏图数量已经达到上限，无法再开启新的藏宝图');
                    return
                end
				self:SetTreasureReceiveCount(self:GetTreasureReceiveCount() + 1)
				SendMailOpr(SMAOT_GET, 1, {[0] = mails[index].id})
			end)
		else
			objButton:SetActive(false)
		end
	end
end

-- 初始化本地记录的领取次数信息
function ToptitleUI:InitTreasureReceiveCount()
	local openid = PlayerSetDataManager:GetInstance():GetPlayerID()
	if (not openid) then
		self:SetTreasureReceiveCount(0)
		return
	end
    local data = CS.UnityEngine.PlayerPrefs.GetString('TREASURE_RECEIVE_COUNT_'..tostring(openid))
    if data and data ~= '' then
        local json = dkJson.decode(data)
        local ts = json['ts']
        if MSDKHelper:IsSameDay(ts, GetCurServerTimeStamp()) ~= true then
            self:SetTreasureReceiveCount(0)
        end
    else
        self:SetTreasureReceiveCount(0)
    end
end

-- 获取藏宝图领取次数信息
function ToptitleUI:GetTreasureReceiveCount()
	local openid = PlayerSetDataManager:GetInstance():GetPlayerID()
	if (not openid) then
		return 0
	end
	local data = CS.UnityEngine.PlayerPrefs.GetString('TREASURE_RECEIVE_COUNT_'..tostring(openid))
	if (not data) then
		return 0
	end

	local json = dkJson.decode(data)
	local count = json['count']
	if (not count) then
		return 0
	end

	return count
end

function ToptitleUI:SetTreasureReceiveCount(count)
	local openid = PlayerSetDataManager:GetInstance():GetPlayerID()
	if (not openid) then
		return
	end
	if (count == nil) then
		count = self:GetTreasureReceiveCount() + 1
	end
	local json = {
        ['ts'] = GetCurServerTimeStamp(),
        ['count'] = count
    }
    local jsonStr = dkJson.encode(json)
	CS.UnityEngine.PlayerPrefs.SetString('TREASURE_RECEIVE_COUNT_'..tostring(openid), jsonStr)
end

function ToptitleUI:GetTreasureIsShow(mailData)
	if (not mailData) then
		return false
	end

	-- 判断类型
	if (mailData.type ~= SMAT_TREASUREMAZE) then
		return false
	end

	-- 是否已经领取
	if (NetCommonMail:IsReceived(mailData.state)) then
		return false
	end

	-- 是否已读
	if (NetCommonMail:IsReadReceived(mailData.state)) then
		return false
	end

	-- 判断时间
	local create_time = mailData.time
	if (create_time) then
		local remaintime = os.time() - tonumber(create_time)
		local aHour = 60 * 60;
		if (remaintime and remaintime > aHour) then
			return false
		end
	end

	return true
end

function ToptitleUI:UpdateBackButton()
	if not self.comBackButton then
		return 
	end
	self.objBackButton:SetActive(true)
	self:RemoveButtonClickListener(self.comBackButton)
	self:UpdateBackButtonDisplay()
	self:UpdateBackButtonClickListener()
end

function ToptitleUI:ResetBackButtonDisplay()
	self.objBackButton:SetActive(true)
	if self.objBackButtonArrowMark ~= nil then 
		self.objBackButtonArrowMark.gameObject:SetActive(false)
	end
	if self.objBackButtonReturnBigMapMark ~= nil then 
		self.objBackButtonReturnBigMapMark.gameObject:SetActive(false)
	end
	if self.objBackButtonExitMazeMark ~= nil then 
		self.objBackButtonExitMazeMark.gameObject:SetActive(false)
	end
	if self.objBackButtonBackMark ~= nil then 
		self.objBackButtonBackMark.gameObject:SetActive(false)
	end
end

function ToptitleUI:UpdateBackButtonDisplay()
	self:ResetBackButtonDisplay()
	local backButtonText = '返回'
	if self.toptitleType == TOPTITLE_TYPE.TT_MAP then 
		local mapData = MapDataManager:GetInstance():GetCurMapData()
		local curStoryID = GetCurScriptID()

		if curStoryID ~= 6 and (mapData == nil or mapData.CanReturn == TBoolean.BOOL_NO) then 
			self.objBackButton:SetActive(false)
			return
		end
		if mapData and mapData.SceneType == MapSceneType.ST_ROOM then 
			backButtonText = '去室外'
			if self.objBackButtonArrowMark ~= nil then 
				self.objBackButtonArrowMark.gameObject:SetActive(true)
			end
		elseif mapData and MapDataManager:GetInstance():GetParentMapID(mapData.BaseID) == 0 then 
			backButtonText = '大地图'

			if self.objBackButtonReturnBigMapMark ~= nil then 
				self.objBackButtonReturnBigMapMark.gameObject:SetActive(true)
			end
		else
			backButtonText = '往回走'
			if self.objBackButtonBackMark ~= nil then 
				self.objBackButtonBackMark.gameObject:SetActive(true)
			end
		end
	elseif self.toptitleType == TOPTITLE_TYPE.TT_MAZE then 
		backButtonText = '出迷宫'
		if self.objBackButtonExitMazeMark ~= nil then 
			self.objBackButtonExitMazeMark.gameObject:SetActive(true)
		end
	elseif self.toptitleType == TOPTITLE_TYPE.TT_BIGMAP then
		self.objBackButton:SetActive(false)
	else
		self.objBackButton:SetActive(false)
	end
	if self.comBackButtonText ~= nil then 
		self.comBackButtonText.text = backButtonText
	end
end

function ToptitleUI:UpdateBackButtonClickListener()
	local backButtonCallback = nil
	if self.toptitleType == TOPTITLE_TYPE.TT_MAP then 
		backButtonCallback = function()
			local bigMapUI = GetUIWindow("TileBigMap")
			if bigMapUI and bigMapUI:IsOpen() then
				-- 还有大地图不允许退到大地图
				return
			end
			local cityUI = GetUIWindow("CityUI")
			if cityUI ~= nil and cityUI:IsOpenAnim() then 
				-- 进城动画播放中不允许点击
				return
			end
			local mapData = MapDataManager:GetInstance():GetCurMapData()
			if mapData ~= nil then
				SendClickMap(CMT_BACKRETURN)
			end
			CloseCityRoleListUI()
		end
	elseif self.toptitleType == TOPTITLE_TYPE.TT_MAZE then 
		-- 逻辑放在了MazeUI里
		-- FIXME: 提示文字 应该使用多语言ID而不是直接使用字符串
		-- local tipStr = '是否退出迷宫？'
		-- backButtonCallback = function()
		-- 	-- 掉落没有完全爆出来之前不允许点击
		-- 	if g_mazeGridAdvLootUpdateTimer and globalTimer:GetTimer(g_mazeGridAdvLootUpdateTimer) then 
		-- 		return
		-- 	end
		-- 	OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, tipStr, function()
		-- 		SendClickMaze(CMAT_QUIT)
		-- 	end})
		-- end
		self.objBackButton:SetActive(false)
	elseif self.toptitleType == TOPTITLE_TYPE.TT_BIGMAP then 
		self.objBackButton:SetActive(false)
	end

	if backButtonCallback then 
		self:AddButtonClickListener(self.comBackButton, backButtonCallback)
	end
end

function ToptitleUI:UpdateNavLabel()
	local labelText = ''
	local city
	if self.toptitleType == TOPTITLE_TYPE.TT_MAP then 
		local uiCurCityID = CityDataManager:GetInstance():GetCurCityID()
		local mapData = MapDataManager:GetInstance():GetCurMapData()
		-- 月牙村(uiCurCityID: 2)不显示好感度
		self.objClanFavor:SetActive(uiCurCityID ~= 2)
		labelText = self:GetCurMapName()
	elseif self.toptitleType == TOPTITLE_TYPE.TT_MAZE then 
		local mazeName = MazeDataManager:GetInstance():GetCurMazeName() or ''
		local areaName = MazeDataManager:GetInstance():GetCurAreaName() or ''
		if areaName == '' then 
			labelText = mazeName
		else
			labelText = mazeName .. '-' .. areaName
		end
		self.objClanFavor:SetActive(false)
	elseif self.toptitleType == TOPTITLE_TYPE.TT_BIGMAP then 
		labelText = GetLanguageByID(378)
		local tileMap = GetUIWindow('TileBigMap')
		if tileMap ~= nil and tileMap:IsOpen() then 
			city = TDM:GetInstance():GetCurCity()
			if city then
				labelText = GetLanguageByID(city.NameID)
			end
		end
		self.objClanFavor:SetActive(false)
	end
	self.comNavLabelText.text = labelText

	-- 好感度
	local uiClanTypeID = CityDataManager:GetInstance():GetCurClanTypeID()
	if uiClanTypeID and uiClanTypeID > 0 then
		local clanData = TB_Clan[uiClanTypeID]
		if clanData.Type == ClanType.CLT_Null and clanData.Location ~= 0 then
			-- 城市好感	
			curCityData = CityDataManager:GetInstance():GetCityData(clanData.Location)
			self.objClanFavor:SetActive(true)
			--self.objDescription:SetActive(true)
			local dispostion = curCityData.iCityDispo or 0
			self.comDispositionText.text = string.format("好感:%s",dispostion)
			local strDesc = GetDispositionDesc(dispostion)
			self.comDescriptionText.text = strDesc
		else
			-- 门派好感
			local clanDisposition = ClanDataManager:GetInstance():GetDisposition(uiClanTypeID)
			self.objClanFavor:SetActive(true)
			--self.objDescription:SetActive(true)
			local dispostion = clanDisposition
			self.comDispositionText.text = string.format("好感:%s",dispostion)
			local strDesc = GetDispositionDesc(dispostion)
			self.comDescriptionText.text = strDesc
		end
	else
		self.objClanFavor:SetActive(false)
		--self.objDescription:SetActive(false)
		-- self.comDispositionText.text = string.format("好感:%s",'0')
		if city then
			self.objClanFavor:SetActive(true)
			local curCityData = CityDataManager:GetInstance():GetCityData(city.BaseID)
			self.comDispositionText.text = string.format("好感:%s",city.iCityDispo or 0)
		end
	end
end

function ToptitleUI:GetCurMapName()
	local curMapID = MapDataManager:GetInstance():GetCurMapID()
	local highTowerMapName = HighTowerDataManager:GetInstance():GetHighTowerMapName(curMapID)

	if highTowerMapName then
		return highTowerMapName
	else
		return MapDataManager:GetInstance():GetMapSceneName(curMapID)
	end
end

return ToptitleUI