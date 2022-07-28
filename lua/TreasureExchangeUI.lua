TreasureExchangeUI = class("TreasureExchangeUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI';

function TreasureExchangeUI:ctor()
    
end

function TreasureExchangeUI:Create()
	local obj = LoadPrefabAndInit("TreasureExchangeUI/TreasureExchangeUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TreasureExchangeUI:Init()
    self.comText_ActiveDate = self:FindChildComponent(self._gameObject,'Root/AD/Date','Text')
    self.comText_ActiveDesc = self:FindChildComponent(self._gameObject,'Root/AD/Desc','Text')

    self.ItemIconUI = ItemIconUI.new()
    self.PlayerSetDataMgr = PlayerSetDataManager:GetInstance()
    self.ActivityHelper = ActivityHelper:GetInstance()
    self.objLayout_ExchangeList = self:FindChild(self._gameObject,'Root/Task_node/Tasks')
    self.objLayout_ExchangeChild = self:FindChild(self._gameObject,'Root/Task_node/TaskChild')
    self.objLayout_ExchangeChild:SetActive(false)


    self.comText_Material1 = self:FindChildComponent(self._gameObject,'Root/Task_node/Item1/Text','Text')
    self.comText_Material2 = self:FindChildComponent(self._gameObject,'Root/Task_node/Item2/Text','Text')

    self.comImg_Material1 = self:FindChildComponent(self._gameObject,'Root/Task_node/Item1/icon','Image')
    self.comImg_Material2 = self:FindChildComponent(self._gameObject,'Root/Task_node/Item2/icon','Image')

    self.comImg_ad = self:FindChildComponent(self._gameObject,'Root/AD/Image','Image')

    self.obj_Btn_Refreash = self:FindChild(self._gameObject,'Root/Task_node/Button')

    self.TB_ActivityTreasureExchangeGroup = TableDataManager:GetInstance():GetTable("ActivityTreasureExchangeGroup") or {}

    self:CommonBind(self.obj_Btn_Refreash,function()
        -- 刷新操作
        local info = {
            icon1 = self.MaterialIcon1,
            Num1 = self.MaterialNum1,
            icon2 = self.MaterialIcon2,
            Num2 = self.MaterialNum2,
            iActivityID = self.iActivityID,
        }
        OpenWindowImmediately('TreasureExchangePopWindowUI',info)

    end )

    self:AddEventListener("UpdataTreasureExchange", function(info)
		self:OnCallBackFunction()
    end)

end
function TreasureExchangeUI:OnCallBackFunction()
    -- if self.callback_Funcs then 
    --     for i,func in pairs(self.callback_Funcs) do
    --         func()
    --     end 
    -- end 
    self:RefreshUI()
end 
function TreasureExchangeUI:RefreshUI()
    self.TreasureExchangeData = self.ActivityHelper:GetActiveTreasureExchange()
    if not self.TreasureExchangeData then 
        RemoveWindowImmediately('TreasureExchangeUI')
        return 
    end 
    self.TableData = self.TreasureExchangeData.tabledata
    self.MaterialID1 = self.TableData.ParamN[1]
    self.MaterialID2 = self.TableData.ParamN[3]
    self.MaterialNum1 = self.TableData.ParamN[2]
    self.MaterialNum2 = self.TableData.ParamN[4]

    self.MaterialData1 = TableDataManager:GetInstance():GetTableData("Item",self.MaterialID1)
    self.MaterialData2 = TableDataManager:GetInstance():GetTableData("Item",self.MaterialID2)

    self.MaterialIcon1 = self.MaterialData1 and self.MaterialData1.Icon
    self.MaterialIcon2 = self.MaterialData2 and self.MaterialData2.Icon

    self.iActivityID = self.TreasureExchangeData.dwActivityID
    self.callback_Funcs = {}
    self.dataList_ExchangeList = {}
    local func_getindex = function(iIndex)
        for i,v in pairs(self.TB_ActivityTreasureExchangeGroup) do
            if v.BaseID == self.iActivityID and v.Index == iIndex then 
                return v 
            end
        end 
    end
    for iBaseID,ibBought in pairs(self.TreasureExchangeData.iList) do 
        local tempdata = {
            iIndex = iBaseID,
            bBought = ibBought == 1 ,
            tabledata = func_getindex(iBaseID)
        }
        table.insert(self.dataList_ExchangeList , tempdata)
    end 
    table.sort( self.dataList_ExchangeList, function(a,b)
        return a.iIndex < b.iIndex
    end )
    self:RefreshUPInfo()
    self:RefreshExchangeList()
    self:RefreshRefreashInfo()
end
function TreasureExchangeUI:RefreshUPInfo()
    if self.comText_ActiveDate then 
        local SD = self.TableData.StartDate or {}
        local ED = self.TableData.StopDate or {}
        local ST = self.TableData.StartTime or {}
        local ET = self.TableData.StopTime or {}
        local strDataTimewww = string.format( "活动时间：%d月%d日%02d:%02d - %d月%d日%02d:%02d",SD.Month,SD.Day,ST.Hour,ST.Minute,ED.Month,ED.Day,ET.Hour,ET.Minute)
            
        local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(self.TableData.RewardDesc, "(<color=.+>)(.*)</color>")
        strColorTag = strColorTag or ""
        strColorCloseTag = (strColorTag == "") and "" or "</color>"
        self.comText_ActiveDate.text = string.format("%s%s%s", strColorTag, strDataTimewww, strColorCloseTag)
        
        self.comImg_ad.sprite = GetSprite(self.TableData.ActIcon)

        self.comText_ActiveDesc.text = self.TableData.RewardDesc
    end
end 
function TreasureExchangeUI:RefreshRefreashInfo()
    if self.comText_Material1 then 
        local func_callback = function()
            self.comText_Material1.text = self.PlayerSetDataMgr:GetTreasureExchangeValue(1)
            self.comText_Material2.text = self.PlayerSetDataMgr:GetTreasureExchangeValue(2)

            self:SetSpriteAsync( self.MaterialIcon1,self.comImg_Material1)
            self:SetSpriteAsync( self.MaterialIcon2,self.comImg_Material2)
        end 
        func_callback()
        -- table.insert( self.callback_Funcs, func_callback)
    end 
end
function TreasureExchangeUI:RefreshExchangeList()
    if self.objLayout_ExchangeList then 
        RemoveAllChildren(self.objLayout_ExchangeList)
        for i=1,#self.dataList_ExchangeList do 
            local data_Inst = self.dataList_ExchangeList[i]
            local obj_clone = CloneObj(self.objLayout_ExchangeChild,self.objLayout_ExchangeList)

            obj_clone:SetActive(true)
            local data_Excel = data_Inst.tabledata

            local obj_Item_Target = self:FindChild(obj_clone,'ItemIcon1')
            local obj_Item_Material1 = self:FindChild(obj_clone,'ItemIcon2')
            local obj_Item_Material2 = self:FindChild(obj_clone,'ItemIcon3')
            local obj_Text_Num_Material1 = self:FindChildComponent(obj_clone,'ItemIcon2/Text_Num','Text')
            local obj_Text_Num_Material2 = self:FindChildComponent(obj_clone,'ItemIcon3/Text_Num','Text')


            local data_RewardItem = data_Excel and data_Excel.RewardItem and data_Excel.RewardItem and data_Excel.RewardItem[1] or {}
            local data_CostItem1 = data_Excel and data_Excel.CostItem and data_Excel.CostItem and data_Excel.CostItem[1] or {}
            local data_CostItem2 = data_Excel and data_Excel.CostItem and data_Excel.CostItem and data_Excel.CostItem[2] or {}
            if data_RewardItem.ItemId then 
                local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",data_RewardItem.ItemId)
                self.ItemIconUI:UpdateUIWithItemTypeData(obj_Item_Target, itemTypeData)
                local inum = data_RewardItem.ItemNum or 0
                self.ItemIconUI:SetItemNum(obj_Item_Target, inum,inum <= 1)
            end 
            if data_CostItem1.ItemId then 
                local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",data_CostItem1.ItemId)
                self.ItemIconUI:UpdateUIWithItemTypeData(obj_Item_Material1, itemTypeData)
            end 
            if data_CostItem2.ItemId then 
                local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",data_CostItem2.ItemId)
                self.ItemIconUI:UpdateUIWithItemTypeData(obj_Item_Material2, itemTypeData)
            end 

            local obj_Btn_Exchange = self:FindChild(obj_clone,'Button_exchange')
            local combtn = obj_Btn_Exchange:GetComponent('DRButton')
            local combtnText = self:FindChildComponent(obj_Btn_Exchange,'Text','Text')
            local func_callback = function()
                -- 材料数字 刷新
                local iV1
                local iV2 
                local strfOrmat 
                local bCanBuy = true
                iV1 = self.PlayerSetDataMgr:GetTreasureExchangeValue(1)
                iV2 = data_CostItem1.ItemNum or 0
                strfOrmat = iV1 < iV2 and '<color=#bd321f>%d</color>/%d' or '<color=#3d7b2c>%d</color>/%d'
                obj_Text_Num_Material1.text = string.format(strfOrmat,iV1,iV2)
                bCanBuy = bCanBuy and iV1 >= iV2
                iV1 = self.PlayerSetDataMgr:GetTreasureExchangeValue(2)
                iV2 = data_CostItem2.ItemNum or 0
                strfOrmat = iV1 < iV2 and '<color=#bd321f>%d</color>/%d' or '<color=#3d7b2c>%d</color>/%d'
                obj_Text_Num_Material2.text = string.format(strfOrmat,iV1,iV2)
                bCanBuy = bCanBuy and iV1 >= iV2
                -- BTN状态 刷新
                if self.ActivityHelper:GetTreasureExchangeBought(self.iActivityID,data_Inst.iIndex) then 
                    setUIGray(obj_Btn_Exchange:GetComponent('Image'), true)
                    combtn.interactable = false 
                    combtnText.text = '已兑换'
                else 
                    if bCanBuy then 
                        setUIGray(obj_Btn_Exchange:GetComponent('Image'), false)
                        combtn.interactable = true 
                        combtnText.text = '兑换'
                    else
                        setUIGray(obj_Btn_Exchange:GetComponent('Image'), true)
                        combtn.interactable = false 
                        combtnText.text = '材料不足'
                    end 
                end 
            end 
            func_callback()
            -- table.insert( self.callback_Funcs, func_callback)
            self:CommonBind(obj_Btn_Exchange,function()
                -- 兑换行为
                SendActivityOper(SAOT_EVENT, self.iActivityID,SATET_TREASURE_EXCHANGE,data_Inst.iIndex-1)
            end )
        end 
    end 
end 

function TreasureExchangeUI:Update()
    
end

function TreasureExchangeUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "TreasureExchangeUI", 
        ['titleName'] = "秘宝大会",
        ['bSaveToCache'] = true,
    })
end

function TreasureExchangeUI:OnDisable()
    RemoveWindowBar('TreasureExchangeUI')
end

function TreasureExchangeUI:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent('Button')
    local tog = gameObject:GetComponent('Toggle')
    if btn then
        local _callback = function()
            callback(gameObject)
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback)
    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide)
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)
    end
end

function TreasureExchangeUI:OnDestroy()
    self:RemoveEventListener("UpdataTreasureExchange")
    self.ItemIconUI:Close()

end
return TreasureExchangeUI
