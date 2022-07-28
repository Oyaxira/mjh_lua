NpcConsultUI = class("NpcConsultUI",BaseWindow)

local MartialUI = require 'UI/Martial/MartialUI'

local InitMartialToggle = function (uilayer, ui_clone, typeID, func)
    local comUIName_TMP = uilayer:FindChildComponent(ui_clone,"Name","Text")
    local comUILevel_TMP = uilayer:FindChildComponent(ui_clone,"Text_level","Text")
    comUILevel_TMP.text = ""
    local martialTypeData = GetTableData("Martial",typeID)
    if not martialTypeData then
        derror("武学静态数据不存在,id=" .. typeID)
        return
    end

    comUIName_TMP.text = GetLanguageByID(martialTypeData.NameID)
    comUIName_TMP.color = getRankColor(martialTypeData.Rank)
    local comUIToggle = ui_clone:GetComponent("Toggle")
    comUIToggle.group = uilayer.objListContent:GetComponent("ToggleGroup")
    if func then
        uilayer:RemoveToggleClickListener(comUIToggle)
        uilayer:AddToggleClickListener(comUIToggle, func)
    end 
end

local InitGiftToggle = function (uilayer, ui_clone, typeID, func)
    local comUIName_TMP = uilayer:FindChildComponent(ui_clone,"Name","Text")
    local comUILevel_TMP = uilayer:FindChildComponent(ui_clone,"Text_level","Text")
    comUILevel_TMP.text = ""
    local martialTypeData = TableDataManager:GetInstance():GetTableData("Gift", typeID)
    if not martialTypeData then
        derror("Gift静态数据不存在,id=" .. typeID)
        return
    end

    comUIName_TMP.text = GetLanguageByID(martialTypeData.NameID)
    comUIName_TMP.color = getRankColor(martialTypeData.Rank)
    local comUIToggle = ui_clone:GetComponent("Toggle")
    comUIToggle.group = uilayer.objListContent:GetComponent("ToggleGroup")
    if func then
        uilayer:RemoveToggleClickListener(comUIToggle)
        uilayer:AddToggleClickListener(comUIToggle, func)
    end 
end

function NpcConsultUI:Create()
	local obj = LoadPrefabAndInit("Role/NpcConsultUI",UI_UILayer,true)
	if obj then
        self:SetGameObject(obj)
        self.MartialUI = MartialUI.new(obj)
        self.MartialUI:Init('NpcConsult')
	end
end

function NpcConsultUI:OnPressESCKey()
    if self.comReturn_Button and not IsWindowOpen("RandomRollUI") then
        self.comReturn_Button.onClick:Invoke()
    end
end

