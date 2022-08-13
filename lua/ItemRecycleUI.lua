ItemRecycleUI = class("ItemRecycleUI",BaseWindow)
local BackpackUIComNew = require 'UI/Role/BackpackNewUI'

ItemRecycleUI.classToType = {
    {
        ['text'] = "全部",
        ['types'] = {
            ItemTypeDetail.ItemType_Null,
        }
    },
    --[[{
        ['text'] = "酒馆",
        ['types'] = {
            ItemTypeDetail.ItemType_Pub,
        }
    },]]
    {
        ['text'] = "装备",
        ['types'] = {
            ItemTypeDetail.ItemType_Equipment,
        }
    },
    {
        ['text'] = "消耗",
        ['types'] = {
            ItemTypeDetail.ItemType_Consume,
        }
    },
    {
        ['text'] = "武学",
        ['types'] = {
            ItemTypeDetail.ItemType_Book,
        }
    },
    {
        ['text'] = "材料",
        ['types'] = {
            ItemTypeDetail.ItemType_Material,
        }
	},
	--[[
    {
        ['text'] = "任务",
        ['types'] = {
            ItemTypeDetail.ItemType_Task,
        }
    }]]
}

local meridianTips = {
	isSkew = true,
	movePositions = {
		x = 0,
		y = -80
	},
	title = '经脉经验',
	content = '经脉经验用于在经脉系统中提升经脉等级，永久提升全队能力'
}

