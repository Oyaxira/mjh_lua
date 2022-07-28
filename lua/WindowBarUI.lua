WindowBarUI = class("WindowBarUI",BaseWindow)

local Tips = {
    ['Shane'] = {
        title = '仁义值',
        content = '做仁义之事会提高仁义值, 做霸道之事会降低仁义值'
    },
    ['JinZhuan'] = {
        title = '金锭',
        content = '通过充值获得，可用于兑换银锭、开启百宝书壕侠等'
    },
    ['YuanBao'] = {
        title = '银锭',
        content = '通过闲聊、完成剧本、日常活动、金锭兑换等获得，可用于强化装备、解锁角色、购买商城物品等'
    },
    ['TongBi'] = {
        title = '铜币',
        content = '通过做任务、卖物品、跑商、战斗等获得，可用于购买物品，强化装备等'
    },
    ['TreasureBook'] = {
        title = '百宝书残页',
        content = '通过百宝书签到、百宝书任务获得，可在百宝书“兑换”或商城“残章”处兑换各种物品'
    },
    ['JuiQuan'] = {
        title = '擂台币',
        content = '通过擂台助威猜对获得，可在商城“擂台”处兑换物品'
    },
    ['JiFenPlat'] = {
        title = '资源值',
        content = '通过分解角色卡获得，可在商城“易货”处兑换角色卡、宠物卡等'
    },
    ['JiFenActive'] = {
        title = '活动积分',
        content = '通过参与游戏外官方论坛、Q群、公众号获得，可在商城“活动”处兑换各种物品'
    },
    ['Meridians'] = {
        title = '经脉经验',
        content = '经脉经验用于在经脉系统中提升经脉等级，永久提升全队能力'
    },
    ['SecondGold'] = {
        title = '旺旺币',
        content = '旺旺币最多能抵扣限时商店中的180金锭价值，每个礼包只能用1个旺旺币抵扣，不能使用多个'
    },
    ['Pinball'] = {
        title = '小侠客',
        content = '通过商城购买、日常活动等途径获得，可用于在侠客行玩法中，换取珍贵宝物'
    },
    ['TuPoDan'] = {
        title = '冲灵丹',
        content = '冲灵丹用于在酒馆-经脉系统中冲破经脉层数，大幅提升经脉能力'
    },
    ['ZmGold'] = {
        title = '掌门币',
        -- TODO: 配表
        content = '参加掌门对决活动，名次越高获得掌门币越多，可用于兑换角色卡。'
    },
    ['BondPellet'] = {
        title = '羁绊丹',
        content = '用于升级角色之间的羁绊，提升属性。可在掌门对决活动中获得，商城限量出售。'
    },
    ['FestivalValue1'] = {
        title = '雪球',
        -- TODO: 提备忘单 后期抽出去
        content = '冬雪节活动材料，仅可在冬雪节活动期间的活动兑换处使用，消耗一定数量，能以比平时更低的价格兑换各种物品'
    },
    ['FestivalValue2'] = {
        title = '冬雪好感度',
        content = '冬雪节活动特殊物品，集齐100个后，可以在礼包福利界面兑换到冬雪老板娘'
    },
}

function WindowBarUI:ctor()

end

