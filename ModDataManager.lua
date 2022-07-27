ModDataManager = class("ModDataManager")
ModDataManager._instance = nil

function ModDataManager:ctor()
    
end

function ModDataManager:GetInstance()
    if ModDataManager._instance == nil then
        ModDataManager._instance = ModDataManager.new()
        ModDataManager:Init()
    end

    return ModDataManager._instance
end

function ModDataManager:Init()
    self:SetRoleModelData()
    --self:SetWeaponData()
end

function ModDataManager:SetRoleModelData()
    if not self.RoleModelData then
        self.RoleModelData = {}
    end

    --简单处理，后面优化
    if #self.RoleModelData <= 0 then
        local temp = {}
        local m = {}
        local Local_TB_RoleModel = TableDataManager:GetInstance():GetTable("RoleModel")
        for _,value in pairs(Local_TB_RoleModel) do
            if value and value.Model and string.sub(value.Model,0, 1) == "r" and value.Head and value.Head ~= "" then
                if not temp[value.Model] then
                    temp[value.Model] = {}
		    table.insert(m, value.Model)
                end
                table.insert(temp[value.Model],value)
            end
        end

        local num = 1
        for _,model in ipairs(m) do
            if not self.RoleModelData[num] then
                self.RoleModelData[num] = {}
            end
            self.RoleModelData[num] = temp[model]
            num = num + 1
        end
    end
end


function ModDataManager:GetRoleModelData()
    return self.RoleModelData
end

function ModDataManager:OnDestroy()
    self.RoleModelData = nil
end

return ModDataManager