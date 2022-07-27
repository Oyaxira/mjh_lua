local GCloudHelper = {}


function GCloudHelper:InitSDK( gameid, gamekey )
    if not self.instance then
        self.instance = CS.GCloudHelper()
    end

    if not self.instance:InitGCloud(gameid, gamekey) then
        derror(self.instance.ErrorString)
        SystemUICall:GetInstance():Toast(self.instance.ErrorString)
    end
end

function GCloudHelper:DoAppUpdate(DolphinCallBackInterface)
    if self.instance and DolphinCallBackInterface then
        local CSUpdateData = CS.GCloud.Dolphin.UpdateInitInfo()
        CSUpdateData.updateInitType = CS.GCloud.Dolphin.UpdateInitType.UpdateInitType_OnlyProgram
        CSUpdateData.gameUpdateUrl = "pre-download.2.1817197254.gcloudcs.com"
        --CSUpdateData.gameUpdateUrl = "download.1.1167737824.gcloudcs.com"
        CSUpdateData.updateChannelId = 86743
        --CSUpdateData.updateChannelId = 11004
        CSUpdateData.userId = "1"
        CSUpdateData.worldId = "1"
        CSUpdateData.grayUpdate = true
        self.instance:DoUpdate("1.0.0.0", "1.0.0.0", CSUpdateData, DolphinCallBackInterface, false)
    end
end

function GCloudHelper:DoSourceUpdate(DolphinCallBackInterface)
    if self.instance and DolphinCallBackInterface then
        local CSUpdateData = CS.GCloud.Dolphin.UpdateInitInfo()
        CSUpdateData.updateInitType = CS.GCloud.Dolphin.UpdateInitType.UpdateInitType_SourceCheckAndSync
        CSUpdateData.gameUpdateUrl = "pre-download.2.1817197254.gcloudcs.com"
        CSUpdateData.updateChannelId = 86743
        CSUpdateData.userId = "1"
        CSUpdateData.worldId = "1"
        CSUpdateData.grayUpdate = true
        self.instance:DoUpdate("1.0.0.0", "1.0.0.0", CSUpdateData, DolphinCallBackInterface, false)
    end
end

function GCloudHelper:DownloadUpdate()
    if self.instance then
        self.instance:Tick()
    end
end

function GCloudHelper:StopUpdate()
    if self.instance then
        self.instance:StopUpdate()
    end
end

function GCloudHelper:ContinueUpdate()
    if self.instance then
        self.instance:ContinueUpdate()
    end
end

function GCloudHelper:InstallApk(path)
    if self.instance then
        self.instance:InstallApk(path)
    end
end

return GCloudHelper

