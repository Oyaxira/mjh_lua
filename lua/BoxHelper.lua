BoxHelper = {}

-- 获取Box列表
-- root => (box1、box2、box3……)
function BoxHelper.GetBoxList(boxClass, root, formatKey, startIndex, param)
    local boxList = {}

    if root == nil then
        return boxList
    end

    local index = startIndex or 1
    while true do
        local node = root:FindChild(string.format(formatKey, index))

        if not node then
            break
        end

        boxList[index] = boxClass.new(node, param)
        index = index + 1
    end

    return boxList
end

-- 获取GameObject列表
-- TODO: 如果有UIHelper，最好写在UIHelper里
function BoxHelper.GetNodeList(root, formatKey, startIndex)
    local nodeList = {}

    if root == nil then
        return nodeList
    end

    local index = startIndex or 1
    while true do
        local node = root:FindChild(string.format(formatKey, index))

        if not node then
            break
        end

        nodeList[index] = node
        index = index + 1
    end

    return nodeList
end
function BoxHelper.ForeachNode(root, formatKey, callback, startIndex)
    if root == nil then
        return
    end

    local index = startIndex or 1
    while true do
        local node = root:FindChild(string.format(formatKey, index))

        if not node then
            break
        end

        callback(index, node)
        index = index + 1
    end
end

-- 获取Component列表
-- TODO: 如果有UIHelper，最好写在UIHelper里
function BoxHelper.GetComponentList(component, root, formatKey, startIndex)
    local componentList = {}

    if root == nil then
        return componentList
    end

    local index = startIndex or 1
    while true do
        local component = root:FindChildComponent(string.format(formatKey, index), component)

        if not component then
            break
        end

        componentList[index] = component
        index = index + 1
    end

    return componentList
end
function BoxHelper.ForeachComponent(component, root, formatKey, callback, startIndex)
    if root == nil then
        return
    end

    local index = startIndex or 1
    while true do
        local component = root:FindChildComponent(string.format(formatKey, index), component)

        if not component then
            break
        end

        callback(index, component)
        index = index + 1
    end
end

return BoxHelper
