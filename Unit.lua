Unit = class("Unit",UnitData)

local l_BATTLE_GRID_WIDTH = SSD_BATTLE_GRID_WIDTH
local l_BATTLE_GRID_HEIGHT = SSD_BATTLE_GRID_HEIGHT
function Unit:ctor()
    self.roleType = ROLE_TYPE.BATTLE_ROLE
    self.SkeletonGhost = nil
    self.animationToTime = {}  --动作对应的时间
    self.gameObject = nil --spine的gameobject
    self.transform = nil
    self.kPathFinder = PathFinder:GetInstance()
    self.kEffectMgr = EffectMgr:GetInstance()
    self.akMartialData = {}
    self.aiComboBaseID = {}
    self.iCurChooseSkillIndex = 0 
    --具体存储内容在GetSkillDamageRange中 
    --在选择移动点阶段，这个值是 移动后所有能打到的目标点信息
    --在技能选择阶段 ，这个值是 在当前位置下 技能能打到的所有目标点信息
    self.akCurSkillCanAttackData = {} -- 保存目标位置，显示为黄色，表示所有有效目标位置
    self.OnlyShowCastData = {}
    self.akCurCanMoveGrid = nil
    self.aiSkillCastPos ={['x'] = 0,['y'] = 0} --技能施法点
    self.kUnitLifeBar = nil
    self.kUnitNum = nil
    self._timeHandle = {}

    self.fMoveTime = 2
    self.old_fOptNeedTime = 0
    self.fOptNeedTime = 0

    self.attckSpeedTimeScale = 1
end

function Unit:OnDestroy()
	self.SpineRoleUINew:Close()
end

function Unit:Clear()
    LuaEventDispatcher:dispatchEvent("BATTLE_DELETE_UNIT",self.iUnitIndex)
    if self.kUnitLifeBar then
        self.kUnitLifeBar:Clear()
    end
    if self.kUnitNum then
        self.kUnitNum:Clear()
    end

    -- ReturnObjectToPool(self.gameObject)
    DRCSRef.ObjDestroy(self.gameObject)
    self.gameObject = nil
    
    if self._timeHandle ~= nil then
		for k,v in pairs(self._timeHandle) do
			globalTimer:RemoveTimer(v)
		end
	end

	for k, v in pairs(self) do
        self[k] = nil;
    end

end

function Unit:GetSex()
    if self.iSex then 
        return self.iSex
    end
    if self.uiTypeID == MAINROLE_TYPE_ID then 
        return RoleDataManager:GetInstance():GetMainRoleSex()
    end
    local staticData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(self.uiTypeID) 
    if staticData then
        return staticData.Sex or SexType.ST_Male
    end
    return SexType.ST_Male
end

function Unit:GenName()
    local uiSex = 0
    local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(self.uiTypeID)
    if staticData then
        uiSex = staticData.Sex
    end
    if self.uiNameID == 117 then --游戏玩法逻辑_通用_随机姓名
        self.sName = RoleDataHelper.getRandomPersonNameBySex(uiSex)
    elseif self.uiNameID == 102 then --随机生成一个名字
        self.sName = RoleDataHelper.getRandomPersonNameBySex(uiSex)
    else
        self.sName = self.battleRole:GenName(self)--RoleDataHelper.GetName(self, roleTypeData)
    end
end

function Unit:Init(kParent, kUnitData, uiModleID,uiTypeID,startTime,isImmediately)
    self.kParent = kParent
    self.iUnitIndex = kUnitData['uiUnitIndex']
    self.uiRoleID = kUnitData["uiRoleID"]
    self.kRoleFaceData = nil
    -- 服务器下发的捏脸数据
    if kUnitData['kRoleFaceData'] then
        if kUnitData['kRoleFaceData']['uiRoleID'] == 0 then
            -- if DEBUG_MODE then
            --     SystemUICall:GetInstance():Toast("战斗下发捏脸数据uiRoleID为0")
            -- end
        else
            self.kRoleFaceData = kUnitData['kRoleFaceData']
        end
    else
        if DEBUG_MODE then
            SystemUICall:GetInstance():Toast("战斗下发捏脸数据为nil")
        end 
    end
    self.uiTypeID = uiTypeID or RoleDataManager:GetInstance():GetRoleTypeID(self.uiRoleID)
    if self.uiTypeID == 0 then
        self.uiTypeID = uiTypeID or 1000001001
    end
    
    self.iMAXHP = kUnitData['iMAXHP']
    self.iMAXMP = kUnitData['iMAXMP']
    self.iShield = kUnitData['iShield'] or 0
    self.iSex = kUnitData['iSex'] or 1
    self.iHP = kUnitData['iHP'] or 1
    self.iMP = kUnitData['iMP'] or 1
    self.battleRole = BattleRole.new(self.uiRoleID,self)
    -- set init data
    self.iCamp = kUnitData['eCamp']
    -- 优先捏脸数据中的ModelId
    self.uiModleID = self.kRoleFaceData ~= nil and self.kRoleFaceData.uiModelID or uiModleID
    
    if self.uiModleID == 0 then 
        self.uiModleID = MODEL_DEFAULT_MODELID
    end
    self.iAssistFlag = kUnitData['iAssistFlag']
    self.iFace = kUnitData['iFace'] or 1
    self.uiNameID =  kUnitData['uiNameID']
    self.uiFamilyNameID =  kUnitData['uiFamilyNameID']
    self.uiFirstNameID =  kUnitData['uiFirstNameID']
    self.akEquipItem = kUnitData.akEquipItem
    self:GenName()
    local gridX = kUnitData['iGridX'] + 1
    local gridY = kUnitData['iGridY'] + 1
    self:LoadSpineCharacter(gridX, gridY, self.iCamp, self.iFace)
    if self.SpineRoleUINew == nil then 
        derror("unit init failed:",kParent,uiModleID)
        return 
    end
    local boneX,boneY = self.SpineRoleUINew:GetOverheadWorldXY()
    self.kUnitLifeBar = UnitLifeBar.new()
    self.kUnitLifeBar:Init(self.gameObject,boneX,boneY)

    self.kUnitNum = UnitDamageNum.new()
    self.kUnitNum:Init(self.gameObject,boneX,boneY)
    self.iShield = 0
    self:UpdateUnitLifeBar()
    self:SetFace(self.iFace)
    
    self.transform.localScale = self.transform.localScale * SCALE_BATTLE_UNIT

    local time = math.random(100,300)
    self:SetPos(gridX, gridY, true,false,false,time+startTime,isImmediately)
end

function Unit:HideLife(bHide)
    self.kUnitLifeBar:HideLife(bHide)
end

function Unit:SetObserveData(retStream)
    -- 更新天赋
    self.gifts = {}
    for index = 0,retStream.iBuffNum - 1 do
        local iBuffTypeID = retStream.akBuffData[index]
        table.insert(self.gifts,iBuffTypeID)
    end
    self:SetMartial(retStream.akUnitsMartial)
    self.iGoodEvil = retStream.iGoodEvil
    self.uiLevel = retStream.uiLevel
    self.aiAttrs = retStream.aiAttrs
    self.iRank = retStream.iRank
    self.iClan = retStream.iClan
end

function Unit:SetMoveTime(needTime,movetime)
    self.fMoveTime = movetime
    self.old_fOptNeedTime = self.fOptNeedTime
    self.fOptNeedTime = needTime
end

function Unit:ShowSkillName(name)
    self.kUnitLifeBar:SetSkillName(name)
end

function Unit:GetMartialData()
    return  self.akMartialData
end

function Unit:RoundRestore()
    if self.iRoundHP and self.iRoundHP > 0 then 
        self:ShowNumber(self.iRoundHP,COLOR_BATTLE_LIFE,true)
        -- self:AddHP(self.iRoundHP)
    end
    if self.iRoundMP and self.iRoundMP > 0 then 
        self:ShowNumber(self.iRoundMP,COLOR_BATTLE_ZHENQI,false)
        -- self:AddMP(self.iRoundMP)
    end
end

function Unit:SaveChooseSkill()
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData then 
        SetConfig("UnitChooseSkill" .. self.uiTypeID,kMartialData.iMartialID)
    end
end

function Unit:LoadChooseSkill()
    local iMartialID = GetConfig("UnitChooseSkill" .. self.uiTypeID)
    self.iCurChooseSkillIndex = 0 
    if iMartialID then 
        for k,v in pairs(self.akMartialData) do
            if v:IsEmbattle() and v.iMartialID == iMartialID then 
                self.iCurChooseSkillIndex = k
                return
            end
        end
    end
    if self.iCurChooseSkillIndex ==0 and next(self.akMartialData) then 
        for k,v in pairs(self.akMartialData) do
            if v:IsEmbattle() then 
                self.iCurChooseSkillIndex = k
                return
            end
        end
    end 
end
function Unit:GetGifts()
    return self.gifts or {}
end

function Unit:GetBuff_Hash()
    local result = {}
    for index = 0,self.iBuffNum - 1 do
        local buff = self.akBuffData[index]
        if buff.iRoundNum ~= 0 then 
            result[buff.iBuffTypeID] = buff 
        end
    end
    return result
end



function Unit:SetComboData(iComboNum,aiComboBaseID)
    self.aiComboBaseID = {}
    for i = 0 ,iComboNum - 1 do
        self.aiComboBaseID[i + 1] = aiComboBaseID[i]
    end
end

function Unit:setInitValue(name,value)
    if value and value ~= 0 then 
        self[name] = value
    end
end

