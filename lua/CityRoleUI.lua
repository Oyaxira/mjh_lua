CityRoleUI = class("CityRoleUI", SpineRoleUINew)

function CityRoleUI:ctor()
	-- 任务进度更新的时候刷新任务标记
	self:AddEventListener("TASK_BROADCAST", function(info)
		if not (self.iCareAboutTaskSignInfo and self.iCurRoleTypeID and info and info.new) then
			return
		end
		local kTaskInfo = self.iCareAboutTaskSignInfo
		if (info.new.uiID == kTaskInfo.taskID)
		and (kTaskInfo.mapTypeID == self.iCurMapID)
		and (kTaskInfo.roleTypeID == self.iCurRoleTypeID) then
			self:UpdateRoleMark(self.iCurMapID)
		end
	end)

	-- 队友数据更新的时候刷新任务标记
	self:AddEventListener("UPDATE_TEAM_INFO", function()
		self:UpdateTeammateMark()
	end, nil, nil, nil, true)
end

function CityRoleUI:OnDestroy()
	if self:HasEventListener("TASK_BROADCAST") then
		self:RemoveEventListener("TASK_BROADCAST")
	end
end

function CityRoleUI:SetGameObject(gameObject)
	self.super.SetGameObject(self,gameObject,gameObject:FindChild("Spine"))
	local objNameNode = self:FindChild(gameObject, 'Name_Node')
	self.comRoleMark = self:FindChildComponent(gameObject, 'head_Node/scale/role_mark', 'Image')
	self.objNameText = self:FindChild(gameObject, 'Name_Node/Name')
	self.comNameText = self:FindChildComponent(gameObject, 'Name_Node/Name', 'Text')
	self.objTeamMarkNode = self:FindChild(objNameNode, 'team_mark')
	self.objRevengeMarkNode = self:FindChild(objNameNode, 'revenge_mark')
	self.objNameTitleFlag = self:FindChild(objNameNode, 'Name/TitleFlag')
end

function CityRoleUI:SetNameActive(bActive)
	if self.objNameText then 
		self.objNameText:SetActive(bActive)
	end
end

function CityRoleUI:SetSpine(objSpine)
	self.super.SetSpine(self,objSpine)
end

function CityRoleUI:SetRoleData(roleData)
	self:SetActive(true)
	if self.super.SetRoleData(self,roleData) then 
		self:UpdateCityRole()
	end
end

function CityRoleUI:UpdateCityRole(mapID)
	self.iCurMapID = mapID

	self:UpdateRoleSpine()
	self:UpdateRoleName()

	self.iCareAboutTaskSignInfo = nil
	self:UpdateRoleMark(mapID)
end

function CityRoleUI:UpdateRoleMark(mapID)
	-- 迷宫也用CityRoleUI来刷新任务标记的, 这个时候mapID会是空的
	-- 所有不要对mapID进行判空, 判空会导致迷宫格任务标记不刷新
	if not (self.roleData and self.roleData.uiID) then
		return
	end
	self.iCurRoleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(self.roleData.uiID)
	local mazeBaseID = MazeDataManager:GetInstance():GetCurMazeTypeID()
	local max_weight_info = TaskDataManager:GetInstance():CheckRoleMark(self.roleData.uiID, mapID, mazeBaseID, nil)
	-- 如果没有任务标记信息, 那么热判断当前是否是门派守门人站在门派入口, 如果是, 判断要不要显示门派委托任务标记
	-- 这是段特殊逻辑, 因为门派委托任务的标记走的不是通用的流程
	if not (max_weight_info and max_weight_info.state) then
		local bCanAddDelTask, iClanTypeID = ClanDataManager:GetInstance():CanAddDelegationTask(self.roleData.uiID)
		if (bCanAddDelTask == true) and (iClanTypeID ~= nil) and (mapID ~= nil) then
			local kClanEliminate = TableDataManager:GetInstance():GetTableData("ClanEliminate", iClanTypeID)
			local kEvoMaster = RoleDataHelper.CheckSubMaster(self.roleData.uiID)  -- 是否是掌门人?
			local kEvo = RoleDataHelper.CheckDoorKeeper(self.roleData.uiID)  -- 是否是守门弟子?
			if (kEvoMaster and (kEvoMaster.iParam1 == iClanTypeID) and (mapID == kClanEliminate.SubMasterPosition))
			or (kEvo and (kEvo.iParam1 == iClanTypeID) and (mapID == kClanEliminate.ClanBuilding)) then
				max_weight_info = {['state'] = 'regional_new'}
			end
		end
	end
	-- 如果门派委托没有拿到数据, 那么检查一下要不要显示城市委托(六扇门)委托任务标记
	if not (max_weight_info and max_weight_info.state) then
		local curCityID = CityDataManager:GetInstance():GetCurCityID()
		local kComfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
		local uiCityDelOpenTagID = kComfig and kComfig.CityDelegationOpenTag or 0

		if uiCityDelOpenTagID 
		and mapID
		and TaskTagManager:GetInstance():TagIsValue(uiCityDelOpenTagID, 1) 
		and curCityID and (CityDataManager:GetInstance():IsCityDelegationTaskStart(curCityID) == false)
		and RoleDataManager:GetInstance():CanRolePublishGovernmentTask(self.roleData.uiID, mapID) then
			max_weight_info = {['state'] = 'regional_new'}
		end
	end
	-- 显示卡片上角色的任务标记
	if max_weight_info and max_weight_info.state then
		-- 如果设置了任务标记, 那么表示当前卡片需要关心这个任务的进度变化
		self.iCareAboutTaskSignInfo = max_weight_info
		self.comRoleMark.gameObject:SetActive(true)
		self.comRoleMark.sprite = GetAtlasSprite("CommonAtlas", max_weight_info.state)
	else
		self.iCareAboutTaskSignInfo = nil
		self.comRoleMark.gameObject:SetActive(false)
	end
