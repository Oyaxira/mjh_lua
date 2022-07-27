EvolutionShowManager = class("EvolutionShowManager")
EvolutionShowManager._instance = nil

local MAX_RECORD_COUNT = 500
local MAX_PARAM_COUNT = 4
local L = {}

function L.GetParamData(recordType, param)
	local data = nil

	if recordType == EvoluteRecordType.ERT_Role then
		data = TableDataManager:GetInstance():GetTableData("Role", param)
	elseif recordType == EvoluteRecordType.ERT_Item then
		data = TableDataManager:GetInstance():GetTableData("Item", param)
	elseif recordType == EvoluteRecordType.ERT_Martial then
		data = TableDataManager:GetInstance():GetTableData("Martial", param)
	elseif recordType == EvoluteRecordType.ERT_Gift then
		data = TableDataManager:GetInstance():GetTableData("Gift", param)
	elseif recordType == EvoluteRecordType.ERT_Clan then
		data = TableDataManager:GetInstance():GetTableData("Clan", param)
	elseif recordType == EvoluteRecordType.ERT_City then
		data = TableDataManager:GetInstance():GetTableData("City", param)
	end

	return data
end

function EvolutionShowManager:ctor()
end

function EvolutionShowManager:IsOpenEvolute()
	return TaskTagManager:GetInstance():TagIsValue(110001, 1) or TaskTagManager:GetInstance():TagIsValue(110001, 2)
end

function EvolutionShowManager:GetOnlyShowImportant()
    return self.onlyShowImportant
end

function EvolutionShowManager:SetOnlyShowImportant(flag)
    self.onlyShowImportant = flag
end

function EvolutionShowManager:GetInstance()
    if EvolutionShowManager._instance == nil then
		EvolutionShowManager._instance = EvolutionShowManager:new()
		EvolutionShowManager._instance:ResetManager()
    end

    return EvolutionShowManager._instance
end

function EvolutionShowManager:ResetManager()
	self.akEvolutionRecord = {}
    self.kShowData = {}
	self.onlyShowImportant = false
	self.needReBuildDes = false
end

function EvolutionShowManager:RecordUpdate(data)
	self.akEvolutionRecord = self.akEvolutionRecord or {}

    local akDataRecord = data.akEvolutionRecord

	for index = 0, #akDataRecord do
		local recordID = akDataRecord[index].uiID

        self.akEvolutionRecord[recordID] = akDataRecord[index]
	end
	self.needReBuildDes = true
	--LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_EVOLUTION_RECORD")
end

function EvolutionShowManager:UpdateCurMonthShowData()
	local iYear,iMonth = EvolutionDataManager:GetInstance():GetRivakeTimeYMD()
	self:UpdateMonthShowData(iYear, iMonth)
end

function EvolutionShowManager:UpdateMonthShowData(uiYear, uiMonth)
	if not uiYear or not uiMonth then
		return
	end
	if self.kShowData and self.kShowData.year == uiYear and self.kShowData.month == uiMonth and self.needReBuildDes == false then
		return
	end

	local teammatesKey = 10000

    self.kShowData = {}
    self.kShowData.year = uiYear
    self.kShowData.month = uiMonth
	self.kShowData.cityMap = {}
	self.needReBuildDes = false

    local cityMap = self.kShowData.cityMap

    for id, record in pairs(self.akEvolutionRecord) do
        local itemCityID = record.uiCityID
        local itemTime = record.iTime
		local itemYear, itemMonth = EvolutionDataManager:GetInstance():GetRivakeTimeYMD(itemTime)

		if itemYear == uiYear and itemMonth == uiMonth then
			if record.uiBaseID and record.uiBaseID ~= 0 then
				local recordRes = TableDataManager:GetInstance():GetTableData("EvoluteRecord",record.uiBaseID)

				if recordRes then
					local itemImportant = L.GetItemImprotant(record)
					local text, hyperlinkDataDict = L.GetItemText(record)
					local textItem = {recordID = id,  text = text, important = itemImportant, hyperlinkDataDict = hyperlinkDataDict}

					if L.IsTeammatesRecord(record) then
						if not cityMap[teammatesKey] then
							cityMap[teammatesKey] = {cityID = 0, important = false, textList = {}, teammatesRecord = true}
						end

						table.insert(cityMap[teammatesKey].textList, textItem)
						if itemImportant then
							cityMap[teammatesKey].important = true
						end
					else
						if not cityMap[itemCityID] then
							cityMap[itemCityID] = {cityID = itemCityID, important = false, textList = {}}
						end

						table.insert(cityMap[itemCityID].textList, textItem)
						if itemImportant then
							cityMap[itemCityID].important = true
						end
					end
				end

			end
        end
	end

	-- 排序
	for city, cityRecord in pairs(cityMap) do
		table.sort(cityRecord.textList, function(record1, record2)
			return record1.recordID < record2.recordID
		end)
	end
