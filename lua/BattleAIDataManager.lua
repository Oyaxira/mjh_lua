BattleAIDataManager = class("BattleAIDataManager")
BattleAIDataManager._instance = nil
local AI_ID_OFFSET = 1000

function BattleAIDataManager:GetInstance()
    if BattleAIDataManager._instance == nil then
        BattleAIDataManager._instance = BattleAIDataManager.new()
        BattleAIDataManager._instance:InitData()
    end

    return BattleAIDataManager._instance
end

function BattleAIDataManager:ResetManager()
    self.bIsObserveData = nil
end

function BattleAIDataManager:InitData()
    self._CustomAIInfoIndex = SSD_AI_CUSTOM_INDEX
    self._AIs = {}
    local tl = {}
    self.tl = {}
    self.tm = {}
    self.aoyiMap = {}
    local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()

    local TB_AoYi = TableDataManager:GetInstance():GetTable("AoYi")
    for k, v in pairs(TB_AoYi) do
        self.aoyiMap[v.AoYiID] = 1
    end

    local TB_Target = TableDataManager:GetInstance():GetTable("BattleAITarget")
    for index, data in pairs(TB_Target) do
        --if curDiff >= data.LockLevel then
            if tl[data.ClassType] == nil then
                tl[data.ClassType] = { ClassType = data.ClassType, text = GetEnumText("BattleAITargetClass", data.ClassType)}
                table.insert(self.tl, tl[data.ClassType])
            end
            data.text = GetLanguageByID(data.NameID)
            data.id = data.BaseID
            data.lock = 0
            if data.LockLevel and data.LockLevel >curDiff then
                data.lock = 1
            end
            self.tm[data.id] = data
            table.insert(tl[data.ClassType], data)
        --end
    end
    table.sort(self.tl, function(a,b)
        return a.ClassType < b.ClassType
    end)
    
    local TB_Action = TableDataManager:GetInstance():GetTable("BattleAIAction")
    local am = {}
    self.al = {}
    for index, data in pairs(TB_Action) do
        if am[data.ClassType] == nil then
            am[data.ClassType] = { ClassType = data.ClassType, text = GetEnumText("BattleAIActionClass", data.ClassType),map = {}}
            table.insert(self.al, am[data.ClassType])
        end
        data.text = GetEnumText("BattleAIActionType", data.Type)
        data.id = data.BaseID
        if data.ClassType == BattleAIActionClass.BAAC_OTHER then
            data.class = am[data.ClassType]
            table.insert(am[data.ClassType], data)
            am[data.ClassType].map[data.BaseID] = data
        end
    end

    local CCID = BattleAIActionClass.BAAC_CUSTOM_COMBO
    am[CCID] = {ClassType = CCID, text = "释放自创套路", map = {}}
    table.insert(self.al, am[CCID])
    for i = 1, 3 do
        data = {BaseID=i - 1,Type=CCID,ClassType=CCID,Filter=BattleAIMartionType.BAMT_NULL}
        data.text = "自创套路"..i
        data.id = data.BaseID
        data.class = am[CCID]
        table.insert(am[CCID], data)
        am[CCID].map[data.BaseID] = data
    end
    
    self.am = am    
    table.sort(self.al, function(a,b)
        return a.ClassType < b.ClassType
    end)
    for _, cls in ipairs(self.al) do
        table.sort(cls, function(a,b)
            return a.BaseID < b.BaseID
        end)
    end
    
    -- sort
end

function BattleAIDataManager:GetTargetList()
    local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
    for _, cls in ipairs(self.tl) do
        for i, data in ipairs(cls) do
            data.lock = 0
            if data.LockLevel and data.LockLevel > curDiff then
                data.lock = 1
            end
        end
        --当lock == 1 即选择被锁定之时 对选择框的LockLevel做一次排序 当LockLevel相等时 再使用SortValue做排序
        table.sort(cls, function(a,b)
            if a.lock == b.lock then
                if a.lock == 0 then
                    return a.SortValue < b.SortValue
                else
                    if a.LockLevel == b.LockLevel then
                        return  a.SortValue < b.SortValue
                    end
                    return a.LockLevel < b.LockLevel
                end
            end
            return a.lock < b.lock
        end)
    end
    return self.tl
end

