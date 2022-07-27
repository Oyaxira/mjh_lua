SocialDataManager = class('SocialDataManager');
SocialDataManager._instance = nil;

function SocialDataManager:GetInstance()
    if SocialDataManager._instance == nil then
        SocialDataManager._instance = SocialDataManager.new();
        SocialDataManager._instance:Init();
    end

    return SocialDataManager._instance;
end

function SocialDataManager:Init()
    self.otherPlayerData = {};
    self:ResetData();
end

function SocialDataManager:ResetData()
    self.mailsData = {};
    self.friendsData = {};
    self.qwFriendData = {};
    self.applysData = {};
    self.friendServerData = {};
    self.applyServerData = {};
    self.newMailCount = 0;
    self.totalMailCount = 0;
    self.totalFriendCount = 0;
end

function SocialDataManager:ClearMailsData()
    self.mailsData = {};
    self.newMailCount = 0;
    self.totalMailCount = 0;
end

function SocialDataManager:ClearFriendsData()
    self.friendsData = {};
    self.applysData = {};
    self.friendServerData = {};
    self.applyServerData = {};
end

-----------------------------------------------------------------
-- mailsData
function SocialDataManager:_JsonToLua()
    local filePath = "C:/Users/Administrator/Desktop/mail.json"
    local file = io.open(filePath, "r")
    local str = file:read("*a")
    local pattern = "\"[%w]+\":"
    string.gsub(str, pattern, function(v)
        if string.find(str, v) then
            str = string.gsub(str, v, string.gsub(v, "\"", ""))
        end
    end)
    str = string.gsub(str, ":", "=")
    str = string.gsub(str, "%[", "{")
    str = string.gsub(str, "%]", "}")
    local data = "return " .. str
    return load(data)();
end

function SocialDataManager:SetMailData(data, isCahce)

    if (not data.mails) or #(data.mails) == 0 then
        return;
    end

    if isCahce then
        if #(self.mailsData) == 0 then
            return;
        else
            for i = 1, #(data.mails) do
                if not self:HasMailData(data.mails[i].id) then
                    table.insert(self.mailsData, data.mails[i]);
                end
            end
        end
    else
        self.mailsData = data.mails;
    end
end

function SocialDataManager:SetMailTotleCount(totalMailCount)
    self.totalMailCount = totalMailCount;
end

function SocialDataManager:GetMailTotleCount(totalMailCount)
    return self.totalMailCount;
end

function SocialDataManager:SetMailRedPoint(newMailCount)
    self.newMailCount = newMailCount;
end

function SocialDataManager:GetMailRedPoint(newMailCount)
    return self.newMailCount;
end

function SocialDataManager:GetMailData(type, state)
    if not type then
        return self.mailsData;
    end

    local mail = {}
    for k, v in pairs(self.mailsData) do
        if (v.type == type)
        and ((state == nil) or (state == v.state)) then
            table.insert(mail, v);
        end
    end

    return mail;
end

function SocialDataManager:GetShowMailData()
    local mail = {};
    local ignoreRedPointMail = {};
    for i = 1, #(self.mailsData) do
        -- 正常过期邮件在下次拉取时不会被拉到 但是没有重登的情况下还是会存在缓存 这里将过期邮件过滤
        if (self.mailsData[i].expireAt - os.time()) > 0 then
            if self.mailsData[i].type == SMAT_TREASUREMAZE then
                table.insert(ignoreRedPointMail, self.mailsData[i]);
            else
                table.insert(mail, self.mailsData[i]);
            end
        end
    end

    return mail;
end

function SocialDataManager:AddMailData(data)
    if not data then
        return false;
    end

    if self:HasMailData(data.id) then
        return false;
    end

    if data.type == SMAT_GIVEFRIEND_TREASUREBOOK then
        self:DealTreasureBookSendMail(data)
    end

    if data.type ~= SMAT_TREASUREMAZE then
        if NetCommonMail:IsNew(data.state) then
            self.newMailCount = self.newMailCount + 1;
        end
        self.totalMailCount = self.totalMailCount + 1;
        table.insert(self.mailsData, 1, data);
        return true;
    else
        table.insert(self.mailsData, 1, data);
        return false;
    end
end

function SocialDataManager:DealTreasureBookSendMail(data)
    if not data then
        return
    end
    local strSender = data.body or ""
    if strSender == "" then
        strSender = string.format("%s%s", STR_ACCOUNT_DEFAULT_PREFIX, data.from or "0")
    end
    SystemUICall:GetInstance():Toast(string.format("%s给你赠送了一个月的壕侠百宝书", strSender))
    -- 收到百宝书赠送邮件时, 自动领取
    SendMailOpr(SMAOT_GET, 1, {[0] = tonumber(data.id)})
