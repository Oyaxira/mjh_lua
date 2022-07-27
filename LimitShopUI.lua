LimitShopUI = class('LimitShopUI', BaseWindow);

local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'

local BA_KANDAO = 1
local BA_DAJINBI = 2
local BA_BUYOUHUI = 3
function LimitShopUI:ctor()
    self.bindBtnTable = {}
end

function LimitShopUI:Create()
	local obj = LoadPrefabAndInit('LimitShopUI/LimitShopUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function LimitShopUI:Init()
    self.ItemDataManager = ItemDataManager:GetInstance()
    self.LimitShopManager = LimitShopManager:GetInstance()
   
    self.ItemInfoUI = ItemInfoUI.new()


    self.obj_scr_list_big = self:FindChild(self._gameObject,"LimitShopItemsList/Viewport/Content")

    self.obj_Button_discountpanal = self:FindChild(self._gameObject,"Button_discountpanal")
    self:CommonBind(self.obj_Button_discountpanal,function()
        OpenWindowImmediately('LimitShopDiscountPanalUI')
    end )

    self.obj_Button_guessgold = self:FindChild(self._gameObject,"Button_guessgold")
    self.obj_Button_guessgold:SetActive(self.LimitShopManager:GetYaZhuFinished())
    self:CommonBind(self.obj_Button_guessgold,function()
        OpenWindowImmediately('GuessCoinUI')
    end )
    self.txt_BtnGuessGoldLastNum = self:FindChildComponent(self._gameObject,"Button_guessgold/Guessgold_left/Text_num","Text")

    self.obj_listitem_type = self:FindChild(self._gameObject,"LimitShopItemsList/ShopTypeListItems")
    self.obj_listitem_type:SetActive(false)

    self.com_LeftTime_text = self:FindChildComponent(self._gameObject,'LeftTime','Text')

    self:BindBtnCB();

    self:AddEventListener("UPDATE_LIMITSHOP_BUTTON", function(info)
		self:UpdateBoughtUI()
    end)
    self:AddEventListener("UPDATE_GUESSCOIN_BUTTON", function(info)
        local gamelevel = info
        self.txt_BtnGuessGoldLastNum.text = "剩余"..tostring(4-gamelevel).."次"
        if (info > 3) then
            self.obj_Button_guessgold:SetActive(false)
        end
	end)
end


function LimitShopUI:LateUpdate()
    local str_ = self.LimitShopManager:GetLeftTimeStr_Shop()
    if str_ then 
        self.com_LeftTime_text.text = '倒计时：'..str_ 
    else 
        RemoveWindowImmediately('LimitShopUI')
        
        LimitShopManager:GetInstance():SetLimitActionEnd(true)
        LimitShopManager:GetInstance():LimitShopDisplayActionEnd()

        DialogRecordDataManager:GetInstance():SetAutoChatState(false)
        DialogRecordDataManager:GetInstance():SetFastChatState(false)
        PlotDataManager:GetInstance():DisplayCustomStrDialogue(1000114002, '大侠，本店货物已全部售卖完毕，期待下次和您相遇')
    end 
end


function LimitShopUI:RefreshUI()
    -- self.LimitShopData = self.LimitShopManager:GetShopShowData()
    self:SetLimitShopList()
    self.iSecondGold = PlayerSetDataManager:GetInstance():GetPlayerSecondGold()

    self:InitList()
    self:RefreshDiscountBtnUI()

    self.txt_BtnGuessGoldLastNum.text = "剩余"..(4-self.LimitShopManager:GetNowGuessCoinGameLevel()).."次"
end
function LimitShopUI:RefreshDiscountBtnUI()
    
    self.allDiscountList = self.LimitShopManager:GetDiscountList()
    local bBtnShow = false 
    for i,data in pairs(self.allDiscountList) do 
        if  self.LimitShopManager:GetLeftTimeStr(data.iEndTime) then 
            bBtnShow = true 
            break
        end 
    end 
    self.obj_Button_discountpanal:SetActive(bBtnShow)
end
function LimitShopUI:UpdateBoughtUI()


    self.iSecondGold = PlayerSetDataManager:GetInstance():GetPlayerSecondGold()
    
    -- self.LimitShopData = self.LimitShopManager:GetShopShowData()
    self:SetLimitShopList()
    self:RefreshDiscountBtnUI()
    if self._callback_check_bought then 
        for i,func in ipairs(self._callback_check_bought) do 
            func()
        end 
    end 
end 
function LimitShopUI:SetLimitShopList()
    local List = self.LimitShopManager:GetShopShowData()
    self.LimitShopData = self.LimitShopData or {}
    if List then
        for i,gift in pairs(List) do 
            self.LimitShopData[i] = self.LimitShopData[i] or {}
            if gift then 
                for ii,vv in pairs(gift) do 
                    self.LimitShopData[i][ii] = vv
                end 
            end 
        end
    end 
end

function LimitShopUI:InitList()
    RemoveAllChildren(self.obj_scr_list_big)
    self._callback_check_bought = {}
    local _Listi = {}
    if  self.LimitShopData then 
        for i = 1,5 do 
            local data = self.LimitShopData[i-1]
            if data then 
                local typedata = self.LimitShopManager:GetShopDataByID(data.giftType,data.grade)
                table.insert( _Listi, {
                    typedata = typedata,
                    index = i-1,
                    giftType = data.giftType,
                    grade = data.grade,
                } )
            end 
        end 
    end 
    table.sort( _Listi, function(a,b)
        if a.giftType == 0 or b.giftType == 0 then 
            return  a.giftType == 0
        elseif a.typedata and b.typedata then 
            return a.typedata.Price < b.typedata.Price
        else 
            return a.grade < b.grade
        end
    end )
    for i = 1,#_Listi do 
        local data = _Listi[i]
        if data  then
            self.LimitShopData[data.index].typedata =  data.typedata
            local obj_clone = self:GetInitListItem(data.index+1)
            self.LimitShopData[data.index].object = obj_clone
        end 
    end 
    local comobj = self.obj_scr_list_big:GetComponent('RectTransform')
    if comobj then 
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(comobj)
    end
end
function LimitShopUI:GetInitListItem(iList)
    local LimitShopData =  self.LimitShopData[iList-1]
    if not LimitShopData then return end 

    local obj_clone = CloneObj(self.obj_listitem_type,self.obj_scr_list_big)
    obj_clone:SetActive(true)

    local comName1 = self:FindChildComponent(obj_clone,'Name/Text1','Text')
    local comNameNum = self:FindChildComponent(obj_clone,'Name/cost/value','Text')
    local comName2 = self:FindChildComponent(obj_clone,'Name/Text2','Text')
    local objItemsList = self:FindChild(obj_clone,'ItemsList')
    local objBtnBuy = self:FindChild(objItemsList,'Button_buy')
    local objBtnGet = self:FindChild(objItemsList,'Button_get')

    local objPrevious  = self:FindChild(objBtnBuy,'Image/value_bottom/Text_price_previous')
    objPrevious:SetActive(false)

    objBtnBuy:SetActive(LimitShopData.giftType ~= 0)
    objBtnGet:SetActive(LimitShopData.giftType == 0)
    local typedata = LimitShopData.typedata
    if not typedata then return end 
    
    if LimitShopData.giftType == 0 then 
        -- 铜币礼包 就这么特殊处理呗 
        -- 配置信息 可以填在礼包列表中
        comName1.text = string.format( "%s,价值",GetLanguageByID(typedata.NameID) )
        comNameNum.text = typedata.ShowPrice or 0
        comName2.text = '铜币'
        setUIGray(objBtnGet:GetComponent('Image'), false)
        local func_check_bought = function()
            -- 调用manager接口来判断是否
            local combtn = objBtnGet:GetComponent('DRButton')
            if self.LimitShopManager:GetBuyStateByTypeid(LimitShopData.giftType) then 
                setUIGray(objBtnGet:GetComponent('Image'), true)
                combtn.interactable = false 
			else
				setUIGray(objBtnGet:GetComponent('Image'), false)
				combtn.interactable = true
            end 
        end 
        func_check_bought()
        table.insert( self._callback_check_bought, func_check_bought )

        local objChosen = self:FindChild(objItemsList,'LimitShopItem/ChooseBtn/Image_chosen')
        objChosen:SetActive(false)

        local objiteminfo = self:FindChild(objItemsList,'LimitShopItem/ItemInfoUI')
        local itemid = typedata.ItemId and typedata.ItemId[1] or 1301
        local itemnum = typedata.ItemNum and typedata.ItemNum[1] or 5000
        local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(itemid)
        self.ItemInfoUI:UpdateUIWithItemTypeData(objiteminfo, ItemTypeData)
        local comNum = self:FindChildComponent(objiteminfo,'Button/ItemIconUI/Num','Text')
        comNum.text = itemnum
        if ItemDataManager:GetInstance():GetIfMainRolePackageFilled(1) then 
            SystemUICall:GetInstance():Toast('背包空间不足，请麻烦大侠您空出些许背包来购买道具')
            return
        end
        self:CommonBind(objBtnGet,function()
            -- buy
            SendLimitShopOpr(EN_LIMIT_SHOP_BUY,LimitShopData.giftType,0,0,0,LimitShopData.grade)
        end )
        return 
    end 


    if not typedata then return end 
    -- local str_name = GetLanguageByID(typedata.NameID)
    -- comName.text = str_name
    local iPrice = typedata.Price or 0

    comName1.text = string.format( "%s,价值",GetLanguageByID(typedata.NameID) )
    comNameNum.text = typedata.Price or 0
    comName2.text = '金锭'

    self:CommonBind(objBtnBuy,function()
        -- buy
        OpenWindowImmediately('LimitShopActionPanalUI',{
            iItemIndex = LimitShopData.chosenItemIndex,
            iItemID = LimitShopData.chosenItemID,
            iTypeID = LimitShopData.giftType,
            iGrade = LimitShopData.grade,
            typedate = LimitShopData.typedata,
            iGiftID = LimitShopData.nDataId,
            CallBackFunc = function(iIndex,iItemId)
                self:OnclickChoseItem(iList,iIndex,iItemId)
            end 
        })
    end )

    local bShowChose = typedata.IsMultiChoice == 1 
    -- local toggleGroup = objItemsList:GetComponent('ToggleGroup');

    local obj_old = self:FindChild(objItemsList,'LimitShopItem')
    local toggle1st = false
    self.LimitShopData[iList-1].chosenItemID = nil
    self.LimitShopData[iList-1].chosenItemIndex = nil
    self.LimitShopData[iList-1].itemsList = {}
    if typedata.ItemId then 
        for i=1,#typedata.ItemId do 
            local iItemId = typedata.ItemId[i]
            local iNum = typedata.ItemNum[i] or 1
            local objChild 
            if i == 1 then 
                objChild = obj_old 
            else 
                objChild = CloneObj(obj_old,objItemsList)
            end 
            local objiteminfo = self:FindChild(objChild,'ItemInfoUI')
            local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(iItemId)
            self.ItemInfoUI:UpdateUIWithItemTypeData(objiteminfo, ItemTypeData)
            local comNum = self:FindChildComponent(objiteminfo,'Button/ItemIconUI/Num','Text')
            local objitemicon = self:FindChild(objiteminfo,'Button/ItemIconUI')
            if iNum ~= 1 and comNum then 
                comNum.text = iNum
            end
            if bShowChose then 
                if not toggle1st then 
                    local ibuyindex = self.LimitShopManager:GetBuyStateByTypeid(LimitShopData.giftType)
                    if ibuyindex ~= nil and typedata.ItemId[ibuyindex+1] then 
                        self.LimitShopData[iList-1].chosenItemIndex = ibuyindex
                        self.LimitShopData[iList-1].chosenItemID = typedata.ItemId[ibuyindex+1]

                    else
                        self.LimitShopData[iList-1].chosenItemIndex = i - 1
                        self.LimitShopData[iList-1].chosenItemID = iItemId
                    end
                end 
                toggle1st = true
                local func_chose = function(gameObject,boolHide)
                    local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, ItemTypeData)
                    if not self.LimitShopManager:GetBuyStateByTypeid(LimitShopData.giftType) then 
                        tips.buttons = {{
                            ['name'] = "选择",
                            ['func'] = function()
                                self:OnclickChoseItem(iList,i - 1,iItemId)
                            end
                        }} 
                    end 
                    OpenWindowImmediately("TipsPopUI", tips)
                end
                self:CommonBind(objChild,func_chose)
                self:CommonBind(objitemicon,func_chose)
            end
            self.LimitShopData[iList-1].itemsList[iItemId] = objChild
        end 
    end 
    self:OnclickChoseItem(iList)

    local comPrice  = self:FindChildComponent(objBtnBuy,'Image/value_bottom/Num','Text')
    local imgBigGold  = self:FindChild(objBtnBuy,'Image/BigGold')
    setUIGray(objBtnBuy:GetComponent('Image'), false)
    local func_check_bought = function()
        -- 调用manager接口来判断是否
        local combtn = objBtnBuy:GetComponent('DRButton')
        if self.LimitShopManager:GetBuyStateByTypeid(LimitShopData.giftType) then 
            setUIGray(objBtnBuy:GetComponent('Image'), true)
            combtn.interactable = false 
        else
            setUIGray(objBtnBuy:GetComponent('Image'), false)
            combtn.interactable = true 
        end 
        if self.iSecondGold > 0 then 
            local iPrice2 = iPrice - 180 
            if iPrice2 < 0 then iPrice2 = 0 end 
            comPrice.text = iPrice2
            imgBigGold:SetActive(true)
        else 
            comPrice.text = iPrice
            imgBigGold:SetActive(false)
        end 
    end 
    func_check_bought()
    table.insert( self._callback_check_bought, func_check_bought )

    return obj_clone
