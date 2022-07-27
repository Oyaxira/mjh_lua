HouseRole = class("HouseRole", BaseRole)

local revert = {
	[1] = {"Strength" ,"力道"},
	[2] = {"Constitution" ,"体质"},
	[3] = {"Energy" ,"精力"},
	[4] = {"Power" ,"内劲"},
	[5] = {"Agility" ,"灵巧"},
	[6] = {"Comprehension" ,"悟性"},

	[7] = {"FistMastery" ,"拳掌精通"},
	[8] = {"SwordMastery" ,"剑法精通"},
	[9] = {"KnifeMastery" ,"刀法精通"},
	[10] = {"LegMastery" ,"腿法精通"},
	[11] = {"StickMastery" ,"奇门精通"},
	[12] = {"NeedleMastery" ,"暗器精通"},
	[13] = {"HealingMastery" ,"医术精通"},
    [14] = {"SoulMastery" ,"内功精通"},
    
    [15] = {"HP" ,"生命"},
    [16] = {"MP" ,"真气"},
    [17] = {"HittingPer" ,"命中率"},
    [18] = {"CritsPer" ,"暴击率"},
    [19] = {"CritsFactor" ,"暴击伤害倍率"},
    [20] = {"Speed" ,"速度值"},
}

function HouseRole:ctor(uiID, roleData)
    self:UpdateNPCRoleInfo(roleData)
end

function HouseRole:UpdateNPCRoleInfo(roleData)
    self.roleType = ROLE_TYPE.HOUSE_ROLE;
    self._roleData = roleData
end

function HouseRole:SetMeridiansInfo(breakData,akMeridians)
    if breakData ~= nil and akMeridians~= nil then
        self.breakData = breakData
        self.akMeridians = akMeridians
    end
end

-- itemIndex: 武器随机下标（因为掌门对决固定为0，所以加上了）
function HouseRole:UpdateAttr(itemIndex)

    if self:IsError() then
        derror('npc dbData error');
        return;
    end

    -- 基础
    local level = self.uiLevel;
    local attrs = table_c2lua(self.aiAttrs);
    local revertT = {};
    for i = 1, #(revert) do
        local attr = revert[i][2];
        if AttrType_Revert[attr] then
            revertT[AttrType_Revert[attr]] = attrs[i];
        end
    end

    self.baseAttr = {revertT};
    self.convBaseAttr = RoleDataHelper.GetConvertAttr(revertT, level);

    -- 
    local _func = function(attrData)
        local attr = {};
        for k, v in pairs(attrData) do
            for kk, vv in pairs(v) do
                if not attr[kk] then
                    attr[kk] = 0;
                end
                attr[kk] = attr[kk] + vv;
            end
        end
        return attr;
    end

    -- 武学
    self.martialAttr = RoleDataHelper.GetAttrByMartials(self, self._dbData);
    self.convMartialAttr = RoleDataHelper.GetConvertAttr(_func(self.martialAttr), level);

    -- 装备
    self.equipAttr = RoleDataHelper.GetAttrByEquips(self, self._dbData, itemIndex);
    self.convEquipAttr = RoleDataHelper.GetConvertAttr(_func(self.equipAttr), level);

    -- 称号
    self.titleAttr = RoleDataHelper.GetAttrByTitle(self, self._dbData);
    self.convTitleAttr = RoleDataHelper.GetConvertAttr(_func(self.titleAttr), level);

    -- 天赋
    self.fixGiftAttr = RoleDataHelper.GetAttrByGifts(self, self._dbData, true, false, false);
    self.perGiftAttr = RoleDataHelper.GetAttrByGifts(self, self._dbData, false, true, false);
    self.conGiftAttr = RoleDataHelper.GetAttrByGifts(self, self._dbData, false, false, true);
    self.convFixGiftAttr = RoleDataHelper.GetConvertAttr(_func(self.fixGiftAttr), level);
    self.convPerGiftAttr = RoleDataHelper.GetConvertAttr(_func(self.perGiftAttr), level);
    self.convConGiftAttr = RoleDataHelper.GetConvertAttr(_func(self.conGiftAttr), level);

    -- 经脉
    self.meridiansAttr = {MeridiansDataManager:GetInstance():GetMeridiansInfo(self.breakData,self.akMeridians)};
    self.convMeridiansAttr = RoleDataHelper.GetConvertAttr(_func(self.meridiansAttr), level);

    -- 角色卡
    local overlayLevel = RoleDataManager:GetInstance():GetRoleOverlayLevel(self.uiID);
    local uiCardLevel = self.uiOverlayLevel ~= nil and self.uiOverlayLevel or overlayLevel;
    local TB_RolePiece = TableDataManager:GetInstance():GetTable("RolePiece") or {};
    local sumAttrAdd = 0;
    for i = 1, #(TB_RolePiece) do
        if uiCardLevel == TB_RolePiece[i].Level then
            sumAttrAdd = sumAttrAdd + TB_RolePiece[i].AttrAdd;
            break;
        end
    end
    local baseAttr = {
        AttrType.ATTR_LIDAO,
        AttrType.ATTR_TIZHI,
        AttrType.ATTR_JINGLI,
        AttrType.ATTR_NEIJIN,
        AttrType.ATTR_LINGQIAO,
        AttrType.ATTR_WUXING,
    }
    local cardAttr = {};
    for i = 1, #(baseAttr) do
        cardAttr[baseAttr[i]] = (self.baseAttr[1][baseAttr[i]] or 0) * sumAttrAdd / 10000;
    end
    self.cardAttr = {cardAttr};
    self.convCardAttr = RoleDataHelper.GetConvertAttr(cardAttr, level);