end

function EvolutionShowManager:GetShowData()
    return self.kShowData
end

function EvolutionShowManager:MonthEvolutionShow(uiYear, uiMonth)
	local info = {}
	info.uiYear = uiYear
	info.uiMonth = uiMonth
	info.bHistory = false
	DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MONTH_EVOLUTION, false, info)
end

function EvolutionShowManager:HistoryShow()
	local curStoryID = GetCurScriptID()
	if curStoryID == 1 then
		return
	end
	local info = {}
	info.bHistory = true
	DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MONTH_EVOLUTION, false, info)
end

-- Return : text, hyperlinkDataDict
-- HyperlinkData Map: index - { dataType, dataID }
function L.GetItemText(record)
	local recordType = TableDataManager:GetInstance():GetTableData("EvoluteRecord",record.uiBaseID)
	if not recordType then 
		return false
	end 
	local text = GetLanguageByID(recordType.LanguageID)
	local hyperlinkDataDict = {}
	local strLen = 0

	if record.uiBaseID == 36 then	-- 多人物好感度下降
		local paramText = {}
		for i = 1, MAX_PARAM_COUNT do
			paramText[i] = L.GetItemParamText(record['iParam'..i], recordType['RecordArg' .. i .. 'Type'])
		end

		local roleNameText = ''
		if paramText[1] then
			roleNameText = paramText[1]
			for i = 2, MAX_PARAM_COUNT do
				if paramText[i] and paramText[i] ~= '' then
					roleNameText = roleNameText .. '、' .. paramText[i]
				end
			end
		end
		text = string.format(text, roleNameText)
	else
		local paramText = {}
		local textLen = {}
		local hyperlinkData = nil
		for i = 1, MAX_PARAM_COUNT do
			paramText[i], hyperlinkData, textLen[i] = L.GetItemParamText(record['iParam'..i], recordType['RecordArg' .. i .. 'Type'], i)
			if hyperlinkData then
				local left = 0
				local str = string.format(text, "A","A","A","A")
				for j = 1, i-1 do
					left = left + (textLen[j] or 0)
					str = string.gsub(str,"A","",1)
				end
				local num = string.find(str,"A") or 0
				if num ~= 0 then
					num = (num-1)/3
				end
				hyperlinkData.left = left + num
				hyperlinkDataDict[i] = hyperlinkData
			end
		end
		
		text = string.format(text, paramText[1], paramText[2], paramText[3], paramText[4])
	end

	return text, hyperlinkDataDict
end

function L.IsTeammatesRecord(record)
	local recordType = TableDataManager:GetInstance():GetTableData("EvoluteRecord",record.uiBaseID)
	if not recordType then 
		return false
	end 

	if recordType.FixTeamBar == TBoolean.BOOL_YES then
		return true
	end

	for i = 1, MAX_PARAM_COUNT do
		local argType = recordType['RecordArg' .. i .. 'Type']
		local param = record['iParam'..i]

		if argType == EvoluteRecordType.ERT_Role and param then
			if RoleDataManager:GetInstance():IsRoleInTeam(param) then
				
				if recordType.TeamBarParam then
					for index, teamParamIndex in ipairs(recordType.TeamBarParam) do
						if teamParamIndex == i then
							return true
						end
					end
				end

			end
		end

	end

	return false