function Unit:SetData(kUnitData,bInit,startTime)
    if self.bDeath then return end
    self.iMoveDistance = kUnitData['iMoveDistance']
    self.iMAXHP = kUnitData['iMAXHP']
    self.iMAXMP = kUnitData['iMAXMP']
    self.iBuffNum = kUnitData['iBuffNum']
    self.akBuffData = kUnitData['akBuffData']
    self.iRoundHP = kUnitData['iRoundHP']
    self.iRoundMP = kUnitData['iRoundMP']
    self.iMaxAttack = kUnitData['iMaxAttack']
    self.iDefend = kUnitData['iDefend']
    self.iMoveValue = kUnitData['iMoveValue']
    self.eMaxAttackType = kUnitData['eMaxAttackType']
    if self.iAssistFlag ~= 0 and self.iAssistFlag ~=  kUnitData['iAssistFlag'] then 
        self.iCamp = SE_CAMPA
        -- 创建替补头像
        LuaEventDispatcher:dispatchEvent("BATTLE_CREATE_UNIT",self.iUnitIndex)
    end
    self.iAssistFlag = kUnitData['iAssistFlag']
    if self.uiModleID == MODEL_DEFAULT_MODELID or self.iCamp == 0 then 
        dprint("error")
    end
    self.iChuanTouCiShu = kUnitData['iChuanTouCiShu'] or 0
     

    if kUnitData['iShield'] and self.iShield ~= kUnitData['iShield'] then 
        self:SetShield(kUnitData['iShield'])
    end
    local gridX = kUnitData['iGridX'] + 1
    local gridY = kUnitData['iGridY'] + 1
    startTime = startTime or 0
    local hasChangePos = false
    if UnitMgr:GetInstance().eChooseState == OPT_STATE.CHOOSE_POS then
        hasChangePos = self:SetPos(gridX, gridY,startTime)
    end

    BuffObjectManager:GetInstance():UpdateUnitBuff(self)

    if self.iHP ~= kUnitData['iHP'] then
        self:SetHP(kUnitData['iHP'])
    end
    local l_UnitMgr = UnitMgr:GetInstance()

    if self.iMP ~= kUnitData['iMP'] then
        self:SetMP(kUnitData['iMP'])
    end
    if l_UnitMgr:GetCurOptUnit() == self and self:CanControl() then 
        -- LuaEventDispatcher:dispatchEvent("BATTLE_REFRESH_SKILL_MAP_LOCKSTATE")
        self:ShowSkillUI()
        self:ShowCanMoveGrid()
    end
    self:UpdateUnitLifeBar()

    self:SetFace(kUnitData['iFace'] or 1)
    
    if hasChangePos then 
        self:UpdateUIState()
    end

end

function Unit:UpdateUIState()
    local l_UnitMgr = UnitMgr:GetInstance()
    if (l_UnitMgr.eChooseState == OPT_STATE.CHOOSE_POS or l_UnitMgr.eChooseState == OPT_STATE.CHOOSE_SKILL) then 
        local curUint = l_UnitMgr:GetCurOptUnit()
        if curUint and curUint:CanControl() then 
            curUint:ShowCanMoveGrid()
        end
    end
end
function Unit:SetMartial(akUnitsMartial)
    local iSkillNum = tonumber(akUnitsMartial.iSkillNum)
    for i = 0 ,iSkillNum - 1 do
        local kMartialData = akUnitsMartial.akMartial[i]
        local uiMartialIndex = kMartialData['uiMartialIndex']
        
        if self.akMartialData[uiMartialIndex] == nil then
            local martialData = BattleMartialData.new()
            martialData:Init(kMartialData)
            martialData:SetUnit(self)
            self.akMartialData[uiMartialIndex] = martialData
        else
            self.akMartialData[uiMartialIndex]:SetData(kMartialData)
        end
        -- 检测是否有是药三分毒
        if self.akMartialData[uiMartialIndex]:CureIsDemage() then 
            self._HasCureIsDemage = true
        end
    end
end

function Unit:HasCureIsDemage()
    return self._HasCureIsDemage
end

function Unit:UpdateUnitLifeBar_MP()
    if self.kUnitLifeBar then 
        if self.iMP > 0 then
            self.kUnitLifeBar:SetPercent_MP(self.iMP / self.iMAXMP)
        else
            self.kUnitLifeBar:SetPercent_MP(0)
        end
    end
end

function Unit:UpdateUnitLifeBar_HP()
    if self.kUnitLifeBar then 
        if self.iShield > 0 then
            self.kUnitLifeBar:SetPercent_Shield((self.iHP + self.iShield) / (self.iMAXHP + self.iShield))
        else
            self.kUnitLifeBar:SetPercent_Shield(0)
        end

        if self.iHP > 0 then
            self.kUnitLifeBar:SetPercent_HP(self.iHP /(self.iMAXHP + (self.iShield or 0)))
        else
            self.kUnitLifeBar:SetPercent_HP(0)
        end
    end
end

function Unit:SetFrameArrowShow(bShow)
    self.kUnitLifeBar:ShowFramesArrow(bShow)
end

function Unit:UpdateUnitLifeBar()
    self.kUnitLifeBar:SetName(self:GetName())
    self.kUnitLifeBar:SetCamp(self.iCamp)

    -- 我方显示绿色（当前仅适用于掌门对决）
    if ARENA_PLAYBACK_DATA then
        local playerID = (ARENA_PLAYBACK_DATA['kPly2Data'] or {})['defPlayerID']
        local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
        if playerID == ownerID then
            self.kUnitLifeBar:SetCamp(self:IsEnemy() and SE_CAMPA or SE_CAMPB)
        end
    end

    self:UpdateUnitLifeBar_HP()

    self:UpdateUnitLifeBar_MP()

    self.kUnitLifeBar:SetBuff(self.iBuffNum,self.akBuffData)

    if DEBUG_MODE then
        self.kUnitLifeBar:SetName(self:GetName() .. ":" .. self.iUnitIndex)
        local sHp = string.format("(%d/%d)", self.iHP, self.iMAXHP)
        self.kUnitLifeBar:SetName(self:GetName() .. ":" .. self.iUnitIndex)
    end
end

function Unit:IsSameCamp(eCamp)
    return IsSameCamp(eCamp,self.iCamp)
end

function Unit:ShowSpecialFont(flag,ctrlName)
    self.kUnitNum:SetSpecialText(flag,ctrlName)
end

function Unit:ShowNumber(dHp,Color,bHp,flag)
    if dHp and dHp == 0 then
        return
    end

    self.kUnitNum:SetFinalText(dHp,Color,bHp,flag)
end

function Unit:AddHP(iHP)
    self:SetHP(self:GetHP() + iHP)
end

function Unit:SetHP(iHP)
    iHP = math.max(math.min(iHP,self.iMAXHP),0)
    if iHP ~= self.iHP then
        self.iHP = iHP
        self:UpdateUnitLifeBar_HP()
        self:ShowBossInfo()
    end
end

function Unit:SetDeath(death)
    self.bDeath = death
    self.kPathFinder:SetWalkableAt(self.iGridX,self.iGridY,true,self.iUnitIndex,self.iCamp)
    self:UpdateUIState()
    BuffObjectManager:GetInstance():DeleteUnit(self)
    LuaEventDispatcher:dispatchEvent("BATTLE_DELETE_UNIT",self.iUnitIndex)
end

function Unit:GetRoleData()
    if self.uiTypeID == MAINROLE_TYPE_ID then 
        local baseID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
        return TB_Role[baseID]
    end
    return TB_Role[self.uiTypeID]
end

function Unit:_GetAudioInfo(name)
    local staticData = self:GetRoleData()
    local ans
    if staticData then 
        local battleAudioID
        if staticData.BattleAudio and staticData.BattleAudio ~= 0 then 
            battleAudioID = staticData.BattleAudio
        else
            if staticData.BattleAudio and staticData.BattleAudio ~= 0 then 
                battleAudioID = staticData.BattleAudio
            else
                local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
                if typeData and typeData.BattleAudio and typeData.BattleAudio ~= 0  then 
                    battleAudioID = typeData.BattleAudio
                end
            end

        end
        if battleAudioID and battleAudioID ~= 0 then 
            local typeData = TableDataManager:GetInstance():GetTableData("BattleAudio", battleAudioID)
            if typeData then 
                ans = typeData[name]
            end
        end
    end
    return ans
end

function Unit:PlayHurtAudio(startTime)
    if GetConfig("config_stophurtaudio") == 1 then return end
    if self._hurtAudio == nil then 
        self._hurtAudio = self:_GetAudioInfo("Hurt")
        if not self._hurtAudio then 
            local staticData = self:GetRoleData()
            if staticData then 
                self._hurtAudio = staticData.hurtSound
            end
        end
        if self._hurtAudio == nil then 
            if self:GetSex() == SexType.ST_Female then 
                self._hurtAudio = GetAudioSoundID("VoiceHurtFemale")
            else
                self._hurtAudio = GetAudioSoundID("VoiceHurtMale")
            end
        end
    end
    if self._hurtAudio and self._hurtAudio ~= 0 then 
        AddTrackSound(startTime or 0,self._hurtAudio)

    end
end

function Unit:PlayDeathAudio()
    if GetConfig("config_stophurtaudio") == 1 then return end
    if self._deathAudio == nil then 
        self._deathAudio = self:_GetAudioInfo("Death")
        if not self._deathAudio then 
            local staticData = self:GetRoleData()
            if staticData then 
                self._deathAudio = staticData.dieSound
            end
        end
        if self._deathAudio == nil then 
            if self:GetSex() == SexType.ST_Female then 
                self._deathAudio = GetAudioSoundID("VoiceDieFemale")
            else
                self._deathAudio = GetAudioSoundID("VoiceDieMale")
            end
        end
    end
    if self._deathAudio and self._deathAudio ~= 0 then 
        PlaySound(self._deathAudio)
    end
end

function Unit:PlayAttackAudio(skillTypeData)
    if GetConfig("config_stopattackaudio") == 1 then return end
    local skillAudio = self:_GetAudioInfo("Skill")
    local audioID = 0
    if skillAudio == 1 then
        if self:GetSex() == SexType.ST_Female then 
            audioID = skillTypeData.WomanAudio
        else
            audioID = skillTypeData.ManAudio
        end
    end
    if audioID == nil or audioID == 0 then 
        audioID = self:_GetAudioInfo("Attack")
    end

    if audioID then 
        AddTrackSound(0,audioID)
    end
end

function Unit:ShowBossInfo()
    if LogicMain:GetInstance():IsBoss(self.uiTypeID) then 
        LuaEventDispatcher:dispatchEvent("BATTLE_SHOW_BOSS_INFO",self)
    end
