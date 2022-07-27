GeneralBoxUI = class('GeneralBoxUI',BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function GeneralBoxUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function GeneralBoxUI:OnPressESCKey()
    if self.comBtnClose then
        self.comBtnClose.onClick:Invoke()
    end
end

function GeneralBoxUI:Create()
	local obj = LoadPrefabAndInit('Interactive/GeneralBoxUI', TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function GeneralBoxUI:Init()
    self.comContentText = self:FindChildComponent(self._gameObject, 'content_box/Text', "EmojiText")
    self.comContentText.text = ''

    self.itemRoot = self:FindChild(self._gameObject, 'itemRoot')
    self.objItemIconUI = self:FindChild(self.itemRoot, 'ItemIconUI')
    self.comNum = self:FindChildComponent(self.itemRoot, 'num', DRCSRef_Type.Text)
    self.comName = self:FindChildComponent(self.itemRoot, 'name', DRCSRef_Type.Text)

    self.comBtnClose = self:FindChildComponent(self._gameObject, 'PopUpWindow_2/newFrame/Btn_exit', DRCSRef_Type.Button)
    self:SafelyAddButtonClickListener(self.comBtnClose, function()
        if self.leftBtnFunc and self._CancleRunLeftBtnFunc then
            self.leftBtnFunc()
        end
        -- 防止回调中移除了ui
        if self and self.CheckNextMsgOrExit then
            self:CheckNextMsgOrExit()
        end
    end)
    self.objBtnClose = self:FindChild(self._gameObject, 'PopUpWindow_2/newFrame/Btn_exit')

    self.objBtnLayer = self:FindChild(self._gameObject, 'Button')

    self.comBtnGreen = self:FindChildComponent(self._gameObject, 'Button_green', DRCSRef_Type.Button)
    self.objBtnGreen = self:FindChild(self.objBtnLayer, 'Button_green')
    self.comBtnGreenText = self:FindChildComponent(self.objBtnGreen, 'Text', DRCSRef_Type.Text)

    self.comBtnTips = self:FindChildComponent(self._gameObject, 'Button_tips', DRCSRef_Type.Button)
    self.objBtnTips = self:FindChild(self.objBtnLayer, 'Button_tips')
    self.comBtnTipsText = self:FindChildComponent(self.objBtnGreen, 'Text', DRCSRef_Type.Text)

    self.comBtnRed = self:FindChildComponent(self._gameObject, 'Button_red', DRCSRef_Type.Button)
    self.objBtnRed = self:FindChild(self.objBtnLayer, 'Button_red')
    self.comBtnRedText = self:FindChildComponent(self.objBtnRed, 'Text', DRCSRef_Type.Text)

    
    self.objBtnBuy = self:FindChild(self.objBtnLayer, 'Button_buy')
        self.comBtnBuy_red = self:FindChildComponent(self._gameObject, 'Buy_red', DRCSRef_Type.Button)
        self.comBtnBuy_green = self:FindChildComponent(self._gameObject, 'Buy_green', DRCSRef_Type.Button)
    self.comBtnBuyText = self:FindChildComponent(self.objBtnBuy, 'Text', DRCSRef_Type.Text)
    
    self.objTitleBox = self:FindChild(self._gameObject, 'newFrame/Title')
    self.comTitleText = self.objTitleBox:GetComponent("Text")
    self.comTitleText.text = ''

    self.objCheckBox = self:FindChild(self._gameObject, 'CheckBox')
    self.textCheckBox = self:FindChildComponent(self.objCheckBox, "Label", DRCSRef_Type.Text)
    self.toggleCheckBox = self.objCheckBox:GetComponent(DRCSRef_Type.Toggle)
    self.toggleCheckBox.isOn = false

    self.objInputConfirm = self:FindChild(self._gameObject, "InputRoot")
    self.objInputConfirm:SetActive(false)
    self.comInputConfirm = self:FindChildComponent(self.objInputConfirm, "InputField", DRCSRef_Type.InputField)
    self.comInputPlaceHolder = self:FindChildComponent(self.objInputConfirm, "InputField/Placeholder", DRCSRef_Type.Text)
    self.textInput = self:FindChildComponent(self.objInputConfirm, "Text", DRCSRef_Type.Text)

    self:SafelyAddButtonClickListener(self.comBtnGreen, function()
        if self.CommonTipCallBack then
            self.CommonTipCallBack();
        end
        -- callback 中可能会销毁window
        if IsWindowOpen("GeneralBoxUI") then
            self:CheckNextMsgOrExit()
        end
    end)

    self:SafelyAddButtonClickListener(self.comBtnRed, function() 
        PlayButtonSound("ButtonCancel")

        if (self:IsInputAllow() == false) then
          return
        end
        if self.leftBtnFunc then
            self.leftBtnFunc()
        end
         -- callback 中可能会销毁window
        if IsWindowOpen("GeneralBoxUI") then
            self:CheckNextMsgOrExit()
        end
    end)

    self:SafelyAddButtonClickListener(self.comBtnTips, function() 
        PlayButtonSound("ButtonCancel")

        if (self:IsInputAllow() == false) then
            return
        end

        local navigationUI = GetUIWindow('NavigationUI');
        if navigationUI and navigationUI:IsOpen() then
            navigationUI:SetStoryArenaBetTip(false)
        end

        globalTimer:AddTimer(60000, function()
            local navigationUI2 = GetUIWindow('NavigationUI');
            if navigationUI2 and navigationUI2:IsOpen() then
                navigationUI2:CheckOpenArenaTip();
            end
        end, 1)
         
        -- callback 中可能会销毁window
        if IsWindowOpen("GeneralBoxUI") then
            self:CheckNextMsgOrExit()
        end

        RemoveWindowImmediately('GeneralBoxUI')
    end)

    self:SafelyAddButtonClickListener(self.comBtnBuy_green, function()
        if self.CommonTipCallBack then
            self.CommonTipCallBack();
        end
         -- callback 中可能会销毁window
        if IsWindowOpen("GeneralBoxUI") then
            self:CheckNextMsgOrExit()
        end
    end)

    self:SafelyAddButtonClickListener(self.comBtnBuy_red, function()
        if self.CommonTipCallBack then
            self.CommonTipCallBack();
        end
         -- callback 中可能会销毁window
        if IsWindowOpen("GeneralBoxUI") then
            self:CheckNextMsgOrExit()
        end
    end)

    self.inputFunc = function()
      if (self:IsInputAllow() == false) then
        setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), true)
      else
        setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), false)
      end
    end

    if self.comInputConfirm then
      local fun = function()
        if (self.inputFunc) then
          self.inputFunc()
        end
      end
      self.comInputConfirm.onValueChanged:AddListener(fun)
      self.comInputConfirm.onEndEdit:AddListener(fun)
    end
  
    self.objBtnClose:SetActive(false)
    self.objBtnGreen:SetActive(false)
    self.objBtnTips:SetActive(false)
    self.objBtnRed:SetActive(false)
    self.objBtnBuy:SetActive(false)
    self.objCheckBox:SetActive(false)

    self.CommonTipCallBack = nil
    self.leftBtnFunc = nil
    self._CancleRunLeftBtnFunc = true
