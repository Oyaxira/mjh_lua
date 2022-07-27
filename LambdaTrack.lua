LambdaTrack = class("LambdaTrack",BaseTrack)
function LambdaTrack:ctor(startTime,durationTime,lambda)
    self.lambda = lambda
end
function LambdaTrack:Run()
    self.super.Run(self)
    if self.lambda then 
        self.lambda()
    end
end

function LambdaTrack:GetStr()
    return string.format("LambdaTrack,%.2f,%.2f,%s",self.startTime,self.endTime or 0,self.funcName)
end

return LambdaTrack