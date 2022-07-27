AchieveDiffDropUI = class("AchieveDiffDropUI",BaseWindow)
local AchieveDiffDropIconUI = require 'UI/Achieve/AchieveDiffDropIconUI'
local DiffDropType = {
    TASK = 1,
    EXPLORE = 2,
}
function AchieveDiffDropUI:ctor()
    self.AchieveDiffDropIconUI = AchieveDiffDropIconUI.new()
end

function AchieveDiffDropUI:OnPressESCKey()
    if self.comReturn_Button then
	    self.comReturn_Button.onClick:Invoke()
    end
end

function AchieveDiffDropUI:Init(objParent, instParent)
    --初始化
    local obj = LoadPrefabAndInit("LuckyUI/LuckyUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
    
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"frame/Btn_exit","Button")
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
    end

    self.comItemLoopScroll = self:FindChildComponent(self._gameObject, 'main/ItemList', 'LoopVerticalScrollRect')
    self.comItemLoopScroll:AddListener(function(...) 
        if self:IsOpen() == true then
            self:OnItemScrollChanged(...) 
        end
    end)

    -- 剧本界面设置
    self.comScriptDropDown = self:FindChildComponent(self._gameObject,'main/StoryList','Dropdown')
    self.textDropDownTitle = self:FindChildComponent(self._gameObject, "main/StoryList/Label", "Text")
    self.textScriptName = self:FindChildComponent(self._gameObject, "main/StoryName/Name", "Text")

    self.comScriptDropDown:ClearOptions()
    self.scripts = {}
    local optionsData = {}
    local TB_Story = TableDataManager:GetInstance():GetTable("Story")
    for key, value in pairs(TB_Story) do
        local tbstory = value
        local strName = GetLanguageByID(tbstory.NameID)
        local optionData = CS.UnityEngine.UI.Dropdown.OptionData(strName, nil)
        table.insert(optionsData, optionData)
        table.insert(self.scripts,tbstory.BaseID)
    end
    self.comScriptDropDown:AddOptions(optionsData)
    self.comScriptDropDown.onValueChanged:RemoveAllListeners()
    local fun = function(index)
        local id = self.scripts[index + 1]
        self:UpdateUI(id)
	end
    self.comScriptDropDown.onValueChanged:AddListener(fun)
    
    -- 难度界面设置
    -- self.comDiffText = self:FindChildComponent(self._gameObject, 'DifficultList/Text', 'Text')
    -- self.comDiffText.text = "难度1"

    -- 切换剧本界面设置
    self.comSwitchScriptButton = self:FindChildComponent(self._gameObject, "main/StoryName/Button", "Button")
    self:AddButtonClickListener(self.comSwitchScriptButton,function()
        self:OnClick_SwitchScript()
    end)

    self.comDiffLoopScroll =  self:FindChildComponent(self._gameObject, 'main/DifficultList/ScrollView', 'LoopVerticalScrollRect')
    -- #TODO 难度上限 没有接口
    local maxDiff = 30
	local minDiff = 1
	local storyData = TableDataManager:GetInstance():GetTableData("Story", GetCurScriptID())
	if storyData then
		maxDiff = storyData.DifficultMax
		minDiff = storyData.DifficultMin
	end
    self.comDiffLoopScroll.totalCount = maxDiff
    self.comDiffLoopScroll:AddListener(function(...)
        if self:IsOpen() == true then
            self:OnDiffScrollChanged(...) 
        end
    end)

    -- 仅显示未获得界面设置
    self.objOnlyShowUnGet = self:FindChild(self._gameObject, "main/Setting")
    self.objOnlyShowUnGetImgFalse = self:FindChild(self._gameObject, "main/Setting/Image_false")
    self.objOnlyShowUnGetImgTrue = self:FindChild(self._gameObject, "main/Setting/Image_true")
    self.comOnlyShowUnGet = self:FindChildComponent(self._gameObject,"main/Setting", "Button")
    if (self.comOnlyShowUnGet) then
        local fun = function()
			self:OnClick_Switch_OnlyShow()
        end
        self:AddButtonClickListener(self.comOnlyShowUnGet,fun)
    end

    self.textLuckyValue = self:FindChildComponent(self._gameObject, "main/LuckyValue", "Text")
    self.textLuckyValue.text = ""

    self.objProgress = self:FindChild(self._gameObject, "main/Progress")
    self.comProgressSlider = self:FindChildComponent(self.objProgress,"Slider", "Slider")
    self.comProgressSlider.value = 0
    self.textProgressText = self:FindChildComponent(self.objProgress, "Text_num", "Text")
    self.textProgressText.text = "0%"

    self.objToggle_task = self:FindChild(self._gameObject,"main/ToggleGroup/Tag_1")
    self.comToggle_task = self:FindChildComponent(self._gameObject,"main/ToggleGroup/Tag_1","Toggle")
    self.comToggle_task_name = self:FindChildComponent(self._gameObject,"main/ToggleGroup/Tag_1/text_name","Text")
    self.comToggle_task_info = self:FindChildComponent(self._gameObject,"main/ToggleGroup/Tag_1/text_info","Text")
    if self.comToggle_task then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_Nav(LuckyItemType.LIT_QUEST,self.comToggle_task_info)
            else
            end
        end
        self:RemoveToggleClickListener(self.comToggle_task)
        self:AddToggleClickListener(self.comToggle_task,fun)
    end
    self.comToggle_explore = self:FindChildComponent(self._gameObject,"main/ToggleGroup/Tag_2","Toggle")
    self.comToggle_explore_name = self:FindChildComponent(self._gameObject,"main/ToggleGroup/Tag_2/text_name","Text")
    self.comToggle_explore_info = self:FindChildComponent(self._gameObject,"main/ToggleGroup/Tag_2/text_info","Text")
    if self.comToggle_explore then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_Nav(LuckyItemType.LIT_EXPLORE,self.comToggle_explore_info)
            else
            end
        end
        self:RemoveToggleClickListener(self.comToggle_explore)
        self:AddToggleClickListener(self.comToggle_explore,fun)
    end


    self.comInfoAreaBtn = self:FindChildComponent(self._gameObject,"main/InfoTextArea/Info_Btn","DRButton") 
    if self.comInfoAreaBtn then 
        local fun = function()
            self:OnClick_Btn_Info_Text()
        end
        self:AddButtonClickListener(self.comInfoAreaBtn,fun)
    end  
    self.comInfoAreaText = self:FindChildComponent(self._gameObject,"main/InfoTextArea/Text_info","Text")

    self.objStoryLucky = self:FindChild(self._gameObject, "LuckyState")
    self.objStoryLucky:SetActive(false)
    self.transStoryLuckyState = self.objStoryLucky.transform

    self.onlyShowUnget = true -- 默认开启
    self.diff = minDiff       -- 难度
    self.scriptID = 1   -- 剧本
    self.colorTabNameOnChoose = DRCSRef.Color.white
    self.colorTabNameUnChoose = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1)
    self.colorTabInfoOnChoose = DRCSRef.Color(0.8, 0.8, 0.8, 1)
    self.colorTabInfoUnChoose = DRCSRef.Color(0.4, 0.4, 0.4, 1)

    self.comDiffLoopScroll:RefillCells()

