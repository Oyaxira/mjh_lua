LuaEventDispatcher = {
    _listeners_ = {},
}

function LuaEventDispatcher:addEventListener(eventName, listener, target, dontDestory, isTriggerOnce)
    if self._listeners_[eventName] == nil then
        self._listeners_[eventName] = {}
    end

    for i,v in pairs(self._listeners_[eventName]) do
        if v.listener == listener and v.target  == target then
            return
        end
    end
    table.insert(self._listeners_[eventName], {
        listener = listener, 
        target = target, 
        dontDestory = dontDestory,
        triggerOnce = isTriggerOnce == true
    })
end

function LuaEventDispatcher:removeEventListener(eventName, listener, target)
    if self._listeners_[eventName] ~= nil then
        for i,v in ipairs(self._listeners_[eventName]) do
            if v.listener == listener and v.target == target then
                table.remove(self._listeners_[eventName], i)
                break
            end
        end
    end
end

function LuaEventDispatcher:dispatchEvent(eventName, data, mergeSame)
    dprint('[Event]->dispatchEvent ' .. tostring(eventName))
    if LuaEventDispatcher.CanDispatchEventImmediately == false then 
        self:AddPendingEvent(eventName, data, mergeSame)
        return
    end
    if self._listeners_[eventName] ~= nil then
		local listenerList = self._listeners_[eventName]
        for i = #listenerList, 1, -1 do 
            local listenerInfo = listenerList[i]
            if listenerInfo then 
                if listenerInfo.target == nil then
                    xpcall(listenerInfo.listener,showError,data,eventName)
                else
                    xpcall(listenerInfo.listener,showError,listenerInfo.target,data,eventName)
                end
                if listenerInfo.triggerOnce then 
                    table.remove(listenerList, i)
                end
            end
        end
    end
end

function LuaEventDispatcher:AddPendingEvent(eventName, paramsList, mergeSame)
    self.pendingEvent = self.pendingEvent or {}
    if(mergeSame == true) then
        for i = 1, #self.pendingEvent do
            local event = self.pendingEvent[i]
            if (event.name == eventName) then
                return
            end
        end
    end
    table.insert(self.pendingEvent, {name = eventName, paramsList = {paramsList}})
end

function LuaEventDispatcher:ProcPendingEvent()
    if self.pendingEvent == nil then 
        return 
    end
    for eventName, data in ipairs(self.pendingEvent) do 
        eventName = data.name
        paramsList = data.paramsList
        self:dispatchEvent(eventName, table.unpack(paramsList))
    end
    self.pendingEvent = {}
end

function LuaEventDispatcher:ClearListener()
    local newListeners = {}
    for eventName, listenerInfoList in pairs(self._listeners_) do 
        for _, listenerInfo in ipairs(listenerInfoList) do 
            if listenerInfo.dontDestory then 
                newListeners[eventName] = newListeners[eventName] or {}
                table.insert(newListeners[eventName], listenerInfo)
            end
        end
    end
    self._listeners_ = newListeners
end

function LuaEventDispatcher:HasListener(eventName)
    return self._listeners_ ~= nil and self._listeners_[eventName] ~= nil and #self._listeners_[eventName] > 0
end