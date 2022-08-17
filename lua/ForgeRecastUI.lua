ForgeRecastUI = class("ForgeRecastUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type

local BackpackNewUICom = require 'UI/Role/BackpackNewUI'
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local ForgeAttrChangeUI = require 'UI/Forge/ForgeAttrChangeUI'

function ForgeRecastUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
    --同时执行属性改变界面的构造函数
    self.ForgeAttrChangeUIInst = ForgeAttrChangeUI.new()
end

function ForgeRecastUI:Init(objParent, instParent)
    -- 初始化
    if not (objParent and instParent) then return end
    self._gameObject_parent = objParent
    self._inst_parent = instParent
    local obj = self:FindChild(objParent, "recast_box")
	if obj then
		self:SetGameObject(obj)
    end

    -- 初始化背包
    self.objBackpack = self:FindChild(obj, "BackpackUI")
    self.BackpackNewUICom = BackpackNewUICom.new({
        ['objBind'] = self.objBackpack,  -- 背包实例绑定的ui节点
        ['navData'] = self._inst_parent.classToType_recast,  -- 导航栏数据
        ['RowCount'] = 2,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 6,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)
            local recastData = {}
            local kItemMgr = ItemDataManager:GetInstance()
            recastData['typeData'] = kItemMgr:GetItemTypeData(itemID)
            recastData['instData'] = kItemMgr:GetItemData(itemID)
            recastData['uiItemID'] = itemID
            self:OnClickRecastItem(recastData)
        end, 
        ['funcOnClickItemIcon'] = function(obj, itemID)
            local kItemMgr = ItemDataManager:GetInstance()
            local kTypeData = kItemMgr:GetItemTypeData(itemID)
            local kInstData = kItemMgr:GetItemData(itemID)
            local tips = TipsDataManager:GetInstance():GetItemTipsByData(kInstData, kTypeData)
            if not tips then
                return
            end
            if self.recastItem_chose_dynamic ~= kInstData then
                tips.buttons = {{
                    ['name'] = "选中",
                    ['func'] = function()
                        local recastData = {}
                        recastData['typeData'] = kTypeData
                        recastData['instData'] = kInstData
                        recastData['uiItemID'] = itemID
                        self:OnClickRecastItem(recastData)
                    end
                }}
            end
            OpenWindowImmediately("TipsPopUI", tips)
        end,
    })

    -- 同时初始化属性改变界面
    self.ForgeAttrChangeUIInst:Init(objParent, self)

    -- 熟练度
    self.forge_level_top = self:FindChild(self._gameObject_parent, "forge_level_top")
    self.comForge_level_TMP = self:FindChildComponent(self.forge_level_top, "TMP_forge",l_DRCSRef_Type.Text)  -- XX熟练度   X级
    self.comScrollbar_exp = self:FindChildComponent(self.forge_level_top,"Scrollbar_exp",l_DRCSRef_Type.Scrollbar)
    self.comExp_TMP = self:FindChildComponent(self.forge_level_top, "TMP_exp",l_DRCSRef_Type.Text)    -- 经验值

    -- 重铸
    self._gameObject:SetActive(false)

    self.text_itemName_recast = self:FindChildComponent(self._gameObject, "Image_title/TMP_name",l_DRCSRef_Type.Text)
    self.obj_defaultTip_recast = self:FindChild(self._gameObject, "Text_default")
    self.objImg_default = self:FindChild(self._gameObject, "BG_LuDing") 
    self.obj_warning_recast = self:FindChild(self._gameObject, "Text_warning")
    self.obj_sc_info_recast = self:FindChild(self._gameObject, "ItemInfo_box")
    self.obj_content_info_recast = self:FindChild(self.obj_sc_info_recast, "SC_material/Viewport/Content")
    self.obj_content_prop_recast = self:FindChild(self.obj_content_info_recast, "Content")
    self.toggleGroup_content_prop_recast = self.obj_content_prop_recast:GetComponent(l_DRCSRef_Type.ToggleGroup)
    self.obj_prop_template = self:FindChild(self.obj_content_info_recast, "RecastInfo_template")
    self.obj_prop_template:SetActive(false)
    self.obj_coinBox = self:FindChild(self.obj_content_info_recast, "TongBi_box")
    self.obj_jingTieBox = self:FindChild(self.obj_content_info_recast, "JingTie_box")
    self.obj_wanMeiFenBox = self:FindChild(self.obj_content_info_recast, "WanMeiFen_box")
    self.obj_TianGongChui_Box = self:FindChild(self.obj_content_info_recast, "TianGongChui_Box")
    self.obj_wmfInfo = self:FindChild(self.obj_jingTieBox, "MaterialInfo_box")
    self.obj_wmfItemInfo = self:FindChild(self.obj_jingTieBox, "MaterialInfo_box/ItemIconUI2")
    self.obj_TingGongChuiItem =  self:FindChild(self.obj_TianGongChui_Box, "MaterialInfo_box/ItemIconUI")
    self.com_TianGongChui = self:FindChildComponent(self.obj_TianGongChui_Box, "MaterialInfo_box/Text_num", l_DRCSRef_Type.Text)
    self.text_wmfNum = self:FindChildComponent(self.obj_wmfInfo, "Text_num2", l_DRCSRef_Type.Text)
    self.obj_text_wmf_choosen = self:FindChild(self.obj_wmfInfo, "Text_choosen")
    self.text_wmf_choosen = self.obj_text_wmf_choosen:GetComponent(l_DRCSRef_Type.Text)
    self.obj_toggle_wmf_choosen = self:FindChild(self.obj_wmfInfo, "Toggle_choosen")
    self.toggle_wmf_choosen = self.obj_toggle_wmf_choosen:GetComponent(l_DRCSRef_Type.Toggle)
    self:AddToggleClickListener(self.toggle_wmf_choosen, function(bOn)
        self:OnClickToggleUseWMF(bOn)
    end)
    self.btn_recast = self:FindChild(self._gameObject, "Button_recast")
    self.com_RepairCrack = self:FindChildComponent(self._gameObject, "Button_RepairCrack", l_DRCSRef_Type.Button)
    self.com_RepairCrackImg = self:FindChildComponent(self._gameObject, "Button_RepairCrack", l_DRCSRef_Type.Image)
    self.img_btn_recast = self.btn_recast:GetComponent(l_DRCSRef_Type.Image)
    self.com_btn_recast = self.btn_recast:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.com_btn_recast, function()
        if self.recastBtnOnClick then
            self.recastBtnOnClick()
        else
            dprint("recast button hasn't an onClickFunc( self.recastBtnOnClick is nil )")
        end
    end)

    self:AddButtonClickListener(self.com_RepairCrack, function()
        if self.uiChooseItemID ~= nil then
            SendClickItemRepairCrackCMD(self.uiChooseItemID)
        end
    end)

    -- 材料数量
    self.objMatNumBox = self:FindChild(self._gameObject, "MatNumBox")
    self.objWanMeiFenNum = self:FindChild(self.objMatNumBox, "WanMeiFen")
    self.objJingTieNum = self:FindChild(self.objMatNumBox, "JingTie")
    self.objTianGongChuiNum = self:FindChild(self.objMatNumBox, "TianGongChui")
    self.comWanMeiFenNum = self:FindChildComponent(self.objWanMeiFenNum, "Num", l_DRCSRef_Type.Text)
    self.comJingTieNum = self:FindChildComponent(self.objJingTieNum, "Num", l_DRCSRef_Type.Text)
    self.comTianGongChuiNum = self:FindChildComponent(self.objTianGongChuiNum, "Num", l_DRCSRef_Type.Text)

    -- 其它值
    self.color_no = UI_COLOR.red
    self.color_ok = UI_COLOR.green
    self.color_attrOnPick = DRCSRef.Color(0.8705882, 0.8705882, 0.8705882, 1)
    self.color_attrUnPick = DRCSRef.Color(0.2352941, 0.2352941, 0.2352941, 1)

    -- 注册监听
    self:AddEventListener("ReforgeAttrResult", function(info)
        local pack = {
            ['uiType'] = info.uiAttrTypeID,
            ['iBaseValue'] = info.iBaseValue,
            ['iExtraValue'] = info.iExtraValue,
            ['uiAttrUID'] = info.uiDynamicAttrID,
            ['uiRecastType'] = 1,
            ['uiBlueAttrTypeID'] = info.uiBlueAttrTypeID,
            ['iBlueBaseValue'] = info.iBlueBaseValue,
            ['uiEnhanceWhiteAttrTypeID'] = info.uiEnhanceWhiteAttrTypeID
        }
        self:ShowAttrChangeWithAttrData(pack)
    end)
