LevelUPUI = class("LevelUPUI",BaseWindow)

function LevelUPUI:ctor()
end

function LevelUPUI:Create()
	local obj = LoadPrefabAndInit("Role/levelUpUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function LevelUPUI:Init()
	self.touchAnyPosClose = self:FindChildComponent(self._gameObject, "TouchCloseBack","Button")
	self:AddButtonClickListener(self.touchAnyPosClose,function()
		self:CloseLevelUpUI()
	end)
	self.objTouchClose = self:FindChild(self._gameObject, "newFrame/Btn_exit")
	self.btnTouchClose = self.objTouchClose:GetComponent("Button")
	self:AddButtonClickListener(self.btnTouchClose,function()
		self:CloseLevelUpUI()
	end)
	self.scrollRectLevelUp = self:FindChildComponent(self._gameObject,"SC_LevelUpList","LoopVerticalScrollRect")
	if self.scrollRectLevelUp  then
		local funUpdate = function(transform, idx)
			self:OnScrollChanged(transform, idx)
		end
		self.scrollRectLevelUp :AddListener(funUpdate)
	end

	self.scrollViewClick = self:FindChildComponent(self._gameObject,"SC_LevelUpList","ScrollViewClick")
	if self.scrollViewClick then
		self.scrollViewClick:SetLuaFunction(function ()
			self:CloseLevelUpUI()
		end)
	end
end

function LevelUPUI:RefreshUI(info)
	self.bNeedDisplayEnd = true
	if info then
		self.bNeedDisplayEnd = (info.bNeedDisplayEnd ~= false)
		info.bNeedDisplayEnd = nil
	end
	self.levelUpInfo = self:GenLevelUpData(info)
	-- 重新更新滚动栏
	self.scrollRectLevelUp:ClearCells()	
    self.scrollRectLevelUp.totalCount = #self.levelUpInfo
	self.scrollRectLevelUp:RefillCells()
	
	PlayButtonSound("EventLevelUp")
end

-- 将等级提升数据解析为数组形式
function LevelUPUI:GenLevelUpData(info)
	if not (info and next(info)) then return {} end
	local ret = {}
	for roleID, data in pairs(info) do
		-- 有可能存在已经缓存里角色升级数据, 但是角色离队里, 这个时候 InstRole -> NpcRole
		-- 所有整理数据到时候同时移除掉找不到InstRoleData到数据
		if RoleDataManager:GetInstance():GetRoleData(roleID) ~= nil then
			ret[#ret + 1] = {
				['roleID'] = roleID,
				['levelData'] = data
			}
		end
	end
	return ret
end

-- 滚动栏更新
function LevelUPUI:OnScrollChanged(transform, idx)
	if not (transform and idx) then return end
	self.levelUpInfo = self.levelUpInfo or {}
	local index = idx + 1
	local data = self.levelUpInfo[index]
	local node = transform.gameObject
	if not (data and node) then return end
	local roleMgr = RoleDataManager:GetInstance()
	local roleID = data.roleID
	local levelData = data.levelData
	-- 角色等级提升数据
	local roleLevelNode = self:FindChild(node, "RoleLevel")
	local roleModle = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
	if roleModle then
		self:FindChildComponent(roleLevelNode, "Head_mask/Role_head", "Image").sprite = GetSprite(roleModle.Head)
	end
	self:FindChildComponent(roleLevelNode, "Text_name", "Text").text = roleMgr:GetRoleName(roleID)
	local msgNode = self:FindChild(roleLevelNode, "Msg")
	local markNode = self:FindChild(msgNode, "Mark")
	markNode:SetActive(false)
	msgNode:SetActive(false)
	if levelData.oldRoleLevel and levelData.newRoleLevel then
		local oldLevel = levelData.oldRoleLevel or 1
		local newLevel = levelData.newRoleLevel or 1
		self:FindChildComponent(msgNode, "Text_level_1", "Text").text = oldLevel
		self:FindChildComponent(msgNode, "Text_level_2", "Text").text = newLevel
		-- 每5级会有一个新天赋出现
		if math.floor(newLevel / 5) > math.floor(oldLevel / 5) then
			markNode:SetActive(true)
		end
		msgNode:SetActive(true)
	end
	-- 武学等级提升数据
	local martialNode = self:FindChild(node, "MaitialLevelList")
	if (martialNode == nil) then
		return
	end
	-- 移除旧节点
	local nodeTrans = martialNode.transform
	for i = 0, nodeTrans.childCount - 1 do
		DRCSRef.ObjDestroy(nodeTrans:GetChild(i).gameObject);
	end
	local objBg1 = self:FindChild(node, "BG")
	local objBg2 = self:FindChild(node, "BG_2")
	-- 显示数据
	if levelData.martialLevelUp and next(levelData.martialLevelUp) then
		local martialCache = levelData.martialLevelUp
		local martialLevelDatas = {}
		-- 整理武学数据
		for martialTypeID, matData in pairs(martialCache) do
			martialLevelDatas[#martialLevelDatas + 1] = {
				['martialTypeData'] = GetTableData("Martial",martialTypeID),
				['oldLevel'] = matData.oldLevel or 1,
				['newLevel'] = matData.newLevel or 1,
				['bHasNewAttr'] = (matData.bHasNewAttr == true),
			}
		end
		table.sort(martialLevelDatas, function(a,b)
			return (a.Rank or 1) < (b.Rank or 1)
		end)
		-- 显示武学升级
		local temnplate = self:FindChild(node, "MartialLevel")
		temnplate:SetActive(false)
		local ui_child = nil
		local martialTypeData = nil
		local iRank = nil
		for index, martialLevelData in ipairs(martialLevelDatas) do
			ui_child = CloneObj(temnplate, martialNode)
			if (ui_child ~= nil) then
				martialTypeData = martialLevelData.martialTypeData
				iRank = martialTypeData.Rank
				self:FindChildComponent(ui_child, "Text_name", "Text").text = getRankBasedText(iRank, GetLanguageByID(martialTypeData.NameID))
				msgNode = self:FindChild(ui_child, "Msg")
				self:FindChildComponent(msgNode, "Text_level_1", "Text").text = martialLevelData.oldLevel
				self:FindChildComponent(msgNode, "Text_level_2", "Text").text = martialLevelData.newLevel
				markNode = self:FindChild(msgNode, "Mark")
				markNode:SetActive(martialLevelData.bHasNewAttr)
				ui_child:SetActive(true)
			end
		end
		martialNode:SetActive(true)
		objBg1:SetActive(false)
		objBg2:SetActive(true)
	else
		martialNode:SetActive(false)
		objBg1:SetActive(true)
		objBg2:SetActive(false)
	end
end

-- 关闭等级提升界面
function LevelUPUI:CloseLevelUpUI()
	RoleDataManager:GetInstance():ClearRoleLevelUpMsg()
	RemoveWindowImmediately('LevelUPUI')
	if self.bNeedDisplayEnd then
		self.bNeedDisplayEnd = nil
		DisplayActionEnd()
	end
end

function LevelUPUI:OnDestroy()
end

function LevelUPUI:OnEnable()
	local win = GetUIWindow("CharacterUI")
	if win then
		win:SetTriggerDontUpdateBackPack()
	end
end

function LevelUPUI:OnDisable()
end

function LevelUPUI:OnPressESCKey() 
    if self.btnTouchClose then
	    self.btnTouchClose.onClick:Invoke()
    end
end

return LevelUPUI