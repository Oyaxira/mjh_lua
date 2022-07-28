SetNicknameTip = class('SetNicknameTip', BaseWindow)
local forbidText = require 'ForbidText'
local forbidTexts = string.split(forbidText, '\n')

local Warning = '请在输入框中输入%s对你的爱称\n爱称最长不超过4个字'

function SetNicknameTip:Create()
    local obj = LoadPrefabAndInit("Role/SetNicknameTip",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function SetNicknameTip:OnPressESCKey()
    if self.close_btn then
        self.close_btn.onClick:Invoke()
    end
end

function SetNicknameTip:Init()
    self.close_btn = self:FindChildComponent(self._gameObject, "Btn_exit", DRCSRef_Type.Button)
    self.comBtnGreen = self:FindChildComponent(self._gameObject, 'Button_green', DRCSRef_Type.Button)
    self.comBtnRed = self:FindChildComponent(self._gameObject, 'Button_red', DRCSRef_Type.Button)
    self.comContentText = self:FindChildComponent(self._gameObject, 'content_box/Text', "EmojiText")
    self.objInputConfirm = self:FindChild(self._gameObject, "InputRoot")
    self.comInputConfirm = self:FindChildComponent(self.objInputConfirm, "InputField", DRCSRef_Type.InputField)
    self.comInputPlaceHolder = self:FindChildComponent(self.objInputConfirm, "InputField/Placeholder", DRCSRef_Type.Text)

    if self.close_btn then
        self:AddButtonClickListener(self.close_btn,function()
            if self.netData and self.netData.iType then
                SendClickDialogCMD(self.netData.iType, self.netData.iTask, self.netData.iRet, 0)
            end
            RemoveWindowImmediately("SetNicknameTip",false)
		end)        
    end

    if self.comBtnGreen then
        self:AddButtonClickListener(self.comBtnGreen,function()
            self:check_rolename(self.comInputConfirm.text)
		end)  
    end

    if self.comBtnRed then
        self:AddButtonClickListener(self.comBtnRed,function()
            RemoveWindowImmediately("SetNicknameTip",false)
		end)          
    end

    if self.comInputConfirm then
        local fun = function(str)
            self.name = str
        end
        self.comInputConfirm.onEndEdit:AddListener(fun)
    end  

    self.name = ""
    self.roleID = 0
end

function SetNicknameTip:RefreshUI(info)
    self.roleID = info
    self.comContentText.text = string.format(Warning,RoleDataManager:GetInstance():GetRoleNameByTypeID(self.roleID))
    local mainName = RoleDataManager:GetInstance():GetMainRoleName()
    local info = globalDataPool:getData("MainRoleInfo")
    if info["NpcNickName"] and info["NpcNickName"][self.roleID] then
        mainName = info["NpcNickName"][self.roleID]
    end
    self.comInputPlaceHolder.text = mainName
end

local IsNotAllSimpleChinese = function(str)
	local strList = {utf8.codepoint(str,1,-1)}
    for i=1,#strList do
		if strList[i] < 0x4e00 or strList[i] >  0x9fa5 then
			return true
		end
	end
	return false
end

function IsForbid(str)
	for k = 1, #forbidTexts do
		if string.find(str, forbidTexts[k]) then
			return true
		end
	end
	return false
end

function SetNicknameTip:check_rolename(string_name)
	string_name = string_name or ''
    if IsForbid(string_name) then
        self.err_log = "爱称中包含敏感词汇"
		SystemUICall:GetInstance():Toast(self.err_log)--
		self.comInputConfirm.text = ""
        return
    end
    if string.len(string_name) == 0 then
        self.err_log = "爱称不可为空"
        SystemUICall:GetInstance():Toast(self.err_log)
        return
    end
    if string.len(string_name) > 12 then
        self.err_log = "爱称不可以超过四个字"
        SystemUICall:GetInstance():Toast(self.err_log)
        return
    end
    if string.find(string_name,' ') then
        self.err_log = "爱称中不可以有空格"
        SystemUICall:GetInstance():Toast(self.err_log)
        return
    end
    if IsNotAllSimpleChinese(string_name) then
        self.err_log = "爱称只能使用全中文"
        SystemUICall:GetInstance():Toast(self.err_log)
        return
    end
    local str = string.format("好，以后我就称呼你为【%s】！",self.name)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false,self.roleID, str)
    SendClickSetNickName(self.roleID, self.name)

    RemoveWindowImmediately("SetNicknameTip",false)
end

function SetNicknameTip:OnEnable()
    
end

function SetNicknameTip:OnDisable()

end

function SetNicknameTip:OnDestroy()
end

return SetNicknameTip