end

function ForgeRecastUI:RefreshUI(info)
    -- 显示熟练度
    self.forge_level_top:SetActive(false)
    self:UpdateRecastExp()
    if self.recastBoxShown ~= true then
        self.recastBoxShown = true
        -- 状态初始化
        self.obj_defaultTip_recast:SetActive(true)
        self.objImg_default:SetActive(true)
        self.obj_warning_recast:SetActive(false)
        self.obj_sc_info_recast:SetActive(false)
        self.obj_coinBox:SetActive(false)
        self.obj_jingTieBox:SetActive(false)
        self.obj_wanMeiFenBox:SetActive(false)
        self.obj_TianGongChui_Box:SetActive(false)
        self.com_RepairCrack.gameObject:SetActive(false)
        self.btn_recast:SetActive(true)
        self:SetRecastBtnState(true, false, false, "待选择")
        
        -- 数据初始化
        self.recastAttrPool = {}
        self.recastAttrPool_index = 0
        self.recastAttrPool_max = 0
        self:HideAllChildren(self.obj_content_prop_recast)
    end
    -- 物品初始化
    self.curRecastChose = nil
    self:UpdateRecastItemList()
    -- 其它
    self:UpdateMatsNum()
end

function ForgeRecastUI:Update()
    self.BackpackNewUICom:Update()
end

-- 获取物品管理对象
function ForgeRecastUI:GetItemManager()
    if not self.itemDataMgr then
        self.itemDataMgr = ItemDataManager:GetInstance()
    end
    return self.itemDataMgr
end

-- 隐藏所有子ui
function ForgeRecastUI:HideAllChildren(obj)
    local t = obj.transform
    for int_i = t.childCount - 1, 0, -1 do
		t:GetChild(int_i).gameObject:SetActive(false)
    end
end

