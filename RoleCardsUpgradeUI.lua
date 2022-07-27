RoleCardsUpgradeUI = class('RoleCardsUpgradeUI', BaseWindow)

local SpineRoleUINew = require 'UI/Role/SpineRoleUINew'
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local l_DRCSRef_Type = DRCSRef_Type
local TAB_TYPE = {
    ABILITY = 1,
    Bond = 2,
}
local NAV_TPYE = {
    RANK = 1,
    GRADE = 2,
    PIECE = 3,
}
local SORT_TPYE = {
    SEQUENCE = 1,
    INVERTE = 2,
}
local map_bIfRank = {
    ['Sort_Rank_SEQUENCE'] = true,
    ['Sort_Rank_INVERTE'] = true,
    ['Sort_Grade_SEQUENCE'] = false,
    ['Sort_Grade_INVERTE'] = false,
}
local map_bIfInverte = {
    ['Sort_Rank_SEQUENCE'] = false,
    ['Sort_Rank_INVERTE'] = true,
    ['Sort_Grade_SEQUENCE'] = false,
    ['Sort_Grade_INVERTE'] = true,
}
local CardsMgr
local CARD_LV_LMT_BY_RANK = {10,10,10,10,10,10,10,10,10,10}
local COLOR_WHITE = DRCSRef.Color(1, 1, 1, 1)
local COLOR_BlACK = DRCSRef.Color(0, 0, 0, 0.8)
local next_grade = function(igrade, rank)
    igrade = igrade or 0
    local grade = CARD_LV_LMT_BY_RANK[rank or 1] or 10;
    if igrade >= grade then
        return grade;
    end
    return math.min(igrade + 1,10) 
end
local IfNotMaxGrade = function(igrade,rank)
    return igrade ~= next_grade(igrade,rank)
end
local func_checkSortType = function(a,b,etype)
    -- 0 rank 
    -- 1 grade
    -- 2 id 
    -- 优先排序选择的，再排序另一个，最后排序id
    if map_bIfRank[etype] and a.rank ~= b.rank then 
        return 0 
    elseif not map_bIfRank[etype] and a.grade ~= b.grade then 
        return 1
    elseif map_bIfRank[etype] and a.grade ~= b.grade then 
        return 1
    elseif not map_bIfRank[etype] and a.rank ~= b.rank then 
        return 0
    else 
        return 2
    end
end 
local SortFunction = function(a,b,etype)
    local acanlvup = a.needpiece <= a.piece and IfNotMaxGrade(a.grade,a.roledata and a.roledata.Rank)
    local bcanlvup = b.needpiece <= b.piece and IfNotMaxGrade(b.grade,b.roledata and b.roledata.Rank)
    if acanlvup == bcanlvup and a.unlock == b.unlock  then
        local bRet = false 
        local SortT = func_checkSortType(a,b,etype)
        if SortT == 0 then 
            if map_bIfInverte[etype] then 
                return a.rank > b.rank 
            else 
                return a.rank < b.rank 
            end 
        elseif SortT == 1 then 
            if map_bIfInverte[etype] then 
                return a.grade > b.grade 
            else 
                return a.grade < b.grade 
            end
        else 
            return a.roleid < b.roleid  
        end 
    elseif a.unlock ~= b.unlock then 
        return a.unlock 
    else
        return acanlvup 
    end
