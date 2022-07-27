BlurBackgroundManager = class('BlurBackgroundManager');
BlurBackgroundManager._instance = nil

BlurBackgroundManager.SITESTATE_MAP = 1
BlurBackgroundManager.SITESTATE_MAZE = 2
BlurBackgroundManager.SITESTATE_BIGMAP = 3

function BlurBackgroundManager:GetInstance()
    if BlurBackgroundManager._instance == nil then
        BlurBackgroundManager._instance = BlurBackgroundManager.new()
        BlurBackgroundManager._instance:Init()
    end

    return BlurBackgroundManager._instance
end

function BlurBackgroundManager:Init()
    self:ResetManager()
end

function BlurBackgroundManager:ResetManager()
    self.siteState = nil
    self.tempBGInfo = nil
    self.bgImg = nil
    self.tempBGInfo = nil
    self.blurRefCount = 0
    RemoveWindowImmediately('BlurBGUI')
end

function BlurBackgroundManager:GetSiteState()
    return self.siteState
end

function BlurBackgroundManager:AddBgImg(bgImg)
    self.bgImg = bgImg
end

function BlurBackgroundManager:GetBgImg()
    return self.bgImg
end

function BlurBackgroundManager:GetTempBackgroundInfo()
    return self.tempBGInfo
end

function BlurBackgroundManager:AddTempBackground(bIsBigMap, uiMapTypeID, uiMazeTypeID)
    self.tempBGInfo = {}
    self.tempBGInfo.bIsBigMap = bIsBigMap
    self.tempBGInfo.uiMapTypeID = uiMapTypeID
    self.tempBGInfo.uiMazeTypeID = uiMazeTypeID
end

function BlurBackgroundManager:RemoveTempBackground()
    self.tempBGInfo = nil
end

function BlurBackgroundManager:ShowBlurBG()
    self.blurRefCount = self.blurRefCount + 1
    OpenWindowImmediately('BlurBGUI')
end

function BlurBackgroundManager:HideBlurBG()
    self.blurRefCount = self.blurRefCount - 1
    -- self.blurRefCount = self.blurRefCount - 100
    if self.blurRefCount <= 0 then
        self.blurRefCount = 0
        RemoveWindowImmediately('BlurBGUI')
    end
end

return BlurBackgroundManager