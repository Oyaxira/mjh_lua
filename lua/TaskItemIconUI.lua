TaskItemIconUI = class("TaskItemIconUI", ItemIconUINew)


function TaskItemIconUI:Create(kParent)
	local obj = LoadPrefabAndInit("TaskUI/TaskItemIconUINew",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TaskItemIconUI:Init()
	if self.super then
		self.super.Init(self)
	end
    self.objTick = self:FindChild(self._gameObject, "Tick")
    self.objDiffDropGet = self:FindChild(self._gameObject,"GetMark")
    self.objOnlyGetOnce = self:FindChild(self._gameObject, "Mark_only")
end

-- 物品图标
function TaskItemIconUI:UpdateUI(kRewardData, hideDispositionValue)
    if not kRewardData then 
    	return 
    end
    self.kCurReward = kRewardData
    -- 初始化
    self.tips = nil
    self.imgFrame.gameObject:SetActive(true)
    self.imgIcon.gameObject:SetActive(true)
    self.objClan:SetActive(false)
    self.objCity:SetActive(false)
    self.objFavor:SetActive(false)
    self.objWish:SetActive(false)
    self.objCard:SetActive(false)
    self.objHeart:SetActive(false)
    self.objTick:SetActive(false)
    -- 传入模板id的物品显示
    local baseID =  kRewardData['BaseID']
    local data = TableDataManager:GetInstance():GetTableData("Item",baseID)
    if baseID and data then
        self:UpdateUIWithItemTypeData(data)
    end

    local TB_RankMsg = TableDataManager:GetInstance():GetTable("RankMsg")
    -- 传入了物品类型的物品显示
    if kRewardData['ItemType'] then
        local itemType = kRewardData['ItemType']
        local depart = kRewardData['Depart']
        local rank = kRewardData['Rank']
        -- 获取icon数据
        if itemType == ItemTypeDetail.ItemType_SecretBook then
        	-- 缓存一份品质与系别对应到秘籍图标的数据
        	if not self.rank2SecretBookIcon then
                self.rank2SecretBookIcon = {}
                local TB_RankSecretBookIcon = TableDataManager:GetInstance():GetTable("RankSecretBookIcon")
				for index, data in pairs(TB_RankSecretBookIcon) do
					if not self.rank2SecretBookIcon[data.Rank] then
						self.rank2SecretBookIcon[data.Rank] = {}
					end
					self.rank2SecretBookIcon[data.Rank][data.Kftype] = data.SecretBookIcon
	            end
        	end
        	if self.rank2SecretBookIcon[rank] and self.rank2SecretBookIcon[rank][depart] then
				kRewardData['Icon'] = self.rank2SecretBookIcon[rank][depart]
        	end
        elseif itemType == ItemTypeDetail.ItemType_IncompleteBook then
            local data = TableDataManager:GetInstance():GetTableData("Kftype",depart)
            if data then
            	kRewardData['Icon'] = data.IncompleteBookIcon
            end
        elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
        	-- 缓存一份品质到天书图标的数据
        	if not self.rank2HeavenBookIcon then
				self.rank2HeavenBookIcon = {}
				for index, data in ipairs(TB_RankMsg) do
					self.rank2HeavenBookIcon[data.Rank] = data.HeavenBookIcon
	            end
        	end
        	if self.rank2HeavenBookIcon[rank] then
				kRewardData['Icon'] = self.rank2HeavenBookIcon[rank]
        	end
        end
        -- 覆盖边框
        self:UpdateIconFrame(rank)
    end
    -- 传入了门派id的物品显示
    if kRewardData['ClanTypeID'] then
        local iClanTypeID = kRewardData['ClanTypeID']
        local kClanTypeData = TB_Clan[iClanTypeID]
        if kClanTypeData then
            self.objIconex.gameObject:SetActive(true)
            self.imgFrame.gameObject:SetActive(false)
            self.imgIcon.gameObject:SetActive(false)
            self.objClan:SetActive(true)
            local strShowName = kClanTypeData.ClanAbbreviation
            if (not strShowName) or (strShowName == "") then
                local strClanName = GetLanguageByID(kClanTypeData.NameID)
                local iMaxWordCount = 2
                if string.utf8len(strClanName) > iMaxWordCount then
                    strShowName = string.utf8sub(strClanName, 1, iMaxWordCount)
                else
                    strShowName = strClanName
                end
            end
            self.textClan.text = strShowName
        end
    end
    -- 传入了城市id的物品显示
    if kRewardData['CityTypeID'] then
        local iCityTypeID = kRewardData['CityTypeID']
        local TB_City = TableDataManager:GetInstance():GetTable("City")
        local kCityTypeData = TB_City[iCityTypeID]
        if kCityTypeData then
            self.objIconex.gameObject:SetActive(true)
            self.imgFrame.gameObject:SetActive(false)
            self.imgIcon.gameObject:SetActive(false)
            self.objCity:SetActive(true)
            local strShowName = nil
            local strCityName = GetLanguageByID(kCityTypeData.NameID)
            local iMaxWordCount = 2
            if string.utf8len(strCityName) > iMaxWordCount then
                strShowName = string.utf8sub(strCityName, 1, iMaxWordCount)
            else
                strShowName = strCityName
            end
            self.textCity.text = strShowName or "??"
        end
    end
    -- 角色好感度的显示，隐藏 边框 和 图标，使用角色头像框
    if kRewardData['RoleTypeID'] then
        local roleTypeID = kRewardData['RoleTypeID']
        local roleArtData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
        if roleArtData then
            self.objIconex.gameObject:SetActive(true)
            self.imgFrame.gameObject:SetActive(false)
            self.imgIcon.gameObject:SetActive(false)
            if kRewardData.IsWishTask == true then
                self.objWish:SetActive(true)
                self.imgWishHead.sprite = GetSprite(roleArtData.Head)
            else
                self.objFavor:SetActive(true)
                self.imgFavorHead.sprite = GetSprite(roleArtData.Head)
            end
        end
    end
    -- 设置图标
    if kRewardData['Icon'] then
        self.imgIcon.sprite = GetSprite(kRewardData['Icon'])
    end
    -- 设置数量
    if kRewardData['Num'] then
        if kRewardData['RoleTypeID'] and hideDispositionValue then 
            self.textNum.gameObject:SetActive(false)
        else
            self:SetItemNum(kRewardData['Num'], kRewardData['Num'] == 1)
        end
    else
        self.textNum.gameObject:SetActive(false)
    end
    -- 如果是全局难度幸运值掉落控制的，需要显示是否已经获得
    local bIsEmpty = (kRewardData.bShowEmpty == true) and (kRewardData["DiffDropGet"] ~= nil) and (kRewardData["DiffDropGet"] ~= false)
    if bIsEmpty then
        self.objDiffDropGet:SetActive(true)
    else
        self.objDiffDropGet:SetActive(false)
    end

    -- 如果是全服唯一掉落的，需要显示特殊图标
    if (kRewardData["onlyGetOnce"]) then
        self.objOnlyGetOnce:SetActive(true)
    else
        self.objOnlyGetOnce:SetActive(false)
    end
end

-- 覆盖默认点击行为
function TaskItemIconUI:ResetClickData()
    if not self.kCurReward then 
        return
    end
    if self.kCurReward['Desc'] then
        if not self.kCurReward.Rank then
            self.kCurReward.Rank = RankType.RT_White
        end
        self.tips = {
            ['title'] = getRankBasedText(self.kCurReward['Rank'], self.kCurReward['Name']),
            ['titlestyle'] = "outline",
            ['content'] = self.kCurReward['Desc'],
        }
    elseif self.kCurReward['BaseID'] then
        local baseID =  self.kCurReward['BaseID']
        self.tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, TableDataManager:GetInstance():GetTableData("Item",baseID))
    end
end

return TaskItemIconUI