CharacterUI = class("CharacterUI",BaseWindow)
local BackpackNewUIComS = require 'UI/Role/BackpackNewUIS'
local MartialUICom = require 'UI/Martial/MartialUIS'
local TeamListUICom = require 'UI/Role/TeamListUI'
local SpineRoleUINew = require 'UI/Role/SpineRoleUINew'
local RoleEmbattleUINewCom = require 'UI/Role/RoleEmbattleUINew'

local l_DRCSRef_Type = DRCSRef_Type
local l_DRCSRef = DRCSRef

local array_attack = {
    {[AttrType.ATTR_HITATK]        = "命中"},
    {[AttrType.ATTR_CRITATK]       = "暴击"},
    {[AttrType.ATTR_CONTINUATK]    = "连击"},
    {[AttrType.ATTR_BAOSHANGZHI]   = "暴伤"},
    {[AttrType.ATTR_LIANZHAOLV]    = "连招率"},
    {[AttrType.ATTR_IGNOREDEFPER]   = "忽视防御率"}, -- 防御削减率 = 忽视防御率
    {[AttrType.ATTR_HEJILV]        = "合击率"},
    {[AttrType.ATTR_NEILIYANGXING] = "内力阳性"},
    {[AttrType.ATTR_NEILIYINXING]  = "内力阴性"},
}

local array_defence = {
    {[AttrType.ATTR_SHANBI]            = "闪避"},
    {[AttrType.ATTR_BAOJIDIKANGZHI]    = "暴击抵抗"},
    {[AttrType.ATTR_KANGLIANJI]        = "抗连击"},
    {[AttrType.ATTR_FANJIZHI]   = "反击"},
    {[AttrType.ATTR_POZHAOVALUE]   = "破招"},
    {[AttrType.ATTR_FANTANVALUE]          = "反弹"},
    -- {[AttrType.ATTR_ROUNDHP]           = "回合恢复生命"},
    {[AttrType.ATTR_ROUNDMP]           = "回合回真气"},
    -- {[AttrType.ATTR_MAX_NUM]   = "体质转生命值"},
    {[AttrType.ATTR_FANGYUTISHENGLV]   = "防御提升率"},
    {[AttrType.ATTR_SUCKHP]            = "吸血率"},
    {[AttrType.ATTR_ZHILIAOXIAOGUO]    = "治疗效果"},
    {[AttrType.ATTR_FANTANBEISHU]      = "反弹倍数"},
    {[AttrType.ATTR_ZHONGDUKANGXING]   = "中毒抗性"},
    {[AttrType.ATTR_LIUXUEKANGXING]    = "流血抗性"},
    {[AttrType.ATTR_POJIAKANGXING]     = "破甲抗性"},
    {[AttrType.ATTR_JIANSUKANGXING]    = "减速抗性"},
    {[AttrType.ATTR_NEISHANGKANGXING]  = "内伤抗性"},
    {[AttrType.ATTR_CANFEIKANGXING]    = "残废抗性"},
}

local weekLimitValue = {
    [AttrType.ATTR_HITATKPER]               ="HitRate",
    [AttrType.ATTR_SHANBILV]                ="MissRate",
    [AttrType.ATTR_CRITATKPER]              ="CritRate",
    [AttrType.ATTR_BAOJIDIKANGLV]           ="CritDefenseRate",
    [AttrType.ATTR_CRITATKTIME]             ="CritTimes",
    [AttrType.ATTR_CONTINUATKPER]           ="RepeatRate",
    [AttrType.ATTR_LIANZHAOLV]              ="LianZhaoRate",
    [AttrType.ATTR_HEJILV]                  ="JointAttackRate",
    [AttrType.ATTR_IGNOREDEFPER]            ="PenetrateDefenseRate",
    [AttrType.ATTR_KANGLIANJILV]            ="AntiHitRate",
    [AttrType.ATTR_POZHAOLV]                ="PoZhaoRate",
    [AttrType.ATTR_FANJILV]                 ="CounterAttackRate",
    [AttrType.ATTR_SUCKHP]                  ="BloodSuckRate",
    [AttrType.ATTR_FANTANLV]                ="ReboundRate",
    [AttrType.ATTR_FANTANBEISHU]            ="Rebound",
    [AttrType.ATTR_YUANHULV]                ="AidRate",
    [AttrType.ATTR_JUEZHAOLV]               ="UniqueSkillRate",
}

local order_master = {      -- 精通属性排序
    AttrType.ATTR_JIANFAJINGTONG,
    AttrType.ATTR_QIMENJINGTONG,
    AttrType.ATTR_DAOFAJINGTONG,
    AttrType.ATTR_ANQIJINGTONG,
    AttrType.ATTR_QUANZHANGJINGTONG,
    AttrType.ATTR_YISHUJINGTONG,
    AttrType.ATTR_TUIFAJINGTONG,
    AttrType.ATTR_NEIGONGJINGTONG
}

local l_attrTypeToAttrName =
{
    [AttrType.ATTR_LIDAO] = "力道",
    [AttrType.ATTR_TIZHI] = "体质",
    [AttrType.ATTR_LINGQIAO] = "灵巧",
    [AttrType.ATTR_JINGLI] = "精力",
    [AttrType.ATTR_NEIJIN] = "内劲",
    [AttrType.ATTR_WUXING] = "悟性",

    [AttrType.ATTR_JIANFAATK] = "剑法攻击",
    [AttrType.ATTR_QIMENATK] = "奇门攻击",
    [AttrType.ATTR_DAOFAATK] = "刀法攻击",
    [AttrType.ATTR_ANQIATK] = "暗器攻击",
    [AttrType.ATTR_QUANZHANGATK] = "拳掌攻击",
    [AttrType.ATTR_YISHUATK] = "医术攻击",
    [AttrType.ATTR_TUIFAATK] = "腿法攻击",
    [AttrType.ATTR_NEIGONGATK] = "内功攻击",

    [AttrType.ATTR_MARTIAL_ATK] = "攻击"
}

local order_martial_atk_attr  = {    -- 武学攻击排序
    AttrType.ATTR_MARTIAL_ATK
}

-- 周目信息
local array_round =
{
    MainRoleData.MRD_DIFF,
    MainRoleData.MRD_ENMEY_DIFFUP,
    -- MainRoleData.MRD_EQUIP_ATTRUP,  -- 没有这条了，装备只跟强化等级挂钩，然后根据周目不同爆出的装备强化等级也不同
    MainRoleData.MRD_WEEK_TOTALTIME,
}

-- 开局优势
local array_gift =
{
    MainRoleData.MRD_ROLELEVELMAX,  -- 角色等级上限
    MainRoleData.MRD_MARTIALLVMAX,  -- 武学等级上限
    MainRoleData.MRD_MARTIAL_NUM_MAX,  -- 武学数量上限
    --MainRoleData.MRD_BATTLE_TEAMNUMS,  -- 可上阵队友数
    MainRoleData.MRD_EXTRA_ROLEEXP,  -- 角色经验加成
    MainRoleData.MRD_EXTRA_MARITAL,  -- 武学经验加成
    MainRoleData.MRD_DEFAULT_GOOD,  -- 默认好感度
    MainRoleData.MRD_EXTRA_GOOD,  -- 额外好感度加成
    MainRoleData.MRD_EXTRA_ROLESELLITEM,  -- 商店卖货收益率
}

-- 经脉
local array_meridians = {
    AttrType.ATTR_QUANZHANGJINGTONG, -- 拳掌精通
    AttrType.ATTR_JIANFAJINGTONG, -- 剑法精通
    AttrType.ATTR_DAOFAJINGTONG, -- 刀法精通
    AttrType.ATTR_TUIFAJINGTONG, -- 腿法精通
    AttrType.ATTR_QIMENJINGTONG, -- 奇门精通
    AttrType.ATTR_ANQIJINGTONG, -- 暗器精通
    AttrType.ATTR_YISHUJINGTONG, -- 医术精通
    AttrType.ATTR_NEIGONGJINGTONG, -- 内功精通
}

local UPDATE_TYPE =
{
    ["RefreshAttr"] = 1,
    ["RefreshGift"] = 2,
    ["RefreshEquipItem"] = 3,
    ["RefreshMainRole"] = 4,
    ["RefreshWishTask"] = 5,
    ["UpdateBackpackMsgBar"] = 6,
    ["UpdateTempBackpack"] = 7,
    ["UpdateTeamData"] = 8,
}

local STAT_LIST = {
    [WeekEndDataEnum.WE_INVITE_COUNT] = '邀请次数',
    [WeekEndDataEnum.WE_OBSERVE_COUNT] = '观察次数',
    [WeekEndDataEnum.WE_Qi1Tao] = '乞讨次数',
    [WeekEndDataEnum.WE_GIVE_GIFT_COUNT] = '送礼成功次数',
    [WeekEndDataEnum.WE_Qie1Cuo] = '切磋成功次数',
    [WeekEndDataEnum.WE_Jue1Dou] = '决斗成功次数',
    [WeekEndDataEnum.WE_CALL_UP_COUNT] = '号召成功次数',
    [WeekEndDataEnum.WE_PUNISH_COUNT] = '惩恶成功次数',
    [WeekEndDataEnum.WE_INQUIRY_COUNT] = '盘查成功次数',
    [WeekEndDataEnum.WE_Zhen1Fu2Men3Pai] = '征服门派数量',
}

-- 交互信息
local InterctGroupData = 
{
	Observe = 1,
	GiveGift = 2,
	Compare = 3,
	LearnMartial = 4,
	Beg = 5,
	Fight = 6,
	Punish = 7,
	Inquiry = 8,
}

local temp_battle_factor


function CharacterUI:Create()
	local obj = LoadPrefabAndInit("Role/CharacterUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end

    self:UpdateData()
end

function CharacterUI:ctor()
    self.iUpdateFlag = 0
    -- self.DontDestroy = true
    temp_battle_factor = TableDataManager:GetInstance():GetTableData("BattleFactor",1)
end

function CharacterUI:Init()
    self.akEquipmentItemUIClass = {}
    self.objWindowTabUI = self:FindChild(self._gameObject,"WindowTabUI")
    self.objTab_box = self:FindChild(self._gameObject,"WindowTabUI/TransformAdapt_node_right/Tab_box")
    self.TeamListUI = self:FindChild(self._gameObject,"TransformAdapt_node_left/TeamListUI")
    self.TeamListUICom = TeamListUICom.new()
    self.TeamListUICom:SetGameObject(self.TeamListUI)
    self.TeamListUICom:Init()
    self.TeamListUICom:SetScriptUI(self)

    self:InitAbilityNode()
    self:InitEquipNode()

    --初始化tips函数
    self.cur_tip_func = self.OnClick_Tips_Common
    -- 背包扩容界面
    self.ObjBackpackExtend = self:FindChild(self._gameObject,"BackpackExtend")
    self.ObjBackpackExtendBG = self:FindChild(self.ObjBackpackExtend,"Background")
    local BtnBackpackExtendClose = self:FindChildComponent(self.ObjBackpackExtendBG, "CloseButton", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(BtnBackpackExtendClose, function()
        -- self.roleSpine:SetActive(true)
        self.spineRoleUINew:SetActive(true)

        self.ObjBackpackExtend:SetActive(false)

        local windowBarUI = WindowsManager:GetInstance():GetUIWindow("WindowBarUI")
        if windowBarUI then
            windowBarUI:SetActive(true)
        end
    end)

    self.ObjBackpackExtendList = self:FindChild(self.ObjBackpackExtendBG, "List")
    self.TextExtendListSum = self:FindChildComponent(self.ObjBackpackExtendList, "Num/Text", l_DRCSRef_Type.Text)
    self.ObjExtendListBase = self:FindChild(self.ObjBackpackExtendList, "BaseNum")
    self.ObjExtendListDiff = self:FindChild(self.ObjBackpackExtendList, "DiffNum")
    self.ObjExtendListWeekly = self:FindChild(self.ObjBackpackExtendList, "WeeklyNum")
    self.ObjExtendListBuy = self:FindChild(self.ObjBackpackExtendList, "BuyNum")
    local BtnExtendListBuy = self:FindChildComponent(self.ObjExtendListBuy, "Button", l_DRCSRef_Type.Button)
    local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    local backpackBuyPrice = commonConfig.BackpackPayPrice or 0
    local backpackBuySize = commonConfig.BackpackPaySize or 0
    local warningText = string.format("花费%d银锭激活%d个背包格子吗?\n仅本周目生效", backpackBuyPrice, backpackBuySize)
    self:AddButtonClickListener(BtnExtendListBuy, function()
        local content = {
            ['btnText'] = "确定",
            ['btnType'] = "silver",
            ['title'] = "扩充背包",
            ['text'] = warningText,
            ['num'] = backpackBuyPrice
        }
        local callBack = function()
            PlayerSetDataManager:GetInstance():RequestSpendSilver(backpackBuyPrice, function()
                SendClickBagCapacityBuy()
            end)
        end
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.Pay_TIP, content, callBack })
    end)
    -- 背包
    self.BackpackUI = self:FindChild(self._gameObject, "TransformAdapt_node_right/BackpackUI")
    -- 临时背包
    self.TempBackpackUI = self:FindChild(self._gameObject, "TempBackpackUI")
    self.BtnTempBackpackClose = self:FindChildComponent(self.TempBackpackUI, "CloseButton", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.BtnTempBackpackClose, function()
        self.TempBackpackNewUICom:UnPickAllItems()
        self.TempBackpackUI:SetActive(false)
    end)
    self.BtnTempBackpackBackBag = self:FindChildComponent(self.TempBackpackUI, "BackBagButton", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.BtnTempBackpackBackBag, function()
        self:TempBagMoveBack()
    end)
    self.TextBackpackSizeInTemp = self:FindChildComponent(self.TempBackpackUI,"BagMsg/Tip", l_DRCSRef_Type.Text)

    -- 背包下方工具栏
    self.ObjBackpackMsg = self:FindChild(self.BackpackUI, "BackpackMsg")
    self.TextBackpackSize = self:FindChildComponent(self.ObjBackpackMsg,"Num", l_DRCSRef_Type.Text)
    self.ObjBtnBackpackExtend = self:FindChild(self.ObjBackpackMsg,"ExtendButton")
    self.ObjBtnBackpackExtend:SetActive(false)
    self.BtnBackpackExtend = self.ObjBtnBackpackExtend:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.BtnBackpackExtend, function()
        -- self.roleSpine:SetActive(false)
        self.spineRoleUINew:SetActive(false)
        self:ShowBackpackExtend()
    end)

    self:CommonBind(self:FindChild(self.ObjBackpackMsg,"Num/Tips"),function()
        OpenWindowImmediately("TipsPopUI", TipsDataManager:GetInstance():GetBackpackExtendTips())
    end)

    self.ObjBtnBackpackTemp = self:FindChild(self.ObjBackpackMsg,"TempButton")
    self.BtnBackpackTemp = self.ObjBtnBackpackTemp:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.BtnBackpackTemp, function()
        self:ShowTempBackpack()
    end)
    self.ObjBtnBackpackWareHouse = self:FindChild(self.ObjBackpackMsg,"WareHouseButton")
    --local objWareHouseGray = self:FindChild(self.ObjBtnBackpackWareHouse,"Gray")
    --objWareHouseGray:SetActive(false)
    --self.ObjBtnWareHouseRedPoint = self:FindChild(self.ObjBtnBackpackWareHouse,"Point")
    --self.ObjBtnWareHouseRedPoint:SetActive(false)
    -- 注册监听: 仓库物品更新的时候显示小红点
    -- self:AddEventListener("UPDATE_STORAGE_ITEM", function()
    --     local bNewItemAdded = (StorageDataManager:GetInstance():GetNewItemAddedFlag() == true)
    --     self.ObjBtnWareHouseRedPoint:SetActive(bNewItemAdded)
    -- end)
    -- self.BtnBackpackWareHouse = self.ObjBtnBackpackWareHouse:GetComponent(l_DRCSRef_Type.Button)
    -- self:AddButtonClickListener(self.BtnBackpackWareHouse, function()
    --     if CLOSE_EXPERIENCE_OPERATION then
    --         SystemUICall:GetInstance():Toast('体验版暂不开放')
    --         return
    --     else
    --         self:ShowStorage()
    --         -- 打开仓库就可以关掉小红点了
    --         self.ObjBtnWareHouseRedPoint:SetActive(false)
    --     end
        
    -- end)
    self.MartialUI = self:FindChild(self._gameObject,"MartialUI")
    self.gift_box = self:FindChild(self._gameObject,"gift_box")
    self.chain_box = self:FindChild(self._gameObject,"chain_box")
    self.RoleEmbattleUINew = self:FindChild(self._gameObject,"RoleEmbattleUINew")

    -- 右边栏的各个按钮，获取Toggle组件
    self.Toggle_ability = self:FindChildComponent(self.objTab_box,"Toggle_ability",l_DRCSRef_Type.Toggle)
    self.Image_ability = self:FindChild(self.objTab_box, "Toggle_ability/Image")
    self.Image_ability_bac = self:FindChild(self.objTab_box, "Toggle_ability/bac")
    if self.Toggle_ability then
        local fun = function(bool)
            self.Image_ability:SetActive(not bool)
            self.Image_ability_bac:SetActive(bool)
            if bool then
                self:OnClick_Toggle_ability()
            end
        end
        self:AddToggleClickListener(self.Toggle_ability,fun)
    end
    self.Toggle_embattle = self:FindChildComponent(self.objTab_box,"Toggle_embattle",l_DRCSRef_Type.Toggle)
    self.Image_embattle = self:FindChild(self.objTab_box, "Toggle_embattle/Image")
    self.Image_embattle_bac = self:FindChild(self.objTab_box, "Toggle_embattle/bac")
    if self.Toggle_embattle then
        local fun = function(bool)
            self.Image_embattle:SetActive(not bool)
            self.Image_embattle_bac:SetActive(bool)
            if bool then
                self:OnClick_Toggle__embattle()
            end
        end
        self:AddToggleClickListener(self.Toggle_embattle,fun)
    end

    self.Button_guide = self:FindChildComponent(self.objTab_box, "Toggle_embattle/Button_guide",l_DRCSRef_Type.Button)
    if self.Button_guide then
        local fun = function(bool)
            self.Toggle_embattle:OnSubmit()
        end
        self:AddButtonClickListener(self.Button_guide,fun)
    end


    self.Toggle_backpack = self:FindChildComponent(self.objTab_box,"Toggle_backpack",l_DRCSRef_Type.Toggle)
    self.Image_backpack = self:FindChild(self.objTab_box,"Toggle_backpack/Image")
    self.Image_backpack_bac = self:FindChild(self.objTab_box, "Toggle_backpack/bac")
    if self.Toggle_backpack then
        local fun = function(bool)
            self.Image_backpack:SetActive(not bool)
            self.Image_backpack_bac:SetActive(bool)
            if bool then
                self:OnClick_Toggle_backpack()
            end
        end
        self:AddToggleClickListener(self.Toggle_backpack,fun)
    end
    self.Toggle_martial = self:FindChildComponent(self.objTab_box,"Toggle_martial",l_DRCSRef_Type.Toggle)
    self.Image_martial = self:FindChild(self.objTab_box,"Toggle_martial/Image")
    self.Image_martial_bac = self:FindChild(self.objTab_box, "Toggle_martial/bac")
    if self.Toggle_martial then
        local fun = function(bool)
            self.Image_martial:SetActive(not bool)
            self.Image_martial_bac:SetActive(bool)
            if bool then
                self:OnClick_Toggle_martial()
            end
        end
        self:AddToggleClickListener(self.Toggle_martial,fun)
    end
    self.Toggle_gift = self:FindChildComponent(self.objTab_box,"Toggle_gift",l_DRCSRef_Type.Toggle)
    self.Image_gift = self:FindChild(self.objTab_box,"Toggle_gift/Image")
    self.Image_gift_bac = self:FindChild(self.objTab_box, "Toggle_gift/bac")
    if self.Toggle_gift then
        local fun = function(bool)
            self.Image_gift:SetActive(not bool)
            self.Image_gift_bac:SetActive(bool)
            if bool then
                self:OnClick_Toggle_gift()
            end
        end
        self:AddToggleClickListener(self.Toggle_gift,fun)
    end
    self.Toggle_chain = self:FindChildComponent(self.objTab_box,"Toggle_chain",l_DRCSRef_Type.Toggle)
    self.Image_chain = self:FindChild(self.objTab_box,"Toggle_chain/Image")
    self.Image_chain_bac = self:FindChild(self.objTab_box, "Toggle_chain/bac")
    if self.Toggle_chain then
        local fun = function(bool)
            self.Image_chain:SetActive(not bool)
            self.Image_chain_bac:SetActive(bool)
            if bool then
                self:OnClick_Toggle_chain()
            end
        end
        self:AddToggleClickListener(self.Toggle_chain,fun)
    end

    self.leftNode = self:FindChild(self._gameObject,"TransformAdapt_node_left")
    self.rightNode = self:FindChild(self._gameObject,"WindowTabUI/TransformAdapt_node_right")
    -- self.embattleBtn = self:FindChild(self._gameObject,"TransformAdapt_node_left/Button_embattle")
    -- self.objButton_embattle = self.embattleBtn:GetComponent(l_DRCSRef_Type.Button)
    -- if self.objButton_embattle then
    --     self:AddButtonClickListener(self.objButton_embattle,function ()
    --         -- self.roleSpine:SetActive(false)
    --         self.spineRoleUINew:SetActive(false)
    --         OpenWindowByQueue("RoleEmbattleUI",{bShowWheelWar = false},true)
    --     end)
    -- end


    self.objBackPackUISC = self:FindChild(self.BackpackUI, 'Pack/LoopScrollView')
    self.objBackPackUIMsg = self:FindChild(self.BackpackUI, 'BackpackMsg')
    self.objBackPackUIMask = self:FindChild(self.BackpackUI, 'Image_Mask')

    self.objTeammateLimit = self:FindChild(self._gameObject, "TransformAdapt_node_left/TeammateLimit")
    self.textTeammateLimit = self:FindChildComponent(self.objTeammateLimit, "Text", l_DRCSRef_Type.Text)
    local btnTeammateLimitTips = self:FindChildComponent(self.objTeammateLimit, "Button_tips", l_DRCSRef_Type.Button)
    btnTeammateLimitTips.gameObject:SetActive(false)
    local objTeammateLimittips = self:FindChild(self._gameObject, "TransformAdapt_node_left/TeammateLimit/Tips")
    objTeammateLimittips:SetActive(false)
    -- self:AddButtonClickListener(btnTeammateLimitTips, function()
    --     self:OnClickTeammateLimitTips()
    -- end)


    --標題
    self.txtTitle = self:FindChildComponent(self._gameObject, "frame/Title", l_DRCSRef_Type.Text)

    --退出按钮
    self.btnExit = self:FindChildComponent(self._gameObject, "frame/Btn_exit", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnExit, function()
        -- self.roleSpine:SetActive(false)
        ItemDataManager:GetInstance():ClearNewItemFlag()
        RemoveWindowImmediately("CharacterUI",false)
        --RemoveWindowImmediately不会把UI直接置为false 而是将其移到屏幕不可见的一个区域 RoleEmbattleUINew里面的模型
        --不受UI控件影响 因此暂时制空 后续有好方法再改
        --self.RoleEmbattleUINew:SetActive(false)

    end)

    -- 监听队伍数据
    local fun_refreshAttr = function(info)
        if info == self.selectRole then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshAttr)
        end
    end
    local fun_refreshGift = function(info)
        if info == self.selectRole  then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshGift)
        end
    end
    local fun_refreshRoleItem = function(info)
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshEquipItem)
    end
    local fun_refreshMainRole = function(info)
        if self.iMainRoleID == self.selectRole then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshMainRole)
        end
    end

    local fun_refreshWishTask = function(info)
        --if info == self.selectRole then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshWishTask)
        --end
    end

    local fun_refreshBackpackMsgBar = function()
        --在characterui中，但是不在背包里使用了物品，会因为背包的隐藏 而接受不到刷新事件 导致没刷新.在这里重新刷新一下
        if not self.Toggle_backpack.isOn then
            self.bRefreshBackPack = nil
        end
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateBackpackMsgBar)
    end

    local fun_refreshTempBag = function()
        if self.TempBackpackUI.activeSelf then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateTempBackpack)
        end
    end
    self:AddEventListener("UPDATE_DISPLAY_ROLEATTRS",fun_refreshAttr,nil,nil,nil,true)
    self:AddEventListener("UPDATE_DISPLAY_ROLECOMMON",fun_refreshAttr,nil,nil,nil,true)
    self:AddEventListener("UPDATE_DISPLAY_ROLEITEMS",fun_refreshRoleItem,nil,nil,nil,true)
    self:AddEventListener("UPDATE_MAIN_ROLE_INFO",fun_refreshMainRole,nil,nil,nil,true)
    self:AddEventListener("UPDATE_GIFT",fun_refreshGift,nil,nil,nil,true)
    self:AddEventListener("UPDATE_WISHTASK",fun_refreshWishTask,nil,nil,nil,true)
    self:AddEventListener("UPDATE_ITEM_DATA", fun_refreshBackpackMsgBar,nil,nil,nil,true)
    self:AddEventListener("UPDATE_ITEM_DATA", fun_refreshTempBag,nil,nil,nil,true)
    self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function()
        if self.ObjBackpackExtend.activeSelf then
            self:UpdateBackpackMsgBar()
            self:ShowBackpackExtend()
        end
    end)

    self.SetUpdateTeamDataFlag = function()
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateTeamData)
    end
    self:AddEventListener("UPDATE_TEAM_INFO", SetUpdateTeamDataFlag,nil,nil,nil,true)

    -- 当前选中角色
    self.iMainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    self.selectRole = self.iMainRoleID
    -- 当前剩余点数，和加点所用点数
    self.uiRemainAttrPoint = 0
    self.array_attr_due_to_point = {}

    self.BackpackNewUIComS = BackpackNewUIComS.new({
        ['objBind'] = self.BackpackUI,  -- 背包实例绑定的ui节点
        ['RowCount'] = 2,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 6,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID) -- 点击ItemInfo组件的回调, 可缺省
            self:OnClick_BackpackItem(obj, itemID)
        end,
        ['funcOnClickItemIcon'] = function(obj, itemID)  -- 点击ItemIcon组件的回调, 可缺省
            self:OnClick_BackpackItem(obj, itemID)
        end,
    })
    self.BackpackNewUIComS:SetSortButton(true)

    self.TempBackpackNewUICom = BackpackNewUIComS.new({
        ['objBind'] = self.TempBackpackUI,  -- 背包实例绑定的ui节点
        ['RowCount'] = 4,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 4,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)
            self:OnClick_TempBackpackItemInfo(itemID)
        end,
        ['funcOnClickItemIcon'] = function(obj, itemID)
            self:OnClick_TempBackpackItemIcon(obj, itemID)
        end,
    })
    self.TempBackpackNewUICom:SetSortButton(true)

    self.MartialUICom = MartialUICom.new(self.MartialUI)
    self.MartialUICom:Init('Character', self)

    self.RoleEmbattleUINewCom = RoleEmbattleUINewCom.new(self.RoleEmbattleUINew)
    
    self.RoleEmbattleUINewCom:Init()
    self.RoleEmbattleUINewCom:OnEnable()
    self.RoleEmbattleUINewCom:RefreshUI({bShowWheelWar = false})

    self:InitGift()
    self:InitWishTasks()
    self:ResetMode()

    -- 初始化关系界面
    -- 角色关系
    self.comToggleRoleChain = self:FindChildComponent(self.chain_box, "Nav_box_chain/Role", l_DRCSRef_Type.Toggle)
    self.objToggleRoleChain = self.comToggleRoleChain.gameObject
    self.comToggleRoleChainText = self:FindChildComponent(self.objToggleRoleChain, "Text", l_DRCSRef_Type.Text)
    self.objRoleChainBox = self:FindChild(self.chain_box, 'chain_box_role')
    self.objRoleChainList = self:FindChild(self.chain_box, 'chain_box_role/Viewport/G_ChainContent')
    self.objRoleChainObject = self:FindChild(self.objRoleChainList, 'Disposition')
    self.objRoleChainBox:SetActive(false)
    self.objRoleChainObject:SetActive(false)
    self.roleChainObjectPool = {self.objRoleChainObject}
    local fun = function(isOn)
        self:OnClick_Toggle_Chain_Role(isOn)
        if isOn then
            self.comToggleRoleChainText.color = UI_COLOR.white
        else
            self.comToggleRoleChainText.color = UI_COLOR.black
        end
    end
    self:AddToggleClickListener(self.comToggleRoleChain, fun)

    -- 城市关系
    self.comToggleCityChain = self:FindChildComponent(self.chain_box, "Nav_box_chain/City", l_DRCSRef_Type.Toggle)
    self.objToggleCityChain = self.comToggleCityChain.gameObject
    self.comToggleCityChainText = self:FindChildComponent(self.objToggleCityChain, "Text", l_DRCSRef_Type.Text)
    self.objCityChainBox = self:FindChild(self.chain_box, 'chain_box_city')
    self.objCityChainList = self:FindChild(self.chain_box, 'chain_box_city/Viewport/Content')
    self.objCityChainObject = self:FindChild(self.objCityChainList, 'Disposition_city')
    self.objCityChainBox:SetActive(false)
    self.objCityChainObject:SetActive(false)
    self.cityChainObjectPool = {self.objCityChainObject}
    local fun = function(isOn)
        self:OnClick_Toggle_Chain_City(isOn)
        if isOn then
            self.comToggleCityChainText.color = UI_COLOR.white
        else
            self.comToggleCityChainText.color = UI_COLOR.black
        end
    end
    self:AddToggleClickListener(self.comToggleCityChain, fun)

    -- 门派关系
    self.comToggleClanChain = self:FindChildComponent(self.chain_box, "Nav_box_chain/Clan", l_DRCSRef_Type.Toggle)
    self.objToggleClanChain = self.comToggleClanChain.gameObject
    self.comToggleClanChainText = self:FindChildComponent(self.objToggleClanChain, "Text", l_DRCSRef_Type.Text)
    self.objClanChainBox = self:FindChild(self.chain_box, 'chain_box_clan')
    self.objClanChainList = self:FindChild(self.chain_box, 'chain_box_clan/Viewport/Content')
    self.objClanChainObject = self:FindChild(self.objClanChainList, 'Disposition_clan')
    self.objClanChainBox:SetActive(false)
    self.objClanChainObject:SetActive(false)
    self.clanChainObjectPool = {self.objClanChainObject}
    local fun = function(isOn)
        self:OnClick_Toggle_Chain_Clan(isOn)
        if isOn then
            self.comToggleClanChainText.color = UI_COLOR.white
        else
            self.comToggleClanChainText.color = UI_COLOR.black
        end
    end
    self:AddToggleClickListener(self.comToggleClanChain, fun)

    self:SetSelectRole(self.iMainRoleID)

    -- 角色讨论区
    self.btnRoleDiscuss = self:FindChildComponent(self._gameObject,"Button_discuss","Button")
    if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_ROLE) then
        self.btnRoleDiscuss.gameObject:SetActive(true)
        self:AddButtonClickListener(self.btnRoleDiscuss, function()
            local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByID(self.selectRole)     -- 静态数据
            local targetId
            if (roleTypeData) then
                targetId = roleTypeData.RoleID
            end
            local articleId
            if (targetId) then
                articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_ROLE,targetId)
            end
            if (articleId == nil) then
                SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
            else
                OpenWindowImmediately("DiscussUI",articleId)
            end
        end)
    else
        self.btnRoleDiscuss.gameObject:SetActive(false)
    end
