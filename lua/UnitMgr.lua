UnitMgr = class("UnitMgr")
UnitMgr._instance = nil

local lChoose_State = OPT_STATE    --CHOOSE_POS, --选择位置中 CHOOSE_SKILL, --选择技能中 CHOOSE_END, --选择结束


function UnitMgr:ctor()
    self.kPathFinder = PathFinder:GetInstance()

    self.iIndexID = 0 --自增id
    self.akAllUnit = {}
    self.akAllAssistUnit = {}
    self.kCurOptUnit = nil
    self:SetChooseState(lChoose_State.CHOOSE_END)
    self.handle = {}
    self.kCurMoveUnit = nil
    self.kOldMoveUnit = nil
end

function UnitMgr:GetInstance()
    if UnitMgr._instance == nil then
        UnitMgr._instance = UnitMgr.new()
        UnitMgr._instance:BeforeInit()
    end
    return UnitMgr._instance
end

function UnitMgr:BeforeInit()
    self.handle.UnitMoveGrid = function(tb) self:UI_Move_Grid(tb[1],tb[2]) end
    self.handle.BattleUIReelectPos = function() self:BattleUI_ReelectPos() end
    self.handle.BattleUIChangeSkill = function(iSkillIndex) self:BattleUI_ChangeSkill(iSkillIndex) end
    LuaEventDispatcher:addEventListener("UI_MOVE_GRID",self.handle.UnitMoveGrid)
    LuaEventDispatcher:addEventListener("BattleUI_ReelectPos",self.handle.BattleUIReelectPos)
    LuaEventDispatcher:addEventListener("UI_CHANGE_SKILL",self.handle.BattleUIChangeSkill)
end

function UnitMgr:Clear()
    self.iIndexID = 0
    for k,v in pairs(self.akAllUnit) do
        v:Clear()
        self.akAllUnit[k] = nil
    end
    for k,v in pairs(self.akAllAssistUnit) do
        v:Clear()
        self.akAllAssistUnit[k] = nil
    end
    self.akAllAssistUnit = {}
    self.deadlist = {}
    self.kCurOptUnit = nil
    self:SetChooseState(lChoose_State.CHOOSE_END)
end