end
function RoleCardsUpgradeUI:ctor()
	local obj = LoadPrefabAndInit('CardsUpgradeUI/RoleCardsUpgradeUI', UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
    self.ItemIconUI = ItemIconUI.new()
end

function RoleCardsUpgradeUI:Create()
end

function RoleCardsUpgradeUI:Init()

    self.objWindowTabUI = self:FindChild(self._gameObject, 'WindowTabUI')
    self.objNavbox = self:FindChild(self._gameObject, 'NPCList/Nav_box')
    self.comButton_back = self:FindChildComponent(self._gameObject, 'TransformAdapt_node_left/Button_back','Button')
    if self.comButton_back then
        self:AddButtonClickListener(self.comButton_back,function ()
            if self.close_to_collection then 
                OpenWindowImmediately("CollectionUI")
            end
            if self.iRetCollectionPoint then 
                SendUpdateCollectionPoint()
            end 
            RemoveWindowImmediately("RoleCardsUpgradeUI", false)
            LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
        end)
    end

    self.objTab_box = self:FindChild(self._gameObject,"WindowTabUI/TransformAdapt_node_right/Tab_box")
    self.Toggle_ability = self:FindChildComponent(self.objTab_box,"Tab_toggle1",l_DRCSRef_Type.Toggle)
    if self.Toggle_ability then
        local fun = function(bool)
            if bool then
                self:RefreshChooseTab(TAB_TYPE.ABILITY)
            end
        end
        self:AddToggleClickListener(self.Toggle_ability,fun)
    end

    self.Toggle_Bond = self:FindChildComponent(self.objTab_box,"Tab_toggle2",l_DRCSRef_Type.Toggle)
    if self.Toggle_Bond then
        self.Toggle_Bond.gameObject:SetActive(QuerySystemIsOpen(SGLST_RELATION_BOND))
        local fun = function(bool)
            if bool then
                self:RefreshChooseTab(TAB_TYPE.Bond)
            end
        end
        self:AddToggleClickListener(self.Toggle_Bond,fun)
    end
    self.objToggleRedPoint_ability = self:FindChild(self.objTab_box,"Tab_toggle1/img_up")
    self.objToggleRedPoint_bond = self:FindChild(self.objTab_box,"Tab_toggle2/img_up")
    
    self.comToggle_grade = self:FindChildComponent(self.objNavbox,"1","Toggle")
    self.comToggle_grade_Text = self:FindChildComponent(self.objNavbox,"1/Text","Text")
    self.comToggle_grade_Text.text = '等级'
    self.objToggle_grade_Arrow = self:FindChild(self.objNavbox,"1/Arrow")
    if self.comToggle_grade then
        local fun = function(bool)
            self.objToggle_grade_Arrow:SetActive(bool)
            if bool then
                self.comToggle_grade_Text.color = COLOR_WHITE
                self:OnClick_Toggle_Nav(NAV_TPYE.GRADE)
            else
                self.comToggle_grade_Text.color = COLOR_BlACK
            end
        end
        self:RemoveToggleClickListener(self.comToggle_grade)
        self:AddToggleClickListener(self.comToggle_grade,fun)
    end

    self.comToggle_rank = self:FindChildComponent(self.objNavbox,"2","Toggle")
    self.comToggle_rank_Text = self:FindChildComponent(self.objNavbox,"2/Text","Text")
    self.comToggle_rank_Text.text = '品质'
    self.objToggle_rank_Arrow = self:FindChild(self.objNavbox,"2/Arrow")
    if self.comToggle_rank then
        local fun = function(bool)
            self.objToggle_rank_Arrow:SetActive(bool)
            if bool then
                self.comToggle_rank_Text.color = COLOR_WHITE
                self:OnClick_Toggle_Nav(NAV_TPYE.RANK)
            else
                self.comToggle_rank_Text.color = COLOR_BlACK
            end
        end
        self:RemoveToggleClickListener(self.comToggle_rank)
        self:AddToggleClickListener(self.comToggle_rank,fun)
    end
    self.objPanal_Bond = self:FindChild(self._gameObject, 'Bond')
    self.comBtn_BondInfoAll = self:FindChildComponent(self.objPanal_Bond,'AllBond','DRButton')
    if self.comBtn_BondInfoAll then
        self:AddButtonClickListener(self.comBtn_BondInfoAll,function()
            self:Onclick_Btn_AllBond(true)
        end )
    end

    self.obj_BondChild = self:FindChild(self.objPanal_Bond,'SC_formula/Child')
    if self.obj_BondChild then 
        self.obj_BondChild:SetActive(false)
    end
    self.obj_BondChildHead = self:FindChild(self.objPanal_Bond,'SC_formula/Head')
    if self.obj_BondChildHead then 
        self.obj_BondChildHead:SetActive(false)
    end
    self.comLoopSVBond = self:FindChildComponent(self.objPanal_Bond,"SC_formula","LoopVerticalScrollRect")
    if self.comLoopSVBond then
        self.comLoopSVBond:AddListener(function(...) self:OnBondChanged(...) end)
    end


    self.objPanal_RoleInfo = self:FindChild(self._gameObject, 'RoleInfo')
    self.objActor_BaseInfoSpine = self:FindChild(self.objPanal_RoleInfo, 'Base_Actor')
    self.spineRoleUINew = SpineRoleUINew.new()
    self.spineRoleUINew:SetGameObject(self.objPanal_RoleInfo)
    self.spineRoleUINew:SetSpine(self.objActor_BaseInfoSpine,false)
    self.spineRoleUINew:SetDefaultScale(60)

    self.obj_TextChildInfo = self:FindChild(self.objPanal_RoleInfo,'Text_child_tips')
    self.obj_TextChildInfo:SetActive(false)
    self.InitScale = self.objActor_BaseInfoSpine.transform.localScale

    self.comEffect_lvup = self:FindChildComponent(self.objPanal_RoleInfo, 'ef_lv_up','ParticleSystem')

    self.comText_BaseInfoName =  self:FindChildComponent(self.objPanal_RoleInfo, 'Text_Name',"Text")
    self.comText_BaseInfoTitle =  self:FindChildComponent(self.objPanal_RoleInfo, 'Text_Title',"Text")

    self.objBaseInfoPanal =  self:FindChild(self.objPanal_RoleInfo, 'BaseInfoPanal')
    self.comText_BaseInfoClan = self:FindChildComponent(self.objBaseInfoPanal,"InfoLayouts/Clan/Text_info","Text")
    self.comText_BaseInfoMartial = self:FindChildComponent(self.objBaseInfoPanal,"InfoLayouts/Martial/Text_info","Text")
    self.comText_BaseInfoGrow = self:FindChildComponent(self.objBaseInfoPanal,"InfoLayouts/Grow/Text_info","Text")
    self.comText_BaseInfoGift = self:FindChildComponent(self.objBaseInfoPanal,"InfoLayouts/Gift/Text_info","Text")
    self.objItem_BaseInfoItem = self:FindChild(self.objBaseInfoPanal,"InfoLayouts/Item/ItemIconUI")
    self.objItem_BaseInfoExclusive = self:FindChild(self.objBaseInfoPanal,"InfoLayouts/Exclusive/ItemIconUI")
    self.comText_BaseInfoGift_Button = self:FindChildComponent(self.objBaseInfoPanal,"InfoLayouts/Gift_Button","DRButton")
    if self.comText_BaseInfoGift_Button then 
        local func = function()
            self:Onclick_Btn_GiftInfo()
        end
        self:AddButtonClickListener(self.comText_BaseInfoGift_Button,func)
    end 

    self.objGradeInfoPanal =  self:FindChild(self.objPanal_RoleInfo, 'GradeInfoPanal')
    self.objBtn_GradeUp =  self:FindChild(self.objGradeInfoPanal, 'Button_GradeUP')
    self.objGradeinfo_1 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/grade1')
    self.objGradeinfo_2 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/grade2')
    self.objGradeinfo_3 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/grade3')
    self.objGradeinfo_4 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/grade4')
    self.objs_Gradeinfo = {self.objGradeinfo_1,self.objGradeinfo_2,self.objGradeinfo_3,self.objGradeinfo_4}
    self.ComBtn_GradeUpScrollBar_text = self:FindChildComponent(self.objBtn_GradeUp,"Scrollbar/Value","Text")
    self.ComBtn_GradeUpScrollBar = self:FindChildComponent(self.objBtn_GradeUp,"Scrollbar","Scrollbar")
    self.comBtn_GradeUp = self.objBtn_GradeUp:GetComponent('DRButton')
    self.comtextBtn_GradeUP = self:FindChildComponent(self.objBtn_GradeUp,"Text","Text")
    if self.comBtn_GradeUp then
        local fun = function()
            self:Onclick_Btn_GradeUp()
        end
        self:AddButtonClickListener(self.comBtn_GradeUp,fun)
    end
    self.objcg_box = self:FindChild(self._gameObject, 'cg_box')
    self.comCGImage = self:FindChildComponent(self._gameObject, "cg_box/Image","Image")
    self.objNPCList = self:FindChild(self._gameObject, 'NPCList')
    self.objSC_Panal = self:FindChild(self._gameObject, 'NPCList/SC_Panal')
    self.comLoopScrollView = self:FindChildComponent(self.objSC_Panal,"LoopScrollView","LoopVerticalScrollRect")
    if self.comLoopScrollView then
        self.comLoopScrollView:AddListener(function(...) self:OnRoleCardChanged(...) end)
    end


    self.objAllBondPanal = self:FindChild(self._gameObject,'AllBondPanal')
    self.objAllBondPanal:SetActive(false)
    self.objAllBondPanalList1 = self:FindChild(self.objAllBondPanal,'Content/Layout1')
    self.objAllBondPanalList2 = self:FindChild(self.objAllBondPanal,'Content/Layout2')
    self.objAllBondPanalList3 = self:FindChild(self.objAllBondPanal,'Content/Layout3')
    self.objAllBondPanalItem = self:FindChild(self.objAllBondPanal,'Child')
    self.objAllBondPanalItem:SetActive(false)
    self.comBtn_AllBondPanalClose = self:FindChildComponent(self.objAllBondPanal,'PopUpWindow_2/Board/Button_close','DRButton')
    if self.comBtn_AllBondPanalClose then
        self:AddButtonClickListener(self.comBtn_AllBondPanalClose,function()
            self:Onclick_Btn_AllBond(false)
        end)
    end
    CardsMgr = CardsUpgradeDataManager:GetInstance()
    self.GiftsTB = TableDataManager:GetInstance():GetTable("Gift")
    self.RoleCardBondTB = TableDataManager:GetInstance():GetTable("RoleCardBond")
    self.BondLevelTB = TableDataManager:GetInstance():GetTable("RoleCardBond")
    self.comRankInitBG = {}
    self.rootRankInitlINE = {
        'CardRank/card_rank_white',
        'CardRank/card_rank_green',
        'CardRank/card_rank_blue',
        'CardRank/card_rank_purple',
        'CardRank/card_rank_orange',
        'CardRank/card_rank_golden',
        'CardRank/card_rank_dark-gold',
    }
    self.imgRankInitlINE = {}
    for i ,v in ipairs(self.rootRankInitlINE) do 
        self.imgRankInitlINE[i] = GetSprite(v,typeof(CS.UnityEngine.Sprite))
    end 

    for i=1,8 do 
        self.comRankInitBG[i] = self:FindChildComponent(self._gameObject,"NPCList/RankBG/"..i,"Image")
    end
	self:AddEventListener("UPDATE_CARDSUPGRADE_UI", function(info)
		self:SetNeedUpdateData(true)
    end)
    
    --讨论区
    self.btnDiscuss = self:FindChildComponent(self._gameObject,"RoleInfo/Button_discuss","Button")
    if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_ROLE) then
        self.btnDiscuss.gameObject:SetActive(true)
        self:AddButtonClickListener(self.btnDiscuss, function()
            local targetId = self:GetCurRoleCardData().roleid
            local articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_ROLE,targetId)
            if (articleId == nil) then
                SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
            else
                OpenWindowImmediately("DiscussUI",articleId)
            end
        end)
    else
        self.btnDiscuss.gameObject:SetActive(false)
    end


    --讨论区
    self.btnWishTaskInfo = self:FindChildComponent(self._gameObject,"RoleInfo/Text_Name/Button_WishTaskInfo","Button")
    self:AddButtonClickListener(self.btnWishTaskInfo, function()
        local targetId = self:GetCurRoleCardData().roleid
        local tips = TipsDataManager:GetInstance():GetRoleWishTaskRoleCardDetailsTips(targetId)
        OpenWindowImmediately("TipsPopUI", tips)
    end)


