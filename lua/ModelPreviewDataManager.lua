ModelPreviewDataManager = class("ModelPreviewDataManager")
ModelPreviewDataManager._instance = nil

function ModelPreviewDataManager:ctor()

end

function ModelPreviewDataManager:GetInstance()
    if ModelPreviewDataManager._instance == nil then
        ModelPreviewDataManager._instance = ModelPreviewDataManager.new()
        ModelPreviewDataManager._instance:Init()
    end

    return ModelPreviewDataManager._instance
end

function ModelPreviewDataManager:Init()
    self:SetRoleModelData()
    self:SetWeaponData()
    self:SetBattleBG()
end

function ModelPreviewDataManager:SetRoleModelData()
    local Local_TB_RoleModel = reloadModule("Data/ResourceRoleModel")
    --所有模型路径一样的 作为一类，贴图作为换肤
    local modelData = {}
    for _,value in pairs(Local_TB_RoleModel) do
        if value and value["ModelPath"] then
            local sModelPath = value["ModelPath"]
            if modelData[sModelPath] == nil then
                modelData[sModelPath] = {}
            end
            local kStr= string.split(value.Texture,"/")
            if kStr[3] == sModelPath then
                table.insert(modelData[sModelPath],1,value)
            else
                table.insert(modelData[sModelPath],value)
            end
        end
    end

    self.RoleModelData = {}
    for key, value in pairs(modelData) do
        self.RoleModelData[#self.RoleModelData + 1] = value
    end
end

function ModelPreviewDataManager:SetWeaponData()
    if not self.WeaponData then
        self.WeaponData = {}
    end
    self.WeaponData[0] = {}
    
    local weaponType = {
        [ItemTypeDetail.ItemType_Knife] = 1,
        [ItemTypeDetail.ItemType_Sword] = 1,
        [ItemTypeDetail.ItemType_Fist] = 1,
        [ItemTypeDetail.ItemType_Rod] = 1,
        [ItemTypeDetail.ItemType_Whip] = 1,
        [ItemTypeDetail.ItemType_Cane] = 1,
        [ItemTypeDetail.ItemType_NeedleBox] = 1,
        [ItemTypeDetail.ItemType_Fan] = 1,
        [ItemTypeDetail.ItemType_HiddenWeapon] = 1,
    }

    local TB_Item = TableDataManager:GetInstance():GetTable("Item")
    for _,value in pairs(TB_Item) do
        local type = value.ItemType
        if weaponType[type] == 1 then
            if self.WeaponData[type] == nil then
                self.WeaponData[type] = {}
            end
            table.insert(self.WeaponData[0],value)
            table.insert(self.WeaponData[type],value)
        end
    end  
end

function ModelPreviewDataManager:SetBattleBG()
    local kData = reloadModule("Data/Battle")
    self.BGData = {}

    local tempBG = {}
    for key, value in pairs(kData) do
        if value and value.Layout then
            tempBG[value.Layout] = 1
        end
    end

    for key, value in pairs(tempBG) do
        self.BGData[#self.BGData + 1] = key
    end
end

function ModelPreviewDataManager:CheckWeaponPath(path)
    if not path or path == "" then
        return false
    end
    
    local _,t= string.find(path,'^ItemIcon/')
    if not t then
        return false
    end
    return true
end

function ModelPreviewDataManager:GetRoleModelData()
    return self.RoleModelData
end

function ModelPreviewDataManager:GetWeaponData()
    return self.WeaponData
end

function ModelPreviewDataManager:GetBattleBG()
    return self.BGData
end


return ModelPreviewDataManager