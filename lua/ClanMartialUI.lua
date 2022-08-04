ClanMartialUI = class("ClanMartialUI",BaseWindow)
local MartialUI = require 'UI/Martial/MartialUI'

local martial_condition = {
    [RankType.RT_White] = 10,
    [RankType.RT_Green] = 20,
    [RankType.RT_Blue] = 40,
    [RankType.RT_Purple] = 60,
    [RankType.RT_Orange] = 90,
    [RankType.RT_Golden] = 100,
    --[RankType.RT_DarkGolden] = '不传',
}

local UPDATE_TYPE =
{
    ["UpdateMartialByRole"] = 1,
    ["UpdateEmbattleMartial"] = 2,
}

function ClanMartialUI:Create()
	local obj = LoadPrefabAndInit("Role/ClanMartialUI",UI_UILayer,true)
	if obj then
        self:SetGameObject(obj)
	end

	-- 新建一份 MartialUI 的代码，并传入界面
	self.MartialUI = MartialUI.new(obj)
    self.MartialUI:Init('Clan')
    
    self.objLearnWindowTabUI = self:FindChild(self._gameObject, "LearnWindowTabUI")
    self.objTabBox = self:FindChild(self.objLearnWindowTabUI, "TransformAdapt_node_right/Tab_box")

    self.objcomToggle_Temp = self:FindChild(self.objLearnWindowTabUI, "TransformAdapt_node_right/Toggle_temp")

    self.objinspect = self:FindChild(self._gameObject,'inspect')
    self.objinspect:SetActive(false)
    self.objcomToggle_Temp:SetActive(false)
    self.all_tabsbtn = {}
    self.objToggles = {}
end

function ClanMartialUI:Init()
	-- 右侧武学分类 Toggle 组件
    -- self.comToggle_junior = self:FindChildComponent(self.objTabBox,"Toggle_junior","Toggle")
    -- self.comToggle_senior = self:FindChildComponent(self.objTabBox,"Toggle_senior","Toggle")
	-- self.comToggle_suppress = self:FindChildComponent(self.objTabBox,"Toggle_suppress","Toggle")
	
	-- 门派武学介绍、人物CG、修炼条件
    self.comTextClanDisposition = self:FindChildComponent(self._gameObject,"person_info/Image/Text","Text")
	self.comImageCG = self:FindChildComponent(self._gameObject,"person_info/Mask/CG","Image")
	self.comTextMartialTip = self:FindChildComponent(self._gameObject,"person_info/Describe/Text","Text")

    self.Text_info = self:FindChildComponent(self._gameObject,"martial_box/Text_info","Text")
	-- 修炼按钮
    self.comBtnTrain = self:FindChildComponent(self._gameObject,"train","Button")
    self.comImgBtnTrain = self:FindChildComponent(self._gameObject,"train","Image")
    self.comTextTrain = self:FindChildComponent(self._gameObject,"train/Text","Text")

	-- 返回按钮
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"frame/Btn_exit","Button")
	if self.comReturn_Button then
        self:AddButtonClickListener(self.comReturn_Button,function ()
            RemoveWindowImmediately("ClanMartialUI", false)
            DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
        end)
	end

	-- 注册监听
    self:AddEventListener("UPDATE_MARTIAL_DATA", function() 
        self:UpdateDetail(self.curMartialTypeID) 
    end)
    self:AddEventListener("UPDATE_DISPLAY_ROLE_MARTIALS", function() 
        self.MartialUI:UpdateMartialNum()
        self:UpdateDetail(self.curMartialTypeID) 
    end)
end

function ClanMartialUI:OnPressESCKey()
    RemoveWindowImmediately("ClanMartialUI", false)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
end

function ClanMartialUI:Update()
    self.MartialUI:Update()
end

function ClanMartialUI:OnEnable()
    -- OpenWindowBar({
    --     ['windowstr'] = "ClanMartialUI", 
    --     ['titleName'] = "门派武学",
    --     ['topBtnState'] = {
    --         ['bBackBtn'] = false,
    --         ['bGoodEvil'] = true,
    --         ['bSilver'] = true,
    --         ['bCoin'] = true,
    --     },
    --     ['bSaveToCache'] = false,
    -- })