end
function RoleCardsUpgradeUI:RefreshChooseTab(eType)

    if self.eChosenTab == eType then 
        return 
    else 
        self.eChosenTab = eType
        self.iUpdateFlag = 2
    end
    if eType == TAB_TYPE.Bond then 
        CardsMgr:UpdateBondCanLVUP(true)
    end
end
function RoleCardsUpgradeUI:RefreshUI(info)
    for i=1,RankType.RT_ThirdGearDarkGolden do 
        CARD_LV_LMT_BY_RANK[i] = CardsMgr:GetUpgrade(2,i) or 10
    end
    self:InitCreateRoleList()
    self:InitDataList()
    if self.comToggle_grade then 
        self.comToggle_grade.isOn = true
    end
    self.close_to_collection = info
    self.objcg_box:SetActive(false)
    self.objNPCList:SetActive(true)

end

function RoleCardsUpgradeUI:InitCreateRoleList()
    self.role_create_map = {}
    local TB_CreateRole = TableDataManager:GetInstance():GetTable("CreateRole")
    if TB_CreateRole then 
        for i,CreateRole  in ipairs(TB_CreateRole) do 
            local rolemapid = CreateRole.OldRoleID
            if rolemapid and rolemapid > 0 and CreateRole.CreateHide ~= TBoolean.BOOL_YES then 
                self.role_create_map[rolemapid] = true 
            end
        end
    end 

end

function RoleCardsUpgradeUI:Update()
    if self.iNeedUpdateData then 
        self.iNeedUpdateData = false
        self:InitDataList()
        self.iUpdateFlag = self.iOBTarget and 2 or 1
    end

    
    if self.iUpdateFlag == 1 and not self.iOBTarget then 
        -- 刷新列表
        dprint('RoleCardsUpgradeUI  .. Update  1 RefreashList')
        self.iUpdateFlag = 0
        self:RefreashList()
        self:RefreshRedPoint()
    elseif self.iUpdateFlag == 2 then 
        -- 刷新属性
        dprint('RoleCardsUpgradeUI  .. Update  2 RefreashInfo')
        self.iUpdateFlag = 0
        if self.eChosenTab == TAB_TYPE.Bond then 
            self.objPanal_RoleInfo:SetActive(false)
            self.objPanal_Bond:SetActive(true)
            self:RefreashBond()
        else 
            self.objPanal_RoleInfo:SetActive(true)
            self.objPanal_Bond:SetActive(false)
            self:RefreashInfo()
            self:RefreashGradeInfo()
        end 
        self:RefreshRedPoint()

    end 
end
-- 刷新右侧红点 
function RoleCardsUpgradeUI:RefreshRedPoint()
    local dataitem = self:GetCurRoleCardData() or {}
    self.objToggleRedPoint_ability:SetActive(self:GetRedPointStateAbility(dataitem))
    self.objToggleRedPoint_bond:SetActive(self:GetRedPointStateBond(dataitem))
end
-- 获取红点状态 - 能力 
function RoleCardsUpgradeUI:GetRedPointStateAbility(dataitem)
    dataitem = dataitem or self:GetCurRoleCardData() or {}
    local ineed = dataitem.needpiece
    local bRedAbility = false
    if dataitem.grade < CardsMgr:GetUpgrade(2, dataitem.rank)  then
        bRedAbility = dataitem.piece >= ineed 
    end
    return bRedAbility
end
-- 获取红点状态 - 羁绊 
function RoleCardsUpgradeUI:GetRedPointStateBond(dataitem)
    dataitem = dataitem or self:GetCurRoleCardData() or {}
    local bRedBond = false 
    bRedBond = CardsMgr:GetBondCanLVUPByRoleID(dataitem.roleid)
    return bRedBond 
end
-- 刷新整个界面
function RoleCardsUpgradeUI:SetNeedUpdateData(bool)
    self.iNeedUpdateData = bool
    self.iRetCollectionPoint = true
end
-- 设置观察角色卡对象
function RoleCardsUpgradeUI:SetObTarGet(iRoleID)
    self.objcg_box:SetActive(true)
    self.objNPCList:SetActive(false)
    self.iOBTarget = iRoleID
    self.iUpdateFlag = 2
end
function RoleCardsUpgradeUI:OnClick_Toggle_Nav(inavtype)
    if inavtype == self.data_Chose_Toggle_Nav then 
        self.eSortType = 1 == self.eSortType and 2 or 1 
        local last_chose = self:GetCurRoleCardData()
        self.last_chose_id = last_chose and last_chose.roleid
    else 
        self.data_Chose_Toggle_Nav = inavtype
        self.eSortType = 1
        self.data_Chose_Index = nil 
    end 
    local iY = 1 == self.eSortType and -1 or 1
    if self.objToggle_rank_Arrow.activeSelf then 
        self.objToggle_rank_Arrow.transform.localScale = DRCSRef.Vec3(1, iY, 1)
    elseif self.objToggle_grade_Arrow.activeSelf then 
        self.objToggle_grade_Arrow.transform.localScale = DRCSRef.Vec3(1, iY, 1)
    end
    self.iUpdateFlag = 1
    self.bRefill = true 
