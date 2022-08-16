SystemSettingUI = class("SystemSettingUI",BaseWindow)

function SystemSettingUI:ctor(obj)
    self:SetGameObject(obj)
    self:Init()
end

function SystemSettingUI:Init()
    
    self.objLayout = self:FindChild(self._gameObject, "Layout")
    -- self.Button_Quit = self:FindChildComponent(self.objLayout,"Button_quit","Button")
    -- if IsValidObj(self.Button_Quit) then
    --     self.Button_Quit.gameObject:SetActive(not self.bIfInLoginUI)
    --     local fun = function()
    --         -- 如果这个时候临时背包中还有物品, 那么在返回酒馆的时候给个提示
    --         local tempItems = ItemDataManager:GetInstance():GetTempBackpackItems() or {}
    --         if #tempItems > 0 then
    --             local msg = "临时背包中还有物品, 离开剧本就会消失, 确定要返回标题吗?"
    --             local boxCallback = function()
    --                 SendClickQuitStoryCMD()
    --             end
    --             OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg or "", boxCallback})
    --         else
    --             SendClickQuitStoryCMD()
    --         end
	-- 	end
	-- 	self:AddButtonClickListener(self.Button_Quit,fun)
    -- end

    self.Button_ExchangeCode = self:FindChildComponent(self._gameObject,"Button_exchange_code","Button")
    if IsValidObj(self.Button_ExchangeCode) then
        local fun = function()
			self:OnClick_ExchangeCode_Button()
		end
		self:AddButtonClickListener(self.Button_ExchangeCode,fun)
    end
    -- self.Button_BackToLogin = self:FindChildComponent(self._gameObject,"Button_BackToLogin","Button")
    -- if IsValidObj(self.Button_BackToLogin) then
    --     self.Button_BackToLogin.gameObject:SetActive(not self.bIfInLoginUI)
    --     local fun = function()
	-- 		-- self:OnClick_Report_Button()
    --         -- quit
    --         SendClickQuitStoryCMD()

	-- 	end
	-- 	self:AddButtonClickListener(self.Button_BackToLogin,fun)
    -- end


    self.Button_Mod = self:FindChildComponent(self._gameObject,"Button_mod","Button")
    if IsValidObj(self.Button_Mod) then
        local fun = function()
			self:OnClick_Report_Mod()
		end
		self:AddButtonClickListener(self.Button_Mod,fun)
    end

    self.Button_Agreement_1 = self:FindChildComponent(self._gameObject, "Panel_private/Content/PrivateItem/Button_Agreement_1", "Button")
    if (self.Button_Agreement_1) then
        local fun = function()
            MSDKHelper:OpenContractUrl()
        end
        self:AddButtonClickListener(self.Button_Agreement_1, fun)
    end

    self.Button_Agreement_2 = self:FindChildComponent(self._gameObject, "Panel_private/Content/PrivateItem/Button_Agreement_2", "Button")
    if (self.Button_Agreement_2) then
      local fun = function()
        MSDKHelper:OpenPrivacyGuideUrl()
      end
      self:AddButtonClickListener(self.Button_Agreement_2, fun)
    end

    self.Button_Agreement_3 = self:FindChildComponent(self._gameObject, "Panel_private/Content/PrivateItem/Button_Agreement_3", "Button")
    if (self.Button_Agreement_3) then
      local fun = function()
        MSDKHelper:OpenPrivacyGuideChildrenUrl()
      end
      self:AddButtonClickListener(self.Button_Agreement_3, fun)
    end

    self.Button_Agreement_4 = self:FindChildComponent(self._gameObject, "Panel_private/Content/PrivateItem/Button_Agreement_4", "Button")
    if (self.Button_Agreement_4) then
      local fun = function()
        self:OnClick_PowerInfo()
      end
      self:AddButtonClickListener(self.Button_Agreement_4, fun)
    end

    local kButton1 = self:FindChildComponent(self._gameObject, "Panel_private/Content/PersonalItem/Button_link1", "Button")
    if kButton1 then
      local fun = function()
        DRCSRef.MSDKWebView.OpenUrl("https://kf.qq.com")
      end
      self:AddButtonClickListener(kButton1, fun)
    end

    local kButton1 = self:FindChildComponent(self._gameObject, "Panel_private/Content/PersonalItem/Button_link2", "Button")
    if kButton1 then
      local fun = function()
        DRCSRef.MSDKWebView.OpenUrl("https://privacy.qq.com")
      end
      self:AddButtonClickListener(kButton1, fun)
    end

    -- 注销账号
    self.Button_DeleteAccount = self:FindChildComponent(self._gameObject, "Panel_private/Content/PrivateItem/Button_Agreement_5", "Button")
    if (self.Button_DeleteAccount) then
      local func = function()
        local deleteUrl = "https://gacc-account-web.odp.qq.com/writeoff.html"
        deleteUrl = deleteUrl .. "?ADTAG=client" .. "&os=".. tostring(MSDK_OS) .. "&gameid=10127" .. "&channelid=" .. tostring(MSDKHelper:GetChannelId() or 0) .. "&outerIp=127.0.0.1"
        DRCSRef.MSDKWebView.OpenUrl(deleteUrl)
      end
      self:AddButtonClickListener(self.Button_DeleteAccount, func)
    end

    -- 设置分页
    self.objVoicePage = self:FindChild(self._gameObject, "Panel_voice")
    self.objBattlePage = self:FindChild(self._gameObject, "Panel_battle")
    self.objFramePage = self:FindChild(self._gameObject, "Panel_frame")
    self.objStoryPage = self:FindChild(self._gameObject, "Panel_story")
    self.objSystemPage = self:FindChild(self._gameObject, "Panel_system")
    self.objPrivatePage = self:FindChild(self._gameObject, "Panel_private")
    self.objShortcutPage = self:FindChild(self._gameObject, "Panel_shortcut")
    self.objRegardPage = self:FindChild(self._gameObject, "Panel_regard")

    -- 页签切换
    self.colorNavPick = DRCSRef.Color(0.91, 0.91, 0.91, 1)
    self.colorNavUnPick = DRCSRef.Color(0.1960784, 0.1960784, 0.1960784, 1)
    local objToggleGroup = self:FindChild(self._gameObject, "Toggle_Group")
    local toggleVoice = self:FindChildComponent(objToggleGroup,"Toggle_voice", DRCSRef_Type.Toggle)
    self.textTogVoice = self:FindChildComponent(objToggleGroup,"Toggle_voice/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleVoice, function(bIsOn)
        self:SetPageState("Voice", bIsOn)
    end)

    local toggleBattle = self:FindChildComponent(objToggleGroup,"Toggle_battle", DRCSRef_Type.Toggle)
    self.textTogBattle = self:FindChildComponent(objToggleGroup,"Toggle_battle/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleBattle, function(bIsOn)
        self:SetPageState("Battle", bIsOn)
    end)
    local toggleStory = self:FindChildComponent(objToggleGroup,"Toggle_story", DRCSRef_Type.Toggle)
    self.textTogStory = self:FindChildComponent(objToggleGroup,"Toggle_story/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleStory, function(bIsOn)
        self:SetPageState("Story", bIsOn)
    end)
    local toggleFrame = self:FindChildComponent(objToggleGroup,"Toggle_frame", DRCSRef_Type.Toggle)
    self.textTogFrame = self:FindChildComponent(objToggleGroup,"Toggle_frame/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleFrame, function(bIsOn)
        self:SetPageState("Frame", bIsOn)
    end)
    local toggleSystem = self:FindChildComponent(objToggleGroup,"Toggle_system", DRCSRef_Type.Toggle)
    self.textTogSystem = self:FindChildComponent(objToggleGroup,"Toggle_system/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleSystem, function(bIsOn)
        self:SetPageState("System", bIsOn)
    end)

    local togglePrivate = self:FindChildComponent(objToggleGroup,"Toggle_private", DRCSRef_Type.Toggle)
    self.textTogPrivate = self:FindChildComponent(objToggleGroup,"Toggle_private/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(togglePrivate, function(bIsOn)
        self:SetPageState("Private", bIsOn)
    end)
    local toggleShortcut=self:FindChildComponent(objToggleGroup,"Toggle_shortcut", DRCSRef_Type.Toggle)
    self.textTogShortcut = self:FindChildComponent(objToggleGroup,"Toggle_shortcut/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleShortcut,function(bIsOn)
        self:SetPageState("Shortcut", bIsOn)
    end)
    local toggleRegard=self:FindChildComponent(objToggleGroup,"Toggle_regard", DRCSRef_Type.Toggle)
    self.textTogRegard = self:FindChildComponent(objToggleGroup,"Toggle_regard/Label", DRCSRef_Type.Text)
    self:AddToggleClickListener(toggleRegard,function(bIsOn)
        self:SetPageState("Regard", bIsOn)
    end)

    -- 设置单项
    -- 侠客行

    local pingballToggle = {}
    self.objTogPinballSetting = self:FindChild(self.objSystemPage, "Content/SettingItem_Pinball")
    self.togPinballSettingOn = self:FindChildComponent(self.objTogPinballSetting, "Toggle_Pinball/On", DRCSRef_Type.Toggle)
    self.togPinballSettingOff = self:FindChildComponent(self.objTogPinballSetting, "Toggle_Pinball/Off", DRCSRef_Type.Toggle)
    local bIsPinballQuickShootOn = CS.UnityEngine.PlayerPrefs.GetInt("lang") == 1
    self.togPinballSettingOff.isOn = not bIsPinballQuickShootOn
    self.togPinballSettingOn.isOn = bIsPinballQuickShootOn
    self:AddToggleClickListener(self.togPinballSettingOn, function(bIsOn)
        --PinballDataManager:GetInstance():SetQuickShootState(bIsOn)
        local str = 'schinese'
        -- CS.UnityEngine.PlayerPrefs.SetInt("lang", 0)
        if bIsOn then
            str = 'tchinese'
            -- CS.UnityEngine.PlayerPrefs.SetInt("lang", 1)
        end
        if str ~= io.readfile('lang.txt') then
            SystemUICall:GetInstance():Toast('重启游戏后生效')
            io.writefile('lang.txt', str)
        end
    end)
    pingballToggle[1] = self.togPinballSettingOn
    pingballToggle[2] = self.togPinballSettingOff
    local clickImg = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Pinball/Toggle_Pinball/clickImg","Button")
    local fun = function()
        bIsPinballQuickShootOn = not bIsPinballQuickShootOn
        self.togPinballSettingOn.isOn = bIsPinballQuickShootOn
        self.togPinballSettingOff.isOn = not bIsPinballQuickShootOn
    end
    self:AddButtonClickListener(clickImg,fun)

    self.objTogMoveSetting = self:FindChild(self.objSystemPage, "Content/SettingItem_Move")
    self.togMoveSettingOn = self:FindChildComponent(self.objTogMoveSetting, "Toggle_Move/On", DRCSRef_Type.Toggle)
    self.togMoveSettingOff = self:FindChildComponent(self.objTogMoveSetting, "Toggle_Move/Off", DRCSRef_Type.Toggle)
    local bIsMoveShootOn = GetConfig("confg_Move") == 2
    self.togMoveSettingOn.isOn = not bIsMoveShootOn
    self.togMoveSettingOff.isOn = bIsMoveShootOn
    self:AddToggleClickListener(self.togMoveSettingOn, function(bIsOn)
        if bIsOn then
            ROLE_MOVE_TYPE = 1
            SetConfig("confg_Move", 1 ,true)
        else
            ROLE_MOVE_TYPE = 2
            SetConfig("confg_Move", 2 ,true)
        end
    end)
    local clickImg = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Move/Toggle_Move/clickImg","Button")
    local fun = function()
        bIsMoveShootOn = not bIsMoveShootOn
        self.togMoveSettingOn.isOn = bIsMoveShootOn
        self.togMoveSettingOff.isOn = not bIsMoveShootOn
    end
    self:AddButtonClickListener(clickImg,fun)


    self.objTogVideoSetting = self:FindChild(self.objSystemPage, "Content/SettingItem_Video")
    self.togVideoSettingOn = self:FindChildComponent(self.objTogVideoSetting, "Toggle_Video/On", DRCSRef_Type.Toggle)
    self.togVideoSettingOff = self:FindChildComponent(self.objTogVideoSetting, "Toggle_Video/Off", DRCSRef_Type.Toggle)
    local bIsVideoShootOn = GetConfig("confg_Video") == 2
    self:AddToggleClickListener(self.togVideoSettingOn, function(bIsOn)
        if bIsOn then
            SetConfig("confg_Video", 1 ,true)
        else
            SetConfig("confg_Video", 2 ,true)
        end
    end)
    self.togVideoSettingOn.isOn = not bIsVideoShootOn
    self.togVideoSettingOff.isOn = bIsVideoShootOn
    local clickImg = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Video/Toggle_Video/clickImg","Button")
    local fun = function()
        bIsVideoShootOn = not bIsVideoShootOn
        self.togVideoSettingOn.isOn = bIsVideoShootOn
        self.togVideoSettingOff.isOn = not bIsVideoShootOn
    end
    self:AddButtonClickListener(clickImg,fun)

    self:InitVoicettings()
    self:InitStorySettings()
    self:InitPictureSettings()
    self:InitSystemSettings()
    self:InitRegard()
    self:InitShortcutSettings()
    self.objVoicePage:SetActive(true) 
    self.objFramePage:SetActive(false) 
    self.objBattlePage:SetActive(false) 
    self.objSystemPage:SetActive(false) 
    self.objPrivatePage:SetActive(false)
    self.objShortcutPage:SetActive(false)
    self.objRegardPage:SetActive(false)