end
function AchieveDiffDropUI:OnClick_Toggle_Nav(iType,text_obj) 
    if iType ~= self.int_ChoseTogType then 
        self.int_ChoseTogType = iType
        -- self.RefreshUI
        -- 刷新道具显示列表 
        -- 都默认选择未获取的
        -- 选任务 
        if self.int_ChoseTogType == LuckyItemType.LIT_EXPLORE then 
            self.comInfoAreaText.text = '以下奖励，探索江湖获得。'
        else 
            self.comInfoAreaText.text = '以下奖励，在任务中额外掉落，本难度中仅限一次。'
        end 
        self:UpdateUI()

        self.comToggle_task_name.color = self.colorTabNameUnChoose
        self.comToggle_explore_name.color = self.colorTabNameUnChoose
        self.comToggle_task_info.color = self.colorTabInfoUnChoose
        self.comToggle_explore_info.color = self.colorTabInfoUnChoose
        if iType == LuckyItemType.LIT_QUEST then
            self.comToggle_task_name.color = self.colorTabNameOnChoose
            self.comToggle_task_info.color = self.colorTabInfoOnChoose
        elseif iType == LuckyItemType.LIT_EXPLORE then
            self.comToggle_explore_name.color = self.colorTabNameOnChoose
            self.comToggle_explore_info.color = self.colorTabInfoOnChoose
        end
    end
