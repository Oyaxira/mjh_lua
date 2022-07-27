PlayerReturnTipUI = class("PlayerReturnTipUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function PlayerReturnTipUI:Create()
	local obj = LoadPrefabAndInit("PlayerReturnUI/PlayerReturnTipUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end 
end

function PlayerReturnTipUI:Init()
    self.comItemIcon = ItemIconUI.new()
    self.objAchieveTip = self:FindChild(self._gameObject, "Tip")
    self.comCanvasGroup = self.objAchieveTip:GetComponent("CanvasGroup")
end

function PlayerReturnTipUI:RefreshUI(info)
    if not info then
        return
    end
    if not self.mailBox then
        self.mailBox = info
        self.curIndex = 0
    else
        table.move(info, 1, #info, #self.mailBox + 1, self.mailBox)
    end
    if not self.bPlaying then
        self.bPlaying = true
        self:FeachAndShow()
    end
end

function PlayerReturnTipUI:FeachAndShow()
    if not (self.mailBox and (#self.mailBox > 0) and self.curIndex) then
        return
    end
    self.curIndex = self.curIndex + 1  -- take a new index
    local kTaskData = self.mailBox[self.curIndex]
    if not kTaskData then
        RemoveWindowImmediately("PlayerReturnTipUI")
        self.mailBox = nil
        self.bPlaying = nil
        return
    end
    self:SetAchieveMsg(kTaskData)
    self.objAchieveTip:SetActive(true)
    self.comCanvasGroup:DR_DOCanvasGroupFade(1,0,1,2.5,false,function()
        local win = GetUIWindow("PlayerReturnTipUI")
        if not win then
            return
        end
        win:FeachAndShow()
    end)
    self.comCanvasGroup:DR_DOCanvasGroupFade(0,1,1)
end

function PlayerReturnTipUI:SetAchieveMsg(kTaskData)
    if not kTaskData then
        return
    end

    local objMsg = self:FindChild(self.objAchieveTip, "Msg")
    local Text_desc = self:FindChildComponent(objMsg,"Text_desc","Text")
    Text_desc.text = GetLanguageByID(kTaskData.NameID) 
    -- 初始化成就奖励
    local objReward = self:FindChild(self.objAchieveTip, "Reward")
    -- 要显示几个奖励, 是在ui里就设计好的, 策划保证了最多只有三个奖励
    local aNodeRewards = {
        self:FindChild(objReward, "ItemIcon1"),
        self:FindChild(objReward, "ItemIcon2"),
        self:FindChild(objReward, "ItemIcon3")
    }

    for index, node in ipairs(aNodeRewards) do
        if kTaskData.ItemReward and  kTaskData.ItemReward[index] then
            local itemID = kTaskData.ItemReward[index]
            node:SetActive(true)
            self.comItemIcon:UpdateUIWithItemTypeData(node, TableDataManager:GetInstance():GetTableData("Item",itemID))
            self.comItemIcon:SetItemNum(node, kTaskData.ItemRewardSum[1])
            self.comItemIcon:RemoveClickFunc(node)
        else
            node:SetActive(false)
        end
    end
end

function PlayerReturnTipUI:OnDestroy()
    self.comItemIcon:Close()
end

return PlayerReturnTipUI