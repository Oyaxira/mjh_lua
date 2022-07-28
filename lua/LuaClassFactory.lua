LuaClassFactory = class("LuaClassFactory")
LuaClassFactory._instance = nil

LUA_CLASS_TYPE = 
{
    ["ItemIconUI"] = 1,
    ["ForgeItemIconUI"] = 2,
    ["RewardItemIconUI"] = 3,
    ["TaskItemIconUI"] = 4,
    ["LuckItemIconUI"] = 5,
    ["TreasureBookItemIconUI"] = 6,
    ["ItemDispositionUI"] = 7,
    ["AdvlootUI"] = 8,
    ["SkillIconUI"] = 9,
    ["PlayerSpineItemUI"] = 10,
    ["ItemReward"] = 11,
    ["PlayerReturnRewardItemUI"] = 12,
    ["HeadBoxUI"] = 13,
    ["MallItemUI"] = 14,
    ["SkillIconUIS"] = 15,
    ["ItemIconUITrigger"] = 16,
}

local RegisterClass = 
{
    [LUA_CLASS_TYPE.ItemIconUI] = require 'UI/ItemUI/ItemIconUINew',
    [LUA_CLASS_TYPE.ItemIconUITrigger] = require 'UI/ItemUI/ItemIconUINewTrigger',
    [LUA_CLASS_TYPE.ForgeItemIconUI] = require 'UI/ItemUI/ForgeItemIconUI',
    [LUA_CLASS_TYPE.RewardItemIconUI] = require 'UI/ItemUI/RewardItemIconUI',
    [LUA_CLASS_TYPE.LuckItemIconUI] = require 'UI/ItemUI/LuckItemIconUI',
	[LUA_CLASS_TYPE.TaskItemIconUI] = require 'UI/Task/TaskItemIconUI',
    [LUA_CLASS_TYPE.ItemDispositionUI] = require 'UI/ItemUI/ItemDispositionUI',
    [LUA_CLASS_TYPE.AdvlootUI] = require 'UI/MazeUI/AdvLootUI',
    [LUA_CLASS_TYPE.SkillIconUI] = require 'UI/ItemUI/SkillIconUINew',
    [LUA_CLASS_TYPE.SkillIconUIS] = require 'UI/ItemUI/SkillIconUINewS',
    [LUA_CLASS_TYPE.PlayerSpineItemUI] = require 'UI/TownUI/PlayerSpineItemUI',
    [LUA_CLASS_TYPE.ItemReward] = require 'UI/ItemUI/ItemReward',
    [LUA_CLASS_TYPE.PlayerReturnRewardItemUI] = require 'UI/ItemUI/PlayerReturnRewardItemUI',
    [LUA_CLASS_TYPE.HeadBoxUI] = require 'UI/TownUI/HeadBoxUI',
    [LUA_CLASS_TYPE.MallItemUI] = require 'UI/Activity/MallItemUI',
}

ClassState =
{
    ["InPool"] = 1,
    ["Used"] = 2,
}

function LuaClassFactory:GetInstance()
    if LuaClassFactory._instance == nil then
        LuaClassFactory._instance = LuaClassFactory.new()
        LuaClassFactory._instance:Init()
    end

    return LuaClassFactory._instance
end

function LuaClassFactory:Init()
    self.akLuaUIClass = {}--所有lua ui类 实例  
    for key, value in pairs(LUA_CLASS_TYPE) do
        self.akLuaUIClass[value] = {}
    end
end

function LuaClassFactory:GetItemIconByInst(iItemType,kInst)
    local uiClass = nil
    if RegisterClass[iItemType] then
        uiClass = RegisterClass[iItemType].new()
        uiClass._classType = iItemType
        if kInst then
            uiClass:SetGameObject(kInst)
            uiClass:Init()
        end
    end
    return uiClass
end

function LuaClassFactory:GetUIClass(iItemType, kParent, kInfo)
    local uiClass = nil
    if self.akLuaUIClass[iItemType] then
        if kInfo and kParent then
            kInfo['kParent'] = kParent
        end
        local iCount = #self.akLuaUIClass[iItemType]
        if iCount > 0 then
            uiClass =  table.remove(self.akLuaUIClass[iItemType],iCount)
            if uiClass then
                uiClass:SetParent(kParent)
            else
                uiClass = RegisterClass[iItemType].new()
                uiClass._classType = iItemType
                if kInfo then
                    uiClass:Create(kInfo)
                else
                    uiClass:Create(kParent)
                end
                uiClass:Init()
            end
        else
            uiClass = RegisterClass[iItemType].new()
            uiClass._classType = iItemType
            if kInfo then
                uiClass:Create(kInfo)
            else
                uiClass:Create(kParent)
            end
            uiClass:Init()
        end
        uiClass:SetActive(true)
        uiClass.eClassState = ClassState.Used
        uiClass.lastUseTime = nil
    end
    return uiClass
end

function LuaClassFactory:ReturnUIClass(kUIClass,bDestory)
    if kUIClass.eClassState == ClassState.Used then
        if bDestory == true then
            kUIClass:Close(true)
            kUIClass = nil
            kUIClass.eClassState = ClassState.InPool
        else
            kUIClass:ToPoolClear()
            kUIClass:ReturnToPool()
            kUIClass.lastUseTime = os.clock()
            kUIClass.eClassState = ClassState.InPool
            table.insert(self.akLuaUIClass[kUIClass._classType],kUIClass)
        end
    elseif DEBUG_MODE then
        --showError("已经在池里的类 重复返回")
    end
end

function LuaClassFactory:ReturnAllUIClass(classTable)
    for key, value in pairs(classTable) do
        if value and value.eClassState == ClassState.Used then
            self:ReturnUIClass(value)
        elseif DEBUG_MODE then
            --showError("已经在池里的类 重复返回")
        end
	end
end

function LuaClassFactory:UpdateUnload()
    if self.akLuaUIClass then
        local curTime = os.clock()
        local delTime = UPDATE_UNLOAD_CLASS
        for key, classList in pairs(self.akLuaUIClass) do
            if classList and #classList > 0 then
                for index, value in ipairs(classList) do
                    if value and value.eClassState == ClassState.InPool and value.lastUseTime ~= nil and curTime - value.lastUseTime > delTime  then 
                        table.remove(classList,index)
                        -- classList[index] = nil
                        value:Close(true)
                        value = nil       
                        break
                    end
                end
            end
        end
    end
end


function LuaClassFactory:Clear()
    for iItemType, akClass in pairs(self.akLuaUIClass) do
        for key ,value in ipairs(akClass) do
            if value then
                value:SetActive(false)
                value:Destroy(true)
            end
        end
    end
    self.akLuaUIClass = nil
end