SocialUI = class('SocialUI', BaseWindow);

local DKJson = require("Base/Json/dkjson")

local aHour = 60 * 60;
local aDay = 24 * 60 * 60;

local whiteColor = DRCSRef.Color(1, 1, 1, 1);
local blackColor = DRCSRef.Color(0, 0, 0, 1);
local readColor = DRCSRef.Color(0x7f/0xff, 0x7f/0xff, 0x7f/0xff, 1);
local headColor = DRCSRef.Color(0x55/0xff, 0x55/0xff, 0x55/0xff, 1);

local Type = {
    friend = 1,
    apply = 2,
}

function SocialUI:ctor()
    self.TABTable = {};
    self.bindBtnTable = {};
    self.clickMailInfo = nil;
    self.clickFriendTarget = nil;
    self.clickObserveTarget = nil;
    self.isApplyOpen = false;
    self.isClickMail = false;
    self.isClickFriend = false;

    self.page = 1;
end

function SocialUI:Create()
	local obj = LoadPrefabAndInit('Friends/SocialUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function SocialUI:Init()

    -- local t = {}
    -- for k, v in pairs(self._gameObject.transform) do
    --     table.insert(t, v);
    -- end
    -- self.objTabUI.transform:SetSiblingIndex(0);

    self.SocialDataManager = SocialDataManager:GetInstance();
    self.ChatBoxUIDataManager = ChatBoxUIDataManager:GetInstance();

    self.buttonBackBtn = self:FindChild(self._gameObject, 'Button_back');
    self.objTabUI = self:FindChild(self._gameObject, 'FriendsWindowTabUI');

    -- Mail
    self.objMailsUI = self:FindChild(self._gameObject, 'MailsUI');
    self.objNullMail = self:FindChild(self.objMailsUI, 'Image_null');
    self.objMail = self:FindChild(self.objMailsUI, 'Mail');
    self.objLeft = self:FindChild(self.objMail, 'Left');
    self.objRight = self:FindChild(self.objMail, 'Right');
    self.objImageTips = self:FindChild(self.objMail, 'Image_tips');
    
    --
    self.objMailsToggle = self:FindChild(self.objTabUI, 'Toggle_mail');
    self.objFriendsToggle = self:FindChild(self.objTabUI, 'Toggle_friend');

    -- MailLeft
    self.objLeftSCMails = self:FindChild(self.objLeft, 'SC_mails');
    self.objLeftSCMailsContent = self:FindChild(self.objLeftSCMails, 'Viewport/Content');
    self.objLeftDelAllBtn = self:FindChild(self.objLeft, 'Button_delall');
    self.objLeftGetAllBtn = self:FindChild(self.objLeft, 'Button_getall');

    -- MailRight
    self.objRightImageTitle = self:FindChild(self.objRight, 'Image_title');
    self.objRightSCContent = self:FindChild(self.objRight, 'SC_content');
    self.objRightItemIconList = self:FindChild(self.objRight, 'Item_iconList');
    self.objRightDelBtn = self:FindChild(self.objRight, 'Button_del');
    self.objRightGetBtn = self:FindChild(self.objRight, 'Button_get');

    self.objRightText = self:FindChild(self.objRightSCContent, 'Text');

    -- Friend
    self.objFriendsUI = self:FindChild(self._gameObject, 'FriendsUI');
    self.objNullNode = self:FindChild(self.objFriendsUI, 'Null_node');
    self.objSCFriends = self:FindChild(self.objFriendsUI, 'SC_Friends');
    self.objFriendApplyBtn = self:FindChild(self.objFriendsUI, 'Button_friendApply');
    self.objApplys = self:FindChild(self.objFriendsUI, 'Applys');

    -- Apply
    self.objCloseBtn = self:FindChild(self.objApplys, 'Button_close');
    self.objCancelAllBtn = self:FindChild(self.objApplys, 'Button_cancelall');
    self.objNull = self:FindChild(self.objApplys, 'Null');
    self.objSCApply = self:FindChild(self.objApplys, 'SC_apply');

    self.akItemUIClass = {}
    --
    table.insert(self.bindBtnTable, self.buttonBackBtn);
    table.insert(self.bindBtnTable, self.objLeftDelAllBtn);
    table.insert(self.bindBtnTable, self.objLeftGetAllBtn);
    table.insert(self.bindBtnTable, self.objRightDelBtn);
    table.insert(self.bindBtnTable, self.objRightGetBtn);
    table.insert(self.bindBtnTable, self.objFriendApplyBtn);
    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objCancelAllBtn);
    table.insert(self.bindBtnTable, self.objMailsToggle);
    table.insert(self.bindBtnTable, self.objFriendsToggle);

    --
    table.insert(self.TABTable, self.objMailsUI);
    table.insert(self.TABTable, self.objFriendsUI);

    --
    self:BindBtnCB();

    --
    self:AddEventListener('ONEVENT_ADDAWARD', function(data) self:AddAward(data) end);

end

