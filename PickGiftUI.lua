PickGiftUI = class("PickGiftUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local SpineRoleUI = require 'UI/Role/SpineRoleUI'
local CharacterUI = require 'UI/Role/CharacterUI'

function PickGiftUI:Create()
	local obj = LoadPrefabAndInit("Role/PickGiftUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function PickGiftUI:Init()
    self.BG = self:FindChild(self._gameObject,"PopUpWindow_4/Black")
    self.Button_close = self:FindChild(self._gameObject,"newFrame/Btn_exit")
    self.Gift_pool_box = self:FindChild(self._gameObject,"Gift_pool_box")
    self.Button_buy = self:FindChild(self._gameObject,"Button_buy")
    self.Text_Number =  self:FindChildComponent(self.Button_buy,"Number","Text")

    self.Text_refresh_times = self:FindChildComponent(self._gameObject,"Text_refresh_times","Text")
    self.Text_gift_point = self:FindChildComponent(self._gameObject,"Text_gift_point","Text")

    self.Button_question = self:FindChildComponent(self._gameObject,"Text_gift_point/Button_question","Button")
    local BGButton = self.BG:GetComponent("Button")
    self.closeButton = self.Button_close:GetComponent("Button")
    self:RemoveButtonClickListener(BGButton)
    self:RemoveButtonClickListener(self.closeButton)
    self:AddButtonClickListener(BGButton, function() RemoveWindowImmediately("PickGiftUI",true) end)
    self:AddButtonClickListener(self.closeButton, function() 
        RemoveWindowImmediately("PickGiftUI",true) 
        LogicMain:GetInstance():SetOpenWindowsNO(1)
    end)
    local t = function(uiGifts) 
        self:RefreshGiftPool(uiGifts) 
    end

    self:RemoveButtonClickListener(self.Button_question)
    self:AddButtonClickListener(self.Button_question, function() 
        self:ShowTips()
    end)
   

    self:AddEventListener("ShoppingMallUI",function(iOpen)
        if iOpen == 1 then
            RemoveWindowImmediately("PickGiftUI",true)
        else
            OpenWindowImmediately("PickGiftUI",self.selectRole)
        end
    end,nil,nil,nil,true
    )
    
    self:AddEventListener("UPDATE_DISPLAY_RANDOMGIFT",t)
    self:AddEventListener("UPDATE_INTERACT_REFRESHTIMES", function()
        self:RefreshText()
    end)
    self:RefreshText()
end

function PickGiftUI:RefreshText()
    local refreshBallNum = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall() or 0
    local refreshCost = TableDataManager:GetInstance():GetTable("CommonConfig")[1].RefreshGiftCost or 1
    self.Text_Number.text = "(" .. refreshBallNum .. " / " .. refreshCost .. ")"
end

function PickGiftUI:OnPressESCKey() 
    if self.closeButton then
	    self.closeButton.onClick:Invoke()
    end
    LogicMain:GetInstance():SetOpenWindowsNO(2)
end
function PickGiftUI:RefreshTimes()
    local icur, iMax = RoleDataHelper.GetRefreshTimes(PlayerBehaviorType.PBT_GiftRefresh)
    if icur and iMax then
        self.Text_refresh_times.text = "今日刷新次数：" .. tostring(iMax - icur)
    end
end

function PickGiftUI:RefreshGiftPool(uiGifts)
    for int_i = 0,#uiGifts do
        self:RefreshGiftGrid(int_i,uiGifts[int_i])
    end
    self:RefreshRemainPoint()
end

function PickGiftUI:RefreshRemainPoint()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if  self.Text_gift_point and roleData and roleData.aiAttrs[AttrType.ATTR_WUXING] and roleData.uiGiftUsedNum then
        self.Text_gift_point.text = "剩余天赋值:"..tostring(roleData.aiAttrs[AttrType.ATTR_WUXING] * 2  - roleData.uiGiftUsedNum)
    end
end

function PickGiftUI:RefreshGiftGrid(index,giftId)
    --Cost
    local text_cost = self:FindChildComponent(self.Gift_pool_box.transform:GetChild(index).gameObject,"Text_cost","Text")
    --Name
    text_cost.enabled = true
    local text_name = self:FindChildComponent(self.Gift_pool_box.transform:GetChild(index).gameObject,"Name","Text")
    --Des
    local text_des = self:FindChildComponent(self.Gift_pool_box.transform:GetChild(index).gameObject,"Text","EmojiText")
    --AddGift
    local button_Add  = self:FindChildComponent(self.Gift_pool_box.transform:GetChild(index).gameObject,"Button_sure","Button")
    local scrollView_Add  = self:FindChildComponent(self.Gift_pool_box.transform:GetChild(index).gameObject,"SC_gift_des","ScrollViewClick")

    if(giftId == nil) then
        return
    end
    
    local _Gift = TableDataManager:GetInstance():GetTableData("Gift", giftId)
    if _Gift == nil then
        dprint("Error，天赋表不存在此ID：".. giftId)
        return
    end

    dprint("创建天赋，giftID为：%d,名字：%s", giftId,GetLanguageByID(_Gift.NameID))


    text_name.text = GetLanguagePreset(_Gift.NameID,"天赋名".._Gift.NameID)
    text_name.color = getRankColor(_Gift.Rank)
        
    text_des.text  = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID)
	-- text_des.color = getRankColor(_Gift.Rank)

    text_cost.text =  "<color=#62523b>天赋值:</color>".._Gift.Cost;
    -- text_name.text = ""
    -- text_des.text = ""
    if scrollView_Add then
        scrollView_Add:ClearLuaFunction()
		scrollView_Add:SetLuaFunction(function (args)
			self:OnClick_AddGift(_Gift.BaseID,args)
		end)
    end

    self:RemoveButtonClickListener(button_Add)
    self:AddButtonClickListener(button_Add, function() self:OnClick_AddGift(_Gift.BaseID) end)
    
end

function PickGiftUI:OnClick_AddGift(giftid,args)
    if args and args.button == DRCSRef.EventSystems.PointerEventData.InputButton.Right then return end
    local _Gift = TableDataManager:GetInstance():GetTableData("Gift", giftid)
    if not _Gift then
        return
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if not roleData then
        return
    end
    -- if roleData.aiAttrs[AttrType.ATTR_WUXING] * 2  - roleData.uiGiftUsedNum < _Gift.Cost then
    --     SystemUICall:GetInstance():Toast("您的天赋值不够，无法学习此天赋")
    --     return
    -- end

	dprint(string.format("OnClick_AddRoleGift"))
    local roleid = self.selectRole
	local clickCheatData = EncodeSendSeGC_ClickRoleAddGift(roleid,giftid,RAGT_LEARN)
	local iSize = clickCheatData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_ADD_GIFT,iSize,clickCheatData)
    RemoveWindowImmediately("PickGiftUI",true)
    globalDataPool:setData("IsUpdatePickGiftUI", true, true)

