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


-- ?????????Root?????????????????????
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

-- ????????????????????????????????????
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

-- ?????????????????????
function Day3SignInUI:InitStepData()
	-- 3?????????????????????
	self.akStep = {
		[D3SST_FIRST] = {
			['descName'] = "[NAME]??????:",
			['descWord'] = "	????????????,????????????????????????,?????? ???????????????<color=#913E2B>(????????????:[TIME])</color>",
			['bItemListState'] = {
				['FirstDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup1] = true,
			},
		},
		[D3SST_SECOND_NORMAL] = {
			['descName'] = "[NAME]??????:",
			['descWord'] = "	????????????,???????????????,??????????????? ???,????????????????????????......",
			['bItemListState'] = {
				['FirstDayItems'] = true,
				['NextDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup2] = true,
			},
			['warning'] = {
				[false] = {
					['desc'] = "?????????????????????,???????????????????????????,?????????????????????,??????????????????????????????",
					['bWarningBtnState'] = {
						[self.objWalkBack] = true,
						[self.objWaitFree] = true,
					}
				},
				[true] = {
					['desc'] = "??????[COST][MONEYTYPE], [TARROLENAME]???????????????,??????????????????????????????",
					['bWarningBtnState'] = {
						[self.objWaitBuy] = true,
						[self.objComeSoon] = true,
					}
				},
			},
		},
		[D3SST_SECOND_FREE] = {
			['descName'] = "[NAME]??????:",
			['descWord'] = "	??????????????????,??????????????????,?????? ???????????????<size=16>(????????????:[TIME])</size>",
			['bItemListState'] = {
				['FirstDayItems'] = true,
			},
			['bRootBtnGroupState'] = {
				[self.objBtnGroup1] = true,
			},
		},
		[D3SST_THIRD] = {
			['descName'] = "[NAME]??????:",
			['descWord'] = "	????????????????????????!",
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
	-- ?????????
	self.kMmanager = Day3SignInDataManager:GetInstance()

	-- ???????????????
	self.kMmanager:OpenActivityUINotify()

	-- ????????????????????????
	self.strPlayerName = PlayerSetDataManager:GetInstance():GetPlayerName() or ""

	-- ?????????????????????
	self.kCurActivity = self.kMmanager:GetCurActivityTypeData() or {}

	-- ??????????????????, ????????????
	self.eMoneyType = self.kCurActivity.MoneyType or 0
	self.strMoneyType = ""
	if self.eMoneyType == RackItemMoneyType.RIMT_GOLD then
		self.strMoneyType = "??????"
	elseif self.eMoneyType == RackItemMoneyType.RIMT_SILVER then
		self.strMoneyType = "??????"
	end
	self.iCost = self.kCurActivity.Cost or 0

	-- ?????????????????????
	local objPrice = self:FindChild(self.objComeSoon, "Number")
	objPrice:GetComponent("Text").text = tostring(self.iCost)
	self:FindChild(objPrice, "Image_jinding"):SetActive(self.eMoneyType == RackItemMoneyType.RIMT_GOLD)
	self:FindChild(objPrice, "Image_yinding"):SetActive(self.eMoneyType == RackItemMoneyType.RIMT_SILVER)
	
	-- ??????????????????, ????????????
	self.iTarRole = self.kCurActivity.TargetRole or 0
	self.strTarRoleName = self.kMmanager:GetTarRoleName() or ""

	-- ????????????
	self.kTarItemTypeData = ItemDataManager:GetInstance():GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_RolePieces, self.iTarRole)

	-- ???????????????
	if self.kCurActivity.AdImg and (self.kCurActivity.AdImg ~= "") then
		self:SetSpriteAsync(self.kCurActivity.AdImg, self.ImgRoleImg)
	end

	-- ?????????????????????????????????
	self:AddEventListener("DAY3_SIGN_IN_COLLECT_ITEM", function()
		self.bNeedRefresh = true
	end)

	-- ?????????????????????????????????
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
	-- ????????????????????????
	self.eCurStep = self.kMmanager:GetCurStep()
	if self.eCurStep then
		self:SetDataByStep(self.eCurStep)
	end
end

-- ????????????????????????
function Day3SignInUI:ReturnAllIcons()
	if self.akItemUIClass and (#self.akItemUIClass > 0) then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

-- ?????????????????????????????????
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

-- ???????????????????????????
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

-- ????????????????????????
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

-- ???????????????????????????
function Day3SignInUI:SetDataByStep(eStepType)
	if not eStepType then
		return
	end
	self:ReturnAllIcons()
	-- ????????????
	local kInfo = self.akStep[eStepType]
	if not kInfo then
		return
	end
	-- ??????????????????
	if self.kTarItemTypeData and self.transTarItemSlot then
		self:CreateIcon(self.kTarItemTypeData, 1, self.transTarItemSlot)
	end
	-- ????????????
	if kInfo.descName then
		self.textDescName.text = self:ReplaceArgsInString(kInfo.descName)
	end
	-- ????????????
	if kInfo.descWord then
		self.textDescWord.text = self:ReplaceArgsInString(kInfo.descWord)
	end
	-- ??????????????????
	local btnGroupState = kInfo.bRootBtnGroupState or {}
	for index, obj in ipairs(self.objBtnGroups) do
		obj:SetActive(btnGroupState[obj] == true)
	end
	-- ????????????
	local kItemListState = kInfo.bItemListState
	self.objItemList:SetActive(false)
	self.objWarningItemList:SetActive(false)
	-- ????????????????????????????????????????????????
	self:CreateIcon(self.kTarItemTypeData, 1, self.transWarningItemList)
	local iCount = 0
	if kItemListState.FirstDayItems == true then
		-- ??????????????????????????????
		local list, numList = self.kMmanager:GetAllPickedItems()
		iCount = iCount + #list
		self:SetItemList(self.transItemList, list, numList)
		self:SetItemList(self.transWarningItemList, list, numList)
	end
	if (kItemListState.NextDayItems == true)
	and (self.kCurActivity ~= nil)
	and (#self.kCurActivity.NextDayItems > 0) then
		-- ??????????????????
		local list = self.kCurActivity.NextDayItems
		local numList = self.kCurActivity.NDINums
		iCount = iCount + #list
		self:SetItemList(self.transItemList, list, numList)
		self:SetItemList(self.transWarningItemList, list, numList, true)
	end
	self.objItemListLabel:SetActive(iCount > 0)
	-- ????????????
	self.kPayChooseData = kInfo.warning
end

function Day3SignInUI:OnDestroy()
	self:ReturnAllIcons()
end

------------------????????????------------------

-- ??????????????????
function Day3SignInUI:OnClickClose()
	self:ReturnAllIcons()
	RemoveWindowImmediately("Day3SignInUI")
end

function Day3SignInUI:OnClickRootAbility()
	if not self.iTarRole then
		return
	end
	-- ??????????????????
	CardsUpgradeDataManager:GetInstance():DisplayRoleCardInfoObserve(self.iTarRole)
end

function Day3SignInUI:OnClickRootNotify()
	-- #TODO ?????? ??????
	SystemUICall:GetInstance():Toast("???MSDK?????????, ???????????????")
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
	-- ????????????????????????
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
	-- ??????????????????????????????
	self.kMmanager:NotifyWalkBack()
end

function Day3SignInUI:OnClickWarningWait()
	self.objWarning:SetActive(false)
end

function Day3SignInUI:OnClickWarningComeSoon()
	if not self.kMmanager:GetCurActivityID() then
		return
	end
	-- ??????????????????????????????
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