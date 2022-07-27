WindowOrderManager = class("WindowOrderManager")
WindowOrderManager._instance = nil

function WindowOrderManager:GetInstance()
    if WindowOrderManager._instance == nil then
        WindowOrderManager._instance = WindowOrderManager.new()
        WindowOrderManager._instance:Init()
    end

    return WindowOrderManager._instance
end

function WindowOrderManager:InitData()
    self.orderInfoMap = {}
    self.orderInfoMap["NavigationUI"] = 10
    self.orderInfoMap["ToptitleUI"] = 10
    self.orderInfoMap["TaskTipsUI"] = 10
    self.orderInfoMap["CityRoleListUI"] = 10
    self.orderInfoMap["BlackBackgroundUI"] = 20
end

function WindowOrderManager:Init()
    self:InitData()

    self.updateCache = {}

    local temp = {}
    for name, value in pairs(self.orderInfoMap) do
        temp[name..'(Clone)'] = value
    end
    self.orderInfoMap = temp
end

function WindowOrderManager:UpdateOrder(objLayer)
    if objLayer then
        self.updateCache[objLayer] = true
    end
end

function WindowOrderManager:LateUpdate()
    for objLayer, v in pairs(self.updateCache) do
        if objLayer then
            self:DoUpdateOrder(objLayer)
        end
    end

    self.updateCache = {}
end

function WindowOrderManager:DoUpdateOrder(objLayer)
    if not objLayer then
        return
    end

    local objLayer_Transform = objLayer:GetComponent('RectTransform')
    local oldIndexList = {}
    local windowDataList = {}

    for index = 0, objLayer_Transform.childCount - 1 do
        local objWindow_Transform = objLayer_Transform:GetChild(index)
        local objectName = objWindow_Transform.name
        if self.orderInfoMap[objectName] then
            local windowData = { name = objectName, objTransform = objWindow_Transform, oldIndex = index, order = self.orderInfoMap[objectName] }
            table.insert(oldIndexList, index)
            table.insert(windowDataList, windowData)
        end
    end

    -- 需要稳定排序
    for i = 1, #windowDataList - 1 do
        local sel = i
        for j = i + 1, #windowDataList do
            if windowDataList[j].order < windowDataList[sel].order then
                sel = j
            end
        end

        if sel ~= i then
            local temp = windowDataList[i]
            windowDataList[i] = windowDataList[sel]
            windowDataList[sel] = temp
        end
    end

    -- 调整次序改变了的window
    for index = 1, #windowDataList do
        if oldIndexList[index] ~= windowDataList[index].oldIndex then
            windowDataList[index].objTransform:SetSiblingIndex(oldIndexList[index])
        end
    end
end