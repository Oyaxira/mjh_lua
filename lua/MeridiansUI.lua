MeridiansUI = class('MeridiansUI', BaseWindow);

local whiteColor = DRCSRef.Color(1, 1, 1, 1);
local redColor = DRCSRef.Color(1, 0, 0, 1);
local darkRed = DRCSRef.Color(0.1803922, 0.04705882, 0.04705882, 1);
local grayColor = DRCSRef.Color(0.5, 0.5, 0.5, 1);

local textStr = '';
local textFullStr = '';

function MeridiansUI:ctor()
    self.TABTable = {};
    self.bindBtnTable = {};
    self.removeListeners = {};
    self.breakMerdians = {};
    self.clickMeridians = nil;
    self.clickAcupoint = nil;
    self.nextLevelExp = 0;

    self.unlockStage = 1;
end

function MeridiansUI:Create()
	local obj = LoadPrefabAndInit('Meridians/MeridiansUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function MeridiansUI:Init()
    self.MeridiansDataManager = MeridiansDataManager:GetInstance();

    self.objTabUI = self:FindChild(self._gameObject, 'MeridiansWindowTabUI');
    self.objLeftUI = self:FindChild(self._gameObject, 'Left');
    self.objRightUI = self:FindChild(self._gameObject, 'TransformAdapt_node_right/Right');
    self.objDetailUI = self:FindChild(self._gameObject, 'Detail');
    self.objTipsUI = self:FindChild(self._gameObject, 'Tips');

    --
    self.TabBox = self:FindChild(self.objTabUI, 'Tab_box');
    self.transTabBox = self.TabBox.transform
    self.TabBoxToggle1 = self:FindChild(self.TabBox, 'Tab_toggle1');
    self.TabBoxToggle2 = self:FindChild(self.TabBox, 'Tab_toggle2');

    --
    self.SCTips = self:FindChild(self.objTipsUI, 'SC_tips');
    self.SCTipsCloseBtn = self:FindChild(self.objTipsUI, 'Button_close');
    self.SCTipsItem = self:FindChild(self.SCTips, 'Item');
    self.SCTipsContent = self:FindChild(self.SCTips, 'Viewport/Content');

    --
    self.LeftLine = self:FindChild(self.objLeftUI, 'Line');
    self.transLeftLine = self.LeftLine.transform
    self.LeftAcupoint = self:FindChild(self.objLeftUI, 'Acupoint');
    self.transLeftAcupoint = self.LeftAcupoint.transform
    self.LeftSCMeridians = self:FindChild(self.objLeftUI, 'TransformAdapt_node_left/SC_Meridians');
    self.LeftSCMeridiansContent = self:FindChild(self.LeftSCMeridians, 'Viewport/Content');
    self.LeftImageMask = self:FindChild(self.objLeftUI, 'Image_Mask');

    self.LeftImageMask:SetActive(false);
    
    --
    self.SCDetail = self:FindChild(self.objDetailUI, 'SC_detail');
    self.DetailAll = self:FindChild(self.objDetailUI, 'Text_all');

    --
    self.buttonBackBtn = self:FindChild(self._gameObject, 'frame/Btn_exit');
    self.breakUpBtn = self:FindChild(self.objRightUI, 'Button_breakup');
    self.textDec = self:FindChild(self.objRightUI, 'Text_Dec');
    self.levelUpBtn = self:FindChild(self.objRightUI, 'Image_btn/Button_levelUp');
    self.fullBtn = self:FindChild(self.objRightUI, 'Image_btn/Button_full');
    self.questionBtn = self:FindChild(self.objRightUI, 'Level_top/Button_question');

    self.breakUpBtn:SetActive(false);
    self.textDec:SetActive(true);

    self.comMeridiansText = self:FindChildComponent(self.objRightUI,"MeridiansText/Meridians/Text", "Text")

    self.bOpenTip = false

    --
    table.insert(self.bindBtnTable, self.buttonBackBtn);
    table.insert(self.bindBtnTable, self.breakUpBtn);
    table.insert(self.bindBtnTable, self.levelUpBtn);
    table.insert(self.bindBtnTable, self.SCTipsCloseBtn);
    table.insert(self.bindBtnTable, self.LeftImageMask);
    table.insert(self.bindBtnTable, self.TabBoxToggle1);
    table.insert(self.bindBtnTable, self.TabBoxToggle2);
    table.insert(self.bindBtnTable, self.questionBtn);
    table.insert(self.bindBtnTable, self.fullBtn);
    
    --
    self:BindBtnCB();

    self:RefreshMeridians()

	self:AddEventListener("ONEVENT_REFMERIDIANSUI",function ()
        self:RefreshMeridians()
    end,nil,nil,nil,true)
end

function MeridiansUI:OnPressESCKey()
    if self.bOpenTip == true then
        self.objTipsUI:SetActive(false)
        self.bOpenTip = false
    else
        RemoveWindowImmediately('MeridiansUI');
    end
end

-- 刷新经脉经验数量
function MeridiansUI:RefreshMeridians()
    self.comMeridiansText.text = MeridiansDataManager:GetInstance():GetCurTotalExp() or 0
end

function MeridiansUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function MeridiansUI:OnclickBtn(obj, boolHide)
    if obj == self.buttonBackBtn then
        RemoveWindowImmediately('MeridiansUI');

    elseif obj == self.levelUpBtn then
        self:OnClickLevelUpBtn(obj);

    elseif obj == self.SCTipsCloseBtn then
        self:OnClickCloseBtn(obj);
    
    elseif obj == self.TabBoxToggle1 or obj == self.TabBoxToggle2 then
        if boolHide then
            self.chooseTab = obj;
            self:UpdateTab();
        end
    
    elseif obj == self.LeftImageMask or obj == self.breakUpBtn then
        self:OnClickMaskBtn(obj);

    elseif obj == self.questionBtn then
        self:OnClickQustionBtn(obj);

    elseif obj == self.fullBtn then
        self:OnClickFullBtn(obj)

    end
end

function MeridiansUI:OnClickFullBtn(obj)
    SystemUICall:GetInstance():Toast('本穴位已达等级上限');
end

function MeridiansUI:OnClickQustionBtn(obj)
    local tips = {
        title = '冲破经脉',
        content = '1.将本经脉全部升级至上限后，将解锁本经脉的冲破功能。\n' ..
                  '2.冲破经脉将消耗一定数量的冲脉丹。\n' .. 
                  '3.冲破后，将按百分比提升本页所有经脉的属性值。',
    }
    OpenWindowImmediately("TipsPopUI", tips);
end

function MeridiansUI:OnClickMaskBtn(obj)

    local meridians = self.clickMeridians;
    if not meridians then
        return;
    end
    local netMessage = function()
        local seMeridiansInfo = {
            [0] = {
                dwMeridianID = meridians.BaseID,
                dwAcupointID = meridians.BaseID * 1000,
            }
        }
    
        SendMeridiansOpr(SMOT_BREAK_LIMIT, getTableSize2(seMeridiansInfo), seMeridiansInfo);
    end

    local breakData = self.MeridiansDataManager:GetBreakData(meridians.BaseID);
    local breakValue = meridians.BreakConsume[breakData.dwLevel + 1] or 0;
    local value = self.MeridiansDataManager:GetCurTotalBreak();

    if breakValue > value then
        SystemUICall:GetInstance():Toast('冲灵丹不足');
    else
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '是否消耗冲灵丹，\n提升当前经脉的全属性百分比？', netMessage });
    end