function BattleAIDataManager:GetOpenTargetList()
    local actionList = clone(self:GetTargetList())
    return self:GetUniversalOpenList(actionList,"Target")
end

function BattleAIDataManager:GetUniversalOpenList(tab,tabType)
    local i = 1
    while i < #tab + 1 do
        if self:canAddTab(tab[i],tabType) == false then
            table.remove(tab,i)
        else
            i = i + 1
        end
    end
    return tab
end

function BattleAIDataManager:GetTargetMap(id)
    return self.tm
end

function BattleAIDataManager:GetTarget(roleID, idx, stg)
    local role = self._AIs[roleID]
    if idx and role then
        stg = stg or role.curStrategy
        if stg and role[stg] and role[stg][idx] then
            return role[stg][idx].targetID
        end
    end
end
local function clearArray(t)
    for k = #t, 1, -1 do
        t[k] = nil
    end
end

local function OwnCombo(combo, map)    
    for _, m in pairs(combo.MartialList) do
        if map[m] == nil then
            return false
        end
    end
    return true
end
local function GetJueZhaoName(data)
    for _, v in pairs(data.UnlockClauses) do
        local mi = GetTableData("MartialItem",v)
        if mi then
            local skill = GetTableData("Skill", mi.SkillID1)
            if skill then
                if skill.Type == SkillType.SkillType_juezhao then
                    return GetLanguageByID(skill.NameID)
                end
            end
        end 
    end
end

function BattleAIDataManager:UpdateRole(role)
    local TB_Combo = TableDataManager:GetInstance():GetTable("Combo")
    if role then
        local ma = self.am[BattleAIActionClass.BAAC_MARTIAL]
        local aoyi = self.am[BattleAIActionClass.BAAC_AOYI]
        local combo = self.am[BattleAIActionClass.BAAC_COMBO]
        self.am[7] = ma
        clearArray(ma)
        ma.map = {}
        clearArray(aoyi)
        aoyi.map = {}
        clearArray(combo)
        local map = {}
        local lst = MartialDataManager:GetInstance():GetRoleMartial(role) or {}
        for k, v in pairs(lst) do
            local typeID = v.uiTypeID
			if typeID then
                local dat = GetTableData("Martial",typeID)
                local tb = ma
                if self.aoyiMap[dat.BaseID] then
                    tb = aoyi
                end
                if dat.MartMovIDs and dat.MartMovIDs[1] then
                    local itm = { id = dat.BaseID, text = GetLanguageByID(dat.NameID), color = getRankColor(dat.Rank), class = tb }
                    itm.text = getRankBasedText(dat.Rank, itm.text)
                    table.insert(tb, itm)
                    tb.map[dat.BaseID] = itm
                    map[dat.BaseID] = 1
                end
			end
        end
        for k, v in pairs(TB_Combo) do            
            if OwnCombo(v, map) then
                local dat = GetTableData("Martial",v.TrigMartial)
                local itm = { id = v.BaseID, text = GetJueZhaoName(dat), color = getRankColor(dat.Rank), class = combo }
                itm.text = getRankBasedText(dat.Rank, itm.text)
                table.insert(combo, itm)
                combo.map[v.BaseID] = itm
            end
        end

        -- local RM = RoleDataManager:GetInstance()
        -- local teammates = RM:GetRoleTeammates()
        -- if teammates and teammates[idx] then
        --     local roleid = teammates[idx]
        --     local bool_InBattle = RM:CheckRoleEmbattleState(roleid)
        --     if bool_InBattle then                
        --         local s_name = RM:GetRoleTitleAndName(roleid)
                
        --         local itm = { id = dat.BaseID, text = s_name, class = tb } --color = getRankColor(dat.Rank),
        --         --itm.text = getRankBasedText(dat.Rank, itm.text)
        --         table.insert(tb, itm)
        --         tb.map[dat.BaseID] = itm                
        --     end
        -- end
    end
end

function BattleAIDataManager:GetActionList(roleID)
    self:UpdateRole(roleID)
    return self.al
end

function BattleAIDataManager:GetOpenActionList(roleID)
    local actionList = clone(self:GetActionList(roleID))
    return self:GetUniversalOpenList(actionList,"Action")
end

