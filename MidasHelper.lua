local dkJson = require("Base/Json/dkjson")
local HttpHelper = require("Net/NetHttpHelper")
local MidasHelper = {}

local eToken_QQ_Access = 1
local eToken_QQ_Pay = 2
local eToken_WX_Access = 3
local eToken_WX_Code = 4
local eToken_WX_Refresh = 5
local eToken_Guest_Access = 6

local midasPayUrl = 'http://163.177.94.71:50004/v1/buyGoods' --midas支付
local gcloudmidastoken = "gcloudmidastoken"
local offerId = "1450020213" --midas后台可查
local useItopSession = false

local payCallback = nil

WAITQUERYGOLDCALLBACK = false

--初始化回调
function MidasHelper:OnMidasInitFinished(jsonStr)
    -- body
    dprint("初始化回调 jsonStr="..jsonStr)
end

function MidasHelper:QueryPlayerGoldUntilCallback()
    if (self.iQueryGoldTimer) then
        return
    end
    -- 设定3s后重新发起查询
    -- WAITQUERYGOLDCALLBACK 在金锭更新并有变化后置为false 则停止继续查询
    self.iQueryGoldTimer = globalTimer:AddTimer(3000,function()
        -- 发起金锭查询
        SendQueryPlayerGold(true, 1)
        if (not WAITQUERYGOLDCALLBACK) then
            self:RemoveQueryGoldTimer()
        end
    end,-1)
end

function MidasHelper:RemoveQueryGoldTimer()
    if not self.iQueryGoldTimer then
        return
    end
    globalTimer:RemoveTimerNextFrame(self.iQueryGoldTimer)
    self.iQueryGoldTimer = nil
end

--支付结束回调
function MidasHelper:OnMidasPayFinished(result)
    -- body
    --dprint("支付结束回调 jsonStr="..dkJson.decode(result))
    dprint("支付结束回调")
    --resultCode
    --支付流程失败 PAYRESULT_ERROR        = -1;
    --支付流程成功 PAYRESULT_SUCC         = 0;
    --用户取消 PAYRESULT_CANCEL       = 2;
    --参数错误 PAYRESULT_PARAMERROR   = 3;
    --未知 PAYRESULT_UNKOWN   = 100;        
    if result.resultCode == 0 then
        -- 支付成功 
        -- 1、执行支付调用时传入的callback
        if payCallback then
            local callback = payCallback
            callback()
            payCallback = nil
        end
        -- 2、执行充值后数据刷新
        WAITQUERYGOLDCALLBACK = true
        self:QueryPlayerGoldUntilCallback()
    elseif result.resultCode == 2 then
        SystemUICall:GetInstance():Toast('支付取消')
    else
        dprint(result.resultInerCode)   --内部错误码
        dprint(result.resultMsg)        --支付错误信息描述
        SystemUICall:GetInstance():Toast('支付失败！错误码'..result.resultInerCode..' 错误信息:'..result.resultMsg)
    end
    -- dprint(result.realSaveNum) --游戏币购买数据，only for android国内
    -- dprint(result.payChannel) --支付所使用的渠道
    -- dprint(result.appExtends) --游戏透传字段 only for iOS
end

--登录过期回调
function MidasHelper:OnMidasLoginExpired()
    local msg = "您的登录状态过期，请重新授权登录"
    local boxCallback = function()
        -- 比较特殊的,如果是微信平台,那么需要自动拉起微信的授权
        if (MSDKHelper:IsLoginWeChat()) then
            MSDKHelper.loginWeChatAutoRun = true
        end
        if (MSDKHelper:IsLoginQQ()) then
            MSDKHelper.loginQQAutoRun = true
        end
        ReturnToLogin(true)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback, {cancel = false, close = false, confirm = true}})
end

function MidasHelper:SetEvent()
    -- body
    DRCSRef.MidasMain.mOfferID = offerId
    DRCSRef.MidasMain.mLoginRet = nil
    self.OnMidasInitFinishedCallback = function(jsonStr)
        self:OnMidasInitFinished(jsonStr)
    end
    self.OnMidasPayFinishedCallback = function(result)
        self:OnMidasPayFinished(result)
    end
    self.OnMidasLoginExpiredCallback = function()
        self:OnMidasLoginExpired()
    end
    self.onMidasGetInfoCallback = function(jsonStr)
        local ans = {}
        if jsonStr then 
            local jsonObj = dkJson.decode(jsonStr)
            if jsonObj and jsonObj.ret and jsonObj.msg and jsonObj.ret == 0 then 
                local jsonObjmsg
                if type(jsonObj.msg) == "string" then
                    jsonObjmsg = dkJson.decode(jsonObj.msg)
                else
                    jsonObjmsg = jsonObj.msg
                end
                if jsonObjmsg then 
                    local mp_info = jsonObjmsg.mp_info
                    if mp_info then 
                        local utp_mpinfo = mp_info.utp_mpinfo
                        if utp_mpinfo then 
                            for i=1,#utp_mpinfo do
                                local info = utp_mpinfo[i]
                                ans[i] = true
                                if info.single_ex == nil then 
                                    ans[i] = false
                                end
                            end
                        end
                    end
                end
            end
        end
        self._mpInfo = ans
        local node = GetUIWindow("ShoppingMallUI")
        if node then 
            node:UpdateFirstRechargeInfo(ans)
        end
    end
    --绑定回调事件 注销放在c# ClearAllDelegate
    DRCSRef.MidasMain:OnMidasInitFinished('+',self.OnMidasInitFinishedCallback)
    DRCSRef.MidasMain:OnMidasLoginExpired('+',self.OnMidasLoginExpiredCallback)
    DRCSRef.MidasMain:OnMidasPayFinished('+',self.OnMidasPayFinishedCallback) 
    DRCSRef.MidasMain:OnGetInfoFinished('+',self.onMidasGetInfoCallback) 