end

function GeneralBoxUI:SafelyAddButtonClickListener(btn, func)
    if not (btn and func) then
        return
    end
    self:RemoveButtonClickListener(btn)
    self:AddButtonClickListener(btn, func)
end

function GeneralBoxUI:giveUpBattleCallBack()
    ResumeGame()
    BattleDataManager:GetInstance():SetBattleEndFlag(true)
    local logicMainInst = LogicMain:GetInstance()
    if logicMainInst:IsReplaying() then
        if logicMainInst:IsReplayNeedGiveUp() then
            local binData, iCmd = EncodeSendSeCGA_GiveUpChallengePlatRole();
            SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
        end 
        logicMainInst:GameEnd()
    else
        local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
        local iSize = data:GetCurPos()
        NetGameCmdSend(SGC_CLICK_BATTLE_GAME_END,iSize,data)
    end
end

function GeneralBoxUI:setCallbackFun(eType,content,callback)
    self.leftBtnFunc = nil
    self.CommonTipCallBack = nil
    self._CancleRunLeftBtnFunc = true
    if eType == GeneralBoxType.SYSTEM_TIP then
        self.CommonTipCallBack = function() 
            SystemTipManager:GetInstance():ShowNextPopupTip()
        end
    elseif eType == GeneralBoxType.BATTLE_GIVEUP then
        self.leftBtnFunc = function()
            ResumeGame()
        end
        self.CommonTipCallBack = function() 
            self:giveUpBattleCallBack()
        end
    elseif eType == GeneralBoxType.COMMON_TIP or eType == GeneralBoxType.COMMON_TIP_WITH_BTN then
        self.CommonTipCallBack = callback;
        if type(content) == "table" then
            self.leftBtnFunc = content.leftBtnFunc
        end
    elseif eType == GeneralBoxType.Pay_TIP then
        self.CommonTipCallBack = callback;
    elseif eType == GeneralBoxType.BATTLE_AI_TIP then
        self.CommonTipCallBack = callback;
    elseif eType == GeneralBoxType.COSTITEM_TIP then
        self.CommonTipCallBack = callback;
    elseif eType == GeneralBoxType.SYSTEM_TIP_NEXT then
        self.leftBtnFunc = function()
            SystemTipManager:GetInstance():ClearPopupTipList()
        end
        self.CommonTipCallBack = function()
            SystemTipManager:GetInstance():ShowNextPopupTip()
        end
    elseif eType == GeneralBoxType.BATTLE_DEFEATED then
        self._CancleRunLeftBtnFunc = false
        self.leftBtnFunc = function()
            if (self.comInputConfirm.text ~= "认输") then
                return
            end
            if (content.leftBtnFunc) then
                content.leftBtnFunc()
            end
        end
    elseif eType == GeneralBoxType.DELETE_SCRIPT then
        self._CancleRunLeftBtnFunc = false
        self.leftBtnFunc = function()
            if (not DEBUG_MODE) and (self.comInputConfirm.text ~= "删档") then
                return
            end
            if type(content.leftBtnFunc) == 'function' then
                content.leftBtnFunc()
            end
        end
    elseif eType == GeneralBoxType.ARENA_TIP then
        self._CancleRunLeftBtnFunc = false
        self.CommonTipCallBack = callback;
        if type(content) == "table" then
            self.leftBtnFunc = content.leftBtnFunc
        end
    elseif eType == GeneralBoxType.CREDIT_SCENELIMIT then
        self.CommonTipCallBack = callback
        self._CancleRunLeftBtnFunc = false
        self.leftBtnFunc = content.leftBtnFunc
    elseif eType == GeneralBoxType.EMERGENCY_RESET then
        self._CancleRunLeftBtnFunc = false
        self.leftBtnFunc = function()
            if (self.comInputConfirm.text ~= "结束") then
                return
            end
            if type(content.leftBtnFunc) == 'function' then
                content.leftBtnFunc()
            end
        end
    elseif eType == GeneralBoxType.CHALLENGEORDER_TIP then
        self._CancleRunLeftBtnFunc = false
        self.CommonTipCallBack = callback;
        if type(content) == "table" then
            self.leftBtnFunc = content.leftBtnFunc
        end
    elseif eType == GeneralBoxType.STORY_WEEK_TAKEOUT_LIMIT then
        self.leftBtnFunc = function()
            if (self.comInputConfirm.text ~= "无法带出") then
                return
            end
            if (content.leftBtnFunc) then
                content.leftBtnFunc()
            end
        end
    end