end

function PickGiftUI:RefreshUI(info)
    self.selectRole = info
    dprint("刷新天赋池")
    
    local BuyButton = self.Button_buy:GetComponent("Button")
    self:RemoveButtonClickListener(BuyButton)
    self:AddButtonClickListener(BuyButton, function()  self:SendRandomGiftCMD()  end)
end

function PickGiftUI:SendRandomGiftCMD()
    local refreshBallNum = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall()
    local cost = TableDataManager:GetInstance():GetTable("CommonConfig")[1].RefreshGiftCost or 1
    if refreshBallNum < cost then
        SystemUICall:GetInstance():Toast("幸运珠不足")
        return
    end
    SendRandomGiftCMD(1, self.selectRole, 3)
end

function PickGiftUI:ShowTips()
    local des = "天赋抽取规则\n1、点天赋时随机抽取3条天赋，可从中选择一条天赋获得。\n2、抽取天赋时，不同品质天赋的出现概率为：\n白色天赋：21%\n蓝色天赋：16%\n紫色天赋：14%\n橙色天赋：12%\n金色天赋：10%\n暗金天赋：8%"
    

    local info = {
        des = des,
        pivotx = 0.5,
        pivoty = 0.5,
        posx = 0,
        posy = 0
    }
    OpenWindowImmediately("RulePopUI",info)

end

function PickGiftUI:OnEnable()
    self:RefreshText()
    -- OpenWindowBar({
    --     ['windowstr'] = "PickGiftUI",
    --     --['titleName'] = "抽取天赋",
	-- 	    ['topBtnState'] = {
    --         ['bGold'] = true,
    --         ['bSilver'] = true,
	-- 	},
	-- })
end

function PickGiftUI:OnDisable()
    RemoveWindowBar('PickGiftUI')
end

return PickGiftUI