end

--声音设置
function SystemSettingUI:InitVoicettings()
    if not self._slider then
        self._slider = {}
    end
    
    self._slider.Slider_YinYue = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Yinyue/Slider_YinYue","Slider")
    if self._slider.Slider_YinYue then
        local iValue =  GetConfig("confg_YinYue")
        if iValue == nil  then
            iValue = 1
        end
        self._slider.Slider_YinYue.value = iValue
        local fun_YinYue = function(value)
            self:OnYinYueValueChange(value)
        end
        self._slider.Slider_YinYue.onValueChanged:AddListener(fun_YinYue)
    end
    self._slider.Slider_YinXiao = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Yinxiao/Slider_YinXiao","Slider")
    if self._slider.Slider_YinXiao then
        local fun_YinXiao = function(value)
            self:OnYinXiaoValueChange(value)
        end
        local iValue =  GetConfig("confg_YinXiao")
        if iValue == nil  then
            iValue = 1
        end
        self._slider.Slider_YinXiao.value = iValue
        self._slider.Slider_YinXiao.onValueChanged:AddListener(fun_YinXiao)
    end
    self._slider.Slider_YuYin = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Yuyin/Slider_YuYin","Slider")
    if self._slider.Slider_YuYin then
        local fun_YuYin = function(value)
            --[todo] 等音频拆bus 出来
            SetConfig("confg_YuYin",value)
            CS.GameApp.FMODManager.SetVocalVolume(value)
        end
        local iValue =  GetConfig("confg_YuYin")
        if iValue == nil  then
            iValue = 1
        end
        self._slider.Slider_YuYin.value = iValue
        self._slider.Slider_YuYin.onValueChanged:AddListener(fun_YuYin)
    end
