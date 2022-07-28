ComicPlotUI = class("ComicPlotUI",BaseWindow)

local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function ComicPlotUI:Create()
	local obj = LoadPrefabAndInit("Game/ComicPlotUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ComicPlotUI:Init(removeFunc)
    self.imgTags = {}
    self.imgCount = 0

    local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    if shareGroupUI then
        if not MSDKHelper:IsPlayerTestNet() then

            local _callback = function(bActive)
                local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
                if serverAndUIDUI and serverAndUIDUI._gameObject then
                    serverAndUIDUI._gameObject:SetActive(bActive);
                end
            end

            self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
            self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.CG, _callback);

            local canvas = shareGroupUI:GetComponent('Canvas');
            if canvas then
                canvas.sortingOrder = 1236;
            end
        else
            shareGroupUI:SetActive(false);
        end
    end

    self.imgBG = self:FindChildComponent(self._gameObject,"root/Image","Image")
    self.shareGroupUI = shareGroupUI;
    self.obj_root = self:FindChild(self._gameObject,"root/GameObject")
    self.comButton_screen = self:FindChildComponent(self._gameObject,"Button_screen","Button")
    self.waitTime = nil
    self.waitClick = false
    self.increaseZOrder = 0
    self.removeFunc = removeFunc

    self:AddButtonClickListener(self.comButton_screen, function() 
        self:OnClickScreen()
    end)
end

function ComicPlotUI:OnClickScreen()
    if self.waitClick then
        self.waitClick = false
        if self.imgCount == 0 then
            if self.removeFunc then
                self.removeFunc()
            else
                RemoveWindowImmediately('ComicPlotUI')
            end
        end
        DisplayActionEnd()
        return true
    end
    return false
end

function ComicPlotUI:RefreshUI(config)
    if config == nil then 
        return
    end
    if config.waitclick then
        self:WaitClick()
    else
        self:AddIMG(config.imgtag, config.imgpath, config.x, config.y, config.alpha, config.fittype, config.cgType)
    end
end

function ComicPlotUI:AddIMG(imgtag, imgpath, x, y, alpha, fittype, cgType)
    if cgType then
        if self.shareGroupUI then
            self.shareGroupUI:SetActive(cgType == CGType.CGT_CG);
        end
    end

    if cgType == CGType.CGT_Comic then
        self.imgBG.color = DRCSRef.Color.white
    else
        self.imgBG.color = DRCSRef.Color.black
    end

    if type(fittype) == 'string' then
        fittype = tonumber(fittype)
    end

    fittype = fittype or ComicFitType.CFT_NULL

    if imgtag == '111' then
        imgtag = '-1'
        fittype = ComicFitType.CFT_FIT_ALL
        alpha = 255
    end

    if self.imgTags[imgtag] then
        self.imgCount = self.imgCount - 1

        local objImage = self.imgTags[imgtag]
        objImage.transform:SetParent(nil)
        DRCSRef.ObjDestroy(objImage)

        self.imgTags[imgtag] = nil
    end

    local zorder = 0
    local curtag = tonumber(imgtag)
    for k,v in pairs(self.imgTags) do
        k = tonumber(k) or 0
        if k < curtag then
            zorder = zorder + 1
        end
    end

    -- x = (tonumber(x) or 640) - 640
    -- y = (tonumber(y) or 360) - 360
    x = tonumber(x) or 0
    y = tonumber(y) or 0
    alpha = (tonumber(alpha) or 255)/255 or 0

    self.imgCount = self.imgCount + 1

    local objImage = DRCSRef.GameObject()
    local comImage = objImage:AddComponent(typeof(CS.UnityEngine.UI.Image))
   
    objImage.transform:SetParent(self.obj_root.transform)
    objImage:SetActive(true)
    objImage.transform.localPosition = DRCSRef.Vec3(x, y, 0)
    objImage.transform.localScale = DRCSRef.Vec3(1, 1, 1)
    comImage.color = DRCSRef.Color(1.0, 1.0, 1.0, alpha)
    objImage.transform:SetSiblingIndex(zorder)

    if imgpath and imgpath ~= '' then
        local pathinfo = self:GetCGByID(imgpath)
        local bgImg = ''
        if pathinfo then
            bgImg = pathinfo
        else
            bgImg = imgpath
        end
        comImage.sprite = GetSprite(bgImg)
        -- FIXME: 光记录图片可能不够
        BlurBackgroundManager:GetInstance():AddBgImg(bgImg)
    end
    comImage:SetNativeSize()
    if fittype == ComicFitType.CFT_FIT_ALL then
        local rectTransform = objImage.transform:GetComponent('RectTransform')
        rectTransform.anchorMax = DRCSRef.Vec2(1,1)
        rectTransform.anchorMin = DRCSRef.Vec2(0,0)
        rectTransform.offsetMax = DRCSRef.Vec2(0,0)
        rectTransform.offsetMin = DRCSRef.Vec2(0,0)
    elseif fittype == ComicFitType.CFT_NULL then
        comImage:SetNativeSize()
    elseif fittype == ComicFitType.CFT_FIT_NOBORDER then
        local rectTransform = objImage.transform:GetComponent('RectTransform')
		ratio = rectTransform.rect.width / rectTransform.rect.height
        local comARF = objImage:AddComponent(typeof(DRCSRef.AspectRatioFitter))
		if comARF then
			comARF.aspectMode = DRCSRef.AspectMode.EnvelopeParent
			comARF.aspectRatio = ratio
        end
    elseif fittype == ComicFitType.CFT_FIT_BORDER then
        local rectTransform = objImage.transform:GetComponent('RectTransform')
		ratio = rectTransform.rect.width / rectTransform.rect.height
        local comARF = objImage:AddComponent(typeof(DRCSRef.AspectRatioFitter))
		if comARF then
			comARF.aspectMode = DRCSRef.AspectMode.FitInParent
			comARF.aspectRatio = ratio
		end
    end

    self.imgTags[imgtag] = objImage

    DisplayActionEnd()
