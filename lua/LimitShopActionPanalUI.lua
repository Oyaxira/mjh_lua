LimitShopActionPanalUI = class('LimitShopActionPanalUI', BaseWindow);

local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'


local BA_DAJINBI = 1
local BA_KANDAO = 2
local BA_BUYOUHUI = 3
function LimitShopActionPanalUI:ctor()
    self.bindBtnTable = {}
end

function LimitShopActionPanalUI:Create()
	local obj = LoadPrefabAndInit('LimitShopUI/LimitShopActionPanalUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function LimitShopActionPanalUI:Init()
    self.ItemDataManager = ItemDataManager:GetInstance()
    self.LimitShopManager = LimitShopManager:GetInstance()
   
    self.ItemInfoUI = ItemInfoUI.new()
    
    self.obj_btn_buy_back = self:FindChild(self._gameObject,'Button_close')
    table.insert(self.bindBtnTable, self.obj_btn_buy_back)
    
    self.obj_btn_buy = self:FindChild(self._gameObject,'Button_buy')
    table.insert(self.bindBtnTable, self.obj_btn_buy)

    self.obj_btn_buy = self:FindChild(self._gameObject,'Button_buy')
    self.com_btn_buy_text = self:FindChildComponent(self.obj_btn_buy,'Image/value_bottom/Num','Text')
    self.obj_btn_buy_sp = self:FindChild(self.obj_btn_buy,'Image/value_bottom/Text_price_previous')
    self.com_btn_buy_sp_text = self:FindChildComponent(self.obj_btn_buy,'Image/value_bottom/Text_price_previous','Text')
    table.insert(self.bindBtnTable, self.obj_btn_buy)

    self.obj_Action_ActionList = self:FindChild(self._gameObject,'ChooseBuyAction')
    self.obj_Action_ItemList = self:FindChild(self._gameObject,'ItemInfoList/Viewport/Content')
    self.com_ItemInfoList_ScrollRect = self:FindChildComponent(self._gameObject,'ItemInfoList','LoopVerticalScrollRect')
    if self.com_ItemInfoList_ScrollRect then
        self.com_ItemInfoList_ScrollRect:AddListener(function(...) self:OnItemChanged(...) end)
    end
    self.comTog_Action_ItemList = self.obj_Action_ItemList:GetComponent('ToggleGroup')
    self.com_Action_Text = self:FindChildComponent(self._gameObject,'Text','Text')
    self.com_Action_Title = self:FindChildComponent(self._gameObject,'title_box/Text','Text')

    self.obj_LimitShopItem_Type = self:FindChild(self._gameObject,'ItemInfoList/Viewport/LimitShopItem')
    
    self:BindBtnCB();

end

function LimitShopActionPanalUI:RefreshUI(info)
    self.iChoseItemIndex = info and info.iItemIndex
    self.iChoseItemID = info and info.iItemID
    self.iChoseTypeID = info and info.iTypeID
    self.iChoseGrade = info and info.iGrade
    self.ChoseTypeData = info and info.typedate
    self.ChoseCallBackFunc = info and info.CallBackFunc
    if not self.iChoseGrade or not self.iChoseTypeID then 
        return 
    end 
    self.LimitShopData = self.LimitShopManager:GetShopShowData()
    self.akLimitShopDiscountData =  {}
    self.allDiscountList = self.LimitShopManager:GetDiscountList()

    for i,data in pairs(self.allDiscountList) do 
        if self.LimitShopManager:GetLeftTimeStr(data.iEndTime) then 
            table.insert( self.akLimitShopDiscountData, data)
        end 
    end 
    table.sort(self.akLimitShopDiscountData,function(a,b)
        return a.discount < b.discount
    end )
    self.iSecondGold = PlayerSetDataManager:GetInstance():GetPlayerSecondGold()

    self:InitBuyPanal()
    self:ShowBuyActionPanal()
    if self._obj_Actions then 
        if  self.iSecondGold and self.iSecondGold > 0 then 
            self._obj_Actions[BA_DAJINBI].tog.isOn = true
        else
            self._obj_Actions[BA_BUYOUHUI].tog.isOn = true
        end
    end
end

function LimitShopActionPanalUI:InitBuyPanal()
    local iNum = self.obj_Action_ActionList.transform.childCount
    self._obj_Actions = {}
    toggleGroup = self.obj_Action_ActionList:GetComponent('ToggleGroup')
	for i = 0, iNum -1  do
		local kChild = self.obj_Action_ActionList.transform:GetChild(i).gameObject
        local obj_chose = self:FindChild(kChild,'ChooseBtn/Image_chosen')
        obj_chose:SetActive(false)
        local comtoggle = kChild:GetComponent('Toggle') 
        comtoggle.group = toggleGroup
        self._obj_Actions[i+1] = {
            obj = kChild,
            tog = comtoggle,
            type = i + 1
        }
        comtoggle.isOn = false
        self:CommonBind(kChild, function(gameObject,boolHide)
            obj_chose:SetActive(boolHide)
            if boolHide then 
                self.data_ChosenAction = i + 1
            end
            if self.refreash_func then  
                self.refreash_func() 
            end 
        end)
    end

    self.obj_BtnDetails = self:FindChild(self._obj_Actions[BA_KANDAO].obj,'Details')
    self.obj_DiscountList = self:FindChild(self._obj_Actions[BA_KANDAO].obj,'DiscountList')
    local obj_text  = self:FindChild(self.obj_DiscountList,'Num')
    obj_text:SetActive(false)
    self.com_BtnDetailsScroll = self.obj_DiscountList:GetComponent('LoopVerticalScrollRect')

    self.obj_DiscountList:SetActive(false)
    self.state_DiscountList = false 
    if self.com_BtnDetailsScroll then
        self.com_BtnDetailsScroll:AddListener(function(...) self:OnDetailChanged(...) end)
    end
    self:CommonBind(self.obj_BtnDetails, function()
        self:ShowBuyActionPanalDetails()
    end)

    iNum = self.obj_Action_ItemList.transform.childCount
end

function LimitShopActionPanalUI:OnDetailChanged(gameobj,index)
    -- local iList = self.data_ShowiList 
    local DiscountData =  self.akLimitShopDiscountData and  self.akLimitShopDiscountData[index+1] 
    if not DiscountData then return end 
    local Object = gameobj.gameObject
    local comtext = Object:GetComponent('Text')
    local str_sh = DiscountData.discount / 100
    comtext.text = str_sh.. '折'
    Object:SetActive(true)
    local comDRButton = Object:GetComponent('DRButton')
    if comDRButton then 
        self:RemoveButtonClickListener(comDRButton)
        self:AddButtonClickListener(comDRButton, function() 
            self.data_Chosediscount = DiscountData.discount
            self:ShowBuyActionPanalDetails(true)
            self._obj_Actions[BA_KANDAO].tog.isOn = true
            self.refreash_func()
        end)
    end
end

function LimitShopActionPanalUI:ShowBuyActionPanalDetails(boolHide)
    if not  self.akLimitShopDiscountData then return end 
    if self.state_DiscountList or boolHide == true then 
        self.obj_DiscountList:SetActive(false)
        self.state_DiscountList = false 
    else
        self.obj_DiscountList:SetActive(true)
        self.state_DiscountList = true 
    end
    self.com_BtnDetailsScroll.totalCount = #self.akLimitShopDiscountData
    self.com_BtnDetailsScroll:RefillCells()
end
function LimitShopActionPanalUI:GetBuyItemNum()
    if self.ChoseTypeData then 
        if self.ChoseTypeData.IsMultiChoice == 1 then 
            return 1
        else 
            return getTableSize(self.ChoseTypeData.ItemId)
        end 
    end 
    return 1
end 
function LimitShopActionPanalUI:OnItemChanged(gameobj,index)
    
    local obj_curitem = gameobj.gameObject
    local typedata = self.ChoseTypeData
    local bShowChose = typedata.IsMultiChoice == 1 
    local iItemId = typedata.ItemId[index+1]
    self._obj_Actions_Items[iItemId] = obj_curitem
    obj_curitem:SetActive(true)

    local objItemInfo = self:FindChild(obj_curitem,'ItemInfoUI')
    local iNum = typedata.ItemNum[index+1] or 1
    local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(iItemId)
    self.ItemInfoUI:UpdateUIWithItemTypeData(objItemInfo, ItemTypeData)
    local comNum = self:FindChildComponent(objItemInfo,'Button/ItemIconUI/Num','Text')
    local objitemicon = self:FindChild(objItemInfo,'Button/ItemIconUI')
    if iNum ~= 1 then 
        comNum.text = iNum
    end
    if bShowChose  then 
        local func_chose = function()
            local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, ItemTypeData)
            tips.buttons = {{
                ['name'] = "选择",
                ['func'] = function()
                    self:OnclickChoseItem(index,iItemId)
                end
            }}
            OpenWindowImmediately("TipsPopUI", tips)
        end
        self:CommonBind(obj_curitem,func_chose)
        self:CommonBind(objitemicon,func_chose)
    end
    local objChooseBtn = self:FindChild(obj_curitem,'ChooseBtn')
    objChooseBtn:SetActive(bShowChose and iItemId == self.iChoseItemID )
    local objImage_chosen2 = self:FindChild(obj_curitem,'Image_chosen2')
    objImage_chosen2:SetActive(bShowChose and iItemId == self.iChoseItemID)