end

function MeridiansUI:OnClickCloseBtn(obj)
    self.objTipsUI:SetActive(false);
    self.bOpenTip = false
end

function MeridiansUI:OnClickLevelUpBtn(obj)
    local curTotalExp = self.MeridiansDataManager:GetCurTotalExp();

    -- if self.isSend then
    --     return;  
    -- end

    if not self.chooseNode then
        return;
    end

    if curTotalExp and self.nextLevelExp > curTotalExp then
        SystemUICall:GetInstance():Toast('经脉经验不足');
        return;
    end

    local acupoint = self.clickAcupoint;
    if not acupoint then
        return;
    end
    local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupoint);
    if serverAcupointData.dwLevel >= self.MeridiansDataManager:GetAcupointLevel(acupoint.BaseID) then
        SystemUICall:GetInstance():Toast('等级已达上限');
        return;
    end

    local netMessage = function()
        local seMeridiansInfo = {
            [0] = {
                dwMeridianID = acupoint.OwnerMeridian,
                dwAcupointID = acupoint.BaseID,
            }
        }
    
        SendMeridiansOpr(SMOT_LEVEL_UP, getTableSize2(seMeridiansInfo), seMeridiansInfo);
    end

    local particleEffect = self:FindChild(self.chooseNode, 'ef_jingmai_touch');
    if particleEffect then
        particleEffect:SetActive(true);
        particleEffect:GetComponent("ParticleSystem"):Play();
    end
    netMessage();
end

function MeridiansUI:RefreshUI(info)
    self.unlockStage = self.MeridiansDataManager:GetUnlockStage();
    self.TabBoxToggle2:GetComponent('Toggle').isOn = true;
    self:InitTab(true);
    self:UpdateTab();
end

