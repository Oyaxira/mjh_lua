CardsUpgradeDataManager = class('CardsUpgradeDataManager');
CardsUpgradeDataManager._instance = nil;

local CARD_TYPE_ROLE = 0
local CARD_TYPE_PET = 1
local CARD_TYPE_BOND = 2


local ROLE_CARD_MAX_LV = 10
local PET_CARD_MAX_LV = 10
local BOND_CARD_MAX_LV = 10

function CardsUpgradeDataManager:GetInstance()
    if CardsUpgradeDataManager._instance == nil then
        CardsUpgradeDataManager._instance = CardsUpgradeDataManager.new();
        CardsUpgradeDataManager._instance:Init();
    end

    return CardsUpgradeDataManager._instance;
end

function CardsUpgradeDataManager:Init()
    self:ResetManager()
end
function CardsUpgradeDataManager:ResetManager()
    self.roleIdCardListMap = nil
    self.akInstPetCardList = nil
    self.akRoleCardList_Grade2Effects = nil
    self.akPetBaseTable = nil
    self.m_akRoleCard = nil
    self.bondinited = nil

    self.Bond_AttrGrow_MAP = {}
    local TB_BondLevel = TableDataManager:GetInstance():GetTable("BondLevel") or {}
    for ilevel = 1,BOND_CARD_MAX_LV do 
        local cur = TB_BondLevel[ilevel] and TB_BondLevel[ilevel].GrowScale or 0
        cur = cur / 10000
        if ilevel == 1 then 
            self.Bond_AttrGrow_MAP[ilevel] = cur
        else 
            self.Bond_AttrGrow_MAP[ilevel] = self.Bond_AttrGrow_MAP[ilevel - 1] + cur
        end 
    end 
end
function CardsUpgradeDataManager:InitTable_RoleCard()
    local _RoleCard = TableDataManager:GetInstance():GetTable("RoleCard")
    if _RoleCard and next(_RoleCard) ~= nil then
        if self.m_akRoleCard  == nil then 
            self.m_akRoleCard  = {}
        end

        for _, data in pairs(_RoleCard) do
            if data.EffectEnum == RoleCardEffect.RCE_GiftTreeUp then
                local roleBaseID = data.RoleID
                local uiLevel = data.Level
                local uiTreeID = data.EffectValue1
                local uiIndex = data.EffectValue2

                local _RoleGiftTree = TableDataManager:GetInstance():GetTableData("RoleWishTree",uiTreeID)
                if _RoleGiftTree ~= nil then
                    local uiGiftID = _RoleGiftTree.GiftIDs[uiIndex]
                    if self.m_akRoleCard[roleBaseID] == nil then
                        self.m_akRoleCard[roleBaseID] = {}
                    end

                    if self.m_akRoleCard[roleBaseID][uiLevel] == nil then
                        self.m_akRoleCard[roleBaseID][uiLevel] = {}
                    end
                    table.insert(self.m_akRoleCard[roleBaseID][uiLevel], uiGiftID)
                end
            end
        end
    end
end
-------------------------------心愿树相关-------------------------------------
-----------------------------------------------------------------------------
function CardsUpgradeDataManager:GetGiftTreeByTypeID(roleBaseID)
    return self.map_Role2GiftTree[roleBaseID] or {}
end
function CardsUpgradeDataManager:GetTreeGift(roleBaseID, uiLevel, uiWishTreeID)
    if self.m_akRoleCard == nil then
        self:InitTable_RoleCard()
    end
    if self.m_akRoleCard == nil then
        return 0
    end
    if  self.m_akRoleCard[roleBaseID] == nil then
        return 0
    end
    local giftID = 0
    local _treeData = GetTableData("RoleWishTree", uiWishTreeID)
    if _treeData and _treeData.GiftIDs then
        local _table_UnlockGift = {}
        local _table_gift = self.m_akRoleCard[roleBaseID]
        for index, _table_id in pairs(_table_gift) do
            if uiLevel >= index then
                for _, id in pairs(_table_id) do
                    _table_UnlockGift[id] = true
                end
            end
        end

        for index = 1, #_treeData.GiftIDs do
            local id = _treeData.GiftIDs[index]
            if _table_UnlockGift[id] ~= nil then
                giftID = id
            end
        end
    end
    return giftID
end
-----------------------------------------------------------------------------
-------------------------------初始化----------------------------------------