function NpcConsultUI:Init()
	-- 左边武学列表
	self.left_box = self:FindChild(self._gameObject,"martial_box/left_box")
	self.comHaveMartial_TMP = self:FindChildComponent(self.left_box,"label/Number","Text")
	self.objListContent = self:FindChild(self.left_box,"SC_list/Viewport/Content")
	self.comListContent_TG = self.objListContent:GetComponent("ToggleGroup")
	self.objListTemplate = self:FindChild(self.left_box,"SC_list/Toggle_skill")
    self.comListTemplate_Toggle = self.objListTemplate:GetComponent("Toggle")
    self.comText_title = self:FindChildComponent(self._gameObject,"martial_box/Text_title","Text")
    self.comText_Martial_num = self:FindChildComponent(self._gameObject,"martial_box/Martial_num/Number","Text")
    self.comText_DispoNum = self:FindChildComponent(self._gameObject,"martial_box/DispoNum/Number","Text")
	self.objListTemplate:SetActive(false)
    -- 右侧武学分类 Toggle 组件
    self.obj_Tab_box = self:FindChild(self._gameObject,"Tab_box")
    self.obj_martial = self:FindChild(self._gameObject,"Toggle_martial")
    self.obj_gift_learn = self:FindChild(self._gameObject,"Toggle_gift")
    self.obj_martial_sel = self:FindChild(self.obj_martial,"bac")
    self.obj_gift_sel = self:FindChild(self.obj_gift_learn,"bac")
    self.Toggle_martial = self:FindChildComponent(self._gameObject,"Toggle_martial","Toggle")
    self.Toggle_gift_learn = self:FindChildComponent(self._gameObject,"Toggle_gift","Toggle")
    
    self.objNo_martial = self:FindChild(self._gameObject,"martial_box/no_martial")
	self.objNo_martial:SetActive(false)
    self.right_box = self:FindChild(self._gameObject,"martial_box/right_box")
    
	-- 门派武学介绍、人物CG、修炼条件
    self.comTextClanDisposition = self:FindChildComponent(self._gameObject,"person_info/Image/Text","Text")
	self.comImageCG = self:FindChildComponent(self._gameObject,"person_info/Mask/CG","Image")
	self.comTextMartialTip = self:FindChildComponent(self._gameObject,"person_info/Describe/Text","Text")
    self.objDescribe = self:FindChild(self._gameObject,"person_info/Describe")
	-- 修炼按钮
    self.comBtnTrain = self:FindChildComponent(self._gameObject,"train","Button")
    self.comBtnTrainImage = self:FindChildComponent(self._gameObject,"train","Image")
    self.comTextTrain = self:FindChildComponent(self._gameObject,"train/Text","Text")

    self.comBtnInspect = self:FindChildComponent(self._gameObject,"inspect","Button")
    self.comBtnInspectImage = self:FindChildComponent(self._gameObject,"inspect","Image")
    self.comTextInspect = self:FindChildComponent(self._gameObject,"inspect/Text","Text")

    self.comTextTitle = self:FindChildComponent(self._gameObject,"title_box/layout/label/Name","Text")

    self.objDetail_template = self:FindChild(self._gameObject, "right_box/SC_content/Viewport/template")
    self.objDetail_template:SetActive(false)
    self.objDetail_content = self:FindChild(self._gameObject, "right_box/SC_content/Viewport/Content")
    --self.objDetail_gift_content = self:FindChild(self._gameObject, "right_box/SC_content_Gift/Viewport/Content")
    self.objSkill_box = self:FindChild(self._gameObject, "skill_box")
    self.objExp_box = self:FindChild(self._gameObject, "exp_box")
    self.objDetail_gift  = self:FindChild(self._gameObject, "detail_gift")
	-- 返回按钮
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Button_back","Button")
	if self.comReturn_Button then
        self:AddButtonClickListener(self.comReturn_Button,function (  )
            RemoveWindowImmediately("NpcConsultUI")
            if self.isFromMarry then
                SendConsultClose(self.roleid)
                DisplayActionEnd()
                self.isFromMarry = false
            end
        end)
	end
    self.bNeedUpdate = false
	-- 注册监听
    self:AddEventListener("UPDATE_MARTIAL_DATA", function() 
        self.bNeedUpdate = true
    end)
    self:AddEventListener("UPDATE_DISPLAY_ROLE_MARTIALS", function() 
        self.bNeedUpdate = true
    end)
    self:AddEventListener("UPDATE_GIFT_DATA", function() 
        self.bNeedUpdate = true
    end)
    self:AddEventListener("DISPLAY_INTERACT_DATE_UPDATE", function() 
        self.bNeedUpdate = true
    end)
    self:AddEventListener("UPDATE_TEAM_INFO", function() 
        if (self:IsOpen() == true) then
            RemoveWindowImmediately("NpcConsultUI")
        end
    end)

    self:AddEventListener("UPDATE_DISPOSITION", function() 
        if RoleDataManager:GetInstance():IsRevengeRole(self.roleid) then
            RemoveWindowImmediately("NpcConsultUI")
        end
    end)

    self.leftToggles = {}

    self.recodeBtn = nil


    self:AddEventListener('ONEVENT_REF_CONSULTUI_DETAIL', function()
        self:UpdateDetailText()
    end)
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"frame/Btn_exit","Button")
	if self.comReturn_Button then
        self:AddButtonClickListener(self.comReturn_Button,function (  )
            RemoveWindowImmediately("NpcConsultUI")
            if self.isFromMarry then
                SendConsultClose(self.roleid)
                DisplayActionEnd()
                self.isFromMarry = false
            end
        end)
	end
end

