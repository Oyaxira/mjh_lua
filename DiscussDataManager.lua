local dkJson = require("Base/Json/dkjson")
local TB_DISCUSS
local INIT_ALREADY
DISCUSS_TESTMODE = false
-- 控制讨论区功能是否开放
DISCUSS_ISOPEN = true
-- 控制不同模块是否开放
--                   任务  武学  角色  宠物  酒馆    
DISCUSS_OPENTABLE = {true,false,false,false,true}
-- 控制玩家留言功能是否开放
DISCUSS_OPENREPLY = false

DiscussDataManager = class('DiscussDataManager');
DiscussDataManager._instance = nil;

function DiscussDataManager:GetInstance()
    if DiscussDataManager._instance == nil then
        DiscussDataManager._instance = DiscussDataManager.new();
        DiscussDataManager._instance:Init();
    end

    return DiscussDataManager._instance;
end

--discuss的post请求需要带上论坛token
function DiscussDataManager:HttpPost(url, data, callback)
    if (self.discussToken == nil or  self.discussToken == "") then
        derror("论坛token为nil,未登录,无法发送请求")
        return
    end
    CS_Coroutine.start(function()
        local webRequest = CS.UnityEngine.Networking.UnityWebRequest(url, "POST")
        webRequest.timeout = 10
        webRequest.uploadHandler = CS.UnityEngine.Networking.UploadHandlerRaw(data)
        webRequest.downloadHandler = CS.UnityEngine.Networking.DownloadHandlerBuffer()
        webRequest:SetRequestHeader("Content-Type", "application/json")
        local tokenHeader = "Bearer "..self.discussToken
        webRequest:SetRequestHeader("Authorization", tokenHeader)
        coroutine.yield(webRequest:SendWebRequest())
        if webRequest.isHttpError or webRequest.isNetworkError then
            dprint(webRequest.error)
            if callback then
                callback({error = webRequest.error})
            end
        else 
            dprint(webRequest.downloadHandler.text)
            if callback then
                callback({data = webRequest.downloadHandler.text})
            end
        end
    end)
end

--getarticle需要增加header
function DiscussDataManager:HttpGet(url, callback,useSign,useTimestamp)
    if not url then
        return
    end
    CS_Coroutine.start(function()
        local webRequest = CS.UnityEngine.Networking.UnityWebRequest.Get(url);
        webRequest.timeout = 10
        if (useSign) then
            -- sign规则 = md5(thirdNo + timestamp + appId + secret)
            local signContent = self.articleId..os.time()..self.discussAppid..self.discussSecret
            local md5sign = string.lower(string.gsub(DRCSRef.GameConfig:GenMD5(signContent),"-",""))
            webRequest:SetRequestHeader("sign", md5sign)
        end
        if (useTimestamp) then
            webRequest:SetRequestHeader("timestamp", tostring(os.time()))
        end
        if (self.discussToken) then
            webRequest:SetRequestHeader("Authorization", "Bearer "..self.discussToken)
        end
        coroutine.yield(webRequest:SendWebRequest())
        if webRequest.isHttpError or webRequest.isNetworkError then
            dprint(webRequest.error)
            if callback then
                callback({error = webRequest.error})
            end
        else 
            dprint(webRequest.downloadHandler.text)
            if callback then
                callback({data = webRequest.downloadHandler.text})
            end
        end
    end)	
    
end

