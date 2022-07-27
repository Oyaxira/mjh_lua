RoleDataHelper = {}

local FavorString = {
    [FavorType.FT_Null] = "",
    [FavorType.FT_Game] = "游戏",
    [FavorType.FT_Paint] = "书画",
    [FavorType.FT_Wine] = "酒类",
    [FavorType.FT_Flower] = "花卉",
    [FavorType.FT_LivingItem] = "生活道具",
    [FavorType.FT_Food] = "美食",
    [FavorType.FT_Weapon] = "武器",
    [FavorType.FT_Martial] = "武学",
    [FavorType.FT_Jewelry] = "饰品",
    [FavorType.FT_Cloth] = "服装",
    [FavorType.FT_Cooking] = "烹饪材料",
    [FavorType.FT_Medicinal] = "药材",
    [FavorType.FT_Ore] = "矿石",
    [FavorType.FT_Maquillage] = "化妆品",
    [FavorType.FT_Rubbish] = "垃圾",
    [FavorType.FT_Music] = "音律",
    [FavorType.FT_FavorNull] = "无",
    [FavorType.FT_Compare] = "切磋",
}

RoleAttrTypeMap = {
    ['HP'] = AttrType.ATTR_MAXHP,
    ['MP'] = AttrType.ATTR_MAXMP,

    ['Strength'] = AttrType.ATTR_LIDAO,
    ['Agility'] = AttrType.ATTR_LINGQIAO,
    ['Energy'] = AttrType.ATTR_JINGLI,
    ['Constitution'] = AttrType.ATTR_TIZHI,
    ['Comprehension'] = AttrType.ATTR_WUXING,
    ['Power'] = AttrType.ATTR_NEIJIN,

    ['SwordMastery'] = AttrType.ATTR_JIANFAJINGTONG,
    ['KnifeMastery'] = AttrType.ATTR_DAOFAJINGTONG,
    ['FistMastery'] = AttrType.ATTR_QUANZHANGJINGTONG,
    ['LegMastery'] = AttrType.ATTR_TUIFAJINGTONG,
    ['StickMastery'] = AttrType.ATTR_QIMENJINGTONG,
    ['NeedleMastery'] = AttrType.ATTR_ANQIJINGTONG,
    ['HealingMastery'] = AttrType.ATTR_YISHUJINGTONG,
    ['SoulMastery'] = AttrType.ATTR_NEIGONGJINGTONG,
    ['Crits'] = AttrType.ATTR_CRITATK,
    ['Hits'] = AttrType.ATTR_HITATK,
    ['Continu'] = AttrType.ATTR_CONTINUATK,
    ['YangXing'] = AttrType.ATTR_NEILIYANGXING,
    ['YinXing'] = AttrType.ATTR_NEILIYINXING,
    ['Defense'] = AttrType.ATTR_DEF,
    ['MartialATK'] = AttrType.ATTR_MARTIAL_ATK,
    ['Speed'] = AttrType.ATTR_SUDUZHI,
    ['ActionInterval'] = AttrType.ATTR_XINGDONGJIANGE,
    ["baoshang"]   = AttrType.ATTR_BAOSHANGZHI,
    ["lianzhaolv"] =AttrType.ATTR_LIANZHAOLV,
    ["ignoreDefense"] =AttrType.ATTR_IGNOREDEFPER,
    ["hejilv"] = AttrType.ATTR_HEJILV,
    ["shanbi"] = AttrType.ATTR_SHANBI,AttrType.ATTR_BAOJIDIKANGZHI,
    ["baojidikang"] = AttrType.ATTR_BAOJIDIKANGZHI,
    ["kanglianji"] = AttrType.ATTR_KANGLIANJI,
    ["fanji"] = AttrType.ATTR_FANJIZHI,
    ["pozhao"] = AttrType.ATTR_POZHAOVALUE,
    ["fantan"] = AttrType.ATTR_FANTANVALUE,
    ["roundMP"] = AttrType.ATTR_ROUNDMP,
    ["fangyutishenglv"] = AttrType.ATTR_FANGYUTISHENGLV,
    ["suckHP"] = AttrType.ATTR_SUCKHP,
    ["zhiliaoxiaoguo"] = AttrType.ATTR_ZHILIAOXIAOGUO,
    ["fantanbeishu"] = AttrType.ATTR_FANTANBEISHU,
    ["zhongdukangxing"] = AttrType.ATTR_ZHONGDUKANGXING,
    ["liuxuekangxing"] =AttrType.ATTR_LIUXUEKANGXING,
    ["pojiakangxing"] = AttrType.ATTR_POJIAKANGXING,
    ["jiansukangxing"] = AttrType.ATTR_JIANSUKANGXING,
    ["neishangkangxing"] = AttrType.ATTR_NEISHANGKANGXING,
    ["canfeikangxing"] = AttrType.ATTR_CANFEIKANGXING,
    ["ATTR_MAXHP"] = AttrType.ATTR_MAXHP,
    ["ATTR_MAXMP"] = AttrType.ATTR_MAXMP,
    ["ATTR_MARTIAL_ATK"] = AttrType.ATTR_MARTIAL_ATK,
}

RoleAttrTypeMapRevert = {
    [AttrType.ATTR_JIANFAJINGTONG] = 'SwordMastery',
    [AttrType.ATTR_DAOFAJINGTONG] = 'KnifeMastery',
    [AttrType.ATTR_QUANZHANGJINGTONG] = 'FistMastery',
    [AttrType.ATTR_TUIFAJINGTONG] = 'LegMastery',
    [AttrType.ATTR_QIMENJINGTONG] = 'StickMastery',
    [AttrType.ATTR_ANQIJINGTONG] = 'NeedleMastery',
    [AttrType.ATTR_YISHUJINGTONG] = 'HealingMastery',
    [AttrType.ATTR_NEIGONGJINGTONG] = 'SoulMastery',
}

FAMILY_NAME_POOL = {"赵","钱","孙","李","欧阳","慕容","上官","陈","林","沙","周","吴","金","郑","段","木","萧","顾","钟","何","王","贾","叶","铁","柴","郁","张","云","成","方","卜","孟","皇甫","于","沐","茅","蒋","牛","马","宫","凌","司徒","吕","班","阳","韦","左","华","毕","潘","崔","公","公孙","梁","祝","安","秦","步","汤","万","厉"}
FIRST_NAME_POOL = {
    [1] = {"承君","继林","玉龙","宏厚","华荣","丹林","擎天","博文","子昂","作人","古云","光和","和玉","中辉","嘉德","鹏宣","梁宇","曾琪","国兴","雅畅","坚成","伟志","鸿轩","建业","文敏","和硕","兴运","子濯","乐心","学博","悦","修能","理全","光济","光誉","德运","子杰","俊彼","博远","语堂","普存","嘉誉","宏俊","浩博","康安","其乐","俊逸","阳冰","翰飞","宏朗","俊贤","子明","高芬","浩歌","宏伯","安邦","和风","嘉胜","文瑞","乃亮","之罗","民","彪","奉","怀","安","建","笙","丰","斯","伯","水","晨","城","根","三","克","岩","南","山","坊","达","杭","天","中","朋","本","泉","顺","原","兰","力","诸","储","亨","汇","虹","宝","化","傅","壮","治","新","前","宫","巴","盼","池","乐","沁","含","茗","虎","胜","云","海","涛","誉","庆","峰","甲",},
    [2] = {"秀婉","青曼","含易","觅露","心慈","柔","端雅","玲然","灵波","顾菱","晓槐","清莹","芳蕙","叶春","语琦","香雪","萧玉","望慕","青香","欣诺","流逸","谷冬","柔谨","碧函","采文","海瑛","莘莘","幻珊","含桃","凝然","以晴","叶芳","歌韵","静琪","和美","绿旋","小玉","诗婷","冰安","蝶梦","向雁","静宜","听露","盼曼","沛儿","瑰玮","冬菱","音景","忆敏","丁辰","莉莉","侬绮","心语","丹","娅","融","菊","婉","蓓","婷","夏","晓","碧","友","银","冷","慕","玉","雪","苹","烟","惠","凡","舒","筠","翠","山","露","含","育","傲","之","清","兰","红","枫","漪","茗","思","燕","芝","彤","芷","亚","炅","瑾","从","娇","曼",},
}

RoleDataHelper.GetFavorName = function(enumFavor)
    return FavorString[enumFavor] or '';
end