-- 获取一条重铸属性的描述
function ForgeRecastUI:GetRecastAttrDesc(itemID, attrData, hideperfect)
    if not (itemID and attrData) then return "" end
    local uiType = attrData.uiType
    local centerDesc = ""
    local ivalue = 0
    -- 如果属性类型是 武学威力 和 武学等级 的话, 则iExtraValue表示武学id
    if (uiType == AttrType.MP_WEILI) or (uiType == AttrType.MP_WUXUEDENGJISHANGXIAN) then
        local martialTypeID = attrData.iExtraValue  --武学静态id
        local martialTypeData = GetTableData("Martial",martialTypeID)
        local martialName = GetLanguageByID(martialTypeData.NameID)
        local attrName = GetEnumText("AttrType", uiType)
        centerDesc = string.format("%s %s", martialName, attrName)
    else
        centerDesc = GetEnumText("AttrType", uiType)
    end
    ivalue = attrData.iBaseValue
    local itemManager = self:GetItemManager()
    local bIsPerfect = itemManager:IsItemAttrPerfect(itemID, attrData)
    --# TODO 钱程 完美前缀应该是全局统一的, 到时候配到语言表里去
    local prefxt = bIsPerfect and "完美·" or ""
    if (hideperfect) then
        prefxt = ""
    end
    local strInfo = ""
    local matDataManager = MartialDataManager:GetInstance()
    local bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(uiType)
    if bIsPerMyriad then
        ivalue = ivalue / 10000
    end
    if bShowAsPercent then
        strInfo = string.format("%s%s+%.1f%%", prefxt, centerDesc, ivalue * 100)
    else
        local fs = bIsPerMyriad and "%s%s+%.1f" or "%s%s+%.0f"
        strInfo = string.format(fs, prefxt, centerDesc, ivalue)
    end
    return strInfo
end

-- 获取某一品质重铸的完美粉消耗
function ForgeRecastUI:GetRecastPerfectPowderCost(iRank)
    local TB_RecastConfig = TableDataManager:GetInstance():GetTable("RecastConfig")
    for _, recastConfig in ipairs(TB_RecastConfig) do
         if recastConfig.Rank == iRank then
            return recastConfig.RecastNeedPerfectPowderCount
         end
    end
    return 99999
end

-- 获取某一品质重铸的精铁消耗
function ForgeRecastUI:GetRecastJingTieCost(itemID)
    local itemData = ItemDataManager:GetInstance():GetItemData(itemID)
    local itemBaseData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
    local itemRank = itemBaseData.Rank
    if itemData == nil then 
        return 99999
    end
    local usedIronCount = itemData.uiRecastIronUsedCount or 0
    
    local needIronCount = 99999
    local perfectNeedUsedIronCount = 99999

    local TB_RecastConfig = TableDataManager:GetInstance():GetTable("RecastConfig")
    for _, recastConfig in ipairs(TB_RecastConfig) do
         if recastConfig.Rank == itemRank then
            needIronCount = recastConfig.RecastNeedIronCount or 0
            perfectNeedUsedIronCount = recastConfig.PerfectIronTotalCount or 0
            break
        end
    end
    if needIronCount == nil then
        return 99999 
    end
    if self.useWmfToRecast then 
        -- 获取物品已经重铸消耗精铁的数量, 返回期望减去已消耗精铁数量
        if usedIronCount > perfectNeedUsedIronCount then
            return 0
        else
            return perfectNeedUsedIronCount - usedIronCount
        end
    else
        return needIronCount
    end
end

--获取某一品质重铸的铜币消耗
function ForgeRecastUI:GetRecastCoinCost(iRank)
    if not iRank then
        return 0
    end

    local TB_RecastConfig = TableDataManager:GetInstance():GetTable("RecastConfig")
    if not self.kRank2CoinCost then
        self.kRank2CoinCost = {}
        for _, data in pairs(TB_RecastConfig) do
            self.kRank2CoinCost[data.Rank] = data.RecastNeedCoinCount or 0
        end
    end
    return self.kRank2CoinCost[iRank] or 0
end

-- 提示弹框
function ForgeRecastUI:WarningBox(title, content, iPaySilverNum, strPayFor, callBack)
    if not content then return end
    local type = GeneralBoxType.COMMON_TIP
    local showContent = content
    local safeCall = callBack
    if iPaySilverNum and strPayFor then
        type = GeneralBoxType.Pay_TIP
        showContent = {
            ['title'] = title,
            ['text'] = content,
            ['btnType'] = "silver",
            ['num'] = iPaySilverNum,
            ['btnText'] = strPayFor
        }
        safeCall = function()
            PlayerSetDataManager:GetInstance():RequestSpendSilver(iPaySilverNum, callBack)
        end
    end
    OpenWindowImmediately('GeneralBoxUI', {type, showContent, safeCall})
end

