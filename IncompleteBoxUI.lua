IncompleteBoxUI = class("IncompleteBoxUI",BaseWindow)
local TaskItemUI = require 'UI/Task/TaskItemUI'

function IncompleteBoxUI:ctor()
    self.TaskItemUI = TaskItemUI.new()
end

function IncompleteBoxUI:OnPressESCKey()
    if self.comButtonClose then
        self.comButtonClose.onClick:Invoke()
    end
end

function IncompleteBoxUI:Create()
	local obj = LoadPrefabAndInit("IncompleteBox/IncompleteBoxUI",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function IncompleteBoxUI:Init()
    self.objInfo = self:FindChild(self._gameObject,'info')

    -- 导航
    self.objNavigation = self:FindChild(self.objInfo,"SC_nav/Viewport/Content")
    self.objNavTemplate = self:FindChild(self.objInfo,"SC_nav/template")
    self.objNavTemplate:SetActive(false)

    -- 关闭按钮
    self.comButtonClose = self:FindChildComponent(self._gameObject,"newFrame/Btn_exit",'Button')
    if self.comButtonClose then
        self:AddButtonClickListener(self.comButtonClose, function() RemoveWindowByQueue('IncompleteBoxUI') end)
    end

    -- 右侧标题
    self.objTitle = self:FindChild(self.objInfo,"title")
    self.comGetText = self:FindChildComponent(self.objTitle,"get/Text", "Text")
    self.objWord = self:FindChild(self.objTitle,"word")
    self.comWordText = self:FindChildComponent(self.objTitle,"word/Text", "Text")
    self.comButtonQuestion = self:FindChildComponent(self.objTitle,"Button_question", "Button")
    if self.comButtonQuestion then
        self:AddButtonClickListener(self.comButtonQuestion, function()
            -- 添加 tips
            local tips = self:ShowTips()
            OpenWindowImmediately("TipsPopUI", tips)
        end)
    end

    -- 右侧内容
    self.comContentScroll = self:FindChildComponent(self.objInfo,"LoopScrollView","LoopVerticalScrollRect")
    if self.comContentScroll then
       local fun = function(transform, idx)
           -- 渲染，包括日期 和 武学条目
           self:RefreshItem(transform, idx)
       end
       self.comContentScroll:AddListener(fun)
   end

   self:InitNav()
end

local rank_value = {
    [RankType.RT_White] = 5,
    [RankType.RT_Green] = 10,
    [RankType.RT_Blue] = 20,
    [RankType.RT_Purple] = 50,
    [RankType.RT_Orange] = 100,
    [RankType.RT_Golden] = 150,
    [RankType.RT_DarkGolden] = 200,
}

local rank_nav = {
    [1] = RankType.RT_RankTypeNull,
    [2] = RankType.RT_White,
    [3] = RankType.RT_Green,
    [4] = RankType.RT_Blue,
    [5] = RankType.RT_Purple,
    [6] = RankType.RT_Orange,
    [7] = RankType.RT_Golden,
    [8] = RankType.RT_DarkGolden,
}

function IncompleteBoxUI:ShowTips()
    local tips = {}
    local content = {}
    
    tips.title = '武学残文获取说明'
    content[#content + 1] = "某门武学等级上限达到20后，新获得的残章将被分解为武学残文。\n"
    content[#content + 1] = "武学残文可用于将武学等级上限突破至30。\n"
    content[#content + 1] = "不同品质残章分解获得的武学残文数量为：\n"

    local martialConvert = TableDataManager:GetInstance():GetTable("MartialRemainsConvertConfig");
    for k,v in pairs(martialConvert) do
        local rankText = GetEnumValueLanguageID('RankType', v.InCompleteBookRank);
        rankText = GetLanguageByID(rankText)
        if k == RankType.RT_DarkGolden then
            rankText = string.format("%s\t\t\t%d", getRankBasedText(k, rankText), v.ConvertNum)
        else
            rankText = string.format("%s\t\t\t\t%d", getRankBasedText(k, rankText), v.ConvertNum)
        end
        
        if v.RemainsQuality == MartialRemainsRank.MRR_LOW then
            rankText = rankText .. '残文';
        elseif v.RemainsQuality == MartialRemainsRank.MRR_MID then
            rankText = rankText .. '残文';
        elseif v.RemainsQuality == MartialRemainsRank.MRR_HIGH then
            rankText = rankText .. '残文';
        end
        -- rankText = getRankBasedText(k, rankText)
        content[#content + 1] = rankText
    end

    tips.content = table.concat(content, "\n")
    return tips
end

function IncompleteBoxUI:InitNav()
    self.class = RankType.RT_RankTypeNull
    for i = 1, #rank_nav do
        local ui_temp = CloneObj(self.objNavTemplate, self.objNavigation)
        if (ui_temp ~= nil) then
            ui_temp:SetActive(true)
            local comNavText = self:FindChildComponent(ui_temp, "Text", "Text")
            local rankText = ''
            if rank_nav[i] == RankType.RT_RankTypeNull then
                rankText = dtext(979)
            else
                rankText = GetEnumValueLanguageID('RankType', rank_nav[i])
                rankText = GetLanguageByID(rankText)
            end
            comNavText.text = getRankBasedText(rank_nav[i], rankText)
            -- SetUIntDataInGameObject(ui_temp, 'index', rank_nav[i])
            local comToggle = ui_temp:GetComponent('Toggle')
            local objUnclick = self:FindChild(ui_temp, 'UnClick')
            if comToggle then
                self:AddToggleClickListener(comToggle, function(bool)
                    objUnclick:SetActive(not bool)
                    if bool then
                        self:ChooseNav(rank_nav[i])
                    end
                end)
                if rank_nav[i] == RankType.RT_RankTypeNull then
                    comToggle.isOn = true
                end
            end
        end
    end
end

function IncompleteBoxUI:ChooseNav(enum)
    if not self.record then return end
    self.class = enum
    self:UpdateInfo()
end

function IncompleteBoxUI:RefreshUI(info)
    -- local result = {}
	-- result["iNum"] = netStreamValue:ReadInt()
	-- result["akRecord"] = {}
	-- for i = 0,result["iNum"] do
	-- 	if i >= result["iNum"] then
	-- 		break
	-- 	end
	-- 	result["akRecord"][i] = {}
	-- 	result["akRecord"][i]["dwTypeID"] = netStreamValue:ReadInt()
	-- 	result["akRecord"][i]["dwDreamLandTime"] = netStreamValue:ReadInt()
	-- 	result["akRecord"][i]["dwArriveMaxLvl"] = netStreamValue:ReadInt()
	-- 	result["akRecord"][i]["dwAddInCompleteTextNum"] = netStreamValue:ReadInt()
	-- end
    -- return result
    
    self.record = nil
    if info and info['akRecord'] then
        self.record = self:Reverse(info['akRecord'])        -- 排序，只需要在 RefreshUI 里做
    end
    self:UpdateInfo()

    -- 岳巍： uiTotalInCompleteTextNum 给的是 所有剧本获得的残文总数
    -- self.comWordText.text = string.format('%s: %d',dtext(984), info['uiTotalInCompleteTextNum'] or 0)
    self.comWordText.text = string.format('%s: %d',dtext(984), self:GetCW(self.record))

end

function IncompleteBoxUI:Reverse(t)
    if type(t) ~= 'table' then
        return t
    end
    
    local array = {}
    local size = getTableSize(t)
    for i = size, 1, -1 do
        table.insert( array, t[i - 1] )
    end    
    return array
end

function IncompleteBoxUI:UpdateInfo()
    self.showData = self:Filter(self.record)
    self.showData = self:Generate(self.showData)

    if self.class == RankType.RT_RankTypeNull then
        self.objWord:SetActive(true)
    else
        self.objWord:SetActive(false)
    end
    self.comGetText.text = string.format('%s: %d',dtext(983), self.filter_num)

    -- 计算排序好的数据个数，填入个数并渲染
    self.comContentScroll.totalCount = getTableSize(self.showData)
    self.comContentScroll:RefillCells()
    self.comContentScroll:RefreshNearestCells()
end

function IncompleteBoxUI:GetCW(record)
    if not record then
        return 0
    end
    local total = 0
    for i = 1, #record do
        if record[i]['dwAddInCompleteTextNum'] then
            total = total + record[i]['dwAddInCompleteTextNum']
        end
    end
    return total
end

function IncompleteBoxUI:Filter(record)
    self.filter_num = 0
    if not record then
        return {}
    end
    local showData = {}
    for i = 1, #record do
        local martialID = record[i]['dwTypeID']
        local martialTypeData = GetTableData("Martial",martialID)
        if martialTypeData then
            local martialRank = martialTypeData.Rank
            if self.class == RankType.RT_RankTypeNull or self.class  == martialRank then
                table.insert( showData, record[i] )
                self.filter_num = self.filter_num + (record[i].dwAddInCompleteBookNum or 1)
            end
        end
    end
    return showData
end

-- transform 从 0 开始的
function IncompleteBoxUI:RefreshItem(transform, idx)
    local showData = self.showData[idx + 1]
    if showData then
        local martialID = showData['dwTypeID']
        local martialTypeData = nil
        if martialID and (martialID > 0) then
            martialTypeData = GetTableData("Martial",martialID)
        end
        local dreamLandTime = showData['dwDreamLandTime']
        local maxLevel = showData['dwArriveMaxLvl']
        local textNum = showData['dwAddInCompleteTextNum']
        local bookNum = showData['dwAddInCompleteBookNum']
        local martialName = ''
        local showItem

        local objTimer = self:FindChild(transform.gameObject, "TimeRecord_node")
        local textTimer = self:FindChildComponent(objTimer, "Text_tiem", "Text")
        local objText = self:FindChild(transform.gameObject, "Text")
        local comText = objText:GetComponent("Text")
        local comTextOutline = objText:GetComponent("OutlineEx")
        local objItemIcon = self:FindChild(transform.gameObject, "TaskItemIconUI")
        local objImageLow = self:FindChild(transform.gameObject, "ImageLow")
        local objImageMid = self:FindChild(transform.gameObject, "ImageMid")
        local objImageHigh = self:FindChild(transform.gameObject, "ImageHigh")
        objImageLow:SetActive(false);
        objImageMid:SetActive(false);
        objImageHigh:SetActive(false);
        objTimer:SetActive(false)
        objText:SetActive(false)
        if objItemIcon then 
            -- self.TaskItemUI:UpdateUI(objItemIcon, itemID, type)
        end
        if martialTypeData then
            martialName = GetLanguageByID(martialTypeData.NameID)
            martialName = getRankBasedText(martialTypeData.Rank, martialName)
            showItem = TaskDataManager:GetMartialPageItem(martialID, bookNum)
            objItemIcon:SetActive(true)
            self.TaskItemUI:UpdateUI(objItemIcon, showItem)
            
            if dnull(textNum) then
                local strText = '';
                local martialConvert = GetTableData("MartialRemainsConvertConfig", martialTypeData.Rank);
                if martialConvert.RemainsQuality == MartialRemainsRank.MRR_LOW then
                    strText = '';
                    objImageLow:SetActive(true);
                elseif martialConvert.RemainsQuality == MartialRemainsRank.MRR_MID then
                    strText = '';
                    objImageMid:SetActive(true);
                elseif martialConvert.RemainsQuality == MartialRemainsRank.MRR_HIGH then
                    strText = '';
                    objImageHigh:SetActive(true);
                end

                comText.text = string.format("%s%s%d%s%s", martialName, dtext(981), textNum, strText,dtext(982))
            elseif maxLevel then
                comText.text = string.format("%s%s%d", martialName, dtext(980), maxLevel + bookNum + 10)
            else
                comText.text = ""
            end
            -- comText.color = DRCSRef.Color.Black
            objText:SetActive(true)
        else
            objItemIcon:SetActive(false)
            local kTimeStruct = getDreamlandTimeStruct(dreamLandTime)
            if kTimeStruct then
                textTimer.text = EvolutionDataManager:GetInstance():GetLunarDate(kTimeStruct.Year,kTimeStruct.Month,kTimeStruct.Day)
            else
                textTimer.text = ""
            end
            objTimer:SetActive(true)
            -- comTextOutline.OutlineWidth = 1
            -- comText.color = DRCSRef.Color.White
        end
    end
end

-- 排序需要显示的数据（排序有问题，直接按先后顺序就行了）
-- function IncompleteBoxUI:Arrange(record)
--     local arrangeData = table_c2lua(record)
--     table.sort(arrangeData, function(a,b)
--         if a['dwDreamLandTime'] == b['dwDreamLandTime'] then
--             if a['dwTypeID'] == b['dwTypeID'] then
--                 if a['dwArriveMaxLvl'] == b['dwArriveMaxLvl'] then
--                     return false    -- 数据完全一样，不用排
--                 end
--                 return a['dwArriveMaxLvl'] > b['dwArriveMaxLvl']    -- 最后排提升等级
--             end
--             return a['dwTypeID'] > b['dwTypeID']    -- 再排武学ID
--         end
--         return a['dwDreamLandTime'] > b['dwDreamLandTime']  -- 先排时间
--     end)
--     return arrangeData
-- end

-- 遍历一遍记录，按 天（100刻）为单位划分，并插入时间数据
function IncompleteBoxUI:Generate(record)
    local currentDay = -1
    for i = 1, #record do
        if record[i]['dwDreamLandTime'] // 100 ~= currentDay then
            currentDay = record[i]['dwDreamLandTime'] // 100
            local time = {
                ['dwDreamLandTime'] = record[i]['dwDreamLandTime']
            }
            table.insert(record, i, time)
            i = i + 1   -- i 的元素变成了 i+1，因此要跳一格
        end
    end
    return record
end

function IncompleteBoxUI:OnDestroy()
    self.TaskItemUI:Close()
end


return IncompleteBoxUI