function SocialUI:RefreshUI()

    if AppsManagerFlag then
        NetCommonData.Config.token = nil;
    end

    self:RefMailRedPoint();
    self:RefFriendRedPoint();

    local socialUISet = globalDataPool:getData("socialUI");
    dprint("socialUI refreshUI"..socialUISet)
    if (socialUISet == "mailUI") then
        self.page = 1;
        self.objMailsToggle:GetComponent('Toggle').isOn = true
        self:SetTABState(self.objMailsUI);
    else
        self.objFriendsToggle:GetComponent('Toggle').isOn = true
        self:SetTABState(self.objFriendsUI);
    end

end

function SocialUI:ResetMailPage()
    self.page = 1;
end

-------------------------------------------------------------------------------
-- mail
function SocialUI:OnRefMailUI(isRemove)
    
    -- self.mailIndex = nil;
    self.mailData = self.SocialDataManager:GetShowMailData();
    self.totalMailCount = self.SocialDataManager:GetMailTotleCount();
    self.mailDCount = #(self.mailData);

    if isRemove then
        self.objRight:SetActive(false);
        self.objImageTips:SetActive(true);
    end

    if #(self.mailData) < MaxMailReqCount and #(self.mailData) < self.totalMailCount then
        if self.page <= 20 then
            self.page = self.page + 1;
            NetCommonMail:GetMailPageV2(self.page, MaxMailReqCount, nil, MailState1, MailType, true);
            return;
        end
    end

    if not self:SetMailVisible() then
        return;
    end

    local lvSC = self.objLeftSCMails:GetComponent('LoopListView2');
    local scrollRect = self.objLeftSCMails:GetComponent('ScrollRect');
    if lvSC then
        local _func = function(item, index)
            local obj = item:NewListViewItem('Toggle_mail');
            self:OnMailScrollChanged(obj.gameObject, index);
            return obj;
        end

        local _func1 = function()
        end

        local _func2 = function()
        end

        local _func3 = function()
            if scrollRect.verticalNormalizedPosition > 0 then
            else
                if #(self.mailData) < self.totalMailCount then
                    if self.page <= 20 then
                        self.page = self.page + 1;
                        NetCommonMail:GetMailPageV2(self.page, MaxMailReqCount, nil, MailState1, MailType, true);
                    end
                end
            end
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.mailDCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.mailDCount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCMail = lvSC;
    end
end

-- 邮件数据预处理
function SocialUI:PreProcMailData(data)
    if not (data and data.type) then
        return
    end

    if data.bHasPreProc == true then
        return data
    end

    local eType = data.type

    -- 好友上供百宝书经验
    if eType == SMAT_COMMIT_TREASUREEXP then
        local strSenderName = data.body or data.from
        local attachment = DKJson.decode(data.attachment)
        local uiItemNum = 0
        if attachment and attachment[1] then
            uiItemNum = attachment[1].itemnum or 0
        end
        local strFormatTitle = GetLanguageByID(469)
        local strFormatBody = GetLanguageByID(470)
        data.title = string.format(strFormatTitle, strSenderName)
        data.body = string.format(strFormatBody, strSenderName, uiItemNum)
    -- 新的百宝书赠送邮件
    elseif eType == SMAT_GIVEFRIEND_TREASUREBOOK then
        local strSenderName = data.body
        if (not strSenderName) or (strSenderName == "") then
            strSenderName = STR_ACCOUNT_DEFAULT_PREFIX .. (data.from or "")
        end
        local strFormatTitle = GetLanguageByID(467)
        local strFormatBody = GetLanguageByID(468)
        data.title = string.format(strFormatTitle, strSenderName)
        data.body = string.format(strFormatBody, strSenderName)
    end

    data.bHasPreProc = true

    return data
end

function SocialUI:OnMailScrollChanged(gameObject, idx)
    local mailData = self.SocialDataManager:GetShowMailData();
    local data = mailData[idx + 1];
    if data then
        -- 对于一些特殊类型的邮件做数据预处理
        data = self:PreProcMailData(data)
    
        SetStringDataInGameObject(gameObject, 'idx', tostring(idx));
        self:SetSingleMailUI(gameObject, data);
    
        local _func = function(idx)
            for k, v in pairs(gameObject.transform.parent.transform) do
                if GetStringDataInGameObject(v.gameObject, 'idx') == tostring(idx) then
                    self:PickItem(v.gameObject);
                end
            end
        end
    
        local _callback = function(gameObject)
            _func(idx);
            self.mailIndex = idx;
            self:OnClickMailItem(gameObject);
        end
        self:CommonBind(gameObject, _callback);
    
        -- 滑动处理
        self:PickItem(nil);
        _func(self.mailIndex);
    end
end