function ItemRecycleUI:Create()
	local obj = LoadPrefabAndInit("TownUI/ItemRecycleUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ItemRecycleUI:OnPressESCKey()
	if self.btnExit and not IsWindowOpen("ShowAllChooseGoodsUI") and not IsWindowOpen("BatchChooseUI")  then
		self.btnExit.onClick:Invoke()
	end
end

function ItemRecycleUI:Init()
	-- 批量选择
	self.objBtnBatchChoose = self:FindChild(self._gameObject, "BatchChoose")
    self.btnBatchChoose = self.objBtnBatchChoose:GetComponent("Button")
    self:AddButtonClickListener(self.btnBatchChoose, function()
        self:OpenBatchChoose()
    end)

    -- 右侧面板
    self.objDetail = self:FindChild(self._gameObject, "Detail")
    self.objDetailTitle = self:FindChild(self.objDetail, "Title")
    self.textItemTitle = self.objDetailTitle:GetComponent("Text")
    self.objDetailTips = self:FindChild(self.objDetail, "Tips")
    self.textDetailContent = self:FindChildComponent(self.objDetailTips, "Viewport/Content/Content", "Text")
    self.objDetailHave = self:FindChild(self.objDetail, "Have")
    self.textHave = self:FindChildComponent(self.objDetailHave,"Value","Text")
	self.comTextMeridians = self:FindChildComponent(self.objDetail,"Meridians/Text","Text")
	self.comLuaUIActionMeridians = self:FindChildComponent(self.objDetail,"Meridians/DRButton","LuaUIAction")
	if self.comTextMeridians then
		self.comTextMeridians.text = MeridiansDataManager:GetInstance():GetCurTotalExp() or 0
	else	
		derror("comTextMeridians not get")
	end
	if self.comLuaUIActionMeridians then
		self.comLuaUIActionMeridians:SetPointerEnterAction(function()
			OpenWindowImmediately("TipsPopUI", meridianTips);
		end)
		self.comLuaUIActionMeridians:SetPointerExitAction(function()
			RemoveWindowImmediately("TipsPopUI")
		end)
	else
		derror("comLuaUIActionMeridians not get")
	end
    -- 按钮区域
	self.objBtns = self:FindChild(self.objDetail, "Btns")
    self.textNumber = self:FindChildComponent(self.objBtns,"Number/Image/Text","Text")
	self.comNumberBtn = self:FindChildComponent(self.objBtns,"Number/Image/Text","Button")
	self.comNumberInputField = self:FindChildComponent(self.objBtns,"Number/Image/InputField","InputField")

	local AddButtonClickListener = function(comBtn,func)
        self:AddButtonClickListener(comBtn,func)
    end
    local GetMaxNum = function()
        return self.kItemMgr:GetItemNum(self.curItemID)
    end
    local UpdateUI = function(curNumber,curRemainNum)
		self.curNumber = curNumber
		self.comBackpackUINew:PickItemByID(self.curItemID, curNumber)
        self:UpdateRecBtnState()
    end
    BindInputFieldAndText(AddButtonClickListener,self.comNumberBtn,self.comNumberInputField,self.textNumber,GetMaxNum,UpdateUI,true)


    local btnMinus = self:FindChildComponent(self.objBtns,"Number/Min","Button")
	self:AddButtonClickListener(btnMinus, function() 
		self:OperateNumSelector(-1)
	end)
    local btnAdd = self:FindChildComponent(self.objBtns,"Number/Add","Button")
	self:AddButtonClickListener(btnAdd, function()
		self:OperateNumSelector(1)
	end)
    local btnAll = self:FindChildComponent(self.objBtns,"Number/All","Button")
	self:AddButtonClickListener(btnAll, function() 
		self:OperateNumSelector(0)
	end)
    self.objRecButton = self:FindChild(self.objBtns,"Recycle")
    self.comImageBuyButton = self.objRecButton:GetComponent("Image")
    self.btnBuy = self.objRecButton:GetComponent("Button")
	self:AddButtonClickListener(self.btnBuy, function()
		self:OnClickItemRecBtn()
	end)
	self.textRecBtnExp = self:FindChildComponent(self.objRecButton,"Number","Text")

	-- 周目回收限制
    self.objRecLimit = self:FindChild(self._gameObject, 'RecLimit')
	self.objRecLimitUpBtn = self:FindChild(self.objRecLimit, 'Button')
	self.textRecLimit = self:FindChildComponent(self.objRecLimit, 'Text', 'Text')
    local btnRecLimitUp = self.objRecLimitUpBtn:GetComponent('Button')
    self:AddButtonClickListener(btnRecLimitUp, function()
        self:OnClickRecLimitUp()
	end)
	self.objRecLimit:SetActive(false)
	self:UpdateItemRecLimitMsg(MeridiansDataManager:GetInstance():GetWeekRecycleExp())
	
	-- 背包
	self.objBackpack = self:FindChild(self._gameObject, "Backpack")
	self.comBackpackUINew = BackpackUIComNew.new({
        ['objBind'] = self.objBackpack,  -- 背包实例绑定的ui节点
        ['navData'] = self.classToType,  -- 导航栏数据
        ['RowCount'] = 3,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 6,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = true,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)  -- 点击ItemInfo组件的回调
            self:OnClickPackItemInfo(obj, itemID)
        end,
        ['funcOnClickItemIcon'] = function(obj, itemID)  -- 点击ItemIcon组件的回调
            self:OnClickPackItemIcon(obj, itemID)
		end,
		['careEvent'] = {
			{
				['eventName'] = "UPDATE_ITEM_LOCK_STATE",  -- 事件名称
				['callback'] = function(kBackPack)  -- 事件回调
					if not kBackPack  then
						return
					end
					kBackPack:ShowRefreshPack()
				end,
			}
		}
	})
	self.comBackpackUINew:SetSortButton(true)

	-- 注册监听
    self:AddEventListener("UPDATE_STORAGE_ITEM",function() 
        self:RefreshUI()
	end)
	self:AddEventListener("UPDATE_MERIDIANS_EXP",function(info)
		if not info then
			return
		end
		--LuaPanda.BP()
		self:UpdateItemRecLimitMsg(info.dwlParam)
	end)
	self:AddEventListener("UPDATE_MERIDIANS_OPENLIMIT",function(info)
		if not info then
			return
		end
		self:UpdateItemRecLimitMsg(0)
    end)
	
	-- 其他数据
	self.kItemMgr = ItemDataManager:GetInstance()
	self.kStorageMgr = StorageDataManager:GetInstance()
	self.matGray = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))

	self.btnStorage = self:FindChildComponent(self._gameObject, 'Tab_box/Toggle_warehouse/Toggle', 'Button')
	if self.btnStorage then
		self:AddButtonClickListener(self.btnStorage, function() 
			OpenWindowImmediately('StorageUI')
			RemoveWindowImmediately("ItemRecycleUI")
		end)
	end

	self.btnExit = self:FindChildComponent(self._gameObject, "frame/Btn_exit", "Button")
    if self.btnExit then
        self:AddButtonClickListener(self.btnExit, function()
            RemoveWindowImmediately("ItemRecycleUI",false)
        end)
    end
