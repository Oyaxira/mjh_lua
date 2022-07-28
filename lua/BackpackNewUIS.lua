BackpackNewUIS = class("BackpackNewUIS", BaseWindow)
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'
local l_DRCSRef_Type = DRCSRef_Type
-- 脏标枚举
local PackDirtyFlag = {
    ['UPDATE_BOARD_BASE'] = 1,  -- 刷新整个背包显示(静态数据)
    ['UPDATE_BOARD_INST'] = 2,  -- 刷新整个背包显示(动态数据)
    ['UPDATE_REFRESH'] = 3,  -- 刷新当前可见的物品显示
    ['UPDATE_REFRESH_RESET'] = 4,  -- 重置数据并刷新当前可见的物品显示
}

-- 脏标覆盖, 出现一个脏标的时候直接移除其它脏标
local PackDirtyFlagCover = {
    [PackDirtyFlag.UPDATE_BOARD_INST] = {
        PackDirtyFlag.UPDATE_BOARD_BASE,
        PackDirtyFlag.UPDATE_REFRESH,
        PackDirtyFlag.UPDATE_REFRESH_RESET,
    },
    [PackDirtyFlag.UPDATE_BOARD_BASE] = {
        PackDirtyFlag.UPDATE_REFRESH,
        PackDirtyFlag.UPDATE_REFRESH_RESET,
    },
    [PackDirtyFlag.UPDATE_REFRESH_RESET] = {
        PackDirtyFlag.UPDATE_REFRESH,
    },
}

-- 默认背包标签页
local NavIndex2TypeDefault = {
    -- ['preProcess'] = function(tab, oriType)
    --     if (oriType == ItemTypeDetail.ItemType_HiddenWeapon)
    --     or (oriType == ItemTypeDetail.ItemType_Leechcraft) then
    --         return ItemTypeDetail.ItemType_Equipment
    --     end
    -- end,
    {
        ['text'] = "全部",
        ['types'] = {
            ItemTypeDetail.ItemType_Null,
        }
    },
    {
        ['text'] = "装备",
        ['types'] = {
            ItemTypeDetail.ItemType_Equipment,
            ItemTypeDetail.ItemType_HiddenWeapon,
            ItemTypeDetail.ItemType_Leechcraft,
        }
    },
    {
        ['text'] = "消耗",
        ['types'] = {
            ItemTypeDetail.ItemType_Consume,
        }
    },
    {
        ['text'] = "武学",
        ['types'] = {
            ItemTypeDetail.ItemType_Book,
        }
    },
    {
        ['text'] = "材料",
        ['types'] = {
            ItemTypeDetail.ItemType_Material,
        }
    },
    {
        ['text'] = "任务",
        ['types'] = {
            ItemTypeDetail.ItemType_Task,
        }
    },
    -- {
    --     ['text'] = "资产",
    --     ['paging'] = 'asset'
    -- }
}

-- 参数参考
-- kConfig = {
--     ['objBind'] = obj,  -- 背包实例绑定的ui节点
--     ['RowCount'] = int,  -- 背包中一行包含的物品节点个数
--     ['ColumnCount'] = int,  -- 背包中一列包含的物品节点个数
-- -------------------------以下为可选参数-----------------------------------------
--     ['navData'] = {data like NavIndex2TypeDefault},  -- 导航栏数据, 参考NavIndex2TypeDefault, 可缺省
--     ['bCanShowLock'] = bool,  -- 是否显示物品的锁定状态, 可缺省
--     ['funcOnClickItemInfo'] = luaFunc,  -- 点击ItemInfo组件的回调, 可缺省
--     ['funcOnClickItemIcon'] = luaFunc,  -- 点击ItemIcon组件的回调, 可缺省
--     ['funcOnRefreshItem'] = luaFunc,  -- 对ItemInfo组件的刷新回调
--     ['careEvent'] = {  -- 背包关心的事件列表, 可缺省
--         [1] = {
--             ['eventName'] = string,  -- 事件名称
--             ['registerCond'] = func,  -- 注册条件, 缺省直接注册该事件
--             ['responseCond'] = func,  -- 响应条件, 缺省直接响应该事件
--             ['callback'] = func,  -- 事件回调
--         },
--         ...
--     }
-- }
function BackpackNewUIS:ctor(kConfig)
    -- 必须参数: 绑定的ui节点, 背包行列数
    if not (kConfig and kConfig.objBind 
    and kConfig.RowCount and (kConfig.RowCount > 0)
    and kConfig.ColumnCount and (kConfig.ColumnCount > 0)) then
        return
    end
    -- 缓存参数, 初始化数据
    self.kCacheConfig = kConfig
    self:SetGameObject(kConfig.objBind)
    self:DoInit()
end

function BackpackNewUIS:DoInit()
    if not self.kCacheConfig then
        return
    end
    -- 必要数据
    self.ItemInfoUI = ItemInfoUI.new()
    self.kDirtyFlag = {}
    self.kDirtyFlagExInfo = {}
    self.colorNavPick = DRCSRef.Color.white
    self.colorNavUnPick = DRCSRef.Color(0.2,0.2,0.2,1)
    self.bShowLockState = self.kCacheConfig.bCanShowLock == true
    -- 注册背包关心的事件监听
    self:AddCareEventListener()
    -- 注册滚动栏监听
    self.objLoopScroll = self:FindChild(self._gameObject, 'Pack/LoopScrollView')
    self.comLoopScroll = self.objLoopScroll:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
    self.comLoopScroll:AddListener(function(...) 
        if self:IsOpen() == true then
            self:LoopScvUpdateFunc(...)
        end
    end)
    self.transLoopScrollContent = self:FindChild(self.objLoopScroll, 'Content').transform
    -- 页签相关
    self.objNavBoxTemplate = self:FindChild(self._gameObject, 'Pack/navBoxTemplateS')
    self.objNavBox = self:FindChild(self._gameObject, "Pack/nav_boxS")

    --CharacterUI打开时 改小为三分之二
    -- if IsWindowOpen('CharacterUI') then
    --     self.objNavBox.transform.localScale= DRCSRef.Vec3(2/3,2/3,2/3)
    --     local rectClone =  self.objNavBox:GetComponent("RectTransform")
    --     SetUIAxis(self.objNavBox,rectClone.rect.width/3 * 2,rectClone.rect.height/3 * 2)
    -- end

    self.comToggleGroupNavBox = self.objNavBox:GetComponent(l_DRCSRef_Type.ToggleGroup)
    self.togFirst = self:InitNavBar()  -- 初始化页签并记录第一个页签

    self.objSortNode =  self:FindChild(self._gameObject, 'BackPackSortNode')
    self.objSortButton = self:FindChild(self._gameObject, 'Pack/SortButton')
    if self.objSortButton then
        local sortToggle = self.objSortButton:GetComponent(l_DRCSRef_Type.Toggle)
        if sortToggle then
            self:AddToggleClickListener(sortToggle, function(bIsOn)
                self.objSortNode:SetActive(bIsOn)
            end)
        end
        self:InitSortNode()

        self.objRaycast = self:FindChild(self._gameObject, 'BG_Click');
        AddEventTrigger(self.objRaycast, function()
            if sortToggle then
                sortToggle.isOn = not sortToggle.isOn
            end
        end)
        self.objSortButton:SetActive(false)
    end
