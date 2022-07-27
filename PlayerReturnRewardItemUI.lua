PlayerReturnRewardItemUI = class("PlayerReturnRewardItemUI", ItemIconUINew)



function PlayerReturnRewardItemUI:Create(kParent)
	local obj = LoadPrefabAndInit("PlayerReturnUI/PlayerReturnTaskRewardItem",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function PlayerReturnRewardItemUI:Init()
	self.super.Init(self)

	self.comProgressText1 = self:FindChildComponent(self._gameObject,'Title/ValueText',DRCSRef_Type.Text)
	self.comProgressText2 = self:FindChildComponent(self._gameObject,'Title/Get/ValueText',DRCSRef_Type.Text)
	self.comStateText = self:FindChildComponent(self._gameObject,'Title/StateText',DRCSRef_Type.Text)
	self.objTick = self:FindChild(self._gameObject,'Icon1/Tick')
	self.objGetNode = self:FindChild(self._gameObject,'Title/Get')

	self.comGetButton =  self.objGetNode:GetComponent(DRCSRef_Type.Button)
    if self.comGetButton then
		self:AddButtonClickListener(self.comGetButton, function()
			-- 回流活动的 0号位 用来表示 回流活动是否领取，积分任务的领取状态从1开始
			SendActivityOper(SAOT_EVENT, self.iActivityID, SATET_BACKFLOWPOINT_RECEIVE, self.iIndex)
        end)
	end
	local comButton = self:FindChildComponent(self._gameObject,'Icon1',DRCSRef_Type.Button)
	local fun = function()
        if self.onClick then
            self.onClick()
            return
        end

        if self.tips == nil then
            self:ResetClickData()
        end
        if self.tips ~= nil then
            OpenWindowImmediately("TipsPopUI", self.tips)        
        end
    end
    self:AddButtonClickListener(comButton, fun, self.canSaveBtn)
end

-- iState 0 未达成 1已达成未领取 2已领取
function PlayerReturnRewardItemUI:SetProgressState(iProgressValue,iState,iActivityID,iIndex)
	self.comProgressText1.text = "总进度:"..iProgressValue
	self.comProgressText2.text = "总进度:"..iProgressValue
	self.iActivityID = iActivityID
	self.iIndex = iIndex

	if iState == 0 then	
		self.comStateText.text = "未达成"
		self.objGetNode:SetActive(false)
		self.objTick:SetActive(false)
	elseif iState == 1 then
		self.objGetNode:SetActive(true)
		self.objTick:SetActive(false)
	elseif iState == 2 then
		self.comStateText.text = "已领取"
		self.objGetNode:SetActive(false)
		self.objTick:SetActive(true)
	end
end

return PlayerReturnRewardItemUI