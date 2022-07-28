ClanEliminateUI = class("ClanEliminateUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function ClanEliminateUI:ctor()
	local obj = LoadPrefabAndInit("Clan/ClanEliminateUI",UI_UILayer,true)
	if obj then
        self:SetGameObject(obj)
    end
end


-- 该结构需要删除
local clantype_convert = {
	[ClanType.CLT_Null] = '全部',
	[ClanType.CLT_BaDao] = '霸道盟',
	[ClanType.CLT_WuLin] = '武林盟',
	[ClanType.CLT_XianSan] = '中立闲散',
}

local status_convert = {
	[StatusType.STT_StatusTypeNull] = '无',
}

local ShowMemberType = {
    ALL = 0,    -- 所有成员
    BATTLE1 = 1,    -- 第一场战斗
    BATTLE2 = 2,    -- 第二场战斗
    BATTLE3 = 3,    -- 第三场战斗
}

local CET_JIEMENG = 1
local CET_QUZHU = 2
local CET_ZHENGFU = 3

function ClanEliminateUI:OnPressESCKey()
    if self.comBtnBack_Button then
        self.comBtnBack_Button.onClick:Invoke()
    end
end

function ClanEliminateUI:Init()
    -- 初始化当前卡片的ui数据（取节点）
    self.ItemIconUI = ItemIconUI.new()
	self.comTeacher_CG = self:FindChildComponent(self._gameObject, "Window_base_new/CG", "Image")	-- 立绘
    
    self.intro_box = self:FindChild(self._gameObject, "Window_base_new/intro_box")
	self.comText_camp = self:FindChildComponent(self.intro_box, "Text_camp", "Text")	-- 阵营
	self.comName = self:FindChildComponent(self.intro_box, "Name", "Text")	-- 名字
	self.comText_join = self:FindChildComponent(self.intro_box, "Text_join", "Text")	-- 加入人数
    self.comBtn_TiGuan = self:FindChildComponent(self.intro_box, "Tiguan_Button", "DRButton")	-- 详细信息
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
    self.objClan_Nav_Box = self:FindChild(self.objReward_box,'right/Clan_nav_box')
    self.comClan_Nav_Box1 = self:FindChildComponent(self.objClan_Nav_Box,'1','Toggle')
    self.comClan_Nav_Box1_Text = self:FindChildComponent(self.objClan_Nav_Box,"1/Text","Text")

	if self.comClan_Nav_Box1 then
		local _callBack = function(boolHide)
			if boolHide then
				self:OnClickTog(CET_JIEMENG);
            end
            self.comClan_Nav_Box1_Text.color = boolHide and DRCSRef.Color.white or DRCSRef.Color(0.2,0.2,0.2,1)
		end
		self:AddToggleClickListener(self.comClan_Nav_Box1, _callBack);
	end
    self.comClan_Nav_Box2 = self:FindChildComponent(self.objClan_Nav_Box,'2','Toggle')
    self.comClan_Nav_Box2_Text = self:FindChildComponent(self.objClan_Nav_Box,"2/Text","Text")
	if self.comClan_Nav_Box2 then
		local _callBack = function(boolHide)
			if boolHide then
				self:OnClickTog(CET_QUZHU);
            end
            self.comClan_Nav_Box2_Text.color = boolHide and DRCSRef.Color.white or DRCSRef.Color(0.2,0.2,0.2,1) 
		end
		self:AddToggleClickListener(self.comClan_Nav_Box2, _callBack);
	end
    self.comClan_Nav_Box3 = self:FindChildComponent(self.objClan_Nav_Box,'3','Toggle')
    self.comClan_Nav_Box3_Text = self:FindChildComponent(self.objClan_Nav_Box,"3/Text","Text")
	if self.comClan_Nav_Box3 then
		local _callBack = function(boolHide)
			if boolHide then
				self:OnClickTog(CET_ZHENGFU);
            end
            self.comClan_Nav_Box3_Text.color = boolHide and DRCSRef.Color.white or DRCSRef.Color(0.2,0.2,0.2,1) 
		end
		self:AddToggleClickListener(self.comClan_Nav_Box3, _callBack);
	end
    
    self.objInfo_Box = self:FindChild(self.objReward_box,'right/info_box')
    self.objInfo_Box1 = self:FindChild(self.objInfo_Box,'1')
    self.objInfo_Box2 = self:FindChild(self.objInfo_Box,'2')
    self.objInfo_Box3 = self:FindChild(self.objInfo_Box,'3')

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
    self.comTextToggleBattle3 = self:FindChildComponent(self.comToggleBattle3.gameObject, "Text", l_DRCSRef_Type.Text)
    local fun = function(isOn)
        if isOn then 
            self:SetShowMemberType(ShowMemberType.BATTLE3)
        end
    end
    self:AddToggleClickListener(self.comToggleBattle3, fun)

    self:AddEventListener('UPDATE_CLAN_COLLECTIONINFO', function()
        self.clanNumUpdateFlag = true
	end)
end

function ClanEliminateUI:Update()
    if self.clanNumUpdateFlag then
        if self.calnTypeID and self.calnTypeID > 0 then
            self:SetJoinNumber(self.calnTypeID)
        end

        self.clanNumUpdateFlag = false
    end
end

function ClanEliminateUI:RefreshUI(info)
    if not info or not info.uiParam1 then
        return
    end

    self.calnTypeID = info.uiParam1
    self.comToggleAllBattle.isOn = true
    local clanTypeData = TB_Clan[self.calnTypeID]
    local clanEliminateTypeData = TableDataManager:GetInstance():GetTableData("ClanEliminate",self.calnTypeID)
    self.clanTypeData = clanTypeData
    self.clanEliminateTypeData = clanEliminateTypeData

    ClanDataManager:GetInstance():SendQueryClanCollectionInfo(self.calnTypeID)

    self:InitBaseInfo(clanTypeData, clanEliminateTypeData)
    self:RefreshMemberList()
    self:InitRewardBox(clanTypeData, clanEliminateTypeData)
    self:InitBattleBuffBox(clanTypeData, clanEliminateTypeData)
    self:SetJoinNumber(self.calnTypeID)

    if self.comClan_Nav_Box1 then 
        self.comClan_Nav_Box1.isOn = true 
    end 
end

function ClanEliminateUI:InitBaseInfo(clanTypeData, eliminateTypeData)
	local teacher = clanTypeData['Teacher']
	local roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(teacher)
    if roleModelData and roleModelData["Drawing"] then
        self.comTeacher_CG.sprite = GetSprite(roleModelData.Drawing)
    end
    
    self.comName.text = GetLanguageByID(clanTypeData.NameID)
	self.comText_camp.text = clantype_convert[clanTypeData.Type]
end

function ClanEliminateUI:RefreshMemberList()
    RemoveAllChildrenImmediate(self.comSc_member)
    if not self.clanEliminateTypeData then 
        return
    end
    local memberList = {}
    if self.showMemberType == ShowMemberType.ALL then 
        memberList = self.clanEliminateTypeData.ClanMembers or {}
    elseif self.showMemberType == ShowMemberType.BATTLE1 then 
        -- 获取第一场战斗的参战角色
        if self.clanEliminateTypeData.EliBattleList ~= nil then 
            memberList = BattleDataManager:GetInstance():GetBattleMemberList(self.clanEliminateTypeData.EliBattleList[1])
        end
    elseif self.showMemberType == ShowMemberType.BATTLE2 then 
        -- 获取第二场战斗的参战角色
        if self.clanEliminateTypeData.EliBattleList ~= nil then 
            memberList = BattleDataManager:GetInstance():GetBattleMemberList(self.clanEliminateTypeData.EliBattleList[2])
        end
    elseif self.showMemberType == ShowMemberType.BATTLE3 then 
        -- 获取第三场战斗的参战角色
        if self.clanEliminateTypeData.EliBattleList ~= nil then 
            memberList = BattleDataManager:GetInstance():GetBattleMemberList(self.clanEliminateTypeData.EliBattleList[3])
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

function ClanEliminateUI:ShowMemberItem(objMember, roleTypeID)
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
    if status == StatusType.STT_Menpaizhangmen  then 
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

function ClanEliminateUI:InitRewardBox(clanTypeData, eliminateTypeData)
    self.dataRewards = {}
    self.dataRewards[CET_ZHENGFU] = {}
    self.dataRewards[CET_JIEMENG] = {}
    self.dataRewards[CET_QUZHU] = {}
    if eliminateTypeData.RewardIDList then 
        for int_i =1,#eliminateTypeData.RewardIDList do 
            -- local type = eliminateTypeData.RewardTypeList[int_i]
            local source = eliminateTypeData.RewardSourceList[int_i]
            local id = eliminateTypeData.RewardIDList[int_i]
            self.dataRewards[source]= self.dataRewards[source] or {}
            table.insert(self.dataRewards[source],id)
        end 
    end 
    local uiTreasure = clanTypeData and clanTypeData.ClanTreasure or 0
    for i,lists in pairs(self.dataRewards) do 
        if lists then 
            local bHas = true
            for ii,uid in ipairs(lists ) do 
                if uid == uiTreasure then 
                    bHas = false 
                end 
            end 
            if bHas then  
                table.insert(lists ,uiTreasure)
            end 
        end 
    end
    self:RefreshRewards()
end
function ClanEliminateUI:RefreshRewards()
    self.dataChooseType = self.dataChooseType or CET_JIEMENG
    self.objInfo_Box1:SetActive(self.dataChooseType == CET_JIEMENG)
    self.objInfo_Box2:SetActive(self.dataChooseType == CET_QUZHU)
    self.objInfo_Box3:SetActive(self.dataChooseType == CET_ZHENGFU)

    for i,objitem in ipairs(self.objs_itembox) do 
        objitem:SetActive(false)
    end 
    local int_index = 1
    local objitem 
    -- 先判断铜币 id硬取 数目待算
    if self.dataChooseType == CET_QUZHU then 
        objitem = self.objs_itembox[int_index]
        objitem:SetActive(true)
        local item = TableDataManager:GetInstance():GetTableData("Item",1301)
        self.ItemIconUI:UpdateUIWithItemTypeData(objitem,item)
        self.ItemIconUI:SetItemNum(objitem,2000)
        self.ItemIconUI:AddClickFunc(objitem,function()
            local tips = {
                ['title'] = '每月俸禄',
                ['titlestyle'] = 'outline',
                ['content'] = '<color=#FFFFFF>铜币</color>\n\n门派每月上供的俸禄',
                ['kind'] = 'normal',
            }
            OpenWindowImmediately("TipsPopUI", tips)    
        end )
        int_index = int_index + 1
    end 
    local items = self.dataRewards[self.dataChooseType]

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
function ClanEliminateUI:InitBattleBuffBox(clanTypeData, eliminateTypeData)
    local int_all = ClanDataManager:GetInstance():GetClanTiaoXinNum()
    local int_side = ClanDataManager:GetInstance():GetClanTiaoXinNum(self.calnTypeID)
    local iLayer = 0
    iLayer = iLayer + ClanDataManager:GetInstance():GetYeJingYuQinLayer(self.calnTypeID)
    iLayer = iLayer + ClanDataManager:GetInstance():GetGongShouTongMengLayer(self.calnTypeID)

    self.com_Battlebuff_all.text = string.format( "累计踢馆门派：%d",int_all )
    self.com_Battlebuff_side.text = string.format( "阵营踢馆门派：%d",int_side )
    self.com_Battlebuff_buff.text = string.format( "踢馆战中敌方各项一级属性提升%d%%，生命值提升%d%%",iLayer,iLayer)
end

function ClanEliminateUI:OnClick_Tips_TiGuan()
    local tips = {
        ['title'] = '玩法介绍',
        ['content'] = '进行三场踢馆战斗：\n分别为：弟子战、长老战、掌门战\n降低门派好感度<color=#C53926>60</color>\n失败会被关进大牢'
    }
    OpenWindowImmediately("TipsPopUI",tips)
end

function ClanEliminateUI:OnClickTog(itype)
    self.dataChooseType = itype
    self:RefreshRewards()
end

function ClanEliminateUI:OnClick_Event_TiGuan(bcontinue)
	dprint(string.format("OnClick_JoinClan"..tostring(bcontinue)))
	local uiClanTypeID = self.calnTypeID
	local clickData = EncodeSendSeGC_Click_Choose_TiGuan(uiClanTypeID,bcontinue and 1 or 0)
	local iSize = clickData:GetCurPos()
	NetGameCmdSend(SGC_CLICK_CHOOSE_TIGUAN, iSize, clickData)
    RemoveWindowImmediately("ClanEliminateUI")
	DisplayActionEnd()
end

function ClanEliminateUI:OnDestroy()
    self.ItemIconUI:Close()  
end


function ClanEliminateUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function ClanEliminateUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

-- 显示加入人数
function ClanEliminateUI:SetJoinNumber(calnBaseID)
	local num = ClanDataManager:GetInstance():GetClanJoinNumber(calnBaseID)

	self.comText_join.text = string.format("当前已有%d人加入", num)
end

function ClanEliminateUI:SetShowMemberType(showMemberType)
    self.showMemberType = showMemberType
    
    self.comTextToggleAllBattle.color = UI_COLOR.black
    self.comTextToggleBattle1.color = UI_COLOR.black
    self.comTextToggleBattle2.color = UI_COLOR.black
    self.comTextToggleBattle3.color = UI_COLOR.black
    if showMemberType == ShowMemberType.ALL then 
        self.comTextToggleAllBattle.color = UI_COLOR.white
    elseif showMemberType == ShowMemberType.BATTLE1 then 
        self.comTextToggleBattle1.color = UI_COLOR.white
    elseif showMemberType == ShowMemberType.BATTLE2 then 
        self.comTextToggleBattle2.color = UI_COLOR.white
    elseif showMemberType == ShowMemberType.BATTLE3 then 
        self.comTextToggleBattle3.color = UI_COLOR.white
    end
    self:RefreshMemberList()
end

return ClanEliminateUI