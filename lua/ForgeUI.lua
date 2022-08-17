ForgeUI = class("ForgeUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type

local ForgeMakeUI = require 'UI/Forge/ForgeMakeUI'
local ForgeRecastUI = require 'UI/Forge/ForgeRecastUI'
local ForgeStrengthenUI = require 'UI/Forge/ForgeStrengthenUI'
local ForgeSmeltUI = require 'UI/Forge/ForgeSmeltUI'

local SubViewTipsID = {
    ['make_box'] = 550,
    ['strengthen_box'] = 551,
    ['recast_box'] = 552,
    ['smelt_box'] = 553,
}

ForgeUI.classToType_recast = {
    {
        ['text'] = "全部",
        ['types'] = {
            ItemTypeDetail.ItemType_Equipment,
        }
    },
    {
        ['text'] = "武器",
        ['types'] = {
            ItemTypeDetail.ItemType_WeaponEquip,
        }
    },
    {
        ['text'] = "衣服",
        ['types'] = {
            ItemTypeDetail.ItemType_Clothes,
        }
    },
    {
        ['text'] = "鞋子",
        ['types'] = {
            ItemTypeDetail.ItemType_Shoe,
        }
    },
    {
        ['text'] = "饰品",
        ['types'] = {
            ItemTypeDetail.ItemType_Ornaments,
        }
    },
    {
        ['text'] = "神器",
        ['types'] = {
            ItemTypeDetail.ItemType_Artifact,
        }
    }
}

function ForgeUI:ctor()
    self.ForgeMakeUIInst = ForgeMakeUI.new()
    self.ForgeRecastUIInst = ForgeRecastUI.new()
    self.ForgeStrengthenUIInst = ForgeStrengthenUI.new()
    self.ForgeSmeltUIInst = ForgeSmeltUI.new()
end


function ForgeUI:OnPressESCKey()
    local objAttrChange = self:FindChild(self._gameObject, "attr_change_box")
    if objAttrChange.activeSelf then
        self.ForgeRecastUIInst.ForgeAttrChangeUIInst.comCloseButton.onClick:Invoke()
        return
    end
    if self.comCloseButton then
        self.comCloseButton.onClick:Invoke()
    end
end

function ForgeUI:Create()
	local obj = LoadPrefabAndInit("ForgeUI/ForgeUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
    --
    self.comCloseButton = self:FindChildComponent(self._gameObject, "frame/Btn_exit", "Button")
    if self.comCloseButton then
        self:AddButtonClickListener(self.comCloseButton, function ()
            self:OnClick_Return_Button()
            RemoveWindowImmediately("ForgeUI")
        end)
    end
    -- tab栏
    self.objTab_box = self:FindChild(self._gameObject, "ForgeWindowTabUI/TransformAdapt_node_right/Tab_box")
    self.objToggle_Make = self:FindChild(self.objTab_box, "Toggle_zhizao")
    self.objToggle_Recast = self:FindChild(self.objTab_box, "Toggle_chongzhu")
    self.objToggle_Strengthen = self:FindChild(self.objTab_box, "Toggle_qianghua")
    self.objToggle_Smelt = self:FindChild(self.objTab_box, "Toggle_ronglian")

    --子页面集合
    local obj_make_ui = self:FindChild(self._gameObject, "make_box")
    local obj_recast_ui = self:FindChild(self._gameObject, "recast_box")
    local obj_strengthen_ui = self:FindChild(self._gameObject, "strengthen_box")
    local obj_smelt_ui = self:FindChild(self._gameObject, "smelt_box")    
    
    self.table_sub_views = {
        ['make_box'] = {
            ['ui'] = obj_make_ui,
            ['inst'] = self.ForgeMakeUIInst,
            ['tab'] = self.objToggle_Make,
        },
        ['recast_box'] = {
            ['ui'] = obj_recast_ui,
            ['inst'] = self.ForgeRecastUIInst,
            ['tab'] = self.objToggle_Recast,
            ['cond'] = function()
                return true--MeridiansDataManager:GetInstance():GetSumLevel() >= UNLOCK_FORGE_MERIDIANS_LEVEL or RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_RECAST)
            end
        }, 
        ['strengthen_box'] = {
            ['ui'] = obj_strengthen_ui,
            ['inst'] = self.ForgeStrengthenUIInst,
            ['tab'] = self.objToggle_Strengthen,
            ['cond'] = function()
                return true --MeridiansDataManager:GetInstance():GetSumLevel() >= UNLOCK_FORGE_MERIDIANS_LEVEL or RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_STRENGTHEN)
            end
        },
        ['smelt_box'] = {
            ['ui'] = obj_smelt_ui,
            ['inst'] = self.ForgeSmeltUIInst,
            ['tab'] = self.objToggle_Smelt,
            ['cond'] = function()
                return true--MeridiansDataManager:GetInstance():GetSumLevel() >= UNLOCK_FORGE_MERIDIANS_LEVEL or RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_SMELT)
            end
        },
    }