end
-- init data list and level(PIECE) to show
function RoleCardsUpgradeUI:InitDataList()
    self.dataRoleCardList = {}
    self.sort_list_rank = {}
    self.sort_list_grade = {}
    self.sort_list_rank_ex = {}
    self.sort_list_grade_ex = {}
    self.mapRoleCardList ={} -- 角色id 索引
    local RoleCardList = CardsMgr:GetEntireRoleCardList()
    for iroleid,instdata in pairs(RoleCardList) do
        -- local iroleid = rolecard.RoleID
        if iroleid and TB_Role[iroleid] and not (self.mapRoleCardList[iroleid]) then 
            table.insert(self.dataRoleCardList,{
                roleid = iroleid,
                roledata = TB_Role[iroleid],
                grade = instdata.level or 0,
                piece = instdata.piece or 0,
                unlock = instdata.unlock,
                rank = RoleDataManager:GetInstance():GetRoleRankByTypeID(iroleid),
                num4map = #self.dataRoleCardList + 1,
                needpiece = CardsMgr:GetGradeNeedPiece(next_grade(instdata.level or 0, TB_Role[iroleid].Rank)) or 0,
            })
            self.mapRoleCardList[iroleid] = self.dataRoleCardList[#self.dataRoleCardList]
        end 
    end
end
-- chose the first DATA AS INIT ONE
function RoleCardsUpgradeUI:RefreashList()
    -- 下帧 和 同种情况不重复排序
    -- 每次的点击 存id列表 正反 取值的时候换算下就行 
    -- 三种排序 第一次点击后 缓存正序的列表 后面就可以不再重新 算 
    -- 如果操作升级后 记录标记即可
    local sort_func 
    local tar_list 
    if self.data_Chose_Toggle_Nav == NAV_TPYE.RANK then 
        if self.eSortType == SORT_TPYE.INVERTE then 
            if self.sort_list_rank_ex == nil or #self.sort_list_rank_ex == 0 then 
                sort_func = 'Sort_Rank_SEQUENCE'
                self.sort_list_rank_ex = {} 
            end
            tar_list = self.sort_list_rank_ex
        else 
            if self.sort_list_rank == nil or #self.sort_list_rank == 0 then 
                sort_func = 'Sort_Rank_INVERTE' 
                self.sort_list_rank = {} 
            end
            tar_list = self.sort_list_rank
        end
    else
        if self.eSortType == SORT_TPYE.INVERTE then 
            if self.sort_list_grade_ex == nil or #self.sort_list_grade_ex == 0 then 
                sort_func = 'Sort_Grade_SEQUENCE'
                self.sort_list_grade_ex = {} 
            end
            tar_list = self.sort_list_grade_ex
        else 
            if self.sort_list_grade == nil or #self.sort_list_grade == 0 then 
                sort_func = 'Sort_Grade_INVERTE'
                self.sort_list_grade = {}  
            end
            tar_list = self.sort_list_grade
        end 
    end
    if sort_func then 
        local temptable = {}
        local iAll = #self.dataRoleCardList
        for i=1,iAll do 
            temptable[i] = self.dataRoleCardList[i]
        end
        table.sort(temptable,function(a,b)
            return SortFunction(a,b,sort_func)
        end )
        self:SpecialSort(temptable)
        for i=1,iAll do 
            tar_list[i] = temptable[i].num4map
        end 
    end
    if self.last_chose_id then 
        for i,mapid in ipairs(tar_list) do 
            local roledata = self.dataRoleCardList[mapid]
            if roledata and roledata.roleid == self.last_chose_id then 
                self.data_Chose_Index = i
            end
        end 
        self.last_chose_id = nil
    end 
    if self.comLoopScrollView then
        self.obj_card_list = {}
        self.comLoopScrollView.totalCount = getTableSize(self.dataRoleCardList)
        if self.bRefill then 
            self.comLoopScrollView:RefillCells()
            self.bRefill = false
        else
            self.comLoopScrollView:RefreshCells()
        end
        self:RefreshChooseCard()
    end 
        
    if #self.dataRoleCardList > 0 and self.data_Chose_Index == nil then 
        self.data_Chose_Index = 1 
    end 
    self.iUpdateFlag = 2
    self:RefreshChooseCard()
end
function RoleCardsUpgradeUI:SpecialSort(temptable)
    -- 特殊排序,引导的时候需要把指定角色卡放第一个
    -- 江灵露角色卡引导
    if GuideDataManager:GetInstance():IsGuideRunning(47) then
        for index, data in ipairs(temptable) do
            if data.roleid == 1000012015 then
                table.remove(temptable, index)
                table.insert(temptable, 1, data)
                break
            end
        end
    end
end
function RoleCardsUpgradeUI:OnRoleCardChanged(gameobj,index)
    local dataitem = self:GetCurRoleCardData(index + 1)
    local objRoleCardItem = gameobj.gameObject
    self.obj_card_list = self.obj_card_list or {}
    self.obj_card_list[index + 1] = objRoleCardItem
    local objInfo = self:FindChild(objRoleCardItem,'Info')
    local comImgBG = self:FindChildComponent(objRoleCardItem,"ImgBG","Image") 
    local comImgRankUP = self:FindChildComponent(objRoleCardItem,"Rank/Image_up","Image") 
    local comImgRankDOWN = self:FindChildComponent(objRoleCardItem,"Rank/Image_down","Image") 
    if not dataitem then 
        comImgBG.sprite = self.comRankInitBG[8] and self.comRankInitBG[8].sprite
        comImgRankUP.sprite = self.imgRankInitlINE[1]
        comImgRankDOWN.sprite = self.imgRankInitlINE[1]
        objInfo:SetActive(false)
        return 
    end 
    local iRank = dataitem.rank or 1
    if iRank == 0 then iRank = 1 end
    local obj_anjin = self:FindChild(objRoleCardItem,'Rank_anim_AnJin')
    local obj_jin = self:FindChild(objRoleCardItem,'Rank_anim_Jin')
    obj_anjin:SetActive(dataitem.unlock and iRank == 7)
    obj_jin:SetActive(dataitem.unlock and iRank == 6)
    comImgBG.sprite = self.comRankInitBG[iRank] and self.comRankInitBG[iRank].sprite
    comImgRankUP.sprite = self.imgRankInitlINE[iRank]
    comImgRankDOWN.sprite = self.imgRankInitlINE[iRank]
    objInfo:SetActive(true)

    local ComText_title = self:FindChildComponent(objRoleCardItem,"Info/Text_title","Text")
    local roleTypeData = dataitem.roledata
    local str_rolename = GetLanguageByID(roleTypeData.NameID) or ''
    if str_rolename == '' then 
        str_rolename = RoleDataManager:GetInstance():GetRoleTitleStr(dataitem.roleid, true)
    end
    if dataitem.grade and dataitem.grade > 0 then 
        str_rolename =  string.format('%s+%d',str_rolename,dataitem.grade or 0)
    end 
    ComText_title.text =  str_rolename
    ComText_title.color = getRankColor(1)

    local obj_mainroleimg = self:FindChild(objRoleCardItem,'Info/img_mainrole')
    if self.role_create_map and self.role_create_map[dataitem.roleid] then 
        obj_mainroleimg:SetActive(true) 
    else 
        obj_mainroleimg:SetActive(false) 
    end 

    local ComText_grade = self:FindChildComponent(objRoleCardItem,"Info/Text_grade","Text")
    ComText_grade.text =  string.format('+%d',dataitem.grade or 0)
    ComText_grade.color = getRankColor(dataitem.rank)


    local ComScrollBar_text = self:FindChildComponent(objRoleCardItem,"Info/Scrollbar/Value","Text")
    local ComScrollBar = self:FindChildComponent(objRoleCardItem,"Info/Scrollbar","Scrollbar")
    local ineed = dataitem.needpiece
    local obj_imageup = self:FindChild(objRoleCardItem,'img_up')
    if dataitem.grade >= CardsMgr:GetUpgrade(2, dataitem.rank)  then
        ComScrollBar_text.text = '已满级'
        ComScrollBar.size = 1
    else 
        ComScrollBar_text.text  = dataitem.piece .. '/' .. ineed
        ComScrollBar.size = dataitem.piece/ineed
    end
    obj_imageup:SetActive(self:GetRedPointStateAbility(dataitem) or self:GetRedPointStateBond(dataitem))
    
    local ComImage_imgCG = self:FindChildComponent(objRoleCardItem,"Info/head","Image")
    local modelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(dataitem.roleid)
    if (modelData) then
        ComImage_imgCG.sprite = GetSprite(modelData.Head)
        ComImage_imgCG:SetNativeSize()
    end
    local obj_imagelock = self:FindChild(objRoleCardItem,'img_lock')
    obj_imagelock:SetActive(not dataitem.unlock)
    local comDRButton = self:FindChildComponent(objRoleCardItem,"ImgBG","DRButton") 

    local comdark = self:FindChild(objRoleCardItem,'ImgBG_chose')
    self:RemoveButtonClickListener(comDRButton)
    self:AddButtonClickListener(comDRButton, function() 
        self:OnClick_Chose_Card(index + 1)
        if comdark then 
            comdark:SetActive(true)
        end
    end)
    if comdark then 
        comdark:SetActive( index + 1 == self.data_Chose_Index)
    end
end
function RoleCardsUpgradeUI:OnClick_Chose_Card(index)
    self.data_Chose_Index = index 
    self.iUpdateFlag = 2
    self.old_grade = nil
    self.bRefillBond = true
    self:RefreshChooseCard()
    
end
function RoleCardsUpgradeUI:RefreshChooseCard()
    if self.obj_card_list then 
        -- TODO 优化列表
        for i,v in pairs(self.obj_card_list) do 
            local com = self:FindChild(v,'ImgBG_chose')
            if com then 
                com:SetActive(false)
            end
        end 
        if self.obj_card_list[self.data_Chose_Index] then 
            local com = self:FindChild(self.obj_card_list[self.data_Chose_Index],'ImgBG_chose')
            if com then 
                com:SetActive(true)
            end
        end 
    end  
end
function RoleCardsUpgradeUI:RefreashBond()
    local dataitem = self:GetCurRoleCardData() or {}
    local roleTypeData = dataitem.roledata
    if not roleTypeData then return end 

    if not self.RoleCardBondTB then
        return  
    end  
    self.BondShowList = {}
    for i,Bond in pairs(self.RoleCardBondTB) do 
        if Bond and Bond.BondRole then 
            for index,roleid in ipairs(Bond.BondRole) do 
                if dataitem.roleid == roleid then 
                    table.insert( self.BondShowList, Bond )
                    break
                end
            end
        end 
    end 
    table.sort( self.BondShowList, function(a,b)
        return a.Order < b.Order
    end  )
    
    if self.comLoopSVBond then
        self.comLoopSVBond.totalCount = getTableSize(self.BondShowList)
        if self.bRefillBond ~= false then 
            self.comLoopSVBond:RefillCells()
            self.bRefillBond = false
        else
            self.comLoopSVBond:RefreshCells()
        end
        self:RefreshChooseCard()
    end
end
-- 羁绊列表刷新
function RoleCardsUpgradeUI:OnBondChanged(gameobj,index)
    local objBondItem = gameobj.gameObject
    local bonddata = self.BondShowList[index+1]
    if not bonddata or not objBondItem then 
        return 
    end 
    local ilevel = CardsMgr:GetBondCardLevelByID(bonddata.BaseID)
    local bFinish = CardsMgr:GetIfBondStoryFinishByID(bonddata.BaseID)
    local iNextlevel = math.min(ilevel + 1,10)
    local BondLevelData = TableDataManager:GetInstance():GetTableData("BondLevel", iNextlevel) or {}


    objBondItem:SetActive(true)
    local comTextName = self:FindChildComponent(objBondItem,'Name','Text')
    local strname = GetLanguageByID(bonddata.NameID)
    if ilevel > 0 then 
        strname = strname .. ' +' .. ilevel
    end
    if comTextName then 
        comTextName.text = strname
    end 

    local objHeadList = self:FindChild(objBondItem,'Heads')
    RemoveAllChildren(objHeadList)
    local bCardLVFit = true 
    for i=1,#bonddata.BondRole do 
        local objtemp = CloneObj(self.obj_BondChildHead,objHeadList)
        local roleBaseID = bonddata.BondRole[i]
        objtemp:SetActive(true)
        local comimage = self:FindChildComponent(objtemp,'head','Image')
        local comDRButton = objtemp:GetComponent('DRButton')
        local modelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleBaseID)
        if (modelData) then
            comimage.sprite = GetSprite(modelData.Head)
        end
        local rolecarddata = self.mapRoleCardList and self.mapRoleCardList[roleBaseID]
        local iCurLv = rolecarddata and rolecarddata.grade
        if not iCurLv then 
            iCurLv = CardsMgr:GetRoleCardLevelByRoleBaseID(roleBaseID)
        end 
        local roleTypeData = rolecarddata and rolecarddata.roledata
        local strname = roleTypeData and GetLanguageByID(roleTypeData.NameID) or ''

        self:RemoveButtonClickListener(comDRButton)
        self:AddButtonClickListener(comDRButton, function() 
            local tips = {
                ['content'] = strname .. '+' .. iCurLv .. '\n' .. '羁绊需求+' .. iNextlevel
            }
            OpenWindowImmediately("TipsPopUI",tips)
        end)
        if iCurLv < iNextlevel then 
            bCardLVFit = false 
            setHeadUIGray(comimage,true)
        else
            setHeadUIGray(comimage,false)
        end 
    end 
    local comText1 = self:FindChildComponent(objBondItem,'InfDetail1','Text')
    local str1 = self:GetAttrLanguage(bonddata.BondAttr) or ''
    local num = (bonddata.BondAttrValue or 0)
    num = num * (BondLevelData.GrowScale or 0) / 10000
    str1 = str1 .. '+' .. self:GetAttrNum(bonddata.BondAttr,num)
    comText1.text = str1
    local comText2 = self:FindChildComponent(objBondItem,'InfDetail2','Text')
    local str2 = self:GetAttrLanguage(bonddata.AllAttr) or ''
    num = (bonddata.AllAttrValue or 0)
    num = num * (BondLevelData.GrowScale or 0) / 10000
    str2 = str2 .. '+' .. self:GetAttrNum(bonddata.AllAttr,num)
    comText2.text = str2

    local objBtn = self:FindChild(objBondItem,'Influence/Button')
    local objBtnPellet = self:FindChild(objBondItem,'Influence/Button/back')
    local comBtn = objBtn:GetComponent('DRButton')
    local comBtnText = self:FindChildComponent(objBtn,'Text','Text')
    local comBtnPelletText = self:FindChildComponent(objBtnPellet,'Number','Text')
    local comNotFitText = self:FindChildComponent(objBondItem,'Influence/NotFit','Text')
    local comTextUnlock = self:FindChildComponent(objBondItem,'Unlock','Text')
    local objeff = self:FindChild(objBondItem,'Influence/Button/eff')

    --local comImgSpInfluence = self:FindChildComponent(objBondItem,'SpInfluence/image','Image')
    local comTextSpInfluence = self:FindChildComponent(objBondItem,'SpInfluence/Text','Text')
    local objRewardSpInfluence = self:FindChild(objBondItem,'SpInfluence/Reward')
    local comRewardSpInfluenceText = self:FindChildComponent(objBondItem,'SpInfluence/Reward/Number','Text')
    if not ilevel or ilevel == 0 then 
        comTextUnlock.text = '未解锁'
        comTextSpInfluence.text = '羁绊剧情未解锁'
        comTextSpInfluence.color = COLOR_VALUE[COLOR_ENUM.Gray]
        objRewardSpInfluence:SetActive(false)
        --setUIGray(comImgSpInfluence,true)
    elseif  bFinish  then 
        comTextUnlock.text = ''
        comTextSpInfluence.text = '羁绊剧情已完成'
        comTextSpInfluence.color = COLOR_VALUE[COLOR_ENUM.Gray]
        objRewardSpInfluence:SetActive(false)
    else 
        comTextUnlock.text = ''
        comTextSpInfluence.text = GetLanguageByID(bonddata.UnlockFun)
        comTextSpInfluence.color = TIPS_COLOR['green']
        objRewardSpInfluence:SetActive(true)
        comRewardSpInfluenceText.text = bonddata.Reward
    end
    if bonddata.UnlockFun == nil or bonddata.UnlockFun == 0 then 
        comTextSpInfluence.text = ''
        objRewardSpInfluence:SetActive(false)
    end
    local btoastBUGOU = false
    if bCardLVFit then 
        objBtn:SetActive(true)
        comNotFitText.gameObject:SetActive(false)
        if not ilevel or ilevel == 0 then 
            comBtnText.text = '解锁'
        else 
            comBtnText.text = '升级'
        end

        local iPelletNeed = bonddata.Consume or 0 
        iPelletNeed = iPelletNeed * (BondLevelData.ConsumeScale or 0)  / 10000
        if iPelletNeed > 0 then 
            objBtnPellet:SetActive(true)
            comBtnPelletText.text = math.floor(iPelletNeed or 0)
            local iCurPellet = PlayerSetDataManager:GetInstance():GetBondPellet() or 0
            if iCurPellet < iPelletNeed then 
                btoastBUGOU = true
                comBtnPelletText.color = COLOR_VALUE[COLOR_ENUM.Red]
            else
                comBtnPelletText.color = COLOR_VALUE[COLOR_ENUM.White]
            end 
            objeff:SetActive(false)
        else
            objBtnPellet:SetActive(false)
            objeff:SetActive(true)
        end 
        self:RemoveButtonClickListener(comBtn)
        self:AddButtonClickListener(comBtn, function() 
            SendRequestRolePetCardOperate(RPCRT_ROLE_BOND, RPCOT_LEVEL_UP_ROLE_BOND, bonddata.BaseID) 
            self.bRefillBond = true 
            if btoastBUGOU then 
                SystemUICall:GetInstance():Toast("羁绊丹不足")
            end 
        end)
    else 
        objBtn:SetActive(false)
        comNotFitText.gameObject:SetActive(true)
        comNotFitText.text = string.format( "需要所有角色+%d" , iNextlevel or 0 )
        objeff:SetActive(false)
    end
        
