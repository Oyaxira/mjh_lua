ForgetMartialGiftUI = class("ForgetMartialGiftUI",BaseWindow)
local ID_WANGYOUCAO = 9626

function ForgetMartialGiftUI:ctor()
	
end

function ForgetMartialGiftUI:Create()
	local obj = LoadPrefabAndInit("Role/ForgetGiftUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ForgetMartialGiftUI:Close()
  RemoveWindowImmediately('ForgetMartialGiftUI', true)
  LogicMain:GetInstance():SetOpenWindowsNO(1)
end

function ForgetMartialGiftUI:Init()
  -- 放弃按钮
  self.comButtonNo = self:FindChildComponent(self._gameObject, "Button_no", "Button")
  if self.comButtonNo then
		local fun = function()
      RemoveWindowImmediately('ForgetMartialGiftUI', true)
      LogicMain:GetInstance():SetOpenWindowsNO(1)
		end
		self:AddButtonClickListener(self.comButtonNo,fun)
  end

  self.comBtnClose = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", "Button")
  if self.comBtnClose then
    self:AddButtonClickListener(self.comBtnClose,function()
      self:Close()
    end)
  end
  -- self.comButtonClose = self:FindChildComponent(self._gameObject, "black", "Button")
  -- if (self.comButtonClose) then
  --   local fun = function()
  --     RemoveWindowImmediately('ForgetMartialGiftUI', true)
	-- 	end
	-- 	self:AddButtonClickListener(self.comButtonClose,fun)
  -- end

  -- Button_yes
  self.comButtonYes = self:FindChildComponent(self._gameObject, "Button_yes", "Button")
  if self.comButtonYes then
		local fun = function()
      self:ForgetSure()
		end
		self:AddButtonClickListener(self.comButtonYes,fun)
  end

    -- 背景
    self.comBG_Button = self:FindChildComponent(self._gameObject, "black","Button")
    if self.comBG_Button then
        local fun = function()
            RemoveWindowImmediately('ForgetMartialGiftUI', true)
        end
        self:AddButtonClickListener(self.comBG_Button,fun)
    end

  -- 忘忧草数量
  self.textWangyoucao = self:FindChildComponent(self._gameObject, "Item_num", "Text")

  
  -- 下拉列表
  self.comGiftItemLoopScroll =  self:FindChildComponent(self._gameObject, 'SC_Gift', 'LoopVerticalScrollRect')
  self.comGiftItemLoopScroll.totalCount = 0
  self.comGiftItemLoopScroll:AddListener(function(...)
      self:OnGiftItemScrollChanged(...)
  end)
  self.comGiftItemLoopScroll:RefillCells()

  self.comToggleGroup = self:FindChildComponent(self._gameObject, "SC_Gift/Viewport/Content", "ToggleGroup")
  self.newRefresh = true
end

function ForgetMartialGiftUI:RefreshUI(uiRoleID)
  self.roleID = uiRoleID
  self.canForgetGift = GiftDataManager:GetInstance():GetDynamicGift(self.roleID)
  if (self.canForgetGift == nil or next(self.canForgetGift) == nil) then
    self.comGiftItemLoopScroll.totalCount = 0
  else
    self.comGiftItemLoopScroll.totalCount = #self.canForgetGift
  end
  self.newRefresh = true
  self.comGiftItemLoopScroll:RefillCells()
  self.comGiftItemLoopScroll:RefreshNearestCells()

  self.chooseForgetGift = 0

  local itemnum = PlayerSetDataManager:GetInstance():GetPlayerWangyoucao()
  local buttonYesImg = self.comButtonYes.gameObject:GetComponent('Image')
  if buttonYesImg then
      setUIGray(buttonYesImg,itemnum == 0)
  end

  self.textWangyoucao.text = "忘忧草数量:" .. (itemnum or 0)

  LogicMain:GetInstance():SetOpenWindowsNO(2)
end

function ForgetMartialGiftUI:OnDisable()
	
end

function ForgetMartialGiftUI:OnDestroy()

end

function ForgetMartialGiftUI:ForgetSure()
  if (not self.chooseForgetGift ) then
    return
  end

  if (self.canForgetGift == nil) then
    return
  end
  local giftData = self.canForgetGift[self.chooseForgetGift + 1]
  if (giftData == nil) then
    RemoveWindowImmediately('ForgetMartialGiftUI', true)
    return
  end

  local callBack = function()
    SendDeleteGiftCMD(self.roleID,giftData.id, giftData.BaseID)
  end

  local noitemcallback = function()
			CommonSpendSliverWindow(GetCommonConfig("ForgetMartialCostSilver"),function()
        SendDeleteGiftCMD(self.roleID,giftData.id, giftData.BaseID)
			end)
  end

  local itemnum = PlayerSetDataManager:GetInstance():GetPlayerWangyoucao()
  if itemnum > 0 then
      local ID_WANGYOUCAO = 9626 
      strNotice = string.format("确定要遗忘天赋 <<%s>> 吗？需要消耗一个忘忧草",GetLanguageByID(giftData.NameID))
      local content = {
          ["title"] = "提示",
          ["text"] = strNotice,
          ["ItemID"] = ID_WANGYOUCAO,
          ["ItemNum"] = itemnum,
          ["ItemCost"] = 1,
      }
      OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COSTITEM_TIP, content, callBack })
      RemoveWindowImmediately('ForgetMartialGiftUI', true)
  else
      SystemUICall:GetInstance():Toast('忘忧草数量不足')
  end
end

function ForgetMartialGiftUI:OnGiftItemScrollChanged(transform, idx)
  if not (transform and idx) then
    return
  end

  if (self.canForgetGift == nil) then
    return
  end

  local objNode = transform.gameObject
  objNode:SetActive(true)

  -- 获取所有可以遗忘的武学
  local giftData = self.canForgetGift[idx + 1]
  if (giftData == nil) then
    return
  end
  
  local comGiftText = self:FindChildComponent(objNode, "Text", "Text")
  if (not comGiftText) then
    return
  end
  comGiftText.text = GetLanguageByID(giftData.NameID)

  -- 获取rank
  local color = getRankColor(giftData.Rank)
  comGiftText.color = color

  -- 设置点击效果
  local toggleComponent = objNode:GetComponent("Toggle")
  toggleComponent.group = self.comToggleGroup
  local imgDefaultTexture = self:FindChild(objNode, "Image_default")
  local imgChoosenTexture = self:FindChild(objNode, "Image_chosen")
  self:RemoveToggleClickListener(toggleComponent)
  local togfunction = function(bShow)
    if bShow ~= nil then
      imgChoosenTexture:SetActive(bShow)
    else
      imgChoosenTexture:SetActive(self.chooseForgetGift == idx)
    end 
  end
  self:AddToggleClickListener(toggleComponent, function(bool)
    if bool then
      self.chooseForgetGift = idx
      togfunction(true)
    else
      togfunction(false)
    end
  end)
  if (idx == 0) then
    if (self.newRefresh) then
      self.newRefresh = false
      toggleComponent.isOn = true
    end
  end
  togfunction()
end

function ForgetMartialGiftUI:OnPressESCKey() 
  if self.comButtonNo then
    self.comButtonNo.onClick:Invoke()
  end
  --LogicMain:GetInstance():SetOpenWindowsNO(2)
end

return ForgetMartialGiftUI