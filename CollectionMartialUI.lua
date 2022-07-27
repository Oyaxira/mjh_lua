CollectionMartialUI = class('CollectionMartialUI', BaseWindow);

local SkillIconUI = require 'UI/Skill/SkillIconUI';

local KungfuType = {
    '所有',
    '拳掌',
    '剑法',
    '刀法',
    '腿法',
    '暗器',
    '奇门',
    '内功',
    '轻功',
    '医术',
    '阵法',
}

local lowTips = {
    title = '武学残文',
    content =   '某门武学等级上限达到20后，新获得的残章将被分解为武学残文\n' ..
                '可用于将武学等级上限突破至30',
}

local midTips = {
    title = '武学残文',
    content =   '某门武学等级上限达到20后，新获得的残章将被分解为武学残文\n' ..
                '可用于将武学等级上限突破至30',
}

local highTips = {
    title = '武学残文',
    content =   '某门武学等级上限达到20后，新获得的残章将被分解为武学残文\n' ..
                '可用于将武学等级上限突破至30',
}

local BaseLevelLimitUp = 10;
local GrowUpLevelLimitUp = 10;

function CollectionMartialUI:ctor()
    self.bindBtnTable = {};

    self.clickSkillData = nil;
    self.toggleSkillIndex = 0;
end

function CollectionMartialUI:SetParent(parent)
    self.parent = parent;
end

function CollectionMartialUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/CollectionMartialUI', self.parent or UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function CollectionMartialUI:Init()

    self.skillIconUI = SkillIconUI.new()
    self.collectionDataManager = CollectionDataManager:GetInstance();
    self.TableDataManager = TableDataManager:GetInstance();
    self.playerData = PlayerSetDataManager:GetInstance();
    self.tbSysOpenData = self.TableDataManager:GetSystemOpenByType(SystemType.SYST_IncompleteText);

    --
    self.objLeft = self:FindChild(self._gameObject, 'Left');
    self.objRight = self:FindChild(self._gameObject, 'Right');
    self.objImageUnlockNum = self:FindChild(self._gameObject, 'Image_UnlockNum');
    
    self.objImageMid = self:FindChild(self._gameObject, 'Image_Mid');
    self.objImageHei = self:FindChild(self._gameObject, 'Image_Hei');
    self.objBackBtn = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Button_back');
    self.comBackBtn = self.objBackBtn:GetComponent("Button")
    --
    self.objLeftSCList = self:FindChild(self.objLeft, 'SC_List');
    self.objLeftSCContent = self:FindChild(self.objLeftSCList, 'Viewport/Content');
    
    --
    self.objRightLeft = self:FindChild(self.objRight, 'Left');
    self.objRightRight = self:FindChild(self.objRight, 'Right');
    
    --
    self.objRightLeftSCList = self:FindChild(self.objRightLeft, 'SC_List');
    self.objRightLeftSCContent = self:FindChild(self.objRightLeftSCList, 'Viewport/Content');
    
    --
    self.objRightBox = self:FindChild(self.objRightRight, 'Right_Box');
    self.objImageUp = self:FindChild(self.objRightRight, 'Image_Up');
    self.objImageLow = self:FindChild(self.objImageUp, 'Image_Low');
    self.objImageUp:SetActive(false);
    
    --
    self.objRightTileBox = self:FindChild(self.objRightBox, 'Title_Box');
    self.objRightSkillBox = self:FindChild(self.objRightBox, 'Skill_Box');
    self.objRightSCList = self:FindChild(self.objRightBox, 'SC_List');
    self.objRightSCContent = self:FindChild(self.objRightSCList, 'Viewport/Content');

    self.objRightTileBox:SetActive(false);
    self.objRightSkillBox:SetActive(false);
    self.objRightSCContent:SetActive(false);

    --
    self.objImageUpText = self:FindChild(self.objImageUp, 'Text');
    self.objImageUpTextFront = self:FindChild(self.objImageUp, 'Text_front');
    self.objImageUpTextNext = self:FindChild(self.objImageUp, 'Text_next');
    self.objImageUpImage = self:FindChild(self.objImageUp, 'Image');
    self.objImageUpButton = self:FindChild(self.objImageUp, 'Button');

    self.objImageUpBtnIcon1 = self:FindChild(self.objImageUp, 'Icon1');
    self.objImageUpBtnIcon2 = self:FindChild(self.objImageUp, 'Icon2');
    self.objImageUpBtnIcon3 = self:FindChild(self.objImageUp, 'Icon3');
    self.objImageUpBtnNum = self:FindChild(self.objImageUp, 'Num');

    --
    table.insert(self.bindBtnTable, self.objBackBtn);
    table.insert(self.bindBtnTable, self.objImageUpButton);
    table.insert(self.bindBtnTable, self.objImageLow);
    table.insert(self.bindBtnTable, self.objImageMid);
    table.insert(self.bindBtnTable, self.objImageHei);

    self:BindBtnCB();

    self:RefComplateText();
    self.collectionDataManager:GetMartialData(1, true);
    
    self:OnRefLeftSCList();

    -- 讨论区
    self.btnDiscuss = self:FindChildComponent(self.objRightRight,"Button_discuss","Button")
    if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_MARTIAL) then
        self.btnDiscuss.gameObject:SetActive(true)
        self:AddButtonClickListener(self.btnDiscuss, function()
            local articleId 
            if (self.curMartialData ~= nil) then
                local targetId = self.curMartialData.BaseID
                articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_MARTIAL,targetId)
            end
            if (articleId == nil) then
                SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
            else
                OpenWindowImmediately("DiscussUI",articleId)
            end
        end)
    else
        self.btnDiscuss.gameObject:SetActive(false)
    end

    -- 筛选按钮
    self.btnScreen = self:FindChildComponent(self._gameObject,"Button_screen",DRCSRef_Type.Toggle)
    if self.btnScreen then
        self:AddToggleClickListener(self.btnScreen, function(bIsOn)
            if bIsOn then
                local info = {
                    ["martialData"] = self.martialData,
                    ["tabIndex"] = DepartEnumType_Revert[self.clickTypeData]
                }
                --if (#self.martialData > 0) then
                    OpenWindowImmediately("MartialScreenUI",info)
                -- if (#self.martialData == 0) then
                --     self.btnScreen.isOn = false
                -- end
            else
                RemoveWindowImmediately("MartialScreenUI")
            end
        end)        
    end
end

function CollectionMartialUI:OnPressESCKey()
    if self.comBackBtn then
	    self.comBackBtn.onClick:Invoke()
    end
end

function CollectionMartialUI:SetScreenToggle(isOn)
    self.btnScreen.isOn = isOn
end

function CollectionMartialUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function CollectionMartialUI:OnclickBtn(obj, boolHide)
    if obj == self.objBackBtn then
        self:OnClickBackBtn(obj);

    elseif obj == self.objImageUpButton then
        self:OnClickUpBtn(obj);

    elseif obj == self.objImageLow then
        OpenWindowImmediately("TipsPopUI", lowTips);
        
    elseif obj == self.objImageMid then
        OpenWindowImmediately("TipsPopUI", midTips);
        
    elseif obj == self.objImageHei then
        OpenWindowImmediately("TipsPopUI", highTips);

    end
end

function CollectionMartialUI:OnClickBackBtn(obj)
    -- OpenWindowImmediately("CollectionUI");
    RemoveWindowImmediately("CollectionMartialUI", false);
end

function CollectionMartialUI:OnClickUpBtn(obj)
    if self.clickSkillData then

        local strLv = '';
        local consumeNum = 0;
        if self.upData.RemainsQuality == MartialRemainsRank.MRR_LOW then
            strLv = '初级';
            consumeNum = self.playerData:GetLowInCompleteTextNum();

        elseif self.upData.RemainsQuality == MartialRemainsRank.MRR_MID then
            strLv = '中级';
            consumeNum = self.playerData:GetMidInCompleteTextNum();
            
        elseif self.upData.RemainsQuality == MartialRemainsRank.MRR_HIGH then
            strLv = '高级';
            consumeNum = self.playerData:GetHighInCompleteTextNum();

        end
        if self.consumeNum > consumeNum then
            SystemUICall:GetInstance():Toast('武学残文不足');
            return;
        end

        SendMartialInComleteText(self.clickSkillData.martialData.BaseID);
    end
end

function CollectionMartialUI:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent('Button');
    local tog = gameObject:GetComponent('Toggle');
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)

    end
end

function CollectionMartialUI:OnRefLeftSCList()    
    local toggleGroup = self.objLeftSCContent:GetComponent('ToggleGroup');

    RemoveAllChildren(self.objLeftSCContent);
    for i = 1, #(KungfuType) do
        local objToggle = LoadPrefabAndInit('CollectionUI/Toggle_Type', self.objLeftSCContent, true)
        if (objToggle ~= nil) then
            local comToggle = objToggle:GetComponent('Toggle');
            if (comToggle ~= nil) then
                comToggle.group = toggleGroup;
            end
    
            local comName = self:FindChildComponent(objToggle, 'Name', 'Text');
            if (comName ~= nil) then
                comName.text = KungfuType[i];
            end
    
            local objMark = self:FindChild(objToggle, 'Mark');
            if (objMark ~= nil) then
                objMark.transform:GetChild(i - 1).gameObject:SetActive(true);
            end
            local _callback = function(gameObject, boolHide)
                if boolHide then
                    self:OnClickTypeToggle(gameObject, KungfuType[i], true);
                    self:FindChild(objToggle, 'markbottom2'):SetActive(true);
                    self:FindChildComponent(objToggle, 'Name','Text').color = DRCSRef.Color.white;
                else
                    self:FindChild(objToggle, 'markbottom2'):SetActive(false);
                    self:FindChildComponent(objToggle, 'Name','Text').color = DRCSRef.Color(0.17,0.17,0.17,1);
                end
            end
            self:CommonBind(objToggle, _callback);
    
            if comToggle ~= nil and i == 1 then
                comToggle.isOn = true;
            end
        end
    end
end

function CollectionMartialUI:OnClickTypeToggle(gameObject, data, bClickFrist)

    self.clickTypeData = data;

    -- 切换tab页时 重置筛选条件
    self.collectionDataManager:ResetAllMartialScreenList()

    local bInited = self:OnRefRightLeftSCList(DepartEnumType_Revert[data]);

    if bInited and bClickFrist then
        self:RefreshByFirstItem()
    end    
end

function CollectionMartialUI:RefreshByFirstItem()
    if #self.martialScreenData==0 then
        self.objImageUp:SetActive(false);
        self.objRightTileBox:SetActive(false);
        self.objRightSkillBox:SetActive(false);
        self.objRightSCContent:SetActive(false);
        return
    end
    self.lvSCRightLeft:MovePanelToItemIndex(0, 0);
    local item = self.lvSCRightLeft:GetShownItemByItemIndex(0);
    if item then
        item.gameObject:GetComponent('Button').onClick:Invoke();
    end
end


function CollectionMartialUI:OnRefRightLeftSCList(index)
    local martialData = {};
    if index == DepartEnumType.DET_All then
        martialData = self.collectionDataManager:GetAllMartialData() or {};
    else
        martialData = self.collectionDataManager:GetSingleMartialData(index) or {};
    end

    --
    local typeSum, sum = self.collectionDataManager:GetMartialNum(index);
    local comText = self:FindChildComponent(self.objImageUnlockNum, 'Text', 'Text');
    if index == DepartEnumType.DET_All then
        comText.text = string.format('已解锁:%d/%d', #(martialData), sum);
    else
        comText.text = string.format('已解锁:%d/%d', #(martialData), typeSum);
    end
    self.martialData = {}
    self.martialScreenData = {}
    if not next(martialData) then
        self.objRightLeftSCContent:SetActive(false);

        self.objImageUp:SetActive(false);
        self.objRightTileBox:SetActive(false);
        self.objRightSkillBox:SetActive(false);
        self.objRightSCContent:SetActive(false);

        return false;
    else
        self.objRightLeftSCContent:SetActive(true);
    end

    -- 使用筛选screenlist对list重新生成
    local newScreenData = {}
    for i=1,#martialData do
        if self.collectionDataManager:CheckScreen(martialData[i]) then
            newScreenData[#newScreenData+1] = martialData[i]
        end
    end

    self.martialData = martialData
    self.martialScreenData = newScreenData;
    self.martialCount = #(self.martialScreenData);

    local lvSC = self.objRightLeftSCList:GetComponent('LoopListView2');
    local scrollRect = self.objRightLeftSCList:GetComponent('ScrollRect');

    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Button_Skill');
            SetStringDataInGameObject(obj.gameObject, 'idx', tostring(index));
            if (index<self.martialCount) then
                self:OnScrollChanged(obj.gameObject, self.martialScreenData[index + 1], index);
            else
                obj.gameObject:SetActive(true)
                local objButton = obj.gameObject:GetComponent("Button") 
                if objButton then
		            self:RemoveButtonClickListener(objButton)
                    self:AddButtonClickListener(objButton, function ()
                        boxCallback = function()
                            self:OnClickTypeToggle(nil, self.clickTypeData, true)
                        end
                        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                            ["title"] = "武学筛选",
                            ["text"] = "是否要解除筛选，显示全部武学？",
                        }, boxCallback})
                    end)
                end
                local comName = self:FindChildComponent(obj.gameObject, 'Name', 'Text');
                comName.text = "其余武学("..(#self.martialData-#self.martialScreenData)..")"
                comName.color = DRCSRef.Color.white
                local comLevel = self:FindChildComponent(obj.gameObject, 'Text_level', 'Text');
                comLevel.text = ""
                comLevel.color = DRCSRef.Color.white
            
            end
            ReBuildRect(obj);
            return obj;
        end
        
        local _func1 = function()
        end

        local _func2 = function()
        end
        
        local _func3 = function()
        end

        local count
        if #self.martialScreenData ~= #self.martialData then
            count = self.martialCount+1
        else 
            count = self.martialCount
        end

        if not self.rightLeftInited then
            self.rightLeftInited = true;
            lvSC:InitListView(count, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(count, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCRightLeft = lvSC;
    end
    
    return true;
end

function CollectionMartialUI:OnScrollChanged(gameObject, data, index, bClickBtn)
    gameObject:SetActive(true);
    
    --
    if data then
        local _func = function(idx)
            for k, v in pairs(gameObject.transform.parent.transform) do
                if GetStringDataInGameObject(v.gameObject, 'idx') == tostring(idx) then
    
                    self:FindChild(v.gameObject, 'Toggle'):SetActive(true);
                else
    
                    self:FindChild(v.gameObject, 'Toggle'):SetActive(false);
                end
            end
        end
    
        local _callback = function(gameObject)
            _func(index);
            self.toggleSkillIndex = index;
            self:OnClickSkillToggle(data);
        end
        self:CommonBind(gameObject, _callback);
    
        if bClickBtn then
            _callback();
        end
    
        _func(self.toggleSkillIndex);
    
        --
        local comName = self:FindChildComponent(gameObject, 'Name', 'Text');
        comName.text = GetLanguageByID(data.martialData.NameID);
        comName.color = getRankColor(data.martialData.Rank);
    
        local comLevel = self:FindChildComponent(gameObject, 'Text_level', 'Text');
        comLevel.text = data.level + BaseLevelLimitUp;
        comLevel.color = getRankColor(data.martialData.Rank);
    end
end

function CollectionMartialUI:CanOpen()
    local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
    for i = 1, #(self.tbSysOpenData) do
        if self.tbSysOpenData[i].OpenTime <= time and self.tbSysOpenData[i].Param1 == -1 then
            return false;
        end
    end 
    return true;
end

function CollectionMartialUI:CanLevelUp(rank, level)
    local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
    local tempTable = {};
    for i = 1, #(self.tbSysOpenData) do
        if self.tbSysOpenData[i].OpenTime <= time then
            table.insert(tempTable, self.tbSysOpenData[i]);
        end
    end

    if #(tempTable) == 0 then
        return true;    
    end

    local bReturn = true;
    for i = 1, #(tempTable) do
        if tempTable[i].Param1 > 0 and tempTable[i].Param2 > 0 then
            if rank == tempTable[i].Param1 then
                if level >= tempTable[i].Param2 then
                    bReturn = bReturn and true;
                else
                    bReturn = bReturn and false;
                end
            end
        end
    end
    
    return bReturn;
end

function CollectionMartialUI:OnClickSkillToggle(data)
    self.curMartialData = data.martialData
    --
    self:UpdateTitle(data.martialData);
    self:UpdateIcon(data.martialData);
    self:OnRefRightSCList(data.martialData);

    --
    local upData = nil;
    local level = data.level;
    local rank = data.martialData.Rank;
    local TB_MartialBreakRemainsConfig = TableDataManager:GetInstance():GetTable("MartialBreakRemainsConfig")
    for i = 1, #(TB_MartialBreakRemainsConfig) do
        local config = TB_MartialBreakRemainsConfig[i];
        if config.MartialRank == data.martialData.Rank then
            upData = config;
            break;
        end
    end

    if not upData then
        return;
    end

    local index = 1;
    for i = 1, #(upData.MartialLevel) do
        if (data.level + 1 + BaseLevelLimitUp) == upData.MartialLevel[i] then
            index = i;
            break;
        end   
    end

    --
    local rect = self.objRightSCList:GetComponent('RectTransform');
    if level >= GrowUpLevelLimitUp then
        self.objImageUp:SetActive(true);
    else
        self.objImageUp:SetActive(false);
    end

    --
    self.objImageUpImage:SetActive(true);
    self.objImageUpTextNext:SetActive(true);
    self.objImageUpTextFront:SetActive(true);
    self.objImageUpButton:SetActive(true);
    local comUpTextFront = self.objImageUpTextFront:GetComponent('Text');
    comUpTextFront.text = 'LV' .. (level + BaseLevelLimitUp);
    local comUpTextNext = self.objImageUpTextNext:GetComponent('Text');
    comUpTextNext.text = 'LV' .. (level + BaseLevelLimitUp + 1);
    self.objImageUpText:GetComponent('Text').text = '等级突破:';
    -- if (level >= GrowUpLevelLimitUp + #(upData.MartialLevel)) or _canOpen() then

    if self:CanLevelUp(rank, level + GrowUpLevelLimitUp) then
        self.objImageUpText:GetComponent('Text').text = '等级突破已达上限';
        self.objImageUpImage:SetActive(false);
        self.objImageUpTextNext:SetActive(false);
        self.objImageUpTextFront:SetActive(false);
        self.objImageUpButton:SetActive(false);
    end

    if self:CanOpen() then
        self.objImageUpText:GetComponent('Text').text = '等级突破已达上限';
        self.objImageUpImage:SetActive(false);
        self.objImageUpTextNext:SetActive(false);
        self.objImageUpTextFront:SetActive(false);
        self.objImageUpButton:SetActive(false);
    end

    --
    local comTextNum = self.objImageUpBtnNum:GetComponent('Text');
    local strText1 = upData.ConsumeNum[index];
    if level >= GrowUpLevelLimitUp + #(upData.MartialLevel) then
        strText1 = 0;
    end
    comTextNum.text = strText1;

    --
    if upData.RemainsQuality == MartialRemainsRank.MRR_LOW then
        self.objImageUpBtnIcon1:SetActive(true);
        self.objImageUpBtnIcon2:SetActive(false);
        self.objImageUpBtnIcon3:SetActive(false);
    elseif upData.RemainsQuality == MartialRemainsRank.MRR_MID then
        self.objImageUpBtnIcon1:SetActive(false);
        self.objImageUpBtnIcon2:SetActive(true);
        self.objImageUpBtnIcon3:SetActive(false);
    elseif upData.RemainsQuality == MartialRemainsRank.MRR_HIGH then
        self.objImageUpBtnIcon1:SetActive(false);
        self.objImageUpBtnIcon2:SetActive(false);
        self.objImageUpBtnIcon3:SetActive(true);
    end

    self.upData = upData;
    self.consumeNum = upData.ConsumeNum[index];
    self.clickSkillData = data;
end

-- 更新右侧 / 标题，标签，系别，门派
function CollectionMartialUI:UpdateTitle(typeData)
    if not typeData then 
        return;
    end

    --
    local comMartialTitle = self:FindChildComponent(self.objRightTileBox, 'layout/label/Name', 'Text');
	comMartialTitle.text = GetLanguageByID(typeData.NameID);
	-- comMartialTitle.color = getRankColor(typeData.Rank);
    
    -- 先隐藏所有标签
    local objTitleClassText = self:FindChild(self.objRightTileBox, 'layout/Text_class');
    local objTitleClanText = self:FindChild(self.objRightTileBox, 'layout/Text_clan');
    local objTitleTagText = self:FindChild(self.objRightTileBox, 'layout/Text_tag');
	local comTitleTagText = objTitleTagText:GetComponent(DRCSRef_Type.Text)

    objTitleClassText:SetActive(false);
	objTitleClanText:SetActive(false);
	objTitleTagText:SetActive(false);
    
    -- 更新武学系别
    if typeData.DepartEnum then
        local comTitleClassText = objTitleClassText:GetComponent('Text');
		comTitleClassText.text = string.format('[%s]', GetEnumText('DepartEnumType', typeData.DepartEnum));
		objTitleClassText:SetActive(true);
	end
    
    -- 更新武学门派
	if typeData.ClanID then
		local clanTypeData = TB_Clan[typeData.ClanID];
        if clanTypeData then
            local comTitleClanText = objTitleClanText:GetComponent('Text');
			comTitleClanText.text = string.format("[%s]", GetLanguageByID(clanTypeData.NameID));
			objTitleClanText:SetActive(true);
		end
	end
    
    	-- 标签
	if typeData.Exclusive and #typeData.Exclusive > 0 then 
		comTitleTagText.text = GetLanguageByID(140093)
		objTitleTagText:SetActive(true)
	end
    self.objRightTileBox:SetActive(true);
end

-- 更新右侧 / 技能图标
function CollectionMartialUI:UpdateIcon(typeData)

	RemoveAllChildren(self.objRightSkillBox);
	self.skillIcons = {};
	local martialLevel = 10;

	-- o_skill_技能 → 附加能力
	-- 技能解锁等级：附加能力[k].解锁等级 or 0
	-- 技能进化：每种绝学，都有解锁的条件，没解锁显示进化图标加锁，解锁了就替换基础图标（角色界面）或者在后面显示（门派界面）
	-- MartMovIDs 招式ID数组（固定有的技能，对应上面一块的技能栏）
	if typeData['MartMovIDs'] then
		for i = 1, #typeData['MartMovIDs'] do
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(typeData['MartMovIDs'][i]);
			self:ParseMiToSkill(miTypeData, martialLevel, -1, i > 1);
		end
    end
    
	-- 渲染解锁等级数组+解锁词条等级数组，里面有【技能进化】的，也要在技能栏里加技能
	-- UnlockLvls 解锁等级数组（对应解锁词条）
	-- UnlockClauses 解锁词条ID数组（对应MartialItem）
	-- TODO：技能进化不好取，暂时不做
	if typeData['UnlockLvls'] and typeData['UnlockClauses'] then
		for i = 1, #typeData['UnlockClauses'] do
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(typeData['UnlockClauses'][i]);
			self:ParseMiToSkill(miTypeData, martialLevel, typeData['UnlockLvls'][i], false);
		end
	end

	-- 最后将填好的 Skill 数据 做成 图标
	if next(self.skillIcons) then
		self.objRightSkillBox:SetActive(true);
		for k, v in pairs(self.skillIcons) do
			self:AddSkillIcon(v, typeData);
		end
	else
		self.objRightSkillBox:SetActive(false);
    end
    
    --
    local rect = self.objRightSCList:GetComponent('RectTransform');
    if self.objRightSkillBox.activeSelf then
        rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, 340);
    else
        rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, 420);
    end
end

-- 在这里真正创建一个 Skill 的图标，并填入数据
function CollectionMartialUI:AddSkillIcon(iconData, typeData)
    local skillIconUI = LoadPrefabAndInit('Game/SkillIconUI', self.objRightSkillBox, true);
    if (skillIconUI ~= nil) then
        skillIconUI:SetActive(true);
    end

    local buttons = {};
    self:UpdateSkillIcon(skillIconUI, iconData, typeData, buttons);
end

-- 渲染一个 SKill 图标，绑定监听
function CollectionMartialUI:UpdateSkillIcon(obj, iconData, typeData, buttons)
	local comBtn = self:FindChildComponent(obj, 'Icon', 'Button');
    local comUIAction = self:FindChildComponent(obj, 'Icon', 'LuaUIAction');
    if not comBtn or not comUIAction then 
        return;
    end

	comBtn.enabled = true;
	self.skillIconUI:UpdateUI(obj, iconData['skillID'], iconData['isCombo'], iconData['isLock'], iconData['unlockLvl']);
	self:FindChild(obj, "Text_tips"):SetActive(false);
	if comBtn and buttons then
		self:RemoveButtonClickListener(comBtn);
		local fun = function()
			self:OnClick_ShowSkillTip(typeData, buttons, iconData['skillID']);
		end
		self:AddButtonClickListener(comBtn, fun);
        comUIAction:SetPointerEnterAction(fun)
        comUIAction:SetPointerExitAction(function()
            if IsWindowOpen("TipsPopUI") then
                RemoveWindowImmediately("TipsPopUI")
            end
        end)
    end
end

function CollectionMartialUI:OnClick_ShowSkillTip(typeData, buttons, skillid)

    local tips = TipsDataManager:GetInstance():GetSkillTips(nil, skillid, typeData.BaseID);
    if not tips then 
        return;
    end
    tips.isSkew = true
    tips.positions = {
        x = 300,
        y=  0,
    }
    SystemUICall:GetInstance():TipsPop(tips);
    
end

-- 解析一个 MartialItemTypeData
function CollectionMartialUI:ParseMiToSkill(miTypeData, uiLevel, UnlockLvl, isCombo)
    
    if not miTypeData then 
        return 
    end
    
    if miTypeData.EffectEnum1 then
		if miTypeData.EffectEnum1 == MartialItemEffect.MTT_ZHAOSHIJINENG then
			self:AddSkillNormal(miTypeData.SkillID1, uiLevel, UnlockLvl, isCombo)

		elseif miTypeData.EffectEnum1 == MartialItemEffect.MTT_JINENGJINGHUA then
            self:AddSkillEvolution(miTypeData.Effect1Value, miTypeData.CondID, uiLevel, UnlockLvl);
            
		end
	end
    
    if miTypeData.EffectEnum2 then
		if miTypeData.EffectEnum2 == MartialItemEffect.MTT_ZHAOSHIJINENG then
			self:AddSkillNormal(miTypeData.SkillID2, uiLevel, UnlockLvl, isCombo)

		elseif miTypeData.EffectEnum2 == MartialItemEffect.MTT_JINENGJINGHUA then
            self:AddSkillEvolution(miTypeData.Effect2Value, miTypeData.CondID, uiLevel, UnlockLvl);
            
		end
	end	
end

-- 处理普通技能的 UI 更新
function CollectionMartialUI:AddSkillNormal(skillID, uiLevel, unlockLvl, isCombo)

	local data = {
		['skillID'] = skillID,
		['isCombo'] = isCombo,
		['unlockLvl'] = unlockLvl,
    };
    
	if self.type == 'Clan' then
        data['isLock'] = false;
	elseif uiLevel and unlockLvl and uiLevel >= unlockLvl then
        data['isLock'] = false;
	else
        data['isLock'] = true;
    end

    data['isLock'] = false;
	table.insert(self.skillIcons, data);
end

-- 处理技能进化的 UI 更新
function CollectionMartialUI:AddSkillEvolution(effectArray, condID, uiLevel, unlockLvl)

	local beforeSkillID = effectArray[1];
	local afterSkillID = effectArray[2];
	local data = {
		['skillID'] = afterSkillID,
		['isCombo'] = false,
		['unlockLvl'] = unlockLvl,
    };
    
    -- 门派学武界面，技能进化直接显示在后面
	if self.type == 'Clan' then
        data['isLock'] = false;
        
    -- 条目解锁了，遍历技能栏，替换基础技能
	elseif uiLevel and unlockLvl and uiLevel >= unlockLvl then
		data['isLock'] = false;

		if condID > 0 then
			local compResult = RoleDataHelper.ConditionComp(condID, self.dynData, self.typeData);
			if not compResult then
				data['isLock'] = true;
			end
		end
    
    -- 条目未解锁，跟在后面
    else	
        data['isLock'] = true;
    end

    data['isLock'] = false;
    table.insert(self.skillIcons, data);
end

function CollectionMartialUI:OnRefRightSCList(data)

    local martialDetailData = MartialDataManager:GetInstance():GetMartialItemsDesc(data) or {};

    if not next(martialDetailData) then
        self.objRightSCContent:SetActive(false);
        return;
    else
        self.objRightSCContent:SetActive(true);
    end

    self.martialDetailData = martialDetailData;

    local lvSC = self.objRightSCList:GetComponent('LoopListView2');
    local scrollRect = self.objRightSCList:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_Detail');
            self:OnRightScrollChanged(obj.gameObject, self.martialDetailData[index + 1], index);
            ReBuildRect(obj);
            return obj;
        end
        
        local _func1 = function()
        end

        local _func2 = function()
        end
        
        local _func3 = function()
        end
        
        self.martialDDcount = getTableSize2(self.martialDetailData);
        if not self.rightRightInited then
            self.rightRightInited = true;
            lvSC:InitListView(self.martialDDcount, _func);
            lvSC:RefreshAllShownItem();
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.martialDDcount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCRightRight = lvSC;
    end
end

function CollectionMartialUI:OnRightScrollChanged(gameObject, data, index)

    gameObject:SetActive(true);

    if not data then
        return;
    end

    local prefix = data.prefix;
    local objLabel = self:FindChild(gameObject, 'Label');
    local comText = objLabel:GetComponent('Text');
    if prefix == '' then
        objLabel:SetActive(false);
    else
        objLabel:SetActive(true);
        comText.text = prefix;
        comText.color = data.color
        comText.color = COLOR_VALUE[COLOR_ENUM.Black]   --字体颜色修正为黑色
    end

    -- 更新条目信息
    local objtext = self:FindChildComponent(gameObject, 'Text', 'Text');
    objtext.color = data.color;
    objtext.color = COLOR_VALUE[COLOR_ENUM.Black]   --字体颜色修正为黑色
    objtext.text = data.desc;

    -- 更新条目标记
    local state = data.state;
    if state == 'achieve' then
        local comImage = self:FindChildComponent(gameObject, 'Icon_unlock', 'Image');
        comImage.color = COLOR_VALUE[COLOR_ENUM.Douzi_brown];
    end
end

function CollectionMartialUI:RefreshUI()

    self:RefComplateText();
    self.collectionDataManager:GetMartialData(1, true);
end

function CollectionMartialUI:RefComplateText()
    
    if self.objImageLow then
        local lowInCompleteTextNum =  PlayerSetDataManager:GetInstance():GetLowInCompleteTextNum()
        local comLowText = self:FindChildComponent(self.objImageLow, 'Text', 'Text')
        if lowInCompleteTextNum and comLowText then
            comLowText.text = lowInCompleteTextNum
        end
    end

    if self.objImageMid then
        local midInCompleteTextNum =  PlayerSetDataManager:GetInstance():GetMidInCompleteTextNum()
        local comMidText = self:FindChildComponent(self.objImageMid, 'Text', 'Text')
        if midInCompleteTextNum and comMidText then
            comMidText.text = midInCompleteTextNum
        end
    end

    if self.objImageHei then
        local highInCompleteTextNum = PlayerSetDataManager:GetInstance():GetHighInCompleteTextNum()
        local comHighText = self:FindChildComponent(self.objImageHei, 'Text', 'Text')
        if highInCompleteTextNum and comHighText then
            comHighText.text = highInCompleteTextNum
        end
    end
    if self.objImageUpBtnNum then
        local comText = self.objImageUpBtnNum:GetComponent("Text")
        if PlayerSetDataManager:GetInstance():GetLowInCompleteTextNum() < tonumber(comText.text) then
            comText.color = COLOR_VALUE[COLOR_ENUM.Red]
        else
            comText.color = COLOR_VALUE[COLOR_ENUM.White]
        end
    end
end

function CollectionMartialUI:OnDisable()
    self:RemoveEventListener('ONEVENT_MARTIALDATA_UPDATE');
end

function CollectionMartialUI:OnEnable()
    self:RefreshByFirstItem()
    self:AddEventListener('ONEVENT_MARTIALDATA_UPDATE', function(info)
        self:RefComplateText();
        self.collectionDataManager:GetMartialData(1, true);
        local revert = DepartEnumType_Revert[self.clickTypeData];
        if revert == DepartEnumType.DET_All then
            self.martialData = self.collectionDataManager:GetAllMartialData() or {};
        else
            self.martialData = self.collectionDataManager:GetSingleMartialData(revert) or {};
        end
        -- 使用筛选screenlist对list重新生成
        local newScreenData = {}
        for i=1,#self.martialData do
            if self.collectionDataManager:CheckScreen(self.martialData[i]) then
                newScreenData[#newScreenData+1] = self.martialData[i]
            end
        end

        self.martialScreenData = newScreenData;

        self:OnRefSingleSkill();
    end);
end

function CollectionMartialUI:OnRefSingleSkill()
    self.clickSkillData = self:GetClickMartialData() or self.clickSkillData;
    local name = GetLanguageByID(self.clickSkillData.martialData.NameID);
    SystemUICall:GetInstance():Toast(string.format('《%s》等级永久 +1', name));
    local item = self.lvSCRightLeft:GetShownItemByItemIndex(self.toggleSkillIndex);
    if not item and self.lvSCRightLeft and self.toggleSkillIndex then
        --self.lvSCRightLeft:MovePanelToItemIndex(self.toggleSkillIndex, 0);
        item = self.lvSCRightLeft:GetShownItemByItemIndex(self.toggleSkillIndex);
    end
    if item and self.clickSkillData then
        self:OnScrollChanged(item.gameObject, self.clickSkillData, self.toggleSkillIndex, true);
    end
end

function CollectionMartialUI:GetClickMartialData()
    local martialData = self.collectionDataManager:GetAllMartialData();
    if self.clickSkillData and self.clickSkillData.martialData then
        for i = 1, #(martialData) do
            if self.clickSkillData.martialData.BaseID == martialData[i].martialData.BaseID then
                return martialData[i];
            end
        end
    end
    return nil;
end

function CollectionMartialUI:OnDestroy()
    self:RemoveEventListener('ONEVENT_MARTIALDATA_UPDATE');
    if self.lvSCRightLeft then
        self.lvSCRightLeft.mOnBeginDragAction = nil;
        self.lvSCRightLeft.mOnDragingAction = nil;
        self.lvSCRightLeft.mOnEndDragAction = nil;
        self.lvSCRightLeft.mOnGetItemByIndex = nil;
    end
    
    if self.lvSCRightRight then
        self.lvSCRightRight.mOnBeginDragAction = nil;
        self.lvSCRightRight.mOnDragingAction = nil;
        self.lvSCRightRight.mOnEndDragAction = nil;
        self.lvSCRightRight.mOnGetItemByIndex = nil;
    end
end

return CollectionMartialUI;