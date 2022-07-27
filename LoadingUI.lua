LoadingUI = class("LoadingUI",BaseWindow)

function LoadingUI:ctor()
	self.objProgress_Text = nil
end

function LoadingUI:Create()
	local obj = LoadPrefabAndInit("LoadingUI/LoadingUI",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function LoadingUI:Init()
    self.objSceneBG = self:FindChild(self._gameObject,"SceneBG")
    self.imgSceneBG = self.objSceneBG:GetComponent(DRCSRef_Type.Image)
    self.objDefaultBG = self:FindChild(self._gameObject, "BG_Image")
    self.imgDefaultBG = self.objDefaultBG:GetComponent(DRCSRef_Type.Image)
    self.defaultColor = self.imgDefaultBG.color
    self.objProgress_Text = self:FindChildComponent(self._gameObject,"Progress_Text","Text")
    self.objProgress_Text.text = "0"
    local fun = function(iProcess)
        iProcess = iProcess or 0
        self.objProgress_Text.text = math.floor(iProcess * 100)
    end
    TableDataManager:GetInstance()

    self:AddEventListener("LoadSceneProcess", fun, nil)
    local fun1 = function()
        if not self.dontRemoveWhenLoadSceneFinish then 
            RemoveWindowImmediately("LoadingUI",true)
        end
    end
    self:AddEventListener("LoadSceneFinish", fun1, nil)
    self.deltaTime = 0
end

function LoadingUI:Update(dt)
    if not self.timerSetting then 
        return
    end
    self.deltaTime = self.deltaTime + dt
    for index, timerInfo in ipairs(self.timerSetting) do 
        local triggerTime = timerInfo.triggerTime
        if self.deltaTime >= triggerTime then 
            local callback = timerInfo.callback
            table.remove(self.timerSetting, index)
            if type(callback) == 'function' then 
                xpcall(callback, showError)
            end
            break
        end
    end
    if #self.timerSetting == 0 then 
        self:ResetTimer()
    end
end

function LoadingUI:RefreshUI(config)
    self.objSceneBG:SetActive(false)
    self.imgDefaultBG.color = self.defaultColor
    local bUnload = nil
    if config then 
        bUnload = config.bUnload
        self.dontRemoveWhenLoadSceneFinish = self.dontRemoveWhenLoadSceneFinish or config.dontRemoveWhenLoadSceneFinish
        local spriteBG = nil
        if config.uiCurMazeID and (config.uiCurMazeID > 0) then
            local kMazeArtData = MazeDataManager:GetInstance():GetMazeArtDataByID(config.uiCurMazeID)
            if kMazeArtData and kMazeArtData.BGImg and (kMazeArtData.BGImg ~= "") then
                spriteBG = GetSprite(kMazeArtData.BGImg)
            end
        elseif config.uiCurMapID and (config.uiCurMapID > 0) then
            local kMapData = MapDataManager:GetInstance():GetMapData(config.uiCurMapID)
            if kMapData and kMapData.SceneImg and (kMapData.SceneImg ~= "") then
                spriteBG = GetSprite(kMapData.SceneImg)
            end
        end
        if spriteBG then 
            self.imgSceneBG.sprite = spriteBG
            self.objSceneBG:SetActive(true)
        end
        if config.defaultBgColor then 
            local r = config.defaultBgColor.r or self.defaultColor.r
            local g = config.defaultBgColor.g or self.defaultColor.g
            local b = config.defaultBgColor.b or self.defaultColor.b
            local a = config.defaultBgColor.a or self.defaultColor.a
            self.imgDefaultBG.color = DRCSRef.Color(r, g, b, a)
        end
        self.timerSetting = config.timerSetting
    end
    if bUnload or bNotUnload == nil then
        CS.GameApp.FMODManager.ClearAllSound()
        CS.GameApp.FMODManager.UnloadAllBank()
    end
    DRCSRef.UnloadAssets()    
end

function LoadingUI:OnDestroy()
	
end

function LoadingUI:OnDisable()
    self.dontRemoveWhenLoadSceneFinish = nil
    self.deltaTime = 0
    self.timerSetting = nil
end

function LoadingUI:ResetTimer()
    self.deltaTime = 0
    self.timerSetting = nil
end

return LoadingUI