function SocialUI:SetSingleMailUI(obj, info)
    info.time = tonumber(info.time);

    SetStringDataInGameObject(obj, 'id', info.id);
    local isNew = NetCommonMail:IsNew(info.state);
    local cp = self:FindChild(obj, 'Image_unread');
    cp:SetActive(isNew);

    cp = self:FindChildComponent(obj, 'Text_sendTime', 'Text');
    cp.text = '【20' .. os.date("%y-%m-%d %H:%M】", info.time);
    
    cp = self:FindChildComponent(obj, 'Text_remainTime', 'Text');
    local remainTime = tonumber(info.expireAt) - os.time();
    cp.text = string.format('剩余%d天 ', math.ceil(remainTime / aDay));
    
    cp = self:FindChildComponent(obj, 'Text_title', 'Text');
    cp.text = self:GetLimitText(info.title);
    --cp.color = isNew and blackColor or readColor;
end

function SocialUI:GetLimitText(str, limit)
    limit = limit or 8;
    local sub = string.utf8sub(str, 1, limit);
    if sub ~= str then
        sub = sub .. '...';
    end
    return sub;
end

function SocialUI:AddMail(data)
    if self.mailIndex then
        self.mailIndex = self.mailIndex + 1;
    end

    self:OnRefMailUI(false);
    self:RefMailRedPoint();
    self:SetMailVisible();
end

function SocialUI:RefMailRedPoint()
    local count = SocialDataManager:GetInstance():GetMailRedPoint();
    local redPoint = self:FindChild(self.objMailsToggle, 'Image_redPoint');
    self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
    if count > 0 then
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end
end

function SocialUI:RefMailRedPointSimple()
    local redPoint = self:FindChild(self.objMailsToggle, 'Image_redPoint');
    local count = self:FindChildComponent(redPoint, 'Text', 'Text').text;
    count = tonumber(count) - 1;
    self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
    if count > 0 then
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end
end

