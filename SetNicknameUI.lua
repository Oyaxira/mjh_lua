SetNicknameUI = class('SetNicknameUI', BaseWindow)

local Warning = '请在输入框中输入%s对你的爱称\n爱称最长不超过4个字'

function SetNicknameUI:Create()
    local obj = LoadPrefabAndInit("Role/MarryUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function SetNicknameUI:OnPressESCKey()
    if self.close_btn then
        self.close_btn.onClick:Invoke()
    end
end

function SetNicknameUI:Init()
    self.confirm_btn = self:FindChildComponent(self._gameObject, "Button_submit", DRCSRef_Type.Button)
    self.close_btn = self:FindChildComponent(self._gameObject, "Btn_exit", DRCSRef_Type.Button)
    self.scrollRect = self:FindChildComponent(self._gameObject, "LoopScrollView","LoopVerticalScrollRect")
    self.title = self:FindChildComponent(self._gameObject, "Title","Text")
    self.bottom_text = self:FindChildComponent(self._gameObject, "Text_bottom","Text")

    if self.confirm_btn then
        self:AddButtonClickListener(self.confirm_btn,function()
			if not self.choseid then
                SystemUICall:GetInstance():Toast('请先选择一名角色')
                return
            end
            OpenWindowImmediately('SetNicknameTip', self.choseid)
		end)
    end

    if self.close_btn then
        self:AddButtonClickListener(self.close_btn,function()
            RemoveWindowImmediately("SetNicknameUI",false)
		end)        
    end

    --数据
    self.list = {}
    self.choseid = nil
    self.title.text = "设置爱称"
    self.bottom_text.text = "请选择一名已誓约/结义的角色修改对自己的称呼"
end

function SetNicknameUI:RefreshUI(info)
    self.scrollRect:AddListener(function(...) self:UpdateItem(...) end)
    self:InitList()
end

function SetNicknameUI:InitList(info)
    local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
    self.list = {}
    for i,v in pairs(teammates) do
        if self:CanEdit(v) then
            local roledata = RoleDataManager:GetInstance():GetRoleData(v)
            if roledata then
                table.insert(self.list, roledata)
            end
        end
    end
    self.listobj = {}
    self:UpdateList()

    if #self.list == 0 then
        SystemUICall:GetInstance():Toast('队伍中无可选择角色')
    end
end

function SetNicknameUI:UpdateList()
    self.scrollRect.totalCount = #self.list
	self.scrollRect:RefillCells()
end

function SetNicknameUI:UpdateItem(transform,iIndex)
    local roledata = self.list[iIndex +1]
    if not roledata then
        return
    end
    local iRoleID = roledata.uiID
    local iTypeID = roledata.uiTypeID

	local nameText = self:FindChildComponent(transform.gameObject,"Name_Text","Text")
	local strName = RoleDataManager:GetInstance():GetRoleTitleAndName(iRoleID)
	nameText.text = getRankBasedText(RoleDataManager:GetInstance():GetRoleRank(iRoleID), strName)

    local LevelText = self:FindChildComponent(transform.gameObject,"Level_Text","Text")
    local uiLevel = roledata.uiLevel or 0
    LevelText.text = getRankBasedText(RoleDataManager:GetInstance():GetRoleRank(iRoleID),uiLevel.."级")
    
    local objshose = self:FindChild(transform.gameObject,'Choose_Image')
    local headImage = self:FindChildComponent(transform.gameObject,"Head_Dispositions/head","Image")
    if headImage then
        local kPath = roledata:GetDBHead()
        headImage.sprite = GetSprite(kPath)
    end

    local dragItem = self:FindChildComponent(transform.gameObject,"Head_Dispositions","DRButton")
    self:AddButtonClickListener(dragItem,function() 
        OpenWindowImmediately("ObserveUI", {['roleID'] = iRoleID})
    end)
    local WatchItem = self:FindChildComponent(transform.gameObject,"Button_Watch","DRButton")
    self:AddButtonClickListener(WatchItem,function() 
        self.choseid = iTypeID
        self.name = RoleDataManager:GetInstance():GetRoleName(iRoleID)
        self:RefreshChose()
    end)
    self.listobj[iTypeID] = transform
    objshose:SetActive(iTypeID == self.choseid)
end

function SetNicknameUI:RefreshChose()
    for i,v in pairs(self.listobj) do
        local objshose = self:FindChild(v.gameObject,'Choose_Image')
        if objshose then 
            objshose:SetActive(self.choseid == i)
        end
    end
end

-- 筛选机制
function SetNicknameUI:CanEdit(roleID)
    if RoleDataManager:GetInstance():IsMarryWithMainRole(roleID) or RoleDataManager:GetInstance():IsSwornedWithMainRole(roleID) then
		return true
	end
	return false
end


function SetNicknameUI:OnEnable()
    
end

function SetNicknameUI:OnDisable()

end

function SetNicknameUI:OnDestroy()
end

return SetNicknameUI