end

function BackpackNewUIS:SetSortButton(bShow)
    self.bShowSortButton = bShow
    if self.objSortButton then
        self.objSortButton:SetActive(bShow)
    end
end

function BackpackNewUIS:_SetSortButtonVisible(bVisible)
    if self.objSortButton then
        self.objSortButton:SetActive(bVisible)
    end
end

function BackpackNewUIS:InitSortNode()
    self.comRankToggles = {}
    for i = 1,7 do
        local iIndex = i
        local objRankToggle = self:FindChildComponent(self.objSortNode, "RankNode/RankToggle/"..i, l_DRCSRef_Type.Toggle)
        self:AddToggleClickListener(objRankToggle, function(bIsOn)
            self:OnClickSortToggle(self.comRankToggles,iIndex,bIsOn)
        end)
        self.comRankToggles[iIndex] = objRankToggle
    end
    local objAllRankToggle = self:FindChildComponent(self.objSortNode, "RankNode/All", l_DRCSRef_Type.Toggle)
    self.comRankToggles[0] = objAllRankToggle
    self:AddToggleClickListener(objAllRankToggle, function(bIsOn)
        self:OnClickSortToggle(self.comRankToggles,0,bIsOn)
    end)

    self.comTypeToggles = {}
    self.objTypeNode = self:FindChild(self.objSortNode,"TypeNode")
    local objAllTypeToggle = self:FindChildComponent(self.objSortNode, "TypeNode/All", l_DRCSRef_Type.Toggle)
    if objAllTypeToggle then
        self.comAllTypeToggle = objAllTypeToggle
        self.comTypeToggles[0] = objAllTypeToggle
        self:AddToggleClickListener(objAllTypeToggle, function(bIsOn)
            self:OnClickSortToggle(self.comTypeToggles,0,bIsOn)
        end)
    end

    self.objTypeToggleNode = self:FindChild(self.objSortNode,"TypeNode/TypeToggle")
    self.iColunmCount = 3
    local comGridLayoutGroup =  self.objTypeToggleNode:GetComponent("GridLayoutGroup")
    if comGridLayoutGroup then
        self.iColunmCount = comGridLayoutGroup.constraintCount
    end
    self.objSortToggleTemplate = self:FindChild(self.objSortNode, 'TypeNode/TemplateToggle')
    self.objSortToggleTemplate:SetActive(false)
    self.comSotrBGImage = self:FindChildComponent(self.objSortNode,"BG",l_DRCSRef_Type.RectTransform)
end

function BackpackNewUIS:OnClickSortToggle(comToggles,iIndex,bIsOn)
    if iIndex == 0 then
        if bIsOn then 
            for k,v in ipairs(comToggles) do
                comToggles[k].isOn = false
            end
            comToggles[0].interactable = false
        else
            comToggles[0].interactable = true
        end
    else
        if bIsOn and comToggles[0].isOn then
            comToggles[0].isOn = false
            comToggles[0].interactable = true
        end

        if not bIsOn then
            --其他筛选取消时 勾选全部
            local bChoose = 0
            for k,v in ipairs(comToggles) do
                if comToggles[k].isOn then
                    bChoose = bChoose + 1
                    break
                end
            end
            if bChoose == 0 then
                comToggles[0].isOn = true
                comToggles[0].interactable = false
            end
        end
    end
    self.eCurSubType = 99999 
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_BOARD_INST)
end

