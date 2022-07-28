ClanBranchEliminateUI = class("ClanBranchEliminateUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function ClanBranchEliminateUI:ctor()
	local obj = LoadPrefabAndInit("Clan/ClanEliminateUI",UI_UILayer,true)
	if obj then
        self:SetGameObject(obj)
    end
end

local ShowMemberType = {
    ALL = 0,    -- 所有成员
    BATTLE1 = 1,    -- 第一场战斗
    BATTLE2 = 2,    -- 第二场战斗
}

function ClanBranchEliminateUI:OnPressESCKey()
    if self.comBtnBack_Button then
        self.comBtnBack_Button.onClick:Invoke()
    end
end

function ClanBranchEliminateUI:Init()
    -- 初始化当前卡片的ui数据（取节点）
    self.ItemIconUI = ItemIconUI.new()
	self.comTeacher_CG = self:FindChildComponent(self._gameObject, "Window_base_new/CG", "Image")	-- 立绘

    if self.comBtn_TiGuan then
        self:AddButtonClickListener(self.comBtn_TiGuan,function() 
            self:OnClick_Tips_TiGuan()
        end)
    end

    self.detail_box = self:FindChild(self._gameObject, "detail_box")
    self.objMember_box = self:FindChild(self._gameObject, "member")
    self.comSc_member = self:FindChildComponent(self.objMember_box, "SC_mumber/Viewport/Content", "Transform")
    self.objMemberItem = self:FindChild(self.objMember_box, "member_item")
    
    self.objReward_box = self:FindChild(self._gameObject, "reward")
    self.objClan_Nav_Box = self:FindChild(self.objReward_box,'Clan_nav_box')
    self.objClan_Nav_Box:SetActive(false)

    self.objInfo_Box = self:FindChild(self.objReward_box,'info_box')
    self.objInfo_Box2 = self:FindChildComponent(self.objInfo_Box,'2/Text_desc','Text')

    self.objItem_Box = self:FindChild(self.objReward_box,'item_box')
    self.objItem_Box1 = self:FindChild(self.objItem_Box,'1')
    self.objItem_Box2 = self:FindChild(self.objItem_Box,'2')
    self.objItem_Box3 = self:FindChild(self.objItem_Box,'3')
    self.objs_itembox = {self.objItem_Box1,self.objItem_Box2,self.objItem_Box3}

    self.objBattlebuff_box = self:FindChild(self._gameObject, "battlebuff")
    self.com_Battlebuff_all = self:FindChildComponent(self.objBattlebuff_box,'text_eliminate1','Text')
    self.com_Battlebuff_side = self:FindChildComponent(self.objBattlebuff_box,'text_eliminate2','Text')
    self.com_Battlebuff_buff = self:FindChildComponent(self.objBattlebuff_box,'text_buff','Text')

    self.comBtnSubmit_Button = self:FindChildComponent(self._gameObject, "Button_submit", "Button")
    if self.comBtnSubmit_Button then
        self:AddButtonClickListener(self.comBtnSubmit_Button,function() 
            self:OnClick_Event_TiGuan(true) 
        end)
    end
    

    self.comBtnBack_Button = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", "Button")
	if self.comBtnBack_Button then
        self:AddButtonClickListener(self.comBtnBack_Button,function() 
            self:OnClick_Event_TiGuan(false)
        end)
    end

    self.comToggleAllBattle = self:FindChildComponent(self.objMember_box, "Nav_box/Total", l_DRCSRef_Type.Toggle)
    self.comTextToggleAllBattle = self:FindChildComponent(self.comToggleAllBattle.gameObject, "Text", l_DRCSRef_Type.Text)
    local fun = function(isOn)
        if isOn then 
            self:SetShowMemberType(ShowMemberType.ALL)
        end
    end
    self:AddToggleClickListener(self.comToggleAllBattle, fun)

    self.comToggleBattle1 = self:FindChildComponent(self.objMember_box, "Nav_box/Battle1", l_DRCSRef_Type.Toggle)
    self.comTextToggleBattle1 = self:FindChildComponent(self.comToggleBattle1.gameObject, "Text", l_DRCSRef_Type.Text)
    local fun = function(isOn)
        if isOn then 
            self:SetShowMemberType(ShowMemberType.BATTLE1)
        end
    end
    self:AddToggleClickListener(self.comToggleBattle1, fun)

    self.comToggleBattle2 = self:FindChildComponent(self.objMember_box, "Nav_box/Battle2", l_DRCSRef_Type.Toggle)
    self.comTextToggleBattle2 = self:FindChildComponent(self.comToggleBattle2.gameObject, "Text", l_DRCSRef_Type.Text)
    local fun = function(isOn)
        if isOn then 
            self:SetShowMemberType(ShowMemberType.BATTLE2)
        end
    end
    self:AddToggleClickListener(self.comToggleBattle2, fun)

    self.comToggleBattle3 = self:FindChildComponent(self.objMember_box, "Nav_box/Battle3", l_DRCSRef_Type.Toggle)
    self.comToggleBattle3.gameObject:SetActive(false)
end

function ClanBranchEliminateUI:Update()
end

function ClanBranchEliminateUI:RefreshUI(info)
    if not info or not info[1].uiClanTypeID then
        return
    end

    local winBlur = GetUIWindow("BlurBGUI")
    if winBlur then
        winBlur:ShowNormalMapBG(MapDataManager:GetInstance():GetCurMapID())
    end

    self.calnTypeID = info[1].uiClanTypeID
    self.comToggleAllBattle.isOn = true
    local clanEliminateTypeData = TableDataManager:GetInstance():GetTableData("ClanBranch",self.calnTypeID)
    self.clanTypeData = info[1]
    self.clanEliminateTypeData = clanEliminateTypeData
    self.clanEliminateTypeData.ClanMembers = {clanEliminateTypeData.Master}

    self:InitBaseInfo(self.clanTypeData, self.clanEliminateTypeData)
    self:RefreshMemberList()
    self:InitRewardBox(self.clanTypeData, self.clanEliminateTypeData)
    self:InitBattleBuffBox(self.clanTypeData, self.clanEliminateTypeData)
    HideAllHUD()
end

function ClanBranchEliminateUI:InitBaseInfo(clanTypeData, eliminateTypeData)
	local teacher = eliminateTypeData['Master']
	local roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(teacher)
    if roleModelData and roleModelData["Drawing"] then
        self.comTeacher_CG.sprite = GetSprite(roleModelData.Drawing)
    end
end

function ClanBranchEliminateUI:RefreshMemberList()
    RemoveAllChildrenImmediate(self.comSc_member)
    if not self.clanEliminateTypeData then 
        return
    end
    local memberList = {}
    local aiMemberList = {}
    if self.showMemberType == ShowMemberType.ALL then 
        memberList = self.clanEliminateTypeData.ClanMembers or {}
        for key, value in pairs(memberList) do
            aiMemberList[value] = true
        end
        if self.clanEliminateTypeData.BattleList ~= nil then 
            memberList = BattleDataManager:GetInstance():AddBattleMemberList(self.clanEliminateTypeData.BattleList[1], memberList,aiMemberList)
            memberList = BattleDataManager:GetInstance():AddBattleMemberList(self.clanEliminateTypeData.BattleList[2],memberList,aiMemberList)
        end
    elseif self.showMemberType == ShowMemberType.BATTLE1 then 
        -- 获取第一场战斗的参战角色
        if self.clanEliminateTypeData.BattleList ~= nil then 
            memberList = BattleDataManager:GetInstance():GetBattleMemberList(self.clanEliminateTypeData.BattleList[1])
        end
    elseif self.showMemberType == ShowMemberType.BATTLE2 then 
        -- 获取第二场战斗的参战角色
        if self.clanEliminateTypeData.BattleList ~= nil then 
            memberList = BattleDataManager:GetInstance():GetBattleMemberList(self.clanEliminateTypeData.BattleList[2])
        end
    end
    for _, roleTypeID in ipairs(memberList) do
        if roleTypeID ~= 0 then 
            local objMember = DRCSRef.ObjInit(self.objMemberItem, self.comSc_member)
            objMember:SetActive(true)
            self:ShowMemberItem(objMember, roleTypeID)
        end
    end
end

function ClanBranchEliminateUI:ShowMemberItem(objMember, roleTypeID)
    local name_Text = self:FindChildComponent(objMember, "Name", "Text")
    local work_Text = self:FindChildComponent(objMember, "work", "Text")
    local head_Image = self:FindChildComponent(objMember, "Head/Mask/Image", "Image")

    local Btn_Image = self:FindChildComponent(objMember, " ", "DRButton")
    if Btn_Image then
        self:AddButtonClickListener(Btn_Image,function() 
            OpenWindowImmediately("ObserveUI", {['roleID'] = RoleDataManager:GetInstance():GetRoleID(roleTypeID)})
        end)
    end
    local roleTypeData = TB_Role[roleTypeID]
    if not roleTypeData then
        return
    end

    name_Text.text = GetLanguageByID(roleTypeData.NameID)
    name_Text.color = getRankColor(roleTypeData.Rank)
    local string_Work = '长老'
    local status = RoleDataManager:GetInstance():GetRoleStatus(roleTypeID, true)
    if self.clanEliminateTypeData.ClanMembers[1] == roleTypeID  then 
        string_Work = '掌门'
    elseif status == StatusType.STT_Menpaizhanglao  then 
        string_Work = '长老'
    elseif status == StatusType.STT_Menpaihufa  then 
        string_Work = '护法'
    elseif status == StatusType.STT_Menpaidizi  then 
        string_Work = '弟子'
    end
    work_Text.text = string_Work
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
    head_Image.sprite = GetSprite(artData.Head)
end

function ClanBranchEliminateUI:InitRewardBox(clanTypeData, eliminateTypeData)
    self.dataRewards = clanTypeData and {clanTypeData.uiClanTreasureID} or 0
    self:RefreshRewards()
end
function ClanBranchEliminateUI:RefreshRewards()
    self.objInfo_Box2.gameObject:SetActive(true)
    self.objInfo_Box2.text = "获得当前分舵的传家宝\n当前分舵解散\n累计踢馆门派和阵营踢馆门派不会增加，不完成踢馆成就"

    for i,objitem in ipairs(self.objs_itembox) do 
        objitem:SetActive(false)
    end 
    local int_index = 1
    local objitem 
    -- 先判断铜币 id硬取 数目待算
    local items = self.dataRewards

    if items then 
        for i,objs in pairs(items) do  
            objitem = self.objs_itembox[int_index]
            objitem:SetActive(true)
            local item = TableDataManager:GetInstance():GetTableData("Item",objs)
            self.ItemIconUI:UpdateUIWithItemTypeData(objitem,item)
            self.ItemIconUI:HideItemNum(objitem)
            int_index = int_index + 1
        end 
    end 
end
function ClanBranchEliminateUI:InitBattleBuffBox(clanTypeData, eliminateTypeData)
    local int_all = ClanDataManager:GetInstance():GetClanTiaoXinNum()
    local int_side = ClanDataManager:GetInstance():GetClanTiaoXinNum(self.calnTypeID)
    local iLayer = 0
    iLayer = iLayer + ClanDataManager:GetInstance():GetYeJingYuQinLayer(self.calnTypeID)
    iLayer = iLayer + ClanDataManager:GetInstance():GetGongShouTongMengLayer(self.calnTypeID)

    self.com_Battlebuff_all.text = string.format( "累计踢馆门派：%d",int_all )
    self.com_Battlebuff_side.text = string.format( "阵营踢馆门派：%d",int_side )
    self.com_Battlebuff_buff.text = string.format( "踢馆战中敌方各项一级属性提升%d%%，生命值提升%d%%",iLayer,iLayer)
end

function ClanBranchEliminateUI:OnClick_Tips_TiGuan()
    local cost = TableDataManager:GetInstance():GetTableData("ClanBranchConfig", 1).ChallengeDispositionNum
    local cost2 = TableDataManager:GetInstance():GetTableData("ClanBranchConfig", 1).ChallengeJusticeNum
    local tips = {
        ['title'] = '玩法介绍',
        ['content'] = '进行两场踢馆战斗\n降低所属门派好感度<color=#C53926>'..cost..'</color>\n玩家自身仁义降低<color=#C53926>'..cost2..'</color>'
    }
    OpenWindowImmediately("TipsPopUI",tips)
end

function ClanBranchEliminateUI:OnClick_Event_TiGuan(bcontinue)
	dprint(string.format("OnClick_JoinClan"..tostring(bcontinue)))
	local uiClanTypeID = self.calnTypeID
	local clickData = EncodeSendSeGC_Click_Choose_TiGuan(uiClanTypeID,bcontinue and 1 or 0, 1)
	local iSize = clickData:GetCurPos()
	NetGameCmdSend(SGC_CLICK_CHOOSE_TIGUAN, iSize, clickData)
    RemoveWindowImmediately("ClanBranchEliminateUI")
    OpenWindowImmediately("TileBigMap")
    ShowAllHUD()   
    DisplayActionEnd()
end

function ClanBranchEliminateUI:OnDestroy()
    self.ItemIconUI:Close()  
end


function ClanBranchEliminateUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function ClanBranchEliminateUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

function ClanBranchEliminateUI:SetShowMemberType(showMemberType)
    self.showMemberType = showMemberType
    
    self.comTextToggleAllBattle.color = UI_COLOR.black
    self.comTextToggleBattle1.color = UI_COLOR.black
    self.comTextToggleBattle2.color = UI_COLOR.black
    if showMemberType == ShowMemberType.ALL then 
        self.comTextToggleAllBattle.color = UI_COLOR.white
    elseif showMemberType == ShowMemberType.BATTLE1 then 
        self.comTextToggleBattle1.color = UI_COLOR.white
    elseif showMemberType == ShowMemberType.BATTLE2 then 
        self.comTextToggleBattle2.color = UI_COLOR.white
    end
    self:RefreshMemberList()
end

return ClanBranchEliminateUI