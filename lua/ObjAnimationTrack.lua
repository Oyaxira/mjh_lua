ObjAnimationTrack = class("ObjAnimationTrack",BaseTrack)
function ObjAnimationTrack:ctor(startTime,durationTime,object,animationName,isLoop)
    object:SetActive(false)
    self.object = object
    self.animation = animationName
    self.isLoop = isLoop
    self.durationTime = durationTime
end

function BaseTrack:GetMaxTime()
    return self.startTime
end

function ObjAnimationTrack:Run()
    self.super.Run(self)
    self.object:SetActive(true)
    self.object:PlayAnimation(self.animation,self.isLoop or false,0)
end

function ObjAnimationTrack:Destroy()
    -- self.object:Destroy()
    if self.durationTime then 
        LogicMain:GetInstance():AddTimer(self.durationTime,function()
            ReturnSkillObjectToPool(self.object)
        end)
    end
end

function ObjAnimationTrack:SetTime(t)
    self.object:SetActive(true)
    self.object:PlayAnimation(self.animation,false,t - self.startTime / 1000)
end

function ObjAnimationTrack:GetStr()
    return string.format("ObjAnimationTrack,%.2f,%.2f,%s",self.startTime,self.endTime,self.animation)
end