end
function LimitShopActionPanalUI:ShowBuyActionPanal(iList)
    if not self.LimitShopData then return end 

    local LimitShopData 
    for i,list in pairs(self.LimitShopData) do 
        if list.giftType ==  self.iChoseTypeID and list.grade ==  self.iChoseGrade then 
            LimitShopData = list 
        end 
    end 
    if not LimitShopData then return end 
    local typedata = self.ChoseTypeData
    self.data_ShowiList = iList
    self.data_Chosediscount = nil
    -- self.obj_BuyAcitonPanal:SetActive(true)
    local str_name = GetLanguageByID(typedata.NameID) or ''
    local iPrice = typedata.Price or 0    
    local bShowChose = typedata.IsMultiChoice == 1 
    self._obj_Actions_Items = {}
    if self.com_ItemInfoList_ScrollRect then
        self.com_ItemInfoList_ScrollRect.totalCount = getTableSize(typedata.ItemId)
        self.com_ItemInfoList_ScrollRect:RefillCells()
        if bShowChose and self.iChoseItemIndex then 
            self.com_ItemInfoList_ScrollRect:SrollToCell(math.floor(self.iChoseItemIndex),600)
        end
    end 
    self:OnclickChoseItem()
    if self.com_Action_Title then 
        self.com_Action_Title.text = string.format( "%s，价值%d金锭",str_name,iPrice)
    end
    if self.com_Action_Text then 
        self.com_Action_Text.text = ''
    end
    self.refreash_func = function()
        for i,_obj_Action in pairs(self._obj_Actions) do
            do 
                local obj = _obj_Action.obj
                if _obj_Action.type == BA_DAJINBI then 
                    local objtext = self:FindChildComponent(obj,'Text','Text')
                    objtext.text = string.format( "使用1旺旺币<size=22>(拥有:%s)</size>",self.iSecondGold)
                elseif _obj_Action.type == BA_KANDAO then 
                    if not self.akLimitShopDiscountData or #self.akLimitShopDiscountData == 0 then 
                        obj:SetActive(false)
                        break
                    else 
                        obj:SetActive(true)
                        if not self.data_Chosediscount then 
                            local min = 1000
                            for ii,vv in pairs(self.akLimitShopDiscountData) do 
                                if min > vv.discount then 
                                    min = vv.discount
                                end
                            end 
                            self.data_Chosediscount = min
                        end  
                        local objtext = self:FindChildComponent(obj,'Text','Text')
                        objtext.text = string.format( "使用砍价刀<size=22>(%s折)</size>",self.data_Chosediscount / 100 )
                    end 
                else 

                end            
            end
        end 
        local iBasePrice = iPrice or 0
        local iFinalPrice = iBasePrice
        local idiscount = self.data_Chosediscount or 1000
        if self.data_ChosenAction == BA_BUYOUHUI then 
        elseif self.data_ChosenAction == BA_KANDAO then 
            iFinalPrice = math.floor(iBasePrice * idiscount / 1000)
        elseif self.data_ChosenAction == BA_DAJINBI then 
            iFinalPrice = iBasePrice - 180 
            if iFinalPrice <= 0 then 
                iFinalPrice = 0
            end
        end 
        if iBasePrice ~= iFinalPrice then 
            self.obj_btn_buy_sp:SetActive(true)
            self.com_btn_buy_sp_text.text = iBasePrice
        else 
            self.obj_btn_buy_sp:SetActive(false)
        end 
        self.iFinalPrice = iFinalPrice
        self.com_btn_buy_text.text = iFinalPrice
    end
    self.refreash_func()
