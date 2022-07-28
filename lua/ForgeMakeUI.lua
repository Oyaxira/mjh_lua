ForgeMakeUI = class("ForgeMakeUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'
local l_MAX_MAKE_COUT = 99
-- 主角制造数据ID
local l_mainRoleForgeNpc = 1

ForgeMakeUI.navIndex2Type = {
    {
        ['text'] = "全部",
        ['types'] = nil
    },
    {
        ['text'] = "装备",
        ['types'] = {
            ForgeMakeType.FMT_Jian, -- 剑
            ForgeMakeType.FMT_Dao, -- 刀
            ForgeMakeType.FMT_QuanTao, -- 拳套
            ForgeMakeType.FMT_HuTui, -- 护腿
            ForgeMakeType.FMT_Gun, -- 棍
            ForgeMakeType.FMT_ZhenXia, -- 针匣
            ForgeMakeType.FMT_Shan, -- 扇
            ForgeMakeType.FMT_YiFu, -- 衣服
            ForgeMakeType.FMT_XieZi, -- 鞋子
            ForgeMakeType.FMT_ShiPin, -- 饰品
            ForgeMakeType.FMT_ShenQi, -- 神器
            ForgeMakeType.FMT_AnQi, -- 暗器
        }
    },
    {
        ['text'] = "食物",
        ['types'] = {
            ForgeMakeType.FMT_CaiYao, -- 菜肴
        }
    },
    {
        ['text'] = "药品",
        ['types'] = {
            ForgeMakeType.FMT_DanYao, -- 丹药
        }
    },
    {
        ['text'] = "其他",
        ['types'] = {
            ForgeMakeType.ForgeMakeType_NULL,
            ForgeMakeType.FMT_RenWu, -- 任务
        }
    },
}

function ForgeMakeUI:ctor()
    self.ItemInfoUI = ItemInfoUI.new()
    self.iMakeCount = 1
    self.iMaxMakeCount = 1
    self.akForgeItemUI = {}
end

function ForgeMakeUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self._gameObject_parent = objParent
    self._inst_parent = instParent
    local obj = self:FindChild(objParent, "make_box")
	if obj then
		self:SetGameObject(obj)
    end

    -- 熟练度
    self.forge_level_top = self:FindChild(self._gameObject_parent, "forge_level_top")
    self.comForge_level_TMP = self:FindChildComponent(self.forge_level_top, "TMP_forge",l_DRCSRef_Type.Text)  -- XX熟练度   X级
    self.comScrollbar_exp = self:FindChildComponent(self.forge_level_top,"Scrollbar_exp",l_DRCSRef_Type.Scrollbar)
    self.comExp_TMP = self:FindChildComponent(self.forge_level_top, "TMP_exp",l_DRCSRef_Type.Text)    -- 经验值
    self.forge_level_top:SetActive(false)

    -- 制造
    self._gameObject:SetActive(false)
    self.objBackpack = self:FindChild(self._gameObject, "ForgePackUI")
    self.objNav_box_zhizao = self:FindChild(self.objBackpack, "Pack/nav_box")        -- 导航栏
    self.objNavBoxTemplate = self:FindChild(self.objBackpack, "Pack/navBoxTemplate")
    self.objLoopScroll = self:FindChild(self.objBackpack, "Pack/LoopScrollView")
    self.objLoopScrollContent = self:FindChild(self.objLoopScroll, "Content")
    self.comLoopScroll = self.objLoopScroll:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
    self.comLoopScroll:AddListener(function(...) 
        if self._inst_parent:IsSubViewOpen("make_box") then
            self:UpdateItemUI(...) 
        end
    end)

    self.comTMP_name = self:FindChildComponent(self._gameObject,"Image_title/TMP_name",l_DRCSRef_Type.Text)  -- 右侧物品名字
    self.objImg_default = self:FindChild(self._gameObject, "BG_LuDing")        -- 没有选择配方时 显示
    self.objText_default = self:FindChild(self._gameObject, "Text_default")    -- 没有选择配方时 显示
    self.objNumberNode = self:FindChild(self._gameObject, "number") 
    self.objItemInfo_box = self:FindChild(self._gameObject, "ItemInfo_box")    -- 右侧
        self.objLabelBack = self:FindChild(self.objItemInfo_box, "Image")
    self.objItemContent = self:FindChild(self.objItemInfo_box, "Viewport/Content").transform  -- 配方所需道具
    self.objButton_submit = self:FindChild(self._gameObject, "Button_submit")  -- 提交按钮
    self.comImg_submit = self.objButton_submit:GetComponent(l_DRCSRef_Type.Image)
    self.comText_submit = self:FindChildComponent(self.objButton_submit,"Text",l_DRCSRef_Type.Text)
    self.comButton_submit = self.objButton_submit:GetComponent(l_DRCSRef_Type.Button)
    if self.comButton_submit then
        self:AddButtonClickListener(self.comButton_submit, function()
            self:OnClickForgeMake()
        end)
    end

    local comMinusBtn = self:FindChildComponent(self._gameObject,"number/Button_minus",l_DRCSRef_Type.Button)
    if comMinusBtn then
        self:AddButtonClickListener(comMinusBtn, function()
            self:AddMakeCount(-1)
        end)
    end
    local comAddBtn = self:FindChildComponent(self._gameObject,"number/Button_add",l_DRCSRef_Type.Button)
    if comAddBtn then
        self:AddButtonClickListener(comAddBtn, function()
            self:AddMakeCount(1)
        end)
    end

    local comAllBtn = self:FindChildComponent(self._gameObject,"number/Button_all",l_DRCSRef_Type.Button)
    if comAllBtn then
        self:AddButtonClickListener(comAllBtn, function()
            self:AddMakeCount(l_MAX_MAKE_COUT)
        end)
    end  
    self.comMakeCountText = self:FindChildComponent(self._gameObject,"number/Image/Text",l_DRCSRef_Type.Text)
    self.comTextBtn = self:FindChildComponent(self._gameObject,"number/Image/Text","Button")
    self.comTextInputField = self:FindChildComponent(self._gameObject,"number/Image/InputField","InputField")
    local AddButtonClickListener = function(comBtn,func)
        self:AddButtonClickListener(comBtn,func)
    end
    local GetMaxNum = function()
        return self.iMaxMakeCount or l_MAX_MAKE_COUT
    end

    local UpdateUI = function(curNumber,curRemainNum)
        self.iMakeCount = curNumber
        self:UpdateMakeCountText()
        --刷新显示
        for k,v in ipairs(self.akForgeItemUI) do
            v:SetMakeCount(self.iMakeCount)
        end
    end
    BindInputFieldAndText(AddButtonClickListener,self.comTextBtn,self.comTextInputField,self.comMakeCountText,GetMaxNum,UpdateUI,false)

    self.objAllNavBar = {}
    -- 初始化导航栏
    self:InitNavBar()

    self.colorCategoryOnPick = DRCSRef.Color(1, 1, 1, 1)
    self.colorCategoryUnPick = DRCSRef.Color(0.3882353, 0.254902, 0.1098039, 1)
end

function ForgeMakeUI:RefreshUI(info)
    if self.curInfo then
        info = self.curInfo
    end
    -- 生成一份静态id到物品数量的映射
    local checkNum = {}
    local itemDataManager = ItemDataManager:GetInstance()
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData then 
        local auiItemIDList = mainRoleData.auiRoleItem or {}
        local uid = nil
        local uiBaseID = nil
        local kBaseData = nil
        for index = 0, #auiItemIDList do
            uid = auiItemIDList[index]
            if uid then
                kBaseData = itemDataManager:GetItemTypeData(uid)
                if kBaseData then 
                    if kBaseData.OrigItemID and (kBaseData.OrigItemID > 0) then
                        uiBaseID = kBaseData.OrigItemID
                    else
                        uiBaseID = kBaseData.BaseID
                    end
                    checkNum[uiBaseID] = (checkNum[uiBaseID] or 0) + (itemDataManager:GetItemNum(uid) or 0)
                end
            end
        end
    end
    self.checkNum = checkNum
    -- 显示熟练度
    -- self.forge_level_top:SetActive(true)
    self:UpdateMakeExp()
    
    -- 获取要显示的数据
    local forgeMakeDatas = {}
    local tableMgr = TableDataManager:GetInstance()
    self.kForgeMakeID2CondData = {}
    -- 如果传入了ForgeNPC ID
    if info and info.forgeNPCID and (info.forgeNPCID > 0) then
        self.curInfo = info
        local forgeNPCData = tableMgr:GetTableData("ForgeNpc",info.forgeNPCID)
        if forgeNPCData and forgeNPCData.ForgeMakeIDList and (#forgeNPCData.ForgeMakeIDList > 0) then
            local useCondList = forgeNPCData.UseConditionList or {}
            local useCondLangList = forgeNPCData.UseLanguageList or {}
            self.iForgeNPCID = info.forgeNPCID
            local condTagList = forgeNPCData.CondTagList or {}
            local iTagID = nil
            local iTagValue = nil
            local condTrue = true
            local tagMgr = TaskTagManager:GetInstance()
            for index, forgeMakeID in ipairs(forgeNPCData.ForgeMakeIDList) do
                -- 判断配方解锁
                condTrue = true
                iTagID = condTagList[index] or 0
                if iTagID ~= 0 then
                    iTagValue = tagMgr:GetTag(iTagID) or 0
                    condTrue = iTagValue > 0
                end
                if condTrue then
                    forgeMakeDatas[#forgeMakeDatas + 1] = forgeMakeID
                    if useCondList[index] and (useCondList[index] > 0) then
                        self.kForgeMakeID2CondData[forgeMakeID] = {
                            ['data'] = tableMgr:GetTableData("Condition", useCondList[index])
                        }
                    end
                    -- 如果存在条件并且填写了语言表id, 那么分析条件描述
                    if self.kForgeMakeID2CondData[forgeMakeID] and useCondLangList[index] and (useCondLangList[index] > 0) then
                        self.kForgeMakeID2CondData[forgeMakeID]['desc'] = GetLanguageByID(useCondLangList[index])
                    end
                end
            end
        end
    -- 否则, 查询玩家解锁的所有配方
    else
        self.iForgeNPCID = 1  -- 1表示主角
        -- 这里要加入主角的初始配方, 为ForgeNpc中BaseID为1的数据
        local forgeNPCData = tableMgr:GetTableData("ForgeNpc",self.iForgeNPCID)
        if forgeNPCData then
            for index, forgeMakeID in ipairs(forgeNPCData.ForgeMakeIDList) do
                forgeMakeDatas[#forgeMakeDatas + 1] = forgeMakeID
            end
        end
        -- 然后加入玩家解锁的配方
        local kUnlockPool = globalDataPool:getData("UnlockPool") or {}
        local kForgeMakeData = kUnlockPool[STLULT_FORMULA] or {}
        for typeID, data in pairs(kForgeMakeData) do
            forgeMakeDatas[#forgeMakeDatas + 1] = typeID
        end
    end

    self:ResetItemContent()
    
    -- 过滤源数据
    forgeMakeDatas = self:FliterForgeMakeData(forgeMakeDatas)
    -- 数据分类 先可生产>不可生产，后是档次高>低 
    self.recipeItemList = self:DivideRecipes(forgeMakeDatas)
    self.comLoopScroll.totalCount = getTableSize(self.recipeItemList)
    if self.bRefill == true then
        self.bRefill = false
        self.comLoopScroll:RefillCells()
    else
        self.comLoopScroll:RefreshCells()
        self.comLoopScroll:RefreshNearestCells()
    end

    -- 如果有已选的数据
    if self.recipeSelect and self.objCurSelect then
        self:OnClick_Info(self.recipeSelect, self.objCurSelect)
    else
        self.recipeSelect = nil
        self.comButton_submit.interactable = false
        self.comText_submit.text = "待选择"
        setUIGray(self.comImg_submit, true)
        self:SetDetailMakeBox()
    end
end

function ForgeMakeUI:OnDisable()
    self.curInfo = nil
    self.recipeSelect = nil
end

-- 初始化导航栏
function ForgeMakeUI:InitNavBar()
    local navData = nil
    local objClone = nil
    local strTag = nil
    local iCount = 1
    for index = 1, #self.navIndex2Type do
        navData = self.navIndex2Type[index]
        if navData then
            if iCount > #self.objAllNavBar then
                objClone = CloneObj(self.objNavBoxTemplate, self.objNav_box_zhizao)
                self.objAllNavBar[iCount] = objClone
            else
                objClone = self.objAllNavBar[iCount]
            end
            iCount = iCount + 1
           
            if (objClone ~= nil) then
                local textClone = self:FindChildComponent(objClone, "Text", l_DRCSRef_Type.Text)
                local toggleClone = objClone:GetComponent(l_DRCSRef_Type.Toggle)
                local objImageClone = self:FindChild(objClone, "Image")
                strTag = navData.text
                if (not strTag) and navData.types and (#navData.types > 0) then
                    strTag = GetEnumText("ForgeMakeType", navData.types[1])
                end
                textClone.text = strTag or "?"
                local onClickFunc = function(bIsOn)
                    objImageClone:SetActive(not bIsOn)
                    if bIsOn then
                        textClone.color = DRCSRef.Color.white
                        self.navIndex = index
                        self.bRefill = true
                        self.recipeSelect = nil
                        self:RefreshUI()
                    else
                        textClone.color = DRCSRef.Color(0.2,0.2,0.2,1)
                    end
                end
                self:RemoveToggleClickListener(toggleClone)
                if index == 1 then
                    toggleClone.isOn = true
                    textClone.color = DRCSRef.Color.white
                end
                self:AddToggleClickListener(toggleClone, onClickFunc)
                objClone:SetActive(true)
            end
        end
    end

    for i = iCount,  #self.objAllNavBar do
        self.objAllNavBar[i]:SetActive(false)
    end
end

-- 根据导航栏过滤配方数据
function ForgeMakeUI:FliterForgeMakeData(oriDatas)
    local navData = self.navIndex2Type[self.navIndex or 1]
    if not navData then return 
        oriDatas 
    end

    local curTypes = navData.types
    if not (curTypes and (#curTypes > 0)) then
        return oriDatas
    end

    local checkOk = {}
    for index, type in ipairs(curTypes) do
        -- -- 如果当前导航栏数据有空类型, 则直接返回全部数据
        -- if type == ForgeMakeType.ForgeMakeType_NULL then
        --     return oriDatas
        -- end
        checkOk[type] = true
    end
    local ret = {}
    local forgeMakeTypeData = nil
    for index, forgeMakeTypeID in ipairs(oriDatas) do
        forgeMakeTypeData = TableDataManager:GetInstance():GetTableData("ForgeMake",forgeMakeTypeID)
        if checkOk[forgeMakeTypeData.ForgeType] then
            ret[#ret + 1] = forgeMakeTypeID
        end
    end
    return ret
end

-- 更新物品节点
function ForgeMakeUI:UpdateItemUI(transform, index)
    local ui_child = transform.gameObject
    if not ui_child then return end
    local data = self.recipeItemList[index + 1]
    if not data then return end
    local recipeItem = data.recipeItem
    local canProduce = data.canProduce
    local objToggleFrame = self:FindChild(ui_child,'Toggle_Frame')
    local objToggleBG = self:FindChild(ui_child,'Button/Toggle_BG')
    local textCategory = self:FindChildComponent(ui_child,'Category', l_DRCSRef_Type.Text)
    if self.recipeSelect and (self.recipeSelect.baseID == recipeItem.baseID) then
        objToggleFrame:SetActive(true)
        objToggleBG:SetActive(true)
        if textCategory then
            textCategory.color = self.colorCategoryOnPick
        end
    else
        objToggleFrame:SetActive(false)
        objToggleBG:SetActive(false)
        if textCategory then
            textCategory.color = self.colorCategoryUnPick
        end
    end
    local typeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(recipeItem.target)
    self.ItemInfoUI:UpdateUIWithItemTypeData(ui_child, typeData)
    local objProducible = self:FindChild(ui_child, "Producible")
    local objInadequate = self:FindChild(ui_child, "Inadequate")
    local objButton = self:FindChild(ui_child, "Button")
    local comButoon = objButton:GetComponent(l_DRCSRef_Type.Button)
    if comButoon then
        self:RemoveButtonClickListener(comButoon)
        -- FIXME: 只要使用 self:AddButtonClickListener 就不能自行 destroy 该节点, 现在不保存只是临时处理
        self:AddButtonClickListener(comButoon, function() 
            self:OnClick_Info(recipeItem, ui_child)
        end)
    end
    local btnIcon = self:FindChildComponent(objButton, "ItemIconUI", l_DRCSRef_Type.Button)
    if btnIcon then
        self:RemoveButtonClickListener(btnIcon)
        self:AddButtonClickListener(btnIcon, function() 
            local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, typeData)
            if not tips then
                return
            end
            if self.objCurSelect ~= ui_child then
                tips.buttons = {{
                    ['name'] = "选中",
                    ['func'] = function()
                        self:OnClick_Info(recipeItem, ui_child)
                    end
                }}
            end
            OpenWindowImmediately("TipsPopUI", tips)
        end)
    end
    objProducible:SetActive(canProduce)
    objInadequate:SetActive(not canProduce)
end

--点击制作按钮
function ForgeMakeUI:OnClickForgeMake()
    if not(self.recipeSelect and self.recipeSelect.makeData) then 
        return 
    end
    local selectInfo = {}
    if self.iForgeNPCID ~= l_mainRoleForgeNpc then 
        selectInfo = RoleDataManager:GetInstance():GetSelectInfo()
        if not selectInfo then 
            showError('[ForgeMakeUI]->OnClickForgeMake 非法执行制作操作')
            return
        end
    end
    -- 交互角色ID
    local interactRoleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(selectInfo.roleID or 0)
    local uiMakerID = self.recipeSelect.makeData.BaseID
    SendClickItemForgeCMD(uiMakerID, self.iForgeNPCID, self.iMakeCount, selectInfo.mapID, selectInfo.mazeTypeID, interactRoleBaseID)
end

-- 配方使用条件解析
function ForgeMakeUI:CheckForgeMakeUseCond(iForgeMakeID)
    if not iForgeMakeID then
        return false, ""
    end
    if not (self.kForgeMakeID2CondData and self.kForgeMakeID2CondData[iForgeMakeID]) then
        return true
    end
    local kCondData = self.kForgeMakeID2CondData[iForgeMakeID].data
    local strDesc = self.kForgeMakeID2CondData[iForgeMakeID].desc
    local bCanUse = false
    local eType = kCondData.CondType
    -- 对有限种Condtion类型进行分析, 如果策划要求支持更多的条件类型, 需要在这里加逻辑
    if eType == ConditionType.CT_MEN_PAI_HAO_GAN_DU_BI_JIAO then
        local iClanTypeID = tonumber(kCondData.CondArg1 or 0)
        local iValue = tonumber(kCondData.CondArg3 or 0)
        local iCurValue = ClanDataManager:GetInstance():GetDisposition(iClanTypeID) or 0
        bCanUse = (iCurValue >= iValue)
        -- 如果没有填写特定的描述, 自己组装一个
        if (not bCanUse) and (not strDesc) then
            local strClanName = ClanDataManager:GetInstance():GetClanNameByBaseID(iClanTypeID) or ""
            strDesc = string.format("<color=#E70D00>%s好感度达到%d</color>", strClanName, iValue)
        end
    end

    return bCanUse, (strDesc or "")
end

-- 右侧显示一个配方是否可生产，如果可以生产√，数量值黑色，如果不能生产灰度，数量值红色
function ForgeMakeUI:SetDetailMakeBox(recipeItem)
    if not recipeItem then
        self.objText_default:SetActive(true)
        self.objImg_default:SetActive(true)
        self.objItemInfo_box:SetActive(false)
        self.objNumberNode:SetActive(false)
        self.comTMP_name.text = "制造"
        return
    end
    self.objNumberNode:SetActive(true)
    self.objText_default:SetActive(false)
    self.objImg_default:SetActive(false)
    self.objItemInfo_box:SetActive(true)
    self.objLabelBack:SetActive(true)
    self.comMakeCountText.gameObject:SetActive(true)
    self.comTextInputField.gameObject:SetActive(false)
    local typeData = recipeItem.typeData
    self.comTMP_name.text =  getRankBasedText(typeData.Rank, typeData.ItemName or '')
    self:ResetItemContent()
    local makings = recipeItem.makeData["Makings"]
    local counts = recipeItem.makeData["MakingsCounts"]
    local bCanMake = true
    local strBtnText = ""
    for i = 1, #makings do
        self.akForgeItemUI[i] =  LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ForgeItemIconUI,self.objItemContent)
        local kIconItem = self.akForgeItemUI[i]
        if (kIconItem ~= nil) then
            local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",makings[i])
            kIconItem:UpdateUIWithItemTypeData(itemTypeData)
            local int_have = self.checkNum[makings[i]] or 0
            local int_need = self:GetMakingRequireNum(recipeItem.target, makings[i], counts[i])
            if int_have < int_need then
                bCanMake = false
                strBtnText = "材料不足"
            end
            kIconItem:InitCountInfo(int_have,int_need,self.iMakeCount)
            local iCanMakeCount = math.floor(int_have / int_need)
            if iCanMakeCount < self.iMaxMakeCount then
                self.iMaxMakeCount = iCanMakeCount
        end
    end
    end
    -- 检查使用条件
    local bCondCheck, strCondDesc = self:CheckForgeMakeUseCond(recipeItem.baseID)
    if not bCondCheck then
        bCanMake = false
        strBtnText = strCondDesc
    end
    self:SetSubmitButtonStatus(bCanMake,strBtnText)
    self:UpdateMakeCountText()
end

-- 更新按钮状态
function ForgeMakeUI:SetSubmitButtonStatus(bCanMake)
    self.comButton_submit.interactable = bCanMake
    if bCanMake then
        self.comText_submit.text = "生产"
    else
        self.comText_submit.text = strBtnText or "不可生产"
    end
    setUIGray(self.comImg_submit, not bCanMake)
end

function ForgeMakeUI:AddMakeCount(iAddCount)
    --最低1个 
    if self.iMakeCount == 1 and iAddCount < 0 then
        return
    --最多99个或可制造上限
    elseif (self.iMaxMakeCount > l_MAX_MAKE_COUT or self.iMaxMakeCount == self.iMakeCount) and iAddCount > 0 then
        return
    end
    self.iMakeCount = self.iMakeCount + iAddCount
    if self.iMakeCount > self.iMaxMakeCount then
        self.iMakeCount = self.iMaxMakeCount
    end

    if self.iMakeCount < 1 then
        self.iMakeCount = 1
    elseif self.iMakeCount > l_MAX_MAKE_COUT then
        self.iMakeCount = l_MAX_MAKE_COUT 
    end
    self:UpdateMakeCountText()
    --刷新显示
    for k,v in ipairs(self.akForgeItemUI) do
        v:SetMakeCount(self.iMakeCount)
    end
end

function ForgeMakeUI:UpdateMakeCountText()
    if self.iMakeCount and self.iMaxMakeCount then
        self.comMakeCountText.text = self.iMakeCount .. "/" .. self.iMaxMakeCount
        self.comTextInputField.text = self.iMakeCount
    end
end

-- 成功生产一个物品，增加制造熟练度
function ForgeMakeUI:UpdateMakeExp()
    local exp = 0
    local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then 
        exp =  role_info["MainRole"][MRIT_FORGE_EXP] or 1
    end
    -- 经验换算到等级
    local level = nil
    local curRExpLimit = 0
    local curLExpLimit = 0
    local curRangLen = 0
    local TB_ForgeLevelExp = TableDataManager:GetInstance():GetTable("ForgeLevelExp")
    for lv, limit in ipairs(TB_ForgeLevelExp) do
        curRExpLimit = limit.ForgeExp or 0
        if exp < curRExpLimit then
            level = lv
            if lv == 1 then
                curRangLen = curRExpLimit
                curLExpLimit = 0
            else
                curLExpLimit = TB_ForgeLevelExp[lv - 1].ForgeExp or 0
                curRangLen = curRExpLimit - curLExpLimit
            end
            break
        end
    end

    -- 遍历完全表还没有找到等级, 就取最大等级
    if not level or level == #TB_ForgeLevelExp then
        level = #TB_ForgeLevelExp
        self.comExp_TMP.text = "已满级"
        self.comScrollbar_exp.size = 1
    else
        local expSub = exp - curLExpLimit
        self.comExp_TMP.text = string.format( "%d/%d", expSub, curRangLen)
        local size = 1
        if expSub <= curRangLen then
            size = expSub / curRangLen
        end
        self.comScrollbar_exp.size = size
    end
    self.comForge_level_TMP.text = string.format("制造熟练度%d级", level)
end

-- 取消选中当前所有ui节点
function ForgeMakeUI:UnPickAllItemNodes()
    local contentTrans = self.objLoopScrollContent.transform
    local itemNode = nil
    for index = 0, contentTrans.childCount - 1 do
        itemNode = contentTrans:GetChild(index).gameObject
        self:FindChild(itemNode,'Toggle_Frame'):SetActive(false)
        self:FindChild(itemNode,'Button/Toggle_BG'):SetActive(false)
        local textCategory = self:FindChildComponent(itemNode,'Category', l_DRCSRef_Type.Text)
        if textCategory then
            textCategory.color = self.colorCategoryUnPick
        end
    end
end

function ForgeMakeUI:OnClick_Info(recipeItem, obj)
    self.recipeSelect = recipeItem        -- 设置当前选中
    self.objCurSelect = obj
    
    self:UnPickAllItemNodes()
    self:FindChild(obj,'Toggle_Frame'):SetActive(true)
    self:FindChild(obj,'Button/Toggle_BG'):SetActive(true)
    local textCategory = self:FindChildComponent(obj,'Category', l_DRCSRef_Type.Text)
    if textCategory then
        textCategory.color = self.colorCategoryOnPick
    end

    self.iMakeCount = 1
    self.iMaxMakeCount = 99

    self:SetDetailMakeBox(recipeItem)
end

function ForgeMakeUI:GetMakingRequireNum(target, making, count)
    -- TODO: 根据生产角色的身份进行材料的减免，生产_获取材料需求数目
    return count
end

-- 将配方列表 按照 能否生产、 品质 排序
function ForgeMakeUI:DivideRecipes(recipeData)
    local can_produce = {}
    local not_produce = {}
    local recipeItemList = {}
    for i = 1, #recipeData do
        -- TODO: 配方的显示条件
        local makeData = TableDataManager:GetInstance():GetTableData("ForgeMake",recipeData[i]) or {}
        local target = makeData["TargetItemID"] or 0
        local typeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(target)
        if typeData then
            local itemRank = typeData.Rank or RankType.RT_White
            -- 组装
            local tb_making = {
                ['baseID'] = recipeData[i],
                ['makeData'] = makeData,
                ['target'] = target,
                ['typeData'] = typeData,
                ['itemRank'] = typeData.Rank,
            }
            -- 插入
            if self:IsPossibleToProduce(recipeData[i]) then 
                table.insert(can_produce, tb_making)
            else
                table.insert(not_produce, tb_making)
            end
        end
    end
    -- 排序
    local sort_func = function(a,b)
        if a.itemRank == b.itemRank then
            return a.baseID > b.baseID
        end
        return a.itemRank > b.itemRank
    end
    table.sort(can_produce, sort_func)
    table.sort(not_produce, sort_func)

    for index, data in ipairs(can_produce) do
        recipeItemList[#recipeItemList + 1] = {
            ['recipeItem'] = data,
            ['canProduce'] = true
        }
    end
    for index, data in ipairs(not_produce) do
        recipeItemList[#recipeItemList + 1] = {
            ['recipeItem'] = data,
            ['canProduce'] = false
        }
    end

    return recipeItemList
end

-- 检查当前配方是否可生产
function ForgeMakeUI:IsPossibleToProduce(baseID)
    if not (baseID) then return false end
    local makeData = TableDataManager:GetInstance():GetTableData("ForgeMake",baseID)
    if (not makeData) then
        return false
    end
    local makings = makeData["Makings"]
    local counts = makeData["MakingsCounts"]
    local target = makeData["TargetItemID"]
    for i = 1, #makings do
        local int_have = self.checkNum[makings[i]] or 0
        local int_need = self:GetMakingRequireNum(target, makings[i], counts[i])
        if int_have < int_need then
            return false
        end
    end
    return true 
end

function ForgeMakeUI:ResetItemContent()
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.akForgeItemUI)
    self.akForgeItemUI = {}
end

function ForgeMakeUI:OnDestroy()
    self:ResetItemContent()
end

return ForgeMakeUI