MartialSelectUI = class('MartialSelectUI', BaseWindow)

function MartialSelectUI:Create()
    local obj = LoadPrefabAndInit("Role/MarryUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function MartialSelectUI:OnPressESCKey()
    if self.close_btn then
        self.close_btn.onClick:Invoke()
    end
end

function MartialSelectUI:Init()
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
                SendClickDialogCMD(self.netData.iType, self.netData.iTask, self.netData.iRet, self.choseid, self.netData.iRet2, self.resid)
                RemoveWindowImmediately("MartialSelectUI",false)
            end
		end)
    end

    if self.close_btn then
        self:AddButtonClickListener(self.close_btn,function()
            if self.netData and self.netData.iType then
                SendClickDialogCMD(self.netData.iType, self.netData.iTask, self.netData.iRet, 0, self.netData.iRet2, 0)
            end
            RemoveWindowImmediately("MartialSelectUI",false)
		end)        
    end

    --数据
    self.list = {}
    self.choseid = nil
    self.resid = nil
    self.netData = {}
    self.title.text = "参悟武学"
    self.bottom_text.text = "请选择好感度达到80的角色进行参悟"
end

function MartialSelectUI:RefreshUI(info)
    self.scrollRect:AddListener(function(...) self:UpdateItem(...) end)
    self:InitList()
    self.netData = info
end

function MartialSelectUI:InitList(info)
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
        SystemUICall:GetInstance():Toast('队伍中无可进行武学参悟的角色')
    end
end

function MartialSelectUI:UpdateList()
    self.scrollRect.totalCount = #self.list
	self.scrollRect:RefillCells()
end

function MartialSelectUI:UpdateItem(transform,iIndex)
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

function MartialSelectUI:RefreshChose()
    for i,v in pairs(self.listobj) do
        local objshose = self:FindChild(v.gameObject,'Choose_Image')
        if objshose then 
            objshose:SetActive(false)
        end
    end
end

-- 筛选机制：队伍中好感度80的有专属武学的角色
-- 参悟等级达到满级的也要筛掉
function MartialSelectUI:CanStrong(roleID)
    local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(roleID)
	if (dispoValue and dispoValue < 80) then
		return false
	end
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    local auiMartials, auiLvs = roleData:GetMartials()
    for i=0, #auiMartials do
        local typeData = TableDataManager:GetInstance():GetTableData("Martial",auiMartials[i])
        if typeData and typeData.Exclusive and auiLvs[i] < 20 then
            return true
        end
    end
	return false
end

function MartialSelectUI:OnEnable()
    
end

function MartialSelectUI:OnDisable()

end

function MartialSelectUI:OnDestroy()
end

return MartialSelectUI