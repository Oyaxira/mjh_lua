ObsBabyUI = class("ObsBabyUI",BaseWindow)

-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

local AttrBase = {
	[1] = {"ATTR_MAXHP" ,"生命", "HpLimitMin", "HpLimitMax"},
	[2] = {"ATTR_MAXMP" ,"真气", "MpLimitMin", "MpLimitMax"},
	[3] = {"Defense" ,"防御", "DefenseLimitMin", "DefenseLimitMax"},
	[4] = {"ATTR_MARTIAL_ATK" ,"武学攻击", "MartialAttackLimitMin", "MartialAttackLimitMax"},
}

local AttrJingtong = {
    [1] = {"SwordMastery" ,"剑法精通"},
	[2] = {"KnifeMastery" ,"刀法精通"},
	[3] = {"FistMastery" ,"拳掌精通"},
	[4] = {"LegMastery" ,"腿法精通"},
	[5] = {"StickMastery" ,"奇门精通"},
	[6] = {"NeedleMastery" ,"暗器精通"},
	[7] = {"HealingMastery" ,"医术精通"},
	[8] = {"SoulMastery" ,"内功精通"},
}

local ColorRankNumStr = {
    UI_COLOR['white'],
    RANK_COLOR[RankType.RT_Green],
    RANK_COLOR[RankType.RT_Blue],
    RANK_COLOR[RankType.RT_Purple],
    RANK_COLOR[RankType.RT_Golden]
}
function ObsBabyUI:ctor()

end

function ObsBabyUI:OnPressESCKey()
    if self.comReturn_Button then
        self.comReturn_Button.onClick:Invoke()
    end
end