RoleDataHelper.GetName = function(roleData, dbRoleData)
    if not roleData or not dbRoleData then
        return "error"
    end

    -- 直接客户端随机的名字
    if roleData.sName ~= nil and roleData.sName ~= "" then
        return roleData.sName
    end

    local roleID = roleData.uiID
    local string_name
    local TitleID = 0

    if roleData.roleType == ROLE_TYPE.BATTLE_ROLE then
        -- Unit:GetName() 移过来的
        if roleData.uiFamilyNameID and roleData.uiFirstNameID and roleData.uiFamilyNameID ~= 0 and roleData.uiFirstNameID ~= 0 then
            return GetLanguageByID(roleData.uiFamilyNameID)..GetLanguageByID(roleData.uiFirstNameID)
        end
    
        if roleData.uiNameID == 0 or roleData.uiNameID == nil then
            return RoleDataManager:GetInstance():GetRoleTitleAndName(roleData.uiTypeID, true)
        end
    
        if BattleName_Revert[roleData.uiNameID] then 
                return BattleName_Revert[roleData.uiNameID]
        elseif GetLanguageByID(roleData.uiNameID) ~= nil and GetLanguageByID(roleData.uiNameID) ~= "" then
            return GetLanguageByID(roleData.uiNameID)
        elseif roleData.uiTypeID then
            return RoleDataManager:GetInstance():GetRoleTitleAndName(roleData.uiTypeID, true)
        end
    
        return RoleDataManager:GetInstance():GetRoleTitleAndName(roleData.uiTypeID, true)
    end


    if not string_name then
        string_name = RoleDataManager:GetInstance():GetRoleName(roleID)
    end


    if roleData.roleType == ROLE_TYPE.INST_ROLE then
        if roleData.uiTitleID and roleData.uiTitleID > 0 then
            TitleID = roleData.uiTitleID
        end
    else
        local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_TITLE)
        if BeEvolution then
            TitleID = BeEvolution.iParam1
        elseif roleData.uiTypeID then
            local dbdata = TB_Role[roleData.uiTypeID]
            if dbdata then
                TitleID = dbdata.TitleID
            end
        end
    end

    if TitleID > 0 then
        local roleTitleData = TableDataManager:GetInstance():GetTableData("RoleTitle",TitleID)
        if roleTitleData and roleTitleData.TitleID then
            local string_title = GetLanguageByID(roleTitleData.TitleID) or ""
            if string_title ~= "" then
                return string_title .. '.' .. string_name
            end
        end
    end
   
    return string_name
end

