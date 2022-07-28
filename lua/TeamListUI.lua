TeamListUI = class("TeamListUI",BaseWindow)

local MOVE_POS = 100
local ROLE_DISPLAY_MAX = 5
local l_DRCSRef_Type = DRCSRef_Type

function TeamListUI:Init()
	self.objlist = self:FindChild(self._gameObject, "SC_list")

	self.comList_Scroller = self.objlist:GetComponent(typeof(CS.FancyScrollView.FancyScroller))
	if self.comList_Scroller then
		local fun = function(index)
			self:OnSectionChanged(index)
		end
		self.comList_Scroller:SetLuaFunction(fun)
		local scrollFunc=function(dir)
			self:OnScroll(dir)
		end
		self.comList_Scroller:SetOnScrollLuaFunction(scrollFunc)
	end
	self.comList_ScrollView = self.objlist:GetComponent(typeof(CS.FancyScrollView.ScrollView))
	if self.comList_ScrollView then
		local fun = function(cell, idx)
			self:OnScrollChanged(cell, idx)
        end
		self.comList_ScrollView:SetLuaFunction(fun)
	end
	self.objCells = {} -- 不要照着这个写 自己去写类。临时做法 为了快
	self.aiCellToRoleID = {}  --按钮监听只加一次 根据这里的数据 来判定按钮点击 到底做什么
	self.objContent = self:FindChild(self._gameObject, "SC_list/Content")

	-- 队伍数据更新，由主角信息控制
	-- local fun_refresh = function(info)
		-- if self._gameObject and self._gameObject.activeSelf == true then
		-- if self._gameObject and self._gameObject.GameObject  and self._gameObject.activeSelf == true then
		-- 	self:RefreshUI(info)
		-- end
	-- end
	-- 改为角色界面调用进来
	-- 不要使用通用的事件做更新事件, 尽量避免频繁更新和不必要的更新
	-- self:AddEventListener("UPDATE_MAIN_ROLE_INFO",fun_refresh)

	self.selectrole = 0		-- 选中角色的序号。
  self.rolenum = 0			-- 当前一共有多少角色。

	-- 角色数据更新时在下一帧刷新队友数据
	self:AddEventListener("UPDATE_DISPLAY_ROLECOMMON", function()
		self.bNeedRefresh = true
	end)
	self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function()
		self.bNeedRefresh = true
	end)
end

function TeamListUI:Update()
	if self.bNeedRefresh then
		self.bNeedRefresh = false
		self:RefreshUI()
	end
end

-- 根据角色信息刷新界面。
function TeamListUI:RefreshUI(info,selectrole)
	self.iMainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
	if GetGameState() == -1 then
		info = globalDataPool:getData('PlatTeamInfo') or {};
	else
		info = info or (globalDataPool:getData("MainRoleInfo") or {})
	end
  
  local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
  if selectrole then
    self.selectrole = selectrole
	self:SetSelectRoleIndex()
  else
    if (self.selectRoleID) then
      self.selectrole = self:GetSelectIdxByRoleID(self.selectRoleID)
    end
	end

	if self.comList_ScrollView then
		self.rolenum = info["TeammatesNums"] or info["iTeammatesNum"]
		-- 纠正index
		if not self.rolenum then
			return;
    end
    
    self.selectrole = self.selectrole or 0
		if self.selectrole and self.rolenum and self.selectrole > self.rolenum - 1 then
			self.selectrole = self.rolenum - 1
		end
		if self.rolenum and self.rolenum < ROLE_DISPLAY_MAX then
			self.comList_Scroller.fakeStartCell = 2
			self.comList_Scroller.fakeEndCell = 2
			self.comList_ScrollView:SetLoop(false)
			self.comList_Scroller:SetMovementType(2)
			self.comList_ScrollView:UpdateScroll(self.rolenum + 4, self.selectrole + 2)
		else
			self.comList_Scroller.fakeStartCell = 0
			self.comList_Scroller.fakeEndCell = 0
			self.comList_Scroller:SetMovementType(0)
			self.comList_ScrollView:SetLoop(true)
			self.comList_ScrollView:UpdateScroll(self.rolenum, self.selectrole)
		end
	end

	if self._scriptUI then
		self._scriptUI:UpdateTeamLimitMsg()
	end
end

-- 是否需要用 未知 的空节点填充。
function TeamListUI:NeedUnknownChild(idx)
	if idx == 0 or idx == 1 then 
		return true 
	end
	if idx == (self.rolenum + 2) or idx == (self.rolenum + 3) then 
		return true 
	end
	return false
