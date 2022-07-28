BaseTrack = class("BaseTrack")
function BaseTrack:ctor(startTime,durationTime)
    self.hasRun = false
    self.startTime = startTime
    if durationTime then 
        self.endTime = startTime + durationTime
    end
end

function BaseTrack:GetMaxTime()
    local result = 0
    if self.endTime then
        result = self.endTime
    end
    if self.endTime == nil and self.startTime and self.startTime > result then
        result = self.startTime
    end
    return result
end
function BaseTrack:CanRun(curTime)
    if self.hasRun then return false end
    if self.startTime and curTime < self.startTime then 
        return false
    end
    if self.endTime and curTime > self.endTime then 
        return false
    end
    return true
end

function BaseTrack:CanRun_Update(curTime)
    if self.hasRun then return 1 end
    if self.startTime and curTime < self.startTime then 
        return 2
    end
    return 0
end

function BaseTrack:Run()
    self.hasRun = true
end

function BaseTrack:Destroy()

end

function BaseTrack:SetTime(t)
    
end

function BaseTrack:GetStr()
    return string.format("BaseTrack,%.2f,%.2f",self.startTime,self.endTime)
end
return BaseTrack