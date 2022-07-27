CheckPath = {}
CheckPath1 = {}
CheckID = {}
CheckID1 = {}
CheckName = {}
CheckResult = {}
CheckPathCount = 0

NotUseBaseID ={}
NotCheckName = {}

local defaultPath = "UI/UISprite/"

function ShowAllUnremovedButtonListenerInfo()

end

function CheckMapDataPath()
    CheckPath = {}
    CheckName = {}
    local TB_Map = require ("Data/Map")
    for key, value in pairs(TB_Map) do
        if value.BuildingImg ~= "" and value.BuildingImg ~= nil then
            table.insert(CheckPath,tostring(defaultPath..value.BuildingImg))
            table.insert(CheckName,tostring(key.. " BuildingImg is nil"))
        end
        if value.SceneImg ~= "" and value.SceneImg ~= nil then
            table.insert(CheckPath,tostring(defaultPath..value.SceneImg))
            table.insert(CheckName,tostring(key).. "SceneImg is  nil")
        end   
    end
    CheckPathCount = #CheckPath
end


function ClassifyMapDataPath()
    CheckPath = {}
    local TB_Map = require ("Data/Map")
    for key, value in pairs(TB_Map) do
        if value.BuildingImg ~= "" and value.BuildingImg ~= nil then
            table.insert(CheckPath,{tostring(defaultPath..value.BuildingImg),value.AtlasName,value.BuildingImg})
        end
        if value.SceneImg ~= "" and value.SceneImg ~= nil then
            table.insert(CheckPath,{tostring(defaultPath..value.SceneImg),value.AtlasName,value.SceneImg})
        end
    end
    CheckPathCount = #CheckPath
end

