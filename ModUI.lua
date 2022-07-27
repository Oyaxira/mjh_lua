ModUI = class("ModUI", BaseWindow)
local roleData
-- 皮肤数量最大值
local skin_num_max = 8
function ModUI:ctor()
	self.comChild_Toggle = {}
	self.array_objSkin = {}
	self.comSkin_child_Toggle = {}
	self.objSkin_child_border = {}
	self.Button = {}
	self.curCGIndex = 1
	self.curSpineAniIndex = 1
end

function ModUI:Create()
	local obj = LoadPrefabAndInit("Mod/Mod",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function ModUI:Init()
	roleData = reloadModule("Data/ResourceRolePicture")
	--do return end
    self.comLoopScrollView =  self:FindChild(self._gameObject,"Img/LoopScrollView"):GetComponent("LoopVerticalScrollRect")
    if IsValidObj(self.comLoopScrollView) then
        local fun = function(transform, idx)
		derror(transform, idx)
		self:OnScrollChanged(transform, idx)
        end
        self.comLoopScrollView:AddListener(fun)
    end

	self.imgCG = self:FindChild(self._gameObject,"Img/Role"):GetComponent("Image")
	self.imgIcon = self:FindChild(self._gameObject,"Img/Icon"):GetComponent("Image")
	local bs = {"OR", "CR", "OI", "CI"}
	local btn
	for i = 1, #bs do
		local v = bs[i]
		btn = self:FindChild(self._gameObject,"Img/"..v):GetComponent("Button")
		if IsValidObj(btn) then
			local fun = function()
				self['OnClick_'..v](self)
			end
			btn.onClick:AddListener(fun)
		end
	end
	btn = self:FindChild(self._gameObject,"Button_back"):GetComponent("Button")
	if IsValidObj(btn) then
		local fun = function()
			self:OnClick_back()
		end
		btn.onClick:AddListener(fun)
	end
	self:RefreshUI()
	self:changeRole(1)
end

function ModUI:OnClick_back()
	RemoveWindowImmediately("ModUI")
end

function ModUI:OnClick_OR()
	local tb = roleData[self.id]
	local name = DRCSRef.ModGetFileName(tb.BaseID, 'Drawing')
	DRCSRef.ModEditImage(name, function(name)
		if name then
			self:UpdateImage(1)
		end
	end)
end

function ModUI:OnClick_CR()
	local tb = roleData[self.id]
	local name = DRCSRef.ModGetFileName(tb.BaseID, 'Drawing')
	DRCSRef.ModRevertImage(name)
	self:UpdateImage(1)
end

function ModUI:OnClick_OI()
	local tb = roleData[self.id]
	local name = DRCSRef.ModGetFileName(tb.BaseID, 'Head')
	DRCSRef.ModEditImage(name, function(name)
		if name then
			self:UpdateImage(1)
		end
	end)
end

function ModUI:OnClick_CI()
	local tb = roleData[self.id]
	local name = DRCSRef.ModGetFileName(tb.BaseID, 'Head')
	DRCSRef.ModRevertImage(name)
	self:UpdateImage(1)
end

function ModUI:RefreshUI()
    self.id = 1
    if  self.comLoopScrollView and roleData then
		self.comLoopScrollView.totalCount = tonumber(#roleData)
		self.comLoopScrollView:RefillCells()
    end
end

function ModUI:OnScrollChanged(item,idx)
    derror(idx)
    if not IsValidObj(item) then
        return
    end
	self.id = self.id or 1
	self.RBtn = item.gameObject
	self:RefreshHead(self.RBtn, idx)
end

function ModUI:changeRole(id)
	self.id = id
	self:UpdateImage()
end

function ModUI:RefreshHead(child, index)
	child:SetActive(true)
	local id = index + 1
	if not roleData or not roleData[id] then return end

	local comImage = child:GetComponent("Image")
	comImage.sprite = GetSprite(roleData[id].HeadPath)
	
	local btn = child:GetComponent("Button")
	local fun = function()
		self:changeRole(id)
	end
	btn.onClick:RemoveAllListeners()
	btn.onClick:AddListener(fun)
	
	local txt = self:FindChild(child,"Text"):GetComponent("Text")
	txt.text = ""
end

local attrs = {'Drawing', 'Head'}
function ModUI:UpdateImage(reset)
	local tb = roleData[self.id]
	local drawing = DRCSRef.ModGetImage(tb.BaseID, 'Drawing', tb.DrawingPath)
	local head = DRCSRef.ModGetImage(tb.BaseID,'Head', tb.HeadPath)
	if reset then
		UnModSprite(drawing)
		UnModSprite(head)
		local rtb = TableDataManager:GetInstance():GetTable("RoleModel")
		for k, v in pairs(rtb) do
			if v.PictureID == tb.BaseID then
				for _, a in ipairs(attrs) do
					local bk = '__' .. a
					if v[bk] then
						v[a] = v[bk]
						v[bk] = nil
					end
				end
			end
		end
	end
	self.imgCG.sprite = GetSprite(drawing)
	self.imgIcon.sprite = GetSprite(head)
end


function ModUI:ShowCG()
	self.imgCG.sprite = GetSprite(self.CGData[self.curCGIndex].CGPath)
end

function ModUI:OnDestroy()

end

return ModUI