end

--midas支付初始化
function MidasHelper:InitMidas()
    if not self.instance then
        -- dprint("midasHelper.InitMidas")
        local strServerKey = string.format("LoginServer_%s", tostring(GetConfig("LoginZone")))
        local zoneId = tostring(GetConfig(strServerKey)) or "1"
        if MIDAS_TEST_ENV then --测试环境
            DRCSRef.MidasMain:InitMidas("test", "local","" , true, zoneId)
            gcloudmidastoken = "gcloudmidastesttoken"
        else
            DRCSRef.MidasMain:InitMidas("release", "local","" , false, zoneId)
            gcloudmidastoken = "gcloudmidastoken"
        end
        WAITQUERYGOLDCALLBACK = false
        self.hasInit = true
    end
end

-- prodID  'com.tencent.apollo.bigcoin'
--GoodsMete 格式必须是“name*des”，批量购买套餐时也只能有1个道具名称和1个描述，即给出该套餐的名称和描述

function MidasHelper:PayItem(prodID,price,saveNum,GoodsMeta,buygoodsid,zoneID)
    if buyGoodsState == 1 then    
        dprint("道具直购进行中，请稍后");
        return
    else
        dprint("开始道具直购，开始下单");
        buyGoodsState = 1
    end
    -- BuyGoodsRequest myObject = new BuyGoodsRequest();
    local mLoginRet = DRCSRef.MSDKLogin:GetLoginRet()
    -- local price = 1
    -- local saveNum = 20
    local myObject = {}
    myObject.OpenID = mLoginRet.OpenId
    myObject.OpenKey = mLoginRet.Token
    myObject.AppID = offerId
    myObject.Pf = mLoginRet.Pf
    myObject.PfKey = mLoginRet.PfKey
    myObject.ZoneID = zoneID and zoneID or "1"
    myObject.PayItem = string.format("%s*%s*%s",prodID, price, saveNum)
    -- myObject.GoodsMeta = "coin*888";
    myObject.GoodsMeta = GoodsMeta;
    -- myObject.BuyGoodsID = "buygoodsid";
    myObject.BuyGoodsID = buygoodsid
    myObject.Sig = DRCSRef.MidasMain:sha256(myObject.BuyGoodsID .. gcloudmidastoken)

    if mLoginRet.Channel == "WeChat" then
        myObject.sessionId = useItopSession and "itopid" or "hy_gameid"
        myObject.sessionType = useItopSession and "itop" or "wc_actoken"  
    elseif mLoginRet.Channel == "QQ" then
        myObject.sessionId = useItopSession and "itopid" or "openid"
        myObject.sessionType = useItopSession and "itop" or "kp_actoken" 
    end

    dprint("myObject="..dkJson.encode(myObject))

    CS_Coroutine.start(function()
        local webRequest = CS.UnityEngine.Networking.UnityWebRequest(midasPayUrl, "POST");

        webRequest.timeout = 20;
        webRequest.uploadHandler = CS.UnityEngine.Networking.UploadHandlerRaw(dkJson.encode(myObject));
        webRequest.downloadHandler = CS.UnityEngine.Networking.DownloadHandlerBuffer();
        webRequest:SetRequestHeader("Content-Type", "application/json")
        coroutine.yield(webRequest:SendWebRequest());

        if webRequest.isHttpError or webRequest.isNetworkError then
            derror('ERROR HttpPost2 : ' .. webRequest.error);
        else 
            --调起支付
            DRCSRef.MidasMain:LaunchBuyGoods(midasPayUrl, price, saveNum, prodID)
        end
        buyGoodsState = 0
    end)	
end

function MidasHelper:SetAndroid_ExtrasJson_uiconfig(unit,isShowNum,isShowListOtherNum,isCanChange ,extras ,resData ,resId,mallLogo)
    local uiconfig = {}
    uiconfig.unit =  unit and unit or "ge"
    uiconfig.isShowNum = isShowNum and isShowNum or false
    uiconfig.isShowListOtherNum = isShowListOtherNum and isShowListOtherNum or false
    uiconfig.isCanChange = isCanChange and isCanChange or false  --购买数量是否可修改，如果不可编辑需要跳过数量修改页，该字段设置为false
    uiconfig.extras = extras and extras or ""
    uiconfig.resData = resData and resData or ""
    uiconfig.resId = resId and resId or 0
    uiconfig.mallLogo = mallLogo and mallLogo or 0
    return uiconfig
