HeadBoxUI = class("HeadBoxUI", BaseWindow)


function HeadBoxUI:ctor()

end

function HeadBoxUI:Create(kParent)
	local obj = LoadPrefabAndInit("TownUI/HeadBoxUI",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function HeadBoxUI:Init()
	self.comImgheadbg = self._gameObject:GetComponent('Image')
	self:AddEventListener("UPDATE_HEADBOX", function(info)
		if self and self.UpdateHeadBoxSprite then 
			-- if self._gameObject.activeSelf then 
				self:UpdateHeadBoxSprite()
			-- end 
		end
	end)

	self.comImgheadbg_replace = self:FindChildComponent(self._gameObject,'ReplaceBg','Image')
	self.spriteImgHeadBG_Replace = self.comImgheadbg_replace and self.comImgheadbg_replace.sprite
end

function HeadBoxUI:UpdateHeadBoxSprite(kSprite)
	if not self then 
		return 
	end 
	kSprite = kSprite or self.kSprite 
	if not kSprite and not self.isothers then
		kSprite = PlayerSetDataManager:GetInstance():GetPlayerHeadBoxSprite(self.iPlayerID)
	end
	if kSprite then 
		self._gameObject:SetActive(true)
		if self.comImgheadbg then 
			self.comImgheadbg.sprite = kSprite 
		end 
		self:UpdateReplacedHeadBoxUI(true)
	else
		self._gameObject:SetActive(false)
		self:UpdateReplacedHeadBoxUI(false)
	end
	self._gameObject.transform.anchoredPosition = DRCSRef.Vec2(0,0)
    self._gameObject.transform.localScale = DRCSRef.Vec3(self.iScale or 1, self.iScale or 1, 1)

end

function HeadBoxUI:UpdateReplacedHeadBoxUI(breplaced)
	if self.spriteImgheadbg_old then 
		if self.bIfMatirial then 
			if IsValidObj(self.comImgheadbg_old) then 
				self.comImgheadbg_old.enabled = not breplaced
			end
		else 
			-- 替换
			if self.spriteImgHeadBG_Replace or self.oldoldsprite then 
				if breplaced then 
					self.spriteImgheadbg_old = self.spriteImgHeadBG_Replace or self.oldoldsprite
				else 
					self.spriteImgheadbg_old = self.oldoldsprite
				end 
			end
		end	
	end 
end

-- 参数1 设置要取代的原头像框
-- 参数2 代表原头像是否用了材质球
function HeadBoxUI:SetReplacedHeadBoxUI(uiHeadbox,bIfMatirial)
	if uiHeadbox then 
		self.comImgheadbg_old = uiHeadbox:GetComponent('Image')
		if not self.comImgheadbg_old then 
			return 
		end 
		self.oldoldsprite = self.oldoldsprite or self.comImgheadbg_old.sprite
		self.spriteImgheadbg_old = self.comImgheadbg_old.sprite
	end 
	self.bIfMatirial = bIfMatirial
	if not self.bIfMatirial then 
		self.comImgheadbg_old = nil 
	end 
end

-- 参数 设置scale
function HeadBoxUI:SetScale(iScale)
	self.iScale = 1
	if iScale then 
		self.iScale = iScale
	end 
end

-- 参数 直接设置头像id 
-- 后于 SetReplacedHeadBoxUI SetScale 调用
-- 互斥于 SetPlayerID
function HeadBoxUI:SetHeadBoxID(iHeadboxID)
	self.kSprite = nil
	self.isothers = true
	if type(iHeadboxID) == "string" then 
		iHeadboxID = tonumber(iHeadboxID)
	end
	if iHeadboxID and iHeadboxID ~= 0 then 
		local kTBData = TableDataManager:GetInstance():GetTableData('PlayerInfo',iHeadboxID)
		if kTBData then 
			self.kSprite = GetSprite(kTBData.IconPath)
		end
	end 
	self:UpdateHeadBoxSprite()
end

-- 参数 直接玩家id 
-- 后于 SetReplacedHeadBoxUI 调用 
-- 互斥于 SetHeadBoxID
function HeadBoxUI:SetPlayerID(iPlayerID)
	self.iPlayerID = iPlayerID
	self.kSprite = nil
	if type(iPlayerID) == "string" then 
		iPlayerID = tonumber(iPlayerID)
	end
	self.isothers = iPlayerID and iPlayerID ~= 0 and true or false 
	self:UpdateHeadBoxSprite()
end

function HeadBoxUI:OnDestroy()
	self:RemoveEventListener('UPDATE_HEADBOX')
	self.comImgheadbg_old = nil
end

function HeadBoxUI:OnEnable()
	self:UpdateHeadBoxSprite()
end

function HeadBoxUI:OnDisable()
	-- self.UpdateHeadBoxSprite()
end


return HeadBoxUI