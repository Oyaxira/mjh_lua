BattleTreasureBox = class("BattleTreasureBox")--后期若出现大量类似功能单位，可再抽一层

local Vec3_Scale = DRCSRef.Vec3(0.27, 0.27, 0.27)
function BattleTreasureBox:ctor()
    self.rewards = {}
    self.gridX = -1
    self.gridY = -1
    self.level = -1
end

function BattleTreasureBox:Clear()
    self.skeletonAnimation = nil
    ReturnObjectToPool(self._gameObject)
    self._gameObject = nil
    self.rewards = nil
    self.gridX = -1
    self.gridY = -1
    self.level = -1
end

--单一职能，只做数据初始化
function BattleTreasureBox:Init(kParent,level)
    self.modelID = BattleDataManager:GetInstance():GetTreasureBoxModelID(level)
    local strPath = BattleDataManager:GetInstance():GetTreasureBoxSpinePath(level)
    self._gameObject = LoadSpineFromPool(string.format("Actor/obj_Treasure_box/%s/%s_prefab",strPath,strPath),kParent,true)
	if self._gameObject == nil then
        derror("load "..strPath.."is nil")
        return 
    end
    self._gameObject.transform.localScale= Vec3_Scale
    self.skeletonAnimation = self._gameObject:GetComponent("SkeletonAnimation")
end

function BattleTreasureBox:SetData(kData)
    if not kData then
        return
    end
    local iGridX = kData['iGridX'] + 1
    local iGridY = kData['iGridY'] + 1
    if self.gridX ~= iGridX or self.gridY ~= iGridY then
        self:SetPos(iGridX,iGridY)
    end
    
    if self.level ~= kData['uiLevel'] then
        self:SetLevel(kData['uiLevel'])
    end

    self:SetRewards(kData['akReward'],kData.iNum)
end

function BattleTreasureBox:SetPos(x,y)
    self.gridX = x
    self.gridY = y
    local baseLayer = GetDepthByGridPos(self.gridX,self.gridY)
    -- self.skeletonAnimation.sortingOrder = baseLayer
    if self._gameObject then 
        self._gameObject:GetComponent("MeshRenderer").sortingOrder = baseLayer
        self._gameObject.transform.localPosition = GetPosByGrid(x,y)
    end

end

function BattleTreasureBox:SetLevel(lv)
    self.level = lv
end

function BattleTreasureBox:SetRewards(rewards,iNum)
    self.rewards = rewards
    self.iNum = iNum
end

function BattleTreasureBox:ShowRewards()
    if self.hadShow then return end
    self.hadShow = true
    local lang = GetLanguageByID(480011)
    for i=0,self.iNum-1 do
        local reward = self.rewards[i]
        if reward.eType == 11 then 
            reward.uiItemID = 1301
        end
        local itemName = ''
        local itemBaseData = TableDataManager:GetInstance():GetTableData('Item', reward.uiItemID)
        if itemBaseData then 
            itemName = itemBaseData.ItemName or ''
        end
        SystemUICall:GetInstance():Toast(string.format(lang,itemName,reward.uiNums or 1))
    end
end

function BattleTreasureBox:PlayIdleAnimation(complete)
    SetSkeletonAnimation(self.skeletonAnimation, 0, "idle", true)
end

function BattleTreasureBox:PlayOpenAnimation(complete)
    if not self.skeletonAnimation then
        return
    end
    LogicMain:GetInstance():LockQuitBattle()
    AnimationMgr:GetInstance():CreateAndRunAnim(self.OpenAndDisappear,self,complete)
end

function BattleTreasureBox:OpenAndDisappear(complete)
    if self.skeletonAnimation ~= nil and self.skeletonAnimation.AnimationState ~= nil then
        SetSkeletonAnimation(self.skeletonAnimation, 0, SPINE_ANIMATION.BOX_OPEN, false, function()
            self.skeletonAnimation.AnimationState:AddAnimation(0,SPINE_ANIMATION.BOX_DISAPPEAR,false,0)
        end)
        local time = getActionFrameTime(self.modelID,SPINE_ANIMATION.BOX_OPEN)
        self.isOpen = true
        LuaEventDispatcher:dispatchEvent("BATTLE_ADD_LOG",{{"宝箱被打开了",TBoolean.BOOL_YES}})
        AnimationMgr:GetInstance():wait_time(time)
        if complete then 
            complete()
        end
    end
end

function BattleTreasureBox:GetPos()
    return self.gridX,self.gridY
end

function BattleTreasureBox:GetLevel()
    return self.level
end

function BattleTreasureBox:GetRewards()
    return self.rewards
end

return BattleTreasureBox