function CardsUpgradeDataManager:SetRolePetInfo(kRetData)
    if not kRetData then return end 
    local akCardsInstInfo = {}
    local cardtype = kRetData.uiCardType
    if not cardtype then return end 
    akCardsInstInfo[cardtype] = akCardsInstInfo[cardtype] or {}

    if kRetData.akData and kRetData.iNum then 
        for i=1,kRetData.iNum do 
            local carddate = kRetData.akData[i-1]
            local uiCardID = carddate.uiCardID 
            akCardsInstInfo[cardtype][uiCardID] = carddate
        end
        self:InitCardList(akCardsInstInfo)
        -- 刷新标记
        LuaEventDispatcher:dispatchEvent("UPDATE_CARDSUPGRADE_UI")
    end 
end
function CardsUpgradeDataManager:InitCardList(akCardsInstInfo)
    self.roleIdCardListMap = self.roleIdCardListMap or {}
    self.akInstPetCardList = self.akInstPetCardList or {} 
    local tempcardlist = {}
    local roleBaseID = 0
    self.map_Role2GiftTree = self.map_Role2GiftTree or {}
    local bool_firstinit = not self.akRoleCardList_Grade2Effects  
    -- 初始化缓存 如果没有ak指定的卡片更新传进来就不
    if bool_firstinit then 
        local init_role_map = {}
        local TB_RoleCard = TableDataManager:GetInstance():GetTable("RoleCard")
        for i ,v in pairs(TB_RoleCard) do 
            roleBaseID = v.RoleID
            if roleBaseID and TB_Role[roleBaseID]  then 
                tempcardlist[roleBaseID] = tempcardlist[roleBaseID] or {}
                tempcardlist[roleBaseID][#tempcardlist[roleBaseID] + 1]  = v

                if bool_firstinit and v.EffectEnum == RoleCardEffect.RCE_GiftTreeUp then 
                    local treeid  = v.EffectValue1
                    self.map_Role2GiftTree[roleBaseID] = self.map_Role2GiftTree[roleBaseID] or {}
                    self.map_Role2GiftTree[roleBaseID][treeid] = 0
                end 
                if not init_role_map[roleBaseID] then 
                    self.roleIdCardListMap[roleBaseID] = self.roleIdCardListMap[roleBaseID] or {
                            level = 0,
                            piece = 0,
                    }
                    init_role_map[roleBaseID] = true 
                end
            end 
        end 
        self.akRoleCardList_Grade2Effects = {}
        for roleBaseID, _rolecard in pairs(tempcardlist) do     
            local itemid = RoleDataManager.GetInstance():GetHeirloomByTypeID(roleBaseID)
            local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemid)
            if itemData and itemData.OrigItemID then 
                itemid = itemData.OrigItemID
            end 
            local gift = 0
            local rank_ex = 0
            local treasure_ex = itemid
            local dispo_ex = 0
            local specialdesc = 0

            self.akRoleCardList_Grade2Effects[roleBaseID] = {}
            for igrade = 0 ,ROLE_CARD_MAX_LV do 
                for i,rolecard in ipairs(_rolecard) do 
                    if rolecard.Level == igrade then 
                        if rolecard.EffectEnum == RoleCardEffect.RCE_RoleQualityUp then 
                            rank_ex = rank_ex + 1
                        elseif rolecard.EffectEnum == RoleCardEffect.RCE_TreasureUp then 
                            treasure_ex = rolecard.EffectValue1
                        elseif rolecard.EffectEnum == RoleCardEffect.RCE_GetGift then 
                            gift = rolecard.EffectValue1
                        elseif rolecard.EffectEnum == RoleCardEffect.RCE_Disposition then 
                            dispo_ex =rolecard.EffectValue1
                        elseif rolecard.EffectEnum == RoleCardEffect.RCE_GiftTreeUp then 
                            --- 新的 天赋书map
                        elseif rolecard.EffectEnum == RoleCardEffect.RCE_SpecialDesc then 
                            specialdesc =rolecard.EffectValue1
                        end
                    end 
                end 
                local temptable = {
                    [RoleCardEffect.RCE_GetGift] = gift,
                    [RoleCardEffect.RCE_RoleQualityUp] = rank_ex,
                    [RoleCardEffect.RCE_TreasureUp] = treasure_ex,
                    [RoleCardEffect.RCE_Disposition] = dispo_ex,
                    [RoleCardEffect.RCE_SpecialDesc] = specialdesc,
                }
                self.akRoleCardList_Grade2Effects[roleBaseID][igrade] = temptable
            end 
        end 
    end
    if akCardsInstInfo and akCardsInstInfo[CARD_TYPE_ROLE] then 
        local kPlatTeamInfo = globalDataPool:getData('PlatTeamInfo')
        local bHasPlatRoleInfo = (kPlatTeamInfo and kPlatTeamInfo.RoleInfos) and true or false
        local roleDataManager = RoleDataManager.GetInstance()
        for roleBaseID, datatemp in pairs(akCardsInstInfo[CARD_TYPE_ROLE]) do 
            local kRoleCard = self.roleIdCardListMap[roleBaseID]
            if datatemp and roleBaseID and kRoleCard then      
                local oldLevel = kRoleCard.level
                kRoleCard.level = datatemp.uiLevel
                kRoleCard.piece = datatemp.uiCardNum
                kRoleCard.uiWishFlag = datatemp.uiUseFlag
                kRoleCard.unlock = true
                
                if  kRoleCard.level ~=  oldLevel and bHasPlatRoleInfo then
                    for k ,v in pairs(kPlatTeamInfo.RoleInfos) do
                        if v.uiTypeID == roleBaseID then
                            v.uiOverlayLevel = datatemp.uiLevel
                            v.uiRank = roleDataManager:GetRoleRankByTypeID(roleBaseID)
                            break
                        end
                    end
                end

            end 
        end 

        if self.bondinited then 
            self:UpdateBondCanLVUP()
        end
    end 
    
    self.akPetBaseTable = self.akPetBaseTable or  {}
    local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
    if bool_firstinit then 
        if TB_Pet then 
            for i,v in pairs(TB_Pet) do 
                local rootid = v.BaseID
                if v.Chain and #v.Chain> 0 then 
                    local datatemp = {}                     
                    self.akPetBaseTable[rootid] =  {
                        level = 0,
                        piece = 0,
                        ifchose = true , 
                        chain = v.Chain,
                        card = v ,
                        choseid = rootid,
                    }
                    for childindex, childid in pairs(v.Chain) do
                        -- body
                        if TB_Pet[childid] then 
                            local datatemp = {}
                            self.akPetBaseTable[childid] = self.akPetBaseTable[childid] or {
                                level = 0,
                                piece = 0,
                                ifchose = false , 
                                rootid = rootid,
                                card = TB_Pet[childid]
                            }
                        end 
                    end
                end 
            end 
        end
    end
    if akCardsInstInfo and akCardsInstInfo[CARD_TYPE_PET] then 
        for cardid,datatemp in pairs(akCardsInstInfo[CARD_TYPE_PET]) do 
            if self.akPetBaseTable[cardid] then 
                self.akPetBaseTable[cardid].level = datatemp.uiLevel or 0
                self.akPetBaseTable[cardid].piece = datatemp.uiCardNum or 0
                self.akPetBaseTable[cardid].ifchose = datatemp.uiUseFlag == 1 and true or false 
                self.akPetBaseTable[cardid].unlock = true
                local rootid = self.akPetBaseTable[cardid].rootid
                if rootid and self.akPetBaseTable[rootid] then 
                    if self.akPetBaseTable[cardid].ifchose then 
                        self.akPetBaseTable[rootid].choseid = cardid
                    end
                end
                if self.akPetBaseTable[cardid].chain then 
                    for idx,childid in ipairs(self.akPetBaseTable[cardid].chain) do 
                        local childdatatemp = self.akPetBaseTable[childid]
                        if childdatatemp then 
                            self.akPetBaseTable[childid].root_piece = datatemp.uiCardNum or 0
                        end
                    end 
                end
            end
        end 
    end

    if bool_firstinit then         
        self.akBondBaseTable = {}
        self:RequestAllDatas(true)
    end
    if akCardsInstInfo and akCardsInstInfo[CARD_TYPE_BOND] then 
        self.bondinited = true 
        for iBondID,datatemp in pairs(akCardsInstInfo[CARD_TYPE_BOND]) do 
            self.akBondBaseTable[iBondID] = datatemp
        end 
        if self.bondinited then 
            self:UpdateBondCanLVUP()
        end
        self:UpdateBondInfluenceMap()
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
end
local TLastCheckTime
function CardsUpgradeDataManager:RequestAllDatas(bForce)
    if bForce or TLastCheckTime == nil or TLastCheckTime + 301 < os.time() then 
        TLastCheckTime = os.time()
        SendRequestRolePetCardOperate(RPCRT_ALL, RPCOT_REQ_DATA, 0, 0)
    end
