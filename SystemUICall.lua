SystemUICall = class("SystemUICall")
SystemUICall._instance = nil

function SystemUICall:GetInstance()
    if SystemUICall._instance == nil then
        SystemUICall._instance = SystemUICall:new()
    end

    return SystemUICall._instance
end

function SystemUICall:TipsPop(tips, buttons, max_num, raycast)
    if not (tips and type(tips) == 'table') then return end
    tips['buttons'] = buttons
    tips['max_num'] = max_num
    tips['raycast'] = raycast
    
    OpenWindowImmediately("TipsPopUI", tips)
end

-- 转换相对坐标
function SystemUICall:TransformPoint( pos, parentFrom, parentTo )
    local worldPos = parentFrom.transform:TransformPoint(pos)
    return parentTo.transform:InverseTransformPoint(worldPos)
end

-- 设置为秘钥模式: 屏蔽所有Toast, 只有传入正确key的才会弹出
function SystemUICall:SetKeyModel(strKey)
    self.strPassKey = strKey
end

-- 关闭秘钥模式
function SystemUICall:CloseKeyModel()
    self.strPassKey = nil
end

function SystemUICall:AddToast(info, key)
    if self.strPassKey and (key ~= self.strPassKey) then
        return
    end
    if (WindowsManager:GetInstance():IsWindowOpen("ToastUI") == false) then
        OpenWindowImmediately("ToastUI", info)
    else
        local toastUI = WindowsManager:GetInstance():GetUIWindow("ToastUI")
        if toastUI ~= nil then
            toastUI:AddToast(info)
        end
    end
end

-- 加入一条聊天信息
function SystemUICall:AddChat(info)
    if (WindowsManager:GetInstance():IsWindowOpen("ChatBoxUI") == false) then
        OpenWindowImmediately("ChatBoxUI", info)
    else
        local ui = WindowsManager:GetInstance():GetUIWindow("ChatBoxUI")
        ui:AddNotice(info)
    end
end

-- 加入一条聊天信息到世界频道
function SystemUICall:AddChat2BCT(strText)
    if (not strText) or (strText == "") then
        return
    end
    self:AddChat({channel = BroadcastChannelType.BCT_System, content = strText})
end

-- 弹出 Toast，添加提示 addToast
function SystemUICall:Toast(text, isChat, toastType, key)
    local info = {
        ['text'] = text,
        ['type'] = toastType or TOAST_TYPE.NORMAL,
    }
    self:AddToast(info, key)
    -- 默认显示到聊天框
    if isChat == nil then isChat = true end

    if not IsWindowOpen("LoginUI") and isChat then
        self:AddChat({channel = BroadcastChannelType.BCT_System, content = text})
    end
end
-- 添加系统消息 addSystemToast
function SystemUICall:SystemToast(text)
    local info = {
        ['text'] = text,
        ['type'] = TOAST_TYPE.SYSTEM,
    }
    self:AddToast(info)
end
-- 添加任务开始提示 addbegintoast
-- 任务开始提示必须在对话后，因此应该加入动画队列中。
-- 已在上层加入队列
function SystemUICall:TaskBeginToast(text)
    self:Toast(text, false, TOAST_TYPE.TASK)
end

-- 资源动画，先只做银锭的
function SystemUICall:PlayGoldAnim(before, after, type)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_SHOW_GOLD_ANIM, false, before, after, type)
end

-- 弹幕
function SystemUICall:BarrageShow(text, needDisplayActionEnd)
    local iRenameCount = PlayerSetDataManager:GetInstance():GetReNameNum() or 0
    -- 玩家起名状态
    if iRenameCount == 0 then 
        return 
    end 
    
    if (WindowsManager:GetInstance():IsWindowOpen("BarrageUI") ~= true) then
        OpenWindowImmediately("BarrageUI", text)
    else
        local ui = WindowsManager:GetInstance():GetUIWindow("BarrageUI")
        if ui then
            ui:AddBarrage(text)
        end
    end
    if needDisplayActionEnd then 
        DisplayActionEnd()
    end
end

-- 弹幕
function SystemUICall:BarrageLoginShow(data)
    local barrageUI = GetUIWindow("BarrageUI");
    if not barrageUI then
        OpenWindowImmediately("BarrageUI");
        barrageUI = GetUIWindow("BarrageUI");
        barrageUI:ShowLoginBarrage(data);
    else
        if barrageUI then
            barrageUI:ShowLoginBarrage(data);
        end
    end
end

-- 红包
function SystemUICall:BarrageRedPacketShow(data)
    local barrageUI = GetUIWindow("BarrageUI");
    if not barrageUI then
        OpenWindowImmediately("BarrageUI");
        barrageUI = GetUIWindow("BarrageUI");
        barrageUI:ShowRedPacketBarrage(data);
    else
        if barrageUI then
            barrageUI:ShowRedPacketBarrage(data);
        end
    end
end

-- 气泡
function SystemUICall:AddBubble(text)
    local info = {
        ['text'] = text,
    }
    if not WindowsManager:GetInstance():IsWindowOpen("ChatBubble") then
        OpenWindowImmediately("ChatBubble", info);
    else
        local chatBubble = WindowsManager:GetInstance():GetUIWindow("ChatBubble");
        if chatBubble then
            chatBubble:AddChatBubble(info);
        end
    end
end


function SystemUICall:WarningBox(text)
    if (not text) or (text == "") then
        return
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, text, nil, {confirm = true}})
end