end

function ComicPlotUI:GetCGByID(id)
    local TB_ResourceCG = TableDataManager:GetInstance():GetTableData("ResourceCG", id)
    if (TB_ResourceCG) then
      return TB_ResourceCG.CGPath
    end

    return nil
end

function ComicPlotUI:MoveIMG(imgtag, x, y, alpha, dur, wait)
    if not self.imgTags[imgtag] then
        DisplayActionEnd()
        return
    end
    alpha = alpha / 255
    -- FIXME: 前人写的代码, 不知道什么含义
    if imgtag == '111' then 
        imgtag = '-1'
    end
    local secdur = dur / 1000
    local objImage = self.imgTags[imgtag]
    local comImage = objImage:GetComponent("Image")
    local targetPos = DRCSRef.Vec3(x, y, objImage.transform.localPosition.z)
    local targetColor = DRCSRef.Color(1.0, 1.0, 1.0, alpha)
    objImage.transform:DR_DOLocalMoveX(x, secdur)
    objImage.transform:DR_DOLocalMoveY(y, secdur)
    comImage:DOColor(targetColor, secdur)
   
    if not wait then
        DisplayActionEnd()
    else
        self.waitTime = dur + 10
    end
end

function ComicPlotUI:RemoveIMG(imgtag)
    if imgtag == '111' then
        imgtag = '-1'
    end
    
    if self.imgCount > 0 then 
        self.imgCount = self.imgCount - 1
    end

    if self.imgTags[imgtag] then 
        local objImage = self.imgTags[imgtag]
        objImage.transform:SetParent(nil)
        DRCSRef.ObjDestroy(objImage)
    end
    self.imgTags[imgtag] = nil

    if self.imgCount <= 0 then
        if self.removeFunc then
            self.removeFunc()
        else
            RemoveWindowImmediately('ComicPlotUI')
        end
    end
    DisplayActionEnd()
end

function ComicPlotUI:Update(deltaTime)
    if self.waitTime == nil then 
        return 
    end
    if self.waitTime > 0 then 
        self.waitTime = self.waitTime - deltaTime
    else
        self.waitTime = nil
        DisplayActionEnd()
    end
end

function ComicPlotUI:WaitClick()
    self.waitClick = true

    self:OnComicWait()
end

function ComicPlotUI:OnComicWait()
    -- 策划说漫画暂时不需要在 自动对话/快进模式下自动跳过
    -- 但是不排除之后策划又会需要这个需求, 暂时先注释掉一下代码
    -------------------------------------------------------------
    -- local bFastChatOpen = (kDialogRecMgr:IsFastChatOpen() == true)  -- 快进对话模式
    -- local bAutoChatOpen = (kDialogRecMgr:IsAutoChatOpen() == true)  -- 自动对话模式
    -- if bFastChatOpen or bAutoChatOpen then
    --     if self.iAutoChatTimer then
    --         self:RemoveTimer(self.iAutoChatTimer)
    --         self.iAutoChatTimer = nil
    --     end
    --     local uiWaitTime = 0
    --     if bFastChatOpen then
    --         uiWaitTime = FASTCHAT_COMIC_WAIT_TIME
    --     else
    --         uiWaitTime = PlayerSetDataManager:GetInstance():GetAutoChatWaitTime()
    --     end
    --     if (not uiWaitTime) or (uiWaitTime == 0) then
    --         return
    --     end
    --     -- 漫画的等待时间在用户值上增加三秒
    --     if not bFastChatOpen then
    --         uiWaitTime = uiWaitTime + 3000
    --     end
    --     self.iAutoChatTimer = self:AddTimer(uiWaitTime, function()
    --         -- 计时器到期触发点击漫画
    --         local win = GetUIWindow("ComicPlotUI")
    --         if not win then
    --             return
    --         end
    --         win:OnClickScreen()
    --     end)
    -- end
end

function ComicPlotUI:IsShow()
    if self.imgCount and self.imgCount > 0 then 
        return true
    end
    return false
end

function ComicPlotUI:OnDestroy()
    if self.TencentShareButtonGroupUI then
        self.TencentShareButtonGroupUI:Close();
    end
end

return ComicPlotUI