RoleDataHelper.getRandomPersonNameBySex = function(enumsex_sex)
	if enumsex_sex ~= 1 and enumsex_sex ~= 2 then
		enumsex_sex =math.random(1,2)
	end
	local _string_firstName = FAMILY_NAME_POOL
	local _string_SecondName = FIRST_NAME_POOL[enumsex_sex]
  return _string_firstName[math.random(1,#_string_firstName)] .. _string_SecondName[math.random(1,#_string_SecondName)]
end

RoleDataHelper.GetNameByID = function(uiRoleID)
    return RoleDataManager:GetInstance():GetRoleName(uiRoleID)
end

RoleDataHelper.GetNpcItemNum = function(roleData, dbRoleData, uiItemTypeID)
    if not roleData or not dbRoleData then
        return 0
    end
    local numout = 0
    if roleData.roleType == ROLE_TYPE.NPC_ROLE then
        if roleData.GetItemNum then
            numout = roleData:GetItemNum(uiItemTypeID)
        end
    end

    return numout
end

	-- //// 角色装备物品位置
	-- //enum RoleEquipItemPos
	-- //{
	--    // REI_NULL,                              //无效位
	--    // REI_WEAPON,                            //武器
	--    // REI_CLOTH,                             //衣服
	--    // REI_JEWELRY,                           //饰品
	--    // REI_WING,                              //翅膀
	--    // REI_THRONE,                            //神器
	--    // REI_SHOE,                              //鞋子
	--    // REI_RAREBOOK,                          //秘籍
	--    // REI_HORSE,                             //坐骑
	--    // REI_ANQI,                              //暗器
	--    // REI_MEDICAL,                           //医术
	--    // REI_NUMS,                              //数量
	-- //};
RoleDataHelper.GetDrawing = function(dbRoleData)
    if not dbRoleData then
        return
    end
    local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(dbRoleData.RoleID)
    if artData then
        return artData.Drawing
    end

    return nil

    -- if dbRoleData.ArtID and dbRoleData.ArtID > 0 then
    --     local _RoleModel = TableDataManager:GetInstance():GetTableData("RoleModel", dbRoleData.ArtID)
    --     if _RoleModel then
    --         return _RoleModel.Drawing;
    --     end
    --     return nil;
    -- end
end

RoleDataHelper.GetEvolutionsByType = function(roleData, eType)
    return EvolutionDataManager:GetInstance():GetEvolutionsByType(roleData.uiID, eType)
end

RoleDataHelper.GetRoleLv = function(roleData, dbRoleData)
    return roleData:GetLevel()
end

RoleDataHelper.GetRoleClan = function(roleData, dbRoleData)
    if not roleData then
        return nil
    end

    if roleData.GetClan then
        return roleData:GetClan()
    elseif dbRoleData then
        return dbRoleData.Clan
    end
end

RoleDataHelper.GetRank = function(roleData)
    if roleData.uiRank ~= nil then
        return roleData.uiRank
    end
        local dbRoleData = TB_Role[roleData.BaseID]
    return dbRoleData.Rank
end


RoleDataHelper.CheckDoorKeeper = function(uiRoleID)
    local aEvos = EvolutionDataManager:GetInstance():GetEvolutionsByType(uiRoleID, NET_DOORKEEPER)
    if aEvos then
        return aEvos[0]
    end
end

RoleDataHelper.CheckSubMaster = function(uiRoleID, bNotMainRoleClan)
    local aEvos = EvolutionDataManager:GetInstance():GetEvolutionsByType(uiRoleID, NET_SUBMASTER)
    if aEvos and aEvos[0] then
        local clanBaseID = aEvos[0].iParam1
        local mainRoleClanTypeID = RoleDataManager:GetInstance():GetMainRoleClanTypeID()

        if not bNotMainRoleClan or clanBaseID ~= mainRoleClanTypeID then
            return aEvos[0]
        end
    end
end

RoleDataHelper.CheckMainMaster = function(uiRoleID, bNotMainRoleClan)
    local aEvos = EvolutionDataManager:GetInstance():GetEvolutionsByType(uiRoleID, NET_MAINMASTER)
    if aEvos and aEvos[0] then
        local clanBaseID = aEvos[0].iParam1
        local mainRoleClanTypeID = RoleDataManager:GetInstance():GetMainRoleClanTypeID()

        if not bNotMainRoleClan or clanBaseID ~= mainRoleClanTypeID then
            return aEvos[0]
        end
    end
end

RoleDataHelper.CheckTempMainMaster = function(uiRoleID, bNotMainRoleClan)
    local aEvos = EvolutionDataManager:GetInstance():GetEvolutionsByType(uiRoleID, NET_TEMPMAINMASTER)
    if aEvos and aEvos[0] then
        local clanBaseID = aEvos[0].iParam1
        local mainRoleClanTypeID = RoleDataManager:GetInstance():GetMainRoleClanTypeID()

        if not bNotMainRoleClan or clanBaseID ~= mainRoleClanTypeID then
            return aEvos[0]
        end
    end
end

RoleDataHelper.CheckClanLetterMission = function(uiRoleID)
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiRoleID)
    if roleData == nil then 
        return
    end
    local dbRoleData = TB_Role[roleData.uiTypeID]
    local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE

    local clanmissions = ClanDataManager:GetInstance():GetAllClanMission()
    for clantypeid,v in pairs(clanmissions) do
        if v.iMissionType == ClanMissionType.CMT_SongXin then
            if v.uiReq == REQ_LV then
                local lv = RoleDataHelper.GetRoleLv(roleData, dbRoleData)
                if lv >= v.iParam0 then
                    return clantypeid
                end
            elseif v.uiReq == REQ_GOODEVIL then
                local value = RoleDataHelper.GetAttr(roleData, dbRoleData, "GoodEvil")
                if v.iParam0 > 0 and value >= v.iParam0 then
                    return clantypeid
                end
                if v.iParam0 < 0 and value <= v.iParam0 then
                    return clantypeid
                end
            elseif v.uiReq == REQ_CLAN then
                if dbRoleData.Clan == v.iParam0 then
                    return clantypeid
                end
            elseif v.uiReq == REQ_RANK then
                if dbRoleData.Rank >= v.iParam0 then
                    return clantypeid
                end
            elseif v.uiReq == REQ_FAVOR then
                local efavors = isNPC and dbRoleData.Favor or dbRoleData.Favor
                efavors = efavors or {}
                for i,v in ipairs(efavors) do
                    if v == v.iParam0 then
                        return clantypeid
                    end
                end
            end
        end
    end

end

RoleDataHelper.GetDispositionNameByValue = function(iValue)
    local name = ""
    if iValue <= -100 then
        name = '势同水火'
    elseif iValue <= -50 then
        name = '深恶痛绝'
    elseif iValue <= -20 then
        name = '厌恶不往'
    elseif iValue <= 0 then
        name = '视若无睹'
    elseif iValue < 10 then
        name = '一面之交'
    elseif iValue < 20 then
        name = '点头之交'
    elseif iValue < 40 then
        name = '泛泛之交'
    elseif iValue < 60 then
        name = '金石之交'
    elseif iValue <= 99 then
        name = '莫逆之交'
    else
        name = '刎颈之交'
    end

    return name
end

RoleDataHelper.GetDispositionDesByValue = function(iValue)
    local des = "一面之缘"
    if iValue < -80 then
        des = '将你视为不共戴天的仇人'
    elseif iValue < -60 then
        des = '对你恨之入骨'
    elseif iValue < -40 then
        des = '你真令人厌恶！'
    elseif iValue < -20 then
        des = '滚滚滚，别让我见到你！'
    elseif iValue < 0 then
        des = '彼此关系不是很好'
    elseif iValue < 20 then
        des = '一面之缘'
    elseif iValue < 40 then
        des = '较为熟悉的朋友'
    elseif iValue < 60 then
        des = '我与你真是一见如故'
    elseif iValue < 80 then
        des = '我与你真是相见恨晚呐！'
    elseif iValue <= 100 then
        des = '愿意为你做任何事！'
    else
        des = '好感超100,有异常'
    end

    return des
end

RoleDataHelper.GetAttr = function(roleData, dbRoleData, sAttr)
    if (not roleData) or (not dbRoleData) then
        return 0;
    end

    local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE
    local isBattleRole = roleData.roleType == ROLE_TYPE.BATTLE_ROLE
    local kData = TableDataManager:GetInstance():GetTableData("RoleAttr", dbRoleData.AttributeID)
    local arrtData = kData or {}
    
    local GetClanName = function()
        local dbClanData = TB_Clan[roleData:GetClan()];

        if not dbClanData then
            local data = TableDataManager:GetInstance():GetTableData("RoleClass",dbRoleData.ClanTemplate)
            if data then
                local clanID = data.ClanID;
                dbClanData = TB_Clan[clanID];
            end
            
            if not dbClanData then
                return "无";
            end
        end

        return GetLanguagePreset(dbClanData.NameID, tostring(dbClanData.NameID) )
	end

	local GetFavor = function()
        local faverString = ""
        local etemp = dbRoleData.Favor or {}
        local efavors = {}      -- 注意从 DB 里取出来的数据，不要修改
        table.move(etemp, 1, #etemp, 1, efavors)

        local evolution_list = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleData.uiID, NET_FAVORTYPE)
        if evolution_list and next(evolution_list) then
            dprint("正在使用动态喜好数据，静态喜好数据！", evolution_list, evolution_list[1], efavors)
            efavors = {}
            if evolution_list.iParam1 and evolution_list.iParam1 > 0 then
                table.insert( efavors, evolution_list.iParam1 )
            end
            if evolution_list.iParam2 and evolution_list.iParam2 > 0 then
                table.insert( efavors, evolution_list.iParam2 )
            end
            if evolution_list.iParam3 and evolution_list.iParam3 > 0 then
                table.insert( efavors, evolution_list.iParam3 )
            end
        end

		for i,v in ipairs(efavors) do
			faverString = faverString .. RoleDataHelper.GetFavorName(v) .. " "
		end
		return faverString
	end

    local GetLv = function()
		return roleData:GetLevel()
    end

    local GetGoodEvil = function()
        return roleData:GetGoodEvil()
    end
    
	local customRule = {	
		["Clan"] = GetClanName,
        ["Favor"] = GetFavor,
        ["Level"] = RoleDataHelper.GetRoleLv, 
        ["GoodEvil"] = GetGoodEvil,
    }
    
    local attrvalue
    local eAttr = RoleAttrTypeMap[sAttr]
    if customRule[sAttr] then
        attrvalue = customRule[sAttr](roleData, dbRoleData)
    else
        return roleData:GetAttr(sAttr)
    end

    return attrvalue or 0
end

RoleDataHelper.GetObserveAttr = function(roleData, dbRoleData, sAttr)
    if not roleData then
        return 0
    end

    local baseAttr = RoleDataHelper.GetAttr(roleData, dbRoleData, sAttr)
    if roleData.roleType ~= ROLE_TYPE.NPC_ROLE and roleData.roleType ~= ROLE_TYPE.HOUSE_ROLE then
        return baseAttr
    end

    local cardLevelAttrs = roleData:GetAttrByCardLevel();
    local martialAttrs = roleData:GetAttrByMartials();
    local fixGiftAttrs = roleData:GetFixAttrByGifts();
    local perGiftAttrs = roleData:GetPerAttrByGifts();
    local conGiftAttrs = roleData:GetConAttrByGifts();
    local equipAttrs = roleData:GetAttrByEquips();
    local titleAttrs = roleData:GetAttrByTitle();
    local meridiansAttrs = {};
    if roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
        meridiansAttrs = roleData:GetAttrByMeridians();
    end

    local cardLevelAttr = RoleDataHelper.GetAttrByType(cardLevelAttrs, sAttr);
    local martialAttr = RoleDataHelper.GetAttrByType(martialAttrs, sAttr);
    local equipAttr = RoleDataHelper.GetAttrByType(equipAttrs, sAttr);
    local titleAttr = RoleDataHelper.GetAttrByType(titleAttrs, sAttr);
    local fixGiftAttr = RoleDataHelper.GetAttrByType(fixGiftAttrs, sAttr);
    local perGiftAttr = RoleDataHelper.GetAttrByType(perGiftAttrs, sAttr);
    local conGiftAttr = RoleDataHelper.GetAttrByType(conGiftAttrs, sAttr);
    local meridiansAttr = RoleDataHelper.GetAttrByType(meridiansAttrs, sAttr);

    local value = math.floor(baseAttr + cardLevelAttr + martialAttr + equipAttr + titleAttr + fixGiftAttr + perGiftAttr + conGiftAttr + meridiansAttr + 0.5)
    return value
end

local _getMartialForcePercent = function(eDepartType, eGrade, eAttrType, eRankType, bIsRoleAttr, bIsGrowup)

    if eGrade == Grade.GA_GradeNull then
		eGrade = Grade.GA_Medium;
	end

    -- 首先根据属性类型/武学系别,角色属性还是成长得出来一个ID
    bIsRoleAttr = bIsRoleAttr and 1 or 0;
    bIsGrowup = bIsGrowup and 1 or 0;
    local kungFuBase =MartialDataManager:GetInstance():GetKungfuBaseData(eAttrType, eDepartType, bIsRoleAttr, bIsGrowup);
    if not kungFuBase then
        return 0;
    end

	--
    local iValue = kungFuBase.RankDatas[eRankType] or 0;

    -- 这里再去获取档次
    local iGradeValue = 0;
	local TB_MatGrowUPAttrGrade = TableDataManager:GetInstance():GetTable("MatGrowUPAttrGrade");
    for i = 1, #(TB_MatGrowUPAttrGrade) do
        local rkGradeTable = TB_MatGrowUPAttrGrade[i];
		if rkGradeTable.Grade == eGrade then
			iGradeValue = bIsGrowup and rkGradeTable.GrowFactor or rkGradeTable.Factor;
            break;
        end
    end

    return (iGradeValue / 10000) * (iValue / 10000) * 10000;
end

local _filter = function(uiFilterID, uiMartialTypeID, uiSrcMartialTypeID, iValue, rkMartialAppend, eAttr, eRankType, eDepartType)
    
    local _AddAttr = function(isSelf)
        if eAttr == AttrType.ATTR_NULL then
            return;
        end

        if eAttr == AttrType.MP_WEILI then
            eAttr = AttrType.MP_WEILIXISHU;
        end

        local martialInfo = {
            uiAttrType = eAttr;
            uiMartialTypeID = uiSrcMartialTypeID;
            uiMartialValue = iValue;
            bSelf = isSelf;
            bInit = false;
        }

        if not rkMartialAppend[uiMartialTypeID] then
            rkMartialAppend[uiMartialTypeID] = {};
        end
        table.insert(rkMartialAppend[uiMartialTypeID], martialInfo);
    end

    -- 如果没填筛选,默认对本武学进行加成
    if uiFilterID == 0 then
		if uiMartialTypeID == uiSrcMartialTypeID then
			-- 1.本武学
			if eAttr == AttrType.MP_WEILI or eAttr == AttrType.MP_WEILIXISHU or eAttr == AttrType.ATTR_WEILIBAIFENBI then
				iValue = _getMartialForcePercent(1, iValue, eRankType, DepartEnumType.DET_DepartEnumTypeNull);
            end

			_AddAttr(true);
		end
        return (uiMartialTypeID == uiSrcMartialTypeID);
    end

	--
    local pkDstMartialRes = GetTableData("Martial", uiMartialTypeID);
    local pkSrcMartialRes = GetTableData("Martial", uiSrcMartialTypeID);
    if not pkDstMartialRes or not pkSrcMartialRes then
        return false;
    end

    --
    local pkMartialFilter = GetTableData("MartialFilter", uiFilterID);
    if not pkMartialFilter then
        return false;
    end

	--
	local uiFilterMartialTypeID = pkMartialFilter.MartialID;
	local uiFilterClanTypeID = pkMartialFilter.ClanID;
	local eFilterDepart = pkMartialFilter.MartialType;
	local eFilterRankType = pkMartialFilter.Rank;

	--
	if pkMartialFilter.AutoMartialType == TBoolean.BOOL_YES then
		eFilterDepart = pkSrcMartialRes.DepartEnum;
    end

    --
    local _DepartCompare = function()
        local kftype = GetTableData("Kftype", pkDstMartialRes.DepartEnum);
        if not kftype then
            return false;
        end
            
        if kftype.WaiGong and eFilterDepart == DepartEnumType.DET_ExternalWork then
            return true;
        else
            if kftype.NeiGong and eFilterDepart == DepartEnumType.DET_Soul then
                return true;
            elseif eFilterDepart == pkDstMartialRes.DepartEnum then
                return true;
            end
            return false;
        end
    end

	--
	if uiFilterMartialTypeID > 0 then
		if uiMartialTypeID == uiFilterMartialTypeID then
			-- 2.指定武学
			if eAttr == AttrType.MP_WEILI or eAttr == AttrType.MP_WEILIXISHU or eAttr == AttrType.ATTR_WEILIBAIFENBI then
				iValue = _getMartialForcePercent(2, iValue, eRankType, eFilterDepart);
            end

			_AddAttr(false);
		end
	else
		if uiFilterClanTypeID > 0 then
			if uiFilterClanTypeID == pkDstMartialRes.ClanID then
				-- 4.指定门派/指定门派的系别
				if eAttr == AttrType.MP_WEILI or eAttr == AttrType.MP_WEILIXISHU or eAttr == AttrType.ATTR_WEILIBAIFENBI then
					iValue = _getMartialForcePercent(4, iValue, eRankType, eFilterDepart);
                end

				if eFilterDepart > 0 then
					if _DepartCompare() then
						if eFilterRankType > 0 then
							if eFilterRankType == pkDstMartialRes.Rank then
								_AddAttr(false);
                            end
                        else
							_AddAttr(false);
                        end
                    end
				else
					if eFilterRankType > 0 then
						if eFilterRankType == pkDstMartialRes.Rank then
							_AddAttr(false);
                        end
                    else
						if uiFilterClanTypeID == pkDstMartialRes.ClanID then
							_AddAttr(false);
                        end
                    end
                end
            end
		else
			if eFilterDepart > 0 then
				if _DepartCompare() then
					-- 3.指定系别
					if eAttr == AttrType.MP_WEILI or eAttr == AttrType.MP_WEILIXISHU or eAttr == AttrType.ATTR_WEILIBAIFENBI then
						iValue = _getMartialForcePercent(3, iValue, eRankType, eFilterDepart);
                    end

					if eFilterRankType > 0 then
						if eFilterRankType == pkDstMartialRes.Rank then
							_AddAttr(false);
                        end
                    else
						_AddAttr(false);
                    end
				end
			else
				if eFilterRankType > 0 then
					if eFilterRankType == pkDstMartialRes.Rank then
						_AddAttr(false);
                    end
				else
					_AddAttr(false);
                end
			end
		end
	end

    -- 有特定武学的就返回是否id相等
    if uiFilterMartialTypeID ~= 0 and uiFilterMartialTypeID ~= uiMartialTypeID then
        return false;
    end

    -- 判断门派
    if uiFilterClanTypeID ~= 0 and uiFilterClanTypeID ~= pkDstMartialRes.ClanID then
        return false;
    end

    -- 判断系别
	if eFilterDepart ~= DepartEnumType.DET_DepartEnumTypeNull and not _DepartCompare() then
        return false;
    end

    -- 判断品质
    if eFilterRankType ~= RankType.RT_RankTypeNull and eFilterRankType ~= pkDstMartialRes.Rank then
        return false;
    end

    return true;
end

local _func_GetAttrByMartialsHelper = function(type, item, martial, martialStruct, martialDescVec, martialInfo)
    local effectEnum = nil;
    local attrEnum = 1;
    local grade = nil;
    local skillID = nil;
    local effectValue = nil;
    local martialFilter = nil;
    local departType = martial.DepartEnum;
    local rankType = martial.Rank;

    if type == 1 then
        effectEnum = item.EffectEnum1;
        attrEnum = item.AttrEnum1;
        grade = item.Grade1;
        skillID = item.SkillID1;
        effectValue = item.Effect1Value;
        martialFilter = item.MartialFilter1;
    elseif type == 2 then
        effectEnum = item.EffectEnum2;
        attrEnum = item.AttrEnum2;
        grade = item.Grade2;
        skillID = item.SkillID2;
        effectValue = item.Effect2Value;
        martialFilter = item.MartialFilter2;
    end
    if skillID == nil then return end
    local iValue = 0;
    if effectValue and #(effectValue) > 0 then
        iValue = effectValue[1];
    end
    
    if effectEnum == MartialItemEffect.MTT_BEIDONGJINENG then
        for i = 1, #(martialDescVec) do
            local martialUnlockSkills = martialInfo.martialUnlockSkills;
            local uiMartialTypeID = martialDescVec[i].uiMartialTypeID;
            if _filter(martialFilter, martialDescVec[i].uiMartialTypeID, martialStruct.uiMartialTypeID, iValue, martialInfo.martialAppend, attrEnum, rankType, departType) then
                martialUnlockSkills[uiMartialTypeID] = martialUnlockSkills[uiMartialTypeID] or {};
                table.insert(martialUnlockSkills[uiMartialTypeID], skillID);
            end
        end

    elseif effectEnum == MartialItemEffect.MTT_JUESECHENGZHANG then
        local martialAttrs = martialInfo.martialAttrs;
        local uiMartialTypeID = martialStruct.uiMartialTypeID;
        martialAttrs[uiMartialTypeID] = martialAttrs[uiMartialTypeID] or {};
        martialAttrs[uiMartialTypeID][attrEnum] = martialAttrs[uiMartialTypeID][attrEnum] or 0;
        local value = martialAttrs[uiMartialTypeID][attrEnum];
        martialAttrs[uiMartialTypeID][attrEnum] = value + iValue * martialStruct.uiMartialLv;

    elseif effectEnum == MartialItemEffect.MTT_JUESESHUXING then
        local martialAttrs = martialInfo.martialAttrs;
        local uiMartialTypeID = martialStruct.uiMartialTypeID;
        martialAttrs[uiMartialTypeID] = martialAttrs[uiMartialTypeID] or {};
        martialAttrs[uiMartialTypeID][attrEnum] = martialAttrs[uiMartialTypeID][attrEnum] or 0;
        local value = martialAttrs[uiMartialTypeID][attrEnum];
        martialAttrs[uiMartialTypeID][attrEnum] = value + iValue;

    elseif effectEnum == MartialItemEffect.MTT_WUXUECHENGZHANG then
        if attrEnum ~= AttrType.MP_WEILI and attrEnum ~= AttrType.MP_WEILIXISHU and attrEnum ~= AttrType.MP_WEILIJIXIAN and attrEnum ~= AttrType.ATTR_WEILIXISHUDUGU then
            departType = DepartEnumType.DET_DepartEnumTypeNull;
        end

        local iFinalValue = _getMartialForcePercent(departType, grade, attrEnum, rankType, false, true);
        local iOrigValue = _getMartialForcePercent(departType, grade, attrEnum, rankType, false, false);
        local martialAttrs = martialInfo.martialAttrs;
        local uiMartialTypeID = martialStruct.uiMartialTypeID;
        martialAttrs[uiMartialTypeID] = martialAttrs[uiMartialTypeID] or {};
        martialAttrs[uiMartialTypeID][attrEnum] = martialAttrs[uiMartialTypeID][attrEnum] or 0;
        local value = martialAttrs[uiMartialTypeID][attrEnum];
        martialAttrs[uiMartialTypeID][attrEnum] = value + iOrigValue + iFinalValue * martialStruct.uiMartialLv;

    elseif effectEnum == MartialItemEffect.MTT_XIBIEWUXUESHUXING or
    effectEnum == MartialItemEffect.MTT_WUXUESHUXING then
        for i = 1, #(martialDescVec) do
            local martialAttrs = martialInfo.martialAttrs;
            local uiMartialTypeID = martialDescVec[i].uiMartialTypeID;
            if _filter(martialFilter, martialDescVec[i].uiMartialTypeID, martialStruct.uiMartialTypeID, iValue, martialInfo.martialAppend, attrEnum, rankType, departType) then
                martialAttrs[uiMartialTypeID] = martialAttrs[uiMartialTypeID] or {};
                martialAttrs[uiMartialTypeID][attrEnum] = martialAttrs[uiMartialTypeID][attrEnum] or 0;
                local value = martialAttrs[uiMartialTypeID][attrEnum];
                martialAttrs[uiMartialTypeID][attrEnum] = value + iValue;
            end
        end

    elseif effectEnum == MartialItemEffect.MTT_ZHAOSHIJINENG then
        for i = 1, #(martialDescVec) do
            local martialUnlockSkills = martialInfo.martialUnlockSkills;
            local uiMartialTypeID = martialDescVec[i].uiMartialTypeID;
            if _filter(martialFilter, martialDescVec[i].uiMartialTypeID, martialStruct.uiMartialTypeID, iValue, martialInfo.martialAppend, attrEnum, rankType, departType) then
                martialUnlockSkills[uiMartialTypeID] = martialUnlockSkills[uiMartialTypeID] or {};
                table.insert(martialUnlockSkills[uiMartialTypeID], skillID);
            end
        end

    elseif effectEnum == MartialItemEffect.MTT_JINENGJINGHUA then
        for i = 1, #(martialDescVec) do
            local martialSkillEvolution = martialInfo.martialSkillEvolution;
            local uiMartialTypeID = martialDescVec[i].uiMartialTypeID;
            martialSkillEvolution[uiMartialTypeID] = martialSkillEvolution[uiMartialTypeID] or {}
            martialSkillEvolution[uiMartialTypeID][attrEnum] = martialSkillEvolution[uiMartialTypeID][attrEnum] or 0;
            if _filter(martialFilter, martialDescVec[i].uiMartialTypeID, martialStruct.uiMartialTypeID, iValue, martialInfo.martialAppend, attrEnum, rankType, departType) then
                martialSkillEvolution[uiMartialTypeID][skillID] = iValue;
            end
        end

    end
end

RoleDataHelper.GetAttrByMartials = function(roleData, dbRoleData)
    return RoleDataHelper.GetMartialInfo(roleData, dbRoleData).martialAttrs;
end

RoleDataHelper.GetMartialInfo = function(roleData, dbRoleData)
    local auiMartials, auiLvs = roleData:GetMartials()
    local martialDescVec = {};
    for i = 0, #(auiMartials) do
        local tempT = {};
        tempT.uiMartialLv = auiLvs[i];
        tempT.uiMartialTypeID = auiMartials[i];
        table.insert(martialDescVec, tempT);
    end

    local martialInfo = {};
    martialInfo.martialUnlockItems = {};
    martialInfo.martialUnlockSkills = {};
    martialInfo.martialAttrs = {};
    martialInfo.martialSkillEvolution = {};
    martialInfo.martialAppend = {};

    for i = 1, #(martialDescVec) do
        local martialTypeID = martialDescVec[i].uiMartialTypeID;
        local martialLV = martialDescVec[i].uiMartialLv;
        local martial = GetTableData("Martial",martialTypeID);

        if martial then           
            martialInfo.martialUnlockItems[martialTypeID] = {};
            
            for j = 1, #(martial.GrowProIDs or {}) do
                table.insert(martialInfo.martialUnlockItems[martialTypeID], martial.GrowProIDs[j]);
            end
            
            for j = 1, #(martial.MartMovIDs or {}) do
                table.insert(martialInfo.martialUnlockItems[martialTypeID], martial.MartMovIDs[j]);
            end
            
            if martialLV then
                for j = 1, #(martial.UnlockClauses or {}) do
                    local lvls = martial.UnlockLvls[j];
                    local clauses = martial.UnlockClauses[j];
                    if lvls <= martialLV then
                        table.insert(martialInfo.martialUnlockItems[martialTypeID], martial.UnlockClauses[j]);
                    end
                end
            else
                dprint('martialLV is null:', i)
            end
        else
            dprint('martialTypeID error:', martialTypeID)
        end
    end

    for k, v in pairs(martialInfo.martialUnlockItems) do
        local martialTypeID = k;
        local unlockItemID = v;
        
        for i = 1, #(unlockItemID) do
            local martial = GetTableData("Martial",martialTypeID)
            local item = TableDataManager:GetInstance():GetTableData("MartialItem", unlockItemID[i])
            local martialStruct = nil;
            for i = 1, #(martialDescVec) do
                if martialDescVec[i].uiMartialTypeID == martialTypeID then
                    martialStruct = martialDescVec[i];
                end
            end

            if martialStruct then
                _func_GetAttrByMartialsHelper(1, item, martial, martialStruct, martialDescVec, martialInfo);
                _func_GetAttrByMartialsHelper(2, item, martial, martialStruct, martialDescVec, martialInfo);
            end
        end
    end

    return martialInfo;
end

RoleDataHelper.GetAttrByType = function(attrData, sAttr)
    local value = 0;
    if attrData and next(attrData) then
        for k, v in pairs(attrData) do
            if v[RoleAttrTypeMap[sAttr]] then
                value = value + v[RoleAttrTypeMap[sAttr]];
            end
        end
    end
    return value;
end

RoleDataHelper.GetGiftAttrByType = function(attrData, sAttr)
    local value = 0;
    if attrData and next(attrData) then
        for k, v in pairs(attrData) do
            if v[RoleAttrTypeMap[sAttr]] then
                value = value + v[RoleAttrTypeMap[sAttr]].Value;
            end
        end
    end
    return value;
end

RoleDataHelper.GetAttrByEquips = function(roleData, dbRoleData, itemIndex)

    if not roleData then
        return {},{};
    end

    local isHouseID = false;
    if roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
        isHouseID = true
    end

    local equipBlueAttr = {};
    local auiEquipItemInfos = roleData:GetEquipItemInfos()
    for k,itemInfo in pairs(auiEquipItemInfos) do
        local itemID = itemInfo.iInstID or 0
        local itemTypeID = itemInfo.iTypeID or 0

        if itemID > 0  then
            itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
        end

        if itemTypeID and itemTypeID > 0 then
            equipBlueAttr[itemTypeID] = {};
            local instData = {};
            local itemBattleID = itemTypeID;
            local data = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemBattleID);

            if itemID > 0 then 
                instData = ItemDataManager:GetInstance():GetItemData(itemID)
            elseif isHouseID then
                instData = ItemDataManager:GetInstance():GetItemData(itemID)
            end

            if instData and instData.auiAttrData then
                for k, v in pairs(instData.auiAttrData) do
                    if not equipBlueAttr[itemBattleID][v.uiType] then
                        equipBlueAttr[itemBattleID][v.uiType] = 0;
                    end
                    equipBlueAttr[itemBattleID][v.uiType] = equipBlueAttr[itemBattleID][v.uiType] + v.iBaseValue;
                end
            end

            if data.BlueGift then
                local gifts = {};
                local level = 0;
                if isTypeID then
                    level = 0;
                elseif isHouseID then
                    level = instData.uiEnhanceGrade;
                end
                for j = 1, #(data.BlueGift) do
                    if data.BlueGiftUnlockLv and (data.BlueGiftUnlockLv[j] == 0 or data.BlueGiftUnlockLv[j] <= level) then
                        table.insert(gifts, data.BlueGift[j]);
                    end
                end

                local tempFix = RoleDataHelper.GetGiftInfo(gifts, roleData, dbRoleData, true, false, false);
                local tempPer = RoleDataHelper.GetGiftInfo(gifts, roleData, dbRoleData, false, true, false);
                local tempCon = RoleDataHelper.GetGiftInfo(gifts, roleData, dbRoleData, false, false, true);
                local tempT = {tempFix, tempPer, tempCon};
                for kF, vF in pairs(tempT) do
                    for kS, vS in pairs(vF) do
                        for kT, vT in pairs(vS) do
                            if not equipBlueAttr[itemBattleID][kT] then
                                equipBlueAttr[itemBattleID][kT] = 0;
                            end
                            equipBlueAttr[itemBattleID][kT] = equipBlueAttr[itemBattleID][kT] + vT;
                        end
                    end
                end
            end
        end
    end

    return equipBlueAttr;