function ForgeRecastUI:GetNewRecastAttrUI()
    local cur_index = self.recastAttrPool_index
    local next_index = cur_index + 1
    if next_index > self.recastAttrPool_max then
        local obj_clone = CloneObj(self.obj_prop_template, self.obj_content_prop_recast)
        if (obj_clone ~= nil) then
            self.recastAttrPool = self.recastAttrPool or {}
            self.recastAttrPool[#self.recastAttrPool + 1] = obj_clone
            self.recastAttrPool_max = self.recastAttrPool_max + 1
        end

    end
    self.recastAttrPool_index = next_index
    return self.recastAttrPool[next_index]
end

--设置重铸按钮状态 是否显示/ 是否激活/ 是否显示花费/ 按钮显示字符串/ 显示花费数额/ 按下回调
function ForgeRecastUI:SetRecastBtnState(bShow, bActive, bShowCost, sText, iCost, funcOnClick)
    if not self.btn_recast then return end
    bShow = (bShow == true)
    bActive = (bActive == true)
    bShowCost = (bShowCost == true)
    sText = sText or "重铸"
    self.btn_recast:SetActive(bShow)
    local obj_text = self:FindChild(self.btn_recast, "Text") 
    local obj_text_expand = self:FindChild(self.btn_recast, "TextExpand") 
    local text_btn = obj_text:GetComponent(l_DRCSRef_Type.Text)
    local text_btn_expand = obj_text_expand:GetComponent(l_DRCSRef_Type.Text)
    local com_btn = self.btn_recast:GetComponent(l_DRCSRef_Type.Button)
    local obj_cost = self:FindChild(self.btn_recast, "cost")
    local text_cost = self:FindChildComponent(obj_cost, "Number", l_DRCSRef_Type.Text)
    if not(text_btn and com_btn and obj_cost) then return end
    self.recastBtnOnClick = funcOnClick
    obj_text:SetActive(false)
    obj_text_expand:SetActive(false)
    if bShowCost then
        obj_text:SetActive(true)
        text_btn.text = sText
        obj_cost:SetActive(true)
        text_cost.text = iCost or 0
    else
        obj_text_expand:SetActive(true)
        text_btn_expand.text = sText
        obj_cost:SetActive(false)
    end

    com_btn.interactable = bActive
    setUIGray(self.img_btn_recast, not bActive)
end

function ForgeRecastUI:UpdateRecastExp()
    local exp = 0
    local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then 
        exp =  role_info["MainRole"][MRIT_REFORGE_EXP] or 1
    end
    -- 经验换算到等级
    local level = nil
    local curRExpLimit = 0
    local curLExpLimit = 0
    local curRangLen = 0
    local TB_ForgeLevelExp = TableDataManager:GetInstance():GetTable("ForgeLevelExp")
    for lv, limit in ipairs(TB_ForgeLevelExp) do
        curRExpLimit = limit.ReForgeExp or 0
        if exp < curRExpLimit then
            level = lv
            if lv == 1 then
                curRangLen = curRExpLimit
                curLExpLimit = 0
            else
                curLExpLimit = TB_ForgeLevelExp[lv - 1].ReForgeExp or 0
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
    self.comForge_level_TMP.text = string.format("重铸熟练度%d级", level)
end

function ForgeRecastUI:UpdateMatsNum()
    -- 初始化图标
    if not self.matIconUpdated then
        -- 显示用的模板id
        local itemTypeDataWMF = TableDataManager:GetInstance():GetTableData("Item",30941)  -- 完美粉
        local itemTypeDataJT = TableDataManager:GetInstance():GetTableData("Item",30951)  -- 精铁
        local itemTypeDataTGC = TableDataManager:GetInstance():GetTableData("Item",30971)  -- 天工锤
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objWanMeiFenNum, itemTypeDataWMF)
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objJingTieNum, itemTypeDataJT)
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objTianGongChuiNum, itemTypeDataTGC)
        -- 同时初始化信息栏中的按钮
        local obj_jtInfo = self:FindChild(self.obj_jingTieBox, "MaterialInfo_box")
        self.ItemIconUI:UpdateUIWithItemTypeData(self.obj_wmfItemInfo, itemTypeDataWMF)
        self.ItemIconUI:UpdateUIWithItemTypeData(obj_jtInfo, itemTypeDataJT)
        self.ItemIconUI:UpdateUIWithItemTypeData(self.obj_TingGongChuiItem, itemTypeDataTGC)
        -- 标记图标初始化完成
        self.matIconUpdated = true
    end
    -- 获取数量
    local playerData = PlayerSetDataManager:GetInstance()
    local WMFCount = playerData:GetPlayerPerfectPowder() or 0
    local JTCount = playerData:GetPlayerRefinedIron() or 0
    local TGCCount = playerData:GetPlayerHeavenHammer() or 0
    self.comWanMeiFenNum.text = WMFCount
    self.comJingTieNum.text = JTCount
    self.comTianGongChuiNum.text = TGCCount
end

-- 更新重铸左侧列表
function ForgeRecastUI:UpdateRecastItemList()
    local itemManager = self:GetItemManager()
    -- 检查物品是否可重铸
    local checkItemRecastable = function(itemID)
        return itemManager:CanItemBeRecasted(itemID, nil)
    end
    -- 筛选出可重铸的 背包中 装备中 物品
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    local roleItems = itemManager:GetPackageItems(mainRoleID, mainRoleID, true, checkItemRecastable , false)
    -- 丢进 BackpackNewUICom
    if self.BackpackNewUICom:HasItemPicked() then
        self.BackpackNewUICom:ShowRefreshAndResetPackByInstIDArray(roleItems)
    else
        self.BackpackNewUICom:ShowPackByInstIDArray(roleItems, nil, {
            ['funcSort'] = self._inst_parent.instItemSortFunc
        })
    end
    self:UpdateSelectData() -- zyw：是不是后选中比较好
end

-- 重置导航栏
function ForgeRecastUI:ResetNavBar()
    self.BackpackNewUICom:Reset2FirstTap()
end

-- 如果初始化列表时发现有已经记录的选中项, 说明这个物品的属性发生了重铸, 那么选中这个物品，判断并且显示属性改变界面
function ForgeRecastUI:UpdateSelectData()
    if self.recastItem_chose_dynamic then
        local id = self.recastItem_chose_dynamic.uiID
        local recastData = {}
        local itemManager = self:GetItemManager()
        recastData['typeData'] = itemManager:GetItemTypeData(id)
        recastData['instData'] = itemManager:GetItemData(id)
        recastData['uiItemID'] = id
        self:OnClickRecastItem(recastData)
        self:JudgeAndShowAttrChange(recastData)
        -- 如果记录了之前的属性, 那么选中
        if self.curComToggle and self.recastAttr_chose and self.recastItem_chose_static then
            self.curComToggle.isOn = true
            local bNeedCostCoin = self:SetRecastMatInfoShow(true)
            self.obj_warning_recast:SetActive(false)
            local cost = self:GetRecastCoinCost(self.recastItem_chose_static.Rank)
            self:SetRecastBtnState(true, true, bNeedCostCoin, "重铸", cost, function()
                self:RecastAttrOnClick(self.recastAttr_chose)
            end)
        end
    end
