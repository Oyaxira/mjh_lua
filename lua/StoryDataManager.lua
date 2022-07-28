StoryDataManager = class("StoryDataManager")
StoryDataManager._instance = nil

function StoryDataManager:GetInstance()
    if StoryDataManager._instance == nil then
        StoryDataManager._instance = StoryDataManager.new()
    end

    return StoryDataManager._instance
end

function StoryDataManager:ResetManager()

end

function StoryDataManager:InitStoryDifficult()
    self.storyDifficultCache = {}

    local difficultDatas = TableDataManager:GetInstance():GetTable("Difficult")
    for baseID, difficultData in pairs(difficultDatas) do
        if not difficultData.Story or #difficultData.Story == 0 then
            SetInnerTableData(self.storyDifficultCache, baseID, 0, difficultData.Diff)
        else
            for _, storyID in ipairs(difficultData.Story) do
                SetInnerTableData(self.storyDifficultCache, baseID, storyID, difficultData.Diff)
            end
        end
    end
end

function StoryDataManager:GetStoryDifficultData(storyID, difficult)
    if not storyID or not difficult or storyID == 0 then
        derror(string.format("获取剧本难度数据出错!! storyID = %s difficlt = %s", tostring(storyID), tostring(difficult)))
        return nil
    end

    if not self.storyDifficultCache then
        self:InitStoryDifficult()
    end

    local baseID = GetInnerTableData(self.storyDifficultCache, storyID, difficult)
    if not baseID then
        baseID = GetInnerTableData(self.storyDifficultCache, 0, difficult)
    end

    if not baseID then
        derror(string.format("获取剧本难度数据出错!! storyID = %s difficlt = %s", tostring(storyID), tostring(difficult)))
        return nil
    end

    local difficultData = TableDataManager:GetInstance():GetTableData("Difficult", baseID)
    return difficultData
end

function StoryDataManager:GetSpecialCreateRole(storyID)
    local storyData = TableDataManager:GetInstance():GetTableData("Story", GetCurScriptID())

    if not storyData or not storyData.SpecialCreateRole or storyData.SpecialCreateRole == 0 then
        return nil  -- 如果要替换成其他值需要改下调用的地方
    else
        return storyData.SpecialCreateRole
    end
end