end

RoleDataHelper.GetAttrByGifts = function(roleData, dbRoleData, bFix, bPer, bCon)
    local auiRoleGifts = table_c2lua(roleData:GetGifts());
    return RoleDataHelper.GetGiftInfo(auiRoleGifts, roleData, dbRoleData, bFix, bPer, bCon);
end

local attr_2 = {
    [3] = {"Strength" ,"力道"},
    [4] = {"Constitution" ,"体质"},
    [5] = {"Energy" ,"精力"},
    [6] = {"Power" ,"内劲"},
    [7] = {"Agility" ,"灵巧"},
    [8] = {"Comprehension" ,"悟性"},

    [9] = {"FistMastery" ,"拳掌精通"},
    [10] = {"SwordMastery" ,"剑法精通"},
    [11] = {"KnifeMastery" ,"刀法精通"},
    [12] = {"LegMastery" ,"腿法精通"},
    [13] = {"StickMastery" ,"奇门精通"},
    [14] = {"NeedleMastery" ,"暗器精通"},
    [15] = {"HealingMastery" ,"医术精通"},
    [16] = {"SoulMastery" ,"内功精通"},
    [17] = {"HP" ,"生命"},
    [18] = {"MP" ,"真气"},
    [30] = {"Hits" ,"命中值"},
    [31] = {"Crits" ,"暴击值"},
    [32] = {"Continu" ,"连击值"},
}