end
function AchieveDiffDropUI:OnClick_Btn_Info_Text() 
    local str_tips = {}
    str_tips.title = ''
    if  self.int_ChoseTogType == LuckyItemType.LIT_EXPLORE then 
        str_tips.content = '1.以下奖励，通过江湖探索获取。每次开启新游戏时重置。\n2.点击图标，可以查询其大致出处。\n3.幸运状态不同，奖励会有所区别。'
    else 
        str_tips.content = '1.以下奖励，通过任务奖励获取。本难度中仅限一次。\n2.点击图标，可以查询其大致出处。\n3.幸运状态不同，奖励不会变化。'
    end 
    OpenWindowImmediately("TipsPopUI",str_tips)
end

function AchieveDiffDropUI:RefreshUI(info)
    if not info then return end
    self.comToggle_task.isOn = true
    self:UpdateUI(info,nil,true)
end

function AchieveDiffDropUI:UpdateUI(scritid,diff,updateScript)
    self.scriptID = scritid or self.scriptID
    self.diff = diff or self.diff
    
    local int_canget = self:GetScriptPercent(LuckyItemType.LIT_QUEST) or 0
    self.comToggle_task_info.text = '（剩余' .. int_canget .. '）'
    int_canget = self:GetScriptPercent(LuckyItemType.LIT_EXPLORE) or 0
    self.comToggle_explore_info.text = '（剩余' .. int_canget .. '）'

    if (updateScript) then
        for i = 1,#self.scripts do
            local scriptid = self.scripts[i]
            if (scriptid == self.scriptID) then
                self.comScriptDropDown.value = i - 1
                break
            end
        end

        local TB_Story = TableDataManager:GetInstance():GetTable("Story")
        local storyData = TB_Story[self.scriptID]
        if (storyData) then
            self.textScriptName.text = GetLanguageByID(storyData.NameID)
            if (self.diff < storyData.DifficultMin) then
                self.diff = storyData.DifficultMin
            end
            local nums = storyData.DifficultMax - storyData.DifficultMin + 1
            self.comDiffLoopScroll.totalCount = nums
            self.comDiffLoopScroll:RefreshNearestCells()
        end
    end

    -- 根据难度和剧本获取所有的图标
    self.diffDropDatas = {}

    local Luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.scriptID)
    local TableDiffDropData = AchieveDataManager:GetInstance():GetDiffDropTBData(self.diff, self.scriptID)
    for k,v in pairs(TableDiffDropData) do
        local StoryDiffDrop = v
        local diffdata = {}
        diffdata.tableData = v
        if self.int_ChoseTogType == StoryDiffDrop.Type then 
            local alreadyGetInfo = AchieveDataManager:GetInstance():GetDiffDropDataByTypeID(v.BaseID, self.scriptID,self.diff)
            local iget =  alreadyGetInfo and alreadyGetInfo.uiRoundFinish or 0
            local iall = StoryDiffDrop and StoryDiffDrop.NumLimit
            if iall == 0 then iall = 1 end 
            -- 这里判断相应的幸运值物品有没有
            local rewardData = AchieveDataManager:GetInstance():GetDiffDropRewordByLucky(v,Luckyvalue)

            if (rewardData and rewardData['Type'] ~= 0) then
              if (iget >= iall) then
                diffdata.getinfo = alreadyGetInfo
                table.insert(self.diffDropDatas, diffdata)
              else
                table.insert(self.diffDropDatas, diffdata)
              end
            end
        end
    end

    table.sort(self.diffDropDatas, function(a, b)
        if a and b and a.tableData and b.tableData and a.tableData.BaseID < b.tableData.BaseID then
            return true
        end
        return false
    end)


    self.comItemLoopScroll.totalCount = #self.diffDropDatas
    self.comItemLoopScroll:RefillCells()

    self.comDiffLoopScroll:RefreshCells()

    local finishPercent = self:GetScriptPercent(nil, true) or 0
    self.comProgressSlider.value = finishPercent

    finishPercent = finishPercent * 100
    self.textProgressText.text = string.format("%.0f%%",finishPercent)

    local curLucyValue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.scriptID)
    local iCurLevel = self:GetLuckyLevel(curLucyValue) or 1
    for index = 1, self.transStoryLuckyState.childCount do
      self.transStoryLuckyState:GetChild(index - 1).gameObject:SetActive(iCurLevel == index)
    end

    -- 这里实现很临时，针对宇文柯剧本特殊做的处理，需要后续改掉，colourstar
    if (self.scriptID == 10) then
        self.objToggle_task:SetActive(false)
        if(self.int_ChoseTogType ~= LuckyItemType.LIT_EXPLORE) then
            self.comToggle_task.isOn = false
            self.comToggle_explore.isOn = true
            self:OnClick_Toggle_Nav(LuckyItemType.LIT_EXPLORE,self.comToggle_explore_info)
            self.process_toggle_flag = true
        end
    else
        self.objToggle_task:SetActive(true)
        if (self.process_toggle_flag) then
            self.process_toggle_flag = false
            self.comToggle_task.isOn = true
            self.comToggle_explore.isOn = false
            self:OnClick_Toggle_Nav(LuckyItemType.LIT_QUEST,self.comToggle_task_info)
        end
    end