end

function ClanMartialUI:OnDisable()
    --RemoveWindowBar('ClanMartialUI')
end

-- 更新门派武学列表
function ClanMartialUI:UpdateWithMartialIDs(martial_list)
    for i= #martial_list,1,-1 do 
        if not GetTableData("Martial",martial_list[i]) then
            table.remove(martial_list,i)
        end 
    end 
    if #martial_list > 1 then
        table.sort( martial_list, function(typeIDA, typeIDB)
            local typeDataA = GetTableData("Martial",typeIDA)
            local typeDataB = GetTableData("Martial",typeIDB)
            if typeDataA.Rank ~= typeDataB.Rank then
                return typeDataA.Rank < typeDataB.Rank
            else
                return typeDataA.BaseID < typeDataB.BaseID
            end
        end )
    end
	
    -- 调用 MartialUI 更新
    self.MartialUI:UpdateMartial(martial_list, true)
    for i = 1, #self.MartialUI.martial_toggle do
        self:RemoveToggleClickListener(self.MartialUI.martial_toggle[i])
        self:AddToggleClickListener(self.MartialUI.martial_toggle[i], function(bool)
            if bool then
                self:UpdateDetail(martial_list[i])
            end
        end)
        if i == 1 then
            self:UpdateDetail(martial_list[1])
        end
	end
end

-- 刷新右侧详细信息
function ClanMartialUI:UpdateDetail(martialTypeID)
	self.curMartialTypeID = martialTypeID

	-- 调用 MartialUI 更新
    self.MartialUI:UpdateDetail(nil,GetTableData("Martial",martialTypeID))
    
    -- 加载material
    if not self.grayMat then
        self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
    end
    
    -- 修炼按钮更新能否学习
    -- 如果已修炼

    if MartialDataManager:GetInstance():InstRoleHaveMartial(RoleDataManager:GetInstance():GetMainRoleID(),martialTypeID) then
        self.comBtnTrain.interactable = false
        self.comImgBtnTrain.material = self.grayMat
        self.comTextTrain.text = "已修炼"
        self.comTextClanDisposition.text = "已修炼"
        return
    end

    if GiftDataManager:GetInstance():InstRoleHaveGift(RoleDataManager:GetInstance():GetMainRoleID(),martialTypeID) then
        self.comBtnTrain.interactable = false
        self.comImgBtnTrain.material = self.grayMat
        self.comTextTrain.text = "已修炼"
        self.comTextClanDisposition.text = "已修炼"
        return
    end
    

    local bCanLearn, sDes, conditionIdx, condition = self:CheckCanLearn(martialTypeID)
    
    self.comBtnTrain.interactable = bCanLearn
    self.comTextTrain.text = bCanLearn and "修炼" or "不可修炼"
    if bCanLearn then
        self.comImgBtnTrain.material = nil
    else
        self.comImgBtnTrain.material = self.grayMat
    end
	self.comTextClanDisposition.text = sDes or ""
    self:RemoveButtonClickListener(self.comBtnTrain)
    local onClickCallback = nil
    -- 是否需要使用燃木令学习?
    if condition == ClanMartialConfig.CMT_RanMuLing then
        onClickCallback = function()
            local type = GeneralBoxType.COMMON_TIP
            local showContent = {
                ['title'] = "修炼武学",
                ['text'] = "是否消耗一枚燃木令, 学习该武学?",
            }
            local callBack = function()
                SendClanMartialLearnCMD(self.uiClanTypeID, martialTypeID, 0)
            end
            OpenWindowImmediately('GeneralBoxUI', {type, showContent, callBack})
        end
    else
        onClickCallback = function()
            SendClanMartialLearnCMD(self.uiClanTypeID, martialTypeID, 0)
        end
    end
    self:AddButtonClickListener(self.comBtnTrain, onClickCallback)