end
function RoleCardsUpgradeUI:RefreashInfo()
    local dataitem = self:GetCurRoleCardData() or {}
    local roleTypeData = dataitem.roledata
    if not roleTypeData then return end 
    local strname = GetLanguageByID(roleTypeData.NameID) or ''
    if strname == '' then 
        strname = RoleDataManager:GetInstance():GetRoleTitleStr(dataitem.roleid, true)
    end 
    if dataitem.grade and dataitem.grade > 0 then 
        strname =  string.format('%s +%d',strname,dataitem.grade or 0)
    end 
    if self.old_grade then 
        if self.old_grade < dataitem.grade then 
            self.comEffect_lvup.gameObject:SetActive(true)
            self.comEffect_lvup:Play()
            self.old_grade = nil
        end
    end 
    self.comText_BaseInfoName.text = strname
    self.comText_BaseInfoName.color = getRankColor(dataitem.rank)

    local strClanName = ClanDataManager:GetInstance():GetClanNameByBaseID(dataitem.roledata.Clan)
    strClanName = strClanName ~= '' and strClanName or  '无'
    self.comText_BaseInfoClan.text = strClanName

    if dataitem.roleid == 1000001077 or dataitem.roleid == 1000001078 then 
        self.obj_TextChildInfo:SetActive(true)
    else 
        self.obj_TextChildInfo:SetActive(false)
    end 


    local string_martial = '无'
    local string_grow = '无'
    local iTypeTemplate = dataitem.roledata.TypeTemplate
    local TB_RoleStatus = TableDataManager:GetInstance():GetTable("RoleStatus")
    if TB_RoleStatus and iTypeTemplate  then 
        for iTbid,RoleStatus in ipairs(TB_RoleStatus) do 
            if RoleStatus.TypeTemplate ==  iTypeTemplate then 
                if RoleStatus.RoleCardDesc then 
                    if RoleStatus.RoleCardDesc[1] then 
                        string_martial = RoleStatus.RoleCardDesc[1]
                    end 
                    if RoleStatus.RoleCardDesc[2] then 
                        string_grow = RoleStatus.RoleCardDesc[2]
                    end 
                end
            end 
        end 
    end
    self.comText_BaseInfoMartial.text = string_martial
    self.comText_BaseInfoGrow.text = string_grow

    local strGiftName = nil
    local _GiftTree = CardsMgr:GetGiftTreeByTypeID(dataitem.roleid) or {}
    for iTreeID,V in pairs(_GiftTree) do 
        local GiftID = CardsMgr:GetTreeGift(dataitem.roleid,dataitem.grade,iTreeID) 
        if GiftID ~= 0 then 
            local gift1 = self.GiftsTB[GiftID]
            local strGiftName1 = gift1 and GetLanguageByID(gift1.NameID) 
            strGiftName1 = getRankBasedText(gift1.Rank,strGiftName1) 
            if strGiftName then 
                strGiftName = strGiftName .. '\n' .. strGiftName1
            else
                strGiftName = strGiftName1
            end 
        end 
    end 
    self.comText_BaseInfoGift_Button.gameObject:SetActive(false)
    -- if strGiftName then 
    --     self.comText_BaseInfoGift_Button.gameObject:SetActive(true)
    -- end 
    self.comText_BaseInfoGift.text = strGiftName
    self.comText_BaseInfoTitle.text = RoleDataManager:GetInstance():GetRoleTitleStr(dataitem.roleid, true)


    local itemid = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_TreasureUp,dataitem.grade )
    local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemid)

    if itemData then 
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objItem_BaseInfoItem, itemData, self.showItemLockState)
        -- self.ItemIconUI:SetIconState(self.objItem_BaseInfoItem,"gray")
        self.objItem_BaseInfoItem:SetActive(true)
    else 
        self.objItem_BaseInfoItem:SetActive(false)
    end 

    -- 专属武学
    local martialID = RoleDataManager:GetInstance():GetRoleExclusiveMartial(dataitem.roleid)
    if martialID then 
        local itemid = ItemDataManager:GetInstance():GetBookItemByMartial(martialID)
        local retData = TableDataManager:GetInstance():GetTableData("Item",itemid)
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objItem_BaseInfoExclusive, retData, self.showItemLockState)
        self.objItem_BaseInfoExclusive:SetActive(true)
    else
        self.objItem_BaseInfoExclusive:SetActive(false)
    end


    self.spineRoleUINew:SetRoleDataByBaseID(dataitem.roleid)
    self.spineRoleUINew:UpdateRoleSpine()
    -- self.objActor_BaseInfoSpine.transform.localScale = DRCSRef.Vec3(self.InitScale.x,self.InitScale.y,self.InitScale.z);
    self.objActor_BaseInfoSpine:SetActive(true)


    local ineed = dataitem.needpiece

    

    if dataitem.grade >= CardsMgr:GetUpgrade(2, dataitem.rank) then
        self.comtextBtn_GradeUP.text = '已满级'
        self.ComBtn_GradeUpScrollBar.size = 1
        self.ComBtn_GradeUpScrollBar_text.text = '剩余：' .. dataitem.piece
        setUIGray(self.objBtn_GradeUp:GetComponent('Image'), true)
    else 
        setUIGray(self.objBtn_GradeUp:GetComponent('Image'), dataitem.piece < ineed)
        self.ComBtn_GradeUpScrollBar_text.text = dataitem.piece .. '/' .. ineed
        self.ComBtn_GradeUpScrollBar.size = dataitem.piece/ineed
        self.comtextBtn_GradeUP.text = dataitem.piece >= ineed and '升级' or '不可升级'
    end 

    if self.iOBTarget then 
        
        local roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByID(dataitem.roleid)
        if roleModelData and roleModelData["Drawing"] then
            self:SetSpriteAsync(roleModelData["Drawing"],self.comCGImage)
        end
    end
