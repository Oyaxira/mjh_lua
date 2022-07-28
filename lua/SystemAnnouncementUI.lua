SystemAnnouncementUI = class("SystemAnnouncementUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type
local whiteColor = DRCSRef.Color(1, 1, 1, 1)
local THANK_ANNOUNCEMENT_ID = 20


function SystemAnnouncementUI:Create()
	local obj = LoadPrefabAndInit("TownUI/SystemAnnouncementUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SystemAnnouncementUI:Init()
    local objRoot = self:FindChild(self._gameObject, 'Announcement_Node')
    self.comTitleText = self:FindChildComponent(objRoot, 'frame/Title', l_DRCSRef_Type.Text)
    local objBtns = self:FindChild(objRoot, 'Btns')
    local objBtnOk = self:FindChild(objBtns, 'ButtonOk')
    self.textBtnOk = self:FindChildComponent(objBtnOk, 'Text', l_DRCSRef_Type.Text)
    local btnOk = objBtnOk:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnOk, function()
        self:OnClickOkBtn()
    end)
    self.objBtn2Url = self:FindChild(objBtns, 'ButtonShowUrl')
    local btn2Url = self.objBtn2Url:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btn2Url, function()
        self:OnClick2UrlBtn()
    end)

    --self.objTextInfoNotice = self:FindChild(objRoot, "PicViewer")
    --local objContent = self:FindChild(self.objTextInfoNotice, "Viewport/Content")
    -- self.contentTitle = self:FindChildComponent(objContent, "Text_title", l_DRCSRef_Type.Text)
    -- self.contentText = self:FindChildComponent(objContent, "Text_word", l_DRCSRef_Type.Text)

    self.objPicListNotice = self:FindChild(objRoot, "PicViewer")
    self.objPicNoticeTitle = self:FindChild(self.objPicListNotice, "Picture/Viewport/Content/Title")
    self.textPicNoticeTitle = self.objPicNoticeTitle:GetComponent(l_DRCSRef_Type.Text)
    self.imgPicNotice = self:FindChildComponent(self.objPicListNotice, "Picture/Viewport/Content/Image", l_DRCSRef_Type.Image)
    self.btnPicNotice = self:FindChildComponent(self.objPicListNotice, "Picture/Viewport/Content/Image", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnPicNotice, function()
        self:OnClickPicNotice()
    end)
    self.comRatioPicNotice = self:FindChildComponent(self.objPicListNotice, "Picture/Viewport/Content/Image", l_DRCSRef_Type.AspectRatioFitter)
    self.transPicNoticeContent = self:FindChildComponent(self.objPicListNotice, "Picture/Viewport/Content", l_DRCSRef_Type.Transform)
    self.rectTransPicNoticeContent = self:FindChildComponent(self.objPicListNotice, "Picture/Viewport/Content", l_DRCSRef_Type.RectTransform)
    self.objBtnPicLeft = self:FindChild(self.objPicListNotice, "BtnLeft")
    self.objBtnPicRight = self:FindChild(self.objPicListNotice, "BtnRight")
    local btnPicLeft = self.objBtnPicLeft:GetComponent(l_DRCSRef_Type.Button)
    local btnPicRight = self.objBtnPicRight:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnPicLeft, function()
        self:OnClickPiclLeft()
    end)
    self:AddButtonClickListener(btnPicRight, function()
        self:OnClickPiclRight()
    end)

    self.objLoading = self:FindChild(objRoot, "Loading")
    self.objEmpty = self:FindChild(objRoot, "Empty")

    self.comCloseButton = self:FindChildComponent(objRoot, "frame/Btn_exit", l_DRCSRef_Type.Button)
    if self.comCloseButton then
        self:AddButtonClickListener(self.comCloseButton, function()
            self:OnClickOkBtn()
        end)
    end

    --定义公告的相关内容
    self.objLeftSC = self:FindChild(self.objPicListNotice, "LeftSC")
    self.objRightContnet = self:FindChild(self.objPicListNotice, "RightContnet")

    self.objLeftSCContnet = self:FindChild(self.objLeftSC, "Viewport/Content")



    self.txtHeadline = self:FindChildComponent(self.objRightContnet, "content_Notice/TopTitle/Image_headline/Text_headline", l_DRCSRef_Type.Text)
    self.txtMainBody = self:FindChildComponent(self.objRightContnet, "content_Notice/SC_content/Viewport/Content/Text_mainBody", l_DRCSRef_Type.Text)
    self.objType = self:FindChild(self.objRightContnet, "content_Notice/TopTitle/Image_headline/Type")
    self.objAnnouncementItem = self:FindChild(self.objPicListNotice, "AnnouncementItem")
    self.objAnnouncementItem:SetActive(false)
