ResultUI2 = class('ResultUI2', BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function ResultUI2:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI2;
    self.ItemIconUI = ItemIconUI.new();

    self.bindBtnTable = {};
end

function ResultUI2:Init()
    --
    self.objImageCG = self:FindChild(self._gameObject, 'Image_CG');
    self.objBtn = self:FindChild(self._gameObject, 'Button');
    self.objTextCur = self:FindChild(self._gameObject, 'Text_Cur');
    self.objTextOther = self:FindChild(self._gameObject, 'Text_Other');
    self.objImageTitle = self:FindChild(self._gameObject, 'Image_Title');
    self.objTextDesc = self:FindChild(self._gameObject, 'Text_Desc');
    self.objScrollView = self:FindChild(self._gameObject, 'Scroll View');
    self.objSCContent = self:FindChild(self.objScrollView, 'Viewport/Content');
    self.transSCContent = self.objSCContent.transform

    table.insert(self.bindBtnTable, self.objBtn);

    self:BindBtnCB();

    self:InitShareUI()
end

function ResultUI2:RefreshUI(info)
    self.info = info;
end

function ResultUI2:OnRefUI()
    local info = self.info or {};
    local ended = info.uiEndType or 1;
    local scriptID = info.uiCurScriptID or 1;
    local scriptEnd = TableDataManager:GetInstance():GetTableData("ScriptEnd",ended)
    scriptEnd = scriptEnd and scriptEnd or TableDataManager:GetInstance():GetTableData("ScriptEnd",1)
    local scriptEndItem = info.kScriptEndItem or {};
    local luaTable = table_c2lua(scriptEndItem);

    --
    local endCG = TableDataManager:GetInstance():GetTableData("ResourceCG",scriptEnd.CG)
    local comImage = self.objImageCG:GetComponent('Image');
    comImage.sprite = GetSprite(endCG.CGPath);
    local comTextDesc = self.objTextDesc:GetComponent('Text');
    comTextDesc.text = scriptEnd.Description;
    local objTextTitle = self:FindChild(self.objImageTitle, 'Text_Title');
    objTextTitle:GetComponent('Text').text = scriptEnd.Name;
    ReBuildRect(self.objImageTitle);

    --
    local tempTable = {};
    local TB_ScriptEnd = TableDataManager:GetInstance():GetTable("ScriptEnd")
    for i = 1, #(TB_ScriptEnd) do
        if TB_ScriptEnd[i] and self:CheckScriptEndOwner(TB_ScriptEnd[i], scriptID) and TB_ScriptEnd[i].WeekEndEnum ~= ended then
            table.insert(tempTable, TB_ScriptEnd[i]);
        end
    end

    local tempTable1 = {}
    local tempTable2 = {}
    for i, tableData in ipairs(tempTable) do
        local bFinish = false
        for j, luaData in ipairs(luaTable) do
            if tableData.WeekEndEnum == luaData.uiScriptEndType then
                bFinish = true
                break
            end
        end

        if bFinish then
            table.insert(tempTable2, tableData)
        else
            table.insert(tempTable1, tableData)
        end
    end
    table.move(tempTable2, 1, #(tempTable2), #(tempTable1) + 1, tempTable1)
    tempTable = tempTable1

    self:RemoveAllChildToPool(self.transSCContent)
    for i = 1, #(tempTable) do
        local tempData = tempTable[i];
        local prefab = self:LoadPrefabFromPool('ResultUI/Item_ResultUI2', self.transSCContent)
        local endCG = TableDataManager:GetInstance():GetTableData("ResourceCG",tempData.CG)
        local comImage = self:FindChildComponent(prefab, 'Image', 'Image');
        comImage.sprite = GetSprite(endCG.CGPath);
        local comTextTitle = self:FindChildComponent(prefab, 'Text_Title', 'Text');
        comTextTitle.text = tempData.Name;
        local comTextDesc = self:FindChildComponent(prefab, 'Text_Desc', 'Text');
        comTextDesc.text = tempData.Complete;

        local completed = false;
        for j = 1, #(luaTable) do
            if tempData.WeekEndEnum == luaTable[j].uiScriptEndType then
                completed = true;
            end
        end

        local objItemIconUI = self:FindChild(prefab, 'ItemIconUI');
        local objImageComplete1 = self:FindChild(prefab, 'Image_Complete1')
        objImageComplete1:SetActive(completed)

        if completed then
            objItemIconUI:SetActive(false);
        else
            if tempData.Award then
                for i = 1, #(tempData.Award) do
                    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",tempData.Award[i])
                    self.ItemIconUI:UpdateUIWithItemTypeData(objItemIconUI, itemTypeData);
                end
                objItemIconUI:SetActive(true)
            else
                objItemIconUI:SetActive(false);
            end
        end

    end
end

function ResultUI2:CheckScriptEndOwner(scriptEndData, storyID)
    if type(scriptEndData.ScriptOwner) == "number" then
        return scriptEndData.ScriptOwner == storyID
    elseif type(scriptEndData.ScriptOwner) == "table" then
        for index, storyItemID in ipairs(scriptEndData.ScriptOwner) do
            if storyItemID == storyID then
                return true
            end
        end
    end

    return false
end

function ResultUI2:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI2:CommonBind(gameObject, callback)
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

function ResultUI2:OnclickBtn(obj, boolHide)
    if obj == self.objBtn then
        self:OnClickBtn(obj);

    end
end

function ResultUI2:OnClickBtn(obj)
    if not self._scriptUI then
        return;
    end

    self._scriptUI:SetResultUIState(self._scriptUI.objResultUI3);
end

function ResultUI2:OnEnable()
end

function ResultUI2:OnDisable()
end

function ResultUI2:OnDestroy()
    self.ItemIconUI:Close();
end

function ResultUI2:InitShareUI()
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

return ResultUI2