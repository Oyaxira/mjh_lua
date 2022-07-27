AchieveRewardUI = class("AchieveRewardUI",BaseWindow)

local PATH_EFFECT_TRAIL = "Effect/Ui_eff/ef_kapai/ef_kp_tw"

function AchieveRewardUI:Create()
	local obj = LoadPrefabAndInit("Create/AchieveRewardUI",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function AchieveRewardUI:OnPressESCKey()
    if self.Button_back then
        self.Button_back.onClick:Invoke()
    end
end

function AchieveRewardUI:Init()
    self.Reward_box = self:FindChild(self._gameObject,"Reward_box")
    self.objNavBar = self:FindChild(self.Reward_box,"NavBar")
    self.SC_reward = self:FindChild(self.Reward_box,"SC_reward")

    self.Choosen_box = self:FindChild(self._gameObject,"Choosen_box")
    self.SC_choosen = self:FindChild(self.Choosen_box,"SC_choosen") 

    self.Button_back = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/Button_back", "Button") 
    self:RemoveButtonClickListener(self.Button_back)
    self:AddButtonClickListener(self.Button_back, function() self:OnClickBack() end)

    self.Button_submit = self:FindChildComponent(self.Choosen_box, "Button_submit", "Button") 
    self:RemoveButtonClickListener(self.Button_submit)
    self:AddButtonClickListener(self.Button_submit, function() self:OnNext() end)

    self.ButtonTip = self:FindChildComponent(self.Choosen_box, "ButtonTip", "Button") 
    self:RemoveButtonClickListener(self.ButtonTip)
    self:AddButtonClickListener(self.ButtonTip, function() 
        self:OnClickTip() 
    end)

    self.objAchievePoint = self:FindChild(self.Choosen_box, "AchievePoint")
    self.Text_numt = self:FindChildComponent(self.objAchievePoint, "Text_num", "Text")
    self.comDOTween_Text = self:FindChildComponent(self._gameObject, "Text_num", "DOTweenAnimation")

    -- 成就奖励列表
    self.LoopScrollView_reward = self.SC_reward:GetComponent("LoopVerticalScrollRect")
    if self.LoopScrollView_reward then
        local fun = function(transform, idx)
            self:OnAchieveScrollChanged(transform, idx)
        end
        self.LoopScrollView_reward:AddListener(fun)
    end

    -- 已选成就奖励列表
    self.LoopScrollView_ChooseReward = self.SC_choosen:GetComponent("LoopVerticalScrollRect")
    if self.LoopScrollView_ChooseReward then
        local fun = function(transform, idx)
            self:OnAchieveChooseScrollChanged(transform, idx)
        end
        self.LoopScrollView_ChooseReward:AddListener(fun)
    end

    -- 其它参数
    self.iCurNavIndex = 1
    self.ChoosenCost = 0
    self.AchievePoint = AchieveDataManager:GetInstance():GetAllAchievePoint() or 0
    -- self.AchievePoint = 99999
    self.bIsVip = TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() == true
    self.level2RomanNum = {"Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ", "Ⅴ", "Ⅵ", "Ⅶ", "Ⅷ", "Ⅸ", "Ⅹ"}
    self.colorNavOn = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1)
    self.colorNavOff = DRCSRef.Color(0.91, 0.91, 0.91, 1)
    self.strColorCondTrue = "<color=#EDF2EB>%s</color>"
    self.strColorCondFalse = "<color=#DE5F46>%s</color>"

    -- 初始化操作
    self:SortAchieveRewards()  -- 拆分数据
    self:InitNavBar()  -- 初始化导航栏
    self:RefreshUI()  -- 刷新界面
end

function AchieveRewardUI:RefreshUI()
    self:UpdateAchieveRewardList()
    self:UpdateChosenAchieveRewardList()
    self.Text_numt.text = self.ChoosenCost .. "/" .. self.AchievePoint 
    self.bRefill = false
end