end

function AchieveDiffDropUI:OnDestroy()
    self.AchieveDiffDropIconUI:Close()
    if(self.comScriptDropDown and self.comScriptDropDown.onValueChanged) then
        self.comScriptDropDown.onValueChanged:RemoveAllListeners()
        self.comScriptDropDown.onValueChanged:Invoke()
    end
end

function AchieveDiffDropUI:OnClick_Return_Town_Button()
    RemoveWindowImmediately("AchieveDiffDropUI",true)
end

function AchieveDiffDropUI:OnItemScrollChanged(transform, idx)
    if not (transform and idx and self.diffDropDatas) then
        return
    end
    local objNode = transform.gameObject
    table.sort(self.diffDropDatas,function(a,b)
        if a.getinfo ~=nil and b.getinfo ~=nil then
            if a.tableData.BaseID < b.tableData.BaseID then
               return true
            else
                return false
            end
        elseif a.getinfo ~=nil and b.getinfo ==nil then
            return false
        elseif a.getinfo ==nil and b.getinfo ~=nil then
            return true
        else
            if a.tableData.BaseID < b.tableData.BaseID then
                return true
             else
                return false
             end
        end
    end)
    local data = self.diffDropDatas[idx + 1]
    if (data == nil) then
        return
    end
    local bfinish = false
    if data.getinfo ~= nil then 
        if  data.getinfo.uiRoundFinish and data.getinfo.uiRoundFinish ~= 0 then
            bfinish = true
        end
    end
    self.AchieveDiffDropIconUI:UpdateIcon(objNode,data.tableData, bfinish, false, self.scriptID, self.diff)
end

function AchieveDiffDropUI:OnDiffScrollChanged(transform, idx)
    if not (transform and idx) then
        return
    end
    local objNode = transform.gameObject
    objNode:SetActive(true)
    local diff = idx + 1
    local mindiff = 1
    local TB_Story = TableDataManager:GetInstance():GetTable("Story")
    local storyData = TB_Story[self.scriptID]
    if (storyData) then
        mindiff = storyData.DifficultMin
    end
    
    local trudiff = diff + mindiff - 1

    local textDiff = self:FindChildComponent(objNode, "Text", "Text")
    textDiff.text = "难度" .. tostring(trudiff)

    local objChooseNode = self:FindChild(objNode, "Image_chosen")
    if (self.diff == trudiff) then
        objChooseNode:SetActive(true)
        textDiff.color = DRCSRef.Color(0.91, 0.91, 0.91, 1);
    else
        objChooseNode:SetActive(false)
        textDiff.color = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1);
    end

    local comButton = objNode:GetComponent("Button")
    if not comButton then
        return
    end

    self:RemoveButtonClickListener(comButton)
    local fun = function()
        self:UpdateUI(nil,trudiff)
    end
    self:AddButtonClickListener(comButton, fun)
