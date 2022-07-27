BackpackUI = class("BackpackUI", BaseWindow)
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'
local l_DRCSRef_Type = DRCSRef_Type
-- 显示模式
local ShowModel = {
    ['NormalItems'] = 1,  -- 正常显示物品
    ['TaskSubmitCond'] = 2,  -- 显示为提交物品时的条件表示
}

-- 默认背包标签页
BackpackUI.navIndex2Type_default = {
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
    }
}

-- ! 一般流程下, 背包被构建并初始化时, 会初始化导航栏, 导航栏初始化时会默认选中[全部]页签,
-- ! 选中[全部]页签时, 设置了背包的更新脏标, 并在下一帧执行背包数据的显示 (当前帧没有传入数据, 则下一帧获取主角背包内数据)
-- ! 如果ui是需要自己传数据进来显示, 但是不是当帧执行的话, 就会白跑一次背包的物品更新
-- ! 这里临时给一个解决方法, 构造背包的时候提供参数 bSetShowDataByUser 表示背包的显示数据由调用者提供, 那么初始化导航栏的时候, 不自动调用物品数据更新
function BackpackUI:ctor(obj, boolAutoUpdate, navBarData, bSetShowDataByUser)
    self:SetGameObject(obj)
    self.bSetShowDataByUser = (bSetShowDataByUser == true)
    -- 背包是否监听物品事件而进行更新
    self.boolAutoUpdate = (boolAutoUpdate ~= false)
    -- 导航栏数据
    self.navIndex2Type = navBarData or self.navIndex2Type_default
    self:init()
end

function BackpackUI:init()    
    self.ItemInfoUI = ItemInfoUI.new()
    self.comLoopScroll = self:FindChildComponent(self._gameObject, 'Pack/LoopScrollView', l_DRCSRef_Type.LoopVerticalScrollRect)
    self.comLoopScroll:AddListener(function(...) 
        if self:IsOpen() == true then
            self:LoopScvUpdateFunc(...)
        end
    end)
    self.colorNavPick = DRCSRef.Color.white
    self.colorNavUnPick = DRCSRef.Color(0.2,0.2,0.2,1)
    self.objNavBoxTemplate = self:FindChild(self._gameObject, 'Pack/navBoxTemplate')
    self.objNavBox = self:FindChild(self._gameObject, "Pack/nav_box")
    self.comToggleGroupNavBox = self.objNavBox:GetComponent(l_DRCSRef_Type.ToggleGroup)
    self:InitNavBar()
    -- self:UpdateBackpack()  -- InitNavBar里面会刷新背包, 这里就不要重复刷新了
    self.chooseItems = {}
    self.chooseNum = 1
end