end
function RoleCardsUpgradeUI:RefreashGradeInfo()
    local dataitem = self:GetCurRoleCardData()
    local icur_grade = dataitem.grade or 0
    local iNext_grade = next_grade(icur_grade, dataitem.roledata.Rank) 
    -- local stack_pop_table = {}
    local iflag = 1
    for i,obj in ipairs(self.objs_Gradeinfo) do 
        self:RefreashGradeInfoPerLine(obj,'','','')
    end 
    if icur_grade ~= iNext_grade then 
        self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],'修行等级',icur_grade,iNext_grade)
        iflag = iflag + 1
    end
    local rankex = CardsMgr:GetGradeAddAttrPer(icur_grade)
    local rankex_next = CardsMgr:GetGradeAddAttrPer(iNext_grade)
    rankex = '+ ' .. (rankex * 100 ) .. "%"
    rankex_next = '+ ' .. (rankex_next * 100 ) .. "%"
    if rankex ~= rankex_next then 
        self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],'基础属性',rankex,rankex_next)
        iflag = iflag + 1
    end


    rankex = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_Disposition,icur_grade)
    rankex_next = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_Disposition,iNext_grade)
    if rankex ~= rankex_next then 
        self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],'初始好感加成',rankex,rankex_next)
        iflag = iflag + 1
    end
    -- 
    local rank_source = dataitem.roledata.Rank
    rankex = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_RoleQualityUp,icur_grade)
    rankex_next = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_RoleQualityUp,iNext_grade)
    rankex = math.min( rankex + rank_source ,8 )
    rankex_next = math.min( rankex_next + rank_source ,8 )
    local str_rankex = GetLanguageByID(RankType_Lang[rankex])
    local str_rankex_next = GetLanguageByID(RankType_Lang[rankex_next])
    str_rankex = getRankBasedText(rankex,str_rankex)
    str_rankex_next = getRankBasedText(rankex_next,str_rankex_next)
    if str_rankex ~= str_rankex_next then 
        self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],'品质提升',str_rankex,str_rankex_next)
        iflag = iflag + 1
    end
    -- 


    local itemidold = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_TreasureUp,icur_grade)
    local itemidnext = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_TreasureUp,iNext_grade)

    if itemidold ~= itemidnext then 
        local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemidold)
        local itemDatanext = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemidnext)
        

        rankex = itemData and itemData.Rank or 1
        rankex_next = itemDatanext and itemDatanext.Rank or 1
        rankex = math.min( rankex  ,8 )
        rankex_next = math.min( rankex_next  ,8 )
        str_rankex = GetLanguageByID(RankType_Lang[rankex])
        str_rankex_next = GetLanguageByID(RankType_Lang[rankex_next])
        
        str_rankex = getRankBasedText(rankex,str_rankex)
        str_rankex_next = getRankBasedText(rankex_next,str_rankex_next)

        self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],'传家宝品质',str_rankex,str_rankex_next)
        iflag = iflag + 1
    end


    local _GiftTree = CardsMgr:GetGiftTreeByTypeID(dataitem.roleid) or {}
    for iTreeID,V in pairs(_GiftTree) do 
        local GiftID = CardsMgr:GetTreeGift(dataitem.roleid,icur_grade,iTreeID) 
        local GiftID_next = CardsMgr:GetTreeGift(dataitem.roleid,iNext_grade,iTreeID)
        if GiftID ~= GiftID_next then 
            
            local gift1 = self.GiftsTB[GiftID]
            local strGiftName1 = gift1 and GetLanguageByID(gift1.NameID) 
            strGiftName1 = getRankBasedText(gift1.Rank,strGiftName1) 

            local gift2 = self.GiftsTB[GiftID_next]
            local strGiftName2 = gift1 and GetLanguageByID(gift2.NameID) 
            strGiftName2 = getRankBasedText(gift2.Rank,strGiftName2) 

            self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],'心愿树提升',strGiftName1,strGiftName2)
            iflag = iflag + 1
        end 
    end 


    local ilanguagenext = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_SpecialDesc,iNext_grade)
    if ilanguagenext and ilanguagenext ~= 0 then 
        local strSpecialDesc = GetLanguageByID(ilanguagenext) 
        if strSpecialDesc and strSpecialDesc ~= '' then 
            self:RefreashGradeInfoPerLine(self.objs_Gradeinfo[iflag],strSpecialDesc,'','')
            iflag = iflag + 1
        end 
    end 