end

-- 剧情设置
function SystemSettingUI:InitStorySettings()
    if not self._slider then
        self._slider = {}
    end
    
    self._slider.Slider_StoryChatSpeed = self:FindChildComponent(self._gameObject,"Slider_StoryChatSpeed","Slider")
    if self._slider.Slider_StoryChatSpeed then
        local iValue =  GetConfig("confg_StoryChatSpeed")
        if iValue == nil  then
            iValue = 0.5
        end
        self._slider.Slider_StoryChatSpeed.value = iValue
        local fun_StoryChatSpeed = function(value)
            self:OnStoryChatSpeedValueChange(value)
        end
        self._slider.Slider_StoryChatSpeed.onValueChanged:AddListener(fun_StoryChatSpeed)
    end
    self._slider.Slider_AutoChatSpeed = self:FindChildComponent(self._gameObject,"Slider_AutoChatSpeed","Slider")
    if self._slider.Slider_AutoChatSpeed then
        local iValue =  GetConfig("confg_AutoChatSpeed")
        if iValue == nil  then
            iValue = 0.5
        end
        self._slider.Slider_AutoChatSpeed.value = iValue
        local fun_AutoChatSpeed = function(value)
            self:OnAutoChatSpeedValueChange(value)
        end
        self._slider.Slider_AutoChatSpeed.onValueChanged:AddListener(fun_AutoChatSpeed)
    end