-- 更新门派武学列表
function NpcConsultUI:UpdateWithTypeIDs(list, isgift)
    local initItemFunc = isgift and InitGiftToggle or InitMartialToggle
    if #list > 1 then
        local Local_TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
        table.sort( list, function(typeIDA, typeIDB)
            local typeDataA = isgift and Local_TB_Gift[typeIDA] or GetTableData("Martial",typeIDA) 
            local typeDataB = isgift and Local_TB_Gift[typeIDB] or GetTableData("Martial",typeIDB)
            if typeDataA.Rank ~= typeDataB.Rank then
                return typeDataA.Rank < typeDataB.Rank
            else
                return typeDataA.BaseID < typeDataB.BaseID
            end
        end )
    end
    for i=1, #self.leftToggles do
        self:RemoveToggleClickListener(self.leftToggles[i])
    end

    self.leftToggles = {}

    RemoveAllChildren(self.objListContent)

    local bFirst = true
    local uiNums = 0
    for i=1, #list do
        if self:CheckTypeIDAvailable(list[i], isgift) then
            uiNums = uiNums + 1
            local ui_clone = CloneObj(self.objListTemplate, self.objListContent)
            if (ui_clone ~= nil) then
                ui_clone:SetActive(true)
                initItemFunc(self, ui_clone, list[i], function(bool)
                    if bool then
                        self:UpdateDetail(list[i], isgift)
                    end
                end)
    
                local comtoggle = ui_clone:GetComponent("Toggle")
                self.leftToggles[#self.leftToggles + 1] = comtoggle
    
                if bFirst then
                    comtoggle.isOn = true
                    bFirst = false
                end
            end
        end
    end

    if isgift then
        self.comHaveMartial_TMP.text = string.format("%d/%d", uiNums, uiNums)		-- 武学数量
    else
        self.comHaveMartial_TMP.text = string.format("%d/%d", uiNums, RoleDataManager:GetInstance():GetMartialNumMax())
    end	

    if uiNums == 0 then
        self:SetEmpty()
    end
end

function NpcConsultUI:Update()
    self.MartialUI:Update()
    if self.bNeedUpdate then
        self.bNeedUpdate = false
        self:UpdateDetail(self.curTypeID, self.isGift) 
    end
end

function NpcConsultUI:SetEmpty()
    self.comBtnTrain.interactable = false
    setUIGray(self.comBtnTrainImage,true)
    self.comTextClanDisposition.text = "" 
    self:RemoveButtonClickListener(self.comBtnTrain)
   
    self.comBtnInspect.interactable = false
    setUIGray(self.comBtnInspectImage,true)
    self:RemoveButtonClickListener(self.comBtnInspect)  

    RemoveAllChildren(self.objSkill_box)
    RemoveAllChildren(self.objDetail_content)
end

-- 刷新右侧详细信息
function NpcConsultUI:UpdateDetailText()
    local isgift = self.isGift 
    local rolename = RoleDataManager:GetInstance():GetRoleName(self.roleid)
    local favorData = RoleDataManager:GetInstance():GetDispotionDataToMainRole(self.roleid)
    self.comText_DispoNum.text = string.format( "%s好感度：%d",rolename,favorData and favorData.iValue or 0 )
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    if not isgift then
        local curNum = RoleDataManager:GetInstance():GetRoleMartialNum()
        local maxNum = RoleDataManager:GetInstance():GetMartialNumMax()
        self.comText_Martial_num.text = string.format( "我的武学：%d/%d",curNum,maxNum)
    else 
        local curGift = GiftDataManager:GetInstance():GetDynamicGift(mainRoleID)
        local curNum =  getTableSize(curGift) or 0
        local maxNum = RoleDataManager:GetInstance():GetGiftNumMax()
        self.comText_Martial_num.text = string.format( "我的天赋：%d/%d",curNum,maxNum)
    end 
end 

-- 刷新右侧详细信息
function NpcConsultUI:UpdateDetail(typeID, isgift)
    self.curTypeID = typeID
    self.isGift = isgift
    
	if not WindowsManager:GetInstance():IsWindowOpen("RandomRollUI") then
        self:UpdateDetailText()
    end 


    if not isgift then
        local typeData = GetTableData("Martial",typeID)
        if typeData then
            self.objExp_box:SetActive(true)
            self.objSkill_box:SetActive(true)
            self.MartialUI:UpdateDetail(nil, typeData)
            --self.objDetail_gift_content:SetActive(false)
            self.objDetail_content:SetActive(true)
            self.objDetail_gift:SetActive(false)
        end
    else
        self.objDetail_content:SetActive(false)
        self.objDetail_gift:SetActive(true)
        self:InitGiftItemDes(self.comTextTitle, self.objDetail_gift, typeID)
        -- local ui_clone = self:LoadGameObjFromPool(self.objDetail_template,self.objDetail_content.transform)
        self.objExp_box:SetActive(false)
        self.objSkill_box:SetActive(false)
        self.MartialUI.objTitleClassText:SetActive(false)
		self.MartialUI.objTitleClanText:SetActive(false)
		self.MartialUI.objTitleTagText:SetActive(false)
    end

	local bCanLearn, sbtnDes, npcdes, bRefresh, toastTips = self:CheckConsult(typeID, isgift)
    self.comBtnTrain.interactable = not bRefresh
    local canGray = false
    if bRefresh then
        canGray = true
    else
        canGray = not bCanLearn
    end
    
    setUIGray(self.comBtnTrainImage,canGray)
    self.comTextTrain.text = sbtnDes
    self.comTextClanDisposition.text = npcdes
    
    self:RemoveButtonClickListener(self.comBtnTrain)
    self:AddButtonClickListener(self.comBtnTrain,function ()
        if bCanLearn then
            if typeID then
                if bRefresh then
                    local info = {type = NPCIT_REFRESH_CONSULT , uiRoleID = self.roleid}
                    OpenWindowByQueue("GeneralRefreshBoxUI", info)
                    self.recodeBtn = "comBtnTrain"
                else
                    self.recodeBtn = nil
                    SendNPCInteractOperCMD(isgift and NPCIT_CONSULT_GIFT or NPCIT_CONSULT_MARTIAL, self.roleid, typeID)
                end
            end
        else
            if toastTips ~= nil then
                SystemUICall:GetInstance():Toast(toastTips)
            end
        end
    end)

    local bCanLearn, sbtnDes, bCanRefresh = self:CheckSteel(typeID, isgift)
    self.comBtnInspect.interactable = bCanLearn
    self.comTextInspect.text = sbtnDes
    canGray = false
    if bCanRefresh then
        canGray = true
    else
        canGray = not bCanLearn
    end
    
    setUIGray(self.comBtnInspectImage,canGray)
    self:RemoveButtonClickListener(self.comBtnInspect)
    self:AddButtonClickListener(self.comBtnInspect,function()
        if typeID then
            if bCanRefresh then
                local info = {type = NPCIT_REFRESH_STEEL, uiRoleID = self.roleid}
                OpenWindowByQueue("GeneralRefreshBoxUI", info)
                self.recodeBtn = "comBtnInspect"
            else
                local okfunc = function()
                    SendNPCInteractOperCMD(isgift and NPCIT_STEAL_GIFT or NPCIT_STEAL_MARTIAL, self.roleid, typeID)
                end

                local tipStr = self:GenSteelTips()
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, tipStr, okfunc})
                self.recodeBtn = nil
            end   
        end
    end)

    self.objDescribe:SetActive(not isgift)
    if not isgift then
        local martialTypeData = GetTableData("Martial",typeID)
        if martialTypeData then
            self.comTextMartialTip.text = GetLanguageByID(martialTypeData.DesID) or ""
        else
            self.comTextMartialTip.text = ""
        end
    end
