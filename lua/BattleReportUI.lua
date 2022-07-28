BattleReportUI = class("BattleReportUI",BugReportUI)

function BattleReportUI:SubmitBugMsg(text)
    -- 获取当前战斗信息
    -- 战斗ID|matchid|playerid
    if ARENA_PLAYBACK_DATA then 
        text = string.format("%d#%d#%d#",ARENA_PLAYBACK_DATA.dwBattleID,ARENA_PLAYBACK_DATA.dwMatchID or 0,PlayerSetDataManager:GetInstance():GetPlayerID()) .. text
        BugReportUI.SubmitBugMsg(self,text,"BattleReport")
    end
end


return BattleReportUI