function BattleAIDataManager:canAddTab(tab,tabType)
	if #tab == 0 then
		return false
	end
    if tabType == "Action" then
        return true
    end
	for i = 1,#tab do
		if tab[i]["lock"] == 0 then
			return true
		end
	end
	return false
end

function BattleAIDataManager:GetActionMap(roleID)
    self:UpdateRole(roleID)
    return self.am
end

function BattleAIDataManager:GetActionText(action, actParam)
    if action == BattleAIActionClass.BAAC_AOYI or BattleAIActionClass.BAAC_MARTIAL then
        local dat = GetTableData("Martial",actParam)
        if dat then
            return getRankBasedText(dat.Rank, GetLanguageByID(dat.NameID))
        end
    elseif action == BattleAIActionClass.BAAC_COMBO then
        local v = GetTableData("Combo",actParam)
        if v then
            local dat = GetTableData("Martial",v.TrigMartial)
            if dat then
                return getRankBasedText(dat.Rank, GetJueZhaoName(dat))
            end
        end
    end
end

function BattleAIDataManager:GetActionSkill(action, actParam)
    local dat
    if action == BattleAIActionClass.BAAC_AOYI or BattleAIActionClass.BAAC_MARTIAL then
        dat = GetTableData("Martial",actParam)
    elseif action == BattleAIActionClass.BAAC_COMBO then
        local v = GetTableData("Combo",actParam)
        if v then
            dat = GetTableData("Martial",v.TrigMartial)
        end
    end
    
    if dat == nil then return nil end
    if dat.MartMovIDs then
        local mvID = dat.MartMovIDs[1]
        if mvID then
            mv = GetTableData("MartialItem",mvID)
            if mv and mv.SkillID1 then
                return GetTableData("Skill", mv.SkillID1)
            end
        end
    end
end

function BattleAIDataManager:GetTargetClass(action, actParam,selectRole)
    local dat
    if action == BattleAIActionClass.BAAC_AOYI or action == BattleAIActionClass.BAAC_MARTIAL then
        dat = GetTableData("Martial",actParam)
    elseif action == BattleAIActionClass.BAAC_COMBO then
        local v = GetTableData("Combo",actParam)
        if v then
            dat = GetTableData("Martial",v.TrigMartial)
        end
    end
    if dat == nil then return 0 end
    if selectRole and dat.DepartEnum == DepartEnumType.DET_MedicalSkill then 
        local roleData = RoleDataManager:GetInstance():GetRoleData(selectRole)
        if roleData and roleData:CureIsDemage() then 
            return 0-- 任意
        end
    elseif selectRole  then 
        local roleData = RoleDataManager:GetInstance():GetRoleData(selectRole)
        if roleData:AnqiIsCure(dat) then 
            return 0
        end
    end
    local skill
    if dat.MartMovIDs then
        local mvID = dat.MartMovIDs[1]
        if mvID then
            mv = GetTableData("MartialItem",mvID)
            if mv and mv.SkillID1 then
                skill = GetTableData("Skill", mv.SkillID1)
            end
        end
    end
    if not skill then return 0 end
    local stt = skill.TargetType
    if stt == SkillTargetType.SkillTargetType_difang or stt == SkillTargetType.SkillTargetType_biaoxingdifang then
        return 1
    end
    if stt == SkillTargetType.SkillTargetType_wofang or stt == SkillTargetType.SkillTargetType_youfang then
        return 2
    end
    return 0
end

function BattleAIDataManager:findRoleInEmBattle(roleID)
    local emBattle = RoleDataManager:GetInstance():GetRoleEmbattleInfo()
    local data = emBattle[EmBattleSchemeType.EBST_Normal][1]
    if data then
        for i = 1, #data do
            if data[i].uiRoleID == roleID then
                return true
            end
        end
    end
    return false
end

function BattleAIDataManager:CheckValid(targetID, action, actParam,selectRole)
    if targetID == nil then return false end
    local tmg = self.am[action]
    if not tmg or not tmg.map[actParam] then
        return false
    end
    local act_tp = self:GetTargetClass(action, actParam,selectRole)
    if act_tp == 0 then return true end
    local tar_tp
    if targetID >= AI_ID_OFFSET then
        if not self:findRoleInEmBattle(targetID - AI_ID_OFFSET) then
            return false
        end
        tar_tp = 2 -- friend
    else
        local tdat = GetTableData("BattleAITarget", targetID)
        if tdat == nil then return false end
        tar_tp = tdat.TargetType
    end
    return tar_tp == act_tp
