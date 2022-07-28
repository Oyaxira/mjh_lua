TipsPopUI = class("TipsPopUI",BaseWindow)

local redColor = DRCSRef.Color(1, 0, 0, 1);
local normalColor = DRCSRef.Color(0xCB / 255, 0xCB / 255, 0xCC / 255, 1);
local TipsType = {
    ["Main"] = 1,
    ["Sub"] = 2,
}
local kKind2Width = {
    ["normal"] = 330,
    ["middle"] = 415,
    ["wide"] = 500,
    ["rolecardui"] = 250,
    ["btn"] = 80
}

function TipsPopUI:ctor()

end

function TipsPopUI:Create()
	local obj = LoadPrefabAndInit("TipsUI/TipsPopUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TipsPopUI:Init()
    self.comScrollbar = self:FindChildComponent(self._gameObject,"Scrollbar","Scrollbar")
    self.comRayCastButton = self:FindChildComponent(self._gameObject,"raycast","Button")
    -- 点击关闭
    self:RemoveButtonClickListener(self.comRayCastButton)
    self:AddButtonClickListener(self.comRayCastButton, function ()
        self:CloseTips()
    end)
    -- tips正文
    self.objMainTips = self:FindChild(self._gameObject,"Tips")
    self.canvasGroupMainTip = self.objMainTips:GetComponent("CanvasGroup")
    self.objSubTips = self:FindChild(self.objMainTips,"SubTips")
    self.objBtnTips = self:FindChild(self._gameObject,"BtnTips")
    self.comContentBG = self.objBtnTips:GetComponent("Image")
    self.comBtnContent = self:FindChildComponent(self.objBtnTips,"Text","Text")
    self.akAllTips = {
        [TipsType.Main] = self.objMainTips,
        [TipsType.Sub] = self.objSubTips,
    }
    self.kTipsComs = {}
    for index, objTips in ipairs(self.akAllTips) do
        local coms = {}
        coms.objText_equip_now = self:FindChild(objTips,"Text_equip_now")
        coms.comText_equip_now = coms.objText_equip_now:GetComponent("Text")  -- 当前装备
        coms.objTitle_box = self:FindChild(objTips,"Title_box")
            coms.objTitle = self:FindChild(coms.objTitle_box,"Title/Text")
            coms.comTitle = coms.objTitle:GetComponent("Text")  -- 标题
            coms.objState = self:FindChild(coms.objTitle_box,"State")
            coms.comState = coms.objState:GetComponent("Text")  -- 状态
        coms.objText_forge = self:FindChild(objTips,"Text_forge")
        coms.comForge = coms.objText_forge:GetComponent("Text")  -- 强化
        coms.objText_time = self:FindChild(objTips,"Text_time")
        coms.comTime = coms.objText_time:GetComponent("Text")  -- 时间
        coms.objText_regular = self:FindChild(objTips,"Text_regular")
        coms.comRegular = coms.objText_regular:GetComponent("Text")  -- 固定内容（基本弃用） 
        coms.objSC_Content = self:FindChild(objTips,"SC_Content")
        coms.comSC_Content_Layout = coms.objSC_Content:GetComponent("LayoutElement")
        coms.comSC_Content_MaxSize = coms.objSC_Content:GetComponent("LayoutMaxSize")
            coms.objContentArea = self:FindChild(coms.objSC_Content,"Content")
            coms.objContent = self:FindChild(coms.objSC_Content,"Content/Text_content")
            coms.comContent = coms.objContent:GetComponent("Text")  -- 内容
            coms.objCreator = self:FindChild(coms.objSC_Content,"Content/Text_creator")
            coms.comCreator = coms.objCreator:GetComponent("Text")  -- 制造者
        coms.objnum_box = self:FindChild(objTips,"num_box")
        coms.objnum_box:SetActive(false)   --默认不显示数量选择
            coms.comButton_minus = self:FindChildComponent(coms.objnum_box, "Button_minus", "Button")  -- 数量减
            coms.comButton_add = self:FindChildComponent(coms.objnum_box, "Button_add", "Button")  -- 数量加
            coms.comButton_all = self:FindChildComponent(coms.objnum_box, "Button_all", "Button")  -- 数量全部
            coms.comButtonAll_Text = self:FindChildComponent(coms.objnum_box, "Button_all/Text", "Text")  -- 数量全部文字
            coms.comNumber = self:FindChildComponent(coms.objnum_box, "Image/Number", "Text")  -- 数量
            coms.comNumberBtn = self:FindChildComponent(coms.objnum_box, "Image/Number", "Button")
            coms.comNumberInputField = self:FindChildComponent(coms.objnum_box, "Image/InputField", "InputField")
            local AddButtonClickListener = function(comBtn,func)
                self:AddButtonClickListener(comBtn,func)
            end
            local GetMaxNum = function()
                if coms.infinite then 
                    return tonumber(dtext(988))
                else
                    return coms.max_num or 0
                end
            end
            local UpdateUI = function(curNumber,curRemainNum)
                coms.choose_num = curNumber
                self:UpdateNum(index)
            end
            BindInputFieldAndText(AddButtonClickListener,coms.comNumberBtn,coms.comNumberInputField,coms.comNumber,GetMaxNum,UpdateUI,true)
        coms.objdiv_2 = self:FindChild(objTips,"div_2")  -- 下分割线
        coms.objbutton_box = self:FindChild(objTips,"button_box")  -- 按钮组，现在是固定了两个按钮
        coms.objBtnTemplate = self:FindChild(coms.objbutton_box, "Button")
        self.kTipsComs[index] = coms
    end
    self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
end

function TipsPopUI:ShowBtnTips(isTrue)
    self.objMainTips:SetActive(isTrue==false)
    self.objBtnTips:SetActive(isTrue==true)
end

function TipsPopUI:RefreshUI(info)
    if not info then
        derror("[TipsPopUI:RefreshUI] 提供给tips显示的数据为空")
        return
    end
    -- 先隐藏tips, 等到内容/高度/位置设置完毕后, 再显示出来
    self.canvasGroupMainTip.alpha = 0
    -- 刷新tips
    self:UpdateTips(info, TipsType.Main)
    local objSubTips = self.akAllTips and self.akAllTips[TipsType.Sub]
    if objSubTips then
        if info.compareTips then
            self:UpdateTips(info.compareTips, TipsType.Sub)
        end
        self.bSubTipsShow = info.compareTips ~= nil
        objSubTips:SetActive(self.bSubTipsShow)
    end
end

function TipsPopUI:OnDestroy()
    RemoveEventTrigger(self.comRayCastButton.gameObject)
end

function TipsPopUI:UpdateTips(tips, eType)
    eType = eType or TipsType.Main
    if not (tips and eType) then
        return
    end
    self:SetTips(tips, eType)      -- 设置基础属性
    self:InitNum(tips, eType)      -- 设置数量
    self:SetButton(tips, eType)    -- 设置按钮与回调
    self:UpdateSize(tips, eType)   -- 更新 tips 的大小
end

-- local tips = {
--     ['title'] = '',             -- 标题
--     ['titlestyle'] = '',       -- 'normal/outline'
--     ['content'] = '',           -- 内容
--     ['iscurrentitem'] = '',     -- 当前装备/当前激活的XX材料
--     ['type'] = '',              -- 当前激活的材料类型
--     ['const_content'] = '',     -- 固定内容（基本弃用）
--     ['level'] = '',             -- 强化等级
--     ['titlecolor'] = nil,       -- 标题颜色
--     ['state'] = '',             -- （状态）有状态的时候
--     ['author'] = '',            -- 道具的制造者信息(o_role)
--     ['compareTips'] = '',       -- 用于比较对象的显示，在角色、战斗、门派界面使用，本身也是一个tips结构
--     ['head'] = '',              -- 头像
--     ['kind'] = '',              -- 类型，'normal','middle','wide','skill'
--     ['buttons'] = {
--         {
--             ['name'] = 'btn1',  -- tips按钮的名字
--             ['func'] = nil  -- 点击tips按钮的回调函数
--         },
--         {
--             ['name'] = 'btn2',
--             ['func'] = nil   
--         }
--     },
--     ['max_num'] = 0,            -- 最大数量
--     ['pierce'] = false,         -- 该tips是否可穿透
-- }
function TipsPopUI:SetTips(tips, eType)
    eType = eType or TipsType.Main
    if (not self.kTipsComs[eType]) 
    or ((tips.title == nil or tips.title == '') and (tips.content == nil or tips.content == '') and (tips.btnContent == nil or tips.btnContent == '')) then
        self:CloseTips()
        return
    end
    local coms = self.kTipsComs[eType]
    self.tips = tips
    if tips.iscurrentitem then
        if tips.type then
            coms.comText_equip_now.text = "当前激活的"..tips.type.."材料:"
        else
            coms.comText_equip_now.text = "当前装备"
        end
        coms.objText_equip_now:SetActive(true)
    else
        coms.objText_equip_now:SetActive(false)
    end
    if tips.title ~= nil and tips.title ~= '' then
        coms.objTitle_box:SetActive(true)
        coms.comTitle.text = tips.title
    else
        coms.objTitle_box:SetActive(false)
    end
    if tips.const_content ~= nil and tips.const_content ~= '' then
        coms.objText_regular:SetActive(true)
        coms.comRegular.text = tips.const_content 
    else
        coms.objText_regular:SetActive(false)
    end
    if tips.level ~= nil then
        coms.objText_forge:SetActive(true)
        coms.comForge.text = tips.level
    else
        coms.objText_forge:SetActive(false)
    end

    --
    if tips.uiDueTime and tips.uiDueTime > 0 then
        local characterUI = GetUIWindow('CharacterUI');
        local storageUI = GetUIWindow('StorageUI');
        local shoppingMallUI = GetUIWindow('ShoppingMallUI');

        local _timeToString = function(time)
            if time > 0 then
                local d = math.floor(time / 60 / 60 / 24);
                local h = math.floor(time / 60 / 60) % 24;
                local m = math.floor(time / 60) % 60;
                local s = math.floor(time) % 60;
    
                if d > 0 then
                   return string.format('%d天%d小时', d, h);
                end
                if h > 0 then
                    return string.format('%d小时%d分钟', h, m);
                end
                if m > 0 then
                    return string.format('%d分钟%d秒', m, s);
                end
                return '1分钟', false;
            else
                return '已过期', true;
            end
        end

        local strText = '';
        local overTime = false;
        if tips.dueTimeType == DueTimeType.DTT_LENGTH then
            if characterUI or storageUI then
                strText, overTime = _timeToString(tips.uiDueTime - os.time());
            elseif shoppingMallUI then
                strText, overTime = _timeToString(tips.timeValue);
            end
        elseif tips.dueTimeType == DueTimeType.DTT_DATE then
            if characterUI or storageUI then
                strText, overTime = _timeToString(tips.uiDueTime - os.time());
            elseif shoppingMallUI then
                strText, overTime = os.date('%Y年%m月%d日 %H:%M:%S', tips.timeValue);
            end
        end
        coms.comTime.text = strText .. '后过期';
        if overTime then
            coms.comTime.color = redColor;
        else
            coms.comTime.color = normalColor;
        end
        coms.objText_time:SetActive(true);
    else
        coms.objText_time:SetActive(false);
    end

    if tips.titlecolor then 
        coms.comTitle.color = tips.titlecolor
    else
        coms.comTitle.color = getUIColor('white')
    end
    -- if tips.titlestyle == "outline" then
    --     coms.comTitle.outlineWidth = 1
    -- else
    --     coms.comTitle.outlineWidth = 0
    -- end

    if tips.state then 
        coms.objState:SetActive(true) 
        coms.comState.text = tips.state 
    else
        coms.objState:SetActive(false)
    end
    if tips.content then 
        -- 将 content 的滚动栏重新置顶（需要测试）
        coms.objContentArea.transform.localPosition =  DRCSRef.Vec3Zero
        coms.objContent:SetActive(true)
        coms.comContent.text = tips.content
    else
        coms.objContent:SetActive(false)
    end
    if tips.author then 
        coms.objCreator:SetActive(true)
        --设置道具的制造者信息
        coms.comCreator.text = '作者:' .. tips.author['name']   -- 需要注意英文
    else
        coms.objCreator:SetActive(false)
    end
    if tips.btnContent then
        self.comBtnContent.text = tips.btnContent
        if tips.contentBg then
            self.comContentBG.sprite = tips.contentBg
        end
        self:ShowBtnTips(true)
    else
        self:ShowBtnTips(false)

    end
end

-- 规则1：Tips顶部与鼠标平齐，间距 40
-- 规则2：Tips默认显示在右边，如果右边显示不下再放到左边
-- 规则3：如果Tips即将超出屏幕-间距，则向内收缩。
-- 规则4：如果有多个Tips，则宽度间距相加，高度计算最大，顶部对齐
function TipsPopUI:UpdatePos(tips)
    local objMainTips = self.akAllTips[TipsType.Main]
    local akMainComs = self.kTipsComs[TipsType.Main]
    local objSubTips = self.akAllTips[TipsType.Sub]
    local akSubComs = self.kTipsComs[TipsType.Sub]
    if not (akMainComs and akSubComs and objMainTips) then
        return
    end
    local mouse_pos = GetTouchUIPos()
    local rect1 = akMainComs.objSC_Content:GetComponent("RectTransform").rect
    local rect2 = objMainTips:GetComponent("RectTransform").rect
    local rect1Sub = akSubComs.objSC_Content:GetComponent("RectTransform").rect
    local rect2Sub = objSubTips:GetComponent("RectTransform").rect
    local movePosition = tips.movePositions
    local isSkew = tips.isSkew
    local isUpDown = tips.isUpDown
    ----------------X方向偏移-----------
    local deltaTip = 15  -- 两个tips之间的间距
    if mouse_pos.x + (rect2.width / 2) > (adapt_ui_w / 2) then
        mouse_pos.x = (adapt_ui_w / 2) - (rect2.width / 2)
    elseif (not self.bSubTipsShow) and (mouse_pos.x - (rect2.width / 2) < -(adapt_ui_w / 2)) then
        mouse_pos.x = (rect2.width / 2) - (adapt_ui_w / 2)
    elseif self.bSubTipsShow and (mouse_pos.x - (rect2.width / 2) - deltaTip - rect2Sub.width < -(adapt_ui_w / 2)) then
        mouse_pos.x = (rect2.width / 2) - (adapt_ui_w / 2) + rect2Sub.width + deltaTip
    end
    ----------------Y方向偏移-----------
    local diffDeltaY = 0
    local total_h = 0
    if (rect2.height < rect2Sub.height) and (self.bSubTipsShow == true) then
        diffDeltaY = (rect2Sub.height - rect1Sub.height)/2
        total_h = rect2Sub.height
    else
        diffDeltaY = (rect2.height - rect1.height)/2
        total_h = rect2.height
    end
    mouse_pos.y = mouse_pos.y + diffDeltaY
    -- 判定,如果显示的高度已经超过了屏幕的下方,那么tip需要显示向上移动
    if (mouse_pos.y - total_h < -adapt_ui_h/2 + 5) then
        mouse_pos.y = total_h - adapt_ui_h/2 + 5
    end

    if (screen_h > adapt_ui_h) then -- 
        mouse_pos.y = mouse_pos.y + (screen_h - adapt_ui_h)/2
    end

    if (mouse_pos.y > design_ui_h/2) then
        mouse_pos.y = design_ui_h/2
    end
    -- 设置位置
    
    mouse_pos.z = 0

    --默认左移右移 isUpDown 为真时 上下移动
    if isSkew then
        self.comRayCastButton.gameObject:SetActive(false)

        if not movePosition then
            movePosition = {x = 0, y = 0}--rect2.height / 2 - 70}
            if isUpDown then
                if mouse_pos.y > 0 then
                    movePosition.y = -60 - rect2.height / 2
                else
                    movePosition.y = 60 + rect2.height / 2
                end
            else
                if mouse_pos.x > 0  then
                    movePosition.x = -60 - rect2.width / 2
                else
                    movePosition.x = 60 + rect2.width / 2
                end
            end
        end
        mouse_pos.y = mouse_pos.y + movePosition.y
        mouse_pos.x = mouse_pos.x + movePosition.x
    else
        self.comRayCastButton.gameObject:SetActive(true)
    end

    objMainTips.transform.localPosition = mouse_pos
    self.objBtnTips.transform.localPosition = mouse_pos
