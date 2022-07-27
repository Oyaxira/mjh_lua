LimitShopManager = class("LimitShopManager")
LimitShopManager._instance = nil

local dkJson = require("Base/Json/dkjson")

function LimitShopManager:GetInstance()
    if LimitShopManager._instance == nil then
        LimitShopManager._instance = LimitShopManager.new()
        LimitShopManager._instance:BeforeInit()
    end

    return LimitShopManager._instance
end
function LimitShopManager:BeforeInit()
    self.TB_TimeLimitConfig = GetTableData("TimeLimitConfig",1)
    self.iGapTime = self.TB_TimeLimitConfig and self.TB_TimeLimitConfig.GapTime or 0
    self.iTriggerLv = self.TB_TimeLimitConfig and self.TB_TimeLimitConfig.TriggerLv or 24
end

function LimitShopManager:SetYaZhuRetData(kRetData)
    --dprint("###押注 callback")
    if not kRetData or not kRetData.acData then 
        return
    else
        local data = dkJson.decode(kRetData.acData)
        if (data) then
            self.kYaZhuRetData = data['yaZhu']
        else
            self.kYaZhuRetData = nil
        end
        LuaEventDispatcher:dispatchEvent("GET_YAZHURETDATA",kRetData)
    end
end

function LimitShopManager:GetNowGuessCoinGameRetData()
    if self.kYaZhuRetData then
        return self.kYaZhuRetData.select
    else
        return nil
    end
end

function LimitShopManager:GetNowGuessCoinGameLevel()
    if self.yaZhuNum then
        return self.yaZhuNum + 1
    else
        return 1
    end
end

function LimitShopManager:SetShareGetCoinTimes(kRetData)
    --dprint("###押注 callback")
    if not kRetData or not kRetData.acData then 
        return
    else
        local data = dkJson.decode(kRetData.acData)
        if (data) then
            self.kYaZhuRetData = data['yaZhu']
        else
            self.kYaZhuRetData = nil
        end
        --判断错误码
        LuaEventDispatcher:dispatchEvent("GET_YAZHURETDATA")
    end
end

function LimitShopManager:GetCurLimitShopState()
    -- ["等待阶段"] = LimitShopState.LSS_Wait;
    -- ["奇遇阶段"] = LimitShopState.LSS_BigmapAction;
    -- ["分享阶段"] = LimitShopState.LSS_Share;
    -- ["购买阶段"] = LimitShopState.LSS_Shop;
    if self:GetLeftTimeStr_Shop() and self.iLimitShopState then 
        if self.iLimitShopState <= LimitShopState.LSS_BigmapAction then 
            return LimitShopState.LSS_BigmapAction
        elseif  self:GetIfShareFinished() then 
            return LimitShopState.LSS_Shop
        else 
            return LimitShopState.LSS_Share
        end
    else 
        return LimitShopState.LSS_Wait 
    end 
end 
function LimitShopManager:CheckBigmapEvent()
    return LimitShopState.LSS_BigmapAction == self:GetCurLimitShopState() or true
end 

function LimitShopManager:SetRetDataShop(kRetData)
    self.shopData = kRetData and kRetData.shopData or {}
    self.iOverTime = self.shopData.overTime
    self.nextTime = self.shopData.nextTime
    self.refreshTime = self.shopData.refreshTime
    self.yaZhuFinished = self.shopData.yaZhuFinished
    self.yaZhuNum = 0
    if (self.shopData.yaZhuNum) then
        self.yaZhuNum = self.shopData.yaZhuNum
    end

    local data = os.date('*t',self.iOverTime)
    local dat2a = os.date('*t',self.nextTime)
    local dat3a = os.date('*t',self.refreshTime)
    
    self.refreshNum = self.shopData.refreshNum
    self.share = self.shopData.share
    self.giftList = self.shopData.giftList
    self.coupons = self.shopData.coupons

    self.catchdata_bought = {} 
    -- 收到商店消息后 检查是否刷新商店
    if not self:GetLeftTimeStr(self.nextTime) then 
        self:CheckRefreshShop()
    end 
    LuaEventDispatcher:dispatchEvent("UPDATE_LIMITSHOP_BUTTON")
end
function LimitShopManager:SetWaitOpenUI(bForceOpen)
    self.bForceOpen = true
end
function LimitShopManager:GetYaZhuFinished()
    return self.yaZhuFinished == false
end
function LimitShopManager:GetDiscountList()
    local ret = {}
    local TimeLimitConfig = GetTableData( 'TimeLimitConfig',1)
    local addtime =( TimeLimitConfig and TimeLimitConfig.DiscountEfcTime or 0 )* 60 * 60 
    for i,v in pairs(self.coupons or  {}) do 
        ret[i] = v
        ret[i].iEndTime = (v.gotTime or 0) + addtime
    end 
    return ret or {}
