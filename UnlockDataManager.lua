UnlockDataManager = class("UnlockDataManager")
UnlockDataManager._instance = nil

function UnlockDataManager:GetInstance()
    if UnlockDataManager._instance == nil then
        UnlockDataManager._instance = UnlockDataManager.new()
    end

    return UnlockDataManager._instance
end
	
-- 服务器下行：更新全部解锁信息
-- 规则:规矩下发直接替换对应数据,如果没有则增加
function UnlockDataManager:UpdateUnlockData(kRetDataArray)
    if not kRetDataArray then 
        return
    end
    local UnlockPool = globalDataPool:getData("UnlockPool") or {}
    for i = 1, #kRetDataArray do
        local kRetData = kRetDataArray[i]
        local eType = kRetData.eType
        local akUnlockInfoArray = kRetData.akUnlockInfo
        local iNum = kRetData.iNum

        if not(eType and akUnlockInfoArray and iNum) then 
            return
        end

        if kRetData.bAll == 1 then
            UnlockPool[eType] = {}
        else
            if UnlockPool[eType] == nil then
                UnlockPool[eType] = {}
            end
        end

        for i = 1, iNum do
            local UnlockInfo = akUnlockInfoArray[i - 1]
            if  UnlockInfo == nil then
                return
            end
            local TypeID = UnlockInfo.dwTypeID

            if not(UnlockPool[eType][TypeID]) then
                UnlockPool[eType][TypeID] = {}
            end
            UnlockPool[eType][TypeID] = UnlockInfo
        end
    end

    globalDataPool:setData("UnlockPool", UnlockPool, true)
    --self:DispatchUpdateEvent()
end

function UnlockDataManager:DispatchUpdateEvent(kRetData)

    -- TODO 判断界面是否打开，打开才会刷新UI
    if kRetData.eType == PlayerInfoType.PIT_INCOMPLETE_BOOK then -- 残章回调
        local win  = GetUIWindow("CollectionUI")
        if win and IsWindowOpen("CollectionUI") then
            local collectionMartialUI = win.collectionMartialUI
            if collectionMartialUI then
                local UnlockPool = globalDataPool:getData("UnlockPool") or {};
                local incompleteBookData = UnlockPool[PlayerInfoType.PIT_INCOMPLETE_BOOK];
                if incompleteBookData then
                    LuaEventDispatcher:dispatchEvent('ONEVENT_MARTIALDATA_UPDATE');
                end
            end
        end
    end
end

function UnlockDataManager:HasUnlock(eUnlockType,iUnlockID)
    if not eUnlockType or not iUnlockID or iUnlockID == 0 then 
        return false 
    end
    local kUnlockPool = globalDataPool:getData("UnlockPool") or {}
    local kForgeMakeData = kUnlockPool[eUnlockType] or {}
    if kForgeMakeData[iUnlockID] then 
        return true
    end
    return false 
end