end 

-- 设置按钮
function TipsPopUI:SetButton(tips, eType)
    eType = eType or TipsType.Main
    if not (tips and self.kTipsComs[eType]) then
        return
    end
    local coms = self.kTipsComs[eType]
    local btns = tips.buttons
    local iNeedBtnCount = btns and #btns or 0
    if iNeedBtnCount == 0 then
        coms.objbutton_box:SetActive(false)
        return
    end
    coms.objbutton_box:SetActive(true)
    local boxTransform = coms.objbutton_box.transform
    local iCurBtnCount = boxTransform.childCount
    local btnGameObj = nil
    local btnCom = nil
    local btnTextCom = nil
    local btnData = nil
    local processBtn = function(btnObj, btnData, bIsNewBtn)
        if (btnObj == nil) then
            return
        end
        btnObj:SetActive(true)
        if btnData.name then
            btnTextCom = self:FindChildComponent(btnObj, "Text", "Text")
            btnTextCom.text = btnData.name
        end
        btnCom = btnObj:GetComponent("Button")
        btnImg = btnObj:GetComponent("Image")
        if btnData.func then
            btnCom.interactable = true
            btnImg.material = nil
            if not bIsNewBtn then
                self:RemoveButtonClickListener(btnCom)
            end
            self:AddButtonClickListener(btnCom, function()
                btnData.func(coms.choose_num)
                -- 数量小于1个，需要点击关闭
                if btnData.iNum == nil then
                    self:CloseTips()
                else
                    btnData.iNum = btnData.iNum - coms.choose_num
                    if btnData.iNum - coms.choose_num < 0 then
                        self:CloseTips()
                    end
                end
            end)
        else
            btnCom.interactable = false
            btnImg.material = self.grayMat
        end
    end
    local bIsNewBtn = true
    for i = 1, iNeedBtnCount do
        btnData = btns[i]
        if i <= iCurBtnCount then
            -- 使用旧按钮
            btnGameObj = boxTransform:GetChild(i - 1).gameObject
            bIsNewBtn = false
        else
            -- 生成新的按钮
            btnGameObj = CloneObj(coms.objBtnTemplate, coms.objbutton_box)
            bIsNewBtn = true
        end
        processBtn(btnGameObj, btnData, bIsNewBtn)
    end
    -- 多余的按钮全部隐藏
    for i = iNeedBtnCount + 1, iCurBtnCount do
        boxTransform:GetChild(i - 1).gameObject:SetActive(false)
    end

    self:RemoveButtonClickListener(coms.comButton_minus)
    self:AddButtonClickListener(coms.comButton_minus, function()
        self:AddNum(-1, eType)
    end)

    self:RemoveButtonClickListener(coms.comButton_add)
    self:AddButtonClickListener(coms.comButton_add, function()
        self:AddNum(1, eType)
    end)

    self:RemoveButtonClickListener(coms.comButton_all)
    self:AddButtonClickListener(coms.comButton_all, function()
        self:AddNum(nil, eType)
    end)
