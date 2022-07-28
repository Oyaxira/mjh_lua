ResultUI4 = class('ResultUI4', BaseWindow)

function ResultUI4:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI4;

    self.bindBtnTable = {};
end

function ResultUI4:Init()
    self.objBtn = self:FindChild(self._gameObject, 'Button');

    table.insert(self.bindBtnTable, self.objBtn);

    self:BindBtnCB();

end

function ResultUI4:RefreshUI(info)

end

function ResultUI4:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI4:CommonBind(gameObject, callback)
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

function ResultUI4:OnclickBtn(obj, boolHide)
    if obj == self.objBtn then
        self:OnClickBtn(obj);

    end
end

function ResultUI4:OnClickBtn(obj)
    if not self._scriptUI then
        return;
    end
    if self._scriptUI.bNotShow4_5 then         
        self._scriptUI:SetResultUIState(self._scriptUI.objResultUI5)
    else
        self._scriptUI:SetResultUIState(self._scriptUI.objResultUI4_5)
    end 
end

function ResultUI4:OnEnable()
end

function ResultUI4:OnDisable()
end

return ResultUI4