end	

function MidasHelper:SetAndroid_ExtrasJson_drmConfig(discountType,discountUrl,discoutId,drmInfo)
    local drmConfig = {}
    drmConfig.discountType =  discountType and discountType or ""
    drmConfig.discountUrl =  discountUrl and discountUrl or ""
    drmConfig.discoutId =  discoutId and discoutId or ""
    drmConfig.drmInfo =  drmInfo and drmInfo or ""
    return drmConfig
end	

function MidasHelper:SetAndroid_ExtrasJson_others(mallType,h5Url)
    local others = {}
    others.mallType =  discountType and discountType or ""
    others.h5Url =  discountUrl and discountUrl or ""
    return others
end	

function MidasHelper:SetExtrasJson(uiconfig ,drmConfig ,others )
    local android_extras = {}
    android_extras.uiconfig = uiconfig and uiconfig or {}
    android_extras.uiconfig = drmConfig and drmConfig or {}
    android_extras.uiconfig = others and others or {}
    return android_extras
end

function MidasHelper:SetAndroid_ExtrasJsonDefault()
    -- body
    return self:SetAndroid_ExtrasJson("ge",false,false,false,"","",0,0,"","","","","","")
end

--安卓额外设置
function MidasHelper:SetAndroid_ExtrasJson(unit,isShowNum,isShowListOtherNum,isCanChange ,extras ,resData ,resId,mallLogo,discountType,discountUrl,discoutId,drmInfo,mallType,h5Url)
    local android_extras = {}
    local uiconfig = {}
    uiconfig.unit =  unit and unit or "ge"
    uiconfig.isShowNum = isShowNum and isShowNum or false
    uiconfig.isShowListOtherNum = isShowListOtherNum and isShowListOtherNum or false
    uiconfig.isCanChange = isCanChange and isCanChange or false  --购买数量是否可修改，如果不可编辑需要跳过数量修改页，该字段设置为false
    uiconfig.extras = extras and extras or ""
    uiconfig.resData = resData and resData or ""
    uiconfig.resId = resId and resId or 0
    uiconfig.mallLogo = mallLogo and mallLogo or 0

    local drmConfig = {}
    drmConfig.discountType =  discountType and discountType or ""
    drmConfig.discountUrl =  discountUrl and discountUrl or ""
    drmConfig.discoutId =  discoutId and discoutId or ""
    drmConfig.drmInfo =  drmInfo and drmInfo or ""

    local others = {}
    others.mallType =  discountType and discountType or ""
    others.h5Url =  discountUrl and discountUrl or ""

    android_extras.uiconfig = uiconfig
    android_extras.drmConfig = drmConfig
    android_extras.others = others

    return dkJson.encode(android_extras)
end


-- 充值外部实际调用接口
function MidasHelper:Deposit(value,callback)
    local android_saveValue = tostring(value*10) --"100" 购买数量
    local android_extras = self:SetAndroid_ExtrasJsonDefault()
    local ios_productId = "com.tencent.dhwdxk.jinding"..value --"com.tencent.dhwdxk.jinding720"
    local ios_payitem = tostring(value*10)   --"60" “物品ID*单价(单位：角)*数量”
    local ios_appExtends = "aid=1234"  --"aid=1234" 透传字段
    payCallback = callback
    self:PayCoin(android_saveValue,android_extras,ios_productId,ios_payitem,ios_appExtends)
end

--货币购买
function MidasHelper:PayCoin(android_saveValue ,android_extras, ios_productId ,ios_payitem,ios_appExtends)
    dprint("MidasHelper:PayCoin")
      dprint(android_saveValue)
       dprint(android_extras)
        dprint(ios_productId)
         dprint(ios_payitem)
          dprint(ios_appExtends)
    local strServerKey = string.format("LoginServer_%s", tostring(GetConfig("LoginZone")))
    local zoneId = tostring(GetConfig(strServerKey)) or "1"
    DRCSRef.MidasMain:PayCoin(android_saveValue ,android_extras, ios_productId ,ios_payitem, ios_appExtends, zoneId)
end
 
--extras 可用SetAndroid_ExtrasJson
function MidasHelper:PaySubscribe(serviceCode,serviceName,productId,saveValue,extras)
    DRCSRef.MidasMain:PaySubscribe(serviceCode,serviceName,productId,saveValue,extras)
end

--月卡
function MidasHelper:PayMonth(serviceCode,serviceName,serviceType,autoPay)
    DRCSRef.MidasMain:PayMonth(serviceCode,serviceName,serviceType,autoPay)
end

--运营活动
function MidasHelper:QueryMPInfo()
    if self.hasInit then
        if DRCSRef.MidasMain.QueryMPInfo then 
            local strServerKey = string.format("LoginServer_%s", tostring(GetConfig("LoginZone")))
            local zoneId = tostring(GetConfig(strServerKey)) or "1"
            DRCSRef.MidasMain:QueryMPInfo(zoneId)
        end
    end
end

return MidasHelper
