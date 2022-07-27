CityAnimUI = class("CityAnimUI",BaseWindow)


function CityAnimUI:ctor()

end

function CityAnimUI:Create()
	local obj = LoadPrefabAndInit("City/CityAnimUI",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end

end

function CityAnimUI:Init()
    self.cloud_box = self:FindChild(self._gameObject,"cloud_box")
    self.Mask = self:FindChild(self._gameObject,"Mask")
    self.poerty_box = self:FindChild(self._gameObject,"poerty_box")
    self.objName_city = self:FindChild(self.poerty_box,"Name_city")
    self.objName_city_Text = self:FindChildComponent(self.poerty_box,"Name_city","Text")
    self.objName_city_big_Text = self:FindChildComponent(self._gameObject,"Name_city_big","Text")

    self.kComponents = self.objName_city:GetComponents(typeof(CS.DG.Tweening.DOTweenAnimation))

    self.objPoerty1_Text = self:FindChildComponent(self.poerty_box,"Text_poerty1","Text")
    self.objPoerty1_TypeText = self:FindChildComponent(self.poerty_box,"Text_poerty1","TypeTextComponent")
    self.objPoerty2_Text = self:FindChildComponent(self.poerty_box,"Text_poerty2","Text")
    self.objPoerty2_TypeText = self:FindChildComponent(self.poerty_box,"Text_poerty2","TypeTextComponent")
    self.objPoet_Text = self:FindChildComponent(self.poerty_box,"Text_poerty2/Text_poet","Text")
    self.objPoet_TypeText = self:FindChildComponent(self.poerty_box,"Text_poerty2/Text_poet","TypeTextComponent")

    self.objText = self:FindChildComponent(self._gameObject,"Text1","Text")
    self.skipBtn = self:FindChildComponent(self._gameObject, "skipBtn", "Button")
    self:AddButtonClickListener(self.skipBtn,function()
        if self.curMapID then
            local isFirstStart=GetConfig("FirstOpenCity"..self.curMapID)
            if isFirstStart==nil or isFirstStart ~= 1 then
                return
            end
            self:OnAnimationComplete(true)
        end
    end)
end

function CityAnimUI:RefreshUI(info)
    if not info then
        self:OnAnimationComplete()
        return
    end
    
    self.curMapID = info.mapId or MapDataManager:GetInstance():GetCurMapID()

    local mapData = MapDataManager:GetInstance():GetMapData(self.curMapID)
    if not mapData then
        self:OnAnimationComplete()
        return
    end

    self.MapName = GetLanguageByID(mapData.NameID)
    self.sceneBG = mapData.SceneImg
    self.curCityID = CityDataManager:GetInstance():GetCurCityID()

    local data = TableDataManager:GetInstance():GetTableData("MapPoem",self.curMapID)
    if data and not GetLanguageByID(data.curMapID) then
        self:OnAnimationComplete()
        return
    end 

    self.OnAnimComplete = info.OnComplete 

    self:ShowPoetryTypeWriter()
end

function CityAnimUI:ShowPoetryTypeWriter()
    self.objPoerty1_Text.text = ""
    self.objPoerty2_Text.text = ""
    self.objPoet_Text.text = ""
    local poemData = TableDataManager:GetInstance():GetTableData("MapPoem",self.curMapID)

    self.objName_city_Text.text = self.MapName
    self.objName_city_big_Text.text = self.MapName

    -- 危险写法，需要细化
    self.kComponents[0].tween:OnStepComplete(function()
        if IsValidObj(self.objPoerty1_Text) then
            self.objPoerty1_Text:TypeText(GetLanguageByID(poemData.Poem1ID), 0.04, function()
                if IsValidObj(self.objPoerty2_Text) then
                    self.objPoerty2_Text:TypeText(GetLanguageByID(poemData.Poem2ID), 0.04, function()
                        if IsValidObj(self.objPoet_Text) then
                            self.objPoet_Text:TypeText(GetLanguageByID(poemData.TitleID), 0.05)
                        end
                    end) 
                end
            end)
        end
    end)

    self.kComponents[1].tween:OnStepComplete(function()
        self:OnAnimationComplete()
    end)
end

function CityAnimUI:OnAnimationComplete(skip)
    if self.OnAnimComplete then
        self.OnAnimComplete(skip)
    end
    SetConfig("FirstOpenCity"..self.curMapID,1)
    RemoveWindowImmediately("CityAnimUI", false)
end

function CityAnimUI:OnDisable()

end

function CityAnimUI:OnDestroy()
    if IsValidObj(self.objPoerty1_Text) then
        self.objPoerty1_TypeText:Destroy()
    end
    if IsValidObj(self.objPoerty2_Text) then
        self.objPoerty2_TypeText:Destroy()
    end
    if IsValidObj(self.objPoet_Text) then
        self.objPoet_TypeText:Destroy()
    end
    self.kComponents[0].tween:OnStepComplete(nil)
    self.kComponents[1].tween:OnStepComplete(nil)
end

return CityAnimUI