RoleDataHelper.GetGiftInfo = function(gifts, roleData, dbRoleData, bFix, bPer, bCon)

    local fixGiftsAttr = {};
    local perGiftsAttr = {};
    local conGiftsAttr = {};
   
    if (not gifts) then
        return fixGiftsAttr, perGiftsAttr, conGiftsAttr;
    end

    local Local_TB_RoleGift = TableDataManager:GetInstance():GetTable("Gift")
    
    -- TODO 固定值
    if bFix then
        for i = 1, #(gifts) do
            
            if not fixGiftsAttr[i] then
                fixGiftsAttr[i] = {};
            end

            local gift = Local_TB_RoleGift[gifts[i]];

            if gift and gift.AttrType and gift.GiftType ~= GiftType.GT_Adventure and gift.BaseID ~= 794 then
                for j = 1, #(gift.AttrType) do
                    if gift.SkillTriggers and gift.SkillTriggers[j] and ((not gift.SkillTriggers[j].ConditionID) or (gift.SkillTriggers[j].ConditionID == 0)) then
                        if gift.AttrValue and #(gift.AttrValue) > 0 then
                            if not fixGiftsAttr[i][gift.AttrType[j]] then
                                fixGiftsAttr[i][gift.AttrType[j]] = 0;
                            end
                            fixGiftsAttr[i][gift.AttrType[j]] = fixGiftsAttr[i][gift.AttrType[j]] + gift.AttrValue[j];
                        end
                    end
                end
            end
        end

        return fixGiftsAttr;
    end

    -- TODO 百分比
    if bPer then
        for i = 1, #(gifts) do
    
            if not perGiftsAttr[i] then
                perGiftsAttr[i] = {};
            end
    
            local gift = Local_TB_RoleGift[gifts[i]];
            
            if gift and gift.AttrType and gift.GiftType ~= GiftType.GT_Adventure and gift.BaseID ~= 794 then
                for j = 1, #(gift.AttrType) do
                    if gift.SkillTriggers and ((not gift.SkillTriggers[j].ConditionID) or (gift.SkillTriggers[j].ConditionID == 0)) then
                            
                        if gift.AttrPercent and #(gift.AttrPercent) > 0 and gift.AttrPercentFlag and #(gift.AttrPercentFlag) > 0 then
                            if gift.AttrPercentFlag[j] == 1 then
                                if not perGiftsAttr[i][gift.AttrType[j]] then
                                    perGiftsAttr[i][gift.AttrType[j]] = 0;
                                end
    
                                local attrType = attr_2[gift.AttrType[j]] and attr_2[gift.AttrType[j]][1] or nil;
                                local baseAttr = roleData:GetAttrByTBData();
                                local convBaseAttr = roleData:GetConvAttrByTBData();
                                local attrB = RoleDataHelper.GetAttrByType(baseAttr, attrType);
                                local attrCB = RoleDataHelper.GetAttrByType(convBaseAttr, attrType);
                                perGiftsAttr[i][gift.AttrType[j]] = perGiftsAttr[i][gift.AttrType[j]] + (attrB + attrCB) * gift.AttrPercent[j] / 10000;
    
                            elseif gift.AttrPercentFlag[j] == 2 then
                                if not perGiftsAttr[i][gift.AttrType[j]] then
                                    perGiftsAttr[i][gift.AttrType[j]] = 0;
                                end
                                
                                local attrType = attr_2[gift.AttrType[j]] and attr_2[gift.AttrType[j]][1] or nil;
                                local equipAttrs = roleData:GetAttrByEquips();
                                local convEquipAttrs = roleData:GetConvAttrByEquips();
                                local attrB = RoleDataHelper.GetAttrByType(equipAttrs, attrType);
                                local attrCB = RoleDataHelper.GetAttrByType(convEquipAttrs, attrType);
                                perGiftsAttr[i][gift.AttrType[j]] = perGiftsAttr[i][gift.AttrType[j]] + (attrB + attrCB) * gift.AttrPercent[j] / 10000;
    
                            elseif gift.AttrPercentFlag[j] == 4 then
                                if not perGiftsAttr[i][gift.AttrType[j]] then
                                    perGiftsAttr[i][gift.AttrType[j]] = 0;
                                end
                                
                                local attrType = attr_2[gift.AttrType[j]] and attr_2[gift.AttrType[j]][1] or nil;
                                local baseAttrs = roleData:GetAttrByTBData();
                                local convBaseAttrs = roleData:GetConvAttrByTBData();
                                local martialAttrs = roleData:GetAttrByMartials();
                                local convMartialAttrs = roleData:GetConvAttrByMartials();
                                local equipAttrs = roleData:GetAttrByEquips();
                                local convEquipAttrs = roleData:GetConvAttrByEquips();
                                local titleAttrs = roleData:GetAttrByTitle();
                                local convTitleAttrs = roleData:GetConvAttrByTitle();
                                
                                local fixGiftAttrs = roleData:GetFixAttrByGifts();
                                local convFixGiftAttrs = roleData:GetFixConvAttrByGifts();
    
                                local baseAttr = RoleDataHelper.GetAttrByType(baseAttrs, attrType);
                                local convBaseAttr = RoleDataHelper.GetAttrByType(convBaseAttrs, attrType);
                                local martialAttr = RoleDataHelper.GetAttrByType(martialAttrs, attrType);
                                local convMartialAttr = RoleDataHelper.GetAttrByType(convMartialAttrs, attrType);
                                local equipAttr = RoleDataHelper.GetAttrByType(equipAttrs, attrType);
                                local convEquipAttr = RoleDataHelper.GetAttrByType(convEquipAttrs, attrType);
                                local titleAttr = RoleDataHelper.GetAttrByType(titleAttrs, attrType);
                                local convTitleAttr = RoleDataHelper.GetAttrByType(convTitleAttrs, attrType);
                                
                                local fixGiftAttr = RoleDataHelper.GetAttrByType(fixGiftAttrs, attrType);
                                local convFixGiftAttr = RoleDataHelper.GetAttrByType(convFixGiftAttrs, attrType);
    
                                local attrB = baseAttr + martialAttr + equipAttr + titleAttr + fixGiftAttr;
                                local attrCB = convBaseAttr + convMartialAttr + convEquipAttr + convTitleAttr + convFixGiftAttr;
                                perGiftsAttr[i][gift.AttrType[j]] = perGiftsAttr[i][gift.AttrType[j]] + (attrB + attrCB) * gift.AttrPercent[j] / 10000;
                            
                            end
                        end
                    end
                end
            end
        end

        return perGiftsAttr;
    end

    -- TODO 转化值
    if bCon then
        for i = 1, #(gifts) do
    
            if not conGiftsAttr[i] then
                conGiftsAttr[i] = {};
            end
    
            local gift = Local_TB_RoleGift[gifts[i]];
            
            if gift and gift.AttrType and gift.GiftType ~= GiftType.GT_Adventure and gift.BaseID ~= 794 then
                for j = 1, #(gift.AttrType) do
                    if gift.SkillTriggers and ((not gift.SkillTriggers[j].ConditionID) or (gift.SkillTriggers[j].ConditionID == 0)) then
    
                        if gift.SrcAttr and j <= #(gift.SrcAttr) then
                            if not conGiftsAttr[i][gift.AttrType[j]] then
                                conGiftsAttr[i][gift.AttrType[j]] = 0;
                            end
                            
                            local attrType = attr_2[gift.SrcAttr[j]] and attr_2[gift.SrcAttr[j]][1] or nil;
                            local baseAttrs = roleData:GetAttrByTBData();
                            local convBaseAttrs = roleData:GetConvAttrByTBData();
                            local martialAttrs = roleData:GetAttrByMartials();
                            local convMartialAttrs = roleData:GetConvAttrByMartials();
                            local equipAttrs = roleData:GetAttrByEquips();
                            local convEquipAttrs = roleData:GetConvAttrByEquips();
                            local titleAttrs = roleData:GetAttrByTitle();
                            local convTitleAttrs = roleData:GetConvAttrByTitle();
                            
                            local fixGiftAttrs = roleData:GetFixAttrByGifts();
                            local convFixGiftAttrs = roleData:GetFixConvAttrByGifts();
    
                            local baseAttr = RoleDataHelper.GetAttrByType(baseAttrs, attrType);
                            local convBaseAttr = RoleDataHelper.GetAttrByType(convBaseAttrs, attrType);
                            local martialAttr = RoleDataHelper.GetAttrByType(martialAttrs, attrType);
                            local convMartialAttr = RoleDataHelper.GetAttrByType(convMartialAttrs, attrType);
                            local equipAttr = RoleDataHelper.GetAttrByType(equipAttrs, attrType);
                            local convEquipAttr = RoleDataHelper.GetAttrByType(convEquipAttrs, attrType);
                            local titleAttr = RoleDataHelper.GetAttrByType(titleAttrs, attrType);
                            local convTitleAttr = RoleDataHelper.GetAttrByType(convTitleAttrs, attrType);
                            
                            local fixGiftAttr = RoleDataHelper.GetAttrByType(fixGiftAttrs, attrType);
                            local convFixGiftAttr = RoleDataHelper.GetAttrByType(convFixGiftAttrs, attrType);
    
                            local attrB = baseAttr + martialAttr + equipAttr + titleAttr + fixGiftAttr;
                            local attrCB = convBaseAttr + convMartialAttr + convEquipAttr + convTitleAttr + convFixGiftAttr;
    
                            local value = (attrB + attrCB) * gift.ConVAttrValue / 10000;
                            if gift.ConvAttrLimit and j <= #(gift.ConvAttrLimit) and gift.ConvAttrLimit[j] > 0 then
                                value = value > (gift.ConvAttrLimit[j] / 10000) and (gift.ConvAttrLimit[j] / 10000) or value;
                            end
    
                            conGiftsAttr[i][gift.AttrType[j]] = conGiftsAttr[i][gift.AttrType[j]] + value;                 
                        end
                    end
                end
            end
        end

        return conGiftsAttr;
    end