function WindowBarUI:Create()
	local obj = LoadPrefabAndInit("Game/WindowBarUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function WindowBarUI:Init()
    self.iMaxBGStyleIndex = 3  -- 每个图标拥有的背景数
    self.resource_box = self:FindChild(self._gameObject, "TransformAdapt_node_right/resource_box")
    self.other_box = self:FindChild(self._gameObject, "TransformAdapt_node_right/other_box")
    self.resource_box.gameObject:SetActive(true)
    self.other_box.gameObject:SetActive(false)

    self.objItem = self:FindChild(self.other_box, "item")
    self.btnItem = self:FindChildComponent(self.objItem, 'DRButton', 'DRButton')
    self.objItem_Text = self:FindChildComponent(self.objItem,"Text","Text")
    self.imgItem = self:FindChildComponent(self.objItem,"Image","Image")

    self.v3OriResBoxPos = self.resource_box.transform.localPosition
    self.comLayoutResourceBox = self.resource_box:GetComponent("HorizontalLayoutGroup")
    self:ResetResourcesBox()
    self.objShane = self:FindChild(self.resource_box, "Shane")
    self.objJinZhuan = self:FindChild(self.resource_box, "JinZhuan")
    self.objYuanBao = self:FindChild(self.resource_box, "YuanBao")
    self.objTongBi = self:FindChild(self.resource_box, "TongBi")
    self.objTreasureBook = self:FindChild(self.resource_box, "TreasureBook")
    self.objJuiQuan = self:FindChild(self.resource_box, "JuiQuan")
    self.objJiFenPlat = self:FindChild(self.resource_box, "JiFenPlat")
    self.objJiFenActive = self:FindChild(self.resource_box, "JiFenActive")
    self.objMeridians = self:FindChild(self.resource_box, "Meridians")
    self.objSecondGold = self:FindChild(self.resource_box, "SecondGold")
    self.objFestivalValue1 = self:FindChild(self.resource_box, "FestivalValue1")
    self.objFestivalValue2 = self:FindChild(self.resource_box, "FestivalValue2")
    self.objPinball = self:FindChild(self.resource_box, "Pinball")
    self.objTuPoDan = self:FindChild(self.resource_box, "TuPoDan")
    self.objZmGold = self:FindChild(self.resource_box, "ZmGold")
    self.objBondPellet = self:FindChild(self.resource_box, "BondPellet")
    self.objNavName = self:FindChild(self._gameObject, "TransformAdapt_node_left/Nav_Label")
    self.objTextUIName = self:FindChild(self._gameObject, "TransformAdapt_node_left/Button_back/Text_UI_name")
    self.objImageUIName = self:FindChild(self._gameObject, "TransformAdapt_node_left/Button_back/Image_UI_name")
    
    local btnTable = {};
    btnTable.Shane = self:FindChildComponent(self.objShane, 'DRButton', 'DRButton');
    btnTable.JinZhuan = self:FindChildComponent(self.objJinZhuan, 'DRButton', 'DRButton');
    btnTable.YuanBao = self:FindChildComponent(self.objYuanBao, 'DRButton', 'DRButton');
    btnTable.TongBi = self:FindChildComponent(self.objTongBi, 'DRButton', 'DRButton');
    btnTable.TreasureBook = self:FindChildComponent(self.objTreasureBook, 'DRButton', 'DRButton');
    btnTable.JuiQuan = self:FindChildComponent(self.objJuiQuan, 'DRButton', 'DRButton');
    btnTable.JiFenPlat = self:FindChildComponent(self.objJiFenPlat, 'DRButton', 'DRButton');
    btnTable.JiFenActive = self:FindChildComponent(self.objJiFenActive, 'DRButton', 'DRButton');
    btnTable.Meridians = self:FindChildComponent(self.objMeridians, 'DRButton', 'DRButton');
    btnTable.SecondGold = self:FindChildComponent(self.objSecondGold, 'DRButton', 'DRButton');
    btnTable.FestivalValue1 = self:FindChildComponent(self.objFestivalValue1, 'DRButton', 'DRButton');
    btnTable.FestivalValue2 = self:FindChildComponent(self.objFestivalValue2, 'DRButton', 'DRButton');
    btnTable.Pinball = self:FindChildComponent(self.objPinball, 'DRButton', 'DRButton');
    btnTable.TuPoDan = self:FindChildComponent(self.objTuPoDan, 'DRButton', 'DRButton');
    btnTable.ZmGold = self:FindChildComponent(self.objZmGold, 'DRButton', 'DRButton');
    btnTable.BondPellet = self:FindChildComponent(self.objBondPellet, 'DRButton', 'DRButton');

    for k, v in pairs(btnTable) do
        local fun = function()
            OpenWindowImmediately("TipsPopUI", Tips[k]);
        end
        self:AddButtonClickListener(v, fun);
    end

    self.objShane_Text = self:FindChildComponent(self.objShane,"Text","Text")
    self.objJinZhuan_Text = self:FindChildComponent(self.objJinZhuan,"Text","Text")
    self.objYuanBao_Text = self:FindChildComponent(self.objYuanBao,"Text","Text")
    self.objTongBi_Text = self:FindChildComponent(self.objTongBi,"Text","Text")
    self.objTreasureBook_Text = self:FindChildComponent(self.objTreasureBook,"Text","Text")
    self.objJuiQuan_Text = self:FindChildComponent(self.objJuiQuan,"Text","Text")
    self.objJiFenPlat_Text = self:FindChildComponent(self.objJiFenPlat,"Text","Text")
    self.objJiFenActive_Text = self:FindChildComponent(self.objJiFenActive,"Text","Text")
    self.objMeridians_Text = self:FindChildComponent(self.objMeridians,"Text","Text")
    self.objSecondGold_Text = self:FindChildComponent(self.objSecondGold,"Text","Text")
    self.objFestivalValue1_Text = self:FindChildComponent(self.objFestivalValue1,"Text","Text")
    self.objFestivalValue2_Text = self:FindChildComponent(self.objFestivalValue2,"Text","Text")
    self.objPinball_Text = self:FindChildComponent(self.objPinball,"Text","Text")
    self.objTuPoDan_Text = self:FindChildComponent(self.objTuPoDan,"Text","Text")
    self.objZmGold_Text = self:FindChildComponent(self.objZmGold,"Text","Text")
    self.comNavName_Text = self:FindChildComponent(self.objNavName, "Text", "Text")
    self.objBondPellet_Text = self:FindChildComponent(self.objBondPellet,"Text","Text")
    self.comTextUIName = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/Button_back/Text_UI_name", "Text")
    
    self.objShaneAdd = self:FindChild(self.objShane,"Button_add")
    self.objShaneAdd_Btn = self:FindChildComponent(self.objShaneAdd,"Button")
    if self.objShaneAdd_Btn then 
        local fun = function()
            self:OnClick_ShaneAdd_Btn()
        end
        self:AddButtonClickListener(self.objShaneAdd_Btn,fun)
    end 
    self.objJinZhuanAdd = self:FindChild(self.objJinZhuan,"Button_add")
    self.objJinZhuanAdd_Btn = self.objJinZhuanAdd:GetComponent("Button")
    if self.objJinZhuanAdd_Btn then 
        local fun = function()
            self:OnClick_JinZhuanAdd_Btn()
        end
        self:AddButtonClickListener(self.objJinZhuanAdd_Btn,fun)
    end 
    self.objYuanBaoAdd =  self:FindChild(self.objYuanBao,"Button_add")
    self.objYuanBaoAdd_Btn = self.objYuanBaoAdd:GetComponent("Button")
    if self.objYuanBaoAdd_Btn then 
        local fun = function()
            self:OnClick_YuanBaoAdd_Btn()
        end
        self:AddButtonClickListener(self.objYuanBaoAdd_Btn,fun)
    end 
    self.objTongBiAdd = self:FindChild(self.objTongBi,"Button_add")
    self.objTongBiAdd_Btn = self:FindChildComponent(self.objTongBiAdd,"Button")
    if self.objTongBiAdd_Btn then 
        local fun = function()
            self:OnClick_TongBiAdd_Btn()
        end
        self:AddButtonClickListener(self.objTongBiAdd_Btn,fun)
    end 
    self.objTreasureBookAdd = self:FindChild(self.objTreasureBook,"Button_add")
    self.objMeridiansAdd = self:FindChild(self.objMeridians,"Button_add")
    self.objFestivalValue1Add = self:FindChild(self.objFestivalValue1,"Button_add")
    self.objFestivalValue2Add = self:FindChild(self.objFestivalValue2,"Button_add")
    self.objSecondGoldAdd = self:FindChild(self.objSecondGold,"Button_add")
    self.objSecondGoldAdd_Btn = self.objSecondGoldAdd:GetComponent("Button")
    if self.objSecondGoldAdd_Btn then 
        local fun = function()
            self:OnClick_SecondGoldAdd_Btn()
        end
        self:AddButtonClickListener(self.objSecondGoldAdd_Btn,fun)
    end 
    self.objPinballAdd = self:FindChild(self.objPinball,"Button_add")
    self.objTuPoDanAdd = self:FindChild(self.objTuPoDan,"Button_add")

    self.objBack_Button = self:FindChild(self._gameObject, "TransformAdapt_node_left/Button_back")
    self.btnBack_Button = self.objBack_Button:GetComponent("Button")
    if self.btnBack_Button then
        local fun = function()
			self:OnClick_Back_Button()
        end
        self:AddButtonClickListener(self.btnBack_Button,fun)
    end

    -- 注册刷新事件，元宝/善恶值 在主角信息里
    local fun_refresh = function()
		self:UpdateWindow()
	end
	self:AddEventListener("UPDATE_MAIN_ROLE_INFO",fun_refresh)
end
local windows={
    "PickGiftUI",
    "BatchChooseUI"
}
function WindowBarUI:OnPressESCKey()
    if self.btnBack_Button and not IsAnyWindowOpen(windows) then
	    self.btnBack_Button.onClick:Invoke()
    end
end

-- 设置resource_box排列为居中
function WindowBarUI:ResetResourcesBox()
    self.comLayoutResourceBox.childAlignment = CS.UnityEngine.TextAnchor.MiddleRight
end

-- 设置resource_box排列为居中
function WindowBarUI:SetResourcesBoxMiddleCenter()
    self.comLayoutResourceBox.childAlignment = CS.UnityEngine.TextAnchor.MiddleCenter
end

function WindowBarUI:OnClick_Back_Button()
    if not self.associated_window then
        return
    end
    local doExit = function()
        if self.callback then
            if self.skipDefaultBackCallback then 
                self:ClearSecondConfirm()
                self.callback()
                return
            end

            self:ClearSecondConfirm()
            self.callback()
            self.callback = nil
        end 
        self.bSaveToCache = (self.bSaveToCache ~= false)
        if GetUIWindow(self.associated_window) then
            RemoveWindowImmediately(self.associated_window, self.bSaveToCache)
            DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
        end
    end
    if self.strSecondConfirm and (self.strSecondConfirm ~= "") then
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, self.strSecondConfirm, doExit})
    else
        doExit()
    end
