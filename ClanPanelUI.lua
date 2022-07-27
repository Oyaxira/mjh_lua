ClanPanelUI = class("ClanPanelUI", BaseWindow)
local ClanCardUI = require 'UI/Clan/ClanCardUI'

function ClanPanelUI:ctor()
    self.ClanCardUI = ClanCardUI.new()
end

function ClanPanelUI:OnDestroy()
    self.ClanCardUI:Close()
end

-- 由外部创建,需要自己调用 Init
function ClanPanelUI:ExternalInit(obj)
    self:SetGameObject(obj)
    self:Init()
end

function ClanPanelUI:SetSwitch(isSwitch)
	self.comButtonLeft.interactable = isSwitch
	self.comButtonRight.interactable = isSwitch
end

-- 下面的回调，需要在 init 前设置 --
function ClanPanelUI:SetCloseFunc(func)
    self.close_func = func
end
-----------------------------------------
function ClanPanelUI:SetSubmitFunc(func)
    self.submit_func = func
end
-----------------------------------------
function ClanPanelUI:SetLeftFunc(func)
    self.left_func = func
end
-----------------------------------------
function ClanPanelUI:SetRightFunc(func)
    self.right_func = func
end


-- 加载卡片
function ClanPanelUI:Init(obj)
    -- 卡片1
	self.detail_card_1 = self:FindChild(self._gameObject, "Clan_detail_card_1")
	self.comButton_close_1 = self:FindChildComponent(self.detail_card_1, "Button_close", "Button")
	if self.comButton_close_1 then
		self:AddButtonClickListener(self.comButton_close_1, self.close_func)
	end
	self.comFrameExit_1 = self:FindChildComponent(self.detail_card_1, "frame/Btn_exit", "Button")
	if self.comFrameExit_1 then
		self:AddButtonClickListener(self.comFrameExit_1, self.close_func)
	end
	self.comButton_submit_1 = self:FindChildComponent(self.detail_card_1, "Button_submit", "Button")
	if self.comButton_submit_1 then
		self:AddButtonClickListener(self.comButton_submit_1, self.submit_func)
    end
    self.objButton_submit_1 = self:FindChild(self.detail_card_1, "Button_submit")
	-- 卡片2
	self.detail_card_2 = self:FindChild(self._gameObject, "Clan_detail_card_2")
	self.comButton_close_2 = self:FindChildComponent(self.detail_card_2, "Button_close", "Button")
	if self.comButton_close_2 then
		self:AddButtonClickListener(self.comButton_close_2, self.close_func)
    end
	self.comFrameExit_2 = self:FindChildComponent(self.detail_card_2, "frame/Btn_exit", "Button")
	if self.comFrameExit_2 then
		self:AddButtonClickListener(self.comFrameExit_2, self.close_func)
	end
    self.comButton_submit_2 = self:FindChildComponent(self.detail_card_2, "Button_submit", "Button")
	if self.comButton_submit_2 then
		self:AddButtonClickListener(self.comButton_submit_2, self.submit_func)
	end
	self.objButton_submit_2 = self:FindChild(self.detail_card_2, "Button_submit")
    -- 左按钮
	self.comButtonLeft = self:FindChildComponent(self._gameObject, "Button_left", "Button")
	if self.comButtonLeft then
		self:AddButtonClickListener(self.comButtonLeft, function() self:ShowNextClan('left') end)
    end
    
    -- 右按钮
	self.comButtonRight = self:FindChildComponent(self._gameObject, "Button_right", "Button")
	if self.comButtonRight then
		self:AddButtonClickListener(self.comButtonRight, function() self:ShowNextClan('right') end)
    end
    
    -- 初始化
    self.detail_card_1:SetActive(true)
	self.detail_card_2:SetActive(false)
	self.card_choose = self.detail_card_1		-- 默认使用第一张卡片
end

-- 显示下一个门派，要做动画切换效果
function ClanPanelUI:ShowNextClan(direction)
    -- 设置 old 和 choose
	if self.card_choose == self.detail_card_1 then
		self.card_old = self.detail_card_1
		self.card_choose = self.detail_card_2
	else
		self.card_old = self.detail_card_2
		self.card_choose = self.detail_card_1
	end
	self.card_old.transform.localPosition = DRCSRef.Vec3(0,5,0)
	self.card_choose:SetActive(true)

	-- 触发回调
	if direction == 'left' then
		self.left_func()
	else
		self.right_func()
	end

    -- 播放动画
	self.comButtonLeft.interactable = false
	self.comButtonRight.interactable = false
	if direction == 'left' then-- 往右移动
		self.card_choose.transform.localPosition = DRCSRef.Vec3(-screen_w,5,0)
		self.card_old.transform:DR_DOLocalMoveX(screen_w, 0.5)		
	else	-- 往左移动
		self.card_choose.transform.localPosition = DRCSRef.Vec3(screen_w,5,0)
		self.card_old.transform:DR_DOLocalMoveX(-screen_w, 0.5)
	end

	local tween = self.card_choose.transform:DOLocalMoveX(0, 0.5)
	tween.onComplete = function()	-- 委托函数需要销毁，直接赋值字段，c#层会做处理
		if self.card_old then
			self.card_old:SetActive(false)
		end
		if self.comButtonLeft then
			self.comButtonLeft.interactable = true
		end
		if self.comButtonRight then
			self.comButtonRight.interactable = true
		end
    end
end

-- 渲染当前卡片 为 clanInfo
function ClanPanelUI:SetCard(clanInfo, isShowOnly)
	self.ClanCardUI:UpdateClanCardUI(self.card_choose, clanInfo)

	self.isShowOnly = isShowOnly
    if isShowOnly then
		self.ClanCardUI:SetShowOnly()
	end
end

-- 设置是否只能看
function ClanPanelUI:SetShowOnly(isShowOnly)
    self.isShowOnly = isShowOnly
end

return ClanPanelUI