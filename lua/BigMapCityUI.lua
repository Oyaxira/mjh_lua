BigMapCityUI = class("BigMapCityUI",BaseWindow)

function BigMapCityUI:ctor()

end

function BigMapCityUI:Create()
end

function BigMapCityUI:Init()
end

function BigMapCityUI:UpdateCity(objCity, cityData, callback)
    self:UpdateCityState(objCity, cityData)
    self:UpdateCityIcon(objCity, cityData)
    self:UpdateCityName(objCity, cityData)
    self:UpdateCityTimer(objCity, cityData)
    self:UpdateCityListener(objCity, cityData,callback)
end

function BigMapCityUI:OnDestroy()
end

function BigMapCityUI:UpdateCityState(objCity, cityData)
    local dyCityData = CityDataManager:GetInstance():GetCityData(cityData.BaseID)

    if not dyCityData or not dyCityData.uiState then
        return
    end

    local comCityIcon = self:FindChildComponent(objCity, 'city_icon', DRCSRef_Type.Image)
    local objCityName = self:FindChild(objCity, 'city_name_back')
    local comCityNameText = self:FindChildComponent(objCityName, 'city_name', DRCSRef_Type.Text)

    if dyCityData.uiState == 0 then
        comCityIcon.color = DRCSRef.Color(1,1,1,1)
        comCityNameText.color = DRCSRef.Color(1,1,1,1)
    else
        comCityIcon.color = DRCSRef.Color(0.6,0.6,0.6,1)
        comCityNameText.color = DRCSRef.Color(0.6,0.6,0.6,1)
    end
end

function BigMapCityUI:UpdateCityIcon(objCity, cityData)
    local comCityIcon = self:FindChildComponent(objCity, 'city_icon', DRCSRef_Type.Image)
    if (cityData == nil) then
        return
    end
    local cityIcon = GetAtlasSprite("BigmapAtlas",cityData.CityIconImage)
    if (objCity ~= nil and comCityIcon ~= nil and cityIcon ~= nil and cityData ~= nil) then
        comCityIcon.sprite = cityIcon
        comCityIcon:SetNativeSize();
        SetUIAxis(comCityIcon.gameObject, cityIcon.rect.width, cityIcon.rect.height)
        objCity.transform.localPosition = DRCSRef.Vec3(cityData.BigmapPosX, cityData.BigmapPosY, 0)
    end
end

-- 更新城市名字信息 和便宜量
function BigMapCityUI:UpdateCityName(objCity, cityData)
   local objCityName = self:FindChild(objCity, 'city_name_back')
    local comCityNameText = self:FindChildComponent(objCityName, 'city_name', DRCSRef_Type.Text)
    local cityName = CityDataManager:GetInstance():GetCityShowName(cityData.BaseID)
    comCityNameText.text = cityName
    if DEBUG_MODE then
        comCityNameText.text = comCityNameText.text .. tostring(cityData.BaseID)
    end
    local default_pos = CITY_DEFAULT_NAME_POS
    objCityName.transform.localPosition = DRCSRef.Vec3(default_pos.x + cityData.NameUIOffsetX, default_pos.y + cityData.NameUIOffsetY, 0)
end

-- 更新城市计时器信息
function BigMapCityUI:UpdateCityTimer(objCity, cityData)
    local objTimer = self:FindChild(objCity, 'city_name_back/Timer')
    if not objTimer then 
        return
    end
    if cityData.uiTimerCount and cityData.uiTimerCount > 0 then 
        objTimer:SetActive(true)
        local comTimerText = self:FindChildComponent(objTimer, 'Text', DRCSRef_Type.Text)
        local comTimerSlider = objTimer:GetComponent(DRCSRef_Type.Slider)
        local taskDataMgr = TaskDataManager:GetInstance()
        local evolutionMgr = EvolutionDataManager:GetInstance()
        -- 最邻近的时间
        local nearTime = nil
        for i = 1, cityData.uiTimerCount do 
            local timerID = cityData.auiTimers[i - 1]
            local triggerTime = taskDataMgr:GetTimerTriggerTime(timerID)
            if nearTime == nil or nearTime > triggerTime then 
                nearTime = triggerTime
            end
        end
        local rivakeTime = evolutionMgr:GetRivakeTime()
        local remainTime = nearTime - rivakeTime
        local remainTimeStr = evolutionMgr:GetRivakeTimeYMDText(remainTime, true) or ''
        comTimerSlider.value = remainTime / MAX_CITY_TIMER_TIME
        comTimerText.text = '剩余' .. remainTimeStr
    else
        objTimer:SetActive(false)
    end
end

function BigMapCityUI:UpdateCityListener(objCity, cityData,callback)
    local comButton = self:FindChildComponent(objCity, "Raycast", DRCSRef_Type.Button) 
    self:RemoveButtonClickListener(comButton)
	self:AddButtonClickListener(comButton, function() 
        callback()
    end)
end

function BigMapCityUI:ClickCity(objCity, cityData)
    local bigmapUI = GetUIWindow('BigMapUI')
    if bigmapUI then
    	bigmapUI:ClickCity(objCity, cityData)
    end
end

function BigMapCityUI:PointerEnterCity(objCity, cityData)
    local bigmapUI = GetUIWindow('BigMapUI')
    if bigmapUI then
    	bigmapUI:PointerEnterCity(objCity, cityData)
    end
end

function BigMapCityUI:PointerExitCity(objCity, cityData)
    local bigmapUI = GetUIWindow('BigMapUI')
    if bigmapUI then
    	bigmapUI:PointerExitCity(objCity, cityData)
    end
end

return BigMapCityUI