end

local hasFlag = HasFlag
function CharacterUI:Update()
    if self.iUpdateFlag ~= 0 then
        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshAttr) then
            self:InitPoint()
            self:RefreshAbility()
        end
        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshGift) then
            self:RefreshGift()
        end
        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshEquipItem) then
            self:RefreshSpine()
            self:RefreshEquipItem()
        end
        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshMainRole) then
            self:RefreshMainRole()
            self:RefreshTitleName()
            self.TeamListUICom:RefreshUI()
        end
        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateBackpackMsgBar) then
            self:UpdateBackpackMsgBar()
        end

        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.RefreshWishTask) then
            self:RefreshWishTask()
        end

        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateTempBackpack) then
            self:UpdateTempBackpack()
        end

        if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateTeamData) then
            if not RoleDataManager:GetInstance():IsRoleInTeam(self.selectRole) then
                self:SetSelectRoleIndex(self.selectIndex, true)
            else
                self.TeamListUICom:RefreshUI()
            end
        end

        self.iUpdateFlag = 0
    end

    self.MartialUICom:Update()
    self.BackpackNewUIComS:Update()
    self.TempBackpackNewUICom:Update()
    self.TeamListUICom:Update()
    self.RoleEmbattleUINewCom:Update()
end
local lPlayAni = {
	[ItemTypeDetail.ItemType_Fist] = {"attack_f_001","attack_f_002","attack_f_101"},
	[ItemTypeDetail.ItemType_Whip] = {"attack_l_001","attack_l_002","attack_l_101"},
	[ItemTypeDetail.ItemType_Rod] = {"attack_r_001","attack_r_002","attack_r_101"},
	[ItemTypeDetail.ItemType_Knife] ={"attack_s_001","attack_s_002","attack_s_101"},
    [ItemTypeDetail.ItemType_Fan] = {"attack_s_001","attack_s_002","attack_s_101"},
    [ItemTypeDetail.ItemType_Sword] ={"attack_s_001","attack_s_002","attack_s_101"},
}

function CharacterUI:PlayerSpineAni()
	local skeletonAnimation = self.roleSpine:GetComponent('SkeletonAnimation')
	local attackList = {}
	local spineAnimaitionData = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime", self.rolemodelid)
    local kRoleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    local kRoleEquipItems = kRoleData.akEquipItem or {}
    local weapon = kRoleEquipItems[REI_WEAPON]
    local itemType = nil
    if weapon and weapon > 0 then
        weapon = ItemDataManager:GetInstance():GetItemTypeID(weapon)
        local itemData = TableDataManager:GetInstance():GetTableData("Item",weapon)
        itemType = itemData.ItemType
    end

	if spineAnimaitionData then
		-- for key, value in ipairs(lPlayAni) do
		-- 	if  spineAnimaitionData[value] then
        --         if weapon > 0 then
        --             if key == itemTypeName then
        --                 for _, ani in pairs(value) do
        --                     local spineaniminfo = self.spineRoleUINew:GetAnimInfoByName(ani,self.rolemodelid,spineAnimaitionData)
        --                     table.insert(attackList, spineaniminfo);
        --                 end
        --             end
        --         else
        --             if key == ItemTypeDetail.ItemType_Fist then
        --                 for _, ani in pairs(value) do
        --                     local spineaniminfo = self.spineRoleUINew:GetAnimInfoByName(ani,self.rolemodelid,spineAnimaitionData)
        --                     table.insert(attackList, spineaniminfo);
        --                 end
        --             end
        --         end
		-- 	end
		-- end
        if itemType and lPlayAni[itemType] then
            local kAni = lPlayAni[itemType]
            for _, value in pairs(kAni) do
                local spineaniminfo = self.spineRoleUINew:GetAnimInfoByName(value,self.rolemodelid,spineAnimaitionData)
                table.insert(attackList, spineaniminfo);
            end
        else
            local kAni = lPlayAni[ItemTypeDetail.ItemType_Fist]
            for _, value in pairs(kAni) do
                local spineaniminfo = self.spineRoleUINew:GetAnimInfoByName(value,self.rolemodelid,spineAnimaitionData)
                table.insert(attackList, spineaniminfo);
            end
        end
	end
    

	if #attackList == 0 then return end 

    if (not self.aniIndex) or (self.aniIndex >= #(attackList)) then
        self.aniIndex = 0;
    end
	self.aniIndex = self.aniIndex + 1;
	-- if self.weapon then 
	-- 	self.spineRoleUINew:SetEquipItemEX(self.roleSpine,self.rolemodelid, {itemID = self.weapon, uiEnhanceGrade = 0} ,attackList[self.aniIndex])
	-- end
	local prepareName = "prepare"
	local animName = attackList[self.aniIndex]['oldActionName']
	
	-- local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo);
	-- if info then
	-- 	local createRoleInfo  = TableDataManager:GetInstance():GetTableData("CreateRole",info.uiTypeID)
	-- 	if createRoleInfo and createRoleInfo[animName] ~= 0 then 
	-- 		PlaySound(createRoleInfo[animName])
	-- 	end
	-- end
 
	SetSkeletonAnimation(skeletonAnimation, 0, animName, false, function()
		if not attackList[self.aniIndex] then return end
		if weapon and weapon > 0 then 
			local scale = DRCSRef.Vec3One
			local RoleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.rolemodelid)
			if RoleModelData and RoleModelData.ModelID > 0 then
				scale = self.spineRoleUINew:GetRoleWeaponScale(RoleModelData.ModelID)
			end
			attackList[self.aniIndex]['action'] = 'prepare'
            self.spineRoleUINew:SetEquipItemEX(weapon, 0 ,attackList[self.aniIndex]);
        else
            self.spineRoleUINew:SetEquipItemEX(nil,nil,spineaniminfo);
        end
		
		if skeletonAnimation == nil or skeletonAnimation.AnimationState == nil then
			return
		end
		skeletonAnimation.AnimationState:AddAnimation(0, attackList[self.aniIndex]['prepare'], true, 0)
	end)
end


function CharacterUI:InitAbilityNode()
    self.comCGImage = self:FindChildComponent(self._gameObject, "AbilityNode/cg_box/Image",l_DRCSRef_Type.Image)
    self.objCreateCGParent = self:FindChild(self._gameObject, "AbilityNode/CreateCG")
    -- 左侧描述
    self.left_name = self:FindChildComponent(self._gameObject, "AbilityNode/cg_box/bottom/desc/title/title_name","Text")
    self.left_nick = self:FindChildComponent(self._gameObject, "AbilityNode/cg_box/bottom/desc/title/title_des","Text")
    self.left_desc = self:FindChildComponent(self._gameObject, "AbilityNode/cg_box/bottom/desc/role_desc","Text")
    self.left_nickedit = self:FindChildComponent(self._gameObject, "AbilityNode/cg_box/bottom/desc/title/title_des/edit",DRCSRef_Type.Button)
    self.objInteractGroup2 = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content")
	self.objShowImage = self:FindChild(self._gameObject, "cg_box/ShowImage")
	self.objShowImageText= self:FindChildComponent(self._gameObject, "cg_box/ShowImage/Text", "Text")

    self:AddButtonClickListener(self.left_nickedit, function()
        OpenWindowImmediately('TitleSelectUI')
    end)

	-- 送礼
	self.objGiveGift = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/GiveGift")
	self.objGiveGiftButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/GiveGift", DRCSRef_Type.Button)
	if self.objGiveGiftButton then
		self:AddButtonClickListener(self.objGiveGiftButton,function()
			OpenWindowByQueue("GiveGiftDialogUI", self.selectRole)
		end)
	end

	-- 观察
	self.objObs = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Observe")
	self.objObsButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Observe", DRCSRef_Type.Button)
	if self.objObsButton then
		self:AddButtonClickListener(self.objObsButton,function()
			SendNPCInteractOperCMD(NPCIT_WATCH, self.selectRole)
		end)
	end

	-- 切磋
	self.objCompare = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare")
	self.objCompareRefresh = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Refresh")
	self.objCompareCompareShader = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Shader")
	self.comCompareText = self:FindChildComponent(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Text", DRCSRef_Type.Text)
	self.objCompareButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Compare", DRCSRef_Type.Button)
	self.comCompareImg = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Compare", DRCSRef_Type.Image)
	if self.objCompareButton then
		self:AddButtonClickListener(self.objCompareButton,function()
			self:CompareWithInteractRole()
		end)
	end

	-- 乞讨
	self.objBegShader = self:FindChild(self.objInteractGroup2, "Beg/Shader")
	self.objBeg = self:FindChild(self.objInteractGroup2, "Beg")
	self.comBegText = self:FindChildComponent(self.objInteractGroup2, "Beg/Text", DRCSRef_Type.Text)
	self.comBegButton = self:FindChildComponent(self.objInteractGroup2,"Beg", DRCSRef_Type.Button)
	self.comBegImg = self:FindChildComponent(self.objInteractGroup2,"Beg", DRCSRef_Type.Image)
	self.objBegRefresh = self:FindChild(self.objInteractGroup2, "Beg/Refresh")
	if self.comBegButton then
		self:AddButtonClickListener(self.comBegButton,function()
			self:BegInteractRole()
		end)
	end

	-- 盘查
	self.objInquiry = self:FindChild(self.objInteractGroup2, "Inquiry")
	self.objInquiryShader = self:FindChild(self.objInteractGroup2, "Inquiry/Shader")
	self.comInquiryText = self:FindChildComponent(self.objInteractGroup2, "Inquiry/Text", DRCSRef_Type.Text)
	self.objInquiryButton = self:FindChildComponent(self.objInteractGroup2,"Inquiry", DRCSRef_Type.Button)
	self.comInquiryImg = self:FindChildComponent(self.objInteractGroup2,"Inquiry", DRCSRef_Type.Image)
	self.objInquiryRefresh = self:FindChild(self.objInteractGroup2, "Inquiry/Refresh")
	if self.objInquiryButton then
		self:AddButtonClickListener(self.objInquiryButton,function()
			self:InquiryInteractRole()
		end)
	end

	-- 请教
	self.objLearnMartial = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/LearnMartial")
	self.objLearnMartialRefresh = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/LearnMartial/Refresh")
	self.comLearnMartialImg = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/LearnMartial", DRCSRef_Type.Image)
	self.comLearnMartialText = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/LearnMartial/Text", DRCSRef_Type.Text)
	self.objLearnMartialButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/LearnMartial", DRCSRef_Type.Button)
	if self.objLearnMartialButton then
		self:AddButtonClickListener(self.objLearnMartialButton,function()
			self:LearnMartial()
		end)
	end

	-- 决斗
	self.objFight = self:FindChild(self.objInteractGroup2, "Fight")
	self.objFightShader = self:FindChild(self.objInteractGroup2, "Fight/Shader")
	self.comFightButton = self:FindChildComponent(self.objInteractGroup2,"Fight", DRCSRef_Type.Button)
	self.comFightImg = self:FindChildComponent(self.objInteractGroup2,"Fight", DRCSRef_Type.Image)
	if self.comFightButton then
		self:AddButtonClickListener(self.comFightButton,function()
			self:ShowDuelSelection()
		end)
	end

	-- 惩恶
	self.objPunish = self:FindChild(self.objInteractGroup2, "Punish")
	self.objPunishShader = self:FindChild(self.objInteractGroup2, "Punish/Shader")
	self.comPunishText = self:FindChildComponent(self.objInteractGroup2, "Punish/Text", DRCSRef_Type.Text)
	self.objPunishButton = self:FindChildComponent(self.objInteractGroup2,"Punish",DRCSRef_Type.Button)
	self.comPunishImg = self:FindChildComponent(self.objInteractGroup2,"Punish",DRCSRef_Type.Image)
	self.objPunishRefresh = self:FindChild(self.objInteractGroup2, "Punish/Refresh")
	if self.objPunishButton then
		self:AddButtonClickListener(self.objPunishButton,function()
			self:ClickPunish()
		end)
	end

    -- 右侧的各个界面
    self.abilityNode = self:FindChild(self._gameObject,"AbilityNode")
    self.nav_box = self:FindChild(self._gameObject,"TransformAdapt_node_right/ability_box/nav_box")
    self.tip_box = self:FindChild(self._gameObject,"TransformAdapt_node_right/ability_box/tip_box")
    self.tip_box:SetActive(false)
    self.comTipsButton = self:FindChildComponent(self.tip_box,"Button",l_DRCSRef_Type.Button)
    if self.comTipsButton then
        self:AddButtonClickListener(self.comTipsButton, function()
            if self.cur_tip_func then
                self:cur_tip_func()
            end
        end)
    end
    self.basic_box = self:FindChild(self._gameObject,"TransformAdapt_node_right/ability_box/basic_box")
    self.backpack_box = self:FindChild(self._gameObject,"TransformAdapt_node_right/ability_box/backpack_box")

    -- 获取等级控件
    self.objLevelScrollbar_Text = self:FindChildComponent(self.basic_box,"Level/Scrollbar/Value",l_DRCSRef_Type.Text)
    self.objLevel_Text = self:FindChildComponent(self.basic_box,"Level/Text",l_DRCSRef_Type.Text)
    self.objLevel_Scrollbar = self:FindChildComponent(self.basic_box,"Level/Scrollbar",l_DRCSRef_Type.Scrollbar)

    -- 获取生命值
    self.objLife_Text = self:FindChildComponent(self.basic_box,"Life/Scrollbar/Value",l_DRCSRef_Type.Text)
    self.objLife_Scrollbar = self:FindChildComponent(self.basic_box,"Life/Scrollbar",l_DRCSRef_Type.Scrollbar)

    -- 获取真气
    self.objSpirit_Text = self:FindChildComponent(self.basic_box,"Spirit/Scrollbar/Value",l_DRCSRef_Type.Text)
    self.objSpirit_Scrollbar = self:FindChildComponent(self.basic_box,"Spirit/Scrollbar","Scrollbar")

    -- 获取基础属性
    self.comActionTimeNumberText = self:FindChildComponent(self.basic_box,"Basic/ActionTime/Number",l_DRCSRef_Type.Text)
    self.objDefence_Number = self:FindChildComponent(self.basic_box,"Basic/defence/Number",l_DRCSRef_Type.Text)
    self.objSpeed_Number = self:FindChildComponent(self.basic_box,"Basic/speed/Number",l_DRCSRef_Type.Text)

    -- 获取精通
    local objMaster = self:FindChild(self.basic_box,"Master")
    self.akMasterControlItem = {}
    for index = 1, 8 do
        local ui_child = self:FindChild(objMaster,tostring(index))
        local textLabel = self:FindChildComponent(ui_child,"Label",l_DRCSRef_Type.Text)
        local textValue = self:FindChildComponent(ui_child,"Value",l_DRCSRef_Type.Text)
        self.akMasterControlItem[index] = {["textLabel"] = textLabel,["textValue"] = textValue }
    end

    self.Increase_Number = self:FindChildComponent(self.basic_box,"Increase/Number",l_DRCSRef_Type.Text)
    self.Increase_Value = self:FindChildComponent(self.basic_box,"Increase/Value",l_DRCSRef_Type.Text)
    self.com_btn_Increase_Tips = self:FindChildComponent(self.basic_box, "Increase/Button", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.com_btn_Increase_Tips, function()
        self:OnClick_IncreaseTips_Button()
    end)

    -- 详细页签
    self.detail_box = self:FindChild(self._gameObject,"TransformAdapt_node_right/ability_box/detail_box")
    self.attack_box = self:FindChild(self.detail_box,"Viewport/Content/attack_box")
    self.defence_box = self:FindChild(self.detail_box,"Viewport/Content/defence_box")

    -- 主角页签
    self.round_box = self:FindChild(self._gameObject,"TransformAdapt_node_right/ability_box/round_box")
    self.difficulty_box = self:FindChild(self.round_box,"Viewport/Content/difficulty_box")
    self.round_gift_box = self:FindChild(self.round_box,"Viewport/Content/gift_box")
    self.qjbm_box = self:FindChild(self.round_box,"Viewport/Content/qjbm_box")
    self.statistics_box = self:FindChild(self.round_box,"Viewport/Content/statistics_box")

    self.objBackpackContent = self:FindChild(self.backpack_box, "Content")

    self.Toggle_basic = self:FindChildComponent(self.nav_box,"1",l_DRCSRef_Type.Toggle)
    self.Toggle_basic_Text = self:FindChildComponent(self.nav_box,"1/Text",l_DRCSRef_Type.Text)
    if self.Toggle_basic then
        -- 初始化
        self.Toggle_basic.isOn = true
        self.Toggle_basic_Text.color = l_DRCSRef.Color.white
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_basic()
                self.Toggle_basic_Text.color = l_DRCSRef.Color.white
                self.tip_box:SetActive(false)
                -- self.cur_tip_func = self.OnClick_Tips_Common
            else
                self.Toggle_basic_Text.color = l_DRCSRef.Color(0.2,0.2,0.2,1)
            end
        end
        self:AddToggleClickListener(self.Toggle_basic,fun)
    end

    self.eventButton = {}
    self.akPrimaryControlCom = {}
    --self.PrimaryControl
    local objPrimaryNode  = self:FindChild(self.basic_box,"Basic/Primary")
    self:InitTips(self.basic_box)
    for i = 1,#order_martial_atk_attr do
        local attr = order_martial_atk_attr[i]
        local ui_child = self:FindChild(objPrimaryNode,tostring(i))
        local textLabel = self:FindChildComponent(ui_child,"Label",l_DRCSRef_Type.Text)
        local valueLabel = self:FindChildComponent(ui_child,"Value",l_DRCSRef_Type.Text)
        self.akPrimaryControlCom[i] = {["textLabel"] = textLabel, ["textValue"] = valueLabel}
    end

    self.Toggle_detail = self:FindChildComponent(self.nav_box,"2",l_DRCSRef_Type.Toggle)
    self.Toggle_detail_Text = self:FindChildComponent(self.nav_box,"2/Text",l_DRCSRef_Type.Text)
    if self.Toggle_detail then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_detail()
                self.Toggle_detail_Text.color = l_DRCSRef.Color.white
                self.tip_box:SetActive(true)
                self.cur_tip_func = self.OnClick_Tips_Detail
            else
                self.Toggle_detail_Text.color = l_DRCSRef.Color(0.2,0.2,0.2,1)
            end
        end
        self:AddToggleClickListener(self.Toggle_detail,fun)
    end

    self.Toggle_round = self:FindChildComponent(self.nav_box,"3",l_DRCSRef_Type.Toggle)
    self.Toggle_round_Text = self:FindChildComponent(self.nav_box,"3/Text",l_DRCSRef_Type.Text)
    if self.Toggle_round then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_round()
                self.Toggle_round_Text.color = l_DRCSRef.Color.white
                self.tip_box:SetActive(false)
                self.cur_tip_func = nil
            else
                self.Toggle_round_Text.color = l_DRCSRef.Color(0.2,0.2,0.2,1)
            end
        end
        self:AddToggleClickListener(self.Toggle_round,fun)
    end

    self.Toggle_backpack2 = self:FindChildComponent(self.nav_box,"4",l_DRCSRef_Type.Toggle)
    self.Toggle_backpack2_Text = self:FindChildComponent(self.nav_box,"4/Text",l_DRCSRef_Type.Text)
    if self.Toggle_backpack2 then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_backpack2()
                self.Toggle_backpack2_Text.color = l_DRCSRef.Color.white
                self.tip_box:SetActive(false)
                self.cur_tip_func = nil                
            else
                self.Toggle_backpack2_Text.color = l_DRCSRef.Color(0.2,0.2,0.2,1)
            end
        end
        self:AddToggleClickListener(self.Toggle_backpack2,fun)
    end
end

function CharacterUI:InitEquipNode()
    -- 装备部分
    self.role_equip_box = self:FindChild(self._gameObject,"role_equip_node")
    self.role_equip_box:SetActive(true)
    self.comMain_Name = self:FindChildComponent(self.role_equip_box, "title_box/Name",l_DRCSRef_Type.Text)
    self.comMain_Title = self:FindChildComponent(self.role_equip_box, "title_box/Title",l_DRCSRef_Type.Text)
    self.objButton = self:FindChildComponent(self.role_equip_box, "Button", "Empty4Raycast")
    local fun = function()
        self:PlayerSpineAni();
    end
    AddEventTrigger(self.objButton,fun)

    self.roleSpine = self:FindChild(self.role_equip_box, "Spine")
    self.spineRoleUINew = SpineRoleUINew.new(false,false)
    self.spineRoleUINew:SetDefaultScale(80*2/3)
    self.spineRoleUINew:SetGameObject(self.role_equip_box,self.roleSpine,false)
    self.icon_box = self:FindChild(self.role_equip_box, "icon_box")
    self.equipSlotNodes = {}  -- 所有装备槽的节点
    self.equipIconItemUI = {}  -- 所有装备槽对应的ItemIconUI
    for equipType = 1, REI_NUMS - 1 do
        local objIconParent = self:FindChild(self.icon_box, tostring(equipType))
        if objIconParent then
            local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI,objIconParent.transform)
            kItem:ResetAnchors()
            kItem.transform.localScale= DRCSRef.Vec3(2/3,2/3,2/3)
            self.equipSlotNodes[equipType] = objIconParent
            self.equipIconItemUI[equipType] = kItem
            self:AddEquipItemListener(kItem)
        end
    end
    self:checkEquipSlotLockState()  -- 检查装备槽的锁定情况
    self.oneClickEquipBtn = self:FindChild(self.role_equip_box, "one_click_equip")
    self.btnAutoEquip = self.oneClickEquipBtn:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnAutoEquip, function()
        self:AutoEquip()
    end)
    local btnAutoEquipTip = self:FindChildComponent(self.role_equip_box, "Tips", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnAutoEquipTip, function()
        self:ShowAutoEquipTip()
    end)
