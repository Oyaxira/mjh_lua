AchievementAchieveUI = class("AchievementAchieveUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function AchievementAchieveUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
    local obj = LoadPrefabAndInit("AchievementUI/AchievementAchieveUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function AchievementAchieveUI:OnPressESCKey()
    if self.btnExit then
        self.btnExit.onClick:Invoke()
    end
end

function AchievementAchieveUI:Init()
    self.tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_Achieve);

    -- 其他值
    self.colorTabOnClick = DRCSRef.Color(0.91, 0.91, 0.91, 1)
    self.colorTabUnClick = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1)
    -- 初始化数据
    self:InitData()
    -- 成就点数
    local objRoot = self:FindChild(self._gameObject,"Achieve_box")
    self.sliderAchievePoint = self:FindChildComponent(objRoot, "Slider_point", "Slider")
    self.textAchievePoint = self:FindChildComponent(objRoot,"Slider_point/Num", "Text")
    -- 成就内容滚动栏
    self.AchieveScrollRect = self:FindChildComponent(objRoot,"SC_achieve","LoopVerticalScrollRect")
    if self.AchieveScrollRect then
        local fun_Adv = function(transform, idx)
            self:OnAchieveScrollChanged(transform, idx)
        end
        self.AchieveScrollRect:AddListener(fun_Adv)
    end
    -- 导航栏
    self.NavScrollRect=self:FindChildComponent(objRoot,"SC_nav","ScrollRect")
    self.objNavBar =  self:FindChild(objRoot,"SC_nav/Viewport/Content")
    self.toggleGroupNavBar = self.objNavBar:GetComponent("ToggleGroup")
    self.objNavBtnTemp = self:FindChild(objRoot,"AchievementBtnItem")
    self.objNavBtnTemp:SetActive(false)
    self:InitNavBar()
    -- 注册事件
    self:AddEventListener("UPDATE_ACHIEVE_DATA", function()
        self:RefreshUI({
            ['bReRank'] = true,
            ["bRefresh"] = true,
        })
    end)
    self.btnExit = self:FindChildComponent(self._gameObject,"frame/Btn_exit","Button")
    if self.btnExit then
        self:AddButtonClickListener(self.btnExit, function()
            RemoveWindowImmediately("AchievementAchieveUI")
		end)
    end
end

function AchievementAchieveUI:OnEnable()
    AchieveDataManager:GetInstance():DispatchUpdateEvent()
    -- OpenWindowBar({
    --     ['windowstr'] = "AchievementAchieveUI",
    --     ['titleName'] = "成就",
    --     ['topBtnState'] = {
    --         ['bBackBtn'] = true,
    --         ['bGold'] = true,
    --         ['bSilver'] = true,
    --         ['bTreasureBook'] = true,
    --     },
    --     ['bSaveToCache'] = true,
    --     ['callback'] = function()
    --         local win = GetUIWindow("NavigationUI")
    --         if win then
    --             win:RefreshAchieveRedPoint()
    --         end
    --     end,
    -- })
end

function AchievementAchieveUI:OnDisable()
    local _tabl = {}
    local iCount = 0
    for itypeid,bif in pairs(self._QuitSendIdList or {}) do
        _tabl[iCount] = itypeid
        iCount = iCount + 1
    end
    SendGetScriptAchieveReward(iCount,_tabl)
    RemoveWindowBar('AchievementAchieveUI')
end

function AchievementAchieveUI:RefreshUI(info)
    info = info or {}
    self:InitData(info.bReRank)
    self:ShowAchievesByIndex(info.index, info.bRefresh)
end

