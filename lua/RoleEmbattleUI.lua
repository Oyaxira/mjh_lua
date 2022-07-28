RoleEmbattleUI = class("RoleEmbattleUI",BaseWindow)

local SpineRoleUI = require 'UI/Role/SpineRoleUI'
local JudgeEnum = 
{
	['SUCCESS'] = 1,
	['NO_FULL'] = 2, --有场次没有布阵单位
	['REPAT_ROLE'] = 3, --重复单位
	['FORBID_CLAN'] = 4, --门派不可上阵
	['NO_EVIL_ELIMINATE_GIFT'] = 5, --没有邪线踢馆所需天赋
	['UNKNOW'] = 6, -- 未知错误
}

local RoleStatueType = 
{
	["TEAM"] = 1,--上阵单位
	["SUB"] = 2, --替补单位
	["ASSIST"] = 3, --助战单位
}

local Type = {
	['SCRIPT_BATTLE'] = 1,
	['TOWN_BATTLE']	= 2,
}

local RoundNum = 
{
	[1] = "一",
	[2] = "二",
	[3] = "三"
}

local g_IS_WINDOWS
local l_UI_CAMER

function RoleEmbattleUI:ctor(obj)
	self.akRoleEmbattle = nil
	self.comScrollRect = nil
	self.bUpdateItemPos = false
	self.comRole_Head_Embattle = false
	self.comDragItemGrid = nil
	self.objGrids ={} --注意 点击在哪个格子 是通过名字来做的 不要改名字!
	self.objGrids_choose = nil
	self.iCurToggleID = 1
	self.iCurRound = 1
	self.iSelectRoleID = nil --{roleid}
	self.objTiBuBG = nil
	self.objZhuZhenBG = nil
	self.objHelpBackImg = nil
	self.objCloneActor = nil
	self.objFreeRoleActors = {}
	self.objGridRoleActors = {}
	self.objGridRoleActors_Texture = {}
	
	self.objActor_Node = nil
	self.aiTeamRoleID = nil
	self.bNeedSendData = false
	self.aiUpdateRound = {}
	self.SpineRoleUI = SpineRoleUI.new()
	self.objStartWheelWarButton = nil
	self.bOpenByWheelWar = false
	self.objWheelWarRoundToogle = {}
	self.type = 1
	self.bIsSingle = true;
	self.curSelectEmbattleRole = -1
	self.OldSelectEmbattleRole = 0
	self.subList = {}
	self.bNeedSetMainRole = false;

	self.strPetName = {}
	self.strRoleName = {}
end

