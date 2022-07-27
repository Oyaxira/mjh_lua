ToastUI = class("ToastUI",BaseWindow)

function ToastUI:ctor()
end

function ToastUI:Create()
	local obj = LoadPrefabAndInit("ToastUI/ToastUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ToastUI:Init()
    self.toastInstDict = {}
end

function ToastUI:RefreshUI(toastInfo)
    if type(toastInfo) == 'table' then
        self:AddToast(toastInfo)
    end
end

function ToastUI:AddToast(toastInfo)
    local curToastCount = self:GetCurToastCount()
    if curToastCount >= MAX_TOAST_COUNT then 
        self:AddToastCache(toastInfo)
        return
    end
    local toastInst = self:GetAvaliableToastInst(toastInfo.type)
    if toastInst == nil then
        return
    end
    self:ResetToastInst(toastInst)
    local comText = self:FindChildComponent(toastInst, 'Text', 'Text')
    if tonumber(toastInfo['text']) ~= nil then 
        languageID =  tonumber(toastInfo['text'])
        toastInfo['text'] = GetLanguageByID(languageID) or ''
    end
    comText.text = toastInfo['text']
    local comCanvasGroup = toastInst:GetComponent("CanvasGroup")
    local tween = Twn_CanvasGroupFade(nil, comCanvasGroup, 0, 1, TOAST_FADE_DELTA_TIME, 0, function()
        local tween1 = Twn_CanvasGroupFade(nil, comCanvasGroup, 1, 0, TOAST_FADE_DELTA_TIME, TOAST_SHOW_DELTA_TIME, function()
            if toastInst then
                toastInst.gameObject:SetActive(false)
            end
            if self and self.ShowNextToast then 
                self:ShowNextToast()
            end 
        end)
    end)
end

function ToastUI:AddToastCache(toastInfo)
    if self.toastCache == nil then 
        self.toastCache = {}
    end
    table.insert(self.toastCache, toastInfo)
end

function ToastUI:ShowNextToast()
    if self.toastCache == nil or #self.toastCache == 0 then
        return
    end
    local toastInfo = table.remove(self.toastCache, 1)
    self:AddToast(toastInfo)
end

function ToastUI:GetCurToastCount()
    local activeToastCount = 0
    for toastType, toastInstList in pairs(self.toastInstDict) do 
        for _, toastInst in ipairs(toastInstList) do 
            if toastInst.gameObject.activeSelf then 
                activeToastCount = activeToastCount + 1
            end
        end
    end
    return activeToastCount
end

function ToastUI:GetAvaliableToastInst(toastType)
    if toastType == nil then 
        return nil
    end
    self.toastInstDict[toastType] = self.toastInstDict[toastType] or {}
    for _, toastInst in ipairs(self.toastInstDict[toastType]) do 
        if not toastInst.gameObject.activeSelf then 
            return toastInst
        end
    end
    local toastInst = nil
    if toastType == TOAST_TYPE.NORMAL then
        toastInst = LoadPrefabAndInit("ToastUI/Toast_Title", self._gameObject, true)
    elseif toastType == TOAST_TYPE.TASK then
        toastInst = LoadPrefabAndInit("ToastUI/Toast_Task", self._gameObject, true)
    elseif toastType == TOAST_TYPE.SYSTEM then
        toastInst = LoadPrefabAndInit("ToastUI/Toast_System", self._gameObject, true)
    end
    
    self:SaveToastInst(toastType, toastInst)
    return toastInst
end

function ToastUI:SaveToastInst(toastType, toastInst)
    if toastType == nil or toastInst == nil then 
        return
    end
    table.insert(self.toastInstDict[toastType], toastInst)
end

function ToastUI:ResetToastInst(toastInst)
    toastInst.transform:SetAsLastSibling()
    toastInst:SetActive(true)
    local comCanvasGroup = toastInst:GetComponent("CanvasGroup")
    comCanvasGroup.alpha = 0
end

return ToastUI