end

function GeneralBoxUI:RefreshUI(kInfo)
    if not self.akQueue then
        self.akQueue = {}
        self.iCursor = 0
    end
    if kInfo.bRefreshSoon and (self.iCursor > 0) then
        kInfo.bRefreshSoon = nil
        self.akQueue[self.iCursor] = kInfo
        self.iCursor = self.iCursor - 1
    else
        self.akQueue[#self.akQueue + 1] = kInfo
    end
    if self.iCursor == 0 then
        self:CheckNextMsgOrExit()
    end
end

function GeneralBoxUI:OnDestroy()
    if self.comInputConfirm then
        self.comInputConfirm.onValueChanged:RemoveAllListeners()
        self.comInputConfirm.onValueChanged:Invoke()
        self.comInputConfirm.onEndEdit:RemoveAllListeners()
        self.comInputConfirm.onEndEdit:Invoke()
    end
end


function GeneralBoxUI:DealSingleMsg(kInfo)
    local eType,content,callback,button = table.unpack(kInfo, 1, 4)
    self:HideAllButton()
    self:setCallbackFun(eType,content,callback)
    if eType == GeneralBoxType.SYSTEM_TIP then 
        self:UpdatePopupTip(content)
    elseif eType == GeneralBoxType.CREDIT_SCENELIMIT then
        self:UpdateCommonTip(content)
    elseif eType == GeneralBoxType.BATTLE_GIVEUP then
        self:UpdateBattleGiveUpTip(content)
    elseif eType == GeneralBoxType.COMMON_TIP then
        self:UpdateCommonTip(content, button);
    elseif eType == GeneralBoxType.Pay_TIP then
        self:UpdatePayTip(content, callback)
    elseif eType == GeneralBoxType.BATTLE_AI_TIP then
        self:UpdateAITip()
    elseif eType == GeneralBoxType.COSTITEM_TIP then
        self:UpdateCostItemTip(content, callback)
    elseif eType == GeneralBoxType.COMMON_TIP_WITH_BTN then
        self:UpdateCommonTip(content, button);
    elseif eType == GeneralBoxType.SYSTEM_TIP_NEXT then
        self:UpdatePopupTipNext(content)
    elseif eType == GeneralBoxType.SYSTEM_RESTART then
        self:UpdateSystemRestart()
    elseif eType == GeneralBoxType.SYSTEM_Reconnect then
        self:UpdateReconnect()
    elseif eType == GeneralBoxType.HTTP_LOGIN_NET_ERROR then
        self:HTTPLoginValidateNetError(content,callback)
    elseif eType == GeneralBoxType.BATTLE_DEFEATED then
        self:BattleAdmitDefeated(content)
    elseif eType == GeneralBoxType.DELETE_SCRIPT then
        self:ScriptDeleteConfirm(content)
    elseif eType == GeneralBoxType.ARENA_TIP then
        self:UpdateCommonTip(content, button);
    elseif eType == GeneralBoxType.EMERGENCY_RESET then
        self:EmergencyReset(content)
    elseif eType == GeneralBoxType.CHALLENGEORDER_TIP then
        self:UpdateCommonTip(content, button);
    elseif eType == GeneralBoxType.FUND_FREE_TIP then
        self:FundFreeTip(content);
    elseif eType == GeneralBoxType.STORY_WEEK_TAKEOUT_LIMIT then
        self:StoryWeekTakeOutLimit(content)
    end
    -- FIXME: 所有界面全部显示关闭按钮, 部分界面特殊处理
    if (not self.forceclose) then
        self.objBtnClose:SetActive(true)
    end
end

-- 检查信息队列, 有则下一条, 无则退出
function GeneralBoxUI:CheckNextMsgOrExit()
    if (not self.akQueue) or (not self.iCursor) or (self.iCursor >= #self.akQueue) then
        PlayButtonSound("ButtonClose")
        self:ClearMsgQueue()
        return
    end
    self.iCursor = self.iCursor + 1
    local kInfo = self.akQueue[self.iCursor]
    self:DealSingleMsg(kInfo)
end

-- 清空信息队列
function GeneralBoxUI:ClearMsgQueue()
    self.akQueue = nil
    self.iCursor = 0
    RemoveWindowImmediately('GeneralBoxUI')
end

function GeneralBoxUI:HTTPLoginValidateNetError(content,callback)
    self.comTitleText.text = '系统提示'
    self.objBtnGreen:SetActive(true);
    self:SetContentText(content)
    self.comBtnGreenText.text = "重新连接";
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = '取消'

    local winLogin = GetUIWindow("LoginUI")
    if winLogin then
        winLogin:SetWaitingAnimState(false)
    end

    self.CommonTipCallBack = function()
        if winLogin then
            winLogin:SetWaitingAnimState(true)
        end
        if callback and type(callback) == "function" then
            callback()
        end
    end
    self.leftBtnFunc = function()
        self:CheckNextMsgOrExit()
    end
end

function GeneralBoxUI:BattleAdmitDefeated(text)
    self.comTitleText.text = '提示'
    self.objBtnGreen:SetActive(true);
    self:SetContentText(text.text)
    self.comBtnGreenText.text = "再想想";
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = "认输"
    self.comInputConfirm.text = ""
    setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), true)
    self.objInputConfirm:SetActive(true)
    self.comInputPlaceHolder.text = "输入“认输”才可以继续认输"

    self.isinputok = function()
        if (self.comInputConfirm.text == "认输") then
            return true
        else
            return false
        end
    end