end

function SystemAnnouncementUI:SetLeftSCItemData(obj, data)
    local releaseTimeData = data.ReleaseTime
    local refreshTimeData = data.RefreshTime

    local txtShortTitle = self:FindChildComponent(obj, "Title/Text_shortTitle", l_DRCSRef_Type.Text)
    local txtReleaseTime = self:FindChildComponent(obj, "Text_releaseTime", l_DRCSRef_Type.Text)
    local txtRefreshTime = self:FindChildComponent(obj, "Text_refreshTime", l_DRCSRef_Type.Text)
    local objType = self:FindChild(obj, "Title/Type")
    txtShortTitle.text = data.ShortHeadline
    txtReleaseTime.text = string.format("%d/%d/%d %d:%02d",releaseTimeData.Year,releaseTimeData.Month,releaseTimeData.Day,releaseTimeData.Hour,releaseTimeData.Minute)
    if self:GetCompareTime(releaseTimeData,refreshTimeData) then
        txtRefreshTime.text = ""
    else
        txtRefreshTime.text = string.format("(更新: %d/%d/%d %d:%02d)",refreshTimeData.Year,refreshTimeData.Month,refreshTimeData.Day,refreshTimeData.Hour,refreshTimeData.Minute)
    end
    self:SetAnnouncementType(objType, data.Type)
    local btnClick = self:FindChildComponent(obj, "Btn_Click","Button")
    --self:SetAnnouncementType(obj,data.Type)
    if btnClick then
        self:RemoveButtonClickListener(btnClick)
        self:AddButtonClickListener(btnClick, function()
            self:ChangeLeftSCItemData(obj)
            self:ChangeRightContnetData(data)
        end)
    end
end

function SystemAnnouncementUI:GetCompareTime(releaseTimeData,refreshTimeData)
    local releaseTime = releaseTimeData.Year * 100000000 + releaseTimeData.Month * 1000000 + releaseTimeData.Day * 10000 
    + releaseTimeData.Hour * 100 + releaseTimeData.Minute
    local refreshTime = refreshTimeData.Year * 100000000 + refreshTimeData.Month * 1000000 + refreshTimeData.Day * 10000 
    + refreshTimeData.Hour * 100 + refreshTimeData.Minute

    if releaseTime ~= refreshTime then
        return false
    end
    return true
end

function SystemAnnouncementUI:ChangeLeftSCItemData(obj)
    --local content = self:FindChild(self.objLeftSCMails, 'Content');
    for k, v in pairs(self.objLeftSCContnet.transform) do
        if obj and obj == v.gameObject then
            self:FindChildComponent(v.gameObject, 'Title/Text_shortTitle', 'Text').color = RANK_COLOR[RankType.RT_White]
            self:FindChildComponent(v.gameObject, 'Text_releaseTime', 'Text').color = RANK_COLOR[RankType.RT_White]
            self:FindChildComponent(v.gameObject, 'Text_refreshTime', 'Text').color = RANK_COLOR[RankType.RT_White]
            self:FindChild(v.gameObject, 'Checkmark'):SetActive(true);
        else
            self:FindChildComponent(v.gameObject, 'Title/Text_shortTitle', 'Text').color = COLOR_VALUE[COLOR_ENUM.Black]
            self:FindChildComponent(v.gameObject, 'Text_releaseTime', 'Text').color = COLOR_VALUE[COLOR_ENUM.Black]
            self:FindChildComponent(v.gameObject, 'Text_refreshTime', 'Text').color = COLOR_VALUE[COLOR_ENUM.Black]
            self:FindChild(v.gameObject, 'Checkmark'):SetActive(false);
        end
    end
