PickWishRewardsUI = class("PickWishRewardsUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local SpineRoleUI = require 'UI/Role/SpineRoleUI'
local CharacterUI = require 'UI/Role/CharacterUI'

function PickWishRewardsUI:Create()
	local obj = LoadPrefabAndInit("Role/PickGiftUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end

    self:UpdateData()
end

function PickWishRewardsUI:Init()
    self.BG = self:FindChildComponent(self._gameObject,"PopUpWindow_4/Black","Button")
    self.Button_close = self:FindChildComponent(self._gameObject,"newFrame/Btn_exit","Button")
    self.Gift_pool_box = self:FindChild(self._gameObject,"Gift_pool_box")
    self.Button_buy = self:FindChildComponent(self._gameObject,"Button_buy","Button")
    self.Text_Number =  self:FindChildComponent(self._gameObject,"Number","Text")

    self.Text_gift_point = self:FindChildComponent(self._gameObject,"Text_gift_point","Text")
    self.Text_refresh_times = self:FindChildComponent(self._gameObject,"Text_refresh_times","Text")

    self:AddButtonClickListener(self.BG, function() RemoveWindowImmediately("PickWishRewardsUI",true) end)
    self:AddButtonClickListener(self.Button_close, function() 
        RemoveWindowImmediately("PickWishRewardsUI",true) 
        LogicMain:GetInstance():SetOpenWindowsNO(1)
    end)
    self:AddButtonClickListener(self.Button_buy, function()  self:SendRandomWishRewards()  end)

    self:RefreshText()

    self:AddEventListener("UPDATE_INTERACT_REFRESHTIMES", function()
        self:RefreshText()
    end)

    self:AddEventListener("ShoppingMallUI",function(iOpen)
        if iOpen == 1 then
            RemoveWindowImmediately("PickWishRewardsUI",true)
        else
            OpenWindowImmediately("PickWishRewardsUI",{self.selectRole,self.wishtaskID})
        end
    end,nil,nil,nil,true
    )
    
    self:RefreshTimes()

    self.Button_question = self:FindChildComponent(self._gameObject,"Text_gift_point/Button_question","Button")
    self:AddButtonClickListener(self.Button_question, function() 
        self:ShowTips()
    end)

    self.objCards = {}
    self.aiCards2ID = {}
    for i=1,3 do 
        local obj = self:FindChild(self._gameObject,"Gift_pool_box/"..i)
        self.objCards[i] = obj
        local button_Add  = self:FindChildComponent(obj,"Button_sure","Button")
        if button_Add then
            self:AddButtonClickListener(button_Add, function() self:OnClick_ChooseWishRewards(self.aiCards2ID[i]) end)
        end
        local scrollView_Add  = self:FindChildComponent(obj,"SC_gift_des","ScrollViewClick")
        if scrollView_Add then
            scrollView_Add:SetLuaFunction(function(args)
                self:OnClick_ChooseWishRewards(self.aiCards2ID[i],args)
            end)
        end
    end

    self:AddEventListener("UPDATE_STORAGE_ITEM",function()
        self:RefreshText()
    end)
end

function PickWishRewardsUI:RefreshText()
    local refreshBallNum = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall() or 0
    local refreshCost = TableDataManager:GetInstance():GetTable("CommonConfig")[1].RefreshGiftCost or 1
    self.Text_Number.text = "(" .. refreshBallNum .. " / " .. refreshCost .. ")"
end

function PickWishRewardsUI:RefreshRemainPoint()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if  self.Text_gift_point and roleData and roleData.aiAttrs[AttrType.ATTR_WUXING] and roleData.uiGiftUsedNum then
        self.Text_gift_point.text = "???????????????:"..tostring(roleData.aiAttrs[AttrType.ATTR_WUXING] * 2  - roleData.uiGiftUsedNum)
    end
end

function PickWishRewardsUI:RefreshGiftPool(uiWishRewards)
    for int_i = 0,#uiWishRewards do
        self:RefreshGiftGrid(int_i,uiWishRewards[int_i])
    end
    self:RefreshTimes()
    self:RefreshRemainPoint()
    self:RefreshText()
end

-- ????????????
function PickWishRewardsUI:RefreshTimes()
    local icur, iMax = RoleDataHelper.GetRefreshTimes(PlayerBehaviorType.PBT_WishTaskRewardRefresh)
    if icur and iMax then
        self.Text_refresh_times.text = "??????????????????:" .. tostring(iMax - icur)
    end
end

function PickWishRewardsUI:RefreshGiftGrid(index,rewardId)
    --Cost
    -- local text_cost = self:FindChildComponent(self.objCards[index+1],"Text_cost","Text")
    -- --Name
    -- text_cost.enabled = true
    local text_name = self:FindChildComponent(self.objCards[index+1].gameObject,"Name","Text")
    --Des
    local text_des = self:FindChildComponent(self.objCards[index+1].gameObject,"Text","EmojiText")
    if(rewardId == nil) then
        return
    end

    local rewardBaseData = TableDataManager:GetInstance():GetTableData("RoleWishReward",rewardId)
    if rewardBaseData == nil then
        dprint("Error????????????????????????ID???".. rewardId)
        return
    end

    self.aiCards2ID[index + 1] = rewardBaseData.BaseID

    if GetLanguageByID(rewardBaseData.NameID) == nil then
        text_name.text = "?????????" .. tostring(rewardBaseData.NameID)
    else
        text_name.text = GetLanguageByID(rewardBaseData.NameID)
        local rankColor = RANK_COLOR[RankType.RT_White]
        if dnull(rewardBaseData.WishTreeID) then 
            local selectRoleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(self.selectRole)
            local cardLevel = RoleDataManager:GetInstance():GetRoleOverlayLevel(self.selectRole)
            local giftID = CardsUpgradeDataManager:GetInstance():GetTreeGift(selectRoleBaseID, cardLevel, rewardBaseData.WishTreeID)
            local giftData = GetTableData("Gift", giftID)
            if giftData then 
                rankColor = getRankColor(giftData.Rank)
            end
        else
            rankColor = getRankColor(rewardBaseData.Rank)
        end
        text_name.color = rankColor
    end
    local string_des, string_Cost = WishTaskDataManager:GetInstance():GetWishTaskDesc(self.selectRole, rewardId)
    text_des.text = string_des
    self:RefreshText()
    --text_cost.text =  "<color=#62523b>?????????:</color>"..string_Cost   
end

function PickWishRewardsUI:OnClick_ChooseWishRewards(rewardID,args)
    if args and args.button == DRCSRef.EventSystems.PointerEventData.InputButton.Right then return end
    -- ????????????????????????
    -- RemoveWindowImmediately("PickWishRewardsUI",true)
    SendChooseWishRewardsCMD(self.selectRole, self.wishtaskID, rewardID);
    --TODO: ??????????????????
    WishTaskDataManager:GetInstance().IsUpdateWishTashRewardUI = true
end

function PickWishRewardsUI:RefreshUI(info)
    local selectRole,wishtaskID = table.unpack(info)
    self.wishtaskID = wishtaskID
    self.selectRole = selectRole

    LogicMain:GetInstance():SetOpenWindowsNO(2)
end

function PickWishRewardsUI:SendRandomWishRewards()
    local refreshBallNum = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall()
    local refreshCost = TableDataManager:GetInstance():GetTable("CommonConfig")[1].RefreshGiftCost or 1
    if refreshBallNum < refreshCost then
        SystemUICall:GetInstance():Toast("?????????????????????")
        return
    end
    SendRandomWishRewardsCMD(1,self.selectRole,self.wishtaskID,3)
end


function PickWishRewardsUI:UpdateData()

end



function PickWishRewardsUI:ShowTips()
    local des = "????????????????????????\n1?????????????????????????????????3??????????????????????????????????????????????????????????????????\n2????????????????????????????????????????????????????????????????????????\n???????????????21%\n???????????????19%\n???????????????16%\n???????????????14%\n???????????????12%\n???????????????10%\n???????????????8%"

    local info = {
        des = des,
        pivotx = 0.5,
        pivoty = 0.5,
        posx = 0,
        posy = 0
    }
    OpenWindowImmediately("RulePopUI",info)

end


function PickWishRewardsUI:OnEnable()
    self:RefreshText()
    -- OpenWindowBar({
    --     ['windowstr'] = "PickWishRewardsUI",
    --     --['titleName'] = "??????????????????",
	-- 	    ['topBtnState'] = {
    --         ['bGold'] = true,
    --         ['bSilver'] = true,
	-- 	},
	-- })
end

function PickWishRewardsUI:OnDisable()
    RemoveWindowBar('PickWishRewardsUI')
    local CharacterUI = GetUIWindow('CharacterUI')
    if CharacterUI then
        CharacterUI:RefreshWishTask()
    end
end

function PickWishRewardsUI:OnPressESCKey() 
    if self.Button_close then
	    self.Button_close.onClick:Invoke()
    end
    
end

return PickWishRewardsUI