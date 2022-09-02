ForgeAttrChangeUI = class("ForgeAttrChangeUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function ForgeAttrChangeUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
end

function ForgeAttrChangeUI:Init(objParent, recastUI)
    --初始化
    if not (objParent and recastUI) then return end
    self.RecastUI = recastUI
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "attr_change_box")
	if obj then
		self:SetGameObject(obj)
    end

    -- 熟练度
    self.forge_level_top = self:FindChild(self._gameObject_parent, "forge_level_top")
    self.comForge_level_TMP = self:FindChildComponent(self.forge_level_top, "TMP_forge",l_DRCSRef_Type.Text)  -- XX熟练度   X级
    self.comScrollbar_exp = self:FindChildComponent(self.forge_level_top,"Scrollbar_exp",l_DRCSRef_Type.Scrollbar)
    self.comExp_TMP = self:FindChildComponent(self.forge_level_top, "TMP_exp",l_DRCSRef_Type.Text)    -- 经验值

    self._gameObject:SetActive(false)
    self.text_itemName_attrChange = self:FindChildComponent(self._gameObject, "newFrame/Title", l_DRCSRef_Type.Text)
    self.obj_sc_attrChage = self:FindChild(self._gameObject, "SC_attr_change")
    self.obj_content_attrChange = self:FindChild(self.obj_sc_attrChage, "Viewport/Content")
    self.rectTransContentAttrChange = self.obj_content_attrChange:GetComponent(l_DRCSRef_Type.RectTransform)
    self.obj_attrChangeBox = self:FindChild(self.obj_content_attrChange, "AttrChange_box")
    self.obj_old_attr = self:FindChild(self.obj_attrChangeBox, "EquipAttrListUI_old")
    self.obj_new_attr = self:FindChild(self.obj_attrChangeBox, "EquipAttrListUI_new")
    self.text_old_attr = self:FindChildComponent(self.obj_old_attr, "Text_name", l_DRCSRef_Type.Text)
    self.text_new_attr = self:FindChildComponent(self.obj_new_attr, "Text_name", l_DRCSRef_Type.Text)
    self.obj_coinBox_attrChange = self:FindChild(self.obj_attrChangeBox, "TongBi_box")
    self.text_coinBoxNum_attrChange = self:FindChildComponent(self.obj_coinBox_attrChange, "Text_num", l_DRCSRef_Type.Text)

    self.objAttrSaveBox = self:FindChild(self._gameObject, "AttrSaveBox")
    self.textAttrSaveBox = self:FindChildComponent(self.objAttrSaveBox, "Content", l_DRCSRef_Type.Text)
    self.text_blueAttrFugai1 = self:FindChildComponent(self.objAttrSaveBox, "ability1", l_DRCSRef_Type.Text)
    self.text_blueAttrFugai2 = self:FindChildComponent(self.objAttrSaveBox, "ability2", l_DRCSRef_Type.Text)
    self.toggle_blueAttrFugai1 = self:FindChildComponent(self.objAttrSaveBox, "Toggle/ability1", l_DRCSRef_Type.Toggle)
    self.toggle_blueAttrFugai2 = self:FindChildComponent(self.objAttrSaveBox, "Toggle/ability2", l_DRCSRef_Type.Toggle)
    local btnGiveUpCover = self:FindChildComponent(self.objAttrSaveBox, "Button/Keep", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnGiveUpCover, function()
        self:GiveUpCoverBlueAttr()
    end)
    local btnConfirmCover = self:FindChildComponent(self.objAttrSaveBox, "Button/Cover", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnConfirmCover, function()
        self:DoCoverBlueAttr()
    end)
    self.obj_btnGroup = self:FindChild(self._gameObject, "Group_button")

    self.obj_jingTieBox_attrChange = self:FindChild(self.obj_attrChangeBox, "JingTie_box")
    self.obj_jtMatBox_attrChange = self:FindChild(self.obj_jingTieBox_attrChange, "MaterialInfo_box")
    self.text_jtMatBox_attrChange = self:FindChildComponent(self.obj_jtMatBox_attrChange, "Text_num", l_DRCSRef_Type.Text)
    -- 更新图标
    self.obj_jtMatBoxIcon_attrChange = self:FindChild(self.obj_jingTieBox_attrChange, "ItemIconUI")
    local JTTypeID = 30951  -- 精铁
    local JTItemTypeData = TableDataManager:GetInstance():GetTableData("Item",JTTypeID)
    self.ItemIconUI:UpdateUIWithItemTypeData(self.obj_jtMatBoxIcon_attrChange, JTItemTypeData)
    
    self.obj_WMFBox = self:FindChild(self.obj_attrChangeBox, "WanMeiFen_box")
    self.obj_WMFMatBox = self:FindChild(self.obj_jingTieBox_attrChange, "MaterialInfo_box2")
    self.text_wmfNum = self:FindChildComponent(self.obj_WMFMatBox, "Text_num", l_DRCSRef_Type.Text)
    self.obj_text_choosen = self:FindChild(self.obj_WMFMatBox, "Text_choosen")
    self.text_choosen = self.obj_text_choosen:GetComponent(l_DRCSRef_Type.Text)
    self.obj_text_choosen:SetActive(false)
    self.obj_toggle_choosen = self:FindChild(self.obj_WMFMatBox, "Toggle_choosen")
    self.toggle_choosen = self.obj_toggle_choosen:GetComponent(l_DRCSRef_Type.Toggle)
    self:AddToggleClickListener(self.toggle_choosen, function(bOn)
        bOn = (bOn == true)
        self.text_choosen.text = ""
        self.RecastUI.toggle_wmf_choosen.isOn = bOn
        self.RecastUI.useWmfToRecast = bOn
        -- 完美粉影响需要的精铁数量
        self:UpdateJTBox()
    end)
    -- 更新图标
    self.obj_WMFMatBoxIcon = self:FindChild(self.obj_WMFMatBox, "ItemIconUI")
    local WMFTypeID = 30941  -- 完美粉
    local WMFItemTypeData = TableDataManager:GetInstance():GetTableData("Item",WMFTypeID)
    self.ItemIconUI:UpdateUIWithItemTypeData(self.obj_WMFMatBoxIcon, WMFItemTypeData)
    
    self.obj_btn_green_false = self:FindChild(self.obj_btnGroup, "Button_green_false")
    local com_btn_green_false = self.obj_btn_green_false:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(com_btn_green_false, function()
        local closeUIfun = function()
            self:CloseUI(true)
        end
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '您确定要放弃吗?',closeUIfun })
    end)

    self.obj_btn_green_true = self:FindChild(self.obj_btnGroup, "Button_green_true")
    local com_btn_green_true = self.obj_btn_green_true:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(com_btn_green_true, function()
        self:SavaAttr()
    end)

    self.obj_btn_buy_go = self:FindChild(self.obj_btnGroup, "Button_buy_go")
    local com_btn_buy_go = self.obj_btn_buy_go:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(com_btn_buy_go, function()
        self:RecastOnClick()
    end)

    self.obj_btn_green_go = self:FindChild(self.obj_btnGroup, "Button_green_go")
    local com_btn_green_go = self.obj_btn_green_go:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(com_btn_green_go, function()
        self:RecastOnClick()
    end)

    self.obj_btn_green = self:FindChild(self._gameObject, "Button_green")
    local com_btn_green = self.obj_btn_green:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(com_btn_green, function()
        self:CloseUI(true)
    end)
	self.comCloseButton = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.comCloseButton, function()
        self:CloseUI(true)
    end)
    --其它值
    self.color_no = UI_COLOR.red
    self.color_ok = UI_COLOR.green