end

-- 设置角色spine显示
function CharacterUI:SetRoleSpineShow(bActive)
    if  self.Toggle_backpack.isOn ~= true and bActive == true then --不是物品切页的时候 不让显示spine

    else
        self.spineRoleUINew:SetActive(bActive ~= false)
    end
    -- self.roleSpine:SetActive(bActive ~= false)
end

-- [todo] 切换队友，需要刷新界面
function CharacterUI:SetSelectRoleIndex(index, autoSelect)
    local info = nil
    self:CloseAddPointTips()
	if GetGameState() == -1 then
		info = globalDataPool:getData('PlatTeamInfo') or {}
	else
		info = globalDataPool:getData("MainRoleInfo") or {}
    end

    local teammates = RoleDataManager:GetInstance():GetRoleTeammates()

    if autoSelect then
        if index == nil then
            index = 0
        elseif index > #teammates then
            index = #teammates
        end
    end

    local selectid = teammates[index]
    if selectid then
        if self.selectRole ~= selectid then
            -- 清空加点
            self.array_attr_due_to_point = {}
            self.isKeepPoint = nil
            self:SetSelectRole(selectid)
            self:RefreshUI()
            self.selectIndex = index
        end
    end
end

function CharacterUI:SetSelectRole(roleID)
    RoleDataManager:GetInstance():SetCurSelectRole(roleID)
    self.lastSelectRole = self.selectRole
    self.selectRole = roleID
    self:UpdateRelationTag()
    self:UpdateModelID()
end

function CharacterUI:GetSelectRole()
    return self.selectRole
end

function CharacterUI:UpdateModelID()
    local l_roleDataMgr = RoleDataManager:GetInstance()
    local iRoleTypeId = l_roleDataMgr:GetRoleTypeID(self.selectRole)
    local dbRoleData = l_roleDataMgr:GetRoleTypeDataByTypeID(iRoleTypeId)
    self.rolemodelid = dbRoleData.ArtID
end

-- [todo] 临时写法，后期优化
function CharacterUI:SetIndex(index)
    if index == 1 then
        self.Toggle_ability.isOn = true
        self.Toggle_ability:Select()
        self:SetSignIndex(1)
    elseif index == 2 then
        self.Toggle_backpack.isOn = true
        -- self.Toggle_backpack:Select()
        self:OnClick_Toggle_backpack()
        self:SetSignIndex(2)
    end
end

function CharacterUI:SetSignIndex(index)
    self.signIndex = index
end

function CharacterUI:GetSignIndex()
    return self.signIndex
end

function CharacterUI:OnClick_Button_Point(attr,isAdd)
    if isAdd then
        -- 如果点的是加，减少剩余加点，存入属性↑
        self.uiRemainAttrPoint = self.uiRemainAttrPoint - 1
    else
        -- 如果点的是减，增加剩余加点，存数属性↓
        self.uiRemainAttrPoint = self.uiRemainAttrPoint + 1
    end
    -- 刷新剩余点数 一级属性 和 加点按钮
    self:CalculatePointChanges(attr, isAdd)
    self.isKeepPoint = true
    self:RefreshAbility()
    self:RefreshPoint()

    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if (not roleData) then
        return
    end
    local iCurValue = roleData:GetAttr(attr) or 0
end

-- 根据加点，组装属性叠加的数组
function CharacterUI:CalculatePointChanges(attr, isAdd)
    local TB_AttrTrans = TableDataManager:GetInstance():GetTable("AttrTrans")
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    for k, v in pairs(TB_AttrTrans) do
        if v.OriAttr == attr then
            for i = 1, 5 do
                local type = v['ConvertAttr'..i]
                local value = v['ConvertValue' .. i]

                if type ~= AttrType.ATTR_NULL then

                    local addVal = self.array_attr_due_to_point[type] or 0
                    if type == AttrType.ATTR_MAXHP then
                        local BattleFactor = TableDataManager:GetInstance():GetTableData("BattleFactor",roleData and roleData.uiLevel or 1)
                        value = BattleFactor and  (BattleFactor.physique_hp * 10000) or value
                    end
                    if isAdd then
                        addVal = addVal + value / v['Value']
                    else
                        addVal = addVal - value / v['Value']
                    end
                    self.array_attr_due_to_point[type] = addVal
                end
            end
            break
        end
    end
end

-- 初始化属性点
function CharacterUI:InitPoint()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)

    if not self.isKeepPoint then        -- 清空属性
        if roleData then
            self.uiRemainAttrPoint = roleData.uiRemainAttrPoint or 0
        else
            dprint("InitPoint roleData is nil : "..tostring(self.selectRole))
        end
    else
        self.isKeepPoint = nil
    end

    if roleData then
        self.uiRemainAttrPoint = roleData.uiRemainAttrPoint or 0
    else
        dprint("InitPoint roleData is nil : "..tostring(self.selectRole))
    end

    self:RefreshPoint()
end

function CharacterUI:AttrPointerDown(attr, isAdd)
    self:OnClick_Button_Point(attr, isAdd)
    if not self.iAddPointTimer then
        self.iAddPointTimer = {}
    end
    self.iAddPointTimer[attr] = self:AddTimer(500,function()
        self:LongPressUpdate(attr, isAdd, 150)
    end)
end

function CharacterUI:AttrPointerUp(attr, isAdd)
    if self.iAddPointTimer and self.iAddPointTimer[attr] then
        self:RemoveTimer(self.iAddPointTimer[attr])
        self.iAddPointTimer[attr] = nil
    end
end

-- 逻辑：
-- 取消 OnClick 的监听
-- 按下去的时候，触发 PointDown，先立刻加/减一点
-- 然后等待一段时间，开始 SetTimer 连续加点

function CharacterUI:LongPressUpdate(attr, isAdd, delayTime)
    self.iAddPointTimer[attr] = self:AddTimer(delayTime,function()
        -- 判断条件
        if self.uiRemainAttrPoint <= 0 then return end
        self:OnClick_Button_Point(attr, isAdd)
        delayTime = (delayTime > 50) and (delayTime - 5) or delayTime
        self:LongPressUpdate(attr, isAdd, delayTime)
    end)
end

function CharacterUI:RefreshPoint()
    -- 设置一级属性
    local index = 1
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if (not roleData) then
        return
    end
    for _, attrType in ipairs(order_martial_atk_attr) do
        local comData = self.akPrimaryControlCom[index]
        if comData then
            comData["textLabel"].text = l_attrTypeToAttrName[attrType]

            if not roleData.GetAttr then
                return
            end

            local iCurValue = roleData:GetAttr(attrType) or 0
            local iMaxValue = RoleDataManager:GetInstance():GetCurDiffValueLimit('MartialAttackMax') or 0
            local strText = self:getTranslate(attrType, iCurValue)
            if iCurValue >= iMaxValue then
                strText = strText .. "<color=#C53926>(限)</color>"
            end
            comData["textValue"].text = strText
        end
        index = index + 1
    end
end

function CharacterUI:InitTips(basic_box)
    self.tips_AddPoint = self:FindChild(basic_box,"tips")
    self.tips_canvasTips = self.tips_AddPoint:GetComponent(l_DRCSRef_Type.CanvasGroup)
    self.tips_text =  self:FindChildComponent(self.tips_AddPoint,"Text",l_DRCSRef_Type.Text)
    self.tips_canvasTips.alpha = 0
end

function CharacterUI:ShowAddPointTips()
    self.tips_canvasTips:DR_DOCanvasGroupFade(self.tips_canvasTips.alpha,1,0.3)
end

function CharacterUI:RefreshAddPointTips(iPoint,Vec2localPos)
    self.tips_AddPoint:SetActive(true)
    self.tips_AddPoint.transform:GetComponent(l_DRCSRef_Type.RectTransform):SetTransAnchoredPosition(Vec2localPos.x, Vec2localPos.y)

    self.tips_text.text = iPoint
    self:ShowAddPointTips()
    if self.timer_AddPonitTips == nil then
        self.timer_AddPonitTips = self:AddTimer(500,function()
            self:CloseAddPointTips()
        end)
    else
        self:RemoveTimer(self.timer_AddPonitTips)
        self.timer_AddPonitTips = self:AddTimer(2000,function()
            self:CloseAddPointTips()
        end)
    end
end

function CharacterUI:CloseAddPointTips()
    if self.tips_canvasTips then
        self.tips_canvasTips:DR_DOCanvasGroupFade(self.tips_canvasTips.alpha,0,0.3)
    end
end

function CharacterUI:RefreshAbility()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if roleData and roleData.uiLevel then
        local int_lv = roleData.uiLevel
        self.objLevel_Text.text = string.format('%d级', int_lv)
        local TB_RoleLevel = TableDataManager:GetInstance():GetTable("RoleLevel")
        if TB_RoleLevel[int_lv] then
            local v = TB_RoleLevel[int_lv]
            local int_exp_now = roleData.uiExp
            self.objLevelScrollbar_Text.text = string.format("%d/%d", int_exp_now, v.Exp)
            self.objLevel_Scrollbar.size = int_exp_now / v.Exp
        end
        local int_hp_now = roleData.uiHP
        local int_hp_max = roleData:GetAttr(AttrType.ATTR_MAXHP)
        -- 生命值存在一个难度的上限
        local iDiffLifeLimit = RoleDataManager:GetInstance():GetCurDiffValueLimit('LifeMax') or 0
        local strLifeLimit = ""
        if int_hp_max >= iDiffLifeLimit then
            strLifeLimit = "<color=#FFE045>(限)</color>"
        end
        local hp_text = string.format("%d/%d%s", int_hp_now, int_hp_max, strLifeLimit)
        local hp_val = toint(self.array_attr_due_to_point[AttrType.ATTR_MAXHP]) or 0
        if hp_val > 0 then
            local hp_val_str = string.format(" %d/%d", hp_val, hp_val)
            hp_text = hp_text .. getUIBasedText('lightgreen', hp_val_str)
        end
        self.objLife_Text.text = hp_text
        self.objLife_Scrollbar.size = int_hp_now / int_hp_max

        local int_mp_now = roleData.uiMP
        local int_mp_max = roleData:GetAttr(AttrType.ATTR_MAXMP)
        -- 真气值存在一个难度的上限
        local iDiffMPLimit = RoleDataManager:GetInstance():GetCurDiffValueLimit('MPMax') or 0
        local strMPLimit = ""
        if int_mp_max >= iDiffMPLimit then
            strMPLimit = "<color=#FFE045>(限)</color>"
        end
        local mp_text = string.format("%d/%d%s", int_mp_now, int_mp_max, strMPLimit)
        local mp_val = toint(self.array_attr_due_to_point[AttrType.ATTR_MAXMP]) or 0
        if mp_val > 0 then
            local mp_val_str = string.format(" %d/%d", mp_val, mp_val)
            mp_text = mp_text .. getUIBasedText('lightgreen', mp_val_str)
        end
        self.objSpirit_Text.text = mp_text
        self.objSpirit_Scrollbar.size = int_mp_now / int_mp_max

        -- 设置精通属性
        local index = 1
        for k, v in pairs(order_master) do
            local akItem = self.akMasterControlItem[index]
            akItem["textLabel"].text = JingTongAttrs[v]
            local iCurValue = roleData:GetAttr(v) or 0
            local iMaxValue = RoleDataManager:GetInstance():GetCurDiffValueLimit('JingtongMax') or 0
            local strText = self:getTranslate(v, iCurValue)
            if iCurValue >= iMaxValue then
                strText = strText .. "<color=#C53926>(限)</color>"
            end
            akItem["textValue"].text = strText
            index = index + 1
        end

        -- 设置基础属性
        self.comActionTimeNumberText.text = string.format('%.2f', RoleDataManager:GetInstance():GetInitialActionTime(self.selectRole))
        -- 速度值有难度指定速度值上限
        local iCurValue = roleData:GetAttr(AttrType.ATTR_SUDUZHI) or 0
        local iMaxValue = RoleDataManager:GetInstance():GetCurDiffValueLimit('SpeedMax') or 0
        local strText = self:getTranslate(AttrType.ATTR_SUDUZHI, iCurValue)
        if iCurValue >= iMaxValue then
            strText = strText .. "<color=#C53926>(限)</color>"
        end
        self.objSpeed_Number.text = strText
        -- 防御拥有难度指定防御上限
        local iCurValue = roleData:GetAttr(AttrType.ATTR_DEF) or 0
        local iMaxValue = RoleDataManager:GetInstance():GetCurDiffValueLimit('DefenseMax') or 0
        local strText = self:getTranslate(AttrType.ATTR_DEF, iCurValue)
        if iCurValue >= iMaxValue then
            strText = strText .. "<color=#C53926>(限)</color>"
        end
        if self.objDefence_Number and tonumber(strText) then
            self.objDefence_Number.text = math.floor(tonumber(strText) * (1 + roleData:GetAttr(AttrType.ATTR_FANGYUTISHENGLV) / 10000) + 0.5)
        elseif self.objDefence_Number then
            self.objDefence_Number.text = strText
        end

        -- 设置进攻属性
        self:RemoveAllChildToPool(self.attack_box.transform)
        for k, v in pairs(array_attack) do
            local ekey, strname = next(v)
            self.cache_zero_value = false
            local str_value = self:getTranslate(ekey, roleData:GetAttr(ekey),nil,strname,roleData)
            if self.cache_zero_value then
                local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080", self.attack_box)
                local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
                obj_Name.text = strname
                local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)
                obj_Value.text = str_value
            end
        end

        -- 设置防御属性
        self:RemoveAllChildToPool(self.defence_box.transform)
        for k, v in pairs(array_defence) do
            local ekey, strname = next(v)
            self.cache_zero_value = false
            local str_value = self:getTranslate(ekey, roleData:GetAttr(ekey),nil,strname,roleData)
            if self.cache_zero_value then
                local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080", self.defence_box)
                local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
                obj_Name.text = strname
                local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)
                obj_Value.text = str_value
            end
        end

        -- 设置叠加等级
        if (self.Increase_Number ~= nil) and (roleData.uiOverlayLevel ~= nil) then
            local percetn_Attr = CardsUpgradeDataManager:GetInstance():GetGradeAddAttrPer(roleData.uiOverlayLevel) or 0
            percetn_Attr = percetn_Attr * 100
            self.Increase_Number.text = string.format("属性提升+%d%%", math.floor(percetn_Attr))
        end

        -- 设置卡片加成属性
        if self.Increase_Value ~= nil then
            if roleData.uiOverlayLevel then
                self.Increase_Value.text = string.format('(<color=#CE7909>+%d</color>)', roleData.uiOverlayLevel)
            end
        end

        if self.lastSelectRole ~= self.selectRole then
           self:ReturnUIClass() 
        end
        -- 设置队友背包属性
        if self.objBackpackContent and self.selectRole ~= self.iMainRoleID then
            local auiRoleItem = roleData:GetBagItems()
            local auiRoleItemCount = getTableSize(auiRoleItem)
            local auiRoleStaticItems = {}
            if roleData.GetBagStaticItems then
                auiRoleStaticItems = roleData:GetBagStaticItems()
            end
            local backpackContent = self.objBackpackContent.transform
            local showIndex = 1
            local normalItemDict = {}
            local itemMgr = ItemDataManager:GetInstance()
    
            for itemTypeID, num in pairs(auiRoleStaticItems) do
                if showIndex > 16 then
                    break
                end
                if not itemMgr:IsEquipItem(nil, itemTypeID) then
                    normalItemDict[itemTypeID] = normalItemDict[itemTypeID] or 0
                    normalItemDict[itemTypeID] = normalItemDict[itemTypeID] + num
                else
                    local tempItemData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
                    if tempItemData or MSDK_MODE == 0 then
                        local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,backpackContent)
                        kItem:UpdateUIWithItemTypeData(tempItemData)
                        if num > 1 then
                            kItem:SetItemNum(num)
                        end
                        table.insert(self.akEquipmentItemUIClass,kItem)
                        showIndex = showIndex + 1
                    end
                end
            end
            for index = 0, auiRoleItemCount - 1 do
                if showIndex > 16 then
                    break
                end
                local itemTypeID = itemMgr:GetItemTypeID(auiRoleItem[index])
                if itemTypeID and itemTypeID > 0 then
                    if not itemMgr:IsEquipItem(nil, itemTypeID) then
                        local num = itemMgr:GetItemNum(auiRoleItem[index])
                        if num then
                            normalItemDict[itemTypeID] = normalItemDict[itemTypeID] or 0
                            normalItemDict[itemTypeID] = normalItemDict[itemTypeID] + num
                        end
                    else
                        local tempItemData = itemMgr:GetItemTypeData(auiRoleItem[index])
                        if tempItemData or MSDK_MODE == 0 then
                            local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,backpackContent)
                            local num = 0
            
                            kItem:UpdateUIWithItemTypeData(tempItemData)
                            num = itemMgr:GetItemNum(auiRoleItem[index])
                
                            if num > 1 then
                                kItem:SetItemNum(num)
                            end
                            table.insert(self.akEquipmentItemUIClass,kItem)
                            showIndex = showIndex + 1
                        end
                    end
                end
    
            end
            
            -- 统一显示可堆叠物品
            for itemTypeID, itemNum in pairs(normalItemDict) do
                if showIndex > 16 then
                    break
                end
    
                local tempItemData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
                if tempItemData then
                    local maxNum = tempItemData.MaxNum
                    if maxNum == 0 then
                        maxNum = 99
                    end
    
                    while itemNum > 0 do
                        if showIndex > 16 then
                            break
                        end
    
                        local num = itemNum
                        if num > maxNum then
                            num = maxNum
                        end
                        itemNum = itemNum - num
    
                        local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,backpackContent)
    
                        kItem:UpdateUIWithItemTypeData(tempItemData)
        
                        if num > 1 then
                            kItem:SetItemNum(num)
                        end
                        table.insert(self.akEquipmentItemUIClass,kItem)
                        showIndex = showIndex + 1
                    end
                end
            end
        end

        self.Toggle_backpack2.gameObject:SetActive(self.selectRole ~= RoleDataManager:GetInstance():GetMainRoleID())

        local rtf = self.attack_box:GetComponent('RectTransform');
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf);

        rtf = self.defence_box:GetComponent('RectTransform');
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf);

         rtf = self.detail_box:GetComponent('RectTransform');
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf);
    end
end

function CharacterUI:RefreshUI()
    if GetGameState() == -1 then
        -- self.embattleBtn:SetActive(false)
        self.oneClickEquipBtn:SetActive(false)
    elseif FinalBattleDataManager:GetInstance():IsRunning() and GetGameState() == GS_MAZE then
        -- self.embattleBtn:SetActive(false)
        self.oneClickEquipBtn:SetActive(true)
    else
        -- self.embattleBtn:SetActive(true)
        self.oneClickEquipBtn:SetActive(true)
    end
    -- 掌门对决特殊处理（屏蔽情缘、设置主角）
    local showChain = true
    if PKManager:GetInstance():IsRunning() then
        showChain = false

        -- 必须退出观察模式
        RoleDataManager:GetInstance():SetObserveData(false)
        -- 掌门对决角色uiID一直在变，所以防止出现鸭子，先确定选择的uiID
        self.iMainRoleID = PKManager:GetInstance():GetMainRoleID()
        local selectRoleID = self.selectRole
        local roleData = RoleDataManager:GetInstance():GetRoleData(selectRoleID)
        if not roleData then
            selectRoleID = self.iMainRoleID
        end

        PKManager:GetInstance():UpdateRole(selectRoleID)
        self:SetSelectRole(selectRoleID)
    end
    if self.AI_mode then
        showChain = false
    end
    self.Toggle_chain.gameObject:SetActive(showChain)

    self.bRefreshGift  = nil
    self.bReFreshChain = nil
    self.bRefreshMartial = nil
    self.bRefreshAbility = nil
    self.bRefreshBackPack = nil
    --如果队友离队 则显示主角
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if GetGameState() ~= -1 then
        local isTeammate = RoleDataManager:GetInstance():IsRoleInTeam(self.selectRole)
        if not roleData or not isTeammate then
            local mainRoleData = RoleDataManager:GetInstance():GetRoleData(self.iMainRoleID)
            local mainRoleIsTeammate = RoleDataManager:GetInstance():GetRoleData(self.iMainRoleID)

            if mainRoleData and mainRoleIsTeammate then
                self:SetSelectRole(self.iMainRoleID)
                self.TeamListUICom:RefreshUI(nil,0)
            end
        end
    end

    self:RefreshMainRole()
    if self.Toggle_ability and self.Toggle_ability.isOn then
        self:InitPoint()
        self:RefreshAbility()
        self:RefreshCG()
        self.bRefreshAbility = true
    end


    if self.Toggle_backpack and self.Toggle_backpack.isOn then
        self.bRefreshBackPack = true
        self:RefreshSpine()
        self:RefreshEquipItem()
        self:RefreshTitleName()
    end

    if self.Toggle_martial and self.Toggle_martial.isOn then
        self.MartialUICom:UpdateMartialByRole(self.selectRole)
        self.bRefreshMartial = true
    end

    -- self.RoleEmbattleUINewCom:RefreshUI({bShowWheelWar = false})
    -- if self.Toggle_embattle and self.Toggle_embattle.isOn then
    --     self.MartialUICom:UpdateMartialByRole(self.selectRole)
    --     self.bRefreshMartial = true
    -- end


    if self.Toggle_gift and self.Toggle_gift.isOn then
        self:RefreshGift()
        self.bRefreshGift  = true
    end

    if self.Toggle_chain and self.Toggle_chain.isOn then
        self:RefreshWishTask()
        self:UpdateRoleChain()
        self:UpdateCityDispositionChain()
        self:UpdateClanDispositionChain()
        self.bReFreshChain = true
    end

    if roleData ~= nil then
        self.TeamListUICom:SetSelectRoleID(self.selectRole)
        self.TeamListUICom:RefreshUI()
    end
end

-- 检查装备格锁定信息
function CharacterUI:checkEquipSlotLockState()
    if not self.equipSlotNodes then
        return
    end
    -- 检查第二神器格 , 与百宝书VIP开通状况相关联
    local equipType = REI_HORSE
    local objSlot = self.equipSlotNodes[equipType]
    if objSlot then
        local btnIcon = objSlot:GetComponent(l_DRCSRef_Type.Button)
        if not btnIcon then return end
        self:RemoveButtonClickListener(btnIcon)
        local objLock = self:FindChild(objSlot, "Lock")
        objLock:SetActive(false)
        -- 获取百宝书壕侠状态
        -- local bIsVip = (TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() == true)
        -- objLock:SetActive(not bIsVip)
        -- self:RemoveButtonClickListener(btnIcon)
        -- if not bIsVip then
        --     self:AddButtonClickListener(btnIcon, function()
        --         local content = {
        --             ['title'] = "神器装备格",
        --             ['text'] = "神器装备格二需要激活壕侠百宝书后解锁, 是否前往百宝书界面?"
        --         }
        --         local callback = function()
        --             self.bDontRemoveWinBar = true
        --             TreasureBookDataManager:GetInstance():AddBookCloseCallBack(function()
        --                 local win = GetUIWindow("CharacterUI")
        --                 if win then
        --                     win:checkEquipSlotLockState()
        --                 end
        --             end)
        --             TreasureBookDataManager:GetInstance():DoEnterTreasureBook()
        --         end
        --         OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback})
        --     end)
        -- end
    end
    -- 其他装备槽的锁定情况...
end

-- Todo：打开界面 / 切换队友 / 主角信息更新时，刷新称号信息
function CharacterUI:RefreshTitleName()
    local ret = RoleDataManager:GetInstance():GetRoleTitleAndName(self.selectRole)
    local roleOverlayLevel = RoleDataManager:GetInstance():GetRoleOverlayLevel(self.selectRole)
    if roleOverlayLevel ~= 0 then
        self.comMain_Name.text = ret..' +' ..roleOverlayLevel
    else
        self.comMain_Name.text = ret
    end

    local roleClanID    -- 门派
    local roleStatus = RoleDataManager:GetInstance():GetRoleStatus(self.selectRole, false)  -- 身份
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)     -- 动态数据
    local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByID(self.selectRole)     -- 静态数据

    -- FIXME：这里的逻辑和楼下版本不一样了，先显示动态门派，再显示静态数据
    if roleData and roleData.uiClanID and roleData.uiClanID > 0 then
        roleClanID = roleData.uiClanID
    elseif roleTypeData and roleTypeData.Clan and roleTypeData.Clan > 0 then        -- 静态表里的数据都要注意 0 值判断
        roleClanID = roleTypeData.Clan
    end

    -- 优先显示门派，没有门派再显示身份
    if roleClanID and roleClanID > 0 then
        -- TODO：门派阶位等级、职位等级
        self.comMain_Title.gameObject:SetActive(true)
        local clanTypeData = ClanDataManager:GetInstance():GetClanTypeDataByTypeID(roleClanID)
        self.comMain_Title.text = GetLanguageByID(clanTypeData.NameID)
    elseif roleStatus and (roleStatus > 0)then
        self.comMain_Title.gameObject:SetActive(true)
        local languageID = GetEnumValueLanguageID('StatusType', roleStatus)
        if languageID and languageID > 0 then
            self.comMain_Title.text = GetLanguageByID(languageID)
        end
    else
        self.comMain_Title.gameObject:SetActive(false)
    end