-- 初始化导航栏
function BackpackUI:InitNavBar()
    if not self.navIndex2Type then
        self.navIndex2Type = self.navIndex2Type_default
    end
    local transNavBox = self.objNavBox.transform
    self:RemoveAllChildToPoolAndClearEvent(transNavBox)
    local navData = nil
    local objClone = nil
    local strTag = nil
    self.kIndex2Toggle = {}
    for index = 1, #self.navIndex2Type do
        navData = self.navIndex2Type[index]
        if navData and navData.types and (#navData.types > 0) then
            objClone = self:LoadGameObjFromPool(self.objNavBoxTemplate, transNavBox)
            objClone.transform.name = index
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
            
            strTag = navData.text
            if not strTag then
                strTag = GetEnumText("ItemTypeDetail", navData.types[1])
            end
            textClone.text = strTag
            objTextClone:SetActive(true)
            SetStringDataInGameObject(objTextClone,"Name",strTag)
            local onClickFunc = function(bIsOn)
                local objTog = objTextClone
                local tempTag = GetStringDataInGameObject(objTog,"Name")
                objImageClone:SetActive(not bIsOn)
                if tempTag == "全部" then
                    objDropDown:SetActive(false)
                else
                    objDropDown:SetActive(bIsOn) 
                end

                if bIsOn then
                    self.navBarIndex = index
                    textClone.color = self.colorNavPick
                    if self.bSetShowDataByUser ~= true then
                        self.bSetShowDataByUser = false
                        if self.eCurShowModel == ShowModel.TaskSubmitCond then
                            self:ShowTaskItem(self.needItem)
                        else
                            self:UpdateBackpack(self.auiItemIDList, self.cond, nil, true)
                        end
                    end
                    if tempTag ~= "全部" then
                        self:UpdateDropDown(objDropDown,textClone)
                    end
                else
                    objTextClone:SetActive(true)
                    textClone.text = tempTag
                    textClone.color = self.colorNavUnPick
                end
            end

            self:RemoveToggleClickListener(toggleClone)
            self:AddToggleClickListener(toggleClone, onClickFunc)
            self.kIndex2Toggle[index] = toggleClone
            if index == 1 then
                toggleClone.isOn = true
                textClone.color = self.colorNavPick
            end
            objClone:SetActive(true)
        end
    end
end

-- 重新设置导航栏
function BackpackUI:ResetNavBar(navDatas)
    self.navIndex2Type = navDatas or self.navIndex2Type_default
    self:InitNavBar()
end

-- 重选导航栏
function BackpackUI:ReChooseNav(iIndex)
    if self.kIndex2Toggle and self.kIndex2Toggle[iIndex] then
        self.kIndex2Toggle[iIndex].isOn = true
    end
end

function BackpackUI:InitBackpackGlobalListener()
    if self.boolAutoUpdate ~= true then
        return
    end
    self:AddEventListener("UPDATE_ITEM_DATA", function() 
        self.bNeedUpdate = true
    end)
    self:AddEventListener("UPDATE_ITEM_LOCK_STATE",function(itemID)
        if (self.showItemLockState) then
            self.bNeedUpdate = true
        end 
    end)
end

function BackpackUI:Update()
    if self.bNeedUpdate then
        self:SetUpdate() 
    end
end

function BackpackUI:RemoveBackpackGlobalListener()
    if self.boolAutoUpdate ~= true then
        return
    end
    self:RemoveEventListener("UPDATE_ITEM_DATA")
    self:RemoveEventListener("UPDATE_ITEM_LOCK_STATE")
end

-- 获取当前滚动栏能显示的最大节点个数
function BackpackUI:GetSCVMaxNodeNum()
    if not self.SCVMaxNodeNum then
        local objSCNode = self:FindChild(self._gameObject, "Pack/LoopScrollView")
        local iSCHeight = objSCNode:GetComponent(l_DRCSRef_Type.RectTransform).rect.height or 0
        local comContentLayout = self:FindChildComponent(objSCNode, "Content", l_DRCSRef_Type.GridLayoutGroup)
        local iCellHeight = comContentLayout.cellSize.y + comContentLayout.spacing.y
        local maxNum = math.ceil(iSCHeight / iCellHeight)
        self.SCVConstraintCount = comContentLayout.constraintCount
        self.SCVMaxNodeNum = maxNum * self.SCVConstraintCount
    end
    return (self.SCVMaxNodeNum or 0), (self.SCVConstraintCount or 0)
end

-- 显示物品的锁定状态
function BackpackUI:SetPackLockState(bEnable)
    self.showItemLockState = (bEnable ~= false)
end

function BackpackUI:GetMainRoleItemArray()
    list = {}
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData and mainRoleData.auiRoleItem then
        for index = 0, #mainRoleData.auiRoleItem do
            list[#list + 1] = mainRoleData.auiRoleItem[index]
        end
    end
    list.bIsMainRoleItems = true
    return list
end

function BackpackUI:SetUpdate()
    -- 如果self.auiItemIDList是空的, 说明外面没有传入指定要显示的物品列表
    -- 那么就需要每次显示之前获取最新的背包的物品并重新得到过滤结果
    -- 如果self.auiItemIDList非空, 那么不主动获取物品, 以UpdateBackpack里面得到的过滤结果为准
    if (not self.auiItemIDList) or (self.auiItemIDList.bIsMainRoleItems == true) then
        self.auiItemIDList = self:GetMainRoleItemArray()
        if self.bFilterSubType == nil then
            self.bFilterSubType = false
        end
        self:FilterItems(self.bFilterSubType) 
    end

    -- 筛选结果
    self.filter_item = self.filter_item or {}

    -- 排序
    if (#self.filter_item > 0) and (self.filter_item.bHasSorted ~= true) and self.sortFunc then
        table.sort(self.filter_item, self.sortFunc)
        self.filter_item.bHasSorted = true
    end

    -- 当显示个数不足一页背包能显示的最大个数时, 用空白item填充满一页
    -- 显示个数不被行容量整除时, 用空白item填充到行容量的整数个
    local realCount = getTableSize(self.filter_item)
    local maxCountOnePage, constraintCount = self:GetSCVMaxNodeNum()
    local showCount = realCount
    if realCount < maxCountOnePage then
        showCount = maxCountOnePage
    elseif (realCount % constraintCount) ~= 0 then
        showCount = realCount  + (constraintCount - realCount % constraintCount)
    end

    self.comLoopScroll.totalCount = showCount
    if self.bRefill == true then
        self.bRefill  = false
        self.comLoopScroll:RefillCells()
    else
        self.comLoopScroll:RefreshCells()
    end

    if self.bAutoSelectItemFlag then
        self.bAutoSelectItemFlag = false
        self:AutoSelectItem()
    end

    self.bNeedUpdate = false
end

function BackpackUI:UpdateBackpack(list, cond, sortFunc, bRefill, bFilterSubType)
    self.eCurShowModel = ShowModel.NormalItems

    self:ResetFirstItemRecord()

    -- 物品列表
    self.auiItemIDList = list or self:GetMainRoleItemArray()

    -- 物品筛选
    self.cond = cond
    if bFilterSubType == nil then
        self.bFilterSubType = false
    else
        self.bFilterSubType = bFilterSubType
    end

    -- 根据分类和条件过滤物品, 这里面直接使用了self.auiItemIDList
    -- 本质上只需要在SetUpdate()里面刷新界面的时候再过滤就好了
    -- 但是发现有的地方设置背包数据之后马上就要获取筛选结果...所以在UpdateBackpack这边过滤
    self:FilterItems(self.bFilterSubType)  

    -- 排序函数, 先只记录, 等到刷新滚动栏再排序数据
    -- 如果没有传入排序函数, 那么默认的排序函数为按品质和id排序
    if sortFunc then
        self.sortFunc = sortFunc
    else
        local itemDataManager = ItemDataManager:GetInstance()
        self.sortFunc = function(a, b)
            local typeDataA = itemDataManager:GetItemTypeData(a)
            local typeDataB = itemDataManager:GetItemTypeData(b)
            if typeDataA.Rank == typeDataB.Rank then
                return typeDataA.BaseID > typeDataB.BaseID
            else
                return typeDataA.Rank > typeDataB.Rank
            end
        end
    end

    if self.bRefill ~= true then
        self.bRefill = bRefill
    end

    -- 刷新脏标
    self.bNeedUpdate = true
end

-- 筛选背包
function BackpackUI:FilterItems(bFilterSubType)
    self.filter_item = {}
    for index, itemID in ipairs(self.auiItemIDList) do
        if self:Filter(itemID,bFilterSubType) then
            self.filter_item[#self.filter_item + 1] = itemID
        end
    end
end

function BackpackUI:Filter(itemID,bFilterSubType)
    local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
    if not itemTypeData then 
        return false 
    end

    if self.cond then
        local cmpID = itemTypeData.BaseID
        local kItemData = TableDataManager:GetInstance():GetTableData("Item", itemTypeData.BaseID)
        if kItemData.OrigItemID and (kItemData.OrigItemID > 0) then
            cmpID = kItemData.OrigItemID
        end

        if cmpID ~= self.cond then     -- TODO：目前 cond 指 指定物品
            return false
        end
    end

    if not self.navBarIndex then 
        return true
    end

    local navData = self.navIndex2Type[self.navBarIndex]
    if not(navData and navData.types and (#navData.types > 0)) then 
        return true 
    end

    local itemType = itemTypeData.ItemType
    -- 类型预处理
    if self.navIndex2Type.preProcess then
        itemType = self.navIndex2Type:preProcess(itemType) or itemType
    end

    if bFilterSubType then
        return self:FilterSubType(itemID)
    end

    for index, type in ipairs(navData.types) do
        if type == ItemTypeDetail.ItemType_Null then
            return true
        elseif ItemDataManager:GetInstance():IsTypeEqual(itemType, type) then
            return true
        end
    end

    return false
end

-- 二级类型筛选
function BackpackUI:GetAllSubType()
    local navData = self.navIndex2Type[self.navBarIndex]
    if not(navData and navData.types and (#navData.types > 0)) then 
        return true 
    end

    self.subType = {}
    local itemType = navData.types
    local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
    for index, value in ipairs(TB_ItemType) do
        if value.EnumType == itemType[1] then
            local subTypeID = value.ChildItemType
            if value.ChildItemType ~= nil then
                for i, id in ipairs(value.ChildItemType) do
                    local tempdata = TB_ItemType[id]
                    if tempdata then
                        local temp = {
                            ["BaseType"] = tempdata.BaseType,
                            ["EnumType"] = tempdata.EnumType
                        }
                    table.insert(self.subType,temp)
                    end
                end
            end
            return true
        end
    end
    return false
end

function BackpackUI:FilterSubType(itemID)
    local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
    if not itemTypeData then 
        return false 
    end

    local itemType = itemTypeData.ItemType
    if self.SubEnumType == nil then
        return false
    elseif ItemDataManager:GetInstance():IsTypeEqual(itemType, self.SubEnumType) then
        return true
    end

    return false
end

-- 下拉框
function BackpackUI:UpdateDropDown(objDropdown,textClone)
    self:GetAllSubType()

    if objDropdown == nil then
        return
    end
    local label = self:FindChildComponent(objDropdown, "Label", l_DRCSRef_Type.Text)
    label.gameObject:SetActive(false)
    local navData = self.navIndex2Type[self.navBarIndex]
    if not(navData and navData.types and (#navData.types > 0)) then 
        return true 
    end

    local dropdown = objDropdown:GetComponent(l_DRCSRef_Type.Dropdown) 
    local options = {} 
    local enumTypes = {}
    local baseTypes = {}
    local str = GetStringDataInGameObject(textClone.gameObject,"Name")
    table.insert(baseTypes,str)
    table.insert(enumTypes,0)
    table.insert(options,CS.UnityEngine.UI.Dropdown.OptionData("全部"))
    for key, value in pairs(self.subType) do
        table.insert(baseTypes,value.BaseType)
        table.insert(enumTypes,value.EnumType)
        table.insert(options,CS.UnityEngine.UI.Dropdown.OptionData(value.BaseType))
    end

    dropdown.onValueChanged:RemoveAllListeners()
    dropdown:ClearOptions()
    dropdown:AddOptions(options)
    dropdown.value = 0

    local fun = function(index)
        textClone.gameObject:SetActive(false)
        label.gameObject:SetActive(true)
        self.SubEnumType = enumTypes[dropdown.value + 1]
        if self.SubEnumType == 0 then
            self:UpdateBackpack(self.auiItemIDList, self.cond, nil, true,false)
            label.text = str
        else
            self:UpdateBackpack(self.auiItemIDList, self.cond, nil, true,true)
        end
        label.color = DRCSRef.Color.white
    end
    
    dropdown.onValueChanged:AddListener(fun)
end

function BackpackUI:DropDown()
    local navData = self.navIndex2Type[self.navBarIndex]
    if not(navData and navData.types and (#navData.types > 0)) then 
        return true 
    end
end

function BackpackUI:ResetBackpackShowModel()
    self.eCurShowModel = ShowModel.NormalItems
end

-- 显示任务物品
function BackpackUI:ShowTaskItem(itemIDs)
    -- 默认显示一个
    self.needItem = itemIDs
    if self.needItem == nil then
        return
    end

    self.eCurShowModel = ShowModel.TaskSubmitCond

    self.comLoopScroll.totalCount = 1
    self.comLoopScroll:RefillCells()
    -- 既然这里要自己刷ui, 那么就清理背包物品刷新的脏标
    self.bNeedUpdate = false
end

function BackpackUI:UpdateTaskItemUI(transform, index)
    local obj = transform.gameObject
    local itemTypeID = self.needItem
    if not itemTypeID then
        self.ItemInfoUI:SetItemUIActiveState(obj, false)
        return
    end


    local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemTypeID)

    self.ItemInfoUI:UpdateUIWithItemTypeData(obj, itemData, self.showItemLockState)
    self.ItemInfoUI:SetIconState(obj,"gray")

    local comNum = self:FindChildComponent(obj,'Button/ItemIconUI/Num',l_DRCSRef_Type.Text)
    comNum.text = "0"
end

-------------------------------------- 物品选中逻辑 ---------------------------------------
-------------------------------------------------------------------------------------------
-- 设置一共需要几个物品
function BackpackUI:SetChooseNum(itemNum)
    self.chooseNum = itemNum or 1
end

-- 设置物品选中 发生更新时的回调函数
function BackpackUI:SetOnChooseUpdateCallback(fun)
    self.funcOnChooseUpdate = fun
end

-- 取消/选中 该物品，弹出Tips选择/直接选择
function BackpackUI:SetClickItem(obj, itemID, type)
    -- 上面的 obj 没用了，还是放到 RefreshNearestCells 里更新
    -- 如果当前物品已经被选中，那么所有的逻辑都是取消该物品选中
    self.chooseItemTips = TipsDataManager:GetInstance():GetItemTips(itemID)
    if self:DeleteChooseItem(itemID, type) then return end
    local chooseTotal = self:GetChooseItemTotalCount()                  -- 所有物品总共选中几件
    local require = self.chooseNum - chooseTotal                        -- 还需要几件（总共需要几件 - 选中了几件）
    local itemNum = ItemDataManager:GetInstance():GetItemNum(itemID)    -- 物品共几件
    if itemNum <= 0 then
        derror("当前选择道具数量错误")
        return
    end
    local maxAdd = math.min(itemNum, require)       -- 该物品最多还能选中几件？
    local final = function(num)             -- 最终添加物品逻辑
        if require < 1 then                         -- 如果当前不需要物品了
            if self.chooseNum == num then           -- 替换物品（但实际上传入 maxAdd，导致只能选择一件物品）
                self:AddChooseItem(itemID, num, true)
            else
                SystemUICall:GetInstance():Toast('已达选中上限')
            end
            return 
        end
        self:AddChooseItem(itemID, num)
    end

    if type == PICKITEM_TYPE.PI_ICON then
        local bCanShowChoose = true
        local buttons = {}
        if self.showItemLockState and itemID then 
            -- 带有锁定特性的物品不显示任何按钮
            if not ItemDataManager:GetInstance():ItemHasLockFeature(itemID) then
                local btnName = nil
                local btnFunc = nil
                if ItemDataManager:GetInstance():GetItemLockState(itemID) then
                    bCanShowChoose = false
                    btnName = "解锁"
                    btnFunc = function()
                        ItemDataManager:GetInstance():SetItemLockState(itemID, false)
                    end
                else
                    btnName = "锁定"
                    btnFunc = function()
                        ItemDataManager:GetInstance():SetItemLockState(itemID, true)
                    end
                end
                buttons[#buttons + 1] = {
                    ['name'] = btnName,
                    ['func'] = btnFunc
                }
            end
        end

        if maxAdd < 1 then maxAdd = 1 end           -- 不需要物品，也要假设要选一件物品
        
        if bCanShowChoose then
            buttons[#buttons + 1] = {
                ['name'] = dtext(1001),
                ['func'] = function(num) final(num) end
            }
        end
        
        SystemUICall:GetInstance():TipsPop(self.chooseItemTips, buttons, maxAdd)
    elseif type == PICKITEM_TYPE.PI_INFO then
        if (not ItemDataManager:GetInstance():ItemHasLockFeature(itemID))
        and ItemDataManager:GetInstance():GetItemLockState(itemID) then
            return
        end
        if maxAdd <= 1 then                        -- 1 件物品以下，不弹提示框
            final(maxAdd)
        else
            local buttons = {
                {
                    ['name'] = dtext(1001),
                    ['func'] = function(num) 
                        self:AddChooseItem(itemID, num)
                    end
                }
            }
            SystemUICall:GetInstance():TipsPop(self.chooseItemTips, buttons, maxAdd)
        end
    else                                            -- 其他界面逻辑
        if require <= 0 and self.chooseNum ~= 1 then 
            SystemUICall:GetInstance():Toast('已达选中上限')
            return
        end
        -- 最终添加选择物品。如果选择上限为1，相当于是交换选择物品
        self:AddChooseItem(itemID, itemNum, self.chooseNum == 1)
    end
end

-- 从选中物品 删除 @prc1 并更新 UI 选中部分
function BackpackUI:DeleteChooseItem(itemID, type)
    for i = 1, #self.chooseItems do
        if self.chooseItems[i]['itemID'] == itemID then
            if type == PICKITEM_TYPE.PI_ICON then   -- 弹出Tips删除
                local buttons = {
                    {
                        ['name'] = dtext(1002),
                        ['func'] = function() 
                            table.remove(self.chooseItems, i)
                            self:UpdateUIChoose(itemID, 0)
                        end
                    }
                }
                SystemUICall:GetInstance():TipsPop(self.chooseItemTips, buttons)
            else    -- 直接删除
                table.remove(self.chooseItems, i)
                self:UpdateUIChoose(itemID, 0)
            end
            return true
        end
    end
    return false
end

-- 获取当前 选中物品 总数量
function BackpackUI:GetChooseItemTotalCount()
    local total = 0
    for i = 1, #self.chooseItems do
        total = total + self.chooseItems[i]['num']
    end
    return total
end

-- 获取当前所有选中物品数据
function BackpackUI:GetAllChooseItem()
    return self.chooseItems
end

-- 添加选择物品和数量，并刷新UI选中
function BackpackUI:AddChooseItem(itemID, itemNum, reset)
    if reset then
        self:ResetChooseItem()
    end
    if itemID then
        itemNum = itemNum or 1 
        table.insert(self.chooseItems, {['itemID']=itemID, ['num']=itemNum})
    end 

    self:UpdateUIChoose(itemID, itemNum)
end

function BackpackUI:ResetChooseItem(isRefresh)
    self.chooseItems = {}
    if isRefresh then
        self.comLoopScroll:RefreshNearestCells()
    end
end

-- 刷新UI选中，并触发回调
function BackpackUI:UpdateUIChoose(itemID, chooseNum)
    local total = self:GetChooseItemTotalCount()
    if self.funcOnChooseUpdate then
        self.funcOnChooseUpdate(total, self.chooseItems)
    end
    self.comLoopScroll:RefreshCells()
end
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

function BackpackUI:GetBackpack()
    return self.auiItemIDList
end

function BackpackUI:GetFilterCount()
    return getTableSize(self.filter_item)
end

function BackpackUI:LoopScvUpdateFunc(transform, index)
    if self.eCurShowModel == ShowModel.NormalItems then
        self:UpdateItemUI(transform, index)
    elseif self.eCurShowModel == ShowModel.TaskSubmitCond then
        self:UpdateTaskItemUI(transform, index)
    end
end

function BackpackUI:UpdateItemUI(transform, index)
    if not self.filter_item then
        self:UpdateBackpack()
    end
    local obj = transform.gameObject
    local itemID = self.filter_item[index + 1]

    if not itemID then
        self.ItemInfoUI:SetItemUIActiveState(obj, false)
        return
    end

    local itemData = ItemDataManager:GetInstance():GetItemData(itemID)
    self.ItemInfoUI:UpdateUIWithItemInstData(obj, itemData, self.showItemLockState)
    self.ItemInfoUI:AddClickFunc(obj, self.func_info, self.func_icon, self.showItemLockState)
    local objToggle = self:FindChild(obj, 'Toggle_Frame')
    local comText = self:FindChildComponent(obj,'Price/Text',l_DRCSRef_Type.Text)
    local comNum = self:FindChildComponent(obj,'Button/ItemIconUI/Num',l_DRCSRef_Type.Text)
    local itemNum = ItemDataManager:GetInstance():GetItemNum(itemID) 
    
    if not self.kChooseItemInfo then
        self.kChooseItemInfo = {["check"] = {}}
    end
    if (self.kChooseItemInfo["check"][itemID] ~= true) and itemData then
        self.kChooseItemInfo["check"][itemID] = true
        self.kChooseItemInfo[#self.kChooseItemInfo + 1] = {
            ['uiItemBaseID'] = itemData.uiTypeID or 0,
            ['uiItemID'] = itemID,
            ['uiNum'] = itemNum or 0,
        }
    end

    local chooseItem = self:FindChooseItem(itemID)
    local chooseNum = 0
    if chooseItem then
        chooseNum = chooseItem['num']
    end

    if GetGameState() ~= -1 then
        if chooseNum > 0 then
            objToggle:SetActive(true)
            self.ItemInfoUI:SetSelectState(obj, true)
            comText.color = COLOR_VALUE[COLOR_ENUM.White]
            if itemNum > 1 then
                comNum.text = string.format( "%d/%d", chooseNum, itemNum)
            else
                comNum.text = ""
            end
        else
            objToggle:SetActive(false)
            self.ItemInfoUI:SetSelectState(obj, false)
            comText.color = DRCSRef.Color(0.3882353, 0.254902, 0.1098039)
            if itemNum > 1 then 
                comNum.text = tostring(itemNum)
            elseif itemNum == 1 then
                comNum.text = ""
            end
        end
    else
        if chooseItem then
            objToggle:SetActive(true)
            self.ItemInfoUI:SetSelectState(obj, true)
            comText.color = DRCSRef.Color(0.3882353, 0.254902, 0.1098039)
            if itemNum > 1 then 
                comNum.text = tostring(itemNum)
            elseif itemNum == 1 then
                comNum.text = ""
            end
        else
            objToggle:SetActive(false)
            self.ItemInfoUI:SetSelectState(obj, false)
            comText.color = DRCSRef.Color(0.3882353, 0.254902, 0.1098039)
            if itemNum > 1 then 
                comNum.text = tostring(itemNum)
            elseif itemNum == 1 then
                comNum.text = ""
            end
        end
    end
end

-- 清除第一个物品的记录
function BackpackUI:ResetFirstItemRecord()
    self.kChooseItemInfo = nil
end

-- 设置自动选中任务物品的标记
function BackpackUI:SetAutoSelectItemFlag()
    self.bAutoSelectItemFlag = true
end

-- 自动选中合适的任务物品
function BackpackUI:AutoSelectItem()
    if (not self.kChooseItemInfo) or (#self.kChooseItemInfo == 0) then
        return
    end
    local uiChooseRemain = self.chooseNum or 1
    local kItemMgr = ItemDataManager:GetInstance()
    for index, kInfo in ipairs(self.kChooseItemInfo) do
        if uiChooseRemain <= 0 then
            return
        end
        local bItemLock, bHasLockFeature = kItemMgr:GetItemLockState(kInfo.uiItemID)
        -- 玩家自己锁定的物品, 不自动选中
        -- 带有锁定特性的物品(不是玩家自己锁定), 如果正是当前需要提交的物品, 那么也自动选中
        local bCanBeChosen = ((bHasLockFeature == true) and (self.cond == kInfo.uiItemBaseID)) or ((bHasLockFeature == false) and (bItemLock ~= true))
        if kInfo.uiItemID and (kInfo.uiItemID > 0) and bCanBeChosen then
            local uiSelectNum = (kInfo.uiNum > uiChooseRemain) and uiChooseRemain or kInfo.uiNum
            self:AddChooseItem(kInfo.uiItemID, uiSelectNum, false)
            uiChooseRemain = uiChooseRemain - uiSelectNum
        end
    end
end

function BackpackUI:FindChooseItem(itemID)
    if not (self.chooseItems and itemID) then return end
    for k,v in pairs(self.chooseItems) do
        if v.itemID == itemID then
            return self.chooseItems[k]
        end
    end
end

-- 要提前设置回调函数，然后再刷新背包。
function BackpackUI:SetClickFunc(func_info, func_icon)
    self.func_info = func_info
    self.func_icon = func_icon
end

function BackpackUI:OnEnable()
    self:InitBackpackGlobalListener()
end

function BackpackUI:OnDisable()
    self:RemoveBackpackGlobalListener()
end

function BackpackUI:OnDestroy()
    self.comLoopScroll:RemoveListener()
	self.ItemInfoUI:Close()
end

return BackpackUI