function ObsBabyUI:Create()
	local obj = LoadPrefabAndInit("Interactive/ObsBabyUI", TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end


-- 根据中文从静态表中获取对应的基础属性
function ObsBabyUI:GetBabyParamByAttrType(attrType)
    local TB_BabyBaseAttr = TableDataManager:GetInstance():GetTable("BabyBaseAttr")
    -- TODO 调整为表驱动
    if attrType == "生命" then
        return TB_BabyBaseAttr[1].BaseHP
    elseif attrType == "真气" then
        return TB_BabyBaseAttr[1].BaseMP
    elseif attrType == "防御" then
        return TB_BabyBaseAttr[1].BaseDefense
    elseif attrType == "武学攻击" then
        return TB_BabyBaseAttr[1].MartialAttack
    elseif attrType == "剑法精通" then
        return TB_BabyBaseAttr[1].JianFaJingTong
    elseif attrType == "刀法精通" then
        return TB_BabyBaseAttr[1].DaoFaJingTong
    elseif attrType == "拳掌精通" then
        return TB_BabyBaseAttr[1].QuanZhangJingTong
    elseif attrType == "腿法精通" then
        return TB_BabyBaseAttr[1].TuiFaJingTong
    elseif attrType == "奇门精通" then
        return TB_BabyBaseAttr[1].QiMenJingTong
    elseif attrType == "暗器精通" then
        return TB_BabyBaseAttr[1].AnQiJingTong
    elseif attrType == "医术精通" then
        return TB_BabyBaseAttr[1].YiShuJingTong
    elseif attrType == "内功精通" then
        return TB_BabyBaseAttr[1].NeiGongJingTong
    end
    return 0
end

function ObsBabyUI:GetBabyNumAndDesIDInTable(attrValue,attrType,attrBaseIndex,babyAttrTable)
    local param = attrValue
    for n=1, #babyAttrTable do
        local value = babyAttrTable[n]
        local attrValueMin,attrValueMax
        if (value.LimitMin and value.LimitMax) then
            attrValueMin = value.LimitMin
            attrValueMax = value.LimitMax
        else
            if (AttrBase[attrBaseIndex]) then
                attrValueMin = value[AttrBase[attrBaseIndex][3]]
                attrValueMax = value[AttrBase[attrBaseIndex][4]]
            else
                derror("error: GetBabyNumAndDesIDInTable failed")
                return
            end
        end
        -- 根据区间判断档位 按找到的第一个区间（可能重复） 如果没有任何满足的返回最后一个区间
        if param >= attrValueMin and param <= attrValueMax then
            return n,value.DesID
        end
        -- 如果是最后一个，特殊判断
        if n == #babyAttrTable then
            if param > attrValueMax then
                return n,value.DesID
            end
        end
    end
    return 0,0
end

 --[====[
<struct Name="BabyStateInfo" Comment="徒儿信息">
<member Name="uiStateID" Type="DWord" InitValue="0" Comment="uiID"/>
<member Name="uiBabyID" Type="DWord" InitValue="0" Comment="RoleID"/>
<member Name="uiFatherID" Type="DWord" InitValue="0" Comment="RoleID"/>
<memeer Name="uiMotherID" Type="DWord" InitValue="0" Comment="RoleID"/>
<member Name="uiBirthday" Type="DWord" InitValue="0" Comment="预计出生日期"/>
<member Name="uiState" Type="DWord" InitValue="0" Comment="状态"/>
<member Name="acPlayerName" Type="string" Length="SSD_MAX_CHAR_NAME" Comment="名"/>
</struct>
]====]
function ObsBabyUI:RefreshUI(uiBabyID)
    uiBabyID = tonumber(uiBabyID) or 0
    RemoveAllChildren(self.objBassAttrLayout)
    RemoveAllChildren(self.objJingTongAttrLayout)
    self.objCloneText:SetActive(false)

    local TB_BabyBassAttrDes = TableDataManager:GetInstance():GetTable("BabyBassAttrDes")

    local kBabyInfo = RoleDataManager:GetInstance():GetBabyInfoByBabyRoleID(uiBabyID)
    if kBabyInfo then
        local roleData = RoleDataManager:GetInstance():GetRoleData(kBabyInfo.uiBabyID)
        local dbRoleData = TB_Role[roleData.uiTypeID]

        local time = getDreamlandTimeString(kBabyInfo.uiBirthday)
        self.comTimeText.text = "预计拜师日期：<color=#82312E>" .. time .. "</color>"

        
        local roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByID(kBabyInfo.uiBabyID)
        if roleModelData and roleModelData["Drawing"] then
            self:SetSpriteAsync(roleModelData["Drawing"],self.comCGImage)
        end

        self.comTextLog1.text = '......'
        self.comTextLog2.text = '......'


        local bShowDetail = CheatDataManager:GetInstance():GetShowBabyDetails()

        local BabyJingtongTable = TableDataManager:GetInstance():GetTable("BabyJingTongAttrDes")
        if roleData then
            for i=1, #AttrBase do
                local attrValue = RoleDataHelper.GetAttr(roleData, dbRoleData, AttrBase[i][1])
                local desID = 0
                local num = 1
                
                -- 获取当前系数并显示对应资质
                num,desID = self:GetBabyNumAndDesIDInTable(attrValue,AttrBase[i][2],i,TB_BabyBassAttrDes)
                if num == 0 and desID == 0 then
                    derror("error: not found param in TB_BabyBassAttrDes table limit")
                    return
                end
                local newObj = CloneObj(self.objCloneAttr_base, self.objBassAttrLayout)
                if (newObj ~= nil) then
                    newObj:SetActive(true)
                    local comAttrName = self:FindChildComponent(newObj,'Text_name','Text')
                    local comAttrlevel = self:FindChildComponent(newObj,'Text_level','Text')
                    comAttrlevel.color = ColorRankNumStr[num]
                    local strValue  = tostring(GetLanguageByID(desID)) 
                    if bShowDetail then 
                        strValue =  attrValue 
                    end 
                    comAttrlevel.text = strValue
                    comAttrName.text = AttrBase[i][2] .. ":"
                end
            end

            for i=1, #AttrJingtong do
                local attrValue = RoleDataHelper.GetAttr(roleData, dbRoleData, AttrJingtong[i][1])
                local desID = 0
                local num = 1
                num,desID = self:GetBabyNumAndDesIDInTable(attrValue,AttrJingtong[i][2],i,BabyJingtongTable)
                if num == 0 and desID == 0 then
                    derror("error: not found param in BabyJingtongTable table limit")
                    return
                end
                local newObj = CloneObj(self.objCloneAttr_jingtong, self.objJingTongAttrLayout)
                if (newObj ~= nil) then
                    newObj:SetActive(true)
                    local comAttrName = self:FindChildComponent(newObj,'Text_name','Text')
                    local comAttrlevel = self:FindChildComponent(newObj,'Text_level','Text')
                    comAttrlevel.color = ColorRankNumStr[num]
                    local strValue  =tostring(GetLanguageByID(desID)) 
                    if bShowDetail then 
                        strValue =  attrValue 
                    end 
                    comAttrlevel.text = strValue
                    comAttrName.text = AttrJingtong[i][2] .. ":"
                end
            end
        end
    end
end

function ObsBabyUI:Init()

    -- local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    -- if shareGroupUI then
    --     if not MSDKHelper:IsPlayerTestNet() then

    --         local _callback = function(bActive)
    --             local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
    --             if serverAndUIDUI and serverAndUIDUI._gameObject then
    --                 serverAndUIDUI._gameObject:SetActive(bActive);
    --             end
    --         end

    --         self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
    --         self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.TUDI, _callback);

    --         local canvas = shareGroupUI:GetComponent('Canvas');
    --         if canvas then
    --             canvas.sortingOrder = 3000;
    --         end
    --     else
    --         shareGroupUI:SetActive(false);
    --     end
    -- end

    self.comReturn_Button = self:FindChildComponent(self._gameObject,"newFrame/Btn_exit","Button")
    self.comTimeText = self:FindChildComponent(self._gameObject,"Time","Text")
    self.objBassAttrLayout = self:FindChild(self._gameObject,"BassAttrLayout")
    self.objJingTongAttrLayout = self:FindChild(self._gameObject,"JingTongAttrLayout")
    self.objCloneText = self:FindChild(self._gameObject,"TextForClone")

    
    self.objCloneAttr_base = self:FindChild(self._gameObject,"Attr_base")
    self.objCloneAttr_base:SetActive(false)
    self.objCloneAttr_jingtong = self:FindChild(self._gameObject,"Attr_jingtong")
    self.objCloneAttr_jingtong:SetActive(false)


    self.comCGImage = self:FindChildComponent(self._gameObject, "baby","Image")

    self.comTextLog1 = self:FindChildComponent(self._gameObject, "Log_1","Text")
    self.comTextLog2 = self:FindChildComponent(self._gameObject, "Log_2","Text")

    self:RemoveButtonClickListener(self.comReturn_Button)   
    self:AddButtonClickListener(self.comReturn_Button, function()
        RemoveWindowImmediately('ObsBabyUI')
    end)
end

function ObsBabyUI:OnEnable()
   
end

function ObsBabyUI:OnDisable()
    
end

function ObsBabyUI:OnDestroy()
    -- if self.TencentShareButtonGroupUI then
    --     self.TencentShareButtonGroupUI:Close();
    -- end
end


return ObsBabyUI