end
function RoleCardsUpgradeUI:RefreashGradeInfoPerLine(obj,strName,strBefore,strAfter)
    if obj == nil  then return end 
    local com_name = self:FindChildComponent(obj,'Text_title','Text') 
    com_name.text = strName
    local com_old = self:FindChildComponent(obj,'Text_old','Text') 
    com_old.text = strBefore
    local com_new = self:FindChildComponent(obj,'Text_new','Text') 
    com_new.text = strAfter
    local obj_add = self:FindChild(obj,'img_add')
    obj_add:SetActive(strBefore ~= strAfter)
end 
function RoleCardsUpgradeUI:Onclick_Btn_GradeUp()
    local dataitem = self:GetCurRoleCardData()
    local cardid = dataitem.roleid 
        
    --
    if dataitem.grade >= CardsMgr:GetUpgrade(2, dataitem.rank) then
        SystemUICall:GetInstance():Toast("已达等级上限")
        return;
    end

    if cardid and cardid ~= 0 then 
        -- TODO: 统一接口
        SendRequestRolePetCardOperate(RPCRT_ROLE_CARD, RPCOT_LEVEL_UP_ROLE_CARD, cardid, 0) 
        LimitShopManager:GetInstance():AddCheckData(LimitShopType.eRoleCard)
        self.old_grade = dataitem.grade
        
        self.last_chose_id = dataitem.roleid
    end
