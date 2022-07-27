PopUpWindowUI = class("PopUpWindowUI", BaseWindow)

local popWindowType = {
    ['s'] = 1,
    ['m'] = 2,
    ['l'] = 3,
    ['b'] = 4,
}

function PopUpWindowUI:ctor()
    self.bindBtnTable = {};
end

function PopUpWindowUI:Create()
    local value = popWindowType.s;
    if self.info and popWindowType[self.info.type] then
        value = popWindowType[self.info.type];
    end
    --目前只有一个大小 先做死了
    local obj = LoadPrefabAndInit("Module/PopUpType/House_PopUpWindow", TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
    end
end

function PopUpWindowUI:Init()
    self.objBoard = self:FindChild(self._gameObject, 'Board');
    self.objTitle = self:FindChild(self.objBoard, 'Bottom/Top/Title');
    self.objText = self:FindChild(self.objBoard, 'Black/Text');
    self.objCloseBtn = self:FindChild(self.objBoard, 'Button_close');

    table.insert(self.bindBtnTable, self.objCloseBtn);

    self:BindBtnCB();
end

function PopUpWindowUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function PopUpWindowUI:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);
    end
end

function PopUpWindowUI:OnClickCloseBtn(obj)
    RemoveWindowImmediately('PopUpWindowUI');
end

function PopUpWindowUI:RefreshUI(info)
    if info then
        if self.objTitle then
            self.objTitle:GetComponent('Text').text = info.title;
        end
        if self.objText then
            self.objText:GetComponent('Text').text = info.text;
        end
    end
end

function PopUpWindowUI:OnEnable()
end

function PopUpWindowUI:OnDisable()
end

function PopUpWindowUI:OnDestroy()
end

return PopUpWindowUI;