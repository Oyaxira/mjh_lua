SaveFileUI = class("SaveFileUI", BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function SaveFileUI:Create()
	local obj = LoadPrefabAndInit("Game/SaveFileUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SaveFileUI:Init()
	self.comCloseButton = self:FindChildComponent(self._gameObject, "frame/Btn_exit", l_DRCSRef_Type.Button)
	self.objEmptyNode = self:FindChild(self._gameObject, "FileNode/EmptyNode")
	self.comFileScrollPool = self:FindChildComponent(self._gameObject, "FileNode/FileLoop/LoopScrollView", l_DRCSRef_Type.LoopVerticalScrollRect)
	self.objFileScrollContent = self:FindChild(self._gameObject, "FileNode/FileLoop/LoopScrollView/Content")
	if self.comFileScrollPool then
		self.comFileScrollPool:AddListener(
			function(...)
				self:RefreshFileScroll(...)
			end
		)
	end
	if self.comCloseButton then
		self:RemoveButtonClickListener(self.comCloseButton)
		self:AddButtonClickListener(self.comCloseButton, function ()
			RemoveWindowImmediately("SaveFileUI")
		end)
	end
	self.comNewFileTipsButton = self:FindChildComponent(self._gameObject, "Btns/NewFileButton", l_DRCSRef_Type.Button)
	self.comSaveFileButton = self:FindChildComponent(self._gameObject, "Btns/SaveFileButton", l_DRCSRef_Type.Button)
	self.comLoadFielButton = self:FindChildComponent(self._gameObject, "Btns/LoadFielButton", l_DRCSRef_Type.Button)
	self.comDeleteButton = self:FindChildComponent(self._gameObject, "Btns/DeleteButton", l_DRCSRef_Type.Button)

	if self.comNewFileTipsButton then
		self:RemoveButtonClickListener(self.comNewFileTipsButton)
		self:AddButtonClickListener(self.comNewFileTipsButton, function ()
			local config = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
			local iMax = 99
			if config then
				iMax = config.SaveMax
			end
			if getTableSize2(self.akSaveFile) >= iMax then
				SystemUICall:GetInstance():Toast("存档数量已到达上限")
				return
			end
			self.comInput_InputField.text = ""
			self.objNewFileTips:SetActive(true)
		end)
	end

	if self.comSaveFileButton then
		self:RemoveButtonClickListener(self.comSaveFileButton)
		self:AddButtonClickListener(self.comSaveFileButton, function ()
			self:OnClickSaveFile()
		end)
	end

	if self.comLoadFielButton then
		self:RemoveButtonClickListener(self.comLoadFielButton)
		self:AddButtonClickListener(self.comLoadFielButton, function ()
			self:OnClickLoadFile()
		end)
	end

	if self.comDeleteButton then
		self:RemoveButtonClickListener(self.comDeleteButton)
		self:AddButtonClickListener(self.comDeleteButton, function ()
			self:OnClickDeleteFile()
		end)
	end

	self.objNewFileTips = self:FindChild(self._gameObject, "NewFileTips")
	self.comCloseTipsButton = self:FindChildComponent(self._gameObject, "NewFileTips/PopUpWindow_2/newFrame/Btn_exit", l_DRCSRef_Type.Button)
	self.comNewFileButton = self:FindChildComponent(self._gameObject, "NewFileTips/Button/Button_green", l_DRCSRef_Type.Button)
	self.objInput = self:FindChild(self._gameObject,"NewFileTips/InputRoot/InputField")
	self.comInput_InputField = self.objInput:GetComponent("InputField")

	if self.comNewFileButton then
		self:RemoveButtonClickListener(self.comNewFileButton)
		self:AddButtonClickListener(self.comNewFileButton, function ()
			self:OnClickNewFile()
		end)
	end

	if self.comCloseTipsButton then
		self:RemoveButtonClickListener(self.comCloseTipsButton)
		self:AddButtonClickListener(self.comCloseTipsButton, function ()
			self.objNewFileTips:SetActive(false)
		end)
	end

	if self.comInput_InputField then
		local fun = function(str)
			self:CheckName(str)
		end
		self.comInput_InputField.onEndEdit:AddListener(fun)
	end
end

function SaveFileUI:CheckName(string_name)
	string_name = string.gsub(string_name, "^%s*(.-)%s*$", "%1") or ''
	if string.len(string_name) == 0 then
		self.err_log = "存档名不可为空"
		SystemUICall:GetInstance():Toast(self.err_log)
		return
	elseif string.len(string_name) > 24 then
		self.err_log = "存档名不可以超过8个字"
		SystemUICall:GetInstance():Toast(self.err_log)
		return
	elseif IsForbid(string_name) then
		self.err_log = "存档名中包含敏感词汇"
		SystemUICall:GetInstance():Toast(self.err_log)--
		return
	elseif self:CheckRepeatFile(string_name) then
		self.err_log = "已有存档名重复，请删除重复的存档"
		SystemUICall:GetInstance():Toast(self.err_log)--
		return
	end
	self.comInput_InputField.text = string_name
	self.strNewFileName = string_name
end

function SaveFileUI:CheckRepeatFile(strName)
	for key, value in pairs(self.akSaveFile) do
		if value[1] == strName then
			return true
		end
	end
	return false
end

function SaveFileUI:RefreshUI()
	self.strNewFileName = ""
	self.strCurFileName = ""
	self.objNewFileTips:SetActive(false)
	self:UpdateFileInfo()
end

function SaveFileUI:UpdateFileInfo()
	self.akSaveFile = SaveFileDataManager:GetInstance():GetSaveFileInfo()
	local iSaveFileLength = getTableSize2(self.akSaveFile)
	self.comFileScrollPool.totalCount = iSaveFileLength
    self.comFileScrollPool:RefillCells()
end

function SaveFileUI:OnClickNewFile()
    if string.len(self.strNewFileName) ~= 0 then
		SaveFileDataManager:GetInstance():SendNewSaveFile(self.strNewFileName)
	end
	self.objNewFileTips:SetActive(false)
	self.strNewFileName = ""
end

function SaveFileUI:OnClickSaveFile()
    if string.len(self.strCurFileName) ~= 0 then
		SaveFileDataManager:GetInstance():SendSaveFile(self.strCurFileName)
	end
end

function SaveFileUI:OnClickLoadFile()
    if string.len(self.strCurFileName) ~= 0 then
		SaveFileDataManager:GetInstance():SendLoadSaveFile(self.strCurFileName)
	end
end

function SaveFileUI:OnClickDeleteFile()
    if string.len(self.strCurFileName) ~= 0 then
		SaveFileDataManager:GetInstance():SendDelectSaveFile(self.strCurFileName)
		self.strCurFileName = ""
	end
end

function SaveFileUI:RefreshFileScroll(transform, index)
	local kCurData = self.akSaveFile[index + 1]
	if kCurData then
		local comNameText = self:FindChildComponent(transform.gameObject, "TextNode/NameText", l_DRCSRef_Type.Text)
		local comTimeText = self:FindChildComponent(transform.gameObject, "TextNode/TimeText", l_DRCSRef_Type.Text)
		local comIconImage = self:FindChildComponent(transform.gameObject, "Icon", l_DRCSRef_Type.Image)
		local objHight = self:FindChild(transform.gameObject, "HightImage")
		local comButton = transform.gameObject:GetComponent(l_DRCSRef_Type.Button)
		objHight:SetActive(self.strCurFileName == kCurData.Name)
		comNameText.text = kCurData[1]
		comTimeText.text = kCurData[3]
		if kCurData[2] then
			comIconImage.sprite = kCurData[2]
		else
			comIconImage.sprite = GetSprite("SaveFile/bg_right_panel")
		end
		
		if comButton then
			self:RemoveButtonClickListener(comButton)
			self:AddButtonClickListener(comButton, function ()
				self.strCurFileName = kCurData[1]
				self:HideHigth()
				objHight:SetActive(true)
				self:ChangeButtonState(index ~= 0)
			end)
		end
		if string.len(self.strCurFileName) == 0 then
			comButton.onClick:Invoke()
		end
	end
end

function SaveFileUI:HideHigth()
	local childCount = self.objFileScrollContent.transform.childCount
	for i = 1, childCount do 
		objItem = self.objFileScrollContent.transform:GetChild(i - 1)
		if objItem then
			local objHight = self:FindChild(objItem.gameObject, "HightImage")
            objHight:SetActive(false)
        end
	end
end

function SaveFileUI:ChangeButtonState(bHide)
	self.comSaveFileButton.gameObject:SetActive(bHide)
	self.comDeleteButton.gameObject:SetActive(bHide)
end

function SaveFileUI:OnPressESCKey()
	if self.objNewFileTips.activeSelf then
		self.objNewFileTips:SetActive(false)
	else
		if self.comCloseButton then
			self.comCloseButton.onClick:Invoke()
		end
	end
end


return SaveFileUI