end

function Unit:AddDeathLog()
    local log = ""
    if self:IsEnemy() then
        log = string.format( "<color=#C53926>%s</color>",self:GetName())
    else
        log = string.format( "<color=#6CD458>%s</color>",self:GetName())
    end
    LuaEventDispatcher:dispatchEvent("BATTLE_ADD_LOG",{{log .. "退场了",TBoolean.BOOL_YES}})
end

function Unit:Show(boolean_show)
    if self.iHP > 0 then
        -- self.gameObject:SetActive(boolean_show)
        changeShapsAlpha(self.gameObject,boolean_show and 1 or 0)
        self.kUnitLifeBar:FadeOut(0,not boolean_show)
    end
end

function Unit:AddMP(iMP)
    self:SetMP(self:GetMP()+iMP)
end

function Unit:SetMP(iMP)
    iMP = math.max(math.min(iMP,self.iMAXMP),0)
    if iMP ~= self.iMP then
        self.iMP = iMP
        self:UpdateUnitLifeBar_MP()
    end
end

function Unit:MakeDemage(iDemage)
    if self.iShield >= iDemage then 
        self.iShield = self.iShield - iDemage
        self:SetShield(self.iShield)
    else
        self:AddHP(-(iDemage - self.iShield))
        self:SetShield(0)
    end
end

function Unit:SetShield(iShield)
    self.iShield = iShield
    self:UpdateUnitLifeBar()
end

function Unit:SetMaxHP(iMAXHP)
    self.iMAXHP = iMAXHP
end

function Unit:SetMaxMP(iMAXMP)
    self.iMAXMP = iMAXMP
end

function Unit:IsDeath()
    return self.bDeath
end

function Unit:GetBaseOrder()
    return GetDepthByGridPos(self.iGridX,self.iGridY)
end

function Unit:MoveInter(iGridX,iGridY,startTime,isImmediately)
    startTime = startTime or 0
    if self.iOldGridX ~= 0 then
        self:setQiTiaoYan(self.iOldGridX,self.iOldGridY,startTime, "com_qitiaoyan",isImmediately)
    end
    if isImmediately then 
        self:DirPlayAnim(SPINE_ANIMATION.MOVE,false)
    else
        AddTrackUnitFunc(self,startTime,'DirPlayAnim',SPINE_ANIMATION.MOVE,false)
    end
    local fMoveTime = getActionFrameTime(self.uiModleID,SPINE_ANIMATION.MOVE)
    if fMoveTime == 0 then fMoveTime = 500 end
    local fJumpTime = getActionFrameTime(self.uiModleID,SPINE_ANIMATION.MOVE,"jump")
    local fjumpoverTime = getActionFrameTime(self.uiModleID,SPINE_ANIMATION.MOVE,"jumpover")
    if fJumpTime == 0 then fJumpTime = 180 end
    if fjumpoverTime == 0 then fjumpoverTime = fMoveTime - 180 end
    local targetPos = GetPosByGrid(iGridX,iGridY)
    local centerPos = DRCSRef.Vec3((targetPos.x + self.transform.position.x) / 2, math.max(targetPos.y,self.transform.position.y) + 0.3,(targetPos.z + self.transform.position.z) / 2)

    local durTime = iGridX * fJumpTime

    if iGridX > l_BATTLE_GRID_WIDTH/2 then
        durTime = (l_BATTLE_GRID_WIDTH - iGridX + 1) * fJumpTime
    end
    local interval = durTime/1000
    local twnSequence = DRCSRef.DOTween.Sequence()
    interval = (fjumpoverTime - fJumpTime) / 1000
    local twn = self.transform:DOLocalMoveX(targetPos.x, interval, false)
    twnSequence:Append(twn)
    twn = self.transform:DOLocalMoveZ(targetPos.z, interval, false)
    twnSequence:Join(twn)
    twn = self.transform:DOLocalMoveY(centerPos.y, interval * 0.5, false)
    twnSequence:Join(twn)
    if isImmediately then 
        -- twnSequence:Pause()
        -- LogicMain:GetInstance():AddTimer(startTime,function()
            twnSequence:Play()
        -- end)
    else
        AddTrackTweener(twnSequence,startTime,durTime)
    end
    twn = self.transform:DOLocalMoveY(targetPos.y, interval * 0.5, false)
    if isImmediately then 
        twn:Pause()
        LogicMain:GetInstance():AddTimer(fjumpoverTime - fJumpTime,function()
            twn:Play()
        end)
        LogicMain:GetInstance():AddTimer(fMoveTime,function()
            self:SetUnitIdleAction()
        end)
    else
        AddTrackTweener(twn,startTime + fjumpoverTime - fJumpTime,durTime)
        AddTrackUnitFunc(self,startTime + fMoveTime,'SetUnitIdleAction')
    end
    self:setQiTiaoYan(iGridX,iGridY,startTime + fMoveTime, "com_luodiyan",isImmediately)
    if self:CanControl() then 
        local state = UnitMgr:GetInstance():GetChooseState()
        if state == OPT_STATE.CHOOSE_POS and self == UnitMgr:GetInstance():GetCurOptUnit() then 
            AddTrackUnitFunc(self,startTime + fMoveTime,'ShowChooseEffect')
        end
    end
end

function Unit:setQiTiaoYan(x,y,startTime, path,isImmediately)
    local oldPos = GetPosByGrid(x,y)
    local sortingLayer = GetDepthByGridPos(x,y)
    local effectObject = AddPrefabToWorldPos(string.format("Effect/Eff/com/%s",path),oldPos.x,oldPos.y,oldPos.z,sortingLayer)
    if effectObject then 
        local waitTime = effectObject:GetPlayTime("animation")
        if isImmediately then 
            effectObject:SetActive(false)
            LogicMain:GetInstance():AddTimer(startTime,function()
                effectObject:SetActive(true)
                effectObject:PlayAnimation("animation",false,0)
            end)
        else
            AddObjTrack(effectObject,startTime,waitTime,"animation")
        end
    end
end

function Unit:RollBackPos()
    self.kPathFinder:SetWalkableAt(self.iGridX,self.iGridY,true,self.iUnitIndex,self.iCamp)
    self.iGridX = self.iOldGridX
    self.iGridY = self.iOldGridY
    self.kPathFinder:SetWalkableAt(self.iOldGridX,self.iOldGridY,false,self.iUnitIndex,self.iCamp)

    local baseDepth = self:GetBaseOrder()
    if self.iAssistFlag == 1 or self.iAssistFlag == 2 then
        baseDepth = 100
    end

    self.SpineRoleUINew:SetSortingOrder(baseDepth)

    self.kUnitLifeBar:SetDepth(baseDepth+5)
    self.kUnitNum:SetDepth(baseDepth+5)

    self:SetFace(self.iOldFace,false)
    local targetPos = GetPosByGrid(self.iGridX,self.iGridY)
    self.transform.localPosition = targetPos
end

function Unit:SetPosAnim(iGridX,iGridY,binit,bJitui,bHeji,startTime,isImmediately,fMoveTime)
   
    startTime = startTime
    fMoveTime = fMoveTime or 0.18

    if not binit and not bJitui then
        self:UpdateFace()
    end

    if bJitui then
        AddTrackTweener(self.transform:DOLocalMove(GetPosByGrid(iGridX,iGridY), fMoveTime),startTime,0)
    else
        if self.iAssistFlag == 2 then
            AddTrackTweener(self.transform:DOLocalMove(GetAssistPosByGrid(iGridX,iGridY,self.iAssistFlag), fMoveTime),startTime,0)
        else
            self:MoveInter(iGridX,iGridY,startTime,isImmediately)
        end
    end
end

function Unit:SetPos(iGridX,iGridY,binit,bJitui,bHeji,startTime,isImmediately)
    if self.iGridX == iGridX and self.iGridY == iGridY then
        self.iOldGridX = self.iGridX
        self.iOldGridY = self.iGridY
        self.iOldFace = self.iFace
        return false
    end

    self.iOldGridX = self.iGridX
    self.iOldGridY = self.iGridY
    self.iOldFace = self.iFace
    self.kPathFinder:SetWalkableAt(self.iGridX,self.iGridY,true,self.iUnitIndex,self.iCamp)
    self.iGridX = iGridX
    self.iGridY = iGridY
    self.kPathFinder:SetWalkableAt(self.iGridX,self.iGridY,false,self.iUnitIndex,self.iCamp)

    local baseDepth = self:GetBaseOrder()
    if self.iAssistFlag == 1 then
        baseDepth = 100 
    elseif self.iAssistFlag == 2 then
        baseDepth = self.iGridY 
        --特殊处理替补层级 
        --TODO 暂不清楚 self.iAssistFlag 是何意义 以及为啥把替补配成 101，101 后续有问题可通知黄飞改 
        if baseDepth == 101 then
            baseDepth = 10
        end
    end
    self.SpineRoleUINew:SetSortingOrder(baseDepth + 1)
    self.kUnitLifeBar:SetDepth(baseDepth+5)
    self.kUnitNum:SetDepth(500)

    self:SetPosAnim(iGridX,iGridY,binit,bJitui,bHeji,startTime,isImmediately)
    
    return true
end

function Unit:SetUnitSelectGrid(gridX, gridY)
    self.selectX = nil 
    self.selectY = nil
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if not kMartialData then    
        return
    end

    local iTargetType = kMartialData:GetTargetType()
    local bHasTarget,aiUnitIndex = self.kPathFinder:IsTargetGrid(gridX,gridY,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)
    if bHasTarget then
        self.selectX = gridX
        self.selectY = gridY
    end
end

function Unit:GetUnitSelectGrid()
    return self.selectX,self.selectY
end

function Unit:UseSkill(x,y)
    --各种判断 比如蓝是否足够
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData == nil then
        return false
    end

    if kMartialData:isInColdTime() then 
        local coldTime = kMartialData:getColdTime()
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "武学冷却中，剩余" .. coldTime .. '回合')
        return false
    end

    if kMartialData:isDizzy() then
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "角色被眩晕")
        return false
    end

    if kMartialData:isFengYin() then
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "武学被封印")
        return false
    end
   
    if self:GetMP() < kMartialData.iCostMP then
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "真气不足")
        return false
    end

    self.aiSkillCastPos.x = x
    self.aiSkillCastPos.y = y
    return  true
