TableDataManager = class("TableDataManager")
TableDataManager._instance = nil

function TableDataManager:GetInstance()
    if TableDataManager._instance == nil then
        TableDataManager._instance = TableDataManager.new()
        TableDataManager._instance:Init()

        --每5分钟检查一次
        -- globalTimer:AddTimer(5 * 1000, function ()
        --     TableDataManager._instance:UnloadTable()
        -- end,-1)
    end

    return TableDataManager._instance
end

function TableDataManager:Init()
    self.iCurTableNums = 0
    self.initTableName = {
        ["Language"] = true,
        ["Plot"] = true,
        ["Story"] = true,
        ["StoryDiffDrop"] = true,
        ["Item"] = true,
        ["Role"] = true,
        ["SkillEffect"] = true,
        ["SkillPerformance"] = true,
        ["TaskEdge"] = true,
        ["TaskEvent"] = true,
        ["Task"] = true,
        ["SpineAnimaitionTime"] = true,
        ["Skill"] = true,
        ['MartialItem'] = true,
        ['Buff'] = true,
        ['Battle'] = true,

        ["ClanEliminate"] = true,
        ["MapAttrChange"] = true,
        ["HighTowerConfig"] = true,
        ["AdvLoot"] = true,
        ["BuildingAdvLoot"] = true,
        ["City"] = true,
        ["Weather"] = true,
        ["InteractUnLock"] = true,
        ["Condition"] = true,
        ["RoleChat"] = true,
        ["NpcMaster"] = true,
    }
    self.iInitNum = getTableSize2(self.initTableName)
    self.maxTableNums = self.iInitNum + 60
    self.useInfo = {}

end

function TableDataManager:LoadInitTable()
    for key, value in pairs(self.initTableName) do
        self:GetTable(key)
    end
    InitRoleTable()
end

function TableDataManager:ProcessLanguage(tbName,key)
    if not self._languageSplit then
        local tab = self:GetTable(tbName)
        if tab then
            self._languageSplit = tab['splitByID']
        end
        if not self._languageSplit then
            derror("language data is error! no splitByID")
            return ""
        end
    end
    local id = key // self._languageSplit
    local tab = self:GetTable(tbName .. "/" .. tbName .. id)
    if tab then
        return tab[key] or ""
    end
end

local attrs= {'Drawing',  'Head'}
function TableDataManager:GetTableData(tbName,key)
    if key == nil then return end
    if tbName == "Language" then
        return self:ProcessLanguage(tbName,key)
    end
    local tab = self:GetTable(tbName)
    local ret = tab[key]

    if tbName == "RoleModel" then
    	if ret then
		for _, v in ipairs(attrs) do
			local backup = '__' .. v
			if not ret[backup] then
				ret[backup] = ret[v]
				ret[v] = DRCSRef.ModGetImage(ret.PictureID, v, ret[backup])
			end
		end
	end
    end
    return ret
end

function TableDataManager:GetTable(tbName)
    if (self.tables == nil) then
        self.tables = {}
    end

    if (self.tables[tbName] == nil) then
        if (self.maxTableNums == nil)then
            return
        end
        if (self.iCurTableNums > self.maxTableNums) then
            self:UnloadTable()
        end
        local ret,tab = xpcall(reloadModule,showError,"Data/" .. tbName)
        if (tab == nil) then
            return nil
        end
        self.tables[tbName] = tab
        self.iCurTableNums = self.iCurTableNums + 1
    end

    self:SetUseInfo(tbName)
    return self.tables[tbName]
end

function TableDataManager:SetUseInfo(taName)
    if self.useInfo[taName] == nil then
        self.useInfo[taName] = {["iLastUseTime"] = nil,["iUseCount"] = 0}
    end
    local useInfo = self.useInfo[taName]
    useInfo.iLastUseTime = os.clock()
    useInfo.iUseCount = useInfo.iUseCount + 1
end

function TableDataManager:UnloadTable()
    local nowTime = os.clock()
    local iDelTime = 60 * 5 --5分钟
    for key, value in pairs(self.useInfo) do
        if self.initTableName[key] == nil and (value.iUseCount <= 1 or (value.iLastUseTime - nowTime > iDelTime)) then
            unloadModel("Data/"..key)
            self.tables[key] = nil
            --self.useInfo[key] = nil
            self.iCurTableNums = self.iCurTableNums - 1
        end
    end
end

function TableDataManager:GetSystemOpenByType(type)
    local outTable = {};
    local TB_SystemOpen = self:GetTable('SystemOpen') or {};
    for k, v in pairs(TB_SystemOpen) do
        if v.SystemType == type then
            table.insert(outTable, v);
        end
    end
    return outTable;
end

local tableManager = nil
function GetTableData(tableName,key)
    if tableManager == nil then
        tableManager = TableDataManager:GetInstance()
    end
    return tableManager:GetTableData(tableName,key)
end

function WriteTableInfo()
    if  (true) then
        return
    end
	local path = "./TableUseInfo.txt"
    local dkJson = require("Base/Json/dkjson")
    local str = dkJson.encode(tableManager.useInfo)
    io.writefile(path, str,"a+b")
end

function GetCommonConfig(name)
    if g_commonConfigTable == nil then 
        g_commonConfigTable = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    end
    if g_commonConfigTable then 
        return g_commonConfigTable[name]
    end
end

return TableDataManager