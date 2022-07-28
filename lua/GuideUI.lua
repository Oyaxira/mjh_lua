GuideUI = class("GuideUI",BaseWindow)

local tip_offset = 20
local protect_frame = 20

function GuideUI:Create()
	local obj = LoadPrefabAndInit("Guide/GuideUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function GuideUI:Init()
    self.comMask = self:FindChildComponent(self._gameObject,"mask", "GuideHighlightMask")
    self.objTisBg = self:FindChild(self._gameObject,"tipbg")
    self.objText = self:FindChild(self._gameObject,"tipstext")
    self.comText = self:FindChildComponent(self._gameObject,"tipstext", "Text")
    self.comTisBg = self.objTisBg:GetComponent("RectTransform")

    self.comBtnBg = self:FindChildComponent(self._gameObject,"mask","Button")

    self.objHand = self:FindChild(self._gameObject,"hand")
    -- 对话相关
    self.objDialog = self:FindChild(self._gameObject,"dialog")
    self.comDialog_Text = self:FindChildComponent(self._gameObject,"Dialog_Text", "Text")
    self.objCG = self:FindChild(self._gameObject, 'CG')
    self.comRoleCGImg = self.objCG:GetComponent('Image')
    self.comRoleName = self:FindChildComponent(self._gameObject,"rolename", "Text")
    self.comBtnDialog = self:FindChildComponent(self._gameObject,"dialog_btn","Button")
    -- 图片相关
    self.objImg = self:FindChild(self._gameObject,"img")
    self.comImg = self:FindChildComponent(self._gameObject, "img", "Image")
    
    self.objArrw = self:FindChild(self._gameObject,"arrw")
    self.comBtnArrw = self:FindChildComponent(self._gameObject,"arrw","Button")

    self:RemoveButtonClickListener(self.comBtnDialog)
    self:AddButtonClickListener(self.comBtnDialog, function()
        if not self.inProtect and self.curConfig.GuideType == GuideType.GT_Dialog then
            GuideDataManager:GetInstance():RunNext()
        end  
    end)

    self:RemoveButtonClickListener(self.comBtnBg)
    self:AddButtonClickListener(self.comBtnBg, function()
        if not self.inProtect and self.curConfig.GuideType == GuideType.GT_Tip then
            GuideDataManager:GetInstance():RunNext()
        end  
    end)

    self:RemoveButtonClickListener(self.comBtnArrw)
    self:AddButtonClickListener(self.comBtnArrw, function()
        if not self.inProtect and self.curConfig.GuideType == GuideType.GT_Click then
            if self.curConfig.RoleID ~= 0 then 
                local window = GetUIWindow("CityUI")

                local roleClickInfo = window and window:GetGuideInfo(self.curConfig.RoleID)
                if roleClickInfo then 
                    local action = roleClickInfo[1]:GetComponent('LuaUIAction')
                    local roleID = roleClickInfo[3][roleClickInfo[2]]
                    local mapID = GetUIntDataInGameObject(roleClickInfo[1], 'mapID')                           
                    RoleDataManager:GetInstance():TryInteract(roleID, mapID)
                end
            elseif self.clickObj and self.clickObj.gameObject then
                if self.BattleFieldClick then 
                    local drbutton = self.clickObj:GetComponent('LuaUIAction')
                    if drbutton then 
                        drbutton:OnPointerDown()
                        drbutton:OnPointerUp()
                    else
                        LogicMain:GetInstance():OnClick_Grid(self.clickObj.gameObject)
                    end
                else
                    local drbutton = self.clickObj:GetComponent('LuaUIAction')
                    if drbutton then 
                        --一个gameObject同时绑定LuaUIAcition和Button时 特殊判断一下来判定引导想要触发的是onclick还是OnPointClick
                        if self.clickObj.name == "Button_lineup" or self.clickObj.name == "EndTurn_Button" 
                            or self.clickObj.name == "Raycast" then
                            local comButton = self.clickObj:GetComponent("Button")
                            if comButton then
                                comButton.onClick:Invoke()
                            end
                        else
                            drbutton:OnPointerClick()
                        end
                        if self.curConfig.UIName == "BattleUI" then
                            drbutton:OnPointerDown()
                        end   
                    else
                        local comButton = self.clickObj:GetComponent("Button")
                        if comButton then
                            comButton.onClick:Invoke()
                        end
                    end
                end 
            end
            GuideDataManager:GetInstance():RunNext()
        elseif not self.inProtect and self.curConfig.GuideType == GuideType.GT_Tip then
            GuideDataManager:GetInstance():RunNext()
        end 
    end)

    local comUIAction = self.objArrw:GetComponent('LuaUIAction')
	if comUIAction then
        local PointerClickCallback = function(objArrw, eventData) 
            local win = GetUIWindow("GuideUI")
            if not win then
                return
            end
            if not win.inProtect and win.curConfig.GuideType == GuideType.GT_RoleClick then
                if win.roleClickInfo then
                    local action = win.roleClickInfo[1]:GetComponent('LuaUIAction')
                    local roleID = win.roleClickInfo[3][win.roleClickInfo[2]]
                    local mapID = GetUIntDataInGameObject(win.roleClickInfo[1], 'mapID')                           
                    RoleDataManager:GetInstance():TryInteract(roleID, mapID)
    
                end
                GuideDataManager:GetInstance():RunNext()
            end
        end
        comUIAction:SetPointerClickAction(PointerClickCallback)
	end
end

function GuideUI:SetTipsAlign(aligntype)
    local center = self.comMask.center
    local size = self.comMask.size
    local tipsSize = self.comTisBg.sizeDelta
    local x = 0
    local y = 0

    if GuideTipAlign.GTA_RightTop == aligntype then
        x = center.x + size.x * 0.5 + tipsSize.x * 0.5 + tip_offset
        y = center.y + size.y * 0.5 - tipsSize.y * 0.5 
    elseif GuideTipAlign.GTA_LeftTop == aligntype then
        x = center.x - size.x * 0.5 - tipsSize.x * 0.5 - tip_offset
        y = center.y + size.y * 0.5 - tipsSize.y * 0.5
    elseif GuideTipAlign.GTA_RightDown == aligntype then
        x = center.x + size.x * 0.5 + tipsSize.x * 0.5 + tip_offset
        y = center.y - size.y * 0.5 + tipsSize.y * 0.5 
    elseif GuideTipAlign.GTA_LeftDown == aligntype then
        x = center.x - size.x * 0.5 - tipsSize.x * 0.5 - tip_offset
        y = center.y - size.y * 0.5 + tipsSize.y * 0.5
    elseif GuideTipAlign.GTA_TopLeft == aligntype then
        x = center.x - size.x * 0.5 + tipsSize.x * 0.5
        y = center.y + size.y * 0.5 + tipsSize.y * 0.5 + tip_offset
    elseif GuideTipAlign.GTA_DownLeft == aligntype then
        x = center.x - size.x * 0.5 + tipsSize.x * 0.5
        y = center.y - size.y * 0.5 - tipsSize.y * 0.5 - tip_offset
    elseif GuideTipAlign.GTA_DownCenter == aligntype then
        x = center.x 
        y = center.y - size.y * 0.5 - tipsSize.y * 0.5 - tip_offset
    elseif GuideTipAlign.GTA_TopCenter == aligntype then
        x = center.x 
        y = center.y + size.y * 0.5 + tipsSize.y * 0.5 + tip_offset
    elseif GuideTipAlign.GTA_LeftCenter == aligntype then
        x = center.x - size.x * 0.5 - tipsSize.x * 0.5 - tip_offset
        y = center.y
    elseif GuideTipAlign.GTA_RightCenter == aligntype then
        x = center.x + size.x * 0.5 + tipsSize.x * 0.5 + tip_offset
        y = center.y
    elseif GuideTipAlign.GTA_TopRight == aligntype then
        x = center.x + size.x * 0.5 - tipsSize.x * 0.5
        y = center.y + size.y * 0.5 + tipsSize.y * 0.5 + tip_offset
    elseif GuideTipAlign.GTA_DownRight == aligntype then
        x = center.x + size.x * 0.5 - tipsSize.x * 0.5
        y = center.y - size.y * 0.5 - tipsSize.y * 0.5 - tip_offset
    end

	self.comTisBg.localPosition = DRCSRef.Vec3(x,y,0)
end

function GuideUI:RefreshDialog()
    if self.curConfig.GuideType == GuideType.GT_Dialog then
        self.objHand:SetActive(true)
        self.objDialog:SetActive(true)
        self.objTisBg:SetActive(false)
        self.objImg:SetActive(false)
        self.comMask.isFullScreenClick = true

        local roleTypeID = self.curConfig.RoleID
        local name = RoleDataManager:GetInstance():GetRoleTitleAndName(roleTypeID, true)
        self.comRoleName.text = tostring(name)
        self.comDialog_Text.text = GetLanguageByID(self.curConfig.TipID) or ""

        local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
        if artData == nil then 
            return
        end
        local roleCG = artData.Drawing
        if roleCG then 
            self.comRoleCGImg.sprite = GetSprite(roleCG)
        else
            self.comRoleCGImg.sprite = nil
        end
        self.comRoleCGImg:SetNativeSize()
    end
end

function GuideUI:RefreshTip()
    if self.curConfig.GuideType == GuideType.GT_Tip then
        self.objHand:SetActive(false)
        self.objDialog:SetActive(false)
        self.objTisBg:SetActive(true)
        self.objImg:SetActive(false)
        self.comMask.isFullScreenClick = true
    end
end

function GuideUI:RefreshImage()
    if self.curConfig.GuideType == GuideType.GT_Image then
        self.objHand:SetActive(false)
        self.objDialog:SetActive(false)
        self.objTisBg:SetActive(false)
        self.objImg:SetActive(true)
        self.comMask.isFullScreenClick = true

        self.comImg.sprite = GetSprite(self.curConfig.Image)
        self.comImg:SetNativeSize()
    end
end

function GuideUI:RefreshClick()
    if self.curConfig.GuideType == GuideType.GT_Click or self.curConfig.GuideType == GuideType.GT_Battle_Click then
        self.objHand:SetActive(false)
        self.objDialog:SetActive(false)
        self.objTisBg:SetActive(true)
        self.objImg:SetActive(false)
        self.comMask.isFullScreenClick = false
    end
end

function GuideUI:RefreshUI(config)
    self.curConfig = config
    self.clickObj = nil
    
    if self.objArrw then
        local rect = self.objArrw:GetComponent("RectTransform")
        rect.sizeDelta = DRCSRef.Vec2(0,  0)
    end

    if self.curConfig.Black == TBoolean.BOOL_YES then
        self.comMask.color = GUIDE_COLOR['black']
    else
        self.comMask.color = GUIDE_COLOR['hide']
    end

    self.comText.text = GetLanguageByID(self.curConfig.TipID) or ""
    if self.curConfig.GuideAudio and self.curConfig.GuideAudio ~= 0 then 
        PlayDialogueSound(self.curConfig.GuideAudio)
    end 
    self.needLayout = 1
    
    self.need_waitrefreashnode =  0
    local rect = self.objTisBg:GetComponent("RectTransform")
    DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rect);

    self:RefreshDialog()
    self:RefreshTip()
    self:RefreshClick()
    self:RefreshImage()

    self.inProtect = true