end

--判断并显示属性改变界面
function ForgeRecastUI:JudgeAndShowAttrChange(newRecastData)
    if not (newRecastData and self.old_recastItem_data) then return end
    local instData = newRecastData.instData
    local typeData = newRecastData.typeData
    local oldData = self.old_recastItem_data
    if instData.uiID ~= oldData.uiID then return end
    local itemManager = self:GetItemManager()
    local attrData = {}
    local kAttrs = instData.auiAttrData
    if kAttrs and next(kAttrs) then
        local data = nil
        for index = 0, #kAttrs do
            data = kAttrs[index]
            if itemManager:JudgeAttrRankType(data, "green") then
                attrData[#attrData + 1] = data
            end
        end
    end
    local old_desc = ""
    local old_attr_data = nil
    local new_attr_data = nil
    if #attrData > #oldData then
        old_desc = "裂痕"
        new_attr_data = attrData[#attrData]
    elseif #attrData == #oldData then
        for index, data in ipairs(attrData) do
            old_attr_data = oldData[index]
            if (data.uiAttrUID ~= old_attr_data.uiAttrUID)
            or (data.iBaseValue ~= old_attr_data.iBaseValue) then
                old_desc = old_attr_data.desc
                new_attr_data = data
            end
        end
    end
    if (old_desc ~= "") and (new_attr_data ~= nil) then
        local new_desc = self:GetRecastAttrDesc(instData.uiID, new_attr_data)
        local info = {
            ['old_desc'] = old_desc,
            ['new_desc'] = new_desc,
            ['new_attr_data'] = new_attr_data,
            ['inst_item'] = instData,
            ['type_item'] = typeData,
            ['model'] = self.arrtChangeShowModel,
            ['iOldBlueAttrNum'] = oldData.iOldBlueAttrNum,
        }
        self.ForgeAttrChangeUIInst:RefreshUI(info)
    end
    self.old_recastItem_data = nil
end

--使用一条新属性数据来显示属性改变界面
function ForgeRecastUI:ShowAttrChangeWithAttrData(newAttrData)
    if not (newAttrData and self.old_recastItem_data) then return end
    local instData = self.recastItem_chose_dynamic
    local typeData = self.recastItem_chose_static
    local oldData = self.old_recastItem_data
    if instData.uiID ~= oldData.uiID then return end
    local old_desc = ""
    local old_attr_data = nil
    for index, data in ipairs(oldData) do
        if (data.uiAttrUID == newAttrData.uiAttrUID) then
            old_desc = data.desc
            break
        end
    end
    if old_desc ~= "" then
        local new_desc = self:GetRecastAttrDesc(instData.uiID, newAttrData)
        local info = {
            ['old_desc'] = old_desc,
            ['new_desc'] = new_desc,
            ['new_attr_data'] = newAttrData,
            ['inst_item'] = instData,
            ['type_item'] = typeData,
            ['model'] = self.arrtChangeShowModel,
            ['iOldBlueAttrNum'] = oldData.iOldBlueAttrNum,
        }
        self.ForgeAttrChangeUIInst:RefreshUI(info)
        -- 更新重铸熟练度
        self:UpdateRecastExp()
    end
    self.old_recastItem_data = nil
end

--点击一个重铸物品, 右边显示物品相关属性条目
function ForgeRecastUI:OnClickRecastItem(recastData)

    --详细信息显示
    local inst_data = recastData.instData
    local type_data = recastData.typeData
    if not inst_data then
        derror("[ForgeRecastUI:OnClickRecastItem] can't find item inst data by dynamic id: " .. tostring(recastData.uiItemID))
        return
    end
    if not type_data then
        derror("[ForgeRecastUI:OnClickRecastItem] can't find item excel data by dynamic id: " .. tostring(recastData.uiItemID))
        return
    end
    self.recastItem_chose_static = type_data
    self.recastItem_chose_dynamic = inst_data

    self.BackpackNewUICom:PickItemByID(inst_data.uiID, 1, true)

    local itemManager = self:GetItemManager()
    local strItemName = itemManager:GetItemName(inst_data.uiID)
    strItemName = getRankBasedText(type_data.Rank, strItemName)
    self.cur_recastItemName = strItemName
    self.text_itemName_recast.text = strItemName
    local auiAttrData = inst_data.auiAttrData or {}
    self:HideAllChildren(self.obj_content_prop_recast)
    self.recastAttrPool_index = 0
    self.obj_defaultTip_recast:SetActive(false)
    self.objImg_default:SetActive(false)
    self.btn_recast:SetActive(false)
    self.obj_warning_recast:SetActive(true)
    self.obj_sc_info_recast:SetActive(true)
    self.com_RepairCrack.gameObject:SetActive(false)
    self.obj_TianGongChui_Box:SetActive(false)
    self:SetRecastMatInfoShow(false)
    local attrCount = 0
    local attrAddRes = false
    for index, data in pairs(auiAttrData) do
        attrAddRes = self:AddRecastInfoToList(data)
        if attrAddRes ~= false then attrCount = attrCount + 1 end
    end
    --剩余的槽位填为 "裂痕"  NOTICE: 现在没有天宫锤修复裂痕了, 原本的裂痕也需要不显示了
    local countMax = ItemDataManager:GetInstance():CanItemRank2MaxAttrCount(type_data.Rank)
    self:AddRecastCrackToList(countMax - attrCount,recastData.uiItemID)
end

-- 点击重铸按钮
function ForgeRecastUI:RecastAttrOnClick(attrData)
    if not (self.recastItem_chose_dynamic and self.recastItem_chose_static and attrData) then return end
    local instData = self.recastItem_chose_dynamic
    local typeData = self.recastItem_chose_static
    local uiID = instData.uiID
    if not uiID then return end

    local sendForgeFunc = function()
        if not IsModuleEnable(SM_ITEM_RECAST) then 
            ShowSystemModuleDisableTip(SM_ITEM_RECAST)
            return
        end
        --属性变化显示模式
        self.arrtChangeShowModel = "recast"
        --记录一下旧的物品属性数据
        self:RecordOldRecastItemData()
        local useWmf = self.useWmfToRecast and 1 or 0
        LimitShopManager:GetInstance():AddCheckData(LimitShopType.eForge)
        SendClickItemReforgeCMD(uiID, attrData.uiAttrUID, useWmf)
        -- 物品只要重铸过, 就自动锁定
        ItemDataManager:GetInstance():SetItemLockState(uiID, true)
    end

    -- 检查完美粉数量
    local iTransWmfSinglePrice = TableDataManager:GetInstance():GetTableData("CommonConfig",1).Wmf2SilverPrice or 0  -- 转换完美粉的单价
    local iWMFLack = 0
    if self.useWmfToRecast == true then
        iWMFLack = (self.iWmfNeed or 0) - (self.iWmfHave or 0)
        if iWMFLack < 0 then
            iWMFLack = 0
        end
    end
    local iTransWmfPaySilverNum = iTransWmfSinglePrice * iWMFLack  -- 转换完美粉锁需要的银锭

    -- 如果是精铁重铸
    if self.recast_with_jt == true then
        -- 精铁或者完美粉不足的情况
        if (self.jt_enough ~= true) or (iTransWmfPaySilverNum > 0) then
            local iSumSilverNum = iTransWmfPaySilverNum
            local iTransIronSinglePrice = TableDataManager:GetInstance():GetTableData("CommonConfig",1).Iron2SilverPrice or 0  -- 转换精铁的单价
            if self.jt_enough ~= true then
                local iTransIronPaySilverNum = iTransIronSinglePrice * (self.jt_need2Trans or 0)  -- 转换精铁需要的银锭
                iSumSilverNum = iSumSilverNum + iTransIronPaySilverNum
            end
            if ((self.jt_enough ~= true) and (self.bSilverTans2IronWarn ~= false)) 
            or ((iTransWmfPaySilverNum > 0) and (self.bSilverTrans2WmfWarn ~= false)) then
                local strTitle = "精铁或完美粉不足"
                local strWarning = "精铁或完美粉数量不足，继续重铸将以每个精铁%d银锭，每个完美粉%d银锭的价格消耗银锭（本次重铸不再提示）"
                local strPayFor = "继续重铸"
                local callback = function()
                    sendForgeFunc()
                    if self.jt_enough ~= true then
                        self.bSilverTans2IronWarn = false
                    end
                    if iTransWmfPaySilverNum > 0 then
                        self.bSilverTrans2WmfWarn = false
                    end
                end
                self:WarningBox(strTitle, string.format(strWarning, iTransIronSinglePrice, iTransWmfSinglePrice), iSumSilverNum, strPayFor, callback)
            else
                PlayerSetDataManager:GetInstance():RequestSpendSilver(iSumSilverNum, sendForgeFunc)
            end
        else
            -- 银锭与完美粉充足的时候直接重铸
            sendForgeFunc()
        end
        return
    end

    -- 铜币重铸
    -- 检查铜币数量
    local coinCost = self:GetRecastCoinCost(typeData.Rank) or 0
    local coinHave  = 0
    local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        coinHave = role_info["MainRole"][MRIT_CURCOIN] or 0
    end
    local bCoinLack = coinCost > coinHave 
    local iTransCoinPaySilverNum = math.ceil(coinCost / 100)
    -- 检查是否需要显示消费提示
    if bCoinLack or (iTransWmfPaySilverNum > 0) then
        local iPaySilverSumNum = iTransCoinPaySilverNum + iTransWmfPaySilverNum
        if (bCoinLack and (self.bSilverTrans2CoinWarn ~= false)) 
        or ((iTransWmfPaySilverNum > 0) and (self.bSilverTrans2WmfWarn ~= false)) then
            local strTitle = "铜币或完美粉不足"
            local strWarning = ""
            if bCoinLack then
                strWarning = string.format("本次重铸需要消耗%d铜币, 铜币数量不足, 是否使用%d银锭代替铜币进行重铸?\n", coinCost, iTransCoinPaySilverNum)
            end
            if iTransWmfPaySilverNum > 0 then
                strWarning = strWarning .. string.format("您选择了使用完美粉重铸, 完美粉不足, 将以每个完美粉%d银锭的价格消耗银锭\n", iTransWmfSinglePrice)
            end
            strWarning = strWarning .. "(本次重铸不再提示)"
            local strPayFor = "重铸"
            local callback = function()
                sendForgeFunc()
                if bCoinLack then
                    self.bSilverTrans2CoinWarn = false
                end
                if iTransWmfPaySilverNum > 0 then
                    self.bSilverTrans2WmfWarn = false
                end
            end
            self:WarningBox(strTitle, strWarning, iPaySilverSumNum, strPayFor, callback)
        else
            -- 这里是铜币重铸但是不需要任何提示
            PlayerSetDataManager:GetInstance():RequestSpendSilver(iPaySilverSumNum, sendForgeFunc)
        end
    else
        sendForgeFunc()
    end
end

--记录旧数据
function ForgeRecastUI:RecordOldRecastItemData()
    local dynamicItemData = self.recastItem_chose_dynamic
    local staticItemData = self.recastItem_chose_static
    if not (dynamicItemData and staticItemData) then return end
    local itemManager = self:GetItemManager()
    local genData = {}
    genData['uiID'] = dynamicItemData.uiID
    local iBlueAttrNum = 0
    local kAttrs = dynamicItemData.auiAttrData
    if kAttrs and next(kAttrs) then
        local data = nil
        for index =  0, #kAttrs do
            data = kAttrs[index]
            if itemManager:JudgeAttrRankType(data, "green") then
                genData[#genData + 1] = {
                    ['uiAttrUID'] = data.uiAttrUID,
                    ['iBaseValue'] = data.iBaseValue,
                    ['desc'] = self:GetRecastAttrDesc(dynamicItemData.uiID, data)
                }
            elseif itemManager:JudgeAttrRankType(data, "blue") then
                iBlueAttrNum = iBlueAttrNum + 1
            end
        end
    end
    -- 记录一下重铸前蓝字的条数
    genData['iOldBlueAttrNum'] = iBlueAttrNum
    self.old_recastItem_data = genData
end

-- 将一条属性 条目添加到列表
function ForgeRecastUI:AddRecastInfoToList(attrData)
    if attrData.uiRecastType <= 0 or attrData.uiRecastType >= 3 then
         return false 
    end
    local strInfo = self:GetRecastAttrDesc(self.recastItem_chose_dynamic.uiID, attrData)
    local obj_clone = self:GetNewRecastAttrUI()
    obj_clone:SetActive(true)
    local text_obj_clone = self:FindChildComponent(obj_clone, "Text_name", l_DRCSRef_Type.Text)
    local com_toggle_clone = obj_clone:GetComponent(l_DRCSRef_Type.Toggle)
    com_toggle_clone.interactable = true
    if text_obj_clone and com_toggle_clone then
        text_obj_clone.text = strInfo
        local fun = function(bOn)
            bOn = (bOn == true)
            text_obj_clone.color = bOn and self.color_attrOnPick or self.color_attrUnPick
            if bOn then
                self.curComToggle = com_toggle_clone
                self.recastAttr_chose = attrData
            end
            self.com_RepairCrack.gameObject:SetActive(false)
            local bNeedCostCoin = self:SetRecastMatInfoShow(bOn, false)
            self.obj_warning_recast:SetActive(not bOn)
            -- 设置按钮状态
            local cost = self:GetRecastCoinCost(self.recastItem_chose_static.Rank)
            self:SetRecastBtnState(bOn, true, bNeedCostCoin, "重铸", cost, function()
                self:RecastAttrOnClick(attrData)
            end)
        end
        self:RemoveToggleClickListener(com_toggle_clone)
        com_toggle_clone.group = nil
        com_toggle_clone.isOn = false
        text_obj_clone.color = self.color_attrUnPick
        self:SetRecastMatInfoShow(false)
        self:AddToggleClickListener(com_toggle_clone, fun)
        com_toggle_clone.group = self.toggleGroup_content_prop_recast
    end
end

--将裂痕添加到列表
function ForgeRecastUI:AddRecastCrackToList(iCount,uiItemID)
    if (not iCount) or (iCount <= 0) then return end
    local obj_clone = nil
    local com_toggle_clone = nil
    
    self:SetRecastMatInfoShow(false)
    for int_i = 1, iCount do
        obj_clone = self:GetNewRecastAttrUI()
        obj_clone:SetActive(true)
        local text_obj_clone = self:FindChildComponent(obj_clone, "Text_name", l_DRCSRef_Type.Text)
        text_obj_clone.text = "裂痕"
        text_obj_clone.color = self.color_attrUnPick
        com_toggle_clone = obj_clone:GetComponent(l_DRCSRef_Type.Toggle)
        com_toggle_clone.group = nil
        com_toggle_clone.isOn = false
        com_toggle_clone.interactable = true
        com_toggle_clone.group = self.toggleGroup_content_prop_recast

        self:RemoveToggleClickListener(com_toggle_clone)
        com_toggle_clone.onValueChanged:RemoveAllListeners()
        self:AddToggleClickListener(com_toggle_clone, function(bOn)      
            if bOn then
                local iHave = PlayerSetDataManager:GetInstance():GetPlayerHeavenHammer() or 0
                self.com_TianGongChui.text = string.format("(%d/1)",iHave)
                self.com_TianGongChui.color = iHave > 0 and self.color_ok or self.color_no
                
                self.obj_TianGongChui_Box:SetActive(true)
                self.obj_warning_recast:SetActive(false)

                -- 设置按钮状态
                --local cost = self:GetRecastCoinCost(self.recastItem_chose_static.Rank)
                self:SetRecastBtnState(false)
                self.uiChooseItemID = uiItemID

                if not self.grayMat then
                    self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
                end
                if iHave < 1 then
                    self.com_RepairCrack.interactable = false
                    self.com_RepairCrackImg.material = self.grayMat
                else
                    self.com_RepairCrack.interactable = true
                    self.com_RepairCrackImg.material = nil
                end
                self.com_RepairCrack.gameObject:SetActive(true)
            end
            text_obj_clone.color = bOn and self.color_attrOnPick or self.color_attrUnPick
        end)
        com_toggle_clone.group = self.toggleGroup_content_prop_recast
    end
end

-- 更新精铁数量信息
function ForgeRecastUI:UpdateJTNumInfo()
    local inst_item = self.recastItem_chose_dynamic
    if not inst_item then 
        return 
    end
    local iHave = PlayerSetDataManager:GetInstance():GetPlayerRefinedIron() or 0
    local iNeed = self:GetRecastJingTieCost(inst_item.uiID)  --精铁消耗
    local obj_jtInfo = self:FindChild(self.obj_jingTieBox, "MaterialInfo_box")
    local text_jt = self:FindChildComponent(obj_jtInfo, "Text_num", l_DRCSRef_Type.Text)
    text_jt.text = string.format("%d/%d", iHave, iNeed)
    self.jt_enough = (iHave >= iNeed)
    self.jt_need2Trans = iNeed - iHave 
    text_jt.color = self.jt_enough and self.color_ok or self.color_no
end

-- 切换条目下方信息的显示
function ForgeRecastUI:SetRecastMatInfoShow(bShow)
    local type_item = self.recastItem_chose_static
    local inst_item = self.recastItem_chose_dynamic
    if not (type_item and inst_item) then return end
    --去除nil值
    bShow = (bShow == true)
    --初始化ui状态 与 数据
    self.uiChooseItemID = nil
    self.obj_coinBox:SetActive(false) 
    self.obj_jingTieBox:SetActive(false)
    self.obj_wanMeiFenBox:SetActive(false)
    self.obj_TianGongChui_Box:SetActive(false)
    if not bShow then return end
    local item_mgr = self:GetItemManager()
    local iHave = 0
    local iNeed = 0
    local playerData = PlayerSetDataManager:GetInstance()
    local bNeedCostCoin = false  -- 是否需要花费铜币
    local count = inst_item.uiCoinRemainRecastTimes or 0
    if count > 0 then  -- 如果可以用铜币重铸
        -- self.recast_with_jt = false
        -- local text_count = self:FindChildComponent(self.obj_coinBox, "Text_num", l_DRCSRef_Type.Text)
        -- --设置铜币重铸次数
        -- text_count.text = string.format("%d", count)
        -- self.obj_coinBox:SetActive(true)
        -- bNeedCostCoin = true
    else  -- 否则, 需要材料 精铁
        self.obj_jingTieBox:SetActive(true)
        self.recast_with_jt = true
        --设置必须材料 精铁数量
        self:UpdateJTNumInfo()
    end
    --完美粉是任何时候都要显示的
    self.obj_wanMeiFenBox:SetActive(false)
    self.obj_toggle_wmf_choosen:SetActive(true)
    --设置添加材料 完美粉
    local config = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    self.iWmfHave = playerData:GetPlayerPerfectPowder() or 0
    self.iWmfNeed = self:GetRecastPerfectPowderCost(type_item.Rank) or 0
    self.text_wmfNum.text = string.format("%d/%d", self.iWmfHave, self.iWmfNeed)
    self.text_wmfNum.color = (self.iWmfNeed <= self.iWmfHave) and self.color_ok or self.color_no
    -- 是否使用完美粉的默认值
    self.useWmfToRecast = self.toggle_wmf_choosen.isOn

    return bNeedCostCoin
end

-- 点击是否使用完美粉的toggle
function ForgeRecastUI:OnClickToggleUseWMF(bOn)
    bOn = (bOn == true)
    self.text_wmf_choosen.text = bOn and "<color=#688A2D>使用</color>" or "不使用"
    self.useWmfToRecast = bOn
    -- 完美粉影响需要的精铁数量
    self:UpdateJTNumInfo()
end

-- 获取今日银锭重铸次数
function ForgeRecastUI:GetSilverUpdateTimes()
    local usedTimes  = 0
    local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        usedTimes = role_info["MainRole"][MRIT_REFORGE_DAYCOUNT] or 0
    end
    return usedTimes
end

function ForgeRecastUI:OnEnable()
    -- 重置 "本次重铸不再提示的标记"
    self.bSilverTrans2CoinWarn = true  -- 银锭转铜币提示
    self.bSilverTans2IronWarn = true  -- 银锭转精铁提示
end

function ForgeRecastUI:OnDestroy()
    -- 清空一些按钮的监听
    local btnToClear = nil
    btnToClear = self.objWanMeiFenNum:GetComponent(l_DRCSRef_Type.Button)
    self.ItemIconUI:RemoveButtonClickListener(btnToClear)
    btnToClear = self.objJingTieNum:GetComponent(l_DRCSRef_Type.Button)
    self.ItemIconUI:RemoveButtonClickListener(btnToClear)
    btnToClear = self.objTianGongChuiNum:GetComponent(l_DRCSRef_Type.Button)
    self.ItemIconUI:RemoveButtonClickListener(btnToClear)
    -- 关闭组件
    self.ItemIconUI:Close()
    self.ForgeAttrChangeUIInst:Close()
    self.BackpackNewUICom:Close()
end


return ForgeRecastUI