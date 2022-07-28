Day3SignInUI = class("Day3SignInUI",BaseWindow)

function Day3SignInUI:ctor()
	self.akItemUIClass = {}
end

function Day3SignInUI:Create()
	local obj = LoadPrefabAndInit("TownUI/Day3SignInUI", UI_UILayer, true)
	if obj then
		self:SetGameObject(obj)
	end
	self.objRoot = self:FindChild(self._gameObject, "Root")
	self.transTarItemSlot = self:FindChild(self.objRoot, "TarItemSlot").transform
	self.textDescName = self:FindChildComponent(self.objRoot, "Desc_name", "Text")
	self.textDescWord = self:FindChildComponent(self.objRoot, "Desc_word", "Text")
	self.ImgRoleImg = self:FindChildComponent(self.objRoot, "RoleImg", "Image")
	self.objItemList = self:FindChild(self.objRoot, "ItemList")
	self.transItemList = self.objItemList.transform
	self.objItemListLabel = self:FindChild(self.objItemList, "Label")
	local btnClose = self:FindChildComponent(self.objRoot, "Close", "Button")
	self:AddButtonClickListener(btnClose, function()
		self:OnClickClose()
	end)

	self.objBtns = self:FindChild(self.objRoot, "Btns")
	self.objBtnGroup1 = self:FindChild(self.objBtns, "1")
	self.objBtnGroup2 = self:FindChild(self.objBtns, "2")
	self.objBtnGroup3 = self:FindChild(self.objBtns, "3")
	self.objBtnGroups = {
		self.objBtnGroup1,
		self.objBtnGroup2,
		self.objBtnGroup3,
	}
	self:InitRootBtnListener()

	self.objWarning = self:FindChild(self._gameObject, "Warning")
	self.objWarning:SetActive(false)
	self.textWarning = self:FindChildComponent(self.objWarning, "Content/Text", "Text")
	self.objWarningItemList = self:FindChild(self.objWarning, "ItemList")
	self.transWarningItemList = self.objWarningItemList.transform

	objWarningBtns = self:FindChild(self.objWarning, "Btns")
	self.objWalkBack = self:FindChild(objWarningBtns, "WalkBack")
	self.objWaitFree = self:FindChild(objWarningBtns, "WaitFree")
	self.objWaitBuy = self:FindChild(objWarningBtns, "WaitBuy")
	self.objComeSoon = self:FindChild(objWarningBtns, "ComeSoon")
	self.objWarningBtns = {
		self.objWalkBack,
		self.objWaitFree,
		self.objWaitBuy,
		self.objComeSoon,
	}
	self:InitWarningBoxBtnListener()

	self:InitStepData()
end


-- 初始化Root下按钮组的监听
function Day3SignInUI:InitRootBtnListener()
	local btnAbility = self:FindChildComponent(self.objBtnGroup1, "Ability", "Button")
	if btnAbility then
		self:AddButtonClickListener(btnAbility, function()
			self:OnClickRootAbility()
		end)
	end
	local btnNotify = self:FindChildComponent(self.objBtnGroup1, "Notify", "Button")
	if btnNotify then
		self:AddButtonClickListener(btnNotify, function()
			self:OnClickRootNotify()
		end)
	end
	local btnWalkBack = self:FindChildComponent(self.objBtnGroup2, "WalkBack", "Button")
	if btnWalkBack then
		self:AddButtonClickListener(btnWalkBack, function()
			self:OnClickRootWalkBack()
		end)
	end
	local btnBuyHorse = self:FindChildComponent(self.objBtnGroup2, "BuyHorse", "Button")
	if btnBuyHorse then
		self:AddButtonClickListener(btnBuyHorse, function()
			self:OnClickRootBuyHorse()
		end)
	end
	local btnGetRole = self:FindChildComponent(self.objBtnGroup3, "GetRole", "Button")
	if btnGetRole then
		self:AddButtonClickListener(btnGetRole, function()
			self:OnClickRootGetRole()
		end)
	end
end