function SocialUI:OnClickMailItem(obj)
    local mailData = self.SocialDataManager:GetShowMailData();
    local info = mailData[self.mailIndex + 1];
    if obj and info then
        self:PickItem(obj);
    
        --
        self.objRight:SetActive(true);
        self.objImageTips:SetActive(false);
    
        self.objRightText:GetComponent('Text').text = string.gsub(info.body, '\\n', '\n');
        self:FindChildComponent(self.objRightImageTitle, 'Text', 'Text').text = info.title;
    
        if info.attachment and info.attachment ~= '' then
            local bActive = NetCommonMail:IsReceived(info.state) or NetCommonMail:IsReadReceived(info.state);
            self.objRightDelBtn:SetActive(bActive);
            self.objRightItemIconList:SetActive(true);
            
            -- TODO 添加道具 attachment为json现在不知道结构
            -- [{"itemid":268633113,"itemnum":1}]
           
            if self.akItemUIClass and (#self.akItemUIClass > 0) then
                LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
            end
            local rootTransform = self.objRightItemIconList.transform
            local attachment = DKJson.decode(info.attachment);
            if attachment and next(attachment) then
                for i = 1, #(attachment) do
                    local info = attachment[i];
                    local objItemIconUI = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI,rootTransform)
                    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",tonumber(info.itemid))
                    if itemTypeData then
                        objItemIconUI._gameObject:SetActive(true);
                        objItemIconUI:UpdateUIWithItemTypeData(itemTypeData);
                        objItemIconUI:SetItemNum(tonumber(info.itemnum));
                        objItemIconUI:SetFrameAnimation(bActive == false and itemTypeData.Rank or 0);
    
                        setUIGray(self:FindChildComponent(objItemIconUI._gameObject, 'Icon', 'Image'), bActive);
                        setUIGray(self:FindChildComponent(objItemIconUI._gameObject, 'Frame', 'Image'), bActive);
                        self.akItemUIClass[#self.akItemUIClass + 1] = objItemIconUI
                    else
                        objItemIconUI._gameObject:SetActive(false);
                    end
                end
            end
        else
            self.objRightDelBtn:SetActive(true);
            self.objRightItemIconList:SetActive(false);
        end
    
        -- TODO 标记状态
        if NetCommonMail:IsNew(info.state) then
            self:FindChild(obj, 'Image_unread'):SetActive(false);
            self:FindChildComponent(obj, 'Text_title', 'Text').color = whiteColor;
            self:RefMailRedPointSimple();   -- TODO 简单处理
            NetCommonMail:MarkRead({info.id});
        end
    
        -- 
        self.clickMailInfo = info;
    end
end

function SocialUI:PickItem(obj)
    local content = self:FindChild(self.objLeftSCMails, 'Content');
    for k, v in pairs(content.transform) do
        if obj and obj == v.gameObject then
            self:FindChildComponent(v.gameObject, 'Text_sendTime', 'Text').color = DRCSRef.Color(0.6745098,0.5529412,0.4470588,1);
            self:FindChildComponent(v.gameObject, 'Text_remainTime', 'Text').color = DRCSRef.Color(0.6745098,0.5529412,0.4470588,1);
            self:FindChildComponent(v.gameObject, 'Text_title', 'Text').color = whiteColor;
            self:FindChild(v.gameObject, 'Checkmark'):SetActive(true);
        else
            self:FindChildComponent(v.gameObject, 'Text_sendTime', 'Text').color = DRCSRef.Color(0.5058824,0.4235294,0.3568628,1);
            self:FindChildComponent(v.gameObject, 'Text_remainTime', 'Text').color = DRCSRef.Color(0.5058824,0.4235294,0.3568628,1);
            self:FindChildComponent(v.gameObject, 'Text_title', 'Text').color = DRCSRef.Color(0.17,0.17,0.17,1);
            self:FindChild(v.gameObject, 'Checkmark'):SetActive(false);
        end
    end
end

-- 删除邮件之后刷新
function SocialUI:RefUIDelMail(data)
    self.mailIndex = nil;
    self:OnRefMailUI(false);
    self.objRight:SetActive(false);
    self.objImageTips:SetActive(true);
end

-- 添加奖励
function SocialUI:AddAward(data)
    if getTableSize(data.akResult) == 0 then
        return;
    end

    self:OnRefMailUI(false);

    if self.clickMailInfo then
        self.objRightDelBtn:SetActive(true);
        -- self.objRightItemIconList:SetActive(false);
        for k, v in pairs(self.objRightItemIconList.transform) do
            self:FindChild(v.gameObject, 'Effect'):SetActive(false);
            setUIGray(self:FindChildComponent(v.gameObject, 'Icon', 'Image'), true);
            setUIGray(self:FindChildComponent(v.gameObject, 'Frame', 'Image'), true);
        end
    end

    self:RefMailRedPoint();

    local houseUI = GetUIWindow('HouseUI');
    if houseUI then
        houseUI:RefMailRedPoint();
    end
end

function SocialUI:SetMailVisible()
    local mailData = self.SocialDataManager:GetShowMailData();
    if (not mailData) or #(mailData) == 0 then
        self.objMail:SetActive(false);
        self.objNullMail:SetActive(true);
        return false;
    else
        self.objNullMail:SetActive(false);
        self.objMail:SetActive(true);
        return true;
    end
end

function SocialUI:OnClickGetBtn(obj) 
    if self.bGetNeedGetNextPage then
        SystemUICall:GetInstance():Toast('正在处理请稍等');
        return;
    end

    self.getArray = {};
    local array = self.getArray;
    local bMax = false;
    local maxCount = 5;
    local mailRewardInfo = {};

    if obj == self.objRightGetBtn then  -- 领取单个
        local info = self.clickMailInfo;
        if info and info.id then
            table.insert(array, tonumber(info.id));
            table.insert(mailRewardInfo, info);
        end
    else                                -- 领取所有
        local mailData = self.SocialDataManager:GetShowMailData();
        local totalMailCount = self.SocialDataManager:GetMailTotleCount();
        for i = 1, #(mailData) do
            local info = mailData[i];
            if (info.attachment ~= '') and (NetCommonMail:IsNew(info.state) or NetCommonMail:IsRead(info.state)) then
                table.insert(array, tonumber(info.id));
                table.insert(mailRewardInfo, info);
                if #(array) >= maxCount then
                    bMax = true;
                    break;
                end
            end
        end

        if totalMailCount > maxCount then
            if #(mailData) < totalMailCount and #(array) < maxCount then  
                self.bGetNeedGetNextPage = true;

                if self.page <= 20 then
                    self.page = self.page + 1;
                    NetCommonMail:GetMailPageV2(self.page, MaxMailReqCount, nil, MailState1, MailType, true);
                    return;
                end
            end
        end
    end
    
    if #(array) > 0 then
        -- 通知服务器加奖励
        local _callback = function()
            local showRewardInfo = {}
            local count = 0
            for i=1,#mailRewardInfo do
                local info = mailRewardInfo[i]
                local attachment = DKJson.decode(info.attachment)
                if attachment then
                    for i = 1, #(attachment) do
                        local itemInfo = {
                            ["dwItemTypeID"] = tonumber(attachment[i].itemid),
                            ["dwNum"] = tonumber(attachment[i].itemnum),
                        }
                        showRewardInfo[count] = itemInfo
                        count = count + 1 
                    end
                end
            end
            OpenWindowImmediately("GiftBagResultUI", showRewardInfo)
            SendMailOpr(SMAOT_GET, getTableSize(array), FormatTable(array));
        end

        if bMax then
            OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, string.format('收取邮件个数超过上限本次最多可以领取%d封', maxCount), _callback })
        else
            _callback();
        end
    else
        -- 没有能领取的邮件
        SystemUICall:GetInstance():Toast('没有能领取的邮件了');
    end
    
end