end

function GuideUI:UpdateRoleClickArea()
    if self.curConfig.GuideType == GuideType.GT_RoleClick then
        -- TODO : 弃用 整理掉
        local window = GetUIWindow("CityUI")
        if window then
            self.roleClickInfo = window:GetGuideInfo(self.curConfig.RoleID)
            if self.roleClickInfo then
                local roleTransform = self.roleClickInfo[1].transform
                local roleScale = roleTransform.localScale
                local buildPosition = self.roleClickInfo[1].transform.position
            
                self.objArrw.transform.position = buildPosition

                local rect = self.objArrw:GetComponent("RectTransform")
                local rolenum = #self.roleClickInfo[3]
                -- roleTransform.rect.height * roleScale.y 策划不希望用实际的点击区域，先写个差不多大小的
                -- 有dotween动画导致缩放大小计算不对 简单处理写死 120 width/rolenum*roleScale.x
                -- local width = roleTransform.rect.width * roleScale.x
                local width = 260
                rect.sizeDelta = DRCSRef.Vec2(width/rolenum, 320)
                local stepwidth = width/rolenum/2
                local posx = self.objArrw.transform.localPosition.x
                posx = posx - width/2 + stepwidth
                posx = posx + stepwidth * 2 * (self.roleClickInfo[2] - 1 )

                self.objArrw.transform.localPosition = DRCSRef.Vec3(posx, self.objArrw.transform.localPosition.y, self.objArrw.transform.localPosition.z)
            else
                GuideDataManager:GetInstance():RunNext()
            end
        else
            GuideDataManager:GetInstance():RunNext()
        end
    end