function MeridiansUI:InitTab(autoClick, noDec, noMove)
    local tfContent = self.LeftSCMeridiansContent.transform;
    self:RemoveAllChildToPoolAndClearEvent(tfContent);
    self.TABTable = {};
    self.breakMerdians = {};

    local meridiansData = self.MeridiansDataManager:GetMeridiansData();
    if not meridiansData then
        return;
    end
    local unlockStage = self.MeridiansDataManager:GetUnlockStage();
    local upGradeStage = false;
    if self.unlockStage ~= unlockStage then
        upGradeStage = true;
    end
    self.unlockStage = unlockStage;
    local showTab = {};
    local willUnlock = {};
    for k, v in pairs(meridiansData) do
        local meridians = meridiansData[k];
        local stage = meridians.Stage;
        local lockStage = 0;
        local curUnlockStage = 0;
        local curIndex = 0;

        for i = 1, #(stage) do
            if unlockStage >= stage[i] then
                curUnlockStage = stage[i];
                curIndex = i;
            else
                lockStage = stage[i];
                break;
            end
        end

        --
        if upGradeStage and (curUnlockStage == unlockStage) then
            local temp = {
                meridians = meridians,
                unlock = curIndex,
            }
            table.insert(willUnlock, temp);
        end

        if curUnlockStage > 0 then 
            table.insert(showTab, meridians);

            --
            local level = self.MeridiansDataManager:GetLevel(meridians, false);
            local levelUp = self.MeridiansDataManager:GetLevel(meridians, true);
            local breakData = self.MeridiansDataManager:GetBreakData(meridians.BaseID);
            if breakData.dwLevel == 0 then
                if (level >= levelUp) or (curIndex - breakData.dwLevel > 1) then
                    table.insert(self.breakMerdians, meridians);
                end
            else
                if (level >= levelUp) and (curIndex > breakData.dwLevel) then
                    table.insert(self.breakMerdians, meridians);
                end
            end
        end
    end

    local unlockDec = {};
    for i = 1, #(willUnlock) do
        local tempData = willUnlock[i]
        local meridians = tempData.meridians;
        local unlock = tempData.unlock;
        local tempTable = {};
        tempTable.dec = meridians.UnlockDescID[unlock];
        tempTable.sprite = meridians.Background;
        table.insert(unlockDec, tempTable);
    end

    RemoveAllChildren(self.SCTipsContent);
    if #(unlockDec) > 0 and (not noDec) then

        -- 最后一期
        if #(willUnlock) > 2 then
            for i = 1, 1 do
                local item = LoadPrefabAndInit('Meridians/Item_dec', self.SCTipsContent);
                local comText = self:FindChildComponent(item, 'Text', 'Text');
                comText.text = '全经脉各穴位等级提升至100';
            end
        else
            for i = 1, #(unlockDec) do
                local dec = unlockDec[i].dec;
                local sprite = unlockDec[i].sprite;
                local item = LoadPrefabAndInit('Meridians/Item_dec', self.SCTipsContent);
                local comImage = self:FindChildComponent(item, 'Image', 'Image');
                local comText = self:FindChildComponent(item, 'Text', 'Text');
                comImage.sprite = GetSprite(sprite);
                comText.text = GetLanguageByID(dec);
            end
        end

        self.objTipsUI:SetActive(true);
        self.bOpenTip = true
    else
        self.objTipsUI:SetActive(false);
        self.bOpenTip = false
    end

    table.sort(showTab, function(a, b)
        return b.ShowArray > a.ShowArray;
    end)

    local bNoFull = false;
    for i = 1, #(showTab) do
        local meridians = showTab[i];
        local tab = self:LoadPrefabFromPool('Meridians/Toggle_Meridian', tfContent)
        local tog = tab:GetComponent('Toggle');
        tog.group = self.LeftSCMeridiansContent:GetComponent('ToggleGroup');
        tog.isOn = false;
        local _callback = function(gameObject, boolHide)
            if boolHide then
                self.chooseTab = tab;
                self.clickMeridians = meridians;
                self:UpdateTab();
            end
        end
        self:CommonBind(tab, _callback);

        SetStringDataInGameObject(tab, 'id', tostring(meridians.BaseID));
        self:FindChildComponent(tab, 'Label', 'Text').text = GetLanguageByID(meridians.NameID);

        local level = self.MeridiansDataManager:GetLevel(meridians, false);
        local LevelUp = self.MeridiansDataManager:GetLevel(meridians, true);
        if (level < LevelUp) and (not bNoFull) then
            bNoFull = true;
            if autoClick then
                self.clickMeridians = meridians;
            end
        end

        table.insert(self.TABTable, tab);
    end

    if bNoFull or noMove then
        self:UpdateTabState();
    else
        self.TABTable[#(self.TABTable)]:GetComponent('Toggle').isOn = true;
    end
end

function MeridiansUI:UpdateTabState()
    local transform = self.LeftSCMeridiansContent.transform;
    for i = 1, transform.childCount do
        local go = transform:GetChild(i - 1).gameObject;
        local str = GetStringDataInGameObject(go, 'id');
        if self.clickMeridians and (str == tostring(self.clickMeridians.BaseID)) then
            go:GetComponent('Toggle').isOn = true;
            self:FindChildComponent(go, 'Label', 'Text').color = DRCSRef.Color(0.88, 0.88, 0.88, 1);
        else
            go:GetComponent('Toggle').isOn = false;
            self:FindChildComponent(go, 'Label', 'Text').color = DRCSRef.Color(0.17, 0.17, 0.17, 1);
        end
    end
end

function MeridiansUI:UpdateTab()
    local meridiansData = self.MeridiansDataManager:GetMeridiansData();
    if not meridiansData then
        return;
    end
    self.clickMeridians = self.clickMeridians or meridiansData[1];

    self.objLeftUI:SetActive(false);
    self.objRightUI:SetActive(false);
    self.objDetailUI:SetActive(false);
    if self.chooseTab == self.TabBoxToggle1 then
        self:ShowDetailAttr();
        self.objDetailUI:SetActive(true);
    else
        self:InitNode();
        self:UpdateNode();
        local meridians = self.clickMeridians;
        local sprite = GetSprite(meridians.Background);
        if sprite then
            self:FindChildComponent(self.objLeftUI, 'Image', 'Image').sprite = sprite;
        end
        self:UpdateBreakMerdiansMask(meridians);
        self.objLeftUI:SetActive(true);
        self.objRightUI:SetActive(true);
    end
end

function MeridiansUI:UpdateBreakMerdiansMask(meridiansData)
    local valueTable = {10, 30, 60, 100};
    local meridians = self.clickMeridians;
    if not meridians then
        return;
    end
    local breakData = self.MeridiansDataManager:GetBreakData(meridians.BaseID);
    local value = valueTable[breakData.dwLevel + 1] or 0;

    -- self.LeftImageMask:SetActive(false);

    -- self.levelUpBtn:GetComponent('Button').enabled = true;
    -- setUIGray(self.levelUpBtn:GetComponent('Image'), false);
    -- self.levelUpBtn:SetActive(true);

    local bCanBreak = false;
    for i = 1, #(self.breakMerdians) do
        if meridiansData and self.breakMerdians[i].BaseID == meridiansData.BaseID then
            -- self.LeftImageMask:SetActive(true);
            local comText = self:FindChildComponent(self.breakUpBtn, 'Number', 'Text');
            local breakValue = meridians.BreakConsume[breakData.dwLevel + 1] or 0;
            comText.text = breakValue;
            local value = self.MeridiansDataManager:GetCurTotalBreak() or 0;
            comText.color = breakValue > value and redColor or whiteColor;
            self.breakUpBtn:SetActive(false);
            self.textDec:SetActive(false);
            bCanBreak = true;

            -- self.levelUpBtn:GetComponent('Button').enabled = false;
            -- setUIGray(self.levelUpBtn:GetComponent('Image'), true);
            -- self.levelUpBtn:SetActive(false);
        end
    end

    if breakData.dwLevel >= #(valueTable) then
        self.textDec:GetComponent('Text').text = textFullStr;
    else
        self.textDec:GetComponent('Text').text = string.format(textStr, value);
    end

    if not bCanBreak then
        self.breakUpBtn:SetActive(false);
        self.textDec:SetActive(true);
    end
end

function MeridiansUI:RemoveBreakMeridians(meridiansData)
    for i = 1, #(self.breakMerdians) do
        if self.breakMerdians[i].BaseID == meridiansData.BaseID then
            table.remove(self.breakMerdians, i);
            break;
        end
    end
end

function MeridiansUI:InitNode()
    self:RemoveAllChildToPoolAndClearEvent(self.transLeftAcupoint)
    self:RemoveAllChildToPoolAndClearEvent(self.transLeftLine)

    self.chooseNode = nil;

    -- 读取经脉节点
    local clickMeridians = self.clickMeridians;
    local meridiansData = self.MeridiansDataManager:GetMeridiansData();
    local acupointData = self.MeridiansDataManager:GetAcupointData();
    
    if not meridiansData or not acupointData or not clickMeridians then
        return;
    end

    local contains = nil;
    local acupointTable = {};
    for k, v in pairs(acupointData) do
        if v.OwnerMeridian == self.clickMeridians.BaseID then
            contains = meridiansData[v.OwnerMeridian].AcupointID;
            table.insert(acupointTable, v);
        end
    end

    local unFullAcupoint = nil;
    for i = 1, #(acupointTable) do
        local acupoint = acupointTable[i];
        local level = 0;
        --local level = contains and contains[acupoint.BaseID] or 0;
        local levelUp = self.MeridiansDataManager:GetAcupointLevel(acupoint.BaseID);
        local acu = self:LoadPrefabFromPool('Meridians/Acu_toggle', self.transLeftAcupoint)
        local tog = acu:GetComponent('Toggle');
        tog.group = self.LeftAcupoint:GetComponent('ToggleGroup');
        tog.isOn = false;
        self:FindChild(acu, 'ef_jingmai'):SetActive(false);
        self:FindChild(acu, 'ef_jingmai_idle'):SetActive(false);
        self:FindChildComponent(acu, 'ef_jingmai_idle', 'ParticleSystem'):Stop();
        self:FindChild(acu, 'ef_jingmai_touch'):SetActive(false);
        self:FindChildComponent(acu, 'ef_jingmai_touch', 'ParticleSystem'):Stop();
        self:FindChild(acu, 'Image_full'):SetActive(false);
        local _callback = function(gameObject, boolHide)
            if boolHide then
                self.chooseNode = acu;
                self.clickAcupoint = acupoint;
                self:UpdateNode();
            end
        end
        self:CommonBind(acu, _callback);
        acu.transform.localPosition = DRCSRef.Vec3(acupoint.XAxis, acupoint.YAxis, 0);
        SetStringDataInGameObject(acu, 'id', tostring(acupoint.BaseID));
        self:FindChildComponent(acu, 'Label_lv', 'Text').text = level;
        self:FindChildComponent(acu, 'Label_lv', 'Text').color = redColor;
        self:FindChildComponent(acu, 'Label_lvUp', 'Text').text = '/' .. levelUp;

        if level >= levelUp then 
            self:FindChildComponent(acu, 'Label_lv', 'Text').color = whiteColor;
        elseif not unFullAcupoint then
            unFullAcupoint = acu;
        end

        -- 如果该节点有配置连接节点, 则画线
        if acupoint.NextAcupointID then
            local pos1 = {
                ['x'] = acupoint.XAxis,
                ['y'] = acupoint.YAxis,
            }
            local nextAcupoint = acupointData[acupoint.NextAcupointID];
            if nextAcupoint then
                local pos2 = {
                    ['x'] = nextAcupoint.XAxis,
                    ['y'] = nextAcupoint.YAxis,
                }
                self:InitNodeLine(pos1, pos2);
            end
        end

        acu:SetActive(true);
    end

    local index = 0;
    local hasNoFull = false;
    local temp = {
        ['Array'] = 0xffff,
    };
    for i = 1, #(acupointTable) do
        local acupoint = acupointTable[i];
        local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupoint);
        local levelUp = self.MeridiansDataManager:GetAcupointLevel(acupoint.BaseID);
        if acupoint.Array < temp.Array and serverAcupointData.dwLevel < levelUp then
            temp = acupoint;
            index = i - 1;
            hasNoFull = true;
        end
    end
    if not IsValidObj(self.chooseNode) then
        local objSelect1 = self.LeftAcupoint.transform:GetChild(index);
        local objSelect2 = self.LeftAcupoint.transform:GetChild(0);
        self.chooseNode = hasNoFull and objSelect1.gameObject or objSelect2.gameObject;
    end
    self.chooseNode:GetComponent('Toggle').isOn = true;

    self:UpdateTabState(hasNoFull, temp);
