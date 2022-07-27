MazeRoleUI = class("MazeRoleUI", SpineRoleUINew)

function MazeRoleUI:SetGameObject(gameObject)
	self.super.SetGameObject(self,gameObject,self:FindChild(gameObject, 'Spine/Spine'))
	self.comNameText = self:FindChildComponent(gameObject, 'Slider/Name', 'Text')
	self.hpImage = self:FindChildComponent(gameObject, 'Slider/HPSlider', 'Image')
	self.mpImage = self:FindChildComponent(gameObject, 'Slider/MPSlider', 'Image')
end

function MazeRoleUI:SetRoleData(roleData)
	self:SetActive(true)
	if self.super.SetRoleData(self,roleData) then 
		self:UpdateRole()
	end
end

function MazeRoleUI:UpdateRole()
	self:UpdateRoleSpine()
	self:UpdateRoleName()
	self:UpdateRoleInfo()
end

function MazeRoleUI:UpdateRoleMark(roleID, mapID)
end

function MazeRoleUI:UpdateRoleName()
	self:UpdateRoleNameByCustomData()
end

function MazeRoleUI:UpdateRoleInfo()
	local roleInfo = self.roleData
	if roleInfo then
		if roleInfo.uiHP == nil or roleInfo.aiAttrs == nil or roleInfo.aiAttrs[AttrType.ATTR_MAXHP] == nil or roleInfo.aiAttrs[AttrType.ATTR_MAXHP] == 0 then
			self.hpImage.fillAmount = 1
		else
			self.hpImage.fillAmount = roleInfo.uiHP / roleInfo.aiAttrs[AttrType.ATTR_MAXHP]
		end

		if roleInfo.uiMP == nil or roleInfo.aiAttrs == nil or roleInfo.aiAttrs[AttrType.ATTR_MAXMP] == nil or roleInfo.aiAttrs[AttrType.ATTR_MAXMP] == 0 then
			self.mpImage.fillAmount = 1
		else
			self.mpImage.fillAmount = roleInfo.uiMP / roleInfo.aiAttrs[AttrType.ATTR_MAXMP]
		end
	else
		self.hpImage.fillAmount = 1
		self.mpImage.fillAmount = 1
	end
end

function MazeRoleUI:UpdateRoleNameByCustomData()
	local name = RoleDataManager:GetInstance():GetRoleName(self.roleData.uiID)
	--local name = self.roleData:GetName()
	self.comNameText.text = name
end

return MazeRoleUI