end

function WindowBarUI:OnClick_ShaneAdd_Btn()
    if self.associated_window then

    end
end
function WindowBarUI:OnClick_JinZhuanAdd_Btn()
    if self.associated_window then
        OpenWindowImmediately("ShoppingMallUI")
        local win = GetUIWindow("ShoppingMallUI")
        if win then 
            win:SetPayTag()
        end
        --SystemUICall:GetInstance():Toast("暂未开放充值")
    end
end
function WindowBarUI:OnClick_YuanBaoAdd_Btn()
    OpenWindowImmediately("Gold2SilverUI")
end
function WindowBarUI:OnClick_SecondGoldAdd_Btn()
    OpenWindowImmediately("Gold2SecondGoldUI")
end
function WindowBarUI:OnClick_TongBiAdd_Btn()
    if self.associated_window then

    end
end

function WindowBarUI:OnDestroy()

end

--参数说明
-- info = {
--     ['windowstr'] = "xxxxUI",  --关联的界面名称, 用于点击返回时关闭该界面
--     ['titleName'] = "",                      -- 窗口名称
--     ['topBtnState'] = {  --决定顶部栏资源显示状态, true时显示
--         ['bBackBtn'] = true,
--         ['bGoodEvil'] = true,
--         ['bGold'] = true,
--         ['bSilver'] = true,
--         ['bCoin'] = true,
--         ['bTreasureBook'] = true,
--         ['bMeridians'] = true,
--         ['bSecondGold'] = true,
--         ['bFestivalValue1'] = true,
--         ['bFestivalValue2'] = true,
--         ['bPinball'] = true,
--     },
--     ['callback'] = function,  --关闭前回调
--     ['bSaveToCache'] = true, 是否缓存ui
--     ['iOffset'] = 0,  --偏移
--     ['iYOffset'] = 0,  --纵向偏移偏移
--     ['style'] = 1,  -- 样式
--     ['strSecondConfirm'] = "Ready to exit?",  -- 二次确认提示

-- }
function WindowBarUI:AddWindowInfo(info)
    if info == nil then 
        return
    end
    local windowName = info.windowstr
    self.windowInfo = self.windowInfo or {}
    self.windowInfo[windowName] = info
    self:UpdateWindow()