end

-- 更新UI大小
function TipsPopUI:UpdateSize(tips, eType)
    eType = eType or TipsType.Main
    if not (tips and self.kTipsComs[eType]) then
        return
    end
    local coms = self.kTipsComs[eType]
    local kind = tips['kind']
    local maxsize = 432

    -- 属性影响、通用提示 是 0.8 倍
    -- 战斗技能提示 是 0.75 倍
    -- 其他情况是 0.6 倍
    if kind == nil or kind == 'normal' then
        maxsize = 0.6 * design_ui_h
    end

    if kind == 'skill' then
        maxsize = 0.75 * design_ui_h
        coms.objdiv_2:SetActive(false)
    else
        coms.objdiv_2:SetActive(true)
    end

    if kind == 'rolecardui' then
        maxsize = 0.85 * design_ui_h
    end 

    -- 如果 tips 的类型是  属性影响/通用提示，那么tips的宽度是500，否则tips的宽度是330
    if kind == 'wide' then
        maxsize = 0.8 * design_ui_h
    end
    
    SetUIAxis(coms.objSC_Content, kKind2Width[kind])
    SetUIAxis(coms.objTitle_box, kKind2Width[kind])
    SetUIAxis(coms.objbutton_box, kKind2Width[kind])

    if coms.comSC_Content_MaxSize then
        coms.comSC_Content_MaxSize.maxHeight = maxsize
    end

    self:StartCheckSCHeight(tips,eType)
