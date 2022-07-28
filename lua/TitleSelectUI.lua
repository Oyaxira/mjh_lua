TitleSelectUI = class("TitleSelectUI",BaseWindow)

function TitleSelectUI:ctor()

end

function TitleSelectUI:Create()
	local obj = LoadPrefabAndInit("Interactive/TitleSelectUI", TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TitleSelectUI:OnPressESCKey()
    if self.comReturn_Button then
        self.comReturn_Button.onClick:Invoke()
    end
end

function TitleSelectUI:RefreshUI(info)
    local UnlockPool = globalDataPool:getData("UnlockPool") or {};
    local unlockTitle = UnlockPool[PlayerInfoType.PIT_TITLE] or {};

    local auiTitles = {};
    for k, v in pairs(unlockTitle) do
        local tbTitle = TableDataManager:GetInstance():GetTableData('RoleTitle', v.dwTypeID & 0xffffff);
        if (tbTitle and tbTitle.IsTakenIn == TBoolean.BOOL_YES) or ((v.dwTypeID >> 24) & 0xff == GetCurScriptID()) then
            local cloneV = clone(v)
            cloneV.dwTypeID = v.dwTypeID & 0xffffff
            table.insert(auiTitles, cloneV);
        end
    end

    -- local auiTitles = RoleDataManager:GetInstance():GetScriptRoleTitle()
    local uiMainTitle = RoleDataManager:GetInstance():GetCurMainRoleTitle()
    table.sort(auiTitles, function(a, b) 
        return a.dwTypeID > b.dwTypeID;
    end)

    if self.objContent then
		RemoveAllChildren(self.objContent)
	end
   
    if uiMainTitle > 0 then
        -- self:AddItems(uiMainTitle, 0)
        self:AddItems(uiMainTitle, uiMainTitle)
    end

    for i,v in ipairs(auiTitles) do
        if v.dwTypeID ~= uiMainTitle then
            self:AddItems(uiMainTitle, v.dwTypeID)
        end
    end
end

function TitleSelectUI:AddItems(uiMainTitle, titleid)
    local objItem = CloneObj(self.objClone, self.objContent)
    if (objItem == nil) then
        return
    end
    objItem:SetActive(true)

    local text_title = self:FindChildComponent(objItem,"text_title", "Text")
    local btn_select = self:FindChildComponent(objItem,"btn_select", "Button")
    local obj_select = self:FindChild(objItem,"btn_select")

    if titleid > 0 then
        local roleTitleData = TableDataManager:GetInstance():GetTableData("RoleTitle",titleid)
        if roleTitleData and roleTitleData.TitleID then
            local string_title = GetLanguageByID(roleTitleData.TitleID) or ""
            text_title.text = string_title
        else
            text_title.text = tostring(titleid)
        end
    else
        text_title.text = '不显示称号'
    end

    self:RemoveButtonClickListener(btn_select)
    if uiMainTitle ~= titleid then
        self:AddButtonClickListener(btn_select, function()
            SendTitleSelectCMD(titleid)
        end)
        obj_select:SetActive(true)
    else
        obj_select:SetActive(false)
    end  
end

function TitleSelectUI:Init()
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Btn_exit","Button")
    self.objContent = self:FindChild(self._gameObject,"Content")
    self.objClone = self:FindChild(self._gameObject,"obj_item")
    
    self:RemoveButtonClickListener(self.comReturn_Button)   
    self:AddButtonClickListener(self.comReturn_Button, function()
        RemoveWindowImmediately('TitleSelectUI')
    end)
end

function TitleSelectUI:OnEnable()
    self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function()
        self:RefreshUI()
    end)
end

function TitleSelectUI:OnDisable()
    self:RemoveEventListener("UPDATE_MAIN_ROLE_INFO")
end

function TitleSelectUI:OnDestroy()

end


return TitleSelectUI