FunctionTrack = class("FunctionTrack",BaseTrack)
function FunctionTrack:ctor(startTime,durationTime,funcName,...)
    self.funcName = funcName
    self.params = {...}
end
function FunctionTrack:Run()
    self.super.Run(self)
    local func = _G[self.funcName]
    if func then 
        func(table.unpack(self.params))
    end
end

function FunctionTrack:GetStr()
    return string.format("FunctionTrack,%.2f,%.2f,%s",self.startTime,self.endTime or 0,self.funcName)
end

return FunctionTrack