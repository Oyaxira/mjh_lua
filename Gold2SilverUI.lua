Gold2SilverUI = class("Gold2SilverUI", BaseWindow)


function Gold2SilverUI:Create()
    local obj = LoadPrefabAndInit("Game/Gold2SilverUI",TIPS_Layer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function Gold2SilverUI:Init()
    self.objRoot = self:FindChild(self._gameObject, "Board")
    self.ojbClose = self:FindChildComponent(self._gameObject, "Button_close", "Button")
    self:AddButtonClickListener(self.ojbClose, function()
        self:DoExit()
    end)
    --self.textDescWay = self:FindChildComponent(self.objRoot, "Desc/Text", "Text")
    self.objControl = self:FindChild(self.objRoot, "Control")
    self.objControlBoard = self:FindChild(self.objControl, "Board")
    self.transControlBoard = self.objControlBoard.transform
    self.twnControlBoard = self.objControlBoard:GetComponent("DOTweenAnimation")

    self.objTrans = self:FindChild(self.objControlBoard, "Trans")
    self.objTransMyGold = self:FindChild(self.objTrans, "MyGold")
    self.objTransNum = self:FindChild(self.objTrans, "TransNum")
    self.btnTransNum = self:FindChildComponent(self.objTransNum, "Value", "Button")
    self:AddButtonClickListener(self.btnTransNum, function()
        self:ClearInput()
        self:SetInputPanel(true)
    end)
    self.objTransGetSilver = self:FindChild(self.objTrans, "GetSilver")
    self.textTransMyGold = self:FindChildComponent(self.objTransMyGold, "Value/Text", "Text")
    self.textTransNum = self:FindChildComponent(self.objTransNum, "Value/Text", "Text")
    self.textTransGetSilver = self:FindChildComponent(self.objTransGetSilver, "Value/Text", "Text")
    self.objTransBtns = self:FindChild(self.objTrans, "Button")
    self.btnTransCancel = self:FindChildComponent(self.objTransBtns, "Cancel", "Button")
    self:AddButtonClickListener(self.btnTransCancel, function()
        self:DoExit()
    end)
    self.btnTransComfirm = self:FindChildComponent(self.objTransBtns, "Trans", "Button")
    self:AddButtonClickListener(self.btnTransComfirm, function()
        self:DoGoldToCoin()
    end)

    self.objTouchDisable = self:FindChild(self.objControl, "TouchDisable")

    self.objInput = self:FindChild(self.objControlBoard, "Input")
    self.objInputNum = self:FindChild(self.objInput, "Num")
    self.textInputNum = self:FindChildComponent(self.objInputNum, "Value/Text", "Text")
    self.btnInputNumEmpty = self:FindChildComponent(self.objInputNum, "Empty", "Button")
    self:AddButtonClickListener(self.btnInputNumEmpty, function()
        self:ClearInput()
    end)

    self.objKeyBoard = self:FindChild(self.objInput, "KeyBoard")
    self.btnKeyBoardCancel = self:FindChildComponent(self.objKeyBoard, "Cancel", "Button")
    self:AddButtonClickListener(self.btnKeyBoardCancel, function()
        self:SetInputPanel(false)
    end)
    self.btnKeyBoardConfirm = self:FindChildComponent(self.objKeyBoard, "Confirm", "Button")
    self:AddButtonClickListener(self.btnKeyBoardConfirm, function()
        self:SetTransNum()
    end)

    self:InitKeyBoardNumListener()

    -- 其他值
    self.MAX_TANS_NUM = 9999
end

function Gold2SilverUI:InitKeyBoardNumListener( )
    if not self.objKeyBoard then
        return
    end
    local objChild = nil
    local btnChild = nil
    -- 数字0~9
    for iNum = 0, 9 do
        objChild = self:FindChild(self.objKeyBoard, tostring(iNum))
        if objChild then
            btnChild = objChild:GetComponent("Button")
            self:AddButtonClickListener(btnChild, function()
                self:SetInput(iNum)
            end)
        end
    end
end

function Gold2SilverUI:RefreshUI(info)
    self.iCurTransNum = 1  -- 兑换数额
    self.strCurInput = ""
    self.transControlBoard.localPosition = DRCSRef.Vec3Zero
    self.objTouchDisable:SetActive(false)
    --self:SetDesc()
    self:SetValue()
end
--[[
function Gold2SilverUI:SetDesc()
    self.textDescWay.text = "银锭获取途径:\n1.剧本结束奖励\n2.与角色闲聊"
end
--]]
function Gold2SilverUI:SetValue()
    self.textTransMyGold.text = PlayerSetDataManager:GetInstance():GetPlayerGold() or 0
    self.iCurTransNum = self.iCurTransNum or 0
    self.textTransNum.text = (self.iCurTransNum == 0) and "点击输入" or tostring(self.iCurTransNum)
    self.textTransGetSilver.text = tostring(self.iCurTransNum * SSD_EXCHAGE_GOLD_TO_SILVER)
end

function Gold2SilverUI:DoGoldToCoin()
    local iToTransNum = self.iCurTransNum or 0
    if iToTransNum <= 0 then
        SystemUICall:GetInstance():Toast('请输入正确兑换数额')
        return
    end
    local iHaveGoldNum = PlayerSetDataManager:GetInstance():GetPlayerGold() or 0
    if iHaveGoldNum >= iToTransNum then
        local msg =  string.format("是否耗费%d金锭, 兑换%d银锭?", iToTransNum, iToTransNum * SSD_EXCHAGE_GOLD_TO_SILVER)
        local boxCallback = function()
            -- 这里手动转换金锭之前清空一下自动银锭转换的回调, 防止转换回来执行了错误的逻辑
            PlayerSetDataManager:GetInstance():ClearSilverExchangeCallBack()
            SendExchangeGoldToSilver(iToTransNum)
            self:DoExit()
        end
        PlayerSetDataManager:GetInstance():RequestSpendGold(iToTransNum, boxCallback, true, msg)
    else
        local msg =  "金锭余额不足, 是否跳转到充值界面?"
        local boxCallback = function()
            OpenWindowImmediately("ShoppingMallUI")
            local win = GetUIWindow("ShoppingMallUI")
            if win then 
                win:SetPayTag()
            end
            --SystemUICall:GetInstance():Toast('暂未开放金锭充值')
            self:DoExit()
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
    end
end

function Gold2SilverUI:SetInputPanel(bShow)
    bShow = bShow == true
    self.objTouchDisable:SetActive(true)
    if not self.iMoveDis then
        self.iMoveDis = self.objControlBoard:GetComponent("RectTransform").rect.height
    end
    local iMove = (bShow and 1 or -1) * self.iMoveDis
    local fMoveTime = 0.5
    local twn = Twn_MoveBy_Y(nil, self.objControlBoard, iMove, fMoveTime, nil, function()
        self.objTouchDisable:SetActive(false)
    end)
    if (twn ~= nil) then
        twn:SetAutoKill(true)
    end
end

function Gold2SilverUI:SetInput(iNum)
    if (not iNum) or (iNum < 0) then
        return
    end
    self.strCurInput = self.strCurInput .. tostring(iNum)
    local iSum = tonumber(self.strCurInput)
    if iSum > self.MAX_TANS_NUM then 
        self.strCurInput = tostring(self.MAX_TANS_NUM) 
    end
    self.textInputNum.text = self.strCurInput
end

function Gold2SilverUI:SetTransNum()
    if (not self.strCurInput) or (self.strCurInput == "") then 
        return 
    end
    local iNum = tonumber(self.strCurInput)
    self.iCurTransNum = iNum
    self:SetInputPanel(false)
    -- 重新设置数据
    self.strCurInput = ""
    self:SetValue()
end

function Gold2SilverUI:ClearInput()
    self.textInputNum.text = ""
    self.strCurInput = ""
end

function Gold2SilverUI:DoExit()
    RemoveWindowImmediately("Gold2SilverUI")
end

return Gold2SilverUI