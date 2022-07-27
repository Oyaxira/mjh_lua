MartialStrongUI = class("MartialStrongUI",BaseWindow)

function MartialStrongUI:ctor()
end

function MartialStrongUI:Create()
	local obj = LoadPrefabAndInit("Role/MartialStrongUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function MartialStrongUI:Init()
	self.objTouchClose = self:FindChild(self._gameObject, "TouchCloseBack")
	self.btnTouchClose = self.objTouchClose:GetComponent("Button")
	self:AddButtonClickListener(self.btnTouchClose,function()
		self:CloseUI()
    end)
    self.btnTouchClose2 = self:FindChildComponent(self._gameObject, "PopUpWindow_3/Board/Button_close", "Button")
    self:AddButtonClickListener(self.btnTouchClose2,function()
		self:CloseUI()
    end)
    
	-- self.HeadImage = self:FindChildComponent(self._gameObject,"Head/Mask/Image","Image")
    self.HeadName = self:FindChildComponent(self._gameObject,"RoleName","Text")

    
    self.ItemIcon = self:FindChild(self._gameObject,"ItemIconUI")
    self.kItem = LuaClassFactory:GetInstance():GetItemIconByInst(LUA_CLASS_TYPE.ItemIconUI,self.ItemIcon)

    self.ItemName = self:FindChildComponent(self._gameObject,"MartialName","Text")
    
    self.objLeft = self:FindChild(self._gameObject,"Left")
    self.Left_title = self:FindChildComponent(self.objLeft,"Title","Text")
    self.Left_Info1 = self:FindChildComponent(self.objLeft,"Info1","Text")
    self.Left_Info2 = self:FindChildComponent(self.objLeft,"Info2","Text")
    self.Left_Info3 = self:FindChildComponent(self.objLeft,"Info3","Text")
    self.objLeftText1 = self:FindChild(self.objLeft,"Text1")
    self.objLeftText2 = self:FindChild(self.objLeft,"Text2")
    self.objLeftText3 = self:FindChild(self.objLeft,"Text3")

    self.objRight = self:FindChild(self._gameObject,"Right")
    self.objRightTitle = self:FindChild(self.objRight,"Title")
    self.objRightTitleImage = self:FindChild(self.objRight,"Image_title")
    self.Right_title = self:FindChildComponent(self.objRight,"Title","Text")
    self.Right_Info1 = self:FindChildComponent(self.objRight,"Info1","Text")
    self.Right_Info2 = self:FindChildComponent(self.objRight,"Info2","Text")
    self.Right_Info3 = self:FindChildComponent(self.objRight,"Info3","Text")
    self.objRightInfo3 = self:FindChild(self.objRight,"Info3")
    self.objRightText1 = self:FindChild(self.objRight,"Text1")
    self.objRightText2 = self:FindChild(self.objRight,"Text2")
    self.objRightText3 = self:FindChild(self.objRight,"Text3")

    -- 化境
    self.objRight2 = self:FindChild(self._gameObject,"Right2")
    self.objStateGroup = self:FindChild(self.objRight2,"StateGroup")
    self.stage = {}


    self.desc = self:FindChildComponent(self._gameObject,"Desc","Text")
    self.objDesc = self:FindChild(self._gameObject,"Desc")
    self.objSpend = self:FindChild(self._gameObject,"spend")
    self.spend = self:FindChildComponent(self._gameObject,"spend","Text")

    self.objButton_green_1 = self:FindChild(self._gameObject,"Button_green_1")
    self.Button_green_1 = self:FindChildComponent(self._gameObject,"Button_green_1","Button")
    self:AddButtonClickListener(self.Button_green_1,function()
        local itemNum = ItemDataManager:GetInstance():GetItemNumByTypeID(self.uiItemTypeID)
        if itemNum > 0 then 
            SendClickMartialStrong(self.uiRoleID,self.uiMartialTypeID,self.uiLevel)
        else
            SystemUICall:GetInstance():Toast('秘籍数量不足')
        end
    end)


    -- 特效

    self.ef_yandu = self:FindChildComponent(self._gameObject,"ef_yandu",DRCSRef_Type.ParticleSystem)
    self.ef_yandu_fail = self:FindChildComponent(self._gameObject,"ef_yandu_fail",DRCSRef_Type.ParticleSystem)



    self.objImage_arrow = self:FindChild(self._gameObject,"Image_arrow")

    
    -- 映射枚举


    self:AddEventListener("UpdateMartialStrongUI", function(retStream)
        local node = GetUIWindow("MartialStrongUI")
        if node then 
            node:ReceivedData(retStream.iResult,retStream.uiRoleID,retStream.uiMartialTypeID,retStream.uiLevel)
        end
    end)
end

function MartialStrongUI:GetStrongChangePercent(rank,type,count)
    local itemData = MartialDataManager:GetInstance():GetMartialStrongChangeData(rank,type)
    if itemData then 
        return (itemData.InitWeight or 0) + (itemData.AddWeight or 0) * count
    end
    return 0
end

function MartialStrongUI:UpdateContentInfo_Finally_Stage(index,percent,title,desc)
    if self.stage[index] == nil then 
        self.stage[index] = {}
        local objStage = self:FindChild(self.objStateGroup,"State"..index)
        if objStage then 
            self.stage[index].title = self:FindChildComponent(objStage,"Title","Text")
            self.stage[index].percent = self:FindChildComponent(objStage,"Percentage","Text")
            self.stage[index].desc = self:FindChildComponent(objStage,"Desc","Text")
        end
    end
    if self.stage[index].title then 
        self.stage[index].title.text = title
    end
    if self.stage[index].percent then 
        self.stage[index].percent.text = percent
    end
    if self.stage[index].desc then 
        self.stage[index].desc.text = desc
    end
end

function MartialStrongUI:UpdateContentInfo_Finally()
    if self.martialInst == nil then return end
    self.objRight:SetActive(false)
    self.objRight2:SetActive(true)

    -- 必然是在右边出现
    local iCount = self.martialInst.iStrongCount or 0
    local typeID = self.martialInst.uiTypeID
    local martialTypeData = GetTableData("Martial",typeID)
    local rank = martialTypeData.Rank
    -- 计算总权重
    local weight_null = self:GetStrongChangePercent(rank,MartialStrongType.EMST_NULL,iCount)
    local weight_strong = self:GetStrongChangePercent(rank,MartialStrongType.EMST_TYPE_STRONG,iCount)
    local weight_clear = self:GetStrongChangePercent(rank,MartialStrongType.EMST_TYPE_CLEAR,iCount)
    local weight_change = self:GetStrongChangePercent(rank,MartialStrongType.EMST_TYPE_CHANGE,iCount)
    local weight_strongchange = self:GetStrongChangePercent(rank,MartialStrongType.EMST_TYPE_STRONGANDCHANGE,iCount)
    local weightSum = weight_null + weight_strong + weight_clear + weight_change + weight_strongchange

    local lMartialDataManager = MartialDataManager:GetInstance()

    self:UpdateContentInfo_Finally_Stage(1,string.format("%.0f%%",(weight_strong/weightSum)*100),lMartialDataManager:GetLevelName(ENUM_MSEC_SUPER_STRONG),GetLanguageByID(730013))
    self:UpdateContentInfo_Finally_Stage(2,string.format("%.0f%%",(weight_change/weightSum)*100),lMartialDataManager:GetLevelName(ENUM_MSEC_SUPER_CHANGE),GetLanguageByID(730014))
    self:UpdateContentInfo_Finally_Stage(3,string.format("%.0f%%",(weight_clear/weightSum)*100),lMartialDataManager:GetLevelName(ENUM_MSEC_SUPER_CLEAR),GetLanguageByID(730015))
end

function MartialStrongUI:UpdateContentInfo_helper(text1,text2,text3,info1,info2,info3,level)
    if self.martialInst == nil then return end
    local martialInst = self.martialInst
    local refRetTable = MartialDataManager:GetInstance():GenMartialItemGrowDesc(MartialDataManager:GetInstance():GetMartialTypeData(martialInst.uiID), martialInst,nil,false,level)
    if #refRetTable > 0 then 
        info1.text = refRetTable[1].desc
        text1:SetActive(true)
    else
        info1.text = ""
        text1:SetActive(false)
    end
    if #refRetTable > 1 then 
        info2.text = refRetTable[2].desc
        text2:SetActive(true)
    else
        info2.text = ""
        text2:SetActive(false)
    end
    if #refRetTable > 2 then 
        info3.text = refRetTable[3].desc
        text3:SetActive(true)
    else
        info3.text = ""
        text3:SetActive(false)
    end
end
function MartialStrongUI:UpdateContentInfo(title,text1,text2,text3,info1,info2,info3,level)
    if title == nil or info1 == nil or info2 == nil or level == nil or self.martialInst == nil then return end
    local maxLevel = MartialDataManager:GetInstance():GetMaxMartialStrongLevel()
    if level > maxLevel then 
        self:UpdateContentInfo_Finally()
    else
        self.objRight2:SetActive(false)
        title.text = MartialDataManager:GetInstance():GetLevelName(level)
        local l_martialManager = MartialDataManager:GetInstance()
        -- 获取武学成长条目
        self:UpdateContentInfo_helper(text1,text2,text3,info1,info2,info3,level)
    end
end

function MartialStrongUI:RefreshUI(info)
    local roleID,martialInst = table.unpack(info,1,2)
    if roleID == nil or martialInst == nil then return end
    self.uiRoleID = roleID
    local l_itemManager = ItemDataManager:GetInstance()
    self.uiMartialTypeID = martialInst.uiTypeID
    self.uiItemTypeID = l_itemManager:GetBookItemByMartial(self.uiMartialTypeID)
    self.uiLevel = martialInst.iStrongLevel or 0
    self.sItemName = l_itemManager:GetItemName(0, self.uiItemTypeID, true)
    self.itemData = l_itemManager:GetItemTypeDataByTypeID(self.uiItemTypeID)
    self.martialInst = martialInst
    self:UpdateUI()
end

function MartialStrongUI:UpdateUI_Finally()
    -- 隐藏左右信息
    self.objLeft:SetActive(false)
    self.objRight:SetActive(false)
    self.objRight2:SetActive(false)
    self.objButton_green_1:SetActive(false)
    self.objDesc:SetActive(false)
    self.objSpend:SetActive(false)
    self.objImage_arrow:SetActive(false)

    if self.objEnd == nil then 
        self.objEnd = self:FindChild(self._gameObject,"End")
        self.comEndTitle = self:FindChildComponent(self.objEnd,"Title","Text")
        self.comEndInfo1 = self:FindChildComponent(self.objEnd,"Info1","Text")
        self.comEndInfo2 = self:FindChildComponent(self.objEnd,"Info2","Text")
        self.comEndInfo3 = self:FindChildComponent(self.objEnd,"Info3","Text")
        self.objEndText1 = self:FindChild(self.objEnd,"Text1")
        self.objEndText2 = self:FindChild(self.objEnd,"Text2")
        self.objEndText3 = self:FindChild(self.objEnd,"Text3")


    end
    local lMartialDataManager = MartialDataManager:GetInstance()

    self.objEnd:SetActive(true)
    self.comEndTitle.text = lMartialDataManager:GetLevelName(self.martialInst.iStrongLevel)
    self:UpdateContentInfo_helper(self.objEndText1,self.objEndText2,self.objEndText3,self.comEndInfo1,self.comEndInfo2,self.comEndInfo3)
end


function MartialStrongUI:UpdateUI()
    -- 更新头像
    if self.HeadName then
        local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(self.uiRoleID)
        -- local modelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
        -- self.HeadImage.sprite = GetSprite(modelData.Head)
        self.HeadName.text = RoleDataHelper.GetNameByID(self.uiRoleID)
    end
    -- 更新武学图标
    self.kItem:UpdateItemIcon(self.itemData)
    self.ItemName.text = self.sItemName
    local level = self.martialInst.iStrongLevel or 0
    local count = self.martialInst.iStrongCount or 0
    self.uiLevel = level

    local maxLevel = MartialDataManager:GetInstance():GetMaxMartialStrongLevel()
    if level > maxLevel then 
        self:UpdateUI_Finally()
        return
    else
        if self.objEnd then 
            self.objEnd:SetActive(false)
        end
        self.objButton_green_1:SetActive(true)
        self.objLeft:SetActive(true)
        self.objRight:SetActive(true)
        self:UpdateContentInfo(self.Left_title,self.objLeftText1,self.objLeftText2,self.objLeftText3,self.Left_Info1,self.Left_Info2,self.Left_Info3,level,self.martialInst)
        self:UpdateContentInfo(self.Right_title,self.objRightText1,self.objRightText2,self.objRightText3,self.Right_Info1,self.Right_Info2,self.Right_Info3,level+1,self.martialInst)
    end

    -- 更新信息
    local typeID = self.martialInst.uiTypeID
    local martialTypeData = GetTableData("Martial",typeID)
    local rank = martialTypeData.Rank
    local randomItem = MartialDataManager:GetInstance():GetMartialStrongRandomData(martialTypeData.Rank,level + 1)
    local baseSuccess = randomItem and randomItem.Success or 0
    local maxLevel = MartialDataManager:GetInstance():GetMaxMartialStrongLevel()
    if level == maxLevel then 
        self.desc.text = GetLanguageByID(730012)
        self.objDesc:SetActive(true)
    else
        self.desc.text = string.format(GetLanguageByID(730001),math.min(baseSuccess * (count + 1),100))
        self.objDesc:SetActive(true)
    end
    local itemNum = ItemDataManager:GetInstance():GetItemNumByTypeID(self.uiItemTypeID)
    self.spend.text = string.format(GetLanguageByID(730002),self.sItemName,itemNum)
    self.objSpend:SetActive(true)
end
-- 关闭等级提升界面
function MartialStrongUI:CloseUI()
	RemoveWindowImmediately('MartialStrongUI')
end

function MartialStrongUI:OnDestroy()
end

function MartialStrongUI:ReceivedData(iResult,uiRoleID,uiMartialTypeID,uiLevel)
    if self.uiRoleID == uiRoleID and self.uiMartialTypeID == uiMartialTypeID and self.uiLevel == uiLevel then 
        self:PlayEffect(iResult)
        self:UpdateUI()
    end
end

function MartialStrongUI:PlayEffect(iResult)
    if iResult == ENUM_MSEC_FAILED or iResult == ENUM_MSEC_SUPER_FAILED then -- 先用一样的
        self.ef_yandu_fail:Play()
		PlaySound(4059)
    else
        self.ef_yandu:Play()
		PlaySound(4058)
    end
end
return MartialStrongUI