end
-- 点击后遍历刷新选中标记
function LimitShopUI:OnclickChoseItem( iList,index,itemid )
    if not iList then  
        return 
    end
    if not self.LimitShopData or not self.LimitShopData[iList -1] then 
        return 
    end 
    if index and itemid then 
        self.LimitShopData[iList-1].chosenItemIndex = index
        self.LimitShopData[iList-1].chosenItemID = itemid
    end 
    local itemsList = self.LimitShopData[iList-1].itemsList or {}
    for iItemId,objChild in pairs(itemsList) do 
        local bChose = iItemId == self.LimitShopData[iList-1].chosenItemID
        local objChooseBtn = self:FindChild(objChild,'ChooseBtn')
        objChooseBtn:SetActive(bChose )
        local objImage_chosen2 = self:FindChild(objChild,'Image_chosen2')
        objImage_chosen2:SetActive(bChose)
        local objText_Category = self:FindChildComponent(objChild,'ItemInfoUI/Category','Text')
        objText_Category.color = bChose and DRCSRef.Color(1,1,1,1) or DRCSRef.Color(99/255,65/255,25/255,1)
    end 
end
function LimitShopUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end
function LimitShopUI:CommonBind(gameObject, callback)
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
        self:AddToggleClickListener(tog, _callback)
    end