end

-- 开启文字滚动栏高度修真检测
function TipsPopUI:StartCheckSCHeight(tips, eType)
    eType = eType or TipsType.Main
    if not (self.kTipsComs[eType] and self.akAllTips[eType]) then
        return
    end
    local coms = self.kTipsComs[eType]
    local scRect = coms.objSC_Content:GetComponent("RectTransform")
    local iScMaxHeight = coms.objSC_Content:GetComponent("LayoutMaxSize").maxHeight or 9999
    local contentRect = coms.objContentArea:GetComponent("RectTransform")
    local gameobjRect = self.akAllTips[eType]:GetComponent("RectTransform")
    -- 让tips节点从0开始重新计算高度
    gameobjRect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, 0) 
    local rebuildLayout = CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate
    -- 开启协程之前, 如果之前已经有对应的协程, 那么先关闭
    self.coList = self.coList or {}
    if self.coList[eType] then
        CS_Coroutine.stop(self.coList[eType])
        self.coList[eType] = nil
    end
    self.coList[eType] = CS_Coroutine.start(function()
        local loopCount = 0
        local loopLimit = 20  -- 循环上限, 防止死循环
        local objHeight = 0  -- tips节点的高度
        local scHeight = 0  -- 滚动栏的高度
        local contentHeight = 0  -- 滚动栏content节点的高度
        local iNeedRebuildThre = 1  -- 需要rebuild的阈值
        local bNeedRebuild = true  -- 是否需要build
        while bNeedRebuild and (loopCount < loopLimit) do
            loopCount = loopCount + 1
            objHeight = gameobjRect.rect.height
            scHeight = scRect.rect.height or 0
            contentHeight = contentRect.rect.height or 0
            -- 当滚动栏内容没有超过滚动栏限定的最大高度时, 如果滚动栏与内容高度相差过大, 则刷新高度
            -- 当滚动栏内容超过滚动栏最大高度时, 如果滚动栏与限定的最大高度相差过大, 则刷新高度
            -- 当tips节点连其内部的内容的高度(内容超过最大高度时用最大高度作比较)都没达到时, 刷新高度
            bNeedRebuild = ((contentHeight <= iScMaxHeight) and (math.abs(scHeight - contentHeight) > iNeedRebuildThre)) 
                or ((contentHeight > iScMaxHeight) and (math.abs(scHeight - iScMaxHeight) > iNeedRebuildThre)) 
                or ((contentHeight <= iScMaxHeight) and (objHeight < contentHeight))
                or ((contentHeight > iScMaxHeight) and (objHeight < iScMaxHeight))
            rebuildLayout(scRect)
            rebuildLayout(contentRect)
            rebuildLayout(gameobjRect)
            coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
        end
        self:UpdatePos(tips)
        self:TipsFadeIn()
    end)