end

function GeneralBoxUI:StoryWeekTakeOutLimit(text)
    self.comTitleText.text = '提示'
    self.objBtnGreen:SetActive(true);
    self:SetContentText(text.text)
    self.comBtnGreenText.text = "取消";
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = "确定"
    self.comInputConfirm.text = ""
    setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), true)
    self.objInputConfirm:SetActive(true)
    self.comInputPlaceHolder.text = "输入“无法带出”才可以继续进入"

    self.isinputok = function()
        if (self.comInputConfirm.text == "无法带出") then
            return true
        else
            return false
        end
    end
end

function GeneralBoxUI:EmergencyReset(text)
    self.comTitleText.text = '提示'
    self.objBtnGreen:SetActive(true);
    self:SetContentText(text.text)
    self.comBtnGreenText.text = "再想想";
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = "结束周目"
    self.comInputConfirm.text = ""
    setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), true)
    self.objInputConfirm:SetActive(true)
    self.comInputPlaceHolder.text = "输入“结束”才可以继续结束周目"

    self.isinputok = function()
        if (self.comInputConfirm.text == "结束") then
            return true
        else
            return false
        end
    end
end

function GeneralBoxUI:ScriptDeleteConfirm(text)
    self.comTitleText.text = '提示'
    self.objBtnGreen:SetActive(true);
    self:SetContentText(text.text)
    self.comBtnGreenText.text = "再想想";
    self.objBtnRed:SetActive(true)
    if DEBUG_MODE then 
        self.comBtnRedText.text = '删档(DEBUG)'
        setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), false)
    else
        self.comBtnRedText.text = "删档"
        setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), true)
    end
    self.comInputConfirm.text = ""
    self.comInputPlaceHolder.text = "输入“删档”才可以继续删档"
    self.objInputConfirm:SetActive(true)

    self.isinputok = function()
        if (DEBUG_MODE) or (self.comInputConfirm.text == "删档") then
            return true
        else
            return false
        end
    end