end

function AchieveDiffDropUI:OnClick_Switch_OnlyShow()
    self.onlyShowUnget = not self.onlyShowUnget
    if (self.onlyShowUnget) then
        self.objOnlyShowUnGetImgFalse:SetActive(false)
        self.objOnlyShowUnGetImgTrue:SetActive(true)
    else
        self.objOnlyShowUnGetImgFalse:SetActive(true)
        self.objOnlyShowUnGetImgTrue:SetActive(false)
    end

    self:UpdateUI()
end

function AchieveDiffDropUI:GetScriptIsOK(tb_diffData,scriptid)
    if (tb_diffData.Script == nil) then
        return true
    end
    local scriptIsOK = false
    for i = 1,#tb_diffData.Script do
        local script = tb_diffData.Script[i]
        if (script == scriptid) then
            return true
        end
    end

    return false
end

function AchieveDiffDropUI:GetScriptPercent(i_type, calcuFinish)
    local finishNums = 0
    local totalNums = 0

    local b_ret_canget = i_type and true or false 
    i_type = i_type or self.int_ChoseTogType
    local Luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.scriptID)

    local TableDiffDropData = AchieveDataManager:GetInstance():GetDiffDropTBData(self.diff, self.scriptID)
    for k,v in pairs(TableDiffDropData) do
        local StoryDiffDrop = v
        local diffdata = {}
        if i_type == StoryDiffDrop.Type then 
            diffdata.tableData = v
            local alreadyGetInfo = AchieveDataManager:GetInstance():GetDiffDropDataByTypeID(v.BaseID, self.scriptID,self.diff)
            local iget =  alreadyGetInfo and alreadyGetInfo.uiRoundFinish or 0
            local iall = StoryDiffDrop and StoryDiffDrop.NumLimit
            if iall == 0 then iall = 1 end 

            local rewardData = AchieveDataManager:GetInstance():GetDiffDropRewordByLucky(v,Luckyvalue)

            if (rewardData and rewardData['Type'] ~= 0) then
                if (iget < iall) then
                    finishNums = finishNums + iget
                    totalNums = totalNums + iall
                end
                if (calcuFinish and iget >= iall) then
                    finishNums = finishNums + iget
                    totalNums = totalNums + iall
                end

            end
        end
    end

    if (totalNums == 0) then
        return 0
    end
    if b_ret_canget then 
        return totalNums - finishNums 
    end 

    return finishNums / totalNums
end

function AchieveDiffDropUI:OnClick_SwitchScript()
    local storyId = self:GetNextStoryID()
    if (storyId == 0) then
        return
    end

    self:UpdateUI(storyId,nil,true)
end

function AchieveDiffDropUI:GetNextStoryID()
    local tableStory = TableDataManager:GetInstance():GetTable("Story")
    if (not tableStory or next(tableStory) == nil) then
        return 0
    end
    local curstoryid = self.scriptID
    for i = 1,#tableStory do
        if(tableStory[i].BaseID == curstoryid) then
            if (i == #tableStory) then
                return tableStory[1].BaseID
            else
                return tableStory[i + 1].BaseID
            end
        end
    end

    return 0
end

-- 根据幸运值返回当前幸运档次
function AchieveDiffDropUI:GetLuckyLevel(iLuckyValue)
	iLuckyValue = iLuckyValue or 0
	local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
	if iLuckyValue >= (commonConfig.HighLuckyValueMin or 0) then
		return 1
	elseif iLuckyValue >= (commonConfig.MidLuckyValueMin or 0) then
		return 2
	else
		return 3
	end
end

return AchieveDiffDropUI