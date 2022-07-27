FinalBattleUI = class("FinalBattleUI",BaseWindow)

function FinalBattleUI:ctor()
end

function FinalBattleUI:Create()
	local obj = LoadPrefabAndInit("FinalBattle/FinalBattleUI",Scence_Layer,true)
	if obj then
        self:SetGameObject(obj)
	end
end

function FinalBattleUI:Init()
    self.objFrameCityNode = self:FindChild(self._gameObject, "City_node")

    RemoveAllChildren(self.objFrameCityNode)

    self.objCityNodeTemplate = LoadPrefab("UI/UIPrefabs/FinalBattle/Button_CityBattle",typeof(CS.UnityEngine.GameObject))

    self.cityNodesObjMap = {}
end

function FinalBattleUI:RefreshUI()
    self:RefreshCityNodes()
end

function FinalBattleUI:Update(deltaTime)
    if FinalBattleDataManager:GetInstance():IsNeedUpdateUI() then
        FinalBattleDataManager:GetInstance():SetNeedUpdateUI(false)
        self:RefreshUI()
    end
end

function FinalBattleUI:RefreshCityNodes()
    local finalBattleCityInfos = globalDataPool:getData("FinalBattleCityInfos")

    if finalBattleCityInfos == nil then
        return
    end

    for uiFinalBattleCityID, finalBattleCityData in pairs(finalBattleCityInfos) do
        if self.cityNodesObjMap[uiFinalBattleCityID] == nil then
            self.cityNodesObjMap[uiFinalBattleCityID] = DRCSRef.ObjInit(self.objCityNodeTemplate, self.objFrameCityNode.transform)
        end

        self:ShowCityNode(self.cityNodesObjMap[uiFinalBattleCityID], finalBattleCityData)
    end
end

function FinalBattleUI:TreasureBoxPlayIdleAnimation(objTreasureBox)
    local skeletonAnimation = objTreasureBox:GetComponent("SkeletonAnimation")

    SetSkeletonAnimation(skeletonAnimation, 0, SPINE_DEFAULT_ANIMATION, false)
end
function FinalBattleUI:TreasureBoxPlayOpenAnimation(objTreasureBox, completeOpen)
    local skeletonAnimation = objTreasureBox:GetComponent("SkeletonAnimation")

    if skeletonAnimation ~= nil and skeletonAnimation.AnimationState ~= nil then
        SetSkeletonAnimation(skeletonAnimation, 0, SPINE_ANIMATION.BOX_OPEN, false)

        globalTimer:AddTimer(900, function()
            if completeOpen then
                completeOpen()
            end
        end)
    end
end

