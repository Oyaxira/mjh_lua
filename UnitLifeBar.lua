UnitLifeBar = class("UnitLifeBar")

function UnitLifeBar:ctor()
    self.gameObject = nil
end

function UnitLifeBar:Clear()
    if IsValidObj(self.objBuffList) then
        local iCount = self.objBuffList.transform.childCount
        local transform = self.objBuffList.transform
        if iCount > 0 then
            for i = iCount - 1,0,-1  do
                transform:GetChild(i).gameObject:SetActive(false)
            end
        end
    end

    ReturnObjectToPool(self.gameObject)
    self.gameObject = nil
    for k, v in pairs(self) do
        self[k] = nil;
    end
end
local Vec3_015 = DRCSRef.Vec3(0.017, 0.017, 0.017)
function UnitLifeBar:Init(parentObj,boneX,boneY)
    self.gameObject = LoadPrefabFromPool("Battle/Battle_LifeBar",parentObj)
    self.gameObject.transform.localScale= Vec3_015
    self.gameObject.transform:SetAsFirstSibling() -- 显示在ui对象的后面
    if boneX == nil then 
        if parentObj then 
            local bone = parentObj.skeleton:FindBone("ref_overhead")
            if bone then 
                boneX,boneY= bone.WorldX,bone.WorldY
            end
        end
    end
    self.bFirstSetMP = nil
    self.bFirstSetHP = nil
    self.gameObject.transform.localPosition = DRCSRef.Vec3(boneX or 0,boneY or 0)
    self.comCanvas = self.gameObject:GetComponent("Canvas")
    self.comCanvasGroup = self.gameObject:GetComponent("CanvasGroup")
    self.objSkillNode = self.gameObject:FindChild("skillName_bg")
    self.objSkillNode:SetActive(false)
    self.comSkillCanvasGroup = self.gameObject:FindChildComponent("skillName_bg","CanvasGroup")
    self.comSkillNameText = self.gameObject:FindChildComponent("skillName_bg/skillName_Text","Text")
    self.objNormal_LifeBar = self.gameObject:FindChild("Normal_LifeBar")
    self.objPetNameText = self.gameObject:FindChild("petname")
    self.comPetNameText = self.gameObject:FindChildComponent("petname","Text")
    self.comNameText = self.gameObject:FindChildComponent("Normal_LifeBar/Name_Text","Text")
    self.comHPImage = self.gameObject:FindChildComponent("Normal_LifeBar/HP_Image","Image")
    self.comMPImage = self.gameObject:FindChildComponent("Normal_LifeBar/MP_Image","Image")
    self.comShielfImage = self.gameObject:FindChildComponent("Normal_LifeBar/shield_Image","Image")
    self.comHPImageAnimation = self.gameObject:FindChildComponent("Normal_LifeBar/HP_Image_Animaition","Image")
    self.comMPImageAnimation = self.gameObject:FindChildComponent("Normal_LifeBar/MP_Image_Animaition","Image")
    self.comHPText = self.gameObject:FindChildComponent("Normal_LifeBar/HP_Text","Text")
    self.objBuffList = self.gameObject:FindChild("buffList")
    self.objBuff = self.gameObject:FindChild("Buff")
    self.frames_arrow = self.gameObject:FindChild("choose_arrow")
    self:ShowFramesArrow(false)
    self:FadeOut(0,false)
    
end

function UnitLifeBar:HideLife(bHide)
    self.objNormal_LifeBar:SetActive(not bHide)
end
function UnitLifeBar:SetDepth(depth)
    self.comCanvas.sortingOrder = depth
end

function UnitLifeBar:FadeOut(fadetime,bFade)
    if not bFade then
        self.comCanvasGroup.alpha = 1
    else
        return self.comCanvasGroup:DOFade(0,fadetime):SetId("BATTLE_TWEEN_ID")
    end
end

function UnitLifeBar:ShowFramesArrow(bshow)
    self.frames_arrow:SetActive(bshow)
end