function RoleEmbattleUI:Create()
	local obj = LoadPrefabAndInit("Role/RoleEmbattleUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function RoleEmbattleUI:Init()
	self.objBackButton = self:FindChildComponent(self._gameObject,"newFrame/Btn_exit","Button")
	self:AddButtonClickListener(self.objBackButton, function() 
		if self.type == Type.SCRIPT_BATTLE then
			if self.bOpenByWheelWar then
				self:OnClickStartWheelWarButton(false) 
			elseif self.bOpenByFinalBattle then
				if self.finalBattleInfo.bInCity then
					local msg = "是否放弃战斗，修整时日？"
					OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, function()
						SendClickFinalBattleQuitCity()
						self:CloseUI()
					end})
				else
					local msg = "先行告退，援助其他城市？"
					OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, function()
						self:CloseUI()
					end})
				end
			elseif self.bOpenByHighTower then
				HighTowerDataManager:GetInstance():RegimentEmbattleOver(false)
				self:CloseUI() 
			else
				self:CloseUI() 
			end
		elseif self.type == Type.TOWN_BATTLE then
			self:OnClickCloseBtn()
		end 
	end)
	self.objTiGuan = self:FindChild(self._gameObject,'Text_TiGuan')
	self.objTiGuan_Text = self.objTiGuan:GetComponent("Text")
	self.objTiBu = self:FindChild(self._gameObject,'Text_TiBu')
	self.objAssistTipsButton = self:FindChild(self._gameObject,'AssistTipsButton')

	local assistTipsButton = self.objAssistTipsButton:GetComponent("Button")
	self:AddButtonClickListener(assistTipsButton, function ()
		self:OnClickAssistTips()
	end)

	self.objRoundNode = self:FindChild(self._gameObject,'Canvas_Node/ToggleGroup_Round')
	self.objRoundNode.gameObject:SetActive(false)
	self.objSCImageBG = self:FindChild(self._gameObject,"ScrollRect_Image_BG")
	self.objScrollRect = self:FindChild(self.objSCImageBG,"ScrollRect")
	self.comScrollRect = self:FindChildComponent(self.objSCImageBG,"ScrollRect","LoopVerticalScrollRect")
	self.ImgScriptBG = self:FindChild(self.objSCImageBG,"Image_ScriptBG")
	self.ImgTownBG = self:FindChild(self.objSCImageBG,"Image_TownBG")
	self.objEmbattleRoot = self:FindChild(self._gameObject,"GridMaskAreaRoot/AnimRoot")
	self.objRoleEmbattleGrid = self:FindChild(self._gameObject,"GridMaskAreaRoot/AnimRoot/GridMaskArea/RoleEmbattleGridUI")
	self.objTibuBG = self:FindChild(self.objRoleEmbattleGrid,"tibu_BG")
	self.objImageBG = self:FindChild(self.objRoleEmbattleGrid,"Image_BG")
	self.objSubRoleTips = self:FindChild(self._gameObject,"ScrollRect_Image_BG/Text_TiBu_default")
	self.objSubRoleNullTips = self:FindChild(self._gameObject,"ScrollRect_Image_BG/Text_TiBu_null")
	local kdragItem = self.objRoleEmbattleGrid:GetComponent("DragItem")
	self.comDragItemGrid = kdragItem
	local dragAction = function (obj,inParent)
		self:OnDrag(obj,inParent)
	end
	kdragItem:SetDragAction(function (obj,inParent) self:OnDrag(obj,inParent) end) 
	kdragItem:SetPointDownAction(function (obj,inParent) self:OnBeginDrag(obj,inParent) end) 
	kdragItem:SetEndDragAction(function (obj,inParent) self:OnEndDrag(obj,inParent) end)

	for i = 1, 20 do
		self.objGrids[i] = self:FindChild(kdragItem.gameObject,i).transform.position
	end

	--处理助战位置
	local w = SSD_BATTLE_GRID_WIDTH / 2
	for i=1,4 do
		for j=6,7 do
			local lastIndex = i + (j - 2) * w
			local curIndex = i + (j - 1) * w
			self.objGrids[curIndex]	= DRCSRef.Vec3(self.objGrids[lastIndex].x+3,self.objGrids[lastIndex].y+2,self.objGrids[lastIndex].z);
		end
	end

	local posGrid = {17,13,9,5,1} --备注 格子外替补站位的参考格子
	self.TotalBattleRole = #self.objGrids
	local index = 1
	for i = self.TotalBattleRole+1, self.TotalBattleRole+10 do
		local grid = index%(#posGrid) == 0 and #posGrid or index%(#posGrid)
		grid = posGrid[grid]
		local diff = 4
		if index > 5 then
			diff = 8
		end
		self.objGrids[i] = DRCSRef.Vec3(self.objGrids[grid].x - diff,self.objGrids[grid].y,self.objGrids[grid].z);
		index = index + 1
	end

	self.objStartWheelWarButton = self:FindChildComponent(self._gameObject,"ChallengeAgain_Button","Button")
	if self.objStartWheelWarButton  then	
		self:AddButtonClickListener(self.objStartWheelWarButton, function ()
			self:OnClickStartWheelWarButton(true) end)
		self.objStartWheelWarButton.gameObject:SetActive(false)
	end

	self.objCommonStartButton = self:FindChildComponent(self._gameObject,"CommonStart_Button","Button")
	if self.objCommonStartButton then	
		self:AddButtonClickListener(self.objCommonStartButton, function () self:OnClickCommonStartButton() end)
		self.objCommonStartButton.gameObject:SetActive(false)
	end

	self.objTiBuBG = self:FindChild(kdragItem.gameObject,"tibu_BG")
	self.objZhuZhenBG = self:FindChild(kdragItem.gameObject,"zhuzhen_BG")
	self.objHelpBackImg = self:FindChild(self._gameObject,"GridMaskAreaRoot/AnimRoot/GridMaskArea/HelpEmbattleGridUI")
	self.objGrids_choose = self:FindChild(kdragItem.gameObject,"Grid_Choose")
	self.objGrids_choose:SetActive(false)
	self.objGrids_chooseImage = self:FindChildComponent(kdragItem.gameObject,"Grid_Choose","Image")

	self.comRole_Head_Embattle = self:FindChildComponent(self._gameObject,"Role_Head_Embattle","RectTransform")
	self.comRole_Head_Embattle.gameObject:SetActive(false)
	self.objCloneActor = self:FindChild(self._gameObject,"Actor_Node/Base_Actor_Clone")
	self.InitScale = self.objCloneActor.transform.localScale
	self.objCloneActor:SetActive(false)
	self.objActor_Node = self:FindChild(self._gameObject,"Actor_Node")


	self.objBottom = self:FindChild(self._gameObject, "ToggleGroup_Bottom");
	self.objArena = self:FindChild(self._gameObject, "ToggleGroup_Arena");
	self.objTown = self:FindChild(self._gameObject, "Image_Town");
	self.objTextTips = self:FindChild(self.objTown, "Text_Tips");
	self.objImageNetMask = self:FindChild(self._gameObject, "Image_NetMask");
	
	self.singleTog = self:FindChildComponent(self.objArena, 'Toggle_Single', 'Toggle');
	local objText = self:FindChild(self.singleTog.gameObject, 'Text');
	if self.singleTog then
		local _callBack = function(boolHide)
			if boolHide then
				self:OnClickSingleTog();
				objText:GetComponent('Text').color = DRCSRef.Color(0xff/0xff, 0xff/0xff, 0xff/0xff);
			else
				objText:GetComponent('Text').color = DRCSRef.Color(0x2b/0xff, 0x2b/0xff, 0x2b/0xff);
			end
		end
		self:AddToggleClickListener(self.singleTog, _callBack);
	end

	self.teamTog = self:FindChildComponent(self.objArena, 'Toggle_Team', 'Toggle');
	local objText = self:FindChild(self.teamTog.gameObject, 'Text');
	if self.teamTog then
		local _callBack = function(boolHide)
			if boolHide then
				self:OnClickTeamTog();
				objText:GetComponent('Text').color = DRCSRef.Color(0xff/0xff, 0xff/0xff, 0xff/0xff);
			else
				objText:GetComponent('Text').color = DRCSRef.Color(0x2b/0xff, 0x2b/0xff, 0x2b/0xff);
			end
		end
		self:AddToggleClickListener(self.teamTog, _callBack);
	end

	self.helpTog = self:FindChildComponent(self.objArena, 'Toggle_Help', 'Toggle');
	local objText = self:FindChild(self.helpTog.gameObject, 'Text');
	if self.helpTog then
		local _callBack = function(boolHide)
			self.objAssistTipsButton:SetActive(boolHide)
			if boolHide then
				self:OnClickHelpTog();
				objText:GetComponent('Text').color = DRCSRef.Color(0xff/0xff, 0xff/0xff, 0xff/0xff);
			else
				objText:GetComponent('Text').color = DRCSRef.Color(0x2b/0xff, 0x2b/0xff, 0x2b/0xff);
			end
		end
		self:AddToggleClickListener(self.helpTog, _callBack);
	end

	local copyTeamBtn = self:FindChildComponent(self.objTown, 'CopyTeam_Button', 'Button');
	if copyTeamBtn then
		local _callBack = function()
			self:OnClickCopyTeamBtn();
		end
		self:AddButtonClickListener(copyTeamBtn, _callBack);
	end

	self.objNavTemplate = self:FindChild(self._gameObject,"Toggle_EmbattleTemplate")
	self.objNavGroup = self:FindChild(self._gameObject,"ToggleGroup_Bottom")
	self:InitEmbattleButtons()  -- 初始化布阵按钮组

	for i= 1,3 do
		local kToggle = self:FindChildComponent(self._gameObject,"Canvas_Node/ToggleGroup_Round/Toggle_Round"..i,"Toggle")
		if kToggle then
			local fun = function (bSelect)
				local iIndex = i
				if bSelect then
					self:SelectRoundToggle(iIndex)
				end
			end
			self.objWheelWarRoundToogle[i] = kToggle
			self:AddToggleClickListener(kToggle,fun)
		end
	end

	--是否是pc
	local appPlatform = CS.UnityEngine.Application.platform
	local platEditor = CS.UnityEngine.RuntimePlatform.WindowsEditor
	local platPlayer = CS.UnityEngine.RuntimePlatform.WindowsPlayer
	g_IS_WINDOWS = (appPlatform == platEditor) or (appPlatform == platPlayer)
	l_UI_CAMER = UI_Camera

	self:OnRefUIByPlayerSetting();

	self.bigMap = GetUIWindow('TileBigMap')
end
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
function RoleEmbattleUI:Update()
	if self.bUpdateItemPos then
		if (g_IS_WINDOWS and CS.UnityEngine.Input:GetMouseButton(0))
		or ((not g_IS_WINDOWS) and (DRCSRef.Input.touchCount > 0)) then
			self.comRole_Head_Embattle.localPosition = GetTouchUIPos()
		else
			self:HideChooseItem()
			self:SetSelectGridColor(nil,false)
		end
	end
end

function RoleEmbattleUI:OnPressESCKey()
    if self.objBackButton then
	    self.objBackButton.onClick:Invoke()
    end
end

function RoleEmbattleUI:RefreshUI(embattleInfo)
	self.bOpenByWheelWar = false
	self.bOpenByFinalBattle = false
	self.bOpenByHighTower = false
	self.bShowWheelWar = true
	self.subList = {}
	self.objActor_Node:SetActive(true)
	self.iCantChooseClan = nil
	self.bEvilEliminate = nil
	self.eCommomEmbattleType = nil
	self.auiShowEmbattleSchemeTypes = nil	-- 只显示指定的布阵类型
	self.iAllRoundNum = 3
	if embattleInfo then
		self.eCommomEmbattleType = embattleInfo.eCommomEmbattleType
		self.bOpenByWheelWar = embattleInfo.bOpenByWheelWar or false
		self.bOpenByFinalBattle = embattleInfo.bOpenByFinalBattle or false
		self.bOpenByHighTower = embattleInfo.bOpenByHighTower or false
		self.iAllRoundNum = embattleInfo.data.iAllRoundNum or 3
		self.iCantChooseClan = embattleInfo.data and embattleInfo.data.iCantChooseClan
		self.bEvilEliminate = embattleInfo.data and embattleInfo.data.bEvilEliminate
		if self.bOpenByFinalBattle then
			self.finalBattleInfo = embattleInfo.data
		end

		if self.bOpenByFinalBattle or self.bOpenByHighTower then
			self.bShowWheelWar = false
		elseif embattleInfo.bShowWheelWar ~= nil then
			self.bShowWheelWar = embattleInfo.bShowWheelWar
		end
		self.objTiGuan_Text.text = "踢馆战斗需要连续战斗"..RoundNum[self.iAllRoundNum].."场，每场至少一人出战，任一场次无人上阵时，都不可进行踢馆战斗"
	end

	self.iGameState =  GetGameState()
	self.bClearNormalEmbattle = self.bOpenByFinalBattle or self.bOpenByHighTower
	self.bShowCommonStart = self.bOpenByFinalBattle or self.bOpenByHighTower
	self:InitCommonEmbattleInfo(self.eCommomEmbattleType)

	self.akRoleEmbattle = RoleDataManager:GetInstance():GetRoleEmbattleInfo()
	self:CheckArenaPetsSafe()
	if self.iCantChooseClan ~= nil then 
		-- 禁止参战门派成员剔除
		self:RemoveClanRoleFromEmbattle(self.iCantChooseClan)
	end

	if self.bClearNormalEmbattle then
		-- 清空普通布阵
		if self.akRoleEmbattle then
			local normalEmbattle = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
			if normalEmbattle then
				for index = #normalEmbattle, 1, -1 do
					normalEmbattle[index] = nil
				end
			end
		end
  	end

	self.objStartWheelWarButton.gameObject:SetActive(self.bOpenByWheelWar)
	if self.bShowCommonStart then
		self.objCommonStartButton.gameObject:SetActive(true)
	else
		self.objCommonStartButton.gameObject:SetActive(false)
	end
	if self.bOpenByWheelWar  then
		self.iCurToggleID = EmBattleSchemeType.EBST_WheelWar
		self.iCurRound = self.iCurRound or 1
	else
		self.iCurToggleID = EmBattleSchemeType.EBST_Normal
		self.iCurRound = 1
	end

	local info = nil;
	if self.iGameState == -1 then
		info = globalDataPool:getData('PlatTeamInfo');
		if info then
			local pets = CardsUpgradeDataManager:GetInstance():GetPets();
			info.Pets = table_lua2c(pets);
			info.PetsNum = getTableSize2(pets);

			local arenaHelp = self.akRoleEmbattle[EmBattleSchemeType.EBST_ArenaHelp][1];
			for i = 1, #(arenaHelp) do
				for j = 1, info.PetsNum do
					if arenaHelp[i].uiRoleID == pets[j].uiRootID then
						arenaHelp[i].uiRoleID = pets[j].uiBaseID;
					end
				end
			end

			-- TODO 默认组队
			self.bIsSingle = false;
			self.iCurToggleID = 6;
		end

		--
		if CHANGE_TEAM_BATTLE then
			-- RoleDataManager:GetInstance():ResetRoleEmbattle2();
			-- self.bNeedSetMainRole = true;
			-- local aiTeamRoleID = RoleDataManager:GetInstance():GetRoleTeammates(false, true);
			-- aiTeamRoleID = table_c2lua(aiTeamRoleID);
			-- for i = 1, #(aiTeamRoleID) do
			-- 	local roledata = RoleDataManager:GetInstance():GetRoleData(aiTeamRoleID[i])
			-- 	if roledata then
			-- 		RoleDataManager:GetInstance():AutoAddRole2EmbattleDataPlat(aiTeamRoleID[i]);
			-- 	end
			-- end
		end
	else
		info = globalDataPool:getData("MainRoleInfo");
    end

	if not info then
		return;
	else
		if info.dwScriptID and info.dwScriptID > 0 then
			local TB_Story = TableDataManager:GetInstance():GetTable("Story")
			local nameID = TB_Story[info.dwScriptID].NameID;
			local time = os.date('%Y-%m-%d %H:%M:%S', info.uiTime);
			local comTextTips = self.objTextTips:GetComponent('Text');
			comTextTips.text = '保存于'.. time .. '《' .. GetLanguageByID(nameID) .. '》';
		end
	end

	self.TeammatesNums =  info["TeammatesNums"] or info["iTeammatesNum"] or 0
	self.aiTeamRoleID = self:GetTeamRoles()
	self.AssistTeammatesNums = 0
	self.aiAssistTeamRoleID = {}
	if self.aiTeamRoleID and self.iGameState ~= -1 then 
		for i,iroleid in pairs(self.aiTeamRoleID) do 
			gift = GiftDataManager:GetInstance():isExistAssistGift(iroleid)
			if gift then
				self.AssistTeammatesNums = self.AssistTeammatesNums + 1
				table.insert(self.aiAssistTeamRoleID,iroleid)
			end
		end
	end 
	self.aiPetdata = info["Pets"] or {}
	self.PetsNum = info["PetsNum"] or 0
	self.comScrollRect.totalCount = self.TeammatesNums
	self:SortEmbattleRole()
	self.comScrollRect:RefillCells()

	if self.iCurToggleID == EmBattleSchemeType.EBST_Normal or self.iCurToggleID == EmBattleSchemeType.EBST_Team 
		or self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar  then
		self.objEmbattleRoot.transform.localPosition = DRCSRef.Vec3(0,-2,0)
		self.objActor_Node.transform.localPosition = DRCSRef.Vec3(0,-2,0)
	end

	self.bSelectRole = false
	self:RefreshToggle()
	self:UpdateEmbattleInfo(self.iCurToggleID,self.iCurRound)

	-- TODO: 走掌门对决逻辑，似乎还没屏蔽助战区和替换区
	if PKManager:GetInstance():IsRunning() then
		self.objNavGroup:SetActive(false)
		return
	end
end

function RoleEmbattleUI:InitCommonEmbattleInfo(eType)
	if not eType then
		return
	end

	self.bClearNormalEmbattle = true
	self.bShowCommonStart = true
	self.bShowWheelWar = false

	self.auiShowEmbattleSchemeTypes = {}
	self.auiShowEmbattleSchemeTypes[EmBattleSchemeType.EBST_Normal] = true
	self.auiShowEmbattleSchemeTypes[EmBattleSchemeType.EBST_Help] = true
end

function RoleEmbattleUI:CheckCommonEmbattleSubmit()
	if not self.eCommomEmbattleType then
		return false
	end

	self:SetUpdateFlag(EmBattleSchemeType.EBST_Normal, 1)
	self:SendUpdateRoleEmbattleData()
	SendCommonEmbattleResult(true)
	RemoveWindowImmediately("RoleEmbattleUI")
	return true
end

function RoleEmbattleUI:CheckCommonEmbattleCancel()
	if not self.eCommomEmbattleType then
		return
	end

	SendCommonEmbattleResult(false)
	return false
end

function RoleEmbattleUI:ShowPetList(bshow)
	if bshow then
		self.comScrollRect.totalCount = self.TeammatesNums + self.PetsNum
	else
		self.comScrollRect.totalCount = self.TeammatesNums
	end
	self:SortEmbattleRole()
	self.comScrollRect:RefillCells()
end

function RoleEmbattleUI:OnClickAssistTips()
	local embattleData = self:GetHelpData()
	local strTips = RoleDataManager:GetInstance():GetAssistTipsInfo(embattleData,self.aiPetdata,self.strRoleName)
	if strTips.content == "" then
		strTips.content = "当前没有配置助战队友，请配置后再来查看累计助战效果"
	end
	OpenWindowImmediately("TipsPopUI",strTips)
end

function RoleEmbattleUI:OnClickStartWheelWarButton(bStart)
	if bStart  then
		if self.bNeedSendData then
			self:SendUpdateRoleEmbattleData()
		end

		local iResult = self:JudgeWheelWarCondition()
		if iResult == JudgeEnum.REPAT_ROLE then
			local str = "车轮战不允许重复上阵"
			SystemUICall:GetInstance():Toast(str)
			return
		elseif iResult == JudgeEnum.NO_FULL then
			local str = "车轮战每场至少上阵1人"
			SystemUICall:GetInstance():Toast(str)
			return
		elseif iResult == JudgeEnum.FORBID_CLAN then 
			SystemUICall:GetInstance():Toast('当前踢馆门派的角色不可上阵')
			return
		elseif iResult == JudgeEnum.NO_EVIL_ELIMINATE_GIFT then 
			SystemUICall:GetInstance():Toast('未使用三逆丹的角色不可上阵')
			return
		elseif iResult == JudgeEnum.UNKNOW then 
			SystemUICall:GetInstance():Toast('不可上阵')
			return
		end
	end
	self:CloseUI() 
	local uiClanTypeID = ClanDataManager:GetInstance():GetTiGuanState()
    local data =  EncodeSendSeGC_Click_Battle_WheelWar_Result(bStart == true and 1 or 0, uiClanTypeID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BATTLE_WHEEL_WAR_RESULT, iSize, data)
	ClanDataManager:GetInstance():SetTiGuanState(0)
end

function RoleEmbattleUI:OnClickCommonStartButton()
	local emBattleData = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal]
	if not emBattleData[1] or #emBattleData[1] <= 0 then
		local str = "至少上阵1人"
		SystemUICall:GetInstance():Toast(str)
		return
	end

	if self:CheckCommonEmbattleSubmit() then
		return
	end

	if self.bOpenByFinalBattle then
		self:SendUpdateRoleEmbattleData()
		SendClickFinalBattleEnterCity(self.finalBattleInfo.uiFinalBattleCityID, self.finalBattleInfo.bInCity)
		RemoveWindowImmediately("RoleEmbattleUI")
	elseif self.bOpenByHighTower then
		self:SendUpdateRoleEmbattleData()
		HighTowerDataManager:GetInstance():RegimentEmbattleOver(true)
		RemoveWindowImmediately("RoleEmbattleUI")
	end
end

function RoleEmbattleUI:CheckRoleEnterClanEliminate(roleID, cantChooseClan, isEvilEliminate)
	if not cantChooseClan and not isEvilEliminate then
		return JudgeEnum.SUCCESS
	end

	if roleID == RoleDataManager:GetInstance():GetMainRoleID() then
		return JudgeEnum.SUCCESS
	end

	if self.bEvilEliminate == 1 then
		-- 必须要指定天赋才能上阵
		local success = self:CheckRoleEnterEvilBattle(roleID)

		if success then
			return JudgeEnum.SUCCESS
		else
			return JudgeEnum.NO_EVIL_ELIMINATE_GIFT
		end
	elseif self.iCantChooseClan and self.iCantChooseClan ~= 0 then 
		-- 必须不为指定门派才能上阵

		local RoleData = RoleDataManager:GetInstance():GetRoleData(roleID)
		if RoleData and RoleData.uiClanID == self.iCantChooseClan then 
			return JudgeEnum.FORBID_CLAN
		end

		return JudgeEnum.SUCCESS
	end

	return JudgeEnum.UNKNOW
end

function RoleEmbattleUI:JudgeWheelWarCondition()
	--合法性判断 是否每场都有单位 且不重复
	-- TODO : 没有 不可加入的门派角色
	local emBattleData = self.akRoleEmbattle[EmBattleSchemeType.EBST_WheelWar]
	local kRoleID2Num = {}
	for i = 1, self.iAllRoundNum do 
		local kOndData = emBattleData[i]
		if kOndData and #kOndData > 0 then
			for k,v in pairs(kOndData) do
				if kRoleID2Num[v] then
					return JudgeEnum.REPAT_ROLE
				end 

				local ret = self:CheckRoleEnterClanEliminate(v.uiRoleID, self.iCantChooseClan, self.bEvilEliminate)
				if ret ~= JudgeEnum.SUCCESS then
					return ret
				end

				kRoleID2Num[v] = true
				
			end
		else
			return JudgeEnum.NO_FULL
		end
	end	
	return JudgeEnum.SUCCESS
end