end

function Unit:CurSkillIsFly()
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData == nil then
        return false
    end
    return kMartialData.eDepartEnum == DepartEnumType.DET_Fly

end
function Unit:IsInCastRange(x,y)
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData == nil then
        return false
    end
    local kRangePosData = kMartialData.aiCastRangePos
    local kRangePosDataY = kMartialData.aiCastRangePosY
    local eDepartEnum = kMartialData.eDepartEnum 
    local skillX,skillY
    local castSelfPos = self:isCastSelfPos(kRangePosData)
    if castSelfPos then
        return x == self.iGridX and y == self.iGridY
    end

    if eDepartEnum == DepartEnumType.DET_Fly then
        return  self.kPathFinder:IsWalkableAt(x,y,self.iUnitIndex)
    elseif eDepartEnum == DepartEnumType.DET_HiddenWeapon then
        if x == self.iGridX and y == self.iGridY then
            return false 
        end

        if x ~= self.iGridX then
            for i = 1, #kRangePosData do
                skillX = kRangePosData[i][1] + self.iGridX
                skillY = kRangePosData[i][2] + self.iGridY
                if skillX == x and skillY == y then
                    return  true
                end
            end
        elseif y ~= self.iGridY then
            if kRangePosDataY and #kRangePosDataY > 0 then
                for i = 1, #kRangePosDataY do
                    skillX = kRangePosDataY[i][1] + self.iGridX
                    skillY = kRangePosDataY[i][2] + self.iGridY
                    if skillX == x and skillY == y then
                        return  true
                    end
                end
            end
        end
    else
        for i = 1, #kRangePosData do
            skillX = kRangePosData[i][1] + self.iGridX
            skillY = kRangePosData[i][2] + self.iGridY
            if skillX == x and skillY == y then
                return  true
            end
        end
        if kRangePosDataY and #kRangePosDataY > 0 then
            for i = 1, #kRangePosDataY do
                skillX = kRangePosDataY[i][1] + self.iGridX
                skillY = kRangePosDataY[i][2] + self.iGridY
                if skillX == x and skillY == y then
                    return  true
                end
            end
        end
    end
    return  false
end

function Unit:ChangeSkillChoose(iSkillIndex)
    local iOldSkillIndex =  self.iCurChooseSkillIndex
    self.iCurChooseSkillIndex = iSkillIndex
    self:SaveChooseSkill()
    if self.iCurChooseSkillIndex ~= iOldSkillIndex then
        local state = UnitMgr:GetInstance():GetChooseState()
        local canAttackUnitRange = {}
        if state == OPT_STATE.CHOOSE_SKILL then
            canAttackUnitRange = self:GetAttackGridInSkillDamageRangeByPos(self.iGridX,self.iGridY)
        elseif state == OPT_STATE.CHOOSE_POS then
            canAttackUnitRange = self:GetAttackGridInAllSkillDamageRange()
        end
        LogicMain:GetInstance():ShowCanAttackGrid(canAttackUnitRange)
    end
end

function Unit:IsChooseSkillInColdTime()
    if not self.iCurChooseSkillIndex then 
        return false
    end
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if not kMartialData then
        return false
    end
    return kMartialData.coldTime and kMartialData.coldTime > 0
end

--是可攻击单位的目标点
function Unit:IsAttackUnitGrid(x,y)
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if not kMartialData then
        return false,nil
    end
    local onlyShow = kMartialData.IsOnlyShowCasterRange
    if onlyShow == 1 and GetHashValueByXY(self.OnlyShowCastData,x,y) then
        return true,{['skillPosX']=x,['skillPosY']=y}
    else
        local flag = false
        local rv = nil
        for k,v in ipairs(self.akCurSkillCanAttackData) do
            if v.damageX == x and v.damageY == y then
                rv = v
                flag = true
                if v.skillPosX == x and v.skillPosY == y then 
                    break
                end
            end
        end
        return flag,rv
    end

    return  false,nil
end