end

-- 重置节点的未知显示状态。
function TeamListUI:SetUnknown(comData, bool)
	comData.objUnknown:SetActive(bool)
	comData.imgHead.gameObject:SetActive(not bool)
	comData.objToggle:SetActive(not bool)
	comData.objUnknownNode:SetActive(not bool)
	comData.button.enabled = not bool
end

function TeamListUI:InitCell(objChild,idx)
	local comData  = {}
	comData.textName = self:FindChildComponent(objChild, "TeamListItemUI/UnknownNode/name_box/Name", l_DRCSRef_Type.Text)
	comData.textExlevel = self:FindChildComponent(objChild, "TeamListItemUI/UnknownNode/name_box/Level", l_DRCSRef_Type.Text)

	comData.imgHead = self:FindChildComponent(objChild, "TeamListItemUI/Mask/Head", l_DRCSRef_Type.Image)
	comData.objToggle = self:FindChild(objChild, "TeamListItemUI/Toggle")
	comData.objUnknownNode = self:FindChild(objChild, "TeamListItemUI/UnknownNode")
	comData.objUnknown = self:FindChild(objChild, "TeamListItemUI/Mask/Unknown")
	comData.button = self:FindChildComponent(objChild, "TeamListItemUI",l_DRCSRef_Type.Button)
	comData.textLevel = self:FindChildComponent(objChild, "TeamListItemUI/UnknownNode/Level", l_DRCSRef_Type.Text)
	comData.buttonInteractive = self:FindChildComponent(objChild, "TeamListItemUI/UnknownNode/Button_Interactive", l_DRCSRef_Type.Button)
	comData.objIn_battle = self:FindChild(objChild, "TeamListItemUI/UnknownNode/In_battle")
	comData.objCreateHalfBodyParent = self:FindChild(objChild, "TeamListItemUI/Mask/CreateHalfBody")

	self.objCells[objChild] = comData
	if comData.buttonInteractive then
		self:RemoveButtonClickListener(comData.buttonInteractive)
		local fun = function()
			local roleID = self.aiCellToRoleID[objChild]
			if self.iMainRoleID ~= roleID then
				if RoleDataManager:GetInstance():CanNPCInteractOper() then
					RoleDataManager:GetInstance():DirectInteract(roleID)
				else
					SystemUICall:GetInstance():Toast('当前无法进行交互', false)
				end
			end
		end
		self:AddButtonClickListener(comData.buttonInteractive,fun)
	end
end

function TeamListUI:SetToggle(comData,idx)
	-- 设置选中 与 渲染
	if self.selectrole == idx then
		comData.objToggle:SetActive(true)
		self:SetRole(idx)
		--setUIGray(comData.imgHead,false)
	else
		comData.objToggle:SetActive(false)
		--setUIGray(comData.imgHead,true)
	end
end

-- 发送数据更新请求。
function TeamListUI:SetRole(idx)
	if self._scriptUI then
		self._scriptUI:SetSelectRoleIndex(idx)	-- 查表，获取ID
	end
end