function RoleEmbattleUI:SendUpdateRoleEmbattleData()
	CHANGE_TEAM_BATTLE = true;
	self.bNeedSendData = false;
	SetConfig("LastEmbattleTime", os.time())
	for iToggleID,aiRounds in pairs(self.aiUpdateRound) do
		for k,iRound in pairs(aiRounds) do
			local embattleData = self.akRoleEmbattle[iToggleID][iRound];
			if self.iGameState == -1 then
				local temp = {}
				for i = 1, #(embattleData) do
					temp[i - 1] = embattleData[i];
				end
				SendPlatEmbattle(self.bIsSingle and 1 or 0, #(embattleData), temp);
			elseif PKManager:GetInstance():IsRunning() then
				PKManager:GetInstance():RequestBattlePos(embattleData, iRound)
			else
				SendUpdateEmbattleData(embattleData,iToggleID,iRound);
			end
		end
	end
	self.aiUpdateRound = {}
end

-- 更新布阵按钮
function RoleEmbattleUI:InitEmbattleButtons()
	-- 布阵方案id到toggle ui实例的映射
	self.schemeID2ToggleNode = {}
	local transNavGroup = self.objNavGroup.transform
	local iNodeConut = transNavGroup.childCount
	-- self:RemoveAllChildToPoolAndClearEvent(transNavGroup)
	-- TODO 布阵方案解锁的功能现在没有, 这里暂时不考虑方案有没有解锁, 方案表EmbattleScheme里只放了三组必要数据
	local kToggle = nil
	local firstToggle = nil
	local bShow =false;
	local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
	local index = 0
	for _, data in ipairs(TB_EmbattleScheme) do

		index = index + 1
		
		if index > iNodeConut then
			break
		end

		if index > 4 then
			break
		end
		local nodeCreate = transNavGroup:GetChild(index - 1).gameObject
		nodeCreate:SetActive(true)
		local textNodeCreate = self:FindChildComponent(nodeCreate, "Text", "Text")
		if textNodeCreate then
			textNodeCreate.text = GetLanguageByID(data.NameID)
		end
		kToggle = nodeCreate:GetComponent("Toggle")
		if kToggle then
			local fun = function (bSelect)
				if bSelect then
					self.objTiGuan:SetActive(data.EmbattleType == EmBattleSchemeType.EBST_WheelWar)
					self.objTiBu:SetActive(data.EmbattleType == EmBattleSchemeType.EBST_Sub)
					self.objAssistTipsButton:SetActive(data.EmbattleType == EmBattleSchemeType.EBST_Help)
					if data.EmbattleType == EmBattleSchemeType.EBST_Sub then
						if self.setSubRoleTab ~= true then
							self.setSubRoleTab = true
							self:SelectEmbattleToggle(1,function()
								self:SetSelectGridColor(nil,false)
								self:UpdateEmbattleInfo(self.iCurToggleID,self.iCurRound)							
							end)
						end
					elseif self.iCurToggleID == data.BaseID and data.BaseID == EmBattleSchemeType.EBST_Normal then
						--从替补切换到助战 不清除显示
					else
						self:SelectEmbattleToggle(data.BaseID)
					end
					textNodeCreate.color = DRCSRef.Color(0xff/0xff, 0xff/0xff, 0xff/0xff);
				else
					if data.EmbattleType == EmBattleSchemeType.EBST_Sub then
						self.setSubRoleTab = false
						self:SetSelectGridColor(nil,false)
						self:UpdateEmbattleInfo(self.iCurToggleID,self.iCurRound)
					end
					textNodeCreate.color = DRCSRef.Color(0x2b/0xff, 0x2b/0xff, 0x2b/0xff);
				end
			end
			self:RemoveToggleClickListener(kToggle)
			self:AddToggleClickListener(kToggle, fun)
			-- 添加映射表
			self.schemeID2ToggleNode[data.BaseID] = nodeCreate
		end
	end

	if index <= iNodeConut then
		for i = index, iNodeConut do
			transNavGroup:GetChild(i - 1).gameObject:SetActive(false)
		end
	end
end

function RoleEmbattleUI:RefreshToggle()
	if self.iGameState == -1 then --平台布阵
		self.teamTog.isOn = true
		self.helpTog.isOn = false
	else  -- 剧本布阵
		local bShow = false;
		local firstToggle = nil
		local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
		for k, objToggle in pairs(self.schemeID2ToggleNode) do
			--车轮战的时候 不显示普通布阵
			local data = TB_EmbattleScheme[k]
			
			if self.bOpenByWheelWar then
				if data.EmbattleType == EmBattleSchemeType.EBST_WheelWar then
					bShow  = true
					objToggle:SetActive(true)
				else
					bShow  = false
					objToggle:SetActive(false)
				end
			elseif self.bOpenByFinalBattle or self.bOpenByHighTower then
				if data.EmbattleType == EmBattleSchemeType.EBST_Normal or data.EmbattleType == EmBattleSchemeType.EBST_Help then
					bShow  = true
					objToggle:SetActive(true)
				else
					bShow  = false
					objToggle:SetActive(false)
				end
			elseif self.auiShowEmbattleSchemeTypes then
				if self.auiShowEmbattleSchemeTypes[data.EmbattleType] then
					bShow = true
					objToggle:SetActive(true)
				else
					bShow = false
					objToggle:SetActive(false)
				end
			else
				bShow  = true
				objToggle:SetActive(true)
			end
			if (k == 2) then
				if (self.bShowWheelWar) then
					objToggle:SetActive(true)
				else
					objToggle:SetActive(false)
				end
			end
	
			kToggle = objToggle:GetComponent("Toggle")
			if kToggle then
				-- 显示选中第一个
				if not firstToggle and bShow then
					firstToggle = kToggle
					firstToggle.isOn = true
					self.iCurToggleID = data.BaseID
				else
					kToggle.isOn = false
				end
			end
		end
	end

	for k, v in ipairs(self.objWheelWarRoundToogle) do 
		v.isOn = k == self.iCurRound
	end
	self.objRoundNode.gameObject:SetActive(self.bOpenByWheelWar)
	-- 刷新Toggle文字
	self:UpdateToggleText()
end

function RoleEmbattleUI:DealAssistEmbattle()
	if self.iCurToggleID == EmBattleSchemeType.EBST_Help or
	self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
		return
	end

	local data = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
	if data then
		for i = 1,#data do
			self:DelAssistEmbattle(data[i].uiRoleID)
		end
	end

	for i=1,3 do
		local data = self.akRoleEmbattle[EmBattleSchemeType.EBST_WheelWar][i]
		if data then
			for j = 1,#data do
				self:DelAssistEmbattle(data[j].uiRoleID)
			end
		end
	end
end

--更新当前布阵信息
function RoleEmbattleUI:UpdateEmbattleInfo(iToggleID,iRound)
	if not self.akRoleEmbattle then return end
	if self.bNeedSendData then
		self:SendUpdateRoleEmbattleData()
	end

	if iToggleID ~= self.iCurToggleID then
		self.lastToggle = self.iCurToggleID
		self.lastRound = self.iCurRound
	end

	self.iCurToggleID = iToggleID
	self.iCurRound = iRound

	local bIsHelp = false;
	if self.iCurToggleID == EmBattleSchemeType.EBST_Help or
	self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
		bIsHelp = true;
	end

	local func_UpdateEmbattleInfo = function()
		for k,v in pairs(self.objGridRoleActors) do--回收之前的actor
			v:SetActive(false)
			table.insert(self.objFreeRoleActors,v)
		end
		self.objGridRoleActors = {}

		self:SetInitSelectSub()
	
		local bIsHelp = false;
		if self.iCurToggleID == EmBattleSchemeType.EBST_Help or 
		self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
			bIsHelp = true;
		end
		self:DealAssistEmbattle()
	
		local data = self.akRoleEmbattle[iToggleID][iRound]
		if data then
			if not bIsHelp then
				for i = 1, #data do
					self:SetGridActor(data[i].iGridX,data[i].iGridY,data[i].uiRoleID,bIsHelp,data[i].bPet)
				end
			end
		end
	
		--if not bIsHelp then
			local data = self:GetHelpData()
			if data then
				for i = 1,#data do 
					local gridY = SSD_BATTLE_GRID_HEIGHT + 1
					local gridX = i
					if i > 3 then
						gridY = gridY + 1
						gridX = gridX - 3
					end
					self:SetGridActor(gridX,gridY,data[i].uiRoleID,true,data[i].bPet)
				end
			end
		--end
	
		self:UpdateItemAll()
		self:UpdateWheelWarButton()
		self:UpdateToggleText()
	end
	func_UpdateEmbattleInfo()
	self.Tag = nil 
end

function RoleEmbattleUI:UpdateItemAll()
	if self.iCurToggleID == EmBattleSchemeType.EBST_Normal and self.setSubRoleTab then
		self.aiTeamRoleID = RoleDataManager:GetInstance():GetAllCanSubRoleList(self.curSelectEmbattleRole)
		if self.curSelectEmbattleRole > 0 then
			self.objSubRoleNullTips:SetActive(#self.aiTeamRoleID <= 0)
		end
	else
		self.aiTeamRoleID = self:GetTeamRoles()
		self.objSubRoleNullTips:SetActive(false)
		self:SortEmbattleRole()
	end
	self.comScrollRect:RefreshCells()
end

function RoleEmbattleUI:Anim_MoveEmbattle(bIsHelp)
	local timer = 0.5
	if bIsHelp then
		self.objActor_Node.transform:DOLocalMove(DRCSRef.Vec3(0,-260,-68), timer);
		self.objEmbattleRoot.transform:DOLocalMove(DRCSRef.Vec3(0,-260,-68), timer);
	else
		self.objEmbattleRoot.transform:DOLocalMove(DRCSRef.Vec3(0,-2,0), timer);
		self.objActor_Node.transform:DOLocalMove(DRCSRef.Vec3(0,-2,0), timer);
	end

	return timer
end

function RoleEmbattleUI:UpdateWheelWarButton()
	--更新车轮战按钮
	if self.bOpenByWheelWar then
		local image = self.objStartWheelWarButton:GetComponent("Image")
		local bSuccess = self:JudgeWheelWarCondition() == JudgeEnum.SUCCESS
		setUIGray(image,not bSuccess)
	end
end

function RoleEmbattleUI:isInBattleTeam(iRoleID)
	local embattleData = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
	if embattleData then
		for index, data in ipairs(embattleData) do
			if data.uiRoleID == iRoleID then
				return true
			end
		end
	end

	for i = 1, 3 do
		local embattleData = self.akRoleEmbattle[EmBattleSchemeType.EBST_WheelWar][i]
		if embattleData then
			for index, data in ipairs(embattleData) do
				if data.uiRoleID == iRoleID then
					return true
				end
			end
		end
	end

	return false
end

function RoleEmbattleUI:IsSubRole(iRoleID)
	local roleDataManagerInst =  RoleDataManager:GetInstance()
	local data = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
	for i = 1,#data do
		local roleData = roleDataManagerInst:GetRoleData(data[i].uiRoleID)
		if roleData and roleData.uiHasSubRole == 2 then
			local subRoleID = roleDataManagerInst:GetRoleID(roleData.uiSubRole)
			if iRoleID == subRoleID and roleDataManagerInst:IsRoleInTeam(subRoleID) then
				srcRoleID = data[i].uiRoleID
				return true
			end
		end
	end
	return false
end

function RoleEmbattleUI:isInTurnTeam(iRoleID)
	if self.iCurToggleID and self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
		for i=1,3 do
			--if i~=self.iCurRound then
				local embattleData = self.akRoleEmbattle[self.iCurToggleID][i]
				for index, data in ipairs(embattleData) do
					if data.uiRoleID == iRoleID then
						return true, i
					end
				end
			--end
		end
	end
	return false, 0
end

function RoleEmbattleUI:getCurSubRoleDesc(iRoleID)
	-- TODO 暂时这样
	if self.iGameState == -1 then
		return "";
    end

	local srcRoleID = 0
	local data = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
	for i = 1,#data do
		local roleData = RoleDataManager:GetInstance():GetRoleData(data[i].uiRoleID)
		if roleData and roleData.uiHasSubRole == 2  then
			local subRoleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiSubRole)
			if iRoleID == subRoleID then
				srcRoleID = data[i].uiRoleID
				break
			end
		end
	end

	if srcRoleID > 0 then
		return string.format( "<color=#80C5FF>替补</color>%s",RoleDataManager:GetInstance():GetRoleName(srcRoleID))
	end

	return ""
end

function RoleEmbattleUI:UpdateItem(transform,iIndex)
	local roleDataMgr = RoleDataManager:GetInstance()
	local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
	local schemeData = TB_EmbattleScheme[self.iCurToggleID]
	if not schemeData then return end
	local embattleData = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
	if not embattleData then
		return
	end
	local bIsHelpEmbattle = false;
	if schemeData.EmbattleType == EmBattleSchemeType.EBST_Help or
	schemeData.EmbattleType == EmBattleSchemeType.EBST_ArenaHelp then
		bIsHelpEmbattle = true;
	end
	local iRoleID = self.aiTeamRoleID[iIndex]
	if bIsHelpEmbattle then
		if iIndex > self.AssistTeammatesNums - 1 then
			self:UpdatePetItem(transform,iIndex - self.AssistTeammatesNums)
			return
		else 
			iRoleID = self.aiAssistTeamRoleID[iIndex + 1]
		end
	end

	if not iRoleID or iRoleID == 0 then
		transform.gameObject:SetActive(false)
		return
	end

	transform.gameObject:SetActive(true)
	
	-- 角色名称
	local nameText = self:FindChildComponent(transform.gameObject,"Name_Text","Text")
	local strName = ""
	local roledata =  roleDataMgr:GetRoleData(iRoleID)
	if self.iGameState == -1 then
		local strTitle = roleDataMgr:GetRoleTitleStr(iRoleID);
		strName = roleDataMgr:GetRoleName(iRoleID, true);
		if roledata.uiFragment == 1 then
			strName = roleDataMgr:GetMainRoleName();
		end
		if strTitle then
			strName = strTitle .. '·' .. strName;
		end
	else
		strName = roleDataMgr:GetRoleTitleAndName(iRoleID)
	end
	strName = getRankBasedText(roleDataMgr:GetRoleRank(iRoleID), strName)
	self.strRoleName[iRoleID] = strName
	nameText.text = strName
	if roledata then
		local LevelText = self:FindChildComponent(transform.gameObject,"Level_Text","Text")

		local uiLevel = roledata.uiLevel or roledata:GetLevel()
		if LevelText then
			LevelText.text = getRankBasedText(roleDataMgr:GetRoleRank(iRoleID),uiLevel.."级")
		end
	end
	-- 角色上场状态
	local stateText1 = self:FindChildComponent(transform.gameObject,"State_Text1","Text")
	local stateText2 = self:FindChildComponent(transform.gameObject,"State_Text2","Text")
	stateText1.gameObject:SetActive(not bIsHelpEmbattle)
	stateText2.gameObject:SetActive(bIsHelpEmbattle)
	local strState = ""
	local bInTeam = false  -- 在任意队中
	local bRest = false	-- 休息状态无法上阵 (大决战/千层塔/休整角色使用)
	local round2Word = {
		[1] = "第一场",
		[2] = "第二场",
		[3] = "第三场"
	}
	local bIsHelpRole = false
	-- 分析数据
	local InTurnTeam = false
	for index, data in ipairs(embattleData) do
		if data.uiRoleID == iRoleID then
			bInTeam = true
			if self.iCurToggleID == EmBattleSchemeType.EBST_Normal then
				strState = "上阵中"
			elseif self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
				strState = round2Word[self.iCurRound] or "未知场"
				InTurnTeam = true
			elseif self.iCurToggleID == EmBattleSchemeType.EBST_Help or
			self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
				strState = "助战中"
				bIsHelpRole = true
			elseif self.iCurToggleID == EmBattleSchemeType.EBST_Single or
			self.iCurToggleID == EmBattleSchemeType.EBST_Team then
				strState = "上阵中"
			end
			break
		end
	end

	-- 如果当前在助战布阵, 且角色在其他队, 那么也显示为 上阵中
	local isTurnTeam = false
	local atRound = 0
	if self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
		isTurnTeam, atRound = self:isInTurnTeam(iRoleID)
	end
	if self.iCurToggleID == EmBattleSchemeType.EBST_Help or self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
		if self:isInBattleTeam(iRoleID) then
			strState = "上阵中"
			bInTeam = true
		end
	else
		if not InTurnTeam and self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
			if isTurnTeam then
				strState = round2Word[atRound] or "未知场"
				bInTeam = true
			end
			InTurnTeam = isTurnTeam
		end

		if not InTurnTeam and strState == "" then
			local embattleData = self:GetHelpData()
			for index, data in ipairs(embattleData) do
				if data.uiRoleID == iRoleID then
					strState = "助战中"
					bInTeam = true
					bIsHelpRole = true
				end
			end
		end
	end

	-- 大决战/千层塔休息角色
	if self.bOpenByFinalBattle then
		if FinalBattleDataManager:GetInstance():CheckRestRole(iRoleID) then
			strState = "休息"
			bRest = true
			bInTeam = false
		end
	elseif self.bOpenByHighTower then
		if HighTowerDataManager:GetInstance():CheckRestRole(iRoleID) then
			strState = "休息"
			bRest = true
			bInTeam = false
		end
	end
	--如果不在队伍里 需要判断一下 在不在替补中 替补中 不允许布阵
	local bIsSubRole = false;
	if not bInTeam then
		bIsSubRole = self:IsSubRole(iRoleID)
		if bIsSubRole then
			strState = "替补中"
			bInTeam = bIsSubRole
		end

		if self.setSubRoleTab then
			bInTeam = bIsSubRole
		end
	end
	-- 处于休整状态的角色
	if EvolutionDataManager:GetInstance():GetOneEvolutionByType(iRoleID, NET_CANTBATTLE) then
		strState = "休息"
		bRest = true
		bInTeam = false
	end

	if bIsHelpEmbattle then
		if strState == "助战中" then
			stateText2.text = "<color=#FFA126>"..strState.."</color>"
		else
			stateText2.text = "<color=#6CD458>"..strState.."</color>"
		end
		
	else
		stateText1.text = strState
	end

	-- -- 助战天赋描述
	local descText = self:FindChildComponent(transform.gameObject,"Desc_Text","Text")
	descText.gameObject:SetActive(false)

	local comImageBtn = self:FindChildComponent(transform.gameObject,"Image","Button");
	local tips_callBack = function()
		if bIsHelpEmbattle then 
			local gift = GiftDataManager:GetInstance():isExistAssistGift(iRoleID)
			if gift then 
				local strTipsName = '助战'
				if strState == "助战中" then
					strTipsName = '下阵'
				end 
				local strContent = (GetLanguageByID(gift.NameID) or '') .. (GetLanguageByID(gift.DescID) or '')
				local tips = {
					['title'] =  strName,
					['content'] =  '助战效果\n ·'..strContent,
					['buttons'] = {
						{
							['name'] = strTipsName,  
							['func'] = function()
								self:SetAssistRole2Grid(iRoleID, bInTeam, 0,bIsHelpRole)
							end
						},
					}
				}
				OpenWindowImmediately("TipsPopUI",tips)
			end
		end
	end

	-- 节点选中状态
	local chooseImage = self:FindChild(transform.gameObject,"Choose_Image")
	if strState == "助战中" then
		stateText1.text = "<color=#FFA126>"..strState.."</color>"
		chooseImage.gameObject:SetActive(false)
	elseif bRest then
		stateText1.text = string.format("<color=%s>%s</color>", UI_COLOR_STR.red, strState)
		chooseImage.gameObject:SetActive(false)
	else
		stateText1.text = "<color=#6CD458>"..strState.."</color>"
		chooseImage.gameObject:SetActive(strState~="")
	end

	if self.iCurToggleID == EmBattleSchemeType.EBST_Help or
	self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
		if strState == "助战中" then
			chooseImage.gameObject:SetActive(true)
		else
			chooseImage.gameObject:SetActive(false)
		end
	end

	-- 角色头像
	local iRoleTypeID = roleDataMgr:GetRoleTypeID(iRoleID)
	local modelData = nil
	if self.iGameState == -1 then
		if roledata and roledata.uiFragment == 1 then
			modelData = TableDataManager:GetInstance():GetTableData("RoleModel", roledata.uiModelID);
		else
			modelData = roleDataMgr:GetRoleArtDataByTypeID(iRoleTypeID)
		end
	else
		modelData = roleDataMgr:GetRoleArtDataByTypeID(iRoleTypeID)
	end
	if (modelData) then
		local headImage = self:FindChildComponent(transform.gameObject,"head","Image")
		if headImage  then
			headImage.sprite = GetSprite(modelData.Head)
		end
	end
	
	if comImageBtn then
		self:RemoveButtonClickListener(comImageBtn);
		self:AddButtonClickListener(comImageBtn, function()
			if self.setSubRoleTab then
				if bInTeam  then
					if  bIsSubRole then
						self:OnPointDownItem(self.aiTeamRoleID[iIndex])
					else
						SystemUICall:GetInstance():Toast('该角色已上阵，无法设置为替补');
					end
				else
					self:OnPointDownItem(self.aiTeamRoleID[iIndex])
				end	
			elseif bIsHelpEmbattle then
				self:SetAssistRole2Grid(iRoleID, bInTeam, 0,bIsHelpRole)
			else
				--如果是上阵单位 则直接下阵 否则寻找一个位置上阵
				if bInTeam then
					local iCount = 0
					local kData = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
					if kData then
						iCount = #kData
					end
					if iCount > 1 then
						self:ResetRole(iRoleID)
					else
						SystemUICall:GetInstance():Toast("至少需要上阵一个角色")
					end	
				else
					local success = true

					-- 局内检查好感度
					if self.iGameState ~= -1 and roleDataMgr:GetDispotionDataToMainRole(iRoleID).iValue < 0 then 
						SystemUICall:GetInstance():Toast("对方不愿为你出战")
						success = false
					end
					if not self:canEmbattle(iRoleID) then
						SystemUICall:GetInstance():Toast("徒弟不允许上阵")
						success = false
					end

					if bRest then
						SystemUICall:GetInstance():Toast("角色休息无法上阵")
						success = false
					end

					if success and iRoleID ~= RoleDataManager:GetInstance():GetMainRoleID() then
						if self.bEvilEliminate == 1 then
							-- 必须要指定天赋才能上阵
							if not self:CheckRoleEnterEvilBattle(iRoleID) then
								SystemUICall:GetInstance():Toast("未使用三逆丹拒绝为你出战")
								success = false
							end
						elseif roleDataMgr:GetRoleClanID(iRoleID) == self.iCantChooseClan then
							SystemUICall:GetInstance():Toast("对方拒绝为你出战本门踢馆")
							success = false 
						end
					end

					if success then
						local iCount = 0
						local kData = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
						if kData then
							iCount = #kData
						end
						local iMaxCount = self:GetMaxTeamCout()
						if  iCount < iMaxCount then
							local x,y = roleDataMgr:AutoAddRole2EmbattleData(iRoleID,self.iCurToggleID,self.iCurRound);
							if x ~= 0 and  y ~= 0 then
								self:SetRole2Grid(x,y,iRoleID)

								-- TODO: 掌门对决，这里有个布阵BUG导致上阵不会update
								if PKManager:GetInstance():IsRunning() then
									self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
								end
							end
						else
							local str = string.format("最多允许%d人上阵",iMaxCount)
							SystemUICall:GetInstance():Toast(str)
						end
					end
				end
			end
		end);
	end


	local dragItem = self:FindChildComponent(transform.gameObject,"Button_Imag","DragItem")
	dragItem:ClearLuaFunction() --[todo] 关闭界面的时候 如果不清理这个 可能会导致内存泄露
	-- 助战界面不允许拖拽, 点击直接上阵, 其它布阵界面允许拖拽
	if bIsHelpEmbattle then
		dragItem:SetPointDownAction(function ()
			tips_callBack()
			-- self:SetAssistRole2Grid(iRoleID, bInTeam, 0)
		end)
	elseif not bRest then
		if not bInTeam or (self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar and atRound ~= self.iCurRound) then
			dragItem:SetDragAction(function (obj,inParent) 
				if IsValidObj(obj) then
					self:OnDrag(obj,inParent) 
				end
			end) 
			dragItem:SetEndDragAction(function (obj,inParent) 
				if inParent == false and bInTeam then

				else
					self:OnEndDrag(obj,inParent,bInTeam) 
				end
			
			end)
			dragItem:SetPointDownAction(function () 
				self:OnPointDownItem(self.aiTeamRoleID[iIndex])
			end)
		elseif self.setSubRoleTab then
			dragItem:SetPointDownAction(function () 
				if bInTeam  then
					if  bIsSubRole then
						self:OnPointDownItem(self.aiTeamRoleID[iIndex])
					else
						SystemUICall:GetInstance():Toast('该角色已上阵，无法设置为替补');
					end
				else
					self:OnPointDownItem(self.aiTeamRoleID[iIndex])
				end	
			end)
		end	
	end
	dragItem.linkTransform = self.comDragItemGrid.transform

	--观察功能 只有在平台布阵的时候需要
	if self.iGameState == -1 then
		local comWatchBtn = self:FindChildComponent(transform.gameObject,"Button_Watch","Button");
		if comWatchBtn then
			comWatchBtn.gameObject:SetActive(true)
			local _callBack = function()
				if self.iCurToggleID == EmBattleSchemeType.EBST_Team then
					self:OnClickWatchBtn(iRoleID);
				end
			end
			self:RemoveButtonClickListener(comWatchBtn);
			self:AddButtonClickListener(comWatchBtn, _callBack);
		end
	else
		local comWatchBtn = self:FindChildComponent(transform.gameObject,"Button_Watch","Button");
		if comWatchBtn then
			comWatchBtn.gameObject:SetActive(false)
		end
	end
end

function RoleEmbattleUI:OnClickWatchBtn(roleID)
	OpenWindowImmediately("ObserveUI", {['roleID'] = roleID})
	local _callback = function()
		local roleEmbattleUI = GetUIWindow('RoleEmbattleUI')
		if roleEmbattleUI then
			roleEmbattleUI.objActor_Node:SetActive(true)
		end
	end
	self.objActor_Node:SetActive(false)
	local observeUI = GetUIWindow('ObserveUI');
	if observeUI then
		observeUI:SetCallBack(_callback);
	end
end

function RoleEmbattleUI:UpdatePetItem(transform,iIndex)
	local petdata = self.aiPetdata[iIndex]
	if petdata == nil then
		transform.gameObject:SetActive(false)
		return
	end
	transform.gameObject:SetActive(true)

	local uiBaseID = petdata.uiBaseID
	local strState = ""

	local tb_petdata = TableDataManager:GetInstance():GetTableData("Pet",uiBaseID)
	if tb_petdata == nil then
		return
	end
	
	local embattleData = self:GetHelpData()
	for index, data in ipairs(embattleData) do
		if data.bPet > 0 and data.uiRoleID == uiBaseID then
			strState = "助战中"
		end
	end

	local nameText = self:FindChildComponent(transform.gameObject,"Name_Text","Text")
	local str_petname = GetLanguageByID(tb_petdata.NameID)
	if petdata.uiFragment and petdata.uiFragment > 0 then 
		str_petname = str_petname .. '+' ..  petdata.uiFragment
	end
	str_petname = getRankBasedText(tb_petdata.Rank, str_petname)
	self.strPetName[uiBaseID] = str_petname

	nameText.text = str_petname
	local nameLevel = self:FindChildComponent(transform.gameObject,"Level_Text","Text")
	nameLevel.text = ''

	local kModledata = TableDataManager:GetInstance():GetTableData("RoleModel", tb_petdata.ArtID)
	local headImage = self:FindChildComponent(transform.gameObject,"head","Image")
	if headImage and kModledata then
		local kPath = kModledata.Head or ""
		headImage.sprite = GetSprite(kPath)
	end

	-- 角色上场状态
	local stateText1 = self:FindChildComponent(transform.gameObject,"State_Text1","Text")
	local stateText2 = self:FindChildComponent(transform.gameObject,"State_Text2","Text")
	stateText1.gameObject:SetActive(false)
	stateText2.gameObject:SetActive(true)
	if strState == "助战中" then
		stateText2.text = "<color=#FFA126>"..strState.."</color>"
	else
		stateText2.text = "<color=#6CD458>"..strState.."</color>"
	end

	local chooseImage = self:FindChild(transform.gameObject,"Choose_Image")
	if strState == "助战中" then
		chooseImage.gameObject:SetActive(true)
	else
		chooseImage.gameObject:SetActive(false)
	end

	-- 助战天赋描述
	local descText = self:FindChildComponent(transform.gameObject,"Desc_Text","Text")
	-- descText.text = GetLanguageByID(tb_petdata.DescID)
	descText.gameObject:SetActive(false)

	local comImageBtn = self:FindChildComponent(transform.gameObject,"Image","Button");
	local tips_callBack = function()
		-- self:OnClickWatchBtn();
		local _str = CardsUpgradeDataManager:GetInstance():GetPetCardDesc(tb_petdata.BaseID,petdata.uiFragment)
		local content = '助战效果'
		for i,v in ipairs(_str or {}) do 
			if v and v.lock == false then 
				content = content ..'\n　·' ..(v.basedesc or "")
			end
		end 
		local strName = '助战'
		if strState == "助战中" then
			strName = '下阵'
		end 
		local tips = {
			['title'] =  str_petname,
			['content'] = content,
			['buttons'] = {
				{
					['name'] = strName,  
					['func'] = function()
						self:SetAssistRole2Grid(uiBaseID,false,1)
					end
				},
			}
		}
		OpenWindowImmediately("TipsPopUI",tips)
	end
	--点击背景 直接上阵或者下阵
	if comImageBtn then
		self:RemoveButtonClickListener(comImageBtn);
		self:AddButtonClickListener(comImageBtn, function()
			self:SetAssistRole2Grid(uiBaseID,false,1)
		end);
	end
	local button_Watch = self:FindChild(transform.gameObject,"Button_Watch");
	if button_Watch then
		button_Watch:SetActive(false)
	end
	--点击头像的话 显示tips
	local dragItem = self:FindChildComponent(transform.gameObject,"Button_Imag","DragItem")
	dragItem:ClearLuaFunction()
	dragItem:SetPointDownAction(function ()
		-- self:SetAssistRole2Grid(uiBaseID,false,1)
		tips_callBack()
	end)
end

function RoleEmbattleUI:RefreshItem(iRoleID)
	local iIndex = -1
	
	for k,v in pairs(self.aiTeamRoleID) do
		if v == iRoleID then
			iIndex = k
			break
		end
	end
	if iIndex ~= -1 then
		local obj = self:FindChild(self._gameObject,"ScrollRect_Image_BG/ScrollRect/Content/"..iIndex)
		if obj ~= nil then
			-- self.comScrollRect:RefillCells()
			self:SortEmbattleRole()
			self.comScrollRect:RefreshCells()
		end
	end
end

function RoleEmbattleUI:ShowChooseItem()
	self.comRole_Head_Embattle.gameObject:SetActive(true)
	self.bUpdateItemPos = true
end

function RoleEmbattleUI:HideChooseItem()
	self.comRole_Head_Embattle.gameObject:SetActive(false)
	self.bUpdateItemPos = false
end

function RoleEmbattleUI:ReSetSubConfig()
	self.OldSelectEmbattleRole = 0
	self.curSelectEmbattleRole = 0
	self.iSelectRoleID = nil
end

function RoleEmbattleUI:SelectEmbattleToggle(embattleTypeID,callback)
	if self.iCurToggleID == embattleTypeID then
		if callback then
			callback()
		end
		return
	end
	self.comScrollRect:ClearCells()
	local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
	local embattleTypeData = TB_EmbattleScheme[embattleTypeID]
	if not embattleTypeData then return	end
	
	local bIsHelp = false;
	if embattleTypeData.EmbattleType == EmBattleSchemeType.EBST_Help or
	embattleTypeData.EmbattleType == EmBattleSchemeType.EBST_ArenaHelp then
		bIsHelp = true;
	end
	self.iCurToggleID = embattleTypeID 
	local func_SelectEmbattleToggle = function()
		self:ReSetSubConfig()
		self:ShowPetList(bIsHelp)
		local bIsWheelWar = (embattleTypeData.EmbattleType == EmBattleSchemeType.EBST_WheelWar)
		local iCurRound = 1
		if bIsWheelWar then
			for k,v in ipairs(self.objWheelWarRoundToogle) do 
				if v.isOn == true then
					iCurRound = k
					break 
				end
			end
		end
	
		self:UpdateEmbattleInfo(self.iCurToggleID, iCurRound)	
	
		self.objRoundNode.gameObject:SetActive(bIsWheelWar)
		self.selectEmbattleTimer = 0
		if callback ~= nil then
			callback()
		end
	end
	
	if self.selectEmbattleTimer ~= 0 then
		self:RemoveTimer(self.selectEmbattleTimer)
	end
	local timer = self:Anim_MoveEmbattle(bIsHelp)
	self.selectEmbattleTimer =  self:AddTimer(timer * 1000 , func_SelectEmbattleToggle)
	self.Tag = "Move"

	if self.iCurToggleID and self.iCurToggleID ~= 0 then
		self:ResetAllRole(self.iCurToggleID,self.iCurRound)
	end
end

function RoleEmbattleUI:ResetAllRole(iToggleID,iRound)
	if not self.akRoleEmbattle then
		return
	end

	local dataList = self.akRoleEmbattle[iToggleID][iRound]
	if dataList ~= nil then
		for i = 1,#dataList do
			local data = dataList[i]
			self:FreeGridActor(data.iGridX,data.iGridY)
		end
	end

	if iToggleID ~= EmBattleSchemeType.EBST_Help then
		local dataList = self:GetHelpData()
		if dataList then
			for i = 1,#dataList do
				local data = dataList[i]
				self:FreeGridActor(data.iGridX,data.iGridY)
			end
		end
	end
end

function RoleEmbattleUI:SelectRoundToggle(iRoundIndex)
	self:UpdateEmbattleInfo(self.iCurToggleID,iRoundIndex)
end

function RoleEmbattleUI:OnPointDownItem(iRoleID)
	local roleDataMgr = RoleDataManager:GetInstance()
	if self.setSubRoleTab then
		--处理替补操作
		if iRoleID and iRoleID > 0 and self.curSelectEmbattleRole > 0  then
			SendSetEmBattleSubRoleCMD(self.curSelectEmbattleRole, iRoleID)
		end
		return
	end
	-- 局内才检查好感度
	if self.iGameState ~= -1 and roleDataMgr:GetDispotionDataToMainRole(iRoleID).iValue < 0 then 
		SystemUICall:GetInstance():Toast("对方不愿为你出战")
		return
	end

	if not self:canEmbattle(iRoleID) then
		SystemUICall:GetInstance():Toast("徒弟不允许上阵")
		return
	end

	if iRoleID ~= RoleDataManager:GetInstance():GetMainRoleID() then
		if self.bEvilEliminate == 1 then
			-- 必须要指定天赋才能上阵
			if not self:CheckRoleEnterEvilBattle(iRoleID) then
				SystemUICall:GetInstance():Toast("未使用三逆丹拒绝为你出战")
				return
			end
		elseif roleDataMgr:GetRoleClanID(iRoleID) == self.iCantChooseClan then
			SystemUICall:GetInstance():Toast("对方拒绝为你出战本门踢馆")
			return 
		end
	end
	self.iSelectRoleID = iRoleID
	local nodeHead = self.comRole_Head_Embattle.gameObject
	local iRoleTypeID = roleDataMgr:GetRoleTypeID(iRoleID)
	local kModledata = roleDataMgr:GetRoleArtDataByTypeID(iRoleTypeID)
	local headImage = self:FindChildComponent(nodeHead,"head","Image")
	if headImage and kModledata then
		local kPath = kModledata.Head or ""
		headImage.sprite = GetSprite(kPath)
	end
	self:ShowChooseItem()
end

function RoleEmbattleUI:AddSubList(uiRoleID)
	self.subList = self.subList or {}
	local iIndex = 1

	if self.subList[uiRoleID] then
		return self.subList[uiRoleID]
	end

	local iMaxSub = SSD_BATTLE_GRID_WIDTH * SSD_BATTLE_GRID_HEIGHT / 2
	for i = 1, iMaxSub do
		local bHas = false
		for k ,v in pairs(self.subList) do
			if v == i then
				bHas = true
				break
			end
		end
		if bHas == false then
			iIndex = i
			break
		end
	end
	self.subList[uiRoleID] = iIndex
	return iIndex
end

function RoleEmbattleUI:DelSubList(uiRoleID)
	if self.subList[uiRoleID] then
		local iIndex = self.subList[uiRoleID]
		self.subList[uiRoleID] = nil
		return iIndex
	end
	return 0
end

function RoleEmbattleUI:SetSubRoleShow(uiRoleID, bBattle)
	if bBattle then
		local canBattle = true
		local data = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
		for i = 1,#data do
			local roleData = RoleDataManager:GetInstance():GetRoleData(data[i].uiRoleID)
			if roleData then
				local subRoleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiSubRole)
				if uiRoleID == subRoleID then
					self:RemoveSubRole(data[i].uiRoleID)
					SendSetEmBattleSubRoleCMD(data[i].uiRoleID, 0)
					break
				end
			end
		end

		local embattleData = self:GetHelpData()
		for index, data in ipairs(embattleData) do
			local roleData = RoleDataManager:GetInstance():GetRoleData(data.uiRoleID)
			if roleData then
				local subRoleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiSubRole)
				if uiRoleID == subRoleID then
					self:RemoveSubRole(data.uiRoleID)
					SendSetEmBattleSubRoleCMD(data[index].uiRoleID, 0)
					break
				end
			end
		end
		
		if canBattle then
			if uiRoleID > 0 then
				local roleData = RoleDataManager:GetInstance():GetRoleData(uiRoleID)
				if roleData then
					if roleData.uiSubRole and roleData.uiSubRole > 0 then
						local subRoleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiSubRole)
						if subRoleID > 0 then
							local index = self:AddSubList(uiRoleID)
							local x = 0
							local y = index
							if index > 5 then
								x = -1
								y = index - 5
							end
							self:SetGridActor(x,y,subRoleID,false,nil,true)
						end
					end
				end
			end
		end
	else
		self:RemoveSubRole(uiRoleID)
		SendSetEmBattleSubRoleCMD(uiRoleID, 0)
	end