----- MUST STEP 1 -----
function DiscussDataManager:DiscussLogin(callback)
    -- POST /auth/freeLogin
    local loginUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/auth/freeLogin"
    -- 拼接sign

    local strZoneID = GetConfig("LoginZone") or 0
	local strServerNameKey = string.format("LoginServerName_%s", tostring(strZoneID))
    local serverName = GetConfig(strServerNameKey)
    local strServerKey = string.format("LoginServer_%s", tostring(strZoneID))
    local serverID = tostring(GetConfig(strServerKey))

    self.discussOpenid = ""
    self.playerId = ""
    if (PlayerSetDataManager:GetInstance():GetPlayerID()~=nil) then
        self.playerId = PlayerSetDataManager:GetInstance():GetPlayerID()
        self.discussOpenid = PlayerSetDataManager:GetInstance():GetPlayerID()..strZoneID..serverID
    end

    self.discussNickname = ""
    if (PlayerSetDataManager:GetInstance():GetPlayerName()~=nil) then
        self.discussNickname = PlayerSetDataManager:GetInstance():GetPlayerName()
    end
    self.discussAppid = "3"
    self.discussSecret = "060994ea4e4119cc"
    -- sign规则 = openid + nickname + appid + secret + timestamp
    local signContent = self.discussOpenid..self.discussNickname..self.discussAppid..self.discussSecret..os.time()
    local md5sign = string.lower(string.gsub(DRCSRef.GameConfig:GenMD5(signContent),"-",""))

    self.discussAvatar = ""
    if (MSDKHelper:GetPictureUrl()~=nil) then
        -- 头像URL 拼接前先编码 使用时需要先解码DRCSRef.CommonFunction.URLDecode()
        self.discussAvatar = MSDKHelper:GetPictureUrl()
    end

    local discussPlatId = 3 --默认其他平台
    if (MSDK_OS == 1) then
        --android
        discussPlatId = 1
    elseif (MSDK_OS == 2) then
        --ios
        discussPlatId = 0
    elseif (MSDK_OS == 5) then
        --pc
        discussPlatId = 2
    end    

    --Extra字段增加
    local meridiansLevel = MeridiansDataManager:GetInstance():GetSumLevel() or 0
    self.modelId = 0
    if (PlayerSetDataManager:GetInstance():GetModelID()~=nil) then
        self.modelId = PlayerSetDataManager:GetInstance():GetModelID()
    end
    
    local data = {
        ["openid"] = self.discussOpenid,
        ["nickname"] = self.discussNickname,
        ["avatar"] = self.discussAvatar,
        ["app_id"] = self.discussAppid,
        ['headboxID'] = PlayerSetDataManager:GetInstance():GetHeadBoxID(),
        ["plat_id"] = discussPlatId,
        ["sign"] = md5sign,
        ["extra"] = {
            ["MeridiansLevel"] = tostring(meridiansLevel),
            ["ModelID"] = tostring(self.modelId),
            ["PlayerID"] = tostring(self.playerId),
            ["ServerID"] = tostring(serverID),
            ["ServerName"] = tostring(serverName),
        }
    }
    local jsonData = dkJson.encode(data)
    HttpHelper:HttpPost(loginUrl,jsonData,function(result)
    --self:HttpGet(loginUrl, function(result)
        if (result == nil) then
            derror("DiscussLogin result nil")
            return
        end 
        if (result.data == nil) then
            derror("DiscussLogin result.data nil , error:"..result.error)
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil or resultData.code == nil then
            derror("DiscussLogin result.data after json nil or code=nil")
            return
        end
        if resultData.code ~= 0 or resultData.data == nil then
            derror("DiscussLogin 请求失败 错误码"..resultData.code.." "..resultData.message)
            return
        end
        --获得登录token
        self.discussToken = resultData.data.token;
        if callback then
            callback(resultData.data)
        end
    end,false,true)
end

----- MUST STEP 2 -----
----- 打开特定讨论界面必须先调用这个接口获取articleInnerId 
function DiscussDataManager:GetArticle(articleId,callback)
    -- GET /article  
    self.articleId = articleId
    local getArticleUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/article"
    local articleTitle = ""
    if TB_DISCUSS then
        for index, tbdata in pairs(TB_DISCUSS) do
            if (tbdata.ArticleID == articleId) then
                articleTitle = GetLanguageByID(tbdata.ArticleTitleID)
                break
            end
        end
    end
    local queryData = "?thirdNo="..articleId.."&appId="..self.discussAppid.."&title="..articleTitle
    getArticleUrl = getArticleUrl..queryData
    --使用带sign/timestamp header的HttpGet
    self:HttpGet(getArticleUrl, function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussGetArticle result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussGetArticle result.data after json nil")
            return
        end
        if resultData.code ~= 0 or resultData.code == nil or resultData.data == nil then
            derror("DiscussGetArticle 请求失败 返回0或者nil或 者data=nil")
            return
        end
        -- 其他接口的操作 必须后于这个接口 因为都需要这个articleInnerId 实际的articleId 没有用
        self.articleInnerId = resultData.data.id;
        if callback then
            callback(resultData.data)
        end    
    end,true,true)
end

function DiscussDataManager:PostComment(commentBody,callback)
    -- POST /comment/store/{articleId} articleId是self.articleInnerId
    local postCommentUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/store/"..self.articleInnerId
    local data = {
        ["body"] = commentBody
    }
    local jsonData = dkJson.encode(data)
    self:HttpPost(postCommentUrl,jsonData,function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussPostComment result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussPostComment result.data after jsondecode nil")
            return
        end
        if resultData.code == nil then
            derror("DiscussPostComment 请求失败 code=nil")
            return
        end
        if resultData.code ~=0 then
            if resultData.code == 1 then
                --发送cd2s
                SystemUICall:GetInstance():Toast("发送评论过快，请稍后再试",false)
            elseif resultData.code == 2 then
                --被禁言
                SystemUICall:GetInstance():Toast("无法发送评论",false)
            elseif resultData.code == 7 then
                --超过当日发言次数
                SystemUICall:GetInstance():Toast("今日发言次数已达上限！",false)
            elseif resultData.code == 5 then
                SystemUICall:GetInstance():Toast('评论中含有非法字符发送失败!',false)
                if callback then
                    callback(nil,false)
                end
            else
                dprint("DiscussPostComment 请求失败 错误码:"..resultData.code)
            end
            return
        else 
            if resultData.data == nil then
                derror("DiscussPostComment 请求失败 data=nil")
                return
            end
        end
        if callback then
            callback(resultData.data,true)
        end
    end)
end

function DiscussDataManager:ReplyComment(commentId,targetNickname,commentBody,callback)
    -- POST /comment/reply/{articleId}/{commentId}
    local replyCommentUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/reply/"..self.articleInnerId.."/"..commentId
    local data = {
        ["body"] = commentBody,
        ["target_nickname"] = targetNickname
    }
    local jsonData = dkJson.encode(data)
    self:HttpPost(replyCommentUrl,jsonData,function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussPostComment result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussPostComment result.data after jsondecode nil")
            return
        end
        if resultData.code == nil then
            derror("DiscussPostComment 请求失败 code=nil")
            return
        end
        if resultData.code ~=0 then
            if resultData.code == 1 then
                --发送cd2s
                SystemUICall:GetInstance():Toast("发送评论过快，请稍后再试",false)
            elseif resultData.code == 2 then
                --被禁言
                SystemUICall:GetInstance():Toast("无法发送评论",false)
            elseif resultData.code == 7 then
                --超过当日发言次数
                SystemUICall:GetInstance():Toast("今日发言次数已达上限！",false)
            elseif resultData.code == 5 then
                SystemUICall:GetInstance():Toast('评论中含有非法字符发送失败！',false)
                if callback then
                    --屏蔽字进cd
                    callback(nil,false)
                end
            else
                dprint("DiscussPostComment 请求失败 错误码:"..resultData.code)
            end
            return
        else 
            if resultData.data == nil then
                derror("DiscussPostComment 请求失败 data=nil")
                return
            end
        end
        if callback then
            local modelId = nil
            if (resultData.data.create_user_extra and resultData.data.create_user_extra['ModelID']) then
                modelId = tonumber(resultData.data.create_user_extra['ModelID'])
            end
            local data = {
                ['charPicUrl'] = resultData.data.create_avatar,
                ['dwModelID'] = modelId
            }
            GetHeadPicByData(data,function(sprite)
                resultData.data['charPic'] = sprite
            end)
            callback(resultData.data,true)
        end    
    end)
end

function DiscussDataManager:ClickLike(commentId,callback)
    -- POST /comment/like/{commentId} commentId评论id
    local clickLikeUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/like/"..commentId
    self:HttpPost(clickLikeUrl,nil,function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussClickLike result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussClickLike result.data after json nil")
            return
        end
        if resultData.code == nil or resultData.data == nil then
            derror("DiscussClickLike 请求失败 返回nil或者data=nil")
            return
        end
        if resultData.code ~= 0 then
            derror("DiscussClickLike 请求失败 错误码:"..resultData.code)
            return
        end
        if callback then
            callback(resultData.data)
        end    
    end)
end

function DiscussDataManager:ClickUnlike(commentId,callback)
    -- POST /comment/unlike/{commentId} commentId评论id
    local clickUnlikeUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/unlike/"..commentId
    self:HttpPost(clickUnlikeUrl,nil,function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussClickUnlike result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussClickUnlike result.data after json nil")
            return
        end
        if resultData.code == nil or resultData.data == nil then
            derror("DiscussClickUnlike 请求失败 返回nil或者data=nil")
            return
        end
        if resultData.code ~= 0 then
            derror("DiscussClickUnlike 请求失败 错误码:"..resultData.code)
            return
        end
        if callback then
            callback(resultData.data)
        end    
    end)
end


function DiscussDataManager:GetNewestComment(pageSize,pageIndex,callback)
    -- GET /comment/newest/{aritcleId}
    local getNewestCommentUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/newest/"..self.articleInnerId
    local queryData = "?size="..pageSize.."&page="..pageIndex
    getNewestCommentUrl = getNewestCommentUrl..queryData
    self:HttpGet(getNewestCommentUrl, function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussGetNewestComment result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussGetNewestComment result.data after json nil")
            return
        end
        if resultData.code ~= 0 or resultData.code == nil or resultData.data == nil then
            derror("DiscussGetNewestComment 请求失败 返回0或者nil或者data=nil")
            return
        end
        if callback then
            for k,v in pairs(resultData.data) do
                local modelId = nil
                if (v.create_user_extra and v.create_user_extra['ModelID']) then
                    modelId = tonumber(v.create_user_extra['ModelID'])
                end
                local data = {
                    ['charPicUrl'] = v.create_avatar,
                    ['dwModelID'] = modelId
                }
                GetHeadPicByData(data,function(sprite)
                    v['charPic'] = sprite
                end)
            end
            callback(resultData.data)
        end    
    end)
end

function DiscussDataManager:GetHottestComment(pageSize,pageIndex,callback)
    -- GET comment/hottest/{acticleId}
    local getHottestCommentUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/hottest/"..self.articleInnerId
    local queryData = "?size="..pageSize.."&page="..pageIndex
    getHottestCommentUrl = getHottestCommentUrl..queryData
    self:HttpGet(getHottestCommentUrl, function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussGetHottestComment result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussGetHottestComment result.data after json nil")
            return
        end
        if resultData.code ~= 0 or resultData.code == nil or resultData.data == nil then
            derror("DiscussGetHottestComment 请求失败 返回0或者nil或者data=nil")
            return
        end
        if callback then
            for k,v in pairs(resultData.data) do
                local modelId = nil
                if (v.create_user_extra and v.create_user_extra['ModelID']) then
                    modelId = tonumber(v.create_user_extra['ModelID'])
                end
                local data = {
                    ['charPicUrl'] = v.create_avatar,
                    ['dwModelID'] = modelId
                }
                GetHeadPicByData(data,function(sprite)
                    v['charPic'] = sprite
                end)
            end
            callback(resultData.data)
        end    
    end)
end


function DiscussDataManager:GetAllReplyComment(commentId,pageSize,pageIndex,callback,sortType)
    -- GET /comment/replyList/{commentId}
    -- sortType = 0 new 1 hot
    local getAllReplyCommentUrl = HttpHelper:GetLoginUrlConfig().DiscussUrl.."/comment/replyList/"..commentId
    local queryData = "?size="..pageSize.."&page="..pageIndex.."&type="..sortType
    getAllReplyCommentUrl = getAllReplyCommentUrl..queryData
    self:HttpGet(getAllReplyCommentUrl, function(result)
        if (result == nil or result.data == nil) then
            derror("DiscussGetAllReplyComment result nil or result.data nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("DiscussGetAllReplyComment result.data after json nil")
            return
        end
        if resultData.code ~= 0 or resultData.code == nil or resultData.data == nil then
            derror("DiscussGetAllReplyComment 请求失败 返回0或者nil或者data=nil")
            return
        end
        if callback then
            for k,v in pairs(resultData.data) do
                local modelId = nil
                if (v.create_user_extra and v.create_user_extra['ModelID']) then
                    modelId = tonumber(v.create_user_extra['ModelID'])
                end
                local data = {
                    ['charPicUrl'] = v.create_avatar,
                    ['dwModelID'] = modelId
                }
                GetHeadPicByData(data,function(sprite)
                    v['charPic'] = sprite
                end)
            end
            callback(resultData.data)
        end    
    end)
end

function DiscussDataManager:ReLogin()
    --改名后需要重新登录 判断下是否昵称改变
    if (self.discussNickname~=nil and self.discussNickname ~= PlayerSetDataManager:GetInstance():GetPlayerName()) then
        self:DiscussLogin()
    end
end

function DiscussDataManager:Login()
    -- 初始化需要建立对应的玩家账号 拿到token 作为拼接字后续需要使用
    self:DiscussLogin()
end


function DiscussDataManager:Init()
    if (INIT_ALREADY) then
        return
    end
    INIT_ALREADY = true
    TB_DISCUSS = TableDataManager:GetInstance():GetTable("Discuss") or {}    
end

-- 根据当前的界面type和词条id 获取讨论区id 
function DiscussDataManager:GetDiscussTitleId(themeType,themeId)
    if TB_DISCUSS then
        for index, tbdata in pairs(TB_DISCUSS) do
            if (tbdata.ArticleEnum == themeType and tbdata.TargetID == themeId) then
                return tbdata.ArticleID
            end
        end
    end
    return nil
end

function DiscussDataManager:SetTestMode(mode)
    if (mode == 0) then
        DISCUSS_TESTMODE = false
    else
        DISCUSS_TESTMODE = true
    end
end

function DiscussDataManager:SetReplyOpen(isopen)
    if isopen == 0 then
        DISCUSS_OPENREPLY = false
    else
        DISCUSS_OPENREPLY = true
    end
end

-- 发表评论和回复的限制
function DiscussDataManager:CanTalk(callback)
    if DISCUSS_TESTMODE and callback then
        callback(true,"")
        return
    end
    
    local limitMsg = ""
    local meridiansLevel = MeridiansDataManager:GetInstance():GetSumLevel()
    local creditScore = PlayerSetDataManager:GetInstance():GetTencentCreditScore()
    if (DISCUSS_OPENREPLY == false) then
        if callback then
            callback(false,"玩家评论功能即将开放")
        end
    elseif (meridiansLevel < 100) then
        if callback then
            callback(false,"经脉等级到达100后才可留言")
        end
    elseif (creditScore < 350) then
        if callback then
            callback(false,"信用分达到350才可留言")
        end
    else
        if callback then
            callback(true,"")
        end
    end
end

function DiscussDataManager:DiscussAreaOpen(areaID)
    if areaID == nil then
        return DISCUSS_ISOPEN
    end
    return DISCUSS_ISOPEN and DISCUSS_OPENTABLE[areaID]
end

return DiscussDataManager;