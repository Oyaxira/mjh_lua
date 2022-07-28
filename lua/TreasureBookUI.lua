TreasureBookUI = class("TreasureBookUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

local TreasureBookServerRewardUI = require 'UI/TownUI/TreasureBookServerRewardUI'
local TreasureBookRewardUI = require 'UI/TownUI/TreasureBookRewardUI'
local TreasureBookTaskUI = require 'UI/TownUI/TreasureBookTaskUI'
local TreasureBookStoreUI = require 'UI/TownUI/TreasureBookStoreUI'

TreasureBookUI.PageType = {
    Server = 1,
    Reward = 2, 
    Task = 3,
    Store = 4,
}

function TreasureBookUI:ctor()
    self.TreasureBookServerRewardUIInst = TreasureBookServerRewardUI.new()
    self.TreasureBookRewardUIInst = TreasureBookRewardUI.new()
    self.TreasureBookTaskUIInst = TreasureBookTaskUI.new()
    self.TreasureBookStoreUIInst = TreasureBookStoreUI.new()
end

function TreasureBookUI:Create()
	local obj = LoadPrefabAndInit("TownUI/TreasureBookUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
    -- tab栏
    self.objTabsBox = self:FindChild(self._gameObject, "Tabs/Box")
    self.objToggleServer = self:FindChild(self.objTabsBox, "Server")
    self.objToggleReward = self:FindChild(self.objTabsBox, "Reward")
    self.objToggleTask = self:FindChild(self.objTabsBox, "Task")
    self.objToggleStore = self:FindChild(self.objTabsBox, "Store")

    --子页面集合
    local objServerReward = self:FindChild(self._gameObject, "TreasureBookServerRewardUI")
    local objReward = self:FindChild(self._gameObject, "TreasureBookRewardUI")
    local objTask = self:FindChild(self._gameObject, "TreasureBookTaskUI")
    local objStore = self:FindChild(self._gameObject, "TreasureBookStoreUI")
    -- 奖励总览界面
    self.objAllRewards = self:FindChild(self._gameObject, "TreasureBookAllRewardUI")
    
    self.tableSubViews = {
        [self.PageType.Server] = {
            ['ui'] = objServerReward,
            ['inst'] = self.TreasureBookServerRewardUIInst,
            ['tab'] = self.objToggleServer,
        },
        [self.PageType.Reward] = {
            ['ui'] = objReward,
            ['inst'] = self.TreasureBookRewardUIInst,
            ['tab'] = self.objToggleReward,
        }, 
        [self.PageType.Task] = {
            ['ui'] = objTask,
            ['inst'] = self.TreasureBookTaskUIInst,
            ['tab'] = self.objToggleTask,
        },
        [self.PageType.Store] = {
            ['ui'] = objStore,
            ['inst'] = self.TreasureBookStoreUIInst,
            ['tab'] = self.objToggleStore,
        },
    }
end

function TreasureBookUI:Init()
    local toggleInst = nil
    for ePageType, data in pairs(self.tableSubViews) do
        -- tab监听
        toggleInst = data.tab:GetComponent(l_DRCSRef_Type.Toggle)
        if toggleInst then
            self.tableSubViews[ePageType]['toggleInst'] = toggleInst
            local fun = function(bool)
                self:SwitchSubView(ePageType, bool)
            end
            self:AddToggleClickListener(toggleInst, fun)
        end
        -- 子页面初始化
        data.inst:Init(self._gameObject, self)
        data.ui:SetActive(false)
    end
    -- 其他值
    self.eDefaultSubView = self.PageType.Reward  -- 默认页面
    self.bookManager = TreasureBookDataManager:GetInstance()
end

function TreasureBookUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "TreasureBookUI", 
        --['titleName'] = "百宝书",
        ['topBtnState'] = {
            ['bBackBtn'] = true,
            ['bGold'] = true,
            ['bSilver'] = true,
            ['bTreasureBook'] = true,
        },
        ['bSaveToCache'] = true,
        ['iYOffset'] = 6,
        ['style'] = 3,
    })
    for ePageType, data in pairs(self.tableSubViews) do
        if data.inst and data.inst.OnEnable then
            data.inst:OnEnable()
        end
    end
    -- 每次进入百宝书都要进行的请求
    self.bookManager:SendEnterTreasureBookRequest()
end

function TreasureBookUI:OnDisable()
    RemoveWindowBar('TreasureBookUI')
    for ePageType, data in pairs(self.tableSubViews) do
        if data.inst and data.inst.OnDisable then
            data.inst:OnDisable()
        end
    end
    -- 清空当前选择页面
    self.curSubView = nil
    -- 其他回调
    local callBackList = self.bookManager:GetBookCloseCallBack()
    if callBackList and (#callBackList > 0) then
        for index, func in ipairs(callBackList) do
            func()
        end
    end
    self.bookManager:ClearBookCloseCallBack()
end

function TreasureBookUI:RefreshUI(info)
    if info and info.ePageType and (info.ePageType > 0) then
        self:InitSubViewShow(info.ePageType)
        return
    elseif self.curSubView then
        self:SwitchSubView(self.curSubView, true)
        return
    end
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:CheckBookProgressData()
    else
        self.bookManager:RequestTreasureBookBaseInfo(function()
            local win = GetUIWindow("TreasureBookUI")
            if win then
                win:CheckBookProgressData()
            end
        end)
    end
end

-- 检查百宝书全服等级进度信息
function TreasureBookUI:CheckBookProgressData()
    if self.bookManager:GetTreasureBookServerProgressData() then
        self:InitSubViewShow()
    else
        self.bookManager:RequestTreasureBookServerProgressData(function()
            local win = GetUIWindow("TreasureBookUI")
            if win then
                win:InitSubViewShow()
            end
        end)
    end
end

-- 初始化子页面的显示
function TreasureBookUI:InitSubViewShow(eTarPage)
    -- 直接跳转到指定页
    local ePage2Show = self.eDefaultSubView
    if eTarPage then
        ePage2Show = eTarPage
    elseif self.bookManager:IfHaveServerReward2Get() then
        -- 如若存在可以领取的全服等级奖励, 那么显示全服等级页面
        ePage2Show = self.PageType.Server
    end
    local data = self.tableSubViews[ePage2Show]
    if data and data.toggleInst then
        data.toggleInst.isOn = true
        self:SwitchSubView(ePage2Show, true, info)
        return
    end
end

--切换子页面 子页面名称/ 是否显示/ 参数传递
function TreasureBookUI:SwitchSubView(ePageType, bShow, info)
    if not(self.tableSubViews and self.tableSubViews[ePageType]) then 
        return
    end
    bShow = (bShow == true)
    local data = self.tableSubViews[ePageType]
    if not data then 
        return 
    end
    if data.ui then
        data.ui:SetActive(bShow)
        self.curSubView = ePageType
    end
    if bShow and (data.inst ~= nil) then
        data.inst:RefreshUI(info)
    end
end

function TreasureBookUI:OnDestroy()
    self.TreasureBookServerRewardUIInst:Close()
    self.TreasureBookRewardUIInst:Close()
    self.TreasureBookTaskUIInst:Close()
    self.TreasureBookStoreUIInst:Close()
end

return TreasureBookUI