end

function GuideUI:DoSafe(str_error)
    if self.objArrw then
        local rect = self.objArrw:GetComponent("RectTransform")
        rect.sizeDelta = DRCSRef.Vec2(300,  300)
        self.objArrw.transform.localPosition = DRCSRef.Vec3(0,0,0)
        self.comTisBg.localPosition = DRCSRef.Vec3(400,0,0)

        -- self:SetTipsAlign(self.curConfig.Align)
    else 
        GuideDataManager:GetInstance():RunNext()
    end

    -- 错误上传bugly 客户端就输出
    if self.need_waitrefreashnode == 0 then 
        local str_e = string.format('Notes for guide error,Baesid：%s',tostring(self.curConfig and self.curConfig.BaseID) )
        local trace = str_e .. '\nNote：' .. (str_error or '')
        if DEBUG_MODE then
            SystemTipManager:GetInstance():AddPopupTip(trace)
        end
        if not IS_WINDOWS then 
            DRCSRef.MSDKCrash:ReportException(1,"xpcall","GuideError",trace)
        end
    end
end

function GuideUI:UpdateGuideArea()
    if (self.curConfig.NodeName == nil ) then
        return
    end
    local strname = self.curConfig.UIName
    local window
    local objTarget 
    local objButton 
    local initsize = {0,0} 
    local offpos = {0,0} 
    self.BattleFieldClick = false 

    if strname == 'BattleField' then 
        -- 战斗内 的控件和外面不同，且点击方式不同
        window = LogicMain:GetInstance().battlefile or DRCSRef.FindGameObj("BattleField")
        if window and window:FindChild(self.curConfig.NodeName) then 
            objTarget = window:FindChild(self.curConfig.NodeName); 
        end 
        if window and window:FindChild(self.curConfig.ButtonName) then 
            objButton = window:FindChild(self.curConfig.ButtonName); 
        end 
        -- if not objTarget and window and window.transform:Find(self.curConfig.NodeName) then 
        --     objTarget = window.transform:Find(self.curConfig.NodeName).gameObject
        -- end 
        -- if not objButton and window and window.transform:Find(self.curConfig.ButtonName) then 
        --     objButton = window.transform:Find(self.curConfig.ButtonName).gameObject
        -- end 
        initsize = {50,50}
        offpos = {0,0}
        self.BattleFieldClick = true
    else
        window = GetUIWindow(self.curConfig.UIName)
        objTarget = window and window:FindChild(window:GetGameObject(), self.curConfig.NodeName)
        objButton = window and window:FindChild(window:GetGameObject(), self.curConfig.ButtonName)
    end
    
    objTarget = objTarget or DRCSRef.FindGameObj(self.curConfig.NodeName)
    objButton = objButton or DRCSRef.FindGameObj(self.curConfig.ButtonName)
    if self.curConfig.GridSizeB then 
        initsize[1] = self.curConfig.GridSizeB[1] or initsize[1]
        initsize[2] = self.curConfig.GridSizeB[2] or initsize[2]
    end 
    if self.curConfig.GridOffB then 
        offpos[1] = self.curConfig.GridOffB[1] or offpos[1]
        offpos[2] = self.curConfig.GridOffB[2] or offpos[2]
    end 
    self.objTarget = objTarget
    if objTarget then
        self.clickObj = objButton
        if self.BattleFieldClick then 
            self.comMask:SetTargetUISpine(objTarget.transform,DRCSRef.Vec2(table.unpack(initsize)),DRCSRef.Vec2(table.unpack(offpos)))        
        else
            self.comMask:SetTargetUI(objTarget.transform,DRCSRef.Vec2(table.unpack(initsize)),DRCSRef.Vec2(table.unpack(offpos)))        
        end 
        self.need_waitrefreashnode = self.need_waitrefreashnode or 2
    else
        self.need_waitrefreashnode = self.need_waitrefreashnode or 5
    end