end
function LimitShopManager:GetShopShowData()
    return self.giftList or {}
end

function LimitShopManager:SetBigmapActionFlag(kRetData)
    self.iLimitShopState = kRetData or 0
end

function LimitShopManager:SetFreeGiveBigCoinFlag(kRetData)
    self.iFreeGiveBigCoinFlag = kRetData or 0
end

function LimitShopManager:SetShopAfterBuy(kRetData)
    -- 必对做法 再请求getdata一次
    -- local _str = kRetData and kRetData.acMessage or ''
    -- _tab = dkJson.decode(_str) or {}
    -- if _tab and _tab.finBuy and self.giftList then 
    --     for i,gift in pairs(self.giftList) do 
    --         if gift and gift.giftType ==_tab.giftType then 
    --             self.giftList[i].finBuy = true
    --             LuaEventDispatcher:dispatchEvent("UPDATE_LIMITSHOP_BUTTON")
    --             return 
    --         end 
    --     end 
    -- end 
    SendLimitShopOpr(EN_LIMIT_SHOP_GET)
end 
local lvlistach = {1,2,3,48,4,5,6,49}
-- 获取限时商店刷新的条件字符串
function LimitShopManager:GetShopCondDatas()
    local iLimitShopData = self:GetCheckData()
    local _strFit = dkJson.decode(iLimitShopData.strFit) or {}
    local _ret = {}
    for strType,strTime in pairs(_strFit) do 
        table.insert( _ret, {
            itype = strType,
            itime = strTime or 0,
        })
    end 
    -- 等级提升不是每天都会刷新，所以每次获取的时候单独判断下
    if not _strFit[tostring(LimitShopType.eLimitLVUp)] and self:GetIfLimitLVUp() then 
        table.insert( _ret, {
            itype = tostring(LimitShopType.eLimitLVUp),
            itime = os.time(),
        })
    end 

    table.sort( _ret, function(a,b)
        return a.itime < b.itime
    end)
    local ret_2 = {}
    for i,v in ipairs(_ret) do 
        -- 每个类型的礼包都有单独的剧本出现机制
        if self:GetScriptLimit(tonumber(v.itype)) then 
            ret_2[#ret_2 +1] = tonumber(v.itype)
        end 
    end 
    if #ret_2 > 1 then 
        local str = dkJson.encode(ret_2) 
        return str
    end 
    return nil 
end
function LimitShopManager:AddCheckData(eType,iNum)
    local iLimitShopData = self:GetCheckData()
    eType = tostring(eType or 0)
    if iLimitShopData[eType] then 
        iLimitShopData[eType] = iLimitShopData[eType] + (iNum or 1)
    end 
    -- check
    local TimeLimitConfig = GetTableData("TimeLimitConfig",1)
    local _str = dkJson.decode(iLimitShopData.strFit) or {}
    if not _str[eType] then 
        if not _str[tostring(LimitShopType.eLimitLVUp)] and self:GetIfLimitLVUp() then 
            _str[tostring(LimitShopType.eLimitLVUp)] = os.time()
        end 

        if (eType == tostring(LimitShopType.eMartialPiece)) and (TimeLimitConfig.DayLimitCanZhang or 3) <= (iLimitShopData[eType] or 0) then 
            _str[eType] = os.time()
        elseif (eType == tostring(LimitShopType.eRoleCard)) and (TimeLimitConfig.DayLimitRoleCard or 3) <= (iLimitShopData[eType] or 0) then 
            _str[eType] = os.time()
        elseif (eType == tostring(LimitShopType.eForge)) and (TimeLimitConfig.DayLimitForge or 3) <= (iLimitShopData[eType] or 0) then 
            _str[eType] = os.time()
        end
        if _str[eType] then 
            iLimitShopData.strFit = dkJson.encode(_str)
        end
    end 
    local playerID = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
    SetConfig('LimitShopData',iLimitShopData)
end
-- 首次是否结束判断
function LimitShopManager:GetIfShareFinished()
    if  self.iFreeGiveBigCoinFlag and self.iFreeGiveBigCoinFlag ~= 0  then 
        return true 
    elseif self.refreshTime == 0 then 
        return true 
    end 
end
-- 获取对话
function LimitShopManager:GetDialogue()
    if self:GetLeftTimeStr_Shop() then 
        if self.bshownLimitstr ~= true then 
            if self:GetIfShareFinished() then 
                return "[少侠]，我这有一些新进的礼包可供你选购，可针对喜欢的进行购买。"
            else
                return "[少侠]，请留步，本姑娘近期痴迷猜旺旺币游戏，来与本姑娘玩耍一番吧（先送你一个旺旺币）"
            end 
        end 
    end
    return nil
end 
-- 设置对话间隔 
function LimitShopManager:SetDialogueState(bState)
    self.bshownLimitstr = bState 
end 
function LimitShopManager:CheckRefreshShop()
    -- 判断时间允许 才进来
    -- 判断24级 或者已经首次分享结束了

    -- 剧本限制 
    if not self:GetScriptLimit() then
        return 
    end 

    if self:GetIfShareFinished() then 
        local acjson = self:GetShopCondDatas() 
        if acjson ~= nil then 
            SendLimitShopOpr(EN_LIMIT_SHOP_REFLASH,0,0,0,0,0,acjson)
            LimitShopManager:GetInstance():SetDialogueState(false)
        end 
    else
        -- 判断等级24 iTriggerLv
        local mainroeldata = RoleDataManager:GetInstance():GetMainRoleData()
        local uiLevelLimit = self.iTriggerLv
        if not mainroeldata or not mainroeldata['uiLevel'] or mainroeldata['uiLevel'] < uiLevelLimit then 
            return 
        end  
        SendLimitShopOpr(EN_LIMIT_SHOP_REFLASH,0,0,0,0,0,'[0]')
    end

end
function LimitShopManager:GetCheckDataByType(eType)
    eType = tostring(eType or 0)
    local iLimitShopData = self:GetCheckData()
    return iLimitShopData[eType] or 0 
end
function LimitShopManager:GetCheckData()
    
    local playerID = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
    local iLimitShopData = GetConfig('LimitShopData') or {}
    local curtime = os.time()
    local iLastD = os.date("%d",curtime) 
    local iLastM = os.date("%m",curtime) 
    local iLastY = os.date("%y",curtime) 
    if iLimitShopData.iLastD ~= iLastD or iLimitShopData.iLastM ~= iLastM or iLimitShopData.iLastY ~= iLastY or iLimitShopData.iplayerID ~= playerID then 
        iLimitShopData.iLastD = iLastD
        iLimitShopData.iLastM = iLastM
        iLimitShopData.iLastY = iLastY
        iLimitShopData.iplayerID = playerID
        iLimitShopData[tostring(LimitShopType.eLimitLVUp)] = 0
        iLimitShopData[tostring(LimitShopType.eRoleCard)] = 0
        iLimitShopData[tostring(LimitShopType.eMartialPiece)] = 0
        iLimitShopData[tostring(LimitShopType.eForge)] = 0
        local _str = {}
        if self:GetIfLimitLVUp() then 
            _str[tostring(LimitShopType.eLimitLVUp)] = os.time()
        end 
        iLimitShopData.strFit = dkJson.encode(_str)
    end
    return iLimitShopData
end 
function LimitShopManager:GetIfLimitLVUp()
    local info = globalDataPool:getData("MainRoleInfo");
    if info and info.MainRole then 
        local roleexp = info.MainRole[MainRoleData.MRD_EXTRA_ROLEEXP]
        if  roleexp and roleexp ~= 0 then 
            return true 
        end 
        roleexp = info.MainRole[MainRoleData.MRD_EXTRA_MARITAL]
        if  roleexp and roleexp ~= 0 then 
            return true
        end 
    end
end
function LimitShopManager:GetShopDataByID(iType,iGrade)
    if self.tb_limitshopdata == nil then 
        self.tb_limitshopdata = {}
        local TB_LimitShop = TableDataManager:GetInstance():GetTable("TimeLimitGiftV2")
        for i,data in pairs(TB_LimitShop) do 
            local type = data.GiftType or 0
            local grade = data.Grade or 0
            self.tb_limitshopdata[type] = self.tb_limitshopdata[type] or {}
            self.tb_limitshopdata[type][grade] = data
        end 
    end
    return self.tb_limitshopdata[iType][iGrade]
end 
function LimitShopManager:SetShareEndTime(iEndTime)
    self.iShareEndTime = iEndTime 
end 
function LimitShopManager:GetShareEndTime()
    return self.iOverTime 
end 
-- 获取限时商店的结束时间 
-- bIgnoreState 无视阶段 true：可以在大地图及之前的阶段获得倒计时 false/nil:相反
function LimitShopManager:GetLeftTimeStr_Shop(bIgnoreState)
    if not self.giftList or not self.giftList[1] then 
        return nil 
    end 

    if not self:GetScriptLimit() then
        return nil 
    end 

    local istate = self.iLimitShopState or 0
    if not bIgnoreState and istate <= LimitShopState.LSS_BigmapAction then 
        return nil 
    end 
    local ret = true  
    for i,gift in pairs(self.giftList) do 
        if not gift.finBuy then 
            ret = false 
        end
    end 
    if ret then 
        return nil 
    end 
    return self:GetLeftTimeStr(self.iOverTime)
end

-- 获取剩余时间的字符串 
-- param iSpTime int:期待的结束时间
-- return string：字符串 nil:没有倒计时
function LimitShopManager:GetLeftTimeStr(iSpTime)
    local iCurTime = os.time()

	local iEndTime = tonumber(iSpTime or 0)
	if iEndTime - iCurTime > 0 then 
		local CurTime = os.date('*t',iCurTime)
		local EndTime = os.date('*t',iEndTime)
		local isec_CurTime = ((CurTime.yday * 24 + CurTime.hour) * 60 + CurTime.min ) * 60 + CurTime.sec 
		local isec_EndTime = ((EndTime.yday * 24 + EndTime.hour) * 60 + EndTime.min ) * 60 + EndTime.sec 
		local isec_cha = isec_EndTime - isec_CurTime
		local iHour = math.floor(isec_cha / 3600)
		local iMin =  math.floor(isec_cha / 60 % 60) 
		local iSec =  math.floor(isec_cha % 60)
		
		local str = string.format( "%02d:%02d:%02d",iHour,iMin,iSec)
		return str
	else 
		return nil
	end 
end
function LimitShopManager:GetBuyStateByTypeid(iType)
    local LimitShopData = self:GetShopShowData()
    if self:GetCatchDateBought(iType) then 
        return true 
    end 
    if LimitShopData then 
        for i,kLimitShopData in pairs(LimitShopData) do 
            if kLimitShopData.giftType == iType then 
                if kLimitShopData.finBuy then  
                    return kLimitShopData.buyIndex or 0
                else 
                    return nil 
                end 
            end 
        end 
    end
    return nil
end
-- 设置点击购买后的临时标志，用于等待服务器下行的按钮中间状态
function LimitShopManager:SetCatchDateBought(iType)
    self.catchdata_bought = self.catchdata_bought or {} 
    if self.catchdata_bought.refreshTime ~= self.refreshTime or iType == nil then 
        self.catchdata_bought = {}
    end
    self.catchdata_bought.refreshTime = self.refreshTime
    if iType ~= nil then 
        self.catchdata_bought[iType] = true
    end 
    LuaEventDispatcher:dispatchEvent("UPDATE_LIMITSHOP_BUTTON")
end

-- 获取购买成功的临时标志，用于等待服务器下行的按钮中间状态
function LimitShopManager:GetCatchDateBought(iType)
    if iType and self.catchdata_bought and self.refreshTime and self.catchdata_bought.refreshTime == self.refreshTime then 
        return self.catchdata_bought[iType] or false 
    end
    return false 
end
-- param1 iType int:礼包类型 nil:代表奇遇
-- return boolean true:满足 false：不满足
function LimitShopManager:GetScriptLimit(iType)
    local icurStoryID = GetCurScriptID()
    if iType then 
        if not self.map_GiftEnableScripts then 
            self.map_GiftEnableScripts = {}
            local TB_LimitShop = TableDataManager:GetInstance():GetTable("TimeLimitGiftV2")
            for i,limitGift in pairs(TB_LimitShop or {}) do 
                if not self.map_GiftEnableScripts[limitGift.GiftType] then 
                    self.map_GiftEnableScripts[limitGift.GiftType] = {}
                    for kk,iScriptID in pairs(limitGift.EnableScripts or {}) do 
                        self.map_GiftEnableScripts[limitGift.GiftType][iScriptID] = true 
                    end 
                end
            end 
        end 
        return self.map_GiftEnableScripts[iType] and self.map_GiftEnableScripts[iType][icurStoryID] or false 
    else 
        if not self.map_TimeLimitEnableScripts then 
            self.map_TimeLimitEnableScripts = {}
            for i,iScriptID in pairs(self.TB_TimeLimitConfig and self.TB_TimeLimitConfig.TimeLimitEnableScripts or {}) do 
                self.map_TimeLimitEnableScripts[iScriptID] = true 
            end 
        end   
        return self.map_TimeLimitEnableScripts[icurStoryID] or false 
    end
end


-- 控制限时礼包的displayaction动作 
function LimitShopManager:SetLimitActionEnd(bEnd)
    self.bLimitActionEnd = bEnd
end 
-- 获取限时礼包的displayaction动作
function LimitShopManager:GetLimitActionEnd()
    if self.bLimitActionEnd ~= nil then 
        return self.bLimitActionEnd
    else
        return true 
    end 
end 
-- 获取限时礼包的displayaction动作
function LimitShopManager:LimitShopDisplayActionEnd()
    if self:GetLimitActionEnd() then 
        DisplayActionEnd()
    end 
end 

