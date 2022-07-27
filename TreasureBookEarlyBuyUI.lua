TreasureBookEarlyBuyUI = class("TreasureBookEarlyBuyUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type
local E_FRIEND_STATE = {
    NOT_NOLINE = 1,             -- 好友不在线
    CANT_SEND_ANY_MORE = 2,     -- 不能再送了
    CAN_SEND_NEXT_MONTH = 3,    -- 可以送下个月
    CAN_SEND_CUR_MONTH = 4,     -- 可以送当月
}
local FRIEND_DATA_REQUEST_UOT_OF_TIME = 5000  -- 好友数据请求超时时间

function TreasureBookEarlyBuyUI:Create()
	local obj = LoadPrefabAndInit("TownUI/TreasureBookEarlyBuyUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function TreasureBookEarlyBuyUI:Init()
    -- 广告业页
    self.objAD = self:FindChild(self._gameObject, "AD")
    self.objAD:SetActive(true)
    local btnEnter = self:FindChildComponent(self.objAD, "Enter", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnEnter, function()
        self:OnClickEnter()
    end)
    self.comTwn = self.objAD:GetComponent(l_DRCSRef_Type.DOTweenAnimation)
    self.objImgAD = self:FindChild(self.objAD, "Image")
    self.imgAD = self.objImgAD:GetComponent(l_DRCSRef_Type.Image)
    self.textPrice1 = self:FindChildComponent(self.objImgAD, "Price1", l_DRCSRef_Type.Text)
    self.textPrice2 = self:FindChildComponent(self.objImgAD, "Price2", l_DRCSRef_Type.Text)
    self.objImgAD:SetActive(true)
    -- self.objHasBought = self:FindChild(self.objAD, "HasBought")
    self.objBuyForSelf = self:FindChild(self.objAD, "BuyForSelf")
    self.textBtnBuyForSelf = self:FindChildComponent(self.objBuyForSelf, "Number", l_DRCSRef_Type.Text)
    btnBuyForSelf = self:FindChildComponent(self.objBuyForSelf, "Btn", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnBuyForSelf, function()
        self:OnClickBuyForSelf()
    end)
    local btnBuyForFriend = self:FindChildComponent(self.objAD, "BuyForFriend/Btn", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnBuyForFriend, function()
        self:OnClickBuyForFriend()
    end)
    local btnShowSendList = self:FindChildComponent(self.objAD, "BuyForFriend/ShowSendList", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnShowSendList, function()
        self:OnClickShowSendList()
    end)
    -- self.textToggleHide = self:FindChildComponent(self.objAD, "Label", l_DRCSRef_Type.Text)
    -- self.toggleHide = self:FindChildComponent(self.objAD, "Hide", l_DRCSRef_Type.Toggle)
    -- self:AddToggleClickListener(self.toggleHide, function(bOn)
    --     self:OnClickToggleHide(bOn)
    -- end)
    -- self.toggleHide.isOn = false
    -- 加载界面
    self.objLoading = self:FindChild(self._gameObject, "Loading")
    self.objLoading:SetActive(false)
    -- 好友列表
    self.objFriendList = self:FindChild(self._gameObject, "FriendList")
    local objBoard = self:FindChild(self.objFriendList, "Board")
    -- self.textFriendLimit = self:FindChildComponent(objBoard, "Limit", l_DRCSRef_Type.Text)
    self.objFriendLoading = self:FindChild(objBoard, "Loading")
    self.objFriendNoFriends = self:FindChild(objBoard, "NoFriends")
    self.objSvFriendList = self:FindChild(objBoard, "LoopScrollView")
    self.objContentFriendList = self:FindChild(self.objSvFriendList, "Content")
    self.svFriendList = self.objSvFriendList:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
    self.svFriendList:AddListener(function(...)
        self:UpdateFriendItem(...)
    end)
    self.textBtnFriendListBuy = self:FindChildComponent(objBoard, "Buy/Number", l_DRCSRef_Type.Text)
    local btnFriendListBuy = self:FindChildComponent(objBoard, "Buy/Btn", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnFriendListBuy, function()
        self:OnClickFriendListBuy()
    end)
    self.objFriendListClose = self:FindChild(objBoard, "Close")
    local btnFriendListClose = self.objFriendListClose:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnFriendListClose, function()
        self.objFriendList:SetActive(false)
    end)
    self.objFriendList:SetActive(false)
    -- 其他数据
    self.bookManager = TreasureBookDataManager:GetInstance()
    self.colorFriendItemOnPick = DRCSRef.Color(1,1,1,1)
    self.colorFriendItemOnUnPick = DRCSRef.Color(0.172549,0.172549,0.172549,1)
    -- 事件
    self:AddEventListener("NOTICE_FIND_PLAYER_OFFLINE", function()
        self:DealFriendOffline()
    end)
    self:AddEventListener("QUERY_FRIEND_FINISH", function()
        self:OnQueryFriendFinish()
    end)
end

function TreasureBookEarlyBuyUI:RefreshUI(info)
    -- 检查百宝书基础信息
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:InitAd()
    else
        local callBack = function()
            local win = GetUIWindow("TreasureBookEarlyBuyUI")
            if not win then return end
            win:InitAd()
        end
        self.bookManager:RequestTreasureBookBaseInfo(callBack)
    end
    -- 动画
    self.comTwn:DOPlay()
end

-- 初始化广告
function TreasureBookEarlyBuyUI:InitAd()
    local info = self.bookManager:GetTreasureBookBaseInfo()
    if not (info and info.iCurBookID) then
        return
    end
    local kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",info.iCurBookID)
    if not kTreasureBook then
        return
    end

    -- 宣传图
    local sImgPath = kTreasureBook.EarlyBuyAttractMoneyImage
    if sImgPath then
        self.imgAD.sprite = GetSprite(sImgPath)
    end

    -- 初始化按钮
    self.iPrice = math.ceil((kTreasureBook.GoldCost or 0) * ((kTreasureBook.AdvancePurchaseDiscount or 10000) / 10000))
    local strPrice = tostring(self.iPrice)
    self.textBtnFriendListBuy.text = strPrice
    self.textPrice1.text = strPrice
    self.textPrice2.text = strPrice

    -- 已帮助预购的好友数
    -- local iHelpLimit = SSD_MAX_GIVE_FRIEND_ADVANCE_NUM
    -- local iHelpedNum = info.iGivedFriendAdvanceNum or 0
    -- self.bCantHelpAnyMore = iHelpedNum >= iHelpLimit
    -- self.textFriendLimit.text = string.format("【本月已赠送%d/%d位】", iHelpedNum, iHelpLimit)
end

-- 点击为自己开通壕侠
function TreasureBookEarlyBuyUI:OnClickBuyForSelf()
    if not self.bookManager then
        return
    end
    self.bookManager:TryToBuyVIPForSelf(function()
        local win = GetUIWindow("TreasureBookEarlyBuyUI")
        if not win then
            return
        end
        win:DoBuyForSelf()
    end)
end

-- 为自己开通壕侠
function TreasureBookEarlyBuyUI:DoBuyForSelf()
    if not self.iPrice then
        return
    end
    local kInfo = {}
    kInfo.bForSelf = true
    kInfo.content = string.format("是否要花费%d金锭，为自己续费一个月壕侠版百宝书？", self.iPrice)
    kInfo.callback = function()
        PlayerSetDataManager:GetInstance():RequestSpendGold(self.iPrice, function()
            -- 给自己走的是连续购买流程, 不是预购
            SendQueryTreasureBookInfo(STBQT_BRMB)
            local win = GetUIWindow("TreasureBookEarlyBuyUI")
            if win then
                win:ShowLoading()
            end
        end)
    end
    OpenWindowImmediately('TreasureBookWarningBoxUI', kInfo)
end

-- 查新最新好友信息并执行操作
function TreasureBookEarlyBuyUI:QueryLatestFrendInfoTo(funcDoSth, funcTimeOut)
    if not funcDoSth then
        return
    end
    -- 查询最新的好友数据
    -- 开始请求
    self.bRequestingFriendInfos = true
    self.funcQueryFriendToDo = funcDoSth
    NetCommonFriend:GetFriendList()
    -- 超时处理
    if self.uiRequestTimer then
        self:RemoveTimer(self.uiRequestTimer)
    end
    self.uiRequestTimer = self:AddTimer(FRIEND_DATA_REQUEST_UOT_OF_TIME, function()
        local win = GetUIWindow("TreasureBookEarlyBuyUI")
        if not win then
            return
        end
        if funcTimeOut then
            funcTimeOut(win)
        end
        win.bRequestingFriendInfos = false
    end)
end

-- 查询好友结束
function TreasureBookEarlyBuyUI:OnQueryFriendFinish()
    self.bRequestingFriendInfos = false
    if self.uiRequestTimer then
        self:RemoveTimer(self.uiRequestTimer)
    end
    SocialDataManager:GetInstance():SortServerData()
    if self.funcQueryFriendToDo then
        self.funcQueryFriendToDo()
        self.funcQueryFriendToDo = nil
    end
end

-- 点击为好友海通壕侠
function TreasureBookEarlyBuyUI:OnClickBuyForFriend()
    if TreasureBookDataManager:GetInstance():GetTreasureBookSendSwitch() == false then
        SystemUICall:GetInstance():Toast("百宝书赠送功能暂未开启")
        return  
    end
    -- if self.bCantHelpAnyMore then
    --     SystemUICall:GetInstance():Toast("帮好友预购壕侠数量已达上限")
    --     return
    -- end
    if self.bRequestingFriendInfos == true then
        SystemUICall:GetInstance():Toast("请求处理中")
        return
    end
    -- 查询最新的好友数据
    self:QueryLatestFrendInfoTo(function()
        local win = GetUIWindow("TreasureBookEarlyBuyUI")
        local kOriFriendDatas = SocialDataManager:GetInstance():GetFriendData2() or {}
        if not (kOriFriendDatas and win) then
            return
        end
        if win.uiRequestTimer then
            win:RemoveTimer(win.uiRequestTimer)
        end
        win:SetDirtyFriendData(kOriFriendDatas, true)
    end, function(win)
        win:ShowFriendList({}, false)
        SystemUICall:GetInstance():Toast("好友数据请求超时, 请稍后再试")
    end)

    -- 显示loading
    self.objFriendLoading:SetActive(true)
    self.objFriendList:SetActive(true)
    self.objFriendListClose:SetActive(false)
    self.objFriendNoFriends:SetActive(false)
end

-- 设置好友脏数据与显示脏标
function TreasureBookEarlyBuyUI:SetDirtyFriendData(akRawData, bForceShow)
    if not akRawData then
        return
    end
    self.kDirtyFriendDataCache = {
        ['akRaw'] = akRawData,
        ['bForceShow'] = bForceShow,
    }
    if self.uiRequestTimer then
        self:RemoveTimer(self.uiRequestTimer)
        self.uiRequestTimer = nil
    end
end

-- 循环检查脏数据
function TreasureBookEarlyBuyUI:Update()
    if not self.kDirtyFriendDataCache then
        return
    end
    local kTempCache = self.kDirtyFriendDataCache
    self.kDirtyFriendDataCache = nil
    self:ShowFriendList(kTempCache.akRaw, kTempCache.bForceShow)
end

-- 显示好友列表
function TreasureBookEarlyBuyUI:ShowFriendList(kOriFriendDatas, bForceShow)
    if bForceShow then
        self.objFriendList:SetActive(true)
    end
    self.objFriendLoading:SetActive(false)
    self.objFriendNoFriends:SetActive(false)
    self.objSvFriendList:SetActive(false)
    self.objFriendListClose:SetActive(true)
    if (not kOriFriendDatas) or (#kOriFriendDatas == 0) then
        -- 显示没有好友
        self.objFriendNoFriends:SetActive(true)
        return
    end
    self.iCurChooseFriendID = nil
    -- 当前时间
    local uiCurStamp = GetCurServerTimeStamp()
    local kCurDate = os.date("*t", uiCurStamp)
    -- 成为好友三天以上才可以赠送壕侠百宝书
    local uiSendCondTime = 3 * 24 * 3600
    -- 处理好友数据
    local akFriendInstDatas = {}
    local kFriendID2InstData = {}
    for index, kOriFriendData in ipairs(kOriFriendDatas) do
        local kExtData = kOriFriendData.ext or {}
        -- 好友壕侠到期时间戳
        local uiVIPEndStamp = tonumber(kExtData.dwRMBPlayer or "0") or 0
        -- 好友状态
        local eState = E_FRIEND_STATE.CANT_SEND_ANY_MORE
        if kOriFriendData.online then
            -- -- 如果好友没有开通壕侠, 那么可以赠送好友当月壕侠
            -- if uiVIPEndStamp == 0 then
            --     eState = E_FRIEND_STATE.CAN_SEND_CUR_MONTH
            -- else
            --     local kDate = os.date("*t", uiVIPEndStamp)
            --     -- 如果好友开了壕侠但是本月就到期, 那么可以赠送好友下个月壕侠
            --     if (kDate.year == kCurDate.year)
            --     and (kDate.month == kCurDate.month) then
            --         eState = E_FRIEND_STATE.CAN_SEND_NEXT_MONTH
            --     end
            -- end
            ---------------------------------------------------------------------------
            -- TIPS:以上逻辑修改, 现在只区分 可送(本月) 与 不可送
            if uiVIPEndStamp == 0 then
                eState = E_FRIEND_STATE.CAN_SEND_CUR_MONTH
            else
                local kDate = os.date("*t", uiVIPEndStamp)
                if (kDate.year < kCurDate.year)
                or ((kDate.year == kCurDate.year) and (kDate.month < kCurDate.month)) then
                    eState = E_FRIEND_STATE.CAN_SEND_CUR_MONTH
                end
            end
        else
            eState = E_FRIEND_STATE.NOT_NOLINE
        end
        local uiRenameNum = 0
        if kOriFriendData.ext and kOriFriendData.ext.dwReNameNum then
            uiRenameNum = tonumber(kOriFriendData.ext.dwReNameNum)
        end
        local strName = nil
        if uiRenameNum > 0 then
            strName = kOriFriendData.name or ""
        end
        if (not strName) or (strName == "") then
            strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(kOriFriendData.uid)
        end
        local strNickName = nil
        if kOriFriendData.bIsTecentFriend == true then
            strNickName = MSDKHelper:GetNickNameByFriendPlayerID(kOriFriendData.uid)
        end
        if strNickName and (strNickName ~= "") then
            strName = strName .. string.format("（%s）", tostring(strNickName))
        end
        -- 对最终名字做一个裁切, 超过九个汉字的, 显示为九个汉字 加 ...
        local iMaxUTF8Len = 9
        if string.utf8len(strName) > iMaxUTF8Len then
            strName = string.utf8sub(strName, 1, iMaxUTF8Len) .. "..."
        end
        -- 成为好友的时间戳
        local uiBecomeFriendStamp = tonumber(kOriFriendData.create_time or "0") or 0
        -- 关系链好友可以直接赠送壕侠百宝书, 如果是普通游戏内好友, 成为好友的时间没有超过三天, 不过赠送门槛
        local bEnableSendCond = true
        if kOriFriendData.bIsTecentFriend ~= true then
            bEnableSendCond = (uiCurStamp - uiBecomeFriendStamp) >= uiSendCondTime
        end
        local kProcess = {
            ['ori'] = kOriFriendData,
            ['uid'] = tonumber(kOriFriendData.uid),
            ['name'] = strName,
            ['eState'] = eState,
            ['acVOpenID'] = kExtData.acVOpenID or "",
            ['acOpenID'] = kExtData.acOpenID or "",
            ['bIsTencentFriend'] = (kOriFriendData.bIsTecentFriend == true),
            ['bEnableSendCond'] = bEnableSendCond,
        }
        akFriendInstDatas[#akFriendInstDatas + 1] = kProcess
        kFriendID2InstData[kProcess.uid] = kProcess
    end
    self.akFriendInstDatas = akFriendInstDatas
    self.kFriendID2InstData = kFriendID2InstData
    self:UpdateFriendList()
end

-- 根据好友ui查找好友数据
function TreasureBookEarlyBuyUI:GetFriendDataByUID(uiID)
    if not self.kFriendID2InstData then
        return
    end
    return self.kFriendID2InstData[uiID]
end

-- 更新好友列表
function TreasureBookEarlyBuyUI:UpdateFriendList()
    if (not self.akFriendInstDatas) or (#self.akFriendInstDatas == 0) then
        SystemUICall:GetInstance():Toast("没有请求到好友数据")
        self.objFriendLoading:SetActive(false)
        self.objFriendNoFriends:SetActive(true)
        self.objFriendListClose:SetActive(true)
        return
    end
    -- 按预购状态对好友列表进行排序
    table.sort(self.akFriendInstDatas, function(a, b)
        if a.eState == b.eState then
            if a.bIsTencentFriend ~= b.bIsTencentFriend then
                return (a.bIsTencentFriend == true)
            else
                return a.uid > b.uid
            end
        else
            return a.eState > b.eState
        end
    end)
    self.svFriendList.totalCount = #self.akFriendInstDatas
    self.svFriendList:RefillCells()
    -- 从加载中显示为好友列表
    self.objFriendLoading:SetActive(false)
    self.objFriendNoFriends:SetActive(false)
    self.objSvFriendList:SetActive(true)
    self.objFriendListClose:SetActive(true)
end

-- 更新好友列表对象
function TreasureBookEarlyBuyUI:UpdateFriendItem(transform, index)
    if not (self.akFriendInstDatas and transform and index) then
        return
    end
    local obj = transform.gameObject
    self:SetFriendItemState(obj, false)
    local kFriendInfo = self.akFriendInstDatas[index + 1]
    self:FindChildComponent(obj, "Name", l_DRCSRef_Type.Text).text = kFriendInfo.name
    -- 获取好友预购状态
    local textState = self:FindChildComponent(obj, "State", l_DRCSRef_Type.Text)
    local bCanSend = true  -- 是否可赠送壕侠
    local uiSendFlag = 0
    if kFriendInfo.eState == E_FRIEND_STATE.CAN_SEND_CUR_MONTH then
        -- textState.text = "可赠送本月"
        textState.text = "可赠送"
        uiSendFlag = 1
    -- elseif kFriendInfo.eState == E_FRIEND_STATE.CAN_SEND_NEXT_MONTH then
    --     textState.text = "可赠送下月"
    --     uiSendFlag = 2
    elseif kFriendInfo.eState == E_FRIEND_STATE.CANT_SEND_ANY_MORE then
        bCanSend = false
        textState.text = "不可赠送"
    elseif kFriendInfo.eState == E_FRIEND_STATE.NOT_NOLINE then
        bCanSend = false
        textState.text = "离线"
    end
    -- self:FindChild(obj, "State/Tick"):SetActive(not bCanSend)
    self:FindChild(obj, "State/Tick"):SetActive(false)
    obj:GetComponent(l_DRCSRef_Type.CanvasGroup).alpha = bCanSend and 1 or 0.5
    local btn = self:FindChildComponent(obj, "Btn", l_DRCSRef_Type.Button)
    btn.interactable = (bCanSend)
    self:RemoveButtonClickListener(btn)
    if not bCanSend then
        return
    end
    self:AddButtonClickListener(btn, function()
        if kFriendInfo.bEnableSendCond ~= true then
            SystemUICall:GetInstance():Toast("为保障您的安全，对新加好友3天后才能赠送壕侠百宝书")
            return
        end
        self:OnClickFriendListItem(kFriendInfo.uid, kFriendInfo.name, uiSendFlag, obj)
    end)
end

function TreasureBookEarlyBuyUI:SetFriendItemState(obj, bState)
    if not obj then
        return
    end
    bState = bState == true
    self:FindChild(obj, "Chosen"):SetActive(bState)
    self:FindChildComponent(obj, "Name", l_DRCSRef_Type.Text).color = bState and self.colorFriendItemOnPick or self.colorFriendItemOnUnPick
    self:FindChildComponent(obj, "State", l_DRCSRef_Type.Text).color = bState and self.colorFriendItemOnPick or self.colorFriendItemOnUnPick
end

-- 点击好友列表ui对象
function TreasureBookEarlyBuyUI:OnClickFriendListItem(iFriendID, strFriendName, uiSendFlag, obj)
    if not (iFriendID and strFriendName and obj) then
        return
    end
    local transContent = self.objContentFriendList.transform
    for index = 0, transContent.childCount - 1 do
        self:SetFriendItemState(transContent:GetChild(index).gameObject, false)
    end
    self:SetFriendItemState(obj, true)
    self.iCurChooseFriendID = iFriendID
    self.strCurChooseFriendName = strFriendName
    self.uiCurSendFlag = uiSendFlag
end

-- 点击好友列表开通壕侠
function TreasureBookEarlyBuyUI:OnClickFriendListBuy()
    if not (self.iCurChooseFriendID and self.strCurChooseFriendName) then
        SystemUICall:GetInstance():Toast("请选择要赠送的在线好友")
        return
    end
    if not self.iPrice then
        return
    end
    local kInfo = {}
    kInfo.bForSelf = false
    local strSendFlag = (self.uiCurSendFlag == 1) and "本月" or "下月"
    kInfo.content = string.format("是否要花费%d金锭为好友%s预购%s壕侠版百宝书?", self.iPrice, self.strCurChooseFriendName, strSendFlag)
    kInfo.callback = function()
        PlayerSetDataManager:GetInstance():RequestSpendGold(self.iPrice, function()
            local win = GetUIWindow("TreasureBookEarlyBuyUI")
            if not win then
                return
            end
            uiFriendID = win.iCurChooseFriendID
            if (not uiFriendID) or (uiFriendID == 0) then
                return
            end
            local kFriendData = win:GetFriendDataByUID(uiFriendID)
            if not kFriendData then
                return
            end
            SendQueryTreasureBookInfo(STBQT_ADVANCE_PURCHASE, uiFriendID, 0, kFriendData.acOpenID, kFriendData.acVOpenID)
            self:ShowLoading()
        end)
    end
    OpenWindowImmediately('TreasureBookWarningBoxUI', kInfo)
end

-- 显示等待界面
function TreasureBookEarlyBuyUI:ShowLoading(bState)
    self.objLoading:SetActive(bState ~= false)
    self.objFriendList:SetActive(false)
    self.objAD:SetActive(true)
end

-- 点击不再提醒
-- function TreasureBookEarlyBuyUI:OnClickToggleHide(bOn)
--     local value = nil
--     if bOn then
--         local timetable = os.date("*t", os.time())
--         value = string.format("%d-%d-%d", timetable.year, timetable.month, timetable.day)
--     end
--     SetConfig("TreasureBookEarlyBuy", value)
-- end

-- 显示自己已赠送的好友列表
function TreasureBookEarlyBuyUI:OnClickShowSendList()
    if self.bRequestingFriendInfos == true then
        SystemUICall:GetInstance():Toast("请求处理中")
        return
    end
    local funcGenSendList = function()
        local akFriendItemDatas = SocialDataManager:GetInstance():GetFriendData()
        local akGoodPeopleList = {}
        if #akFriendItemDatas > 0 then
            local uiCurStamp = GetCurServerTimeStamp()
            for index, kInfo in ipairs(akFriendItemDatas) do
                local akValues = kInfo.values or {}
                local uiEndTimeStamp = 0
                local uiTotalExp = 0
                for _, kValue in ipairs(akValues) do
                    if kValue.name == "GiveFriendTreasureExpEndTime" then
                        uiEndTimeStamp = tonumber(kValue.value and (kValue.value.vInt64 or 0) or 0)
                    elseif kValue.name == "TotalTreasureExp" then
                        uiTotalExp = tonumber(kValue.value and (kValue.value.vInt64 or 0) or 0)
                    end
                end
                if uiEndTimeStamp >= uiCurStamp then
                    local strName = nil
                    local kAttr = kInfo.attrib or {}
                    local uiRenameNum = 0
                    if kAttr.ext and kAttr.ext.dwReNameNum then
                        uiRenameNum = tonumber(kAttr.ext.dwReNameNum)
                    end
                    if uiRenameNum and (uiRenameNum > 0) then
                        strName = kAttr.name
                    end
                    if (not strName) or (strName == "") then
                        strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(kAttr.uid or 0)
                    end
                    akGoodPeopleList[#akGoodPeopleList + 1] = {
                        ['name'] = strName,
                        ['point'] = uiTotalExp,
                    }
                end
            end
        end
        table.sort(akGoodPeopleList, function(a, b)
            return (a.point or 0) > (b.point or 0)
        end)
        local strContent = ""
        local strDesc = nil
        local uiMaxShowNum = 10
        for index, kInfo in ipairs(akGoodPeopleList) do
            if uiMaxShowNum <= 0 then
                strDesc = "（最多显示10位好友）"
                break
            end
            strContent = string.format("%s\n%s：%d", strContent, kInfo.name or "", kInfo.point or 0)
            uiMaxShowNum = uiMaxShowNum - 1
        end
        if strContent == "" then
            strContent = "暂无信息"
        else
            strContent = string.format("%s：%s\n", "玩家名字", "贡献百宝书经验") .. strContent
        end
        if strDesc and (strDesc ~= "") then
            strContent = strContent .. "\n" .. strDesc
        end
        OpenWindowImmediately("TipsPopUI", {
            ['title'] = "赠送本月壕侠的好友",
            ['titlecolor'] = DRCSRef.Color.white,
            ['content'] = strContent,
        })
    end
    local funcTimeOut = function()
        SystemUICall:GetInstance():Toast("好友数据请求超时, 请稍后再试")
    end
    self:QueryLatestFrendInfoTo(funcGenSendList, funcTimeOut)
end

-- 点击进入百宝书
function TreasureBookEarlyBuyUI:OnClickEnter()
    OpenWindowImmediately("TreasureBookUI")
    RemoveWindowImmediately("TreasureBookEarlyBuyUI", false)
end

-- 赠送好友百宝书时好友离线
function TreasureBookEarlyBuyUI:DealFriendOffline()
    SystemUICall:GetInstance():Toast("赠送未成功, 好友当前已离线")
    RemoveWindowImmediately("TreasureBookEarlyBuyUI", false)
end

return TreasureBookEarlyBuyUI