end

function SocialDataManager:DelMailDataByID(ids)
    if not ids then
        return nil;
    end

    for i = 1, #(ids) do
        for j = 1, #(self.mailsData) do
            if tostring(ids[i]) == self.mailsData[j].id then
                self.totalMailCount = self.totalMailCount - 1;
                table.remove(self.mailsData, j);
                break;
            end
        end
    end
end

function SocialDataManager:GetMailDataByID(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.mailsData) do
        if tostring(id) == self.mailsData[i].id then
            return self.mailsData[i];
        end
    end

    return nil;
end

function SocialDataManager:HasMailData(id)
    for i = 1, #(self.mailsData) do
        if tostring(id) == self.mailsData[i].id then
            return true;
        end
    end

    return false;
end

function SocialDataManager:SetMailDataState(ids, state)
    for i = 1, #(ids) do
        for j = 1, #(self.mailsData) do
            if tostring(ids[i]) == self.mailsData[j].id then
                if NetCommonMail:IsNew(self.mailsData[j].state) and 
                self.mailsData[j].type ~= SMAT_TREASUREMAZE then
                    self.newMailCount = self.newMailCount - 1;
                end
                if self.mailsData[j].state < state then 
                    self.mailsData[j].state = state;
                end
                break;
            end
        end
    end
end
-----------------------------------------------------------------

-----------------------------------------------------------------
-- friendsData
function SocialDataManager:PushbackFriendData(kData)
    if not kData then
        return
    end

    if not self.friendsData then
        self.friendsData = {}
    end

    if not self.friendsData["check"] then
        self.friendsData["check"] = {}
    end

    local uiFriendID = kData.friendid
    if (not uiFriendID) or (uiFriendID == 0) then
        return
    end

    -- 如果之前已经插入队列, 直接替换原来位置的值
    local uiOldIndex = self.friendsData["check"][uiFriendID]
    if uiOldIndex and (uiOldIndex > 0) then
        self.friendsData[uiOldIndex] = kData
    else
    -- 插入队列, 记录位置
        local uiNewIndex = #self.friendsData + 1
        self.friendsData[uiNewIndex] = kData
        self.friendsData["check"][uiFriendID] = uiNewIndex
    end
end

function SocialDataManager:EraseFriendData(uiIndex)
    if not self.friendsData then
        return
    end

    if not uiIndex then
        uiIndex = #self.friendsData 
    end

    if not self.friendsData[uiIndex] then
        return
    end
    
    local kNewCopy = {["check"] = {}}
    local kTryErase = nil
    for i, kInfo in ipairs(self.friendsData) do
        if i == uiIndex then
            kTryErase = kInfo
        else
            local uiNewIndex = #kNewCopy + 1
            kNewCopy[uiNewIndex] = kInfo
            kNewCopy["check"][kInfo.friendid or 0] = uiNewIndex
        end
    end
    self.friendsData = kNewCopy

    return kTryErase
end

function SocialDataManager:SetFriendData(data)

    if (not data.friends.friends) or #(data.friends.friends) == 0 then
        return;
    end

    for k, v in pairs(data.friends.friends) do
        self:PushbackFriendData(v)
    end
end

function SocialDataManager:GetFriendData()
    return self.friendsData;
end

function SocialDataManager:GetFriendData2()
    return self.friendServerData;
end

function SocialDataManager:AddFriendData(data)
    if not data then
        return;
    end

    local friendData = self:GetFriendDataByID(data.friendid);
    if not friendData then
        self:PushbackFriendData(data)
    end
end

function SocialDataManager:AddFriendData2(data)
    if not data then
        return;
    end

    local friendData = self:GetFriendDataByID2(data.friendid);
    if not friendData then
        table.insert(self.friendServerData, data);
    end
end

function SocialDataManager:DelFriendDataByID(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.friendsData) do
        if tostring(id) == self.friendsData[i].friendid then
            return self:EraseFriendData(i)
        end
    end
end

function SocialDataManager:DelFriendDataByID2(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.friendServerData) do
        if tonumber(id) == self.friendServerData[i].uid then
            return table.remove(self.friendServerData, i);
        end
    end
end

function SocialDataManager:GetFriendDataByID(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.friendsData) do
        if tostring(id) == self.friendsData[i].friendid then
            return self.friendsData[i];
        end
    end

    return nil;
end