end

--初始化节点间连线
function MeridiansUI:InitNodeLine(v2_pos1, v2_pos2)
    local line = self:LoadPrefabFromPool('Meridians/Image_line', self.transLeftLine)
    local xOffset = v2_pos1.x - v2_pos2.x;
    local yOffset = v2_pos1.y - v2_pos2.y;
    local rotation = math.atan(yOffset/xOffset) * (180 / math.pi);
    line.transform.localEulerAngles = DRCSRef.Vec3(0, 0, rotation);
    local x = (v2_pos1.x + v2_pos2.x) / 2;
    local y = (v2_pos1.y + v2_pos2.y) / 2;
    line.transform.localPosition = DRCSRef.Vec3(x, y, 0);
    local rect = line:GetComponent('RectTransform');
    local width = math.sqrt((yOffset) * (yOffset) + (xOffset) * (xOffset));
    rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, width);
    line:SetActive(true);
end

function MeridiansUI:UpdateNode()
    if not self.chooseNode then
        return;
    end

    for k, v in pairs(self.LeftAcupoint.transform) do
        local id = GetStringDataInGameObject(v, 'id');
        local levelUp = self.MeridiansDataManager:GetAcupointLevel(id);
        local acupointData = self.MeridiansDataManager:GetAcupointData();
        if acupointData then
            local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupointData[tonumber(id)]);
            self:FindChildComponent(v.gameObject, 'Label_lv', 'Text').text = serverAcupointData.dwLevel;
            self:FindChildComponent(v.gameObject, 'Label_lvUp', 'Text').text = '/' .. levelUp;
            
            if serverAcupointData.dwLevel >= levelUp then
                self:FindChildComponent(v.gameObject, 'Label_lv', 'Text').color = whiteColor;
                local particleEffect = self:FindChild(v.gameObject, 'ef_jingmai_idle');
                if particleEffect then
                    particleEffect:SetActive(true);
                    particleEffect:GetComponent('ParticleSystem'):Play();
                end
            end
        end
    end

    self:UpdateDetail();