-- 数据划分
function AchievementAchieveUI:InitData(bReRank)
    -- 克隆一份静态数据
    local TB_Achieve = TableDataManager:GetInstance():GetTable("Achieve")
    --LuaPanda.BP()
    if not self.rankedData then
        self.rankedData = {}
        for index, data in pairs(TB_Achieve) do
            self.rankedData[#self.rankedData + 1] = data
        end
    end
    -- AchieveDataManager里面是否设置了需要重新排序的标记?
    local bMgrTellReRank = (AchieveDataManager:GetInstance():GetReRankFlag() == true)
    -- 数据排序
    if (self.bHasRanked ~= true) or (bReRank == true) or (bMgrTellReRank == true) then
        self.bHasRanked = true
        AchieveDataManager:GetInstance():SetReRankFlag(false)
        local stateWeight = {
            ["achieved"] = 0,
            ["running"] = 1,
            ["ready"] = 2,
        }
        -- 排序: 未领取 > 未完成 > 已领取
        local manager = AchieveDataManager:GetInstance()
        local sortKey = function(a, b)
            local baseIDA = a.BaseID
            local baseIDB = b.BaseID
            local stateA = manager:CheckAchieveState(baseIDA)
            local stateB = manager:CheckAchieveState(baseIDB)
            local weightA = stateWeight[stateA] or 0
            local weightB = stateWeight[stateB] or 0
            if weightA == weightB then
                return a.Order < b.Order
            end
            return weightA > weightB
        end
        table.sort(self.rankedData, sortKey)
        -- 排序好的数据分流
        self.Index2AchieveType = {
            [1] = "所有",
            [2] = "剧情",
            [3] = "关系",
            [4] = "探索",
            [5] = "能力",
            [6] = "门派",
            [7] = "战斗",
            [8] = "收集",
        }
        self.departData = {}
        self.achieveType2Index = {}
        for index, sType in ipairs(self.Index2AchieveType) do
            self.achieveType2Index[sType] = index
            self.departData[index] = {}
        end
        local index = nil
        for _, data in ipairs(self.rankedData) do
            index = self.achieveType2Index[data.AchieveType] or 0
            self.departData[index][#self.departData[index] + 1] = data
            self.departData[1][#self.departData[1] + 1] = data
        end
    end
end

-- 初始化导航栏
function AchievementAchieveUI:InitNavBar()
    local firsdtToggle = nil
    local bIsFirstToggle = false
    for index,sType in ipairs(self.Index2AchieveType) do
        local item =  CloneObj(self.objNavBtnTemp, self.objNavBar)
        if (item ~= nil) then
            bIsFirstToggle = false
            if firsdtToggle == nil then
                firsdtToggle = item
                bIsFirstToggle = true
            end
            local textBtn = self:FindChildComponent(item, "Lab", "Text")
            textBtn.text = sType
            local objClick = self:FindChild(item, "Image_toggle")
            local toggleItem = item:GetComponent("Toggle")
            if (toggleItem ~= nil) then
                toggleItem.isOn = bIsFirstToggle
                toggleItem.group = self.toggleGroupNavBar
                objClick.gameObject:SetActive(bIsFirstToggle)
                textBtn.color = bIsFirstToggle and self.colorTabOnClick or self.colorTabUnClick
                local fun_toggle = function(bIsOn)
                    fun(bIsOn)
                end
                self:AddToggleClickListener(toggleItem, function(bIsOn)
                    objClick:SetActive(bIsOn)
                    textBtn.color = bIsOn and self.colorTabOnClick or self.colorTabUnClick
                    if bIsOn then
                        self:ShowAchievesByIndex(index)
                    end
                end)
            end
            item:SetActive(true)
        end
    end
end

-- 更新成就点数
function AchievementAchieveUI:UpdateAchievePoint()
    if not self.subAchieveList then
        return
    end
    local manager = AchieveDataManager:GetInstance()
    local curAchievePoint = 0
    local curMaxAchievePoint = 0
    for index, achieveData in ipairs(self.subAchieveList) do
        curAchievePoint = curAchievePoint + manager:GetAchievePoint(achieveData.BaseID)
        curMaxAchievePoint = curMaxAchievePoint + (achieveData.AchievePoint or 0)
    end
    self.textAchievePoint.text = string.format("%d/%d", curAchievePoint, curMaxAchievePoint)
    self.sliderAchievePoint.value = curAchievePoint / curMaxAchievePoint
end

-- 更新成就列表
function AchievementAchieveUI:OnAchieveScrollChanged(transform, idx)
    local Achieve = self.AchieveList[idx + 1]
    if Achieve == nil then
        return
    end
    local objItem = transform.gameObject
    -- 初始化成就信息部分
    local objMsg = self:FindChild(objItem, "Msg")
    local Text_name = self:FindChildComponent(objMsg,"Text_title","Text")
    local Text_desc = self:FindChildComponent(objMsg,"Text_desc","Text")
    local Text_AchievePoint = self:FindChildComponent(objMsg,"Text_AchievePoint","Text")
    Text_name.text = GetLanguageByID(Achieve.NameID)
    Text_name.color = getRankColor(Achieve.Rank)
    Text_AchievePoint.text = Achieve.AchievePoint or 0
    Text_desc.text = GetLanguageByID(Achieve.DesID)
    -- 初始化成就奖励
    local objReward = self:FindChild(objItem, "Reward")
    -- 要显示几个奖励, 是在ui里就设计好的, 策划保证了最多只有两个奖励
    local aNodeRewards = {
        self:FindChild(objReward, "ItemIcon1"),
        self:FindChild(objReward, "ItemIcon2")
    }
    local akRewards = AchieveDataManager:GetInstance():GetAchieveRewardArray(Achieve.BaseID) or {}
    local rewardData = nil
    local itemTypeData = nil
    for index, node in ipairs(aNodeRewards) do
        rewardData = akRewards[index]
        if rewardData then
            node:SetActive(true)
            itemTypeData = TableDataManager:GetInstance():GetTableData("Item",rewardData.uiTypeID)
            self.ItemIconUI:UpdateUIWithItemTypeData(node, itemTypeData)
            self.ItemIconUI:SetItemNum(node, rewardData.uiNum)
        else
            node:SetActive(false)
        end
    end
    -- 初始化成就进度
    local objProgress = self:FindChild(objItem, "Progress")
    local objSlider = self:FindChild(objProgress, "Slider_point")
    local comSlider = objSlider:GetComponent("Slider")
    local textProgress = self:FindChildComponent(objProgress, "Num", "Text")
    local objImgNew = self:FindChild(objProgress, "ImgNew")
    -- local btnBtnGet = self:FindChildComponent(objBtnGet, "Button", "Button")
    local objHasGot = self:FindChild(objProgress, "HasGot")
    local typeID = Achieve.BaseID
    local manager = AchieveDataManager:GetInstance()
    local iMax = manager:GetAchieveProgressMax(typeID)
    local iCur = manager:GetAchieveProgressCur(typeID)
    objSlider:SetActive(false)
    -- objBtnGet:SetActive(false)
    objHasGot:SetActive(false)
    objImgNew:SetActive(false)

    if ((iMax >= 0) and (iCur >= iMax))
    or ((iMax < 0) and (iCur <= iMax)) then
        -- 根据奖励是否已经领取显示 领取 或 已领取
        objHasGot:SetActive(true)
        if manager:IsAchieveRewardGot(typeID) then
            objImgNew:SetActive(false)
        else
            -- objImgNew:SetActive(true)
            -- objBtnGet:SetActive(true)
            self._QuitSendIdList = self._QuitSendIdList or {}
            self._QuitSendIdList[typeID] = true
            -- self:RemoveButtonClickListener(btnBtnGet)
            -- self:AddButtonClickListener(btnBtnGet, function()
            --     -- 数组是为了之后可能会有批量领取成就奖励的需求留口子, 目前只需要领取所在的单个成就的奖励即可
            --     SendGetScriptAchieveReward(1, {[0] = typeID})
            -- end)
        end
    else
        objSlider:SetActive(true)
        comSlider.value = iCur / iMax
        textProgress.text = string.format("%d/%d", iCur, iMax)
    end
end

function AchievementAchieveUI:GetCanShow(typeID)
    local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
    local tempTable = {};
    for i = 1, #(self.tbSysOpenData) do
        if self.tbSysOpenData[i].OpenTime > time then
            table.insert(tempTable, self.tbSysOpenData[i]);
        end
    end

    for i = 1, #(tempTable) do
        if tempTable[i].Param1 == typeID then
            return false;
        end
	end

    return true;
end

-- 点击页签更新成就列表
function AchievementAchieveUI:ShowAchievesByIndex(index, bRefresh)
    if (not index) or (index <= 0) then
        index = self.curIndex or 1
    end
    self.curIndex = index
    --LuaPanda.BP()
    self.subAchieveList = self.departData[index]
    if not self.subAchieveList then
        self.subAchieveList = TableDataManager:GetInstance():GetTable("Achieve")
    end
    self.AchieveList = {}
    --筛选
    for i=1,#self.subAchieveList do
        local isShow = true
        isShow = self:GetCanShow(self.subAchieveList[i].BaseID);

        -- 设置前置成就未完成则不显示的成就
        if (self.subAchieveList[i].PreAchieve) then
            local preAchieveIdList = self.subAchieveList[i].PreAchieve
            for i=1,#preAchieveIdList do
                local isPreAchieveDone = AchieveDataManager:GetInstance():IsAchieveMade(preAchieveIdList[i])
                if (not isPreAchieveDone) then
                    isShow = false
                    break
                end
            end
        end
        -- 设置领取奖励后不显示的成就
        if (self.subAchieveList[i].IsCompHide) then
            if (self.subAchieveList[i].IsCompHide == TBoolean.BOOL_YES and AchieveDataManager:GetInstance():IsAchieveRewardGot(self.subAchieveList[i].BaseID)) then
                isShow = false
            end
        end

        --

        if (isShow) then
            table.insert(self.AchieveList,self.subAchieveList[i])
        end
    end

    self.AchieveScrollRect.totalCount = getTableSize(self.AchieveList)
    if bRefresh == true then
        self.AchieveScrollRect:RefreshCells()
        self.AchieveScrollRect:RefreshNearestCells()
    else
        self.AchieveScrollRect:RefillCells()
    end
    self:UpdateAchievePoint()
end

function AchievementAchieveUI:OnDestroy()

    self.ItemIconUI:Close()
end

return AchievementAchieveUI