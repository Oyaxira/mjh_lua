ResultUI1 = class('ResultUI1', BaseWindow)
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function ResultUI1:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI1;

    self.bindBtnTable = {};
end

function ResultUI1:Init()
    self.objImageCG = self:FindChild(self._gameObject, 'Image_CG');
    self.objImage1 = self:FindChild(self._gameObject, 'Image1');
    self.objBtn = self:FindChild(self._gameObject, 'Button');

    table.insert(self.bindBtnTable, self.objBtn);

    self:BindBtnCB();
    self:InitShareUI()
end

function ResultUI1:RefreshUI(info)
    local uiEndType = info.uiEndType or 1;
    local scriptEnd = TableDataManager:GetInstance():GetTableData("ScriptEnd",uiEndType)

    --
    scriptEnd = scriptEnd and scriptEnd or TableDataManager:GetInstance():GetTableData("ScriptEnd",1)
    local endCG = TableDataManager:GetInstance():GetTableData("ResourceCG",scriptEnd.CG)
    local comImage = self.objImageCG:GetComponent('Image');
    comImage.sprite = GetSprite(endCG.CGPath);
    local textName = self:FindChildComponent(self.objImage1, 'Text', 'Text');
    textName.text = scriptEnd.Name;
end

function ResultUI1:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI1:CommonBind(gameObject, callback)
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

function ResultUI1:OnclickBtn(obj, boolHide)
    if obj == self.objBtn then
        self:OnClickBtn(obj);

    end
end

function ResultUI1:OnClickBtn(obj)
    if not self._scriptUI then
        return;
    end

    self._scriptUI:SetResultUIState(self._scriptUI.objResultUI2);
    self._scriptUI:SetImageBGActive(true);
    self._scriptUI.ResultUI2:OnRefUI();
end

function ResultUI1:OnEnable()
end

function ResultUI1:OnDisable()
end

function ResultUI1:OnDestroy()
    -- if self.TencentShareButtonGroupUI then
    --     self.TencentShareButtonGroupUI:Close();
    -- end
end

function ResultUI1:InitShareUI()
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

return ResultUI1