end

function SystemAnnouncementUI:ChangeRightContnetData(data)
    self.txtHeadline.text = data.Headline
    self.txtMainBody.text = data.MainBody
    self:SetAnnouncementType(self.objType, data.Type)
end

function SystemAnnouncementUI:SetAnnouncementType(obj, dataType)
    local objUpdate = self:FindChild(obj, "Image_update")
    local objProblem = self:FindChild(obj, "Image_problem")
    local objNotice = self:FindChild(obj, "Image_notice")
    local objTypeList = {objUpdate,objProblem,objNotice}
    for index, objType in ipairs(objTypeList) do
        objType:SetActive(false)
    end
    dataType =  tonumber(dataType)
    if objTypeList[dataType] then
        obj:SetActive(true)
        objTypeList[dataType]:SetActive(true)
    else
        obj:SetActive(false)
    end  
end


function SystemAnnouncementUI:OnPressESCKey()
    if self.comCloseButton then
	    self.comCloseButton.onClick:Invoke()
    end
end

function SystemAnnouncementUI:RefreshUI(kData)
    self.iCurSystemType = kData.eType
    self.comTitleText.text = self.iCurSystemType == SYSTEM_ANNOUNCEMENT_TYPE.Notice and "公告" or "致谢"
    self:SetUserClickState(kData.bIsUserClick)
    local akLuaNoticeList = kData.akLuaNoticeList
    if not akLuaNoticeList then
        self:SetBoardState(NoticeState.Loading)
        return
    end
    for i = #akLuaNoticeList ,1, -1 do
        if self.iCurSystemType == SYSTEM_ANNOUNCEMENT_TYPE.Notice and tonumber(akLuaNoticeList[i].Type) == THANK_ANNOUNCEMENT_ID then
            table.remove(akLuaNoticeList, i)
        elseif self.iCurSystemType == SYSTEM_ANNOUNCEMENT_TYPE.Thank and tonumber(akLuaNoticeList[i].Type) ~= THANK_ANNOUNCEMENT_ID then
            table.remove(akLuaNoticeList, i)
        end
    end
    -- 将公告信息缓存
    self.akCacheNoticeList = akLuaNoticeList
    if #self.akCacheNoticeList == 0 then
        self:SetBoardState(NoticeState.Empty)
        return
    end
    -- 从第一条开始
    self.iCurIndex = 1
    --self:UpdateOkBtnStyle()
    self:SetCurNotice()
end

function SystemAnnouncementUI:SetBoardState(eState)
    local bIsNormal = eState == NoticeState.Normal
    local bIsEmpty = eState == NoticeState.Empty
    local bIsLoading = eState == NoticeState.Loading
    local bIsPickList = eState == NoticeState.Pics

    self.objEmpty:SetActive(bIsEmpty)
    self.objLoading:SetActive(bIsLoading)
    self.objPicListNotice:SetActive(bIsNormal)
    --self.objPicListNotice:SetActive(bIsNormal)

    if bIsLoading or bIsEmpty then
        self.bHasNextNotice = false
        self.textBtnOk.text = "关闭"
    end
end