end

function NpcConsultUI:GenSteelTips()
    local dbdata = nil
    if self.isGift then
        dbdata = TableDataManager:GetInstance():GetTableData("Gift",self.curTypeID)
    else
        dbdata = GetTableData("Martial",self.curTypeID)
    end
    if dbdata then
        local TB_Probability = TableDataManager:GetInstance():GetTable("Probability")
        for i=1, #TB_Probability do
            local kProbability = TB_Probability[i]
            if kProbability.TargetRank == dbdata.Rank and kProbability.PlayerBehavior == PlayerBehaviorType.PBT_TouXue then
                targetProblility = kProbability
            end
        end
    end
    
    if targetProblility then
        local tips = string.format( "若观摩成功，将降低%0.f点好感度", -targetProblility.SuccHaoGanChange)
        
        if self.clanid then
            local dbClanData = TB_Clan[self.clanid]
            
            if dbClanData then
                local clanname = GetLanguagePreset(dbClanData.NameID, tostring(dbClanData.NameID) )
                tips = tips .. string.format('和%s%0.f好感度', clanname, -targetProblility.SuccClanHaoGanChange)
            end
        end
        tips = tips .. string.format('，同时降低%0.f仁义值。', -targetProblility.SuccShanEChange)
        tips = tips .. string.format('若观摩失败，将会降低角色好感度%0.f点，是否观摩？', -targetProblility.FailHaoGanChange)
        return tips
    end

    return ''