end

function BattleAIDataManager:GetAction(roleID, idx, stg)
    local role = self._AIs[roleID]
    if idx and role then        
        stg = stg or role.curStrategy
        if stg then
            local ai = role[stg]
            if ai and ai[idx] then
                local data = GetTableData("BattleAIAction",ai[idx].action)
                if data and data.ClassType == BattleAIActionClass.BAAC_OTHER then
                    return ai[idx].action, BattleAIActionClass.BAAC_OTHER
                end
                return ai[idx].actionParam, ai[idx].action
            end
        end
    end
end

function BattleAIDataManager:GetRoleBattleAI(instRoleID, stg)
    if stg ~= nil then
        return self:GetRoleComboAI(instRoleID, stg)
    end
    local bFlag = false
    local curStrategy = 0
    if self._AIs[instRoleID] == nil then 
        bFlag = true
    else
        local info = self._AIs[instRoleID]
        curStrategy = info.curStrategy
        if curStrategy == nil or info[curStrategy] == nil then 
            bFlag = true
        end
    end
    if bFlag then 
        self:QueryServerAI(instRoleID,curStrategy)
        if DEBUG_MODE then
            SystemUICall:GetInstance():Toast("从服务端请求数据:角色ID:" .. instRoleID)
        end
        return
    end
    local info = self._AIs[instRoleID]
    curStrategy = info.curStrategy
    return info[curStrategy], curStrategy
end

function BattleAIDataManager:GetRoleComboAI(instRoleID, stg)   
    local info = self._AIs[instRoleID] 
    if info == nil then
        self:GetRoleBattleAI(instRoleID)
        self:QueryServerAI(instRoleID,stg)
        return
    end
    if info[stg] == nil then
        self:QueryServerAI(instRoleID,stg)
        info[stg] = {}
        return
    end
    return info[stg], 1
end

function BattleAIDataManager:GetRoleBattleStrategy(instRoleID)
    if instRoleID==nil then return "无" end    
    local info = self._AIs[instRoleID]
    local st = 1
    if info and info.curStrategy then
        st = info.curStrategy
    else
        self:GetRoleBattleAI(instRoleID) -- query
    end
    local options, data = self:GetOptions()
    -- derror('xxxxx', instRoleID, data, st, info)
    local str = ''
    if st == self._CustomAIInfoIndex then 
        str = self._customStr
    else
        if data and data[st] then
            str = GetLanguageByID(data[st].NameID)
        end
    end
    str = string.gsub(str, '【', '')
    str = string.gsub(str, '】', '')
    return str
end


local function cloneAI(ai, dst)
    if ai == dst then return end
    for i=1,SSD_AI_LIST_NUM do
        if ai[i] then 
            dst[i] = {
            ['targetID'] = ai[i].targetID or 0,
            ['action'] = ai[i].action or 0,
            ['actionParam'] = ai[i].actionParam  or 0
            }
        else
            dst[i] = nil
        end
    end
end

function BattleAIDataManager:AIItemSize(roleID, stg)
    local role = self._AIs[roleID]
    if role then
        stg = stg or self._CustomAIInfoIndex
        local ai = role[stg]
        if ai == nil then return 0 end
        return #ai
        --local edit_ai = role[self._CustomAIInfoIndex]
	    --return #edit_ai
    end
    return 0
end
function BattleAIDataManager:CheckCloneAI(roleID, stg)
    stg = stg or self._CustomAIInfoIndex
    local role = self._AIs[roleID]
    local ret = role[stg]
    if stg ~= self._CustomAIInfoIndex then return ret end
    local strategy = role.curStrategy
    local ai = role[strategy]
    if ai == nil then return ret end
    local edit_ai = role[self._CustomAIInfoIndex]
    cloneAI(ai, edit_ai)
    role.curStrategy = self._CustomAIInfoIndex
    return ret
end