end

function MeridiansUI:UpdateDetail()
    if not self.chooseNode then
        self.objRightUI:SetActive(false);
        return;
    end

    --
    local acupoint = self.clickAcupoint;
    if not acupoint then
        return;
    end
    local meridiansData = self.MeridiansDataManager:GetMeridiansData();
    if not meridiansData or not meridiansData[acupoint.OwnerMeridian] then
        return;
    end
    local meridians = meridiansData[acupoint.OwnerMeridian];
    local breakData = self.MeridiansDataManager:GetBreakData(acupoint.OwnerMeridian);
    
    --
    local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupoint);
    local levelUp = self.MeridiansDataManager:GetAcupointLevel(acupoint.BaseID);
    self.iLastChooseLimitLevel = levelUp

    
    local reachLimit = (serverAcupointData.dwLevel >= levelUp);
    self:FindChildComponent(self.objRightUI, 'Image_name/Text', 'Text').text = GetLanguageByID(acupoint.NameID);
    local acupointLevel = self:FindChild(self.objRightUI, 'Level');
    self:FindChildComponent(acupointLevel, 'Text_progress', 'Text').text = serverAcupointData.dwLevel ..'/' .. levelUp;
    self:FindChildComponent(acupointLevel, 'Scrollbar', 'Scrollbar').size = serverAcupointData.dwLevel / levelUp;
    
    local level = self.MeridiansDataManager:GetLevel(meridians, false);
    levelUp = self.MeridiansDataManager:GetLevel(meridians, true);
    local comImageName = self:FindChildComponent(self.objRightUI, 'Image_name_top/Text', 'Text');
    local acupointLevel_top = self:FindChild(self.objRightUI, 'Level_top');
    self:FindChildComponent(acupointLevel_top, 'Text_progress', 'Text').text = level .. '/' .. levelUp;
    self:FindChildComponent(acupointLevel_top, 'Scrollbar', 'Scrollbar').size = level / levelUp;

    --
    local SCDecTop = self:FindChild(self.objRightUI, 'SC_dec_top');
    local contentTop = self:FindChild(SCDecTop, 'Viewport/Content');
    local objTextDecCur = self:FindChild(contentTop, 'Text_decCur');
    local objTextDecNext = self:FindChild(contentTop, 'Text_decNext');
    local objTextNext = self:FindChild(contentTop, 'Text_next');
    local breakStage = breakData.dwLevel;

    --
    comImageName.text = string.format('%s', GetLanguageByID(meridians.NameID));

    -- if breakStage > #(meridians.BreakValue) then
    --     breakStage = #(meridians.BreakValue);
    -- end
    if breakStage < #(meridians.BreakValue) then
        breakStage = breakStage + 1;
        local comItemModelCurTop = objTextDecCur:GetComponent('Text');
        local comItemModelNextTop = objTextDecNext:GetComponent('Text');
        comItemModelCurTop.text = GetLanguageByID(meridians.BreakAddID) .. math.floor((meridians.BreakValue[breakStage] - 1000) / 100) .. '%';
        comItemModelNextTop.text = GetLanguageByID(meridians.BreakAddID) .. math.floor((meridians.BreakValue[breakStage]) / 100) .. '%';

        comItemModelCurTop.color = DRCSRef.Color(0.17,0.17,0.17,1);
        comItemModelNextTop.color = grayColor;

        -- objTextDecNext:SetActive(true);
        -- objTextNext:SetActive(true);
    else
        local comItemModelCurTop = objTextDecCur:GetComponent('Text');
        local comItemModelNextTop = objTextDecNext:GetComponent('Text');
        comItemModelCurTop.text = GetLanguageByID(meridians.BreakAddID) .. math.floor(meridians.BreakValue[#(meridians.BreakValue)] / 100) .. '%';
        comItemModelCurTop.color = DRCSRef.Color(0.17,0.17,0.17,1);
        comItemModelNextTop.text = GetLanguageByID(meridians.BreakAddID) .. '已冲破满级';
        
        -- comItemModelCurTop.color = grayColor;
        -- if breakStage > 1 then
        --     comItemModelCurTop.text = GetLanguageByID(meridians.BreakAddID) .. math.floor(meridians.BreakValue[breakStage - 1] / 100) .. '%';
        --     comItemModelCurTop.color = DRCSRef.Color(0.17,0.17,0.17,1);
        -- end

        -- objTextDecNext:SetActive(false);
        -- objTextNext:SetActive(false);
    end

    --
    local SCDec = self:FindChild(self.objRightUI, 'SC_dec');
    local content = self:FindChild(SCDec, 'Content');
    local textAttr = self:FindChild(self.objRightUI, 'Text_attr');
    local attrNodeNow = self:FindChild(self.objRightUI, 'attr_node/Text_now');
    local attrNodeNext = self:FindChild(self.objRightUI, 'attr_node/Text_next');
    
    --
    local item_modelCur = self:FindChild(content, 'Text_decCur');
    local item_modelNext = self:FindChild(content, 'Text_decNext');
    local item_next_model = self:FindChild(content, 'Text_next');

    --
    local acupointEffectData = self.MeridiansDataManager:GetAcupointEffectData();
    if not acupointEffectData or not acupointEffectData[acupoint.AcupointSkill] then
        return;
    end
    local effect = acupointEffectData[acupoint.AcupointSkill];
    local valueA = effect.EffectValueA;
    local valueB = effect.EffectValueB;
    local text = '';
    if valueA > 0 then
        text = '+' .. math.ceil(valueA) * serverAcupointData.dwLevel;
    end
    if valueB > 0 then
        text = '+' .. (math.ceil(valueB / 100) * serverAcupointData.dwLevel) .. '%';
    end
    
    attrNodeNow:GetComponent('Text').text = text;

    if not reachLimit then
        local valueA = effect.EffectValueA;
        local valueB = effect.EffectValueB;
        local text = '';
        if valueA > 0 then
            text = '+' .. (math.ceil(valueA) * (serverAcupointData.dwLevel + 1));
        end
        if valueB > 0 then
            text = '+' .. (math.ceil(valueB / 100) * (serverAcupointData.dwLevel + 1)) .. '%';
        end
        
        attrNodeNext:GetComponent('Text').text = text;
    end

    textAttr:GetComponent('Text').text = GetLanguageByID(effect.DescID);

    local current = self:FindChild(self.objRightUI, 'Exp/current');
    local need = self:FindChild(self.objRightUI, 'Exp/need');
    local curTotalExp = self.MeridiansDataManager:GetCurTotalExp();
    self:FindChildComponent(current, 'Image/Text', 'Text').text = curTotalExp or 0;
    
    -- local expValue = self:FindChild(need, 'Image/Text');
    local comText = self:FindChildComponent(self.levelUpBtn, 'Number', 'Text'); 
    if not reachLimit then
        local level = self.MeridiansDataManager:GetSumLevel();
        self.nextLevelExp = self.MeridiansDataManager:GetAcupointUpExp(level + 1);
        -- expValue:GetComponent('Text').text = math.ceil(self.nextLevelExp);
        comText.text = math.ceil(self.nextLevelExp);
        if self.nextLevelExp > MeridiansDataManager:GetInstance():GetCurTotalExp() then
            comText.color = redColor
        else
            comText.color = whiteColor
        end
      

        self.fullBtn:SetActive(false);
    else
        -- expValue:GetComponent('Text').text = '已达上限';
        comText.text = '已达上限';
        -- item_modelNext:SetActive(false);
        -- item_next_model:SetActive(false);
        attrNodeNext:GetComponent('Text').text = '已达\n上限';

        self.fullBtn:SetActive(true);
    end

end

function MeridiansUI:ShowDetailAttr()
    local acupointData = self.MeridiansDataManager:GetAcupointData();
    local meridiansData = self.MeridiansDataManager:GetMeridiansData();

    if not acupointData or not meridiansData then
        return;
    end

    local nodesToShow = {}
    for k, v in pairs(acupointData) do
        local acupoint = acupointData[k];
        if meridiansData[acupoint.OwnerMeridian] then
            local index = meridiansData[acupoint.OwnerMeridian].ShowArray + 1; --显示顺序是从0开始的
            if not nodesToShow[index] then
                nodesToShow[index] = {};
            end
            
            local effect = acupoint.AcupointSkill;
            local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupoint);
            if effect and serverAcupointData.dwLevel > 0 then
                table.insert(nodesToShow[index], acupoint);
            end
        end
    end

    local hasNil = false;
    local content = self:FindChild(self.SCDetail, 'Content');
    local transContent = content.transform
    self:RemoveAllChildToPool(transContent)
    for i = 1, #(nodesToShow) do
        local acupointArray = nodesToShow[i];
        local acupointCount = #(acupointArray);
        if acupointCount > 0 then
            --
            local meridian = meridiansData[acupointArray[1].OwnerMeridian];

            --
            local breakData = self.MeridiansDataManager:GetBreakData(acupointArray[1].OwnerMeridian);
            local ItemDetail = self:LoadPrefabFromPool('Meridians/Item_detail', transContent)
            local title = self:FindChild(ItemDetail, 'Title');
            local strText = '%s·%s';
            strText = string.format(strText, GetLanguageByID(meridian.NameID), GetLanguageByID(meridian.DescID));
            self:FindChildComponent(title, 'Image/Text', 'Text').text = strText;
            
            local level = self.MeridiansDataManager:GetLevel(meridian, false);
            local levelUp = self.MeridiansDataManager:GetLevel(meridian, true);
            local text = '总等级: ' .. level .. '/' .. levelUp;
            self:FindChildComponent(title, 'Text', 'Text').text = text;
            
            local attr = self:FindChild(ItemDetail, 'Attr');
            local transAttr = attr.transform
            self:RemoveAllChildToPool(transAttr)
            for j = 1, acupointCount do
                local acupoint = acupointArray[j];
                local ItemAttr = self:LoadPrefabFromPool('Meridians/Item_attr', transAttr)
                local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupoint);
                local acupointEffectData = self.MeridiansDataManager:GetAcupointEffectData();
                if acupointEffectData and acupointEffectData[acupoint.AcupointSkill] then
                    local effect = acupointEffectData[acupoint.AcupointSkill];
                    local valueA = effect.EffectValueA;
                    local valueB = effect.EffectValueB;
                    local text = '';
                    if valueA > 0 then
                        text = math.ceil(valueA) * serverAcupointData.dwLevel;
                        local breakData = self.MeridiansDataManager:GetBreakData(acupoint.OwnerMeridian);
                        if breakData.dwLevel > 0 then
                            text = math.floor(text * (meridian.BreakValue[breakData.dwLevel] / 10000 + 1));
                        end
                    end
                    if valueB > 0 then
                        text = (math.ceil(valueB / 100) * serverAcupointData.dwLevel);
                        local breakData = self.MeridiansDataManager:GetBreakData(acupoint.OwnerMeridian);
                        if breakData.dwLevel > 0 then
                            text = math.floor(text * (meridian.BreakValue[breakData.dwLevel] / 10000 + 1));
                        end
                        text = text .. '%';
                    end
    
                    self:FindChildComponent(ItemAttr, 'Text_dec', 'Text').text = GetLanguageByID(effect.NameID);
                    self:FindChildComponent(ItemAttr, 'Text_value', 'Text').text = '+' .. text;
                    ItemAttr:SetActive(true);
                end
            end
            
            ItemDetail:SetActive(true);
            
            --
            hasNil = true; 
        end
    end

    --
    if not hasNil then
        self:FindChild(self.objDetailUI, 'Dec'):SetActive(true);
        self.DetailAll:SetActive(false);
    else
        self:FindChild(self.objDetailUI, 'Dec'):SetActive(false);
        self.DetailAll:SetActive(true);
        self.DetailAll:GetComponent('Text').text = string.format('全经脉总等级:%d', self.MeridiansDataManager:GetSumLevel());

        self:LoadPrefabFromPool('Meridians/Item_detailTip', transContent);
    end
