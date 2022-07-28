FinalBattleCityInfoUI = class("FinalBattleCityInfoUI",BaseWindow)

function FinalBattleCityInfoUI:ctor()
end

function FinalBattleCityInfoUI:Create()
	local obj = LoadPrefabAndInit("FinalBattle/FinalBattleCityInfoUI",UI_UILayer,true)
	if obj then
        self:SetGameObject(obj)
	end
end

function FinalBattleCityInfoUI:Init()
    self.comBG_Button = self:FindChildComponent(self._gameObject, "BG_BigMap", "Button")
    self.comName_Text = self:FindChildComponent(self._gameObject, "Text_title", "Text")
    self.objBGBattle = self:FindChild(self._gameObject, "BG_battle")
    self.objBGWin = self:FindChild(self._gameObject, "BG_vectory")
    self.objBGLost = self:FindChild(self._gameObject, "BG_fail")
    self.objBGEvilWin = self:FindChild(self._gameObject, "BG_evil_vectory")
    self.objBGEvilLost = self:FindChild(self._gameObject, "BG_evil_fail")
    self.objBattleHP = self:FindChild(self._gameObject, "Battle_HP")
    self.comBattleHP_Slider = self:FindChildComponent(self.objBattleHP, "Slider_HP", "Slider")
    self.comFriendHP_Text = self:FindChildComponent(self.objBattleHP, "Num_company", "Text")
    self.comEnemyHP_Text = self:FindChildComponent(self.objBattleHP, "Num_enemy", "Text")

    self.objFriendCaptainHead = self:FindChild(self._gameObject, "RoleHead_FriendCaptain")
    self.objEnemyCaptainHead = self:FindChild(self._gameObject, "RoleHead_EnemyCaptain")
    self.objFrameFriendMembers = self:FindChild(self._gameObject, "Company_box")
    self.objFrameEnemyMembers = self:FindChild(self._gameObject, "Enemy_box")

    self.objBtnEnter = self:FindChild(self._gameObject, "Button_Enter")
    self.comBtnEnter_Button = self:FindChildComponent(self._gameObject, "Button_Enter", "Button")
    self.comBtnLeft_Button = self:FindChildComponent(self._gameObject, "Button_left", "Button")
    self.comBtnRight_Button = self:FindChildComponent(self._gameObject, "Button_right", "Button")

    self.objRoleHeadTemplate = LoadPrefab("UI/UIPrefabs/FinalBattle/Role_Head_Finalbattle",typeof(CS.UnityEngine.GameObject))

    self.finalBattleCityIDList = {1, 2, 3, 4, 5}

    self:AddButtonClickListener(self.comBG_Button, function()
        RemoveWindowImmediately("FinalBattleCityInfoUI")
    end)
    self:AddButtonClickListener(self.comBtnEnter_Button, function()
        -- TODO : 进入城市
        FinalBattleDataManager:EnterCityEmbattle(self.uiFinalBattleCityID, false)
        RemoveWindowImmediately("FinalBattleCityInfoUI")
    end)
    self:AddButtonClickListener(self.comBtnLeft_Button, function()
        for index, cityID in ipairs(self.finalBattleCityIDList) do
            if cityID == self.uiFinalBattleCityID then
                local refreshIndex = (index - 2 + #self.finalBattleCityIDList) % #self.finalBattleCityIDList + 1
                local refreshID = self.finalBattleCityIDList[refreshIndex]
                self:RefreshUI(refreshID)
                break
            end
        end
    end)
    self:AddButtonClickListener(self.comBtnRight_Button, function()
        for index, cityID in ipairs(self.finalBattleCityIDList) do
            if cityID == self.uiFinalBattleCityID then
                local refreshIndex = index % #self.finalBattleCityIDList + 1
                local refreshID = self.finalBattleCityIDList[refreshIndex]
                self:RefreshUI(refreshID)
                break
            end
        end
    end)
end

function FinalBattleCityInfoUI:RefreshUI(uiFinalBattleCityID)
    local finalBattleCityInfos = globalDataPool:getData("FinalBattleCityInfos") or {}
    local finalBattleCityData = finalBattleCityInfos[uiFinalBattleCityID]

    if finalBattleCityData == nil then
        return
    end

    -- 更新所有城市ID
    self.finalBattleCityIDList = {}
    local dataInfos = FinalBattleDataManager:GetInstance():GetCityInfos()
    for typeID, dataInfo in pairs(dataInfos) do
        table.insert(self.finalBattleCityIDList, typeID)
    end
    table.sort(self.finalBattleCityIDList, function(typeID1, typeID2)
        return typeID1 < typeID2
    end)


    self.uiFinalBattleCityID = uiFinalBattleCityID

    local finalBattleCityTypeData = TableDataManager:GetInstance():GetTableData("FinalBattleCity",finalBattleCityData.uiFinalBattleCityID)

    RemoveAllChildren(self.objFrameFriendMembers)
    RemoveAllChildren(self.objFrameEnemyMembers)

    self.comName_Text.text = GetLanguageByID(finalBattleCityTypeData.NameID)

    local isShowEnter = (finalBattleCityData.uiState == FinalBattleCityState.FBCS_JIANG_CHI)

    self.objBtnEnter:SetActive(isShowEnter)

    self.objBGBattle:SetActive(false)
    self.objBGWin:SetActive(false)
    self.objBGLost:SetActive(false)
    self.objBGEvilWin:SetActive(false)
    self.objBGEvilLost:SetActive(false)
    -- 状态显示
    if finalBattleCityData.uiState == FinalBattleCityState.FBCS_JIE_FANG then
        if FinalBattleDataManager:GetInstance():IsEvilFinalBattle() then
            self.objBGEvilWin:SetActive(true)
        else
            self.objBGWin:SetActive(true)
        end
    elseif finalBattleCityData.uiState == FinalBattleCityState.FBCS_LUN_XIAN then
        if FinalBattleDataManager:GetInstance():IsEvilFinalBattle() then
            self.objBGEvilLost:SetActive(true)
        else
            self.objBGLost:SetActive(true)
        end
    else
        self.objBGBattle:SetActive(true)
    end
        
    -- HP显示
    local iHpUnit = 100
    local iFriendMaxHP = (finalBattleCityData.iAliveFriendSize + finalBattleCityData.iDeadFriendSize) * iHpUnit
    local iEnemyMaxHP = (finalBattleCityData.iAliveEnemySize + finalBattleCityData.iDeadEnemySize) * iHpUnit
    local iCurFriendHP = finalBattleCityData.iCurFriendHP
    local iCurEnemyHP = finalBattleCityData.iCurEnemyHP
    self.comFriendHP_Text.text = tostring(iCurFriendHP)
    self.comEnemyHP_Text.text = tostring(iCurEnemyHP)
    self.comBattleHP_Slider.value = iCurFriendHP / (iCurFriendHP + iCurEnemyHP + 1) -- 防止除0

    -- 队伍头像
    local addTeamsHead = function(auiTeams, isFriend, isAlive, objFrameMembers, objCaptain)
        for index = 0, getTableSize(auiTeams) - 1 do
            local uiTeam = auiTeams[index]
            local teamData = nil

            if isFriend then
                teamData = TableDataManager:GetInstance():GetTableData("FinalBattleFriend",uiTeam)
            else
                teamData = TableDataManager:GetInstance():GetTableData("FinalBattleEnemy",uiTeam)
            end

            if teamData.IsCaptain == TBoolean.BOOL_YES then
                self:ShowTeamHead(objCaptain, teamData.Role, teamData.NameID, not isAlive)
            else
                local objTeam = DRCSRef.ObjInit(self.objRoleHeadTemplate, objFrameMembers.transform)
                objTeam.transform.localScale = DRCSRef.Vec3(0.8, 0.8, 1)
                self:ShowTeamHead(objTeam, teamData.Role, teamData.NameID, not isAlive)
            end
        end
    end


    addTeamsHead(finalBattleCityData.auiAliveFriendIDs, true, true, self.objFrameFriendMembers, self.objFriendCaptainHead)
    addTeamsHead(finalBattleCityData.auiDeadFriendIDs, true, false, self.objFrameFriendMembers, self.objFriendCaptainHead)
    addTeamsHead(finalBattleCityData.auiAliveEnemyIDs, false, true, self.objFrameEnemyMembers, self.objEnemyCaptainHead)
    addTeamsHead(finalBattleCityData.auiDeadEnemyIDs, false, false, self.objFrameEnemyMembers, self.objEnemyCaptainHead)


end

function FinalBattleCityInfoUI:ShowTeamHead(objRoleHead, uiRoleTypeID, uiNameID, bDead)
    local comHead_Image = self:FindChildComponent(objRoleHead, "head", "Image")
    local comName_Text = self:FindChildComponent(objRoleHead, "Name", "Text")
    local objDead = self:FindChild(objRoleHead, "dead")

    local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(uiRoleTypeID, true)
    comHead_Image.sprite = artData and GetSprite(artData.Head)

    comName_Text.text = GetLanguageByID(uiNameID)

    objDead:SetActive(bDead == true)
end

return FinalBattleCityInfoUI