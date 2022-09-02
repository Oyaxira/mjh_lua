RoleSelectUI = class('RoleSelectUI', BaseWindow)

function RoleSelectUI:Create()
    local obj = LoadPrefabAndInit("Role/MarryUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function RoleSelectUI:OnPressESCKey()
    if self.close_btn then
        self.close_btn.onClick:Invoke()
    end
end

function RoleSelectUI:Init()
    self.confirm_btn = self:FindChildComponent(self._gameObject, "Button_submit", DRCSRef_Type.Button)
    self.close_btn = self:FindChildComponent(self._gameObject, "Btn_exit", DRCSRef_Type.Button)
    self.scrollRect = self:FindChildComponent(self._gameObject, "LoopScrollView","LoopVerticalScrollRect")
    self.title = self:FindChildComponent(self._gameObject, "Title","Text")
    self.bottom_text = self:FindChildComponent(self._gameObject, "Text_bottom","Text")

    if self.confirm_btn then
        self:AddButtonClickListener(self.confirm_btn,function()
			if not self.choseid then
                SystemUICall:GetInstance():Toast('请先选择一名角色进行武学参悟')
                return
            end
            if self.netData and self.netData.iType then
                SendClickDialogCMD(self.netData.iType, self.netData.iTask, self.netData.iRet, self.choseid)
                RemoveWindowImmediately("RoleSelectUI",false)
            end
		end)
    end

    if self.close_btn then
        self:AddButtonClickListener(self.close_btn,function()
            if self.netData and self.netData.iType then
                SendClickDialogCMD(self.netData.iType, self.netData.iTask, self.netData.iRet, 0)
            end
            RemoveWindowImmediately("RoleSelectUI",false)
		end)        
    end

    --数据
    self.list = {}
    self.choseid = nil
    self.resid = nil
    self.netData = {}
   
end

function RoleSelectUI:RefreshUI(info)
    self.netData = info
    self.iFavor = info.iFavor or 0
    self.title.text = GetLanguageByID(info.ititle) 
    self.bottom_text.text = GetLanguageByID(info.icontent)
    self.scrollRect:AddListener(function(...) self:UpdateItem(...) end)
    self:InitList()
end

function RoleSelectUI:InitList(info)
    local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
    self.list = {}
    for i,v in pairs(teammates) do
        if self:CanStrong(v) then
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

function RoleSelectUI:UpdateList()
    self.scrollRect.totalCount = #self.list
	self.scrollRect:RefillCells()
end

function RoleSelectUI:UpdateItem(transform,iIndex)
    local roledata = self.list[iIndex +1]
    if not roledata then
        return
    end
    local iRoleID = roledata.uiID
    local iTypeID = roledata.uiTypeID

    local martialID = 0
    local auiMartials= roledata:GetMartials()
    for i=0, #auiMartials do
        local typeData = TableDataManager:GetInstance():GetTableData("Martial",auiMartials[i])
        if typeData and typeData.Exclusive then
            martialID = auiMartials[i]
            break
        end
    end

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
    self:RemoveButtonClickListener(dragItem)
    self:AddButtonClickListener(dragItem,function() 
        OpenWindowImmediately("ObserveUI", {['roleID'] = iRoleID})
    end)
   
    local WatchItem = self:FindChildComponent(transform.gameObject,"Button_Watch","DRButton")
    self:RemoveButtonClickListener(WatchItem)
    self:AddButtonClickListener(WatchItem,function() 
        self.choseid = iTypeID
        self.resid = martialID
        self:RefreshChose()
        objshose:SetActive(true)
    end)
    self.listobj[iTypeID] = transform
    objshose:SetActive(iTypeID == self.choseid)
end

function RoleSelectUI:RefreshChose()
    for i,v in pairs(self.listobj) do
        local objshose = self:FindChild(v.gameObject,'Choose_Image')
        if objshose then 
            objshose:SetActive(false)
        end
    end
end

-- 筛选
function RoleSelectUI:CanStrong(roleID)
    local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(roleID)
	if (dispoValue and dispoValue < self.iFavor) then
		return false
	end
	return true
end

function RoleSelectUI:OnEnable()
    
end

function RoleSelectUI:OnDisable()

end

function RoleSelectUI:OnDestroy()
end

return RoleSelectUI