end

function CardsUpgradeDataManager:CheckPetCardsExsUpGrade()
    if not self.akPetBaseTable then 
        self:InitCardList()
    end
    local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
    for cardid,carddata in pairs(self.akPetBaseTable) do 
        local iLevel = carddata.level or 0
        local iNeed  = self:GetGradeNeedPiece(math.min(iLevel +1,PET_CARD_MAX_LV),true) or 0
        local iPiece = carddata.piece or 0
        if carddata.chain and #carddata.chain > 0 then 
            if iLevel < 5 and iPiece ~= 0 and iPiece >= iNeed then 
                return true 
            end 
        else 
            local rootid = carddata.rootid
            local rootdata = self.akPetBaseTable[rootid]
            local iRootRank = rootdata and rootdata.Rank or 1
            -- TODO优化GetUpgrade
            local iLimitLevel = self:GetUpgrade(1,iRootRank) or 10
            if rootdata and rootdata.level >= 5 and iLevel < iLimitLevel then 
                local petexcel = TB_Pet[cardid]
                if petexcel then 
                    local ineed_jinjie = 0
                    if petexcel and petexcel.cardItem2 and petexcel.cardItem2 ~= 0 then 
                        local unlock_base = math.max( iLevel,5 )
                        ineed_jinjie = self:GetGradeNeedPiece(math.min(iLevel +1,PET_CARD_MAX_LV),true,true)
                    end
                    if iLevel < 6 and not carddata.unlock then 
                        iNeed = 0 
                    end 
                    if ineed_jinjie <= carddata.piece and carddata.unlock and iNeed <= carddata.root_piece then 
                        if iLevel < PET_CARD_MAX_LV then 
                            return true
                        end 
                    end 
                end
            end
        end
    end 