end
function LimitShopActionPanalUI:OnclickChoseItem(iIndex,iItemId)
    if iItemId then  
        self.iChoseItemID = iItemId

        if self.ChoseCallBackFunc then 
            self.ChoseCallBackFunc(iIndex,iItemId)
        end 
    end
    for iItemId,objChild in pairs(self._obj_Actions_Items) do 
        local bChose = iItemId == self.iChoseItemID
        local objChooseBtn = self:FindChild(objChild,'ChooseBtn')
        objChooseBtn:SetActive(bChose)
        local objImage_chosen2 = self:FindChild(objChild,'Image_chosen2')
        objImage_chosen2:SetActive(bChose)
        local objText_Category = self:FindChildComponent(objChild,'ItemInfoUI/Category','Text')
        objText_Category.color = bChose and DRCSRef.Color(1,1,1,1) or DRCSRef.Color(99/255,65/255,25/255,1)
    end 
end
function LimitShopActionPanalUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject,boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end
function LimitShopActionPanalUI:CommonBind(gameObject, callback)
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

function LimitShopActionPanalUI:OnclickBtn(obj, boolHide)
    if obj == self.obj_btn_buy_back then 
        RemoveWindowImmediately('LimitShopActionPanalUI')
    elseif obj == self.obj_btn_buy then 
        local iList = self.data_ShowiList
        local itype = self.iChoseTypeID or 0
        local ipar0 = self.iChoseItemIndex or 0
        local ipar1 = 0
        local ipar2 = 0
        if self.data_ChosenAction == BA_BUYOUHUI then 
            ipar2 = 0
        elseif self.data_ChosenAction == BA_KANDAO then 
            ipar1 = self.data_Chosediscount
            local bret = true
            for i,v in ipairs(self.akLimitShopDiscountData) do 
                if v.discount == self.data_Chosediscount and self.LimitShopManager:GetLeftTimeStr(v.iEndTime) then 
                    bret = false 
                end 
            end 
            if bret then 
                SystemUICall:GetInstance():Toast('该砍价刀已经过期')
                return false 
            end 
        elseif self.data_ChosenAction == BA_DAJINBI then 
            ipar2 = 1
        end 
        if ItemDataManager:GetInstance():GetIfMainRolePackageFilled(self:GetBuyItemNum()) then 
            SystemUICall:GetInstance():Toast('背包空间不足，请麻烦大侠您空出些许背包来购买道具')
            return
        end
        PlayerSetDataManager:GetInstance():RequestSpendGold(self.iFinalPrice,function()
            SendLimitShopOpr(EN_LIMIT_SHOP_BUY,itype,ipar0,ipar1,ipar2,self.ChoseTypeData.Grade)
            -- self.obj_BuyAcitonPanal:SetActive(false)
        end )
        RemoveWindowImmediately('LimitShopActionPanalUI')
    end 

end

function LimitShopActionPanalUI:OnEnable()
end

function LimitShopActionPanalUI:OnDisable()
    -- RemoveWindowBar('LimitShopActionPanalUI')
end

function LimitShopActionPanalUI:OnDestroy()
    
    self.ItemInfoUI:Close()
end

return LimitShopActionPanalUI;