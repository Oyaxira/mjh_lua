MenuPanelUI = class("MenuPanelUI", BaseWindow)


function MenuPanelUI:Create(kParent)
	local obj = LoadPrefabAndInit("MenuPanel/menuPanel",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function MenuPanelUI:Close()
	self.objMenuBtnPanel:SetActive(false)
end

function MenuPanelUI:Init()
    self.comMenuBtn = self:FindChildComponent(self._gameObject,"menuBtn","Button")
	self.comUIAction = self:FindChildComponent(self._gameObject,"menuBtn","LuaUIAction")
	self.objMenuBtnTips = self:FindChild(self._gameObject,"Tips")
	self.objMenuBtnPanel = self:FindChild(self._gameObject,"menuBtnPanel")
    if self.comMenuBtn then
		self:AddButtonClickListener(self.comMenuBtn,function()
			if self.objMenuBtnPanel.activeSelf then
				self.objMenuBtnPanel:SetActive(false)
			else
				self.objMenuBtnPanel:SetActive(true)
			end
		end)
	end
	if self.comUIAction then
		self.comUIAction:SetPointerEnterAction(function()
			self.objMenuBtnTips:SetActive(true)
		end)

		self.comUIAction:SetPointerExitAction(function()
			self.objMenuBtnTips:SetActive(false)
		end)
	end
    self.comSettingsBtn = self:FindChildComponent(self._gameObject,"menuBtnPanel/Panel/settingsBtn","Button")
    self.comDialogRecordBtn = self:FindChildComponent(self._gameObject,"menuBtnPanel/Panel/dialogRecordBtn","Button")
    self.comReturnMainMenuBtn = self:FindChildComponent(self._gameObject,"menuBtnPanel/Panel/returnMainMenuBtn","Button")
    self.comshowStorageBtn = self:FindChildComponent(self._gameObject,"menuBtnPanel/Panel/showStorageBtn","Button")
    self.comSteamShopBtn = self:FindChildComponent(self._gameObject,"menuBtnPanel/Panel/SteamShopBtn","Button")
    self.comCollectionBtn = self:FindChildComponent(self._gameObject,"menuBtnPanel/Panel/collectionBtn","Button")
    self.comSettingsUIAction = self.comSettingsBtn.gameObject:GetComponent("LuaUIAction")
    self.comDialogRecordUIAction = self.comDialogRecordBtn.gameObject:GetComponent("LuaUIAction")
    self.comReturnMainMenuUIAction = self.comReturnMainMenuBtn.gameObject:GetComponent("LuaUIAction")
    self.comShowStorageUIAction = self.comshowStorageBtn.gameObject:GetComponent("LuaUIAction")
    self.comSteamShopUIAction = self.comSteamShopBtn.gameObject:GetComponent("LuaUIAction")
    self.comCollectionUIAction = self.comCollectionBtn.gameObject:GetComponent("LuaUIAction")
    SetUIActionHandle(self.comSettingsUIAction)
    SetUIActionHandle(self.comDialogRecordUIAction)
    SetUIActionHandle(self.comReturnMainMenuUIAction)
    SetUIActionHandle(self.comShowStorageUIAction)
    SetUIActionHandle(self.comSteamShopUIAction)
    SetUIActionHandle(self.comCollectionUIAction)
	if self.comSettingsBtn then
		self:AddButtonClickListener(self.comSettingsBtn,function()
			self:OnClick_Button_setting()
			SetTextDefault(self.comSettingsUIAction.gameObject)
			self:Close()
			--derror("comSettingsBtn click")
		end)
	else
		derror("comSettingsBtn not found")
	end
	if self.comDialogRecordBtn then
		self:AddButtonClickListener(self.comDialogRecordBtn,function()
			OpenWindowImmediately("DialogRecordUI")
			SetTextDefault(self.comDialogRecordUIAction.gameObject)
			self:Close()
			--derror("comDialogRecordBtn click")
		end)
	else
		derror("comDialogRecordBtn not found")
	end
	if self.comshowStorageBtn then
		self:AddButtonClickListener(self.comshowStorageBtn,function()
			local bCanBringIn = self:CanCurStoryBringIn()
			if (not bCanBringIn) then
				SystemUICall:GetInstance():Toast("当前剧本不允许仓库带入物品")
				return
			end

			OpenWindowByQueue("StorageUI")
			SetTextDefault(self.comShowStorageUIAction.gameObject)
			self:Close()
		end)
	else
		derror("comShowStorageUIAction not found")
	end
	if self.comReturnMainMenuBtn then
		local fun = function()
			-- 如果这个时候临时背包中还有物品, 那么在返回酒馆的时候给个提示
			local tempItems = ItemDataManager:GetInstance():GetTempBackpackItems() or {}
			if #tempItems > 0 then
				local msg = "临时背包中还有物品, 离开剧本就会消失, 确定要返回标题吗？"
				local boxCallback = function()
					SendClickQuitStoryCMD()
				end
				OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg or "", boxCallback})
			else
				local _callback = function()
					SendClickQuitStoryCMD();
				end
				OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '是否要返回标题画面？', _callback });
			end
			SetTextDefault(self.comReturnMainMenuUIAction.gameObject)
			self:Close()
		end
		self:AddButtonClickListener(self.comReturnMainMenuBtn,fun)
	else
		derror("comReturnMainMenuBtn not found")
	end
	
	if self.comSteamShopBtn then
		self:AddButtonClickListener(self.comSteamShopBtn,function()
			OpenOnlineShop()
			SetTextDefault(self.comSteamShopUIAction.gameObject)
			self:Close()
		end)
	end
	if self.comCollectionBtn then
		self:AddButtonClickListener(self.comCollectionBtn,function()
			OpenWindowImmediately("CollectionUI")
			SendUpdateCollectionPoint()
			SetTextDefault(self.comCollectionUIAction.gameObject)
			self:Close()
		end)
	end
end

function MenuPanelUI:OnClick_Button_setting()
	OpenWindowImmediately("PlayerSetUI")
end

function MenuPanelUI:CanCurStoryBringIn()
	local curStoryID = GetCurScriptID()
	local TB_Story = TableDataManager:GetInstance():GetTable("Story")
	local storyData = TB_Story[curStoryID]
	if storyData ~= nil and storyData.bAllowStorageIn == TBoolean.BOOL_NO then
		return false
	end
	return true
end

return MenuPanelUI