-- 初始化导航栏
function AchieveRewardUI:InitNavBar()
    if not self.objNavBar then return end
    local transNavBar = self.objNavBar.transform
    local transChild = nil
    local toggleChild = nil
    local toggleFirst = nil
    local textToggleFirst = nil
    for index = 1, transNavBar.childCount do
        transChild = transNavBar:GetChild(index - 1)
        if not self.NavType2GroupIndex[index] then
            transChild.gameObject:SetActive(false)
        else
            transChild.gameObject:SetActive(true)
            toggleChild = transChild:GetComponent("Toggle")
            if not toggleFirst then
                toggleFirst =  toggleChild
            end
            local textToggle = self:FindChildComponent(transChild.gameObject, "Label", "Text")
            if not textToggleFirst then
                textToggleFirst = textToggle
            end
            textToggle.color = self.colorNavOff
            self:AddToggleClickListener(toggleChild, function(bIsOn)
                if bIsOn then
                    if self.twn then
                        self.twn:DOKill()
                        ReturnObjectToPool(self.anm_Effect)
                    end

                    self.iCurNavIndex = index
                    self.bRefill = true
                    self:RefreshUI()
                end
                textToggle.color = bIsOn and self.colorNavOn or self.colorNavOff
            end)
        end
    end
    if toggleFirst and textToggleFirst then
        toggleFirst.isOn = true
        textToggleFirst.color = self.colorNavOn
        toggleFirst:Select()
    end
end