end

function GuideUI:LateUpdate()
    if self.needLayout == 2 then 
        self:UpdateGuideArea()
        -- self:UpdateRoleClickArea()
    elseif self.needLayout == 3 then
        self:SetTipsAlign(self.curConfig.Align)
    elseif self.needLayout == 4 then
        -- if self.curConfig.GuideType == GuideType.GT_Click then
        self:SafeCheck()
    end
    
    if self.needLayout < protect_frame then
        self.needLayout = self.needLayout + 1
    else
        self.inProtect = false
        self.need_waitrefreashnode = self.need_waitrefreashnode  or 0
        if self.need_waitrefreashnode > 0 then 
            self.needLayout = 2
        elseif self.need_waitrefreashnode == 0 then 
            self:SafeCheck()
        end
        self.need_waitrefreashnode = self.need_waitrefreashnode - 1 
    end
end

function GuideUI:SafeCheck()
    if not self.objTarget then 
        -- 行为错误 需要安全处理
        self:DoSafe('cant find target object')
    end 
    if self.objArrw then 
        local rect = self.objArrw:GetComponent("RectTransform")
        local size_w = rect.sizeDelta.x
        local size_h = rect.sizeDelta.y
        local pos_x =  math.abs(self.objArrw.transform.localPosition.x) or 0 
        local pos_y =  math.abs(self.objArrw.transform.localPosition.y) or 0 
        if size_w < 30 or size_h < 30 then
            self:DoSafe('have a wrong size')
        elseif (pos_x + (size_w / 2) - 50) > (adapt_ui_w / 2) or (pos_y + (size_h / 2) - 50) > (adapt_ui_h / 2) then
            self:DoSafe('out of screen ；pos_x：'.. pos_x .. '，pos_y：'.. pos_y )
        end
    end
end
function GuideUI:OnEnable()

end

function GuideUI:OnDisable()
end

function GuideUI:OnDestroy()
    local t= 1
end

return GuideUI