local dkJson = require("Base/Json/dkjson")
DiscussUI = class('DiscussUI', BaseWindow);


function DiscussUI:ctor()
end

function DiscussUI:Create()
	local obj = LoadPrefabAndInit('DiscussAreaUI/DiscussAreaUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function DiscussUI:Init()
    self.discussMgr = DiscussDataManager:GetInstance()
    self.playerid = tostring(globalDataPool:getData("PlayerID"));
    self.lastCommentCD = 60
    
    self.obj_btn_back = self:FindChildComponent(self._gameObject, "PopUpWindow_4/Board/Button_close", "Button") 
	if self.obj_btn_back then
		self:RemoveButtonClickListener(self.obj_btn_back)
        self:AddButtonClickListener(self.obj_btn_back, function ()
            RemoveWindowImmediately('DiscussUI')
        end)
    end
    self.obj_panel = self:FindChild(self._gameObject,"PopUpWindow_4/Board/Panel")
    self.txt_title = self:FindChildComponent(self.obj_panel, "Image_title/Text", "Text")
    
    self.obj_hotCommentsPart = self:FindChild(self.obj_panel,"Left") 
    self.obj_hotCommentsPart_list = self:FindChild(self.obj_hotCommentsPart, "LoopView_discuss/Content")
    self.obj_hotCommentsPart_LoopScrollView = self:FindChildComponent(self.obj_hotCommentsPart,"LoopView_discuss","LoopVerticalScrollRect")
    if self.obj_hotCommentsPart_LoopScrollView then
        self.obj_hotCommentsPart_LoopScrollView:AddListener(function(...) self:OnHotCommentsContentChanged(...) end)
    end

    self.obj_newCommentsPart = self:FindChild(self.obj_panel,"Right")
    self.obj_newCommentsPart_list = self:FindChild(self.obj_newCommentsPart, "LoopView_discuss/Content")
    self.obj_newCommentsPart_LoopScrollView = self:FindChildComponent(self.obj_newCommentsPart,"LoopView_discuss","LoopVerticalScrollRect")
    if self.obj_newCommentsPart_LoopScrollView then
        self.obj_newCommentsPart_LoopScrollView:AddListener(function(...) self:OnNewCommentsContentChanged(...) end)
    end

    self.obj_emptyBG = self:FindChild(self.obj_panel,"Empty")
    self.obj_emptyBG:SetActive(false)

    self.obj_inputBox = self:FindChildComponent(self.obj_panel, "SendArea/InputField", "InputField")
    --?????????????????? ?????????????????????
    self.commentIdForInputBox = nil
    self.obj_inputBox.onValueChanged:AddListener(function(newString,oldString)
		self:CheckCommentLength(newString,self.obj_inputBox)
    end)
    self.txt_inputBoxPlaceholder = self:FindChildComponent(self.obj_panel, "SendArea/InputField/Placeholder", DRCSRef_Type.Text)
    self.obj_inputBox.onEndEdit:AddListener(function(newString,oldString)
        dprint("###onEndEdit")
        self.txt_inputBoxPlaceholder.text = "??????????????????50????????????" 
    end)

    --????????????????????? ????????????????????????
    self.btn_inputBox = self:FindChildComponent(self.obj_panel, "SendArea/InputField", "LuaUIAction")
	if self.btn_inputBox then
        self.btn_inputBox:SetPointerClickAction(function(obj, eventData) 
            dprint("### onPointerClick")
            self.commentIdForInputBox = nil
        end)
	end    

    self.btn_sendComment = self:FindChildComponent(self.obj_panel, "SendArea/Button_send", "Button")
    self:AddButtonClickListener(self.btn_sendComment, function()
        self:OnClickSendComment()
    end)
    self.txt_sendComment = self:FindChildComponent(self.obj_panel, "SendArea/Button_send/Text", "Text")

end

function DiscussUI:SetNowArticle(articleId)
    self.discussMgr:GetArticle(articleId,function(data)
        self.nowArticleId = articleId
        self.txt_title.text = data.title
        self.replyNumList = {}
        if (data.total_comment == 0) then
            self.obj_emptyBG:SetActive(true)
        else
            self:RefreshComments()
        end
    end)
end

function DiscussUI:RefreshComments()
    self.obj_emptyBG:SetActive(false)
    self.discussMgr:GetHottestComment(100,1,function(hdata)
        self.hotCommentsList = hdata
        if self.obj_hotCommentsPart_LoopScrollView then
            self.obj_hotCommentsPart_LoopScrollView.totalCount = getTableSize(self.hotCommentsList)
            self.obj_hotCommentsPart_LoopScrollView:RefillCells()
        end
    end)

    self.discussMgr:GetNewestComment(100,1,function(ndata)
        self.newCommentsList = ndata
        if self.obj_newCommentsPart_LoopScrollView then
            self.obj_newCommentsPart_LoopScrollView.totalCount = getTableSize(self.newCommentsList)
            self.obj_newCommentsPart_LoopScrollView:RefillCells()
        end
    end) 
end

function DiscussUI:OnHotCommentsContentChanged(gameobj,index)
    local obj = self:FindChild(gameobj.gameObject,'Self')
    self:RefreshCommentsItem(obj,self.hotCommentsList,index)
end

function DiscussUI:OnNewCommentsContentChanged(gameobj,index)
    local obj = self:FindChild(gameobj.gameObject,'Self')
    self:RefreshCommentsItem(obj,self.newCommentsList,index)
end	

function DiscussUI:QueryHeadPic(commentsList,index,headPic)
    if self.timerList == nil then
        self.timerList = {}
    end
    local timerIndex = #self.timerList+1
    local timer = globalTimer:AddTimer(500,function()
        --dprint("qqqq")
        local dataComment
        if (index == -1) then
            dataComment = commentsList
        else
            dataComment = commentsList[index+1]
        end
        --????????????????????????????????? ??????sprite????????? ?????? ???Image??????????????? ?????????
        if dataComment.charPic~=nil or not IsValidObj(headPic) then           
            headPic.sprite = dataComment.charPic
            self:StopQuery(timerIndex)
        end
    end,-1)
    self.timerList[timerIndex] = timer
end

function DiscussUI:StopQuery(timerIndex)
    globalTimer:RemoveTimerNextFrame(self.timerList[timerIndex])
    self.timerList[timerIndex] = nil
end


-- ???????????? ???????????? ??????item(noReplyOpen = nil) ??? ????????????item(noReplyOpen = false)
function DiscussUI:RefreshCommentsItem(objComment,commentsList,index,noReplyOpen)
    if (commentsList==nil) then
        return
    end
    local dataComment
    if (index == -1) then
        dataComment = commentsList
    else
        dataComment = commentsList[index+1]
    end

    if (noReplyOpen == nil) then
        local objTextBottom = self:FindChild(objComment.transform.parent.gameObject,'Text_bottom')
        if objTextBottom then
            if (index+1 == #commentsList) then
                objTextBottom:SetActive(true)
            else
                objTextBottom:SetActive(false)
            end
        end
    end

    local txtCreaterNickname = self:FindChildComponent(objComment,'Button_name/name','Text')
    local nickNameWithServerName = dataComment.create_nickname
    
    local self_strServerNameKey = string.format("LoginServerName_%s", tostring(GetConfig("LoginZone")))
    local self_serverName = GetConfig(self_strServerNameKey)
    local serverName
    if (dataComment.create_user_extra and dataComment.create_user_extra['ServerName']) then
        serverName = dataComment.create_user_extra['ServerName']
        if (self_serverName == serverName) then
            nickNameWithServerName = dataComment.create_nickname.."(<color=#3D7B2C>"..serverName.."</color>)"
        else
            nickNameWithServerName = dataComment.create_nickname.."("..serverName..")"
        end
    end
    if (dataComment.isMine) then
        nickNameWithServerName = "<color=#3D7B2C>"..nickNameWithServerName.."</color>"
    end
    txtCreaterNickname.text = nickNameWithServerName

    local btnPlayer = self:FindChildComponent(objComment,'Button_name','Button')
    if (btnPlayer) then
        self:RemoveButtonClickListener(btnPlayer)
        if (serverName) then
            --???????????? ?????????????????? ?????????????????????   
            if (self_serverName == serverName) then
                self:AddButtonClickListener(btnPlayer, function()
                    local playerId = dataComment.create_user_extra['PlayerID']
                    if (playerId ~= nil) then
                        SendGetPlatPlayerDetailInfo(playerId, RLAYER_REPORTON_SCENE.UserBoard)
                    else 
                        SystemUICall:GetInstance():Toast('???????????????,???????????????????????????',false)
                    end
                    --SendGetPlatPlayerDetailInfo(dataComment.create_user_id, RLAYER_REPORTON_SCENE.UserBoard)
                end)
            else
                self:AddButtonClickListener(btnPlayer, function()
                    SystemUICall:GetInstance():Toast('???????????????????????????????????????',false)
                end)
            end
        end
    end
    local btnPlayerHead = self:FindChildComponent(objComment,'Head','Button')
    if (btnPlayerHead) then
        self:RemoveButtonClickListener(btnPlayerHead)
        local headPic = self:FindChildComponent(objComment,'Head/Mask/Image','Image')
        if (headPic) then
            if (dataComment.charPic) then
                headPic.sprite = dataComment.charPic
            else
                GetHeadPicByModelId(0,function(sprite)
                    headPic.sprite = sprite
                end)
                if(dataComment.charPic==nil and dataComment.create_avatar~=nil and dataComment.create_avatar~="") then
                    self:QueryHeadPic(commentsList,index,headPic)
                end
            end
        end
        if (serverName) then
            --???????????? ???????????? ?????????????????????   
            if (self_serverName == serverName) then
                self:AddButtonClickListener(btnPlayerHead, function()
                    local playerId = dataComment.create_user_extra['PlayerID']
                    if (playerId ~= nil) then
                        SendGetPlatPlayerDetailInfo(playerId, RLAYER_REPORTON_SCENE.UserBoard)
                    else 
                        SystemUICall:GetInstance():Toast('???????????????,???????????????????????????',false)
                    end
                    --SendGetPlatPlayerDetailInfo(dataComment.create_user_id, RLAYER_REPORTON_SCENE.UserBoard)
                end)
            else
                self:AddButtonClickListener(btnPlayerHead, function()
                    SystemUICall:GetInstance():Toast('???????????????????????????????????????',false)
                end)
            end
        end
    end
    
    local txtCommentsContent = self:FindChildComponent(objComment,'Button_discussword/name','Text')
    if (dataComment.target_comment_id == 0 or dataComment.target_comment_id == dataComment.root_comment_id) then
        txtCommentsContent.text = dataComment.body
    else
        txtCommentsContent.text = "??????"..dataComment.target_nickname..":"..dataComment.body
    end

    local txtLikeNum = self:FindChildComponent(objComment,'Button_good/number','Text')
    local commentLikeNum = dataComment.like
    if (commentLikeNum == nil) then
        commentLikeNum = 0
    end
    if (commentLikeNum < 10000) then
        txtLikeNum.text = commentLikeNum
    else
        local numPer = commentLikeNum/10000
        --???10000???1?????????
        local numPer1 = numPer - numPer%0.1
        --a??????????????? b???????????????
        local a,b = math.modf(numPer1);
        if (a>9 or b==0) then
            txtLikeNum.text = a.."???" 
        else 
            txtLikeNum.text = numPer1.."???"
        end
    end
    local objHasLike = self:FindChild(objComment,'Button_good/number/Image_active')
    objHasLike:SetActive(dataComment.hasLike)

    -- ??????????????? ???????????????????????? ?????????commentId ??? ??????nickname
    local btnCommentsContent = self:FindChildComponent(objComment,'Button_discussword','Button')
    self:RemoveButtonClickListener(btnCommentsContent)
    self:AddButtonClickListener(btnCommentsContent, function()
        if self.canTalk then
            self.obj_inputBox:ActivateInputField()
            local parentT
            if (noReplyOpen == nil) then
                parentT = objComment.transform.parent.gameObject
            else
                parentT = objComment.transform.parent.parent.gameObject
            end
            self.commentIdForInputBox = {['id'] = dataComment.id,['nickname'] = dataComment.create_nickname,['parentTransform'] = parentT}
            self.txt_inputBoxPlaceholder.text = "??????"..dataComment.create_nickname..":"
        end
    end)
    -- ??????????????? ??????
    local btnReplyActive = self:FindChildComponent(objComment,'Button_discussword2','Button')
    if (btnReplyActive) then
        self:RemoveButtonClickListener(btnReplyActive)
        self:AddButtonClickListener(btnReplyActive, function()
            if self.canTalk then
                self.obj_inputBox:ActivateInputField()
                self.commentIdForInputBox = {['id'] = dataComment.id,['nickname'] = dataComment.create_nickname,['parentTransform'] = objComment.transform.parent.gameObject}
                self.txt_inputBoxPlaceholder.text = "??????"..dataComment.create_nickname..":"
            end
        end)
    end

    -- ????????????
    local btnLike = self:FindChildComponent(objComment,'Button_good','Button')
    self:RemoveButtonClickListener(btnLike)
    self:AddButtonClickListener(btnLike, function()
        if (dataComment.hasLike) then
            self.discussMgr:ClickUnlike(dataComment.id,function(data)
                --?????????commentList??????????????????
                commentsList[index+1].hasLike = data.hasLike
                commentsList[index+1].like = data.like
                self:RefreshCommentsItem(objComment,commentsList,index)
            end)
        else
            self.discussMgr:ClickLike(dataComment.id,function(data)
                --?????????commentList??????????????????
                commentsList[index+1].hasLike = data.hasLike
                commentsList[index+1].like = data.like
                self:RefreshCommentsItem(objComment,commentsList,index)
            end)
        end        
    end)

    -- ????????????item??????????????????
    if (noReplyOpen==nil) then 
        --?????????
        local objReplyOpen = self:FindChild(objComment,'Button_replies')
        local objReplyContentsNode = self:FindChild(objComment.transform.parent.gameObject,'Others_node')
        if (objReplyContentsNode) then
            objReplyContentsNode:SetActive(false)
            RemoveAllChildren(objReplyContentsNode)
        end
        -- local objReplyContentsItem = self:FindChild(objReplyContentsNode,'Others')
        -- if (objReplyContentsItem) then
        --     objReplyContentsItem:SetActive(false)
        -- end
        if (dataComment.reply_nums ~= nil and dataComment.reply_nums > 0) then
            if (not self.replyNumList[dataComment.id]) then
                self.replyNumList[dataComment.id] = dataComment.reply_nums
            end

            objReplyOpen:SetActive(true)
            local txtReplyNum = self:FindChildComponent(objReplyOpen,'name','Text')
            txtReplyNum.text = "??????"..self.replyNumList[dataComment.id].."?????????" 
            local btnReplyOpen = self:FindChildComponent(objComment,'Button_replies','Button')
            self:RemoveButtonClickListener(btnReplyOpen)
            self:AddButtonClickListener(btnReplyOpen, function()
                self:OnClickGetCommentReply(dataComment.id,objComment.transform.parent.gameObject)
            end)
        else
            objReplyOpen:SetActive(false)       
        end
    end
end

function DiscussUI:OnClickGetCommentReply(commentId,objComment)
    local replyNum = self.replyNumList[commentId]
    local txtReplyNum = self:FindChildComponent(objComment,'Button_replies/name','Text')
    local objReplyContentsNode = self:FindChild(objComment,'Others_node')
    if (objReplyContentsNode.activeSelf) then
        objReplyContentsNode:SetActive(false)
        RemoveAllChildren(objReplyContentsNode)
        txtReplyNum.text = "??????"..replyNum.."?????????" 
    else
        if (txtReplyNum.text ~= "?????????...") then
            -- ??????3?????????
            DiscussDataManager:GetInstance():GetAllReplyComment(commentId,3,1,function(data)
                local replyCommentsList = data
                for k,v in pairs(replyCommentsList) do
                    local objItem = LoadPrefabAndInit('DiscussAreaUI/DiscussReplyItem', objReplyContentsNode)
                    if (objItem ~= nil) then
                        objItem:SetActive(true)
                        self:RefreshCommentsItem(objItem,replyCommentsList,k-1,false)
                        if (k==#replyCommentsList and k<replyNum) then
                            local btnMoreReply = self:FindChildComponent(objItem,"Button_replies","Button")
                            btnMoreReply.gameObject:SetActive(true)
                            local txtMoreReply = self:FindChildComponent(objItem,"Button_replies/name","Text")
                            txtMoreReply.text = "??????????????????"
                            self:RemoveButtonClickListener(btnMoreReply)
                            self:AddButtonClickListener(btnMoreReply, function()
                                btnMoreReply.gameObject:SetActive(false)
                                self:OnClickGetMoreReply(commentId,objReplyContentsNode,3,2,replyNum)
                            end)
                        end
                    end
                end
                objReplyContentsNode:SetActive(true)
                txtReplyNum.text = "????????????"
            end,1)
            txtReplyNum.text = "?????????..."
        end
    end
end

function DiscussUI:OnClickGetMoreReply(commentId,objComment,pageSize,pageIndex,replyTotal)
    DiscussDataManager:GetInstance():GetAllReplyComment(commentId,pageSize,pageIndex,function(data)
        local replyCommentsList = data
        for k,v in pairs(replyCommentsList) do
            local objItem = LoadPrefabAndInit('DiscussAreaUI/DiscussReplyItem', objComment)
            if (objItem ~= nil) then
                objItem:SetActive(true)
                self:RefreshCommentsItem(objItem,replyCommentsList,k-1,false)
                if (k==#replyCommentsList and pageSize*(pageIndex-1)+k<replyTotal) then
                    local btnMoreReply = self:FindChildComponent(objItem,"Button_replies","Button")
                    btnMoreReply.gameObject:SetActive(true)
                    local txtMoreReply = self:FindChildComponent(objItem,"Button_replies/name","Text")
                    txtMoreReply.text = "??????????????????"
                    self:RemoveButtonClickListener(btnMoreReply)
                    self:AddButtonClickListener(btnMoreReply, function()
                        btnMoreReply.gameObject:SetActive(false)
                        self:OnClickGetMoreReply(commentId,objComment,pageSize,pageIndex+1,replyTotal)
                    end)
                end   
            end
        end
    end,1)
end

function DiscussUI:CheckCommentLength(newString,objText)
	local iStringLen = string.stringWidth(newString)
	if iStringLen > 50*2 then
		SystemUICall:GetInstance():Toast('?????????????????????50???!',false)
		if objText then
			objText.text = self.oldText
		end
		return false
	else
		self.oldText = newString
		return true
	end
end

function DiscussUI:OnClickSendComment()
    local strComment = self.obj_inputBox.text
	if (not strComment) or (strComment == "") then
		SystemUICall:GetInstance():Toast("??????????????????",false)
		return
	end
    
	if not filter_spec_chars(strComment, Symbol()) then
        SystemUICall:GetInstance():Toast("??????????????????",false)
        self:SendCommentFail()
		return
	end

    if self:CheckCommentLength(strComment) then
        if (self.commentIdForInputBox == nil) then
            self.discussMgr:PostComment(strComment,function(data,isSuccess)
                if (isSuccess) then
                    self:SendCommentSuccess()
                    self:RefreshComments()
                else
                    self:SendCommentFail()
                end
            end)
        else
            self.discussMgr:ReplyComment(self.commentIdForInputBox['id'],self.commentIdForInputBox['nickname'],strComment,function(data,isSuccess)
                if (isSuccess) then
                    self:SendCommentSuccess()
                    local parent = self.commentIdForInputBox['parentTransform']
                    local id = self.commentIdForInputBox['id']
                    local objReplyContentsNode = self:FindChild(parent,'Others_node')
                    local replyCommentsList = data
                    --??????????????????
                    --?????????
                    if (not objReplyContentsNode.activeSelf) then
                        objReplyContentsNode:SetActive(true)
                        local objReplyOpen = self:FindChild(parent,'Button_replies')
                        --?????????
                        if (not objReplyOpen.activeSelf) then
                            objReplyOpen:SetActive(true)
                            local btnReplyOpen = self:FindChildComponent(parent,'Button_replies','Button')
                            self.replyNumList[replyCommentsList.root_comment_id] = 1
                            self:RemoveButtonClickListener(btnReplyOpen)
                            self:AddButtonClickListener(btnReplyOpen, function()
                                self:OnClickGetCommentReply(replyCommentsList.root_comment_id,parent)
                            end)
                        --?????????
                        else
                            self.replyNumList[replyCommentsList.root_comment_id] = self.replyNumList[replyCommentsList.root_comment_id] + 1
                        end
                        local txtReplyNum = self:FindChildComponent(parent,'Button_replies/name','Text')
                        txtReplyNum.text = "????????????"
                    else
                    --?????????
                        self.replyNumList[replyCommentsList.root_comment_id] = self.replyNumList[replyCommentsList.root_comment_id] + 1
                    end
                    --??????item
                    local objItem = LoadPrefabAndInit('DiscussAreaUI/DiscussReplyItem', objReplyContentsNode)
                    if (objItem ~= nil) then
                        objItem:SetActive(true)
                        objItem.transform:SetSiblingIndex(0)
                        self:RefreshCommentsItem(objItem,replyCommentsList,-1,false) 
                    end
                    
                    self.commentIdForInputBox = nil
                else
                    self:SendCommentFail()
                end
            end)
        end
	end
end

function DiscussUI:SendCommentSuccess()
    SystemUICall:GetInstance():Toast("????????????",false)
    self.obj_inputBox.text = ""
    --self:RefreshComments()
    self:EnterSendCD(60)
end

function DiscussUI:SendCommentFail()
    self:EnterSendCD(10)
end

function DiscussUI:EnterSendCD(cdTime)
    -- ??????cd
    SetConfig(self.playerid..'#LastCommentSuccessTime', os.time(), true);
    SetConfig(self.playerid..'#LastCommentCD', cdTime, true);
    self.lastCommentTime = os.time()
    self.lastCommentCD = cdTime
    self.commentCountdown = true
    setUIGray(self.btn_sendComment:GetComponent("Image"),true)
    self.btn_sendComment.enabled = false
end


function DiscussUI:RefreshUI(articleId)
    -- ???????????????????????????????????????
    self.obj_hotCommentsPart_LoopScrollView.totalCount = 0
    self.obj_hotCommentsPart_LoopScrollView:RefillCells()
    self.obj_newCommentsPart_LoopScrollView.totalCount = 0
    self.obj_newCommentsPart_LoopScrollView:RefillCells()
    self.txt_title.text = ""
    self.obj_emptyBG:SetActive(false)
    -- ????????????
    self:SetNowArticle(articleId)
    -- ?????????????????????
    self.obj_inputBox.text = ""
    self.discussMgr:CanTalk(function(canTalk,msg)
        self.canTalk = canTalk
        if canTalk then
            self.obj_inputBox.interactable = true
            self.txt_inputBoxPlaceholder.text = "??????????????????50????????????"
            setUIGray(self.btn_sendComment:GetComponent("Image"),false)
            self.btn_sendComment.enabled = true
        else
            self.obj_inputBox.interactable = false
            self.txt_inputBoxPlaceholder.text = msg
            setUIGray(self.btn_sendComment:GetComponent("Image"),true)
            self.btn_sendComment.enabled = false
        end
        -- ????????????????????????
        if (self.canTalk) then
            self.lastCommentTime = GetConfig(self.playerid..'#LastCommentSuccessTime') or 0
            self.lastCommentCD = GetConfig(self.playerid..'#LastCommentCD') or 60
            if (self.lastCommentTime == 0 or os.time()-self.lastCommentTime > self.lastCommentCD) then
                self.commentCountdown = false
                self.txt_sendComment.text = "??????"
                setUIGray(self.btn_sendComment:GetComponent("Image"),false)
                self.btn_sendComment.enabled = true
            else
                self.commentCountdown = true
                setUIGray(self.btn_sendComment:GetComponent("Image"),true)
                self.btn_sendComment.enabled = false
            end
        else
            self.commentCountdown = false
        end
    end)
    
end

function DiscussUI:Update()
    if (self.commentCountdown) then
        if (os.time() - self.lastCommentTime < self.lastCommentCD) then
            local cur = self.lastCommentCD - (os.time() - self.lastCommentTime)
            self.txt_sendComment.text = string.format("%d",cur).."???"
        else
            self.commentCountdown = false
            self.txt_sendComment.text = "??????"
            setUIGray(self.btn_sendComment:GetComponent("Image"),false)
            self.btn_sendComment.enabled = true
        end
    end    
end

function DiscussUI:OnDisable()
    self.hotCommentsList = nil
    self.newCommentsList = nil
end


function DiscussUI:OnDestroy()
    self.obj_inputBox.onValueChanged:RemoveAllListeners()
    self.obj_inputBox.onEndEdit:RemoveAllListeners()
end

return DiscussUI;