end

function ForgeAttrChangeUI:RefreshUI(info)
    if not (info and info.inst_item) then return end
    local old_desc = info.old_desc
    local new_desc = info.new_desc
    -- 重新查询物品动态数据
    local inst_item = ItemDataManager:GetInstance():GetItemData(info.inst_item.uiID)
    local type_item = info.type_item
    local new_attr_data = info.new_attr_data
    if not (old_desc and new_desc and new_attr_data and inst_item and type_item) then return end
    --数据记录
    self.inst_item = inst_item
    self.type_item = type_item
    self.cur_attr_data = new_attr_data
    self.uiItemID = inst_item.uiID
    self.uiAttrID = new_attr_data.uiAttrUID

    --ui初始化
    local strItemName = ItemDataManager:GetInstance():GetItemName(inst_item.uiID)
    strItemName = getRankBasedText(type_item.Rank, strItemName)
    --self.text_itemName_attrChange.text = strItemName or ""
    local vecPos = self.obj_content_attrChange.transform.localPosition
    self.obj_content_attrChange.transform.localPosition = DRCSRef.Vec3(vecPos.x, 0, vecPos.z)
    self.text_old_attr.text = old_desc
    self.text_new_attr.text = new_desc

    self.obj_jingTieBox_attrChange:SetActive(false)
    self.obj_btnGroup:SetActive(false)
    self.obj_btn_buy_go:SetActive(false)
    self.obj_btn_green_go:SetActive(false)
    self.obj_btn_green:SetActive(false)
    self.obj_coinBox_attrChange:SetActive(false)

    -- 获取显示模式
    local show_model = info.model or "crack"
    if show_model == "crack" then
        self.obj_btn_green:SetActive(true)
    else
        local count = inst_item.uiCoinRemainRecastTimes or 0
        if count > 0 then  -- 如果可以用铜币重铸
            -- self.RecastUI.recast_with_jt = false
            -- self.obj_coinBox_attrChange:SetActive(true)
            -- self.text_coinBoxNum_attrChange.text = string.format("%d", count)
            -- --设置铜币花费数
            -- local text_btn = self:FindChildComponent(self.obj_btn_buy_go, "Number", l_DRCSRef_Type.Text)
            -- text_btn.text = self.RecastUI:GetRecastCoinCost(type_item.Rank)
            -- self.obj_btn_buy_go:SetActive(true)
        else
            self.RecastUI.recast_with_jt = true
            self.obj_jingTieBox_attrChange:SetActive(true)
            self.obj_btn_green_go:SetActive(true)
            --设置精铁数量
            self:UpdateJTBox()
        end
        -- 刷新完美粉数量显示
        self:UpdateWMFBox()
        -- 白字永久提升
        local enhanceWhiteAttr = new_attr_data.uiEnhanceWhiteAttrTypeID
        if enhanceWhiteAttr and (enhanceWhiteAttr > 0) then
            local whiteAttrName = GetEnumText("AttrType", enhanceWhiteAttr)
            local msg = string.format("重铸完美后，白字属性永久提升%s+1", whiteAttrName)
            SystemUICall:GetInstance():Toast(msg, true)
        end
        -- 显示出现了稀有蓝字属性
        local uiBlueAttrTypeID = new_attr_data.uiBlueAttrTypeID
        local iBlueBaseValue = new_attr_data.iBlueBaseValue
        if uiBlueAttrTypeID and (uiBlueAttrTypeID > 0)
        and iBlueBaseValue and (iBlueBaseValue > 0) then
            -- 取蓝字属性数量
            local iOldBlueAttrNum = info.iOldBlueAttrNum or 0
            local blueAttrNums, blueAttrs = self:GetBlueAttrNums(inst_item.auiAttrData)
            blueAttrNums = blueAttrNums or 0
            -- 显示蓝字提示框
            local msg = ""
            if iOldBlueAttrNum <= 0 then
                msg = string.format("恭喜, 出现稀有的蓝字属性")
            elseif (iOldBlueAttrNum <= 1) and (blueAttrNums == 2) then
                msg = string.format("恭喜, 出现第二条稀有的蓝字属性(两条可同时存在)")
            elseif iOldBlueAttrNum >= 2 then
                msg = string.format("恭喜, 出现第三条稀有的蓝字属性\n请选择覆盖一条, 或者保留原有的两条")
            end
            msg = msg .. "\n" .. self:GetBlueAttrDesc(uiBlueAttrTypeID, iBlueBaseValue)
            if iOldBlueAttrNum < 2 then
                -- 当出现第一/第二条蓝字的时候只简单弹出一个提示框告知用户
                local content = {
                    ['title'] = "蓝字属性",
                    ['text'] = msg,
                }
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, nil, {["confirm"] = true}})
                self.objAttrSaveBox:SetActive(false)
            else
                -- 出现第三条稀有蓝字属性的时候, 弹出属性替换框
                self.textAttrSaveBox.text = msg
                self.GiveUpBlueAttr = {}
                for index, attrData in ipairs(blueAttrs or {}) do
                    local desc = self:GetBlueAttrDesc(attrData.uiType, attrData.iBaseValue)
                    if (index == 1) then
                        self.text_blueAttrFugai1.text = desc
                    elseif (index == 2) then
                        self.text_blueAttrFugai2.text = desc
                    end
                    self.GiveUpBlueAttr[index] = {["Desc"] = desc,["AttrID"] = attrData.uiAttrUID}
                end
                self.objAttrSaveBox:SetActive(true)
            end
        end
        self.obj_btnGroup:SetActive(true)
    end
    -- 强刷一遍自适应高度
    DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransContentAttrChange)

    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetSecondConfirm("您确定要放弃吗?")
    end

    self._gameObject:SetActive(true)