function SocialUI:OnClickDelBtn(obj)
    if self.bDelNeedGetNextPage then
        SystemUICall:GetInstance():Toast('正在处理请稍等');
        return;
    end

    self.delArray = {};
    local array = self.delArray;
    local maxCount = 10;
    local maxDelCount = 30;
    local bTrigger = false;

    if obj == self.objRightDelBtn then -- 删除单个
        local info = self.clickMailInfo;
        table.insert(array, info.id);
    else                        -- 删除全部
        local mailData = self.SocialDataManager:GetShowMailData();
        local totalMailCount = self.SocialDataManager:GetMailTotleCount();
        for i = 1, #(mailData) do
            local info = mailData[i];
            if (NetCommonMail:IsRead(info.state) and info.attachment == '') or 
            NetCommonMail:IsReceived(info.state) or
            NetCommonMail:IsReadReceived(info.state) then
                table.insert(array, info.id);
                if #(array) >= maxDelCount then
                    bTrigger = true;
                    break;
                end
            end
        end

        if totalMailCount > maxCount then
            if #(mailData) < totalMailCount then
                self.bDelNeedGetNextPage = true;

                if self.page <= 20 then
                    self.page = self.page + 1;
                    NetCommonMail:GetMailPageV2(self.page, MaxMailReqCount, nil, MailState1, MailType, true);
                    return;
                end
            end
        end
    end

    -- TODO 删除邮件列表不能为空
    local netMessage = function()
        if #(array) > 0 then
            local callback = function()
                NetCommonMail:DelMailV2(array);
            end
            if bTrigger then
                OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '单次批量最多只能删除30封邮件！', callback })
            else
                callback();
            end
        else
            SystemUICall:GetInstance():Toast('没有能删除的邮件了');
        end
    end

    if obj == self.objRightDelBtn then
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '确定要删除该邮件吗？', netMessage })
    else
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '确定要删除所有已读且领取过的邮件吗？', netMessage })
    end
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- friend
function SocialUI:OnRefFriendUI()

    self.SocialDataManager:SortFriendData();
    self.friendServerData = self.SocialDataManager:GetFriendData2();
    self.friendSDCount = #(self.friendServerData);
    self.objNullNode:SetActive(self.friendSDCount == 0);

    --
    local lvSC = self.objSCFriends:GetComponent('LoopListView2');
    local scrollRect = self.objSCFriends:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_friend');
            self:OnFriendScrollChanged(obj.gameObject, index);
            return obj;
        end

        if not self.inited1 then
            self.inited1 = true;
            lvSC:InitListView(self.friendSDCount, _func);
        else
            lvSC:SetListItemCount(self.friendSDCount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCFriend = lvSC;
    end
end

function SocialUI:OnFriendScrollChanged(gameObject, idx)
    gameObject:SetActive(true);
    self:SetSingleFriendUI(gameObject, Type.friend, idx);
end

function SocialUI:SetSingleFriendUI(obj, type, idx)

    local serverData = self.SocialDataManager:GetFriendData2();
    if type == Type.apply then
        serverData = self.SocialDataManager:GetApplyData2();
    end
    local info = serverData[idx + 1];

    if not info then
        return;
    end

    if not info.ext then
        info.ext = {};
    end

    local head = self:FindChild(obj, 'Head');
    local image = self:FindChild(head, 'Mask/Image');
    local imageRich = self:FindChild(obj, 'Image_rich');

    if head and self.objs_headboxInst and self.objs_headboxInst[head] then  
        self.objs_headboxInst[head]._gameObject:SetActive(false)
    end 
    if head and info.ext and info.ext.dwHeadBoxID then 
        local dwHeadBoxID = tonumber(info.ext.dwHeadBoxID)
        self.objs_headboxInst = self.objs_headboxInst or {}
        if not self.objs_headboxInst[head] then 
            self.objs_headboxInst[head] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,head.transform)
        end 
        if self.objs_headboxInst[head] then  
            self.objs_headboxInst[head]._gameObject:SetActive(true)
            self.objs_headboxInst[head]:SetReplacedHeadBoxUI(head,false)	
            self.objs_headboxInst[head]:SetHeadBoxID(dwHeadBoxID)	
        end 
    end 
    --
    local color = info.online and whiteColor or headColor;
    head:GetComponent('Image').color = color;
    image:GetComponent('Image').color = color;
    
    if info.ext.sprite then
        image:GetComponent('Image').sprite = info.ext.sprite;
    else
        local callback = function(sprite)
            image:GetComponent('Image').sprite = sprite;
        end
        GetHeadPicByModelId(0, callback);
    end

    local bRMBPlayer = tonumber(info.ext.dwRMBPlayer or 0);
    if bRMBPlayer > GetCurServerTimeStamp() then
        imageRich:SetActive(true);
    else
        imageRich:SetActive(false);
    end

    local top = self:FindChild(obj, 'Top');
    local title = self:FindChildComponent(top, 'Text_title', 'Text');
    local strNickName = nil
    if info.bIsTecentFriend == true then
        strNickName = MSDKHelper:GetNickNameByFriendPlayerID(info.uid)
    end
    local strName = info.name or ""
    if strName == "" then
        strName = string.format("%s%s", STR_ACCOUNT_DEFAULT_PREFIX, tostring(info.uid or 0))
    end
    if strNickName and (strNickName ~= "") then
        title.text = strName .. "(" .. strNickName .. ")";
    else 
        title.text = strName;
    end

    local online = self:FindChildComponent(top, 'Text_online', 'Text');
    if info.online then
        online.text = '【在线】';
    else
        local hours = (os.time() - tonumber(info.ext.dwLogoutTime or os.time())) / aHour;
        if hours >= 24 then
            online.text = '【' .. math.floor(hours / 24) .. '天前】';
        else
            if hours >= 1 then
                online.text = '【' .. math.ceil(hours) .. '小时前】';
            else
                online.text = '【刚刚下线】';
            end
        end
    end

    local bLoginQQ = MSDKHelper:IsLoginQQ()
    local bLoginWeChat = MSDKHelper:IsLoginWeChat()
    local textFrom = self:FindChildComponent(top, 'Text_from', 'Text')
    if textFrom then
        if (info.bIsTecentFriend == true) and bLoginQQ then
            textFrom.text = "【QQ好友】"
        elseif (info.bIsTecentFriend == true) and bLoginWeChat then
            textFrom.text = "【微信好友】"
        else
            textFrom.text = "【游戏内好友】"
        end
    end

    local objImageQQ = self:FindChild(top,"Image_QQ");
    local objImageWX = self:FindChild(top,"Image_WX");
    if objImageQQ and objImageWX then
        objImageQQ:SetActive(false);
        objImageWX:SetActive(false);
        
        local _callback = function(gameObject)
            if gameObject.name == 'Image_QQ' then
                -- SystemUICall:GetInstance():Toast('从QQ游戏中心启动尊享特权'); 
                MSDKHelper:OpenUrl("https://speed.gamecenter.qq.com/pushgame/v1/inner-game/privilege?launchqq=1")
            elseif gameObject.name == 'Image_WX' then
                SystemUICall:GetInstance():Toast('从微信游戏中心启动尊享特权');
            end
        end
        self:CommonBind(objImageQQ, _callback);
        self:CommonBind(objImageWX, _callback);

        if info.ext.iTencentPrivate then
            if bLoginQQ then
                if HasFlag(tonumber(info.ext.iTencentPrivate), STPT_QQ) then
                    objImageQQ:SetActive(true);
                end
            elseif bLoginWeChat then
                if HasFlag(tonumber(info.ext.iTencentPrivate), STPT_WECHAT) then
                    objImageWX:SetActive(true);
                end 
            end
        end
    end

    local bottom = self:FindChild(obj, 'Bottom');
    local text_AchievePoint = self:FindChildComponent(bottom, 'Text_AchievePoint', 'Text');
    local text_MeridiansLvl = self:FindChildComponent(bottom, 'Text_MeridiansLvl', 'Text');
    if text_AchievePoint then
        text_MeridiansLvl.text = "经脉：" .. (info.ext.dwMeridiansLvl or 0);
    end
    if text_AchievePoint then
        text_AchievePoint.text = "成就：" .. (info.ext.dwAchievePoint or 0);
    end

    local objDelBtn = self:FindChild(obj, 'Button_delete');
    if objDelBtn then
        objDelBtn:SetActive(info.bIsTecentFriend ~= true);
    end

    if type == Type.friend then
        local deleteBtn = self:FindChild(obj, 'Button_delete');
        local observeBtn = self:FindChild(obj, 'Button_observe');
        local chatBtn = self:FindChild(obj, 'Button_chat');
    
        local _callback = function(gameObject, this, boolHide)
            if gameObject.name == deleteBtn.name then
                self:OnClickDelFriend(deleteBtn, info);
    
            elseif gameObject.name == observeBtn.name then
                self:OnClickObserveFriend(observeBtn, info);
    
            elseif gameObject.name == chatBtn.name then
                self:OnClickChatFriend(chatBtn, info);
    
            end
        end
        self:CommonBind(deleteBtn, _callback);
        self:CommonBind(observeBtn, _callback);
        self:CommonBind(chatBtn, _callback);
    end

    if type == Type.apply then
        local cancelBtn = self:FindChild(obj, 'Button_cancel');
        local passBtn = self:FindChild(obj, 'Button_pass');
    
        local _callback = function(gameObject)
            if gameObject == cancelBtn then
                self:OnClickCancelApply(cancelBtn, info);
    
            elseif gameObject == passBtn then
                self:OnClickPassApply(passBtn, info);
    
            end
        end
    
        self:CommonBind(cancelBtn, _callback);
        self:CommonBind(passBtn, _callback);
    end 