end

function ItemRecycleUI:Update()
    self.comBackpackUINew:Update()
end

-- 刷新物品节点数量信息
function ItemRecycleUI:UpdateItemNodeNum(objNode, kItemData, kPackInst)
	if not (objNode and kItemData and kPackInst) then
		return
	end
	local iItemNum = kItemData.uiItemNum or 0
	local iSelectNum = kPackInst:GetPickedItemCount(kItemData.uiID) or 0
	if iSelectNum > iItemNum then
		iSelectNum = iItemNum
	end
	local comNum = self:FindChildComponent(objNode, "Button/ItemIconUI/Num", "Text")
	comNum.text = string.format("%d/%d", iSelectNum, iItemNum)
	local objCategory = self:FindChild(objNode, "Category")
	objCategory:SetActive(false)
	local objPrice = self:FindChild(objNode, "Price")
	local textPrice = self:FindChildComponent(objPrice, "Text", "Text")
	textPrice.text = self:GetSingleItemMeridiansExp(kItemData.uiID) or 0
	self:FindChild(objPrice, "ImageMeridians"):SetActive(true)
	self:FindChild(objPrice, "ImageYingDing"):SetActive(false)
	self:FindChild(objPrice, "ImageTongBi"):SetActive(false)
	objPrice:SetActive(true)
end

function ItemRecycleUI:RefreshUI()
	--LuaPanda.BP()
    self.auiItemIDList = {}
	local auiStorageItems = self.kStorageMgr:GetAllItemUIDs() or {}
	local itemMgr = ItemDataManager:GetInstance()
	local equalFunc = itemMgr.IsTypeEqual
	for index,value in pairs(auiStorageItems) do
		if (value>0) then
			local itemData = self.kStorageMgr:GetItemTypeData(value)
			if (itemData) then
				if (equalFunc(self,itemData.ItemType,ItemTypeDetail.ItemType_Equipment) or
				equalFunc(self,itemData.ItemType,ItemTypeDetail.ItemType_Consume) or 
				equalFunc(self,itemData.ItemType,ItemTypeDetail.ItemType_Book) or 
				equalFunc(self,itemData.ItemType,ItemTypeDetail.ItemType_Material)
				) then
					table.insert(self.auiItemIDList,value)
				end
			else
				dwarning("GetItemTypeData("..value..")".."为nil")
			end
		end
	end

	if self.comBackpackUINew:GetPackSize() == 0 then
        self.comBackpackUINew:ShowPackByInstIDArray(self.auiItemIDList, nil, {
			['funcSort'] = self:GetBackPackSortFunc(),
			['funcLateHandleItemNode'] = function(objNode, kItemData, kPackInst)
				self:UpdateItemNodeNum(objNode, kItemData, kPackInst)
			end
		})
    else
        self.comBackpackUINew:ShowRefreshAndResetPackByInstIDArray(self.auiItemIDList)
    end
	-- 选中空物品状态
	self:OnClickPackItemInfo()

	if self.comTextMeridians then
		self.comTextMeridians.text = MeridiansDataManager:GetInstance():GetCurTotalExp() or 0
	else	
		derror("comTextMeridians not get")
	end
end

function ItemRecycleUI:GetBackPackSortFunc()
    if not self.funcBackPackSort then
        local TBItem = TableDataManager:GetInstance():GetTable("Item")
        self.funcBackPackSort = function(a, b)
            local typeDataA = TBItem[a.uiTypeID]
            local typeDataB = TBItem[b.uiTypeID]
            if typeDataA and typeDataB then
                if typeDataA.Rank == typeDataB.Rank then
                    return typeDataA.BaseID > typeDataB.BaseID
                else
                    return typeDataA.Rank > typeDataB.Rank
                end
            else
                return false
            end
        end
    end
    return self.funcBackPackSort