end

function MeridiansUI:OnRefAcupoint(bLimit)
    --
    local acupoint = self.clickAcupoint;
    if not acupoint then
        return;
    end
    local serverAcupointData = self.MeridiansDataManager:GetServerAcupointData(acupoint);
    local levelUp = self.MeridiansDataManager:GetAcupointLevel(acupoint.BaseID);
    self.iLastChooseLimitLevel = self.iLastChooseLimitLevel or levelUp
    -- 当升级后当前选中的经脉也提升了上限，也需要重新inittab，用iLastChooseLimitLevel 来判断 前后等级
    if serverAcupointData.dwLevel >= levelUp or self.iLastChooseLimitLevel ~= levelUp then 
        -- 每次到上限重新初始化tab栏, 检测是否有新tab页解锁, 也可以达到自动切换到下一个未点满节点的效果
        if bLimit then
            self:InitTab(false, nil, true);
        else
            self:InitTab(false);
        end
    self.iLastChooseLimitLevel = levelUp
        self:UpdateTab();
    else
        self:UpdateNode();
    end

end

function MeridiansUI:OnEnable()
    --
    -- SendMeridiansOpr(SMOT_REFRESH_ALL, 0);
    self.isSend = false;
    -- self:RefreshUI();

    self:AddEventListener('ONEVENT_REFMERIDIANSUI', function(info)

        if info.eOprType == SMOT_REFRESH_ALL then
            self:RefreshUI();
        end

        if info.eOprType == SMOT_LEVEL_UP then
            self.isSend = false;
            self:OnRefAcupoint();

            local acupoint = self.clickAcupoint;
            local meridians = self.clickMeridians;
            if not acupoint or not meridians then
                return;
            end
            local acupointEffectData = self.MeridiansDataManager:GetAcupointEffectData();
            if not acupointEffectData or not acupointEffectData[acupoint.AcupointSkill] then
                return;
            end
            local effect = acupointEffectData[acupoint.AcupointSkill];
            local valueA = effect.EffectValueA;
            local valueB = effect.EffectValueB;
            local text = '';
            if valueA > 0 then
                text = '+' .. math.ceil(valueA);
            end
            if valueB > 0 then
                text = '+' .. math.ceil(valueB / 100) .. '%';
            end
            local descID = string.gsub(GetLanguageByID(effect.DescID), ':', '');
            local strText = descID .. text;
            SystemUICall:GetInstance():Toast(strText);

            -- TODO 数据上报
            MSDKHelper:SetQQAchievementData('meridianslevel', self.MeridiansDataManager:GetSumLevel());
            MSDKHelper:SendAchievementsData('meridianslevel');
        end

        if info.eOprType == SMOT_BREAK_LIMIT then
            -- self.LeftImageMask:SetActive(false);
            
            local meridians = self.clickMeridians;
            if not meridians then
                return;
            end
            local breakData = self.MeridiansDataManager:GetBreakData(meridians.BaseID);
            local level = breakData.dwLevel;
            if level > #(self.clickMeridians.Stage) then
                level = #(self.clickMeridians.Stage);
            end
            local strText = GetLanguageByID(meridians.BreakAddID) .. math.floor(meridians.BreakValue[level] / 100) .. '%';
            SystemUICall:GetInstance():Toast(strText);
            
            self:RemoveBreakMeridians(meridians);
            self:UpdateBreakMerdiansMask(meridians);
            self:OnRefAcupoint(true);
        end

    end);

    -- local topBtnState = {
    --     ['bBackBtn'] = true,
    --     ['bMeridians'] = true,
    --     -- ['bTuPoDan'] = true,
    -- }

    -- local callback = function()
    -- end
    
    -- local info = {
    --     ['windowstr'] = "MeridiansUI",
    --     ['titleName'] = "经脉", 
    --     ['topBtnState'] = topBtnState,
    --     ['callback'] = callback;
    -- }
    -- OpenWindowBar(info);
end

function MeridiansUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REFMERIDIANSUI');
    --RemoveWindowBar('MeridiansUI')
end

function MeridiansUI:OnDestroy()

end

return MeridiansUI;