ResultUI4_5 = class('ResultUI4_5', BaseWindow)

function ResultUI4_5:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI4_5;

    self.bindBtnTable = {};
    self.babylist = {}
end

function ResultUI4_5:Init()
    self.objBtn_submit = self:FindChild(self._gameObject, 'Pack/BottomBtns/Button_submit');
    self.objBtn_close = self:FindChild(self._gameObject, 'Pack/BottomBtns/Button_cancel');
    self.comCloseImage = self.objBtn_close:GetComponent("Image")
    self.comCloseButton = self.objBtn_close:GetComponent("Button")

	self.comScrollRect = self:FindChildComponent(self._gameObject,"Pack/LoopScrollView","LoopVerticalScrollRect")
    table.insert(self.bindBtnTable, self.objBtn_submit);
    table.insert(self.bindBtnTable, self.objBtn_close);

    self:BindBtnCB();
end

function ResultUI4_5:RefreshUI(info)
	self.comScrollRect:AddListener(function(...) self:UpdateItem(...) end)
    self:InitChildList();
    self:RefreshCloseButtonState()
end

function ResultUI4_5:RefreshCloseButtonState()
    local bShowCancalButton = RoleDataManager:GetInstance():CheckCreateRoleHaveBaby()
    self.comCloseButton.interactable = bShowCancalButton
    setUIGray(self.comCloseImage, not bShowCancalButton) 
end

function ResultUI4_5:InitChildList(info)
    local babymap = RoleDataManager:GetInstance():GetBabyInfoAll()
    local teamlist = RoleDataManager:GetInstance():GetRoleTeammates()
    self.babylist = {}
    for i,roleid in  pairs(teamlist ) do 
        local roledata = RoleDataManager:GetInstance():GetRoleData(roleid)
        if RoleDataManager:GetInstance():IsBabyRoleType(roleid) then
            table.insert( self.babylist,roledata)
        end 
    end 
    self.objbabylist = {}
    self:UpdateBabyList()

    if #self.babylist == 0 then 
        if self._scriptUI then 
            self._scriptUI.bNotShow4_5 = true
        end 
    end 

end
function ResultUI4_5:UpdateBabyList()
	self.comScrollRect.totalCount = #self.babylist
	self.comScrollRect:RefillCells()
end 
function ResultUI4_5:UpdateItem(transform,iIndex)
    local roledata = self.babylist[iIndex + 1]
    if not roledata then return end 
    local iRoleID = roledata.uiID
    -- 角色名称
	local nameText = self:FindChildComponent(transform.gameObject,"Name_Text","Text")
	local strName = RoleDataManager:GetInstance():GetRoleTitleAndName(iRoleID)
	nameText.text = getRankBasedText(RoleDataManager:GetInstance():GetRoleRank(iRoleID), strName)
	local roledata =  RoleDataManager:GetInstance():GetRoleData(iRoleID)
	if roledata then
		local LevelText = self:FindChildComponent(transform.gameObject,"Level_Text","Text")

		local uiLevel = roledata.uiLevel or 0
		if LevelText then
			LevelText.text = getRankBasedText(RoleDataManager:GetInstance():GetRoleRank(iRoleID),uiLevel.."级")
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
    local dragItem = self:FindChildComponent(transform.gameObject,"Head_Dispositions","DRButton")
    self:AddButtonClickListener(dragItem,function() 
        OpenWindowImmediately("ObserveUI", {['roleID'] = iRoleID})
    end)
    local WatchItem = self:FindChildComponent(transform.gameObject,"Button_Watch","DRButton")
    self:AddButtonClickListener(WatchItem,function() 
        self.choseid = iRoleID
        self:RefreshChose()
    end)
    self.objbabylist[iRoleID] = transform
    if self.choseid == nil then 
        self.choseid = iRoleID
    end
    objshose:SetActive(iRoleID == self.choseid)
end 
function ResultUI4_5:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnClickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI4_5:RefreshChose()
    if self.objbabylist  then  
        for iRoleID ,obj in pairs(self.objbabylist) do
            local objshose = self:FindChild(obj.gameObject,'Choose_Image')
            if objshose then 
                objshose:SetActive(self.choseid == iRoleID)
            end
        end
    end
end
function ResultUI4_5:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent('Button');
    local tog = gameObject:GetComponent('Toggle');
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback);

    end
end


function ResultUI4_5:OnClickBtn(obj, boolHide)
    if not self._scriptUI then
        return;
    end
    if obj == self.objBtn_submit then
        self._scriptUI.iFinalChoseBaby = self.choseid
    elseif obj == self.objBtn_close then
        self._scriptUI.iFinalChoseBaby = 0
    end
    self._scriptUI:SetResultUIState(self._scriptUI.objResultUI5);
   
end

function ResultUI4_5:OnEnable()
end

function ResultUI4_5:OnDisable()
end

return ResultUI4_5