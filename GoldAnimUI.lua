GoldAnimUI = class("GoldAnimUI",BaseWindow)

function GoldAnimUI:ctor()
    self._coroutine = {}
end

function GoldAnimUI:Create()
	local obj = LoadPrefabAndInit("Game/GoldAnimUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function GoldAnimUI:Init()

    self.resource_box = self:FindChild(self._gameObject, "resource_box")

    self.objJinZhuan = self:FindChild(self.resource_box, "JinZhuan")
    self.objYuanBao = self:FindChild(self.resource_box, "YuanBao")
    self.objTongBi = self:FindChild(self.resource_box, "TongBi")

    self.objJinZhuan:SetActive(false)
    self.objYuanBao:SetActive(false)
    self.objTongBi:SetActive(false)

    -- 原始坐标
    local pos_JinZhuan = self.objJinZhuan.transform.position
    local pos_YuanBao = self.objYuanBao.transform.position
    local pos_TongBi = self.objTongBi.transform.position

    -- 资源图标 obj
    self.obj_image_jz = self:FindChild(self.objJinZhuan, "Image")
    self.obj_image_yd = self:FindChild(self.objYuanBao, "Image")
    self.obj_image_tb = self:FindChild(self.objTongBi, "Image")

    -- 资源值 文字
    self.com_jz_value = self:FindChildComponent(self.objJinZhuan,"Text","Text")
    self.com_yd_value = self:FindChildComponent(self.objYuanBao,"Text","Text")
    self.com_tb_value = self:FindChildComponent(self.objTongBi,"Text","Text")

    -- flowords 模板
    self.obj_jz_words = self:FindChild(self._gameObject, "jz_words")
    self.obj_yd_words = self:FindChild(self._gameObject, "yd_words")
    self.obj_tb_words = self:FindChild(self._gameObject, "tb_words")

    -- 动画池
    self.flowords_box = self:FindChild(self._gameObject, "flowords_box")
    self.icon_box = self:FindChild(self._gameObject, "icon_box")

    -- icon 模板
    self.obj_jz_icon = self:FindChild(self._gameObject, "jz_icon")
    self.obj_yd_icon = self:FindChild(self._gameObject, "yd_icon")
    self.obj_tb_icon = self:FindChild(self._gameObject, "tb_icon")

    self.sequence = nil

    -- 资源表
    self.TypeToUI = {
        [GOLD_ANIM.GOLD]   = {
            ['resource'] = self.objJinZhuan,
            ['image'] = self.obj_image_jz,
            ['value'] = self.com_jz_value,
            ['floword'] = self.obj_jz_words,
            ['icon'] = self.obj_jz_icon,
            ['position'] = DRCSRef.Vec3(pos_JinZhuan.x, pos_JinZhuan.y, pos_JinZhuan.z),
        },
        [GOLD_ANIM.SLIVER] = {
            ['resource'] = self.objYuanBao, 
            ['image'] = self.obj_image_yd,
            ['value'] = self.com_yd_value,
            ['floword'] = self.obj_yd_words,
            ['icon'] = self.obj_yd_icon,
            ['position'] = DRCSRef.Vec3(pos_YuanBao.x, pos_YuanBao.y, pos_JinZhuan.z),
        },
        [GOLD_ANIM.COIN]   = {
            ['resource'] = self.objTongBi,
            ['image'] = self.obj_image_tb,
            ['value'] = self.com_tb_value,
            ['floword'] = self.obj_tb_words,
            ['icon'] = self.obj_tb_icon,
            ['position'] = DRCSRef.Vec3(pos_TongBi.x, pos_TongBi.y, pos_JinZhuan.z),
        },
    }
end

function GoldAnimUI:RefreshUI(info)
    if info then
        self:PlayGoldAnim(info['before'], info['after'], info['type'])
    end
end

function GoldAnimUI:PlayGoldAnim(before, after, type)
    if not (before and after and type) then return end
    if before >= after then return end
    PlayButtonSound("EventGold")
    if self.sequence then
        self.sequence:Kill()
    end
    self.sequence = DRCSRef.DOTween:Sequence()
    local noFade = self:CoverWindowBarUI(type)

    local UI_group = self.TypeToUI[type]

    UI_group['resource']:SetActive(true)
    self:FadeInOut(self.resource_box, noFade)
    --self:IconFly(type)
    self:NumberRoll(UI_group['value'], before, after)
    self:NumberShake(UI_group['value'])
    self:AddFloword(UI_group['floword'], after - before)
end

-- 飘字（1075ms）
function GoldAnimUI:AddFloword(obj, value)
    local ui_clone = CloneObj(obj, self.flowords_box)
    if (ui_clone ~= nil) then
        ui_clone:SetActive(true)
        ui_clone.transform.localPosition = obj.transform.localPosition
        local comText = self:FindChildComponent(ui_clone, "Text","Text")
        comText.text = string.format( "+%d", value)
        local comDT = ui_clone:GetComponent('DOTweenAnimation')
        comDT:DOPlayAllById('anim')
        comDT.tween:OnComplete(function()
            DRCSRef.ObjDestroy(ui_clone)
        end)
    end
end


-- 物品飞入（9个，750ms，每个延迟50ms）
function GoldAnimUI:IconFly(type)
    local mousePos = GetTouchUIPos()
    
    local UI_group = self.TypeToUI[type]
    local target = UI_group['image'].transform.localPosition
    local finalPos = SystemUICall:GetInstance():TransformPoint( target, UI_group['resource'], self.icon_box )
    local child = UI_group['icon']

    -- FIXME：是不是可以不停，就全都一直飞
	if self._coroutine[type] then
		CS_Coroutine.stop(self._coroutine[type])
		self._coroutine[type] = nil
    end
    
    -- 起一个协程，来控制等待时间
	self._coroutine[type] = CS_Coroutine.start(function()
        -- 这里用 协程 或者 sequence 都能做，练练手
        for i = 1, 9 do
            local wait_time = math.random(20, 80)
            local ran_x = math.random(-40, 40)
            local ran_y = math.random(-25, 25)
            mousePos.x = mousePos.x + ran_x
            mousePos.y = mousePos.y + ran_y
            -- dprint('起始位置：',mousePos.x,' ',mousePos.y,'  终点位置：',finalPos.x,' ',finalPos.y)
            coroutine.yield(CS.UnityEngine.WaitForSeconds(wait_time/ 1000))
            self:IconFlyChild(child, mousePos, finalPos)
        end
    end)
end


-- 物品飞入：子节点（750ms）/ TODO: rotate 先不处理旋转
function GoldAnimUI:IconFlyChild(obj, startPos, endPos)
    --
    local ui_clone = CloneObj(obj, self.icon_box)
    if (ui_clone == nil) then
        return
    end
    local objImage = obj.transform:GetChild(0).gameObject
    --local comImage = objImage:GetComponent('Image')
    --comImage.color = DRCSRef.Color(1,1,1,0)
    ui_clone:SetActive(true)
    ui_clone.transform.localPosition = startPos

    -- 计算中间点位置 / y 越大，越在上方
    local mid_x = 0.9 * startPos.x + 0.1 * endPos.x
    local mid_y
    if endPos.y > startPos.y then
        mid_y = startPos.y - 60
    else
        mid_y = startPos.y + 60
    end

    -- 125ms 显现，最后消失
    --comImage:DOFade(1, 0.125)
    --  local tween1 = comImage:DOFade(0, 0.1):SetDelay(0.7)
    --  tween1.onComplete = function()
    -- --     DRCSRef.ObjDestroy(ui_clone)
    --  end
    globalTimer:AddTimer(800, function()
        DRCSRef.ObjDestroy(ui_clone)
    end)

    -- 250ms 缩放到原大小，500ms 不等比例缩放
    ui_clone.transform.localScale = obj.transform.localScale * 0.5
    local tween2 = ui_clone.transform:DOScale(obj.transform.localScale, 0.25)
    tween2.onComplete = function()
        if obj and ui_clone then
            local scaleX = obj.transform.localScale.x * 2/5
            local scaleY = obj.transform.localScale.y * 3/5 
            ui_clone.transform:DR_DOScaleX(scaleX)
            ui_clone.transform:DR_DOScaleY(scaleY)
        end
    end

    -- 两段式横向移动
    local tween3 = ui_clone.transform:DOLocalMoveX(mid_x, 0.25)
    tween3.onComplete = function()
        if ui_clone then
            ui_clone.transform:DR_DOLocalMoveX(endPos.x, 0.5)
        end
    end
    tween3:SetEase(DRCSRef.Ease.InQuad)

    -- 两段式纵向移动
    local tween4 = ui_clone.transform:DOLocalMoveY(mid_y, 0.25)
    tween4.onComplete = function()
        if ui_clone then
            local tween5 = ui_clone.transform:DOLocalMoveY(endPos.y, 0.5)
            tween5:SetEase(DRCSRef.Ease.InCubic)
        end
        --DRCSRef.ObjDestroy(ui_clone)
    end
    tween4:SetEase(DRCSRef.Ease.OutCubic)
end


-- 数字震动（300 + 800 + 1000ms）
function GoldAnimUI:NumberShake(com)
    local comDT = com.gameObject:GetComponent('DOTweenAnimation')
    comDT:DORestart()
end

-- 数字滚动（1000ms）
function GoldAnimUI:NumberRoll(com, before, after)
    com.text = before   -- 初始化
    local tween = Twn_Number(nil, com, before, after, 1, 0.2)
    -- self.sequence:Append(tween)      -- 这种是串行，实际上如果同时获得银锭+铜币，应该并行
end

-- 资源淡入淡出（100 + 2000 + 200ms）
function GoldAnimUI:FadeInOut(obj, noFade)
    local canvas = obj:GetComponent('CanvasGroup')
    local comDT =  obj:GetComponent('DOTweenAnimation')

    if noFade then
        canvas.alpha = 1
        obj:SetActive(true)
        self.sequence:AppendInterval(2.3)
        self.sequence:AppendCallback(function() 
            if not self or not self.objJinZhuan then        -- UI已被销毁
                return
            end

            self.objJinZhuan:SetActive(false)
            self.objYuanBao:SetActive(false)
            self.objTongBi:SetActive(false)
            self:RevertWindowBarUI()
            canvas.alpha = 0
        end)
    else
        canvas.alpha = 0
        obj:SetActive(true)
        comDT:DORestart()
        comDT.tween:OnComplete(function() 
            if self.objJinZhuan then
                self.objJinZhuan:SetActive(false)
            end
            if self.objYuanBao then
                self.objYuanBao:SetActive(false)
            end
            if self.objTongBi then
                self.objTongBi:SetActive(false)
            end
        end)
    end
end

function GoldAnimUI:CoverWindowBarUI(type)
    if not IsWindowOpen("WindowBarUI") then
        return false
    end

    local windowBarUI = GetUIWindow("WindowBarUI")
    local resource_box = self:FindChild(windowBarUI._gameObject, "resource_box")
    local objJinZhuan = self:FindChild(resource_box, "JinZhuan")
    local objYuanBao = self:FindChild(resource_box, "YuanBao")
    local objTongBi = self:FindChild(resource_box, "TongBi")

    local TypeToUI = {
        [GOLD_ANIM.GOLD]   = objJinZhuan,
        [GOLD_ANIM.SLIVER] = objYuanBao,
        [GOLD_ANIM.COIN]   = objTongBi,
    }

    TypeToUI[type]:GetComponent('CanvasGroup').alpha = 0
    local pos = TypeToUI[type].transform.position

    self.TypeToUI[type].resource.transform.position = pos
    local pos_floword = self.TypeToUI[type].floword.transform.position
    pos_floword = DRCSRef.Vec3(pos.x + 0.6, pos_floword.y, pos_floword.z)
    self.TypeToUI[type].floword.transform.position = pos_floword

    return true
end

function GoldAnimUI:RevertWindowBarUI()
    if WindowsManager:GetInstance():GetWindowState("WindowBarUI") == UIWindowState.UNCREATE then
        return
    end

    local windowBarUI = GetUIWindow("WindowBarUI")
    local resource_box = self:FindChild(windowBarUI._gameObject, "resource_box")
    local objJinZhuan = self:FindChild(resource_box, "JinZhuan")
    local objYuanBao = self:FindChild(resource_box, "YuanBao")
    local objTongBi = self:FindChild(resource_box, "TongBi")

    local resList = {objJinZhuan, objYuanBao, objTongBi}

    for index, objRes in ipairs(resList) do
        objRes:GetComponent('CanvasGroup').alpha = 1
    end

    for type, res in pairs(self.TypeToUI) do
        res.resource.transform.position = res.position
        local pos_floword = res.floword.transform.position
        pos_floword = DRCSRef.Vec3(res.position.x, pos_floword.y, pos_floword.z)
        res.floword.transform.position = pos_floword
    end
end

function GoldAnimUI:OnDestroy()
    if self.sequence then
        self.sequence:Kill()
    end

    self:RevertWindowBarUI()
end

return GoldAnimUI