function UnitLifeBar:SetCamp(eCamp)
    if eCamp ~= SE_CAMPB then
        self.comHPImage.color = getUIColor("green")
        self.comHPImageAnimation.color = getUIColor("green_half")
        self.comNameText.color = getUIColor("green")
        self.comPetNameText.color = getUIColor("green")
    else
        self.comHPImage.color = getUIColor("red")
        self.comHPImageAnimation.color = getUIColor("red_half")
        self.comNameText.color = getUIColor("red")
        self.comPetNameText.color = getUIColor("red")
    end
end

function UnitLifeBar:SetName(sName)
    self.comNameText.text = sName
    self.objNormal_LifeBar:SetActive(true)
    self.objPetNameText:SetActive(false)
end


function UnitLifeBar:SetPetName(sName)
    self.comPetNameText.text = sName
    self.objPetNameText:SetActive(true)
end

function UnitLifeBar:SetSkillName(sSkillName)
    self.objSkillNode:SetActive(true)
    self.comSkillNameText.text = sSkillName
    self.comSkillCanvasGroup.alpha = 1
    self.comSkillCanvasGroup:DR_DOFade(0,2)
end

function UnitLifeBar:SetHpText(sText)
    do return end
    self.comHPText.gameObject:SetActive(true)
    self.comHPText.text = sText
end

function UnitLifeBar:SetPercent_HP(iPercent)
    iPercent = Clamp(iPercent,0,1)
    self.comHPImage.fillAmount = iPercent
    if self.bFirstSetHP ~= nil then
        self.comHPImageAnimation.transform:DOPause()
        self.comHPImageAnimation.transform:DR_DOScaleX(iPercent,1)-- 1 时间 s
    else
        self.comHPImageAnimation.transform.localScale = DRCSRef.Vec3(iPercent,1,1)
    end
    self.bFirstSetHP = false
end

function UnitLifeBar:SetPercent_Shield(value)
    self.comShielfImage.fillAmount = value
end

function UnitLifeBar:SetPercent_MP(iPercent)
    self.comMPImage.fillAmount = iPercent
    if self.bFirstSetMP ~= nil then
        self.comMPImageAnimation.transform:DOPause()
        self.comMPImageAnimation.transform:DR_DOScaleX(iPercent,1)-- 1 时间 s
    else
        self.comMPImageAnimation.transform.localScale = DRCSRef.Vec3(iPercent,1,1)
    end
    self.bFirstSetMP = false
end

function UnitLifeBar:SetBuff(iBuffNum,akBuffData)
    if iBuffNum == nil or akBuffData == nil then return end
    local totalCount = self.objBuffList.transform.childCount
    local count = 0
    for i=1,totalCount do
        local obj = self.objBuffList.transform:GetChild(i-1)
        if IsValidObj(obj) then
            obj.gameObject:SetActive(false)
        end
    end

    local existBuff = {}
    local Local_TB_Buff = TableDataManager:GetInstance():GetTable("Buff")
    for index = 0 ,iBuffNum - 1 do
        local iBuffTypeID = akBuffData[index].iBuffTypeID
        local iRoundNum = akBuffData[index].iRoundNum
        local iLayerNum = akBuffData[index].iLayerNum
        local iBuffIndex = akBuffData[index].iBuffIndex

        if count >= 4 then
            return
        end

        local buffData = Local_TB_Buff[iBuffTypeID]
        if iRoundNum ~= 0 and buffData ~= nil and buffData.Icon and buffData.Icon ~= "" and not existBuff[iBuffTypeID] then
            local buffFeature = buffData.BuffFeature
            if not buffFeature or not buffFeature[2] or buffFeature[2] ~= BuffFeatureType.BuffFeatureType_Hide then
                local obj = nil
                if count < totalCount then
                    obj = self.objBuffList.transform:GetChild(count)
                else
                    if self.objBuffList.transform.childCount < 4 then
                        obj = CloneObj(self.objBuff,self.objBuffList)
                    end
                end

                if obj and obj.gameObject and IsValidObj(obj) then
                    obj.gameObject:SetActive(true)
                    obj:GetComponent("Image").sprite = GetSprite(buffData.Icon)
                    existBuff[iBuffTypeID] = true
                end

                count = count + 1
            end
        end
    end
end