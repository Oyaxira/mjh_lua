-- Box对象池管理器
-- WARNING: 单纯的GameObject对象池不需要用到这个
-- TODO: 望后来者使用该接口重构代码
BoxPoolManager = class("BoxPoolManager")
BoxPool = require("Base/Box/BoxPool")

local sInstance = nil
function BoxPoolManager:GetInstance()
    if sInstance == nil then
        sInstance = BoxPoolManager.new()
    end
    return sInstance
end

function BoxPoolManager:ctor()
    self.mKeyToPool = {}
end

function BoxPoolManager:Get(key, boxClass, parent)
    if self.mKeyToPool[key] == nil then
        self.mKeyToPool[key] = BoxPool.new()
    end

    return self.mKeyToPool[key]:Get(boxClass, parent)
end

function BoxPoolManager:Put(key, box)
    if self.mKeyToPool[key] == nil then
        return
    end

    return self.mKeyToPool[key]:Put(box)
end

function BoxPoolManager:Clear(key)
    if self.mKeyToPool[key] == nil then
        return
    end

    return self.mKeyToPool[key]:Clear()
end

function BoxPoolManager:Dispose()
    for key, pool in pairs(self.mKeyToPool) do
        pool:Dispose()
    end
    self.mKeyToPool = {}
end

-- TODO: 暂未调用（因为本例单纯为掌门对决使用的对象，不需要销毁，望后来者可以使用该接口重构代码）
function BoxPoolManager:Update()
    for key, pool in pairs(self.mKeyToPool) do
        pool:Update()
    end
end

return BoxPoolManager