end

function RoleEmbattleUI:RemoveSubRole(uiRoleID)
	if uiRoleID > 0 then
		local iIndex = self:DelSubList(uiRoleID)
		if iIndex > 0 then
			iIndex = self.TotalBattleRole + iIndex
			if self.objGridRoleActors[iIndex] then
				local value = self.objGridRoleActors[iIndex]
				value:SetActive(false)
				table.insert(self.objFreeRoleActors,value)
				self.objGridRoleActors[iIndex] = nil
			end
			self:RefreshItem(uiRoleID)
		end
	end
end

function RoleEmbattleUI:SetGridActor(x,y,iRoleID,bHelp,bpet,bSub)
	local roleData = nil
	if bpet and bpet > 0 then
		bSub = true;
		roleData = TableDataManager:GetInstance():GetTableData("Pet",iRoleID)
	else
		roleData = RoleDataManager:GetInstance():GetRoleData(iRoleID);
	end

	if not roleData then
		return
	end

	local w = SSD_BATTLE_GRID_WIDTH / 2
	local iIndex = x + (y - 1) * w

	--替补站位
	if x <= 0 then
		iIndex = math.abs(x)*5 + y + self.TotalBattleRole
	end
	
	if self.objGridRoleActors[iIndex] == nil then
		if #self.objFreeRoleActors > 0 then
			self.objGridRoleActors[iIndex] = self.objFreeRoleActors[#self.objFreeRoleActors]
			table.remove(self.objFreeRoleActors)
		else
			self.objGridRoleActors[iIndex] = CloneObj(self.objCloneActor,self.objActor_Node)
		end
	end
	local objCurActor = self.objGridRoleActors[iIndex]
	if bpet and bpet > 0 then
		local diying = objCurActor:FindChild("duanyu_diying")
		if diying then 
			diying:SetActive(true)
		end
		local weapon = objCurActor:FindChild("weapon_Node")
		if weapon then 
			weapon:SetActive(false)
		end
		self.objGridRoleActors_Texture[iIndex] = self.SpineRoleUI:UpdateBaseSpine(objCurActor, roleData.ArtID, ROLE_SPINE_DEFAULT_ANIM)
	else
		self.SpineRoleUI:UpdateRoleSpine(objCurActor, iRoleID)
		local diying = objCurActor:FindChild("duanyu_diying")
		if diying then 
			diying:SetActive(false)
		end
		local weapon = objCurActor:FindChild("weapon_Node")
		if weapon then 
			weapon:SetActive(true)
		end
	end
	
	local lifeBar = self:FindChild(objCurActor,"LifeBarNode/Normal_LifeBar")
	lifeBar:SetActive(not bHelp)
	local nameObj = self:FindChild(objCurActor,"LifeBarNode/Name_Text")
	nameObj:SetActive(bHelp)
	local sName = RoleDataManager:GetInstance():GetRoleTitleAndName(iRoleID)
	local comCanvas = self:FindChildComponent(objCurActor.gameObject,"LifeBarNode","CanvasGroup")	

	if self.Tag and self.Tag == "Move" then
		comCanvas:DOFade(1,1)
		FadeInOutShaps(objCurActor.gameObject,1,true,0.5,1)
	else
		comCanvas:DOFade(1,0.1)
		FadeInOutShaps(objCurActor.gameObject,0.1,true,1,1)
	end

	if bHelp then
		local nameText = self:FindChildComponent(objCurActor,"LifeBarNode/Name_Text","Text")
		local sName = ""
		if bpet and bpet > 0 then
			if roleData then
				sName = GetLanguageByID(roleData.NameID)
			end
		else
			sName = RoleDataManager:GetInstance():GetRoleTitleAndName(iRoleID)
		end
		nameText.text = "<color='#6CD458'>" .. sName .. "</color>"
	else
		local sName = RoleDataManager:GetInstance():GetRoleTitleAndName(iRoleID)
		if self.iGameState == -1 then
			local strTitle = RoleDataManager:GetInstance():GetRoleTitleStr(iRoleID);
			if roleData  and roleData.uiFragment == 1 then
				sName = RoleDataManager:GetInstance():GetMainRoleName();
			else
				sName = RoleDataManager:GetInstance():GetRoleName(iRoleID, true);
			end
			if strTitle then
				sName = strTitle .. '·' .. sName;
			end
		end
		local nameText = self:FindChildComponent(objCurActor,"LifeBarNode/Normal_LifeBar/Name_Text","Text")
		local dbRoleData = TB_Role[roleData.uiTypeID]
		nameText.text = "<color='#6CD458'>" .. sName .. "</color>"
		local HPImage = self:FindChildComponent(objCurActor,"LifeBarNode/Normal_LifeBar/HP_Image","Image")	
		HPImage.fillAmount = 1
		local MPImage = self:FindChildComponent(objCurActor,"LifeBarNode/Normal_LifeBar/MP_Image","Image")	
		MPImage.fillAmount = 1
	end
	local position =  self.objGrids[iIndex]
	-- 修改order
	local skeletonRenderSeparator = objCurActor:GetComponent("SkeletonRenderSeparator")	
	local iCount = skeletonRenderSeparator.partsRenderers.Count - 1
	local baseDepth = 0
	local localScale = objCurActor.transform.localScale
	if bHelp then
		baseDepth = 10 - y
		objCurActor.transform.localScale = DRCSRef.Vec3(self.InitScale.x * localScale.x,self.InitScale.y * localScale.y ,self.InitScale.z);
		-- objCurActor.transform.position =-- position
		-- DRCSRef.Vec3(position.x ,position.y + 1,position.z);

		if self.iCurToggleID == EmBattleSchemeType.EBST_Help or self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
			objCurActor.transform.position =  DRCSRef.Vec3(position.x - EMBATTLE_OFFSET_X ,position.y - EMBATTLE_OFFSET_Y,position.z - EMBATTLE_OFFSET_Z);
		else
			objCurActor.transform.position = position
		end

	else
		if bSub then
			baseDepth = y
		else
			baseDepth = GetDepthByGridPos(x, y)
		end
		objCurActor.transform.localScale = DRCSRef.Vec3(self.InitScale.x * localScale.x,self.InitScale.y * localScale.y,self.InitScale.z);
		objCurActor.transform.position = position
	end

	if not self.uiLayerPrder then
		self.uiLayerPrder = UI_UILayer:GetComponent("Canvas").sortingOrder or 0
	end
	baseDepth = self.uiLayerPrder + baseDepth + 300
	objCurActor:GetComponent("MeshRenderer").sortingOrder = baseDepth
	local nameTextCanvas = self:FindChildComponent(objCurActor,"LifeBarNode","Canvas")	
	if nameTextCanvas then 
		nameTextCanvas.sortingOrder = baseDepth + 1
	end
    for i =0,iCount do
        skeletonRenderSeparator.partsRenderers[i].MeshRenderer.sortingOrder = baseDepth + i     
	end
	
	if self.iCurToggleID ~= EmBattleSchemeType.EBST_WheelWar and not bSub then
		self:SetSubRoleShow(iRoleID,true)
	end
end

function RoleEmbattleUI:FreeGridActor(x,y)
	if x == nil or y == nil then
		return
	end
	local w = SSD_BATTLE_GRID_WIDTH / 2
	local iIndex = x + (y - 1) * w
	if self.objGridRoleActors[iIndex] then
		local value = self.objGridRoleActors[iIndex]
		local fadetime = 0.5

		local lifeBar = self:FindChild(value.gameObject,"LifeBarNode/Normal_LifeBar")
		local nameObj = self:FindChild(value.gameObject,"LifeBarNode/Name_Text")
		local comCanvas = self:FindChildComponent(value.gameObject,"LifeBarNode","CanvasGroup")	
		if self.Tag and self.Tag == "Move" then
			comCanvas:DOFade(0,fadetime)
			FadeInOutShaps(value.gameObject,fadetime,true)
		else
			comCanvas:DOFade(0,0.1)
			FadeInOutShaps(value.gameObject,0.1,true,0.1,0)
		end

		local weapon = value.gameObject:FindChild("weapon_Node")
		if weapon then 
			local boneFollower = weapon.gameObject:GetComponent("BoneFollower")   
			if boneFollower then 
				boneFollower.boneName = ""
			end
			weapon:SetActive(false)
		end

		table.insert(self.objFreeRoleActors,value)
		self.objGridRoleActors[iIndex] = nil
	end
end

function RoleEmbattleUI:GetGridRoleID(x,y)
	local data = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
	if data then
		for i = 1,#data do 
			if data[i].iGridX == x and data[i].iGridY == y then
				return  data[i].uiRoleID,i
			end
		end
	end
	return  nil
end

function RoleEmbattleUI:GetInEmbattleType(iRoleID,iRound)
	if iRound == nil then
		iRound = self.iCurRound
	end
	local data = self.akRoleEmbattle[self.iCurToggleID][iRound]
	for i = 1,#data do 
		if data[i].bPet == 0 and data[i].uiRoleID == iRoleID then
			return  data[i].eFlag,i
		end
	end
	return  INVALID,nil
end

function RoleEmbattleUI:DelAssistEmbattle(iRoleID)
	if self.iCurToggleID == EmBattleSchemeType.EBST_Help or
	self.iCurToggleID == EmBattleSchemeType.EBST_ArenaHelp then
		return
	end

	local embattleData = self:GetHelpData()
	for index, data in ipairs(embattleData) do
		if data.uiRoleID == iRoleID then
			table.remove(embattleData,index)
			break
		end
	end
end

--获取上阵最大人数
function RoleEmbattleUI:GetMaxTeamCout()
	local iMaxCount = 5;
	if self.iGameState == -1 then
		if self.iCurToggleID == EmBattleSchemeType.EBST_Single then
			iMaxCount = 1;
		elseif self.iCurToggleID == EmBattleSchemeType.EBST_Team then
			iMaxCount = 5;
		end
	else
		iMaxCount = RoleDataManager:GetInstance():GetCanEmbattleCount()
	end
	return iMaxCount
end

function RoleEmbattleUI:SetRole2Grid(x,y,iRoleID)
	--车轮战 允许拖动不同场次的单位 所以先把之前场次的单位下场
	if self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
		local bInTurn,iCurRound = self:isInTurnTeam(iRoleID)
		if bInTurn then
			self:ResetRole(iRoleID,iCurRound,false)
			--车轮战的 所有轮次 是存在一个地方，所以下阵的人 需要先告诉服务器 否则没法替换
			self:SendUpdateRoleEmbattleData()
		end
	end

	local gridRoleID,iOldIndex = self:GetGridRoleID(x,y)
	if gridRoleID == nil then--上阵
		local iCount = 0
		local kData = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
		if kData then
			iCount= #kData
		end
		local iMaxCount = self:GetMaxTeamCout()
		if  iCount < iMaxCount then
			local eType,iIndex =  self:GetInEmbattleType(iRoleID)
			if eType == IN_TEAM then
				self:ResetRole(iRoleID)
			end

			local roleEmbattle = RoleDataManager:GetInstance():CreatRoleEmbattleData(iRoleID,self.iCurToggleID,self.iCurRound,x,y,IN_TEAM,0)
			table.insert(self.akRoleEmbattle[self.iCurToggleID][self.iCurRound],roleEmbattle)

			--处理一下助战UI
			self:DelAssistEmbattle(iRoleID)

			self:SetGridActor(x,y,iRoleID)
			self:RefreshItem(iRoleID)
			self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
		elseif iCount == iMaxCount then
			local eType,iIndex =  self:GetInEmbattleType(iRoleID)
			if eType == IN_TEAM then
				self:ResetRole(iRoleID)
				local roleEmbattle = RoleDataManager:GetInstance():CreatRoleEmbattleData(iRoleID,self.iCurToggleID,self.iCurRound,x,y,IN_TEAM,0)
				table.insert(self.akRoleEmbattle[self.iCurToggleID][self.iCurRound],roleEmbattle)		
				self:SetGridActor(x,y,iRoleID)
				self:RefreshItem(iRoleID)
				self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
			else
				local str = string.format("最多允许%d人上阵",iMaxCount)
				SystemUICall:GetInstance():Toast(str)
			end
		else
			local str = string.format("最多允许%d人上阵",iMaxCount)
			SystemUICall:GetInstance():Toast(str)
		end
	elseif gridRoleID ~= iRoleID then
		--原来位置上有单位了， 如果我之前没有上阵 则替换掉他(他如果可以替补 则去替补 可以助战则助战)。如果我上阵了 则互相交换位置
		self:DelAssistEmbattle(iRoleID)
		local eType,iIndex =  self:GetInEmbattleType(iRoleID)
		if eType == INVALID then
			self.akRoleEmbattle[self.iCurToggleID][self.iCurRound][iOldIndex].uiRoleID = iRoleID		
			self:SetGridActor(x,y,iRoleID)
			self:RefreshItem(iRoleID)
			self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
		elseif eType == IN_TEAM then
			local data = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound][iOldIndex]
			data.uiRoleID = iRoleID
			self:SetGridActor(data.iGridX,data.iGridY,iRoleID)
			data = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound][iIndex]
			data.uiRoleID = gridRoleID
			self:SetGridActor(data.iGridX,data.iGridY,gridRoleID)
			self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
		end
	end
	-- 更新角色列表状态
	self:UpdateEmbattleInfo(self.iCurToggleID, self.iCurRound)