end

function CardsUpgradeDataManager:CheckRoleCardsExsUpGrade()
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    for i,carddata in pairs(self.roleIdCardListMap) do 
        local iLevel = carddata.level or 0
        local iNeed  = self:GetGradeNeedPiece(math.min(iLevel +1,ROLE_CARD_MAX_LV)) or 0
        local iPiece = carddata.piece or 0
        if iLevel < ROLE_CARD_MAX_LV and iPiece > 0 and iPiece >= iNeed then 
            return true 
        end 
    end 
end
------------------------------- 羁绊相关-------------------------------------
-----------------------------------------------------------------------------
function CardsUpgradeDataManager:UpdateBondCanLVUP()
    if not QuerySystemIsOpen(SGLST_RELATION_BOND) then 
        return false 
    end 
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    if self.bondinited then 
        self.map_BondCanlvUP = self.map_BondCanlvUP or {}
        local new_map = {}
        local RoleCardBondTB = TableDataManager:GetInstance():GetTable("RoleCardBond")
        local iCurPellet = PlayerSetDataManager:GetInstance():GetBondPellet() or 0
        -- 可增量遍历
        for i,Bond in pairs(RoleCardBondTB) do 
            local bcanup = true
            local iBaseID = Bond.BaseID
            local ilevel = self:GetBondCardLevelByID(iBaseID)   
            ilevelNext = math.min(ilevel +1,BOND_CARD_MAX_LV) 
            local BondLevelData = TableDataManager:GetInstance():GetTableData("BondLevel", ilevelNext) or {}

            if Bond and Bond.BondRole then 
                for index, roleBaseID in ipairs(Bond.BondRole) do 
                    local iCurLv = self:GetRoleCardLevelByRoleBaseID(roleBaseID)
                    if iCurLv < ilevelNext then 
                        bcanup = false
                        break
                    end
                end
            else
                bcanup = false
            end 
            if bcanup then 
                local iPelletNeed = Bond.Consume or 0 
                iPelletNeed = iPelletNeed * (BondLevelData.ConsumeScale or 0)  / 10000
                if iCurPellet >= iPelletNeed then 
                    new_map[iBaseID] = true 
                end
            end 
        end 
        self.map_BondCanlvUP = new_map
    end 
    
end
function CardsUpgradeDataManager:GetBondCanLVUPByBaseID(iBaseID)
    return self.map_BondCanlvUP and self.map_BondCanlvUP[iBaseID] or false
end 
function CardsUpgradeDataManager:GetBondCanLVUPByRoleID(iRoleTypeID)
    if self.map_BondCanlvUP then 
        for iBondID,bf in pairs(self.map_BondCanlvUP) do 
            local bonddata = TableDataManager:GetInstance():GetTableData("RoleCardBond", iBondID)
            
            if bonddata and bonddata.BondRole then 
                for j,roleID in pairs(bonddata.BondRole) do 
                    if roleID == iRoleTypeID then 
                        return true 
                    end 
                end 
            end 
        end 
    end 
    return false