function UnitMgr:UI_Click_Grid(x,y)
    if not self.kCurOptUnit then return end
    if not self.kCurOptUnit:CanControl() then return end
    LogicMain:GetInstance():HideZhiShiObject()
    if self.eChooseState == lChoose_State.CHOOSE_POS then
        local bIsAttackUnitGrid,data = self.kCurOptUnit:IsAttackUnitGrid(x,y)
        TimeLineHelper:GetInstance():Reset()
        TimeLineHelper:GetInstance():SetCanUpdate(true)
        if bIsAttackUnitGrid then
            local iCastPosX = 0
            local iCastPosY = 0
            local iMoveX = 0
            local iMoveY = 0
            local bestInfo = self.kCurOptUnit:GetCastPosIncludeTarget(x,y)
            if bestInfo.cx then
                iMoveX = bestInfo.mx
                iMoveY = bestInfo.my
                iCastPosX = bestInfo.cx
                iCastPosY = bestInfo.cy
            end
            if self.kCurOptUnit:CurSkillIsFly() then
                iMoveX = x
                iMoveY = y 
                iCastPosX = x
                iCastPosY = y 
            end

            if iCastPosX ~= 0 and iCastPosY ~= 0 then
                local bMoveSuccess = true
                local bUseSkillSUccess = self.kCurOptUnit:UseSkill(iCastPosX,iCastPosY)
                if bUseSkillSUccess then 
                    if iMoveX ~= self.kCurOptUnit.iGridX or iMoveY ~= self.kCurOptUnit.iGridY then
                        bMoveSuccess = self.kCurOptUnit:SetPos(iMoveX,iMoveY)
                    end
                end

                if bMoveSuccess and bUseSkillSUccess then
                    self.kCurOptUnit:SetUnitSelectGrid(x,y)
                    TimeLineHelper:GetInstance():SetOverCallback(
                        function()
                            LuaEventDispatcher:dispatchEvent("BattleUI_UnitEndTurn",true)
                        end
                    )
                else
                    self:BattleUI_ReelectPos()
                end
            end
        else
            if LogicMain:GetInstance():CanMove(x,y) then 
                self.kCurOptUnit:SetPos(x,y)
                self:SetChooseState(lChoose_State.CHOOSE_SKILL)
                self.kCurOptUnit:ShowSkillRange()
                LuaEventDispatcher:dispatchEvent("BATTLE_CLICK_GRID_MOVE")
            end
        end
    elseif self.eChooseState == lChoose_State.CHOOSE_SKILL then
        local iSkillCastX = nil
        local iSkillCastY = nil
        local bIsAttackUnitGrid,data = self.kCurOptUnit:IsAttackUnitGrid(x,y)
        if not bIsAttackUnitGrid then --是可攻击单位的目标点
            -- 点的是空地
            -- 2020-6-19 修改判定方法，将原选择最佳释放位置改为直接判断玩家选择的点能否释放
            local bHasAttackUnitGrid,data1 = self.kCurOptUnit:IsIncludeAttackGrid(x,y)
            if bHasAttackUnitGrid then
                iSkillCastX = data1.skillPosX
                iSkillCastY = data1.skillPosY
            end    
        else
            -- 点的是敌人
            iSkillCastX = data.skillPosX
            iSkillCastY = data.skillPosY
        end
        
        if iSkillCastX and iSkillCastY then
            local bSuccess = self.kCurOptUnit:UseSkill(iSkillCastX,iSkillCastY)
            if bSuccess then
                self.kCurOptUnit:SetUnitSelectGrid(x,y)
                LuaEventDispatcher:dispatchEvent("BattleUI_UnitEndTurn",true)
            else
                LogicMain:GetInstance():ShowSkillDamageRangeGrid({})
            end
        end
    end
end

function UnitMgr:UI_Move_Grid(x,y)
    if not self.kCurOptUnit then return end
    if self.eChooseState == lChoose_State.CHOOSE_SKILL then
        self.kCurOptUnit:ShowSkillDamageRange(x,y)
    elseif self.eChooseState == lChoose_State.CHOOSE_POS then
        self.kCurOptUnit:ShowMoveUpAttackRange(x,y)
    end
end

function UnitMgr:BattleUI_ReelectPos()
    if not self.kCurOptUnit then return end

    self.kCurOptUnit:RollBackPos()
    self.kCurOptUnit:ShowCanMoveGrid()
    self:SetChooseState(lChoose_State.CHOOSE_POS)
end

function UnitMgr:BattleUI_ChangeSkill(iSkillIndex)
    if self.kCurOptUnit ~= nil then
        LogicMain:GetInstance():HideZhiShiObject()
        self.kCurOptUnit:ChangeSkillChoose(iSkillIndex)
        if self.eChooseState == lChoose_State.CHOOSE_SKILL then
            self.kCurOptUnit:ShowSkillRange()
        end
    end
end

function UnitMgr:GetChooseState()
    return  self.eChooseState
end

function UnitMgr:CreatUnit(kParent,kUnitData,startTime,isImmediately)
    local uiTypeID = kUnitData['uiTypeID']
    if uiTypeID == 0 then
        derror("uiTypeID is 0 , not exist")
        uiTypeID = 1000001001
    end
    local uiModleID = kUnitData['uiModleID']
    local iUnitIndex = kUnitData['uiUnitIndex']
    local kUnit = Unit.new()
    kUnit:Init(kParent, kUnitData,uiModleID,uiTypeID,startTime,isImmediately)
    if self.akAllUnit[iUnitIndex] ~= nil then
        derror("iUnitIndex not Alone")
    end
    self.akAllUnit[iUnitIndex] = kUnit
    LuaEventDispatcher:dispatchEvent("BATTLE_CREATE_UNIT",iUnitIndex)
    return kUnit
end

function UnitMgr:HideLife(bHide)
    for k,v in pairs(self.akAllUnit) do
        v:HideLife(bHide)
    end