--技能范围信息
function Unit:GetSkillRangeGrid()
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    local data ={}
    if kMartialData == nil then
        self.iCurChooseSkillIndex = 0
        return data
    end
    local kRangePosData = kMartialData.aiCastRangePos
    local x,y
    for i = 1, #kRangePosData do
        x = kRangePosData[i][1] + self.iGridX
        y = kRangePosData[i][2] + self.iGridY
        if self.kPathFinder:IsInside(x,y) then
            data[#data + 1] = {x,y}
        end
    end

    local kRangePosDataY = kMartialData.aiCastRangePosY
    if kRangePosDataY and #kRangePosDataY > 0 then
        for i = 1, #kRangePosDataY do
            x = kRangePosDataY[i][1] + self.iGridX
            y = kRangePosDataY[i][2] + self.iGridY
            if self.kPathFinder:IsInside(x,y) then
                data[#data + 1] = {x,y}
            end
        end
    end
    return data
end

--技能范围信息
function Unit:InSkillRangeGrid(gridX,gridY)
    if self.canAttackUnitRange == nil then
        return false
    end
    for i = 1, #self.canAttackUnitRange do
        local x = self.canAttackUnitRange[i][1]
        local y = self.canAttackUnitRange[i][2]
        if gridX == x and gridY == y then
            return true
        end
    end
    return false
end

--x,y是否属于伤害范围
function Unit:IsInSkillDamageRange(x,y,iUnitPosX,iUnitPosY)
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData == nil then
        return false,{}
    end
    
    local kRangePosData = kMartialData.aiCastRangePos
    local kDamagePosData = kMartialData.aiDamagePos
    
    local kRangePosDataY = kMartialData.aiCastRangePosY
    local kDamagePosDataY = kMartialData.aiDamagePosY

    local Alllist = {}
    for key, value in pairs(kRangePosData) do
        Alllist[#Alllist+1] = value
    end
    if kRangePosDataY and #kRangePosDataY > 0 then
        for key, value in pairs(kRangePosDataY) do
            Alllist[#Alllist+1] = value
        end
    end

    local iCastPosX,iCastPosY
    local damageX,damageY
    for i = 1, #Alllist do
        iCastPosX = Alllist[i][1] + iUnitPosX
        iCastPosY = Alllist[i][2] + iUnitPosY
        local kRangeData = self:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,iUnitPosX,iUnitPosY,kMartialData.eDepartEnum)
        for j = 1,#kRangeData do
            damageX = kRangeData[j][1]
            damageY = kRangeData[j][2]
            if x == damageX and y == damageY and kRangeData[j][3] then
                return true,kRangeData
            end
        end
    end

    return false,{}
end

--目标点是否被包含在可攻击的单位的伤害范围中
function Unit:IsIncludeAttackGrid(targetX,targetY)
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData == nil then
        return false
    end

    local castPosData = {}
    local bInclude = false

    for i = 1, #self.akCurSkillCanAttackData do
        local data = self.akCurSkillCanAttackData[i]
        if data.skillPosX == targetX and data.skillPosY == targetY then 
            local kRangeData,gridData_hash = self:GetSkillDamageRangeByPos(kMartialData,targetX,targetY,self.iGridX,self.iGridY,kMartialData.eDepartEnum)
            if gridData_hash[targetX * 100 + targetY] then
                castPosData.skillPosX = targetX
                castPosData.skillPosY = targetY
                bInclude = true
                return bInclude,castPosData
            end
            break
        end
    end
    -- 包含目标点并可以打到单位的点  一定在self.akCurSkillCanAttackData 里。
    -- skillPosX skillPosY
    for i = 1, #self.akCurSkillCanAttackData do
        local data = self.akCurSkillCanAttackData[i]
        local kRangeData,gridData_hash = self:GetSkillDamageRangeByPos(kMartialData,data.skillPosX,data.skillPosY,self.iGridX,self.iGridY,kMartialData.eDepartEnum)
        if gridData_hash[targetX * 100 + targetY] then
            castPosData.skillPosX = data.skillPosX
            castPosData.skillPosY = data.skillPosY
            bInclude = true
            break
        end
    end
    return bInclude,castPosData
end

function Unit:isCastSelfPos(kRangePosData)
    local castSelfPos = false
    if #kRangePosData == 1 and kRangePosData[1][1] == 0 and kRangePosData[1][2] == 0 then
        castSelfPos = true
    end
    return castSelfPos
end

function Unit:PosBetter_Center(battlePosEvalA,battlePosEvalB) 
    -- 最接近游戏画面中心（X 坐标最接近4.5、Y坐标最接近3）的位置作为最终走位   
    local distCenter = function(unitPosX,unitPosY)
        local dx,dy
        dx = math.abs(unitPosX - 4.5)
        dy = math.abs(unitPosY - 3)
        return dx + dy
    end
    local distCenterA = distCenter(battlePosEvalA.unitPosX,battlePosEvalA.unitPosY)
    local distCenterB = distCenter(battlePosEvalB.unitPosX,battlePosEvalB.unitPosY)
    return distCenterA < distCenterB
end

function Unit:PosBetter_Common(battlePosEvalA,battlePosEvalB)
    if (battlePosEvalA.targetCount ~= battlePosEvalB.targetCount) then 
		return battlePosEvalA.targetCount > battlePosEvalB.targetCount
    end 
	if (battlePosEvalA.hitScore ~= battlePosEvalB.hitScore) then
		return battlePosEvalA.hitScore > battlePosEvalB.hitScore
    end
	return self:PosBetter_Center(battlePosEvalA, battlePosEvalB)
end

function Unit:PosBetter_AnQi(battlePosEvalA,battlePosEvalB)
	if (battlePosEvalA.targetCount ~= battlePosEvalB.targetCount) then
		return battlePosEvalA.targetCount > battlePosEvalB.targetCount
    end
	if (battlePosEvalA.distTarget ~= battlePosEvalB.distTarget) then
		return battlePosEvalA.distTarget > battlePosEvalB.distTarget
    end
	return self:PosBetter_Center(battlePosEvalA, battlePosEvalB)
end

function Unit:PosBetter_Heal(battlePosEvalA,battlePosEvalB)
	if (battlePosEvalA.targetCount ~= battlePosEvalB.targetCount) then
		return battlePosEvalA.targetCount > battlePosEvalB.targetCount
    end
	if (battlePosEvalA.distEnemy ~= battlePosEvalB.distEnemy) then
		return battlePosEvalA.distEnemy > battlePosEvalB.distEnemy
    end
	return self:PosBetter_Center(battlePosEvalA, battlePosEvalB)
end

--获取包含特定目标的最佳释放位置
function Unit:GetCastPosIncludeTarget(gridx, gridy)
    -- 武学信息
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    if kMartialData == nil then
        return {}
    end
    local kRangePosData = kMartialData.aiCastRangePos
    local kDamagePosData = kMartialData.aiDamagePos
    local kRangePosDataY = kMartialData.aiCastRangePosY
    local kDamagePosDataY = kMartialData.aiDamagePosY
    local Alllist = {}
    for key, value in pairs(kRangePosData) do
        Alllist[#Alllist+1] = value
    end
    if kRangePosDataY and #kRangePosDataY > 0 then
        for key, value in pairs(kRangePosDataY) do
            Alllist[#Alllist+1] = value
        end
    end

    local castSelfPos = self:isCastSelfPos(kRangePosData)

    local eDepartEnum = kMartialData.eDepartEnum 
    local iTargetType = kMartialData:GetTargetType()

    if eDepartEnum == DepartEnumType.DET_HiddenWeapon then
        Alllist = {{0,0}}
    end

    -- 根据武学类型 决定选择位置的策略
    local cmpBetterFunc = self.PosBetter_Common
    if eDepartEnum == DepartEnumType.DET_HiddenWeapon then
        cmpBetterFunc = self.PosBetter_AnQi
    elseif eDepartEnum == DepartEnumType.DET_MedicalSkill then
        cmpBetterFunc = self.PosBetter_Heal
    end

    local curBattlePosEval = {
        castPosX = 0,
        castPosY = 0,
        unitPosX = 0,
        unitPosY = 0,
        targetCount = 0,
        distTarget = -1,
        distEnemy = -1,
        hitScore = 0,
    }
    local bestBattlePosEval = clone(curBattlePosEval)
    local sortXY = function(a,b)
        if a[1]~=b[1] then
            return a[1]<b[1]
        else
            return a[2]<b[2]
        end
    end
    table.sort(self.akCurCanMoveGrid,sortXY)
    -- 找个能覆盖最多单位的位置 原始策略
    for moveIndex = 1,#self.akCurCanMoveGrid do
        curBattlePosEval.unitPosX = self.akCurCanMoveGrid[moveIndex][1]
        curBattlePosEval.unitPosY = self.akCurCanMoveGrid[moveIndex][2]
        for i = 1, #Alllist do
            curBattlePosEval.castPosX = Alllist[i][1] + curBattlePosEval.unitPosX
            curBattlePosEval.castPosY = Alllist[i][2] + curBattlePosEval.unitPosY
            if self.kPathFinder:IsInside(curBattlePosEval.castPosX,curBattlePosEval.castPosY) then
                local kRangeData = self:GetSkillDamageRangeByPos(kMartialData,curBattlePosEval.castPosX,curBattlePosEval.castPosY,curBattlePosEval.unitPosX,curBattlePosEval.unitPosY,eDepartEnum)
                if iTargetType == SkillTargetType.SkillTargetType_renyi and eDepartEnum == DepartEnumType.DET_HiddenWeapon then 
                    table.insert(kRangeData,1,{curBattlePosEval.unitPosX,curBattlePosEval.unitPosY,true})
                end
                curBattlePosEval.targetUnits = {}
                curBattlePosEval.targetCount = 0
                curBattlePosEval.distTarget = -1
                curBattlePosEval.distEnemy = -1
                curBattlePosEval.hitScore = 0
                local bInclude = false
                for j = 1,#kRangeData do
                    local damageX = kRangeData[j][1]
                    local damageY = kRangeData[j][2]
                    local bHasTarget,aiUnitIndex = self.kPathFinder:IsTargetGrid(damageX,damageY,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)
                    if bHasTarget and kRangeData[j][3] then
                        if (eDepartEnum == DepartEnumType.DET_HiddenWeapon) then
                            if self.iGridX ==  gridx or gridy == self.iGridY then
                                if ((self.iGridX ==  gridx) and (damageX == gridx)) or ((gridy == self.iGridY) and ((damageY == gridy))) then
                                    curBattlePosEval.targetCount = curBattlePosEval.targetCount + 1
                                end
                            end
                        else
                            curBattlePosEval.targetCount = curBattlePosEval.targetCount + 1
                        end
                        table.insert(curBattlePosEval.targetUnits,#curBattlePosEval.targetUnits+1,aiUnitIndex)
                        if not bInclude then
                            bInclude = self:isSameGrid(gridx, gridy, damageX, damageY)
                        end

                        if damageX == gridx and damageY == gridy then
                            -- 对于 暗器 技能，确定了释放目标以及包含最多目标的位置后，若同时存在多个可选的位置，选择距离目标最远的位置作为最终走位
                            curBattlePosEval.distTarget = math.abs(curBattlePosEval.unitPosX - gridx) + math.abs(curBattlePosEval.unitPosY - gridy)
                            if eDepartEnum == DepartEnumType.DET_MedicalSkill then
                                -- 对于 医术 技能，确定了释放目标以及包含最多目标的位置后，若同时存在多个可选的位置，选择距离最近的敌方单位最远的位置作为最终走位
                                curBattlePosEval.distEnemy = self:GetNearestEnemyUnitDist(curBattlePosEval.unitPosX,curBattlePosEval.unitPosY) or -1
                                -- 对自己释放的时候，要求优先级最高
                                if curBattlePosEval.unitPosX == curBattlePosEval.castPosX and curBattlePosEval.unitPosY == curBattlePosEval.castPosY  then
                                    curBattlePosEval.targetCount = 99 
                                end
                            end
                        end

                    end
                end
                
                if cmpBetterFunc == self.PosBetter_Common then
                    local kUnit
                    for k = 1,#curBattlePosEval.targetUnits do
                        local aiUnitIndex = curBattlePosEval.targetUnits[k]
                        for iUnitIndex,v in pairs(aiUnitIndex) do
                            kUnit = UnitMgr:GetInstance():GetUnit(iUnitIndex)
                            break
                        end
                        if kUnit then
                            local face = self:CalcRolePosRelation(curBattlePosEval.unitPosX,curBattlePosEval.unitPosY,gridx,gridy,kUnit.iFace)
                            if face == -1 then -- 背击
                                curBattlePosEval.hitScore = curBattlePosEval.hitScore + 2
                            elseif face == 0 then -- 侧击
                                curBattlePosEval.hitScore = curBattlePosEval.hitScore + 1
                            end
                        end
                    end
                end
                -- if curBattlePosEval.targetCount == 1 and cmpBetterFunc == self.PosBetter_Common then
                --     -- 对于 刀剑拳腿棍 技能，当目标只包含唯一的敌人时，若同时存在多个可选的位置，选择可对该敌人造成背击、侧击的位置作为最终走位
                --     local bHasTarget,aiUnitIndex = self.kPathFinder:IsTargetGrid(gridx,gridy,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)
                --     local kUnit
                --     for iUnitIndex,v in pairs(aiUnitIndex) do
                --         kUnit = UnitMgr:GetInstance():GetUnit(iUnitIndex)
                --         break
                --     end
                --     if kUnit then
                --         local face = self:CalcRolePosRelation(curBattlePosEval.unitPosX,curBattlePosEval.unitPosY,gridx,gridy,kUnit.iFace)
                --         if face == -1 then -- 背击
                --             curBattlePosEval.hitScore = 2
                --         elseif face == 0 then -- 侧击
                --             curBattlePosEval.hitScore = 1
                --         end
                --     end
                -- end
                if bInclude then
                    if bestBattlePosEval == nil then 
                        bestBattlePosEval = clone(curBattlePosEval)
                    elseif cmpBetterFunc(self,curBattlePosEval,bestBattlePosEval) then
                        bestBattlePosEval = clone(curBattlePosEval)
                    end
                    if eDepartEnum == DepartEnumType.DET_HiddenWeapon and not castSelfPos then
                        bestBattlePosEval.castPosX = gridx
                        bestBattlePosEval.castPosY = gridy
                    end
                end
            end
        end
    end
    return {['cx']=bestBattlePosEval.castPosX, ['cy']=bestBattlePosEval.castPosY, ['mx']=bestBattlePosEval.unitPosX, ['my']=bestBattlePosEval.unitPosY}
end

-- 获取离当前位置最近的敌人距离
function Unit:GetNearestEnemyUnitDist(unitPosX,unitPosY)
    local allUnit = UnitMgr:GetInstance():GetAllUnit()
    local minDis
    for k,v in pairs(allUnit) do 
        if v.iAssistFlag == 0 and not v:IsDeath() and v.iCamp == SeUnitCampType.TSE_CAMPB then
            local dis = math.abs(unitPosX - v.iGridX) + math.abs(unitPosY - v.iGridY)
            if minDis == nil or dis < minDis then
                minDis = dis
            end
        end
    end
    return minDis
end

-- 计算位置关系
function Unit:CalcRolePosRelation(posAX,posAY,posBX,posBY,iFace)
    local dx = math.abs(posAX - posBX)
    local dy = math.abs(posAY - posBY)
    if posAY ~= posBY then
        local flag = 1
        if posAX < posBX then
            flag = -1
        end
        if posAX ~= posBX then
            if dx > dy then
                return iFace * flag
            else
                if iFace == flag and dx == dy then
                    return 1
                end
                return 0
            end
        end
        return 0
    else
        if posAX > posBX then
            return iFace
        else
            return iFace * -1
        end
    end
    return 1
end

--获取技能能打到单位的所有格子（包括移动后能打到的）
function Unit:GetAttackGridInAllSkillDamageRange()
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    local gridData ={}
    if kMartialData == nil then
        return gridData
    end
    local kRangePosData = kMartialData.aiCastRangePos
    local kDamagePosData = kMartialData.aiDamagePos

    local kRangePosDataY = kMartialData.aiCastRangePosY
    local kDamagePosDataY = kMartialData.aiDamagePosY

    local Alllist = {}
    for key, value in pairs(kRangePosData) do
        Alllist[#Alllist+1] = value
    end
    if kRangePosDataY and #kRangePosDataY > 0 then
        for key, value in pairs(kRangePosDataY) do
            Alllist[#Alllist+1] = value
        end
    end

    local castSelfPos = self:isCastSelfPos(kRangePosData)

    local eDepartEnum = kMartialData.eDepartEnum 
    local iTargetType = kMartialData:GetTargetType()
    local iCastPosX,iCastPosY
    local damageX,damageY
    local iUnitPosX,iUnitPosY
    self.akCurSkillCanAttackData = {}
    self.OnlyShowCastData = {}
    if eDepartEnum == DepartEnumType.DET_Fly then
        self:GetQingGongRange(gridData,self.akCurSkillCanAttackData)
    else
        if eDepartEnum == DepartEnumType.DET_HiddenWeapon then
            Alllist = {{0,0}}
        end
        if self.akCurCanMoveGrid == nil then 
            self.akCurCanMoveGrid = self.kPathFinder:GetCanMoveGrid(self.iGridX,self.iGridY,self:GetMoveDistance(),self.iUnitIndex)
        end
        if self.akCurCanMoveGrid == nil then  
            return
        end
        -- 计算所有可攻击到的格子 合并矩形
        -- 遍历所有敌人
        -- hash判断
        local hash_pos = {}
        local hash_posCount = 0
        local allUnit = UnitMgr:GetInstance():GetAllUnit()
        for k,v in pairs(allUnit) do
            if v.iAssistFlag == 0 and not v:IsDeath() then
                local posFlag = v.iGridX * 100 + v.iGridY
                hash_pos[posFlag] = true
                hash_posCount = hash_posCount + 1
            end
        end
        for moveIndex = 1,#self.akCurCanMoveGrid do
            iUnitPosX = self.akCurCanMoveGrid[moveIndex][1]
            iUnitPosY = self.akCurCanMoveGrid[moveIndex][2]
            for i = 1, #Alllist do
                iCastPosX = Alllist[i][1] + iUnitPosX
                iCastPosY = Alllist[i][2] + iUnitPosY
                if self.kPathFinder:IsInside(iCastPosX,iCastPosY) then --移动点在格子范围内
                    local kRangeData = self:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,iUnitPosX,iUnitPosY,eDepartEnum)
                    for j = 1,#kRangeData do
                        damageX = kRangeData[j][1]
                        damageY = kRangeData[j][2]
                        local posFlag = damageX * 100 + damageY
                        if hash_pos[posFlag] or iTargetType == SkillTargetType.SkillTargetType_NULL or iTargetType == SkillTargetType.SkillTargetType_kongdi then
                            local bHasTarget,aiUnitIndex = self.kPathFinder:IsTargetGrid(damageX,damageY,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)
                            if bHasTarget and kRangeData[j][3] then
                                gridData[#gridData + 1] = {damageX,damageY,bHasTarget}
                                local data = {
                                    ['damageX'] = damageX,
                                    ['damageY'] = damageY
                                }
                                self.akCurSkillCanAttackData[#self.akCurSkillCanAttackData + 1] = data
                            end
                        end
                    end
                end
            end
        end
    end 
    return gridData --格子可能包含重复的信息
end
--获取技能在释放点 iCastPosX iCastPosY ，伤害范围信息 
--bAddCurSkillCanAttackData 添加格子有无单位信息
function Unit:GetAttackGridInSkillDamageRangeByPos(iUnitPosX,iUnitPosY)
    local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
    local gridData ={}
    if kMartialData == nil then
        return {}
    end
    local kRangePosData = kMartialData.aiCastRangePos
    local kDamagePosData = kMartialData.aiDamagePos

    local kRangePosDataY = kMartialData.aiCastRangePosY
    local kDamagePosDataY = kMartialData.aiDamagePosY

    local Alllist = {}
    for key, value in pairs(kRangePosData) do
        Alllist[#Alllist+1] = value
    end
    if kRangePosDataY and #kRangePosDataY > 0 then
        for key, value in pairs(kRangePosDataY) do
            Alllist[#Alllist+1] = value
        end
    end

    local castSelfPos = self:isCastSelfPos(kRangePosData)

    local iTargetType = kMartialData:GetTargetType()
    local eDepartEnum = kMartialData.eDepartEnum 
    local iCastPosX,iCastPosY
    local damageX,damageY
    self.akCurSkillCanAttackData = {}
    self.OnlyShowCastData = {}
    if eDepartEnum == DepartEnumType.DET_Fly then
        self:GetQingGongRange(gridData,self.akCurSkillCanAttackData)
    else
        if eDepartEnum == DepartEnumType.DET_HiddenWeapon then
            Alllist = {{0,0}}
        end
        for i = 1, #Alllist do
            iCastPosX = Alllist[i][1] + iUnitPosX
            iCastPosY = Alllist[i][2] + iUnitPosY
            if self.kPathFinder:IsInside(iCastPosX,iCastPosY) then --伤害点在格子范围内
                if kMartialData.IsOnlyShowCasterRange == 1 then
                    local kRangeData = self:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,iUnitPosX,iUnitPosY,eDepartEnum)
                    local bHasTarget = false
                    for j = 1,#kRangeData do
                        damageX = kRangeData[j][1]
                        damageY = kRangeData[j][2]
                        if self.kPathFinder:IsInside(damageX,damageY) then --伤害点在格子范围内
                            local bTarget = self.kPathFinder:IsTargetGrid(damageX,damageY,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)    
                            if not bHasTarget and bTarget then
                                bHasTarget = bTarget
                                break-- 满足直接break
                            end
                        end
                    end
                    gridData[#gridData + 1] = {iCastPosX,iCastPosY,bHasTarget}
                    if bHasTarget then
                        SetHashValueByXY(self.OnlyShowCastData,iCastPosX,iCastPosY,true)
                    end
                else
                    local kRangeData = self:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,iUnitPosX,iUnitPosY,eDepartEnum)
                    local bHasRed = false
                    for j = 1,#kRangeData do
                        damageX = kRangeData[j][1]
                        damageY = kRangeData[j][2]
                        if self.kPathFinder:IsInside(damageX,damageY) then --伤害点在格子范围内
                            local bHasTarget = self.kPathFinder:IsTargetGrid(damageX,damageY,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)    
                            if bHasTarget and kRangeData[j][3] then
                                bHasRed = true
                                local data = {}
                                data.skillPosX = iCastPosX
                                data.skillPosY = iCastPosY
                                data.damageX = damageX
                                data.damageY = damageY
                                if eDepartEnum == DepartEnumType.DET_HiddenWeapon and not castSelfPos then
                                    data.skillPosX = damageX
                                    data.skillPosY = damageY
                                end
                                self.akCurSkillCanAttackData[#self.akCurSkillCanAttackData + 1] = data  
                            end
                            gridData[#gridData + 1] = {damageX,damageY,bHasTarget}
                        end
                    end
                    if  bHasRed  then
                        if eDepartEnum ~= DepartEnumType.DET_HiddenWeapon or castSelfPos then
                            for j = #gridData,#gridData - #kRangeData + 1, -1 do
                                if gridData[j] then
                                    gridData[j][3] = true
                                end
                            end
                        end
                    end
                end       
            end
        end
    end
    return gridData
end

--获取轻功行动范围
function Unit:GetQingGongRange(gridData,attackData)
    for i = 1,l_BATTLE_GRID_WIDTH do
        for j = 1,l_BATTLE_GRID_HEIGHT do
            if self.kPathFinder:IsWalkableAt(i,j,self.iUnitIndex) then
                gridData[#gridData + 1] = {i,j,true}   
                local data = {}
                data.movePosX = self.iGridX
                data.movePosY = self.iGridY
                data.skillPosX = i
                data.skillPosY = j
                data.damageX = i
                data.damageY = j
                self.akCurSkillCanAttackData[#self.akCurSkillCanAttackData + 1] = data
            end
        end
    end 
end

function Unit:isSameGrid(gridx,gridy,destGridx,destGridy)
    if not gridx or not gridy then
        return false
    end
    if not destGridx or not destGridy then
        return false
    end
    if destGridx <= 0 or destGridy <= 0 then
        return false
    end

    return ((gridx == destGridx) and (gridy == destGridy))
end

--kMartialData,iCastPosX,iCastPosY
--[todo] 目前只有左右区分 
function Unit:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,iUnitPosX,iUnitPosY,eDepartEnum)
    if not kMartialData then
        return
    end

    -- local martialItemData = TableDataManager:GetInstance():GetTableData("MartialItem", kMartialData.iMartialItemTypeID)
    -- if not martialItemData then
    --     return
    -- end

    local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", kMartialData.skillID)
    if not kSKillData then
        return
    end
    iCastPosX = iCastPosX or 0
    iCastPosY = iCastPosY or 0
    iUnitPosX = iUnitPosX or 0
    iUnitPosY = iUnitPosY or 0
    local xOffSet = self.iFace
    local yOffSet = 1
    local damageX,damageY
    local gridData = {} 
    local gridData_hash = {}

    local kDamagePosData = kMartialData.aiDamagePos
    local kRangePosData = kMartialData.aiCastRangePos
    local iTargetType = kMartialData:GetTargetType()
    local bCastY = #kMartialData.aiDamagePosY > 0 and true or false
    if bCastY then
        if iCastPosX ~= iUnitPosX then
            if iCastPosX > iUnitPosX then
                xOffSet = 1
            else
                xOffSet = -1
            end
            yOffSet = 1
        elseif iCastPosY ~= iUnitPosY then
            xOffSet = 1
            if iCastPosY > iUnitPosY then
                yOffSet = 1
            else
                yOffSet = -1
            end
            kDamagePosData = kMartialData.aiDamagePosY
        else
            xOffSet = 1
            yOffSet = 1
        end
    end

    local castSelfPos = false
    if #kRangePosData == 1 and kRangePosData[1][1] == 0 and kRangePosData[1][2] == 0 then
        castSelfPos = true
    end
    
    if eDepartEnum == DepartEnumType.DET_HiddenWeapon and not castSelfPos then
        local chuantoucishu = (self.iChuanTouCiShu or 0) + (kSKillData.Penetrate or 0)
        if chuantoucishu == 0 then
            chuantoucishu = 1
        end 

        local distance = math.floor(#kRangePosData/2)
        local tmpList = {}
        local list = {}
        for j=1,l_BATTLE_GRID_WIDTH do
            if j > iUnitPosX then
                list[#list+1] = {j,iUnitPosY}
            end
        end
        tmpList[#tmpList+1] = list

        list = {}
        for j=l_BATTLE_GRID_WIDTH,1,-1 do
            if j < iUnitPosX then
                list[#list+1] = {j,iUnitPosY}
            end
        end
        tmpList[#tmpList+1] = list

        list = {}
        for j=1,l_BATTLE_GRID_HEIGHT do
            if j > iUnitPosY then
                list[#list+1] = {iUnitPosX,j}
            end
        end
        tmpList[#tmpList+1] = list

        list = {}
        for j=l_BATTLE_GRID_HEIGHT,1,-1 do
            if j < iUnitPosY then
                list[#list+1] = {iUnitPosX,j}
            end
        end
        tmpList[#tmpList+1] = list
        
        for i=1,#tmpList do
            local list = tmpList[i]
            local diff = 0
            local first = false

            local tmpCiShu = chuantoucishu
            for j=1,#list do
                if tmpCiShu == 0 then
                    break
                end

                if j > distance and not first then
                    break
                end
                damageX = list[j][1]
                damageY = list[j][2]
                if self.kPathFinder:IsInside(damageX,damageY) then
                    local bHasTarget,aiUnitIndex = self.kPathFinder:IsTargetGrid(damageX,damageY,iTargetType,self.iUnitIndex,self.iCamp,kMartialData)
                    for iUnitIndex,v in pairs(aiUnitIndex) do
                        local kUnit = UnitMgr:GetInstance():GetUnit(iUnitIndex)
                        if kUnit and not kUnit:IsSameCamp(self.iCamp) and not kUnit:IsDeath() then
                            tmpCiShu = tmpCiShu - 1
                            first = true
                        end
                    end

                    if bHasTarget then
                        diff = 0
                    else
                        diff = diff + 1
                    end

                    if diff > 1 and first then
                        bHasTarget = false
                    end

                    gridData[#gridData + 1] = {damageX,damageY,bHasTarget}
                    gridData_hash[damageX * 100 + damageY] = bHasTarget
                end
            end
        end
    else
        for j = 1,#kDamagePosData do
            damageX = kDamagePosData[j][1] * xOffSet + iCastPosX
            damageY = kDamagePosData[j][2] * yOffSet + iCastPosY
            if self.kPathFinder:IsInside(damageX,damageY) then --伤害点在格子范围内 
                gridData[#gridData + 1] = {damageX,damageY,true}
                gridData_hash[damageX * 100 + damageY] = true
            end
        end 
    end
    return  gridData,gridData_hash
end

function Unit:HideChooseEffect()
    self.kEffectMgr:SetActorChooseEffecVisible(self:GetCamp(),false)
    self:SetFrameArrowShow(false)
end

function Unit:HideAllGridEffect()
    self:HideChooseEffect()
    LogicMain:GetInstance():ClearGridColor()
end

function Unit:ShowChooseEffect()
    if LogicMain:GetInstance():IsGridShow() then 
        self.kEffectMgr:SetActorChooseEffecVisible(self:GetCamp(),true)
        self.kEffectMgr:SetActorChooseEffectPos(self.iGridX,self.iGridY,self:GetCamp())
        self:SetFrameArrowShow(true)
    end
end

function Unit:ShowCanMoveGrid()
    if LogicMain:GetInstance():IsAutoBattle() then
        return false
    end
    LogicMain:GetInstance():ShowAllGrid(true)
    self:ShowChooseEffect()
    local canMoveGrid = self:GetCanMoveGrid()
    LogicMain:GetInstance():ShowCanMoveGrid(canMoveGrid)
    local canAttackUnitRange = self:GetAttackGridInAllSkillDamageRange()
    LogicMain:GetInstance():ShowCanAttackGrid(canAttackUnitRange)
end

function Unit:ShowSkillRange()
    self:ShowChooseEffect()
    local skillRange = self:GetSkillRangeGrid()
    LogicMain:GetInstance():ShowSkillRangeGrid(skillRange)
    LuaEventDispatcher:dispatchEvent("BATTLE_SHOW_SKILL_RANGE")
    local state = UnitMgr:GetInstance():GetChooseState()
    local canAttackUnitRange = {}
    if state == OPT_STATE.CHOOSE_SKILL then
        canAttackUnitRange = self:GetAttackGridInSkillDamageRangeByPos(self.iGridX,self.iGridY)
    elseif state == OPT_STATE.CHOOSE_POS then
        canAttackUnitRange = self:GetAttackGridInAllSkillDamageRange()
    end
    self.canAttackUnitRange = canAttackUnitRange
    LogicMain:GetInstance():ShowCanAttackGrid(canAttackUnitRange)
end

function Unit:GetMartialDamagePos(uiMartialID)
    for k,v in pairs(self.akMartialData) do
        if v.iMartialID == uiMartialID then 
            return v.aiDamagePos
        end
    end
    return {}
end
function Unit:ShowSkillDamageRange(x,y)
    local iCastPosX = 0
    local iCastPosY = 0
    local skillDamageRangeGrid = {}
    local bIsInSkillDamageRange = false
    if self:IsInCastRange(x,y) then
        iCastPosX = x
        iCastPosY = y
    elseif self:InSkillRangeGrid(x,y) then 
        local bIsAttackUnitGrid,data = self:IsAttackUnitGrid(x,y)
        if not bIsAttackUnitGrid then 
            local bHasAttackUnitGrid,data1 = self:IsIncludeAttackGrid(x,y)
            if bHasAttackUnitGrid then --在包含目标单位的攻击点范围中
                iCastPosX = data1.skillPosX
                iCastPosY = data1.skillPosY 
            else 
                bIsInSkillDamageRange,skillDamageRangeGrid = self:IsInSkillDamageRange(x,y,self.iGridX,self.iGridY)
            end    
        else--是可攻击单位的点
            iCastPosX = data.skillPosX
            iCastPosY = data.skillPosY   
        end
    end
    if iCastPosX ~= 0 and iCastPosY ~= 0 then
        local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
        local castSelfPos = self:isCastSelfPos(kMartialData.aiCastRangePos)
        if kMartialData and kMartialData.eDepartEnum == DepartEnumType.DET_HiddenWeapon and not castSelfPos then
            skillDamageRangeGrid = {{x,y,true}}
        else
            skillDamageRangeGrid = self:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,self.iGridX,self.iGridY,kMartialData.eDepartEnum)
        end   
    end
    LogicMain:GetInstance():ShowSkillDamageRangeGrid(skillDamageRangeGrid)
end

function Unit:ShowMoveUpAttackRange(x,y)
    local iCastPosX = 0
    local iCastPosY = 0
    local iMoveX = 0
    local iMoveY = 0
    local uiModleID = nil
    local skillDamageRangeGrid = {}
    local moveGrid = nil
    local bIsAttackUnitGrid,data = self:IsAttackUnitGrid(x,y)
    if bIsAttackUnitGrid then
        local bestInfo = self:GetCastPosIncludeTarget(x,y)
        if bestInfo.cx then
            iMoveX = bestInfo.mx
            iMoveY = bestInfo.my 
            iCastPosX = bestInfo.cx 
            iCastPosY = bestInfo.cy
            moveGrid = {['x']=iMoveX,['y']=iMoveY}
            if iMoveX ~= self.iGridX or iMoveY ~= self.iGridY then
                uiModleID = self.uiModleID
            end
        end
        
        if iCastPosX ~= 0 and iCastPosY ~= 0 then
            local kMartialData = self.akMartialData[self.iCurChooseSkillIndex]
            local castSelfPos = self:isCastSelfPos(kMartialData.aiCastRangePos)
            if kMartialData and kMartialData.eDepartEnum == DepartEnumType.DET_HiddenWeapon and not castSelfPos then
                skillDamageRangeGrid = {{x,y,true}}
            else
                skillDamageRangeGrid = self:GetSkillDamageRangeByPos(kMartialData,iCastPosX,iCastPosY,iMoveX,iMoveY,kMartialData.eDepartEnum)
            end
        end
        LogicMain:GetInstance():ShowMoveSkillDamageRangeGrid({skillDamageRangeGrid,self.akCurSkillCanAttackData,moveGrid,uiModleID,self.uiRoleID,self.iFace})
        self._showRedGrid = true
    else
        if self._showRedGrid then 
            self._showRedGrid = false
            LogicMain:GetInstance():ClearGridColor("Red")
            LogicMain:GetInstance():HideZhiShiObject("Red")
        end
    end
end

function Unit:ShowSkillUI()
    if LogicMain:GetInstance():IsAutoBattle() then
        return false
    end
    self:LoadChooseSkill()
    ---[todo] 这里先直接扔到ui层，后面需要初始化skilldata的时候组装好
    LuaEventDispatcher:dispatchEvent("BATTLE_REFRESH_SKILL_UI",{self.akMartialData,self.iCurChooseSkillIndex})
end

function Unit:ShowComboUI(comboInfo)
    LuaEventDispatcher:dispatchEvent("BATTLE_SHOW_COMBO",comboInfo or self.aiComboBaseID)
end

function Unit:UpdateFace() --显示上的朝向
    if self.iGridX < self.iOldGridX then
        self:SetFace(-1)
    elseif self.iGridX > self.iOldGridX  then
        self:SetFace(1)
    end
end

function Unit:FaceToPos(x) --显示上的朝向
    if self.iGridX < x then
        self:SetFace(1)
    elseif self.iGridX > x then
        self:SetFace(-1)
    end
end

function Unit:SetFaceAnim()
    self.SpineRoleUINew:SetFace(self.iFace >= 0 and 1 or -1)
end
function Unit:SetFace(iFace,boolean_anim)
    self.iFace = iFace
    if boolean_anim ~= false then
        AddTrackUnitFunc(self,0,"SetFaceAnim")
    else
        self:SetFaceAnim()
    end
end

function Unit:GetPos()
    return self.iGridX,self.iGridY
end

function Unit:GetMoveTime()
    return  self.fMoveTime
end

function Unit:GetUnitIndex()
    return self.iUnitIndex
end

function Unit:GetCamp()
    return self.iCamp
end

function Unit:IsEnemy()
    return self.iCamp == SE_CAMPB
end

function Unit:CanControl()
    if LogicMain:GetInstance():IsReplaying() then
        return false
    end

    return self.iCamp == SE_CAMPA and (self.iFlag == nil or self.iFlag == 0)
end

function Unit:NotSelfCamp()
    return self.iCamp ~= SE_CAMPA
end
function Unit:SetFlag(iFlag)
    self.iFlag = iFlag
end


function Unit:GetMAXHP()
    return self.iMAXHP
end

function Unit:GetMAXMP()
    return self.iMAXMP
end

function Unit:GetHP()
    return self.iHP
end

function Unit:GetMP()
    return self.iMP
end

function Unit:GetRoleTypeID()
    return self.uiTypeID
end

function Unit:GetName()
    return self.sName or ""
end

function Unit:GetDrawing()
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
    return typeData and typeData.Drawing or ""
end

function Unit:GetHead()
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
    return typeData and typeData.Head or ""

    -- local roleModel = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(self.uiTypeID)
    -- return roleModel and roleModel.Head or ""
end

function Unit:GetModelPath()
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
    return typeData and typeData.Model or "role_xiaobangzhu"
    -- local roleModel = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(self.uiTypeID)
    -- return roleModel and roleModel.Model or "role_xiaobangzhu"

end

function Unit:GetModelID()
    return self.uiModleID
end

function Unit:GetModelData()
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModleID)
    return typeData
end

function Unit:GetMoveDistance()
    return self.iMoveDistance
end

function Unit:GetCanMoveGrid()
    self.akCurCanMoveGrid = self.kPathFinder:GetCanMoveGrid(self.iGridX,self.iGridY,self:GetMoveDistance(),self.iUnitIndex)
    return  ReturnReadOnly(self.akCurCanMoveGrid)
end

function Unit:GetCurChooseSkillIndex()
    return  self.iCurChooseSkillIndex
end

function Unit:GetSkillCastPos()
    return self.aiSkillCastPos.x,self.aiSkillCastPos.y
end

-- 直接播放动作，不管武器
function Unit:DirPlayAnim(actionName,loop)
    do
        self.SpineRoleUINew:DirPlayAnim(actionName,loop)
        return
    end
    if getActionFrameTime(self.uiModleID,actionName) == 0 then 
        return 
    end
    if loop == nil then
		loop = false
    end
    self.curAnima = actionName
    self.skeletonAnimation.AnimationState:SetAnimation(0, actionName, loop)
end

function Unit:SetUnitAction(actionName,loop,spineaniminfo,itemID)
    do
        self.SpineRoleUINew:SetAction(actionName,loop,spineaniminfo)
        return
    end
	if loop == nil then
		loop = false
    end
    if getActionFrameTime(self.uiModleID,actionName) == 0 then 
        return 
    end

	if self.skeletonAnimation == nil or self.skeletonAnimation.AnimationState == nil or not IsValidObj(self.skeletonAnimation.gameObject) then
        return
    end
    if itemID == nil then 
        itemID = self:GetEquipItemBaseID()
        if spineaniminfo == nil then 
            spineaniminfo = self.SpineRoleUINew:GetAnimInfoByName(actionName,self:GetModelID())
        end
        -- 武器类型
        if (itemID == nil or itemID == 0 ) and spineaniminfo.type then 
            itemID = SPINE_ANIM_DEFAULT_ITEM[spineaniminfo.type]
        end
    end
    self.SpineRoleUINew:SetEquipItemEX(itemID,nil,spineaniminfo)
    -- end
    self.skeletonAnimation.AnimationState:SetAnimation(0, actionName, loop)
    self.curAnima = actionName
    self.oldItemID = itemID
end
function Unit:SetUnitIdleAction()
    do
        self.SpineRoleUINew:SetIdleAction()
        return
    end
    local itemID = self:GetEquipItemBaseID()
    local prepareName = SPINE_ANIMATION.BATTLE_IDEL
    if itemID == nil or itemID == 0 then 
        itemID = self.oldItemID
    end
    local spineaniminfo
    if itemID and itemID ~= 0 then
        local itemData = TableDataManager:GetInstance():GetTableData("Item",itemID)
        if itemData then 
            prepareName = ItemTypeToPrepareMap[itemData.ItemType] or SPINE_ANIMATION.BATTLE_IDEL
        end
        spineaniminfo = self.SpineRoleUINew:GetAnimInfoByName(prepareName,self:GetModelID())
        if itemData.ItemType == ItemTypeDetail.ItemType_Knife then 
            spineaniminfo.type = 1 -- 刀
        end
    end
    if not HasActionFrameTime(self.uiModleID,prepareName) then 
        prepareName = ROLE_SPINE_DEFAULT_ANIM
    end
    if self.curAnima == prepareName then
        return
    end
    self:SetUnitAction(prepareName,true,spineaniminfo,itemID)
    self.curAnima = prepareName
end

function Unit:LoadSpineCharacter(gridX,gridY,camp,face)
    local strPath = self:GetModelPath()

    if not IsValidObj(self.kParent) then
        dprint("kParent is nil")
        return
    end

    self.kParent:SetActive(true)

    -- self.gameObject = DRCSRef.GameObject(tostring(self.iUnitIndex));

    self.SpineRoleUINew = LoadSpineCharacterNew(strPath,self.kParent,nil,self.battleRole)
    if self.SpineRoleUINew == nil then
        dprint("load "..strPath.."is nil")
        self.uiModleID = 35
        self.SpineRoleUINew = LoadSpineCharacterNew("role_nan",self.kParent,nil,self.battleRole)
    end
    self.gameObject = self.SpineRoleUINew.gameObject
    changeShapsAlpha(self.gameObject,1)
    self.gameObject:SetActive(true)
    self.transform = self.gameObject.transform

    self.transform.name = 'unit' .. (self.uiTypeID or 0)
    self.gameObject.layer = 9
    local iNum = self.transform.childCount
	for i = 0, iNum -1  do
		local kChild = self.transform:GetChild(i)
        kChild.gameObject.layer = 9
    end

    if self.iAssistFlag == 1 or self.iAssistFlag == 2 then
        local position = GetAssistPosByGrid(gridX,gridY,self.iAssistFlag)
        self.transform.localPosition = position
    else
        local baseDepth = GetDepthByGridPos(gridX,gridY)
        self.SpineRoleUINew:SetSortingOrder(baseDepth)
        local position
        if gridX <= l_BATTLE_GRID_WIDTH/2 then
            position = GetPosByGrid(1,gridY)
            position = DRCSRef.Vec3(position.x-4,position.y,position.z)
        else
            position = GetPosByGrid(l_BATTLE_GRID_WIDTH,gridY)
            position = DRCSRef.Vec3(position.x+4,position.y,position.z)
        end
        self.transform.localPosition = position
    end
    AddTrackUnitFunc(self,0,'SetUnitIdleAction')
    self.SpineRoleUINew:SetFace(face)
    self:ResetAnimationToTime()
end

function Unit:SetCanyinSkill(skillID)
    self.SpineRoleUINew:SetCanyinSkill(skillID)
end

function Unit:addSkeletonGhost(canying)
    self.SpineRoleUINew:AddSkeletonGhost(canying)
end

function Unit:disableSkeletonGhost()
    self.SpineRoleUINew:DisableSkeletonGhost()
end

function Unit:GetXYByMountName(mount1Name,mount2Name,isOnRole,SeBattle_HurtInfo)
    return self.SpineRoleUINew:GetXYByMountName(mount1Name,mount2Name,isOnRole,SeBattle_HurtInfo)
end


function Unit:GetSkeletonRenderer()
    if self.SpineRoleUINew then 
        return self.SpineRoleUINew:GetSkeletonRenderer()
    end
end


function Unit:GetSpineNode()
    return self.SpineRoleUINew.objSpine
end
function Unit:ChangeSpineCharacter()
    if self.gameObject == nil then return end
    local strPath = self:GetModelPath()

    local result = DynamicChangeSpine(self.gameObject,strPath)
    self.gameObject:SetActive(result)

    self:ResetAnimationToTime()
end

function Unit:ResetAnimationToTime()
    local tarData = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime",self.uiModleID)
    if tarData then
        self.animationToTime = tarData
    else
        self.animationToTime = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime", 1)
    end
end

function Unit:ShowBubble(bubbleStr,showtime)
    self.SpineRoleUINew:ShowBubble(bubbleStr,showtime)
end

function Unit:SetTimeScale(timeScale)
    self.SpineRoleUINew:SetTimeScale(timeScale)
    self.attckSpeedTimeScale = timeScale;
end

function Unit:SetTimeScaleParam(timeScale)
    self.attckSpeedTimeScale = timeScale;
end

function Unit:GetTimeScale()
    return self.attckSpeedTimeScale
end

function Unit:SetPose(animationName,time)
    self.SpineRoleUINew:SetPose(animationName,time)
end

function Unit:SetActive(boolean_result)
    if self.gameObject then 
        self.gameObject:SetActive(boolean_result)
    end
end

function Unit:Clone()
    local spineuinew = LoadSpineCharacterNew(self:GetModelPath(),self.kParent,nil,self.battleRole)
    spineuinew:SetScale(SCALE_BATTLE_UNIT)
    return spineuinew
end