-- 玩家点击滚动栏后，每个显示的 Child 都会进行更新。
function TeamListUI:OnScrollChanged(cell, idx)
	if self.objCells[cell] == nil then
		self:InitCell(cell,idx)
	end
	local comData = self.objCells[cell]
	-- 当前角色少于 最大显示数量时，使用未知角色填充。
	if self.rolenum < ROLE_DISPLAY_MAX then
		if self:NeedUnknownChild(idx) then
			self:SetUnknown(comData, true)
			return
		else
			idx = idx - 2			-- 修正 idx
		end
	end

	-- SetUIntDataInGameObject(cell,'index',idx + MOVE_POS)
	self:SetUnknown(comData, false)
	self:SetToggle(comData,idx)


	local canTalk = false
	-- local info = nil;
	-- if GetGameState() == -1 then
	-- 	info = globalDataPool:getData('PlatTeamInfo');
	-- else
	-- 	info = globalDataPool:getData("MainRoleInfo")
	-- end
	
	-- local teammates = info["Teammates"] or info["auiTeammates"];
	local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
	if teammates and teammates[idx] then
		local roleid = teammates[idx]
		self.aiCellToRoleID[cell] = roleid
		if roleid ~= self.iMainRoleID and GetGameState() ~= -1 then
			comData.buttonInteractive.gameObject:SetActive(true)
		else	
			comData.buttonInteractive.gameObject:SetActive(false)
		end

		-- TODO: 掌门对决特殊处理
		if PKManager:GetInstance():IsRunning() then
			comData.buttonInteractive.gameObject:SetActive(false)
		end

		local roleinfo = RoleDataManager:GetInstance():GetRoleData(roleid)
		local s_name =  RoleDataManager:GetInstance():GetRoleNameByRoleID(roleid)
		local uiOverlayLevel = RoleDataManager:GetInstance():GetRoleOverlayLevel(roleid)
		local uiRank = RoleDataManager:GetInstance():GetRoleRank(roleid)
		if uiOverlayLevel > 0 then
			comData.textExlevel.gameObject:SetActive(true)
			comData.textExlevel.text = ' +'..uiOverlayLevel
			comData.textExlevel.color = getRankColor(uiRank)
		else 			
			comData.textExlevel.gameObject:SetActive(false)
		end
		if DEBUG_MODE then
			s_name = s_name .. "(" .. roleid .. ")"
		end
		comData.textName.text = s_name
		comData.textName.color = getRankColor(uiRank)

		local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleid)
		local modelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
		if (modelData) then
			comData.imgHead.sprite = GetSprite(modelData.Head)
			comData.imgHead:SetNativeSize()
		end

		if not roleinfo then return end
		if  roleinfo["uiLevel"] then
			comData.textLevel.text = string.format("%d级", roleinfo["uiLevel"])
		end

		local bool_InBattle = RoleDataManager:GetInstance():CheckRoleEmbattleState(roleid)
		comData.objIn_battle:SetActive(bool_InBattle)

		local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
		-- TODO 捏脸14 半身头像 判断是否有捏脸数据 然后生成prefab加载对应数据
		-- 剧本内roleid不是实际id
		local iRoleTypeID = roleid
		if iStoryId ~= 0 then
			local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleid)
			local iMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
			local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
			if roleTypeID == iMainRoleTypeID then 
				iRoleTypeID = iMainRoleCreateRoleID
			end
		end
		local faceData = CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleTypeID)
		if faceData then
			-- 调用接口 生成半身像Prefab
			if comData.objCreateHalfBody then
				comData.objCreateHalfBody = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeID, comData.objCreateHalfBodyParent, comData.objCreateHalfBody, true)
				comData.objCreateHalfBody:SetActive(true)
			else
				comData.objCreateHalfBody = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeID, comData.objCreateHalfBodyParent, nil, true)
			end
			comData.imgHead.gameObject:SetActive(false) -- 将原有头像隐藏
		else
			if comData.objCreateHalfBody then
				comData.objCreateHalfBody:SetActive(false)
			end
			comData.imgHead.gameObject:SetActive(true) -- 将原有头像显示
		end
	end
end

function TeamListUI:CanShowInteractUI(roleTypeID)
	local roleSelectEventList = RoleDataManager:GetInstance():GetRoleSelectEvent(roleTypeID)
	if #roleSelectEventList > 0 then
		return false
	end
	return true
end

-- 滚动视图定位到 某一个角色时，回调（设置选中角色）。
function TeamListUI:OnSectionChanged(idx)
	if not idx then return end
	if self.rolenum < ROLE_DISPLAY_MAX then
		self.selectrole = idx - 2
	else
		self.selectrole = idx
	end

	self:SetSelectRoleIndex()

	local showMainRole = self.selectrole == 0

	-- 掌门对决不显示主角
	if PKManager:GetInstance():IsRunning() then
		showMainRole = false
	end

	if self._scriptUI then
		self._scriptUI:SetMainRoleInfoActive(showMainRole);
	end
end

function TeamListUI:OnDestroy()
	self.comList_Scroller:ClearLuaFunction()
	self.comList_ScrollView:ClearLuaFunction()
end

function TeamListUI:SetScriptUI(scriptUI)
	self._scriptUI = scriptUI;
end

function TeamListUI:GetCurTeammateNum()
	return self.rolenum or 0
end

function TeamListUI:SetSelectRoleIndex(selectIdx)
  selectIdx = selectIdx or self.selectrole
  local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
  if (teammates and teammates[selectIdx]) then
    self.selectRoleID = teammates[selectIdx]
  end
end

function TeamListUI:SetSelectRoleID(roleID)
	self.selectRoleID = roleID
end

function TeamListUI:GetSelectIdxByRoleID(selectRoleID)
  local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
  if (teammates) then
    for key, value in pairs(teammates) do
      if (value == selectRoleID) then
        return key
      end
    end
  end

  return nil
end

function TeamListUI:OnScroll(idx)
	--向上 y>0,向下 y<0 
	self.bNeedRefresh=true
end


return TeamListUI