function BattleAIDataManager:AddAI(roleID, idx, stg)
    --derror(roleID, idx, stg, ')))))')
    local role = self._AIs[roleID]
    if role then
        local edit_ai = self:CheckCloneAI(roleID, stg)        
        for i = #edit_ai, idx + 1, -1  do
            edit_ai[i + 1] = edit_ai[i]
        end
        edit_ai[idx + 1] = {}
        local ea = edit_ai[idx + 1]
        ea.targetID, ea.action, ea.actionParam = 2,6,0

        edit_ai.dirty = true
        return true
    end
end

function BattleAIDataManager:DelAI(roleID, idx, stg)
    local role = self._AIs[roleID]
    if role then
        local edit_ai = self:CheckCloneAI(roleID, stg)   
        for i = idx + 1, #edit_ai do
            edit_ai[i - 1] = edit_ai[i]
        end
        edit_ai[#edit_ai] = nil        
        edit_ai.dirty = true
        return true
    end
end

local function checkWrite(ai, edit_ai, idx, key, v)
    local itm = ai[idx]
    local src
    if itm then
        src = itm[key]
    end
    if v and src ~= v then
        cloneAI(ai, edit_ai)
        edit_ai[idx] = edit_ai[idx] or {}
        edit_ai[idx][key] = v
        return true
    end
end

function BattleAIDataManager:UpdateAI(roleID, idx, tar, act_cls, act, stg)
    local role = self._AIs[roleID]
    if role then 
        stg = stg or self._CustomAIInfoIndex
        local ai = role[role.curStrategy]
        if stg ~= self._CustomAIInfoIndex then
            ai = role[stg]
        end
        if ai == nil then return end
        if idx == nil then return end
        local edit_ai = role[stg]
        if act_cls == BattleAIActionClass.BAAC_OTHER then
            act_cls = act
            act = 0
        end
        local changed = checkWrite(ai, edit_ai, idx, 'targetID', tar)
        changed = checkWrite(ai, edit_ai, idx, 'action', act_cls) or changed
        changed = checkWrite(ai, edit_ai, idx, 'actionParam', act) or changed
        edit_ai.dirty = changed
        if changed and stg == self._CustomAIInfoIndex then
            role.curStrategy = self._CustomAIInfoIndex
        end
        return changed
    end
end

-- function BattleAIDataManager:WriteCustomAIInfo(roleID,iIndex)
--     if iIndex == self._CustomAIInfoIndex then return end
--     if self._AIs[roleID] and self._AIs[roleID][iIndex] then 
--         local ais = self._AIs[roleID]
--         local ai = ais[iIndex]
--         ais[self._CustomAIInfoIndex] = {}
--         local dst = ais[self._CustomAIInfoIndex]
--         for i=1,SSD_AI_LIST_NUM do
--             if ai[i] then 
--                 dst[i] = {
--                 ['targetID'] = ai[i].targetID or 0,
--                 ['action'] = ai[i].action or 0,
--                 ['actionParam'] = ai[i].actionParam  or 0
--                 }
--             end
--         end
--         self._AIs[roleID].dirty = true
--     end
-- end

function BattleAIDataManager:SwapAI(roleID, idx1, idx2, stg)
    local role = self._AIs[roleID]
    if role then
        local edit_ai = self:CheckCloneAI(roleID, stg)
        edit_ai[idx1], edit_ai[idx2] = edit_ai[idx2], edit_ai[idx1]
        edit_ai.dirty = true
    end
end

function BattleAIDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_BATTLEAI_DATA")
end

function BattleAIDataManager:QueryServerAI(instRoleID,iIndex)
    local data = EncodeSendSeGC_Click_AIInfo(instRoleID,iIndex or 0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_AIINFO,iSize,data)
end

function BattleAIDataManager:MartialIDMap(AIIinfo)
    if AIIinfo == nil then return 0 end
    local ret = ((AIIinfo.targetID or 0) << 24) | ((AIIinfo.action or 0) << 16) | (AIIinfo.actionParam or 0)
    -- derror(string.format("make id %x", ret))
    return ret
end

function BattleAIDataManager:MartialIDMapDecode(AINum)
    local targetID = (AINum & 0xffffffffff000000) >> 24
    local action = (AINum & 0x00ff0000) >> 16
    local actionParam = (AINum & 0x0000ffff)
    return {
        ['targetID'] = targetID,
        ['action'] = action,
        ['actionParam'] = actionParam,
    }
end

function BattleAIDataManager:UploadServerAIInfo(instRoleID, stg)
    if instRoleID == nil or self._AIs[instRoleID] == nil then return end    
    local role = self._AIs[instRoleID]
    if stg == nil then
        stg = role.curStrategy
    end
    if role[stg] == nil then return end
    if not role[stg].dirty and not role.curDirty then return end
    local actionList = {}
    local iNum = 0
    if stg >= self._CustomAIInfoIndex then
        local ais = role[stg]
        for i=1,SSD_AI_LIST_NUM do
            if ais[i] then 
                actionList[iNum] = self:MartialIDMap(ais[i])
                iNum = iNum + 1
            end
        end
    end
    role[stg].dirty = false
    role.curDirty = false
    --derror('$$$$$$$$$$', stg)
    local data = EncodeSendSeGC_Click_UploadAIInfo(instRoleID,stg,iNum,actionList)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_UPLOAD_AIINFO,iSize,data)
    if DEBUG_MODE then
        SystemUICall:GetInstance():Toast("向服务端上传数据:角色ID:" .. instRoleID)
    end
