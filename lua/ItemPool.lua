ItemPool = class('ItemPool')

function ItemPool:ctor()
    self.akItemUIClass = {}
end

function ItemPool:Push(kItemTypeData, iNum, kTransParent, showName)
    if not (kItemTypeData and kTransParent and self.akItemUIClass) then
        return
    end

    local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent.transform)
    local iNum = iNum or 0
    kIconBindData:UpdateUIWithItemTypeData(kItemTypeData)
    kIconBindData:SetItemNum(iNum, iNum == 1)

    if showName then
        kIconBindData:ShowExtraName(true)
    end

    self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
    return kIconBindData
end

function ItemPool:PushIcon(icon, name, tip, kTransParent)
    local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent.transform)

    kIconBindData:UpdateUIWithIconData(icon, name, tip)

    self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
    return kIconBindData
end

function ItemPool:PushRole(roleID, kTransParent)
    local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID)
    local roleArtData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleID, true)

    if roleData and roleArtData then
        local kIconBindData =
            LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent.transform)

        kIconBindData:UpdateUIWithRoleData(roleID, roleArtData.Head, GetLanguageByID(roleData.NameID))

        self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
        return kIconBindData
    end

    return nil
end

function ItemPool:Put(kUIClass)
    if not (self.akItemUIClass) then
        return
    end

    for index, value in pairs(self.akItemUIClass) do
        if value == kUIClass then
            table.remove(self.akItemUIClass, index)
            LuaClassFactory:GetInstance():ReturnUIClass(kUIClass)
            return
        end
    end
end

function ItemPool:Clear()
    if self.akItemUIClass and (#self.akItemUIClass > 0) then
        LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
        self.akItemUIClass = {}
    end
end

return ItemPool
