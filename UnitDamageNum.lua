UnitDamageNum = class("UnitDamageNum")
function UnitDamageNum:ctor()
    self.gameObject = nil
    self.ctrlList = {}
    self.ctrlNameMap = {}
    self.textList = {}
    self.numList = {}
    self.lastNumTime = nil
end

function UnitDamageNum:Clear()
    DRCSRef.ObjDestroy(self.gameObject)
    --ReturnObjectToPool(self.gameObject)
    self.gameObject = nil
    for k, v in pairs(self) do
        self[k] = nil
    end
end

local Vec3_015 = DRCSRef.Vec3(0.015, 0.015, 0.015)
function UnitDamageNum:Init(parentObj,boneX,boneY)
    self.gameObject = LoadPrefabAndInit("Battle/Battle_NumAnimation",parentObj)
    self.gameObject.transform.localScale= Vec3_015
    if boneX == nil then 
        if parentObj then 
            local bone = parentObj.skeleton:FindBone("ref_overhead")
            if bone then 
                boneX,boneY= bone.WorldX,bone.WorldY
            end
        end
    end
    self.gameObject.transform.localPosition = DRCSRef.Vec3(boneX or 0,boneY or 0)

    self.numObj = self.gameObject:FindChild("num")
    local iNum = self.numObj.transform.childCount
	for i = 0, iNum -1  do
        local kChild = self.numObj.transform:GetChild(i).gameObject
        kChild:SetActive(false)
        table.insert(self.numList,kChild)
    end
    self.numObjRect = self.numList[1]:GetComponent("RectTransform")
    self.initNumpos = self.numList[1]:FindChild("shengming").transform.localPosition
    
    self:GetObjList("bj")
    self:GetObjList("cj")
    self:GetObjList("pz")
    self:GetObjList("sb")
    self:GetObjList("xx")
    self:GetObjList("ft")

    self.comCanvas = self.gameObject:GetComponent("Canvas")
    self.ctrlNameMap = {
        [BDEF_MISS] = "sb",
        [BDEF_POZHAO] = "pz",
        [BDEF_CEJI] = "cj",
        [BDEF_BEIJI] = "bj",
        [BDEF_REBOUND] = "ft",
    }
end

function UnitDamageNum:GetObjList(ctrlName)
    local Obj = self.gameObject:FindChild(ctrlName)
    if not self.ctrlList[ctrlName] then
        self.ctrlList[ctrlName] = {}
    end

    for i=1, Obj.transform.childCount do
        local kChild = Obj.transform:GetChild(i-1)
        local image = kChild:GetComponent("Image")
        table.insert(self.ctrlList[ctrlName],image)
        kChild.gameObject:SetActive(false)
    end
end

function UnitDamageNum:getImage(ctrlName)
    local list = self.ctrlList[ctrlName]
    if not list then
        return nil
    end

    for i=1, #list do
        if not list[i].gameObject.activeSelf or list[i].color.a == 0 then
            return list[i]
        end
    end

    return nil
end

function UnitDamageNum:SetDepth(depth)
    self.comCanvas.sortingOrder = depth
end

function UnitDamageNum:ShowText(txt,color,bBj,bHp)
    local numText = self:getEmptyNumText()
    if numText then
        numText:SetActive(true)
        local textCom = numText:GetComponent("Text")
        numText.transform.localScale = bBj and DRCSRef.Vec3(1.5,1.5,1.5) or DRCSRef.Vec3(1.2,1.2,1.2)
        textCom.color = color or DRCSRef.Color(1,1,1,1)
        textCom.text = txt

        local maxLen = 16
        local curLen = string.len(txt)
        self.sizeX = (self.numObjRect.sizeDelta.x - (self.numObjRect.sizeDelta.x)*(curLen/maxLen))/2
        local HPCtrlObj = numText:FindChild("shengming")
        local MPCtrlObj = numText:FindChild("zhenqi")
        local baojiCtrlObj = numText:FindChild("baoji")
        if bHp ~= nil then
            HPCtrlObj:SetActive(bHp)
            MPCtrlObj:SetActive(not bHp)
            if bHp then
                HPCtrlObj.transform.localPosition = DRCSRef.Vec3(self.initNumpos.x+self.sizeX,self.initNumpos.y,0)
                self:PlayDoTween(HPCtrlObj)
            else
                MPCtrlObj.transform.localPosition = DRCSRef.Vec3(self.initNumpos.x+self.sizeX,self.initNumpos.y,0)
                self:PlayDoTween(MPCtrlObj)
            end
        else
            HPCtrlObj:SetActive(false)
            MPCtrlObj:SetActive(false)
        end
        baojiCtrlObj:SetActive(bBj)
        if bBj then
            baojiCtrlObj.transform.localPosition = DRCSRef.Vec3(self.initNumpos.x+self.sizeX-40,self.initNumpos.y,0)
            self:PlayDoTween(baojiCtrlObj)
            local ImageObj = baojiCtrlObj:FindChild("Image")
            self:PlayDoTween(ImageObj)
        end
        self:PlayDoTween(numText)
    end
end

function UnitDamageNum:PlayDoTween(obj)
    local kComponents= obj.transform:GetComponents(typeof(CS.DG.Tweening.DOTweenAnimation))	
    if kComponents and kComponents.Length > 0 then
        for i=1, kComponents.Length do
            local animation = kComponents[i-1]
            if animation then
                animation:DORestart()
            end
        end
    end
end

function UnitDamageNum:GetShowText()
    if not self.textList or #self.textList == 0 then
        return
    end

    local textInfo = table.remove(self.textList, 1)
    local bBj = false
    if textInfo.flag then
        bBj = HasFlag(textInfo.flag,BDEF_CRIT)
    end
    self:ShowText(textInfo.value,textInfo.color,bBj,textInfo.bHp)
end

function UnitDamageNum:SetFinalText(value,color,bHp,flag)
    self.textList = self.textList or {}
    local time = self.lastNumTime and os.clock() - self.lastNumTime or 0

    local textInfo = {
        ["value"] = value,
        ["color"] = color,
        ["bHp"] = bHp,
        ["flag"] = flag
    }

    table.insert(self.textList,textInfo)
    
    if self.lastNumTime and time < 300 then
        globalTimer:AddTimer(300*(#self.textList), function()
            self:GetShowText()
        end)
    else
        self:GetShowText()
    end

    self.lastNumTime = os.clock()
end

function UnitDamageNum:setImageEffect(ctrlName)
    local ctrl = self:getImage(ctrlName)
    if ctrl then
        ctrl.gameObject:SetActive(false)
        ctrl.gameObject:SetActive(true)
        ctrl.color = DRCSRef.Color(1,1,1,1)
        local Animator = ctrl.gameObject:GetComponent("Animator")
        Animator.enabled = true
    end
end

--特殊文字 暴击 闪避
function UnitDamageNum:SetSpecialText(flag,ctrlName)
    if ctrlName == nil then
        for i=BDEF_MISS,BDEF_FIGHT_BACK do
            if (flag == nil or HasFlag(flag,i) )and self.ctrlNameMap[i] then
                ctrlName = self.ctrlNameMap[i]
                self:setImageEffect(ctrlName)
            end
        end
    else
        self:setImageEffect(ctrlName)
    end
end

function UnitDamageNum:getEmptyNumText()
    for i=1, #self.numList do
        local textCom = self.numList[i]:GetComponent("Text")
        if not self.numList[i].activeSelf or textCom.color.a == 0 then
            return self.numList[i]
        end
    end
    return nil
end