function SocialDataManager:GetFriendDataByID2(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.friendServerData) do
        if tonumber(id) == tonumber(self.friendServerData[i].uid) then
            return self.friendServerData[i];
        end
    end

    return nil;
end

function SocialDataManager:SetFriendTotleCount(totalFriendCount)
    self.totalFriendCount = totalFriendCount;
end

function SocialDataManager:GetFriendTotleCount()
    return self.totalFriendCount;
end

function SocialDataManager:AddQWFriendData(data)
    if not data then
        return;
    end

    table.insert(self.qwFriendData, data);
end
-----------------------------------------------------------------

-----------------------------------------------------------------
-- applysData
function SocialDataManager:SetApplyData(data)

    if (not data.friends.applys) or #(data.friends.applys) == 0 then
        return;
    end

    local temp = {};
    for k, v in pairs(data.friends.applys) do
        table.insert(temp, v);
    end

    self.applysData = temp;
end

function SocialDataManager:GetApplyData()
    return self.applysData;
end

function SocialDataManager:GetApplyData2()
    return self.applyServerData;
end

function SocialDataManager:AddApplyData(data)
    if not data then
        return false;
    end

    table.insert(self.applysData, data);
    return true;
end

function SocialDataManager:AddApplyData2(data)
    if not data then
        return;
    end

    table.insert(self.applyServerData, data);
end

function SocialDataManager:DelApplyDataByID(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.applysData) do
        if tostring(id) == self.applysData[i].friendid then
            return table.remove(self.applysData, i);
        end
    end
end

function SocialDataManager:DelApplyDataByID2(id)
    if not id then
        return nil;
    end

    for i = 1, #(self.applyServerData) do
        if tonumber(id) == self.applyServerData[i].uid then
            return table.remove(self.applyServerData, i);
        end
    end
end

function SocialDataManager:HasApplyData(id)
    for i = 1, #(self.applysData) do
        if tostring(id) == self.applysData[i].friendid then
            return self.applysData[i];
        end
    end

    return nil;
end

function SocialDataManager:HasApplyData2(id)
    for i = 1, #(self.applyServerData) do
        if tonumber(id) == self.applyServerData[i].uid then
            return self.applyServerData[i];
        end
    end

    return nil;
end

function SocialDataManager:ReSetApplyData()
    self.applysData = {};
    self.applyServerData = {};
end
-----------------------------------------------------------------

function SocialDataManager:QueryFriendInfoFromServer(callback)

    --[[
        self.friendsData = {
            [1] = {friendid = '11001438'},
            [2] = {friendid = '11001439'},
        }
        self.applysData = {
            [1] = {friendid = '11001287'},
            [2] = {friendid = '11001440'},
            [3] = {friendid = '11001441'},
        };
    --]]

    local temp = {};
    for i = 1, #(self.friendsData) do
        table.insert(temp, tostring(self.friendsData[i].friendid));
    end
    for i = 1, #(self.qwFriendData) do
        table.insert(temp, tostring(self.qwFriendData[i].friendid));
    end
    for i = 1, #(self.applysData) do
        table.insert(temp, tostring(self.applysData[i].friendid));
    end
    local _callback = function()
        self:SortServerData();
        if callback then
            callback();
        end
    end
    self:QueryFriendInfo(temp, _callback);
end

function SocialDataManager:QueryQWFriendInfoFromServer(callback)
    -- 使用游戏内好友数据建立查询表
    local bIsGameFriend = {}
    for index, data in ipairs(self.friendsData) do
        bIsGameFriend[data.friendid] = true
    end
    -- 筛选出关系链好友中, 不在游戏内好友列表中的玩家, 强制添加为游戏内好友(在限定个数内)
    local uiGameFriendSumCont = #self.friendsData
    local uiRemainAddCount = MAX_GAME_FRIEND_COUNT - uiGameFriendSumCont
    local kQueryInfoList = {}
    for index, kTecentFriend in ipairs(self.qwFriendData) do
        local strID = tostring(kTecentFriend.friendid)
        if (bIsGameFriend[strID] ~= true) and (uiRemainAddCount > 0) then
            uiRemainAddCount = uiRemainAddCount - 1
            -- 和灵波确认过, 目前同玩关系链好友量不会太大, 并且公共服有自己的限速,
            -- 所以请求强制添加好友放在循环里没有问题
            NetCommonFriend:AddFriend(strID)
        end
        table.insert(kQueryInfoList, strID)
    end
    local _callback = function()
        self:SortServerData();
        if callback then
            callback();
            callback = nil;
        end
    end
    self:QueryFriendInfo(kQueryInfoList, _callback);
end