end

-- 添加助战成员
function RoleEmbattleUI:SetAssistRole2Grid(iRoleID, bInTeam, bPet ,bIsHelpRole)
	-- 如果该成员已经在其他场中上阵, 那么不允许助战
	if bInTeam == true then
		self:ResetRole(iRoleID)
		self:UpdateEmbattleInfo(self.iCurToggleID, self.iCurRound)
		if not bIsHelpRole then
			SystemUICall:GetInstance():Toast("已上阵成员无法助战")
		end
		return
	end
	
	local freePos = nil
	local bAlreadyInTeam = false
    local gridRoleID,iOldIndex = nil, nil
    for index, pos in ipairs(ASSISTCOMBATPOS) do
        gridRoleID, iOldIndex = self:GetGridRoleID(pos.x, pos.y)
        if (gridRoleID == nil) and (not freePos) then
            freePos = pos
		elseif gridRoleID == iRoleID then
			bAlreadyInTeam = true
			break
		end
	end

	if bAlreadyInTeam then
		if bPet and bPet > 0 then
			self:ResetPet(iRoleID)
		else
			self:ResetRole(iRoleID)
		end
		self:UpdateEmbattleInfo(self.iCurToggleID, self.iCurRound)
		return
	end
	
    if not freePos then
        SystemUICall:GetInstance():Toast("助战成员已达上限")
        return
	end
	
	if bPet and bPet > 0 then
		local roleEmbattle = RoleDataManager:GetInstance():CreatRoleEmbattleData(iRoleID,self.iCurToggleID,self.iCurRound,freePos.x, freePos.y,INVALID,1)
		table.insert(self.akRoleEmbattle[self.iCurToggleID][self.iCurRound],roleEmbattle)
		self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
		self:SetGridActor(freePos.x, freePos.y, iRoleID, true, 1)
		self:UpdateEmbattleInfo(self.iCurToggleID, self.iCurRound)
	else
		self:SetRole2Grid(freePos.x, freePos.y, iRoleID)
	end