function GetSkillPerformanceEffectPath()
    CheckPath = {}
    CHeckID = {}
    CheckName = {}

    local TB_SkillPerformance = require("Data/SkillPerformance")
    local TB_Language = require("Data/Language")
    local TB_Skill = require("Data/Skill")

    local GetSkillName = function(ID)
        local name = ""
        local skillData = TB_Skill[ID]
        if skillData and skillData.NameID then
            local languageData = TB_Language[skillData.NameID]
            if languageData then
                name = languageData.Ch_Text
            end
        end
        CheckName[#CheckName + 1] = name
    end


    for k,v in pairs(TB_SkillPerformance) do
        if v["skillEffect"] ~= nil then
            for kk,vv in pairs(v["skillEffect"]) do
                local castEffect = vv["castEffect"]
                if castEffect ~= nil then
                    for key,value in pairs(castEffect) do
                        if value and value["prefabPath"] ~= nil then
                            CheckPath[#CheckPath+ 1] = value["prefabPath"]
                            CheckID[#CheckID + 1] = v.id
                            GetSkillName(v.id)
                        end
                    end
                end
    
                local hurtEffect = vv["hurtEffect"]
                if hurtEffect ~= nil then
                    for key,value in pairs(hurtEffect) do
                        if value and value["prefabPath"] ~= nil then
                            CheckPath[#CheckPath+ 1] = value["prefabPath"]
                            CheckID[#CheckID + 1] = v.id
                            GetSkillName(v.id)
                        end
                    end
                end
            end
        end
    end
end

function GetBuffPerformanceEffectPath()
    CheckPath = {}
    CHeckID = {}
    CheckName = {}
    local TB_BuffPerformance = require("Data/BuffPerformance")
    local TB_Language = require("Data/Language")
    local TB_Buff = require("Data/Buff")

    local GetBuffName = function(ID)
        local name = ""
        local buffData = TB_Buff[ID]
        if buffData and buffData.NameID then
            local languageData = TB_Language[buffData.NameID]
            if languageData then
                name = languageData.Ch_Text
            end
        end
        CheckName[#CheckName + 1] = name
    end


    for k,v in pairs(TB_BuffPerformance) do
        if v["skillEffect"] ~= nil then
            for kk,vv in pairs(v["skillEffect"]) do
                local castEffect = vv["castEffect"]
                if castEffect ~= nil then
                    for key,value in pairs(castEffect) do
                        if value and value["prefabPath"] ~= nil then
                            CheckPath[#CheckPath+ 1] = value["prefabPath"]
                            CheckID[#CheckID + 1] = v.id
                            GetBuffName(v.id)
                        end
                    end
                end
    
                local hurtEffect = vv["hurtEffect"]
                if hurtEffect ~= nil then
                    for key,value in pairs(hurtEffect) do
                        if value and value["prefabPath"] ~= nil then
                            CheckPath[#CheckPath+ 1] = value["prefabPath"]
                            CheckID[#CheckID + 1] = v.id
                            GetBuffName(v.id)
                        end
                    end
                end
            end
        end
    end
end

function GetAudioPath()
    CheckPath = {}
    CheckName = {}
    local TB_ResourceBGM = require ("Data/ResourceBGM")
    for key, value in pairs(TB_ResourceBGM) do
        if value.BGMPath ~= "" and value.Bank ~= nil then
            table.insert(CheckPath,value.BGMPath)
            table.insert(CheckName,value.Bank)        
        end
    end
    CheckPathCount = #CheckPath
end

-----------------语言表检查 begin
local TB_Language = {}
local Log = CS.UnityEngine.Debug.Log
local totalLanguageCount = 0
local notCheckTable = {["Language"] = true, ["ClientEnum"] = true,["common"] = true}
local useableLanguageKey = {}

function SetLanguageTable(sTableName)
    local TB_CheckData = require("Data/Language/"..sTableName)
    for k , v in pairs(TB_CheckData) do
        TB_Language[k] = v
        totalLanguageCount = totalLanguageCount + 1
    end
end

function CheckLanguageUseable(sCheckName)
    if notCheckTable[sCheckName] then
        return
    end 
    CheckResult = {}
    --检查 sCheckName 表中language的引用
    local TB_CheckData = require("Data/"..sCheckName)
    local checkKey = {
        --"Name",
        "NameID","GivennameID","DescID","DesID","EvoDescID",
        "TimeID","TitleID","Title","TipID","RelationDescID",
        "MatchDecNameID","MatchTypeNameID","DefaultChatIDList",
        "ClanTipsID","UnlockCondDesc","SurnameID",
        "CGName","ArtistName","TextID","SourceID",
        "ArticleTitleID","RewardTextID","WriterNameID",
        "QuestionID","UnlockDescID",
        "EffectDescID","NormalMapDesc",
        "BloodMapDesc","BloodMapLockDesc",
        "RegimentMapDesc","RegimentMapLockDesc",
        "IntroduceID","MazeDescID","BreakAddID","LanguageID","PreDes",
        "ShowName","ShowDes","LanguageIDList","DescTextID",
        "SpecialIntroduce","Poem2ID","BuildingNameID","Poem1ID",
    }

    local bHasNone = true
    if TB_CheckData ~= nil then
        for k ,v in pairs(TB_CheckData) do
            for kk ,checkKey in ipairs(checkKey) do
                local languageID = v[checkKey]
                if languageID ~= nil and languageID ~= 0 then
                    if type(languageID) == "table" then
                        for kkk, ID in pairs(languageID) do
                            ID = tonumber(ID)
                            if ID ~= nil and TB_Language[ID] == nil then
                                local str = string.format("%s BaseID : %s %s: %s 在Language表中不存在",sCheckName,tostring(k),checkKey,ID)
                                table.insert(CheckResult,str)
                            else
                                useableLanguageKey[ID] = true
                            end
                        end
                    else
                        languageID = tonumber(languageID)
                        if TB_Language[languageID] == nil then
                            local str = string.format("%s BaseID : %s %s: %s 在Language表中不存在",sCheckName,tostring(k),checkKey,languageID)
                            table.insert(CheckResult,str)
                        else
                            useableLanguageKey[languageID] = true
                        end
                    end
                    bHasNone = false
                end
            end
            if bHasNone then         
                table.insert(NotCheckName,sCheckName.." not check")
                break
            end
        end
    end
end

function GetComicPlotPath()
    CheckPath = {}
    CheckID = {}

    local TB_Plot = require("Data/Plot")
    local TB_ResourceCG = require("Data/ResourceCG")
    
    local checkIMG = PlotType.PT_SHOW_IMG
    local type2Param2 = {
        [PlotType.PT_DIALOGUE] = {"Param2"},
        [PlotType.PT_LINSHI_JUESE_DUIHUA] = {"Param2","Param10"},
        [PlotType.PT_TOAST] = {"Param1"},
    }

    for plotID,plotData in pairs(TB_Plot) do
        if plotData.PlotType == checkIMG then
            local kCheckPath = plotData.Param2
            local CGData = TB_ResourceCG[tonumber(kCheckPath)]
            if CGData ~= nil then
                table.insert(CheckPath,tostring(CGData.CGPath))
            else
                table.insert(CheckPath,kCheckPath)
            end
            table.insert(CheckID,tostring(plotID))
        end
        
        local checkKeys = type2Param2[plotData.PlotType]
        if checkKeys ~= nil then
            for _,param in ipairs(checkKeys) do
                local languageID = tonumber(plotData[param])
                if languageID ~= nil then
                    if TB_Language[languageID] == nil then
                        local str = string.format("Plot BaseID : %s %s: %s 在Language表中不存在",tostring(plotID),param,tostring(languageID))
                        table.insert(CheckResult,str)
                    else
                        useableLanguageKey[languageID] = true
                    end
                end
            end
        end
    end
end

local function CheckTaskEventUse()
    local TB_TaskEvent = require("Data/TaskEvent")

    local type2Param2 = {
        [Event.Event_Choose] = {"EventArg1","EventArg2"},
        [Event.Event_RoleInteractive] = {"EventArg1","EventArg2","EventArg4"},
        [Event.Event_UI_tijiao_wupin] = {"EventArg2"},
        [Event.Event_ShowChooseText] = {"EventArg1"},
        
    }

    for taskID,taskData in pairs(TB_TaskEvent) do
        local checkKeys = type2Param2[taskData.Event]
        if checkKeys ~= nil then
            for _,param in ipairs(checkKeys) do
                local languageID = tonumber(taskData[param])
                if TB_Language[languageID] == nil then
                    local str = string.format("TB_TaskEvent BaseID : %s %s: %s 在Language表中不存在",tostring(taskID),param,tostring(languageID))
                    table.insert(CheckResult,str)
                else
                    useableLanguageKey[languageID] = true
                end
            end
        end
    end
end

local function CheckBehaviorUse()
    local TB_Behavior = require("Data/Behavior")

    local type2Param2 = {
        [BehaviorType.BET_GUANXI_MIAOSHU] = {"Arg3"},
        [BehaviorType.BET_auto_ren4wu4shu4ju4xiu1gai3_jiao3se4_xiu1gai3jiao3se4xian3shi4ming2chen4] = {"Arg2"},
        
    }

    for taskID,taskData in pairs(TB_Behavior) do
        local checkKeys = type2Param2[taskData.Type]
        if checkKeys ~= nil then
            for _,param in ipairs(checkKeys) do
                local languageID = tonumber(taskData[param])
                if TB_Language[languageID] == nil then
                    local str = string.format("TB_Behavior BaseID : %s %s: %s 在Language表中不存在",tostring(taskID),param,tostring(languageID))
                    table.insert(CheckResult,str)
                else
                    useableLanguageKey[languageID] = true
                end
            end
        end
    end
end

function GetUnuseableLanguage()
    Log("语言表总数量 ："..totalLanguageCount)
    NotUseBaseID = {}
    CheckTaskEventUse()
    CheckBehaviorUse()
    --500以下都认为用了 不然需要从common 把XXX_Lang拷过来
    for i=1 ,500 do
        TB_Language[i] = nil
    end

    for i = 110001, 110792 do 
        TB_Language[i] = nil
    end

    for k, v in pairs(useableLanguageKey) do
        TB_Language[k] = nil
    end

    for k , v in pairs(TB_Language) do
        if v == "" then
            
        else
            table.insert(NotUseBaseID,tostring(k))
        end
    end 
end 

----------------语言表检查 end