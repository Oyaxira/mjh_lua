UnitFunctionTrack = class("UnitFunctionTrack",BaseTrack)
function UnitFunctionTrack:ctor(startTime,durationTime,unit,funcName,...)
    self.unit = unit
    if unit == nil and DEBUG_MODE then 
        dprint('fzt' .. funcName .. "|" .. debug.traceback())
    end
    self.funcName = funcName
    self.params = {...}
end
function UnitFunctionTrack:Run()
    self.super.Run(self)
    local func = self.unit[self.funcName]
    if func then 
        func(self.unit,table.unpack(self.params))
    end
end

function UnitFunctionTrack:GetStr()
    return string.format("UnitFunctionTrack,%.2f,%.2f,%s",self.startTime,self.endTime or 0,self.funcName)
end

return UnitFunctionTrack