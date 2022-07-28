TweenerTrack = class("TweenerTrack",BaseTrack)
function TweenerTrack:ctor(startTime,durationTime,tweener)
    self.tweener = tweener
    tweener:Pause()
end

function TweenerTrack:Run()
    self.super.Run(self)
    self.tweener:Play()
end

function TweenerTrack:SetTime(t)
    self.tweener:Goto(t - self.startTime)
end

function TweenerTrack:GetStr()
    return string.format("TweenerTrack,%.2f,%.2f,%s",self.startTime,self.endTime or 0,self.tweener)
end