end

-- 界面刷新，数据初始化
function NpcConsultUI:RefreshUI(paramlist)
    local roleID = paramlist[1]
    self.isFromMarry = paramlist[2]

    local transform = self.obj_Tab_box.transform
    for i = 1, transform.childCount - 1 do
        transform:GetChild(i).gameObject:SetActive(false)
    end

    self.roleid = roleID
    local roleData = RoleDataManager:GetInstance():GetRoleData(self.roleid)
    local roletypeid = roleData.uiTypeID
    
    local dbRoleData = TB_Role[roletypeid]
    local akMartialTypeIDsTemp = table_c2lua(roleData:GetMartials())
    local akGiftTypeIDsTemp = table_c2lua(roleData:GetGifts())
    
    local akMartialTypeIDs = {}
    for i=1, #akMartialTypeIDsTemp do
        if self:CheckTypeIDAvailable(akMartialTypeIDsTemp[i], false) then
            akMartialTypeIDs[#akMartialTypeIDs + 1] = akMartialTypeIDsTemp[i]
        end
    end

    local akGiftTypeIDs = {}
    for i=1, #akGiftTypeIDsTemp do
        if self:CheckTypeIDAvailable(akGiftTypeIDsTemp[i], true) then
            akGiftTypeIDs[#akGiftTypeIDs + 1] = akGiftTypeIDsTemp[i]
        end
    end

    self.clanid = RoleDataHelper.GetRoleClan(roleData, dbRoleData)

    self:RemoveToggleClickListener(self.Toggle_martial)
    self:RemoveToggleClickListener(self.Toggle_gift_learn)

    self:AddToggleClickListener(self.Toggle_martial, function(ison)
        if ison then
            self.comText_title.text = "拥有武学"
            self.obj_martial_sel:SetActive(true)
            self:UpdateWithTypeIDs(akMartialTypeIDs, false)
        else
            self.obj_martial_sel:SetActive(false)
        end
    end)

    self:AddToggleClickListener(self.Toggle_gift_learn, function(ison)
        if ison then
            self.comText_title.text = "拥有天赋"
            self.obj_gift_sel:SetActive(true)
            self:UpdateWithTypeIDs(akGiftTypeIDs, true)
        else
            self.obj_gift_sel:SetActive(false)
        end
    end)
    
    if #akGiftTypeIDs == 0 then
        self.obj_gift_learn:SetActive(false)
    else
        self.obj_gift_learn:SetActive(true)
        self.Toggle_gift_learn.isOn = true
        self.comText_title.text = "拥有天赋"
        self:UpdateWithTypeIDs(akGiftTypeIDs, true)
    end

    if #akMartialTypeIDs == 0 then
        self.obj_martial:SetActive(false)
    else
        self.obj_martial:SetActive(true)
        self.Toggle_martial.isOn = true 
        self.comText_title.text = "拥有武学"
        self:UpdateWithTypeIDs(akMartialTypeIDs, false)
    end

	-- 更新门派长老 CG
    local drawing = RoleDataHelper.GetDrawing(dbRoleData)
	if drawing then
        self.comImageCG.sprite = GetSprite(drawing)
        self.comImageCG:SetNativeSize()
    end

    if  #akMartialTypeIDs == 0 and #akGiftTypeIDs == 0 then
        RemoveWindowImmediately("NpcConsultUI")
        SystemUICall:GetInstance():Toast("没有可以观摩请教的武学和天赋")
        if self.isFromMarry then
            SendConsultClose(self.roleid)
            DisplayActionEnd()
            self.isFromMarry = false
        end
    end
end

function NpcConsultUI:FindGift(typeID)
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    return GiftDataManager:GetInstance():InstRoleHaveGift(mainRoleID,typeID)
end

function NpcConsultUI:CheckTypeIDAvailable(typeID, isgift)
    local typeData = nil
    if isgift then
        typeData = TableDataManager:GetInstance():GetTableData("Gift",typeID)
    else
        typeData = GetTableData("Martial",typeID)
    end
    if not typeData then
        return false
    end

    if isgift and typeData.GiftType and typeData.GiftType == GiftType.GT_Adventure then
        if GiftDataManager:GetInstance():HasMoreLevelAdvGift(typeData) then
            return false
        end
    end
    
    if isgift then
        local flag = typeData.GiftFlag or {}
        for i=1, #flag do
            if flag[i] == GiftFlagType.GFT_WatchEnable then
                return true
            end
        end
    else
        --其实是不可掉落的意思
        return typeData.Drop == TBoolean.BOOL_NO
    end
    return false
end

function NpcConsultUI:OnDestroy()
    self.MartialUI:Close()
    self:RemoveToggleClickListener(self.Toggle_martial)
    self:RemoveToggleClickListener(self.Toggle_gift_learn)
    self:RemoveEventListener('ONEVENT_REF_CONSULTUI_DETAIL');

end

function NpcConsultUI:CheckMartialCondition(roleID, martialBaseID)
    local roleData = RoleDataManager:GetInstance():GetMainRoleData()
    local clanBaseID = 0
    local condDesc = ''
    if roleData then 
        clanBaseID = roleData.uiClanID or 0
    end
    local canLearnMartial = true
    local martialDataManager = MartialDataManager:GetInstance()
    local condTypeList, condValueList = martialDataManager:GetMartialLearnCondition(martialBaseID, clanBaseID, false)
    for index, condType in ipairs(condTypeList) do 
        local condValue = condValueList[index] or 0
        local prefix = '<color=#1A1A1A>'
        if not martialDataManager:CheckMartialLearnConditionByType(clanBaseID, martialBaseID, condType, condValue) then 
            prefix = '<color=#C53926>'
            canLearnMartial = false
        end
        if condDesc ~= '' then
            condDesc = condDesc .. '\n'
        end
        if condValue >= 6000 then
            condDesc = condDesc .. "<color=#C1AE0F>调整中，暂不开放学习</color>"
        else
            condDesc = condDesc .. prefix .. martialDataManager:GetMartialLearnConditionTypeText(condType) .. "达到" .. condValue .. '</color>'
        end
    end
    return canLearnMartial, condDesc
end

function NpcConsultUI:CheckConsult(typeID, isgift)
    if not typeID then
        return false, ""
    end
    local dbdata = nil
    if isgift then
        dbdata = TableDataManager:GetInstance():GetTableData("Gift",typeID)
    else
        dbdata =  GetTableData("Martial",typeID)
    end
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    local favorData = RoleDataManager:GetInstance():GetDispotionDataToMainRole(self.roleid)

    local targetProblility = nil
    local TB_Probability = TableDataManager:GetInstance():GetTable("Probability")
    for i=1, #TB_Probability do
        local kProbability = TB_Probability[i]
        if kProbability.TargetRank == dbdata.Rank and kProbability.PlayerBehavior == PlayerBehaviorType.PBT_QingJiao then
            targetProblility = kProbability
        end
    end

    local conditionDes = '好感度' .. (targetProblility and tostring(targetProblility.HaoGanLimit))
    if isgift then
        conditionDes = conditionDes --.. ' 天赋点 >= ' .. dbdata.Cost
    end

    if not isgift and MartialDataManager:GetInstance():InstRoleHaveMartial(mainRoleID, typeID) then
        return false, '已修炼', '已学会该武学',nil,"已修炼"
    end

    -- 非冒险天赋 需要判断天赋上限
    if isgift and dbdata.GiftType ~= GiftType.GT_Adventure and (not GiftDataManager:GetInstance():CheckRoleGiftNum(mainRoleID)) then
        return false, '无法请教', conditionDes, nil, "已经到达天赋上限"
    end

    if isgift and self:FindGift(typeID) then
        return false, '已修炼', '已学会该天赋',nil,"已修炼"
    end

    if not targetProblility then
        return false, '当面请教', "未找到db数据",nil,"未找到db数据"
    end
    
    if isgift and dbdata.Cost > RoleDataManager:GetInstance():GetMainRoleRemainGiftPoint() then
        return false, '无法请教', conditionDes, nil, "天赋点不足"
    end

    if not isgift and (not MartialDataManager:GetInstance():CheckRoleMartialNum(mainRoleID)) then
        return false, '无法请教', conditionDes, nil, "已经达到武学上限"
    end

    if not isgift then
        local martialCondDes = ''
        local canLearnMartial = false
        canLearnMartial, martialCondDes = self:CheckMartialCondition(self.roleid, typeID)
        conditionDes = conditionDes .. martialCondDes
        if not canLearnMartial then 
            return false, '无法请教', conditionDes, nil, "武学学习条件不满足"
        end
    end

    local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.roleid, NPCIT_STEAL_CONSULT)
    if not bAvailable then
        local resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()
		local des = '剩余' .. resDayStr .. '天'
		return true, des, conditionDes, true
    end

    if targetProblility.HaoGanLimit <= favorData.iValue then
        if isgift then
            if dbdata.Cost <= RoleDataManager:GetInstance():GetMainRoleRemainGiftPoint() then
                return true, '当面请教', conditionDes  
            else
                return false, '当面请教', conditionDes, nil, '天赋点不足'
            end
        else
            return true, '当面请教', conditionDes
        end
    else
        return false, '无法请教', conditionDes, nil, "好感度不足"
    end
end

function NpcConsultUI:CheckSteel(typeID, isgift)
    if not typeID then
        return false, ""
    end
    
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()

    if not isgift and MartialDataManager:GetInstance():InstRoleHaveMartial(mainRoleID, typeID) then
        return false, '已修炼'
    end

    if isgift and (not GiftDataManager:GetInstance():CheckRoleGiftNum(mainRoleID)) then
        return false, '无法观摩'
    end

    if isgift and self:FindGift(typeID) then
        return false, '已修炼'
    end

    local dbdata = nil
    if isgift then
        dbdata = TableDataManager:GetInstance():GetTableData("Gift",typeID)
    else
        dbdata = GetTableData("Martial",typeID)
    end

    if isgift and dbdata.Cost > RoleDataManager:GetInstance():GetMainRoleRemainGiftPoint() then
        return false, '无法观摩'
    end

    if not isgift and (not MartialDataManager:GetInstance():CheckRoleMartialNum(mainRoleID)) then
        return false, '无法观摩'
    end

    if not isgift then
        local martialCondDes = ''
        local canLearnMartial = false
        canLearnMartial, martialCondDes = self:CheckMartialCondition(self.roleid, typeID)
        if not canLearnMartial then 
            return false, '无法观摩'
        end
    end

    local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.roleid, NPCIT_STEAL_CONSULT)
    if not bAvailable then
        local resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()
        local des = '剩余' .. resDayStr .. '天'
		return true, des, true
    end
    
    return true, '暗中观摩'