function FinalBattleUI:ShowCityNode(objCityNode, finalBattleCityData)
    local comCityNode_Button = objCityNode:GetComponent("Button")
    local objStateBattle = self:FindChild(objCityNode, "State_battle")
    local objStateWin = self:FindChild(objCityNode, "State_vectory")
    local objStateLost = self:FindChild(objCityNode, "State_fail")
    local objStateEvilWin = self:FindChild(objCityNode, "State_evil_vectory")
    local objStateEvilLost = self:FindChild(objCityNode, "State_evil_fail")
    local objRoleHeadFriend = self:FindChild(objCityNode, "Role_Head_company") 
    local objRoleHeadEnemy = self:FindChild(objCityNode, "Role_Head_enemy") 
    local comFriendHP_Scrollbar = self:FindChildComponent(objCityNode, "Scrollbar_HP_company", "Scrollbar")
    local comEnemyHP_Scrollbar = self:FindChildComponent(objCityNode, "Scrollbar_HP_enemy", "Scrollbar") 
    local comCiteyName_Text = self:FindChildComponent(objCityNode, "Text_city", "Text")
    local comFriendHP_Text = self:FindChildComponent(objCityNode, "Scrollbar_HP_company/Text", "Text")
    local comEnemyHP_Text = self:FindChildComponent(objCityNode, "Scrollbar_HP_enemy/Text", "Text")
    local objTreasureBox = self:FindChild(objCityNode, "TreasureBox")

    local finalBattleCityTypeData = TableDataManager:GetInstance():GetTableData("FinalBattleCity",finalBattleCityData.uiFinalBattleCityID)

    objCityNode.transform.localPosition = DRCSRef.Vec3(finalBattleCityTypeData.PosX, finalBattleCityTypeData.PosY, 0)

    -- 状态
    objStateBattle:SetActive(false)
    objStateWin:SetActive(false)
    objStateLost:SetActive(false)
    objStateEvilWin:SetActive(false)
    objStateEvilLost:SetActive(false)
    if finalBattleCityData.uiState == FinalBattleCityState.FBCS_LUN_XIAN then
        if FinalBattleDataManager:GetInstance():IsEvilFinalBattle() then
            objStateEvilLost:SetActive(true)
        else
            objStateLost:SetActive(true)
        end
    elseif finalBattleCityData.uiState == FinalBattleCityState.FBCS_JIE_FANG then
        if FinalBattleDataManager:GetInstance():IsEvilFinalBattle() then
            objStateEvilWin:SetActive(true)
        else
            objStateWin:SetActive(true)
        end
    else
        objStateBattle:SetActive(true)
    end

    -- 城市名
    comCiteyName_Text.text = GetLanguageByID(finalBattleCityTypeData.NameID)

    -- HP显示
    local iHpUnit = 100
    local iFriendMaxHP = (finalBattleCityData.iAliveFriendSize + finalBattleCityData.iDeadFriendSize) * iHpUnit
    local iEnemyMaxHP = (finalBattleCityData.iAliveEnemySize + finalBattleCityData.iDeadEnemySize) * iHpUnit
    local iCurFriendHP = finalBattleCityData.iCurFriendHP
    local iCurEnemyHP = finalBattleCityData.iCurEnemyHP

    comFriendHP_Text.text = tostring(iCurFriendHP)
    comFriendHP_Scrollbar.size = iCurFriendHP / iFriendMaxHP
    comEnemyHP_Text.text = tostring(iCurEnemyHP)
    comEnemyHP_Scrollbar.size = iCurEnemyHP / iEnemyMaxHP

    -- 队长头像
    local uiFriendCaptainRoleTypeID = 0
    local uiEnemyCaptainRoleTypeID = 0
    local uiFriendNameID = 0
    local uiEnemyNameID = 0

    for index, uiFriendID in ipairs(finalBattleCityTypeData.FriendTeams) do
        local friendTeamData = TableDataManager:GetInstance():GetTableData("FinalBattleFriend",uiFriendID)

        if friendTeamData and friendTeamData.IsCaptain == TBoolean.BOOL_YES then
            uiFriendCaptainRoleTypeID = friendTeamData.Role
            uiFriendNameID = friendTeamData.NameID
        end
    end
    for index, uiEnemyID in ipairs(finalBattleCityTypeData.EnemyTeams) do
        local enemyTeamData = TableDataManager:GetInstance():GetTableData("FinalBattleEnemy",uiEnemyID)

        if enemyTeamData and enemyTeamData.IsCaptain == TBoolean.BOOL_YES then
            uiEnemyCaptainRoleTypeID = enemyTeamData.Role
            uiEnemyNameID = enemyTeamData.NameID
        end
    end

    -- 宝箱
    local bShowTreasureBox = false
    if finalBattleCityData.uiState == FinalBattleCityState.FBCS_JIE_FANG then
        if finalBattleCityData.bGotReward == 0 then
            bShowTreasureBox = true
        end
    end
    if objTreasureBox.activeSelf ~= bShowTreasureBox then
        if bShowTreasureBox then
            objTreasureBox:SetActive(true)
            self:TreasureBoxPlayIdleAnimation(objTreasureBox)
        else
            objTreasureBox:SetActive(false)
        end
    end
    self:RemoveButtonClickListener(comCityNode_Button)
    if bShowTreasureBox then
        self:AddButtonClickListener(comCityNode_Button, function()
            self:TreasureBoxPlayOpenAnimation(objTreasureBox, function()
                SendClickFinalBattleOpenBox(finalBattleCityData.uiFinalBattleCityID)
            end)
        end)
    else
        self:AddButtonClickListener(comCityNode_Button, function()
            OpenWindowImmediately("FinalBattleCityInfoUI", finalBattleCityData.uiFinalBattleCityID)
        end)
    end

    -- 双方头像
    self:ShowRoleHead(objRoleHeadFriend, uiFriendCaptainRoleTypeID, uiFriendNameID, finalBattleCityData.uiState == FinalBattleCityState.FBCS_LUN_XIAN)
    self:ShowRoleHead(objRoleHeadEnemy, uiEnemyCaptainRoleTypeID, uiEnemyNameID, finalBattleCityData.uiState == FinalBattleCityState.FBCS_JIE_FANG)
end

function FinalBattleUI:ShowRoleHead(objRoleHead, uiRoleTypeID, uiNameID, bDead)
    local comHead_Image = self:FindChildComponent(objRoleHead, "head", "Image")
    local comName_Text = self:FindChildComponent(objRoleHead, "Name", "Text")
    local objDead = self:FindChild(objRoleHead, "dead")

    local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(uiRoleTypeID, true)
    comHead_Image.sprite = artData and GetSprite(artData.Head)

    comName_Text.text = GetLanguageByID(uiNameID)

    objDead:SetActive(bDead == true)
end

function FinalBattleUI:ShowCityInfo(uiFinalBattleCityID)

end

function FinalBattleUI:OnEnable()
	RemoveWindowImmediately("CityUI", true)
    RemoveWindowImmediately("MazeUI")
    RemoveWindowImmediately("TileBigMap")

	DisplayActionManager:GetInstance():ShowToptitle(TOPTITLE_TYPE.TT_BIGMAP)
	DisplayActionManager:GetInstance():ShowNavigation()
    MapEffectManager:GetInstance():ShowTempMapEffect(1)
end

function FinalBattleUI:OnDestroy()
    MapEffectManager:GetInstance():RemoveTempMapEffect()
end

return FinalBattleUI