end

-- 打开界面 / 主角信息更新时，刷新主角信息
function CharacterUI:RefreshMainRole(info)
    -- TODO: 掌门对决不走这个接口
    if PKManager:GetInstance():IsRunning() then
        return
    end

    info = info or globalDataPool:getData("MainRoleInfo")
    if info and info["MainRole"] then
        -- 设置周目信息
        self:RemoveAllChildToPool(self.difficulty_box.transform)
        for k, v in pairs(array_round) do
            local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080",self.difficulty_box)
            local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
            local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)

            if v == MainRoleData.MRD_WEEK_TOTALTIME then
                obj_Name.text = dtext(970) .. ':'
                obj_Value.text = getTimeString(globalDataPool:getData("CurScriptTime"), 4)
            else
                obj_Name.text = GetEnumText("MainRoleData", v)
                obj_Value.text = self:getTranslate(v, info["MainRole"][v], true)
            end
        end
        local rtf = self.difficulty_box:GetComponent(l_DRCSRef_Type.RectTransform)
        l_DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)

        -- 设置开局优势
        self:RemoveAllChildToPool(self.round_gift_box.transform)
        for k, v in pairs(array_gift) do
            local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080", self.round_gift_box)
            local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
            obj_Name.text = GetEnumText("MainRoleData", v) .. ':'
            local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)
            obj_Value.text = self:getTranslate(v, info["MainRole"][v], true)
        end
        rtf = self.round_gift_box:GetComponent(l_DRCSRef_Type.RectTransform)
        l_DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)

        -- 奇经八脉
        self:RemoveAllChildToPool(self.qjbm_box.transform)
        local mInfo = MeridiansDataManager:GetInstance():GetMeridiansInfo()
        if next(mInfo) then
            for k, v in ipairs(array_meridians) do
                if mInfo[v] then
                    local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080", self.qjbm_box)
                    local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
                    obj_Name.text = GetEnumText("AttrType", v) .. ':'
                    local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)
                    obj_Value.text = mInfo[v]
                end
            end
        else
            local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080", self.qjbm_box)
            local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
            obj_Name.text = '无'
            local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)
            obj_Value.text = ''
        end
        rtf = self.qjbm_box:GetComponent(l_DRCSRef_Type.RectTransform)
        l_DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)

        -- 本次游戏统计
        self:RemoveAllChildToPool(self.statistics_box.transform)
        local info = globalDataPool:getData("WeekRoundDataMap") or {};
        for k, v in pairs(STAT_LIST) do
            local ui_clone = self:LoadPrefabFromPool("Module/Role/Ability_Detail_box1080", self.statistics_box)
            local obj_Name = self:FindChildComponent(ui_clone,"Name",l_DRCSRef_Type.Text)
            obj_Name.text = v .. ':'
            local obj_Value = self:FindChildComponent(ui_clone,"Value",l_DRCSRef_Type.Text)
            obj_Value.text = info[k] or 0
        end
        rtf = self.statistics_box:GetComponent(l_DRCSRef_Type.RectTransform)
        l_DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)
    end
end

function CharacterUI:RefreshCG()
	self.akInteractData = {}
	self.akInteractData[InterctGroupData.Observe] = "观察"
	self.akInteractData[InterctGroupData.GiveGift] = "送礼"
	self.akInteractData[InterctGroupData.Fight] = "决斗"
    self.akInteractData[InterctGroupData.LearnMartial] = "请教"
    self.akInteractData[InterctGroupData.Beg] = "乞讨"
    self.akInteractData[InterctGroupData.Punish] = "惩恶"
    self.akInteractData[InterctGroupData.Inquiry] = "盘查"
    self.akInteractData[InterctGroupData.Compare] = "切磋"

    local l_roleDataMgr = RoleDataManager:GetInstance()
    -- TODO 捏脸13 立绘
    local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
    local roleTypeID = l_roleDataMgr:GetRoleTypeID(self.selectRole)
    local roleModelData = l_roleDataMgr:GetRoleArtDataByID(self.selectRole)
    -- 判断是否有捏脸数据
    local iRoleTypeID = roleTypeID
    local iMainRoleTypeID = l_roleDataMgr:GetMainRoleTypeID()
    local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
	if iRoleTypeID == iMainRoleTypeID then 
		iRoleTypeID = iMainRoleCreateRoleID
	end
    if iRoleTypeID == iMainRoleCreateRoleID and CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleTypeID) then
        self.comCGImage.gameObject:SetActive(false) 
        if self.objCreateCG then
            self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, iRoleTypeID, self.objCreateCGParent, self.objCreateCG)
            self.objCreateCG:SetActive(true)
        else
            self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, iRoleTypeID, self.objCreateCGParent)
        end
    else
        if self.objCreateCG then
            self.objCreateCG:SetActive(false)
        end
        if roleModelData and roleModelData["Drawing"] then
            self.comCGImage.gameObject:SetActive(true) 
            self:SetSpriteAsync(roleModelData["Drawing"],self.comCGImage)
        end
    end
    -- 名称和描述等
    local uiRank = RoleDataManager:GetInstance():GetRoleRank(self.selectRole)
    self.left_name.text = RoleDataManager:GetInstance():GetRoleName(self.selectRole)
    self.left_name.color = getRankColor(uiRank)
    local ret = RoleDataManager:GetInstance():GetRoleTitleStr(self.selectRole)
    self.left_nick.gameObject:SetActive(ret ~= nil)
    if ret then
        self.left_nick.text = ret
        self.left_nick.color = getRankColor(uiRank)
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    local typeData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleData.uiTypeID)
    local desc = GetLanguageByID(typeData.IntroduceID)
    if (not desc) or (desc == "") or (desc == "暂无介绍") then
        desc = "与你交好，决定陪你在这个江湖上闯荡一番的侠客，若是仔细培养日后说不定大有可为。"
    end
    self.left_desc.text = desc
    if self.left_nickedit then
        local UnlockPool = globalDataPool:getData("UnlockPool") or {}
        local unlockTitle = UnlockPool[PlayerInfoType.PIT_TITLE] or {}

        local auiTitles = {};
        for k, v in pairs(unlockTitle) do
            local tbTitle = TableDataManager:GetInstance():GetTableData('RoleTitle', v.dwTypeID & 0xffffff);
            if (tbTitle and tbTitle.IsTakenIn == TBoolean.BOOL_YES) or ((v.dwTypeID >> 24) & 0xff == GetCurScriptID()) then
                local cloneV = clone(v)
                cloneV.dwTypeID = v.dwTypeID & 0xffffff
                table.insert(auiTitles, cloneV);
            end
        end
        if getTableSize2(auiTitles) > 0 and self.selectRole == self.iMainRoleID then
            self.left_nickedit.gameObject:SetActive(true)
        else
            self.left_nickedit.gameObject:SetActive(false)
        end
    end
    self.objShowImage:SetActive(false)
    -- 主角不显示交互直接return
    if self.selectRole == self.iMainRoleID then
        self.objInteractGroup2:SetActive(false)
        return
    end
    self.objInteractGroup2:SetActive(true)

    -- 下方交互按钮
	-- 决斗
    local enabele = self:IsCanDuel() and RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_JueDou)
	self.comFightButton.interactable = enabele
	self.objFightShader:SetActive(not enabele)
    self.objFight:SetActive(enabele)

	-- 切磋
	local compareEnabele, des, needRefresh = self:IsCanCompare()
	self.objCompareButton.interactable = (needRefresh or compareEnabele)
	self.objCompareCompareShader:SetActive(not compareEnabele)
	self.objCompareRefresh:SetActive(needRefresh)
	if needRefresh then
		self.comCompareImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
        local str = des ~= "" and "<color=red>("..des..")</color>" or ""
		self.akInteractData[InterctGroupData.Compare] = "切磋"..str
	else
		self.comCompareImg.color = DRCSRef.Color(1,1,1,1)
        local str = des ~= "" and "<color=red>("..des..")</color>" or ""
		self.akInteractData[InterctGroupData.Compare] = "切磋"..str
    end

	-- 乞讨
	if (RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_QiTao) == true) then
		local begEnabele, des, needRefresh= self:IsCanBeg()
		self.objBegRefresh:SetActive(needRefresh)
		self.comBegButton.interactable = begEnabele or needRefresh
		self.objBegShader:SetActive(not (begEnabele or needRefresh))
		if needRefresh then
			self.comBegImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
            local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Beg] = "乞讨"..str
		else
			self.comBegImg.color = DRCSRef.Color(1,1,1,1)
            local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Beg] = "乞讨"..str
		end
	else
        self.objBeg:SetActive(false)
	end

	-- 盘查
	if self:IsInquiryUnlock() then
		local begEnabele, des, needRefresh= self:IsCanInquiry()
		self.objInquiryRefresh:SetActive(needRefresh)
		self.objInquiryButton.interactable = begEnabele or needRefresh
		self.objInquiryShader:SetActive(not (begEnabele or needRefresh))
		if needRefresh then
			self.comInquiryImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			--self.comInquiryText.text = ''
            local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Inquiry] = "盘查"..str
		else
			self.comInquiryImg.color = DRCSRef.Color(1,1,1,1)
			--self.comInquiryText.text = des
			local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Inquiry] = "盘查"..str
		end
	else
        self.objInquiry:SetActive(false)
	end

	-- 请教
    local needRefresh = not RoleDataManager:GetInstance():InteractAvailable(self.selectRole, NPCIT_STEAL_CONSULT)
    local resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()
    local des = UIConstStr["SelectUI_Left"] .. resDayStr .. '天'

    if needRefresh then
        local str = des and "<color=red>("..des..")</color>" or ""
        self.akInteractData[InterctGroupData.LearnMartial] = "请教"..str
    else
        self.akInteractData[InterctGroupData.LearnMartial] = "请教"
    end

    self.objLearnMartialRefresh:SetActive(needRefresh)

	-- 惩恶
	if RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_Punish) then
		local punishEnabele, des, needRefresh= self:IsCanPunish()
		self.objPunishButton.interactable = punishEnabele or needRefresh
		self.objPunishShader:SetActive(not (punishEnabele or needRefresh))
		self.objPunishRefresh:SetActive(needRefresh)
		if needRefresh then
			self.comPunishImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			self.akInteractData[InterctGroupData.Punish] = "惩恶"
		else
			self.comPunishImg.color = DRCSRef.Color(1,1,1,1)
			local str = des and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Punish] = "惩恶"..str
		end
	else
		self.objPunish:SetActive(false)
	end

    self:SetButtonHightState()
end

function CharacterUI:RefreshSpine()
    self.spineRoleUINew:SetRoleDataByUID(self.selectRole)
    self.spineRoleUINew:UpdateRoleSpine()

    --self.roleSpine.transform.localScale = self.roleSpine.transform.localScale * 80
end

function CharacterUI:RefreshEquipItem(refreshRoleID)
    if refreshRoleID ~= nil and refreshRoleID ~= self.selectRole  then
        return
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole) or RoleDataManager:GetInstance():GetMainRoleData()
    if not roleData then
        return
    end

    -- 始终隐藏暗器与医药装备位
    local mainRoleBelone = {REI_ANQI, REI_MEDICAL}
    local bIsMainRole = (self.selectRole == self.iMainRoleID)
    local objMainRoleBelone = nil
    for index, eType in ipairs(mainRoleBelone) do
        objMainRoleBelone = self:FindChild(self.icon_box, tostring(eType))
        if objMainRoleBelone then
            objMainRoleBelone:SetActive(false)
        end
    end

    local equipItemList = roleData.akEquipItem or {}
    local itemData = nil
    local itemMgr = ItemDataManager:GetInstance()
    for equipType = 1, REI_NUMS - 1 do
        local equipItemID = equipItemList[equipType]
        local itemIconUI = self.equipIconItemUI[equipType]
        if itemIconUI and equipItemID and equipItemID ~= 0 then
            itemData = itemMgr:GetItemData(equipItemID)
            if itemData then
                itemIconUI:SetActive(true)
                itemIconUI:UpdateUIWithItemInstData(itemData)
                itemIconUI:SetIntValue(equipItemID)
            else
                itemIconUI:SetActive(false)
            end
        elseif itemIconUI then
            itemIconUI:SetActive(false)
        end
    end
end

function CharacterUI:AddEquipItemListener(itemIconUI)
    local comButton = itemIconUI._gameObject:GetComponent(l_DRCSRef_Type.Button)
    itemIconUI:RemoveButtonClickListener(comButton)
    itemIconUI:AddButtonClickListener(comButton, function() self:OnClickEquipItem(itemIconUI:GetIntValue()) end)
end

function CharacterUI:OnClickEquipItem(itemID)
    local roleID = self.selectRole
    if not (roleID  and itemID) then
        return
    end
    local itemManager = ItemDataManager:GetInstance()
    local typeID = itemManager:GetItemTypeID(itemID)
    local itemData = itemManager:GetItemTypeDataByTypeID(typeID)
    local tips = TipsDataManager:GetInstance():GetItemTips(itemID, typeID)
    if GetGameState() == -1 then
        return
    end
    local btns = {}
    local bIsSecretBook = itemData.ItemType == ItemTypeDetail.ItemType_SecretBook
    if bIsSecretBook then
        -- 如果角色没有学会这门武学, 那么显示一个学习按钮, 点击可以直接学习得到一级该武学
        local uiMartialBaseID = itemData.MartialID or 0
        if uiMartialBaseID and (uiMartialBaseID > 0) then
        local martialInst = RoleDataManager:GetInstance():GetMartialInstByTypeID(roleID, uiMartialBaseID)
            if (not martialInst) then
                btns[#btns + 1] = {
                    ["name"] = "学习",
                    ['func'] = function()
                        local martialStaticData = MartialDataManager:GetInstance():GetMartialTypeDataByItemTypeID(typeID)
                        if getTableSize(martialStaticData.Exclusive) > 0 and martialStaticData.Exclusive[1] ~= RoleDataManager:GetInstance():GetRoleTypeID(self.selectRole) then
                            SystemUICall:GetInstance():Toast("无法学习他人的专属武学")
                            return  
                        end
                        local canUse, useCondDesc = itemManager:ItemUseCondition(itemID, typeID, false, true, true)
                        if not canUse then
                            SystemUICall:GetInstance():Toast("不满足学习条件")
                            return
                        end
                        SendRoleLearnSecretBookMartial(roleID, itemID)
                    end
                }
            end
        end
    end
    btns[#btns + 1] = {
        ["name"] = "卸下",
        ['func'] = function(iNum)
            -- TODO: 走掌门对决逻辑，等待重构
            if PKManager:GetInstance():IsRunning() then
                PKManager:GetInstance():RequestUnEquip(roleID, itemID)
                return
            end

            local iCurBackpackSize = RoleDataHelper.GetMainRoleBackpackSize() or 0
            if iCurBackpackSize >= self.backpackSizeLimit then
                SystemUICall:GetInstance():Toast("背包已满, 卸下失败, 请先清理背包")
                return
            end

            if bIsSecretBook then
                local kRoleData = RoleDataManager:GetInstance():GetRoleData(roleID)
                local uiMartialCount = RoleDataManager:GetInstance():GetRoleMartialCount(roleID, true)
                if uiMartialCount > kRoleData.uiMartialNum then
                    local strItemName = itemData.ItemName or ''
                    local strTips = '由于武学数量超过上限，脱下' .. strItemName .. '时，对应的武学将被遗忘，是否继续？'
                    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strTips, function()
                        SendUnequipItemCMD(roleID, itemID)
                    end})
                else
                    SendUnequipItemCMD(roleID, itemID)
                end
            else
                self:TryUnloadTeammateEquip(roleID, itemID)
            end

        end
    }
    -- TODO: 走掌门对决逻辑，等待重构，不写在赋值前面判断是因为怕污染现有逻辑代码，所以进行后处理
    if PKManager:GetInstance():IsRunning() and not PKManager:GetInstance():IsEquip(roleID, itemID) then
        table.remove(btns, #btns)
    end

    tips.buttons = btns
    OpenWindowImmediately("TipsPopUI", tips)
end

-- 卸下队友装备
function CharacterUI:TryUnloadTeammateEquip(uiRoleID, uiItemID)
    if (not uiRoleID) or (not uiItemID)
    or (uiRoleID == 0) or (uiItemID == 0) then
        return
    end
    local kItemMgr = ItemDataManager:GetInstance()
    local kInstItem = kItemMgr:GetItemDataInItemPool(uiItemID)
    if not kInstItem then
        return
    end
    local uiMainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    if (uiMainRoleID ~= uiRoleID)
    and (kInstItem.bBelongToMainRole ~= 1) then
        -- 分析卸下队友装备的前提条件
        local kPreCond = kItemMgr:GenUnloadRoleEquipPrecondition(kInstItem.uiTypeID or 0, uiRoleID)
        if kPreCond and (kPreCond.bCondTrue ~= true) then
            local strMsg = string.format("您不是该装备的拥有者，卸下%s的%s，需要与其好感度达到<color=#913E2B>%d</color>，否则好感度会下降<color=#913E2B>%d</color>。继续卸下装备吗？"
                , kPreCond.strRoleName or ""
                , kPreCond.strItemDesc or ""
                , kPreCond.uiFavorNeed or 0
                , kPreCond.uiFavorSub or 0
            )
            if kPreCond.bWillLeave == true then
                strMsg = strMsg .. string.format("\n卸下装备后，%s的<color=#913E2B>好感度将降至0及以下</color>，%s将会<color=#913E2B>离开队伍</color>", kPreCond.strRoleName or "", kPreCond.strRoleName or "")
            end
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, function()
                SendUnequipItemCMD(uiRoleID, uiItemID)
            end})
            return
        end
    end
    SendUnequipItemCMD(uiRoleID, uiItemID)
end
-------------天赋-------------
function CharacterUI:InitGift()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if (not roleData) then
        return
    end

    -- self.gift_point_box = self:FindChild(self.gift_box,"gift_point_box")
    -- if self.gift_point_box then
    --     local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    --     local value = self:FindChildComponent(self.gift_point_box, "Value", l_DRCSRef_Type.Text)
    --     local iUsedNum = roleData['uiGiftUsedNum'] or 0
    --     local iMaxNum = (roleData:GetAttr(AttrType.ATTR_WUXING) or 0) * 2
    --     local strColor = (iUsedNum <= iMaxNum) and "#2B2B2B" or "#913E2B"
    --     value.text = string.format("<color=%s>%s/%s</color>", strColor, tostring(iUsedNum), tostring(iMaxNum))
    -- end

    self.gift_nums = self:FindChild(self.gift_box,"label_adventure")
    if (self.gift_nums) then
        local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
        self.Comgift_nums = self:FindChildComponent(self.gift_nums, "Text", l_DRCSRef_Type.Text)
        local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
		local maxNum = RoleDataManager:GetInstance():GetGiftNumMax(self.selectRole)
        local curGiftNum = getTableSize(self.RoleAdvGift)
        local strColor = (curGiftNum <= maxNum) and "#2B2B2B" or "#913E2B"
        self.Comgift_nums.text = string.format("数量:<color=%s>%s/%s</color>", strColor, tostring(curGiftNum), tostring(maxNum))
    end

    self.SC_battle_gift = self:FindChild(self.gift_box,"SC_battle_gift")
    self.LoopScrollView_bat = self.SC_battle_gift:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
    if self.LoopScrollView_bat then
        local fun_bat = function(transform, idx)
			self:OnBatGiftScrollChanged(transform, idx)
        end
        self.LoopScrollView_bat:AddListener(fun_bat)
    end

    self.SC_adventure_gift = self:FindChild(self.gift_box,"SC_adventure_gift")
    self.LoopScrollView_adv = self.SC_adventure_gift:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
    if self.LoopScrollView_adv then
       local fun_Adv = function(transform, idx)
           self:OnAdvGiftScrollChanged(transform, idx)
       end
       self.LoopScrollView_adv:AddListener(fun_Adv)
   end

   self.Button_question = self:FindChildComponent(self.gift_box,"Button_question",l_DRCSRef_Type.Button)

   local fun_click = function(transform, idx)
        OpenWindowByQueue("GiftTipsUI")
   end
   self:AddButtonClickListener(self.Button_question, fun_click)

   self.Button_ForgetGift = self:FindChildComponent(self.gift_box, "Button_forget", l_DRCSRef_Type.Button)
   self:AddButtonClickListener(self.Button_ForgetGift, function()
        if CLOSE_EXPERIENCE_OPERATION then
            SystemUICall:GetInstance():Toast('体验版暂不开放')
            return
        else
            self:OpenForgetGiftUI()
        end
   end)

   self.Button_LearnGift = self:FindChildComponent(self.gift_box, "Button_learn", l_DRCSRef_Type.Button)
   self:AddButtonClickListener(self.Button_LearnGift, function()
        if CLOSE_EXPERIENCE_OPERATION then
            SystemUICall:GetInstance():Toast('体验版暂不开放')
            return
        else
            self:OpenAddGiftUI()
        end
    end)

    local maxNum = RoleDataManager:GetInstance():GetGiftNumMax(self.selectRole) or 0
    local curGiftNum = getTableSize(self.RoleAdvGift or {})

    local canaddgift = (curGiftNum < maxNum) and (roleData.uiRemainGiftPoint > 0)
    img = self:FindChildComponent(self.gift_box,"Button_learn",l_DRCSRef_Type.Image)
    setUIGray(img, not canaddgift)

    --
    if GetGameState() == -1 then
        self.Button_LearnGift.interactable = false
        self.Button_ForgetGift.interactable = false
    else
        self.Button_LearnGift.interactable = true
        self.Button_ForgetGift.interactable = true
    end

	-- TODO: 掌门对决，特殊处理
	if PKManager:GetInstance():IsRunning() then
        self.Button_LearnGift.interactable = false
        self.Button_ForgetGift.interactable = false
	end
end

function CharacterUI:RefreshGift()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if (not roleData) then
        return
    end

    if (not roleData.GetAttr) then
        return
    end

    --刷新天赋点以及天赋值
    -- if self.gift_point_box then
    --     local value = self:FindChildComponent(self.gift_point_box, "Value", l_DRCSRef_Type.Text)
    --     local iUsedNum = roleData['uiGiftUsedNum'] or 0
    --     local iMaxNum = (roleData:GetAttr(AttrType.ATTR_WUXING) or 0) * 2
    --     local strColor = (iUsedNum <= iMaxNum) and "#2B2B2B" or "#913E2B"
    --     value.text = string.format("<color=%s>%s</color>/%s", strColor, tostring(iUsedNum), tostring(iMaxNum))
    -- end

    --刷新战斗天赋
    if self.LoopScrollView_bat then
        self.LoopScrollView_bat:ClearCells()
        self.RoleBatGift = 	GiftDataManager:GetInstance():GetStaticGift(roleData.uiID)
        if roleData.auiRoleGift then
            self.LoopScrollView_bat.totalCount = getTableSize(self.RoleBatGift)
            self.LoopScrollView_bat:RefillCells()
        end
    end

    -- 刷新冒险天赋
    if self.LoopScrollView_adv then
        self.LoopScrollView_adv:ClearCells()
        self.RoleAdvGift = GiftDataManager:GetInstance():GetDynamicGift(roleData.uiID) or {}
        if roleData.auiRoleGift then
            self.LoopScrollView_adv.totalCount = getTableSize(self.RoleAdvGift)
            self.LoopScrollView_adv:RefillCells()
        end
    end

    -- 刷新学习武学按钮
    img = self:FindChildComponent(self.gift_box,"Button_learn",l_DRCSRef_Type.Image)
    setUIGray(img, self:IsCanLearnMartial() == false)

    -- 刷新遗忘按钮
    local imgForget = self:FindChildComponent(self.gift_box,"Button_forget",l_DRCSRef_Type.Image)
    setUIGray(imgForget, self:IsCanForgetMartial() == false)

    -- 刷新數量
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
    local maxNum = RoleDataManager:GetInstance():GetGiftNumMax(self.selectRole)
    local curGiftNum = getTableSize(self.RoleAdvGift)
    if (self.Comgift_nums) then
        local strColor = (curGiftNum <= maxNum) and "#2B2B2B" or "#913E2B"
        self.Comgift_nums.text = string.format("数量:<color=%s>%s/%s</color>", strColor, tostring(curGiftNum), tostring(maxNum))
    end
end

-- 是否可以遗忘武学
function CharacterUI:IsCanForgetMartial()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if (not roleData) then
        return false
    end
    local allRoleDynamicGift = GiftDataManager:GetInstance():GetDynamicGift(roleData.uiID)
    if (not allRoleDynamicGift) then
        return false
    end

    if (#allRoleDynamicGift == 0) then
        return false
    end

    return true
end

-- 是否可以学习武学
function CharacterUI:IsCanLearnMartial()
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if (not roleData) then
        return false
    end

    -- 首先判断玩家是否已经学满了天赋
    local maxNum = RoleDataManager:GetInstance():GetGiftNumMax(self.selectRole)
    local curGiftNum = 0
    local allRoleDynamicGift = GiftDataManager:GetInstance():GetDynamicGift(roleData.uiID)
    if (allRoleDynamicGift and #allRoleDynamicGift > 0) then
        curGiftNum = #allRoleDynamicGift
    end

    if (curGiftNum >= maxNum) then
        return false
    end

    if (not roleData.uiRemainGiftPoint or roleData.uiRemainGiftPoint == 0) then
        return false
    end

    return true
end

function CharacterUI:OpenAddGiftUI()
    -- dprint("打开天赋学习面板")
    if (self:IsCanLearnMartial() == false) then
        SystemUICall:GetInstance():Toast("当前不存在可以学习的天赋")
        return
    end

    SendRandomGiftCMD(0, self.selectRole, 3)
    self.bDontRemoveWinBar = true
    OpenWindowByQueue("PickGiftUI",self.selectRole)
end

function CharacterUI:OpenForgetGiftUI()
    if (self:IsCanForgetMartial() == false) then
        SystemUICall:GetInstance():Toast("当前不存在可以遗忘的天赋")
        return
    end

    OpenWindowImmediately("ForgetMartialGiftUI",self.selectRole)
end

local function GetBuffText_LiQi()
    local contentText = nil
    local uiTaskTagTypeid = 130003
    local uiMingZhongTagTypeid = 130018
    local uiBaoJiShangHaiTagTypeid = 130017
    local iLayer = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid) or 0
    local iMingZhongVal = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiMingZhongTagTypeid) or 0
    local iBaoJiBeiLvVal = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiBaoJiShangHaiTagTypeid) or 0
    contentText = string.format('当前戾气 %.0f/100', iLayer)
    if iMingZhongVal == 0 and iBaoJiBeiLvVal == 0 then
        contentText = contentText.."\n无额外效果"
    end
    if iBaoJiBeiLvVal ~= 0 then
        contentText = contentText..string.format("\n暴击伤害倍数+%.0f%%", iBaoJiBeiLvVal / 100)
    end
    if iMingZhongVal ~= 0 then
        contentText = contentText..string.format("\n命中率-%.0f%%", iMingZhongVal / 100)
    end

    return contentText