end

function RoleEmbattleUI:ResetPet(typeid)
	local embattleData = self:GetHelpData()
	for index, data in ipairs(embattleData) do
		if data.bPet > 0 and data.uiRoleID == typeid then
			self:SetUpdateFlag(self.iCurToggleID,self.iCurRound)
			self:FreeGridActor(data.iGridX,data.iGridY)
			table.remove(embattleData,index)
			break
		end
	end
	self:UpdateEmbattleInfo(self.iCurToggleID, self.iCurRound)
end

function RoleEmbattleUI:ResetRole(iRoleID,iRound,bFreeGridActor)
	if iRound == nil then
		iRound = self.iCurRound
	end
	local eType,iIndex =  self:GetInEmbattleType(iRoleID,iRound)
	if iIndex ~= nil then
		local data = self.akRoleEmbattle[self.iCurToggleID][iRound][iIndex]
		table.remove(self.akRoleEmbattle[self.iCurToggleID][iRound],iIndex)
		self:SetUpdateFlag(self.iCurToggleID,iRound)
		if bFreeGridActor == nil or bFreeGridActor == true then
			self:FreeGridActor(data.iGridX,data.iGridY)
		end
		self:RefreshItem(iRoleID)
		--self:SetSubRoleShow(iRoleID,false)
		
		-- 重置角色之后, 更新Toggle的文字
		self:UpdateToggleText()
	end