end

function SocialUI:OnClickDelFriend(obj, data)

    local netMessage = function()
        SendDelFriendInfo(STLPLAT_DEL_FRIEND, data.uid);
        NetCommonFriend:DeleteFriend(data.uid);
    end

    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, '确定要删除此好友?', netMessage});
end

function SocialUI:OnClickObserveFriend(obj, data)
    self.clickObserveTarget = data;
    SendObservePlatRole(data.uid);
end

function SocialUI:OnClickChatFriend(obj, data)
    
    local chatBoxUI = GetUIWindow('ChatBoxUI');
    if chatBoxUI then
        chatBoxUI:OnClickExtenBtn(nil, true);
        chatBoxUI:SetToggleState(chatBoxUI.objTogglePrivate);
        chatBoxUI:OnClickFriendListItem(nil, data, true);
    end

    RemoveWindowImmediately('SocialUI');
end

function SocialUI:RefFriendRedPoint()
    local applyData = self.SocialDataManager:GetApplyData2();
    local count = #(applyData);

    local redPoint = self:FindChild(self.objFriendsToggle, 'Image_redPoint');
    self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
    if count > 0 then
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end
    
    redPoint = self:FindChild(self.objFriendApplyBtn, 'Image_redPoint');
    self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
    if count > 0 then
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end
end