end

local function GetBuffText_LiQiNew(roleID, baseText)
    local contentText = nil
    local uiTaskTagTypeid = 130003
    local iLayer = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid) or 0
    contentText = string.format('当前戾气 %.0f/100', iLayer)
    contentText = contentText.."\n"..baseText
    return contentText
end

local function GetBuffText_ShenMiZhenQi(giftID)
    local contentText = nil
    local uiStartTimeTagID = 130016
    local uiDurTimeTagID = 130045
    local iValue = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiStartTimeTagID) or 0
    local iDur = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiDurTimeTagID) or 0
    iValue = iValue + iDur
    local months = iValue // 3000

    if giftID == 2241 then
        if months <= 0 then
            contentText = "真气即将爆发"
        else
            contentText = string.format("修炼《无咎神功》饱受内伤折磨，修炼《无誉心法》无法根治，若不在江湖%.0f年%.0f月1日前解除会有性命之忧", months // 12 + 1, months % 12 + 1)
        end
    else
        if months <= 0 then
            contentText = "宇文珂注入我体内的神秘真气，即将爆发"
        else
            contentText = string.format("宇文珂注入我体内的神秘真气，若不在江湖%.0f年%.0f月1日前解除，恐有性命之虞", months // 12 + 1, months % 12 + 1)
        end
    end

    return contentText
end

local function GetBuffText_TaiJiYuanWu(roleID, baseText)
    local contentText = nil
    local uiCurExpTagTypeID = 130002
    local uiMaxExpTagTypeID = 130020
    local uiLevelTagTypeID = 130001

    local uiCurExp = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiCurExpTagTypeID) or 0
    local uiMaxExp = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiMaxExpTagTypeID) or 0
    local uiLevel = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiLevelTagTypeID) or 0

    if uiLevel == 0 then
        uiLevel = 1
    end

    if uiMaxExp ~= 0 then
        contentText = string.format("当前等级%.0f级（%.0f/%.0f）", uiLevel, uiCurExp, uiMaxExp)
    else
        contentText = string.format("当前等级%d级（满级）", uiLevel)
    end

    contentText = contentText.."\n"..baseText

    return contentText
end

local function GetBuffText_BingHuoCanShi(roleID, baseText)
    local evolutionItem = EvolutionDataManager:GetInstance():GetOneEvolutionByType(roleID, NET_BINGHUOCANSHI)
    local iCurDRTime = EvolutionDataManager:GetInstance():GetRivakeTime() or 0

    if evolutionItem == nil then
        return baseText
    end

    local overDRTime = evolutionItem.iParam2 or 0
    if overDRTime <= iCurDRTime then
        return baseText
    end

    local text = EvolutionDataManager:GetInstance():GetRivakeTimeYMDText(overDRTime - iCurDRTime, true)
    return baseText.."距离毒发还有"..text.."。"
end

local function GetBuffText_XiNeng(roleID, baseText)
    local absorbCommon = TableDataManager:GetInstance():GetTableData("AbsorbCommon", 1)
    local evolution = EvolutionDataManager:GetInstance():GetOneEvolutionByType(roleID, NET_ABSORBATTR)
    local exp = 0
    local attrType = 0
    local attrValue = 0

    if not absorbCommon then
        return baseText
    end

    if evolution then
        exp = evolution.iParam1
        attrType = evolution.iParam2
        attrValue = evolution.iParam3
    end

    local curLevelMaxExp = 0
    local curLevelExp = exp
    local level = 0
    for index, needExp in ipairs(absorbCommon.LayersExp) do
        if exp >= needExp then
            level = level + 1
            curLevelExp = exp - needExp
        else
            break
        end
    end
    if level < #absorbCommon.LayersExp then
        curLevelMaxExp = absorbCommon.LayersExp[level + 1] - absorbCommon.LayersExp[level]
    end


    local expMax = absorbCommon.MaxExp
    local absorbPrecent = math.floor(absorbCommon.LayersAbsorbAttr[level] / 100)

    local abosrbAttrText = "当前属性：无"
    if attrType > 0 then
        local isMax = false
        local attrConfigs = TableDataManager:GetInstance():GetTable("AbsorbAttrConfig") or {}
        for _, attrConfig in pairs(attrConfigs) do
            if attrConfig.AttrType == attrType then
                isMax = attrValue >= attrConfig.RoleAttrLimit
                break
            end
        end

        local attrTypeText = GetEnumText("AttrType", attrType)
        abosrbAttrText = string.format("当前属性：%s+%d", attrTypeText, attrValue)
        if isMax then
            abosrbAttrText = abosrbAttrText.."<color=#C53926>(限)</color>"
        end
    end

    local curExpDesc = "精通已达到最大值"
    if curLevelMaxExp > curLevelExp then
        curExpDesc = string.format("当前精通%d/%d", curLevelExp, curLevelMaxExp)
    end

    return string.format("%s\n吸收对方任一属性的%d%%来增强自己\n%s",
        curExpDesc, absorbPrecent, abosrbAttrText)
end

-- 峨嵋戾气
local EMEILIQI_GIFTS = {
    [2090] = true,
    [2088] = true,
    [2094] = true,
    [2093] = true,
    [2092] = true,
    [2091] = true,
}
-- 太极圆武功
local TAIJIYUANWU_GIFTS = {
    [1790] = true,
    [1791] = true,
    [1793] = true,
    [1792] = true,
    [1796] = true,
    [1795] = true,
    [1794] = true,
}
-- 冰火蚕尸毒
local BINGHUOCANSHI_GIFTS = {
    [1675] = true,
    [1676] = true,
    [1677] = true,
    [1678] = true,
    [1679] = true
}
-- 吸能
local XINENG_GIFTS = {
    [2198] = true,
    [2199] = true,
    [2200] = true,
    [2201] = true,
    [2202] = true,
    [2203] = true,
    [2204] = true,
}
-- 神秘真气
local SHENMIZHENQI_GIFTS = {
    [960] = true,
    [2241] = true,
}
--战斗天赋
function CharacterUI:OnBatGiftScrollChanged(transform, idx)
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
	self.objChild_Name = self:FindChildComponent(transform.gameObject, "Up/Name", l_DRCSRef_Type.Text)
    self.objChild_Content = self:FindChildComponent(transform.gameObject, "Content", l_DRCSRef_Type.Text)
    self.objExc = self:FindChild(transform.gameObject, "Up/exc")
    self.objHerit = self:FindChild(transform.gameObject, "Up/herit")
    local _Gift = self.RoleBatGift[idx + 1]
    if(_Gift ~= nil) then
        self.objChild_Name.text = GetLanguagePreset(_Gift.NameID,"天赋名".._Gift.NameID)
        --string.format('%s(%s)',GetLanguagePreset(_Gift.NameID,"天赋名".._Gift.NameID) ,_Gift.Cost)
        self.objChild_Name.color = getRankColor(_Gift.Rank)
        if _Gift.AttrType == AttrType.ATTR_NULL then
            self.objChild_Name.text = self.objChild_Name.text .. '(未实现)'
        end
        local exc = GiftDataManager:GetInstance():IfExclusiveGift(_Gift.BaseID)
        local canHerit = RoleDataManager:GetInstance():CanHeritGift(self.selectRole,_Gift.BaseID)
        self.objExc:SetActive(exc)
        self.objHerit:SetActive(canHerit)
        local contentText = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID) or ""
        if _Gift.BaseID == 794 then

            local rank = RankType.RT_DarkGolden --尝遍四海,所有人统一为暗金
            local eatFoodNum = roleData.uiEatFoodNum
            local maxEatFoodNum = GiftDataManager:GetInstance():GetEatFoodMaxNum(roleData)

            self.objChild_Name.color = getRankColor(rank)
            contentText = '使用食物次数限制 :　(' .. eatFoodNum .. '/' .. maxEatFoodNum ..')'
        elseif _Gift.BaseID == 1054 then -- 峨嵋戾气(弃用需兼容)
            contentText = GetBuffText_LiQi() or ""
        elseif SHENMIZHENQI_GIFTS[_Gift.BaseID] then -- 神秘真气
            contentText = GetBuffText_ShenMiZhenQi(_Gift.BaseID) or ""
        elseif _Gift.BaseID == 1143 then -- 太极圆武(弃用)
            contentText = ""
        elseif TAIJIYUANWU_GIFTS[_Gift.BaseID] then -- 太极圆武
            local baseText = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID) or ""
            contentText = GetBuffText_TaiJiYuanWu(self.selectRole, baseText)
        elseif _Gift.BaseID == 472 then   -- 冰火蚕尸毒
            local baseText = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID) or ""
            contentText = GetBuffText_BingHuoCanShi(self.selectRole, "")
        elseif _Gift.BaseID == 616 then -- 阴阳调和
            contentText = '当前内力阴性提升%s%%的伤害输出\n' ..
                          '当前内力阳性降低%s%%的承受伤害';
            local yinValue = roleData:GetAttr(AttrType.ATTR_NEILIYINXING) / 10;
            local yangValue = roleData:GetAttr(AttrType.ATTR_NEILIYANGXING) / 10;
            contentText = string.format(contentText, tostring(yinValue), tostring(yangValue))
        elseif EMEILIQI_GIFTS[_Gift.BaseID] then -- 峨嵋戾气
            local baseText = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID) or ""
            contentText = GetBuffText_LiQiNew(self.selectRole, baseText)
        elseif XINENG_GIFTS[_Gift.BaseID] then -- 吸能
            local baseText = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID) or ""
            contentText = GetBuffText_XiNeng(self.selectRole, baseText)
        end
        -- TODO : 这块代码和 GiftDataManager:GetDes 重合 可以整合在一起

        self.objChild_Content.text = contentText
    end
end

--冒险天赋
function CharacterUI:OnAdvGiftScrollChanged(transform, idx)
	-- 这里的监听最好只加一次，现在是临时处理，每次滚到了都加一下监听
	self.objChild_Name = self:FindChildComponent(transform.gameObject, "Up/Name", l_DRCSRef_Type.Text)
	self.objChild_Content = self:FindChildComponent(transform.gameObject, "Content", l_DRCSRef_Type.Text)
    self.objExc = self:FindChild(transform.gameObject, "Up/exc")
    self.objHerit = self:FindChild(transform.gameObject, "Up/herit")
    local _Gift = self.RoleAdvGift[idx + 1]
    if(_Gift ~= nil) then
        self.objChild_Name.text = GetLanguagePreset(_Gift.NameID,"天赋名".._Gift.NameID)-- .. '(' .. _Gift.Cost .. ')'
        self.objChild_Name.color = getRankColor(_Gift.Rank)
        local contentText = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID) or ""
        if _Gift.BaseID == 794 then
            contentText = '使用食物次数限制 :　(' .. (_Gift.EatFoodNum or 0) .. '/' .. (_Gift.MaxEatFoodNum or 0) ..')'
        end
        local exc = GiftDataManager:GetInstance():IfExclusiveGift(_Gift.BaseID)
        local show = RoleDataManager:GetInstance():CanHeritGift(self.selectRole,_Gift.BaseID)
        self.objExc:SetActive(exc)
        self.objHerit:SetActive(show)
        self.objChild_Content.text = contentText
    end
end

-------------星愿任务-------------
function CharacterUI:InitWishTasks()
    self.SC_adventure_wishTask = self:FindChild(self.chain_box,"SC_adventure_gift")
    self.LoopScrollView_wishTask = self.SC_adventure_wishTask:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
    self.Content_wishTask = self:FindChild(self.SC_adventure_wishTask,"Content")
    if self.LoopScrollView_wishTask then
		--  self.LoopScrollView_wishTask:ClearCells()		-- 清理child，暂时没用
        local fun_WishTask = function(transform, idx)
			self:OnWishTaskScrollChanged(transform, idx)
        end
        self.LoopScrollView_wishTask:AddListener(fun_WishTask)
    end
end

function CharacterUI:InitWishTaskUI(transform)
    self.obj_UnFinish_State = self:FindChild(transform.gameObject,"Content/UnFinish_State")
    self.obj_End_State = self:FindChild(transform.gameObject,"Content/End_State")
    self.com_ContentSizeFiter = transform:GetComponent(l_DRCSRef_Type.ContentSizeFitter)
    self.objChild_Text = self:FindChildComponent(transform.gameObject, "Content/UnFinish_State/Text", l_DRCSRef_Type.Text)
    self.objChild_BtnAddGift = self:FindChildComponent(transform.gameObject, "Content/UnFinish_State/element/Button_add_gift", l_DRCSRef_Type.Button)
    self.UnFinish = self:FindChild(transform.gameObject,"Content/UnFinish_State/element/UnFinish")

    self.rewardName_Text = self:FindChildComponent(transform.gameObject, "Content/End_State/rewardName", l_DRCSRef_Type.Text)
    self.End = self:FindChild(transform.gameObject,"Content/End_State/End")
end

--星愿任务
function CharacterUI:OnWishTaskScrollChanged(transform, idx)
	-- 这里的监听最好只加一次，现在是临时处理，每次滚到了都加一下监听
    self:InitWishTaskUI(transform)

    local tableDataManager = TableDataManager:GetInstance()
    if self.auiRoleWishTasks and self.auiRoleWishTasks[idx + 1] then
        local wishQuest = {}
        local wishtaskID =  self.auiRoleWishTasks[idx + 1]
        local wishTaskData = WishTaskDataManager:GetInstance():GetWishTaskData(wishtaskID)
        if wishTaskData then
            wishQuest.ID = wishTaskData.uiTypeID
            wishQuest.state = wishTaskData.uiState
        end
        local wishQuestBaseID = wishQuest.ID
        if wishQuestBaseID and wishQuestBaseID > 0 then
            local wishQuestBaseData = tableDataManager:GetTableData("RoleWishQuest", wishQuestBaseID)
            if wishQuestBaseData == nil then
                showError("心愿池不存在此ID:" .. wishQuest.ID)
                return
            end

            local des = ""
            local bFirstGet = wishTaskData.bFirstGet
            local uiChooseReward = wishTaskData.uiReward
            local uiRoleCard = wishTaskData.uiRoleCard

            local roleTypeID = wishTaskData.roleTypeID
            local roleCardItemBaseData = tableDataManager:GetTableData("Item", uiRoleCard)
            local cardName = ""
            if roleCardItemBaseData then
                cardName = roleCardItemBaseData.ItemName or ''
            end

            local uiLevel  = 0
            -- 普通的心魔挑战
            -- 灵云的心魔挑战
            -- 主角的心魔挑战
            if wishQuestBaseID == 8 or wishQuestBaseID == 151 or wishQuestBaseID == 209 then
                local uiRoleBaseID = 0
                local uiRank = 0
                if uiRoleBaseID == 209 and roleCardItemBaseData then
                    uiRoleBaseID = roleCardItemBaseData.FragmentRole
                else
                    uiRoleBaseID = self.roleData.uiTypeID
                end

                if self.roleData.uiID == RoleDataManager:GetInstance():GetMainRoleID() then
                    uiRoleBaseID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
                end

                if self.roleData then
                    uiRank = self.roleData.uiRank
                end
                local uiCardLevel = RoleDataManager:GetInstance():GetRoleOverlayLevel(self.roleData.uiID)
                uiLevel = WishTaskDataManager:GetInstance():GetInnerDemoLevel(uiCardLevel, uiRank, uiRoleBaseID)
                des = string.format("(挑战等级%d)\n",uiLevel)
                des = des..getSizeText(18,"奖励:")
                if bFirstGet == 0 then
                    if self.roleData and CardsUpgradeDataManager:GetInstance():GetRoleCardDataByRoleBaseID(uiRoleBaseID, true) then
                        -- 可获得 红色
                        des = des..getSizeText(18,getUIBasedText('red', string.format("%s(本难度未获得)", cardName)))
                    else
                        -- 无法获得 红色
                        des = des..getSizeText(18,getUIBasedText('red', string.format("(本角色暂无角色卡，无法获得)")))
                    end
                else
                    -- 已获得 黑色
                    des = des..getSizeText(18,getUIBasedText('black', string.format("%s(本难度已获得)", cardName)))
                end
                self.objChild_Text.text = GetLanguagePreset(wishQuestBaseData.NameID,"心愿名"..wishQuestBaseData.NameID)..des
            elseif  wishQuestBaseData.RewardID and next(wishQuestBaseData.RewardID) then
                for _, uiRewardID in pairs(wishQuestBaseData.RewardID) do
                     -- 特殊奖励
                    local _Reward = tableDataManager:GetTableData("RoleWishReward", uiRewardID)
                    if _Reward then
                        -- 天赋树
                        if _Reward.WishTreeID ~= nil and _Reward.WishTreeID > 0 then
                            local uiGrade = RoleDataManager:GetInstance():GetRoleOverlayLevel(self.roleData.uiID)
                            local giftID = CardsUpgradeDataManager.GetInstance():GetTreeGift(self.roleData.uiTypeID, uiGrade, _Reward.WishTreeID)
                            local giftData = GetTableData("Gift",giftID)
                            if giftData then
                                des = getSizeText(18, "奖励：天赋"..getRankBasedText(giftData.Rank,string.format("《%s》",GetLanguageByID(giftData.NameID)),true).. "加入心愿池")
                            end
                        elseif _Reward.GiftIDs and next(_Reward.GiftIDs) ~= nil then
                            for _, giftID in pairs(_Reward.GiftIDs) do
                                local giftData = GetTableData("Gift",giftID)
                                if giftData then
                                    des = getSizeText(18, "奖励：天赋"..getRankBasedText(giftData.Rank,string.format("《%s》",GetLanguageByID(giftData.NameID)),true).. "加入心愿池")
                                end
                            end
                        elseif _Reward.MartialIDs and next(_Reward.MartialIDs) ~= nil then
                            for _, martialID in pairs(_Reward.MartialIDs) do
                                local martialData = GetTableData("Martial",martialID)
                                if martialData then
                                    des =  getSizeText(18,"奖励：武学"..getRankBasedText(martialData.Rank,string.format("《%s》",GetLanguageByID(martialData.NameID)),true) .. "加入心愿池")
                                end
                            end
                        end
                    end
                end

                self.objChild_Text.text = GetLanguagePreset(wishQuestBaseData.NameID, "心愿名" .. wishQuestBaseData.NameID) .. "\n" .. des
            else
                self.objChild_Text.text = GetLanguagePreset(wishQuestBaseData.NameID, "心愿名" .. wishQuestBaseData.NameID) .. "\n"
            end

            if wishTaskData.uiState == RWTT_FINISH then
                -- 任务完成
                self.obj_UnFinish_State.gameObject:SetActive(true)
                self.obj_End_State.gameObject:SetActive(false)
                self.objChild_BtnAddGift.gameObject:SetActive(true)
                if self.objChild_BtnAddGift then
                    local fun_add = function()
                        if CLOSE_EXPERIENCE_OPERATION then
                            SystemUICall:GetInstance():Toast('体验版暂不开放')
                            return
                        else
                            self:OpenAddRewards(wishtaskID)
                        end
                    end
                    self:RemoveButtonClickListener(self.objChild_BtnAddGift)
                    self:AddButtonClickListener(self.objChild_BtnAddGift,fun_add)
                end
                self.UnFinish.gameObject:SetActive(false)
            elseif wishTaskData.uiState == RWTT_END then
                -- 完成心愿奖励
                self.obj_UnFinish_State.gameObject:SetActive(false)
                self.obj_End_State.gameObject:SetActive(true)
                self.UnFinish.gameObject:SetActive(false)
                self.objChild_BtnAddGift.gameObject:SetActive(false)
                self:RemoveButtonClickListener(self.objChild_BtnAddGift)

                if uiChooseReward > 0 then
                    local _Reward = tableDataManager:GetTableData("RoleWishReward", uiChooseReward)
                    if _Reward then
                        -- local des = GetLanguageByID(_Reward.NameID)
                        local des = GetLanguagePreset(wishQuestBaseData.NameID, '心愿名' .. wishQuestBaseData.NameID)

                        local next_des = ""
                        if dnull(_Reward.WishTreeID) then
                            next_des = next_des.. "\n" .. WishTaskDataManager:GetInstance():GetWishTaskDesc(self.selectRole, uiChooseReward)
                        elseif _Reward.GiftIDs and next(_Reward.GiftIDs) ~= nil then
                            for _, giftID in pairs(_Reward.GiftIDs) do
                                local giftData = GetTableData("Gift",giftID)
                                if giftData then
                                    next_des = next_des.. "\n" .. getRankBasedText(giftData.Rank,string.format("天赋《%s》",GetLanguageByID(giftData.NameID)),true) or ""
                                    next_des = next_des .. "\n" .. getSizeText(20, GetLanguageByID(giftData.DescID))
                                end
                            end
                        elseif _Reward.MartialIDs and next(_Reward.MartialIDs) ~= nil then
                            for _, martialID in pairs(_Reward.MartialIDs) do
                                local martialData = GetTableData("Martial",martialID)
                                if martialData then
                                    next_des = next_des .. "\n" .. getRankBasedText(martialData.Rank,string.format("《%s》",GetLanguageByID(martialData.NameID)),true)
                                    next_des = next_des .. "\n" .. getSizeText(20, GetLanguageByID(martialData.DesID))
                                end
                            end
                        end

                        if _Reward.RoleAttrs and next(_Reward.RoleAttrs) ~= nil then
                            for index, iattrid in pairs(_Reward.RoleAttrs) do
                                next_des = next_des.."\n"..getSizeText(24,"<color=#CB4424>属性奖励：</color>\n".."")
                                local ret = ''
                                local attr_name = GetLanguageByID(AttrType_Lang[iattrid]) or "error"
                                local int_value = _Reward.Values[index] or 0
                                local bIsPerMyriad,bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(iattrid)
                                int_value = int_value / 10000
                                if bShowAsPercent then
                                    if int_value == 0 then return "0%" end
                                    local fvalue = int_value * 100
                                    if fvalue == math.floor(fvalue) then
                                        int_value = string.format("%.0f%%", fvalue)
                                    else
                                        int_value = string.format("%.1f%%", fvalue)
                                    end
                                else
                                    if int_value == 0 then return "0" end
                                    local fs
                                    if  bIsPerMyriad and int_value ~= math.floor(int_value) then
                                        fs = "%.1f"
                                    else
                                        fs = "%.0f"
                                    end
                                    int_value = string.format(fs, int_value)
                                end
                                ret = string.format("%s%s+%s",ret, attr_name, int_value)
                                next_des = next_des..ret
                            end
                        end
                        if next_des == "" then
                            self.rewardName_Text.text = des .. "\n"
                        else
                            self.rewardName_Text.text = des .. next_des
                        end
                    end
                end
            else
                self.obj_UnFinish_State.gameObject:SetActive(true)
                self.obj_End_State.gameObject:SetActive(false)

                self.objChild_BtnAddGift.gameObject:SetActive(false)
                self:RemoveButtonClickListener(self.objChild_BtnAddGift)
                self.UnFinish.gameObject:SetActive(true)
                self.objChild_BtnAddGift.gameObject:SetActive(false)
            end

            self.com_ContentSizeFiter.enabled = true
        end
	end
end

function CharacterUI:RefreshWishTask()
    local iCount = 0
    self.roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    if   self.roleData and  self.roleData.auiRoleWishTasks  then
        self.auiRoleWishTasks  = WishTaskDataManager:GetInstance():Sort(self.roleData.auiRoleWishTasks)
        iCount = #self.auiRoleWishTasks
    end

    --刷新星愿
    if self.LoopScrollView_wishTask then
        self.LoopScrollView_wishTask.totalCount = iCount
        self.LoopScrollView_wishTask:RefillCells()
        self.Content_wishTask.transform:GetComponent(l_DRCSRef_Type.RectTransform):DOAnchorPosY(-10, 0.1)
        ReBuildRect(self.Content_wishTask.gameObject)
        --ReBuildRect(self.Content_wishTask.gameObject)
    end
end