end

--画面设置
function SystemSettingUI:InitPictureSettings()
    --粒子质量 1 低 2 中 3高
    local particleMode = GetConfig("confg_ParticleMode")
    if particleMode == nil then
        particleMode = 3   --默认为低
    end

    local particleToggle = {}
    for i = 1, 3 do
        local toggle = self:FindChildComponent(self._gameObject,"Panel_frame/Viewport/Content/SettingItem_Particle/Toggle_setting/Toggle_"..i,"Toggle")
        --self:FindChild(self._gameObject,"Panel_frame/Content/SettingItem_Particle/Toggle_setting/Toggle_"..i.."/Label_active","Toggle"):SetActive(i == particleMode)
        local fun = function(isOn)
            if isOn then
                SetConfig("confg_ParticleMode",i)
                CS.ParticleLevelSetting.SetParticleLevel(i)
                if i == 3 then
                    SetConfig("confg_ElectricMode",1, true)
                    CS.UnityEngine.Application.targetFrameRate = 60
                else
                    SetConfig("confg_ElectricMode",0, true)
                    CS.UnityEngine.Application.targetFrameRate = 30
                end
            end
        end

        toggle.isOn = (i == particleMode)
        self:AddToggleClickListener(toggle,fun)
        particleToggle[i] = toggle
    end


    local clickImg = self:FindChildComponent(self._gameObject,"Panel_frame/Viewport/Content/SettingItem_Particle/Toggle_setting/clickImg","Button")
    local fun = function()
        particleMode = particleMode % 3 + 1
        particleToggle[particleMode].isOn = true
    end
    self:AddButtonClickListener(clickImg,fun)


    local SCREEN = getScreen()
    self.objFrameContent = self:FindChild(self._gameObject, "Panel_frame/Viewport/Content")

    self.fullScreenOn = self:FindChildComponent(self.objFrameContent, "SettingItem_FullScreen/Toggle_Pinball/On", DRCSRef_Type.Toggle)
    self.fullScreenOff = self:FindChildComponent(self.objFrameContent, "SettingItem_FullScreen/Toggle_Pinball/Off", DRCSRef_Type.Toggle)
    local fullscreen = SCREEN.fullScreen == 1
    self.fullScreenOff.isOn = not fullscreen
    self.fullScreenOn.isOn = fullscreen
    self:AddToggleClickListener(self.fullScreenOn, function(bIsOn)
        if SCREEN.fullScreen == 0 and bIsOn then
            SCREEN.fullScreen = 1 - SCREEN.fullScreen
            ResetScreen()
        end
    end)
    self:AddToggleClickListener(self.fullScreenOff, function(bIsOn)
        if SCREEN.fullScreen == 1 and bIsOn then
            SCREEN.fullScreen = 1 - SCREEN.fullScreen
            ResetScreen()
        end
    end)
    -- local fullScreenclick = self:FindChildComponent(self.objFrameContent,"SettingItem_FullScreen/Toggle_Pinball/clickImg","Button")
    -- self:AddButtonClickListener(fullScreenclick,function()
    --     SCREEN.fullScreen = 1 - SCREEN.fullScreen
    --     ResetScreen()
    --     fullscreen = SCREEN.fullScreen == 1
    --     self.fullScreenOn.isOn = fullscreen
    --     self.fullScreenOff.isOn = not fullscreen
    -- end)


    self.resolutionToggle = {}
    for i = 1, 4 do
        self.resolutionToggle[i] = self:FindChildComponent(self.objFrameContent, "SettingItem_Resolution/group/"..i, DRCSRef_Type.Toggle)
        if i == SCREEN.resolution then
            self.resolutionToggle[i].isOn = true
        end
        self:AddToggleClickListener(self.resolutionToggle[i], function(bIsOn)
            self.resolutionToggle[i].isOn = bIsOn
            if bIsOn then
                SCREEN.resolution = i
                ResetScreen()
            end
        end)
    end


    --初始化标题画面选框

    --获取预制体
    self.objPreviewItem = self:FindChild(self._gameObject, 'PreviewItem')
    self.objSettingItemContent = self:FindChild(self._gameObject, 'SettingItemContent')
    local transSettingItemContent = self.objSettingItemContent.transform
    self.objPreviewItem:SetActive(false)
    local previewItemList = TableDataManager:GetInstance():GetTable("TitleScreen")
    if not previewItemList then
        return
    end
    local objClone = nil
    local itemList = {}
    table.sort(previewItemList,function(a,b)
        return a.BaseID < b.BaseID
    end)
    for key, titleScreenData in ipairs(previewItemList) do
        if not titleScreenData then
            return
        end
        objClone = self:LoadGameObjFromPool(self.objPreviewItem, transSettingItemContent)
        objClone.transform.name = titleScreenData.BaseID
        local imgIcon = self:FindChildComponent(objClone, "Icon","Image")
        if titleScreenData.PreviewBG then
            imgIcon.sprite = GetSprite(titleScreenData.PreviewBG)
        end
        local objIsUsing = self:FindChild(objClone, 'IsUsing')
        
        if titleScreenData.BaseID == GetConfig("BGImage") then
            objIsUsing:SetActive(true)
        else
            objIsUsing:SetActive(false)
        end
        local btnClick = self:FindChildComponent(objClone, "Btn_ChangeBG","Button")
        if btnClick then
            self:RemoveButtonClickListener(btnClick)
            self:AddButtonClickListener(btnClick, function()
                local lastkey = GetConfig("BGImage")
                itemList[lastkey]:SetActive(false)
                itemList[titleScreenData.BaseID]:SetActive(true)
                SetConfig("BGImage",titleScreenData.BaseID)
                local loginUI = GetUIWindow('LoginUI')
                if (loginUI) then
                    loginUI:RefreshBGImage(titleScreenData.BaseID)
                end
                -- for key, value in pairs(itemList) do
                --     local objIsUsing = self:FindChild(value, 'IsUsing')
                --     objIsUsing:SetActive(false)

                -- end

            end)
        end

        local unlock = titleScreenData.InitUnlock
        if dnull(unlock) then
            objClone:SetActive(true)
        else          
            -- 一些解锁BG的功能
            local dlcID = titleScreenData.DlcID
            if dlcID and DRCSRef.LogicMgr:GetInfo("dlc", dlcID) == 1 then
                objClone:SetActive(true)
            else
                objClone:SetActive(false)
            end

            
        end
        itemList[titleScreenData.BaseID] = objIsUsing
        --itemList[key].objIsUsing = objIsUsing
    end