end

function UnitMgr:ShowActionNode(iUnitIndexID,iFlag)
    local moveQueue_unit = {}
    local iIndex = 0
    local kCurOptUnit = self.akAllUnit[iUnitIndexID]
    iFlag = iFlag or 0

    for k,v in pairs(self.akAllUnit) do
        if v.iAssistFlag == 0 then
            iIndex = iIndex + 1
            moveQueue_unit[iIndex] = v
        end
    end
    
    local showData = {}
    showData['unit'] = kCurOptUnit
    local iIdnex = 1
    for i = 1, #moveQueue_unit do
        local kUnit = moveQueue_unit[i]
        if not kUnit:IsDeath() then
            local data = {}
            data.fMovePercent = kUnit.fOptNeedTime / kUnit.fMoveTime
            data.iCamp = kUnit:GetCamp()
            data.iUnitIndex = kUnit:GetUnitIndex()
            data.uiRoleTypeID = kUnit:GetRoleTypeID()
            data.uiModleID = kUnit:GetModelID()
            showData[iIdnex] = data
            iIdnex = iIdnex + 1
        end
    end
    if (kCurOptUnit) then
        showData['minDelay'] = kCurOptUnit.old_fOptNeedTime / 10000
        kCurOptUnit:SetFlag(iFlag)
    end
    
    showData['skipRound'] = iFlag > 0
    LuaEventDispatcher:dispatchEvent("BATTLE_SHOW_MOVE_ICON_QUEUE",showData)
end

function UnitMgr:ShowRole(boolean_show,boolean_showAttacker,boolean_showDefender,boolean_hideOther)
    for k,unit in pairs(self.akAllUnit) do
        -- TODO:hurtinfo 分析攻击者 受击者
        unit:Show(boolean_show)
    end
end
function  UnitMgr:HasUnit(iUnitIndex)
    if iUnitIndex == nil then return false end
    return self.akAllUnit[iUnitIndex] ~= nil
end

function  UnitMgr:GetUnit(iUnitIndex)
    if iUnitIndex == nil then return end
    return self.akAllUnit[iUnitIndex]
end

function  UnitMgr:GetUnitAssist(iTypeID,eCamp)
    if iTypeID == nil then return end
    for k,info in pairs(self.akAllAssistUnit) do
        if iTypeID == info.uiTypeID and IsSameCamp(eCamp,info.iCamp) then 
            return info
        end
    end
end

function UnitMgr:GetAllUnit()
    return self.akAllUnit
end

function UnitMgr:GetCurOptUnit()
    return  self.kCurOptUnit
end

function UnitMgr:OptOver()
    self:SetChooseState(lChoose_State.CHOOSE_END)
    LuaEventDispatcher:dispatchEvent("BATTLE_OPTOVER")
    LogicMain:GetInstance():ShowAllGrid(false)
    self.kCurOptUnit = nil
end
function UnitMgr:SetChooseState(state)
    self.eChooseState = state
end


function UnitMgr:SetCurOperationalUnit(iUnitIndexID)
    if self.kCurOptUnit then
        self.kCurOptUnit:HideChooseEffect()
    end
    self.kCurOptUnit = self.akAllUnit[iUnitIndexID]
    
    if self.kCurMoveUnit then  
        self.kOldMoveUnit = self.kCurMoveUnit
        -- 此处将上一次的移动角色 的剩余时间 重置
        --self.kCurMoveUnit.fOptNeedTime = self.kCurMoveUnit.fMoveTime
    end
    self.kCurMoveUnit = nil
    -- self.kOldMoveUnit = nil
    if self.kCurOptUnit ~= nil then --服务器不用下发 阵营b？
        self:SetChooseState(lChoose_State.CHOOSE_POS)
    end
    EffectMgr:GetInstance():SetActorChooseEffectPos(self.kCurOptUnit.iGridX,self.kCurOptUnit.iGridY,self.kCurOptUnit:GetCamp())
end