-- 整理成就奖励数据
function AchieveRewardUI:SortAchieveRewards()
    self.AchieveRewardGroup = {}  -- 所有的成就数据
    self.NavType2GroupIndex = {}  -- 成就大类下所包含的奖励组组号
    self.TypeID2GroupIndex = {}  -- 静态id查询组号
    -- 将奖励分组
    local NavTypeGroupIndexCheck = {}
    local addData2Group = function(iGroupIndex, achieveReward)
        if not (achieveReward and iGroupIndex) then
            return
        end
        local uiTypeID = achieveReward.BaseID
        local uiNavType = achieveReward.RewardNavType
        -- 获取当前所在的大类组
        if not self.NavType2GroupIndex[uiNavType] then
            self.NavType2GroupIndex[uiNavType] = {}
        end
        local curNavGroup = self.NavType2GroupIndex[uiNavType]
        -- 创建分组
        if not self.AchieveRewardGroup[iGroupIndex] then
            self.AchieveRewardGroup[iGroupIndex] = {}
        end
        local curGroup = self.AchieveRewardGroup[iGroupIndex]
        curGroup[#curGroup + 1] = {
            ['data'] = achieveReward,
            ['picked'] = false,
        }
        self.TypeID2GroupIndex[uiTypeID] = iGroupIndex
        -- 将该组号记录在该大类下
        if NavTypeGroupIndexCheck[iGroupIndex] ~= true then
            NavTypeGroupIndexCheck[iGroupIndex] = true
            curNavGroup[#curNavGroup + 1] = iGroupIndex
        end
    end
    local iGroupIndex = 0
    local uiTypeID = nil
    local baseRewardTypeID = nil
    local checkData = nil
    local checkGruopIndex = nil
    local TB_AchieveReward = TableDataManager:GetInstance():GetTable("AchieveReward")
    for _, achieveReward in pairs(TB_AchieveReward) do
        uiTypeID = achieveReward.BaseID
        -- 如果奖励已经在某个分组里了， 那么跳过
        if not self.TypeID2GroupIndex[uiTypeID] and not self:IsStoryLockReward(uiTypeID) then
            -- 如果没有前置奖励， 那么为这个奖励添加一个新的分组
            if not (achieveReward.Condition and achieveReward.Condition > 0) then
                iGroupIndex = iGroupIndex + 1  -- 取一个新的索引
                addData2Group(iGroupIndex, achieveReward)
            -- 如果一个成就拥有前置奖励， 那么一直往前查找， 直到找到在某个组中的奖励， 加入它的组
            -- 一直没找到，就为最终的BaseReward创建一个组， 然后加入
            else
                checkData = achieveReward
                checkGruopIndex = nil
                while (checkData and checkData.Condition and checkData.Condition > 0) do
                    baseRewardTypeID = checkData.Condition
                    checkGruopIndex = self.TypeID2GroupIndex[baseRewardTypeID]
                    if checkGruopIndex then
                        break
                    end
                    checkData = TB_AchieveReward[baseRewardTypeID]
                end
                if checkGruopIndex then
                    addData2Group(checkGruopIndex, achieveReward)
                else
                    iGroupIndex = iGroupIndex + 1  -- 取一个新的索引
                    if checkData then
                        addData2Group(iGroupIndex, checkData)
                    end
                    addData2Group(iGroupIndex, achieveReward)
                end
            end
        end
    end
    -- 数据分类好之后， 将各个分组的数据按Sequence排序一下
    local comps = function(a,b)
        if a.data == nil or b.data == nil then
            return false
        end
        return (a.data.Sequence or 0) < (b.data.Sequence or 0)
    end
    for index, group in ipairs(self.AchieveRewardGroup) do
        table.sort(group, comps)
    end
end

-- 获取当前已选成就点数奖励
function AchieveRewardUI:GetCurChosenRewardsID()
    local list = {}
    local id2Level = {}
    for index, groupData in ipairs(self.AchieveRewardGroup) do
        for iLevel, rewardData in ipairs(groupData) do
            if rewardData.picked == true then
                list[#list + 1] = rewardData.data.BaseID
                id2Level[rewardData.data.BaseID] = iLevel
            end
        end
    end
    return list, id2Level
end

-- 刷新成就点数奖励列表
function AchieveRewardUI:UpdateAchieveRewardList()
    if not self.LoopScrollView_reward then return end
    self.iCurNavIndex = self.iCurNavIndex or 1
    if not self.NavType2GroupIndex[self.iCurNavIndex] then
        self.iCurNavIndex = 1
    end
    local navGroup = self.NavType2GroupIndex[self.iCurNavIndex]
    if not navGroup then return end
    self.CurNavGroup = navGroup
    self.LoopScrollView_reward.totalCount = #navGroup
    if self.bRefill then
        self.LoopScrollView_reward:RefillCells()
    else
        self.LoopScrollView_reward:RefreshCells()
        self.LoopScrollView_reward:RefreshNearestCells()
    end
end

-- 刷新已选成就点数奖励列表
function AchieveRewardUI:UpdateChosenAchieveRewardList()
    if not self.LoopScrollView_ChooseReward then return end
    local list, id2Level  = self:GetCurChosenRewardsID()
    self.ChosenAchieveRewardsID = list
    self.ChosenAchieveRewardsID2Level = id2Level
    self.LoopScrollView_ChooseReward.totalCount = #list
    self.LoopScrollView_ChooseReward:RefreshCells()
    self.LoopScrollView_ChooseReward:RefreshNearestCells()
end

function AchieveRewardUI:OnAchieveScrollChanged(transform, idx)
    idx = idx + 1
    if not (self.CurNavGroup and self.CurNavGroup[idx] and self.AchieveRewardGroup) then 
        return 
    end
    local curGroup = self.AchieveRewardGroup[self.CurNavGroup[idx]]
    if not curGroup then 
        return 
    end
    -- 找到第一个unpick的奖励, 找不到就取最后一个
    local tarReward = nil
    local iStyle = 1
    local iRewardLevel = 1
    for index, rewardData in ipairs(curGroup) do
        if rewardData.picked ~= true then
            tarReward = rewardData.data
            iRewardLevel = index
            break
        end
    end
    if not tarReward then
        iStyle = 2
        tarReward = curGroup[#curGroup].data
        iRewardLevel = #curGroup
    end
    local fun = function(achieveID)
        local bCanClick = self:OnClickAchieve(achieveID)
        if bCanClick then 
            self:Effect_OnClickAchieve(transform)
        end
    end
    self:UpdateItem(tarReward, iRewardLevel ,transform, fun, iStyle)
end

-- 右边选中框
function AchieveRewardUI:OnAchieveChooseScrollChanged(transform, idx)
    if not (self.ChosenAchieveRewardsID and self.ChosenAchieveRewardsID2Level) then
        return
    end
    idx = idx + 1
    local fun = function(achieveID)
        self:OnClickChosenAchieve(achieveID)
    end
    local achieveReward = TableDataManager:GetInstance():GetTableData("AchieveReward",self.ChosenAchieveRewardsID[idx])
    local iLevel = self.ChosenAchieveRewardsID2Level[achieveReward.BaseID] or 1
    self:UpdateItem(achieveReward, iLevel, transform, fun, 3)
end

function AchieveRewardUI:UpdateItem(achieveReward, iRewardLevel, transform, onClickCall, iStyle)
    if not (achieveReward and transform) then
        return
    end
    local objReward = transform.gameObject
    iRewardLevel = iRewardLevel or 1
    -- iStyle: 1 左侧成就卡片正常  2 左侧成就卡片选完  3 右侧成就列表对象
    iStyle = iStyle or 1

    local timer = 0 
    local func_UpdateItem = function()
        -- 这地方要处理下动画影响的多余root
        if transform.childCount > 1 then
            local iCount = transform.childCount - 1
            for i = iCount,2,-1 do
                transform:GetChild(i).gameObject:SetActive(false)
                --ReturnObjectToPool( transform:GetChild(i).gameObject)
            end
        end

        local transRoot = self:FindChild(transform.gameObject, "root")
        -- 按钮组件
        local Btn_click = transform:GetComponent("Button")
        -- 成就名称
        local Text_name = self:FindChildComponent(objReward, "root/Text_name", "Text")
        Text_name.text =  getRankBasedText(achieveReward.Rank, GetLanguageByID(achieveReward.NameID))
        -- 成就等级
        self:FindChildComponent(objReward, "root/Text_level", "Text").text = self.level2RomanNum[iRewardLevel] or self.level2RomanNum[1]
        local transBG = self:FindChild(objReward, "root/BG_level").transform
        -- 背景中, 第0张图片表示百宝书条件不满足
        -- 最后一张图片是最高级背景的灰化, 表示选完
        local bIsChooseOver = (iStyle == 2)
        iMaxCount = transBG.childCount
        local objVIPCondBack = transBG:GetChild(0).gameObject
        local objEmptyBack = transBG:GetChild(iMaxCount - 1).gameObject
        local objCurLevelBack = nil
        local objChild = nil
        for index = 0, iMaxCount - 1 do
            objChild = transBG:GetChild(index).gameObject
            if index == iRewardLevel then
                objCurLevelBack = objChild
                objChild:SetActive(true)
            else
                objChild:SetActive(false)
            end
        end
        -- 成就点数
        local objTextPoint = self:FindChild(objReward, "root/Text_point")
        if iStyle == 2 then
            objTextPoint:SetActive(false)
        else
            objTextPoint:SetActive(true)
            local Text_point = objTextPoint:GetComponent("Text")
            local iCurPoint = achieveReward.AchievePointCost or 0
            self.AchievePoint = self.AchievePoint or 0
            local iRemainPoint = self.AchievePoint - (self.ChoosenCost or 0)
            local strFormat = "<color=black>%s</color>"
            if iStyle ~= 3 then
                strFormat = (iCurPoint > iRemainPoint) and self.strColorCondFalse or self.strColorCondTrue
            end
            Text_point.text = string.format(strFormat, iCurPoint)
        end
        -- 成就条件 / 描述
        if iStyle < 3 then
            local objTextDesc = self:FindChild(objReward, "root/Text_desc")
            local objTextDesc2 = self:FindChild(objReward, "root/Text_desc_2")
            local objTextCond = self:FindChild(objReward, "root/Text_condition")
            local Text_desc = objTextDesc:GetComponent("Text")
            local Text_desc2 = objTextDesc2:GetComponent("Text")
            local Text_condition = objTextCond:GetComponent("Text")
            if iStyle == 2 then
                Btn_click.interactable = false
                objTextCond:SetActive(false)
                Text_desc.text = "已选完"
                Text_desc2.text = ""
                objEmptyBack:SetActive(true)
                if objCurLevelBack then
                    objCurLevelBack:SetActive(false)
                end
            else
                objTextCond:SetActive(true)
                local bNeedVip = (achieveReward.NeedVIP == TBoolean.BOOL_YES) 
                -- self:FindChild(objReward, "Image_vip"):SetActive(bNeedVip)
                if (not self.bIsVip) and bNeedVip then
                    Btn_click.interactable = false
                    Text_condition.text = "需要壕侠版百宝书"
                    objVIPCondBack:SetActive(true)
                    if objCurLevelBack then
                        objCurLevelBack:SetActive(false)
                    end
                else 
                    Btn_click.interactable = true
                    Text_condition.text = ''
                end
                -- 拆分描述为两行
                local strDesc = GetLanguageByID(achieveReward.DescID)
                local splitDescs = string.split(strDesc, "#") or {}
                Text_desc.text = splitDescs[1] or ""
                Text_desc2.text = string.format("<size=28>%s</size>", splitDescs[2] or "")
            end
        end
        -- 点击回调
        self:RemoveButtonClickListener(Btn_click)
        if iStyle ~= 2 then
            local achieveID = achieveReward.BaseID
            self:AddButtonClickListener(Btn_click, function() 
                onClickCall(achieveID) 
            end)
        end

        if iStyle == 3 and self._clickAchieveID  and self._clickAchieveID == achieveReward.BaseID then
            self:Anim_ItemMove(transRoot)
            self._clickAchieveID = nil
        end
    end

    if iStyle == 1 and self._resetAchieveID and self._resetAchieveID == achieveReward.BaseID then
        timer = self:Anim_FadeIn(transform)
    end

    

    if timer > 0 then
        if self.timer_UpdateItem ~= nil then
            self:RemoveTimer(self.timer_UpdateItem)
            func_UpdateItem()
        end

        self.timer_UpdateItem = self:AddTimer((timer - 0.1) * 1000,
            function() 
                self.timer_UpdateItem = nil
                func_UpdateItem() 
            end)
    else
        func_UpdateItem()
    end 
end

function AchieveRewardUI:Anim_ItemMove(transRoot)
    local func_Click = function()
        local eff_kp = self:FindChild(transRoot.transform.parent.gameObject,"ef_kpeff_02") 
        eff_kp.gameObject:SetActive(true)
        eff_kp.transform:GetComponent("ParticleSystem"):Play()
    end
    func_Click()
    transRoot.transform.localPosition = DRCSRef.Vec3(-260,0,0)
    transRoot.transform:DOLocalMoveX(0,0.2):SetEase(DRCSRef.Ease.InCubic)
end

function AchieveRewardUI:Anim_FadeIn(trans)
    local fAnimTime = 0.5
    if self.bInAnim then
        self.anm_Effect.gameObject:SetActive(true)
        self:Anim_UpdateRoot(self.anm_Effect.transform)
        return fAnimTime
    end
    local root = trans:GetChild(0).gameObject
    local effect = LoadGameObjFromPool(root, trans.transform)
    self.anm_Effect = effect
    if effect == nil then
        return fAnimTime
    end
    effect.gameObject:SetActive(true)
    effect.gameObject.name = "root"
    self:Anim_UpdateRoot(effect.transform)
    local comCanvasGroup = effect.transform:GetComponent("CanvasGroup")
    comCanvasGroup.alpha = 0

    effect.transform.localPosition =  DRCSRef.Vec3Zero
    effect.transform.localScale = DRCSRef.Vec3One

    self.bInAnim = true
        self.twn = Twn_CanvasGroupFade(self.twn, comCanvasGroup, 0, 1, fAnimTime)
        if (self.twn ~= nil) then
            self.twn:OnComplete(
            function()
                self.bInAnim = false
                ReturnObjectToPool(root)
            end)
            self.twn:OnRewind(
                function()
                    ReturnObjectToPool(root)
                end)
            self.twn:SetAutoKill(true)
            self.twn = nil
            self._resetAchieveID = nil
        end
    -- if self.twn ~= nil then
    --     comCanvasGroup.alpha = 1
    --     ReturnObjectToPool(root)
    --     self._resetAchieveID = nil
    --     return fAnimTime
    -- else
        
    -- end
    return fAnimTime
end


function AchieveRewardUI:Anim_UpdateRoot(transform)
    local achieveReward = TableDataManager:GetInstance():GetTableData("AchieveReward",self._resetAchieveID)
    local transRoot = self:FindChild(transform.gameObject, "root")
    -- 成就名称
    local Text_name = self:FindChildComponent(transform.gameObject, "Text_name", "Text")
    Text_name.text =  getRankBasedText(achieveReward.Rank, GetLanguageByID(achieveReward.NameID))
    -- 成就等级
    local iRewardLevel = self.ChosenAchieveRewardsID2Level[achieveReward.BaseID] or 1
    self:FindChildComponent(transform.gameObject, "Text_level", "Text").text = self.level2RomanNum[iRewardLevel] or self.level2RomanNum[1]
    local transBG = self:FindChild(transform.gameObject, "BG_level").transform
    -- 背景中, 第0张图片表示百宝书条件不满足
    -- 最后一张图片是最高级背景的灰化, 表示选完
    iMaxCount = transBG.childCount
    local objVIPCondBack = transBG:GetChild(0).gameObject
    local objEmptyBack = transBG:GetChild(iMaxCount - 1).gameObject
    local objCurLevelBack = nil
    local objChild = nil
    for index = 0, iMaxCount - 1 do
        objChild = transBG:GetChild(index).gameObject
        if index == iRewardLevel then
            objCurLevelBack = objChild
            objChild:SetActive(true)
        else
            objChild:SetActive(false)
        end
    end
    -- 成就点数
    local objTextPoint = self:FindChild(transform.gameObject, "Text_point")
    objTextPoint:SetActive(true)
    local Text_point = objTextPoint:GetComponent("Text")
    local iCurPoint = achieveReward.AchievePointCost or 0
    self.AchievePoint = self.AchievePoint or 0
    local iRemainPoint = self.AchievePoint - (self.ChoosenCost or 0)
    local strFormat = "<color=black>%s</color>"
    strFormat = (iCurPoint > iRemainPoint) and self.strColorCondFalse or self.strColorCondTrue
    Text_point.text = string.format(strFormat, iCurPoint)
    local objTextDesc = self:FindChild(transform.gameObject, "Text_desc")
    local objTextDesc2 = self:FindChild(transform.gameObject, "Text_desc_2")
    local objTextCond = self:FindChild(transform.gameObject, "Text_condition")
    local Text_desc = objTextDesc:GetComponent("Text")
    local Text_desc2 = objTextDesc2:GetComponent("Text")
    local Text_condition = objTextCond:GetComponent("Text")
    objTextCond:SetActive(true)
    local bNeedVip = (achieveReward.NeedVIP == TBoolean.BOOL_YES) 
    if (not self.bIsVip) and bNeedVip then
        Text_condition.text = "需要壕侠版百宝书"
        objVIPCondBack:SetActive(true)
        if objCurLevelBack then
            objCurLevelBack:SetActive(false)
        end
    else 
        Text_condition.text = ''
    end
    -- 拆分描述为两行
    local strDesc = GetLanguageByID(achieveReward.DescID)
    local splitDescs = string.split(strDesc, "#") or {}
    Text_desc.text = splitDescs[1] or ""
    Text_desc2.text = string.format("<size=28>%s</size>", splitDescs[2] or "")
end


function AchieveRewardUI:Effect_OnClickAchieve(transform)
    local func_Click = function()
        local eff_kp = self:FindChild(transform.gameObject,"ef_kpeff_01") 
        eff_kp.gameObject:SetActive(true)
        eff_kp.transform:GetComponent("ParticleSystem"):Play()
    end

    local func_Move = function()
            -- 飞入ui
        local effect = LoadPrefabFromPool(PATH_EFFECT_TRAIL, transform.parent.parent.parent.transform,true)
        local trailEffect01 = effect:GetComponent("TrailRenderer")
        local trailEffect02 = effect.transform:GetChild(0):GetComponent("TrailRenderer")
        local recEffect = effect.transform:GetComponent("RectTransform")
        local worldPos = transform:TransformPoint(DRCSRef.Vec3(0,0,16) );
        local localPos = transform.parent.parent.parent.transform:InverseTransformPoint(worldPos)
        recEffect.localPosition = localPos

        if trailEffect01 ~= nil then
            trailEffect01:Clear()
        end
        if trailEffect02 ~= nil then
            trailEffect02:Clear()
        end
        effect.transform.localScale = DRCSRef.Vec3(100,100,1) 
        --将wp坐标转换到Content的局部坐标下
      
        local targetPos = self:_GetEffectTargetPos()
        local OnComplete = function()
            self:RefreshUI()
            if trailEffect01 ~= nil then
                trailEffect01:Clear()
            end
            if trailEffect02 ~= nil then
                trailEffect02:Clear()
            end
            ReturnObjectToPool(effect.gameObject)
        end

        local fDuration = 0.2 
        local ctrlPos = DRCSRef.Vec3((targetPos.x + localPos.x)/2, (localPos.y + targetPos.y) / 2,0)
        Twn_Bezier(recEffect, localPos, targetPos, 150, OnComplete, 50, fDuration, DRCSRef.Ease.Linear, 0, ctrlPos)
    end

    func_Click()
    func_Move()
end

-- 点击卡片
function AchieveRewardUI:OnClickAchieve(achieveID)
    local bCanClick = false
    local achieveReward = TableDataManager:GetInstance():GetTableData("AchieveReward",achieveID)
    if not achieveReward then
        return
    end

    local iCurGroupIndex = self.TypeID2GroupIndex[achieveID]
    if not iCurGroupIndex then return end
    local curGroup = self.AchieveRewardGroup[iCurGroupIndex]
    
    local bPicked = false
    local iPos = 1
    for index, rewardData in ipairs(curGroup) do
        if rewardData.data and rewardData.data.BaseID == achieveID then
            bPicked = rewardData.picked
            iPos = index
            break
        end
    end
    if bPicked then 
        return
    end

    local iRemainPoint = self.AchievePoint - (self.ChoosenCost or 0)
    if achieveReward.AchievePointCost > iRemainPoint then
        SystemUICall:GetInstance():Toast("成就点不足！")
        return
    end
   
    bCanClick = true
    self.ChoosenCost = (self.ChoosenCost or 0) + achieveReward.AchievePointCost
    curGroup[iPos].picked = true
    self._clickAchieveID = achieveID
    return bCanClick
end

function AchieveRewardUI:OnClickChosenAchieve(achieveID)
    local achieveReward = TableDataManager:GetInstance():GetTableData("AchieveReward",achieveID)
    if not achieveReward then
        return
    end

    local iCurGroupIndex = self.TypeID2GroupIndex[achieveID]
    if not iCurGroupIndex then return end
    local curGroup = self.AchieveRewardGroup[iCurGroupIndex]
    
    local bPicked = false
    local iPos = 1
    for index, rewardData in ipairs(curGroup) do
        if rewardData.data and rewardData.data.BaseID == achieveID then
            bPicked = rewardData.picked
            iPos = index
            break
        end
    end
    if bPicked ~= true then 
        return
    end

    -- self.ChoosenCost = self.ChoosenCost - achieveReward.AchievePointCost
    -- 一者剔除, 后者连带
    local kData = nil
    for index = iPos, #curGroup do
        kData = curGroup[index]
        if kData.picked == true then
            kData.picked = false
            self.ChoosenCost = self.ChoosenCost - (kData.data.AchievePointCost or 0)
        end
    end
    -- 设置播放重置卡片的特效
    self._resetAchieveID = achieveID
    self:RefreshUI()
end

function AchieveRewardUI:ClearPickedReward()
    for index, groupData in ipairs(self.AchieveRewardGroup) do
        for _, rewardData in ipairs(groupData) do
            rewardData.picked = false
        end
    end
end

function AchieveRewardUI:OnClickBack()
    self:ClearPickedReward()
    OpenWindowImmediately("DifficultyUI")
    RemoveWindowImmediately("AchieveRewardUI",false)
end

function AchieveRewardUI:OnNext()
    g_CreateRoleWaitingLoadingFlag = true
    local gameMode = globalDataPool:getData("GameMode")
    if (gameMode == "ServerMode") then
        -- 先发送难度选择消息
        SendClickDiffChoose(g_selectStoryDiff or 1)
        -- 再发送成就选择消息
        local list = self:GetCurChosenRewardsID()
        SendAchieveRewardScript(list)
        
        -- TODO 数据上报
        MSDKHelper:SetQQAchievementData('scriptdiff', g_selectStoryDiff or 1);
        MSDKHelper:SendAchievementsData('scriptdiff');
        OpenWindowImmediately("LoadingUI")
    else
        -- 单机模式下发送作弊指令选择难度
        local curDiff = g_selectStoryDiff or 1
        local cheatPara = string.format("CHET_SELECT_DIFF@%d@0@0",curDiff)
        CheatDataManager:GetInstance():SendCheatCmd(cheatPara)
        -- 发送作弊带入成就
    end
    -- 再发送创角消息
    SendClickCreateMainRole()

    -- 创角比较特殊,服务器端是队列的形式,需要做Loading,colourstar 2020/10/24

    -- 这里做一个Timer
    globalTimer:AddTimer(5000, function()
        if(g_CreateRoleWaitingLoadingFlag) then
            RemoveWindowImmediately("LoadingUI");
            SystemUICall:GetInstance():Toast("本次创建角色失败，请重新开启游戏。若多次失败，请在官方Q群（423860584）联系客服阿月进行反馈。")
        end
    end, 1);

    RemoveWindowImmediately("AchieveRewardUI",false)
end

function AchieveRewardUI:OnClickTip()
    local tips = {
        ['content'] = "<color=#FFFFFF>你的成就点数，决定了你能选择的能力加成项目的数量。\n尝试达成游戏内的挑战，尽可能获得成就点数吧！</color>"
    }
    OpenWindowImmediately("TipsPopUI", tips)
end

function AchieveRewardUI:OnDestroy()

end


function AchieveRewardUI:_GetEffectTargetPos()
    local list, _  = self:GetCurChosenRewardsID()
    local count = #list
    local x = 488
    if  count > 9 then
        count = 9
    end
    local y = 288 - (count - 1 ) * 50

    return DRCSRef.Vec3(x,y,0)
end

function AchieveRewardUI:IsStoryLockReward(achieveRewardID)
    local achieveReward = TableDataManager:GetInstance():GetTableData("AchieveReward",achieveRewardID)
    if not achieveReward or not achieveReward.LockStorys then
        return false
    end

    local curStoryID = GetCurScriptID()
    for _, storyID in ipairs(achieveReward.LockStorys) do
        if storyID == curStoryID then
            return true
        end
    end

    return false
end

return AchieveRewardUI