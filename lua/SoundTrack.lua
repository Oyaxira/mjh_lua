SoundTrack = class("SoundTrack",BaseTrack)
function SoundTrack:ctor(startTime,durationTime,soundID)
    self.soundID = soundID
end

function SoundTrack:Run()
    self.super.Run(self)
    PlaySound(self.soundID)
end

function SoundTrack:GetStr()
    return string.format("SoundTrack,%.2f,%.2f,%s",self.startTime,self.endTime,self.soundID)
end