end

--系统设置
function SystemSettingUI:InitSystemSettings()
    --显示区服UID 1 关  2开
    local showUID = GetConfig("confg_ShowUID")
    if showUID == nil then
        showUID = 2
    end

    local IDToggle = {}
    for i = 1, 2 do
        local toggle = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_ID/Toggle_setting/Toggle_"..i,"Toggle")
        local fun = function(isOn)
            if isOn then
                SetConfig("confg_ShowUID",i)
                ShowServerAndUID(i)
            end
        end

        toggle.isOn = (i == showUID)
        IDToggle[i] = toggle
        self:AddToggleClickListener(toggle,fun)
    end
    local clickImg = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_ID/Toggle_setting/clickImg","Button")
    local fun = function()
        IDToggle[showUID % 2 + 1].isOn = true
        showUID = (showUID + 1) 
    end
    self:AddButtonClickListener(clickImg,fun)


    local toggle_stopattackaudio_0 = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Attack/Toggle_setting/Toggle_1","Toggle")
    self:AddToggleClickListener(toggle_stopattackaudio_0,function(isOn)
        if isOn then
            SetConfig("config_stopattackaudio",0)
        end
    end)
    local toggle_stopattackaudio_1 = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Attack/Toggle_setting/Toggle_2","Toggle")
    self:AddToggleClickListener(toggle_stopattackaudio_1,function(isOn)
        if isOn then
            SetConfig("config_stopattackaudio",1)
        end
    end)
    local clickImg_stopattackaudio = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Attack/Toggle_setting/clickImg","Button")
    local stopattackaudioUID = GetConfig("config_stopattackaudio") or 0
    local fun = function()
        if stopattackaudioUID % 2 == 0 then 
            toggle_stopattackaudio_0.isOn = true
            toggle_stopattackaudio_1.isOn = false
        else
            toggle_stopattackaudio_0.isOn = false
            toggle_stopattackaudio_1.isOn = true
        end
        stopattackaudioUID = stopattackaudioUID + 1
    end
    fun()
    self:AddButtonClickListener(clickImg_stopattackaudio,fun)

    local toggle_stophurtaudio_0 = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Hurt/Toggle_setting/Toggle_1","Toggle")
    self:AddToggleClickListener(toggle_stophurtaudio_0,function(isOn)
        if isOn then
            SetConfig("config_stophurtaudio",0)
        end
    end)
    local toggle_stophurtaudio_1 = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Hurt/Toggle_setting/Toggle_2","Toggle")
    self:AddToggleClickListener(toggle_stophurtaudio_1,function(isOn)
        if isOn then
            SetConfig("config_stophurtaudio",1)
        end
    end)
    local clickImg_stophurtaudio = self:FindChildComponent(self._gameObject,"Panel_voice/Viewport/Content/SettingItem_Hurt/Toggle_setting/clickImg","Button")
    local stophurtaudioID = GetConfig("config_stophurtaudio") or 0
    local fun = function()
        if stophurtaudioID % 2 == 0 then 
            toggle_stophurtaudio_0.isOn = true
            toggle_stophurtaudio_1.isOn = false
        else
            toggle_stophurtaudio_0.isOn = false
            toggle_stophurtaudio_1.isOn = true
        end
        stophurtaudioID = stophurtaudioID + 1
    end
    fun()
    self:AddButtonClickListener(clickImg_stophurtaudio,fun)


    -- 显示UID
    local comSettingItemIDText = self:FindChildComponent(self._gameObject, "Panel_system/Content/SettingItem_ID/Text", "Text")
    if (comSettingItemIDText) then
      comSettingItemIDText.text = string.format("UID: %d",PlayerSetDataManager:GetInstance():GetPlayerID() or 0)
    end
    
    --地图移动二次确认 1 关  2开
    -- local mapMove = GetConfig("confg_MapMove")
    -- if mapMove == nil then
    --     mapMove = 2
    -- end

    -- local moveToggle = {}
    -- for i = 1, 2 do
    --     local toggle = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Map/Toggle_setting/Toggle_"..i,"Toggle")
    --     local fun = function(isOn)
    --         if isOn then
    --             SetConfig("confg_MapMove",i)
    --         end
    --     end
    --     toggle.isOn = ( i == mapMove)
    --     moveToggle[i] = toggle
    --     self:AddToggleClickListener(toggle,fun)
    -- end
    -- local clickImg = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Map/Toggle_setting/clickImg","Button")
    -- local fun = function()
    --     moveToggle[mapMove % 2 + 1].isOn = true
    --     mapMove = (mapMove + 1) 
    -- end
    -- self:AddButtonClickListener(clickImg,fun)

    --使用qq\wx头像 1 关  2开
    local useHeadText = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Head/title_bottom/title_1","Text")
    local channel = MSDKHelper:GetChannel()
    local channelName = "平台"
    if (channel == "WeChat") then
        channelName = "微信"
	elseif (channel == "QQ") then
    	channelName = "QQ"
    end
    useHeadText.text = "使用"..channelName.."头像"
    
    local playerID = tostring(globalDataPool:getData("PlayerID"));
    local QQHead = GetConfig(playerID .. "#confg_QQHead")
    if (not QQHead) then
        MSDKHelper:SetHeadPic(nil)
    end
    local headToggle = {}
    for i = 1, 2 do
        local toggle = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Head/Toggle_setting/Toggle_"..i,"Toggle")
        local fun = function(isOn)
            if isOn then
                SetConfig(playerID .. "#confg_QQHead",i)
                MSDKHelper:UploadHeadPicUrl()
                LuaEventDispatcher:dispatchEvent('Modify_UseTencentHeadPic')
            end
        end
        toggle.isOn = (i == QQHead)
        headToggle[i] = toggle
        --游客等渠道 默认按钮处于“关” 修改按钮无用
        if CAN_USE_PLATHEAD and (channel == "WeChat" or channel == "QQ") then
            self:AddToggleClickListener(toggle,fun)
        end
    end


    local clickImg = self:FindChildComponent(self._gameObject,"Panel_system/Content/SettingItem_Head/Toggle_setting/clickImg","Button")
    local fun = function()
        headToggle[QQHead % 2 + 1].isOn = true
        QQHead = (QQHead + 1) 
    end
    self:AddButtonClickListener(clickImg,fun)



    self.Button_private = self:FindChildComponent(self._gameObject,"Panel_private/Button_private","Button")
    if IsValidObj(self.Button_private) then
        local fun = function()
			self:OnClick_PrivateInfo()
		end
		self:AddButtonClickListener(self.Button_private,fun)
    end

    self.Button_power = self:FindChildComponent(self._gameObject,"Panel_private/Button_power","Button")
    if IsValidObj(self.Button_power) then
        local fun = function()
			    self:OnClick_PowerInfo()
		    end
		self:AddButtonClickListener(self.Button_power,fun)
    end

    self.Button_Credit = self:FindChildComponent(self._gameObject,"Panel_private/Content/PowerItem/Button_Credit","Button")
    if IsValidObj(self.Button_Credit) then
        self.Button_Credit.gameObject:SetActive(true)
        local fun = function()
            MSDKHelper:OpenCriditUrl()
        end
        self:AddButtonClickListener(self.Button_Credit,fun)
    end

    self.ObjSavePrivate = self:FindChild(self._gameObject,"Panel_private/Content/PowerItem/SystemPowerItem (1)")
    if IsValidObj(self.ObjSavePrivate) then
        if (MSDK_OS == 2) then
            self.ObjSavePrivate.gameObject:SetActive(false)
        else
            self.ObjSavePrivate.gameObject:SetActive(true)
        end
    end