end

function WindowBarUI:RemoveWindowInfo(closeWindowName)
    if closeWindowName == nil or self.windowInfo == nil then 
        return
    end
    self.windowInfo[closeWindowName] = nil
    local hasAssociateWindow = false
    for infoWindowName, info in pairs(self.windowInfo) do 
        if IsWindowOpen(infoWindowName) then 
            hasAssociateWindow = true
            break
        end
    end
    if hasAssociateWindow then 
        self:UpdateWindow()
    else
        self.windowInfo = {}
        RemoveWindowImmediately("WindowBarUI")
    end
end

function WindowBarUI:GetCurAssociateWindowInfo()
    if self.windowInfo == nil then 
        return nil
    end
    local curWindowInfo = nil
    local curWindowOrder = 0
    for windowName, info in pairs(self.windowInfo) do 
        if IsWindowOpen(windowName) and WINDOW_ORDER_INFO[windowName] and (WINDOW_ORDER_INFO[windowName].order or 0) > curWindowOrder then
            curWindowOrder = WINDOW_ORDER_INFO[windowName].order
            curWindowInfo = info
        end
    end
    return curWindowInfo
end

function WindowBarUI:UpdateWindow()
    local info = self:GetCurAssociateWindowInfo()
    if info then
        self.topBtnState = info.topBtnState or {}  --顶部按钮的状态信息
        local windowstr = info.windowstr  --关联的ui
        local bLegalWindow = (type(windowstr) == 'string')
        self.associated_window = nil
        if bLegalWindow then
            self.associated_window = windowstr
        end

        if (not bLegalWindow) or (self.topBtnState.bBackBtn == false) then
            self.objBack_Button:SetActive(false)
        else
            self.objBack_Button:SetActive(true)
        end

        self.bSaveToCache = (info.bSaveToCache ~= false)

        local callback = info.callback
        self.callback = callback
        -- 是否跳过默认返回回调
        self.skipDefaultBackCallback = info.skipDefaultBackCallback

        info.iOffset = info.iOffset or 0 
        info.iYOffset = info.iYOffset or 0
        self.v3Local = self.v3OriResBoxPos
        self.resource_box.transform.localPosition = DRCSRef.Vec3(self.v3Local.x + info.iOffset, self.v3Local.y + info.iYOffset , self.v3Local.z)

        local style = info.style or 1
        self:SetBGType(style)

        if info.strSecondConfirm and (info.strSecondConfirm ~= "") then
            self:SetSecondConfirm(info.strSecondConfirm)
        end
    end
    
    if info and (info.titleName and info.titleName ~= "") then
        self.objTextUIName:SetActive(true)
        self.objImageUIName:SetActive(true)
        self.comTextUIName.text = info.titleName
    else
        self.objTextUIName:SetActive(false)
        self.objImageUIName:SetActive(false)
        self.comTextUIName.text = ""
    end

    local playerSetMgr = PlayerSetDataManager:GetInstance()
    self.objJinZhuan_Text.text = playerSetMgr:GetPlayerGold()
    self.objYuanBao_Text.text = playerSetMgr:GetPlayerSliver()
    self.objJuiQuan_Text.text = playerSetMgr:GetPlayerDrinkMoney()
    self.objJiFenPlat_Text.text = playerSetMgr:GetPlayerPlatScore()
    self.objJiFenActive_Text.text = playerSetMgr:GetPlayerActiveScore()
    self.objSecondGold_Text.text = playerSetMgr:GetPlayerSecondGold()
    self.objFestivalValue1_Text.text = playerSetMgr:GetFestivalValue(1)
    self.objFestivalValue2_Text.text = playerSetMgr:GetFestivalValue(2)
    self.objBondPellet_Text.text = playerSetMgr:GetBondPellet()

    local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        self.objTongBi_Text.text = playerSetMgr:GetPlayerCoin()
    else
        self.objTongBi_Text.text = 0
    end

    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData then 
        self.objShane_Text.text = mainRoleData["iGoodEvil"] or 0
    else
        self.objShane_Text.text = 0
    end

    local treasureBookBaseInfo = TreasureBookDataManager:GetInstance():GetTreasureBookBaseInfo()
    if treasureBookBaseInfo and treasureBookBaseInfo.iMoney then
        self.objTreasureBook_Text.text = treasureBookBaseInfo.iMoney or 0
    else
        self.objTreasureBook_Text.text = 0
    end

    self.objTuPoDan_Text.text = MeridiansDataManager:GetInstance():GetCurTotalBreak() or 0

    -- 掌门币
    if PKManager:GetInstance():IsRunning() then
        self.objZmGold_Text.text = PKManager:GetInstance():GetZmGold()
    end

    self:RefreshMeridians()
    self:RefreshPinball()

    self:SwitchTopBtn(self.topBtnState)

    if info and info.doAfterInit then
        info.doAfterInit()
    end