end

function LimitShopUI:OnclickBtn(obj, boolHide)
    if obj == self.obj_btn_buy_back then 
        self.obj_BuyAcitonPanal:SetActive(false)
    elseif obj == self.obj_btn_buy then 
        local iList = self.data_ShowiList
        local itype = self.LimitShopData[iList-1].giftType
        local ipar0 = self.LimitShopData[iList-1].chosenItemID or 0
        local ipar1 = 0
        local ipar2 = 0
        if self.data_ChosenAction == BA_BUYOUHUI then 
            ipar2 = 0
        elseif self.data_ChosenAction == BA_KANDAO then 
            ipar1 = self.data_ChosenDiscount
        elseif self.data_ChosenAction == BA_DAJINBI then 
            ipar2 = 1
        end 
        if ItemDataManager:GetInstance():GetIfMainRolePackageFilled(1) then 
            SystemUICall:GetInstance():Toast('背包空间不足，请麻烦大侠您空出些许背包来购买道具')
            return
        end
        SendLimitShopOpr(EN_LIMIT_SHOP_BUY,itype,ipar0,ipar1,ipar2,self.LimitShopData[iList-1].grade)
        self.obj_BuyAcitonPanal:SetActive(false)
    end 

end

function LimitShopUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "LimitShopUI", 
        --['titleName'] = "限时礼包",
        ['topBtnState'] = {
            ['bBackBtn'] = true,
            ['bGold'] = true,
            ['bSecondGold'] = true,
        },
        ['callback'] = function()
            LimitShopManager:GetInstance():SetLimitActionEnd(true)
            -- DisplayActionEnd()
            LimitShopManager:GetInstance():LimitShopDisplayActionEnd()
        end,
    })
    
	local winDialogRec = GetUIWindow("DialogControlUI")
	if winDialogRec then
		winDialogRec:HideBtns()
	end
end

function LimitShopUI:OnDisable()
    RemoveWindowBar('LimitShopUI')
	local winDialogRec = GetUIWindow("DialogControlUI")
	if winDialogRec then
		winDialogRec:ShowBtns()
	end
end

function LimitShopUI:OnDestroy()
    self:RemoveEventListener("UPDATE_LIMITSHOP_BUTTON");
    self:RemoveEventListener("UPDATE_GUESSCOIN_BUTTON");
    
    self._callback_check_bought = {} 
    self.ItemInfoUI:Close()

end

return LimitShopUI;