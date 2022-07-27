PKMatchUI = class("PKMatchUI", BaseWindow)

local Util = require("xlua/util")

function PKMatchUI:ctor()
    local obj = LoadPrefabAndInit("PKUI/PKMatchUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKMatchUI:Create()
    self.mLabNum = self:FindChildComponent(self._gameObject, "LabNum", "Text")
    self.mLabTime = self:FindChildComponent(self._gameObject, "LabTime", "Text")

    self:AddButtonClickListener(
        self:FindChildComponent(self._gameObject, "BtnExit", "Button"),
        Util.bind(self.OnClickExit, self)
    )
end

function PKMatchUI:Init()
    local pkConfig = GetTableData("PKConfig", 1) or {}
    self.mTotalNum = (pkConfig["TotalNum"] or 0)
    self.mRobotNum = self.mTotalNum - (pkConfig["PlayerNum"] or 0)
end

function PKMatchUI:RefreshUI()
end

function PKMatchUI:OnEnable()
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.MatchStart, self.OnMatchStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.MatchEnd, self.OnMatchEnd, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.MatchCancel, self.OnMatchCancel, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.Match, self.OnMatch, self)

    -- 刷新界面
    self:Reset()
end

function PKMatchUI:OnDisable()
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.MatchStart, self.OnMatchStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.MatchEnd, self.OnMatchEnd, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.MatchCancel, self.OnMatchCancel, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.Match, self.OnMatch, self)
end

function PKMatchUI:Update()
    self:RefreshTip()
end

-- 根据PKManager重置界面
function PKMatchUI:Reset()
    self:RefreshTip()
end

--region UI监听事件
function PKMatchUI:OnMatchStart(data)
    self.mRandNum = 0

    self:OnMatch()
end

function PKMatchUI:OnMatchEnd()
    self.mLabNum.text = string.format("玩家（%d/%d）", self.mTotalNum, self.mTotalNum)
    RemoveWindowImmediately("PKMatchUI")
end

function PKMatchUI:OnMatchCancel()
    RemoveWindowImmediately("PKMatchUI")
end

function PKMatchUI:OnMatch()
    self.mTime = os.time()
    self:RefreshTip()
end
--endregion

-- 取消匹配
function PKMatchUI:OnClickExit()
    PKManager:GetInstance():RequestCancelMatch()
end

function PKMatchUI:RefreshTip()
    local matchData = PKManager:GetInstance():GetMatchData()

    if matchData and matchData.Num then
        -- 客户端负责做匹配数据
        self.mRandNum = (self.mRandNum or 0)
        if math.random(0, 1) < 0.0001 then
            self.mRandNum = self.mRandNum + 1
        end
        local num = matchData.Num + math.min(self.mRandNum, self.mRobotNum)
        num = math.min(num, self.mTotalNum)
        self.mLabNum.text = string.format("玩家（%d/%d）", num, self.mTotalNum)
    end

    if matchData and matchData.EndTime then
        local diffTime = matchData.EndTime - os.time()
        self.mLabTime.text = string.format("剩余时间%d秒", math.max(0, math.ceil(diffTime)))
    end
end

return PKMatchUI