end 
-- 刷新羁绊加成属性的map表
function CardsUpgradeDataManager:UpdateBondInfluenceMap()
    -- typeid - > { attr : num, ... }
    -- ['ALL'] -> { attr : num, ... }
    if not self.bondinited then 
        return 
    end 
    self.Map_BondInfluence = {}
    self.Map_BondInfluence['ALL'] = {}
    local RoleCardBondTB = TableDataManager:GetInstance():GetTable("RoleCardBond")
    local func_add = function(key1,key2_attr,iNum,ilevel)
        if not key1 or not key2_attr or not iNum or not ilevel or iNum == 0 or key2_attr == 0 or ilevel == 0 then 
            return 
        end 
        local iAddNum = iNum * (self.Bond_AttrGrow_MAP and self.Bond_AttrGrow_MAP[ilevel] or 0)
        self.Map_BondInfluence[key1] = self.Map_BondInfluence[key1] or {}
        self.Map_BondInfluence[key1][key2_attr] = self.Map_BondInfluence[key1][key2_attr] or 0
        self.Map_BondInfluence[key1][key2_attr] = self.Map_BondInfluence[key1][key2_attr] + iAddNum
    end
    for iBaseid,Bond in pairs(RoleCardBondTB) do 
        local ilevel = self:GetBondCardLevelByID(iBaseid)
        if ilevel > 0 and Bond then 
            func_add('ALL',Bond.AllAttr,Bond.AllAttrValue,ilevel)
            if Bond.BondRole then 
                for index,roleid in ipairs(Bond.BondRole) do 
                    func_add(roleid,Bond.BondAttr,Bond.BondAttrValue,ilevel)
                end
            end 
        end 
    end
end 
-- 靠角色id来获取羁绊加成属性的map表
function CardsUpgradeDataManager:GetBondInfluenceMapByRoleTypeID(iRoleTypeID)
    if not self.Map_BondInfluence then 
        self:UpdateBondInfluenceMap()
    end 
    local map_ret = {}
    if not self.Map_BondInfluence or not iRoleTypeID  then 
        return map_ret
    end 
    if self.Map_BondInfluence['ALL'] then 
        for iattr,iNum in pairs(self.Map_BondInfluence['ALL']) do 
            if not map_ret[iattr] then 
                map_ret[iattr] = 0 
            end 
            map_ret[iattr] = map_ret[iattr] + iNum
        end 
    end
    if self.Map_BondInfluence[iRoleTypeID] then 
        for iattr,iNum in pairs(self.Map_BondInfluence[iRoleTypeID]) do 
            if not map_ret[iattr] then 
                map_ret[iattr] = 0 
            end 
            map_ret[iattr] = map_ret[iattr] + iNum
        end 
    end
    return map_ret
end 
-- 
function CardsUpgradeDataManager:CheckBondCanLVUP()
    if not QuerySystemIsOpen(SGLST_RELATION_BOND) then 
        return false 
    end 
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    if self.bBondCanLVUP == nil then 
        self:UpdateBondCanLVUP()
    end 
    
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function CardsUpgradeDataManager:GetEntireRoleCardList()
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    return self.roleIdCardListMap or {}
end
function CardsUpgradeDataManager:GetEntirePetCardList()
    if not self.akPetBaseTable then 
        self:InitCardList()
    end
    return self.akPetBaseTable or {}
end
-- 凭星级卡的id获取角色卡
function CardsUpgradeDataManager:GetRoleCardDataByCardID(iBaseID)

end

-- 凭角色的id获取角色卡列表
function CardsUpgradeDataManager:GetRoleCardDataByRoleBaseID(roleBaseID, defaultNil)
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    if not roleBaseID then 
        if defaultNil then 
            return nil
        end
        return {} 
    end 
    if self.roleIdCardListMap[roleBaseID] == nil and defaultNil then 
        return nil
    end
    return self.roleIdCardListMap[roleBaseID] or {}
end

function CardsUpgradeDataManager:IsRoleCardUnlock(roleBaseID)
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    
    if roleBaseID == nil then
        return false
    end

    local instRoleData = self.roleIdCardListMap[roleBaseID]
    if instRoleData == nil then 
        return false
    end

    return instRoleData.unlock 
end

function CardsUpgradeDataManager:GetRoleCardUnLockNum()
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end

    local num = 0
    for _, instCard in pairs(self.roleIdCardListMap) do
        if instCard and instCard.unlock then
            num = num + 1
        end
    end

    return num
end