end

-- 初始化数量显示
function TipsPopUI:InitNum(tips, eType)
    eType = eType or TipsType.Main
    if not self.kTipsComs[eType] then
        return
    end
    local coms = self.kTipsComs[eType]
    -- self.choose_num = 1      -- 选择数量
    -- self.max_num = 1         -- 最大数量
    -- self.infinite = false    -- 是否无限

    -- 初始化选择数量
    coms.choose_num = 1

    local maxNum = tips['max_num'] or 1
    if maxNum and maxNum > 1 then 
        coms.max_num = maxNum
        coms.comButtonAll_Text.text = dtext(990)
        coms.infinite = false
    elseif maxNum == 1 then 
        coms.objnum_box:SetActive(false) 
        return
    else
        coms.max_num = 1 
        coms.infinite = true 
        coms.comButtonAll_Text.text = dtext(989)
    end
    coms.objnum_box:SetActive(true)
    coms.comNumber.gameObject:SetActive(true)
    coms.comNumberInputField.gameObject:SetActive(false)
    self:UpdateNum(eType)
end

-- 增减数量
function TipsPopUI:AddNum(num, eType)
    eType = eType or TipsType.Main
    if not self.kTipsComs[eType] then
        return
    end
    local coms = self.kTipsComs[eType]
    if coms.comNumberInputField.gameObject.activeSelf then
        if num then
            coms.choose_num = coms.choose_num + num
            if coms.infinite then
                -- 无上限 每次加10
                coms.choose_num = coms.choose_num + 10 
            else
                if coms.choose_num >= coms.max_num then
                    coms.choose_num = coms.max_num
                end
            end
            if coms.choose_num <= 0 then
                coms.choose_num= 0
            end
        else
            coms.choose_num = coms.max_num
        end
        self:UpdateNum(eType)
    else
        if num and coms.infinite then 
            -- 无上限 改变指定数目
            if coms.choose_num + num <= 0 then 
                coms.choose_num = 0
            else
                coms.choose_num = coms.choose_num + num 
            end
        elseif num then 
            -- 有上限 改变指定数目
            if coms.choose_num + num <= 0 then 
                coms.choose_num = 0
            elseif coms.choose_num + num > coms.max_num then 
                coms.choose_num = coms.max_num
            else
                coms.choose_num = coms.choose_num + num 
            end
        elseif coms.infinite then 
            -- 无上限 加10
            coms.choose_num = coms.choose_num + 10 
        else
            coms.choose_num = coms.max_num
        end
        self:UpdateNum(eType) 
    end
