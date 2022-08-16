StoreUI = class("StoreUI",BaseWindow)
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'
local l_DRCSRef_Type = DRCSRef_Type
function StoreUI:ctor()
    self.ItemInfoUI = ItemInfoUI.new()
end

function StoreUI:Create()
	local obj = LoadPrefabAndInit("Game/StoreUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function StoreUI:Init()
    -- 值定义

    self.other_box = self:FindChild(self._gameObject, "other_box")
    self.other_box.gameObject:SetActive(false)

    self.objItem = self:FindChild(self.other_box, "item")
    self.btnItem = self:FindChildComponent(self.objItem, 'DRButton', 'DRButton')
    self.objItem_Text = self:FindChildComponent(self.objItem,"Text","Text")
    self.imgItem = self:FindChildComponent(self.objItem,"Image","Image")

    self.btnExit = self:FindChildComponent(self._gameObject, "frame/Btn_exit", "Button")
    if self.btnExit then
        self:AddButtonClickListener(self.btnExit, function()
            RemoveWindowImmediately("StoreUI",false)    --只remove的话，selectUI会认为我们处于对话界面，进行一些刷新界面的操作时会重新刷新出对话界面
            local win = GetUIWindow("SelectUI")         --所以去调用对话界面的exit，同时退出对话界面
            if win then
                win:Exit()
            end
        end)
    end

    self.shopPickList = {}     -- 当前选中的物品、数量，购买只有一个，卖出会有多个
    self.colorUnPick = DRCSRef.Color(0.3882353, 0.254902, 0.1098039)
    self.colorOnPick = COLOR_VALUE[COLOR_ENUM.White]
    self.colorNavBoxUnChoose = DRCSRef.Color(0.2,0.2,0.2,1)
    self.colorNavBoxOnChoose = COLOR_VALUE[COLOR_ENUM.White]
    self.colorPriceYes = COLOR_VALUE[COLOR_ENUM.White]
    self.colorPriceNo = COLOR_VALUE[COLOR_ENUM.Red]
    self.shop_status = 'buy'  -- 初始界面状态

    -- 查找组件
    self.objNavBox = self:FindChild(self._gameObject, 'BackpackUI/Pack/nav_box')
    self.objLoopScrollView = self:FindChild(self._gameObject, 'BackpackUI/Pack/LoopScrollView')
    self.comLoopScroll = self.objLoopScrollView:GetComponent('LoopVerticalScrollRect')
    self.comLoopScroll:AddListener(function(...) self:UpdateItemUI(...) end)
    self.objLoopScrollViewContent = self:FindChild(self.objLoopScrollView, "Content")
    
    self.objTipsBox = self:FindChild(self._gameObject, "tips_box")
    self.btnTipsBox = self:FindChildComponent(self.objTipsBox, "Button_question", "Button")
    self:AddButtonClickListener(self.btnTipsBox, function()
        self:ShowDiscountTips()
    end)
    self.objBatchChooseBox = self:FindChild(self._gameObject, "BatchChoose")
    self.btnBatchChooseBox = self.objBatchChooseBox:GetComponent("Button")
    self:AddButtonClickListener(self.btnBatchChooseBox, function()
        self:OpenBatchChoose()
    end)

    self.comBuy_Toggle = self:FindChildComponent(self._gameObject, "ShopWindowTabUI/TransformAdapt_node_right/Tab_box/Toggle_buy", "Toggle")
    if self.comBuy_Toggle then
        local fun = function(bool)
            if bool then
                if self.shop_status ~= 'buy' then
                    self:UnPickAllItem()
                    self.shop_status = 'buy'
                    self.bRefillScv = true
                    self:SetSortButtonVisible(true)
                    self:RefreshUI(self.businessid)
                end
            end
        end
        self:AddToggleClickListener(self.comBuy_Toggle, fun)
    end
    self.comSell_Toggle = self:FindChildComponent(self._gameObject,"ShopWindowTabUI/TransformAdapt_node_right/Tab_box/Toggle_sell","Toggle")
    if self.comSell_Toggle then
        local fun = function(bool)
            if bool then
                if self.shop_status ~= 'sell' then
                    self:UnPickAllItem()
                    self.shop_status = 'sell'
                    self.bRefillScv = true
                    self:SetSortButtonVisible(true)
                    self:RefreshUI(self.businessid)
                end
            end
        end
        self:AddToggleClickListener(self.comSell_Toggle, fun)
    end  

    -- 右侧面板
    self.detail_box = self:FindChild(self._gameObject, "detail_box")
    self.objDetailTitle = self:FindChild(self.detail_box, "Title")
    self.comItemTitle = self.objDetailTitle:GetComponent("Text")
    self.objDetailTips = self:FindChild(self.detail_box, "SC_tips")
    self.comRegularText = self:FindChildComponent(self.objDetailTips, "Viewport/Content/Regular", "Text")
    self.comContentText = self:FindChildComponent(self.objDetailTips, "Viewport/Content/Content", "Text")
    self.comCreatorText = self:FindChildComponent(self.objDetailTips, "Viewport/Content/Creator", "Text")
    self.objDetailHave = self:FindChild(self.detail_box, "have")
    self.comHaveTMPText = self:FindChildComponent(self.objDetailHave,"TMP_value","Text")
    self.button_box = self:FindChild(self.detail_box, "button_box")
    -- 按钮区域
    self.objTongbi = self:FindChild(self.button_box, "price/Icon_tongbi")
    self.objYinding = self:FindChild(self.button_box, "price/Icon_yinding")
    self.objOther = self:FindChild(self.button_box, "price/Icon_other")

    self.objOriPrice = self:FindChild(self.button_box,"price")
    self.comOriPriceText = self:FindChildComponent(self.objOriPrice,"Number","Text")

    self.comNumberText = self:FindChildComponent(self.button_box,"number/Image/Text","Text")
    self.comNumberBtn = self:FindChildComponent(self.button_box,"number/Image/Text","Button")
    self.comNumberInputField = self:FindChildComponent(self.button_box,"number/Image/InputField","InputField")
    local AddButtonClickListener = function(comBtn,func)
        self:AddButtonClickListener(comBtn,func)
    end
    local GetMaxNum = function()
        if self.shop_status == "buy" then
            return ShopDataManager:GetInstance():GetShopItemRemainNum(self.curItemID)
        elseif self.shop_status == 'buyDynamic' then
            return ShopDataManager:GetInstance():GetDynamicShopItemNum(self.businessid, self.curItemID)
        elseif self.shop_status == "sell" then
            return ItemDataManager:GetInstance():GetItemNum(self.curItemID)
        else
            derror("shop_status error")
            return 0
        end
    end
    local UpdateUI = function(curNumber,curRemainNum)
        self.curNumber = curNumber
        self.shopPickList[self.curItemID]['num'] = curNumber
        self.shopPickList[self.curItemID]['numRemain'] = curRemainNum
        -- 卖出界面需要更新商品节点数量
        if self.shop_status == "sell" then
            local node = self:GetNodeByID(self.curItemID)
            if node then
                if curRemainNum == 0 then
                    curRemainNum = ItemDataManager:GetInstance():GetItemNum(self.curItemID)
                end
                -- 卖出商品被取消选中的状态默认展示为选中全部
                if not self.shopPickList[self.curItemID] then
                    self.curNumber = curRemainNum
                end
                local comPrice = self:FindChildComponent(node, "Button/ItemIconUI/Num", "Text")
                comPrice.text = string.format("%d/%d", self.curNumber, curRemainNum)
            end
        end
        self:UpdateBuyBtnState()
    end
    BindInputFieldAndText(AddButtonClickListener,self.comNumberBtn,self.comNumberInputField,self.comNumberText,GetMaxNum,UpdateUI,false)

    self.comMinusButton = self:FindChildComponent(self.button_box,"number/Button_minus","Button")
    if self.comMinusButton then
        self:AddButtonClickListener(self.comMinusButton, function() 
            self:OperateNumSelector(-1)
        end) 
    end
    self.comAddButton = self:FindChildComponent(self.button_box,"number/Button_add","Button")
    if self.comAddButton then
        self:AddButtonClickListener(self.comAddButton, function()
            self:OperateNumSelector(1)
        end)
    end
    self.comAllButton = self:FindChildComponent(self.button_box,"number/Button_all","Button")
    if self.comAllButton then
        self:AddButtonClickListener(self.comAllButton, function() 
            self:OperateNumSelector(0)
        end)
    end
    self.objBuyButton = self:FindChild(self.button_box,"Button_buy")
    self.comImageBuyButton = self.objBuyButton:GetComponent("Image")
    self.comBuyButton = self.objBuyButton:GetComponent("Button")
    if self.comBuyButton then
        self:AddButtonClickListener(self.comBuyButton, function() self:OnClick_Buy_Button() end)
    end
    self.objBuyButtonText = self:FindChild(self.objBuyButton,"Text")
    self.comBuyButtonText = self.objBuyButtonText:GetComponent("Text")
    self.objBuyButtonCondText = self:FindChild(self.objBuyButton,"TextCond")
    self.comBuyButtonCondText = self.objBuyButtonCondText:GetComponent("Text")
    self.comBuyButtonPriceText = self:FindChildComponent(self.objBuyButton,"Number","Text")

    self.objImgTongbi = self:FindChild(self.objBuyButton, "Number/Image_tongbi")
    self.objImgOther = self:FindChild(self.objBuyButton, "Number/Image_other")

    self:InitStoreListener()

    self.kItemMgr = ItemDataManager:GetInstance()


    self.objSortNode =  self:FindChild(self._gameObject, 'BackpackUI/BackPackSortNode')
    self.objSortButton = self:FindChild(self._gameObject, 'SortButton')
    if self.objSortButton then
        self.sortToggle = self.objSortButton:GetComponent(l_DRCSRef_Type.Toggle)
        if self.sortToggle then
            self:AddToggleClickListener(self.sortToggle, function(bIsOn)
                self.objSortNode:SetActive(bIsOn)
            end)
        end
        self:InitSortNode()

        self.objRaycast = self:FindChild(self._gameObject, 'BackPackSortNode/BG_Click');
        AddEventTrigger(self.objRaycast, function()
            if self.sortToggle then
                self.sortToggle.isOn = not self.sortToggle.isOn
            end
        end)
        self.objSortButton:SetActive(true)
    end
    self:InitNavBox()  -- 初始化导航栏
end

-- 初始化商店监听
function StoreUI:InitStoreListener()
    -- 注册监听
    self:AddEventListener("UPDATE_STORE_DATA",function()
        if self.shop_status ~= 'sell' then
            self.bNeedRefreshUI = true
        end
    end)
    self:AddEventListener("UPDATE_ITEM_DATA",function()
        if self.shop_status == 'sell' then
            self.bNeedRefreshUI = true
        end
    end)
    self:AddEventListener("UPDATE_ITEM_LOCK_STATE",function(itemID)
        local isItemLock = ItemDataManager:GetInstance():GetItemLockState(itemID)
        self:UpdateItemLockState(itemID, isItemLock)
    end)
end

function StoreUI:Update()
    if self.bNeedRefreshUI then
        self:RefreshUI(self.businessid) 
        self.bNeedRefreshUI = false
    end
end


-- 移除商店监听
function StoreUI:RemoveStoreListener()
    self:RemoveEventListener("UPDATE_STORE_DATA")
    self:RemoveEventListener("UPDATE_ITEM_DATA")
end

-- 刷新商店ui界面
function StoreUI:RefreshUI(businessid)
    -- 传入 商店 businessid
local TB_Businessman = TableDataManager:GetInstance():GetTable("Businessman")
    if not (businessid and TB_Businessman) then
        return
    end
    if DEBUG_MODE then 
        SystemUICall:GetInstance():Toast('商店ID:' .. businessid)
    end
    -- 更新时锁定折扣,提升折扣计算效率
    ShopDataManager:GetInstance():SetLockShopItemDiscount(true)
    -- 初始化主角背包物品数量
    self:UpdateMainRoleItemNum()
    -- 商店相关
    self.businessid = businessid
    -- self.comLoopScroll.totalCount = 0
    self.auiItemIDList = {}
    local bReSelect = false
    local bussinessManData = TB_Businessman[businessid]
    if not bussinessManData then 
        derror('Cannot Find Store Data. Store:' .. tostring(businessid))
        RemoveWindowImmediately('StoreUI')
        return
    end
    -- 是否显示批量选中
    local bShowBatchChoose = true
    -- 是否显示tips按钮
    local bShowTipsBox = (bussinessManData.DiscountTips and bussinessManData.DiscountTips ~= "")
    -- 是否是特殊货币商店
    local bIsSpecialMonetStore = false

    self.UseMoneyID = nil
    if bussinessManData["UseMoney"] and bussinessManData["UseMoney"] > 0 then
        self.UseMoneyID = bussinessManData["UseMoney"]
        self.shop_status = 'buy'
        bIsSpecialMonetStore = true
    end

    -- 判断界面状态
    if (self.shop_status ~= 'sell') then 
        if bussinessManData["PlanID"] and (bussinessManData["PlanID"] ~= 0) then
            self.shop_status = 'buyDynamic'
        else
            self.shop_status = 'buy'
        end
        bShowBatchChoose = false
        -- bShowTipsBox = (not bIsSpecialMonetStore)  -- 特殊货币商店不显示tips
    end

    self.objBatchChooseBox:SetActive(bShowBatchChoose)
    self.objTipsBox:SetActive(bShowTipsBox)
    self.comSell_Toggle.gameObject:SetActive(not bIsSpecialMonetStore)
    self:RefreshGoldUI()

    -- 获取物品数据
    if self.shop_status == 'buy' then
        self.auiItemIDList = self:GenLegalShopItemList(businessid)
    elseif self.shop_status == 'buyDynamic' then
        self.auiItemIDList = self:GenLegalDynamicShopItemList()
    elseif self.shop_status == 'sell' then
        self.auiItemIDList = self:GenLegalToSellItemList()
    end

    local listLen = #self.auiItemIDList
    -- 如果商品列表发生改变, 所有有一个不能补货的物品被卖到断货了, 这时候要重新刷新选择项
    if listLen ~= self.curListLen then
        self.curListLen = listLen
        bReSelect = true
    end

    -- 当显示个数不足一页背包能显示的最大个数时, 用空白item填充满一页
    -- 显示个数不被行容量整除时, 用空白item填充到行容量的整数个
    local realCount = getTableSize(self.auiItemIDList)
    local maxCountOnePage, constraintCount = self:GetSCVMaxNodeNum()
    local showCount = realCount
    if realCount < maxCountOnePage then
        showCount = maxCountOnePage
    elseif (realCount % constraintCount) ~= 0 then
        showCount = realCount  + (constraintCount - realCount % constraintCount)
    end
    if self.bRefillScv ~= false then
        self.bRefillScv = false
        self.comLoopScroll.totalCount = showCount
        self.comLoopScroll:RefillCells()
    else
        if showCount > self.comLoopScroll.totalCount then
            self.comLoopScroll.totalCount = showCount
        end
        self.comLoopScroll:RefreshCells()
    end

    -- 若有之前选中的物品, 且bReSelect不为false, 则刷新界面后依然选中
    if (bReSelect ~= true) and next(self.shopPickList) then
        -- 前面的只需要选中, 取最后一个做显示信息
        local list = {}
        for id, data in pairs(self.shopPickList) do
            list[#list + 1] = id
        end
        for i = 1, #list - 1 do
            self:PickItem(list[i])
        end
        self:OnClick_Info(list[#list])
    -- 否则, 如果是买入界面, 且至少有一个可卖商品, 就默认选中第一个
    elseif (self.shop_status ~= 'sell') and (#self.auiItemIDList > 0) then
        self:UnPickAllItem()
        self:OnClick_Info(self.auiItemIDList[1])
    -- 否则, 清空显示
    else
        self:OnClick_Info()
    end
end

function StoreUI:InitSortNode()
    self.comRankToggles = {}
    for i = 1,7 do
        local iIndex = i
        local objRankToggle = self:FindChildComponent(self.objSortNode, "RankNode/RankToggle/"..i, l_DRCSRef_Type.Toggle)
        self:AddToggleClickListener(objRankToggle, function(bIsOn)
            self:OnClickSortToggle(self.comRankToggles,iIndex,bIsOn)
        end)
        self.comRankToggles[iIndex] = objRankToggle
    end
    local objAllRankToggle = self:FindChildComponent(self.objSortNode, "RankNode/All", l_DRCSRef_Type.Toggle)
    self.comRankToggles[0] = objAllRankToggle
    self:AddToggleClickListener(objAllRankToggle, function(bIsOn)
        self:OnClickSortToggle(self.comRankToggles,0,bIsOn)
    end)

    self.comTypeToggles = {}
    self.objTypeNode = self:FindChild(self.objSortNode,"TypeNode")
    local objAllTypeToggle = self:FindChildComponent(self.objSortNode, "TypeNode/All", l_DRCSRef_Type.Toggle)
    if objAllTypeToggle then
        self.comAllTypeToggle = objAllTypeToggle
        self.comTypeToggles[0] = objAllTypeToggle
        self:AddToggleClickListener(objAllTypeToggle, function(bIsOn)
            self:OnClickSortToggle(self.comTypeToggles,0,bIsOn)
        end)
    end

    self.objTypeToggleNode = self:FindChild(self.objSortNode,"TypeNode/TypeToggle")
    self.iColunmCount = 3
    local comGridLayoutGroup =  self.objTypeToggleNode:GetComponent("GridLayoutGroup")
    if comGridLayoutGroup then
        self.iColunmCount = comGridLayoutGroup.constraintCount
    end
    self.objSortToggleTemplate = self:FindChild(self.objSortNode, 'TypeNode/TemplateToggle')
    self.objSortToggleTemplate:SetActive(false)
    self.comSotrBGImage = self:FindChildComponent(self.objSortNode,"BG",l_DRCSRef_Type.RectTransform)
end

function StoreUI:OnClickSortToggle(comToggles,iIndex,bIsOn)
    if iIndex == 0 then
        if bIsOn then 
            for k,v in ipairs(comToggles) do
                comToggles[k].isOn = false
            end
            comToggles[0].interactable = false
        else
            comToggles[0].interactable = true
        end
    else
        if bIsOn and comToggles[0].isOn then
            comToggles[0].isOn = false
            comToggles[0].interactable = true
        end

        if not bIsOn then
            --其他筛选取消时 勾选全部
            local bChoose = 0
            for k,v in ipairs(comToggles) do
                if comToggles[k].isOn then
                    bChoose = bChoose + 1
                    break
                end
            end
            if bChoose == 0 then
                comToggles[0].isOn = true
                comToggles[0].interactable = false
            end
        end
    end
    self.bNeedRefreshUI = true
end

function StoreUI:SetSortButtonVisible(bShow)
    self.aiSortRankType = nil
    self.aiSortType = nil
    self.objSortButton:SetActive(bShow)
    if bShow then
        self:UpdateSortButton({})
    end
end

function StoreUI:CheckSrotRankAndType()
    if self.comAllTypeToggle == nil then
         return
    end
    if self.comRankToggles[0].isOn then
        --全部选
        self.aiSortRankType = nil
    else
        self.aiSortRankType = {} --筛选品质
        local specialRank = RankType.RT_DarkGolden
        for k ,v in ipairs(self.comRankToggles) do
            if v.isOn then
                self.aiSortRankType[k] = true
                if k == specialRank then --优秀暗金  精良暗金 都算暗金
                    self.aiSortRankType[RankType.RT_MultiColor] = true
                    self.aiSortRankType[RankType.RT_ThirdGearDarkGolden] = true
                end
            end
        end
    end

    if self.comTypeToggles[0].isOn then
        --全选
        self.aiSortType = nil
    else
        self.aiSortType = {} --筛选类型
        for k ,v in ipairs(self.comTypeToggles) do
            if v.isOn then
                self.aiSortType[self.sortEnumTypes[k]] = true
            end
        end
    end
end

function StoreUI:UpdateSortButton(itemTypeList)
    if not itemTypeList then
        return
    end
    -- 分流一次ItemType表, 获得所有分类的子类型
    if not self.eItemType2ChildType then
        self.eItemType2ChildType = ItemDataManager:GetInstance():SplitItemType()
    end

    if not self.eItemType2ChildType then
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,150)
        self.objTypeNode:SetActive(false)
        return
    end

    self.sortEnumTypes = {}
    local options = {}
    for index, fType in ipairs(itemTypeList) do
        local kSubItemTypes = self.eItemType2ChildType[fType]
        if kSubItemTypes and (#kSubItemTypes > 0) then
            for _, kCType in ipairs(kSubItemTypes) do
                if ItemTypeDetail.ItemType_Wing ~= kCType.EnumType then
                    self.sortEnumTypes[#self.sortEnumTypes + 1] = kCType.EnumType
                    options[#options+ 1] = kCType.SimpleName
                end
            end
        end
    end

    local transNode = self.objTypeToggleNode.transform
    for k ,v in ipairs(self.comTypeToggles) do
        local toggleClone = v:GetComponent(l_DRCSRef_Type.Toggle)
        self:RemoveToggleClickListener(toggleClone)
        self:ReturnObjToPool(v.gameObject)
    end

    self.comAllTypeToggle.isOn = true
    self.comTypeToggles =  {}
    self.comTypeToggles[0] = self.comAllTypeToggle
    for k,v in ipairs(options) do
        local objClone = self:LoadGameObjFromPool(self.objSortToggleTemplate, transNode)
        objClone:SetActive(true)
        local toggleClone = objClone:GetComponent(l_DRCSRef_Type.Toggle)
        toggleClone.isOn = false
        local textClone = objClone:FindChildComponent("Label",l_DRCSRef_Type.Text)
        textClone.text = options[k]
        self.comTypeToggles[k] = toggleClone
        local iIndex = k
        self:AddToggleClickListener(toggleClone, function(bIsOn)
            self:OnClickSortToggle(self.comTypeToggles,iIndex,bIsOn)
        end)
    end

    local iShowCount = #options
    local iColunmCount = self.iColunmCount
    if iShowCount > iColunmCount then
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,  STORE_SORT_BG_HEIGHT+280 + math.ceil((iShowCount - iColunmCount) / iColunmCount) * 56)  -- 50为单个高度
        self.objTypeNode:SetActive(true)
    elseif iShowCount > 0 then
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,STORE_SORT_BG_HEIGHT+280)
        self.objTypeNode:SetActive(true)
    else
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,STORE_SORT_BG_HEIGHT+175)
        self.objTypeNode:SetActive(false)
    end

    self.comRankToggles[0].isOn = true
end

-- 刷新商店所需货币
function StoreUI:RefreshGoldUI(businessid)
    if self.UseMoneyID and self.UseMoneyID  > 0 then
        self.objTongbi.gameObject:SetActive(false)
        self.objOther.gameObject:SetActive(true)
        self.objImgTongbi.gameObject:SetActive(false)
        self.objImgOther.gameObject:SetActive(true)

        local itemData = TableDataManager:GetInstance():GetTableData("Item",self.UseMoneyID)
        if itemData then
            local comIcon1 = self.objOther.transform:GetComponent("Image")
            local comIcon2 = self.objImgOther.transform:GetComponent("Image")
            -- 切换购买健
            comIcon1.sprite = GetSprite(itemData.Icon)
            comIcon2.sprite = GetSprite(itemData.Icon)
            comIcon1:SetNativeSize()
            comIcon2:SetNativeSize()
            -- 切换导航栏
            self:UpdateMoneyType(self.UseMoneyID)
        end
    else
        self.objTongbi.gameObject:SetActive(true)
        self.objOther.gameObject:SetActive(false)
        self.objImgTongbi.gameObject:SetActive(true)
        self.objImgOther.gameObject:SetActive(false)
    end
end

-- 获取当前滚动栏能显示的最大节点个数
function StoreUI:GetSCVMaxNodeNum()
    if not self.SCVMaxNodeNum then
        local objSCNode = self:FindChild(self._gameObject, "BackpackUI/Pack/LoopScrollView")
        local iSCHeight = objSCNode:GetComponent("RectTransform").rect.height or 0
        local comContentLayout = self:FindChildComponent(objSCNode, "Content", "GridLayoutGroup")
        local iCellHeight = comContentLayout.cellSize.y + comContentLayout.spacing.y
        local maxNum = math.ceil(iSCHeight / iCellHeight)
        self.SCVConstraintCount = comContentLayout.constraintCount
        self.SCVMaxNodeNum = maxNum * self.SCVConstraintCount
    end
    return (self.SCVMaxNodeNum or 0), (self.SCVConstraintCount or 0)
end

-- 初始化导航栏
function StoreUI:InitNavBox()
    local navBoxData = {
        [1] = {},
        [2] = {
            ItemTypeDetail.ItemType_Equipment,
            ItemTypeDetail.ItemType_HiddenWeapon,
            ItemTypeDetail.ItemType_Leechcraft,
        },
        [3] = {
            ItemTypeDetail.ItemType_Consume
        },
        [4] = {
            ItemTypeDetail.ItemType_Book
        },
        [5] = {
            ItemTypeDetail.ItemType_Material
        },
        [6] = {
            ItemTypeDetail.ItemType_Task
        },
    }
    self:CheckSrotRankAndType()
    local navBoxTrans = self.objNavBox.transform
    for index = 0, navBoxTrans.childCount - 1 do
        local objToggle = navBoxTrans:GetChild(index)
        local comToggle = objToggle:GetComponent('Toggle')
        local objImage = self:FindChild(objToggle.gameObject,"Image")
        local objText = objToggle:Find("Text")
        local comText = objText:GetComponent('Text')
        if comToggle and comText then
            local fun = function(bool)
                objImage:SetActive(not bool)
                if bool then
                    self.legalItemType = navBoxData[index + 1]
                    comText.color = self.colorNavBoxOnChoose
                    if self.businessid then
                        self:UnPickAllItem()
                        self.bRefillScv = true
                        self:RefreshUI(self.businessid)
                    end
                        self:UpdateSortButton(self.legalItemType)
                else
                    comText.color = self.colorNavBoxUnChoose
                end
            end
            self:AddToggleClickListener(comToggle, fun)
            if index == 0 then
                comToggle.isOn = true
            end
        end
    end
end

-- 验证物品是否属于当前导航分类
function StoreUI:IsItemBelongToLegalType(itemTypeID)
    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
    if not itemTypeData then 
        return false 
    end

    local itemType = itemTypeData.ItemType
    if self.aiSortRankType and next(self.aiSortRankType) and not self.aiSortRankType[itemTypeData.Rank] then
        return false
    end

    if self.aiSortType and next(self.aiSortType)  then
        if self.aiSortType[itemType] then
            return true
        end
    else
        local legalItemType = self.legalItemType
        if (not legalItemType) or (#legalItemType == 0) then 
            return true 
        end

        local itemMgr = ItemDataManager:GetInstance()
        for index, type in ipairs(legalItemType) do
            if itemMgr:IsTypeEqual(itemType, type) then
                return true
            end
        end
    end

    return false
end

-- 更新主角背包物品数量
function StoreUI:UpdateMainRoleItemNum()
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if not mainRoleData then return end
    local itemTypeID = nil
    local numMap = {}
    local itemMgr = ItemDataManager:GetInstance()
    for k,v in pairs(mainRoleData.auiRoleItem) do
        itemTypeID = itemMgr:GetItemTypeID(v)
        numMap[itemTypeID] = (numMap[itemTypeID] or 0) + (itemMgr:GetItemNum(v) or 0)
    end
    self.MainRoleItemNum = setmetatable(numMap, {
        __index = function(tab, key)
            return 0
        end
    })
end

-- 筛选符合条件的商品id列表
function StoreUI:GenLegalShopItemList(businessid)
    self:CheckSrotRankAndType()
    local list = {}
    local shopItemTypeID = nil
    local shopItemTypeData = nil
    local remainCount = 0
    local bIsReplenish = false
    local itemTypeData = nil
    local shopMgr = ShopDataManager:GetInstance()
    local itemIDCheck = {}
    self.shopItemUseCond = {}  -- 物品购买条件数据
    local condRes = true  -- 物品能否购买
    local condDesc = nil  -- 物品购买条件的描述
    local bNeedSort = true
    -- for int_i = 1, #TB_Shop do
    local TB_Shop = TableDataManager:GetInstance():GetTable("Shop")
    for uiTypeID, shopItemTypeData in pairs(TB_Shop) do
        -- shopItemTypeData = TB_Shop[int_i]
        if shopItemTypeData.BusinessManID == businessid then
            shopItemTypeID = shopItemTypeData.BaseID
            -- 如果商品余量为0并且拥有不补货属性, 或不属于当前导航分类则不显示
            remainCount = shopMgr:GetShopItemRemainNum(shopItemTypeID)
            bIsReplenish = shopMgr:IsReplenish(shopItemTypeID)
            local bIsLegalType = false
            itemTypeData = shopMgr:GetItemTypeDataByShopItemTypeID(shopItemTypeID)
            if itemTypeData then
                bIsLegalType = self:IsItemBelongToLegalType(itemTypeData.BaseID)
            end
            if (bIsLegalType == true) and ((bIsReplenish == true) or (remainCount > 0)) then
                local iSortId = shopItemTypeData.ItemSortID
                if iSortId == 0 then
                    bNeedSort = false
                end
                local tempData = {
                    ['baseID'] = shopItemTypeID,
                    ['sortID'] = iSortId,
                }
                table.insert(list, tempData)
                
                itemIDCheck[shopItemTypeID] = true
                -- 生成物品的使用条件数据
                condRes, condDesc = shopMgr:GenShopItemBuyCondition(shopItemTypeID)
                -- 余量不足, 也不能购买
                if remainCount <= 0 then
                    condRes = false
                    if bIsReplenish then
                        condDesc = "补货中"
                    end
                end
                self.shopItemUseCond[shopItemTypeID] = {
                    ['canBuy'] = condRes,
                    ['desc'] = condDesc,
                }
            end
        end
    end
    -- 原先在选中列表里, 但是现在不在合法物品列表里的, 要移除该数据
    for id, data in pairs(self.shopPickList) do
        if itemIDCheck[id] ~= true then
            self:UnPickItem(id)
        end
    end

    if bNeedSort then
        table.sort(list, function(a,b)
            if (a ~= nil and b ~= nil) then
                return (a.sortID < b.sortID)
            end
        end)
    end
    local finalList = {}
    for index, data in ipairs(list) do
        table.insert(finalList, data.baseID)
    end
    return finalList
end

-- 筛选合法的卖出物品
function StoreUI:GenLegalToSellItemList()
    self:CheckSrotRankAndType()
    local list = {}
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if not mainRoleData then return list end
    local itemTypeData = nil
    local itemMgr = ItemDataManager:GetInstance()
    local itemIDCheck = {}
    for k,v in pairs(mainRoleData.auiRoleItem) do
        local bIsLegalType = false
        itemTypeData = itemMgr:GetItemTypeData(v)
        if itemTypeData then
            bIsLegalType = self:IsItemBelongToLegalType(itemTypeData.BaseID)
        end
        if bIsLegalType == true then
            table.insert(list, v)
            itemIDCheck[v] = true
        end
    end
    -- 原先在选中列表里, 但是现在不在合法物品列表里的, 要移除该数据
    for id, data in pairs(self.shopPickList) do
        if itemIDCheck[id] ~= true then
            self:UnPickItem(id)
        end
    end
    -- 排序
    local kTableMgr = TableDataManager:GetInstance()
    table.sort(list, function(a, b)
        local kInstA = self.kItemMgr:GetItemDataInItemPool(a) or {}
        local kInstB = self.kItemMgr:GetItemDataInItemPool(b) or {}
        local kBaseA = kTableMgr:GetTableData("Item", kInstA.uiTypeID or 0) or {}
        local kBaseB = kTableMgr:GetTableData("Item", kInstB.uiTypeID or 0) or {}
        local eRankA = kBaseA.Rank or 0
        local eRankB = kBaseB.Rank or 0
        if eRankA == eRankB then
            local uiLvA = kInstA.uiEnhanceGrade or 0
            local uiLvB = kInstB.uiEnhanceGrade or 0
            if uiLvA == uiLvB then
                return (a or 0) > (b or 0)
            else
                return uiLvA > uiLvB
            end
        else
            return eRankA > eRankB
        end
    end)
    -- 显示第一个物品的信息
    if list and (#list > 0) then
        self.curItemID = self:GetFirstCanSellItemId(list)
        self:RefreshTips()
        self:RefreshNums()
    end
    return list
end

function StoreUI:GetFirstCanSellItemId(list)
    if not list then 
        derror("list is nil")
        return 0
    end
    for i = 1,#list do
        if not self.kItemMgr:ItemHasLockFeature(list[i]) then
            return list[i]
        end
    end
    return 0
end

-- 筛选合法的动态商品
function StoreUI:GenLegalDynamicShopItemList()
    local list = {}
    local itemTypeData = nil
    local itemMgr = ItemDataManager:GetInstance()
    local itemIDCheck = {}
    local shopList = ShopDataManager:GetInstance():GetDynamicShopItems(self.businessid)
    for index, data in ipairs(shopList) do
        local bIsLegalType = false
        itemTypeData = itemMgr:GetItemTypeData(data.uid)
        if itemTypeData then
            bIsLegalType = self:IsItemBelongToLegalType(itemTypeData.BaseID)
        end
        if bIsLegalType == true then
            table.insert(list, data.uid)
            itemIDCheck[data.uid] = true
        end
    end
    -- 原先在选中列表里, 但是现在不在合法物品列表里的, 要移除该数据
    for id, data in pairs(self.shopPickList) do
        if itemIDCheck[id] ~= true then
            self:UnPickItem(id)
        end
    end
    return list
end

-- 通过物品id获取ui节点
function StoreUI:GetNodeByID(itemID)
    if not self.objLoopScrollViewContent then
        return
    end
    local node =  DRCSRef.CommonFunction.StoreUI_GetNodeByID(self.objLoopScrollViewContent.transform,"itemID",itemID)
    return node
end

function StoreUI:UpdateItemUI(transform, index)
    local startTime = os.clock()
    if not transform then return end
    local itemNode = transform.gameObject
    index = index + 1   -- 起始为 0
    if not (self.auiItemIDList and self.auiItemIDList[index]) then 
        -- 将商品节点初始化为空白格
        self.ItemInfoUI:SetItemUIActiveState(itemNode, false)
        return
    end
    -- 初始化 选中/锁定 状态
    local bIsPicked = false
    local bIsLocked = false
    local key = nil  -- 商品或物品的id
    local objPrice = self:FindChild(itemNode, "Price")
    local comTextPrice = self:FindChildComponent(objPrice, "Text", "Text")
    local objCategory = self:FindChild(itemNode, 'Category')
    local shopMgr = ShopDataManager:GetInstance()
    local itemMgr = ItemDataManager:GetInstance()
    if self.shop_status == 'buy' then
        local shopItemTypeID = self.auiItemIDList[index]
        key = shopItemTypeID
        -- 抽取出物品静态数据
        local itemTypeData = shopMgr:GetItemTypeDataByShopItemTypeID(shopItemTypeID)
        -- 物品数量
        local iItemNum = shopMgr:GetShopItemRemainNum(shopItemTypeID)
        local strItemNum = iItemNum
        if iItemNum == 0 then
            strItemNum = shopMgr:IsReplenish(shopItemTypeID) and "补货中" or ""
        end
        -- 物品价格
        local buyPrice = shopMgr:GetShopItemPrice(shopItemTypeID)
        -- 设置ui
        self.ItemInfoUI:UpdateUIWithItemTypeData(itemNode, itemTypeData)
        self.ItemInfoUI:SetItemNum(itemNode, strItemNum)
        local strIcon = nil
        if  self.UseMoneyID then
            local itemData = TableDataManager:GetInstance():GetTableData("Item",self.UseMoneyID)
            if itemData then
                strIcon = itemData.Icon
            end
        end

        self.ItemInfoUI:SetItemPrice(itemNode, buyPrice,strIcon)
        -- 如果不满足购买条件, 节点变灰
        self.shopItemUseCond = self.shopItemUseCond or {}
        local useCondData = self.shopItemUseCond[shopItemTypeID] or {}
        -- 加载material
        if not self.grayMat then
            self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
        end
        -- 设置节点状态
        local strState = nil
        local bActive = true
        if useCondData.canBuy == false then
            strState = "gray"
            bActive = false
        end
        self.ItemInfoUI:SetIconState(itemNode, strState)
        -- 如果物品不能使用且存在条件限制(有条件描述), 则显示锁定
        if (not bActive) and (useCondData.desc ~= nil) then
            bIsLocked = true
        end
    elseif self.shop_status == 'buyDynamic' then
        local itemUID = self.auiItemIDList[index]
        key = itemUID
        local itemData = itemMgr:GetItemData(itemUID)
        self.ItemInfoUI:UpdateUIWithItemInstData(itemNode, itemData)
        objCategory:SetActive(false)
        objPrice:SetActive(true)
        self.ItemInfoUI:SetItemPrice(itemNode,shopMgr:GetDynamicShopItemPrice(self.businessid, itemUID))

    elseif self.shop_status == 'sell' then
        local itemUID = self.auiItemIDList[index]
        key = itemUID
        local itemData = itemMgr:GetItemData(itemUID)
        self.ItemInfoUI:UpdateUIWithItemInstData(itemNode, itemData)
        objCategory:SetActive(false)
        objPrice:SetActive(true)
        self:FindChild(objPrice, "ImageYingDing"):SetActive(false)
        self:FindChild(objPrice, "ImageTongBi"):SetActive(true)
        comTextPrice.text = shopMgr:GetShopItemSellPrice(itemUID);
        local curRemainNum = ItemDataManager:GetInstance():GetItemNum(itemUID)
        local comTextNum = self:FindChildComponent(itemNode, "Button/ItemIconUI/Num", "Text")
        comTextNum.text = string.format("%d/%d", curRemainNum, curRemainNum)
        bIsLocked = ItemDataManager:GetInstance():GetItemLockState(itemUID)
    end
    -- 还原 选中/锁定 状态
    self.ItemInfoUI:UpdateLockState(itemNode, bIsLocked)
    bIsPicked = key and self.shopPickList[key] ~= nil
    self:SetNodeState(itemNode, bIsPicked)
    -- 注册点击监听
    self.ItemInfoUI:AddClickFunc(itemNode, function() 
        self:OnClick_Info(key) 
    end, function() 
        self:OnClick_Icon(key) 
    end)
end

function StoreUI:OnClick_Icon(itemID)
    if self.shop_status == 'sell' then
        if not itemID then return end
        local tips = TipsDataManager:GetItemTips(itemID)
        local btns = {}
        -- 带有锁定特性的物品不显示任何按钮
        if not ItemDataManager:GetInstance():ItemHasLockFeature(itemID) then
            local btnName = nil
            local btnFunc = nil
            if ItemDataManager:GetInstance():GetItemLockState(itemID) then
                btnName = "解锁"
                btnFunc = function()
                    ItemDataManager:GetInstance():SetItemLockState(itemID, false)
                end
            else
                btnName = "锁定"
                btnFunc = function()
                    ItemDataManager:GetInstance():SetItemLockState(itemID, true)
                end

                local strChooseBtn = "选中"
                if self.shopPickList[itemID] then
                    strChooseBtn = "取消"
                end
                btns[#btns + 1] = {
                    ['name'] = strChooseBtn,
                    ['func'] = function()
                        self:OnClick_Info(itemID)
                    end,
                }
            end
            btns[#btns + 1] = {
                ['name'] = btnName,
                ['func'] = btnFunc
            }
        end
        tips.buttons = btns
        OpenWindowImmediately("TipsPopUI", tips)
    else
        self:OnClick_Info(itemID)
    end
end

-- 更新一个物品的锁定状态 (node不是必须的, 但是如果有node传入可以立即设置节点状态为锁定)
function StoreUI:UpdateItemLockState(itemID, bLock)
    if not itemID then 
        return 
    end
    bLock = bLock == true
    local bHasLockFrature = ItemDataManager:GetInstance():ItemHasLockFeature(itemID)
    local node = self:GetNodeByID(itemID)
    -- 如果当前物品在选中时被锁定, 取消当前物品的选中
    if bLock then
        if node then
            self.ItemInfoUI:UpdateLockState(node, bLock)
            ItemDataManager:GetInstance():SetItemLockState(itemID, bLock)
        end
        if self.shopPickList[itemID] then
            self:UnPickItem(itemID)
            self:UpdateBuyBtnState()
        end
    -- 带有锁定特性的物品不允许解锁
    elseif bHasLockFrature ~= true then
        if node then
            self.ItemInfoUI:UpdateLockState(node, bLock)
            ItemDataManager:GetInstance():SetItemLockState(itemID, bLock)
        end
    end
end

-- 设置一个物品ui节点的状态
function StoreUI:SetNodeState(node, bIsChoose)
    if not node then return end
    bIsChoose = bIsChoose == true
    self:FindChild(node,'Toggle_Frame'):SetActive(bIsChoose)
    self:FindChild(node,'Button/Toggle_BG'):SetActive(bIsChoose)
    self:FindChildComponent(node,'Price/Text','Text').color = bIsChoose and self.colorOnPick or self.colorUnPick
end

-- 选中一个节点
function StoreUI:PickItem(id)
    if not id then return end
    -- 在卖出界面, 如果一个物品被锁定, 则不能被选中
    if (self.shop_status == 'sell')
    and ItemDataManager:GetInstance():GetItemLockState(id) then
        return
    end
    -- 如果是静态商店界面, 将商品id解析为物品id
    local key2FindNode = id
    if self.shop_status == 'buy' then
        local itemTypeData = ShopDataManager:GetInstance():GetItemTypeDataByShopItemTypeID(id)
        key2FindNode = itemTypeData.BaseID
    end
    -- 选中ui节点
    local node = self:GetNodeByID(key2FindNode)
    if node then
        self:SetNodeState(node, true)
    end
    -- 买入界面默认选中一个, 卖出界面默认选中全部
    local selectNum = 1
    if self.shop_status == "sell" then
        selectNum = ItemDataManager:GetInstance():GetItemNum(id)
    end
    if id then
        self.shopPickList[id] = {
            ['num'] = selectNum,
            ['numRemain'] = 0
        }
    end
end

-- 取消选中一个节点
function StoreUI:UnPickItem(id)
    if not id then return end
    -- 如果是静态商店界面, 将商品id解析为物品id
    local key2FindNode = id
    -- 如果是静态商店界面, 将商品id解析为物品id
    if self.shop_status == 'buy' then
        local itemTypeData = ShopDataManager:GetInstance():GetItemTypeDataByShopItemTypeID(id)
        key2FindNode = itemTypeData.BaseID
    end
    local node = self:GetNodeByID(key2FindNode)
    if node then
        self:SetNodeState(node, false)
    end
    self.shopPickList[id] = nil
end

-- 取消选中所有节点
function StoreUI:UnPickAllItem()
    self.shopPickList = self.shopPickList or {}
    for id, data in pairs(self.shopPickList) do
        self:UnPickItem(id)
    end
    self.shopPickList = {}
    self.curItemID = nil
end

-- 批量选中回调
function StoreUI:OnBatchChooseOver(res, eBatchType)
    if not (res and self.auiItemIDList) then return end
    -- 先取消选中所有物品
    self:UnPickAllItem()
    if not next(res) then return end
    -- 批量选中只会在卖出界面被调用, 所以物品列表里是物品动态id
    local itemTypeData = nil
    local enumItemType = nil
    local bIsTreasure = false
    local rank = nil
    local itemMgr = ItemDataManager:GetInstance()
    local list = {}
    for index, itemID in ipairs(self.auiItemIDList) do
        itemTypeData = itemMgr:GetItemTypeData(itemID)
        if itemTypeData then
            rank = itemTypeData.Rank
            enumItemType = itemTypeData.ItemType
            -- 暗器. 医药, 算作装备
            if (enumItemType == ItemTypeDetail.ItemType_HiddenWeapon)
            or (enumItemType == ItemTypeDetail.ItemType_Leechcraft) then
                enumItemType = ItemTypeDetail.ItemType_Equipment
            end
            -- -- 传家宝不会被多选选中
            -- bIsTreasure = false
            -- if (itemTypeData.PersonalTreasure ~= 0 )
            -- or (itemTypeData.ClanTreasure ~= 0)
            -- or (itemTypeData.NoneTreasure == TBoolean.BOOL_YES) then
            --     bIsTreasure = true
            -- end
            if res[enumItemType] and (res[enumItemType][rank] == true) then
                list[#list + 1] = itemID
            end
        end
    end
    for i = 1, #list do
        if eBatchType == BATCH_CHOOSE_TYPE.CHOOSE then
            if not ItemDataManager:GetInstance():GetItemLockState(list[i]) then
                self:PickItem(list[i])
            end
        elseif eBatchType == BATCH_CHOOSE_TYPE.LOCK then
            self:UpdateItemLockState(list[i], true)
        elseif eBatchType == BATCH_CHOOSE_TYPE.UNLOCK then
            self:UpdateItemLockState(list[i], false)
        end
    end
    self.curItemID = list[#list] 
    self.objDetailTitle:SetActive(self.curItemID)
    self.objDetailTips:SetActive(self.curItemID)
    self.objDetailHave:SetActive(self.curItemID)
    if self.curItemID then
        self:RefreshTips()
        self:RefreshNums()
    end 
end

-- 选中物品节点
function StoreUI:OnClick_Info(itemID)
    local bShowItwmInfo = (itemID ~= nil) and (itemID > 0)
    self.objDetailTitle:SetActive(bShowItwmInfo)
    self.objDetailTips:SetActive(bShowItwmInfo)
    self.objDetailHave:SetActive(bShowItwmInfo)
    if bShowItwmInfo then
        -- 买入界面, 选中新的物品前要取消选中其它物品
        if (self.shop_status == 'buy') or (self.shop_status == 'buyDynamic') then
            -- 重复点击同一个商品不用管
            if self.curItemID ~= itemID then
                if self.shopPickList[self.curItemID] then
                    -- 把之前选中的取消
                    self:UnPickItem(self.curItemID)
                end
                -- 设置当前选中
                self.curItemID = itemID
                self:PickItem(itemID)
            end
        -- 卖出界面, 选中新物品可以多选, 但是选中已选中的物品要取消该物品的选则
        elseif self.shop_status == 'sell' then
            if self.shopPickList[itemID] then
                self:UnPickItem(itemID)
            else
                self:PickItem(itemID)
            end
            self.curItemID = itemID
        end
    else
        self.comBuyButtonText.text = "待选择"
    end
    self:RefreshTips()
    self:RefreshNums()
end

-- 刷新物品的名称（品质）、类别、描述，这些都是 Tips 后续要自己维护数据
function StoreUI:RefreshTips()
    local itemTypeData = nil
    local itemTypeID = nil
    local itemID = nil
    if self.shop_status == 'buy' then
        local baseID = self.curItemID
        if baseID then
            itemTypeData = ShopDataManager:GetInstance():GetItemTypeDataByShopItemTypeID(baseID)
        end
    elseif (self.shop_status == 'buyDynamic') or (self.shop_status == 'sell') then
        local itemUID = self.curItemID
        itemID = itemUID
        if itemUID then
            itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemUID)
        end
    end
    if not itemTypeData then return end
    itemTypeID = itemTypeData.BaseID
    local tips = TipsDataManager:GetInstance():GetItemTips(itemID, itemTypeID)
    local itemName = tips.title
    self.comItemTitle.text = tostring(itemName)
    if DEBUG_MODE then
        self.comItemTitle.text = self.comItemTitle.text .. '(' .. tostring(self.curItemID) .. ')'
    end
    self.comItemTitle.color = getRankColor(itemTypeData.Rank)
    self.comRegularText.gameObject:SetActive(false) -- 固定内容不知道干啥的先隐藏
    self.comContentText.text = tips.content
    self.comCreatorText.gameObject:SetActive(false) -- TODO: Creator
    self.comNumberText.gameObject:SetActive(true)
    self.comNumberInputField.gameObject:SetActive(false)

end

function StoreUI:RefreshNums()
    local shopMgr = ShopDataManager:GetInstance()
    local id = self.curItemID
    local iHave = 0
    local itemTypeID = nil
    if self.shop_status == 'buy' then
        local itemTypeData = nil
        if id then
            itemTypeData = shopMgr:GetItemTypeDataByShopItemTypeID(id)
        end
        if itemTypeData then 
            itemTypeID = itemTypeData.BaseID
            iHave = self.MainRoleItemNum[itemTypeID]
        end
        -- 原价只有在普通商店界面并且物品有折扣价的时候才显示
        local curPrice, oriPrice, isDiscount = shopMgr:GetShopItemPrice(id)
        self.comOriPriceText.text = oriPrice or 0
        self.objOriPrice:SetActive(isDiscount == true)
    elseif (self.shop_status == 'buyDynamic') or (self.shop_status == 'sell') then
        self.objOriPrice:SetActive(false)
        itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(id)
        if itemTypeID and (itemTypeID > 0) then
            iHave = self.MainRoleItemNum[itemTypeID]
        end
    end
    self.comHaveTMPText.text = string.format("拥有: %d", iHave or 0)
    self:OperateNumSelector()
end

-- 操作数量选择器
function StoreUI:OperateNumSelector(value)
    --输入状态
    if self.comNumberInputField.gameObject.activeSelf then
        local curRemainNum = 0
        if self.shop_status == "buy" then
            curRemainNum = ShopDataManager:GetInstance():GetShopItemRemainNum(self.curItemID)
        elseif self.shop_status == 'buyDynamic' then
            curRemainNum = ShopDataManager:GetInstance():GetDynamicShopItemNum(self.businessid, self.curItemID)
        elseif self.shop_status == "sell" then
            curRemainNum = ItemDataManager:GetInstance():GetItemNum(self.curItemID)
        end
        
        if not self.curNumber then
            self.curNumber = self.shopPickList[self.curItemID].num or 1
        end
        -- 正数: 增加, 负数: 减少, 零: 全部
        self.curNumber = self.curNumber + value
        if value == 0 then
            self.curNumber = curRemainNum 
        end
        if self.curNumber < 1 then
            self.curNumber = 1
        end
        if self.curNumber >= curRemainNum then
            self.curNumber = curRemainNum 
        end
        self.comNumberInputField.text = tostring(self.curNumber)
        -- 卖出界面需要更新商品节点数量
        if self.shop_status == "sell" then
            local node = self:GetNodeByID(self.curItemID)
            if node then
                if curRemainNum == 0 then
                    curRemainNum = ItemDataManager:GetInstance():GetItemNum(self.curItemID)
                end
                -- 卖出商品被取消选中的状态默认展示为选中全部
                if not self.shopPickList[self.curItemID] then
                    self.curNumber = curRemainNum
                end
                local comPrice = self:FindChildComponent(node, "Button/ItemIconUI/Num", "Text")
                comPrice.text = string.format("%d/%d", self.curNumber, curRemainNum)
            end
        end
        self.shopPickList[self.curItemID]['num'] = self.curNumber
        self.shopPickList[self.curItemID]['numRemain'] = curRemainNum
        self:UpdateBuyBtnState() 
    else
        -- 正数: 增加, 负数: 减少, 零: 全部
        local curNum = 0
        local curRemainNum = 0
        local key = self.curItemID
        if key and self.shopPickList[key] then
            local pickedNode = self.shopPickList[key]
            local oriNum = pickedNode.num or 1
            curRemainNum = 0
            if self.shop_status == "buy" then
                curRemainNum = ShopDataManager:GetInstance():GetShopItemRemainNum(key)
            elseif self.shop_status == 'buyDynamic' then
                curRemainNum = ShopDataManager:GetInstance():GetDynamicShopItemNum(self.businessid, key)
            elseif self.shop_status == "sell" then
                curRemainNum = ItemDataManager:GetInstance():GetItemNum(key)
            end
            --买光的时候 不允许再减了
            if curRemainNum == 0  then
                if not value or (value and value <= 0) then
                    self.comNumberText.text =  "0/0"
                    self:UpdateBuyBtnState()
                    return
                end
            end

            if not value then
                curNum = oriNum
            elseif value == 0 then
                curNum = curRemainNum
            else
                curNum = oriNum + value
            end
            if curNum > curRemainNum then
                curNum = curRemainNum
            elseif curNum <= 0 then
                curNum = 1
            end
            self.shopPickList[key]['num'] = curNum
            self.shopPickList[key]['numRemain'] = curRemainNum
        end

        -- 卖出界面需要更新商品节点数量
        if self.shop_status == "sell" then
            local node = self:GetNodeByID(key)
            if node then
                if curRemainNum == 0 then
                    curRemainNum = ItemDataManager:GetInstance():GetItemNum(key)
                end
                -- 卖出商品被取消选中的状态默认展示为选中全部
                if not self.shopPickList[key] then
                    curNum = curRemainNum
                end
                local comPrice = self:FindChildComponent(node, "Button/ItemIconUI/Num", "Text")
                comPrice.text = string.format("%d/%d", curNum, curRemainNum)
            end
        end

        self.comNumberText.text = string.format("%d/%d", curNum, curRemainNum)
        self:UpdateBuyBtnState()
    end
end

-- 获取当前已选商品的总价
function StoreUI:GetSumPrice()
    local baseID = self.curItemID
    if not baseID then return 0, 0, false end
    -- 遍历已选列表, 分析总价
    local singlePrice = 0
    local sumPrice = 0
    local remainCount = 0
    local num = 0
    local itemTypeData = nil
    local shopMgr = ShopDataManager:GetInstance()
    local itemMgr = ItemDataManager:GetInstance()
    for id, data in pairs(self.shopPickList) do
        num = data.num or 1
        remainCount = remainCount + data.numRemain or 0
        if self.shop_status == "buy" then
            singlePrice = shopMgr:GetShopItemPrice(id) or 0
        elseif self.shop_status == 'buyDynamic' then
            singlePrice = shopMgr:GetDynamicShopItemPrice(self.businessid, id)
        elseif self.shop_status == "sell" then
            singlePrice = shopMgr:GetShopItemSellPrice(id)
        end
        sumPrice = sumPrice + singlePrice * num
    end
    local bActive = true
    -- 买入界面, 余额不足则买入按钮不生效
    if (self.shop_status == "buy") or (self.shop_status == 'buyDynamic') then
        -- 如果是兑换商店
        if self.UseMoneyID and self.UseMoneyID > 0 then
           local CurNum = ItemDataManager:GetInstance():GetItemNumByTypeID(self.UseMoneyID)
           bActive = CurNum >= sumPrice
        else
              -- 与用户余额作比较
            local plyerCoin = PlayerSetDataManager:GetInstance():GetPlayerCoin() or 0
            bActive = plyerCoin >= sumPrice
        end
    -- 卖出界面, 没有卖出总价则卖出按钮不生效
    elseif self.shop_status == "sell" then
        bActive = sumPrice ~= 0
    end
    return sumPrice, remainCount, bActive
end

-- 更新按钮状态
function StoreUI:UpdateBuyBtnState()
   
    -- 初始状态
    self.comBuyButton.interactable = true
    self.objBuyButtonText:SetActive(false)
    self.objBuyButtonCondText:SetActive(false)
    local objNumber = self:FindChild(self.objBuyButton, "Number")
    local objBackImg = self:FindChild(self.objBuyButton, "back")
    objNumber:SetActive(true)
    objBackImg:SetActive(true)
    self.comBuyButtonPriceText.color = self.colorPriceYes
    -- 按钮设置
    if (self.shop_status == "buy") or (self.shop_status == 'buyDynamic') then
        -- 先判断商品购买条件是否满足
        local shopItemTypeID = self.curItemID
        local sumPrice, remainCount, bIsEnough = self:GetSumPrice()
        self.comBuyButtonPriceText.text = sumPrice or 0
        local condRes = true
        local condData = nil
        -- 普通商店物品的购买条件
        if self.shop_status == "buy" then
            self.shopItemUseCond = self.shopItemUseCond or {}
            condData = self.shopItemUseCond[shopItemTypeID] or {}
            condRes = (condData.canBuy ~= false)
        end

        if (condRes ~= true) and condData and (condData.desc ~= nil) then
            objNumber:SetActive(false)
            objBackImg:SetActive(false)
            self.objBuyButtonCondText:SetActive(true)
            self.comBuyButtonCondText.text = condData.desc
            self.comBuyButton.interactable = false
        else
            self.objBuyButtonText:SetActive(true)
            self.comBuyButtonText.text = "购买"
            -- 如果余量为0或余额不足, 不允许购买
            -- (这里不使用condData.canBuy, 因为self.shopItemUseCond只在普通商店生成购买条件数据, 但是动态商店也会走这里的逻辑)
            if (remainCount == 0) or (bIsEnough ~= true) then
                self.comBuyButton.interactable = false
                self.comBuyButtonPriceText.color = self.colorPriceNo
            end
        end

        -- 当玩家铜币不足时，购买按钮也不会变灰，而是等待玩家点击，


    elseif self.shop_status == "sell" then
        self.objBuyButtonText:SetActive(true)
        self.comBuyButtonText.text = "出售"
        local sumPrice, remainCount, bIsActive = self:GetSumPrice()
        self.comBuyButtonPriceText.text = sumPrice or 0
        if bIsActive ~= true then
            self.comBuyButton.interactable = false
        end
    end
    -- 加载material
    if not self.grayMat then
        self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
    end
    if self.comBuyButton.interactable then
        self.comImageBuyButton.material = nil
    else
        self.comImageBuyButton.material = self.grayMat
    end
end

function StoreUI:OnClick_Buy_Button()
    if not self.shopPickList then 
        return 
    end
    local selectInfo = RoleDataManager:GetInstance():GetSelectInfo()
    if not selectInfo then 
        selectInfo = {
            roleID = 0,
            mapID = 0,
            mazeTypeID = 0
        }
    end
    -- 交互角色ID
    local interactRoleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(selectInfo.roleID or 0)
    local sumPrice, remainCount, bActive = self:GetSumPrice()
    if (self.shop_status == "buy") then
        if bActive == true then
            local iCount = 0
            local akItemList = {}
            for id, data in pairs(self.shopPickList) do
                dprint("[购买商品]->商品BaseID：" .. id .. " 数量：" .. (data.num or 1))
                akItemList[iCount] = {
                    ['uiItemID'] = id,
                    ['uiItemNum'] = data.num or 1,
                }
                iCount = iCount + 1
            end

            SendClickShop(CST_BUY, self.businessid, iCount, akItemList, selectInfo.mapID, selectInfo.mazeTypeID, interactRoleBaseID)
        else
            OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.SYSTEM_TIP, '铜钱不足' })
        end
    elseif self.shop_status == 'buyDynamic' then
        if bActive == true then
            local iCount = 0
            local akItemList = {}
            for id, data in pairs(self.shopPickList) do
                dprint("[购买商品]->商品BaseID：" .. id .. " 数量：" .. (data.num or 1))
                akItemList[iCount] = {
                    ['uiItemID'] = id,
                    ['uiItemNum'] = data.num or 1,
                }
                iCount = iCount + 1
            end

            SendClickShop(CST_BUY, self.businessid, iCount, akItemList, selectInfo.mapID, selectInfo.mazeTypeID, interactRoleBaseID)
        else
            local strTitle = "铜币不足"
            local strWarning = '本商品价格'..sumPrice..'铜币,铜币数量不足,是否使用'..math.ceil(sumPrice / 100).. '银锭代替铜币购买'
            local iPaySilverNum = math.ceil(sumPrice / 100)
            local strPayFor = "购买"
            local callback = function()
                local iCount = 0
                local akItemList = {}
                for id, data in pairs(self.shopPickList) do
                    dprint("[购买商品]->商品BaseID：" .. id .. " 数量：" .. (data.num or 1))
                    akItemList[iCount] = {
                        ['uiItemID'] = id,
                        ['uiItemNum'] = data.num or 1,
                    }
                    iCount = iCount + 1
                end

                SendClickShop(CST_BUY, self.businessid, iCount, akItemList, selectInfo.mapID, selectInfo.mazeTypeID, interactRoleBaseID)
            end

            self:WarningBox(strTitle, string.format(strWarning, sumPrice, iPaySilverNum), iPaySilverNum, strPayFor, callback)
        end
    elseif self.shop_status == "sell" then
        if bActive == true then
            boxCallback = function()
                local akItemList = {}
                local iListCount = 1
                for id, data in pairs(self.shopPickList) do
                    -- dprint("[卖出物品]->物品UID：" .. id .. " 数量：" .. (data.num or 1))
                    if not akItemList[iListCount] then
                        akItemList[iListCount] = {}
                    elseif #akItemList[iListCount] >= SSD_MAX_ROLE_ITEM_NUMS then
                        iListCount = iListCount + 1
                        akItemList[iListCount] = {}
                    end
                    akItemList[iListCount][#akItemList[iListCount] + 1] = {
                        ['uiItemID'] = id,
                        ['uiItemNum'] = data.num or 1,
                    }
                end
                -- 分批发送
                for index, list in ipairs(akItemList) do
                    local iCount = #list
                    list[0] = list[iCount]
                    list[iCount] = nil
                    SendClickShop(CST_SELL, self.businessid, iCount, list, selectInfo.mapID, selectInfo.mazeTypeID, interactRoleBaseID)
                end
                self.shopPickList = {}
                -- self.comLoopScroll:RefillCells()
            end

            local removeItemCallback = function(itemID,num)
                self:UnPickItem(itemID)
                self:RefreshTips()
                self:RefreshNums()
            end
            local getNewWindowTips = function()
                local strTips = "以下物品将被贩卖并转换为"..self:GetSumPrice().."铜币，是否确定？"
                return strTips
            end

            local itemList = {}
            local itemNumList = {}
            for k,v in pairs (self.shopPickList) do
                -- 转化为下标从1开始的idlist
                itemList[#itemList+1] = k
                itemNumList[#itemNumList+1] = v.num
            end
            local iCount = #itemList
            if (iCount > 1 or (iCount == 1 and self.kItemMgr:ItemUseNeedCheck(itemList[1]))) then
                data = {
                    ['goodsList'] = itemList,
                    ['goodsNumList'] = itemNumList,
                    ['windowTitle'] = "物品贩卖",
                    ['windowTips'] = "以下物品将被贩卖并转换为"..self:GetSumPrice().."铜币，是否确定？",
                    ['commitCallback'] = boxCallback,
                    ['removeItemCallback'] = removeItemCallback,
                    ['getNewWindowTips'] = getNewWindowTips
                }
                OpenWindowImmediately("ShowAllChooseGoodsUI",data)
            else
                boxCallback()
            end
        else
            OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.SYSTEM_TIP, '没有选中任何物品' })
        end
    end
end

-- 打开多选界面
function StoreUI:OpenBatchChoose()
    -- 隐藏状态栏返回键
    -- local windowBarUI = GetUIWindow("WindowBarUI")
    -- if windowBarUI then
    --     windowBarUI:SetBackBtnState(false)
    -- end
    -- 打开多选
    OpenWindowByQueue("BatchChooseUI", {
        ['callback'] = function(res, eBatchType)
            local win = GetUIWindow("StoreUI")
            if not win then
                return
            end
            win:OnBatchChooseOver(res, eBatchType)
		end,
        ['onClose'] = function()
            -- -- 重新打开状态栏返回键
            -- local windowBarUI = GetUIWindow("WindowBarUI")
            -- if windowBarUI then
            --     windowBarUI:SetBackBtnState(true)
            -- end
        end,
    })
end

-- 提示弹框
function StoreUI:WarningBox(title, content, iPaySilverNum, strPayFor, callBack)
    if not content then return end
    local type = GeneralBoxType.COMMON_TIP
    local showContent = content
    local safeCall = callBack
    if iPaySilverNum and strPayFor then
        type = GeneralBoxType.Pay_TIP
        showContent = {
            ['title'] = title,
            ['text'] = content,
            ['btnType'] = "silver",
            ['num'] = iPaySilverNum,
            ['btnText'] = strPayFor
        }
        safeCall = function()
            PlayerSetDataManager:GetInstance():RequestSpendSilver(iPaySilverNum, callBack)
        end
    end
    OpenWindowImmediately('GeneralBoxUI', {type, showContent, safeCall})
end

-- 显示折扣说明
function StoreUI:ShowDiscountTips()
    local tips = {
        ['title'] = '购买折扣',
        ['titlecolor'] = getUIColor('white'),
        ['kind'] = 'wide',
    }

    local businessmanData = TableDataManager:GetInstance():GetTableData("Businessman", self.businessid)
    if businessmanData and businessmanData.DiscountTips and businessmanData.DiscountTips ~= "" then
        tips.content = businessmanData.DiscountTips
        OpenWindowImmediately("TipsPopUI", tips)
    end

    -- local content = {
    --     '仁义值60及以上时, 商店折扣为9折',
    --     '仁义值80及以上时, 商店折扣为8折',
    --     '仁义值100时, 商店折扣为7折',
    --     '仅城市商店参与打折，神秘商人、张少爷和张小缨不参与打折',
    -- }
    -- tips.content = table.concat(content, "\n")
    -- OpenWindowImmediately("TipsPopUI", tips)
end

function StoreUI:UpdateMoneyType(ItemID)
    if ItemID == nil then
        return
    end

    local itemData = TableDataManager:GetInstance():GetTableData("Item",ItemID)
    if itemData then
        --self.resource_box.gameObject:SetActive(false)
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

function StoreUI:ResetType()
    --self.resource_box.gameObject:SetActive(true)
    self.other_box.gameObject:SetActive(false)
end

function StoreUI:OnEnable()
    -- OpenWindowBar({
    --     ['windowstr'] = "StoreUI", 

    --     ['titleName'] = "商店",
    --     ['topBtnState'] = {
    --         ['bBackBtn'] = true,
    --         ['bGoodEvil'] = true,
    --         ['bSilver'] = true,
    --         ['bCoin'] = true,
    --     },
    --     ['bSaveToCache'] = false,
    --     ['callback'] = function()
    --         -- 点击返回键时还原界面状态为买入
    --         self.comBuy_Toggle.isOn = true
    --         self.comSell_Toggle.isOn = false
    --         self.comBuy_Toggle:Select()
    --     end
    -- })
end

function StoreUI:OnDisable()
    if self.UseMoneyID and self.UseMoneyID > 0 then 
        self:ResetType()
    end

    RemoveWindowBar('StoreUI')
end

function StoreUI:OnPressESCKey()
    if self.btnExit and not IsWindowOpen("ShowAllChooseGoodsUI") and not IsWindowOpen("BatchChooseUI") then
        self.btnExit.onClick:Invoke()
    end
end



function StoreUI:OnDestroy()    
    ShopDataManager:GetInstance():SetLockShopItemDiscount(false)
    RemoveEventTrigger(self.objRaycast)
    self:RemoveStoreListener()
    self.ItemInfoUI:Close()
end

return StoreUI