end

RoleDataHelper.EqualItemType = function(eItemTypeA, eItemTypeB)
    local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
    local dbkTypeA = TB_ItemType[eItemTypeA]
    local dbkTypeB = TB_ItemType[eItemTypeB]
     
    if not dbkTypeA.ChildItemType and dbkTypeB.ChildItemType then
        for i=1, #dbkTypeB.ChildItemType do
            if dbkTypeB.ChildItemType[i] == eItemTypeA then
                return true
            end
        end

        return false
    elseif not dbkTypeB.ChildItemType and dbkTypeA.ChildItemType then
        for i=1, #dbkTypeA.ChildItemType do
            if dbkTypeA.ChildItemType[i] == eItemTypeB then
                return true
            end
        end

        return false
    else
        return dbkTypeA == dbkTypeB
    end
end

RoleDataHelper.GetMainRoleItemsByType = function(itemtype, nomissiontype)
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    local auiItemIDList = mainRoleData.auiRoleItem or {}

    if not itemtype and not nomissiontype then
        return auiItemIDList
    end

    --排除任务物品
    if not itemtype and nomissiontype then
        local auiItemIDOut = {}
        local idx = 0
        for i=0, getTableSize(auiItemIDList) - 1 do
            local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(auiItemIDList[i])
            if itemTypeData and not RoleDataHelper.EqualItemType(itemTypeData.ItemType, ItemTypeDetail.ItemType_Task) then
                auiItemIDOut[idx] = auiItemIDList[i]
                idx = idx + 1
            end 
        end
        return auiItemIDOut
    end

    local auiItemIDOut = {}
    local idx = 0
    for i=0, getTableSize(auiItemIDList) - 1 do
        local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(auiItemIDList[i])
        if itemTypeData and RoleDataHelper.EqualItemType(itemTypeData.ItemType, itemtype) then
            auiItemIDOut[idx] = auiItemIDList[i]
            idx = idx + 1
        end 
    end
    return auiItemIDOut
