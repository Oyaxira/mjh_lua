RoleShowUI = class("RoleShowUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function RoleShowUI:ctor()
    self.comReturn_Button = nil
    self.ItemIconUI = ItemIconUI.new()
end

function RoleShowUI:Create()
	local obj = LoadPrefabAndInit("Interactive/RoleShowUI",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function RoleShowUI:RefreshUI(info)
    local roleID = info[1]
    self.showSelf = info[2]
    
    if roleID then
        self:Enqueue(roleID)
        self:CheckAndShow()
    end
end

function RoleShowUI:Init()

    -- local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    -- if shareGroupUI then
    --     if not MSDKHelper:IsPlayerTestNet() then

    --         local _callback = function(bActive)
    --             local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
    --             if serverAndUIDUI and serverAndUIDUI._gameObject then
    --                 serverAndUIDUI._gameObject:SetActive(bActive);
    --             end
    --         end

    --         self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
    --         self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.YAOQING, _callback);

    --         local canvas = shareGroupUI:GetComponent('Canvas');
    --         if canvas then
    --             canvas.sortingOrder = 3000;
    --         end
    --     else
    --         shareGroupUI:SetActive(false);
    --     end
    -- end

    -- 背景点击层
    self.comButtonBG = self:FindChildComponent(self._gameObject, "BG", "Button")
    if self.comButtonBG then
        self.comButtonBG.interactable = false
        self:AddButtonClickListener(self.comButtonBG,function() 
            self.boolean_showing = false
            self:CheckAndShow() 
        end)
    end

    -- 开始动画
    self.comDOAnim_start = self._gameObject:GetComponent("DOTweenAnimation")
    -- 结束动画
    self.comDOAnim_end = self:FindChildComponent(self._gameObject, "detail_panel", "DOTweenAnimation")
    if self.comDOAnim_end then
        self.comDOAnim_end.tween:OnComplete(function()
            if self.comButtonBG then
                self.comButtonBG.interactable = true
            end
        end)
    end
    -- 左侧描述面板
    self.desc_panel = self:FindChild(self._gameObject, "desc_panel")
        self.comCGImage = self:FindChildComponent(self.desc_panel, "CG", "Image")
        self.desc_box = self:FindChild(self.desc_panel, "desc_box")
            self.comText_Label = self:FindChildComponent(self.desc_box, "label", "Text")     -- 称号
            self.comText_Name = self:FindChildComponent(self.desc_box, "name_box/name", "Text") -- 名字
            self.comText_Level = self:FindChildComponent(self.desc_box, "name_box/level", "Text") -- 叠加等级
        self.comText_Desc = self:FindChildComponent(self.desc_panel, "Text_desc", "Text") -- 描述

    -- 右侧详细信息
    self.detail_panel = self:FindChild(self._gameObject, "detail_panel")
        self.objAbility = self:FindChild(self.detail_panel, "ability")
            self.comAbilityTipsButton = self:FindChildComponent(self.objAbility, "title_box/Button", "Button")
            self.ability_chart = self:FindChild(self.objAbility, "ability_chart")
                self.ui_ability = {}    -- 角色属性 × 8
                for i = 1, 8 do
                    self.ui_ability[i] = self:FindChild(self.ability_chart, tostring(i))
                end
            self.item_chart = self:FindChild(self.detail_panel, "item_chart")
                self.objHeirloom = self:FindChild(self.item_chart, "heirloom")  -- 传家宝
                self.comHeirloomButton = self.objHeirloom:GetComponent("Button")
                self.ui_obj_role = {}   -- 角色头像 × 3
                self.kIndex2RoleDespData = {}
                for i = 1, 3 do
                    self.ui_obj_role[i] = self:FindChild(self.item_chart, "role"..i)    -- 关系链
                    if self.ui_obj_role[i] then
                        local comReturnUIAction = self.ui_obj_role[i]:GetComponent("LuaUIAction")
                        if comReturnUIAction then
                            comReturnUIAction:SetPointerEnterAction(function()
                                self:OnClickRoleHead(i)
                            end)
                    
                            comReturnUIAction:SetPointerExitAction(function()
                                RemoveWindowImmediately("TipsPopUI")
                            end)
                        end
                    end
                end
            self.comButton_ability = self:FindChildComponent(self.objAbility, "title_box/Button", "Button")

        
        self.objMartial = self:FindChild(self.detail_panel, "martial")
        self.objMartialitem = self:FindChild(self.objMartial, "SC_demo/martialitem")
        self.objMartialContent = self:FindChild(self.objMartial, "SC_demo/Viewport/Content")

        self.objGift = self:FindChild(self.detail_panel, "gift")
        self.objGiftContent = self:FindChild(self.objGift, "SC_demo/Viewport/Content")
        --objGiftitem直接套用objMartialitem 关掉等级文本就好

        self.objAddlevel = self:FindChild(self.detail_panel, "addlevel")
    
    -- 加入队伍
    self.artword_join = self:FindChild(self._gameObject, "artword_join")
    -- 叠加等级
    self.artword_add_level = self:FindChild(self._gameObject, "artword_add_level")

    self.role_queue = {}        -- 角色队列，存储的是 roleID
    self.role_queue_data = {}   -- TODO：是否叠加等级提升
    self.curRole_dynData = nil         -- 当前展示角色，存储的是 roleData
    self.curRole_typeData = nil        -- 当前展示角色，存储的是 roleTypeData
    self.boolean_showing = false
end

-- 服务器下行：加入队列
function RoleShowUI:Enqueue(roleID, boolean_addlevel)
    self.role_queue[#self.role_queue + 1] = roleID
    self.role_queue_data[#self.role_queue_data + 1] = (boolean_addlevel == true)
end

function RoleShowUI:Dequeue(boolean_check)
    -- 出队
    table.remove(self.role_queue, 1)
    table.remove(self.role_queue_data, 1)

    if boolean_check then
        if #self.role_queue == 0 then
            self:Exit()
        else    -- 跳过当前，检查下一个
            self.boolean_showing = false
            self:CheckAndShow() 
        end
    end
end

-- 退出处理
function RoleShowUI:Exit()
    self.boolean_showing = false
    RemoveWindowImmediately("RoleShowUI", true)
    DisplayActionEnd()
end

-- 检查队列并且取出余项显示
function RoleShowUI:CheckAndShow()
    if self.boolean_showing then    -- 已经在播放了，忽略掉
        return
    end
    self.boolean_showing = true

    if not self.role_queue then
        derror("展示角色时出现错误，队伍为空")
        RemoveWindowImmediately("RoleShowUI", true)
        return
    end

    -- 检查队列
    if #self.role_queue == 0 then
        self:Exit()
        return
    end

    --设置加入队伍
    self.artword_join:SetActive(not(self.showSelf))
    self.artword_add_level:SetActive(self.showSelf)
    -- 取出一个
    local roleID = self.role_queue[1]
    local boolean_addlevel = self.role_queue_data[1]
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if roleData and roleData.uiTypeID then
        -- 判断角色品质，如果角色品质低于蓝色的不用显示
        -- 一般来说, 只有蓝色品质以上的队友才显示入队动画, 但是低品质也可以强制显示
        
        local roleTypeID = roleData.uiTypeID
        local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleTypeID)
        local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
        
        if not(self.showSelf) and roleID == mainRoleID then
            self:Dequeue(true)
            return
        end

        PlayNPCSound(roleTypeID) -- 播放入队招呼音效
        -- 暂时不需要 ,by 陈相相
        -- if roleTypeData and roleTypeData.Rank and roleTypeData.Rank >= RankType.RT_Blue then
            self.curRole_dynData = roleData
            self.curRole_typeData = roleTypeData

            -- 渲染数据
            -- self:playSound() -- TODO：播放声音，暂时不做
            self:SetAbility()   -- 设置属性
            self:SetItems()     -- 设置物品
            self:SetAbout()     -- 设置描述数据

            -- 如果是叠加等级提升，则显示叠加等级，否则显示武学和天赋
            if not boolean_addlevel then
                self:SetKungfu()   -- 设置武学
                self:SetGift()     -- 设置天赋
            else
                -- self:SetExtraLevel()     -- TODO：叠加等级提升内容，暂时不做
            end
            self.objMartial:SetActive(not boolean_addlevel)
            self.objGift:SetActive(not boolean_addlevel)
            self.objAddlevel:SetActive(boolean_addlevel == true)

            -- 开始播放动画
            if self.comDOAnim_start then

                RewindDoAnimation(self._gameObject)
                RewindDoAnimation(self.desc_panel)

                self.comDOAnim_start:DORestart()
            end
        -- else
        --     self:Dequeue(true)
        --     return
        -- end
    end

    self:Dequeue(false)
end

function RoleShowUI:FillLabel(ui_label, name, val)
    if not ui_label then return end
    local ui_name = self:FindChildComponent(ui_label, "Text_label", "Text")
    local ui_value = self:FindChildComponent(ui_label, "TMP_value", "Text")
    if ui_name and ui_value then
        ui_name.text = name
        ui_value.text = tostring(val)
    end
end

-- 设置物品
function RoleShowUI:SetItems()
    if not self.curRole_dynData then return end

    -- --------------------------------------------
    local heirloomItemID = RoleDataManager:GetInstance():GetHeirloomByTypeID(self.curRole_typeData.BaseID)
    if heirloomItemID then
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",heirloomItemID)
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objHeirloom, itemTypeData)
        self.ItemIconUI:SetHeirloom(self.objHeirloom)
        
        if self.comHeirloomButton then
            self:RemoveButtonClickListener(self.comHeirloomButton)
			local fun = function()
				local tips = TipsDataManager:GetInstance():GetItemTips(nil, heirloomItemID)
				OpenWindowImmediately("TipsPopUI", tips)
			end
			self:AddButtonClickListener(self.comHeirloomButton, fun)
        end
    else
        self.objHeirloom:SetActive(false)
    end
    -- --------------------------------------------
    -- 获取好感度
    local dispositions = RoleDataManager:GetInstance():GetDispositionData(self.curRole_dynData.uiID)
    local disp_to_show = {}
    local roleTypeID = nil
    local roleMgr = RoleDataManager:GetInstance()
    local iMainRoleID = roleMgr:GetMainRoleTypeID()
    if dispositions then
        -- 拷贝一份数组，用于排版
        local typeIDMap = {}
        for roleTypeID, data in pairs(dispositions) do 
            if roleTypeID ~= iMainRoleID and typeIDMap[roleTypeID] ~= true then
                local iDespValue = data.iValue or 0
                typeIDMap[roleTypeID] = true
                local sort_array = {
                    ['id'] = roleTypeID,
                    ['iValue'] = iDespValue,
                    ['desc'] = RoleDataHelper.GetDispositionDesByValue(iDespValue),
                    ['descid'] = data.DescID or 0
                }
                table.insert(disp_to_show, sort_array)
            end
        end

        table.sort(disp_to_show, function(a,b)
            local desc_a = a.desc
            local desc_b = b.desc
            if desc_a ~= nil and desc_b == nil then
                return true
            elseif desc_a == nil and desc_b ~= nil then
                return false
            end
            return math.abs(a.iValue) > math.abs(b.iValue)
        end)
    end

    -- 开始显示 UI
    self.kIndex2RoleDespData = {}
    for i = 1, #self.ui_obj_role do
        if not disp_to_show[i] then
            self.ui_obj_role[i]:SetActive(false)
        else
            self.ui_obj_role[i]:SetActive(true)
            local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(disp_to_show[i].id)
            if roleTypeData then 
                local comImage = self:FindChildComponent(self.ui_obj_role[i], "head", "Image")
                local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeData.RoleID)
                if artData and artData['Head'] then
                    comImage.sprite = GetSprite(artData['Head'])
                end
                self.kIndex2RoleDespData[i] = disp_to_show[i]
            else
                derror("[RoleShowUI] dispositions role typeid is nil:",disp_to_show[i].id)
            end
        end
    end
