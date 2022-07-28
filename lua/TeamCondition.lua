TeamCondition = class("TeamCondition")

TeamCondition._instance = nil

--[[函数定义 Start]]

local function CT_TRUE(params)
    return true
end

local function CT_FALSE(params)
    return false
end

local function CT_COMPARE_OVERLAYLEVEL(params)
    local roleTypeID = tonumber(params[1])
    local lv = tonumber(params[2])
    local roleID = RoleDataManager:GetInstance():GetRoleID(roleTypeID)
    local curLV = RoleDataManager:GetInstance():GetRoleOverlayLevel(roleID)
    return curLV >= lv, "角色修行等级" .. lv
end
--[[函数定义 End]]

function TeamCondition:ctor() 
    self.funcMaps = {}
    self.funcMaps[ConditionType.CT_TRUE] = CT_TRUE
    self.funcMaps[ConditionType.CT_FALSE] = CT_FALSE
    self.funcMaps[ConditionType.CT_COMPARE_OVERLAYLEVEL] = CT_COMPARE_OVERLAYLEVEL
end

function TeamCondition:GetInstance()
    if TeamCondition._instance == nil then
        TeamCondition._instance = TeamCondition.new()
    end
    return TeamCondition._instance
end

function TeamCondition:CheckTeamCondition(uiConditionTypeID, noFindValue)
    local data = TableDataManager:GetInstance():GetTableData("Condition",uiConditionTypeID)
    if data and data.CondType then
        local func = self.funcMaps[data.CondType]
        if func then
            local params = {}
            for i=1, 16 do
                local keyStr = "CondArg" .. tostring(i)
                params[#params + 1] = data[keyStr]
            end
            local resoult, des = func(params) 
            return resoult, des
        else
            return noFindValue
        end
    else
        return noFindValue
    end
end

function TeamCondition:Clear()

end

function TeamCondition:OnDestroy()

end