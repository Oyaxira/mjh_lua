ResultUI = class('ResultUI', BaseWindow)

local ResultUI1 = require 'UI/ResultUI/ResultUI1'
local ResultUI2 = require 'UI/ResultUI/ResultUI2'
local ResultUI3 = require 'UI/ResultUI/ResultUI3'
local ResultUI4 = require 'UI/ResultUI/ResultUI4'
local ResultUI4_5 = require 'UI/ResultUI/ResultUI4_5'
local ResultUI5 = require 'UI/ResultUI/ResultUI5'

function ResultUI:ctor()
    self.sumScore = 0;
    self.bindBtnTable = {};
    self.objResultTable = {};
    self.inited = false;
end

function ResultUI:Create()
	local obj = LoadPrefabAndInit('ResultUI/ResultUI', UI_UILayer, true);
	if obj then
		self:SetGameObject(obj);
    end
end

function ResultUI:Init()
    
    self.objResultUI1 = self:FindChild(self._gameObject, 'ResultUI1');
    self.objResultUI2 = self:FindChild(self._gameObject, 'ResultUI2');
    self.objResultUI3 = self:FindChild(self._gameObject, 'ResultUI3');
    self.objResultUI4 = self:FindChild(self._gameObject, 'ResultUI4');
    self.objResultUI4_5 = self:FindChild(self._gameObject, 'ResultUI4_5');
    self.objResultUI5 = self:FindChild(self._gameObject, 'ResultUI5');
    self.objResultUI6 = self:FindChild(self._gameObject, 'ResultUI6');
    self.objResultUI7 = self:FindChild(self._gameObject, 'ResultUI7');

    self.objImageBG2 = self:FindChild(self._gameObject, 'Image_BG2');
    self.objImageBG3 = self:FindChild(self._gameObject, 'Image_BG3');
    self.objImageBG4 = self:FindChild(self._gameObject, 'Image_BG4');
    self.objImageBG5 = self:FindChild(self._gameObject, 'Image_BG5');
    self.objImage = self:FindChild(self._gameObject, 'Image');

    self:SetImageBGActive(false);

    table.insert(self.objResultTable, self.objResultUI1);
    table.insert(self.objResultTable, self.objResultUI2);
    table.insert(self.objResultTable, self.objResultUI3);
    table.insert(self.objResultTable, self.objResultUI4);
    table.insert(self.objResultTable, self.objResultUI4_5);
    table.insert(self.objResultTable, self.objResultUI5);
    
    self.ResultUI1 = ResultUI1.new(self);
    self.ResultUI2 = ResultUI2.new(self);
    self.ResultUI3 = ResultUI3.new(self);
    self.ResultUI4 = ResultUI4.new(self);
    self.ResultUI4_5 = ResultUI4_5.new(self);
    self.ResultUI5 = ResultUI5.new(self);
end

function ResultUI:SetImageBGActive(bActive)
    self.objImageBG2:SetActive(bActive);
    self.objImageBG3:SetActive(bActive);
    self.objImageBG4:SetActive(bActive);
    self.objImageBG5:SetActive(bActive);
    self.objImage:SetActive(bActive);
end

function ResultUI:Update()
    if IsBattleOpen() and IsWindowOpen('ResultUI') then 
        RemoveWindowImmediately('ResultUI')
    end
end

function ResultUI:RefreshUI(info)
    -- 战斗中不允许显示结算界面
    self:SetResultUIState(self.objResultUI1);
end

function ResultUI:SetResultUIState(gameObject)
    for k, v in pairs(self.objResultTable) do
        if v == gameObject then
            v:SetActive(true);
        else
            v:SetActive(false);
        end
    end
end

function ResultUI:OnEnable()
    self:OnRefUI();

    self:AddEventListener('ONEVENT_REF_RESULTUI', function()
		self:OnRefUI();
	end)
end

function ResultUI:OnRefUI()
    local info = globalDataPool:getData("WeekRoundEnd");
    if not self.inited and info then
        self.inited = true;
        self.ResultUI1:OnCreate(info);
        self.ResultUI2:OnCreate(info);
        self.ResultUI3:OnCreate(info);
        self.ResultUI4:OnCreate(info);
        self.ResultUI4_5:OnCreate(info);
        self.ResultUI5:OnCreate(info);

        self:ShowWeekLimit(info)
    end
end

function ResultUI:ShowWeekLimit(info)
    if info.uiDontTakeOut == 1 or info.uiDontTakeOut == 0 then
        local curStoryID = GetCurScriptID()
        local storyData = TableDataManager:GetInstance():GetTableData("Story", curStoryID)

        if storyData and storyData.WeekTakeOutLimit > 0 then
            if info.uiDontTakeOut == 1 then
                local text = string.format("当前剧本限定每个自然周只能结算带出物品%d次，您当前的带出次数已用尽，<color=red>下周目时将无法再带出物品</color>。", storyData.WeekTakeOutLimit)
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, text})
            else
                local text = string.format("由于您本周的结算带出物品次数已用尽，<color=red>本周目的物品将无法在结算后带出剧本</color>，给您带来的不便敬请谅解。")
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, text})
            end
        end
    end
end

function ResultUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_RESULTUI');
end

function ResultUI:OnDestroy()
    self.ResultUI1:Close();
    self.ResultUI2:Close();
    self.ResultUI3:Close();
    self.ResultUI4:Close();
    self.ResultUI4_5:Close();
    self.ResultUI5:Close();
end

return ResultUI