end

function WindowBarUI:SetNumByType(type, num)
    if type == STLMT_COIN then
        self.objTongBi_Text.text = num;
    elseif type == STLMT_SILVER then
        self.objYuanBao_Text.text = num;
    elseif type == STLMT_GOLD then
        self.objJinZhuan_Text.text = num;
    elseif type == STLMT_DRINK then
        self.objJuiQuan_Text.text = num;
    elseif type == STLMT_PLATFORMSCORE then
        self.objJiFenPlat_Text.text = num;
    elseif type == STLMT_ACTIVEFORMSCORE then
        self.objJiFenActive_Text.text = num;
    elseif type == STLMT_SECONDGOLD then
        self.objSecondGold_Text.text = num;
    -- elseif type == STLMT_SECONDGOLD then
    --     self.objFestivalValue1_Text.text = num;
    -- elseif type == STLMT_SECONDGOLD then
    --     self.objFestivalValue2_Text.text = num;
    elseif type == STLMT_ZMGOLD then
        self.objZmGold_Text.text = num;
    end
end

function WindowBarUI:SwitchTopBtn(data)
    data = data or {}
    -- avoid nil
    local bGoodEvil = (data.bGoodEvil == true)
    local bGold = (data.bGold == true)
    local bSilver = (data.bSilver == true)
    local bCoin = (data.bCoin == true)
    local bTreasureBook = (data.bTreasureBook == true)
    local bJuiQuan = (data.bJuiQuan == true)
    local bJiFenPlat = (data.bJiFenPlat == true)
    local bJiFenActive = (data.bJiFenActive == true)
    local bMeridians = (data.bMeridians == true)
    local bSecondGold = (data.bSecondGold == true)
    local bFestivalValue1 = (data.bFestivalValue1 == true)
    local bFestivalValue2 = (data.bFestivalValue2 == true)
    local bPinball = (data.bPinball == true)
    local bTuPoDan = (data.bTuPoDan == true)
    local bZmGold = (data.bZmGold == true)
    local bBondPellet = (data.bBondPellet == true)

    -- set state
    self.objShane:SetActive(bGoodEvil)
    self.objJinZhuan:SetActive(false)
    self.objYuanBao:SetActive(false)
    self.objTongBi:SetActive(bCoin)
    self.objTreasureBook:SetActive(false)
    self.objJuiQuan:SetActive(bJuiQuan)
    self.objJiFenPlat:SetActive(bJiFenPlat)
    self.objJiFenActive:SetActive(bJiFenActive)
    self.objMeridians:SetActive(bMeridians)
    self.objSecondGold:SetActive(bSecondGold)
    self.objFestivalValue1:SetActive(bFestivalValue1)
    self.objFestivalValue2:SetActive(bFestivalValue2)
    self.objPinball:SetActive(bPinball)
    self.objTuPoDan:SetActive(bTuPoDan)
    self.objZmGold:SetActive(bZmGold)
    self.objBondPellet:SetActive(bBondPellet)

    self.objShaneAdd:SetActive(false)
    self.objJinZhuanAdd:SetActive(false)
    self.objYuanBaoAdd:SetActive(true)
    self.objTongBiAdd:SetActive(false)
    self.objTreasureBookAdd:SetActive(false)
    self.objMeridiansAdd:SetActive(false)
    self.objSecondGoldAdd:SetActive(true)
    self.objFestivalValue1Add:SetActive(false)
    self.objFestivalValue2Add:SetActive(false)
    self.objPinballAdd:SetActive(false)
    self.objTuPoDanAdd:SetActive(false)
    -- self.objBondPelletAdd:SetActive(false)