end

-- 刷新精铁数量的显示
function ForgeAttrChangeUI:UpdateJTBox()
    if not self.uiItemID then 
        return 
    end
    local iHave = PlayerSetDataManager:GetInstance():GetPlayerRefinedIron() or 0
    local iNeed = self.RecastUI:GetRecastJingTieCost(self.uiItemID)  --精铁消耗
    self.RecastUI.jt_need2Trans = iNeed - iHave
    self.RecastUI.jt_enough = (iHave >= iNeed)
    self.text_jtMatBox_attrChange.text = string.format("%d/%d", iHave, iNeed)
    self.text_jtMatBox_attrChange.color = self.RecastUI.jt_enough and self.color_ok or self.color_no
end

-- 刷新完美粉数量的显示
function ForgeAttrChangeUI:UpdateWMFBox()
    local type_item = self.type_item
    if not type_item then return end
    local playerData = PlayerSetDataManager:GetInstance()
    local iHave = playerData:GetPlayerPerfectPowder() or 0
    local iNeed = self.RecastUI:GetRecastPerfectPowderCost(type_item.Rank) or 0
    -- if iHave < iNeed then
    --     self.RecastUI.useWmfToRecast = false
    -- end
    --设置添加材料 完美粉
    self.text_wmfNum.text = string.format("%d/%d", iHave, iNeed)
    self.text_wmfNum.color = (iHave >= iNeed) and self.color_ok or self.color_no
    self.toggle_choosen.isOn = (self.RecastUI.useWmfToRecast == true)