-- 凭typeid 获取角色卡等级
function CardsUpgradeDataManager:GetRoleCardLevelByRoleBaseID(roleBaseID)
    if not self.roleIdCardListMap then 
        self:InitCardList()
    end
    if not roleBaseID then return 0 end 
    local rolecarddata = self.roleIdCardListMap[roleBaseID] or {}
    return  rolecarddata.level or 0
end

-- 凭角色的id获取额外好感度加成
function CardsUpgradeDataManager:GetRoleExFavorByRoleID(roleBaseID)
    local igrade = self:GetRoleCardLevelByRoleBaseID(roleBaseID)
    return self:GetCurEffctStateByRoleID(roleBaseID, RoleCardEffect.RCE_Disposition, igrade)
end

-- 凭角色的id获取品质叠加等级
function CardsUpgradeDataManager:GetRoleExRankByRoleID(roleBaseID)
    local igrade = self:GetRoleCardLevelByRoleBaseID(roleBaseID)
    return self:GetCurEffctStateByRoleID(roleBaseID, RoleCardEffect.RCE_RoleQualityUp, igrade)
end
-- 凭角色的id,品级 获取当前类型的状态
function CardsUpgradeDataManager:GetCurEffctStateByRoleID(roleBaseID,enum,igrade)
    if not self.akRoleCardList_Grade2Effects then 
        self:InitCardList()
    end 
    if not self.akRoleCardList_Grade2Effects then 
        return 0 
    end 
    local _akmap_grade = self.akRoleCardList_Grade2Effects[roleBaseID]
    if not _akmap_grade then 
        return 0 
    end 
    igrade = igrade or 0
    local _akmap = _akmap_grade[igrade]
    if not _akmap then 
        return 0 
    end 
    enum = enum or RoleCardEffect.RCE_NULL
    return _akmap[enum] or 0
end
function CardsUpgradeDataManager:GetGradeNeedPiece(iGrade,ifPet,ifjinjie)
    
    if iGrade == nil or iGrade < 0 or iGrade > 10 then 
        iGrade = iGrade or 0 
        iGrade = math.max(iGrade,0)
        iGrade = math.min(iGrade,10)
    end
    if ifPet then 
        local TB_PetLevel = TableDataManager:GetInstance():GetTable("PetLevel")
        if ifjinjie then
            return TB_PetLevel and TB_PetLevel[iGrade] and TB_PetLevel[iGrade].Fragment2 or 100
        else 
            return TB_PetLevel and TB_PetLevel[iGrade] and TB_PetLevel[iGrade].Fragment or 100
        end
    else
        local TB_RolePiece = TableDataManager:GetInstance():GetTable("RolePiece")
        return TB_RolePiece and TB_RolePiece[iGrade] and TB_RolePiece[iGrade].Piece or 100
    end 
end 
function CardsUpgradeDataManager:GetGradeAddAttrPer(iGrade)
    if iGrade == nil or iGrade < 0 or iGrade > ROLE_CARD_MAX_LV then 
        iGrade = iGrade or 0 
        iGrade = math.max(iGrade,0)
        iGrade = math.min(iGrade,ROLE_CARD_MAX_LV)
    end
    if iGrade == nil or iGrade < 0 or iGrade > ROLE_CARD_MAX_LV then 
        iGrade = iGrade or 0 
        iGrade = math.max(iGrade,0)
        iGrade = math.min(iGrade,ROLE_CARD_MAX_LV)
    end
    local TB_RolePiece = TableDataManager:GetInstance():GetTable("RolePiece")
    local all = 0 
    for i,piece in ipairs(TB_RolePiece) do 
        if piece.Level <= iGrade then 
            all = all + (piece.AttrAdd or 0)
        end
    end 
    local info = GetTableData("RolePiece",iGrade)
    if info then 
        return info.AttrAdd / 10000
    end
    return 0
end 
function CardsUpgradeDataManager:GetCardInstData(enumCardType,iCardID)
end 

function CardsUpgradeDataManager:GetBondCardLevelByID(iBondID)
    if not self.akRoleCardList_Grade2Effects then 
        self:InitCardList()
    end
    return self.akBondBaseTable[iBondID] and self.akBondBaseTable[iBondID].uiLevel or 0
end
function CardsUpgradeDataManager:GetIfBondStoryFinishByID(iBondID)
    if not self.akRoleCardList_Grade2Effects then 
        self:InitCardList()
    end
    return (self.akBondBaseTable[iBondID] and self.akBondBaseTable[iBondID].uiCardNum or 0) ~= 0
end