end

local checkMousePos = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint

function SystemSettingUI:InitShortcutSettings()
    self.comShortcutContent = self:FindChildComponent(self._gameObject,"Panel_shortcut/Viewport/Content","Transform")
    self.KeySettingsTable = KeyboardManager:GetInstance():GetKeySettingsTable()
    self.HorizontalItemList = {}
    for key, value in pairs(self.KeySettingsTable) do
        local SettingItem_clone = self:LoadPrefabFromPool("Module/SettingItem_shortcut_prefab", self.comShortcutContent)
        local titleText = self:FindChildComponent(SettingItem_clone,"title_bottom/title_1","Text")
        local VertialContent = self:FindChildComponent(SettingItem_clone,"VerticalContent","Transform")
        titleText.text = value['界面名称']
        local buttonSettingsTable = value['按键设置']
        self.HorizontalItemList[key] = {}
        for k, v in pairs(buttonSettingsTable) do
            local HorizontalItem_clone = self:LoadPrefabFromPool("Module/Settings_shortcut_HorizontalItem", VertialContent)
            self.HorizontalItemList[key][k] = HorizontalItem_clone
            local desc = self:FindChildComponent(HorizontalItem_clone,"FunctionText","Text")
            desc.text = v['功能描述']
            local tipText = self:FindChild(HorizontalItem_clone,"field/TipText")
            local objKeyText = self:FindChild(HorizontalItem_clone,"field/KeyText")
            local keyText = self:FindChildComponent(HorizontalItem_clone,"field/KeyText","Text")
            local comFieldBtn = self:FindChildComponent(HorizontalItem_clone,"field","Button")
            local comFieldRect = self:FindChildComponent(HorizontalItem_clone,"field","RectTransform")
            local comResetBtn = self:FindChildComponent(HorizontalItem_clone,"Reset","Button")
            local img = self:FindChild(HorizontalItem_clone,"field/Image")
            local resetBtn = self:FindChild(HorizontalItem_clone,"Reset")

            objKeyText:SetActive(true)
            tipText:SetActive(false)
            if DEBUG_MODE then
                keyText.text = KeyCodeName[v.keyCode] or "未配置该按键别名"
            else
                keyText.text = KeyCodeName[v.keyCode] or ""
            end
            if v['是否支持自定义'] == false then
                img:SetActive(false)
                resetBtn:SetActive(false)
            else
                img:SetActive(true)
                if KeyboardManager:IsChanged(key,k,v.keyCode) then
                    resetBtn:SetActive(true)
                else
                    resetBtn:SetActive(false)
                end
            end
            --绑定改键功能
            if comFieldBtn then
                if v['是否支持自定义'] then
                    comFieldBtn.interactable = true
                    self:AddButtonClickListener(comFieldBtn,function()
                        objKeyText:SetActive(false)
                        tipText:SetActive(true)
                        local callback = function(currentKeycode)
                            if currentKeycode == KeyCode.Mouse0 then
                                local mousePos = CS.UnityEngine.Input.mousePosition
                                local isOnFieldUI = checkMousePos(comFieldRect, DRCSRef.Vec2(mousePos.x,mousePos.y),UI_Camera)
                                if isOnFieldUI then
                                    KeyboardManager:GetInstance():ContinueWaittingPressKey()
                                else
                                    objKeyText:SetActive(true)
                                    tipText:SetActive(false)
                                end
                            elseif IsMouseButton(currentKeycode) then
                                KeyboardManager:GetInstance():ContinueWaittingPressKey()
                            elseif currentKeycode == KeyCode.Escape then
                                v.keyCode = KeyCode.None
                                if DEBUG_MODE then
                                    keyText.text = KeyCodeName[v.keyCode] or "未配置该按键别名"
                                else
                                    keyText.text = KeyCodeName[v.keyCode] or ""
                                end
                                local defaultKeyCode = KeyboardManager:GetInstance():GetDefaultKeyCode(key,k)
                                resetBtn:SetActive(true)
                                objKeyText:SetActive(true)
                                tipText:SetActive(false)
                            else
                                if v.keyCode ~= currentKeycode then
                                    for ky,val in pairs(buttonSettingsTable) do
                                        -- 检查是否有功能已设置为此按键，有则将其设未None
                                        if val.keyCode == currentKeycode then
                                            if not val['是否支持自定义'] then
                                                SystemUICall:GetInstance():Toast("与不可自定义功能冲突！")
                                                return
                                            end
                                            v.keyCode = KeyCode.None
                                            if DEBUG_MODE then
                                                keyText.text = KeyCodeName[v.keyCode] or "未配置该按键别名"
                                            else
                                                keyText.text = KeyCodeName[v.keyCode] or ""
                                            end
                                            if keyText.text and keyText.text == "无" then
                                                keyText.color = COLOR_VALUE[COLOR_ENUM.WhiteGray]
                                            else
                                                keyText.color = COLOR_VALUE[COLOR_ENUM.White]
                                            end
                                            resetBtn:SetActive(true)
                                            objKeyText:SetActive(true)
                                            tipText:SetActive(false)
                                            KeyboardManager:GetInstance():Save(self.KeySettingsTable)
                                            -- HorizontalItem = self.HorizontalItemList[key][ky]
                                            -- local keyText = self:FindChildComponent(HorizontalItem,"field/KeyText","Text")
                                            -- local objReset = self:FindChild(HorizontalItem,"Reset")
                                            -- objReset:SetActive(true)
                                            -- if DEBUG_MODE then
                                            --     keyText.text = KeyCodeName[val.keyCode] or "未配置该按键别名"
                                            -- else
                                            --     keyText.text = KeyCodeName[val.keyCode] or ""
                                            -- end
                                            SystemUICall:GetInstance():Toast("已有功能设置为此按键！")
                                            
                                            return
                                        end
                                    end
                                    v.keyCode = currentKeycode
                                    if DEBUG_MODE then
                                        keyText.text = KeyCodeName[v.keyCode] or "未配置该按键别名"
                                    else
                                        keyText.text = KeyCodeName[v.keyCode] or ""
                                    end
                                    resetBtn:SetActive(true)
                                    KeyboardManager:GetInstance():Save(self.KeySettingsTable)
                                end
                                local defaultKeyCode = KeyboardManager:GetInstance():GetDefaultKeyCode(key,k)
                                resetBtn:SetActive(defaultKeyCode~=currentKeycode)
                                objKeyText:SetActive(true)
                                tipText:SetActive(false)
                            end
                            if keyText.text and keyText.text == "无" then
                                keyText.color = COLOR_VALUE[COLOR_ENUM.WhiteGray]
                            else
                                keyText.color = COLOR_VALUE[COLOR_ENUM.White]
                            end
                        end
                        KeyboardManager:GetInstance():StartWaittingPressKey(callback)
                    end)
                else
                    keyText.text = v["中文描述"]
                    comFieldBtn.interactable = false
                end
            end
            --绑定还原功能
            if comResetBtn then
                if v['是否支持自定义'] then
                    self:AddButtonClickListener(comResetBtn,function()
                        local defaultKeyCode = KeyboardManager:GetInstance():GetDefaultKeyCode(key,k)
                        for ky,val in pairs(buttonSettingsTable) do
                            -- 检查是否有功能已设置为此按键，有则将其设未None
                            if val.keyCode == defaultKeyCode and defaultKeyCode ~= KeyCode.None then
                                val.keyCode = KeyCode.None
                                HorizontalItem = self.HorizontalItemList[key][ky]
                                local keyText = self:FindChildComponent(HorizontalItem,"field/KeyText","Text")
                                if DEBUG_MODE then
                                    keyText.text = KeyCodeName[val.keyCode] or "未配置该按键别名"
                                else
                                    keyText.text = KeyCodeName[val.keyCode] or ""
                                end
                            end
                        end
                        v.keyCode = defaultKeyCode
                        if DEBUG_MODE then
                            keyText.text = KeyCodeName[v.keyCode] or "未配置该按键别名"
                        else
                            keyText.text = KeyCodeName[v.keyCode] or ""
                        end
                        resetBtn:SetActive(false)
                        KeyboardManager:GetInstance():Save(self.KeySettingsTable)
                        objKeyText:SetActive(true)
                        tipText:SetActive(false)
                        if keyText.text and keyText.text == "无" then
                            keyText.color = COLOR_VALUE[COLOR_ENUM.WhiteGray]
                        else
                            keyText.color = COLOR_VALUE[COLOR_ENUM.White]
                        end
                    end)
                end
            end

        end
    end