end

function GeneralBoxUI:UpdateReconnect()
    self.comTitleText.text = '系统提示'
    self.objBtnGreen:SetActive(true);
    self:SetContentText("网络连接不稳定，是否要重新连接？")
    self.comBtnGreenText.text = "重新连接";
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = '返回登录'

    self.CommonTipCallBack = function ()
        StartReconnect()
        self:CheckNextMsgOrExit()
    end

    self.leftBtnFunc = function()
        ReturnToLogin()
    end
end

function GeneralBoxUI:SetContentText(sText)
    self.comContentText.text =  sText

    local iStringLen = string.stringWidth(self.comContentText.m_OutputText)
    local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(self.comContentText.m_OutputText, "(<color=.+>)(.*)</color>")
    if uiColorTagIndex ~= nil then --<color=AAAAAA></color>属性
        iStringLen = iStringLen - 22
    end
    if iStringLen >= 46  then -- 23个汉字  46个字符
        self.comContentText.alignment = CS.UnityEngine.TextAnchor.MiddleLeft
    else
        self.comContentText.alignment = CS.UnityEngine.TextAnchor.MiddleCenter
    end
end

function GeneralBoxUI:UpdateSystemRestart()
    self.comTitleText.text = '系统提示'
    self.objBtnGreen:SetActive(true);
    self.comBtnGreenText.text = '立即重启';
    self.CommonTipCallBack = function ()
        DRCSRef.CommonFunction.RestartApps(300)
    end
    local contentText = "资源解压完毕，%ds后重启游戏"
    local time = 3
    self:SetContentText(string.format(contentText,time)) 

    self:AddTimer(time * 1000,function ()
        DRCSRef.CommonFunction.RestartApps(300)
    end)

    self:AddTimer(1000,function ()
        time = time - 1
        self:SetContentText(string.format(contentText,time))
    end,time)
