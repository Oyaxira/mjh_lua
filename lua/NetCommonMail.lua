NetCommonMail = {};

-- 邮件相关事件定义
MailEventType = {
    ME_None     = 0,    -- 无
    ME_NewMail  = 1,    -- 新邮件
}

local urlGetMailPage    = 'MailService.GetMailPage';
local urlGetMail        = 'MailService.GetMail';
local urlGetMailList    = 'MailService.GetMailList';
local urlMarkRead       = 'MailService.MarkRead';
local urlDelMail        = 'MailService.DelMail';
local urlDelMailV2      = 'MailService.DelMailV2';
local urlSendMail       = 'MailService.SendMail';
local urlCountMails      = 'MailService.CountMails';
local urlGetMailPageV2  = 'MailService.GetMailPageV2';

function NetCommonMail:Init(data)
    
	local mail = {};
    mail.data = data;
    
	local config = NetCommonData.Config;
    local from = ''--config.host .. config.url;
    mail.urlGetMailPage = from .. urlGetMailPage;
    mail.urlGetMail     = from .. urlGetMail;
    mail.urlGetMailList = from .. urlGetMailList;
    mail.urlMarkRead    = from .. urlMarkRead;
    mail.urlDelMail     = from .. urlDelMail;
    mail.urlDelMailV2   = from .. urlDelMailV2;
    mail.urlSendMail    = from .. urlSendMail;
    mail.urlCountMails  = from .. urlCountMails;
    mail.urlGetMailPageV2  = from .. urlGetMailPageV2;

    self.mail = mail;
    return mail;
end

function NetCommonMail:IsAny(mailState)
    return mailState == MailState.Any
end

function NetCommonMail:IsNew(mailState)
    return mailState == MailState.New
end

function NetCommonMail:IsRead(mailState)
    return mailState == MailState.Read
end

function NetCommonMail:IsReceived(mailState)
    return mailState == MailState.Received
end

function NetCommonMail:IsReadReceived(mailState)
    return mailState == MailState.ReadReceived
end

-- 按页获取邮件数据
-- @int32 page  当前页
-- @int32 page_num  每一页的数量
-- @MailState state  过滤指定状态
-- @callback function(string, GetMailPageReply) end
function NetCommonMail:GetMailPage(page, page_num, state, isCahce)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid,
            userid      = self.mail.data.userid,
            page        = page,
            page_num    = page_num,
            state       = state,
        }
        
        AppsManager.Invoker:AsyncCall(self.mail.urlGetMailPage, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetMailPage(r.data, r.code, isCahce);
        end)
    end
end

function NetCommonMail:OnGetMailPage(data, code, isCahce)
    if code ~= 0 then
        return;
    end

    AppsManagerFlag = false;

    SocialDataManager:GetInstance():SetMailData(data, isCahce);
    local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
    local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');
    local toptileUI = WindowsManager:GetInstance():GetUIWindow('ToptitleUI');
    if socialUI then
        socialUI:RefMailRedPoint();
        -- socialUI:ResetMailPage();
        socialUI:OnRefMailUI(false);
        if socialUI.bGetNeedGetNextPage then
            socialUI.bGetNeedGetNextPage = false;
            socialUI:OnClickGetBtn(nil);
        end
        if socialUI.bDelNeedGetNextPage then
            socialUI.bDelNeedGetNextPage = false;
            socialUI:OnClickDelBtn(nil);
        end
    end
    if houseUI then
        houseUI:RefMailRedPoint();
    end
    if toptileUI then
        toptileUI:RefreshUI()
    end
end

--  分页查询V2
--  按页查询邮件数据，支持更多条件
-- @int32 page  @Validate(min = 1)
-- @int32 page_num  @Validate(min = 1, max = 100)
-- @string from   新增过滤器
-- @[]protocol.MailState state   指定邮件状态
-- @[]int32 type   指定邮件类型
-- @callback function(string, GetMailPageV2Reply) end
function NetCommonMail:GetMailPageV2(page, page_num, from, state, type, isCahce)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid    = NetCommonData.Config.appid,
            userid   = self.mail.data.userid,
            page     = page,
            page_num = page_num,
            from     = from,
            state    = state,
            type     = type,
        }
    
        AppsManager.Invoker:AsyncCall(self.mail.urlGetMailPageV2, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetMailPageV2(r.data, r.code, isCahce);
        end)
    end
end

function NetCommonMail:OnGetMailPageV2(data, code, isCahce)
    self:OnGetMailPage(data, code, isCahce);
end

-- 获得指定邮件的详细数据
-- @int64 id  邮件Id
-- @callback function(string, GetMailReply) end
function NetCommonMail:GetMail(id)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.mail.data.userid,
            id      = id,
        }
        
        AppsManager.Invoker:AsyncCall(self.mail.urlGetMail, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetMail(r.data, r.code);
        end)
    end
end