end

function BattleAIDataManager:ReviceServerAI(retStream)
    local uiRoleID = retStream.uiRoleID
    self._AIs[uiRoleID] = self._AIs[uiRoleID] or {}
    -- 改成数组
    local stg = retStream.curStrategy
    local olddirty 
    if self._AIs[uiRoleID][stg] then
        olddirty = self._AIs[uiRoleID][stg].dirty
    end
    self._AIs[uiRoleID][stg] = {dirty = olddirty}
    self._AIs[uiRoleID][self._CustomAIInfoIndex] = self._AIs[uiRoleID][self._CustomAIInfoIndex] or {}
    local ai = self._AIs[uiRoleID][stg]
    -- derror('----------------------------------')
    for i=0,retStream.iNum-1 do
        ai[i+1] = self:MartialIDMapDecode(retStream.actionList[i])
        -- derror(i, ai[i + 1].targetID,ai[i + 1].action,ai[i + 1].actionParam)
    end
    -- derror('+++++++++++++++++++++', uiRoleID, stg, ai[retStream.iNum + 1])
    if stg <= self._CustomAIInfoIndex then
        if stg == 0 then stg = 1 end
        self._AIs[uiRoleID].curStrategy = stg
    end
    self:DispatchUpdateEvent()
end

function BattleAIDataManager:ClearAIInfo(roleID)
    if self._AIs and roleID then 
        local role = self._AIs[roleID]
        if role then
            role[role.curStrategy] = nil
            for k = 0,3 do
               local stg = self._CustomAIInfoIndex + k
               role[stg] = nil
            end
        end
    end
end

function BattleAIDataManager:Clear()
    self._AIs = {}
end

function BattleAIDataManager:GetOptions()
    local BattleAITemplate = TableDataManager:GetInstance():GetTable("BattleAITemplate")
    local options = {}
    local data = {}
    local dorpdowndata = CS.UnityEngine.UI.Dropdown.OptionData
	for i=1,#BattleAITemplate do
        table.insert(options,dorpdowndata(GetLanguageByID(BattleAITemplate[i].NameID)))
        table.insert(data,BattleAITemplate[i])
    end
    self._templateCount = #options
    self._customStr = "【自定义】"
    table.insert(options,dorpdowndata(self._customStr))
    self._customIndex = #options
    return options,data
end
function BattleAIDataManager:ChangeIndex(roleID, index)
    local role = self._AIs[roleID]
    if role == nil then return end
    local strategy = index
    if self._customIndex == index then 
        strategy = self._CustomAIInfoIndex
    end
    if role.curStrategy ~= strategy then
        if strategy == self._CustomAIInfoIndex then            
            local ai = role[role.curStrategy]
            edit_ai = role[self._CustomAIInfoIndex]
            cloneAI(ai, edit_ai)
        end
        role.curStrategy = strategy
        role.curDirty = true
    end
end

function BattleAIDataManager:GetCurIndex(roleID)
    if self._AIs[roleID] then 
        local ans = self._AIs[roleID].curStrategy or 1
        if ans == self._CustomAIInfoIndex then 
            ans = self._customIndex
        end
        return ans
    end
    return 1
end

function BattleAIDataManager:GetCustomTemplateIndex()
    return self._customIndex
end