end

-- 刷新ui界面
function ItemRecycleUI:RefreshUIState()
	self:RefreshTips()
	self:RefreshNums()
	self:OperateNumSelector()
	self:UpdateRecBtnState()
end

function ItemRecycleUI:OnClickPackItemInfo(obj, itemID)
	if (itemID ~= nil) and (itemID > 0) then
		local num = self.kStorageMgr:GetItemNum(itemID);
		if self.comBackpackUINew:IsItemPicked(itemID) then
			self.comBackpackUINew:UnPickItemByID(itemID, num)
		elseif not self.kItemMgr:GetItemLockState(itemID) then
			self.comBackpackUINew:PickItemByID(itemID, num)
		end
		self.curItemID = itemID
    end
	if self.textNumber and self.comNumberInputField then
		self.textNumber.gameObject:SetActive(true)
		self.comNumberInputField.gameObject:SetActive(false)
	end
    self:RefreshUIState()
end

function ItemRecycleUI:OnClickPackItemIcon(obj, itemID)
	if not itemID then 
		return
	end
	local tips = TipsDataManager:GetItemTips(itemID)
	local btns = {}
	-- 带有锁定特性的物品不显示任何按钮
	if not self.kItemLockFeatureCache then
		self.kItemLockFeatureCache = {}
	end
	if self.kItemLockFeatureCache[itemID] == nil then
		self.kItemLockFeatureCache[itemID] = self.kItemMgr:ItemHasLockFeature(itemID)
	end
	if not self.kItemLockFeatureCache[itemID] then
		local btnName = nil
		local btnFunc = nil
		if self.kItemMgr:GetItemLockState(itemID) then
			btnName = "解锁"
			btnFunc = function()
				self.kItemMgr:SetItemLockState(itemID, false)
			end
		else
			btnName = "锁定"
			btnFunc = function()
				if self.comBackpackUINew:IsItemPicked(itemID) then
					self.comBackpackUINew:UnPickItemByID(itemID)
					self:RefreshUIState()
				end
				self.kItemMgr:SetItemLockState(itemID, true)
			end

			local strChooseBtn = "选中"
			if self.comBackpackUINew:IsItemPicked(itemID) then
				strChooseBtn = "取消"
			end
			btns[#btns + 1] = {
				['name'] = strChooseBtn,
				['func'] = function()
					self:OnClickPackItemInfo(nil, itemID)
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
end

-- 获取仓库物品的数量
function ItemRecycleUI:GetItemNum(itemID)
    return self.kStorageMgr:GetItemNum(itemID) or 0
end

-- 更新回收按钮的状态
function ItemRecycleUI:UpdateRecBtnState()
	local iSumExp, bIsActive = self:GetAllMeridiansExp()
	self.textRecBtnExp.text = iSumExp or 0
    self.btnBuy.interactable = self.comBackpackUINew:HasItemPicked() == true
    if self.btnBuy.interactable then
        self.comImageBuyButton.material = nil
    else
        self.comImageBuyButton.material = self.matGray
    end
end

-- 获取单个物品静脉经验数
function ItemRecycleUI:GetSingleItemMeridiansExp(itemID)
	if not itemID then
		return 0
	end
	--[[
	local TBItem = TableDataManager:GetInstance():GetTable("Item")
	if (TBItem~= nil and TBItem[itemID]~=nil and TBItem[itemID].RecycleMerExp~="-") then
		return TBItem[itemID].RecycleMerExp
	end
	return 0]]
	-- 生成一张 [物品类型][物品品质] => 回收经验 的查找表
	if not self.kItemRecExpLookUp then
		local TBItemRecycleExp = TableDataManager:GetInstance():GetTable("ItemRecycleExp")
		local TBItemType = TableDataManager:GetInstance():GetTable("ItemType")
		local kItemRecExpLookUp = {}
		local dealType = function(eType, kRecData)
			if not (eType and kRecData 
			and kRecData.ItemRank and kRecData.RecycleExp) then
				return
			end
			if not kItemRecExpLookUp[eType] then
				kItemRecExpLookUp[eType] = {}
			end
			for index, eRank in ipairs(kRecData.ItemRank) do
				kItemRecExpLookUp[eType][eRank] = kRecData.RecycleExp[index] or 0
            end
		end
		local eRecType = nil
		local kTypeData = nil
		for index, kRecData in pairs(TBItemRecycleExp) do
			eRecType = kRecData.RecycleType
			dealType(eRecType, kRecData)
			-- 处理子类
			local kTypeData = TBItemType[eRecType]
			if kTypeData and kTypeData.ChildItemType and next(kTypeData.ChildItemType) then
				for _, eType in pairs(kTypeData.ChildItemType) do
					dealType(eType, kRecData)
				end
			end
		end
		self.kItemRecExpLookUp = kItemRecExpLookUp
	end

	local kItemBaseData = self.kStorageMgr:GetItemTypeData(itemID)
	local eItemType = kItemBaseData.ItemType
	if not (eItemType and self.kItemRecExpLookUp[eItemType]) then
		return 0
	end
	local eItemRank = kItemBaseData.Rank
	if not eItemRank then
		return 0
	end
	return self.kItemRecExpLookUp[eItemType][eItemRank] or 0
end

-- 获取当前已选物品的回收经脉数
function ItemRecycleUI:GetAllMeridiansExp()
	--LuaPanda.BP()
	if not self.curItemID then
		return 0, false
	end
	local aiPickList, aiNumList = self.comBackpackUINew:GetPickedItemIDArray()
	if not (aiPickList and aiNumList) then
		return 0, false
	end
    local iSingleExp = 0
    local iSumExp = 0
    local iNum = 0
    for index, itemID in pairs(aiPickList) do
        iNum = aiNumList[index] or 0
        iSingleExp = self:GetSingleItemMeridiansExp(itemID)
        iSumExp = iSumExp + iSingleExp * iNum
    end
	local bActive = iSumExp ~= 0
	self.iCurSumRecExp = iSumExp
    return iSumExp, bActive
end

-- 显示物品信息
function ItemRecycleUI:RefreshTips()
	self.objDetailTitle:SetActive(false)
	self.objDetailTips:SetActive(false)
	if not self.curItemID then
		return
	end
	local itemID = self.curItemID
    local itemTypeData = self.kItemMgr:GetItemTypeData(itemID)
	if not itemTypeData then 
		return 
	end
	self.objDetailTitle:SetActive(true)
	self.objDetailTips:SetActive(true)
    local tips = TipsDataManager:GetInstance():GetItemTips(itemID)
    self.textItemTitle.text = tostring(tips.title)
    self.textItemTitle.color = getRankColor(itemTypeData.Rank)
    self.textDetailContent.text = tips.content
end

function ItemRecycleUI:RefreshNums()
	self.objDetailHave:SetActive(false)
	if not self.curItemID then
		return
	end
    local iHave = 0
    local itemTypeID = self.kItemMgr:GetItemTypeID(self.curItemID)
	if itemTypeID and (itemTypeID > 0) then
		iHave = self.kStorageMgr:GetBaseID2InstItemNum(itemTypeID) or 0
	end
	self.textHave.text = string.format("拥有: %d", iHave or 0)
	self.objDetailHave:SetActive(true)
end

-- 操作数量选择器
function ItemRecycleUI:OperateNumSelector(value)
	if not self.curItemID then
		self.textNumber.text = "0/0"
		self.comNumberInputField.text = "0"
		return
	elseif self.comNumberInputField.gameObject.activeSelf then
		local curRemainNum = self.kItemMgr:GetItemNum(self.curItemID)
        
        if not self.curNumber then
            self.curNumber = self.comBackpackUINew:GetPickedItemCount(self.curItemID) or 0
        end
		if value then
        	self.curNumber = self.curNumber + value
			if value == 0 then
				self.curNumber = curRemainNum
			end
		end
        if self.curNumber <= 0 then
            self.curNumber = 0
        end
        if self.curNumber >= curRemainNum then
            self.curNumber = curRemainNum 
        end
		self.comBackpackUINew:PickItemByID(self.curItemID, self.curNumber)
        self.comNumberInputField.text = tostring(self.curNumber)
        self:UpdateRecBtnState() 
	else
		-- 正数: 增加, 负数: 减少, 零: 全部
		local curNum = 0
		local oriNum = self.comBackpackUINew:GetPickedItemCount(self.curItemID) or 0
		local curRemainNum = self.kItemMgr:GetItemNum(self.curItemID)
		local bNeedRepick = true
		if not value then
			curNum = oriNum
			bNeedRepick = false
		elseif value == 0 then
			curNum = curRemainNum
		else
			curNum = oriNum + value
		end
		if curNum > curRemainNum then
			curNum = curRemainNum
		elseif curNum <= 0 then
			curNum = 0
		end
		if bNeedRepick then
			self.comBackpackUINew:PickItemByID(self.curItemID, curNum)
		end
		self.textNumber.text = string.format("%d/%d", curNum, curRemainNum)
		self:UpdateRecBtnState()
	end
end

function ItemRecycleUI:OnClickItemRecBtn()
	if not self.comBackpackUINew:HasItemPicked() then 
		return 
	end

	local aiItemIDList, aiCount = self.comBackpackUINew:GetPickedItemIDArray()
    if not (aiItemIDList and next(aiItemIDList) and aiCount) then
        return
	end

	-- 获取回收提示
    local kMeridiansMgr = MeridiansDataManager:GetInstance()
	local kCurGrade = kMeridiansMgr:GetWeekLimitGrade()
	if not kCurGrade then
		return
	end
	--本周回收已获得经脉经验
	local iWeekRecycleExp = kMeridiansMgr:GetWeekRecycleExp() or 0
	--选中获得的经脉经验
    local iCurSumRecExp = self.iCurSumRecExp or 0
	local iWeekSumExp = iWeekRecycleExp + iCurSumRecExp
	--本周回收升级次数
	local iWeekLimitNum = MeridiansDataManager:GetInstance():GetWeekLimitNum()
	--本周回收上限
	local iExpLimit = (kCurGrade.ExpLimit * (1 + iWeekLimitNum)) or 0
	--本周剩余可回收经脉经验
	local iSubExp = iExpLimit - iWeekRecycleExp
    iSubExp = iSubExp > 0 and iSubExp or 0
    local strTips = ""
	strTips = '回收选中道具,获得' .. iCurSumRecExp .. '点经脉经验,是否确定?'
	-- 回调
    local boxCallback = function()
        -- 检查物品合法性, 这里原本用接口返回值true时return, 但是用户在使用非法物品时服务器也需要知道并LogWarning
        -- 所以这里调用这个接口只用作出一个警告框, 但是允许继续上行, 交给服务器二次判断并警告
		local aiItemIDList, aiCount = self.comBackpackUINew:GetPickedItemIDArray()
		self.kStorageMgr:IllegalItemCheckWithUID(aiItemIDList, false)

		local akItemList = {}
		local iListCount = 1
		for index, itemID in ipairs(aiItemIDList) do
			if not akItemList[iListCount] then
				akItemList[iListCount] = {}
			elseif #akItemList[iListCount] >= SSD_MAX_OPR_PLAT_ITEM_NUM then
				iListCount = iListCount + 1
				akItemList[iListCount] = {}
			end
			akItemList[iListCount][#akItemList[iListCount] + 1] = {
				['uiItemID'] = itemID,
				['uiItemNum'] = aiCount[index] or 0,
			}
		end
		SystemUICall:GetInstance():Toast("回收中",false)
		-- 分批发送
		for index, list in ipairs(akItemList) do
			local iCount = #list
			list[0] = list[iCount]
			list[iCount] = nil
			globalTimer:AddTimer(100*math.random(1,#akItemList),function()
				SendStorageRecycle(iCount, list)
			end)
		end
		self.comBackpackUINew:UnPickAllItems()
		self.curItemID = nil
	end
	local removeItemCallback = function(itemID,num)
		self.comBackpackUINew:UnPickItemByID(itemID, num)
		self:RefreshUIState()
	end
	local getNewWindowTips = function()
		--local iCurSumRecExp = self.iCurSumRecExp or 0
		iCurSumRecExp = self.iCurSumRecExp or 0
		iWeekSumExp = iWeekRecycleExp + iCurSumRecExp
		--if (iWeekSumExp> iExpLimit) then 
		if false then
			strTips = '本周通过回收物品获得经验已达上限,本次只获得' .. iSubExp .. '点经脉经验,是否继续?'
		elseif iWeekSumExp <= iExpLimit then
			strTips = '以下物品将被回收并转换为' .. iCurSumRecExp .. '点经脉经验,是否确定?'
		end
		return strTips
	end
	-- 多个物品 或 当前物品需要二次确认则
	if (#aiCount > 1 or (#aiCount == 1 and self.kItemMgr:ItemUseNeedCheck(aiItemIDList[1]))) then
		if iWeekSumExp <= iExpLimit then
			strTips = '以下物品将被回收并转换为' .. iCurSumRecExp .. '点经脉经验,是否确定?'
		end
		data = {
			['goodsList'] = aiItemIDList,
			['goodsNumList'] = aiCount,
			['windowTitle'] = "物品回收",
			['windowTips'] = strTips,
			['commitCallback'] = boxCallback,
			['removeItemCallback'] = removeItemCallback,
			['getNewWindowTips'] = getNewWindowTips
		}
		OpenWindowImmediately("ShowAllChooseGoodsUI",data)
	else
		OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
			["title"] = "物品回收",
			["text"] = strTips,
		}, boxCallback})
	end


