BattleDataManager = class("BattleDataManager")
BattleDataManager._instance = nil

function BattleDataManager:GetInstance()
    if BattleDataManager._instance == nil then
        BattleDataManager._instance = BattleDataManager.new()
    end

    return BattleDataManager._instance
end

function BattleDataManager:ResetManager()
    self.roundDetail = nil
    self.comboInfo = nil
    self.bBattleEndFlag = nil
end

function BattleDataManager:GetTreasureBoxesDataByGrid(x,y)
    if not x or not y then
        derror('传入无效位置数据')
        return nil
    end

    local TreasureBoxes = globalDataPool:getData("BattleTreasureBoxes")

    if not TreasureBoxes or not TreasureBoxes['boxes'] then
        return nil
    end
    
    return TreasureBoxes['boxes'][x << 16 | y]
end

function BattleDataManager:GetDropInfo(dropData)
    if not dropData then return end
    local reward = {} 
   
    reward.name = ""
    reward.icon = ""
    if dropData.eType == DropTypeDef.DropType_Item then
        local tbl_item = TableDataManager:GetInstance():GetTableData("Item",dropData.uiItemID)
        if tbl_item then
            reward.nameID = dropData.uiItemID
            reward.name = getRankBasedText(tbl_item.Rank, tbl_item.ItemName or '') or ""
            reward.icon = tbl_item.Icon or ""
        end
    elseif dropData.eType == DropTypeDef.DropType_MartialBook then
        local tbl_martial = GetTableData("Martial",dropData.uiItemID)
        if tbl_martial then
            reward.name = tbl_martial and getRankBasedText(tbl_martial.Rank,GetLanguageByID(tbl_martial.NameID)) or ""
            --待确定是否所有武学秘籍显示同一个icon
        end
    elseif dropData.eType == DropTypeDef.DropType_Coin then
        reward.nameID = 1301
    elseif dropData.eType == DropTypeDef.DropType_MartialPage then
        --todo等策划理出残章规则
    elseif dropData.eType == DropTypeDef.DropType_RoleAttr then
        reward.name = GetLanguageByEnum(dropData.uiItemID)
    end
    reward.num = dropData.uiNums
    
    return reward
end

function BattleDataManager:GetAwardInfos(num,awards)
    if num == nil then return end
    local infos = {}
    for i = 0,num do 
        local info = self:GetDropInfo(awards[i])
        if info then
            table.insert(infos,info)
        end  
    end
    return infos
end

function BattleDataManager:SetBattleEndFlag(bEnd)
    self.bBattleEndFlag = bEnd or false 
end
function BattleDataManager:GetBattleEndFlag()
    return self.bBattleEndFlag 
end

function BattleDataManager:GetTreasureBoxSpinePath(id)
    if not id then return "" end
    local path
    local tbl_TreasureBox = TableDataManager:GetInstance():GetTableData("TreasureBox",id)
    if tbl_TreasureBox == nil then
        tbl_TreasureBox = TableDataManager:GetInstance():GetTableData("TreasureBox",1)
    end
    path = tbl_TreasureBox.Model
    return path or  ""
end

function BattleDataManager:GetTreasureBoxModelID(id)
    if not id then return "" end
    local modelID
    local tbl_TreasureBox = TableDataManager:GetInstance():GetTableData("TreasureBox",id)
    if tbl_TreasureBox == nil then
        tbl_TreasureBox = TableDataManager:GetInstance():GetTableData("TreasureBox",1)
    end
    modelID = tbl_TreasureBox.ModelID
    return modelID or 1
end


--初始化回合提示信息
function BattleDataManager:Init()
    self:InitRoundDescTips()
    self.wuyueInfo = {}
end

--初始化回合提示信息
function BattleDataManager:InitRoundDescTips()
    self.roundDetail = {}
    self.roundDetail.win = {}
    self.roundDetail.fail = {}
    self.roundDetail.extra = {}
    self.roundDetail.other = {}
    table.insert(self.roundDetail.win, '20回合内击倒全部敌人');
    table.insert(self.roundDetail.fail, '我方全体角色被击倒');
end

function BattleDataManager:clearRoundDescTips()
    self.roundDetail = nil
end