function CharacterUI:UpdateRoleChain()
    if not self.objRoleChainList.activeSelf then 
        return
    end
    local l_roleDataMgr = RoleDataManager:GetInstance()
    self:HideAllObjectInPool(self.roleChainObjectPool)
    local dispositions = l_roleDataMgr:GetDispositionData(self.selectRole) or {}
	self.objRoleChainList = self:FindChild(self._gameObject, "G_ChainContent")
	if self.objRoleChainList then
        self:RemoveAllChildToPool(self.objRoleChainList.transform)
	end

	-- 如果没有主角的好感度的话，默认添加一个
	local mainRoleBaseID = l_roleDataMgr:GetMainRoleCreateRoleTypeID()

	local tempSort = {}
	for k, v in pairs(dispositions) do
		v.dstRoleID = k
		if k ~= mainRoleBaseID and k ~= DEFAULT_MAIN_ROLE_BASE_ID then
			table.insert(tempSort, v)
		end
	end

	table.sort(tempSort, function(a, b)
		return a.iValue > b.iValue
	end)

    if dispositions[mainRoleBaseID] then 
        table.insert(tempSort, 1, dispositions[mainRoleBaseID])
    elseif dispositions[DEFAULT_MAIN_ROLE_BASE_ID] then
        table.insert(tempSort, 1, dispositions[DEFAULT_MAIN_ROLE_BASE_ID])
    end
    
    local iRoleTypeId = l_roleDataMgr:GetRoleTypeID(self.selectRole)
	for k, v in pairs(tempSort) do
		dstRoleID = v.dstRoleID
		if (mainRoleBaseID ~= dstRoleID and DEFAULT_MAIN_ROLE_BASE_ID ~= dstRoleID) or (v.Desc and v.Desc ~= '') then
            local name, roleModel
            local dbRoleData = l_roleDataMgr:GetRoleTypeDataByTypeID(dstRoleID)
            if dstRoleID == DEFAULT_MAIN_ROLE_BASE_ID or dstRoleID == mainRoleBaseID then 
                dstRoleID = mainRoleBaseID
                name = l_roleDataMgr:GetMainRoleName()
                roleModel = l_roleDataMgr:GetMainRoleArtData()
            else
                name = l_roleDataMgr:GetRoleName(dstRoleID)
                roleModel = TableDataManager:GetInstance():GetTableData("RoleModel", dbRoleData.ArtID)
            end
			local objDisp = self:LoadPrefabFromPool("Module/Disposition1080",self.objRoleChainList)

			local comName = self:FindChildComponent(objDisp, "layout/title_box/Name", l_DRCSRef_Type.Text)
			local comDisp = self:FindChildComponent(objDisp, "layout/title_box/Value", l_DRCSRef_Type.Text)
			local comDes = self:FindChildComponent(objDisp, "layout/Desc", l_DRCSRef_Type.Text)

			comName.text = name
			local default_des = RoleDataHelper.GetDispositionDesByValue(v.iValue)
			comDes.text = v.Desc or default_des
			comDisp.text = string.format("%0.f", v.iValue)

            if roleModel then
                local comHeadImage = self:FindChildComponent(objDisp, "Head/Head_Dispositions/head", l_DRCSRef_Type.Image)
                comHeadImage.sprite = GetSprite(roleModel.Head)
            end
        elseif mainRoleBaseID == dstRoleID or DEFAULT_MAIN_ROLE_BASE_ID == dstRoleID then
            -- 添加对主角的关系显示
            local dbRoleData = l_roleDataMgr:GetRoleTypeDataByTypeID(dstRoleID)
			local objDisp = self:LoadPrefabFromPool("Module/Disposition1080",self.objRoleChainList)

			local comName = self:FindChildComponent(objDisp, "layout/title_box/Name", l_DRCSRef_Type.Text)
			local comDisp = self:FindChildComponent(objDisp, "layout/title_box/Value", l_DRCSRef_Type.Text)
			local comDes = self:FindChildComponent(objDisp, "layout/Desc", l_DRCSRef_Type.Text)
            local objCreateFaceParent = self:FindChild(objDisp, "Head/Head_Dispositions/CreateHead")
            local imgImage = self:FindChildComponent(objDisp, "Head/Head_Dispositions/head", l_DRCSRef_Type.Image)
            self.objCreateFace = self:FindChild(objCreateFaceParent, "Create_Head(Clone)")

            local name = l_roleDataMgr:GetMainRoleName()
			comName.text = name
			local default_des = RoleDataHelper.GetDispositionDesByValue(v.iValue)
			comDes.text = v.Desc or default_des
			comDisp.text = string.format("%0.f", v.iValue)

			local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID() -- 剧本ID(酒馆0)
            if CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, mainRoleBaseID)then
                if self.objCreateFace then
                    self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, mainRoleBaseID, objCreateFaceParent, self.objCreateFace)
                    self.objCreateFace:SetActive(true)
                else
                    self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, mainRoleBaseID, objCreateFaceParent)
                end
                imgImage.gameObject:SetActive(false)
            else
                if self.objCreateFace then
                    self.objCreateFace:SetActive(false)
                end
                local roleModel = l_roleDataMgr:GetMainRoleArtData()
                imgImage.sprite = GetSprite(roleModel.Head)
            end
			

        end
	end
end

function CharacterUI:OpenAddRewards(wishtaskID)
    -- dprint("打开心愿奖励面板")
    g_characterSelectRole = self.selectRole
    g_characterSelectWishTask = wishtaskID
    SendRandomWishRewardsCMD(0, self.selectRole, wishtaskID, 3)
    self.bDontRemoveWinBar = true
end

function CharacterUI:OnClick_Tips_Common()
    if not self.selectRole then return end
    local tips = TipsDataManager:GetInstance():GetCharacterCommonTips(self.selectRole)
    OpenWindowImmediately("TipsPopUI", tips)
end

function CharacterUI:OnClick_Tips_Detail()
    if not self.selectRole then return end
    local tips = TipsDataManager:GetInstance():GetCharacterDetailTips(self.selectRole)
    OpenWindowImmediately("TipsPopUI", tips)
end

function CharacterUI:OnClick_IncreaseTips_Button()
    if not self.selectRole then return end
    local tips = TipsDataManager:GetInstance():GetRoleAttrAddTips(self.selectRole)
    if not tips then return end
    tips.kind = 'wide'
    OpenWindowImmediately("TipsPopUI", tips)
end
local f_getMaxRate = function(eType)
    if not eType then return 1 end
    local BattleFactorRelate = TableDataManager:GetInstance():GetTableData("BattleFactorRelate",eType)
    if not BattleFactorRelate or not BattleFactorRelate.Value then return 1 end
    return BattleFactorRelate.Value
end
function CharacterUI:f_checkzero(va1,va2)
    local bret = true
    if va2 == nil and  va1 == 0 then
        bret = false
    elseif va2 == 0 and va1 == 0 then
        bret = false
    end
    self.cache_zero_value =  bret
end
----------------------------------------------------
function CharacterUI:getTranslate(enum, value, isMainRoleAttr,stringname,roleData)
    local getAddString = function()
        local attr_add = self.array_attr_due_to_point[enum]
        if attr_add and math.abs( attr_add ) > 1e-4 then
            local add_string = '+' .. getAttrBasedText(enum, attr_add, isMainRoleAttr)
            return getUIBasedText('green', add_string)
        end
    end


    if enum == AttrType.ATTR_MAX_NUM then
        if stringname == '' then
            return ''
        elseif stringname == '体质转生命值' then
            local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
            local BattleFactor = TableDataManager:GetInstance():GetTableData("BattleFactor",roleData and roleData.uiLevel or 1)
            self.cache_zero_value =  true
            return BattleFactor and BattleFactor.physique_hp or 50
        end
    elseif roleData then
        local BattleFactorRelate = TableDataManager:GetInstance():GetTable('BattleFactorRelate')
        local finalStr = nil
        local addStr = getAddString()
        if enum == AttrType.ATTR_SHANBI then
            local n_shanbi = roleData:GetAttr(AttrType.ATTR_SHANBI) or 0
            local n_shanbi_percent = (roleData:GetAttr(AttrType.ATTR_SHANBILV) or 0 )/ 10000
            local n_shanbi_gen = (n_shanbi + temp_battle_factor["dodge_m"]) / (n_shanbi + temp_battle_factor["dodge_n"]) * f_getMaxRate(BattleFactorType.BFACT_DodgeMax)
            n_shanbi_gen = n_shanbi_gen >= 0 and n_shanbi_gen or 0
            local n_shanbi_final = n_shanbi_gen + n_shanbi_percent
            self:f_checkzero(n_shanbi,n_shanbi_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_shanbi, n_shanbi_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_shanbi, addStr, n_shanbi_final * 100)
            end
        elseif enum == AttrType.ATTR_HITATK then
            --  HELP CH TO REM: 由于命中影响过大 调小倍率 初始为0.5 改到了 0.1
            local n_mingzhong = roleData:GetAttr(AttrType.ATTR_HITATK) or 0
            local n_mingzhong_percent = (roleData:GetAttr(AttrType.ATTR_HITATKPER) or 0 )/ 10000
            local n_mingzhong_gen = (n_mingzhong + temp_battle_factor["dodge_m"]) / (n_mingzhong + temp_battle_factor["dodge_n"]) * 0.1
            n_mingzhong_gen = n_mingzhong_gen >= 0 and n_mingzhong_gen or 0
            local n_mingzhong_final = n_mingzhong_gen + n_mingzhong_percent
            self:f_checkzero(n_mingzhong, n_mingzhong_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_mingzhong, n_mingzhong_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_mingzhong, addStr, n_mingzhong_final * 100)
            end
        elseif enum == AttrType.ATTR_CRITATK then
            local n_critatk = roleData:GetAttr(AttrType.ATTR_CRITATK) or 0
            local n_critatk_percent = (roleData:GetAttr(AttrType.ATTR_CRITATKPER) or 0 )/ 10000
            local n_critatk_gen = (n_critatk + temp_battle_factor["crit_m"]) / (n_critatk + temp_battle_factor["crit_n"]) * f_getMaxRate(BattleFactorType.BFACT_CritMax)
            n_critatk_gen = n_critatk_gen >= 0 and n_critatk_gen or 0
            local n_critatc_final = n_critatk_gen + n_critatk_percent
            self:f_checkzero(n_critatk, n_critatc_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_critatk, n_critatc_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_critatk, addStr, n_critatc_final * 100)
            end
        elseif enum == AttrType.ATTR_BAOJIDIKANGZHI then
            local n_count_crittk = roleData:GetAttr(AttrType.ATTR_BAOJIDIKANGZHI) or 0
            local n_count_crittk_percent = (roleData:GetAttr(AttrType.ATTR_IGNOREDEFPER) or 0 )/ 10000
            local n_count_crittk_gen = (n_count_crittk + temp_battle_factor["crit_m"]) / (n_count_crittk + temp_battle_factor["crit_n"]) * f_getMaxRate(BattleFactorType.BFACT_CritMax)
            n_count_crittk_gen = n_count_crittk_gen >= 0 and n_count_crittk_gen or 0
            local n_critatc_final = n_count_crittk_gen + n_count_crittk_percent
            self:f_checkzero(n_count_crittk, n_critatc_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_count_crittk, n_critatc_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_count_crittk, addStr, n_critatc_final * 100)
            end
        elseif enum == AttrType.ATTR_CONTINUATK then
            local n_continuatk = roleData:GetAttr(AttrType.ATTR_CONTINUATK) or 0
            local n_continuatk_percent = (roleData:GetAttr(AttrType.ATTR_CONTINUATKPER) or 0 )/ 10000
            local n_continuatk_gen = (n_continuatk + temp_battle_factor["Combo_m"]) / (n_continuatk + temp_battle_factor["Combo_n"]) * f_getMaxRate(BattleFactorType.BFACT_ComboMax)
            n_continuatk_gen = n_continuatk_gen >= 0 and n_continuatk_gen or 0
            local n_continuatk_final = n_continuatk_gen + n_continuatk_percent
            self:f_checkzero(n_continuatk, n_continuatk_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_continuatk, n_continuatk_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_continuatk, addStr, n_continuatk_final * 100)
            end
        elseif enum == AttrType.ATTR_KANGLIANJI then
            local n_kanglianji = roleData:GetAttr(AttrType.ATTR_KANGLIANJI) or 0
            local n_kanglianji_percent = (roleData:GetAttr(AttrType.ATTR_KANGLIANJILV) or 0 )/ 10000
            local n_kanglianji_gen = (n_kanglianji + temp_battle_factor["Combo_m"]) / (n_kanglianji + temp_battle_factor["Combo_n"]) * f_getMaxRate(BattleFactorType.BFACT_ComboMax)
            n_kanglianji_gen = n_kanglianji_gen >= 0 and n_kanglianji_gen or 0
            local n_kanglianji_final = n_kanglianji_gen + n_kanglianji_percent
            self:f_checkzero(n_kanglianji, n_kanglianji_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_kanglianji, n_kanglianji_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_kanglianji, addStr, n_kanglianji_final * 100)
            end
        elseif enum == AttrType.ATTR_FANJIZHI then
            local n_fanji = roleData:GetAttr(AttrType.ATTR_FANJIZHI) or 0
            local n_fanji_percent = (roleData:GetAttr(AttrType.ATTR_FANJILV) or 0 )/ 10000
            local n_fanji_gen = (n_fanji + temp_battle_factor["counter_m"]) / (n_fanji + temp_battle_factor["counter_n"]) * f_getMaxRate(BattleFactorType.BFACT_counterMax)
            n_fanji_gen = n_fanji_gen >= 0 and n_fanji_gen or 0
            local n_fanji_final = n_fanji_gen + n_fanji_percent
            self:f_checkzero(n_fanji, n_fanji_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_fanji, n_fanji_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_fanji, addStr, n_fanji_final * 100)
            end
        elseif enum == AttrType.ATTR_POZHAOVALUE then
            local n_seethrough = roleData:GetAttr(AttrType.ATTR_POZHAOVALUE) or 0
            local n_seethrough_percent = (roleData:GetAttr(AttrType.ATTR_POZHAOLV) or 0 )/ 10000
            local n_seethrough_gen = (n_seethrough + temp_battle_factor["seeThrough_m"]) / (n_seethrough + temp_battle_factor["seeThrough_n"]) * f_getMaxRate(BattleFactorType.BFACT_seeThroughMax)
            n_seethrough_gen = n_seethrough_gen >= 0 and n_seethrough_gen or 0
            local n_seethrough_final = n_seethrough_gen + n_seethrough_percent
            self:f_checkzero(n_seethrough, n_seethrough_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_seethrough, n_seethrough_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_seethrough, addStr, n_seethrough_final * 100)
            end
        elseif enum == AttrType.ATTR_BAOSHANGZHI then
            local n_baojibeishu = roleData:GetAttr(AttrType.ATTR_BAOSHANGZHI) or 0
            local n_baojibeishu_percent = (roleData:GetAttr(AttrType.ATTR_CRITATKTIME) or 0 )/ 10000
            local n_baojibeishu_gen = (n_baojibeishu + temp_battle_factor["critDge_m"]) / (n_baojibeishu + temp_battle_factor["critDge_n"]) * f_getMaxRate(BattleFactorType.BFACT_CritDgeMax)
            n_baojibeishu_gen = n_baojibeishu_gen >= 0 and n_baojibeishu_gen or 0
            local n_baojibeishu_final = n_baojibeishu_gen + n_baojibeishu_percent + 1
            self:f_checkzero(n_baojibeishu, n_baojibeishu_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_baojibeishu, n_baojibeishu_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_baojibeishu, addStr, n_baojibeishu_final * 100)
            end
        elseif enum == AttrType.ATTR_FANTANVALUE then
            local n_rebound = roleData:GetAttr(AttrType.ATTR_FANTANVALUE) or 0
            local n_rebound_percent = (roleData:GetAttr(AttrType.ATTR_FANTANLV) or 0 )/ 10000
            local n_rebound_gen = (n_rebound + temp_battle_factor["rebound_m"]) / (n_rebound + temp_battle_factor["rebound_n"]) * f_getMaxRate(BattleFactorType.BFACT_reboundMax)
            n_rebound_gen = n_rebound_gen >= 0 and n_rebound_gen or 0
            local n_rebound_final = n_rebound_gen + n_rebound_percent
            self:f_checkzero(n_rebound, n_rebound_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_rebound, n_rebound_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_rebound, addStr, n_rebound_final * 100)
            end
        end

    end
    local iDiffValue = RoleDataManager:GetInstance():GetDifficultyValue()
    local table_AttrMaxDiff = TableDataManager:GetInstance():GetTable("AttrmaxDifficuty")
    if iDiffValue > #table_AttrMaxDiff then
        iDiffValue = #table_AttrMaxDiff
    end
    local bMax = false
    local attrMaxData = table_AttrMaxDiff[iDiffValue]
    if attrMaxData then
        local field = weekLimitValue[enum]
        local maxValue = attrMaxData[field]
        if maxValue then
            if value >= maxValue then
                value = maxValue
                bMax = true
            end
        end
    end
    self:f_checkzero(value)
    local ret_string = getAttrBasedText(enum, value, isMainRoleAttr)
    if bMax then
        ret_string = getUIBasedText('red',ret_string)
    end

    if not isMainRoleAttr then
        local attr_add = self.array_attr_due_to_point[enum]
        if attr_add and math.abs( attr_add ) > 1e-4 then
            local add_string = '+' .. getAttrBasedText(enum, attr_add, isMainRoleAttr)
            ret_string = ret_string .. getUIBasedText('green', add_string)
        end
    end
    return ret_string
end
-- function CharacterUI:formatValue(val, isPrecent)
--     if isPrecent then
--         if val == 0 then return "0%" end
--         return string.format("%.1f%%", val / 100)
--     else
--         if val == 0 then return "0" end
--         return string.format("%.f", val)
--     end
-- end
----------------------------------------------------
function CharacterUI:OnClick_BackpackItem(obj, itemID)
    local roleID = self.selectRole
    if not (roleID  and itemID) then
        return
    end
    local itemManager = ItemDataManager:GetInstance()
    local typeID = itemManager:GetItemTypeID(itemID)
    local typeData = itemManager:GetItemTypeData(itemID)
    if not (typeID and typeData) then
        return
    end
    local itemType = typeData.ItemType
    local bNeedOpenTaskType = ((itemType == ItemTypeDetail.ItemType_Task) or (itemType == ItemTypeDetail.ItemType_Pub))  -- 是否是需要使用效果为开启任务才会出现使用的类型
    local bOpenedTreasure = ((itemType == ItemTypeDetail.ItemType_TreasureMap) and ((typeData.EffectType == nil) or (typeData.EffectType == 0)))  -- 是否为已开启的藏宝图
    local sItemName = itemManager:GetItemName(itemID, typeID, true)
    local tips = TipsDataManager:GetInstance():GetItemTips(itemID, typeID)
    local btns = tips.buttons or {}
    local canUse, useCondDesc = itemManager:ItemUseCondition(itemID, typeID, false, true, true)
    local sysUICall = SystemUICall:GetInstance()
    -- 是否是 暗器 医药 装备
    local bIsMainRoleOnlyItemEquip = (itemType == ItemTypeDetail.ItemType_HiddenWeapon) or (itemType == ItemTypeDetail.ItemType_Leechcraft)
    -- 如果物品有 限主角使用 的特性, 那么角色id必须为主角id
    local bMainRoleUseOnly = itemManager:ItemHasFeature(itemID, ItemFeature.IF_MainRoleUseOnly)
    local iMainRole = RoleDataManager:GetInstance():GetMainRoleID()
    local bIsMainRole = roleID == iMainRole
    local bIsBabyType = RoleDataManager:GetInstance():IsBabyRoleType(roleID)
    local bRoleCanUse = ((not bMainRoleUseOnly) or bIsMainRole) and (not bIsMainRoleOnlyItemEquip)
    if bIsBabyType then
        sysUICall:Toast("徒儿本周目无法使用物品")
    elseif bRoleCanUse then
        -- 秘籍显示两个按钮: 学习与装备
        if itemType == ItemTypeDetail.ItemType_SecretBook then
            -- 如果角色没有学会这门武学, 那么显示一个学习按钮, 点击可以直接学习得到一级该武学
            local uiMartialBaseID = typeData.MartialID or 0
            if uiMartialBaseID and (uiMartialBaseID > 0) then
                local martialInst = RoleDataManager:GetInstance():GetMartialInstByTypeID(roleID, uiMartialBaseID)
                if (not martialInst) then
                    btns[#btns + 1] = {
                        ["name"] = "学习",
                        ['func'] = function()
                            local martialStaticData = MartialDataManager:GetInstance():GetMartialTypeDataByItemTypeID(typeID)
                            if getTableSize(martialStaticData.Exclusive) > 0 and martialStaticData.Exclusive[1] ~= RoleDataManager:GetInstance():GetRoleTypeID(self.selectRole) then
                                SystemUICall:GetInstance():Toast("无法学习他人的专属武学")
                                return
                            end
                            if not canUse then
                                sysUICall:Toast("不满足学习条件: " .. sItemName)
                                return
                            end
                            SendRoleLearnSecretBookMartial(roleID, itemID)
                        end
                    }
                end
                -- elseif --[[MartialDataManager:GetInstance():OpenMakeMartialStrong()]] true then
                --     local maxLevel = MartialDataManager:GetInstance():GetMaxMartialStrongLevel()
                --     if martialInst.iStrongLevel == nil or martialInst.iStrongLevel <= maxLevel then
                --         btns[#btns + 1] = {
                --             ["name"] = "研读",
                --             ['func'] = function()
                --                 OpenWindowImmediately("MartialStrongUI",{roleID, martialInst})
                --             end
                --         }
                --     end
                -- end
            end
            btns[#btns + 1] = {
                ["name"] = "装备",
                ['func'] = function()
                    if not canUse then
                        sysUICall:Toast("不满足装备条件: " .. sItemName)
                        return
                    end
                    -- 装备一本秘籍时, 如果装备位上已经有一本秘籍, 并且角色的武学数量已经超过上限,
                    -- 就意味这装备秘籍顶掉原本的秘籍时会导致角色遗忘掉原来秘籍的武学, 需要提醒玩家
                    local funcDoEquip = function()
                        SendEquipItemCMD(roleID, itemID)
                    end
                    local kRoleData = RoleDataManager:GetInstance():GetRoleData(roleID)
                    local kRoleEquipItems = kRoleData.akEquipItem or {}
                    local uiEquipBookID = kRoleEquipItems[REI_RAREBOOK]
                    local kEquipedBookData = nil
                    if uiEquipBookID and (uiEquipBookID > 0) then
                        kEquipedBookData = itemManager:GetItemTypeData(uiEquipBookID)
                    end
                    if kEquipedBookData then
                        local uiMartialCount = RoleDataManager:GetInstance():GetRoleMartialCount(roleID, true)
                        if uiMartialCount > kRoleData.uiMartialNum then
                            local strTips = '由于武学数量超过上限，替换' .. kEquipedBookData.ItemName or '' .. '时，对应的武学将被遗忘，是否继续？'
                            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strTips, funcDoEquip})
                            return
                        end
                    end
                    funcDoEquip()
                end
            }
        -- 装备显示穿戴按钮
        elseif itemManager:IsEquip(typeID) then
            btns[#btns + 1] = {
                ["name"] = "穿戴",
                ['func'] = function(iNum)
                    -- TODO: 走掌门对决逻辑
                    if PKManager:GetInstance():IsRunning() then
                        PKManager:GetInstance():RequestEquip(roleID, itemID)
                        return
                    end

                    if bIsMainRoleOnlyItemEquip then
                        sysUICall:Toast("医药与暗器不可装备")
                        return
                    end
                    if not canUse then
                        -- sysUICall:Toast("不满足穿戴条件: " .. useCondDesc)
                        sysUICall:Toast("不满足穿戴条件: " .. sItemName)
                        return
                    end
                    -- 对于队友已穿着的装备, 如果:
                    -- 拥有者非玩家，那么只能用高级替换低级, 给队友装备档次更低的装备，会拒绝，客户端提示“队友不喜欢这件装备”
                    -- 拥有者是玩家，那么可以使用任意级别装备替换之
                    if not bIsMainRole then
                        local kRoleInstData = RoleDataManager:GetInstance():GetRoleData(roleID)
                        local kEquipItems = kRoleInstData.akEquipItem or {}
                        local kItemMgr = ItemDataManager:GetInstance()
                        local eTarSlot = kItemMgr:GetEquipSlotByItemInstID(itemID)
                        local uiRoleEquipedItemID = 0
                        for eQuipSlot, uiEquipItemID in pairs(kEquipItems) do
                            if eQuipSlot == eTarSlot then
                                uiRoleEquipedItemID = uiEquipItemID
                                break
                            end
                        end
                        if (uiRoleEquipedItemID > 0)
                        and (kItemMgr:IsEquipItemBelongToMainRole(uiRoleEquipedItemID) ~= true)
                        and (kItemMgr:GetItemRankByItemInstID(itemID) < kItemMgr:GetItemRankByItemInstID(uiRoleEquipedItemID)) then
                            sysUICall:Toast("队友不喜欢这件装备")
                            return
                        end
                    end
                    SendEquipItemCMD(roleID, itemID)
                end
            }
        -- 材料类 或 使用类型不为[开启任务]的[任务类与酒馆类] 或 没有使用类型的物品 不允许出现使用
        elseif (not ItemDataManager:GetInstance():IsTypeEqual(typeData.ItemType,ItemTypeDetail.ItemType_Material))
        and (bOpenedTreasure ~= true)
        and ((bNeedOpenTaskType ~= true) or (typeData.EffectType == EffectType.ETT_OpenTask)) then
            btns[#btns + 1] = {
                ["name"] = "使用",
                ['func'] = function(iNum)
                    if not canUse then
                        -- sysUICall:Toast("不满足使用条件:" .. useCondDesc)
                        sysUICall:Toast("不满足使用条件: " .. sItemName)
                        return
                    end
                    -- 和 相相、岳巍讨论过，直接特殊处理残章匣
                    if typeID == 80701 then
                        -- 上行之前, 先打开界面
                        OpenWindowByQueue('IncompleteBoxUI')
                        local roleID = self.iMainRoleID
                        SendClickIncompleteBoxCMD(roleID)
                    elseif typeID == 9628 then -- 易容面具
                        SendClickRoleDisguise(roleID, 0, false)
                        OpenWindowImmediately("DisguiseUI", roleID)
                    elseif typeID == 1511 then -- 绝情断骨丸

                        if  self.click_JueQing_First == false then
                            SendUseItemCMD(roleID, itemID, 1)
                            return
                        end
                        local callback = function()
                            SendUseItemCMD(roleID, itemID, 1)
                        end
                        local name = RoleDataHelper.GetNameByID(roleID)

                        local showContent = {
                            ['title'] = '提示',
                            ['text'] =string.format('你真的要对 %s 角色使用绝情断骨丹吗?该角色的性别将会变成阴人',name),
                        }

                        OpenWindowImmediately('GeneralBoxUI', {
                            GeneralBoxType.COMMON_TIP,
                            showContent,
                            callback
                        })
                        self.click_JueQing_First = false
                    elseif typeID == 1510 then --阴阳颠倒丹
                          --tips
                        if self.click_YinYangDianDao_First == false then
                            SendUseItemCMD(roleID, itemID, 1)
                            return
                        end
                        local callback = function()
                            SendUseItemCMD(roleID, itemID, 1)
                        end

                        local name = RoleDataHelper.GetNameByID(roleID)
                        local uiSex = 0
                        if roleID == self.iMainRoleID then
                            uiSex =  RoleDataManager:GetInstance():GetMainRoleSex()
                        else
                            local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByID(roleID)
                            uiSex = roleTypeData.Sex
                        end

                        local sSex = ''
                        if uiSex == 1 then
                            sSex = "女"
                        elseif uiSex == 2 then
                            sSex = "男"
                        else
                            -- 无法使用
                            SendUseItemCMD(roleID, itemID, 1)
                            return
                        end

                        local showContent = {
                            ['title'] = '提示',
                            ['text'] =string.format('你真的要对 %s 角色使用阴阳颠覆丹吗?该角色的性别将会变成%s性',name,sSex),
                        }

                        OpenWindowImmediately('GeneralBoxUI', {
                            GeneralBoxType.COMMON_TIP,
                            showContent,
                            callback
                        })
                        self.click_YinYangDianDao_First = false
                    elseif typeData.EffectType == EffectType.ETT_UuseItem_ChooseGift then   -- 可选礼包打开礼包选择界面
                        OpenWindowImmediately("ItemRewardChooseUI", {["itemid"] = itemID, ["type"] = EffectSubType.EST_ScriptChooseGift})
                    else
                        SendUseItemCMD(roleID, itemID, 1)

                        if typeData.EffectType == EffectType.ETT_TreasureMap then
                            -- TODO 数据上报
                            MSDKHelper:SetQQAchievementData('opentreasure', typeData.BaseID);
                            MSDKHelper:SendAchievementsData('opentreasure');
                        end
                    end
                end
            }
            if itemManager:CanItemUsedInBatches(itemID) then
                local itemNum = itemManager:GetItemNum(itemID) or 0
                local strName = "全部使用"
                if itemNum > SSD_MAX_PLAT_ITEM_USEMAX_NUM then
                    strName = string.format("批量使用%d个", SSD_MAX_PLAT_ITEM_USEMAX_NUM)
                end
                btns[#btns + 1] = {
                    ["name"] = strName,
                    ['func'] = function(iNum)
                        if not canUse then
                            -- sysUICall:Toast("不满足使用条件:" .. useCondDesc)
                            sysUICall:Toast("不满足使用条件: " .. sItemName)
                            return
                        end
                        SendUseItemCMD(roleID, itemID, itemNum)
                    end
                }
            end
        end
        tips.buttons = btns
    end
    -- 根据物品类型, 判断相应装备为上是否有物品装备, 如果有, 比对tips信息
    local iEquipedItemID = self:GetEquipedItemIDByItemType(itemType)
    if iEquipedItemID then
        tips.compareTips = TipsDataManager:GetInstance():GetItemTips(iEquipedItemID)
    end
    tips.pierce = true
    OpenWindowImmediately("TipsPopUI", tips)