end

function GeneralBoxUI:HideAllButton()
    self.objBtnClose:SetActive(false)
    self.objBtnGreen:SetActive(false)
    self.objBtnRed:SetActive(false)
    self.objBtnTips:SetActive(false)
    self.objBtnBuy:SetActive(false)
    self.itemRoot:SetActive(false)
    self.objCheckBox:SetActive(false)
    self.objInputConfirm:SetActive(false)
    setUIGray(self.objBtnRed:GetComponent(DRCSRef_Type.Image), false)
    self.isinputok = nil
end

function GeneralBoxUI:UpdateBattleGiveUpTip(content)
    self.comTitleText.text = '系统提示'
    self:SetContentText(tostring(content))
    self.objBtnGreen:SetActive(true)
    self.comBtnGreenText.text = '确定'
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = '取消'
end

function GeneralBoxUI:FundFreeTip(content)
    self.comTitleText.text = '系统提示'
    self:SetContentText(tostring(content))
    self.objBtnGreen:SetActive(true)
    self.comBtnGreenText.text = '好的'
end

function GeneralBoxUI:UpdatePopupTip(content)
    self:SetContentText(tostring(content))
    self.objBtnGreen:SetActive(true)
    self.comBtnGreenText.text = '确定'
    self.comTitleText.text =  '错误'
end

function GeneralBoxUI:UpdatePopupTipNext(content)
    if type(content) == "table" then
        self:UpdatePopupTip(content.text)
    else
        self:UpdatePopupTip(content)
    end

    self.comBtnRedText.text = '忽略全部'
    self.objBtnRed:SetActive(true)
    if content.rightBtnText then
        self.comBtnGreenText.text = tostring(content.rightBtnText);
    else
        self.comBtnGreenText.text = '确定';
    end
end

function GeneralBoxUI:UpdateCommonTip(content, button)
    local bIsTableContent = false
    if type(content) == "table" then
        bIsTableContent = true
    end
    if bIsTableContent then
        self:SetContentText(tostring(content.text or "")) 
    else
        self:SetContentText(tostring(content)) 
    end

    self.objBtnGreen:SetActive(true);
    if bIsTableContent and  content.rightBtnText then
        self.comBtnGreenText.text = tostring(content.rightBtnText);
    else
        self.comBtnGreenText.text = '确定';
    end
    
    self.objBtnRed:SetActive(true);
    if bIsTableContent and content.leftBtnText then
        self.comBtnRedText.text = tostring(content.leftBtnText);
    else
        self.comBtnRedText.text = '取消';
    end

    self.forceclose = nil
    
    if button then
        if button.confirm then
            self.objBtnGreen:SetActive(true);
        else
            self.objBtnGreen:SetActive(false);
        end

        if button.cancel then
            self.objBtnRed:SetActive(true);
        else
            self.objBtnRed:SetActive(false);
        end
        
        if button.close then
            self.objBtnClose:SetActive(true);
        else
            self.objBtnClose:SetActive(false);
        end
        if button.close == false then
            self.forceclose = true
        end

        if button.tips then
            self.objBtnTips:SetActive(true);
        else
            self.objBtnTips:SetActive(false);
        end

        if button.checkBox then
            self.objCheckBox:SetActive(true);
            self.toggleCheckBox.isOn = false;
        end
    end

    if bIsTableContent then
        self.comTitleText.text = tostring(content.title or "")
    else
        self.comTitleText.text = '系统提示'
    end
end