end

function RoleEmbattleUI:UpdateToggleText()
	if not self.schemeID2ToggleNode then return end
	local schemeTypeID = nil
	local strSchemeName = nil
	local nodeToggle = nil
	local comTextToggle = nil
	local curNum = 0
	local maxNum = RoleDataManager:GetInstance():GetCanEmbattleCount() or 0
	-- 助战按钮显示当前助战人数
	local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
	for index, data in pairs(TB_EmbattleScheme) do
		curNum = 0
		schemeTypeID = data.BaseID
		nodeToggle = self.schemeID2ToggleNode[schemeTypeID]
		if data.EmbattleType == EmBattleSchemeType.EBST_Help then
			if nodeToggle then
				strSchemeName = GetLanguageByID(data.NameID)
				if self.akRoleEmbattle and self.akRoleEmbattle[schemeTypeID] then
					curNum = self.akRoleEmbattle[schemeTypeID][1] and #self.akRoleEmbattle[schemeTypeID][1] or 0
				end
				comTextToggle = self:FindChildComponent(nodeToggle, "Text", "Text")
				-- TODO 助战现在只允许5个人
				comTextToggle.text = string.format("%s(%d/%d)", strSchemeName, curNum, 5)
			end
		end
	end
	-- 如果当前是车轮战布阵, 则刷新顶部toggle文字
	local curScheme = TB_EmbattleScheme[self.iCurToggleID]
	if self.akRoleEmbattle and self.akRoleEmbattle[self.iCurToggleID] and (curScheme.EmbattleType == EmBattleSchemeType.EBST_WheelWar) then
		local mateData = self.akRoleEmbattle[self.iCurToggleID]

		local kShowText = {"第一场","第二场","第三场"} --[todo]后面需要放到语言表里
		for i=1,3 do
			self:FindChild(self.objRoundNode, string.format("Toggle_Round%d",i)):SetActive(false)
		end
		for i=1,self.iAllRoundNum do
			self:FindChild(self.objRoundNode, string.format("Toggle_Round%d",i)):SetActive(true)
			local sPath = string.format("Toggle_Round%d/Lable_Text",i)
			local sPath2 = string.format("Toggle_Round%d/Num_Text",i)
			local roundText = self:FindChildComponent(self.objRoundNode, sPath, "Text")
			local numText = self:FindChildComponent(self.objRoundNode, sPath2, "Text")
			local curNum = mateData[i] and #mateData[i] or 0
			local sNum = ""
			if curNum < 1 then
				sNum = string.format("<color=#891a00>(%d/%d)</color>",curNum, maxNum)
			else
				sNum = string.format("(%d/%d)",curNum, maxNum)
			end
			--[[
			if self.iCurRound == i then
				roundText.color = UI_COLOR['white']
			else
				roundText.color = UI_COLOR['black']
			end
			--]]
			
			roundText.text = kShowText[i]
			numText.text = sNum
		end
	end

	--
	if self.iGameState == -1 and curScheme.EmbattleType == EmBattleSchemeType.EBST_ArenaHelp then
		local curNum = 0;
		if self.akRoleEmbattle[curScheme.EmbattleType][1] then
			curNum = #self.akRoleEmbattle[curScheme.EmbattleType][1];
		end
		local comTextToggle = self:FindChildComponent(self.helpTog.gameObject, "Text", "Text");
		comTextToggle.text = string.format("助战(%d/%d)", curNum, 5);
	end
end

function RoleEmbattleUI:canEmbattle(roleID)
	if not roleID then
		return true
	end

	local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByID(roleID);
	if roleData and roleData.BabyTemplate == TBoolean.BOOL_YES then
		return false
	end
	if RoleDataManager:GetInstance():IsBabyRoleType(roleID) then
		return false 
	end 
	return true
end

function RoleEmbattleUI:OnDrag(obj,bInParent)
	if self.setSubRoleTab then
		self.iSelectRoleID = nil
		return
	end
	if not self:IsActive() then
		return
	end
	self:SetSelectGridColor(obj,false)
	if bInParent then
		if obj ~= self.objTiBuBG and self.objZhuZhenBG ~= obj then
			if not self.iSelectRoleID then
				local name = tonumber(obj.name) 
				local w = SSD_BATTLE_GRID_WIDTH / 2
				local f = math.floor((name - 1) / w)
				local x = name - f * w
				local y = f + 1
				self.iSelectRoleID = self:GetGridRoleID(x,y)
			end
			if not self:canEmbattle(self.iSelectRoleID) then
				return
			end
			if self.iSelectRoleID then
				self:SetSelectGridColor(obj,true)
			end
		end
	end
end

function RoleEmbattleUI:OnBeginDrag(obj,bInParent)
	if self.setSubRoleTab then
		self.iSelectRoleID = nil
		self:OnClickDownGrid(obj,bInParent)
		return
	end
	if not self:IsActive() then
		return
	end


	local name = tonumber(obj.name) 
	if name and name >=1 and name <= 20 then
		local w = SSD_BATTLE_GRID_WIDTH / 2
		local f = math.floor((name - 1) / w)
		local x = name - f * w
		local y = f + 1
		if not self.iSelectRoleID then
			self.iSelectRoleID = self:GetGridRoleID(x,y)
		end
		self:SetSelectGridColor(obj,false)
		if not self:canEmbattle(self.iSelectRoleID) then
			return
		end
		if self.iSelectRoleID then
			self:OnPointDownItem(self.iSelectRoleID)
			self:SetSelectGridColor(obj,true)
		end
	end
end

function RoleEmbattleUI:OnEndDrag(obj,bInParent,bInTeam)
	if self.setSubRoleTab then
		self.iSelectRoleID = nil
		return
	end
	if not self:IsActive() then
		return
	end
	
	if not self:canEmbattle(self.iSelectRoleID) then
		self:SetSelectGridColor(obj,false)
		SystemUICall:GetInstance():Toast("徒弟不允许上阵")
		return
	end

	if bInParent then
		--拖拽到 替补 或者 助战 上, 不做反应
		if (self.objTiBuBG == obj) or (self.objZhuZhenBG == obj) then 
			-- pass
		elseif self.iSelectRoleID ~= nil then
			local name = tonumber(obj.name) 
			if name then
				local w = SSD_BATTLE_GRID_WIDTH / 2
				local f = math.floor((name - 1) / w)
				local x = name - f * w
				local y = f + 1
				self:SetRole2Grid(x,y,self.iSelectRoleID)
			end
		end
	else
		local eType,iIndex =  self:GetInEmbattleType(self.iSelectRoleID)
		if eType == INVALID then

		else
			--判断能否替补 助阵
			local bInSub = false
			local bInAssist = false
			local iCount = #self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
			if bInSub then
			
			elseif bInAssist then
			
			else
				if iCount > 1  or self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
					self:ResetRole(self.iSelectRoleID)
					self:UpdateEmbattleInfo(self.iCurToggleID,self.iCurRound)
					self:UpdateWheelWarButton()
				else
					SystemUICall:GetInstance():Toast("至少需要上阵一个角色")
				end	
			end
		end
	end
	self:HideChooseItem()
	self:SetSelectGridColor(obj,false)
	self.iSelectRoleID = nil
end

function RoleEmbattleUI:OnClickDownGrid(obj,bInParent)
	local name = tonumber(obj.name)
	if name then
		local w = SSD_BATTLE_GRID_WIDTH / 2
		local f = math.floor((name - 1) / w)
		local x = name - f * w
		local y = f + 1
		local gridRoleID,iOldIndex = self:GetGridRoleID(x,y)
		if not gridRoleID then
			return
		end
		self.OldSelectEmbattleRole = self.curSelectEmbattleRole
		self.curSelectEmbattleRole = gridRoleID
		if self.setSubRoleTab then
			self.objSubRoleTips:SetActive(false)
			self.objSubRoleNullTips:SetActive(false)		
		end
		self:SetSelectGridColor(obj,true)
		self:UpdateItemAll()
	end
end

function RoleEmbattleUI:SetInitSelectSub()
	if self.curSelectEmbattleRole > -1 then
		self.objSubRoleTips:SetActive(false)
		if self.setSubRoleTab then
			self.objSubRoleNullTips:SetActive(true)
			local data = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
			for i = 1,#data do
				local roleData = RoleDataManager:GetInstance():GetRoleData(data[i].uiRoleID)
				if roleData then
					local aiTeamRoleID = RoleDataManager:GetInstance():GetAllCanSubRoleList(data[i].uiRoleID)
					if #aiTeamRoleID > 0 then
						self.curSelectEmbattleRole = data[i].uiRoleID
						local w = SSD_BATTLE_GRID_WIDTH / 2
						local iIndex = math.floor(data[i].iGridX + (data[i].iGridY - 1) * w)
						local obj = self:FindChild(self.comDragItemGrid.gameObject,iIndex)
						if IsValidObj(obj) then
							self:SetSelectGridColor(obj,true)
						end
						self.objSubRoleNullTips:SetActive(false)
						return
					end
				end
			end
			--啥都没有 给个默认的
			if data[1] then
				self.curSelectEmbattleRole = data[1].uiRoleID
				local w = SSD_BATTLE_GRID_WIDTH / 2
				local iIndex = math.floor(data[1].iGridX + (data[1].iGridY - 1) * w)
				local obj = self:FindChild(self.comDragItemGrid.gameObject,iIndex)
				if IsValidObj(obj) then
					self:SetSelectGridColor(obj,true)
				end
			end
		end
	else
		self.objSubRoleTips:SetActive(self.setSubRoleTab == true)
		self.objSubRoleNullTips:SetActive(false)
	end
end

function RoleEmbattleUI:SetSelectGridColor(obj, bShow)
	if bShow then
		if IsValidObj(obj) then
			local name = tonumber(obj.name)
			if name then
				self.objGrids_choose:SetActive(true)
				self.objGrids_choose.transform.position = self.objGrids[name]
			end
	
			if self.setSubRoleTab then
				self.objGrids_chooseImage.color = UI_COLOR['red']
			else
				self.objGrids_chooseImage.color = UI_COLOR['green']
			end
		else
			derror("SetSelectGridColor obj is nil")
		end
	else
		self.objGrids_choose:SetActive(false)
	end
end

function RoleEmbattleUI:CloseUI()
	self:ReSetSubConfig()
	self.objActor_Node:SetActive(false)
	self:CheckCommonEmbattleCancel()
	--注意:移除界面后 界面所有self里存的东西都没法用了！
	RemoveWindowImmediately("RoleEmbattleUI")
	local characterUI = GetUIWindow("CharacterUI")
    if characterUI then 
        characterUI:SetRoleSpineShow(true)
	end
end

function RoleEmbattleUI:SetUpdateFlag(iID,iRound)
	self.bNeedSendData = true
	if self.aiUpdateRound[iID] == nil then
		self.aiUpdateRound[iID] = {}
	end
	self.aiUpdateRound[iID][iRound] = iRound
end

function RoleEmbattleUI:CheckArenaPetsSafe()
	-- 更换宠物后从新布阵错误
	self.akRoleEmbattle = self.akRoleEmbattle or RoleDataManager:GetInstance():GetRoleEmbattleInfo()
	local pets = CardsUpgradeDataManager:GetInstance():GetPets();
	local arenaHelp = self.akRoleEmbattle[EmBattleSchemeType.EBST_ArenaHelp][1];
	for i = 1, #(arenaHelp) do
		for j = 1, #(pets) do
			if arenaHelp[i].uiRoleID ~= pets[j].uiBaseID and arenaHelp[i].uiRoleID == pets[j].uiRootID then
				arenaHelp[i].uiRoleID = pets[j].uiBaseID;
				self.bNeedSendData = true
			end
		end
	end
end

