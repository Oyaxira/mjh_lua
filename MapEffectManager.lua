MapEffectManager = class("MapEffectManager")
MapEffectManager._instance = nil

function MapEffectManager:ctor()

end

function MapEffectManager:GetInstance()
    if MapEffectManager._instance == nil then
        MapEffectManager._instance = MapEffectManager.new()
        MapEffectManager._instance:Init()
    end

    return MapEffectManager._instance
end

function MapEffectManager:Init()
    self:ResetManager()
end

function MapEffectManager:ResetManager()
    self.globalEffect = {}
    self.tempEffect = nil
    self.mapEffectDict = {}

    self.backgroundEffectDict = {}
end

-- 服务端下发的全局地图效果
function MapEffectManager:UpdateGlobalMapEffect(effectList)
    if effectList then
        self.globalEffect = effectList
        self:ShowMapEffectImmediately()
    end
end

-- 客户端设置的地图效果
function MapEffectManager:AddMapEffect(mpaEffectTypeID)
    if mpaEffectTypeID == nil then
        return
    end

    self.mapEffectDict[mpaEffectTypeID] = self.mapEffectDict[mpaEffectTypeID] or 0
    self.mapEffectDict[mpaEffectTypeID] = self.mapEffectDict[mpaEffectTypeID] + 1

    self:ShowMapEffectImmediately()
end
function MapEffectManager:RemoveMapEffect(mpaEffectTypeID)
    if mpaEffectTypeID == nil then
        return
    end

    if not self.mapEffectDict[mpaEffectTypeID] then
        return
    end

    self.mapEffectDict[mpaEffectTypeID] = self.mapEffectDict[mpaEffectTypeID] - 1

    if self.mapEffectDict[mpaEffectTypeID] < 0 then
        self.mapEffectDict[mpaEffectTypeID] = 0
    end

    self:ShowMapEffectImmediately()
end
function MapEffectManager:ClearMapEffect()
    self.mapEffectDict = {}
    self:ShowMapEffectImmediately()
end

-- 剧情中设置的临时效果
function MapEffectManager:ShowTempMapEffect(data)
    self.tempEffect = data
    self:ShowMapEffectImmediately()
end
function MapEffectManager:RemoveTempMapEffect()
    self.tempEffect = nil
    self:ShowMapEffectImmediately()
end

function MapEffectManager:ShowMapEffectImmediately()
    local effectList = {}
    local effectDice = {}

    if self.tempEffect then
        table.insert(effectList, self.tempEffect)
    else
        for index, effectTypeID in ipairs(self.globalEffect) do
            if not effectDice[effectTypeID] then
                table.insert(effectList, effectTypeID)
                effectDice[effectTypeID] = true
            end
        end
        for effectTypeID, refCount in pairs(self.mapEffectDict) do
            if refCount > 0 then
                if not effectDice[effectTypeID] then
                    table.insert(effectList, effectTypeID)
                    effectDice[effectTypeID] = true
                end
            end
        end
    end

    if #effectList > 0 then
        OpenWindowImmediately("ForegroundUI", effectList)
    else
        local forgroundUI = GetUIWindow("ForegroundUI")
        if forgroundUI then
            forgroundUI:Clear()
            --RemoveWindowImmediately("ForegroundUI")
        end

        effectList = nil
    end

    self.lastEffectList = effectList
    self:UpdateAllBackgroundEffect()
end

function MapEffectManager:ShowMapEffectByQueue()
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_SHOW_FOREGROUND, false)
end
function MapEffectManager:UpdateMapEffectByQueue(globalEffectList, addMapEffect, removeMapEffect)
    local info = {}
    info.globalEffectList = globalEffectList
    info.addMapEffect = addMapEffect
    info.removeMapEffect = removeMapEffect
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_UPDATE_MAP_EFFECT, false, info)
end


-- 后景效果
function MapEffectManager:InitBackgroundEffect(objBGEffect)
    if not objBGEffect or self.backgroundEffectDict[objBGEffect] then
        return
    end

    local comBGEffect = BackgroundEffectUI.new(objBGEffect)
    self.backgroundEffectDict[objBGEffect] = comBGEffect
end
function MapEffectManager:DestroyBackgroundEffect(objBGEffect)
    if objBGEffect then
        self.backgroundEffectDict[objBGEffect] = nil
    end
end
function MapEffectManager:UpdateBackgroundEffect(objBGEffect)
    if not objBGEffect or not objBGEffect.activeSelf then
        return
    end

    if not IsValidObj(objBGEffect) then
        self:DestroyBackgroundEffect(objBGEffect)
        return
    end

    comBGEffect = self.backgroundEffectDict[objBGEffect]
    if comBGEffect then
        comBGEffect:UpdateEffect(self.lastEffectList)
    end
end
function MapEffectManager:UpdateAllBackgroundEffect()
    local removeList = {}

    for objBGEffect, comBGEffect in pairs(self.backgroundEffectDict) do
        if not IsValidObj(objBGEffect) then
            table.insert(removeList, objBGEffect)
        else
            self:UpdateBackgroundEffect(objBGEffect)
        end
    end

    for index, objBGEffect in ipairs(removeList) do
        self:DestroyBackgroundEffect(objBGEffect)
    end
end