end

--roleData = 角色数据
--int_OverLevel 叠加等级
--int_Fragment 碎片数量
--return (百分比)数值= 这个表的对应品质增益累加
RoleDataHelper.GetExtraLevelAttr = function(roleData,int_OverLevel,int_Fragment)
    if not (roleData and int_OverLevel) then
        return
    end

    local ExtraLevelAttr = 0  
    local temp_ExtraLevelAttr = 0
    local TB_RoleStrength = TableDataManager:GetInstance():GetTable("RoleStrength")
    for k,v in ipairs(TB_RoleStrength) do
        if (v.Level == int_OverLevel) and ((int_Fragment == nil) or (v.RolePieceNum == int_Fragment)) then
            if RoleDataHelper.GetRank(roleData) == RankType.RT_White then
                temp_ExtraLevelAttr = v.White
                break
            elseif RoleDataHelper.GetRank(roleData) == RankType.RT_Green then
                temp_ExtraLevelAttr = v.Green
                break
            elseif RoleDataHelper.GetRank(roleData) == RankType.RT_Blue then
                temp_ExtraLevelAttr = v.Blue
                break
            elseif RoleDataHelper.GetRank(roleData) == RankType.RT_Purple then                
                temp_ExtraLevelAttr = v.Purple
                break
            elseif RoleDataHelper.GetRank(roleData) == RankType.RT_Orange then
                temp_ExtraLevelAttr = v.Orange
                break
            elseif RoleDataHelper.GetRank(roleData) == RankType.RT_Golden then
                temp_ExtraLevelAttr = v.Golden
                break
            elseif RoleDataHelper.GetRank(roleData) == RankType.RT_DarkGolden then
                temp_ExtraLevelAttr = v.DarkGolden
                break
            else 
                temp_ExtraLevelAttr = 0
            end
        end
    end
    ExtraLevelAttr = temp_ExtraLevelAttr / 10000
    return ExtraLevelAttr * 100
end

--获取角色静态心愿任务用于成就面板显示
RoleDataHelper.GetRoleWishAchieve = function(roleData)
    if roleData == nil then
        return
    end
    local _wishCount = 0
    local _roleWishAchieve = {}

    local TB_RoleWishAchieve = TableDataManager:GetInstance():GetTable("RoleWishAchieve")
    for _,v in pairs(TB_RoleWishAchieve) do
        if v.Rank == RoleDataHelper.GetRank(roleData) then
            _wishCount = v.WishAmount
            _roleWishAchieve = v.WishNameID
        end
    end
    if roleData.WishQuestID and #roleData.WishQuestID > 0 then
       for index = 1,#roleData.WishQuestID,1 do
            local _wishID =  roleData.WishQuestID[index] or 1
            local _WishQuest = TableDataManager:GetInstance():GetTableData("RoleWishQuest",_wishID)
            if (_WishQuest) then
                _roleWishAchieve[index] = _WishQuest.NameID
            end
        end
    end
   
    return _wishCount,_roleWishAchieve
end


-- AdventureType = {
--     AT_Null = 0; -- -
--     AT_BiQi = 1; -- 闭气术
--     AT_BiDu = 2; -- 避毒术
--     AT_JiGuan = 3; -- 机关术
--     AT_SuiYan = 4; -- 碎岩术
--     AT_TenKong = 5; -- 腾空术
--     AT_CaiKuang = 6; -- 采矿
--     AT_CaiYao = 7; -- 采药
--     AT_ShiCaiSouGua = 8; -- 食材搜刮
--     AT_JinQianSouGua = 9; -- 金钱搜刮
--     AT_Invalid = 10; -- 无效
--   }

--获取队伍角色冒险天赋等级
RoleDataHelper.GetTeammatesAdvGiftsLevel = function(giftType)
    local int_level = 0
    local info = globalDataPool:getData("MainRoleInfo")
	if info and info["Teammates"] then
        for i = 0, getTableSize(info["Teammates"]) do
            local id = info["Teammates"][i]
            local AdvGifts =  GiftDataManager:GetInstance():GetRoleAdvGift(id)
            if AdvGifts and getTableSize(AdvGifts) > 0 then
                for i = 1, getTableSize(AdvGifts) do
                    local _GiftData = AdvGifts[i]
                    if _GiftData.AdventureType == giftType then
                        int_level = int_level + _GiftData.AdventureLevel
                    end
                end
            end
		end
    end
    return int_level
end

RoleDataHelper.GetTeammatesByUID = function(uiRoleID)
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiRoleID)
    if roleData then
        local instroleData = RoleDataManager:GetInstance():GetInstRoleByTypeID(roleData.uiTypeID)
        return instroleData
    end
end

RoleDataHelper.GetRefreshTimes = function(uiPlayerBehaviorType)
    local uiCurTimes = RoleDataManager:GetInstance():GetRefreshTimes(uiPlayerBehaviorType)
    local uiLimitTImes = 0
    local TB_InteractLimit = TableDataManager:GetInstance():GetTable("InteractLimit")
    for i=1, #TB_InteractLimit do
        if TB_InteractLimit[i].PlayerBehavior == uiPlayerBehaviorType then
            uiLimitTImes = TB_InteractLimit[i].RefreshTimes
            break
        end
    end

    return uiCurTimes, uiLimitTImes
end

RoleDataHelper.GetRefreshCost = function(uiPlayerBehaviorType)
    local TB_InteractLimit = TableDataManager:GetInstance():GetTable("InteractLimit")
    for i=1, #TB_InteractLimit do
        if TB_InteractLimit[i].PlayerBehavior == uiPlayerBehaviorType then
            return TB_InteractLimit[i].CostYinDing or 0
        end
    end

    return 999999
end

-- 是否显示好感度
RoleDataHelper.CanShowFavor = function(uiTypeID)
	for i=1, #FAVOR_SHOW_SCRIPT_BLACKLIST do
		if FAVOR_SHOW_SCRIPT_BLACKLIST[i] == GetCurScriptID() then
			return false
		end
	end

	for i=1, #FAVOR_SHOW_ROLE_BLACKLIST do
		if FAVOR_SHOW_ROLE_BLACKLIST[i] == uiTypeID then
			return false
		end
	end

	return true
end

RoleDataHelper.TeammateFullHealth = function()
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
    -- 包括队友在内的人数
    local teammatesCount = mainRoleInfo["TeammatesNums"] or 1
    -- 包括队友在内的所有队友, 索引从0开始
    local teammates = mainRoleInfo["Teammates"]
    local roleID = nil
    local roleData = nil
    local akEquipItem = nil
    local bool_allTeamsFullofHp = true 
    local roleDataManager = RoleDataManager:GetInstance()
    for index = 0, teammatesCount - 1 do
        roleID = teammates[index]
        roleData = roleDataManager:GetRoleData(roleID)
        if roleData.uiHP then
            if roleData.uiHP < roleData.aiAttrs[AttrType.ATTR_MAXHP] then
                bool_allTeamsFullofHp = false
            end
        end
    end

    if bool_allTeamsFullofHp then
        local content = "所有队员生命值已满"
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, content, false)
    end
    return bool_allTeamsFullofHp
end

--是否显示更换替补
RoleDataHelper.CheckShowSubRole = function(uiRoleTypeID)
    local roleDataManager = RoleDataManager:GetInstance()
    local mainroleData = roleDataManager:GetMainRoleData() or {}
    if roleDataManager:IsSwornedWithMainRole(uiRoleTypeID, true) or mainroleData.uiMarry == uiRoleTypeID then
        return true
    end
end

RoleDataHelper.GetAttrByTitle = function(roleData, dbRoleData, ingoreAttr)
    local TB_RoleTitle = TableDataManager:GetInstance():GetTable("RoleTitle")
    
    local titleID = 0; 
    local titleAttrs = {};
    if roleData.roleType == ROLE_TYPE.NPC_ROLE then
        titleID = dbRoleData.TitleID;
    elseif roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
        titleID = roleData.uiTitleID;

        if ingoreAttr ~= true then
            local unlockPool = globalDataPool:getData("UnlockPool") or {};
            if unlockPool[PlayerInfoType.PIT_TITLE] then
                for k, v in pairs(unlockPool[PlayerInfoType.PIT_TITLE]) do
                    if (v.dwTypeID >> 24) & 0xff == 0 then
                        local cloneV = clone(v);
                        cloneV.dwTypeID = v.dwTypeID & 0xffffff;
                        local titleAttr = TB_RoleTitle[v.dwTypeID];
                        if titleAttr then
                            table.insert(titleAttrs, {[titleAttr.TitleAttr] = titleAttr.Value});
                        end
                    end
                end
            end
        end
    end

    if titleID > 0 then
        local titleAttr = TB_RoleTitle[titleID];
        if titleAttr then
            table.insert(titleAttrs, {[titleAttr.TitleAttr] = titleAttr.Value});
        end
    end
    return titleAttrs;
end