-- 传入角色id 观察角色卡信息
function CardsUpgradeDataManager:DisplayRoleCardInfoObserve(roleID)
    OpenWindowImmediately('RoleCardsUpgradeUI')
    local RoleCardsUpgradeUI = WindowsManager:GetInstance():GetUIWindow("RoleCardsUpgradeUI")
    if RoleCardsUpgradeUI then
        RoleCardsUpgradeUI:SetObTarGet(roleID)
    end
end

-- 
function CardsUpgradeDataManager:GetPetCardDesc(iBaseID,iLevel,bfit)
    local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
    iBaseID = iBaseID or 0
    iLevel = iLevel or 0
    ExcelInfo =  TB_Pet and TB_Pet[iBaseID]
    if bfit == nil then bfit = true end 
    if not ExcelInfo then return {} end 
    local icur_grade = iLevel
    local iNext_grade = math.min(icur_grade + 1,PET_CARD_MAX_LV)
    local ret_desc = {}

    local funcGetAttrNum =  function( eAttr,iNum )
        if not eAttr or not iNum then 
            return 0 
        end 
        local bIsPerMyriad, bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(eAttr)

        if bShowAsPercent then
            return string.format( "%s%%",iNum / 100)
        else
            return string.format( "%s",iNum)
        end
    end
    for i=1,4 do 
        local str_Attr = 'Attr' .. i 
        local str_AttrLevel = 'Attr' .. i .. 'Level'
        local str_AttrValue1 = 'Attr' .. i .. 'Value1'	
        local str_AttrValue2 = 'Attr' .. i .. 'Value2'	
        local str_AttrInit = 'Attr' .. i .. 'Init'	
        local str_AttrGrow = 'Attr' .. i .. 'Grow'
        local boolLock = false
        local boolup = false
        local boolnum = false

        local int_Attr = ExcelInfo[str_Attr] or 0
        local int_AttrLevel = ExcelInfo[str_AttrLevel] or 0
        local int_AttrValue1 = ExcelInfo[str_AttrValue1] or 0
        local int_AttrValue2 = ExcelInfo[str_AttrValue2] or 0
        local int_AttrInit = ExcelInfo[str_AttrInit] or 0
        local int_AttrGrow = ExcelInfo[str_AttrGrow] or 0

        local igrade_a = math.max( icur_grade,int_AttrLevel )
        local igrade_b = math.max( iNext_grade,int_AttrLevel )

        local int_cur_all = int_AttrInit + int_AttrGrow * (igrade_a - int_AttrLevel)
        local int_next_all = int_AttrInit + int_AttrGrow * (igrade_b - int_AttrLevel)

        local str_base
        if int_Attr == PetAttrType.PAT_ATTR1 then 
            str_base = string.format( "我方上阵角色%s+%s",GetLanguageByEnum(int_AttrValue1) ,funcGetAttrNum(int_AttrValue1,int_cur_all))
            int_next_all = funcGetAttrNum(int_AttrValue1,int_next_all)
        elseif int_Attr == PetAttrType.PAT_ATTR2 then 
            local clanname = ClanDataManager:GetInstance():GetClanNameByBaseID(int_AttrValue1)
            str_base = string.format( "我方角色使用%s武学%s+%s",clanname,GetLanguageByEnum(int_AttrValue2),funcGetAttrNum(int_AttrValue2,int_cur_all))
            int_next_all = funcGetAttrNum(int_AttrValue2,int_next_all)

        elseif int_Attr == PetAttrType.PAT_ATTR3 then 
            local buffname = '';
            for k, v in pairs(PetBuffType_Revert) do
                if int_AttrValue2 == v then
                    buffname = k;
                    break;
                end
            end
            str_base = string.format( "我方攻击时，%s%%的概率附加%s%s层",int_AttrValue1 /100,buffname,int_cur_all)
        elseif int_Attr == PetAttrType.PAT_ATTR4 then 
            local strlang = GetLanguageByEnum(int_AttrValue2)
            if strlang == '最终伤害减免百分比' then 
                strlang = '最终伤害减免'
            end  
            str_base = string.format( "我方角色受到%s攻击时%s%s",GetLanguageByID(DepartEnumType_Lang[int_AttrValue1]),strlang,funcGetAttrNum(int_AttrValue2,int_cur_all)) 
            
            int_next_all = funcGetAttrNum(int_AttrValue2,int_next_all)
        elseif int_Attr == PetAttrType.PAT_ADDROLEEXP then 
            str_base = string.format( "战斗结束后，经验奖励增加%s%%",int_cur_all) 
        elseif int_Attr == PetAttrType.PAT_ADDMARTIALEXP then 
            str_base = string.format( "战斗结束后，武学经验奖励增加%s%%",int_cur_all) 
        elseif int_Attr == PetAttrType.PAT_ADDGOLD then 
            str_base = string.format( "战斗结束后，额外获得%s铜币",int_cur_all) 
        elseif int_Attr == PetAttrType.PAT_ADDGOODBUFF then 
            local buffname = '';
            for k, v in pairs(PetBuffType_Revert) do
                if int_AttrValue2 == v then
                    buffname = k;
                    break;
                end
            end
            str_base = string.format( "我方攻击时，%s%%概率为行动角色附加%s%s层",int_AttrValue1 /100,buffname,int_cur_all)
        elseif int_Attr == PetAttrType.PAT_RECOVERYHP then 
            str_base = string.format( "我方攻击时，%s%%概率对目标额外造成%s点伤害",int_AttrValue1 /100,int_cur_all)
        elseif int_Attr == PetAttrType.PAT_USESKILL then 
            str_base = string.format( "我方攻击时，%s%%概率为行动角色恢复%s点生命",int_AttrValue1 /100,int_cur_all)
        end  

        if int_AttrLevel > iNext_grade then 
            boolup = false 
            boolnum = true
            boolLock = true 
            int_next_all = '+'..int_AttrLevel..'解锁'
        elseif int_AttrLevel == iNext_grade then  
            if bfit then 
                boolup = true 
                boolnum = true
                boolLock = true 
                int_next_all = '解锁'
            else 
                boolup = false 
                boolnum = true
                boolLock = true 
                int_next_all = '+'..int_AttrLevel..'解锁'
            end 
        elseif bfit then 
            boolup = true 
            boolnum = true
            boolLock = false 
        else 
            boolup = false 
            boolnum = false
            boolLock = false 
        end 
            
        if str_base then 
            ret_desc[#ret_desc+1] = {
                basedesc = str_base,
                nextNum = int_next_all,
                lock = boolLock,
                up = boolup,
                num = boolnum,
            }
        end
    end 
    return ret_desc