function SystemAnnouncementUI:SetCurNotice()
    if not (self.akCacheNoticeList and self.iCurIndex) then
        return
    end
    local kNotice = self.akCacheNoticeList[self.iCurIndex]
    if not kNotice then
        return
    end
    -- 旧 公告技术组 公告结构
    -- if not (kNotice.content and next(kNotice.content)) then
    --     return
    -- end
    local kContent = kNotice
    self:RemoveAllChildToPool(self.objLeftSCContnet.transform)
    
    for key, titleScreenData in ipairs(self.akCacheNoticeList) do
        local objClone = self:LoadGameObjFromPool(self.objAnnouncementItem, self.objLeftSCContnet)
        objClone:SetActive(true)
        self:SetLeftSCItemData(objClone,titleScreenData)
    end
    self:ChangeRightContnetData(kContent)
    self:ChangeLeftSCItemData(self.objLeftSCContnet.transform:GetChild(0).gameObject)
    self:SetBoardState(NoticeState.Normal)
    -- -- 新 MSDK公告结构
    -- self.strGotoUrl = nil
    -- self.objBtn2Url:SetActive(false)
    -- self.strPicGotoUrl = nil
    -- self.btnPicNotice.interactable = false
    -- -- 获取重定向链接
    -- local strRedirectURL = nil
    -- if kNotice.TextInfo
    -- and kNotice.TextInfo.NoticeRedirectUrl
    -- and (kNotice.TextInfo.NoticeRedirectUrl ~= "") then
    --     strRedirectURL = kNotice.TextInfo.NoticeRedirectUrl
    -- end
    -- -- 文字公告
    -- if kNotice.TextInfo 
    -- and kNotice.TextInfo.NoticeTitle
    -- and (kNotice.TextInfo.NoticeTitle ~= "")
    -- and kNotice.TextInfo.NoticeContent
    -- and (kNotice.TextInfo.NoticeContent ~= "") then
    --     local kTextInfo = kNotice.TextInfo
    --     self.contentTitle.text = kTextInfo.NoticeTitle
    --     self.contentText.text = kTextInfo.NoticeContent
    --     if strRedirectURL then
    --         -- 显示 去完成 按钮, 跳转重定向链接
    --         self.strGotoUrl = strRedirectURL
    --         self.objBtn2Url:SetActive(true)
    --     end
    --     self:SetBoardState(NoticeState.Normal)
    -- -- 图片列表公告
    -- elseif kNotice.PicUrlList
    -- and kNotice.PicUrlList.Count
    -- and (kNotice.PicUrlList.Count > 0) then
    --     local bNeedSwitch = (kNotice.PicUrlList.Count > 1)
    --     self.objBtnPicLeft:SetActive(bNeedSwitch)
    --     self.objBtnPicRight:SetActive(bNeedSwitch)
    --     self.listPicNotices = kNotice.PicUrlList
    --     self.iCurPicNoticeIndex = 0
    --     self:SetCurPicNotice()
    --     if strRedirectURL then
    --         -- 设置点击图片跳转
    --         self.strPicGotoUrl = strRedirectURL
    --         self.btnPicNotice.interactable = true
    --     end
    --     self:SetBoardState(NoticeState.Pics)
    -- -- 暂时没有用到 网页公告
    -- -- elseif kNotice.WebUrl
    -- -- and (kNotice.WebUrl ~= "") then
    -- end
end

-- 刷新确定按钮
function SystemAnnouncementUI:UpdateOkBtnStyle()
    if not self.akCacheNoticeList then
        return
    end
    self.bHasNextNotice = self.iCurIndex < #(self.akCacheNoticeList or {})
    self.textBtnOk.text = self.bHasNextNotice and "下一条" or "我知道了"
end