function SocialUI:RefFriendRedPointSimple()
    local redPoint = self:FindChild(self.objFriendsToggle, 'Image_redPoint');
    local count = self:FindChildComponent(redPoint, 'Text', 'Text').text;
    count = tonumber(count) - 1;
    self:FindChildComponent(redPoint, 'Text', 'Text').text = count;

    if count > 0 then
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end

    redPoint = self:FindChild(self.objFriendApplyBtn, 'Image_redPoint');
    count = self:FindChildComponent(redPoint, 'Text', 'Text').text;
    count = tonumber(count) - 1;
    self:FindChildComponent(redPoint, 'Text', 'Text').text = count;

    if count > 0 then
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end
end

function SocialUI:OnRefApplyUI(obj)
    
    self.SocialDataManager:SortApplyData();
    self.applyServerData = self.SocialDataManager:GetApplyData2();
    self.applySDCount = #(self.applyServerData);
    self.objNull:SetActive(self.applySDCount == 0);

    --
    local lvSC = self.objSCApply:GetComponent('LoopListView2');
    local scrollRect = self.objSCApply:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_apply');
            self:OnApplyScrollChanged(obj.gameObject, index);
            return obj;
        end

        local _func1 = function()
        end

        local _func2 = function()
        end

        local _func3 = function()
        end
        
        if not self.inited2 then
            self.inited2 = true;
            lvSC:InitListView(self.applySDCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.applySDCount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCApply = lvSC;
    end
end

function SocialUI:OnApplyScrollChanged(gameObject, idx)
    gameObject:SetActive(true);
    self:SetSingleFriendUI(gameObject, Type.apply, idx);
end

function SocialUI:OnClickCancelApply(obj, data)
    NetCommonFriend:AnswerAddFriend(data.uid, false);
end

function SocialUI:OnClickPassApply(obj, data)
    SendDelFriendInfo(STLPLAT_ADD_FRIEND, data.uid);
    NetCommonFriend:AnswerAddFriend(data.uid, true);
end

function SocialUI:RefAnswerAddFriend(friendid, accept)

    if accept then
        self:OnRefFriendUI();
    end

    self:OnRefApplyUI();
    self:RefFriendRedPointSimple();
end

function SocialUI:OnClickCancelAllBtn(obj)

    local applyData = self.SocialDataManager:GetApplyData2();
    
    local _netMessage = function()
        for i = 1, #(applyData) do
            NetCommonFriend:AnswerAddFriend(applyData[i].uid, false);
        end
    end

    if #(applyData) > 0 then
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, '确定要删除所有好友请求?', _netMessage});
    end
end

function SocialUI:OnClickFriendApplyBtn(obj)
    self.isApplyOpen = true;
    self.objApplys:SetActive(true);
    self:OnRefApplyUI();
end

function SocialUI:onClickApplyCloseBtn(obj)
    self.isApplyOpen = false;
    self.objApplys:SetActive(false);
end

function SocialUI:IsApplyOpen()
    return self.isApplyOpen;
end

-------------------------------------------------------------------------------
function SocialUI:OnclickBtn(obj, boolHide)
    if obj.name == self.buttonBackBtn.name then
        self:OnClickBackBtn(obj);

    elseif obj.name == self.objMailsToggle.name then
        self:OnClickMailToggle(self.objMailsToggle, boolHide);

    elseif obj.name == self.objFriendsToggle.name then
        self:OnClickFriendsToggle(self.objFriendsToggle, boolHide);

    elseif obj.name == self.objLeftDelAllBtn.name then
        self:OnClickLeftDelAllBtn(self.objLeftDelAllBtn);

    elseif obj.name == self.objLeftGetAllBtn.name then
        self:OnClickLeftGetAllBtn(self.objLeftGetAllBtn);

    elseif obj.name == self.objRightDelBtn.name then
        self:OnClickRightDelBtn(self.objRightDelBtn);

    elseif obj.name == self.objRightGetBtn.name then
        self:OnClickRightGetBtn(self.objRightGetBtn);

    elseif obj.name == self.objFriendApplyBtn.name then
        self:OnClickFriendApplyBtn(self.objFriendApplyBtn);

    elseif obj.name == self.objCancelAllBtn.name then
        self:OnClickCancelAllBtn(self.objCancelAllBtn);

    elseif obj.name == self.objCloseBtn.name then
        self:onClickApplyCloseBtn(self.objCloseBtn);

    end