end

function WindowBarUI:SetBGType(type)
    if not self.iconBG then
        local nodeList = {
            self.objJinZhuan,
            self.objYuanBao,
            self.objTongBi,
            self.objTreasureBook,
            self.objJuiQuan,
            self.objJiFenPlat,
            self.objJiFenActive,
            self.objMeridians,
            self.objSecondGold,
            self.objFestivalValue1,
            self.objFestivalValue2,
            self.objPinball,
            self.objTuPoDan,
            self.objZmGold,
        }
        self.iconBG = {}
        local objBG = nil
        for i = 1, self.iMaxBGStyleIndex do
            if not self.iconBG[i] then
                self.iconBG[i] = {}
            end
            for index, node in ipairs(nodeList) do
                objBG = self:FindChild(node, 'Image_bg' .. i)
                if objBG then
                    self.iconBG[i][#self.iconBG[i] + 1] = objBG
                    objBG:SetActive(false)
                end
            end
        end
    end
    
    if not self.iconBG[type] then
        return
    end

    if self.iCurBGStyle then
        for index, objBG in ipairs(self.iconBG[self.iCurBGStyle]) do
            objBG:SetActive(false)
        end
    end

    for index, objBG in ipairs(self.iconBG[type]) do
        objBG:SetActive(true)
    end
    self.iCurBGStyle = type
end

function WindowBarUI:OnEnable()
    self:ResetResourcesBox()

    self:AddEventListener('ONEVENT_REF_MONEY', function(info)
        self:SetNumByType(info.eMoneyType, info.dwCurNum);
    end);

    self:UpdateWindow()
end

function WindowBarUI:OnDisable()
    self.resource_box.transform.localPosition = self.v3Local

    self:RemoveEventListener('ONEVENT_REF_MONEY');
end

function WindowBarUI:SetSecondConfirm(strSecondConfirm)
    if (not strSecondConfirm) or (strSecondConfirm == "") then
        return
    end
    self.strSecondConfirm = strSecondConfirm
end

function WindowBarUI:ClearSecondConfirm()
    self.strSecondConfirm = nil
end

function WindowBarUI:SetBackBtnState(bOn)
    self.objBack_Button:SetActive(bOn ~= false)
end

-- 刷新经脉经验数量
function WindowBarUI:RefreshMeridians()
    self.objMeridians_Text.text = MeridiansDataManager:GetInstance():GetCurTotalExp() or 0
end

-- 刷新小侠客数量
function WindowBarUI:RefreshPinball()
    self.objPinball_Text.text = PinballDataManager:GetInstance():GetNormalHoodleNum() or 0
end

--
function WindowBarUI:SetTitleName(titleName)
    self.comTextUIName.text = titleName;
end

function WindowBarUI:ResetType()
    self.resource_box.gameObject:SetActive(true)
    self.other_box.gameObject:SetActive(false)
end

function WindowBarUI:UpdateMoneyType(ItemID)
    if ItemID == nil then
        return
    end

    local itemData = TableDataManager:GetInstance():GetTableData("Item",ItemID)
    if itemData then
        self.resource_box.gameObject:SetActive(false)
        self.other_box.gameObject:SetActive(true)

        local fun = function()
            OpenWindowImmediately("TipsPopUI", 
            {
                title = itemData.ItemName or '',
                content = itemData.ItemDesc or ''
            })
        end
        self.imgItem.sprite = GetSprite(itemData.Icon)
        self.imgItem:SetNativeSize()
        self:RemoveButtonClickListener(self.btnItem)
        self:AddButtonClickListener(self.btnItem, fun)
        self.objItem_Text.text = ItemDataManager:GetInstance():GetItemNumByTypeID(ItemID)
    end
end


function WindowBarUI:UpdateOtherBox()
    
end


return WindowBarUI