--获取回合提示信息
function BattleDataManager:GetRoundDescTips()
    local tips = {}
    --tips.title = "<size=28>战斗信息</size>"
    tips.title = "战斗信息"
    local t = {};

    local fun = function(t,list)
        for int_i = 1, #list do
            local value = list[int_i]
            --table.insert(t,"<size=26>" .. value..'</size>\n')
            table.insert(t, value..'\n')
        end
    end

    if self.roundDetail.win and #self.roundDetail.win > 0 then
        --table.insert(t, '<color=green><size=24>胜利条件</size></color>\n')
        table.insert(t, '<color=green>胜利条件</color>\n')
        fun(t,self.roundDetail.win)
    end
    if self.roundDetail.fail and #self.roundDetail.fail > 0 then
        --table.insert(t, '<color=red><size=24>失败条件</size></color>\n')
        table.insert(t, '<color=red>失败条件</color>\n')
        fun(t,self.roundDetail.fail)
    end
    if self.roundDetail.extra and #self.roundDetail.extra > 0 then
        --table.insert(t, '<color=green><size=24>额外条件</size></color>\n')
        table.insert(t, '<color=green>额外条件</color>\n')
        fun(t,self.roundDetail.extra)
    end

    if self.roundDetail.other and #self.roundDetail.other > 0 then
        for int_i=1,#self.roundDetail.other do
            --table.insert(t, '<color=green><size=24>'..self.roundDetail.other[int_i][1]..'</size></color>\n')
            table.insert(t, '<color=green>'..self.roundDetail.other[int_i][1]..'</color>\n')
            fun(t,self.roundDetail.other[int_i][2])
        end
    end

    tips.content = table.concat(t, "")
    return tips
end

--添加回合提示信息
--type win fail extra
function BattleDataManager:AddRoundDescTipsInfo(descList,type)
    if self.roundDetail == nil then return end
    local tb = self.roundDetail[type]
    if not tb or #descList < 1 then
        return
    end

    local list = {}
    if type == 'other' then
        for int_i=1, #tb do
            list[tb[int_i][1]] = int_i
        end
    end

    for int_i=1,#descList do
        if type == 'other' then
            local idx = list[descList[int_i][1]]
            if idx then
                tb[idx] = descList[int_i]
            else
                tb[#tb+1] = descList[int_i]
            end
        else
            tb[#tb+1] = descList[int_i]
        end
    end
end

function BattleDataManager:SaveWuYueInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo then
        self.wuyueInfo = self.wuyueInfo or {}
        table.insert(self.wuyueInfo,SeBattle_HurtInfo)
    end
end

function BattleDataManager:GetWuYueInfo()
    return self.wuyueInfo or {}
end

function BattleDataManager:ClearWuYueInfo()
    self.wuyueInfo = {}
end

function BattleDataManager:GetBattleMemberList(battleBaseID)
    local memberList = {}
    local battleData = TableDataManager:GetInstance():GetTableData("Battle", battleBaseID)
    if battleData then 
        local battlePosID = battleData.ArrayID
        local embattleID = battleData.ArrayFargID
        local battlePosData = TableDataManager:GetInstance():GetTableData("BattlePos", battlePosID)
        local embattleData = TableDataManager:GetInstance():GetTableData("Embattle", embattleID)
        if battlePosData then 
            memberList = battlePosData.showname or {}
        elseif embattleData then
            if embattleData.BOSS ~= nil and #embattleData.BOSS > 0 then 
                memberList = embattleData.BOSS or {}
            elseif embattleData.RoleData ~= nil and #embattleData.RoleData > 0 then
                for _, embattleRoleData in ipairs(embattleData.RoleData) do 
                    local roleID = embattleRoleData.ID
                    if roleID ~= nil then 
                        table.insert(memberList, roleID)
                    end
                end
            end
        end
    end
    return memberList
end

function BattleDataManager:AddBattleMemberList(battleBaseID, memberList,aiMemberList)
    local battleData = TableDataManager:GetInstance():GetTableData("Battle", battleBaseID)
    if battleData then 
        local battlePosID = battleData.ArrayID
        local embattleID = battleData.ArrayFargID
        local battlePosData = TableDataManager:GetInstance():GetTableData("BattlePos", battlePosID)
        local embattleData = TableDataManager:GetInstance():GetTableData("Embattle", embattleID)
        if battlePosData then 
            for _, roleID in ipairs(battlePosData.showname or {}) do 
                if roleID ~= nil and not aiMemberList[roleID] then 
                    table.insert(memberList, roleID)
                    aiMemberList[roleID] = true
                end
            end
        elseif embattleData then
            if embattleData.BOSS ~= nil and #embattleData.BOSS > 0 then 
                for _, roleID in ipairs(embattleData.BOSS or {}) do 
                    if roleID ~= nil and not aiMemberList[roleID] then 
                        table.insert(memberList, roleID)
                        aiMemberList[roleID] = true
                    end
                end
            elseif embattleData.RoleData ~= nil and #embattleData.RoleData > 0 then
                for _, embattleRoleData in ipairs(embattleData.RoleData) do 
                    local roleID = embattleRoleData.ID
                    if roleID ~= nil and not aiMemberList[roleID] then 
                        table.insert(memberList, roleID)
                        aiMemberList[roleID] = true
                    end
                end
            end
        end
    end
    return memberList
end

return BattleDataManager