end
-- 凭宠物的id获取宠物卡列表
function CardsUpgradeDataManager:GetPetCardDataByPetID(iBaseID)
    if not self.akPetBaseTable then 
        self:InitCardList()
    end
    return self.akPetBaseTable[iBaseID]
end

-- 凭宠物的id获取宠物卡列表
function CardsUpgradeDataManager:GetPetLevel(iBaseID)
    local info = self:GetPetCardDataByPetID(iBaseID)
    if info then
        return info.level
    end
    return 0
end
-- 
function CardsUpgradeDataManager:GetPets(bTableLua2C)
    if not self.akPetBaseTable then 
        self:InitCardList()
    end
    local _ret = {}
    for cardid,carddata in pairs(self.akPetBaseTable) do 
        if carddata.ifchose and (carddata.piece > 0 or carddata.level > 0) then 
            local tempT = {
                uiBaseID = carddata.card.BaseID,
                uiFragment = carddata.level,
                uiRootID = carddata.rootid,
            }
            table.insert(_ret,tempT)
        end
    end 
    return bTableLua2C == true and table_lua2c(_ret) or _ret;
end

--
local Type = {
    Pet = 1,
    Role = 2,
}
function CardsUpgradeDataManager:GetUpgrade(type, rank)
    local tbSysOpenData = {};
    if type == Type.Pet then
        tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_PetCard);
    elseif type == Type.Role then
        tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_RoleCard);
    end

    local get_cur_grade = function(rank)
        local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
        local tempTable = {};
        for i = 1, #(tbSysOpenData) do
            if tbSysOpenData[i].OpenTime <= time then
                table.insert(tempTable, tbSysOpenData[i]);
            end
        end
    
        if #(tempTable) == 0 then
            return 5;    
        end
    
        local tempGrage = 5;
        for i = 1, #(tempTable) do
            if tempTable[i].Param1 > 0 and tempTable[i].Param2 > 0 then
                if tempTable[i].Param1 == rank then
                    tempGrage = tempTable[i].Param2;
                end
            end
        end

        return tempGrage;
    end

    -- 毁天灭地最高支持5级
    local get_cur_grade_scriptlimit = function()
      if (PlayerSetDataManager:GetInstance():IsUnlockStory(8))then
        return 5;
      end

      return 20;
    end

    -- TODO
    local lvMin = get_cur_grade_scriptlimit();
    return math.min(lvMin, get_cur_grade(rank));
end

return CardsUpgradeDataManager;