function UnitMgr:AutoBattle() --[todo]需要动画播完 才能上发
    if not self.kCurOptUnit then return end
    self.kCurOptUnit:HideAllGridEffect()
    if self.kCurOptUnit:CanControl() then
        local uiIndex = self.kCurOptUnit:GetUnitIndex()
        LogicMain:GetInstance():SendAutoCmd(uiIndex)
        self:OptOver()
    end
end

function UnitMgr:CreateAssistUint(kParent,kUnitAssistData,iIndex)
    local uiTypeID = kUnitAssistData['uiTypeID']
    if uiTypeID == 0 then
        uiTypeID = 1000001001
    end
    local y = SSD_BATTLE_GRID_HEIGHT + 1
    local AssitPos = {{1,y},{2,y},{3,y},{1,y+1},{2,y+1},{3,y+1}}
    local depth = {11,11,11,10,10,10}
    if iIndex > #AssitPos then 
        iIndex = #AssitPos
    end
    local camp = kUnitAssistData['eCamp']
    local bpet = kUnitAssistData['bPet']
    local uiLevel = kUnitAssistData['uiLevel']
    local uiModel = kUnitAssistData['uiMoedlID']
    local UnitAssist = UnitAssist.new()
    UnitAssist:Init(kParent, uiTypeID, bpet, camp, AssitPos[iIndex],uiLevel,depth[iIndex],uiModel)
    self.akAllAssistUnit[iIndex] = UnitAssist
end

function UnitMgr:GetPetInfo()
    if self.akAllAssistUnit then 
        for k,v in pairs(self.akAllAssistUnit) do
            local petData = TableDataManager:GetInstance():GetTableData("Pet",v.uiTypeID)
            if petData then 
                local level = CardsUpgradeDataManager:GetInstance():GetPetLevel(v.uiTypeID)
                local value = petData.Attr2Init + petData.Attr2Grow * (level - petData.Attr2Level)
                if level >= petData.Attr2Level and petData.Attr2 == PetAttrType.PAT_ADDROLEEXP then 
                    LogicMain:GetInstance():RecordAwardInfo(string.format("%s加成角色经验+%.0f%%",GetLanguageByID(petData.NameID),value))
                elseif level >= petData.Attr2Level and petData.Attr2 == PetAttrType.PAT_ADDMARTIALEXP then 
                    LogicMain:GetInstance():RecordAwardInfo(string.format("%s加成武学经验+%.0f%%",GetLanguageByID(petData.NameID),value))
                end
            end
        end
    end
end

function UnitMgr:GetPetTipsInfo(camp)
    if self.akAllAssistUnit then 
        local embattleData = {}
        local allpetdata = {}
        for k,v in pairs(self.akAllAssistUnit) do
            if v.iCamp == camp then 
                local uid = v.uiTypeID
                if 0 == v.bpet then 
                    local instdata = RoleDataManager:GetInstance():GetInstRoleByTypeID(uid)
                    if instdata then 
                        uid = instdata.uiID
                    end
                end
                table.insert(embattleData,{
                    ['bPet'] = v.bpet,
                    ['uiRoleID'] = uid,
                })

                table.insert(allpetdata,{
                    ['uiBaseID'] = uid,
                    ['uiFragment'] = v.uiLevel
                })
            end
        end
        return RoleDataManager:GetInstance():GetAssistTipsInfo(embattleData,allpetdata)
    end
end

function UnitMgr:OnDestroy()
    LuaEventDispatcher:removeEventListener("UI_MOVE_GRID",self.handle.UnitMoveGrid)
    LuaEventDispatcher:removeEventListener("BattleUI_ReelectPos",self.handle.BattleUIReelectPos)
    LuaEventDispatcher:removeEventListener("UI_CHANGE_SKILL",self.handle.BattleUIChangeSkill)
    self.handle = nil
    self:Clear()
end

function UnitMgr:IsSameCamp(uIDA,uIDB)
    local unitA = self:GetUnit(uIDA)
    local unitB = self:GetUnit(uIDB)
    if unitA and unitB then 
        return unitA:IsSameCamp(unitB:GetCamp())
    end
    return false
end