end
local ATR_TRANS = {
    ['暴击伤害倍数'] = '暴击伤害',
    ['最终伤害减免百分比'] = '伤害减免',
    ['最终伤害附加百分比'] = '伤害加成',
    ['最终伤害减免值'] = '伤害减免值',
    ['最终伤害附加值'] = '伤害附加值',
}
function RoleCardsUpgradeUI:GetAttrLanguage(iAttr)
    if iAttr then 
        local str =  GetLanguageByEnum(iAttr) or ''
        if ATR_TRANS[str] then 
            return ATR_TRANS[str]
        end 
        return str
    end 
    return ''
end 
function RoleCardsUpgradeUI:GetAttrNum(iAttr,inum)
    if iAttr  then 
        inum = inum or 0

        local bIsPerMyriad, bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(iAttr)

        if bShowAsPercent then
            return string.format( "%0.f%%",inum / 100)
        else
            return string.format( "%d",inum)
        end
    end 
    return ''
end 
function RoleCardsUpgradeUI:Onclick_Btn_AllBond(bShow)
    self.objAllBondPanal:SetActive(bShow or false)
    if not bShow then 
        return 
    end 

    local dataitem = self:GetCurRoleCardData() or {}
    local roleTypeData = dataitem.roledata
    if not roleTypeData then return end 

    if not self.RoleCardBondTB then
        return  
    end 
    local List1 = {}
    local List2 = {}
    local List3 = {}
    local mapjichu = {
        [AttrType.ATTR_LIDAO] = true,
        [AttrType.ATTR_TIZHI] = true,
        [AttrType.ATTR_JINGLI] = true,
        [AttrType.ATTR_NEIJIN] = true,
        [AttrType.ATTR_LINGQIAO] = true,
        [AttrType.ATTR_WUXING] = true,
    }
    local iListALl = CardsMgr:GetBondInfluenceMapByRoleTypeID(dataitem.roleid)
    for iAttr,iValue in pairs(iListALl or {}) do 
        if JingTongAttrs[iAttr] then 
            List2[iAttr] = iValue or 0
        elseif mapjichu[iAttr] then 
            List1[iAttr] = iValue or 0
        else 
            List3[iAttr] = iValue or 0
        end 
    end 
    local func_addIcon = function(list,datas)
        RemoveAllChildren(list)
        if not datas then 
            return 
        end
        for itype,num in pairs(datas) do 
            local objitem = CloneObj(self.objAllBondPanalItem,list)
            objitem:SetActive(true)
            local comtype = self:FindChildComponent(objitem,'Text','Text')
            comtype.text = self:GetAttrLanguage(itype)
            local comNum = self:FindChildComponent(objitem,'Num','Text')
            comNum.text = self:GetAttrNum(itype,num or 0)
        end 
    end 
    func_addIcon(self.objAllBondPanalList1,List1)
    func_addIcon(self.objAllBondPanalList2,List2)
    func_addIcon(self.objAllBondPanalList3,List3)
end
function RoleCardsUpgradeUI:Onclick_Btn_GiftInfo()
    local dataitem = self:GetCurRoleCardData()
    local iGift = CardsMgr:GetCurEffctStateByRoleID(dataitem.roleid,RoleCardEffect.RCE_GetGift,dataitem.grade)
    if iGift and iGift ~= 0 then 
        local gift = self.GiftsTB[iGift]
        if gift then 
            local tips = {
                ['title'] = GetLanguageByID(gift.NameID) or '',
                ['content'] = GetLanguageByID(gift.DescID) or ""
            }
            OpenWindowImmediately("TipsPopUI",tips)
        end
    end 
end
-- 统一用该接口获取 当前展示的角色卡信息
function RoleCardsUpgradeUI:GetCurRoleCardData(iIndex)
    if not self.dataRoleCardList then 
        self:InitDataList()
    end
    if self.iOBTarget then 
        -- TODO: 给钱程预留 需要显示单个角色卡信息 和立绘
        if self.mapRoleCardList and self.mapRoleCardList[self.iOBTarget] then 
            return self.mapRoleCardList[self.iOBTarget] 
        end
    else 
        iIndex = iIndex or self.data_Chose_Index  

        if self.data_Chose_Toggle_Nav == NAV_TPYE.RANK then 
            if self.eSortType == SORT_TPYE.INVERTE then 
                iIndex = self.sort_list_rank_ex[iIndex] 
            else 
                iIndex = self.sort_list_rank[iIndex] 
            end
        else
            if self.eSortType == SORT_TPYE.INVERTE then 
                iIndex = self.sort_list_grade_ex[iIndex] 
            else 
                iIndex = self.sort_list_grade[iIndex]  
            end 
        end

        local dataitem = self.dataRoleCardList[iIndex]
        return dataitem or {}
    end 
end
function RoleCardsUpgradeUI:OnDisable()
    RemoveWindowBar('RoleCardsUpgradeUI')
end
function RoleCardsUpgradeUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "RoleCardsUpgradeUI", 
        ['topBtnState'] = {
            ['bBackBtn'] = false,
            ['bBondPellet'] = true,
            ['bGoodEvil'] = false,
            ['bSilver'] = false,
            ['bCoin'] = false,
        },
        ['bSaveToCache'] = false,
    })
end
function RoleCardsUpgradeUI:OnDestroy()
    self.ItemIconUI:Close()
    self.spineRoleUINew:Close()
    self.spineRoleUINew = nil
    
    self:RemoveEventListener('UPDATE_CARDSUPGRADE_UI')

end
return RoleCardsUpgradeUI;