function NetCommonMail:OnGetMail(data, code)
    if code ~= 0 then
        return;
    end

    local bAdd = SocialDataManager:GetInstance():AddMailData(data.mail);
    local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
    local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');
    if bAdd then
        if socialUI then
            socialUI:AddMail(data.mail);
        end
        if houseUI then
            houseUI:RefMailRedPoint();
        end
    end
end

-- 标记为已读 - 客户端调用接口
-- 将新邮件状态标记为已读状态，返回标记成功的列表，重复调用只有第一次标记成功会返回数据
-- @[]int64 ids  邮件id列表
-- @callback function(string, MarkReadReply) end
function NetCommonMail:MarkRead(ids)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid, 
            userid  = self.mail.data.userid, 
            ids     = ids, 
        }
        
        AppsManager.Invoker:AsyncCall(self.mail.urlMarkRead, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnMarkRead(ids, r.data, r.code);
        end)
    end
end

function NetCommonMail:OnMarkRead(ids, data, code)
    if code ~= 0 then
        return;
    end

    SocialDataManager:GetInstance():SetMailDataState(ids, MailState.Read);
    local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');
    if houseUI then
        houseUI:RefMailRedPoint();
    end
end

-- 删除一个或者多个邮件
-- @[]int64 ids  优先删除ids列表，如果没有提供则删除指定状态
-- @MailState state  删除所有指定状态的邮件
-- @callback function(string, DelMailReply) end
function NetCommonMail:DelMail(ids, state)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.mail.data.userid,
            ids     = ids,
            state   = state,
        }
        
        AppsManager.Invoker:AsyncCall(self.mail.urlDelMail, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnDelMail(ids, r.data, r.code);
        end)
    end
end

function NetCommonMail:OnDelMail(ids, data, code)
    if code ~= 0 then
        return;
    end

    SocialDataManager:GetInstance():DelMailDataByID(ids);
    local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
    if socialUI then
        socialUI:RefUIDelMail(data);
    end
end

--  删除邮件V2
--  安全删除，防止误删没有领取附件的邮件
--  删除 已读没有附件，或者 有附件 已领取的
-- @[]int64 ids  @Validate(max = 100)
-- @callback function(string, DelMailV2Reply) end
function NetCommonMail:DelMailV2(ids)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.mail.data.userid,
            ids    = ids,
        }
    
        AppsManager.Invoker:AsyncCall(self.mail.urlDelMailV2, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp)
            if not r and err then
                return;
            end
            self:OnDelMailV2(ids, r.data, r.code);
        end)
    end
end

function NetCommonMail:OnDelMailV2(ids, data, code)
    self:OnDelMail(data.ids, data, code)
end

-- 发送一封邮件
-- @string receiver  接受目标用户
-- @string title  邮件标题
-- @string content  邮件正文
-- @string attachment  附件内容(游戏服务器自定义)
-- @int32 type  邮件类型 (游戏服务器自定义)
-- @callback function(string, SendMailReply) end
function NetCommonMail:SendMail(receiver, title, content, attachment, type)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid,
            userid      = self.mail.data.userid,
            receiver    = receiver,
            title       = title,
            content     = content,
            attachment  = attachment,
            type        = type,
        }
        
        AppsManager.Invoker:AsyncCall(self.mail.urlSendMail, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnSendMail(receiver, title, content, attachment, type, r.data, r.code);
        end)
    end
end

function NetCommonMail:OnSendMail(receiver, title, content, attachment, type, data, code)

end

--  统计邮件数量
--  用于显示红点等功能
-- @string from   指定发件人
-- @[]protocol.MailState state   指定邮件状态
-- @[]int32 type   指定邮件类型
-- @callback function(string, CountMailsReply) end
function NetCommonMail:CountMails(from, states, types, bTotleCount)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.mail.data.userid,
            from   = from,
            state  = states,
            type   = types,
        }
        
        AppsManager.Invoker:AsyncCall(self.mail.urlCountMails, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnCountMails(r.data, r.code, bTotleCount);
        end)
    end
end 

function NetCommonMail:OnCountMails(data, code, bTotleCount)
    if code ~= 0 then
        return;
    end

    if bTotleCount then
        SocialDataManager:GetInstance():SetMailTotleCount(data.total);
    else
        SocialDataManager:GetInstance():SetMailRedPoint(data.total);
    end

    local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');
    if houseUI then
        houseUI:RefMailRedPoint();
    end
end

--  查询指定邮件列表
-- @[]int64 ids  @Validate(nonzero, min = 1, max = 50)
-- @callback function(string, GetMailListReply) end
function NetCommonMail:GetMailList(ids)
    if self.mail and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.mail.data.userid,
            ids    = ids,
        }
    
        AppsManager.Invoker:AsyncCall(self.mail.urlGetMailList, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp)
            if not r and err then
                return;
            end
            self:OnGetMailList(ids, r.data, r.code);
        end)
    end
end

function NetCommonMail:OnGetMailList(ids, data, code)
    if code ~= 0 then
        return;
    end

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_GETALLMAIL', data.mailList);
end

return NetCommonMail;