end

-- 显示角色好感度tips
function RoleShowUI:OnClickRoleHead(iDestIndex)
    if not (iDestIndex and self.kIndex2RoleDespData) then
        return
    end
    local kData = self.kIndex2RoleDespData[iDestIndex]
    if not (kData and kData.iValue and kData.id and kData.desc) then
        return
    end
    local roleMgr = RoleDataManager:GetInstance()
    local roleTypeData = roleMgr:GetRoleTypeDataByID(kData.id) or roleMgr:GetRoleTypeDataByTypeID(kData.id)
    if not roleTypeData then
        return
    end
    local roleName = getRankBasedText(roleTypeData.Rank, GetLanguageByID(roleTypeData.NameID))
    local title = string.format("%s(好感度:%d)", roleName or "", kData.iValue)
    local descText = kData.desc
    if kData.descid and kData.descid ~= 0 then
        descText = GetLanguageByID(kData.descid)
    end

    OpenWindowImmediately("TipsPopUI", {
        ['kind'] = 'normal',
        ['title'] = title,
        ['titlecolor'] = DRCSRef.Color.white,
        ['content'] = descText,
        ['isSkew'] = true,
        ['isUpDown'] = true,
    })
end

-- 设置属性
function RoleShowUI:SetAbility()
    if not self.curRole_dynData then return end

    local level = 1    -- 等级
    if self.curRole_dynData['uiLevel'] and self.curRole_dynData['uiLevel'] > 0 then
        level = self.curRole_dynData['uiLevel']
    end
    self:FillLabel(self.ui_ability[1], "等级", level)

    local clanID    -- 门派
    if self.curRole_dynData.uiClanID and self.curRole_dynData.uiClanID > 0 then
        clanID = self.curRole_dynData.uiClanID
    elseif self.curRole_typeData and self.curRole_typeData.Clan and self.curRole_typeData.Clan > 0 then
        clanID = self.curRole_typeData.Clan
    end

    local clanTypeData = ClanDataManager:GetInstance():GetClanTypeDataByTypeID(clanID)
    if clanTypeData then
        self:FillLabel(self.ui_ability[2], "门派", GetLanguagePreset(clanTypeData.NameID, 995) )
    else
        self:FillLabel(self.ui_ability[2], "门派", "无" )
    end

    self:FillLabel(self.ui_ability[3], "仁义", self.curRole_dynData.iGoodEvil)

    -- 只显示两个喜好, 多余的省略
    -- local hobby_list = self.curRole_dynData.auiFavor
    local roleTypeID = self.curRole_dynData.uiTypeID
    local roleID = RoleDataManager:GetInstance():GetRoleID(roleTypeID)
    local hobby_list = RoleDataManager:GetInstance():GetRoleFavor(roleID)
    local index = 0
    local hobby_str = ""
    for i = 1, #hobby_list do
        if index < 2 and dnull(hobby_list[i]) then
            local text = GetEnumText("FavorType", hobby_list[i]) or ""
            hobby_str = hobby_str .. (index > 0 and dtext(975) or "") .. text
            index = index + 1
        else
            break
        end
    end
    hobby_str = (index == 0) and dtext(995) or hobby_str
    self:FillLabel(self.ui_ability[4], "喜好", hobby_str)

    self:FillLabel(self.ui_ability[5], "生命值", self.curRole_dynData.uiHP)
    self:FillLabel(self.ui_ability[6], "真气", self.curRole_dynData.uiMP)
    self:FillLabel(self.ui_ability[7], "攻击",  self.curRole_dynData.aiAttrs[AttrType.ATTR_MARTIAL_ATK])
    self:FillLabel(self.ui_ability[8], "防御",  self.curRole_dynData.aiAttrs[AttrType.ATTR_DEF])

    self:RemoveButtonClickListener(self.comButton_ability)
    local fun = function()
        local tips = TipsDataManager:GetInstance():GetCharacterCommonTips(self.curRole_dynData.uiID)
        OpenWindowImmediately("TipsPopUI", tips)
    end
    self:AddButtonClickListener(self.comButton_ability, fun)
