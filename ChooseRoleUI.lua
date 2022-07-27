ChooseRoleUI = class('ChooseRoleUI', BaseWindow)

function ChooseRoleUI:ctor(obj)
    -- self._gameObject = obj;
    self.teamlist = {}
end

function ChooseRoleUI:Create()
	local obj = LoadPrefabAndInit("ResultUI/ChooseRoleUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end
function ChooseRoleUI:Init()
    self.RoleDataMgr = RoleDataManager:GetInstance()
    self.comBtn_submit = self:FindChildComponent(self._gameObject, 'Pack/Button_submit','DRButton')
    self.comBtn_close = self:FindChildComponent(self._gameObject, 'Pack/newFrame/Btn_exit','DRButton')
    
    self.objBtn_close = self:FindChild(self._gameObject, 'Pack/newFrame/Btn_exit')
    self.objBtn_close:SetActive(false)

    self.comScrollRect = self:FindChildComponent(self._gameObject,"Pack/LoopScrollView","LoopVerticalScrollRect")
    
    self.comtoggleGroup = self:FindChildComponent(self._gameObject,"Pack/LoopScrollView","ToggleGroup")

    self.comBottom_Text = self:FindChildComponent(self._gameObject, 'Pack/Text_bottom','Text')

    if self.comBtn_submit then
        self:AddButtonClickListener(self.comBtn_submit,function (  )
            self:OnClick_SubMit()
        end)
    end
    if self.comBtn_close then
        self:AddButtonClickListener(self.comBtn_close,function (  )
            RemoveWindowImmediately("ChooseRoleUI")
        end)
	end

    self.type = nil
    self.submitCallback = nil
end

function ChooseRoleUI:RefreshUI(info)
    self.choseid = nil
    if type(info) == "table" and info.type then
        self.type = info.type
    else
        self.type = ShooseRoleUIType.SRUIT_ChooseNPCMaster
    end

    self.comScrollRect:AddListener(function(...) self:UpdateItem(...) end)
    self:InitChildList()
    self:AddEventListener("UPDATE_TEAM_INFO", function() 
        self:InitChildList()
    end)
end
function ChooseRoleUI:InitChildList()
    if self.type == ShooseRoleUIType.SRUIT_ChooseNPCMaster then
        local teamlist = self.RoleDataMgr:GetRoleTeammates()
        self.teamlist = {}
        local uiMainRoleID = self.RoleDataMgr:GetMainRoleID()
        for i,roleid in pairs(teamlist ) do 
            if uiMainRoleID ~= roleid then 
                table.insert( self.teamlist, self.RoleDataMgr:GetRoleData(roleid))
            end 
        end

        self.comBottom_Text.text = "请选择一个队友作为当该门派的新掌门"
        self.objBtn_close:SetActive(false)

        self.submitCallback = function(roleid)
            SendClickChooseNPCMaster(self.RoleDataMgr:GetRoleTypeID(roleid))
            RemoveWindowImmediately('ChooseRoleUI',true)
        end
    elseif self.type == ShooseRoleUIType.SRUIT_ChooseRoleChallenge then
        local teamlist = self.RoleDataMgr:GetRoleTeammates()
        self.teamlist = {}
        local uiMainRoleID = self.RoleDataMgr:GetMainRoleID()
        for i,roleid in pairs(teamlist) do 
            local roleData = self.RoleDataMgr:GetRoleData(roleid)
            if roleData and (roleData.uiRoleChallengeState == nil or roleData.uiRoleChallengeState == 0) then
                local roleChallengeData = TableDataManager:GetInstance():GetTableData("RoleChallenge", roleData.uiTypeID)
                if roleChallengeData then
                    table.insert( self.teamlist, roleData)
                end
            end
        end

        self.comBottom_Text.text = "选择一个队友进行武神殿挑战"
        self.objBtn_close:SetActive(true)

        self.submitCallback = function(roleid)
            SendClickChooseRoleChallengeSelectRole(roleid)
            RemoveWindowImmediately('ChooseRoleUI',true)
        end
    else
        return        
    end

    self:UpdateItemList()
end
function ChooseRoleUI:UpdateItemList()
	self.comScrollRect.totalCount = #self.teamlist
    self.comScrollRect:RefillCells()	

end 
function ChooseRoleUI:UpdateItem(transform,iIndex)
    local roledata = self.teamlist[iIndex + 1]
    if not roledata then return end 
    local iRoleID = roledata.uiID
    -- 角色名称
	local nameText = self:FindChildComponent(transform.gameObject,"Name_Text","Text")
	local strName = self.RoleDataMgr:GetRoleTitleAndName(iRoleID)
	nameText.text = getRankBasedText(self.RoleDataMgr:GetRoleRank(iRoleID), strName)
	local roledata =  self.RoleDataMgr:GetRoleData(iRoleID)
	if roledata then
		local LevelText = self:FindChildComponent(transform.gameObject,"Level_Text","Text")

		local uiLevel = roledata.uiLevel or 0
		if LevelText then
			LevelText.text = getRankBasedText(self.RoleDataMgr:GetRoleRank(iRoleID),uiLevel.."级")
		end
    end
    
    local objshose = self:FindChild(transform.gameObject,'Choose_Image')
    if roledata then
		local headImage = self:FindChildComponent(transform.gameObject,"Head_Dispositions/head","Image")
		if headImage then
			local kPath = roledata:GetDBHead()
			headImage.sprite = GetSprite(kPath)
		end
    end
    local dragItem = self:FindChildComponent(transform.gameObject,"Head_Dispositions","DragItem")
	dragItem:ClearLuaFunction()
	dragItem:SetPointDownAction(function ()
        OpenWindowImmediately("ObserveUI", {['roleID'] = iRoleID})
	end)
    local WatchItem = self:FindChildComponent(transform.gameObject,"Button_Watch","Toggle")
    -- self:RemoveWindowImmediately
    WatchItem.interactable = true
    WatchItem.group = self.comtoggleGroup

    self:RemoveToggleClickListener(WatchItem)
    self:AddToggleClickListener(WatchItem, function(boolHide)
        if boolHide then 
            self.choseid = iRoleID
        end 
        objshose:SetActive(boolHide)
    end)

    if self.choseid == nil then 
        self.choseid = iRoleID
        WatchItem.isOn = true
    else
        WatchItem.isOn = false
    end
    -- objshose:SetActive(iRoleID == self.choseid)
end 


function ChooseRoleUI:OnClick_SubMit()
    if self.submitCallback and self.choseid then
        self.submitCallback(self.choseid)
    end
end

function ChooseRoleUI:OnEnable()
end

function ChooseRoleUI:OnDisable()
end

return ChooseRoleUI