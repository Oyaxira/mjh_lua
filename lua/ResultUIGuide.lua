ResultUIGuide = class('ResultUIGuide', BaseWindow)

function ResultUIGuide:ctor()
    self.bindBtnTable = {};
    self.objResultTable = {};
end

function ResultUIGuide:Create()
	local obj = LoadPrefabAndInit('ResultUI/ResultUI_Guide', UI_UILayer, true);
	if obj then
		self:SetGameObject(obj);
    end
end

function ResultUIGuide:Init()
    
    self.objImageMask = self:FindChild(self._gameObject, 'Image_Mask');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objSCMind = self:FindChild(self._gameObject, 'SC_Mind');
    self.objSCMindContent = self:FindChild(self.objSCMind, 'Viewport/Content');

    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objImageMask);

    self:BindBtnCB();
end

function ResultUIGuide:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUIGuide:OnclickBtn(obj, boolHide)
    if obj == self.objImageMask or obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function ResultUIGuide:OnClickCloseBtn(obj)
    RemoveWindowImmediately('ResultUIGuide');
end

function ResultUIGuide:RefreshUI(info)
    self:OnRefUI();
end

function ResultUIGuide:OnEnable()
    
end

function ResultUIGuide:OnRefUI()
    local tbData = TableDataManager:GetInstance():GetTable("NewRound");
    if tbData then
        local tf = self.objSCMindContent.transform;
        for i = 1, tf.childCount do
            if tbData[i] then
                local go = tf:GetChild(i - 1).gameObject;
                local comImage = self:FindChildComponent(go, 'Image', 'Image');
                local comText = self:FindChildComponent(go, 'Text', 'Text');
                comImage.sprite = GetSprite(tbData[i].PicID);
                comText.text = GetLanguageByID(tbData[i].TipsID);
            end
        end
    end
end

function ResultUIGuide:OnDisable()

end

function ResultUIGuide:OnDestroy()

end

return ResultUIGuide