function SocialDataManager:SortServerData()

    -- local _func = function(sortArray)
    --     local tempTableArray = {};
    --     local itemTableROL = {};
    --     local itemTableRNOL = {};
    --     local itemTableOL = {};
    --     local itemTableNOL = {};
    --     table.insert(tempTableArray, itemTableROL);
    --     table.insert(tempTableArray, itemTableOL);
    --     table.insert(tempTableArray, itemTableRNOL);
    --     table.insert(tempTableArray, itemTableNOL);

    --     for i = 1, #(sortArray) do
    --         local info = sortArray[i];
    --         if info.ext then
    --             local bRMBPlayer = tonumber(info.ext.dwRMBPlayer or 0);
    --             if bRMBPlayer > GetCurServerTimeStamp() then
    --                 if info.online then
    --                     table.insert(itemTableROL, info);
    --                 else
    --                     table.insert(itemTableRNOL, info);
    --                 end
    --             else
    --                 if info.online then
    --                     table.insert(itemTableOL, info);
    --                 else
    --                     table.insert(itemTableNOL, info);
    --                 end
    --             end
    --         else
    --             if info.online then
    --                 table.insert(itemTableOL, info);
    --             else
    --                 table.insert(itemTableNOL, info);
    --             end
    --         end 
    --     end

    --     local tempArray = {};
    --     for i = 1, #(tempTableArray) do
    --         table.move(tempTableArray[i], 1, #(tempTableArray[i]), #(tempArray) + 1, tempArray);
    --     end

    --     return tempArray;
    -- end

    -- self.friendServerData = {};
    -- for i = 1, #(self.friendsData) do
    --     local friendServerData = self:GetOtherPlayerData(self.friendsData[i].friendid);
    --     if friendServerData then
    --         table.insert(self.friendServerData, friendServerData);
    --     end
    -- end
    -- for i = 1, #(self.qwFriendData) do
    --     local friendServerData = self:GetOtherPlayerData(self.qwFriendData[i].friendid);
    --     if friendServerData then
    --         table.insert(self.friendServerData, friendServerData);
    --     end
    -- end
    -- self.friendServerData = _func(self.friendServerData);
    
    -- self.applyServerData = {};
    -- for i = 1, #(self.applysData) do
    --     local applyServerData = self:GetOtherPlayerData(self.applysData[i].friendid);
    --     if applyServerData then
    --         table.insert(self.applyServerData, applyServerData);
    --     end
    -- end
    -- self.applyServerData = _func(self.applyServerData);
   
    self:SortFriendData();
    self:SortApplyData();
end

function SocialDataManager:SortDataFunc(sortArray)
    if not sortArray then
        return;
    end

    local tempTableArray = {};
    local itemTableROL = {};
    local itemTableRNOL = {};
    local itemTableOL = {};
    local itemTableNOL = {};
    table.insert(tempTableArray, itemTableROL);
    table.insert(tempTableArray, itemTableOL);
    table.insert(tempTableArray, itemTableRNOL);
    table.insert(tempTableArray, itemTableNOL);

    for i = 1, #(sortArray) do
        local info = sortArray[i];
        if info.ext then
            local bRMBPlayer = tonumber(info.ext.dwRMBPlayer or 0);
            if bRMBPlayer > GetCurServerTimeStamp() then
                if info.online then
                    table.insert(itemTableROL, info);
                else
                    table.insert(itemTableRNOL, info);
                end
            else
                if info.online then
                    table.insert(itemTableOL, info);
                else
                    table.insert(itemTableNOL, info);
                end
            end
        else
            if info.online then
                table.insert(itemTableOL, info);
            else
                table.insert(itemTableNOL, info);
            end
        end 
    end

    local tempArray = {};
    for i = 1, #(tempTableArray) do
        table.move(tempTableArray[i], 1, #(tempTableArray[i]), #(tempArray) + 1, tempArray);
    end

    return tempArray;
end

function SocialDataManager:SortFriendData()
    self.friendServerData = {}
    -- 由于现在进游戏走到 QueryQWFriendInfoFromServer 的时候会吧腾讯关系链好友强制加为游戏内好友
    -- 所以会出现一个好友的数据在 self.friendsData 与 self.qwFriendData 中同时出现的情况
    -- 所以Sort的时候遵循规则: 
    -- 1.以腾讯关系链好友数据为优先, 如果玩家数据优先出现在了 self.qwFriendData 中, 那么不采用 self.friendsData 中的重复数据
    -- 2.腾讯关系链好友数据都打上 bIsFromTecentFriend = true 的标记
    local bInsertCheck = {}
    for index, kData in ipairs(self.qwFriendData) do
        local kFriendInfo = self:GetOtherPlayerData(kData.friendid)
        if kFriendInfo then
            kFriendInfo["bIsTecentFriend"] = true
            table.insert(self.friendServerData, kFriendInfo)
            bInsertCheck[kFriendInfo.uid] = true
        end
    end

    for index, kData in ipairs(self.friendsData) do
        if kData.friendid and (bInsertCheck[kData.friendid] ~= true) then
            local kFriendInfo = self:GetOtherPlayerData(kData.friendid)
            if kFriendInfo then
                kFriendInfo["bIsTecentFriend"] = false
                table.insert(self.friendServerData, kFriendInfo)
            end
        end
    end

    self.friendServerData = self:SortDataFunc(self.friendServerData);
end

function SocialDataManager:SortApplyData()
    self.applyServerData = {};
    for i = 1, #(self.applysData) do
        local applyServerData = self:GetOtherPlayerData(self.applysData[i].friendid);
        if applyServerData then
            table.insert(self.applyServerData, applyServerData);
        end
    end
    self.applyServerData = self:SortDataFunc(self.applyServerData);
end

function SocialDataManager:QueryFriendInfo(data, callback)
    if data and #(data) > 0 then
        if #(data) > 300 then
            derror('QueryFriendInfo out of range 300');
            local tempT = {};
            if #(data) > 300 then
                table.move(data, 1, 300, #(tempT) + 1, tempT);
                data = tempT;
            end
        end
        self.queryFriendCallBack = callback;
        NetCommonAttrib:GetAttrib(data);
    else
        LuaEventDispatcher:dispatchEvent("QUERY_FRIEND_FINISH")
    end
end

function SocialDataManager:UpdatePlayerData(aStrUsers, funcCallback)
    if (not aStrUsers) or (#aStrUsers == 0) then
        return
    end
    local funcProcess = function()
        SocialDataManager:GetInstance():SortServerData()
        if not funcCallback then
            return
        end
        funcCallback()
    end
    self:QueryFriendInfo(aStrUsers, funcProcess)
end

function SocialDataManager:SetQureyOtherPlayerData(data)
    if data.attribList then
        for k, v in pairs(data.attribList) do
            local tempData = v;

            if not tempData.ext then
                tempData.ext = {};
            end

            local otherPlayerData = self.otherPlayerData[tempData.uid];
            if otherPlayerData and otherPlayerData.ext and otherPlayerData.ext.sprite then
                tempData.ext.sprite = otherPlayerData.ext.sprite;
            end

            self.otherPlayerData[tempData.uid] = tempData;
            GetHeadPicByData(tempData.ext, function(sprite)
                if not self.otherPlayerData[tempData.uid].ext then
                    self.otherPlayerData[tempData.uid].ext = {};
                end
                self.otherPlayerData[tempData.uid].ext.sprite = sprite;
            end);
        end
    end

    if self.queryFriendCallBack then
        self.queryFriendCallBack();
        self.queryFriendCallBack = nil;
    end
    LuaEventDispatcher:dispatchEvent("QUERY_FRIEND_FINISH")
end

function SocialDataManager:GetOtherPlayerData(playerID)
    return self.otherPlayerData[tostring(playerID)];
end

function SocialDataManager:SetOtherPlayerData(data)
    if not data then
        return;
    end

    for i = 1, #(data) do
        self:SetPlayerData(data[i].attrib);
    end
end

function SocialDataManager:SetPlayerData(data)
    if data.uid then
        if not data.ext then
            data.ext = {};
        end
        self.otherPlayerData[data.uid] = data;
        GetHeadPicByData(data.ext, function(sprite)
            if not self.otherPlayerData[data.uid].ext then
                self.otherPlayerData[data.uid].ext = {};
            end
            self.otherPlayerData[data.uid].ext.sprite = sprite;
        end);
    end
end

function SocialDataManager:AddFriend(playerID, openID, vOpenID)
    if self:GetFriendDataByID(playerID) then
		SystemUICall:GetInstance():Toast('该玩家已是好友')
		return false
	end
    
	if not PlayerSetDataManager:GetInstance():GetTXCreditSceneLimit(TCSSLS_APPLY_FRIENDS) then
		OnRecv_TencentCredit_SceneLimit(1, {dwParam = TCSSLS_APPLY_FRIENDS}) 
		return  
	end 

	SendAddFriendReq(playerID, openID, vOpenID)
	SystemUICall:GetInstance():Toast('好友申请已发送')
end

return SocialDataManager;