PinballServerPlayRecordUI = class("PinballServerPlayRecordUI",BaseWindow)

function PinballServerPlayRecordUI:ctor(obj)
    local obj = LoadPrefabAndInit("PinBallGameUI/PinballServerPlayRecBoard",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function PinballServerPlayRecordUI:Init()
    -- 其他数据
    self.kPinballMgr = PinballDataManager:GetInstance()
    -- 夺宝记录
    self.objRecord = self:FindChild(self._gameObject, "Content")
    self.textRecordDate = self:FindChildComponent(self.objRecord, "Date", DRCSRef_Type.Text)
    self.objRecordEmpty = self:FindChild(self.objRecord, "Empty")
    self.objRecordList = self:FindChild(self.objRecord, "List")
    self.scvRecordList = self.objRecordList:GetComponent(DRCSRef_Type.LoopVerticalScrollRect)
    self.scvRecordList:AddListener(function(transform, index) 
        if self._gameObject.activeSelf == true then
            self:UpdateRecordItem(transform, index)
        end
    end)
    local btnRecordClose = self:FindChildComponent(self.objRecord, "Close", DRCSRef_Type.Button)
    self:AddButtonClickListener(btnRecordClose, function()
        RemoveWindowImmediately("PinballServerPlayRecordUI")
    end)
    -- 夺宝记录上下翻页
    self.objRecordTurnBtns = self:FindChild(self.objRecord, "Btns")
    self.btnRecordTurnUP = self:FindChildComponent(self.objRecordTurnBtns, "UP", DRCSRef_Type.Button)
    self.btnRecordTurnDown = self:FindChildComponent(self.objRecordTurnBtns, "Down", DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnRecordTurnUP, function()
        self:TurnRecordPage(false)
    end)
    self:AddButtonClickListener(self.btnRecordTurnDown, function()
        self:TurnRecordPage(true)
    end)
end

function PinballServerPlayRecordUI:RefreshUI()
    self.objRecordEmpty:SetActive(true)
    self.objRecordList:SetActive(false)
    self.objRecordTurnBtns:SetActive(false)
    local uiBeginTimeStamp, uiEndTimeStamp = self.kPinballMgr:GetServerPlayActivityTime()
    if not (uiBeginTimeStamp and uiEndTimeStamp) then
        return
    end
    local kDateBegin = os.date("*t", uiBeginTimeStamp) or {}
    local kDateEnd = os.date("*t", uiEndTimeStamp) or {}
    self.textRecordDate.text = string.format("%s/%s/%s-%s/%s/%s"
        , kDateBegin.year or 0, kDateBegin.month or 0, kDateBegin.day or 0
        , kDateEnd.year or 0, kDateEnd.month or 0, kDateEnd.day or 0)

    self.iCurRecPage = 1
    self.btnRecordTurnUP.interactable = false
    self.kPinballMgr:RequestServerPlayRecord(self.iCurRecPage)
end

-- 设置奖励领取记录面板
function PinballServerPlayRecordUI:SetRecBoard(iPage, kRecData, bIsEmpty)
    self.btnRecordTurnDown.interactable = (not bIsEmpty)
    if bIsEmpty then
        self.iCurRecPage = (self.iCurRecPage > 1) and (self.iCurRecPage - 1) or 1
        return
    end
    if (not kRecData) or (not kRecData[0]) then
        return
    end
    self.iCurRecPage = iPage or 1
    self.btnRecordTurnUP.interactable = (self.iCurRecPage > 1)
    self.objRecordEmpty:SetActive(false)
    self.objRecordList:SetActive(true)
    self.objRecordTurnBtns:SetActive(true)
    self.kCurRecData = kRecData
    self.iRecDataCount = #kRecData + 1
    self.scvRecordList.totalCount = self.iRecDataCount
    self.scvRecordList:RefillCells()
end

-- 更新一个奖励记录节点
function PinballServerPlayRecordUI:UpdateRecordItem(transform, index)
    if not (transform and index and self.kCurRecData and self.iRecDataCount) then
        return
    end
    local kRecData = self.kCurRecData[index]
    if not kRecData then
        return
    end
    local objNode = transform.gameObject
    local kTimetable = os.date("*t", kRecData.uiRecordTime or 0)
    self:FindChildComponent(objNode, "Date", DRCSRef_Type.Text).text = string.format("%04d/%02d/%02d", kTimetable.year, kTimetable.month, kTimetable.day)
    self:FindChildComponent(objNode, "Time", DRCSRef_Type.Text).text = string.format("%02d:%02d:%02d", kTimetable.hour, kTimetable.min, kTimetable.sec)
    local strItemName = ""
    if kRecData.uiItemId and (kRecData.uiItemId > 0) then
        strItemName = ItemDataManager:GetInstance():GetItemName(nil, kRecData.uiItemId)
    end
    self:FindChildComponent(objNode, "Msg/User", DRCSRef_Type.Text).text = string.format("玩家%s获得", kRecData.acPlayerName or "")
    self:FindChildComponent(objNode, "Msg/Item", DRCSRef_Type.Text).text = (strItemName or "")
    -- self:FindChild(objNode, "Bac"):SetActive(index & 1 == 0)
    self:FindChild(objNode, "DevoteSign"):SetActive(kRecData.bMaxCont == 1)
end

-- 奖励记录界面翻页
function PinballServerPlayRecordUI:TurnRecordPage(bNextPage)
    bNextPage = (bNextPage == true)
    if not self.iCurRecPage then
        self.iCurRecPage = 1
    end
    if bNextPage then
        -- 下一页
        self.iCurRecPage = self.iCurRecPage + 1
        self.kPinballMgr:RequestServerPlayRecord(self.iCurRecPage)
    else
        -- 上一页
        if self.iCurRecPage <= 1 then
            return
        end
        self.iCurRecPage = self.iCurRecPage - 1
        self.kPinballMgr:RequestServerPlayRecord(self.iCurRecPage)
    end
end

function PinballServerPlayRecordUI:OnEnable()
    self.kWinBar = GetUIWindow("WindowBarUI")
    if self.kWinBar then
        self.kWinBar:SetBackBtnState(false)
    end
end

function PinballServerPlayRecordUI:OnDisable()
    if self.kWinBar then
        self.kWinBar:SetBackBtnState(true)
    end
end

return PinballServerPlayRecordUI
