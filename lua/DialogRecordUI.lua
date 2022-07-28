DialogRecordUI = class("DialogRecordUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function DialogRecordUI:Create()
	local obj = LoadPrefabAndInit("Game/DialogRecordUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DialogRecordUI:Init()
	self.objRoot = self:FindChild(self._gameObject, "Content")
	self.objTips = self:FindChild(self.objRoot, "Tips")
	self.objSC = self:FindChild(self.objRoot, "SC")
	self.comSC = self.objSC:GetComponent('LoopListView2')

	self.btnClose = self:FindChildComponent(self._gameObject, "frame/Btn_exit", l_DRCSRef_Type.Button)
	self:AddButtonClickListener(self.btnClose, function()
		self:DoExit()
	end)

	self.RebuildLayout = CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate
	self.bSCFirstUpdate = false
end

function DialogRecordUI:OnPressESCKey()
	if self.btnClose then
		self.btnClose.onClick:Invoke()
	end
end

function DialogRecordUI:RefreshUI()
	-- 获取对话记录队列
	self.kCurQueue = DialogRecordDataManager:GetInstance():GetQueue()
	self.iQueueLen = #self.kCurQueue
	self.objTips:SetActive(self.iQueueLen == 0)
	self.objSC:SetActive(self.iQueueLen > 0)
	if self.iQueueLen == 0 then
		return
	end
	-- 设置滚动栏数据
	if not self.bSCFirstUpdate then
		self.bSCFirstUpdate = true
        self.comSC:InitListView(self.iQueueLen, function(comSC, index)
			return self:OnGetItemByIndex(comSC, index)
        end)
	else
		self.comSC:SetListItemCount(self.iQueueLen, false)
        self.comSC:RefreshAllShownItem()
	end
	self.comSC:MovePanelToItemIndex(self.iQueueLen, 0)
end

function DialogRecordUI:OnGetItemByIndex(comSC, index)
	local kData = self.kCurQueue[index + 1]
	if not kData then
		return
	end
	local kSCItem = nil
	local objNode = nil
	-- 他人 对话气泡
	if kData.type == "Others" then
		kSCItem = comSC:NewListViewItem('DialogRecordBubbleOthers')
		if kSCItem then
			objNode = kSCItem.gameObject
		end
		self:SetRoleBubble(objNode, kData)
	-- 自身 对话气泡
	elseif kData.type == "Me" then
		kSCItem = comSC:NewListViewItem('DialogRecordBubbleMe')
		if kSCItem then
			objNode = kSCItem.gameObject
		end
		self:SetRoleBubble(objNode, kData)
	-- 系统/旁白 对话气泡
	elseif kData.type == "System" then
		kSCItem = comSC:NewListViewItem('DialogRecordBubbleSystem')
		if kSCItem then
			objNode = kSCItem.gameObject
		end
		self:SetSystemBubble(objNode, kData)
	end
	if not objNode then
		return
	end
	local rectNode = objNode:GetComponent("RectTransform")
	self.RebuildLayout(rectNode)
	return kSCItem
end

-- 更新对话气泡 - 他人
-- {
-- 	['type'] = 'Others',
-- 	['role'] = 0,
--	['avatar'] = "xxx/xxx.png",
-- 	['name'] = 'jack',
-- 	['content'] = 'hello',
-- }
function DialogRecordUI:SetRoleBubble(objRoot, kData)
	if (not objRoot) or (not kData) then
		return
	end
	local strType = kData.type or ""
	local objNode = self:FindChild(objRoot, strType)
	if not objNode then
		return
	end
	local objCreateFace = self:FindChild(objRoot, "Create_Head(Clone)")
	-- head TODO 捏脸16 头像 kData.roleBaseID
	local imgHead = self:FindChildComponent(objNode, "Head/Head/Mask/Image", l_DRCSRef_Type.Image)
	imgHead.sprite = GetSprite(kData.avatar)
	local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()

	-- 判断是否为主角并且有捏脸数据
	local iMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
	local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
	local iRoleTypeId = kData.roleBaseID 
	
	if iRoleTypeId == iMainRoleTypeID then 
		iRoleTypeId = iMainRoleCreateRoleID
	end
	if iRoleTypeId == iMainRoleCreateRoleID and CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeId) then
		local objParent = imgHead.gameObject.transform.parent
		-- 调用接口 生成头像Prefab
		if objCreateFace then
			objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeId, objParent, objCreateFace)
			objCreateFace:SetActive(true)
		else
			objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeId, objParent)
		end
		imgHead.gameObject:SetActive(false)
	else
		if objCreateFace then
			objCreateFace:SetActive(false)
		end
		imgHead.gameObject:SetActive(true)
	end
	-- name
	local objName = self:FindChild(objNode, "Content/Name")
	local textName = self:FindChildComponent(objName, "Text", l_DRCSRef_Type.Text)
	textName.text = kData.name or "角色名称"
	-- msg
	local objContent = self:FindChild(objNode, "Content")
	local objMsg = self:FindChild(objContent, "Msg")
	local objMsgText = self:FindChild(objMsg, "Text")
	local textContent = objMsgText:GetComponent(l_DRCSRef_Type.Text)
	textContent.text = kData.content or ""


	local uiRoleID = RoleDataManager:GetInstance():GetRoleID(kData.roleBaseID)
	local comTitleFlag = self:FindChildComponent(objNode, "Content/Name/TitleFlag", 'DRButton')
	if comTitleFlag then 
		local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(uiRoleID,NET_NAME_ID)
		if BeEvolution and BeEvolution.iParam2 == -1 then
			comTitleFlag.gameObject:SetActive(true)
		else
			comTitleFlag.gameObject:SetActive(false)
		end 
	end 
end

-- 更新对话气泡 - 系统
-- {
-- 	['type'] = 'System',
-- 	['content'] = 'hello',
-- }
function DialogRecordUI:SetSystemBubble(objNode, kData)
	if (not objNode) or (not kData) then
		return
	end
	-- msg
	local textContent = self:FindChildComponent(objNode, "Text", l_DRCSRef_Type.Text)
	textContent.text = kData.content or ""
end

-- 设置关闭回调
function DialogRecordUI:SetCloseCallback(funcCallback)
	self.funcCloseCallback = funcCallback
end

-- 退出
function DialogRecordUI:DoExit()
	RemoveWindowImmediately("DialogRecordUI")
	if self.funcCloseCallback then
		self.funcCloseCallback()
		self.funcCloseCallback = nil
	end
end

function DialogRecordUI:OnDestroy()
	self.comSC.mOnGetItemByIndex = nil
	self.bSCFirstUpdate = false
end

return DialogRecordUI