function RoleDataHelper.GetConvertAttr(attr, level)
	local convertAttrTable = {};
	level = level or 1;
	local TB_AttrTrans = TableDataManager:GetInstance():GetTable("AttrTrans");
    for k, v in pairs(attr) do
        -- body
        if not convertAttrTable[k] then
            convertAttrTable[k] = {};
		end
        for kk, vv in pairs(TB_AttrTrans) do
            -- body
			if k == vv.OriAttr then
				for i = 1, 5 do 
					local type = vv['ConvertAttr' .. i];
					local value = vv['ConvertValue' .. i];
					if type ~= AttrType.ATTR_NULL then
						if type == AttrType.ATTR_MAXHP then  
							local BattleFactor = TableDataManager:GetInstance():GetTableData("BattleFactor", level);
							value = BattleFactor and (BattleFactor.physique_hp * 10000) or value;
						end 
						convertAttrTable[k][type] = value * v / vv.Value;
					end
				end
				break;
            end
        end
    end
    return convertAttrTable;
end

-- Condition
RoleDataHelper.ConditionComp = function(condID, martialData, dbMartialData)
    local condData = TableDataManager:GetInstance():GetTableData("Condition",condID)
    if not condData then
        return false;    
    end

    local roleData = RoleDataManager:GetInstance():GetRoleData(martialData.uiRoleUID);
    local dbRoleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleData.uiTypeID);

    if condData.CondType == ConditionType.CT_Role_MartialLV then
        return RoleDataHelper.Cond1Wu2Xue3Deng4Ji(condID, roleData, dbRoleData);

    elseif condData.CondType == ConditionType.CT_auto_jiao3se4_jiao3se4yong1you3tian1fu4 then
        return RoleDataHelper.Cond1Yong2You3Tian4Fu(condID, roleData, dbRoleData);

    elseif condData.CondType == ConditionType.CT_ROLR_ATTR_CMP then
        return RoleDataHelper.Cond1Shu2Xing3Bi4Jiao(condID, roleData, dbRoleData);

    end

    return false;
end

-- 角色_武学等级
RoleDataHelper.Cond1Wu2Xue3Deng4Ji = function (condID, roleData, dbRoleData)
    local condData = TableDataManager:GetInstance():GetTableData("Condition",condID)
    if not condData then
        return false;    
    end

    local condArg1 = tonumber(condData.CondArg1);
    local condArg2 = condData.CondArg2;
    local condArg3 = tonumber(condData.CondArg3);

    local _Comp = function(cond, value1, value2)
        local comp = CompareSignType_Revert[cond];
        if comp == CompareSignType.CMP_NULL then
            return false;
        
        elseif comp == CompareSignType.CMP_GREATER then
            return value1 > value2;

        elseif comp == CompareSignType.CMP_GREATER_EQUAL then
            return value1 >= value2;
            
        elseif comp == CompareSignType.CMP_LESS then
            return value1 < value2;

        elseif comp == CompareSignType.CMP_LESS_EQUAL then
            return value1 <= value2;

        elseif comp == CompareSignType.CMP_EQUAL then
            return value1 == value2;

        elseif comp == CompareSignType.CMP_NOT_EQUAL then
            return value1 ~= value2;

        end
    end

    local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE;
    if isNPC then
        for k, v in pairs(dbRoleData.Kungfu) do
            if condArg1 == dbRoleData.Kungfu[k] then
                return _Comp(condArg2, dbRoleData.KungfuLevel[k], condArg3);
            end
        end

        local akRemoveEvolutions = RoleDataHelper.GetEvolutionsByType(roleData, NET_MARTIAL_TYPEID);
        for n = 0, getTableSize(akRemoveEvolutions) - 1 do
            if condArg1 == akRemoveEvolutions[n].iParam1 then
                return _Comp(condArg2, akRemoveEvolutions[n].iParam2, condArg3);
            end
        end
    else
        local martialList = MartialDataManager:GetInstance():GetRoleMartial(roleData.uiID) or {};
        for iTypeID, v in pairs(martialList) do
            if condArg1 == iTypeID then
                return _Comp(condArg2, v.uiLevel, condArg3);
            end
        end

    end

    return false;
end

-- 角色_角色拥有天赋
RoleDataHelper.Cond1Yong2You3Tian4Fu = function (condID, roleData, dbRoleData)
    local condData = TableDataManager:GetInstance():GetTableData("Condition",condID)
    if not condData then
        return false;    
    end

    -- 参数解析
    -- 参数1 角色id
    -- 参数2 天赋id
    -- 参数3 是否包含队友
    local condArg1 = condData.CondArg1;
    local condArg2 = condData.CondArg2;
    local condArg3 = condData.CondArg3;

    local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE;
    if isNPC then
        for k, v in pairs(dbRoleData.Gift) do
            if condArg2 == dbRoleData.Gift[k] then
                return true;
            end
        end

        local akRemoveEvolutions = RoleDataHelper.GetEvolutionsByType(roleData, NET_MARTIAL_TYPEID);
        for n = 0, getTableSize(akRemoveEvolutions) - 1 do
            if condArg2 == akRemoveEvolutions[n].iParam1 then
                return true;
            end
        end
    else
        local roleBatGift = GiftDataManager:GetInstance():GetRoleGift(roleData.uiID);
        if (roleBatGift ~= nil) then
            for k, v in pairs(roleBatGift) do
                local giftData = GiftDataManager:GetInstance():GetGiftData(v);
                if giftData and condArg2 == tostring(giftData.uiTypeID) then
                    return true;
                end
            end
        end
    end

    return false;
end

-- 角色属性比较
RoleDataHelper.Cond1Shu2Xing3Bi4Jiao = function (condID, roleData, dbRoleData)
    local condData = TableDataManager:GetInstance():GetTableData("Condition",condID)
    if not condData then
        return false;    
    end

    local condArg1 = condData.CondArg1;
    local condArg2 = condData.CondArg2;
    local condArg3 = condData.CondArg3;

    local _Comp = function(cond, value1, value2)
        local comp = CompareSignType_Revert[cond];
        if comp == CompareSignType.CMP_NULL then
            return false;
        
        elseif comp == CompareSignType.CMP_GREATER then
            return value1 > value2;

        elseif comp == CompareSignType.CMP_GREATER_EQUAL then
            return value1 >= value2;
            
        elseif comp == CompareSignType.CMP_LESS then
            return value1 < value2;

        elseif comp == CompareSignType.CMP_LESS_EQUAL then
            return value1 <= value2;

        elseif comp == CompareSignType.CMP_EQUAL then
            return value1 == value2;

        elseif comp == CompareSignType.CMP_NOT_EQUAL then
            return value1 ~= value2;

        end
    end

    local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE;
    if isNPC then
        local attributeID = TableDataManager:GetInstance():GetTableData("RoleAttr", dbRoleData.AttributeID)
        if not attributeID then
            return false;
        end

        local akRemoveEvolutions = RoleDataHelper.GetEvolutionsByType(roleData, NET_ATTR);
        for n = 0, getTableSize(akRemoveEvolutions) - 1 do
            if condArg1 == akRemoveEvolutions[n].iParam1 then
                
            end
        end
        
        local revert = AttrType_Revert[condArg1];
        return _Comp(condArg2, attributeID[revert], condArg3);
    else
        local roleData = RoleDataManager:GetInstance():GetRoleData(roleData.uiID);
        local revert = AttrType_Revert[condArg1];
        return _Comp(condArg2, roleData[revert], condArg3);
    end
end

RoleDataHelper.CheckMasterChat = function(uiRoleTypeID, uiMapID, mazeBaseID, mazeAreaIndex)
    local data = RoleDataManager:GetInstance():GetStoryMasterData(uiRoleTypeID)
    if data and (data.Map == uiMapID or (data.Maze == mazeBaseID and (data.MazeArea - 1) == mazeAreaIndex)) then
        -- 检查江湖高手开启状态
        if RoleDataHelper.IsNpcMasterEnable(data.MasterType) then 
            return data.ChatID
        end
    end
    return 0
end

RoleDataHelper.IsNpcMasterEnable = function(masterType)
    if masterType == nil then 
        return false
    end
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
    if not (mainRoleInfo ~= nil and mainRoleInfo["MainRole"] ~= nil) then 
        return false
    end
    local masterEnableState = mainRoleInfo["MainRole"][MRIT_NPC_MASTER_ENABLE_STATE]
    return HasFlag(masterEnableState, masterType)
end

RoleDataHelper.CheckClanSelecttion = function(uiRoleID)
    if RoleDataHelper.CheckDoorKeeper(uiRoleID) or RoleDataHelper.CheckSubMaster(uiRoleID, true) or RoleDataHelper.CheckMainMaster(uiRoleID, true) then
        return true
    end
end

RoleDataHelper.GetMainRoleBackpackSize = function()
    local iNum = 0
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData() or {}
    local auiItemIDList = mainRoleData.auiRoleItem or {}
    local itemMgr = ItemDataManager:GetInstance()
    for index, itemID in pairs(auiItemIDList) do
        local itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
        if itemTypeData and (itemMgr:IsTypeEqual(itemTypeData.ItemType, ItemTypeDetail.ItemType_Task) ~= true) then
            iNum = iNum + 1
        end
    end
    return iNum
end

RoleDataHelper.GetTempBackpackItemsSize = function()
    local auiItemIDList = ItemDataManager:GetInstance():GetTempBackpackItems()
    local iNum = 0
    for index, itemID in pairs(auiItemIDList) do
        local itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
        if itemTypeData and itemTypeData.ItemType ~= ItemTypeDetail.ItemType_Task then
            iNum = iNum + 1
        end
    end
    return iNum
end
return RoleDataHelper