end

function HouseRole:GetAttrByMeridians()
    return self.meridiansAttr or {};
end

function HouseRole:GetConvAttrByMeridians()
    return self.convMeridiansAttr or {};
end


function HouseRole:GetAttrByCardLevel()
    return self.cardAttr or {};
end

function HouseRole:GetConvAttrByCardLevel()
    return self.convCardAttr or {};
end

function HouseRole:GetAttrByTBData()
    return self.baseAttr or {};
end

function HouseRole:GetConvAttrByTBData()
    return self.convBaseAttr or {};
end

function HouseRole:GetAttrByMartials()
    return self.martialAttr or {};
end

function HouseRole:GetConvAttrByMartials()
    return self.convMartialAttr or {};
end

function HouseRole:GetAttrByEquips()
    return self.equipAttr or {};
end

function HouseRole:GetConvAttrByEquips()
    return self.convEquipAttr or {};
end

function HouseRole:GetAttrByTitle()
    return self.titleAttr or {};
end

function HouseRole:GetConvAttrByTitle()
    return self.convTitleAttr or {};
end

function HouseRole:GetFixAttrByGifts()
    return self.fixGiftAttr or {};
end

function HouseRole:GetPerAttrByGifts()
    return self.perGiftAttr or {};
end

function HouseRole:GetConAttrByGifts()
    return self.conGiftAttr or {};
end

function HouseRole:GetFixConvAttrByGifts()
    return self.convFixGiftAttr or {};
end

function HouseRole:GetPerConvAttrByGifts()
    return self.convPerGiftAttr or {};
end

function HouseRole:GetConConvAttrByGifts()
    return self.convConGiftAttr or {};
end

function HouseRole:IsError()
    if not self._data or not self._dbData then
        return true;
    end
    return false;
end

-- 基础
function HouseRole:GetAttr(sAttr)
    if self.aiAttrs then
        local attrs = table_c2lua(self.aiAttrs);
        for i = 1, #(revert) do
            if revert[i][1] == sAttr then
                return attrs[i] or 0;
            end
        end
    end    
    return 0;
end

function HouseRole:GetEquipItems()
    if self:IsError() then
        return {};
    end

    return self.akEquipItem or {};
end

-- 装备
function HouseRole:GetEquipItemInfos()
    local infos = {};
    local equipItems = self:GetEquipItems();
    if equipItems then
        for equips, itemID in pairs(equipItems) do
            local info = {};
            info.iInstID = itemID;
            infos[equips] = info;
        end
    end
    return infos;
end

-- 武学
function HouseRole:GetMartials()
    local auiLvs = {};
    local auiTypeIds = {};
    if self.MartialsTypeIDValue then
        local index = 0;
        for k, v in pairs(self.MartialsTypeIDValue) do
            auiLvs[index] = v.uiLevel;
            auiTypeIds[index] = k;
            index = index + 1;
        end 
    end
    return auiTypeIds, auiLvs;
end

function HouseRole:SetQueryType(eQueryType)
    self.eQueryType = eQueryType
end

-- 天赋
function HouseRole:GetGifts()
    local index = 0;
    local auiTypeIds = {};

    local platTeamInfo = nil

    if self.eQueryType == SPTQT_PLAT then
        platTeamInfo = globalDataPool:getData('PlatTeamInfo')
    elseif self.eQueryType == SPTQT_OBSERVE_OTHER then
        platTeamInfo = globalDataPool:getData('ObserveInfo')
    elseif self.eQueryType == SPTQT_OBSERVE_ARENA then
        platTeamInfo = globalDataPool:getData('ObserveArenaInfo')
    end
    local l_TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
    if self.auiRoleGift then
        for k, v in pairs(self.auiRoleGift) do
            if platTeamInfo and platTeamInfo.GiftInfo and platTeamInfo.GiftInfo[v] then
                local typeID = platTeamInfo.GiftInfo[v].uiTypeID
                local kGift = l_TB_Gift[typeID]
                if kGift and  ((kGift.SurperType > 0 and platTeamInfo.GiftInfo[v].bIsGrowUp > 0) or (kGift.SurperType == 0)) then
                    auiTypeIds[index] = typeID;
                    index = index + 1;
                end
            end
        end
    end
    return auiTypeIds;
end

function HouseRole:GetLevel()
    return self.uiLevel;
end

function HouseRole:GetClan()
    return self:GetDBClan();
end

function HouseRole:GetGoodEvil()
    return self.iGoogEvil;
end

function HouseRole:GetModelID()
    return self.super.GetModelID(self);
end

function HouseRole:GetWeaponTypeID()
    local akEquipItemInfos = self:GetEquipItemInfos()
    if akEquipItemInfos and akEquipItemInfos[REI_WEAPON] then
        return akEquipItemInfos[REI_WEAPON]["iTypeID"];
    end
    return 0;
end

function HouseRole:GetEnchanceGrade()
    return 0;
end