end

-- 点击重铸
function ForgeAttrChangeUI:RecastOnClick()
    if not self.cur_attr_data then return end
    self.RecastUI:RecastAttrOnClick(self.cur_attr_data)
end

-- 关闭属性展示界面
function ForgeAttrChangeUI:CloseUI(bUpdateRecastUI)
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:ClearSecondConfirm()
    end
    if (bUpdateRecastUI == true) and (self.RecastUI ~= nil) then
        self.RecastUI:UpdateSelectData()
        self.RecastUI:UpdateMatsNum()
    end
    self.iOldBlueAttrNum = nil
    self.iBlueAttrNum= nil
    self._gameObject:SetActive(false)
end

-- 保留重铸属性
function ForgeAttrChangeUI:SavaAttr()
    if not (self.uiItemID and self.uiAttrID ~= nil) then return end
    SendClickItemReforgeSaveCMD(self.uiItemID, self.uiAttrID, 1000, false)
    self:CloseUI()
end

-- 覆盖蓝色属性
function ForgeAttrChangeUI:DoCoverBlueAttr()
    if not (self.GiveUpBlueAttr and self.uiItemID and self.uiAttrID ~= nil and self.cur_attr_data) then
        return
    end
    local uiBlueAttrTypeID = self.cur_attr_data.uiBlueAttrTypeID
    local iBlueBaseValue = self.cur_attr_data.iBlueBaseValue
    if not (uiBlueAttrTypeID and (uiBlueAttrTypeID > 0) and iBlueBaseValue and (iBlueBaseValue > 0)) then
        return
    end

    local uiGiveupAttr = nil
    local desc = ""
    if (self.toggle_blueAttrFugai1.isOn == true) then
        uiGiveupAttr = self.GiveUpBlueAttr[1]["AttrID"]
        desc = self.GiveUpBlueAttr[1]["Desc"]
    elseif (self.toggle_blueAttrFugai2.isOn == true) then
        uiGiveupAttr = self.GiveUpBlueAttr[2]["AttrID"]
        desc = self.GiveUpBlueAttr[2]["Desc"]
    end

    if (uiGiveupAttr == nil) then
        SystemUICall:GetInstance():Toast("请先选择要覆盖的蓝字属性")
        return
    end
    local callBack = function()
        SendClickItemReforgeSaveCMD(self.uiItemID, self.uiAttrID, uiGiveupAttr, true)
        self.objAttrSaveBox:SetActive(false)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, string.format('您确定要替换蓝字属性 %s 吗?',desc), callBack})
end

-- 放弃覆盖蓝色属性
function ForgeAttrChangeUI:GiveUpCoverBlueAttr()
    self.objAttrSaveBox:SetActive(false)
end

function ForgeAttrChangeUI:GetBlueAttrNums(attrInst)
    if (attrInst == nil) then
        return 0
    end

    local nums = 0
    local attrs = {}
    for k,v in pairs(attrInst) do
        if v.uiRecastType == 3 then
            nums = nums + 1
            attrs[#attrs + 1] = v
        end
    end

    return nums, attrs
end

function ForgeAttrChangeUI:OnDestroy()
    local comButton = self.obj_jtMatBoxIcon_attrChange:GetComponent(l_DRCSRef_Type.Button)
    if comButton then 
        self:RemoveButtonClickListener(comButton)
    end
    self.ItemIconUI:Close()
end

function ForgeAttrChangeUI:GetBlueAttrDesc(type,value)
    local attrName = GetEnumText("AttrType", type)
    if (not attrName) then
        return ""
    end

    return string.format("<color=#3375B0>本装备上铸造属性\"%s\"属性效果提升%d%%</color>", attrName, value or 0)
end

return ForgeAttrChangeUI