end

function ForgeUI:Init()
    -- tab栏
    self.toggle_Make = self.objToggle_Make:GetComponent(l_DRCSRef_Type.Toggle)
    if self.toggle_Make then
        local fun = function(isOn)
            self:SwitchSubView(self.cur_sub_view, false, true)
            self:SwitchSubView("make_box", isOn, true)
        end
        self:AddToggleClickListener(self.toggle_Make,fun)
    end
    self.toggle_Recast = self.objToggle_Recast:GetComponent(l_DRCSRef_Type.Toggle)
    if self.toggle_Recast then
        local fun = function(isOn)
            if isOn then 
                if not IsModuleEnable(SM_ITEM_RECAST) then 
                    ShowSystemModuleDisableTip(SM_ITEM_RECAST)
                    self:SwitchSubView(self.cur_sub_view, true, true)
                    return
                end
                self:SwitchSubView(self.cur_sub_view, false, true)
                self:SwitchSubView("recast_box", isOn, true)
            end
        end
        self:AddToggleClickListener(self.toggle_Recast,fun)
    end
    self.toggle_Strengthen = self.objToggle_Strengthen:GetComponent(l_DRCSRef_Type.Toggle)
    if self.toggle_Strengthen then
        local fun = function(isOn)
            if isOn then 
                if not IsModuleEnable(SM_ITEM_ENHANCE) then 
                    ShowSystemModuleDisableTip(SM_ITEM_ENHANCE)
                    self:SwitchSubView(self.cur_sub_view, true, true)
                    return
                end
                self:SwitchSubView(self.cur_sub_view, false, true)
                self:SwitchSubView("strengthen_box", isOn, true)
            end
        end
        self:AddToggleClickListener(self.toggle_Strengthen,fun)
    end
    self.toggle_Smelt = self.objToggle_Smelt:GetComponent(l_DRCSRef_Type.Toggle)
    if self.toggle_Smelt then
        local fun = function(isOn)
            if isOn then 
                if not IsModuleEnable(SM_ITEM_SMELT) then 
                    ShowSystemModuleDisableTip(SM_ITEM_SMELT)
                    self:SwitchSubView(self.cur_sub_view, true, true)
                    return
                end
                self:SwitchSubView(self.cur_sub_view, false, true)
                self:SwitchSubView("smelt_box", isOn, true)
            end
        end
        self:AddToggleClickListener(self.toggle_Smelt,fun)
    end

    local btnTips = self:FindChildComponent(self._gameObject, "Button_question", l_DRCSRef_Type.Button)
    btnTips.gameObject:SetActive(false)
    self:AddButtonClickListener(btnTips, function()
        self:ShowSubViewTips()
    end)

    --注册监听
    self:AddEventListener("UPDATE_ITEM_DATA", function()
        self:RefreshUI({['bKeepNav'] = true})
    end)
    -- 跨天的时候直接充值账户数据中的银锭重铸次数和强化次数(服务器也会更新数据)
    self:AddEventListener("ONEVENT_DIFF_DAY", function()
        local kMainRoleInfo = globalDataPool:getData("MainRoleInfo") or {}
        if not kMainRoleInfo.MainRole then
            kMainRoleInfo.MainRole = {}
        end
        kMainRoleInfo.MainRole[MRIT_REFORGE_DAYCOUNT] = 0
        kMainRoleInfo.MainRole[MRIT_ENHANCEGRADE_DAYCOUNT] = 0
        globalDataPool:setData("MainRoleInfo", kMainRoleInfo, true)
    end)


    local kItemMgr = ItemDataManager:GetInstance()
    local kTableMgr = TableDataManager:GetInstance()
    -- 排序函数
    self.instItemSortFunc = function(a, b)
        local idA = a.uiID or 0
        local idB = b.uiID or 0

        local bEquipedA = kItemMgr:IsItemEquipedByRole(idA)
        local bEquipedB = kItemMgr:IsItemEquipedByRole(idB)        
        if bEquipedA ~= bEquipedB then 
            return bEquipedA
        end
        
        local uiBaseIDA = a.uiTypeID or 0
        local uiBaseIDB = b.uiTypeID or 0
        local kBaseItemA = kTableMgr:GetTableData("Item",uiBaseIDA) or {}
        local kBaseItemB = kTableMgr:GetTableData("Item",uiBaseIDB) or {}
        local eRankA = kBaseItemA.Rank or 0
        local eRankB = kBaseItemB.Rank or 0
        if eRankA == eRankB then
            if uiBaseIDA == uiBaseIDB then
                return idA > idB
            else
                return uiBaseIDA > uiBaseIDB
            end
        else
            return eRankA > eRankB
        end
    end

    --子页面的Init
    self.ForgeMakeUIInst:Init(self._gameObject, self)
    self.ForgeRecastUIInst:Init(self._gameObject, self)
    self.ForgeStrengthenUIInst:Init(self._gameObject, self)
    self.ForgeSmeltUIInst:Init(self._gameObject, self)
