SkillIconUI = class("SkillIconUI", BaseWindow)

function SkillIconUI:ctor(obj)
end

function SkillIconUI:ResetColdTimeUI(obj)
    self.comColdTimeText = self:FindChildComponent(obj, "ColdTime/Text", DRCSRef_Type.Text)
    self.comColdTimeImage = self:FindChildComponent(obj, "ColdTime/Mark", DRCSRef_Type.Image)
    self.comColdTimeText.text = ''
    self.comColdTimeImage.fillAmount = 0
end

function SkillIconUI:UpdateUI(obj, skillID, isCombo, isLock, unlock_level, coldTime)
    if not (obj and skillID) then return end
    self:ResetColdTimeUI(obj)
    skillID = toint(skillID)    -- [TODELETE] 要改一下表头
    self:UpdateSkillIcon(obj, skillID)
    self:UpdateLockState(obj, isLock, unlock_level)
    self:UpdateCombo(obj, isCombo)
end

function SkillIconUI:SetChoose(obj,boolean)
    if boolean == nil then
        boolean = false
    end 
    local objAoyiFrame = self:FindChild(obj, "skill_choose")
    objAoyiFrame:SetActive(boolean)
end

-- TODO: 更新技能图标
function SkillIconUI:UpdateSkillIcon(obj, skillID)
    if obj == nil then obj = self._gameObject end
    local comFrameImage = self:FindChildComponent(obj, "Icon","Image")
    local objBorder = self:FindChild(obj, "border")
    local comBorderImage = objBorder:GetComponent('Image')
    local objBorderAoYi = self:FindChild(obj, "border_aoyi")
    local objImageAoYi = self:FindChild(obj, "aoyi")
    local objImageJuexue = self:FindChild(obj, "juexue")
    local objSkillChoose = self:FindChild(obj, "skill_choose")
    local objAoyiFrame = self:FindChild(obj, "frames_aoyi")
    objImageAoYi:SetActive(false)
    objImageJuexue:SetActive(false)
    objSkillChoose:SetActive(false)
    objAoyiFrame:SetActive(false)

    local skillTypeData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
    if not skillTypeData then 
        return 
    end
    local skillIcon = skillTypeData.Icon
    if skillIcon then 
        comFrameImage.sprite = GetSprite(skillIcon)
    end

    -- 更新边框
    if comBorderImage then
        comBorderImage.sprite = GetAtlasSprite("CommonAtlas", RANK_SKILL_BORDER[skillTypeData.Rank])
    end

    -- 更新 奥义 标识
    if skillTypeData.Type == SkillType.SkillType_aoyi then
        objBorderAoYi:SetActive(true)
        objBorder:SetActive(false)
        objImageAoYi:SetActive(true)
        objAoyiFrame:SetActive(true)
    else
        objBorderAoYi:SetActive(false)
        objBorder:SetActive(true)
        objImageAoYi:SetActive(false)
        objAoyiFrame:SetActive(false)
    end

    -- 更新 绝招 标识
    if skillTypeData.Type == SkillType.SkillType_juezhao then
        objImageJuexue:SetActive(true)
    else
        objImageJuexue:SetActive(false)
    end
end

-- 设置层数/等级
function SkillIconUI:SetLayer(obj, value)
    if obj == nil then obj = self._gameObject end
    if not obj then return end
    local objLayerBack = self:FindChild(obj, "layer_back")
    if not objLayerBack then return end
    local comLayerText = self:FindChildComponent(objLayerBack, "Text", "Text")
    if not comLayerText then return end

    if type(value) == 'number' then
        objLayerBack:SetActive(true)
        comLayerText.text = string.format( "%d", toint(value) )
    else
        objLayerBack:SetActive(false)
    end
end

-- TODO：更新技能连招线，奥义 和 绝招 都没有
function SkillIconUI:UpdateCombo(obj, isCombo)
    if obj == nil then obj = self._gameObject end
    local objCombo = self:FindChild(obj, "combo")
    if objCombo then
        objCombo:SetActive(isCombo or false)
    end
end

-- TODO: 更新锁定状态
function SkillIconUI:UpdateLockState(obj, isLock, unlock_level)
    if obj == nil then obj = self._gameObject end
    local objLock = self:FindChild(obj, "lock_box")
    local objneed_spirit = self:FindChild(objLock, "need_spirit")
    if objneed_spirit then
        objneed_spirit:SetActive(false) -- 默认隐藏真气不足
    end
    local comText_TMP = self:FindChildComponent(objLock, "Text", "Text")
    if objLock then
        if isLock then
            objLock:SetActive(true)
            if dnull(unlock_level) then
                comText_TMP.text = string.format("%d级", unlock_level)
            else
                comText_TMP.text = "未解锁"
            end
        else
            objLock:SetActive(false)
        end
    end
end

-- TODO: 更新锁定状态
function SkillIconUI:SetMPLock(obj, isLock)
    if obj == nil then obj = self._gameObject end
    local objLock = self:FindChild(obj, "lock_box")
    local objneed_spirit = self:FindChild(objLock, "need_spirit")
    local objText_TMP = self:FindChild(objLock, "Text")
    local objback = self:FindChild(objLock, "back")
    local objlock = self:FindChild(objLock, "lock")
    local banned = self:FindChild(objLock, "banned")
    objText_TMP:SetActive(false)
    objback:SetActive(false)
    objlock:SetActive(false)
    banned:SetActive(false)
    if objLock then
        if isLock then
            objLock:SetActive(true)
            objneed_spirit:SetActive(true)
        else
            objLock:SetActive(false)
            objneed_spirit:SetActive(false)
        end
    end
end

function SkillIconUI:SetBannedLock(obj, isLock)
    if obj == nil then obj = self._gameObject end
    local objLock = self:FindChild(obj, "lock_box")
    local objneed_spirit = self:FindChild(objLock, "need_spirit")
    local banned = self:FindChild(objLock, "banned")
    local objText_TMP = self:FindChild(objLock, "Text")
    local objback = self:FindChild(objLock, "back")
    local objlock = self:FindChild(objLock, "lock")
    objText_TMP:SetActive(false)
    objback:SetActive(false)
    objlock:SetActive(false)
    objneed_spirit:SetActive(false)
    if objLock then
        if isLock then
            objLock:SetActive(true)
            banned:SetActive(true)
        else
            objLock:SetActive(false)
            banned:SetActive(false)
        end
    end
end

function SkillIconUI:SetTipsText(obj, text)
    local textObj = self:FindChild(obj, "Text_tips")
    if text == nil then 
        textObj:SetActive(false)
    else
        local textTips = self:FindChildComponent(obj, "Text_tips", "Text")
        if textTips then
            textTips.text = text
            textObj:SetActive(true)
        end
    end
end

SkillIconUIInst = SkillIconUI.new()
return SkillIconUI