end

function SystemSettingUI:InitRegard()
    self.Button_Report = self:FindChildComponent(self._gameObject,"Panel_regard/Content/ButtonArea/Button_report","Button")
    if IsValidObj(self.Button_Report) then
        local fun = function()
			self:OnClick_Report_Button()
		end
		self:AddButtonClickListener(self.Button_Report,fun)
    end

    self.Button_Homepage = self:FindChildComponent(self._gameObject,"Panel_regard/Content/ButtonArea/Button_homepage","Button")
    if IsValidObj(self.Button_Homepage) then
        local fun = function()
            OpenOnlineShop()
		end
		self:AddButtonClickListener(self.Button_Homepage,fun)
    end
end

function SystemSettingUI:RefreshUI(info)
    -- 显示当前设置页
    if self.strCurPage then
        self:SetPageState(self.strCurPage, true)
    end
    -- 恢复设置单项
    -- 侠客行
    self.bIfInLoginUI = info or false 
    -- if IsValidObj(self.Button_Quit) then
    --     self.Button_Quit.gameObject:SetActive(not self.bIfInLoginUI)
    -- end

    local bQuickShootCondTrue = (PinballDataManager:GetInstance():GetHoodleAccNum() or 0) >= SSD_MIN_OPEN_TEN_SHOOT_HOODLE_NUM
    local bIsPinballQuickShootOn = (PinballDataManager:GetInstance():GetQuickShootState() == true)
    self.objTogPinballSetting:SetActive(true)--bQuickShootCondTrue or bIsPinballQuickShootOn