end

function ForgeUI:UpdateSmeltSpecialSwitch()
    if self.ForgeSmeltUIInst then 
        self.ForgeSmeltUIInst:UpdateSmeltSpecialSwitch()
    end
end
function ForgeUI:OnEnable()
    -- OpenWindowBar({
    --     ['windowstr'] = "ForgeUI", 
    --     --['titleName'] = "生产",
    --     ['topBtnState'] = {
    --         ['bBackBtn'] = false,
    --         ['bGoodEvil'] = true,
    --         ['bCoin'] = true,
    --     },
    --     ['callback'] = function()
    --         self:OnClick_Return_Button()
    --     end,
    --     ['bSaveToCache'] = false,
    -- })
    for sUIName, data in pairs(self.table_sub_views) do
        if data.cond == nil or data.cond() == true then 
            data.tab.gameObject:SetActive(true)
            if data.inst and data.inst.OnEnable then
                data.inst:OnEnable()
                data.isEnable = true
            end
        else
            data.tab.gameObject:SetActive(false)
        end
    end
end

function ForgeUI:OnDisable()
    --RemoveWindowBar('ForgeUI')
    for sUIName, data in pairs(self.table_sub_views) do
        if data.inst and data.inst.OnDisable and data.isEnable then
            data.inst:OnDisable()
        end
    end
    self.bMonoSubView = nil
end

function ForgeUI:RefreshUI(info)
    if info then
        if info.subView and self.table_sub_views and self.table_sub_views[info.subView] then
            self.cur_sub_view = info.subView
        end

        if info.bOpenImmediately == true then
            self.bOpenImmediately = true
        end
    end
    self.cur_sub_view = self.cur_sub_view or "make_box"
    self:SwitchSubView(self.cur_sub_view, true, true, info)
    self:UpdateSmeltSpecialSwitch()
end

function ForgeUI:Update(dt)
    for _, subData in pairs(self.table_sub_views) do
        if (subData.ui.activeSelf == true) and (subData.inst.Update ~= nil) then
            subData.inst:Update(dt)
        end
    end
end

--切换子页面 子页面名称/ 是否显示/是否记忆为当前页面/ 参数传递
function ForgeUI:SwitchSubView(str_view, bShow, bRecord, info)
    if not(self.table_sub_views and self.table_sub_views[str_view]) then return end
    local bMono = false
    if self.bMonoSubView ~= nil then
        bMono = (self.bMonoSubView == true)
    elseif info then
        bMono = (info.bMono == true)
        self.bMonoSubView = bMono
    end
    -- 如果mono, 其它界面的tab不显示
    local toggleTab = nil
    for strSubView, data in pairs(self.table_sub_views) do
        if data.tab then
            if data.cond ~= nil and data.cond() == false then
                data.tab:SetActive(false)
            else
                toggleTab = data.tab:GetComponent(l_DRCSRef_Type.Toggle)
                if (strSubView ~= str_view ) and (data.tab) then
                    data.tab:SetActive(not bMono)
                    toggleTab.interactable = true
                else
                    data.tab:SetActive(true)
                    toggleTab.interactable = not bMono
                end
            end 
        end
    end
    bShow = (bShow == true)
    bRecord = (bRecord == true)
    local data = self.table_sub_views[str_view]
    if data.ui then
        data.ui:SetActive(bShow)
        if bRecord then
            self.cur_sub_view = str_view
        end
    end
    if bShow and (data.inst ~= nil) then
        data.inst:RefreshUI(info)
        if data.inst.ResetNavBar and ((not info) or (not info.bKeepNav)) then
            data.inst:ResetNavBar()
        end
    end
end

function ForgeUI:IsSubViewOpen(strView)
    return self:IsOpen() and (self.cur_sub_view == strView)
end

function ForgeUI:OnClick_Return_Button()
    if self.bOpenImmediately == true then
        self.bOpenImmediately = nil
        -- DisplayActionEnd()
    end
end

function ForgeUI:ShowSubViewTips()
    if (not SubViewTipsID) or (not self.cur_sub_view) or (not SubViewTipsID[self.cur_sub_view]) then
        return
    end
    if not self.strSubViewTips then
        self.strSubViewTips = {}
    end
    if not self.strSubViewTips[self.cur_sub_view] then
        self.strSubViewTips[self.cur_sub_view] = GetLanguageByID(SubViewTipsID[self.cur_sub_view]) or ""
    end
    local tips = {
        ['title'] = "提示",
        ['titlecolor'] = DRCSRef.Color.white,
        ['kind'] = "wide",
        ['content'] = self.strSubViewTips[self.cur_sub_view] or "",
    }
    OpenWindowImmediately("TipsPopUI", tips)
end

function ForgeUI:OnDestroy()
    self.ForgeMakeUIInst:Close()
    self.ForgeRecastUIInst:Close()
    self.ForgeStrengthenUIInst:Close()
    self.ForgeSmeltUIInst:Close()
end

return ForgeUI