end

function RoleShowUI:SetKungfu()
    if not self.curRole_dynData then return end

    local ids, lvs = self.curRole_dynData:GetMartials()

    -- TODO: 插入武学, 这里要筛选掉 秘奥义/轻功

    -- TODO: 优先按品质排序, 其次, 外功优先显示, 再次之, 等级高优先显示, 再次之, 按o表排序
    -- local sortfunction = function(a,b)
    --     if (a.角色专属天赋 and b.角色专属天赋) or not (a.角色专属天赋 or b.角色专属天赋) then
    --         if a.品质 and b.品质 and a.品质.id ~= b.品质.id   then
    --             return a.品质.id > b.品质.id
    --         else
    --             local boolea_a_外功 = a.系别 and (a.系别.外功 == true) or false
    --             local boolea_b_外功 = b.系别 and (b.系别.外功 == true) or false
    --             if boolea_a_外功 ~= boolea_b_外功 then
    --                 return boolea_a_外功
    --             elseif a.等级 and b.等级 and a.等级 ~= b.等级 then
    --                 return a.等级 > b.等级
    --             else
    --                 return a.name > b.name
    --             end
    --         end
    --     elseif a.角色专属天赋 then
    --         return true
    --     else
    --         return false
    --     end
    -- end
    -- TODO：筛选符合条件的武学（kungfu.显示）
    local kMartialID2Level = {}
	local akMartials = {}
	local typeID = nil
    for index = 0, #ids do
		typeID = ids[index]
		if typeID then
			local data = GetTableData("Martial",typeID) 
			if data then
				kMartialID2Level[typeID] = lvs[index]
				akMartials[#akMartials + 1] = data
			end
		end
	end
    self:RemoveAllChildToPool(self.objMartialContent.transform)
    for index, kMartialTypeData in ipairs(akMartials) do
        local objMartialText = self:LoadGameObjFromPool(self.objMartialitem,self.objMartialContent.transform)
        objMartialText:SetActive(true)
        local typeID = kMartialTypeData.BaseID
        local comTMP_label = self:FindChildComponent(objMartialText, 'TMP_label', 'Text')
        local comTMP_value = self:FindChildComponent(objMartialText, 'TMP_value', 'Text')
        local excObj = self:FindChild(objMartialText, 'exc')

        local exc = false 
        local typeData = TableDataManager:GetInstance():GetTableData("Martial",typeID)
        if typeData and typeData.Exclusive then
            exc = true
        end
        comTMP_label.text = getRankBasedText(kMartialTypeData.Rank, GetLanguageByID(kMartialTypeData.NameID))
        comTMP_value.text = string.format('%d%s', kMartialID2Level[typeID], dtext(994)) 
        excObj:SetActive(exc)
                local comReturnUIAction = objMartialText:GetComponent("LuaUIAction")
                if comReturnUIAction then
                    local fun = function()
                        local name = exc == true and getRankBasedText(kMartialTypeData.Rank, GetLanguageByID(kMartialTypeData.NameID)).."<color=#ff0000>[专属]</color>" or
                            getRankBasedText(kMartialTypeData.Rank, GetLanguageByID(kMartialTypeData.NameID))
                        local tips={
                            title = string.format("%s  <color=#FFFFFF>%d级</color>",name, kMartialID2Level[typeID]),
                            content = (GetLanguageByID(kMartialTypeData.DesID) or ""),
                            -- movePositions = {
                            -- 	x = 0,
                            -- 	y = 120
                            -- },
                            isSkew = true,
                            isExc = exc
                        }
                            OpenWindowImmediately("TipsPopUI",tips)
                    end
                    comReturnUIAction:SetPointerEnterAction(function()
                        fun()
                    end)
            
                    comReturnUIAction:SetPointerExitAction(function()
                        RemoveWindowImmediately("TipsPopUI")
                    end)
                end

            
    end
    -- self:RemoveButtonClickListener(self.comButton_martial)

    -- local fun = function()
    --     local tips = TipsDataManager:GetInstance():GetRoleShowMartialTips(ids, lvs)
    --     OpenWindowImmediately("TipsPopUI", tips)
    -- end
    -- self:AddButtonClickListener(self.comButton_martial, fun)
end

function RoleShowUI:SetGift()
    if not self.curRole_dynData then return end
    local gift_list = self.curRole_dynData["auiRoleGift"] or {}
    -- TODO: 首先专属天赋靠前，其次按品质排序，再按等级排序
    gift_list = table_c2lua(gift_list)
    -- local sortfunction = function(a,b)
    --     if (a.角色专属天赋 and b.角色专属天赋) or not (a.角色专属天赋 or b.角色专属天赋) then
    --         if a.品质 and b.品质 and a.品质.id ~= b.品质.id   then
    --             return a.品质.id > b.品质.id
    --         elseif a.等级 and b.等级 and a.等级 ~= b.等级 then
    --             return a.等级 > b.等级
    --         else
    --             return a.name > b.name
    --         end
    --     elseif a.角色专属天赋 then
    --         return true
    --     else
    --         return false
    --     end
    -- end
    -- TODO：筛选符合条件的天赋（gift.是否显示）
    -- TODO：不显示尝遍四海 阴阳调和
    self:RemoveAllChildToPool(self.objGiftContent.transform)
    for i = 1, #gift_list do
        local objGiftText = self:LoadGameObjFromPool(self.objMartialitem,self.objGiftContent.transform)
        objGiftText:SetActive(true)

        local comTMP_label = self:FindChildComponent(objGiftText, 'TMP_label', 'Text')
        local comTMP_value = self:FindChildComponent(objGiftText, 'TMP_value', 'Text')
        local excObj = self:FindChild(objGiftText, 'exc')
        local giftTypeData = GiftDataManager:GetInstance():GetGiftTypeData(gift_list[i])
        if giftTypeData then
            local exc = GiftDataManager:GetInstance():IfExclusiveGift(giftTypeData.BaseID)
            if giftTypeData and giftTypeData.BaseID ~= 794 then
                comTMP_label.text = getRankBasedText(giftTypeData.Rank, GetLanguageByID(giftTypeData.NameID))
                comTMP_value.text = ""
                excObj:SetActive(exc)
            end
            if giftTypeData and giftTypeData.BaseID == 794 then
                objGiftText:SetActive(false)
            end
            local comReturnUIAction = objGiftText:GetComponent("LuaUIAction")
            if comReturnUIAction then
                local fun = function()
                    local name = exc == true and getRankBasedText(giftTypeData.Rank, GetLanguageByID(giftTypeData.NameID)).."<color=#ff0000>[专属]</color>"
                        or getRankBasedText(giftTypeData.Rank, GetLanguageByID(giftTypeData.NameID))
                    local tips={
                        title = name,
                        content = GiftDataManager:GetInstance():GetDes(self.curRole_dynData, giftTypeData),
                        -- movePositions = {
                        -- 	x = 0,
                        -- 	y = 120
                        -- },
                        isSkew = true
                    }
                        OpenWindowImmediately("TipsPopUI",tips)
                end
                comReturnUIAction:SetPointerEnterAction(function()
                    fun()
                end)
        
                comReturnUIAction:SetPointerExitAction(function()
                    RemoveWindowImmediately("TipsPopUI")
                end)
            end
        end
      
    end
end

-- 设置描述数据
function RoleShowUI:SetAbout()
    -- 立绘
    local roleTypeID = self.curRole_dynData.uiTypeID
    local roleArtData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
    if roleArtData and roleArtData["Drawing"] then
        self.comCGImage.sprite = GetSprite(roleArtData["Drawing"])
    end

    local roleID = RoleDataManager:GetInstance():GetRoleID(roleTypeID)
    local rank = RoleDataManager:GetInstance():GetRoleRank(roleID)
    
    local UIcolor = getRankColor(rank or RankType.RT_White)

    -- 名字
    local sRoleName = RoleDataManager:GetInstance():GetRoleName(roleID)
    self.comText_Name.text = sRoleName
    self.comText_Name.color = UIcolor

    -- 叠加等级
    local level = self.curRole_dynData.uiOverlayLevel or 0    
    self.comText_Level.gameObject:SetActive(level ~= 0)
    self.comText_Level.text = string.format("+%d",toint(level))
    self.comText_Level.color = UIcolor

    -- 称号
    local TitleID = 0
    if self.curRole_dynData then
        if self.curRole_dynData.roleType == ROLE_TYPE.INST_ROLE then
            if self.curRole_dynData.uiTitleID and self.curRole_dynData.uiTitleID > 0 then
                TitleID = self.curRole_dynData.uiTitleID
            end
        else
            local roleID = self.curRole_dynData.uiID
            local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_TITLE)
            if BeEvolution then
                TitleID = BeEvolution.iParam1
            elseif self.curRole_dynData.uiTypeID then
                local dbdata = TB_Role[self.curRole_dynData.uiTypeID]
                if dbdata then
                    TitleID = dbdata.TitleID
                end
            end
        end
    end
    if TitleID > 0 then
        local roleTitleData = TableDataManager:GetInstance():GetTableData("RoleTitle",TitleID)
        if roleTitleData and roleTitleData.TitleID then
            self.comText_Label.gameObject:SetActive(true)
            self.comText_Label.text = GetLanguageByID(roleTitleData.TitleID)
            self.comText_Label.color = UIcolor
        end
    else
        self.comText_Label.gameObject:SetActive(false)
    end

    -- 描述
    local desc = GetLanguageByID(self.curRole_typeData.IntroduceID)
    if (not desc) or (desc == "") or (desc == "暂无介绍") then
        desc = "与你交好，决定陪你在这个江湖上闯荡一番的侠客，若是仔细培养日后说不定大有可为。"
    end
    self.comText_Desc.text = desc
end

function RoleShowUI:OnDestroy()
    self.ItemIconUI:Close()
    -- if self.TencentShareButtonGroupUI then
    --     self.TencentShareButtonGroupUI:Close();
    -- end
end


return RoleShowUI