function GeneralBoxUI:UpdatePayTip(content, callback)
    if (content == nil) then
        return
    end

    self:SetContentText(tostring(content.text))
    self.objBtnBuy:SetActive(true)
    self.comBtnBuyText.text = content.btnText or '购买'
    local objTongBi = self:FindChild(self.objBtnBuy, "Number/Image_tongbi")
    local objYingDing = self:FindChild(self.objBtnBuy, "Number/Image_yinding")
    local objJinDing = self:FindChild(self.objBtnBuy, "Number/Image_jinding")
    objTongBi:SetActive(false)
    objJinDing:SetActive(false)
    objYingDing:SetActive(false)
    local GoldSliver
    if content.btnType == "silver" then
        objYingDing:SetActive(true)
        GoldSliver = PlayerSetDataManager:GetInstance():GetPlayerSliver() or 0
    elseif content.btnType == "gold" then
        objJinDing:SetActive(true)
        GoldSliver = PlayerSetDataManager:GetInstance():GetPlayerGold() or 0
    else
        objTongBi:SetActive(true)
        GoldSliver = PlayerSetDataManager:GetInstance():GetPlayerCoin() or 0
    end

    self:FindChildComponent(self.objBtnBuy, "Text", DRCSRef_Type.Text).text = content.btnText or "购买"

    self:FindChildComponent(self.objBtnBuy, "Number", DRCSRef_Type.Text).text = content.num or 0
    local redColor = DRCSRef.Color(1, 0, 0, 1);
    local whiteColor = DRCSRef.Color(1, 1, 1, 1);
    
    local color = GoldSliver >= content.num and whiteColor or redColor;
    self:FindChildComponent(self.objBtnBuy, "Number", DRCSRef_Type.Text).color = color;

    self.comTitleText.text = content.title or '购买';

    self.comBtnBuy_red.gameObject:SetActive(false)
    self.comBtnBuy_green.gameObject:SetActive(false)

    if content ~= nil or  content.btnColor == 'green' then
        self.comBtnBuy_green.gameObject:SetActive(true)
    else
        self.comBtnBuy_red.gameObject:SetActive(true)
    end

    if content and content.checkBox and (content.checkBox ~= "") then
        self.textCheckBox.text = content.checkBox
        self.toggleCheckBox.isOn = (content.bCheckBox == true)
        self.objCheckBox:SetActive(true)
    end

    if (not self.forceclose) then
        self.objBtnClose:SetActive(true)
    end
end


function GeneralBoxUI:UpdateAITip()
    self:SetContentText(GetLanguageByID(518))
    self.objBtnGreen:SetActive(true)
    self.comBtnGreenText.text = '解锁完整版'
    
    self.objBtnRed:SetActive(true)
    self.comBtnRedText.text = '放弃'
    self.comTitleText.text = '解锁完整版'

end

function GeneralBoxUI:UpdateCostItemTip(content, callback)
    local bIsTableContent = false
    if type(content) == "table" then
        bIsTableContent = true
    end
    if bIsTableContent then
        self:SetContentText(tostring(content.text or "")) 
    else
        self:SetContentText(tostring(content)) 
    end
    self.objBtnGreen:SetActive(true);
    self.comBtnGreenText.text = '确定';
    self.objBtnRed:SetActive(true);
    self.comBtnRedText.text = '取消';

    if bIsTableContent then
        self.comTitleText.text = tostring(content.title or "")
    else
        self.comTitleText.text = '系统提示'
    end

    -- itemicon
    if content.ItemID and content.ItemID > 0 then
        self.itemRoot.gameObject:SetActive(true)
        local itemID = content.ItemID
        local ItemNum = content.ItemNum
        local ItemCost = content.ItemCost
        local itemdata = TableDataManager:GetInstance():GetTableData("Item",itemID)
        if itemdata then
            self.ItemIconUI:UpdateUIWithItemTypeData(self.objItemIconUI, itemdata)
            self.comNum.text = string.format('(%d / %d)',ItemNum,ItemCost)
            self.comName.text = itemdata.ItemName or ''
            --self.comName.color = getRankColor(itemdata.Rank)
        end
    end
end

-- 获取勾选框的选中状态
function GeneralBoxUI:GetCheckBoxState()
    return (self.toggleCheckBox.isOn == true)
end

function GeneralBoxUI:IsInputAllow()
  if (self.isinputok) then
    return self.isinputok()
  end

  return true
end

return GeneralBoxUI