function BackpackNewUIS:UpdateSortButton(itemTypeList)
    -- 分流一次ItemType表, 获得所有分类的子类型
    if not self.eItemType2ChildType then
        self.eItemType2ChildType = ItemDataManager:GetInstance():SplitItemType()
    end

    if not self.eItemType2ChildType then
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,150)
        self.objTypeNode:SetActive(false)
        return
    end

    self.sortEnumTypes = {}
    local options = {}
    for index, fType in ipairs(itemTypeList) do
        local kSubItemTypes = self.eItemType2ChildType[fType]
        if kSubItemTypes and (#kSubItemTypes > 0) then
            for _, kCType in ipairs(kSubItemTypes) do
                if ItemTypeDetail.ItemType_Wing ~= kCType.EnumType then
                    self.sortEnumTypes[#self.sortEnumTypes + 1] = kCType.EnumType
                    options[#options+ 1] = kCType.SimpleName
                end
            end
        end
    end

    local transNode = self.objTypeToggleNode.transform
    for k ,v in ipairs(self.comTypeToggles) do
        local toggleClone = v:GetComponent(l_DRCSRef_Type.Toggle)
        self:RemoveToggleClickListener(toggleClone)
        self:ReturnObjToPool(v.gameObject)
    end

    self.comAllTypeToggle.isOn = true
    self.comTypeToggles =  {}
    self.comTypeToggles[0] = self.comAllTypeToggle
    for k,v in ipairs(options) do
        local objClone = self:LoadGameObjFromPool(self.objSortToggleTemplate, transNode)
        objClone:SetActive(true)
        local toggleClone = objClone:GetComponent(l_DRCSRef_Type.Toggle)
        toggleClone.isOn = false
        local textClone = objClone:FindChildComponent("Label",l_DRCSRef_Type.Text)
        textClone.text = options[k]
        self.comTypeToggles[k] = toggleClone
        local iIndex = k
        self:AddToggleClickListener(toggleClone, function(bIsOn)
            self:OnClickSortToggle(self.comTypeToggles,iIndex,bIsOn)
        end)
    end

    local iShowCount = #options
    local iColunmCount = self.iColunmCount
    if iShowCount > iColunmCount then
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width, STORE_SORT_BG_HEIGHT+280 + math.ceil((iShowCount - iColunmCount) / iColunmCount) * 56)  -- 50为单个高度
        self.objTypeNode:SetActive(true)
    elseif iShowCount > 0 then
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,STORE_SORT_BG_HEIGHT+280)
        self.objTypeNode:SetActive(true)
    else
        self.comSotrBGImage.sizeDelta = DRCSRef.Vec2(self.comSotrBGImage.rect.width,STORE_SORT_BG_HEIGHT+175)
        self.objTypeNode:SetActive(false)
    end

    self.comRankToggles[0].isOn = true

    self.eCurSubType = nil
end

function BackpackNewUIS:CheckSrotRankAndType()
    if self.comRankToggles == nil then
         return 
    end
    if  self.comRankToggles[0].isOn   then
        --全部选
        self.aiSortRankType = nil
    else
        self.aiSortRankType = {} --筛选品质
        local specialRank = RankType.RT_DarkGolden
        for k ,v in ipairs(self.comRankToggles) do
            if v.isOn then
                self.aiSortRankType[k] = true
                if k == specialRank then --优秀暗金  精良暗金 都算暗金
                    self.aiSortRankType[RankType.RT_MultiColor] = true
                    self.aiSortRankType[RankType.RT_ThirdGearDarkGolden] = true
                end
            end
        end
    end

    if self.comTypeToggles[0].isOn then
        --全选
        self.aiSortType = nil
    else
        self.aiSortType = {} --筛选类型
        for k ,v in ipairs(self.comTypeToggles) do
            if v.isOn then
                self.aiSortType[self.sortEnumTypes[k]] = true
            end
        end
    end
end

-- 设置脏标
function BackpackNewUIS:SetDirtyFlag(eFlag, kExtraInfo)
    if not eFlag then
        return
    end
    local aeFlagCover = PackDirtyFlagCover[eFlag] or {}
    for index, eCoverFlag in ipairs(aeFlagCover) do
        -- 这里做一个脏标舍弃的策略, 
        -- 当某个高优脏标出现的时候, 之前已经设置的低优脏标直接丢弃
        -- 一般认为是高优脏标对应的行为包括了低优脏标的行为, 所以不用重复执行
        if self.kDirtyFlag[eCoverFlag] then
            self:ClearDirtyFlag(eCoverFlag)
        end
    end
    self.kDirtyFlag[eFlag] = true
    self.kDirtyFlag['bIsDirty'] = true
    if kExtraInfo then
        self.kDirtyFlagExInfo[eFlag] = kExtraInfo
    end
end

-- 获取脏标信息
function BackpackNewUIS:GetDirtyFlagExInfo(eFlag)
    if not (eFlag and self.kDirtyFlagExInfo) then
        return
    end
    return self.kDirtyFlagExInfo[eFlag]
end

-- 清除脏标信息
function BackpackNewUIS:ClearDirtyFlagExInfo(eFlag)
    if not (eFlag and self.kDirtyFlagExInfo) then
        return
    end
    self.kDirtyFlagExInfo[eFlag] = nil
end

-- 清除脏标
function BackpackNewUIS:ClearDirtyFlag(eFlag)
    if not eFlag then
        return
    end
    self.kDirtyFlag[eFlag] = nil
    self.kDirtyFlagExInfo[eFlag] = nil
end

-- 处理脏标
function BackpackNewUIS:DealDirtyFlag(eFlag)
    if not eFlag then
        return
    end
    -- 刷新整个背包显示(静态数据)
    if eFlag == PackDirtyFlag.UPDATE_BOARD_BASE then
        self:SetPackByBaseDataArray()
        return
    end
    -- 刷新整个背包显示(动态数据)
    if eFlag == PackDirtyFlag.UPDATE_BOARD_INST then
        self:SetPackByInstDataArray()
        return
    end
    -- 刷新当前显示的物品
    if eFlag == PackDirtyFlag.UPDATE_REFRESH then
        self:RefreshPackData()
        return
    end
    -- 重置并刷新当前显示的物品
    if eFlag == PackDirtyFlag.UPDATE_REFRESH_RESET then
        self:RefreshPackAndResetData()
        return
    end
end

-- 循环检测脏标
function BackpackNewUIS:Update()
    if (not self.kDirtyFlag) or (not self.kDirtyFlag.bIsDirty) then
        return
    end
    for strFlag, eFlag in pairs(PackDirtyFlag) do
        if self.kDirtyFlag[eFlag] then
            self:DealDirtyFlag(eFlag)
            self:ClearDirtyFlag(eFlag)
        end
    end
    self.kDirtyFlag.bIsDirty = false
end

-- 移除ui所有事件
function BackpackNewUIS:RemoveAllRegisterListener()
    if self._eventHandle and next(self._eventHandle) then
        -- RemoveEventListener 方法中会破坏self._eventHandle迭代器, 所以不在遍历中移除事件
        local toRemoveEvent = {}
        for strEvent, _ in pairs(self._eventHandle) do
            toRemoveEvent[#toRemoveEvent + 1] = strEvent
        end
        for _, strEvent in ipairs(toRemoveEvent) do
            self:RemoveEventListener(strEvent)
        end
    end
end

-- 注册背包关心的事件监听
function BackpackNewUIS:AddCareEventListener()
    -- 如果背包需要显示锁的状态, 那么注册对应的事件
    if self.bShowLockState then
        self:AddEventListener("UPDATE_ITEM_LOCK_STATE",function(itemID)
            -- 认为只有动态物品数据才会有这个事件下发
            if (not self.bShowLockState) or (not self.akInstItemArray)
            or (not itemID) or (itemID == 0) then
                return
            end
            self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH)
        end)
    end
    -- user added events
    if not (self.kCacheConfig and self.kCacheConfig.careEvent and (#self.kCacheConfig.careEvent > 0)) then
        return
    end
    -- {
    --     ['eventName'] = "UPDATE_ITEM_LOCK_STATE",  -- 事件名称
    --     ['registerCond'] = function(kBackPack)  -- 注册条件, 缺省直接注册该事件
    --         return kBackPack.bShowLockState == true
    --     end,
    --     ['responseCond'] = nil,  -- 响应条件, 缺省直接响应该事件
    --     ['callback'] = function(kBackPack)  -- 事件回调
    --         kBackPack:ShowRefreshPack()
    --     end,
    -- }
    -- remove all registered event first
    self:RemoveAllRegisterListener()
    -- register all case event
    for index, eventInfo in ipairs(self.kCacheConfig.careEvent) do
        if ((eventInfo.eventName ~= nil) and (eventInfo.eventName ~= "") and (eventInfo.callback ~= nil)) 
        and ((not eventInfo.registerCond) or (eventInfo.registerCond(self) == true)) then
            self:AddEventListener(eventInfo.eventName, function(...)
                if self._gameObject.activeSelf 
                and ((not eventInfo.responseCond) or (eventInfo.responseCond(self) == true)) then
                    eventInfo.callback(self, {...})
                end
            end)
        end
    end
end

-- 根据不同的数据, 调用不同的显示接口
function BackpackNewUIS:ShowPackByDataType()
    if self.akInstItemArray then
        self:ShowPackByInstDataArray()
    elseif self.akBaseItemArray then
        self:ShowPackByBaseDataArray()
    end
end

-- 始化导航栏
function BackpackNewUIS:InitNavBar()
    if not self.kCacheConfig then
        return
    end
    
    self.navIndex2Type = self.kCacheConfig.navData
    if not self.navIndex2Type then
        self.navIndex2Type = NavIndex2TypeDefault
    end
    local transNavBox = self.objNavBox.transform
    self:RemoveAllChildToPoolAndClearEvent(transNavBox)
    local objClone = nil
    local togFirst = nil
    for index = 1, #self.navIndex2Type do
        local navData = self.navIndex2Type[index]
        if navData and ((navData.types and #navData.types > 0) or navData.paging) then
            local iNavIndex = index
            objClone = self:LoadGameObjFromPool(self.objNavBoxTemplate, transNavBox)
            objClone.transform.name = index
            --CharacterUI 改小为三分之二
            -- if IsWindowOpen('CharacterUI') then
            --     objClone.transform.localScale= DRCSRef.Vec3(2/3,2/3,2/3)
            --     local rectClone =  objClone:GetComponent("RectTransform")
            --     SetUIAxis(objClone,rectClone.rect.width/3 * 2,rectClone.rect.height/3 * 2)
            -- end
            
            --objClone:SetDefaultScale(2/3,2/3)
            -- local rectClone =  objClone:GetComponent("RectTransform")
            -- local mm = objClone:GetComponent("RectTransform").rect
            -- local ss = rectClone.rect
            -- SetUIAxis(objClone,rectClone.rect.width/3 * 2,rectClone.rect.height/3 * 2)
            local objTextClone = self:FindChild(objClone, "Text")
            local textClone = objTextClone:GetComponent(l_DRCSRef_Type.Text)
            textClone.color = self.colorNavUnPick
            local toggleClone = objClone:GetComponent(l_DRCSRef_Type.Toggle)
            toggleClone.isOn = false
            toggleClone.group = self.comToggleGroupNavBox
            local objImageClone = self:FindChild(objClone, "Image")
            objImageClone:SetActive(true)
            local objDropDown = self:FindChild(objClone,"Dropdown")
            objDropDown:SetActive(false)
            
            local strTag = navData.text
            if not strTag then
                strTag = GetEnumText("ItemTypeDetail", navData.types[1])
            end
            textClone.text = strTag
            objTextClone:SetActive(true)

            local onClickFunc = function(bIsOn)
                local bShowAll = (strTag == "全部")
                objImageClone:SetActive(not bIsOn)
                -- 带筛选按钮的时候 不显示下拉框
                if not self.bShowSortButton then
                    objDropDown:SetActive((not bShowAll) and bIsOn and (not navData.paging)) 
                end
                if bIsOn then
                    if self.iCurTabIndex == iNavIndex then
                        return
                    end
                    textClone.color = self.colorNavPick
                    self.iCurTabIndex = iNavIndex
                    self.eCurSubType = nil
                    self:ShowPackByDataType()

                    if (not bShowAll) and not self.bShowSortButton then
                        self:UpdateDropDown(objDropDown, objTextClone, strTag, navData.types)
                    end

                    if self.bShowSortButton then
                         --资产界面 不显示筛选
                        if navData.paging then
                            self:_SetSortButtonVisible(false)
                        else
                            self:_SetSortButtonVisible(true)
                            self:UpdateSortButton(navData.types)
                        end
                    end
                else
                    objTextClone:SetActive(true)
                    textClone.text = strTag
                    textClone.color = self.colorNavUnPick
                end
            end

            self:RemoveToggleClickListener(toggleClone)
            self:AddToggleClickListener(toggleClone, onClickFunc)
            if iNavIndex == 1 then
                togFirst = toggleClone
            end
            objClone:SetActive(true)
        end
    end
    return togFirst
end

-- 重新初始化导航栏
function BackpackNewUIS:ResetNavBar(navData)
    if not (self.kCacheConfig and navData) then
        return
    end
    self.kCacheConfig.navData = navData
    self:InitNavBar()
end

-- 下拉框
function BackpackNewUIS:UpdateDropDown(objDropdown, objText, strTab, itemTypeList)
    if not (objDropdown and objText and strTab and itemTypeList and (#itemTypeList > 0)) then
        return
    end
    
    -- 分流一次ItemType表, 获得所有分类的子类型
    if not self.eItemType2ChildType then
        self.eItemType2ChildType = ItemDataManager:GetInstance():SplitItemType()
    end
    if not self.eItemType2ChildType then
        return
    end
    
    local objLabel = self:FindChild(objDropdown, "Label")
    local textLabel = objLabel:GetComponent(l_DRCSRef_Type.Text)
    local comDropdown = objDropdown:GetComponent(l_DRCSRef_Type.Dropdown) 
    objLabel:SetActive(false)

    local CSDropdown = CS.UnityEngine.UI.Dropdown
    local enumTypes = {}
    local options = {}
    local insertOptions = function(eType, strOpt)
        enumTypes[#enumTypes + 1] = eType
        options[#options + 1] = CSDropdown.OptionData(strOpt)
    end
    
    -- 插入所有类型以及子类型的选项
    insertOptions(0, "全部")
    for index, fType in ipairs(itemTypeList) do
        local kSubItemTypes = self.eItemType2ChildType[fType]
        if kSubItemTypes and (#kSubItemTypes > 0) then
            for _, kCType in ipairs(kSubItemTypes) do
                insertOptions(kCType.EnumType, kCType.BaseType)
            end
        end
    end

    comDropdown.onValueChanged:RemoveAllListeners()
    comDropdown:ClearOptions()
    comDropdown:AddOptions(options)
    comDropdown.value = 0

    local fun = function(index)
        objText:SetActive(false)
        objLabel:SetActive(true)
        self.eCurSubType = enumTypes[comDropdown.value + 1]
        if self.eCurSubType == 0 then
            textLabel.text = strTab
        end
        textLabel.color = DRCSRef.Color.white
        self:ShowPackByDataType()
    end
    
    comDropdown.onValueChanged:AddListener(fun)
end

-- 判断单个物品静态数据是否符合当前大类/子类/条件
function BackpackNewUIS:BaseItemPassCheck(kBaseItem, kInstItem)
    if not kBaseItem then
        return false
    end
    if not (self.navIndex2Type and self.iCurTabIndex and self.navIndex2Type[self.iCurTabIndex]) then
        return false
    end
    local itemMgr = ItemDataManager:GetInstance()
    -- father type
    local kCurFTypes = self.navIndex2Type[self.iCurTabIndex]

    -- 专属字段判定，不通过类型判断（用于资产这些和类型无关的物品）
    if kInstItem then
        -- 选取paging字段相同的
        if kCurFTypes and kCurFTypes['paging'] then 
            local paging = kCurFTypes['paging']
            return kInstItem['paging'] == paging
        end

        -- 忽略有paging字段的
        if kInstItem['paging'] then
            -- 全部的时候 也显示资产
            local bIsAll = false
            for index, eType in ipairs(kCurFTypes.types) do
                if (eType == ItemTypeDetail.ItemType_Null) then
                    bIsAll = true
                    break
                end
            end

            if not bIsAll then
                return false
            end
        end
    end


    local eItemType = kBaseItem.ItemType
    -- enum pre process
    if self.navIndex2Type.preProcess then
        eItemType = self.navIndex2Type:preProcess(eItemType) or eItemType
    end


    -- check child type
    if self.eCurSubType and (self.eCurSubType ~= 0) then
        if self.eCurSubType == 99999 then
            if self.aiSortRankType and not self.aiSortRankType[kBaseItem.Rank] then
                return false
            end
    
            if self.aiSortType  then
                if  not self.aiSortType[eItemType] then
                    return false
                end
            else
                -- check father type
                local bHifFType = false
                for index, eType in ipairs(kCurFTypes.types) do
                    if (eType == ItemTypeDetail.ItemType_Null) or itemMgr:IsTypeEqual(eItemType, eType) then
                        bHifFType = true
                        break
                    end
                end
                if not bHifFType then
                    return false
                end
            end
        else
            if not itemMgr:IsTypeEqual(eItemType, self.eCurSubType) then
                return false
            end
        end
    else
    -- check father type
        local bHifFType = false
        for index, eType in ipairs(kCurFTypes.types) do
            if (eType == ItemTypeDetail.ItemType_Null) or itemMgr:IsTypeEqual(eItemType, eType) then
                bHifFType = true
                break
            end
        end
        if not bHifFType then
            return false
        end
    end
    

    -- check cond
    if funcCond and (funcCond(kBaseItem) == false) then
        return false
    end
    -- final pass
    return true
end

-- 从一组物品静态数据中筛选出符合当前大类/子类/条件的物品数组
function BackpackNewUIS:FilterBaseItems(akBaseItems, funcCond)
    local akFliterItems = {}
    for index, kBaseItem in ipairs(akBaseItems) do
        if self:BaseItemPassCheck(kBaseItem) then
            akFliterItems[#akFliterItems + 1] = kBaseItem
        end
    end
    return akFliterItems
end

-- 从一组物品动态数据中筛选出符合当前大类/子类/条件的物品数组
function BackpackNewUIS:FilterInstItems(akInstItems, funcCond)
    self:CheckSrotRankAndType()
    -- 如果当前选择的tab只有ItemTypeNull, 那么直接返回当前所有物品
    if self.iCurTabIndex and self.navIndex2Type and self.navIndex2Type[self.iCurTabIndex] and not self.eCurSubType == 99999 then
        local kNav = self.navIndex2Type[self.iCurTabIndex]
        if kNav.types and (#kNav.types == 1) and (kNav.types[1] == ItemTypeDetail.ItemType_Null) then
            return akInstItems
        end
    end
    local akFliterItems = {}
    local iBaseID, kBaseItem = nil, nil
    local kTBItem = TableDataManager:GetInstance():GetTable("Item")
    for index, kInstItem in ipairs(akInstItems) do
        iBaseID = kInstItem.uiTypeID
        kBaseItem = kTBItem[iBaseID]
        if self:BaseItemPassCheck(kBaseItem, kInstItem) then
            akFliterItems[#akFliterItems + 1] = kInstItem
        end
    end
    return akFliterItems
end

-- 根据 物品没满一页时用空物品格填满一页
-- 物品超过一页但是没满一行时用空物品格填满一行的规则获取显示用的物品个数
function BackpackNewUIS:GetSCVShowCount(iRealCount)
    if not self.kCacheConfig then
        return 0
    end
    local iRow = self.kCacheConfig.RowCount or 0
    local iColumn = self.kCacheConfig.ColumnCount or 0
    local iMaxNodeNum = iRow * iColumn
    -- 当显示个数不足一页背包能显示的最大个数时, 用空白item填充满一页
    -- 显示个数不被行容量整除时, 用空白item填充到行容量的整数个
    iRealCount = iRealCount or 0
    local iShowCount = iRealCount
    if iRealCount < iMaxNodeNum then
        iShowCount = iMaxNodeNum
    elseif (iRealCount % iRow) ~= 0 then
        iShowCount = iRealCount  + (iRow - iRealCount % iRow)
    end
    return iShowCount
end

-- 通过动态id数组转化为动态物品数据数组
function BackpackNewUIS:GenInstItemListByInstIDList(aiIDs, akOutItems)
    if not (aiIDs and akOutItems) then
        return
    end
    local kItemMgr = ItemDataManager:GetInstance()
    local uiStartIndex = aiIDs[0] and 0 or 1
    for index = uiStartIndex, #aiIDs do
        local kInstItem = kItemMgr:GetItemData(aiIDs[index] or 0)
        if kInstItem then
            akOutItems[#akOutItems + 1] = kInstItem
        end
    end
end

-- 通过静态id数组转化为静态物品数据数组
function BackpackNewUIS:GenBaseItemListByBaseIDList(aiIDs, akOutItems)
    if not (aiIDs and akOutItems) then
        return
    end
    local kTBItem = TableDataManager:GetInstance():GetTable("Item")
    local uiStartIndex = aiIDs[0] and 0 or 1
    for index = uiStartIndex, #aiIDs do
        local kBaseItem = kTBItem[aiIDs[index] or 0]
        if kBaseItem then
            akOutItems[#akOutItems + 1] = kBaseItem
        end
    end
end

-- 获取主角背包物品id列表
function BackpackNewUIS:GetMainRoleItemInstDatas()
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if not (mainRoleData and mainRoleData.auiRoleItem) then
        return {}
    end
    local kRet = {}
    self:GenInstItemListByInstIDList(mainRoleData.auiRoleItem, kRet)
    return kRet
end

-- 使用动态数据更新滚动栏
function BackpackNewUIS:UpdateNodeByInstItem(transform, index)
    if not (transform and index and self.kCacheConfig and self.akInstItemArrayToSet) then
        return
    end
    local objNode = transform.gameObject
    local kInstItem = self.akInstItemArrayToSet[index + 1]
    if not kInstItem then
        self.ItemInfoUI:SetItemUIActiveState(objNode, false)
        return
    end
    local iID = kInstItem.uiID

    -- paging分页下的物品，类型强制设为分页名字
    -- TODO: 最好还是配表吧……
    local categoryName = nil
    if kInstItem.paging and self.navIndex2Type then
        for i, tempNavData in pairs(self.navIndex2Type) do
            if tempNavData.paging == kInstItem.paging then
                categoryName = tempNavData.text
                break
            end
        end
    end

    self.ItemInfoUI:UpdateUIWithItemInstData(objNode, kInstItem, self.bShowLockState, false , categoryName)
    if (self.kCacheConfig.funcOnClickItemInfo or self.kCacheConfig.funcOnClickItemIcon) then
        if iID < 0 then
            -- 资产走独立点击注册事件，因为uiID从-1开始
            self.ItemInfoUI:AddClickFunc(objNode, self.kCacheConfig.funcOnClickItemInfo, self.kCacheConfig.funcOnClickItemIcon, false, iID)
        else
            self.ItemInfoUI:AddClickFunc(objNode, self.kCacheConfig.funcOnClickItemInfo, self.kCacheConfig.funcOnClickItemIcon)
        end
    end
    -- 如果用户提供了物品数量数组, 那么使用用户提供的值
    if self.kItemNumsMap then
        self.ItemInfoUI:SetItemNum(objNode, self.kItemNumsMap[iID] or 1)
    end
    -- 如果这个节点是被选中的, 显示选中背景
    self.ItemInfoUI:SetSelectState(objNode, self:IsItemPicked(iID))
    -- 节点后处理
    if self.LateHandleItemNode then
        self.LateHandleItemNode(objNode, kInstItem, self)
    end

    -- 刷新节点处理回调（用于二次开发）
    if self.kCacheConfig.funcOnRefreshItem then
        self.kCacheConfig.funcOnRefreshItem(self.ItemInfoUI, objNode, kInstItem)
    end
end

-- 使用静态数据更新滚动栏
function BackpackNewUIS:UpdateNodeByBaseItem(transform, index)
    if not (transform and index and self.kCacheConfig and self.akBaseItemArrayToSet) then
        return
    end
    local objNode = transform.gameObject
    local kBaseItem = self.akBaseItemArrayToSet[index + 1]
    if not kBaseItem then
        self.ItemInfoUI:SetItemUIActiveState(objNode, false)
        return
    end
    local iID = kBaseItem.BaseID
    self.ItemInfoUI:UpdateUIWithItemTypeData(objNode, kBaseItem, self.bShowLockState)
    if (self.kCacheConfig.funcOnClickItemInfo or self.kCacheConfig.funcOnClickItemIcon) then
        self.ItemInfoUI:AddClickFunc(objNode, self.kCacheConfig.funcOnClickItemInfo, self.kCacheConfig.funcOnClickItemIcon)
    end
    -- 如果用户提供了物品数量数组, 那么使用用户提供的值
    if self.kItemNumsMap then
        self.ItemInfoUI:SetItemNum(objNode, self.kItemNumsMap[iID] or 1)
    end
    -- 如果这个节点是被选中的, 显示选中背景
    self.ItemInfoUI:SetSelectState(objNode, self:IsItemPicked(iID))
    -- 节点后处理
    if self.LateHandleItemNode then
        self.LateHandleItemNode(objNode, kBaseItem, self)
    end

    -- 刷新节点处理回调（用于二次开发）
    if self.kCacheConfig.funcOnRefreshItem then
        self.kCacheConfig.funcOnRefreshItem(self.ItemInfoUI, objNode, kBaseItem)
    end
end

-- 滚动栏更新接口
function BackpackNewUIS:LoopScvUpdateFunc(transform, index)
    if self.akInstItemArrayToSet then
        self:UpdateNodeByInstItem(transform, index)
    elseif self.akBaseItemArrayToSet then
        self:UpdateNodeByBaseItem(transform, index)
    end
end

-- 处理背包回调集合
function BackpackNewUIS:SetBackPackFuncSet(kFuncSet)
    if not kFuncSet then
        return
    end
    -- 显示条件(kItemData) return bool
    if kFuncSet.funcCond then
        self.CondCheck = kFuncSet.funcCond
    end
    -- 排序(kItemDataA, kItemDataB) return bool
    if kFuncSet.funcSort then
        self.SortDatas = kFuncSet.funcSort
    end
    -- 显示完一个节点后, 对这个节点的后处理(objNode, kItemData, kBackPackInst)
    if kFuncSet.funcLateHandleItemNode then
        self.LateHandleItemNode = kFuncSet.funcLateHandleItemNode
    end
end

----------------RESETDATA---------------------------

-- 重置物品动态数据
function BackpackNewUIS:ResetInstItemData(akInstItemArray)
    self.akInstItemArrayToSet = {}
    if akInstItemArray then
        self.akInstItemArray = akInstItemArray
    end
    if not self.akInstItemArray then
        return
    end
    -- init the navgation bar
    if not self.iCurTabIndex then
        self:Reset2FirstTap()
    end
    -- fliter the item array first
    self.akInstItemArrayToSet = self:FilterInstItems(self.akInstItemArray, self.CondCheck) or {}
    -- then sort the fliter result
    if self.SortDatas and (#self.akInstItemArrayToSet > 0) then
        table.sort(self.akInstItemArrayToSet, self.SortDatas)
    end
end

-- 重置物品静态数据
function BackpackNewUIS:ResetBaseItemData(akBaseItemArray)
    self.akBaseItemArrayToSet = {}
    if akBaseItemArray then
        self.akBaseItemArray = akBaseItemArray
    end
    if not self.akBaseItemArray then
        return
    end
    -- init the navgation bar
    if not self.iCurTabIndex then
        self:Reset2FirstTap()
    end
    -- fliter the item array first
    self.akBaseItemArrayToSet = self:FilterBaseItems(self.akBaseItemArray, self.CondCheck) or {}
    -- then sort the fliter result
    if self.SortDatas and (#self.akBaseItemArrayToSet > 0) then
        table.sort(self.akBaseItemArrayToSet, self.SortDatas)
    end
end


----------------SET---------------------------

-- 真正的设置物品面板数据
-- !注意, 高消耗! 原则上外部只能设置数据与脏标, 不允许外部直接调用Set接口
function BackpackNewUIS:SetPackByInstDataArray()
    -- gen self.akInstItemArrayToSet
    self:ResetInstItemData()
    if not self.akInstItemArrayToSet then
        return
    end
    -- then set the scroll view
    self.comLoopScroll.totalCount = self:GetSCVShowCount(#self.akInstItemArrayToSet) or 0
    self.comLoopScroll:RefillCells()
    -- finally clear the flag
    self:ClearDirtyFlag(PackDirtyFlag.UPDATE_BOARD_INST)
end

-- 真正的设置物品面板数据
-- !注意, 高消耗! 原则上外部只能设置数据与脏标, 不允许外部直接调用Set接口
function BackpackNewUIS:SetPackByBaseDataArray()
    if not self.akBaseItemArray then
        return
    end
    -- gen self.akBaseItemArrayToSet
    self:ResetBaseItemData()
    if not self.akBaseItemArrayToSet then
        return
    end
    -- then set the scroll view
    self.comLoopScroll.totalCount = self:GetSCVShowCount(#self.akBaseItemArrayToSet) or 0
    self.comLoopScroll:RefillCells()
    -- finally clear the flag
    self:ClearDirtyFlag(PackDirtyFlag.UPDATE_BOARD_BASE)
end

----------------REFRESH---------------------------

-- 刷新当前数据
function BackpackNewUIS:RefreshPackData()
    self.comLoopScroll:RefreshCells()
end

-- 刷新并重置当前数据
function BackpackNewUIS:RefreshPackAndResetData()
    local kFlagInfo = self:GetDirtyFlagExInfo(PackDirtyFlag.UPDATE_REFRESH_RESET)
    self:ClearDirtyFlagExInfo(PackDirtyFlag.UPDATE_REFRESH_RESET)
    -- Reset NumsMap
    if kFlagInfo and kFlagInfo.kNewItemNumsMap then
        self.kItemNumsMap = kFlagInfo.kNewItemNumsMap
    end
    -- Reset Items
    if kFlagInfo and kFlagInfo.kNewInstItems then
        self:ResetInstItemData(kFlagInfo.kNewInstItems)
    elseif kFlagInfo and kFlagInfo.kNewBaseItems then
        self:ResetBaseItemData(kFlagInfo.kNewBaseItems)
    end
    local iItemCount = 0
    if self.akInstItemArrayToSet then
        iItemCount = #self.akInstItemArrayToSet
    elseif self.akBaseItemArrayToSet then
        iItemCount = #self.akBaseItemArrayToSet
    end
    -- 刷新物品显示的时候, 如果显示的物品是呈减少状态, 那么保留当前滚动栏的显示个数不变, 减少的位置显示为空物品栏
    -- 如果物品是呈增加状态, 那么需要重新计算滚动栏应该显示的个数
    if iItemCount > self.comLoopScroll.totalCount then
        self.comLoopScroll.totalCount = self:GetSCVShowCount(iItemCount) or 0
    end
    self:RefreshPackData()
end

----------------SHOW---------------------------

-- 这里只做数据记录, 不做真正的显示与筛选, 设置一个脏标, 留到下一帧调用 设置面板ByBaseDataArray
function BackpackNewUIS:ShowPackByInstDataArray(akInstItems, kItemNumsMap, funcSet)
    if akInstItems then
        self.akInstItemArray = akInstItems
    end
    if not self.akInstItemArray then
        return
    end
    if kItemNumsMap then
        self.kItemNumsMap = kItemNumsMap
    end
    self:SetBackPackFuncSet(funcSet)
    -- just cache here, dont update the scrollview
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_BOARD_INST)
end

-- 这里只做数据记录, 不做真正的显示与筛选, 设置一个脏标, 留到下一帧调用 设置面板ByInstDataArray
function BackpackNewUIS:ShowPackByBaseDataArray(akBaseItems, kItemNumsMap, funcSet)
    if akBaseItems then
        self.akBaseItemArray = akBaseItems
    end
    if not self.akBaseItemArray then
        return
    end
    if kItemNumsMap then
        self.kItemNumsMap = kItemNumsMap
    end
    self:SetBackPackFuncSet(funcSet)
    -- just cache here, dont update the scrollview
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_BOARD_BASE)
end

-- 获取到数据之后值只用 ShowPackByInstDataArray
function BackpackNewUIS:ShowPackByInstIDArray(aiInstIDs, kItemNumsMap, funcSet)
    if not aiInstIDs then
        return
    end
    local akInstItems = {}
    self:GenInstItemListByInstIDList(aiInstIDs, akInstItems)
    self:ShowPackByInstDataArray(akInstItems, kItemNumsMap, funcSet)
end

-- 获取到数据之后值只用 ShowPackByBaseDataArray
function BackpackNewUIS:ShowPackByBaseIDArray(akBaseIDs, kItemNumsMap, funcSet)
    if not akBaseIDs then
        return
    end
    local akBaseItems = {}
    self:GenBaseItemListByBaseIDList(akBaseIDs, akBaseItems)
    self:ShowPackByBaseDataArray(akBaseItems, kItemNumsMap, funcSet)
end

-- 拿到主角物品的数据, 并调用 ShowPackByInstIDArray
function BackpackNewUIS:ShowAutoUpdateMainRolePack(bRegisterAutoUpdate, funcSet)
    -- 如果需要自动更新, 注册事件自动刷新数据
    if bRegisterAutoUpdate and (not self:HasEventListener("UPDATE_ITEM_DATA")) then
        self:AddEventListener("UPDATE_ITEM_DATA", function()
            if not self._gameObject.activeSelf then
                return
            end
            local akNewRoleItems = self:GetMainRoleItemInstDatas()
            self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH_RESET, {
                ['kNewInstItems'] = akNewRoleItems
            })
        end)
    end
    -- 获取角色背包数据
    local akInstDatas = self:GetMainRoleItemInstDatas()
    if akInstDatas then
        self:ShowPackByInstDataArray(akInstDatas, nil, funcSet)
    end
end

-- 刷新当前显示的物品数据
function BackpackNewUIS:ShowRefreshPack()
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH)
end

-- 重置并刷新当前显示的动态物品数据, kItemNumsMap若无可不提供
function BackpackNewUIS:ShowRefreshAndResetPackByInstItems(akInstItems, kItemNumsMap)
    if not akInstItems then
        akInstItems = {}
    end
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH_RESET, {
        ['kNewInstItems'] = akInstItems,
        ['kNewItemNumsMap'] = kItemNumsMap,
    })
end

-- 重置并刷新当前显示的动态物品数据, kItemNumsMap若无可不提供
function BackpackNewUIS:ShowRefreshAndResetPackByBaseItems(akBaseItems, kItemNumsMap)
    if not akBaseItems then
        akBaseItems = {}
    end
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH_RESET, {
        ['kNewBaseItems'] = akBaseItems,
        ['kNewItemNumsMap'] = kItemNumsMap,
    })
end

-- 重置并刷新当前显示的动态物品数据, kItemNumsMap若无可不提供
function BackpackNewUIS:ShowRefreshAndResetPackByInstIDArray(aiIDs, kItemNumsMap)
    local akInstItems = {}
    self:GenInstItemListByInstIDList(aiIDs, akInstItems)
    self:ShowRefreshAndResetPackByInstItems(akInstItems, kItemNumsMap)
end

-- 重置并刷新当前显示的动态物品数据, kItemNumsMap若无可不提供
function BackpackNewUIS:ShowRefreshAndResetPackByBaseIDArray(aiIDs, kItemNumsMap)
    local akBaseItems = {}
    self:GenBaseItemListByBaseIDList(aiIDs, akBaseItems)
    self:ShowRefreshAndResetPackByBaseItems(akBaseItems, kItemNumsMap)
end

----------------ITEM PICK---------------------------

-- 通过id将一个物品添加到选中列表, bCover覆盖原结果
function BackpackNewUIS:PickItemByID(iID, iPickNum, bCover)
    if not iID then
        return
    end 
    iPickNum = iPickNum or 1
    if bCover or (not self.kPickedInfo) then
        self.kPickedInfo = {['count'] = 0}
    end
    local iOldPickNum = self.kPickedInfo[iID] or 0
    self.kPickedInfo[iID] = iPickNum
    self.kPickedInfo.count = self.kPickedInfo.count +  (iPickNum - iOldPickNum)
    -- set dirty flag
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH)
end

-- 通过id数组将一组物品添加到选中列表
function BackpackNewUIS:PickItemByIDArray(aiIDs, aiNums, bCover)
    if not aiIDs then
        return
    end
    aiNums = aiNums or {}
    if bCover or (not self.kPickedInfo) then
        self.kPickedInfo = {['count'] = 0}
    end
    for index, iID in ipairs(aiIDs) do
        self.kPickedInfo[iID] = (aiNums[index] or 1)
        self.kPickedInfo.count = self.kPickedInfo.count +  (aiNums[index] or 1)
    end
    -- set dirty flag
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH)
end

-- 通过id将一个物品从选中列表移除
function BackpackNewUIS:UnPickItemByID(iID)
    if not (iID and self.kPickedInfo and self.kPickedInfo[iID]) then
        return
    end
    self.kPickedInfo.count = (self.kPickedInfo.count or 0) - self.kPickedInfo[iID]
    if self.kPickedInfo.count < 0 then
        self.kPickedInfo.count = 0
    end
    self.kPickedInfo[iID] = nil
    -- set dirty flag
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH)
end

-- 移除整个选中列表
function BackpackNewUIS:UnPickAllItems()
    self.kPickedInfo = {['count'] = 0}
    -- set dirty flag
    self:SetDirtyFlag(PackDirtyFlag.UPDATE_REFRESH)
end

-- 获取所有选中的物品id
function BackpackNewUIS:GetPickedItemIDArray()
    local list = {}
    local count = {}
    for key, res in pairs(self.kPickedInfo or {}) do
        if key ~= 'count' then
            list[#list + 1] = key
            count[#count + 1] = res
        end
    end
    return list, count
end


-- 获取选中物品的个数, 如果没有传入id, 获取总的选中个数
function BackpackNewUIS:GetPickedItemCount(iID)
    if not self.kPickedInfo then
        return 0
    end
    if iID then
        return self.kPickedInfo[iID] or 0
    end
    return self.kPickedInfo.count or 0
end

-- 某个id对应的物品是否选中?
function BackpackNewUIS:IsItemPicked(iID)
    return self:GetPickedItemCount(iID) > 0
end

-- 是否有物品被选中?
function BackpackNewUIS:HasItemPicked()
    return self:GetPickedItemCount() > 0
end

----------------OTHER FUNC---------------------------

-- 获取背包容量
function BackpackNewUIS:GetPackSize()
    if self.akInstItemArray then
        return #self.akInstItemArray
    elseif self.akBaseItemArray then
        return #self.akBaseItemArray
    end
    return 0
end

-- 将导航栏重置到第一个标签
function BackpackNewUIS:Reset2FirstTap()
    if not self.togFirst then
        return
    end
    self.togFirst.isOn = true
    self.iCurTabIndex = 1
end

-- 获取背包当前显示中的数据(经过页签选择/条件过滤后的数据集)
function BackpackNewUIS:GetCurShowItemsArray()
    if self.akInstItemArrayToSet then
        return self.akInstItemArrayToSet
    end
    return self.akBaseItemArrayToSet
end

function BackpackNewUIS:OnDestroy()
    RemoveEventTrigger(self.objRaycast)
    self.comLoopScroll:RemoveListener()
    self.ItemInfoUI:Close()
    self:RemoveAllRegisterListener()
end

return BackpackNewUIS