end

-- 打开多选界面
function ItemRecycleUI:OpenBatchChoose()
    -- 隐藏状态栏返回键
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetBackBtnState(false)
    end
    -- 打开多选
    OpenWindowByQueue("BatchChooseUI", {
        ['callback'] = function(res, eBatchType)
            local win = GetUIWindow("ItemRecycleUI")
            if not win then
                return
            end
            win:OnBatchChooseOver(res, eBatchType)
		end,
		['onClose'] = function()
			-- 重新打开状态栏返回键
			local windowBarUI = GetUIWindow("WindowBarUI")
			if not windowBarUI then
				return
			end
			windowBarUI:SetBackBtnState(false)
		end
    })
end

-- 批量选中回调
function ItemRecycleUI:OnBatchChooseOver(res, eBatchType)
    -- 先取消选中所有物品
	self.comBackpackUINew:UnPickAllItems()
	local akCurShowItems = self.comBackpackUINew:GetCurShowItemsArray()
    if not (res and next(res) and akCurShowItems) then 
        self:UpdateRecBtnState()
        return 
    end
    local itemTypeData = nil
    local enumItemType = nil
    local bIsTreasure = false
	local rank = nil
	local iLastPickedItemID = nil  -- 最后一个选中的物品
	-- 多选时只操纵当前页签下的数据
	for index, kInstItem in ipairs(akCurShowItems) do
		local itemID = kInstItem.uiID or 0
		if (itemID > 0) and ((not self.kItemMgr:GetItemLockState(itemID)) or eBatchType == BATCH_CHOOSE_TYPE.UNLOCK )then
			itemTypeData = self.kItemMgr:GetItemTypeData(itemID)
			rank = itemTypeData.Rank
			-- 精良暗金、优秀暗金 跟暗金一起被多选选中
			if (rank == 8 or rank == 9) then
				rank = 7
			end
			enumItemType = itemTypeData.ItemType
			-- 暗器. 医药, 算作装备
			if (enumItemType == ItemTypeDetail.ItemType_HiddenWeapon)
			or (enumItemType == ItemTypeDetail.ItemType_Leechcraft) then
				enumItemType = ItemTypeDetail.ItemType_Equipment
			end
			if res[enumItemType] and (res[enumItemType][rank] == true) then
				-- 选中物品
				if eBatchType == BATCH_CHOOSE_TYPE.CHOOSE then
					self.comBackpackUINew:PickItemByID(itemID, self:GetItemNum(itemID), false)
					iLastPickedItemID = itemID
				elseif eBatchType == BATCH_CHOOSE_TYPE.LOCK then
					if self.comBackpackUINew:IsItemPicked(itemID) then
						self.comBackpackUINew:UnPickItemByID(itemID)
					end
					self.kItemMgr:SetItemLockState(itemID, true)
					iLastPickedItemID = itemID
				elseif eBatchType == BATCH_CHOOSE_TYPE.UNLOCK then
					if self.kItemMgr:GetItemLockState(itemID) then
						self.kItemMgr:SetItemLockState(itemID, false)
					end
					iLastPickedItemID = itemID
				end
			end
		end
	end
	if iLastPickedItemID then
		self.curItemID = iLastPickedItemID
		self:RefreshUIState()
	else
		self:UpdateRecBtnState()
	end
