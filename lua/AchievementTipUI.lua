AchievementTipUI = class("AchievementTipUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function AchievementTipUI:Create()
	local obj = LoadPrefabAndInit("AchievementUI/AchievementTipUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end 
end

function AchievementTipUI:Init()
    self.comItemIcon = ItemIconUI.new()
    self.objAchieveTip = self:FindChild(self._gameObject, "AchieveTip")
    self.comCanvasGroup = self.objAchieveTip:GetComponent("CanvasGroup")
end

function AchievementTipUI:RefreshUI(info)
    if not (info and (type(info) == "table") and (#info > 0)) then
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

function AchievementTipUI:FeachAndShow()
    if not (self.mailBox and (#self.mailBox > 0) and self.curIndex) then
        return
    end
    self.curIndex = self.curIndex + 1  -- take a new index
    local curAchieveID = self.mailBox[self.curIndex]
    if not curAchieveID then
        RemoveWindowImmediately("AchievementTipUI")
        self.mailBox = nil
        self.bPlaying = nil
        return
    end
    self:SetAchieveMsg(curAchieveID)
    self.objAchieveTip:SetActive(true)
    self.comCanvasGroup:DR_DOCanvasGroupFade(1,0,1,2.5,false,function()
        local win = GetUIWindow("AchievementTipUI")
        if not win then
            return
        end
        win:FeachAndShow()
    end)
    self.comCanvasGroup:DR_DOCanvasGroupFade(0,1,1)
end

function AchievementTipUI:SetAchieveMsg(uiAchieveTypeID)
    if not uiAchieveTypeID then
        return
    end
    local acheiveTypeData = TableDataManager:GetInstance():GetTableData("Achieve",uiAchieveTypeID)
    if not acheiveTypeData then
        return 
    end
    local objMsg = self:FindChild(self.objAchieveTip, "Msg")
    local TMP_name = self:FindChildComponent(objMsg,"TMP_name","Text")
    local Text_desc = self:FindChildComponent(objMsg,"Text_desc","Text")
    local Text_AchievePoint = self:FindChildComponent(objMsg,"Text_AchievePoint","Text")
    TMP_name.text = GetLanguageByID(acheiveTypeData.NameID) 
    TMP_name.color = getRankColor(acheiveTypeData.Rank)
    Text_AchievePoint.text = acheiveTypeData.AchievePoint or 0
    Text_desc.text = GetLanguageByID(acheiveTypeData.DesID) 
    -- 初始化成就奖励
    local objReward = self:FindChild(self.objAchieveTip, "Reward")
    -- 要显示几个奖励, 是在ui里就设计好的, 策划保证了最多只有两个奖励
    local aNodeRewards = {
        self:FindChild(objReward, "ItemIcon1"),
        self:FindChild(objReward, "ItemIcon2")
    }
    local akRewards = AchieveDataManager:GetInstance():GetAchieveRewardArray(uiAchieveTypeID) or {}
    local rewardData = nil
    for index, node in ipairs(aNodeRewards) do
        rewardData = akRewards[index]
        if rewardData then
            node:SetActive(true)
            self.comItemIcon:UpdateUIWithItemTypeData(node, TableDataManager:GetInstance():GetTableData("Item",rewardData.uiTypeID))
            self.comItemIcon:SetItemNum(node, rewardData.uiNum)
            self.comItemIcon:RemoveClickFunc(node)
        else
            node:SetActive(false)
        end
    end
end

function AchievementTipUI:OnDestroy()
    self.comItemIcon:Close()
end

return AchievementTipUI