end

function SocialUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function SocialUI:CommonBind(gameObject, callback)
    local this = self;
    local btn = gameObject:GetComponent('Button');
    local tog = gameObject:GetComponent('Toggle');
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)

    end
end

function SocialUI:OnClickBackBtn(obj)
    if self.refRedPointFunc then
        self.refRedPointFunc();
    end

    RemoveWindowImmediately('SocialUI', true);
end

function SocialUI:OnClickMailToggle(obj, boolHide)
    if boolHide then
        self:SetTABState(self.objMailsUI);
    end
end

function SocialUI:OnClickFriendsToggle(obj, boolHide)
    if boolHide then
        self:SetTABState(self.objFriendsUI);
    end
end

function SocialUI:OnClickLeftDelAllBtn(obj)
    self:OnClickDelBtn(obj);
end

function SocialUI:OnClickLeftGetAllBtn(obj)
    self:OnClickGetBtn(obj)
end

function SocialUI:OnClickRightDelBtn(obj)
    self:OnClickDelBtn(obj)
end

function SocialUI:OnClickRightGetBtn(obj)
    self:OnClickGetBtn(obj);
end

function SocialUI:SetTABState(obj)
    local windowBarUI = GetUIWindow('WindowBarUI');
    if obj == self.objMailsUI then
        --if not self.isClickMail then
        --    self.isClickMail = true;
        --    self.isClickFriend = false;
            
            self:OnRefMailUI(true);
            if windowBarUI then
                windowBarUI:SetTitleName('邮件');
            end
        --end
    elseif obj == self.objFriendsUI then
        --if not self.isClickFriend then
        --   self.isClickMail = false;
        --   self.isClickFriend = true;
            
            self:OnRefFriendUI();
            if windowBarUI then
                windowBarUI:SetTitleName('好友');
            end
        --end
    end

    for i = 1, #(self.TABTable) do
        if obj == self.TABTable[i] then            
            self.TABTable[i].gameObject:SetActive(true);
        else
            self.TABTable[i].gameObject:SetActive(false);
        end
    end
end

function SocialUI:OnRefPlayerSetUI()
	PlayerSetDataManager:GetInstance():SetObserveOtherPlayerData();
    local playerInfo = {};
    playerInfo.bIsVisitor = true;
    playerInfo.defPlyID = self.clickObserveTarget.uid;
	OpenWindowImmediately("PlayerSetUI", playerInfo)
	RemoveWindowImmediately("PlayerMsgMiniUI")
end

function SocialUI:SetRefRedPointFunc(callback)
    self.refRedPointFunc = callback;
end

function SocialUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_OBAERVEUI');
    self:RemoveEventListener('ONEVENT_REF_GETALLMAIL');
    RemoveWindowBar('SocialUI')
end

function SocialUI:OnRemoveAllMail(info)
    if info then
        for i = 1, #(info) do
            if (NetCommonMail:IsRead(info[i].state) and info[i].attachment == '') or 
            NetCommonMail:IsReceived(info[i].state) or
            NetCommonMail:IsReadReceived(info[i].state) then
                NetCommonMail:DelMail(self, { info[i].id });
            end
        end
    end
end

function SocialUI:OnEnable()
	self:AddEventListener('ONEVENT_REF_OBAERVEUI', function(info)
		self:OnRefPlayerSetUI();
    end);
    self:AddEventListener('ONEVENT_REF_GETALLMAIL', function(info)
        self:OnRemoveAllMail(info);
    end);

    --
    local topBtnState = {}
    local callback = function() end
    local socialUISet = globalDataPool:getData("socialUI");
    if socialUISet == "mailUI" then
        topBtnState.bGold = true;
        topBtnState.bSilver = true;

        callback = function()
            NetCommonMail:CountMails(nil, MailState2, MailType, false);
        end
    end

    local info = {
        ['windowstr'] = "SocialUI",
        ['titleName'] = "邮件", 
        ['topBtnState'] = topBtnState,
        ['callback'] = callback;
    }
    OpenWindowBar(info);
end

function SocialUI:OnDestroy()
    if self.akItemUIClass and (#self.akItemUIClass > 0) then
        LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
    end

    LuaClassFactory:GetInstance():ReturnAllUIClass(self.objs_headboxInst or {})

    local funcNameT = {
        'mOnBeginDragAction',
        'mOnDragingAction',
        'mOnEndDragAction',
        'mOnGetItemByIndex',
    }

    local lvSCT = {};
    table.insert(lvSCT, self.lvSCMail);
    table.insert(lvSCT, self.lvSCFriend);
    table.insert(lvSCT, self.lvSCApply);

    for i = 1, #(lvSCT) do
        for j = 1, #(funcNameT) do
            if lvSCT[i][funcNameT[j]] then
                lvSCT[i][funcNameT[j]] = nil;
            end
        end
    end
end

return SocialUI;