function RoleEmbattleUI:OnDisable()
    if self.bigMap then
        self.bigMap.wait_event = nil
		ShowAllHUD()
    end

	self:RemoveEventListener('ONEVENT_REF_PLATETEAM');

	if self.bNeedSendData then
		self:SendUpdateRoleEmbattleData()
	end

	self:RemoveEventListener("UPDATE_EMBATTLE")
	self:RemoveEventListener("UPDATE_MAIN_ROLE_SUBROLEINFO")
	self:SetSelectGridColor(nil,false)
end

function RoleEmbattleUI:OnEnable()
    if self.bigMap then
        self.bigMap.wait_event = 1
		HideAllHUD()
    end

	self.comScrollRect:AddListener(function(...) self:UpdateItem(...) end)

    self:AddEventListener('ONEVENT_REF_PLATETEAM', function(info)
		self:RefreshUI();
    end);

	self:AddEventListener("UPDATE_EMBATTLE", function(data)
		self.akRoleEmbattle = RoleDataManager:GetInstance():GetRoleEmbattleInfo()
		self:CheckArenaPetsSafe()
		self:UpdateEmbattleInfo(data.ToggleID or 1, data.Round or 1)
	end)
	
	self:AddEventListener("UPDATE_MAIN_ROLE_SUBROLEINFO",function(data)
		local roleID = data[1]
		local uiSubRole = data[2] or 0
		local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
		if roleData then
			--之前是替补 ，现在去掉了
			if roleData.uiHasSubRole == 1 and uiSubRole ~= 0 then
				self:RemoveSubRole(roleID)
			--换了个替补 或者 从没替补变成了有替补
			elseif roleData.uiHasSubRole == 2 then
				self:SetSubRoleShow(roleID,true)
			end
		end

		self:SortEmbattleRole()
		self.comScrollRect:RefillCells()
		self:UpdateItemAll()
	end)
end

function RoleEmbattleUI:SortEmbattleRole()
	self.aiTeamRoleID = self:GetTeamRoles()
end


function RoleEmbattleUI:OnDestroy()
	self.SpineRoleUI:Close()
end

function RoleEmbattleUI:SetType(type)
	self.type = type;
end

function RoleEmbattleUI:OnRefUIByPlayerSetting()
	if not self.type then
		self.type = Type.SCRIPT_BATTLE;
	end

	local _func = function(bIsActive)
		self.objBottom:SetActive(bIsActive);
		self.objTiBuBG:SetActive(bIsActive);
		self.ImgScriptBG:SetActive(bIsActive);

		self.objArena:SetActive(not bIsActive);
		self.objTown:SetActive(not bIsActive);
		--self.objImageBG:SetActive(not bIsActive);
		self.ImgTownBG:SetActive(not bIsActive);
	end

    local rect = self.objSCImageBG:GetComponent('RectTransform');

	if self.type == Type.SCRIPT_BATTLE then
		_func(true);
		-- rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, 570);
		
	elseif self.type == Type.TOWN_BATTLE then
		_func(false);
	-- 	rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, 570);
	end 

	--
	if self.type == Type.TOWN_BATTLE then
		self.singleTog:GetComponent('Toggle').isOn = true;
		if not globalDataPool:getData('PlatTeamInfo') then
			SendQueryPlatTeamInfo(SPTQT_PLAT, 0);
		else
			self:RefreshUI();
		end
	end
end

function RoleEmbattleUI:OnClickSingleTog()
	self.bIsSingle = true;
	self:SelectEmbattleToggle(EmBattleSchemeType.EBST_Single);
end

function RoleEmbattleUI:OnClickTeamTog()
	self.bIsSingle = false;
	self:SelectEmbattleToggle(EmBattleSchemeType.EBST_Team);
end

function RoleEmbattleUI:OnClickHelpTog()
	self.bIsSingle = true;
	self:SelectEmbattleToggle(EmBattleSchemeType.EBST_ArenaHelp);
end

function RoleEmbattleUI:OnClickCopyTeamBtn()
	self.objActor_Node:SetActive(false);
	local _callBack = function()
		self.objActor_Node:SetActive(true);
	end

    OpenWindowImmediately('RoleTeamOutUI');
	local roleTeamOutUI = GetUIWindow("RoleTeamOutUI")
    roleTeamOutUI:SetCallBack(_callBack);
end

function RoleEmbattleUI:OnClickCloseBtn()
	if self.iGameState == -1 then
		local appearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo();
		local team = self.akRoleEmbattle[EmBattleSchemeType.EBST_Team][1];
		local bHas = false;
		if not self.bNeedSetMainRole then
			for i = 1, #(team) do
				if team[i].uiRoleID == appearanceInfo.showRoleID then
					bHas = true;
					break;
				end
			end
		end
		if not bHas then
			if team and next(team) then
				SendModifyPlayerAppearance(SMPAT_SHOWROLE, tostring(team[1].uiRoleID));
				PlayerSetDataManager:GetInstance():SetShowRoleID(team[1].uiRoleID);
			end
		end
		self.bNeedSetMainRole = false;
	end

	if self.callback then
		self.callback();
	end

	if CHANGE_TEAM_BATTLE then
		CHANGE_TEAM_BATTLE = false;
		self:MenPaiSingn();
		SystemUICall:GetInstance():Toast('已更新酒馆切磋和擂台阵容!');
    end

	RemoveWindowImmediately('RoleEmbattleUI')
end

function RoleEmbattleUI:MenPaiSingn()
    local matchData = ArenaDataManager:GetInstance():GetMatchData();
    if not matchData or not next(matchData) then
        SendRequestArenaMatchOperate(ARENA_REQUEST_MATCH);
    else
        ArenaDataManager:GetInstance():MenPaiUpdateData();
    end
end

function RoleEmbattleUI:SetCallBack(callback)
	self.callback = callback;
end

function RoleEmbattleUI:GetHelpData()
	if self.iGameState == -1 then
		return self.akRoleEmbattle[EmBattleSchemeType.EBST_ArenaHelp][1]
	else
		return self.akRoleEmbattle[EmBattleSchemeType.EBST_Help][1]
	end
end

function RoleEmbattleUI:GetTeamRoles()
	local kRoleDataManager = RoleDataManager:GetInstance()
	local info = nil;
	local auiTeamList = nil
	if self.iGameState == -1 then
		auiTeamList = kRoleDataManager:GetRoleTeammates(false, false);
	else
		info = globalDataPool:getData("MainRoleInfo")
		auiTeamList = info["Teammates"] or info["auiTeammates"]
	end
	auiTeamList = clone(auiTeamList)
	local mainRoleID = 0
	local sort = function(roleID1,roleID2)
        local roledata1 = kRoleDataManager:GetRoleData(roleID1)
        local roledata2 = kRoleDataManager:GetRoleData(roleID2)

        if roledata1 == nil or roledata2 == nil then
            return false
		end
		
		if self.iGameState == -1 and roledata1.uiFragment == 1 then
			mainRoleID = roleID1
		end
		
        if roledata1["uiLevel"] == roledata2["uiLevel"] then
            if roledata1["uiRank"] == roledata2["uiRank"] then
                return roleID1 > roleID2
            else
                return roledata1["uiRank"] > roledata2["uiRank"]
            end
        else
            return roledata1["uiLevel"] >  roledata2["uiLevel"]
        end
	end

	if auiTeamList[0] ~= nil then
		auiTeamList[#auiTeamList +1] = auiTeamList[0]
		auiTeamList[0] = nil
	end
	table.sort(auiTeamList,sort)

	local inBattleList = {}
	local notInBattleList = {}
	local aiInRoundRoleID = {}

	local embattleData = self.akRoleEmbattle[self.iCurToggleID][self.iCurRound]
	-- 剧本外 mainroleid 不是真正的创建角，有可能是 展示角色
	if self.iGameState ~= -1 then
		mainRoleID = kRoleDataManager:GetMainRoleID()
	end
	local mainRoleInBattle = false
	local aiIsInBattleRolID = {}

	if embattleData ~= nil and #embattleData > 0 then
		for index, data in ipairs(embattleData) do
			if data.uiRoleID == mainRoleID then
				mainRoleInBattle = true
			end
			aiIsInBattleRolID[data.uiRoleID] = true
		end
	end

	if self.iCurToggleID == EmBattleSchemeType.EBST_WheelWar then
		local kSorData = self.akRoleEmbattle[self.iCurToggleID]
		for k ,roundData in ipairs(kSorData)  do
			if k ~= self.iCurRound then
				for kk ,data in ipairs(roundData) do
					if  data.uiRoleID == mainRoleID then
						if not mainRoleInBattle then
							table.insert(notInBattleList,(#notInBattleList + 1) - kk + 1,data.uiRoleID)
							aiInRoundRoleID[data.uiRoleID] = true
						end
					else
						notInBattleList[#notInBattleList + 1] = data.uiRoleID
						aiInRoundRoleID[data.uiRoleID] = true
					end
				end
			end
		end

		if mainRoleInBattle then
			table.insert(inBattleList,mainRoleID)
		elseif aiInRoundRoleID[mainRoleID] ~= true then
			notInBattleList[#notInBattleList + 1] = mainRoleID
		end 

		for key, roleID in pairs(auiTeamList) do
			if roleID ~= mainRoleID then
				if aiIsInBattleRolID[roleID] then
					table.insert(inBattleList,roleID)
				else
					if aiInRoundRoleID[roleID] ~= true then
						table.insert(notInBattleList,roleID)
					end
				end
			end
		end
	else
		if mainRoleID ~= 0 then
			if mainRoleInBattle then
				table.insert(inBattleList,mainRoleID)
			else
				table.insert(notInBattleList,mainRoleID)
			end		
		end
			
		for key, roleID in pairs(auiTeamList) do
			if roleID ~= mainRoleID then
				if aiIsInBattleRolID[roleID] then
					table.insert(inBattleList,roleID)
				else
					table.insert(notInBattleList,roleID)
				end
			end
		end
	end


	auiTeamList = {}

	for key, roleID in pairs(inBattleList) do
		table.insert(auiTeamList,roleID)
	end

	for key, roleID in pairs(notInBattleList) do
		table.insert(auiTeamList,roleID)
	end

	self:RemoveCantSelectRole(auiTeamList)

	auiTeamList = table_lua2c(auiTeamList)
	return auiTeamList
end

function RoleEmbattleUI:RemoveCantSelectRole(auiTeamList)
	if self.bEvilEliminate == 1 or (self.bOpenByFinalBattle == true and 
	FinalBattleDataManager:GetInstance():IsEvilFinalBattle()) then
		for index = #auiTeamList, 1, -1 do
			if not self:CheckRoleEnterEvilBattle(auiTeamList[index]) then
				table.remove(auiTeamList, index)
			end
		end
	end
end

-- 
function RoleEmbattleUI:CheckRoleEnterEvilBattle(roleID)
	if roleID == RoleDataManager:GetInstance():GetMainRoleID() then
		return true
	end

	if not self.evilEliminateGifts then
		self.evilEliminateGifts = {}

		local config = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
		if config and config.EvilEliminateGifts then
			for index, giftTypeID in ipairs(config.EvilEliminateGifts) do
				self.evilEliminateGifts[giftTypeID] = true
			end
		end
	end

	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
	if roleData and roleData.GetGifts then
		local giftTypeIDs = roleData:GetAllGifts()
		if giftTypeIDs then
			for index, giftTypeID in pairs(giftTypeIDs) do
				if self.evilEliminateGifts[giftTypeID] then
					return true
				end
			end
		end
	end

	return false
end

function RoleEmbattleUI:RemoveClanRoleFromEmbattle(clanBaseID)
	if self.akRoleEmbattle == nil then 
		return 
	end
	local roleDataMgr = RoleDataManager:GetInstance()
	-- 移除车轮战上阵成员
	if self.akRoleEmbattle[EmBattleSchemeType.EBST_WheelWar] ~= nil then 
		for roundIndex, embattleInfoList in ipairs(self.akRoleEmbattle[EmBattleSchemeType.EBST_WheelWar]) do 
			for i = #embattleInfoList, 1, -1 do 
				local embattleRoleInfo = embattleInfoList[i]
				local roleID = embattleRoleInfo.uiRoleID
				local roleData = roleDataMgr:GetRoleData(roleID)
				local roleBaseData = roleDataMgr:GetRoleTypeDataByID(roleID)
				if roleID ~= RoleDataManager:GetInstance():GetMainRoleID() then
					if self.bEvilEliminate == 1 then
						-- 必须要指定天赋才能上阵
						local success = self:CheckRoleEnterEvilBattle(roleID)
						if not success then
							table.remove(embattleInfoList, i)
							self.bNeedSendData = true
							self:SetUpdateFlag(EmBattleSchemeType.EBST_WheelWar, roundIndex)
							local roleName = RoleDataHelper.GetName(roleData, roleBaseData)
							SystemUICall:GetInstance():Toast(tostring(roleName) .. ' 未使用三逆丹拒绝为你出战')
						end
					else
						if RoleDataHelper.GetRoleClan(roleData, roleBaseData) == clanBaseID then 
							table.remove(embattleInfoList, i)
							self.bNeedSendData = true
							self:SetUpdateFlag(EmBattleSchemeType.EBST_WheelWar, roundIndex)
							local roleName = RoleDataHelper.GetName(roleData, roleBaseData)
							SystemUICall:GetInstance():Toast(tostring(roleName) .. ' 拒绝为你出战本门踢馆')
						end

					end
				end

			end
		end
	end
end

return RoleEmbattleUI