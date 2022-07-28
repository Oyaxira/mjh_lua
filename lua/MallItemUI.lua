MallItemUI = class("MallItemUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI';

local shopBuyLimitResetTypeRevert = {
    [ShopBuyLimitResetType.SBLRT_NULL] = "限购:",
    [ShopBuyLimitResetType.SBLRT_DAILY] = "每日重置:",
    [ShopBuyLimitResetType.SBLRT_WEEKLY] = "每周重置:",
    [ShopBuyLimitResetType.SBLRT_MONTH] = "每月重置:",
}
local MAP_MONEYTYPE_2_STROBJ = {
    [RackItemMoneyType.RIMT_GOLD] = 'Image_JinDing',
    [RackItemMoneyType.RIMT_SILVER] = 'Image_YinDing',
    [RackItemMoneyType.RIMT_TREASUREBOOK] = 'Image_HuoDong',
    [RackItemMoneyType.RIMT_DRINK] = 'Image_HuoDong',
    [RackItemMoneyType.RIMT_PLATSCORE] = 'Image_HuoDong',
    [RackItemMoneyType.RIMT_ACTIVITYSCORE] = 'Image_HuoDong',
}
local MAP_MONEYTYPE_2_STRNAME = {
    [RackItemMoneyType.RIMT_GOLD] = '金锭',
    [RackItemMoneyType.RIMT_SILVER] = '银锭',
    [RackItemMoneyType.RIMT_TREASUREBOOK] = '',
    [RackItemMoneyType.RIMT_DRINK] = '',
    [RackItemMoneyType.RIMT_PLATSCORE] = '',
    [RackItemMoneyType.RIMT_ACTIVITYSCORE] = '',
}
function MallItemUI:ctor()

end

function MallItemUI:Create(kParent)
	local obj = LoadPrefabAndInit("ActivityCommonUI/MallItem",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end


function MallItemUI:Init()
    self.ItemIconUI = ItemIconUI.new();
    self.ItemDataManager = ItemDataManager:GetInstance()

    self.comTextName = self:FindChildComponent(self._gameObject,'Text_name','Text')
    self.comTextLimit = self:FindChildComponent(self._gameObject,'Limit/Text','Text')
    self.comBtnBuy = self:FindChildComponent(self._gameObject,'Button_buy','DRButton')

    if self.comBtnBuy then 
        self:AddButtonClickListener(self.comBtnBuy, function()
            self:FuncCallBack()
        end );
    end
    self.objCostMoneyImg = self:FindChild(self._gameObject,'Button_buy/Cost/Money_node')

    self.comTextPrice = self:FindChildComponent(self._gameObject,'Button_buy/Cost/Text_price','Text')
    self.comTextPricePrevious = self:FindChildComponent(self._gameObject,'Button_buy/Cost/Text_price_previous','Text')
    self.objImgPricePrevious = self:FindChild(self._gameObject,'Button_buy/Cost/Text_price_previous/Image')

    self.objLimit = self:FindChild(self._gameObject,'Limit')
    self.comTextLimit = self:FindChildComponent(self._gameObject,'Limit/Text','Text')
    self.objItemIcon = self:FindChild(self._gameObject,'ItemIconUI')

    
    self.objImage_none = self:FindChild(self._gameObject,'Image_none')
    self.objImgMarkFree = self:FindChild(self._gameObject,'Mark/Free')
    self.objImgMarkDiscount = self:FindChild(self._gameObject,'Mark/Discount')
    self.comTextMarkDiscount = self:FindChildComponent(self._gameObject,'Mark/Discount/Text','Text')
end
-- dataMallItem
-- "iNeedUnlockID":-1
-- "uiItemID":1601
-- "iSort":3
-- "iCanBuyCount":0
-- "iPrice":100
-- "iDiscount":100
-- "iFinalPrice":100
-- "iMaxBuyNumsPeriod":0
-- "iNeedUnlockType":-1
-- "uiMoneyType":1
-- "iType":10
-- "iMaxBuyNums":10
-- "uiShopID":10090003
-- "iRemainTime":0
-- "uiFlag":2
-- "uiProperty":0
function MallItemUI:SetMallItem(dataMallItem)
    self.dataMallItem = dataMallItem

    self.TBdata = TableDataManager:GetInstance():GetTableData("Rack",dataMallItem.uiShopID)
    self.comTextName.text = self.TBdata.ItemName


    local dataTypeItem = self.ItemDataManager:GetItemTypeDataByTypeID(dataMallItem.uiItemID)
    self.comTextName.color = getRankColor(dataTypeItem.Rank)

    self.ItemIconUI:UpdateUIWithItemTypeData(self.objItemIcon, dataTypeItem)
    self.ItemIconUI:SetItemNum(self.objItemIcon, '')

    local strLimitText = string.format( "%s%d/%d",shopBuyLimitResetTypeRevert[dataMallItem.iMaxBuyNumsPeriod],dataMallItem.iCanBuyCount,dataMallItem.iMaxBuyNums )
    self.comTextLimit.text = strLimitText

    self.objImage_none:SetActive(dataMallItem.iCanBuyCount == 0)
    self.comBtnBuy.gameObject:SetActive(dataMallItem.iCanBuyCount ~= 0)

    self:SetMoneyType(dataMallItem.uiMoneyType)
    self.iFinalPrice = dataMallItem.iFinalPrice

    self.comTextPrice.text = dataMallItem.iFinalPrice
    if dataMallItem.iFinalPrice == dataMallItem.iPrice then 
        self.comTextPricePrevious.gameObject:SetActive(false)
        if dataMallItem.iFinalPrice == 0 then 
            self.objImgMarkFree:SetActive(true)
        else
            self.objImgMarkFree:SetActive(false)
        end 
        self.objImgMarkDiscount:SetActive(false)
    else 
        self.comTextPricePrevious.gameObject:SetActive(true)
        self.comTextPricePrevious.text = dataMallItem.iPrice 
        if dataMallItem.iFinalPrice == 0 then 
            self.objImgMarkFree:SetActive(true)
            self.objImgMarkDiscount:SetActive(false)
        else
            self.objImgMarkFree:SetActive(false)
            self.objImgMarkDiscount:SetActive(true)
            self.comTextMarkDiscount.text = string.format( "%d折",math.floor( dataMallItem.iFinalPrice * 10 /dataMallItem.iPrice )  )
        end 
    end
end
function MallItemUI:SetMoneyType(eType)
    local strType = MAP_MONEYTYPE_2_STROBJ[eType]
    for index=1,self.objCostMoneyImg.transform.childCount do 
        local transChild = self.objCostMoneyImg.transform:GetChild(index - 1)
        if transChild then 
            transChild.gameObject:SetActive(transChild.gameObject.name == strType)
        end 
    end 

    self.strMoneyType = MAP_MONEYTYPE_2_STRNAME[eType] or ''
end
function MallItemUI:SetMoneyNum(iPrice)
    self.objImgMarkFree:SetActive(false)
    self.objImgMarkDiscount:SetActive(false)
    self.comTextPrice.text = iPrice
    self.iFinalPrice = iPrice
end
function MallItemUI:SetMoneyByItemid(iItemID)
    self:SetMoneyType(MAP_MONEYTYPE_2_STROBJ[RackItemMoneyType.RIMT_TREASUREBOOK])
    local MartirialData = self.ItemDataManager:GetItemTypeDataByTypeID(iItemID)
    local comImgItem_icon =  self:FindChildComponent(self.objCostMoneyImg,'Image_HuoDong',DRCSRef_Type.Image)
    comImgItem_icon.gameObject:SetActive(true)
    self:SetSpriteAsync(MartirialData.Icon,comImgItem_icon)

    self.strMoneyType = GetLanguageByID(MartirialData.NameID)

end
function MallItemUI:SetCallBackFunc(func)
    self.funcCallBack = func
end

function MallItemUI:FuncCallBack()
    
    if not self.funcCallBack then
        return 
    end  
    if self.iFinalPrice and self.iFinalPrice > 0 then 
        OpenWindowImmediately(
            "GeneralBoxUI",
            {
                GeneralBoxType.COMMON_TIP,
                string.format('是否花费%d%s购买礼包',self.iFinalPrice,self.strMoneyType),
                function()
                    if self.strMoneyType == '金锭' then 
                        PlayerSetDataManager:GetInstance():RequestSpendGold(
                            self.iFinalPrice,
                            function()
                                self.funcCallBack()
                            end
                        )
                    elseif self.strMoneyType == '银锭' then 
                        PlayerSetDataManager:GetInstance():RequestSpendSilver(
                            self.iFinalPrice,
                            function()
                                self.funcCallBack()
                            end
                        )
                    else
                        self.funcCallBack()
                    end 
                end
            }
        )
    else
        self.funcCallBack()
    end 

end

function MallItemUI:RefreshUI(info)
    if not info then return end
    
end


function MallItemUI:OnDestroy(info)    
    self.ItemIconUI:Close()
end
return MallItemUI