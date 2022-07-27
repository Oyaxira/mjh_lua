ResultUI3 = class('ResultUI3', BaseWindow)
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function ResultUI3:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI3;

    self.bindBtnTable = {};
end

function ResultUI3:Init()
    self.objImage = self:FindChild(self._gameObject, 'Image');
    self.objBtn = self:FindChild(self._gameObject, 'Button');
    self.comBtnText = self:FindChildComponent(self.objBtn,"Text","Text")
    if not STORYID_SETTINGS[GetCurScriptID()] then
        self.comBtnText.text = "返回标题"
    else
        self.comBtnText.text = "下一步"
    end
    self.objScrollView = self:FindChild(self._gameObject, 'Scroll View');
    self.objSCContent = self:FindChild(self.objScrollView, 'Viewport/Content');
    self.transSCContent = self.objSCContent.transform

    table.insert(self.bindBtnTable, self.objBtn);

    self:BindBtnCB();
    self:InitShareUI()

end

function ResultUI3:RefreshUI(info)
    local scriptID = info.uiCurScriptID or 1;
    local weekRoundDataMap = globalDataPool:getData('WeekRoundDataMap') or {}
    local TB_ScriptItem = TableDataManager:GetInstance():GetTable("ScriptItem")
    local sumScore = 0;

    local scriptItem = {};
    for k, v in pairs(TB_ScriptItem) do
        if v.ScriptOwner == scriptID then
            table.insert(scriptItem, v);
        end
    end

    local _sort = function(a, b)
        return a.Order < b.Order;
    end
    table.sort(scriptItem, _sort);

    self:RemoveAllChildToPool(self.transSCContent)
    for k, v in pairs(scriptItem) do
        --
        if scriptItem[k] and scriptItem[k].ScriptOwner == scriptID then
            local storyItemEnum = scriptItem[k].ItemEnum
            local completeNum = weekRoundDataMap[storyItemEnum] or 0
            local completed = completeNum > 0
    
            if scriptItem[k].Score1 > 0 then
                local prefab = self:LoadPrefabFromPool('ResultUI/Item_ResultUI4', self.transSCContent)
                
                local comImage1 = self:FindChildComponent(prefab, 'Image1/Text', 'Text');
                comImage1.text = scriptItem[k].Description;
        
                local objCheckmarkFail = self:FindChild(prefab, 'Checkmark_fail');
                local objImage2 = self:FindChild(prefab, 'Image2/Text');
                local comImage2 = objImage2:GetComponent('Text');
                local objText = self:FindChild(prefab, 'Text');
                local comText = objText:GetComponent('Text');
                
                if completeNum > 0 and completed then
                    local number = math.floor(completeNum * scriptItem[k].Score1 / scriptItem[k].Percent1)
                    if number > scriptItem[k].MaxValue then
                        comImage2.text = scriptItem[k].MaxValue..' <size=15em>已上限</size>'
                        sumScore = sumScore + scriptItem[k].MaxValue;
                    else 
                        comImage2.text = number
                        sumScore = sumScore + math.ceil(tonumber(comImage2.text));
                    end 
                    comText.text = completeNum
    
                    objImage2:SetActive(true);
                    objText:SetActive(true);
                    objCheckmarkFail:SetActive(false);
                else
                    objImage2:SetActive(false);
                    objText:SetActive(false);
                    objCheckmarkFail:SetActive(true);
                end
    
                if completed then
                    prefab:GetComponent('CanvasGroup').alpha = 1.0;
                else
                    prefab:GetComponent('CanvasGroup').alpha = 0.6;
                end
            end
    
            if scriptItem[k].Score2 > 0 then
                local prefab = self:LoadPrefabFromPool('ResultUI/Item_ResultUI3', self.transSCContent)
    
                local comImage1 = self:FindChildComponent(prefab, 'Image1/Text', 'Text');
                local comAnother = self:FindChildComponent(prefab, 'Image_another/Text', 'Text');
                comImage1.text = scriptItem[k].Description;
                comAnother.text = scriptItem[k].Description;
        
                local objImage2 = self:FindChild(prefab, 'Image2/Text');
                local comImage2 = objImage2:GetComponent('Text');
                local objAnother = self:FindChild(prefab, 'Image_another');
                local objCheckmark = self:FindChild(prefab, 'Checkmark');
                local objCheckmarkFail = self:FindChild(prefab, 'Checkmark_fail');
                
                if completed then
                    local number = math.floor(scriptItem[k].Score2 / scriptItem[k].Percent2) 
                    if number > scriptItem[k].MaxValue then
                        comImage2.text = scriptItem[k].MaxValue..' <size=15em>已上限</size>'
                        sumScore = sumScore + scriptItem[k].MaxValue;
                    else 
                        comImage2.text = number 
                        sumScore = sumScore + math.ceil(tonumber(comImage2.text));
                    end
                    objImage2:SetActive(true);
                    objAnother:SetActive(true);
                    objCheckmark:SetActive(true);
                    objCheckmarkFail:SetActive(false);
                else
                    objImage2:SetActive(false);
                    objAnother:SetActive(false);
                    objCheckmark:SetActive(false);
                    objCheckmarkFail:SetActive(true);
                end
                
                if completed then
                    prefab:GetComponent('CanvasGroup').alpha = 1.0;
                else
                    prefab:GetComponent('CanvasGroup').alpha = 0.6;
                end
            end
        end
    end

    local comText = self:FindChildComponent(self.objImage, 'Text_Score', 'Text');
    comText.text = info.uiTotalScore or 0
    self._scriptUI.sumScore = sumScore;
end

function ResultUI3:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI3:CommonBind(gameObject, callback)
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
        self:AddToggleClickListener(tog, _callback);

    end
end

function ResultUI3:OnclickBtn(obj, boolHide)
    if obj == self.objBtn then
        self:OnClickBtn(obj);

    end
end

function ResultUI3:OnClickBtn(obj)
    if not self._scriptUI then
        return;
    end
    if not STORYID_SETTINGS[GetCurScriptID()] then
        local _callback = function()
            SendWeekEndGameOver(self._scriptUI.iFinalChoseBaby or 0);
            SendClickQuitStoryCMD();
        end
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '确认返回标题画面?', _callback });
        return
    end
    if self._scriptUI.bNotShow4_5 then         
        self._scriptUI:SetResultUIState(self._scriptUI.objResultUI5)
    else
        self._scriptUI:SetResultUIState(self._scriptUI.objResultUI4_5)
    end 
    -- self._scriptUI:SetResultUIState(self._scriptUI.objResultUI4);
end

function ResultUI3:OnEnable()
end

function ResultUI3:OnDisable()
end

function ResultUI3:OnDestroy()
end

function ResultUI3:InitShareUI()
    -- local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    -- if shareGroupUI then
    --     if not MSDKHelper:IsPlayerTestNet() then

    --         local _callback = function(bActive)
    --             local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
    --             if serverAndUIDUI and serverAndUIDUI._gameObject then
    --                 serverAndUIDUI._gameObject:SetActive(bActive);
    --             end

    --             local objImage = self:FindChild(self._gameObject, 'Image');
    --             if objImage then
    --                 objImage:SetActive(bActive);
    --             end
    --         end

    --         self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
    --         self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.JIESUAN, _callback, true);

    --         local canvas = shareGroupUI:GetComponent('Canvas');
    --         if canvas then
    --             canvas.sortingOrder = 1301;
    --         end
    --     else
    --         shareGroupUI:SetActive(false);
    --     end
    -- end
end

return ResultUI3