end

-- Return : text, hyperlinkData
function L.GetItemParamText(param, type, hyperlinkIndex)
	if not param or param == 0 or not type or type == EvoluteRecordType.ERT_Null then
		return ''
	end

	local nameText
	local hyperlinkData = nil
	local nameLen = 0
	if type == EvoluteRecordType.ERT_Role then
		local roleID = param
		local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
		if not roleTypeID or roleTypeID == 0 then
			roleTypeID = roleID
		end
		if roleTypeID == 1 or roleTypeID == 1000001260 then
			roleID = RoleDataManager:GetInstance():GetMainRoleID()
		end

		nameText = RoleDataManager:GetInstance():GetRoleTitleAndName(roleID)
		local s = string.gsub(nameText,"·","")
		nameLen = string.len(s)/3 + 2
		nameText = '<color=black>【' .. nameText .. '】</color>'
	elseif type == EvoluteRecordType.ERT_Language then
		nameText = GetLanguageByID(param)
		nameLen = string.len(nameText)/3
	elseif type == EvoluteRecordType.ERT_Clan then
		local data = L.GetParamData(type, param)
		if not data then
			return ''
		end

		nameText = GetLanguageByID(data.NameID)
		nameLen = string.len(nameText)/3
	else
		local data = L.GetParamData(type, param)
		
		if not data then
			return ''
		end

		if type == EvoluteRecordType.ERT_Item then
			nameText = data.ItemName or ''
		else
			nameText = GetLanguageByID(data.NameID)
		end
		local s = string.gsub(nameText,"·","")
		nameLen = string.len(s)/3

		-- 物品、天赋和武学需要悬浮显示tip
		if hyperlinkIndex then
			if type == EvoluteRecordType.ERT_Item then
				hyperlinkData = {}
				hyperlinkData.width = nameLen
				--nameText = string.format("<a href=%d>%s</a>", hyperlinkIndex, nameText)
				hyperlinkData.dataType = EvoluteRecordType.ERT_Item
				hyperlinkData.dataID = param
				hyperlinkData.index = hyperlinkIndex
			elseif type == EvoluteRecordType.ERT_Gift then
				hyperlinkData = {}
				hyperlinkData.width = nameLen
				hyperlinkData.dataType = EvoluteRecordType.ERT_Gift
				hyperlinkData.dataID = param
				hyperlinkData.index = hyperlinkIndex
			elseif type == EvoluteRecordType.ERT_Martial then
				hyperlinkData = {}
				hyperlinkData.width = nameLen
				hyperlinkData.dataType = EvoluteRecordType.ERT_Martial
				hyperlinkData.dataID = param
				hyperlinkData.index = hyperlinkIndex
			end
		end

		local rank = data.Rank
		if rank then
			nameText = getRankBasedText(rank, nameText, true)
		end
	end

	return nameText, hyperlinkData, nameLen
end

function L.GetItemImprotant(record)
	local recordType = TableDataManager:GetInstance():GetTableData("EvoluteRecord",record.uiBaseID)

	if recordType.IsImportant == TBoolean.BOOL_YES then
		return true
	end

	for i = 1, MAX_PARAM_COUNT do

		if recordType['Record' .. i .. 'Judge'] == TBoolean.BOOL_YES then
			local important = L.GetItemParamImprotant(record['iParam'..i], recordType['RecordArg' .. i .. 'Type'])
			
			if important then
				return true
			end
		end
	end

	return false
end

function L.GetItemParamImprotant(param, dataType)
	if not param or not dataType or dataType == EvoluteRecordType.ERT_Null then
		return false
	end

	local data = L.GetParamData(dataType, param)

	if not data then
		return false
	end

	local rank = data.Rank
	if type(rank) ~= "number" then
		return false
	end

	local important = (rank >= RankType.RT_Golden)
	return important
end