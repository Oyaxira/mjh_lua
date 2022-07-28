HighTowerRewardUI = class("HighTowerRewardUI",BaseWindow)

function HighTowerRewardUI:ctor()
    self.mailbox = {}
end

function HighTowerRewardUI:Create()
	local obj = LoadPrefabAndInit("HighTower/HighTowerRewardUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function HighTowerRewardUI:Init()
    self.comTitle_Text = self:FindChildComponent(self._gameObject, "title_complete", "Text")
    self.comDesc_Text = self:FindChildComponent(self._gameObject, "desc", "Text")
    self.objRewardContent = self:FindChild(self._gameObject, "Reward_S/Viewport/Content")

    -- 背景
    self.comBG_Button = self:FindChildComponent(self._gameObject, "BG_black","Button")
    if self.comBG_Button then
        local fun = function()
            RemoveWindowImmediately("HighTowerRewardUI")
            DisplayActionEnd()
        end
        self:AddButtonClickListener(self.comBG_Button,fun)
    end

    self.akItemUIClass = {}
end

function HighTowerRewardUI:InitDataMap()
    self.highTowerDataMap = {}

    for baseID, data in pairs(TableDataManager:GetInstance():GetTable("HighTower")) do
        self.highTowerDataMap[data.HighTowerType] = self.highTowerDataMap[data.HighTowerType] or {}
        self.highTowerDataMap[data.HighTowerType][data.Stage] = baseID
    end
end

function HighTowerRewardUI:GetResData(type, stage)
    if not self.highTowerDataMap then
        self:InitDataMap()
    end

    local baseID = self.highTowerDataMap[type]
    if baseID then
        baseID = baseID[stage]
    end

    if baseID then
        return TableDataManager:GetInstance():GetTableData("HighTower",baseID)
    end

    return nil
end

function HighTowerRewardUI:RefreshUI(info)
    if not info then
       return
    end

    local type = info.eType
    local stage = info.iStage

    local rewardList = {}
    local dropIDs = {}
    
    self:ReturnAllTaskItemIcon()

    local resData = self:GetResData(type, stage)
    local typeName = ""

    if type == HighTowerType.HTT_NORMAL then
        typeName = "无间秘境-普通模式"
    elseif type == HighTowerType.HTT_BLOOD then
        typeName = "无间秘境-血斗模式"
    elseif type == HighTowerType.HTT_REGIMENT then
        typeName = "无间秘境-混战模式"
    end
    self.comTitle_Text.text = typeName
    self.comDesc_Text.text = string.format("恭喜大侠闯过了<color=red>%s</color>的<color=red>%d</color>层，获得以下奖励！", typeName, stage)

    if resData and resData.Drops then
        for dropIndex, dropID in ipairs(resData.Drops) do
            local dropBaseIDList = DropDataManager:GetInstance():GetDropBaseIDListByDropID(dropID) or {}
            for _, dropBaseID in ipairs(dropBaseIDList) do
                local subRewardList = TaskDataManager:GetInstance():ParseTaskDrop(dropBaseID)
                if subRewardList and #subRewardList > 0 then
                    table.move(subRewardList, 1, #subRewardList, #rewardList + 1, rewardList)
                end
            end
        end
    end


    for k = 1, #rewardList do
        self:AddRewardIcon(rewardList[k], self.objRewardContent)
    end
end

function HighTowerRewardUI:ReturnAllTaskItemIcon()
    if #self.akItemUIClass > 0 then
        LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
        self.akItemUIClass = {}
    end
end

function HighTowerRewardUI:CreateTaskItemIcon(kRewardData, kTransParent)
    if not (kRewardData and kTransParent) then
        return
    end
    local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.TaskItemIconUI, kTransParent)
    kIconBindData:UpdateUI(kRewardData)
    self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
	return kIconBindData
end

-- 添加一个物品图标到任务奖励中
function HighTowerRewardUI:AddRewardIcon(rewardData, objParent)
    if not (rewardData and objParent) then return end
    local kTransParent = objParent.transform
    local kIconBindData = self:CreateTaskItemIcon(rewardData, kTransParent)
end

function HighTowerRewardUI:OnDestroy()
    self:ReturnAllTaskItemIcon()
end

function HighTowerRewardUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function HighTowerRewardUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

return HighTowerRewardUI