end

-- 使用物品类型获取装备位上的装备
function CharacterUI:GetEquipedItemIDByItemType(itemType)
    if not itemType then
        return
    end
    local roleMgr = RoleDataManager:GetInstance()
    local roleData = roleMgr:GetRoleData(self.selectRole) or roleMgr:GetMainRoleData()
    if not roleData then
        return
    end
    if not self.equipCategories then
        -- 这个分类没有什么特别的意义, 只是希望某些类型用一个值绑定为一组
        self.equipCategories = {
            [ItemTypeDetail.ItemType_Clothes] = 1, -- 衣服
            [ItemTypeDetail.ItemType_Shoe] = 2, -- 鞋子
            [ItemTypeDetail.ItemType_Ornaments] = 3, -- 饰品
            [ItemTypeDetail.ItemType_Wing] = 4, -- 翅膀
            [ItemTypeDetail.ItemType_Knife] = 5, -- 刀
            [ItemTypeDetail.ItemType_Sword] = 5, -- 剑
            [ItemTypeDetail.ItemType_Fist] = 5, -- 拳
            [ItemTypeDetail.ItemType_Rod] = 5, -- 棍
            [ItemTypeDetail.ItemType_Whip] = 5, -- 鞭
            [ItemTypeDetail.ItemType_NeedleBox] = 5,  -- 针匣
            [ItemTypeDetail.ItemType_Cane] = 5,  -- 手杖/护腿
            [ItemTypeDetail.ItemType_Artifact] = 6, -- 神器
            [ItemTypeDetail.ItemType_SecretBook] = 7, -- 秘籍
            [ItemTypeDetail.ItemType_HiddenWeapon] = 8, -- 暗器
            [ItemTypeDetail.ItemType_Leechcraft] = 9, -- 医术
        }
    end
    local iEquipCate = self.equipCategories[itemType]
    if not iEquipCate then
        return
    end
    local equipItemList = roleData.akEquipItem or {}
    local itemMgr = ItemDataManager:GetInstance()
    for equipType = 1, REI_NUMS - 1 do
        local equipItemID = equipItemList[equipType]
        if equipItemID and (equipItemID > 0) then
            local kItemTypeData = itemMgr:GetItemTypeData(equipItemID)
            if kItemTypeData and (self.equipCategories[kItemTypeData.ItemType] == iEquipCate) then
                return equipItemID
            end
        end
    end
end

-- 一键装备
function CharacterUI:AutoEquip()
    -- 获取将要一键装备的角色
    local roleID = self.selectRole or 0
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if not roleData then
        return
    end
    -- 在背包中选取能够装备上的最高品质装备，若有相同品质的装备，则挑选最靠前的
    local itemMgr = ItemDataManager:GetInstance()
    local mainRoleID = self.iMainRoleID
    local bIsMainRole = (mainRoleID == roleID)
    -- 获取背包物品, 包括装备道具, 已经过滤并且按品质排序好
    local fliterFunc = function(itemID)
        local itemTypeID = itemMgr:GetItemTypeID(itemID)
        -- 筛选所有装备
        if not itemMgr:IsEquip(itemTypeID) then
            return false
        end
        -- 判断使用条件, 如果已装备, 忽略使用条件
        if itemMgr:IsItemEquipedByRole(itemID) then
            return true
        end
        -- 不处于装备中的道具, 必须达到使用条件
        if itemMgr:ItemUseCondition(itemID, itemTypeID, false, false, true) then
            return true
        end
        return false
    end
    local auiSortedItemIDList = itemMgr:GetPackageItems(mainRoleID, self.selectRole, false, fliterFunc)
    if not (auiSortedItemIDList and next(auiSortedItemIDList)) then
        return
    end

    -- 将上一步筛选并排序好的数据, 按装备槽分流
    local itemTypeData = nil
    local eEquipSlot = nil
    local fliter = {}  -- 分流结果
    local subFliter = nil
    for index, itemID in ipairs(auiSortedItemIDList) do
        itemTypeData = itemMgr:GetItemTypeData(itemID)
        eEquipSlot = itemMgr:GetEquipSlotByItemType(itemTypeData.ItemType)
        -- 过滤掉 暗器 和 医药 这两个装备位的数据
        if ((eEquipSlot ~= REI_ANQI) and (eEquipSlot ~= REI_MEDICAL)) then
            subFliter = fliter[eEquipSlot] or {}
            subFliter[#subFliter + 1] = itemID
            fliter[eEquipSlot] = subFliter
        end
    end

    -- 挑选一件最优装备穿上
    local kEquipItemList = roleData.akEquipItem or {}
    -- local bOpenSecondThroneSlot = (TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() == true)
    for eEquipSlot, datas in pairs(fliter) do
        -- 对于普通装备(神器格2没开的时候, 神器也做普通装备处理, 神器格2开启的时候, 神器需要特殊处理), 将挑选的最优装备与对应装备位装备进行对比
        -- 如果对应装备位上的装备存在一下情形之一, 则跳过自动装备:
        -- 1.非空, 与最优装备是同一个实例(uid相同)
        -- 2.非空, 装备种类与最优装备相同, 且品质大于等于最优装备
        -- (同一个装备位, 装备种类发生变化的情况发生在 例如角色从剑法培养成拳法方向, 此时最优道具是拳套, 已装备道具可能是剑)
        if (#datas > 0) then--and ((eEquipSlot ~= REI_THRONE))
            local iBestItemID = nil
            -- 如果是武器, 那么需要根据目标角色最擅长的属性来挑选对应的最优装备
            -- 其他装备直接挑选按品质排序好的数组的第一个作为最优装备
            if eEquipSlot == REI_WEAPON then
                iBestItemID = itemMgr:GetFitnessWeapon(roleID, datas) or 0
            else
                iBestItemID = datas[1] or 0
            end
            local kBestItemData = itemMgr:GetItemTypeData(iBestItemID)
            -- 获取对应装备位的装备
            local iEquipedItemID = kEquipItemList[eEquipSlot] or 0
            local kEquipedItemData = itemMgr:GetItemTypeData(iEquipedItemID)
            if not kEquipedItemData then
                SendEquipItemCMD(roleID, iBestItemID)
            elseif (kBestItemData ~= nil)
            and (iEquipedItemID ~= iBestItemID)
            and ((kEquipedItemData.ItemType ~= kBestItemData.ItemType) or (kEquipedItemData.Rank < kBestItemData.Rank)) then
                SendEquipItemCMD(roleID, iBestItemID)
            end
        -- 关于两个神器格的自动装备, 需要特殊处理:
        -- 神器可以装备在两个位置(REI_THRONE/REI_HORSE), 并且同一个神器不能装两个(BaseID不能相同)
        -- 因此神器需要判断两个装备位可装备神器的可能性
        elseif #datas > 0 then
            -- 获取对应装备位的装备
            local iFirstThroneItemID = kEquipItemList[REI_THRONE] or 0
            local iSecondThroneItemID = kEquipItemList[REI_HORSE] or 0
            local kFirstThroneItemData = itemMgr:GetItemTypeData(iFirstThroneItemID)
            local kSecondThroneItemData = itemMgr:GetItemTypeData(iSecondThroneItemID)
            -- 从按品质排序好的数组中拿出最多两件神器
            -- 这两件神器只要满足:
            -- 1.不与已装备的任意一件神器相同
            -- 2.品质大于任意一件已装备神器
            -- 就上行装备这件神器
            local uiDoCount = 2
            for index, uiID in ipairs(datas) do
                if uiDoCount <= 0 then
                    break
                end
                local kBaseItem = itemMgr:GetItemTypeData(uiID)
                if ((not kFirstThroneItemData) or (kBaseItem.Rank > kFirstThroneItemData.Rank))
                and ((not kSecondThroneItemData) or (kBaseItem.BaseID ~= kSecondThroneItemData.BaseID)) then
                    uiDoCount = uiDoCount - 1
                    kFirstThroneItemData = kBaseItem
                    SendEquipItemCMD(roleID, uiID)
                elseif ((not kSecondThroneItemData) or (kBaseItem.Rank > kSecondThroneItemData.Rank))
                and ((not kFirstThroneItemData) or (kBaseItem.BaseID ~= kFirstThroneItemData.BaseID)) then
                    uiDoCount = uiDoCount - 1
                    kSecondThroneItemData = kBaseItem
                    SendEquipItemCMD(roleID, uiID)
                end
            end
        end
    end
end

-- 一键装备tip
function CharacterUI:ShowAutoEquipTip()
    if not self.kAutoEquipTip then
        self.kAutoEquipTip = {
            ['kind'] = 'wide',
            ['title'] = "一键装备说明",
            ['titlecolor'] = l_DRCSRef.Color.white,
            ['content'] = GetLanguageByID(556)
        }
    end
    OpenWindowImmediately("TipsPopUI", self.kAutoEquipTip)
end

-- 显示背包扩容界面
function CharacterUI:ShowBackpackExtend()
    local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    -- 基础容量
    local baseSize = commonConfig.BackpackBaseSize or 0
    self:FindChildComponent(self.ObjExtendListBase, "Num", l_DRCSRef_Type.Text).text = baseSize
    self:FindChildComponent(self.ObjExtendListBase, "State", l_DRCSRef_Type.Text).text = "已激活"
    -- 难度提升容量
    local sizePerDiff = commonConfig.BackpackSizePerDiff or 0
    local diffValue = RoleDataManager:GetInstance():GetDifficultyValue() or 1
    local diffSize = (diffValue - 1) * sizePerDiff
    self:FindChildComponent(self.ObjExtendListDiff, "Title", l_DRCSRef_Type.Text).text = string.format("难度%d", diffValue)
    self:FindChildComponent(self.ObjExtendListDiff, "Num", l_DRCSRef_Type.Text).text = diffSize
    self:FindChildComponent(self.ObjExtendListDiff, "State", l_DRCSRef_Type.Text).text = "已激活"
    -- 成就奖励提升容量
    local iRewardID = 16  -- 包治百病 成就点数奖励
    local kRewardTypeData = TableDataManager:GetInstance():GetTableData("AchieveReward", iRewardID) or {}
    local iRewardSize = kRewardTypeData.RewardValueB or 0
    local bRewardHasChosen = AchieveDataManager:GetInstance():IfAchieveRewardBeenChosen(iRewardID)
    self:FindChildComponent(self.ObjExtendListWeekly, "Num", l_DRCSRef_Type.Text).text = iRewardSize
    self:FindChildComponent(self.ObjExtendListWeekly, "State", l_DRCSRef_Type.Text).text = bRewardHasChosen and "已激活" or "未激活"
    -- 银锭购买
    local buyTimesLimit = commonConfig.BackpackPayTime or 0
    local boughtTimes = 0
    local roleInfo = globalDataPool:getData("MainRoleInfo") or {}
    local mainRoleInfo = roleInfo["MainRole"]
    if mainRoleInfo then
        boughtTimes = mainRoleInfo[MRIT_BUYBAG_FLAG] or 0
    end
    -- 银锭解锁背包格数
    local bugSize = commonConfig.BackpackPaySize or 0
    self:FindChildComponent(self.ObjExtendListBuy, "Num", l_DRCSRef_Type.Text).text = bugSize
    self:FindChildComponent(self.ObjExtendListBuy, "State", l_DRCSRef_Type.Text).text = (boughtTimes > 0) and string.format("已激活(%d/%d)", boughtTimes, buyTimesLimit) or "未激活"
    self:FindChild(self.ObjExtendListBuy, "Button"):SetActive(boughtTimes < buyTimesLimit)
    -- 当前总容量
    self.TextExtendListSum.text = string.format("当前总容量%d", self.backpackSizeLimit or 0)
    self.ObjBackpackExtend:SetActive(true)

    local windowBarUI = WindowsManager:GetInstance():GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetActive(false)
    end
end

function CharacterUI:RefreshTempBackpack()
    self.TextBackpackSizeInTemp.text = string.format("当前已用背包格:%d/%d", RoleDataHelper.GetMainRoleBackpackSize(), self.backpackSizeLimit)
    local TBItem = TableDataManager:GetInstance():GetTable("Item")
    self.TempBackpackNewUICom:ShowPackByInstIDArray(self.tempBackpackItems or {},nil,{
        ['funcSort'] = function(a,b)
            local typeDataA = TBItem[a.uiTypeID]
            local typeDataB = TBItem[b.uiTypeID]
            if typeDataA and typeDataB then
                if typeDataA.Rank ~= typeDataB.Rank then
                    return typeDataA.Rank > typeDataB.Rank
                end
                return typeDataA.BaseID > typeDataB.BaseID
            end
            return false
        end,
    })
end

-- 显示临时背包界面
function CharacterUI:ShowTempBackpack()
    self.TempBackpackUI:SetActive(true)
    self:RefreshTempBackpack()
end

-- 刷新临时背包
function CharacterUI:UpdateTempBackpack()
    if self.TempBackpackUI.activeSelf then
        self.tempBackpackItems = ItemDataManager:GetInstance():GetTempBackpackItems()
        self:RefreshTempBackpack()
    end
end

-- 临时背包物品点击info
function CharacterUI:OnClick_TempBackpackItemInfo(itemID)
    if self.TempBackpackNewUICom:IsItemPicked(itemID) then
        self.TempBackpackNewUICom:UnPickItemByID(itemID)
    else
        self.TempBackpackNewUICom:PickItemByID(itemID, 1, false)
    end
end

-- 临时背包物品点击icon
function CharacterUI:OnClick_TempBackpackItemIcon(obj, itemID)
    local roleID = self.selectRole
    if not (roleID  and itemID) then
        return
    end
    local tips = TipsDataManager:GetInstance():GetItemTips(itemID)
    local strChooseBtn = "选中"
    if self.TempBackpackNewUICom:IsItemPicked(itemID) then
        strChooseBtn = "取消"
    end
    tips.buttons = {
        {
            ["name"] = strChooseBtn,
            ['func'] = function()
                self:OnClick_TempBackpackItemInfo(itemID)
            end
        }
    }
    OpenWindowImmediately("TipsPopUI", tips)
end

-- 临时背包物品移回背包
function CharacterUI:TempBagMoveBack()
    -- 获取到所有选中的物品
    local aiList, aiCount = self.TempBackpackNewUICom:GetPickedItemIDArray()
    local listCount = #aiList

    local iPackSize = RoleDataHelper.GetMainRoleBackpackSize() or 0
    if listCount == 0 then
        SystemUICall:GetInstance():Toast("请选择要取回剧本背包中的物品")
        return
    elseif iPackSize + listCount > self.backpackSizeLimit then
        SystemUICall:GetInstance():Toast("当前剧本背包格数量不足，取回失败")
        return
    end
    aiList[0] = aiList[listCount]
    aiList[listCount] = nil
    SendTempBagMoveBack(listCount, aiList)
    self.TempBackpackNewUICom:UnPickAllItems()
end

-- 更新背包信息栏
function CharacterUI:UpdateBackpackMsgBar()
    -- 背包上限
    local roleInfo = globalDataPool:getData("MainRoleInfo") or {}
    local mainRoleInfo = roleInfo["MainRole"]
    self.backpackSizeLimit = 0
    if mainRoleInfo then
        self.backpackSizeLimit = mainRoleInfo[MRIT_BAG_ITEMNUM] or 0
    end
    -- 当前背包物品数量
    self.TextBackpackSize.text = string.format("背包格:%d/%d", RoleDataHelper.GetMainRoleBackpackSize(), self.backpackSizeLimit)
    -- 存在临时背包数据时, 显示临时背包按钮
    local tempItems = ItemDataManager:GetInstance():GetTempBackpackItems()
    local tempItemsize = RoleDataHelper.GetTempBackpackItemsSize()
    if tempItems and (tempItemsize > 0) then
        self.tempBackpackItems = tempItems
        self.ObjBtnBackpackTemp:SetActive(true)
    else
        self.ObjBtnBackpackTemp:SetActive(false)
    end
end

-- 当前剧本能否带入物品
function CharacterUI:CanCurStoryBringIn()
	local curStoryID = GetCurScriptID()
	local TB_Story = TableDataManager:GetInstance():GetTable("Story")
	local storyData = TB_Story[curStoryID]
	if storyData ~= nil and storyData.bAllowStorageIn == TBoolean.BOOL_NO then
		return false
	end
	return true
end


-- 显示仓库
function CharacterUI:ShowStorage()
    -- local bReturnHouseState = PlayerSetDataManager:GetInstance():GetUnlockHouseState()
    -- if bReturnHouseState == false then
    --   SystemUICall:GetInstance():Toast("解锁酒馆功能后开放仓库")
    --   return
    -- end

    local bCanBringIn = self:CanCurStoryBringIn()
    if (not bCanBringIn) then
      SystemUICall:GetInstance():Toast("当前剧本不允许仓库带入物品")
      return
    end

    OpenWindowByQueue("StorageUI")
end

function CharacterUI:OnClick_Toggle_backpack()
    self.BackpackUI:SetActive(true)
    if not self.packSortFunc then
        local itemManager = ItemDataManager:GetInstance()
        local TB_Item = TableDataManager:GetInstance():GetTable("Item")
        local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
        -- 权重排序
        local martialDepartWeight = {
            [DepartEnumType.DET_DepartEnumTypeNull] = 0, -- -
            [DepartEnumType.DET_MedicalSkill] = 1, -- 医术
            [DepartEnumType.DET_Fly] = 2, -- 轻功
            [DepartEnumType.DET_Soul] = 3, -- 内功
            [DepartEnumType.DET_HiddenWeapon] = 4, -- 暗器
            [DepartEnumType.DET_QiMen] = 5, -- 奇门
            [DepartEnumType.DET_LegMethod] = 6, -- 腿法
            [DepartEnumType.DET_KnifeMethod] = 8, -- 刀法
            [DepartEnumType.DET_SwordMethod] = 9, -- 剑法
            [DepartEnumType.DET_Boxing] = 10, -- 拳掌
        }
        local genWeight = function(kInstItem)
            if not kInstItem then
                return 0
            end
            local itemID = kInstItem.uiID
            local itemBaseID = kInstItem.uiTypeID
            local itemTypeData = TB_Item[itemBaseID]
            if not itemTypeData then
                return 0
            end
            local weight = 0
            -- 第一位 [新: 1, 旧: 0] * 1000
            local bIsNew = itemManager:IsItemNew(itemID) == true
            weight = weight + (bIsNew and 1 or 0) * 1000
            -- 权重分两部分, 第一部分新旧是需要动态数据分析的, 第二部分是纯静态数据分析, 可以直接从缓存里取
            if not self.genWeightSecPart then
                self.genWeightSecPart = {}
            end
            if not self.genWeightSecPart[itemBaseID] then
                local secWeight = 0
                -- 第二位 品质 * 100
                local rank = itemTypeData.Rank
                secWeight = secWeight + rank * 100
                -- 第三位 类型权重
                local departWeight = 0
                local itemType = itemTypeData.ItemType
                local type = TB_ItemType[itemType]
                departWeight = departWeight + type.SortWeight
                -- 如果是秘籍, 加上武学权重
                if itemType == ItemTypeDetail.ItemType_SecretBook then
                    local martial = MartialDataManager:GetInstance():GetMartialTypeDataByItemTypeID(itemTypeData.BaseID)
                    if martial then
                        departWeight = departWeight + (martialDepartWeight[martial.DepartEnum] or 0)
                    end
                end
                secWeight = secWeight + (departWeight / 1000)
                self.genWeightSecPart[itemBaseID] = secWeight
            end
            return weight + (self.genWeightSecPart[itemBaseID] or 0)
        end
        self.packSortFunc = function(a, b)
            local wa = genWeight(a) or 0
            local wb = genWeight(b) or 0
            return wa > wb
        end
    end

    self.abilityNode:SetActive(false)
    self.MartialUI:SetActive(false)
    self.MartialUICom:OnClose()
    self.gift_box:SetActive(false)
    -- self.roleSpine:SetActive(true)
    self.spineRoleUINew:SetActive(true)
    self.chain_box:SetActive(false)
    self.role_equip_box:SetActive(true)
    self.RoleEmbattleUINew:SetActive(false)
    self:UpdateBackpackMsgBar()

    local bShow = GetGameState() == -1
    self.objBackPackUISC:SetActive(not bShow)
    self.objBackPackUIMsg:SetActive(not bShow)
    self.objBackPackUIMask:SetActive(bShow)

    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, "CharacterUI", "OnClick_Toggle_backpack")

    -- 掌门对决屏蔽背包消息栏
    if PKManager:GetInstance():IsRunning() then
        self.objBackPackUIMsg:SetActive(false)
    end

    if  self.bRefreshBackPack == nil then
        self.BackpackNewUIComS:ShowAutoUpdateMainRolePack(true, {
            ['funcSort'] = self.packSortFunc,
        })
        self.bRefreshBackPack = true
        self:RefreshSpine()
        self:RefreshEquipItem()
        self:RefreshTitleName()
    end

    self:SetTittleTxt("物品")
end

function CharacterUI:OnClick_Toggle__embattle()
    self.BackpackUI:SetActive(false)
    self.abilityNode:SetActive(false)
    self.MartialUI:SetActive(false)
    self.MartialUICom:OnClose()
    self.gift_box:SetActive(false)
    -- self.roleSpine:SetActive(true)
    self.spineRoleUINew:SetActive(false)
    self.RoleEmbattleUINew:SetActive(true)
    self.RoleEmbattleUINewCom:OnEnable()
    self.RoleEmbattleUINewCom:RefreshUI({bShowWheelWar = false})
    self.chain_box:SetActive(false)
    self.role_equip_box:SetActive(false)
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, "CharacterUI", "OnClick_Toggle__embattle")


    self:SetTittleTxt("布阵")
end

function CharacterUI:OnClick_Toggle_ability()
    self.BackpackUI:SetActive(false)
    self.abilityNode:SetActive(true)
    self.MartialUI:SetActive(false)
    self.MartialUICom:OnClose()
    self.gift_box:SetActive(false)
    -- self.roleSpine:SetActive(true)
    self.spineRoleUINew:SetActive(true)

    self.chain_box:SetActive(false)
    self.role_equip_box:SetActive(false)
    self.RoleEmbattleUINew:SetActive(false)
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, "CharacterUI", "OnClick_Toggle_ability")

    if self.bRefreshAbility == nil then
        self:InitPoint()
        self:RefreshAbility()
        self:RefreshCG()
        self.bRefreshAbility  = true
    end

    self:SetTittleTxt("属性")
end

function CharacterUI:OnClick_Toggle_martial()
    self.MartialUI:SetActive(true)
    self.BackpackUI:SetActive(false)
    self.abilityNode:SetActive(false)
    self.gift_box:SetActive(false)
    -- self.roleSpine:SetActive(false)
    self.spineRoleUINew:SetActive(false)
    self.chain_box:SetActive(false)
    self.role_equip_box:SetActive(false)
    self.role_equip_box:SetActive(false)
    self.RoleEmbattleUINew:SetActive(false)
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, "CharacterUI", "OnClick_Toggle_martial")

    -- 改成全刷新
    self.MartialUICom:UpdateMartialByRole(self.selectRole)

    -- if self.bRefreshMartial == nil then
    --     self.bRefreshMartial  = true
    -- end
    self:SetTittleTxt("武学")