end

function NpcConsultUI:InitGiftItemDes(comTextTitle, objItem, giftTypeID)
    
    local _Gift = TableDataManager:GetInstance():GetTableData("Gift", giftTypeID)
    if _Gift == nil then
        dprint("Error，天赋表不存在此ID：".. giftTypeID)
        return
    end

    dprint("创建天赋，giftID为：%d,名字：%s", giftTypeID, GetLanguageByID(_Gift.NameID))


    comTextTitle.text = GetLanguagePreset(_Gift.NameID,"天赋名".._Gift.NameID)
    -- comTextTitle.color = getRankColor(_Gift.Rank)
     
    local icon = self:FindChildComponent(objItem, 'Icon_unlock', 'Image')
    icon.color = getRankColor(_Gift.Rank)
    
    local label = self:FindChildComponent(objItem, 'Label', 'Text')
    label.text = '描述'
    label.color = getRankColor(_Gift.Rank)

    local des = self:FindChildComponent(objItem, 'Text', 'Text')
    des.text  = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID)
    des.color = getRankColor(_Gift.Rank)

    local labeloutline = self:FindChildComponent(objItem, 'Label', 'OutlineEx')
    labeloutline.OutlineWidth = 1
    local desloutline = self:FindChildComponent(objItem, 'Text', 'OutlineEx')
    desloutline.OutlineWidth = 1
end

function NpcConsultUI:QuickSkip()
    do return true end

    if self.recodeBtn == nil then
        return false
    end

    if self.recodeBtn == "comBtnTrain" then
        self.comBtnTrain.onClick:Invoke()
    elseif self.recodeBtn == "comBtnInspect" then
        self.comBtnInspect.onClick:Invoke()
    end
    return true
end

return NpcConsultUI