end

-- 更新数量显示
function TipsPopUI:UpdateNum(eType)
    eType = eType or TipsType.Main
    if not self.kTipsComs[eType] then
        return
    end
    local coms = self.kTipsComs[eType]
    if coms.infinite then 
        coms.comNumberInputField.text = tostring(coms.choose_num)
        coms.comNumber.text = string.format("%d/%s",coms.choose_num, dtext(988))
    else
        coms.comNumberInputField.text = tostring(coms.choose_num)
        coms.comNumber.text = string.format("%d/%d",coms.choose_num,coms.max_num)
    end

    coms.comButton_minus.interactable = (coms.choose_num > 0)

    if coms.infinite or coms.choose_num < coms.max_num  then 
        coms.comButton_add.interactable = true
    else
        coms.comButton_add.interactable = false
    end
    
    coms.objbutton_box.transform:GetChild(0):GetComponent("Button").interactable = coms.choose_num>0
end

-- tips渐入
function TipsPopUI:TipsFadeIn()
    local iStartAlpha = 0
    local iEndAlpha = 1
    local fDeltaTime = 0.3
    local iDelay = 0
    self.canvasGroupMainTip:DR_DOCanvasGroupFade(0,1,0.3)
end

-- 关闭tips
function TipsPopUI:CloseTips()
    self.coList = self.coList or {}
    for eType, co in pairs(self.coList) do
        CS_Coroutine.stop(co)
    end
    self.coList = nil
    self.canvasGroupMainTip.alpha = 0
    RemoveWindowImmediately("TipsPopUI")
end

function TipsPopUI:GetScrollValue()
    return self.comScrollbar.value
end

return TipsPopUI