-- 初始化提示框下按钮的监听
function Day3SignInUI:InitWarningBoxBtnListener()
	local btnWalkBack = self.objWalkBack:GetComponent("Button")
	if btnWalkBack then
		self:AddButtonClickListener(btnWalkBack, function()
			self:OnClickWarningWalkBack()
		end)
	end
	local btnWaitFree = self.objWaitFree:GetComponent("Button")
	if btnWaitFree then
		self:AddButtonClickListener(btnWaitFree, function()
			self:OnClickWarningWait()
		end)
	end
	local btnWaitBuy = self.objWaitBuy:GetComponent("Button")
	if btnWaitBuy then
		self:AddButtonClickListener(btnWaitBuy, function()
			self:OnClickWarningWait()
		end)
	end
	local btnComeSoon = self.objComeSoon:GetComponent("Button")
	if btnComeSoon then
		self:AddButtonClickListener(btnComeSoon, function()
			self:OnClickWarningComeSoon()
		end)
	end
end

-- 初始化步骤数据
function Day3SignInUI:InitStepData()
	-- 3天签到配置数据
	self.akStep = {
		[D3SST_FIRST] = {
			['descName'] = "[NAME]少侠:",
			['descWord'] = "	我已出发,不出一两日便到达,与你 共闯江湖。<color=#913E2B>(剩余时间:[TIME])</color>",
			['bItemListState'] = {
				['FirstDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup1] = true,
			},
		},
		[D3SST_SECOND_NORMAL] = {
			['descName'] = "[NAME]少侠:",
			['descWord'] = "	路遇麻匪,虽鏖战获胜,缴获若干宝 物,可惜我的马走失了......",
			['bItemListState'] = {
				['FirstDayItems'] = true,
				['NextDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup2] = true,
			},
			['warning'] = {
				[false] = {
					['desc'] = "让风冲慢慢走回,将在明日子时后到达,且没有马匹载物,部分宝物将无法带回。",
					['bWarningBtnState'] = {
						[self.objWalkBack] = true,
						[self.objWaitFree] = true,
					}
				},
				[true] = {
					['desc'] = "花费[COST][MONEYTYPE], [TARROLENAME]将立即到达,且带回所有携带宝物。",
					['bWarningBtnState'] = {
						[self.objWaitBuy] = true,
						[self.objComeSoon] = true,
					}
				},
			},
		},
		[D3SST_SECOND_FREE] = {
			['descName'] = "[NAME]少侠:",
			['descWord'] = "	我将慢慢走回,明日子时到达,与你 共闯江湖。<size=16>(剩余时间:[TIME])</size>",
			['bItemListState'] = {
				['FirstDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup1] = true,
			},
		},
		[D3SST_THIRD] = {
			['descName'] = "[NAME]少侠:",
			['descWord'] = "	我愿与你共闯江湖!",
			['bItemListState'] = {
				['FirstDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup3] = true,
			},
		}
	}
end

function Day3SignInUI:Init()
	-- 管理类
	self.kMmanager = Day3SignInDataManager:GetInstance()

	-- 通知服务器
	self.kMmanager:OpenActivityUINotify()

	-- 取玩家自己的名字
	self.strPlayerName = PlayerSetDataManager:GetInstance():GetPlayerName() or ""

	-- 获取当前期活动
	self.kCurActivity = self.kMmanager:GetCurActivityTypeData() or {}

	-- 设置货币类型, 活动花费
	self.eMoneyType = self.kCurActivity.MoneyType or 0
	self.strMoneyType = ""
	if self.eMoneyType == RackItemMoneyType.RIMT_GOLD then
		self.strMoneyType = "金锭"
	elseif self.eMoneyType == RackItemMoneyType.RIMT_SILVER then
		self.strMoneyType = "银锭"
	end
	self.iCost = self.kCurActivity.Cost or 0

	-- 初始化付费按钮
	local objPrice = self:FindChild(self.objComeSoon, "Number")
	objPrice:GetComponent("Text").text = tostring(self.iCost)
	self:FindChild(objPrice, "Image_jinding"):SetActive(self.eMoneyType == RackItemMoneyType.RIMT_GOLD)
	self:FindChild(objPrice, "Image_yinding"):SetActive(self.eMoneyType == RackItemMoneyType.RIMT_SILVER)
	
	-- 设置目标角色, 角色名称
	self.iTarRole = self.kCurActivity.TargetRole or 0
	self.strTarRoleName = self.kMmanager:GetTarRoleName() or ""

	-- 目标物品
	self.kTarItemTypeData = ItemDataManager:GetInstance():GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_RolePieces, self.iTarRole)

	-- 设置宣传图
	if self.kCurActivity.AdImg and (self.kCurActivity.AdImg ~= "") then
		self:SetSpriteAsync(self.kCurActivity.AdImg, self.ImgRoleImg)
	end

	-- 角色捡到垃圾时刷新界面
	self:AddEventListener("DAY3_SIGN_IN_COLLECT_ITEM", function()
		self.bNeedRefresh = true
	end)

	-- 活动阶段更新时刷新界面
	self:AddEventListener("DAY3_SIGN_IN_IS_DIRTY", function(eStage)
		if eStage and (self.eCurStep ~= eStage) then
			self.bNeedRefresh = true
		end
	end)
end

function Day3SignInUI:Update(dt)
	if self.bNeedRefresh then
		self.bNeedRefresh = false
		self:RefreshUI()
	end
end

function Day3SignInUI:RefreshUI(info)
	-- 获取当前显示步骤
	self.eCurStep = self.kMmanager:GetCurStep()
	if self.eCurStep then
		self:SetDataByStep(self.eCurStep)
	end
end

-- 归还所有物品图标
function Day3SignInUI:ReturnAllIcons()
	if self.akItemUIClass and (#self.akItemUIClass > 0) then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

-- 从对象池中加载一个图标
function Day3SignInUI:CreateIcon(kItemTypeData, iNum, kTransParent)
	if not (kItemTypeData and kTransParent) then
		return
	end
	local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent)
	local iNum = iNum or 0
	kIconBindData:UpdateUIWithItemTypeData(kItemTypeData)
	kIconBindData:SetItemNum(iNum, iNum == 1)
	self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
	return kIconBindData
end

-- 替换字符串中的参数
function Day3SignInUI:ReplaceArgsInString(strOri)
	if (not strOri) or (strOri == "") then
		return
	end
	-- player name
	if string.find(strOri, "%[NAME%]") then
		strOri = string.gsub(strOri, "%[NAME%]", self.strPlayerName or "")
	end
	-- time string
	if string.find(strOri, "%[TIME%]") then
		strOri = string.gsub(strOri, "%[TIME%]", self.kMmanager:GetCurTimeStr() or "")
	end
	-- target role name
	if string.find(strOri, "%[TARROLENAME%]") then
		strOri = string.gsub(strOri, "%[TARROLENAME%]", self.strTarRoleName or "")
	end
	-- money type
	if string.find(strOri, "%[MONEYTYPE%]") then
		strOri = string.gsub(strOri, "%[MONEYTYPE%]", self.strMoneyType or "")
	end
	-- money cost
	if string.find(strOri, "%[COST%]") then
		strOri = string.gsub(strOri, "%[COST%]", tostring(self.iCost or 0))
	end
	return strOri
end

-- 设置一组物品数据
function Day3SignInUI:SetItemList(transParent, aiItemList, aiNumList, bNeedShowDelete)
	if not (transParent and aiItemList) then
		return
	end
	local tableDr = TableDataManager:GetInstance()
	self.akShowDeleteBindData = {}
	aiNumList = aiNumList or {}
	for index, itemID in ipairs(aiItemList) do
		local kBindData = self:CreateIcon(tableDr:GetTableData("Item", itemID), aiNumList[index] or 1, transParent)
		if bNeedShowDelete == true then
			self.akShowDeleteBindData[#self.akShowDeleteBindData + 1] = kBindData
		end
	end
	transParent.gameObject:SetActive(true)
end

-- 设置一个步骤的数据
function Day3SignInUI:SetDataByStep(eStepType)
	if not eStepType then
		return
	end
	self:ReturnAllIcons()
	-- 步骤数据
	local kInfo = self.akStep[eStepType]
	if not kInfo then
		return
	end
	-- 设置目标物品
	if self.kTarItemTypeData and self.transTarItemSlot then
		self:CreateIcon(self.kTarItemTypeData, 1, self.transTarItemSlot)
	end
	-- 主页名字
	if kInfo.descName then
		self.textDescName.text = self:ReplaceArgsInString(kInfo.descName)
	end
	-- 主页描述
	if kInfo.descWord then
		self.textDescWord.text = self:ReplaceArgsInString(kInfo.descWord)
	end
	-- 主页按钮状态
	local btnGroupState = kInfo.bRootBtnGroupState or {}
	for index, obj in ipairs(self.objBtnGroups) do
		obj:SetActive(btnGroupState[obj] == true)
	end
	-- 物品数据
	local kItemListState = kInfo.bItemListState
	self.objItemList:SetActive(false)
	self.objWarningItemList:SetActive(false)
	-- 二次确认框的物品列中加入目标物品
	self:CreateIcon(self.kTarItemTypeData, 1, self.transWarningItemList)
	local iCount = 0
	if kItemListState.FirstDayItems == true then
		-- 获取已经捡起来的垃圾
		local list, numList = self.kMmanager:GetAllPickedItems()
		iCount = iCount + #list
		self:SetItemList(self.transItemList, list, numList)
		self:SetItemList(self.transWarningItemList, list, numList)
	end
	if (kItemListState.NextDayItems == true)
	and (self.kCurActivity ~= nil)
	and (#self.kCurActivity.NextDayItems > 0) then
		-- 获取次日物品
		local list = self.kCurActivity.NextDayItems
		local numList = self.kCurActivity.NDINums
		iCount = iCount + #list
		self:SetItemList(self.transItemList, list, numList)
		self:SetItemList(self.transWarningItemList, list, numList, true)
	end
	self.objItemListLabel:SetActive(iCount > 0)
	-- 选项数据
	self.kPayChooseData = kInfo.warning
end

function Day3SignInUI:OnDestroy()
	self:ReturnAllIcons()
end

------------------点击事件------------------

-- 点击关闭按钮
function Day3SignInUI:OnClickClose()
	self:ReturnAllIcons()
	RemoveWindowImmediately("Day3SignInUI")
end

function Day3SignInUI:OnClickRootAbility()
	if not self.iTarRole then
		return
	end
	-- 查看角色能力
	CardsUpgradeDataManager:GetInstance():DisplayRoleCardInfoObserve(self.iTarRole)
end

function Day3SignInUI:OnClickRootNotify()
	-- #TODO 钱程 通知
	SystemUICall:GetInstance():Toast("走MSDK的通知, 暂时先不管")
end

function Day3SignInUI:OnClickCoseMoneyChoose(bCost)
	if not self.kPayChooseData then
		return
	end
	bCost = (bCost == true)
	local kData = self.kPayChooseData[bCost]
	if not kData then
		return
	end
	if kData.desc then
		self.textWarning.text = self:ReplaceArgsInString(kData.desc)
	end
	local bBtnState = kData.bWarningBtnState or {}
	for index, obj in ipairs(self.objWarningBtns) do
		obj:SetActive(bBtnState[obj] == true)
	end
	-- 设置图标删除标志
	if self.akShowDeleteBindData and (#self.akShowDeleteBindData > 0) then
		for index, kBindData in ipairs(self.akShowDeleteBindData) do
			kBindData:SetDeleteSign(not bCost)
		end
	end
	self.objWarning:SetActive(true)
end

function Day3SignInUI:OnClickRootWalkBack()
	self:OnClickCoseMoneyChoose(false)
end

function Day3SignInUI:OnClickRootBuyHorse()
	self:OnClickCoseMoneyChoose(true)
end

function Day3SignInUI:OnClickRootGetRole()
	self.kMmanager:NotifyGetRoleReward()
end

function Day3SignInUI:OnClickWarningWalkBack()
	self.eCurStep = D3SST_SECOND_FREE
	self:SetDataByStep(self.eCurStep)
	self.objWarning:SetActive(false)
	-- 通知服务器点击了走回
	self.kMmanager:NotifyWalkBack()
end

function Day3SignInUI:OnClickWarningWait()
	self.objWarning:SetActive(false)
end

function Day3SignInUI:OnClickWarningComeSoon()
	if not self.kMmanager:GetCurActivityID() then
		return
	end
	-- 通知服务器点击了买马
	local callback = function()
		Day3SignInDataManager:GetInstance():NotifyBuyHouse()
	end
	if self.eMoneyType == RackItemMoneyType.RIMT_GOLD then
		PlayerSetDataManager:GetInstance():RequestSpendGold(self.iCost, callback, true, nil, 5)
	elseif self.eMoneyType == RackItemMoneyType.RIMT_SILVER then
		PlayerSetDataManager:GetInstance():RequestSpendSilver(self.iCost, callback)
	end
	self.objWarning:SetActive(false)
	RemoveWindowImmediately("Day3SignInUI", false)
end

return Day3SignInUI