end

function SystemSettingUI:SetPageState(strPage, bIsOn)
    local bTransRes = false
    if strPage == "Voice" then
        self.objVoicePage:SetActive(bIsOn == true)
        self.textTogVoice.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true
    elseif strPage == "Battle" then
        self.objBattlePage:SetActive(bIsOn == true)
        self.textTogBattle.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true   
    elseif strPage == "Story" then
        self.objStoryPage:SetActive(bIsOn == true)
        self.textTogStory.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true   
    elseif strPage == "Frame" then
        self.objFramePage:SetActive(bIsOn == true)
        self.textTogFrame.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true
    elseif strPage == "System" then
        self.objSystemPage:SetActive(bIsOn == true)
        self.textTogSystem.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true
    elseif strPage == "Private" then
        self.objPrivatePage:SetActive(bIsOn == true)
        self.textTogPrivate.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true
    elseif strPage == "Shortcut" then
        self.objShortcutPage:SetActive(bIsOn == true)
        self.textTogShortcut.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true
    elseif strPage == "Regard" then
        self.objRegardPage:SetActive(bIsOn == true)
        self.textTogRegard.color = bIsOn and self.colorNavPick or self.colorNavUnPick
        bTransRes = true
    end
    if bTransRes and bIsOn then
        self.strCurPage = strPage
    end
end

function SystemSettingUI:OnYinYueValueChange(value)
    CS.GameApp.FMODManager.SetMusicVolume(value)
    SetConfig("confg_YinYue",value,true)

end

function SystemSettingUI:OnYinXiaoValueChange(value)
    CS.GameApp.FMODManager.SetSoundVolume(value)
    SetConfig("confg_YinXiao",value,true)
end

function SystemSettingUI:OnStoryChatSpeedValueChange(value)
    PlayerSetDataManager:GetInstance():SetStoryChatSpeedPercent(value)
end

function SystemSettingUI:OnAutoChatSpeedValueChange(value)
    PlayerSetDataManager:GetInstance():SetAutoChatWaitTimePercent(value)
end

function SystemSettingUI:OnClick_Quit_Button()
    local msg = "点击确定将返回至登录界面"
    local boxCallback = function()
        g_IS_AUTOLOGIN = false
        ReturnToLogin(true)
        SetConfig("Login_IsAgreeMent", false)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
end

function SystemSettingUI:OnClick_ExchangeCode_Button()
    OpenWindowImmediately('ExchangeCodeUI')
end

function SystemSettingUI:OnClick_Report_Button()
    --OpenWindowImmediately("BugReportUI")    
    local gid = G_UID or "1"
    local url = "https://wdxk.17m3.com/feedback/?gameId="..gid.."&&version="..CLIENT_VERSION
    CS.UnityEngine.Application.OpenURL(url);
end

function SystemSettingUI:OnClick_Report_Mod()
    --todo
    OpenWindowImmediately("ModUI")
end

function SystemSettingUI:OnClick_PrivateInfo()
    OpenWindowImmediately("PrivateMessageUI")
end

function SystemSettingUI:OnClick_PowerInfo()
    OpenWindowImmediately("SystemPowerUI")
end

function SystemSettingUI:OnDestroy()
    if self._slider then
        for _,value in pairs(self._slider) do
            value.onValueChanged:RemoveAllListeners()
        end
    end
end

return SystemSettingUI