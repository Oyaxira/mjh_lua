BattleTreasureBoxMgr = class("BattleTreasureBoxMgr")
BattleTreasureBoxMgr._instance = nil

function BattleTreasureBoxMgr:ctor()
    self.handle = {}
    self.treasureBoxs = {}
    
end

function BattleTreasureBoxMgr:GetInstance()
    if BattleTreasureBoxMgr._instance == nil then
        BattleTreasureBoxMgr._instance = BattleTreasureBoxMgr.new()
        BattleTreasureBoxMgr._instance:BeforeInit()
    end
    return BattleTreasureBoxMgr._instance
end

function BattleTreasureBoxMgr:BeforeInit()
    self.handle.HandleTreasureBox = function() self:HandleTreasureBox() end
    LuaEventDispatcher:addEventListener("Battle_Update_TreasureBox",self.handle.HandleTreasureBox)
end

function BattleTreasureBoxMgr:Init(kParent)
    self.kParent = kParent
    self.treasureBoxs = {}
    self:HandleTreasureBox()
end

function BattleTreasureBoxMgr:Clear()
    if self.treasureBoxs then
        for _,v in pairs(self.treasureBoxs) do
            self:ReleaseTreasureBox(v)
        end
    end
   
    self.kParent = nil
end

--宝箱增删改处理函数
function BattleTreasureBoxMgr:HandleTreasureBox()
    local TreasureBoxes = globalDataPool:getData("BattleTreasureBoxes")
    if not TreasureBoxes or not self.kParent then
        return
    end

    local boxes = TreasureBoxes['boxes']
    if boxes then
        for k,v in pairs(boxes) do
            if self.treasureBoxs[k] == nil then
                --创建宝箱
                self.treasureBoxs[k] = self:CreatTreasureBox(self.kParent,v)
            end
            self.treasureBoxs[k]:SetData(v)
            if v.iFlag == BTBF_DEL then
                --删除宝箱
                self:ReleaseTreasureBox(self.treasureBoxs[k])
            elseif v.iFlag == BTBF_OPEN then
                --打开宝箱
                self:OpenTreasureBox(self.treasureBoxs[k])
            end
        end
    else
        --删除所有宝箱
        for _,v in pairs(self.treasureBoxs) do
            self:ReleaseTreasureBox(v)
        end
    end
end

function BattleTreasureBoxMgr:CreatTreasureBox(kParent,kTreasureBoxData)
    local treasureBox = BattleTreasureBox.new()
    treasureBox:Init(kParent,kTreasureBoxData['uiLevel'])
    treasureBox:SetData(kTreasureBoxData)
    treasureBox:PlayIdleAnimation()
    return treasureBox
end

function BattleTreasureBoxMgr:ReleaseTreasureBox(treasureBox)
    if treasureBox then
        if not treasureBox.isOpen then
            LuaEventDispatcher:dispatchEvent("BATTLE_ADD_LOG",{{"宝箱被敌人打开了",TBoolean.BOOL_YES}})
        end
        treasureBox:Clear()
        treasureBox = nil
    end
end

function BattleTreasureBoxMgr:OpenTreasureBox(treasureBox)
    if treasureBox then
        local func = function()
            self:ReleaseTreasureBox(treasureBox)
            LogicMain:GetInstance():ReleaseQuitBattle()
        end
        treasureBox:ShowRewards()
        treasureBox:PlayOpenAnimation(func)
    end
end

function BattleTreasureBoxMgr:OnDestroy()
    LuaEventDispatcher:removeEventListener("Battle_Update_TreasureBox",self.handle.HandleTreasureBox)
    self.handle = nil

    self:Clear()
end

return BattleTreasureBoxMgr