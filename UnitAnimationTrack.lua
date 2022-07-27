UnitAnimationTrack = class("UnitAnimationTrack",BaseTrack)

function UnitAnimationTrack:ctor(startTime,durationTime,unit,animationName)
    self.unit = unit
    self.animation = animationName
end
function UnitAnimationTrack:Run()
    self.super.Run(self)
    self.unit.skeletonAnimation.AnimationState:SetAnimation(0,self.animation,false)
    self.unit.skeletonAnimation.AnimationState:AddAnimation(0,SPINE_ANIMATION.BATTLE_IDEL,true,0)
end

function UnitAnimationTrack:SetTime(t)
    local track = self.unit.skeletonAnimation.AnimationState:SetAnimation(0,self.animation,false)
    self.unit.skeletonAnimation.AnimationState:AddAnimation(0,SPINE_ANIMATION.BATTLE_IDEL,true,0)
    track.TrackTime = t - self.startTime / 1000
end

function UnitAnimationTrack:GetStr()
    return string.format("UnitAnimationTrack,%.2f,%.2f,%s",self.startTime,self.endTime or 0,self.animation)
end