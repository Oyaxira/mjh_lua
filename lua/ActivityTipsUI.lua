ActivityTipsUI = class("ActivityTipsUI",BaseWindow)

function ActivityTipsUI:ctor()

end

function ActivityTipsUI:Create()
	local obj = LoadPrefabAndInit("TipsUI/ActivityTipsPopUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ActivityTipsUI:Init()
    self.comBGButton = self:FindChildComponent(self._gameObject, 'raycast', DRCSRef_Type.Button)
    self.comTimeText = self:FindChildComponent(self._gameObject, 'Tips/SC_Content/Content/Text_Time', DRCSRef_Type.Text)
    self.comContentText = self:FindChildComponent(self._gameObject, 'Tips/SC_Content/Content/Text_content', DRCSRef_Type.Text)    

    self.comFavor = self:FindChildComponent(self._gameObject, 'Tips/Image_heart/Text_num',  DRCSRef_Type.Text)
    self.comNameText = self:FindChildComponent(self._gameObject, 'Tips/ItemIcon/Text_name', DRCSRef_Type.Text)
    self.comFinishText = self:FindChildComponent(self._gameObject, 'Tips/ItemIcon/Text_num', DRCSRef_Type.Text)
    self.comIcon = self:FindChildComponent(self._gameObject, 'Tips/ItemIcon/Icon', DRCSRef_Type.Image)
    self:AddButtonClickListener(self.comBGButton, function()
        RemoveWindowImmediately("ActivityTipsUI",true)
    end)
end

function ActivityTipsUI:RefreshUI(tipsData)
    if tipsData then

        -- ['IconPath'] 
        -- ['CompleteTimes']
        -- ['Time']
        -- ["Favor"]
        -- ["Title"]
        -- ["Content"]

        --活动时间
        if self.comTimeText then
            self.comTimeText.text = tostring(tipsData.Time)
        end

        if self.comContentText then
            self.comContentText.text =tipsData.Content
        end

        if self.comFavor then
            self.comFavor.text = tipsData.Favor
        end

        if self.comNameText then
            self.comNameText.text = tipsData.Title
        end

        if self.comFinishText then
            self.comFinishText.text = tipsData.CompleteTimes
        end

        if  self.comIcon then
            self:SetSpriteAsync(tipsData.IconPath,self.comIcon)
        end

    end
    
end

return ActivityTipsUI