-- 设置当前图片公告
function SystemAnnouncementUI:SetCurPicNotice()
    if not self.listPicNotices then
        return
    end
    if not self.iCurPicNoticeIndex then
        self.iCurPicNoticeIndex = 0
    end
    local kPicNotice = self.listPicNotices[self.iCurPicNoticeIndex]
    if (not kPicNotice) then
        return
    end
    local strTitle = kPicNotice.NoticePicTitle
    if (not strTitle) or (strTitle == "") then
        self.objPicNoticeTitle:SetActive(false)
    else
        self.textPicNoticeTitle.text = strTitle
        self.objPicNoticeTitle:SetActive(true)
    end
    local strUrlPic = kPicNotice.NoticePicUrl
    if (not strUrlPic) or (strUrlPic == "") then
        return
    end
    GetHeadPicByUrl(strUrlPic, function(sprite)
        local win = GetUIWindow("SystemAnnouncementUI")
        if (not win) or (not win.imgPicNotice) then
            return
        end
        win.imgPicNotice.sprite = sprite
    end)
    -- 设置图片宽高
    local strPicSize = kPicNotice.NoticePicSize or ""  -- "310x450"
    local iStartIndex, iEndIndex, iWidth, iHeight = string.find(strPicSize, "(%d+)x(%d+)")
    local fRatio = 0
    iWidth = tonumber(iWidth)
    iHeight = tonumber(iHeight)
    if iWidth and (iWidth > 0) and iHeight and (iHeight > 0) then
        fRatio = iWidth / iHeight
    end
    if fRatio > 0 then
        self.comRatioPicNotice.aspectRatio = fRatio
    end
    -- Rebuild
    DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransPicNoticeContent)
    -- 置顶
    local v3Pos = self.transPicNoticeContent.localPosition
    v3Pos.y = 0
    self.transPicNoticeContent.localPosition = v3Pos
end

function SystemAnnouncementUI:OnClickOkBtn()
    if self.bHasNextNotice == true then
        -- show next notice
        self.iCurIndex = self.iCurIndex + 1
        self:UpdateOkBtnStyle()
        self:SetCurNotice()
    else
        RemoveWindowImmediately("SystemAnnouncementUI",true)
    end
end

function SystemAnnouncementUI:ProcessURL(strOriURL)
    if (not strOriURL) or (strOriURL == "") then
        return false
    end
    local iZone = GetConfig("LoginZone")
    if (not MSDK_OS) or (not iZone) then
        return false
    end
    local strTarURL = string.format("%s?os=%s&areaid=%s", strOriURL, tostring(MSDK_OS), tostring(iZone))
    return true, strTarURL
end

function SystemAnnouncementUI:OnClick2UrlBtn()
    local bCanVisit, strTarURL = self:ProcessURL(self.strGotoUrl)
    if not bCanVisit then
        return
    end
    DRCSRef.MSDKWebView.OpenUrl(strTarURL)
end

function SystemAnnouncementUI:OnClickPicNotice()
    local bCanVisit, strTarURL = self:ProcessURL(self.strPicGotoUrl)
    if not bCanVisit then
        return
    end
    DRCSRef.MSDKWebView.OpenUrl(strTarURL)
end

function SystemAnnouncementUI:OnClickPiclLeft()
    if (not self.listPicNotices) or (not self.iCurPicNoticeIndex) then
        return
    end
    local iPreIndex = self.iCurPicNoticeIndex - 1
    if not self.listPicNotices[iPreIndex] then
        return
    end
    self.iCurPicNoticeIndex = iPreIndex
    self:SetCurPicNotice()
end

function SystemAnnouncementUI:OnClickPiclRight()
    if (not self.listPicNotices) or (not self.iCurPicNoticeIndex) then
        return
    end
    local iNextIndex = self.iCurPicNoticeIndex + 1
    if not self.listPicNotices[iNextIndex] then
        return
    end
    self.iCurPicNoticeIndex = iNextIndex
    self:SetCurPicNotice()
end

function SystemAnnouncementUI:SetUserClickState(bOn)
    self.bIsUserClick = (bOn == true)
end

-- 是否是用户主动点击进公告?
function SystemAnnouncementUI:IsUserClick()
    return (self.bIsUserClick == true)
end

return SystemAnnouncementUI