end

-- 更新周目回收上限信息
function ItemRecycleUI:UpdateItemRecLimitMsg(iRecycleExp)
    if not iRecycleExp then
        return
	end
	if (self.haveRecycleExp and iRecycleExp == 0) then
		iRecycleExp = self.haveRecycleExp
	end
	
	local kCurGrade = MeridiansDataManager:GetInstance():GetWeekLimitGrade()
	--本周回收已升级次数
	local iWeekLimitNum = MeridiansDataManager:GetInstance():GetWeekLimitNum()
	if not kCurGrade then
		return
	end
	local iExpLimit = (kCurGrade.ExpLimit * (1 + iWeekLimitNum)) or 0
	
	self.textRecLimit.text = string.format('本周回收物品已获得经脉经验%d点,上限%d点', iRecycleExp, iExpLimit)
	if iRecycleExp >= iExpLimit * 0.8 or iWeekLimitNum > 0 then
		--self.objRecLimit:SetActive(true)
		--self.objRecLimitUpBtn:SetActive(true)
		local btnRecLimitUp = self.objRecLimitUpBtn:GetComponent('Button')
		--if (iWeekLimitNum >= kCurGrade.BuyNum) then
		if false then
			btnRecLimitUp.enabled = false
			setUIGray(self.objRecLimitUpBtn:GetComponent('Image'), true)
		else
			btnRecLimitUp.enabled = true
			setUIGray(self.objRecLimitUpBtn:GetComponent('Image'), false)
		end

	else
		self.objRecLimit:SetActive(false)
		self.objRecLimitUpBtn:SetActive(false)
	end

	self.haveRecycleExp = iRecycleExp
