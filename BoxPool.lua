-- Box对象池
BoxPool = class("BoxPool")

-- 检查销毁时间（单位: 秒）
CHECK_TIME = 30

-- TODO: 看看能不能直接走ResourceManager
-- TODO: 会报WARNING Specified object is not a pooled instance: RoleBox29
local PoolParent = CS.SG.ResourceManager.Instance.transform

function BoxPool:ctor()
    self.mUseList = {}
    self.mUnUseList = {}

    self.mCheckTime = os.time()
end

-- 获取对象
function BoxPool:Get(boxClass, parent)
    local box = nil
    local length = #self.mUnUseList
    if length > 0 then
        -- 对象池里有，直接取（从最后一个开始取，性能好点）
        box = self.mUnUseList[length]
        table.remove(self.mUnUseList, length)

        -- 防止父级被销毁导致的出错
        -- TODO: 加个warn日志
        if box.Root == nil then
            return self:Get(boxClass, parent)
        end
    else
        -- 对象池没有，则新建
        box = boxClass.new()
    end

    if box then
        table.insert(self.mUseList, box)
        box:SetParent(parent)
        box:SetActive(true)
        box.Root.transform.localPosition = DRCSRef.Vec3Zero
        box.Root.transform.localScale = DRCSRef.Vec3One
        return box
    end

    return nil
end

-- 回收使用对象
function BoxPool:Put(box)
    for i = #self.mUseList, 1, -1 do
        if self.mUseList[i] == box then
            table.remove(self.mUseList, i)
            Recover(self, box)
            break
        end
    end
end

-- 清空使用对象
function BoxPool:Clear()
    for i, box in pairs(self.mUseList) do
        Recover(self, box)
    end
    self.mUseList = {}
end

function BoxPool:Dispose()
    for i, box in pairs(self.mUseList) do
        box:Dispose()
    end
    self.mUseList = {}

    for i, box in pairs(self.mUnUseList) do
        box:Dispose()
    end
    self.mUnUseList = {}
end

-- 销毁未使用的对象
function BoxPool:Update()
    local now = os.time()
    if now - self.mCheckTime < CHECK_TIME then
        return
    end

    self.mCheckTime = now
    for i = #self.mUnUseList, 1, -1 do
        local unUseBox = self.mUnUseList[i]
        if unUseBox.Time and now - unUseBox.Time >= UPDATE_UNLOAD_CLASS then
            table.remove(self.mUnUseList, i)
            unUseBox:Dispose()
            unUseBox = nil
            break
        end
    end
end

-- TODO: 目前class好像没有提供private，等以后有了可以改成private
function Recover(self, box)
    box:RecordTime()
    box:ReturnToPool()
    table.insert(self.mUnUseList, box)
end

return BoxPool