end

function CityRoleUI:HideRoleMark()
	self.comRoleMark.gameObject:SetActive(false)
end

function CityRoleUI:ShowTeamMark()
	if IsValidObj(self.objTeamMarkNode) then 
		self.objTeamMarkNode.gameObject:SetActive(true)
	end
end

function CityRoleUI:HideTeamMark()
	if IsValidObj(self.objTeamMarkNode) then 
		self.objTeamMarkNode.gameObject:SetActive(false)
	end
end

function CityRoleUI:UpdateCityRoleByCustomData(customData)
	self:OnlySetModelID(customData.ArtID)
	self:UpdateRoleNameByCustomData(customData)
	self:HideRoleMark()
end

function CityRoleUI:UpdateRoleGrade(grade)
	if grade and grade > 0 then
		local name = self.roleData:GetName()
		local rank = self.roleData:GetRoleRank()
		self.comNameText.text =  getRankBasedText(rank, name .. '+' .. grade)
	end
end

function CityRoleUI:UpdateRoleName()
	if not self.roleData then
		if IsValidObj(self.objTeamMarkNode) then 
			self.objTeamMarkNode.gameObject:SetActive(false)
		end
		self.objRevengeMarkNode.gameObject:SetActive(false)
		return
	end
	local name = self.roleData:GetName()
	local iRank = self.roleData:GetRoleRank()
	local igrade = CardsUpgradeDataManager:GetInstance():GetRoleExRankByRoleID(self.roleData.uiTypeID )
	self.comNameText.text = getRankBasedText(iRank, name)
	local roleBaseID = self.roleData.uiTypeID
	local roleDataMgr = RoleDataManager:GetInstance()
	local roleID = roleDataMgr:GetRoleID(roleBaseID)
	if self.objNameTitleFlag then 
        local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID, NET_NAME_ID)
		if BeEvolution and BeEvolution.iParam2 == -1 then
			self.objNameTitleFlag:SetActive(true)
		else
			self.objNameTitleFlag:SetActive(false)
		end 
	end 
	self:UpdateTeammateMark()
	if roleDataMgr:IsRevengeRole(roleID) then 
		self.objRevengeMarkNode.gameObject:SetActive(true)
	else
		self.objRevengeMarkNode.gameObject:SetActive(false)
	end
end

-- 更新队友标记
function CityRoleUI:UpdateTeammateMark()
	if not IsValidObj(self.objTeamMarkNode) then 
		return
	end
	if not self.roleData then
		self.objTeamMarkNode.gameObject:SetActive(false)
		return
	end
	local roleBaseID = self.roleData.uiTypeID
	local roleDataMgr = RoleDataManager:GetInstance()
	local roleID = roleDataMgr:GetRoleID(roleBaseID)
	local isInTeam = roleDataMgr:IsRoleInTeam(roleID)
	if isInTeam then
		self.objTeamMarkNode.gameObject:SetActive(true)
	else
		self.objTeamMarkNode.gameObject:SetActive(false)
	end
end

function CityRoleUI:UpdateRoleNameByCustomData(customData)
	local name = GetLanguageByID(customData.NameID)
	local rank = RankType.RT_White
	self.comNameText.text = getRankBasedText(RankType.RT_White, name)
	if IsValidObj(self.objTeamMarkNode) then 
		self.objTeamMarkNode.gameObject:SetActive(false)
	end
	self.objRevengeMarkNode.gameObject:SetActive(false)
end

function CityRoleUI:PlayRoleRecoverAnim()
	if not self.gameObject then 
		return 
	end
	local comTween = self.gameObject:GetComponent('DOTweenAnimation')
	if comTween then 
		comTween:DOPlayForward()
	end
end

function CityRoleUI:PlayRoleSelectAnim()
	if not self.gameObject then 
		return 
	end
	local comTween = self.gameObject:GetComponent('DOTweenAnimation')
	if comTween then 
		comTween:DOPlayBackwards()
	end
end

-- function CityRoleUI:ShowBubble(bubbleStr, showtime)
--     self:ShowBubble(bubbleStr, showtime)
-- end

function CityRoleUI:SetAction(animName, isLoop, spineAnimInfo)
	local trackEntry = self.super.SetAction(self,animName, isLoop, spineAnimInfo)
	if animName == AnimEnumNameMap[SpineAnimType.SPT_TREASURE_OPEN] then 
		local keyFrameName = 'drop'
		local animTime = getActionFrameTime(self.modelID, animName, keyFrameName)
		local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.modelID)
		if roleModelData and roleModelData.OpenAudio then 
			PlaySound(roleModelData.OpenAudio)
		end
		return animTime
	end
	if trackEntry == nil then 
		return 0
	else
		return trackEntry.AnimationEnd
	end
end

function CityRoleUI:ResetPerfabWeapon(objRoleSpine)
	--self.objRoleSpine = objRoleSpine
	self:ClearItemSpine()
	self:ClearItemPerfab()
	self:ResetBoneFollower()
end

function CityRoleUI:SetNameTextSize(size)
	if self.comNameText then
		self.comNameText.text = getSizeText(size,self.comNameText.text)
	end
end

return CityRoleUI