end

function CharacterUI:OnClick_Toggle_gift()
    self.MartialUI:SetActive(false)
    self.MartialUICom:OnClose()
    self.BackpackUI:SetActive(false)
    self.abilityNode:SetActive(false)
    self.gift_box:SetActive(true)
    -- self.roleSpine:SetActive(false)
    self.spineRoleUINew:SetActive(false)
    self.chain_box:SetActive(false)
    self.role_equip_box:SetActive(false)
    self.RoleEmbattleUINew:SetActive(false)
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, "CharacterUI", "OnClick_Toggle_gift")
    -- 改成全刷新
    self:RefreshGift()
    -- if self.bRefreshGift == nil then
    --     self:RefreshGift()
    --     self.bRefreshGift  = true
    -- end
    self:SetTittleTxt("天赋")
end

function CharacterUI:OnClick_Toggle_chain()
    self.MartialUI:SetActive(false)
    self.MartialUICom:OnClose()
    self.BackpackUI:SetActive(false)
    self.abilityNode:SetActive(false)
    self.gift_box:SetActive(false)
    -- self.roleSpine:SetActive(false)
    self.spineRoleUINew:SetActive(false)
    self.chain_box:SetActive(true)
    self.role_equip_box:SetActive(false)
    self.RoleEmbattleUINew:SetActive(false)
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, "CharacterUI", "OnClick_Toggle_chain")

    if self.bReFreshChain == nil then
        self:RefreshWishTask()
        self:UpdateRoleChain()
        self:UpdateCityDispositionChain()
        self:UpdateClanDispositionChain()
        self.bReFreshChain = true
    end
    self:SetTittleTxt("情缘")
end
----------------------------------------------------
function CharacterUI:OnClick_Toggle_basic()
    self.basic_box:SetActive(true)
    self.detail_box:SetActive(false)
    self.round_box:SetActive(false)
    self.backpack_box:SetActive(false)
end
function CharacterUI:OnClick_Toggle_detail()
    self.basic_box:SetActive(false)
    self.detail_box:SetActive(true)
    self.round_box:SetActive(false)
    self.backpack_box:SetActive(false)

    self:FilterSize(self.defence_box.transform.parent.gameObject)
end
function CharacterUI:OnClick_Toggle_round()
    self.basic_box:SetActive(false)
    self.detail_box:SetActive(false)
    self.round_box:SetActive(true)
    self.backpack_box:SetActive(false)

    self:FilterSize(self.difficulty_box.transform.parent.gameObject)
end
function CharacterUI:OnClick_Toggle_backpack2()
    self.basic_box:SetActive(false)
    self.detail_box:SetActive(false)
    self.round_box:SetActive(false)
    self.backpack_box:SetActive(true)    
end
----------------------------------------------------
function CharacterUI:SetWindowBar()
    OpenWindowBar({
        ['windowstr'] = "CharacterUI",
        --['titleName'] = "角色",
        ['topBtnState'] = {  --决定顶部栏资源显示状态
            ['bBackBtn'] = true,
            ['bGoodEvil'] = true,
            ['bCoin'] = true,
        },
        ['callback'] = function()
            -- 关闭队伍界面的时候清除所有新物品的标记
            ItemDataManager:GetInstance():ClearNewItemFlag()
            if self.MartialUICom then
                self.MartialUICom:OnClose()
            end
            if self.callBack then
                self.callBack()
            end
        end
    })

    self.windowBarUI = GetUIWindow("WindowBarUI")
    if GetGameState() == -1 then
        self.windowBarUI.resource_box:SetActive(false)
    else
        self.windowBarUI.resource_box:SetActive(true)
    end
end

function CharacterUI:SetTriggerDontUpdateBackPack()
    self.bTriggerDontUpdateBackPack = true
end

function CharacterUI:SetTittleTxt(str)
    self.txtTitle.text = str
end

function CharacterUI:OnEnable()
    -- self:SetWindowBar()
    self.array_attr_due_to_point = {}
    -- 打开队伍界面的时候, 设置一下背包的刷新
    if self.bTriggerDontUpdateBackPack then
        self.bTriggerDontUpdateBackPack = false
    else
        self.BackpackNewUIComS:ShowAutoUpdateMainRolePack()
    end
    -- 刷新底部栏信息
    self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateBackpackMsgBar)
    -- 通过 背包界面->仓库 可以看到收集活动掉落的资源, 所以请求一下收集活动的数据以同步收集活动的id
    ResDropActivityDataManager:GetInstance():RequestResDropCollectActivityOnce()


    -- 掌门对决特殊处理
    if PKManager:GetInstance():IsRunning() then
        local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
        if roleData then
            PKManager:GetInstance():UpdateRole(self.selectRole)
        else
            self:RefreshUI()
        end
    end

    self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function()
        self:RefreshCG()
    end)
end

function CharacterUI:OnDisable()
    RemoveWindowBar('CharacterUI')
    self.timer_AddPonitTips = nil
    self:RemoveEventListener("UPDATE_MAIN_ROLE_INFO")
    self:ReturnUIClass()
end

local wins = {
    "GeneralBoxUI",
    "PickGiftUI",
    "ForgetMartialGiftUI",
    "PickWishRewardsUI",
    "DisguiseUI",
    "IncompleteBoxUI"
}

function CharacterUI:ShowSpine()
    if  self.Toggle_backpack.isOn ~= true then --不是物品切页的时候 不显示spine

    else
        self.spineRoleUINew:SetActive(true)
    end
end

function CharacterUI:HideSpine()
    self.spineRoleUINew:SetActive(false)
end

function CharacterUI:OnPressESCKey()
    if IsInDialog() then return end
    if IsAnyWindowOpen(wins) then return end
    if self.MartialUICom and self.MartialUICom:IsBattleAIUIShow() then 
        self.MartialUICom.AIUICom.comBtnExit.onClick:Invoke()
        return
    end
    if self.btnExit then
        self.btnExit.onClick:Invoke()
    end
end

function CharacterUI:OnDestroy()
    self.BackpackNewUIComS:Close()
    self.TempBackpackNewUICom:Close()
    self.TeamListUICom:Close()
    self.MartialUICom:Close()
    self.RoleEmbattleUINewCom:Close()
    self:ReturnUIClass()
    
	RemoveEventTrigger(self.objButton)

	--[TODO] 如果后面 setparent开销太高，按LUA_CLASS_TYPE 分类，UI里自己再做一层缓存，不直接使用ReturnAllUIClass
    if #self.equipIconItemUI > 0 then
        for index, value in ipairs(self.equipIconItemUI) do
            local comButton = value._gameObject:GetComponent(l_DRCSRef_Type.Button)
            value:RemoveButtonClickListener(comButton)
            value:SetDefaultClickListener()
            LuaClassFactory:GetInstance():ReturnUIClass(value)
        end
		-- LuaClassFactory:GetInstance():ReturnAllUIClass(self.equipIconItemUI)
		self.equipIconItemUI = {}
	end

    for k,v in pairs(self.eventButton) do
        RemoveEventTrigger(v)
    end
end

function CharacterUI:UpdateData()

end

function CharacterUI:FilterSize(obj)
    local _func
    _func = function(gameObject, uiObjArray)

        local csf = gameObject:GetComponent(l_DRCSRef_Type.ContentSizeFitter)
        if csf then
            table.insert(uiObjArray, gameObject)
        end

        for k, v in pairs(gameObject.transform) do
            _func(v.gameObject, uiObjArray)
        end
    end

    local uiObjArray = {}
    _func(obj, uiObjArray)

    for i = #(uiObjArray), 1, -1 do
        local rtf = uiObjArray[i]:GetComponent(l_DRCSRef_Type.RectTransform)
        l_DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)
    end
end

function CharacterUI:SetMainRoleInfoActive(bActive)
    self:FindChild(self.nav_box, '3'):SetActive(bActive)
    self:FindChild(self.nav_box, '4'):SetActive(not bActive)
    if bActive then
        if self:FindChildComponent(self.nav_box, '4',"Toggle").isOn then
            self:FindChildComponent(self.nav_box, '3',"Toggle").isOn = true
            self:FindChildComponent(self.nav_box, '4',"Toggle").isOn = false
            self:OnClick_Toggle_round()
        end
    else
        if self:FindChildComponent(self.nav_box, '3',"Toggle").isOn then
            self:FindChildComponent(self.nav_box, '4',"Toggle").isOn = true
            self:FindChildComponent(self.nav_box, '3',"Toggle").isOn = false
            self:OnClick_Toggle_backpack2()
        end
    end
end

function CharacterUI:SetCallBack(callBack)
    self.callBack = callBack
end

-- 更新队友上限信息
function CharacterUI:UpdateTeamLimitMsg()
    if not (self.textTeammateLimit and self.TeamListUICom) then
        return
    end
    local iCur = self.TeamListUICom:GetCurTeammateNum() or 0
    local iMax = RoleDataManager:GetInstance():GetCurTeammateLimit() or 0
    self.textTeammateLimit.text = string.format("(%d/%d)", iCur, iMax)
end

function CharacterUI:OnClickTeammateLimitTips()
    if not self.kLimitTip then
        self.kLimitTip = {
            ['kind'] = 'wide',
            ['title'] = "队友上限",
            ['titlecolor'] = l_DRCSRef.Color.white,
            ['content'] = "队友上限50个，百宝书壕侠玩家上限100个。\n设置队友上限的原因是，我们正在优化角色数据量大小过程中。未来解决问题后，必定会免费提升更高队友上限。请大侠海涵。"
        }
    end
    OpenWindowImmediately("TipsPopUI", self.kLimitTip)
end

function CharacterUI:OnClick_Toggle_Chain_Role(isActive)
    if isActive then
        self.objRoleChainList:SetActive(true)
        self.objRoleChainBox:SetActive(true)
        self:UpdateRoleChain()
    else
        self.objRoleChainList:SetActive(false)
        self.objRoleChainBox:SetActive(false)
        self:HideAllObjectInPool(self.roleChainObjectPool)
    end
end

function CharacterUI:OnClick_Toggle_Chain_City(isActive)
    if isActive then
        self.objCityChainList:SetActive(true)
        self.objCityChainBox:SetActive(true)
        self:UpdateCityDispositionChain()
    else
        self.objCityChainList:SetActive(false)
        self.objCityChainBox:SetActive(false)
        self:HideAllObjectInPool(self.cityChainObjectPool)
    end
end

function CharacterUI:UpdateCityDispositionChain()
    if not self.objCityChainList.activeSelf then
        return
    end
    -- 优先回收池子，防止多次实例
    self:HideAllObjectInPool(self.cityChainObjectPool)
    local commonConfig = TableDataManager:GetInstance():GetTableData('CommonConfig', 1)
    local mainCityList = commonConfig.MainCitys
    if not mainCityList then
        return
    end
    for _, cityBaseID in ipairs(mainCityList) do
        local objInfo = self:GetObjectFromPool(self.cityChainObjectPool, self.objCityChainObject, self.objCityChainList)
        objInfo:SetActive(true)
        local cityBaseData = TableDataManager:GetInstance():GetTableData('City', cityBaseID)
        -- 城市图标
        local comImageCity = self:FindChildComponent(objInfo, 'Icon_city', l_DRCSRef_Type.Image)
        comImageCity.sprite = GetSprite(cityBaseData.CityInfoIcon)
        GetAtlasSprite("BigmapAtlas", cityBaseData.CityIconImage)
        -- 城市名称
        local comTextCityName = self:FindChildComponent(objInfo, 'name', l_DRCSRef_Type.Text)
        comTextCityName.text = GetLanguageByID(cityBaseData.NameID)
        -- 好感度值
        local dispositionValue = CityDataManager:GetInstance():GetDisposition(cityBaseID)
        local dispositionDesc = GetDispositionDesc(dispositionValue)
        local comTextDispositionValue = self:FindChildComponent(objInfo, 'value', l_DRCSRef_Type.Text)
        local comTextDispositionDesc = self:FindChildComponent(objInfo, 'value/mark', l_DRCSRef_Type.Text)
        comTextDispositionValue.text = dispositionValue
        comTextDispositionDesc.text = '(' .. dispositionDesc .. ')'
    end
end

function CharacterUI:OnClick_Toggle_Chain_Clan(isActive)
    if isActive then
        self.objClanChainList:SetActive(true)
        self.objClanChainBox:SetActive(true)
        self:UpdateClanDispositionChain()
    else
        self.objClanChainList:SetActive(false)
        self.objClanChainBox:SetActive(false)
        self:HideAllObjectInPool(self.clanChainObjectPool)
    end
end

function CharacterUI:UpdateClanDispositionChain()
    if not self.objClanChainList.activeSelf then
        return
    end
    self:HideAllObjectInPool(self.clanChainObjectPool)
    local clanDataMgr = ClanDataManager:GetInstance()
    local mainRoleClan = RoleDataManager:GetInstance():GetMainRoleClanTypeID()
    local clanTable = TableDataManager:GetInstance():GetTable('Clan')
    -- 因为数量比较少, 直接用基础 UI
    -- 先把门派全部取出并排序
    local clanList = {}
    for _, clanTypeData in pairs(clanTable) do
        if clanTypeData.Type ~= ClanType.CLT_Null then
            table.insert(clanList, clanTypeData)
        end
    end
    table.sort(clanList, function(clanBaseDataA, clanBaseDataB)
        if (clanBaseDataA.BaseID == mainRoleClan) then
            return true
        elseif (clanBaseDataB.BaseID == mainRoleClan) then
            return false
        end
        local clanStateA = clanDataMgr:GetClanState(clanBaseDataA.BaseID)
        local clanStateB = clanDataMgr:GetClanState(clanBaseDataB.BaseID)
        if clanStateA ~= clanStateB then
            return (clanStateA or 0) > (clanStateB or 0)
        end
        -- 大门派显示在小门派前面
        local isASmallClan = clanDataMgr:IsSmallClan(clanBaseDataA.BaseID)
        local isBSmallClan = clanDataMgr:IsSmallClan(clanBaseDataB.BaseID)
        if isASmallClan ~= isBSmallClan then
            if isASmallClan then
                return false
            else
                return true
            end
        end
        local dispositionA = clanDataMgr:GetDisposition(clanBaseDataA.BaseID)
        local dispositionB = clanDataMgr:GetDisposition(clanBaseDataB.BaseID)
        return dispositionA > dispositionB
    end)
    for _, clanTypeData in ipairs(clanList) do
        if clanTypeData.Type ~= ClanType.CLT_Null then
            local clanBaseID = clanTypeData.BaseID
            local clanState = clanDataMgr:GetClanState(clanBaseID)
            local objInfo = self:GetObjectFromPool(self.clanChainObjectPool, self.objClanChainObject, self.objClanChainList)
            objInfo:SetActive(true)
            -- 门派图标
            local comImageClan = self:FindChildComponent(objInfo, 'Icon_clan', l_DRCSRef_Type.Image)
            comImageClan.sprite = GetSprite(clanTypeData.SmallIconPath)
            -- 门派名称
            local comTextName = self:FindChildComponent(objInfo, 'name', l_DRCSRef_Type.Text)
            comTextName.text = GetLanguageByID(clanTypeData.NameID)
            -- 门派状态
            local comTextClanState = self:FindChildComponent(objInfo, 'state', l_DRCSRef_Type.Text)
            comTextClanState.text = ClanStateDesc[clanState] or ''
            -- 是否是主角门派
            local comImageSelfClanMark = self:FindChildComponent(objInfo, 'mark_mine', l_DRCSRef_Type.Image)
            if clanBaseID == mainRoleClan then
                local color = comImageSelfClanMark.color
                color.a = 1
                comImageSelfClanMark.color = color
            else
                local color = comImageSelfClanMark.color
                color.a = 0
                comImageSelfClanMark.color = color
            end
            -- 好感度值
            local dispositionValue = clanDataMgr:GetDisposition(clanBaseID)
            local dispositionDesc = GetDispositionDesc(dispositionValue)
            local comTextDispositionValue = self:FindChildComponent(objInfo, 'value', l_DRCSRef_Type.Text)
            local comTextDispositionDesc = self:FindChildComponent(objInfo, 'value/mark', l_DRCSRef_Type.Text)
            comTextDispositionValue.text = dispositionValue
            comTextDispositionDesc.text = '(' .. dispositionDesc .. ')'
        end
    end
end

function CharacterUI:UpdateRelationTag()
    self.objRoleChainBox:SetActive(false)
    self.objCityChainBox:SetActive(false)
    self.objClanChainBox:SetActive(false)
    if self.selectRole == self.iMainRoleID then
        -- 选中主角的时候, 关系界面不显示 角色关系 按钮
        self.objToggleRoleChain:SetActive(false)
        self.objToggleCityChain:SetActive(true)
        self.objToggleClanChain:SetActive(true)
        self.comToggleRoleChain.isOn = false
        self.comToggleCityChain.isOn = true
        self.comToggleClanChain.isOn = false
        self:OnClick_Toggle_Chain_City(true)
    else
        self.objToggleRoleChain:SetActive(true)
        self.objToggleCityChain:SetActive(false)
        self.objToggleClanChain:SetActive(false)
        self.comToggleRoleChain.isOn = true
        self.comToggleCityChain.isOn = false
        self.comToggleClanChain.isOn = false
        -- 选中其他角色的时候, 关系界面不显示 城市关系 和 门派关系 按钮
        self:HideAllObjectInPool(self.cityChainObjectPool)
        self:HideAllObjectInPool(self.clanChainObjectPool)
        self:OnClick_Toggle_Chain_Role(true)
    end
end

function CharacterUI:ResetMode(mode)
    local isAI = mode == 'ai'
    local notAI = not isAI
    self.AI_mode = isAI
    self.leftNode:SetActive(notAI)
    self.rightNode:SetActive(notAI)
    if self.windowBarUI then
        self.windowBarUI.skipDefaultBackCallback = isAI
    end
    if isAI then
        local bar = self.windowBarUI
        if bar then
            bar.resource_box:SetActive(false)
            bar.objTextUIName:SetActive(true)
            bar.objImageUIName:SetActive(true)
            bar.comTextUIName.text = '行动方式'
        end
    else
        RemoveWindowBar()
        -- self:SetWindowBar()
    end
end

function CharacterUI:GetRemainDay()
	local resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()
	return (resDayStr or 0) .. UIConstStr["NpcConsultUI_Day"] 
end

-- 是否允许切磋
function CharacterUI:IsCanCompare()
	local uiTaskTagTypeid = 0
	TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid)
	local favorData = RoleDataManager:GetInstance():GetDispotionDataToMainRole(self.selectRole)
	if favorData and favorData.iValue and favorData.iValue < 20 then
		return false, UIConstStr["SelectUI_Favor"],false
	end

	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectRole, NPCIT_COMPARE)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr 
		return false, des, true
	end

	return true, ""
end

function CharacterUI:CompareWithInteractRole()
	local compareEnabele, des, needRefresh = self:IsCanCompare()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_COMPARE , uiRoleID = self.selectRole}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		AddLoadingDelayRemoveWindow('CharacterUI')
		SendNPCInteractOperCMD(NPCIT_COMPARE, self.selectRole)
	end
end

-- 是否允许乞讨
function CharacterUI:IsCanBeg()
	local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(self.selectRole)
	if not dispoValue or dispoValue < 0 then
		return false, UIConstStr["SelectUI_Favor0"],false
	end

	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectRole, NPCIT_BEG)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr 
		return false, des, true
	end

	return true, ""
end

function CharacterUI:BegInteractRole()
	local begEnabele, des, needRefresh = self:IsCanBeg()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_BEG , uiRoleID = self.selectRole}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		AddLoadingDelayRemoveWindow('CharacterUI')
		SendNPCInteractOperCMD(NPCIT_BEG, self.selectRole, nil)
	end
end

-- 是否允许盘查
function CharacterUI:IsCanInquiry()
	-- 检查盘查是否开启
	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectRole, NPCIT_INQUIRY)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr 
		return false, des, true
	end
	
	return true, ""
end

function CharacterUI:InquiryInteractRole()
	local InquiryEnabele, des, needRefresh = self:IsCanInquiry()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_INQUIRY , uiRoleID = self.selectRole}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		AddLoadingDelayRemoveWindow('CharacterUI')
		SendNPCInteractOperCMD(NPCIT_INQUIRY, self.selectRole, nil)
	end
end

function CharacterUI:LearnMartial()
	local needRefresh = not RoleDataManager:GetInstance():InteractAvailable(self.selectRole, NPCIT_STEAL_CONSULT)
	if needRefresh then
		local info = {type = NPCIT_REFRESH_CONSULT , uiRoleID = self.selectRole}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		OpenWindowByQueue("NpcConsultUI", {self.selectRole})
	end
end

function CharacterUI:ShowDuelSelection()
	OpenWindowImmediately("DialogChoiceUI")
    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
	if dialogChoiceUI then
		local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
    	dialogChoiceUI:UpdateChoiceText(180027, roleData.uiTypeID)
		dialogChoiceUI:AddChoice(180028, function()	
			AddLoadingDelayRemoveWindow('DialogChoiceUI')
			SendNPCInteractOperCMD(NPCIT_FIGHT, self.selectRole)
		end)
		dialogChoiceUI:AddChoice(180029, function()	
			ResetWaitDisplayMsgState()
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
		end)
	end
	RemoveWindowImmediately('CharacterUI')
end

-- 是否允许惩恶
function CharacterUI:IsCanPunish()
	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectRole, NPCIT_PUNISH)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr
		return false, des, true
	end
	if MapDataManager:GetInstance():GetCurMapID() == PRISON_MAP_ID then
		return false
	end
	return true
end

function CharacterUI:ClickPunish()
	local punishEnabele, des, needRefresh = self:IsCanPunish()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_PUNISH , uiRoleID = self.selectRole}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		SendNPCInteractOperCMD(NPCIT_PUNISH, self.selectRole)
		AddLoadingDelayRemoveWindow('SelectUI')
	end
end

-- 是否允许决斗
function CharacterUI:IsCanDuel()
	local dbData = RoleDataManager:GetInstance():GetRoleTypeDataByID(self.selectRole)
	-- EvoKill = false 表示可以决斗 名字跟含义有出入 有点迷惑
	if dbData then
		if dbData.KillCond > 0 then
			do return false end

			local bCond = TeamCondition:GetInstance():CheckTeamCondition(dbData.KillCond, true)
			if not bCond then
				return false
			end	
		end
	end
	if MapDataManager:GetInstance():GetCurMapID() == PRISON_MAP_ID then
		return false
	end
	return true
end

-- 盘查功能是否解锁
function CharacterUI:IsInquiryUnlock()
	-- 监牢不允许盘查
	if MapDataManager:GetInstance():GetCurMapID() == 661 then
		return false
	end
	return RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_INQUIRY)
end

function CharacterUI:SetButtonHightState()
	local iNum = self.objInteractGroup2.transform.childCount
	for i = 0, iNum -1  do
		local str = self.akInteractData[i + 1] 
		local kChild = self.objInteractGroup2.transform:GetChild(i)
		local comLuaAction = kChild:GetComponent('LuaUIPointAction')
        if comLuaAction then 
            comLuaAction:SetPointerEnterAction(function()
				local objShader = self:FindChild(comLuaAction.gameObject, "Shader")
				if not objShader then
					self:SetButtonHight(kChild, true, str)
				else
					if not objShader.activeSelf then
						self:SetButtonHight(kChild, true, str)
					else
						self:SetTitleShow(kChild, true, str)
					end
				end
            end)
            comLuaAction:SetPointerExitAction(function()
                self:SetButtonHight(kChild, false, str)
            end)
			comLuaAction:SetPointerUpAction(function()
                self:SetButtonHight(kChild, false, str)
            end)
        end
	end
end

local sUsuallyIconPath = "DialogueUI/bt_tongyongyuandi"
local sHightIconPath = "DialogueUI/bt_tongyongyuandi_ss"

function CharacterUI:SetButtonHight(kObject, bHight, str)
	local comImage = kObject:GetComponent("Image")
	if bHight then
		self.objShowImageText.text = str
		self.comBGRectTransform = self.objShowImage:GetComponent("RectTransform")
		self.iBGWidth = self.comBGRectTransform.rect.width
		self.objShowImage:SetActive(true)
		local pos = DRCSRef.Camera.main:WorldToScreenPoint(kObject.transform.position + DRCSRef.Vec3(0,2.5,0))
		local scWidth = CS.UnityEngine.Screen.width
		local iScale = scWidth / design_ui_w
		if pos.x + self.iBGWidth * iScale > scWidth then
			pos.x = pos.x - (self.iBGWidth - 285) * iScale
		end
		local newPos = DRCSRef.Camera.main:ScreenToWorldPoint(pos)
		self.objShowImage.transform.position = newPos
		comImage.sprite = GetSprite(sHightIconPath)
	else
		self.objShowImage:SetActive(false)
		comImage.sprite = GetSprite(sUsuallyIconPath)
	end
end

-- just show the little title
function CharacterUI:SetTitleShow(kObject, bHight, str)
	if bHight then
		self.objShowImageText.text = str
		self.comBGRectTransform = self.objShowImage:GetComponent("RectTransform")
		self.iBGWidth = self.comBGRectTransform.rect.width
		self.objShowImage:SetActive(true)
		local pos = DRCSRef.Camera.main:WorldToScreenPoint(kObject.transform.position + DRCSRef.Vec3(0,2.5,0))
		local scWidth = CS.UnityEngine.Screen.width
		local iScale = scWidth / design_ui_w
		if pos.x + self.iBGWidth * iScale > scWidth then
			pos.x = pos.x - (self.iBGWidth - 285) * iScale
		end
		local newPos = DRCSRef.Camera.main:ScreenToWorldPoint(pos)
		self.objShowImage.transform.position = newPos
	else
		self.objShowImage:SetActive(false)
	end
end

function CharacterUI:ReturnUIClass()
	--[TODO] 如果后面 setparent开销太高，按LUA_CLASS_TYPE 分类，UI里自己再做一层缓存，不直接使用ReturnAllUIClass
	if #self.akEquipmentItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akEquipmentItemUIClass)
		self.akEquipmentItemUIClass = {}
	end
end

return CharacterUI