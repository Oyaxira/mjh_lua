SkillIconUINew = class("SkillIconUINew", BaseWindow)

function SkillIconUINew:Create(kParent)
	local obj = LoadPrefabAndInit("Game/SkillIconUI",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SkillIconUINew:Init()
    self.imageIcon = self:FindChildComponent(self._gameObject, "Icon","Image")
    self.imageBorder = self:FindChildComponent(self._gameObject, "border","Image")
    self.objBorderAoYi = self:FindChild(self._gameObject, "border_aoyi")

    self.objImageAoYi = self:FindChild(self._gameObject, "aoyi")
    self.objImageJuexue = self:FindChild(self._gameObject, "juexue")
    self.objSkillChoose = self:FindChild(self._gameObject, "skill_choose")
    self.objAoyiFrame = self:FindChild(self._gameObject, "frames_aoyi")
    self.objLayerBack = self:FindChild(self._gameObject, "layer_back")
    if self.objLayerBack then 
        self.objLayerBack:SetActive(false)
    end
    self.comLayerText = self:FindChildComponent(self._gameObject, "Text", "Text")
    self.objLock = self:FindChild(self._gameObject, "lock_box")
    self.textLockText = self:FindChildComponent(self._gameObject, "lock_box/Text","Text")
    self.textTips = self:FindChildComponent(self._gameObject, "Text_tips","Text")
	self.textTips.gameObject:SetActive(false)
    self.objneed_spirit = self:FindChild(self._gameObject, "lock_box/need_spirit")
    self.objneed_spirit:SetActive(false) -- 默认隐藏真气不足

    self.comColdTimeText = self:FindChildComponent(self._gameObject, "ColdTime/Text", DRCSRef_Type.Text)
    self.comColdTimeImage = self:FindChildComponent(self._gameObject, "ColdTime/Mark", DRCSRef_Type.Image)

    self.objCombo = self:FindChild(self._gameObject, "combo")
    self:InitButtonListener()
end

function SkillIconUINew:OnEnable()
    if not IsValidObj(self._gameObject) then
        return
    end
    if not self.canvasGroup then
        self.canvasGroup = self._gameObject:GetComponent("CanvasGroup")
    end
    if self.canvasGroup then
        self.canvasGroup.blocksRaycasts = true
    end
end

function SkillIconUINew:OnDisable()
    if not IsValidObj(self._gameObject) then
        return
    end
    if not self.canvasGroup then
        self.canvasGroup = self._gameObject:GetComponent("CanvasGroup")
    end
    if self.canvasGroup then
        self.canvasGroup.blocksRaycasts = false
    end
end


function SkillIconUINew:InitButtonListener()
    local button = self:FindChildComponent(self._gameObject,"Icon","Button")
    local func = function()   
        local tips = TipsDataManager:GetInstance():GetSkillTips(self.martialData,self.iSkillID,self.iMartialBaseID)
        if tips == nil then return end
        if self.funcGetBtns then
            self.buttons = self.funcGetBtns()
        end
        if self.parentType then
            if self.parentType == 'IsEmbattle' then
                tips.movePositions = {
                    x = 0,
                    y = 150
                }
            elseif self.parentType == 'Clan' then
                tips.movePositions = {
                    x = 280,
                    y = 50
                }
            elseif self.parentType == 'Character' then
                tips.movePositions = {
                    x = -280,
                    y = 50
                }
            end
        end
        tips.isSkew = true
        SystemUICall:GetInstance():TipsPop(tips, self.buttons)
    end
    self:AddButtonClickListener(button, fun)

    local comUIAction = self:FindChildComponent(self._gameObject,"Icon","LuaUIAction")
    comUIAction:SetPointerEnterAction(function()
        func()
    end)
    comUIAction:SetPointerExitAction(function()
        RemoveWindowImmediately("TipsPopUI")
    end)
end

function SkillIconUINew:UpdateUI(skillID, isCombo, isLock, unlock_level, coldTime, martialBaseID)
    if skillID == nil then
        return
    end
    skillID = toint(skillID)
    self:UpdateSkillIcon(skillID)
    self:UpdateLockState(isLock, unlock_level)
    self:UpdateCombo(isCombo)
    self:UpdateColdTime(coldTime, martialBaseID)
end

-- 设置层数/等级
function SkillIconUINew:SetLayer(value)
    if not self.objLayerBack or not self.comLayerText then
        return
    end

    if type(value) == 'number' then
        self.objLayerBack:SetActive(true)
        self.comLayerText.text = string.format( "%d", toint(value) )
    else
        self.objLayerBack:SetActive(false)
    end
end

function SkillIconUINew:SetTipsValue(martialData,iSkillID,btns,funcGetBtns,iBaseID)
    self.martialData = martialData
    self.iSkillID = iSkillID
    if btns then
        self.buttons = btns
    elseif funcGetBtns then
        self.funcGetBtns = funcGetBtns
    end
    self.iMartialBaseID = iBaseID
end

function SkillIconUINew:ToPoolClear()
    self.martialData = nil
    self.iSkillID = nil
    self.buttons = nil
    self.funcGetBtns = nil
    self.iMartialBaseID = nil
end

-- TODO: 更新技能图标
function SkillIconUINew:UpdateSkillIcon(skillID)
    self.objSkillChoose:SetActive(false)
    local skillTypeData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
    if not skillTypeData then 
        return 
    end

    local skillIcon = skillTypeData.Icon
    if self.imageIcon and skillIcon then 
        self.imageIcon.sprite = GetSprite(skillIcon)
    end

    -- 更新边框
    if self.imageBorder then
        self.imageBorder.sprite = GetAtlasSprite("CommonAtlas", RANK_SKILL_BORDER[skillTypeData.Rank])
    end

    -- 更新 奥义 标识
    if skillTypeData.Type == SkillType.SkillType_aoyi then
        self.objBorderAoYi:SetActive(true)
        self.imageBorder.gameObject:SetActive(false)
        self.objImageAoYi:SetActive(true)
        self.objAoyiFrame:SetActive(true)
    else
        self.objBorderAoYi:SetActive(false)
        self.imageBorder.gameObject:SetActive(true)
        self.objImageAoYi:SetActive(false)
        self.objAoyiFrame:SetActive(false)
    end

    -- 更新 绝招 标识
    if skillTypeData.Type == SkillType.SkillType_juezhao then
        self.objImageJuexue:SetActive(true)
    else
        self.objImageJuexue:SetActive(false)
    end
end

-- TODO: 更新锁定状态
function SkillIconUINew:UpdateLockState(isLock, unlock_level)
    if self.objLock then
        if isLock then
            self.objLock:SetActive(true)
            if dnull(unlock_level) then
                self.textLockText.text = string.format("%d级", unlock_level)
            else
                self.textLockText.text = "未解锁"
            end
        else
            self.objLock:SetActive(false)
        end
    end
end

-- TODO：更新技能连招线，奥义 和 绝招 都没有
function SkillIconUINew:UpdateCombo(isCombo)
    if self.objCombo then
        self.objCombo:SetActive(isCombo or false)
    end
end

function SkillIconUINew:UpdateColdTime(coldTime, martialBaseID)
    if self.comColdTimeText then 
        if coldTime and coldTime > 0 then 
            self.comColdTimeText.gameObject:SetActive(true)
            self.comColdTimeText.text = tostring(coldTime)
        else
            self.comColdTimeText.gameObject:SetActive(false)
        end
    end
    
    if self.comColdTimeImage then 
        if coldTime and coldTime > 0 then 
            self.comColdTimeImage.gameObject:SetActive(true)
            local maxColdTime = MartialDataManager:GetInstance():GetMartialMaxColdTime(martialBaseID)
            local percent = 1
            if maxColdTime > 0 then 
                percent = coldTime / maxColdTime
            end
            self.comColdTimeImage.fillAmount = percent
        else
            self.comColdTimeImage.gameObject:SetActive(false)
        end
    end
end

return SkillIconUINew