end

function ItemRecycleUI:OnClickRecLimitUp()
    local kCurGrade = MeridiansDataManager:GetInstance():GetWeekLimitGrade()
	local iWeekLimitNum = MeridiansDataManager:GetInstance():GetWeekLimitNum()
	if not (kCurGrade and iWeekLimitNum) then
		return
	end

	local callback = function ()
		if not kCurGrade.BuyNum then
			return
		end
        if iWeekLimitNum >= kCurGrade.BuyNum then
           SystemUICall:GetInstance():Toast('本周开启次数已超上限')
        else
            PlayerSetDataManager.GetInstance():RequestSpendSilver(kCurGrade.Price,function()
				SendMeridiansOpr(SMOT_BUY_LIMITNUM, 0)
			end)
		end
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
        ["title"] = '物品回收',
		["text"] = string.format("提升%d点经脉经验上限,需消耗%d个银锭!", kCurGrade.ExpLimit or 0, kCurGrade.Price or 0),
    }, callback})
end

function ItemRecycleUI:OnEnable()
    -- OpenWindowBar({
    --     ['windowstr'] = "ItemRecycleUI", 
    --     ['titleName'] = "物品回收",
    --     ['topBtnState'] = {
	-- 		['bMeridians'] = true,
    --     },
    --     ['bSaveToCache'] = true,
    -- })
end

function ItemRecycleUI:OnDisable()
	-- RemoveWindowBar('ItemRecycleUI')
end

function ItemRecycleUI:OnDestroy()
	self.comBackpackUINew:Close()
end

return ItemRecycleUI