end

function ClanMartialUI:SetTag_ZANGJINGGE(binZangJingGe)
    self.inZangJingGe = binZangJingGe
end

function ClanMartialUI:GetTag_ZANGJINGGE()
    self.inZangJingGe = self.inZangJingGe or false
    return self.inZangJingGe
end

function ClanMartialUI:RefreshZangJingGe(uiMartialTypeIDs)
    self:SetTag_ZANGJINGGE(true)
    for i,comitem in ipairs(self.all_tabsbtn) do 
        -- comitem.onValueChanged:RemoveAllListeners()
        self:RemoveToggleClickListener(comitem)
    end 
    --self.objTabBox:SetActive(false)
    self:UpdateWithMartialIDs(uiMartialTypeIDs)
end
-- 界面刷新，数据初始化
function ClanMartialUI:RefreshUI(configArray)
    local isClan = configArray[1]
    local uiClanTypeID = configArray[2]
    local auiMartialTypeIDs = configArray[3]

    self.objLearnWindowTabUI:SetActive(true)
    self.uiClanTypeID = uiClanTypeID
    local clandata = TB_Clan[uiClanTypeID]

    self:ShowInfo()

    self.clan_tab_map = {}
    local tabname = {'拳掌','刀法','腿法','剑法','奇门','暗器','内功','初级','高级','镇派'}
    self.clan_tab_map['拳掌'] = clandata.Fist or nil
    self.clan_tab_map['刀法'] = clandata.Knife  or nil
    self.clan_tab_map['腿法'] = clandata.Leg  or nil
    self.clan_tab_map['剑法'] = clandata.Sword  or nil
    self.clan_tab_map['奇门'] = clandata.Stick  or nil
    self.clan_tab_map['暗器'] = clandata.Dart  or nil
    self.clan_tab_map['内功'] = clandata.Magic  or nil
    if clandata.DiyName1 then 
        if not self.clan_tab_map[clandata.DiyName1 ] and clandata.DiyName1 ~= '其他' then 
            table.insert(tabname,clandata.DiyName1)
        end
        self.clan_tab_map[clandata.DiyName1 ] = clandata.DiyKungfu1 
    end 
    if clandata.DiyName2 then 
        if not self.clan_tab_map[clandata.DiyName2 ] and clandata.DiyName2 ~= '其他' then 
            table.insert(tabname,clandata.DiyName2)
        end
        self.clan_tab_map[clandata.DiyName2 ] = clandata.DiyKungfu2 
    end 
    if self.clan_tab_map == {} then 
        self.clan_tab_map['初级'] = clandata.BasicMartial
        self.clan_tab_map['高级'] = clandata.HighMartial
        self.clan_tab_map['镇派'] = clandata.BestMartial
    end
    tabname[#tabname+1] = '其他'

    if isClan then
        local bFirst = true 
        local iCount = 1
        for i,sTabName in ipairs(tabname) do 
            local listMartials = self.clan_tab_map[sTabName]
            if listMartials and #listMartials > 0 then 
                local ui_clone = nil
                local comtoggle_clone = nil
                if #self.objToggles >= iCount then
                    ui_clone = self.objToggles[iCount]
                    comtoggle_clone = self.all_tabsbtn[iCount]
                else
                    ui_clone = CloneObj(self.objcomToggle_Temp, self.objTabBox)
                    if (ui_clone ~= nil) then
                        ui_clone:SetActive(true)
                        comtoggle_clone = ui_clone:GetComponent("Toggle")
                        self.objToggles[#self.objToggles + 1] = ui_clone
                        self.all_tabsbtn[#self.all_tabsbtn + 1] = comtoggle_clone
                    end
                end
                iCount = iCount + 1
                local comUIName_TMP = self:FindChildComponent(ui_clone,"Text","Text")
                comUIName_TMP.text = sTabName
                 
                self:RemoveToggleClickListener(comtoggle_clone)
                self:AddToggleClickListener(comtoggle_clone, function(ison)
                    if ison then
                        self:UpdateWithMartialIDs(listMartials)
                    end
                end)
                if bFirst then 
                    if comtoggle_clone then
                        comtoggle_clone.isOn = true
                    end
                    self:UpdateWithMartialIDs(listMartials)
                    bFirst = false
                end                 
            end 
        end 

        for index= iCount,#self.objToggles do
            local obj = self.objToggles[index]
            if obj then
                obj:SetActive(false)
            end
        end
    else
        self:RefreshZangJingGe(auiMartialTypeIDs or {})
        local bFirst = true 
        for i,iMartialID in pairs(auiMartialTypeIDs or {}) do 
            local ui_clone = CloneObj(self.objcomToggle_Temp, self.objTabBox)
            if (ui_clone ~= nil) then
                ui_clone:SetActive(true)
                comtoggle_clone = ui_clone:GetComponent("Toggle")
                self.objToggles[#self.objToggles + 1] = ui_clone
                self.all_tabsbtn[#self.all_tabsbtn + 1] = comtoggle_clone
                local comUIName_TMP = self:FindChildComponent(ui_clone,"Text","Text")
                local typeData = GetTableData("Martial",iMartialID)
                comUIName_TMP.text = GetEnumText('DepartEnumType', typeData.DepartEnum)
                self:RemoveToggleClickListener(comtoggle_clone)
            end
            if bFirst then 
                if comtoggle_clone then
                    comtoggle_clone.isOn = true
                end
                bFirst = false
            end  
        end
        
    end
	-- 更新门派长老 CG
    local kRoleTypeData = TB_Role[clandata.Teacher]
    if kRoleTypeData then
        local drawing = RoleDataHelper.GetDrawing(kRoleTypeData)
        if self.comImageCG and drawing then
            self.comImageCG.sprite = GetSprite(drawing)
            self.comImageCG:SetNativeSize()
        end
    end
end

function ClanMartialUI:GenDes(condTypeList, condValueList)
    local des = ''
    local ranMuLingCount = ItemDataManager:GetInstance():GetItemNumByTypeID(80603)
    local des_HaoGan = nil
    local des_RenYiZhi = nil

    if #condTypeList > 0 and #condTypeList == #condValueList then
        for index, condType in ipairs(condTypeList) do
            if condType == ClanMartialConfig.CMT_HaoGanDu then
                des_HaoGan = "门派好感达到" .. tostring(condValueList[index]) .. ' '
            elseif condType == ClanMartialConfig.CMT_RanMuLing and self:GetTag_ZANGJINGGE() then
                des = des .. "消耗燃木令" .. tostring(condValueList[index]) .. '枚（持有：' .. tostring(ranMuLingCount) .. '） '
            elseif condType == ClanMartialConfig.CMT_RenYiZhi then
                -- 1、学习武学需要判断仁义值，正派要大于等于给定仁义值，邪派小于等于仁义值；
                -- 2、和好感度条件的关系，当门派是正派的时候是且的关系，邪派的时候是或的关系；
                if condValueList[index] < 0 then
                    des_RenYiZhi = "仁义值低于" .. tostring(condValueList[index]) .. ' '
                else
                    des_RenYiZhi = "仁义值高于" .. tostring(condValueList[index]) .. ' '
                end
            elseif condType == ClanMartialConfig.CMT_QuanZhangJingTong then
                -- 拳掌精通
                des = des .. '拳掌精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_JianFaJingTong then
                -- 剑法精通
                des = des .. '剑法精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_DaoFaJingTong then
                -- 刀法精通
                des = des .. '刀法精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_TuiFaJingTong then
                -- 腿法精通
                des = des .. '腿法精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_QiMenJingTong then
                -- 奇门精通
                des = des .. '奇门精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_AnQiJingTong then
                -- 暗器精通
                des = des .. '暗器精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_YiShuJingTong then
                -- 医术精通
                des = des .. '医术精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_NeiGongJingTong then
                -- 内功精通
                des = des .. '内功精通高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            elseif condType == ClanMartialConfig.CMT_SPEED then
                -- 速度
                des = des .. '速度高于' .. tostring(condValueList[index]) .. ' ' .. '\n'
            end
        end
    end

    local clandata = TB_Clan[self.uiClanTypeID]
    if clandata == nil then
        return false
    end
    local clanType = clandata.Type
        -- 邪教
    des = des .. (des_HaoGan or "") 
    if des_RenYiZhi then
        if string.len(des) > 0 then
            des = des .. "且" ..  (des_RenYiZhi or "") 
        else
            des = des_RenYiZhi or ""
        end
    end

    return des
end

function ClanMartialUI:IsSameMartial(martialTypeID)
    -- 重复天赋
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    local data = MartialDataManager:GetInstance():InstRoleHaveMartial(mainRoleID, martialTypeID)
    return data ~= nil
end

function ClanMartialUI:CheckCanLearn(martialBaseID)
    if not martialBaseID or not self.uiClanTypeID then
        return false
    end
    if self:IsSameMartial(martialBaseID) then
        return false, "已拥有" 
    end
    local condTypeList, condValueList = MartialDataManager:GetInstance():GetMartialLearnCondition(martialBaseID, self.uiClanTypeID, true)
    if #condTypeList > 0 and #condTypeList == #condValueList then
        local des = self:GenDes(condTypeList, condValueList)
        local bSuccessd
        local clandata = TB_Clan[self.uiClanTypeID]
        if clandata == nil then
            return false
        end
        local ranMuLingConditionIndex = 0
        local ranMuLingCondition = nil
        local conditionFlag = true
        for i = 1, #condTypeList do
            if self:GetTag_ZANGJINGGE() then
                if condTypeList[i] == ClanMartialConfig.CMT_RanMuLing then
                    local iNum = ItemDataManager:GetInstance():GetItemNumByTypeID(80603)
                    iNum = iNum or 0
                    local param = condValueList[i] or 0
                    if iNum < param then
                        conditionFlag = false
                    else
                        ranMuLingCondition = condValueList[i]
                        ranMuLingConditionIndex = i
                    end
                end
            end
            local checkConditionResult = MartialDataManager:GetInstance():CheckMartialLearnConditionByType(self.uiClanTypeID, martialBaseID, condTypeList[i], condValueList[i])
            conditionFlag = conditionFlag and checkConditionResult
        end
        
        if conditionFlag then
            return true, des, ranMuLingConditionIndex, ranMuLingCondition
        end
        return false, des 
    else
        return false, "不传之秘"
    end
end

-- 门派好感度 , 燃木令
function ClanMartialUI:ShowInfo()
    local str = ""
    if self:GetTag_ZANGJINGGE() then
        local iNum = ItemDataManager:GetInstance():GetItemNumByTypeID(80603)
        str = string.format("燃木令: %d个", iNum) 
    else
        local uiClanTypeID = CityDataManager:GetInstance():GetCurClanTypeID()
        if not uiClanTypeID or uiClanTypeID == 0 then
            uiClanTypeID = self.uiClanTypeID 
        end
        local clanBaseData = TB_Clan[uiClanTypeID]
        local clanName = ''
        if clanBaseData then
            clanName = GetLanguagePreset(clanBaseData.NameID, tostring(clanBaseData.NameID) )
        end
    
        local clanDisposition = ClanDataManager:GetInstance():GetDisposition(uiClanTypeID)
        str = string.format("%s好感度: %d", clanName or '',clanDisposition)
    end
    self.Text_info.text = str
end
-- 获取门派武学的介绍
function ClanMartialUI:GetMartialDes(typeID)
    local des = {}
    local martialTypeData = GetTableData("Martial",typeID)
    local MartMovIDs = martialTypeData.martialTypeData or {}
    local UnlockLvls = martialTypeData.UnlockLvls or {}
    -- TODO 武学详情
end

function ClanMartialUI:OnDestroy()
    self.MartialUI:Close()
end

return ClanMartialUI