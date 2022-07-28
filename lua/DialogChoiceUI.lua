DialogChoiceUI = class("DialogChoiceUI",BaseWindow)

function DialogChoiceUI:ctor()
	
end

local KeyCodeNum = {
    CS.UnityEngine.KeyCode.Alpha1,
    CS.UnityEngine.KeyCode.Alpha2,
    CS.UnityEngine.KeyCode.Alpha3,
    CS.UnityEngine.KeyCode.Alpha4,
    CS.UnityEngine.KeyCode.Alpha5,
    CS.UnityEngine.KeyCode.Alpha6,
    CS.UnityEngine.KeyCode.Alpha7,
    CS.UnityEngine.KeyCode.Alpha8,
    CS.UnityEngine.KeyCode.Alpha9,
}

local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown

function DialogChoiceUI:Create()
	local obj = LoadPrefabAndInit("Interactive/DialogueChoseUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DialogChoiceUI:Init()
    self.objDialogUI  = self:FindChild(self._gameObject, "DialogueUI")
    self.objChoiceUI  = self:FindChild(self._gameObject, "ChoiceUI")

    self.DialogUIInstacne = DialogueUI.new()
    self.DialogUIInstacne:ExternalInit(self.objDialogUI, 'DialogueUI', self._gameObject)

    self.ChoiceUIInstacne = ChoiceUI.new()
    self.ChoiceUIInstacne:SetGameObject(self.objChoiceUI)
    self.ChoiceUIInstacne:Init()

    self.comScreenClickBtn = self:FindChildComponent(self._gameObject,"ScreenClick", DRCSRef_Type.Button)
	if self.comScreenClickBtn then
		self:AddButtonClickListener(self.comScreenClickBtn, function()
            self:OnClickScreen()
		end)
    end
    
    self.objDialogUI:SetActive(false)
    self.objChoiceUI:SetActive(false)

    -- 注册事件
    self:AddEventListener("DialogEnd", function()
        self:OnDialogEnd()
    end)
    self:AddEventListener("DialogueSoundEnd", function()
        if self.bSoundEndTrigger ~= true then
            return
        end
        self.bSoundEndTrigger = false
        self:OnDialogEnd()
    end)
end

function DialogChoiceUI:OnClickScreen()
    --顺序不能换 因为会移除界面 导致 self 失效
    if self.objDialogUI.activeSelf then
        if self.DialogUIInstacne:OnClickDialogue(false) then 
            self.objDialogUI:SetActive(false)
            RemoveWindowImmediately('DialogChoiceUI', true)
            self:DisplayActionEnd()
        end
    elseif self.objChoiceUI.activeSelf then
        return
    else
        RemoveWindowImmediately('DialogChoiceUI', true)
        self:DisplayActionEnd()
    end
end

function DialogChoiceUI:DisplayActionEnd()
    -- 如果是限时礼包的特殊状态 对话不displayend
    if not LimitShopManager:GetInstance():GetLimitActionEnd() then 
        return 
    end 
    DisplayActionEnd()
end

function DialogChoiceUI:RefreshUI(config)
    self.Config = config
    self.objDialogUI:SetActive(false)
    self.objChoiceUI:SetActive(false)
    if config and config.dialogui then
        self.objDialogUI:SetActive(true)
        self.DialogUIInstacne:RefreshUI(config.dialogui)
    elseif config and config.choseui then
        self.objChoiceUI:SetActive(true)
        self.ChoiceUIInstacne:RefreshUI(config.choseui)
        -- 显示选项的时候, 关闭快进对话模式
        DialogRecordDataManager:GetInstance():SetFastChatState(false)
    end
end

function DialogChoiceUI:IsSelectState()
    if IsValidObj(self.objChoiceUI) then
        return self.objChoiceUI.activeSelf
    else
        return false
    end
end

function DialogChoiceUI:Update()
	for index = 1,9 do
		if l_GetKeyDown(KeyCodeNum[index]) then
			self.ChoiceUIInstacne:ActivateBtn(index)
		end
	end
    
	self.DialogUIInstacne:Update()
end


function DialogChoiceUI:OnEnable()
    self.DialogUIInstacne:OnEnable()
    self.ChoiceUIInstacne:OnEnable()
end

function DialogChoiceUI:OnDisable()
    self.DialogUIInstacne:OnDisable()
    self.ChoiceUIInstacne:OnDisable()
end

function DialogChoiceUI:OnDestroy()
    self.DialogUIInstacne:Close()
    self.ChoiceUIInstacne:Close()
end

function DialogChoiceUI:OnPressESCKey()
    if self.objChoiceUI.activeSelf and not IsWindowOpen("ObserveUI") then
        self.ChoiceUIInstacne:OnPressESCKey()
    end
end

function DialogChoiceUI:DialogueRecoverSpeed()
	self.DialogUIInstacne:DialogueRecoverSpeed()
end

-- Choice
function DialogChoiceUI:AddChoice(choiceLangID, customCallback, isLocked, choiceText, isKeyChoice)
    self.objChoiceUI:SetActive(true)
    self.objDialogUI:SetActive(false)
    self.ChoiceUIInstacne:AddChoice(choiceLangID, customCallback, isLocked, choiceText, nil, isKeyChoice)
end

function DialogChoiceUI:UpdateChoiceText(textLangID, roleTypeID, tipText,boolean_outline)
    self.objChoiceUI:SetActive(true)
    self.objDialogUI:SetActive(false)
    self.ChoiceUIInstacne:UpdateChoiceText(textLangID, roleTypeID, tipText,boolean_outline)
end

function DialogChoiceUI:UpdateChoice(taskID)
    local choiceInfo = TaskDataManager:GetInstance():GetChoiceInfo(taskID)
    if choiceInfo == nil then 
        return
    end
    
    self.objChoiceUI:SetActive(true)
    self.objDialogUI:SetActive(false)
    self.ChoiceUIInstacne:ResetChoiceUI()
    -- UpdateChoiceText(textLangID, roleTypeID, tipText, boolean_outline, taskID)
    self.ChoiceUIInstacne:UpdateChoiceText(choiceInfo.textLangID, choiceInfo.roleBaseID, nil, nil, choiceInfo.taskID, choiceInfo.customModelID, choiceInfo.playerName)
    if choiceInfo.choiceList ~= nil then 
        for _, choice in ipairs(choiceInfo.choiceList) do 
            self.ChoiceUIInstacne:AddChoice(choice.choiceLangID, nil, choice.isLocked, nil, nil, choice.isImportantChoice, choiceInfo.taskID)
        end
    end

    -- 显示选项的时候, 关闭快进对话模式
	DialogRecordDataManager:GetInstance():SetFastChatState(false)
end

function DialogChoiceUI:UpdateChoiceTextStr(textLangID, roleTypeID, tipText,boolean_outline)
    self.objChoiceUI:SetActive(true)
    self.objDialogUI:SetActive(false)
    self.ChoiceUIInstacne:UpdateChoiceTextStr(textLangID, roleTypeID, tipText,boolean_outline)
end

function DialogChoiceUI:ShowRoleFavorUp(roleTypeID, iStart, iEnd)
	self.DialogUIInstacne:ShowRoleFavorUp(roleTypeID, iStart, iEnd)
end

function DialogChoiceUI:OnDialogEnd()
    -- 对话记录界面开启时, 暂听 自动对话/快进对话
    if IsWindowOpen("DialogRecordUI") then
        local win = GetUIWindow("DialogRecordUI")
        win:SetCloseCallback(function()
            LuaEventDispatcher:dispatchEvent("DialogEnd") 
        end)
        return
    end
    -- 帮派邀请对话界面打开时暂停
    if IsWindowOpen("ClanCardUI") then
        return
    end
    local kDialogRecMgr = DialogRecordDataManager:GetInstance()
    local bFastChatOpen = (kDialogRecMgr:IsFastChatOpen() == true)  -- 快进对话模式
    local bAutoChatOpen = (kDialogRecMgr:IsAutoChatOpen() == true)  -- 自动对话模式
    if bFastChatOpen or bAutoChatOpen then
        if self.iAutoChatTimer then
            self:RemoveTimer(self.iAutoChatTimer)
            self.iAutoChatTimer = nil
        end
        local uiWaitTime = 0
        if bFastChatOpen then
            uiWaitTime = FASTCHAT_WAIT_TIME
        else
            uiWaitTime = PlayerSetDataManager:GetInstance():GetAutoChatWaitTime()
        end
        if (not uiWaitTime) or (uiWaitTime <= 0) then
            return
        end
        self.iAutoChatTimer = self:AddTimer(uiWaitTime, function()
            local win = GetUIWindow("DialogChoiceUI")
            if not win then
                return
            end
            -- 当计时器到期时, 如果用户已经关闭了自动对话与快进对话, 那么直接返回
            local bAuto = kDialogRecMgr:IsAutoChatOpen() == true
            local bFast = kDialogRecMgr:IsFastChatOpen() == true
            if (not bAuto) and (not bFast) then
                return
            end
            -- 如果计时器到期时, 语音还在播放, 
            -- 如果是快进对话模式, 直接停止语音
            -- 如果是自动对话模式, 那么点击下一句的行为交给语音结束时去触发
            if kDialogRecMgr:GetDialogSoundPlayState() == true then
                if bFast then
                    win.DialogUIInstacne:StopDialogSound()
                elseif bAuto then
                    win.bSoundEndTrigger = true
                    return
                end
            end
            -- 计时器到期触发点击下一句
            win:OnClickScreen()
        end)
    end
end

return DialogChoiceUI