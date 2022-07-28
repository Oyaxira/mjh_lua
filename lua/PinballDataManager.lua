PinballDataManager = class("PinballDataManager")
PinballDataManager._instance = nil

local SERVER_REWARD_MAX_SAVE_NUM = 10000  -- 全服奖励记录最大存储个数

function PinballDataManager:GetInstance()
    if PinballDataManager._instance == nil then
        PinballDataManager._instance = PinballDataManager.new()
        self:Clear()
    end

    return PinballDataManager._instance
end

-- 清空缓存
function PinballDataManager:Clear()
    self.kPinballCache = {}  -- 整个弹珠系统的数据缓存
    self.akItemGotThisRound = {}  -- 本轮游戏获得的所有物品奖励
    self.kPoolOpenState = nil  -- 奖池开放信息
    self.iCurPoolID = nil  -- 当前奖池id
    self.kCurPoolData = nil  -- 当前奖池静态数据
    self.kPoolBaseInfoCache = nil  -- 侠客行各类型奖池的BaseInfo缓存
    self.strQuickShootSettingKey = nil  -- 10连发设置键
    -- self.strItemGotListKey = nil  -- 已获得奖励存储键
    self.kLocalRecKeyCache = nil  -- 侠客行本地记录存储键
    -- 侠客行全服玩法
    self.kCurChooseReward = nil  -- 当前选中
    self.KCurQueue = nil  -- 当前即将开抢队列
    self.kRewardRemainNum = nil  -- 当前奖励剩余量
    self.fCurProgress = nil  -- 当前夺宝进度
    self.akProgressPusher = nil  -- 进度推进者队列
    self.iPusherIndex = nil  -- 进度推进队列索引
    self.strDevotedPlayersMsg = nil  -- 贡献者信息
    self.strResourcePath = nil  -- 活动宣传图路径
    self.uiServerPlayBeginTime = nil  -- 全服侠客行活动时间
    self.uiServerPlayEndTime = nil  -- 全服侠客行活动时间
end

-- 设置缓存数据
function PinballDataManager:SetPinballCache(iPoolID, strKey, info)
    if not (iPoolID and strKey and info) then
        return
    end
    if not self.kPinballCache then
        self.kPinballCache = {}
    end
    if not self.kPinballCache[iPoolID] then
        self.kPinballCache[iPoolID] = {}
    end
    self.kPinballCache[iPoolID][strKey] = info
end

-- 获取缓存数据
function PinballDataManager:GetPinballCache(iPoolID, strKey)
    if not (self.kPinballCache and iPoolID and self.kPinballCache[iPoolID]) then
        return
    end
    if strKey then
        return self.kPinballCache[iPoolID][strKey]
    end
    return self.kPinballCache[iPoolID]
end

-- 缓存当前奖励池的信息
function PinballDataManager:CacheCurPoolInfo(kLuckyNodeQueue, kEndSlotQueue)
    if not self.iCurPoolID then
        return
    end
    self:SetPinballCache(self.iCurPoolID, "eCurPoolType", self:GetCurPoolExcelData("PoolType"))
    self:SetPinballCache(self.iCurPoolID, "akLuckyNodeInfoSquence", kLuckyNodeQueue)
    self:SetPinballCache(self.iCurPoolID, "akEndSlotInfoSquence", kEndSlotQueue)
end

-- 通过dropid获得物品静态数据
function PinballDataManager:GenItemTypeDataByDropID(iDropID)
    local kDropData = TableDataManager:GetInstance():GetTableData("CommercialDrop",iDropID)
    if not (iDropID and kDropData) then
        return nil, 0
    end

    if not self.kDropID2ItemDataCache then
        self.kDropID2ItemDataCache = {}
    end

    if self.kDropID2ItemDataCache[iDropID] then
        local kCache = self.kDropID2ItemDataCache[iDropID]
        if kCache.kItemTypeData and kCache.iCount then
            return kCache.kItemTypeData, kCache.iCount
        end
    end

    local itemMgr = ItemDataManager:GetInstance()
    local itemTypeData = nil
    if kDropData.ItemID and (kDropData.ItemID > 0) then
        itemTypeData = TableDataManager:GetInstance():GetTableData("Item",kDropData.ItemID)
    elseif kDropData.MartialBook and (kDropData.MartialBook > 0) then
        itemTypeData = itemMgr:GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_IncompleteBook, kDropData.MartialBook)
    elseif kDropData.RoleCard and (kDropData.RoleCard > 0) then
        itemTypeData = itemMgr:GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_RolePieces, kDropData.RoleCard)
    elseif kDropData.PetCard and (kDropData.PetCard > 0) then
        itemTypeData = itemMgr:GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_PetPieces, kDropData.PetCard)
    end
    if not itemTypeData then
        derror("@未未: 弹珠掉落ID [" .. tostring(iDropID) .. "] 没有对应的物品数据")
    end

    self.kDropID2ItemDataCache[iDropID] = {
        ['kItemTypeData'] = itemTypeData,
        ['iCount'] = kDropData.Count,
    }

    return itemTypeData, kDropData.Count
end

-- 接收到奖池状态信息
function PinballDataManager:SetPoolState(kPoolsState)
    if not kPoolsState then
        return
    end
    self.kPoolOpenState = kPoolsState
end

-- 当前类型对应的奖池是否开放?
function PinballDataManager:IsPoolTypeOpen(ePoolType)
    if not (self.kPoolOpenState and ePoolType) then
        return false
    end
    return self.kPoolOpenState[ePoolType] == 1
end

-- 设置当前奖池
function PinballDataManager:SetCurPoolByID(iPoolID)
    if not iPoolID then
        return false
    end
    local kBaseData = TableDataManager:GetInstance():GetTableData("Hoodle", iPoolID)
    if not kBaseData then
        return false
    end
    self.iCurPoolID = iPoolID
    self.kCurPoolData = kBaseData
    return true
end

-- 获取当前奖池id
function PinballDataManager:GetCurPoolExcelID()
    return self.iCurPoolID
end

-- 获取当前奖池静态数据
function PinballDataManager:GetCurPoolExcelData(strKey)
    if not self.kCurPoolData then
        return
    end
    if not strKey then
        return self.kCurPoolData
    end
    return self.kCurPoolData[strKey]
end

-- 接收到奖池基本信息
function PinballDataManager:SetPoolBaseInfoWithType(kRetData)
    if not (kRetData and kRetData.ePoolType) then
        return
    end
    if not self.kPoolBaseInfoCache then
        self.kPoolBaseInfoCache = {}
    end
    local kBaseInfo = kRetData.kBaseInfo
    self.kPoolBaseInfoCache[kRetData.ePoolType] = kBaseInfo
    if kBaseInfo.dwAccForTenShootNum and (kBaseInfo.dwAccForTenShootNum > 0) then
        self:SetHoodleAccNum(kBaseInfo.dwAccForTenShootNum)  
    end
    -- 特殊处理: 原先设计为每个池的小侠客数量是独立的
    -- 现在是每个池的小侠客数量是一致的, 与服务器约定总是读第一个池(Normal)
    -- 的小侠客数量作为侠客行的当前小侠客数量, 所以当更新dwCurPoolHoodleNum的时候
    -- 总是要设置第一个池小侠客数量
    if kRetData.ePoolType ~= SHLPT_NORMAL 
    and kBaseInfo.dwCurPoolHoodleNum 
    and (kBaseInfo.dwCurPoolHoodleNum > 0) then
        local kExtraCacheBaseInfo = self.kPoolBaseInfoCache[SHLPT_NORMAL]
        if kExtraCacheBaseInfo then
            kExtraCacheBaseInfo.dwCurPoolHoodleNum = kBaseInfo.dwCurPoolHoodleNum
        end
        self.kPoolBaseInfoCache[SHLPT_NORMAL] = kExtraCacheBaseInfo
    end
    local ePoolType = self:GetCurPoolExcelData("PoolType")
    if ePoolType and (ePoolType ~= kRetData.ePoolType) then
        return false
    end
    return true
end

-- 获取奖池基本信息
function PinballDataManager:GetPoolBaseInfoWithType(ePoolType)
    if not (self.kPoolBaseInfoCache and ePoolType) then
        return
    end
    return self.kPoolBaseInfoCache[ePoolType]
end

-- 获取奖池基本信息
function PinballDataManager:GetCurPoolBaseInfo(strKey)
    if not self.kPoolBaseInfoCache then
        return
    end
    local ePoolType = self:GetCurPoolExcelData("PoolType")
    if not ePoolType then
        return
    end
    local kCacheBaseInfo = self.kPoolBaseInfoCache[ePoolType]
    if not (kCacheBaseInfo) then
        return
    end
    if not strKey then
        return kCacheBaseInfo
    end
    return kCacheBaseInfo[strKey]
end

-- 设置奖池基本信息
function PinballDataManager:SetCurPoolBaseInfo(strKey, kValue)
    if not self.kPoolBaseInfoCache then
        return
    end
    local ePoolType = self:GetCurPoolExcelData("PoolType")
    if not ePoolType then
        return
    end
    local kCacheBaseInfo = self.kPoolBaseInfoCache[ePoolType]
    if not (kCacheBaseInfo) then
        return
    end
    kCacheBaseInfo[strKey] = kValue
    self.kPoolBaseInfoCache[ePoolType] = kCacheBaseInfo
end

-- 设置普通弹珠
function PinballDataManager:SetNromalHoodleNum(iNum)
    if not iNum then
        return
    end
    self:SetCurPoolBaseInfo('dwCurPoolHoodleNum', iNum)
end

-- 获取普通弹珠的数量
function PinballDataManager:GetNormalHoodleNum()
    return self:GetCurPoolBaseInfo('dwCurPoolHoodleNum') or 0
end

-- 设置免费十连弹珠
function PinballDataManager:SetFreeHoodleNum(iNum)
    if not iNum then
        return
    end
    self:SetCurPoolBaseInfo('dwCurPoolFreeHoodleNum', iNum)
end

-- 获取免费十连弹珠的数量
function PinballDataManager:GetFreeHoodleNum()
    return self:GetCurPoolBaseInfo('dwCurPoolFreeHoodleNum') or 0
end

-- 设置弹珠累计计数数量
function PinballDataManager:SetHoodleAccNum(iNum)
    if not iNum then
        return
    end
    self.dwAccForTenShootNum = iNum
    -- 设置累计数量的时候, 检查是否达到开始十连抽的标准, 如果达到, 弹框提示用户开启十连抽
    if iNum >= SSD_MIN_OPEN_TEN_SHOOT_HOODLE_NUM then
        self:AskForTurnQuickShoot(iNum)
    end
end

-- 获取弹珠累计计数数量
function PinballDataManager:GetHoodleAccNum()
    return self.dwAccForTenShootNum or 0
end

-- 设置日常免费抽奖弹珠
function PinballDataManager:SetDailyFreeHoodleNum(iNum)
    if not iNum then
        return
    end
    self:SetCurPoolBaseInfo('dwCurPoolDailyFreeHoodleNum', iNum)
end

-- 获取日常免费抽奖弹珠的数量
function PinballDataManager:GetDailyFreeHoodleNum()
    return self:GetCurPoolBaseInfo('dwCurPoolDailyFreeHoodleNum') or 0
end

-- 获取用户当前所有奖池的日常免费抽奖弹珠的弹珠数量
function PinballDataManager:GetUserAllDailyFreeHoodleNum()
    if not (self.kPoolBaseInfoCache and next(self.kPoolBaseInfoCache)) then
        return 0
    end
    local iCount = 0
    for eType, kBaseInfo in pairs(self.kPoolBaseInfoCache) do
        iCount = iCount + (kBaseInfo.dwCurPoolDailyFreeHoodleNum or 0)
    end
    return iCount
end

-- 获取用户当前所有奖池的普通弹珠的弹珠数量
function PinballDataManager:GetUserAllNormalHoodleNum()
    if not (self.kPoolBaseInfoCache and next(self.kPoolBaseInfoCache)) then
        return 0
    end
    -- 统一只取普通池的数量, 其他池的服务器(@岳巍)保证与普通池相同
    local iCount = 0
    for eType, kBaseInfo in pairs(self.kPoolBaseInfoCache) do
        if eType == SHLPT_NORMAL then
            iCount = kBaseInfo.dwCurPoolHoodleNum or 0
            break
        end
    end
    return iCount
end

-- 获取用户当前可用的弹珠数量
function PinballDataManager:GetUserUsableHoodleNum()
    return self:GetNormalHoodleNum() + self:GetDailyFreeHoodleNum()
end

-- 获取侠客行经脉丹的价格
function PinballDataManager:GetUserPaySilver()
    -- 现在小侠客直接是固定的价格 250, 不走商城商品购买的逻辑
    -- 与服务器固定一个价格常量
    return SSD_HOODLE_SILVER_EXCHANGE_NUM or 999
end

-- 记录物品获取列表, 返回奖励记录的位置
-- Record的时候先暂存在一个单独的数组里, 等到小球下落的时候, 再从该数组中取出并存入self.akItemGotThisRoundForShow
function PinballDataManager:RecordGetReward(poolID, kItemTypeData, iCount)
    if not kItemTypeData then
        return 0
    end
    -- 用一个标记记录当前池有产生新的数据记录
    if not self.kNewPinballRecordFlag then
        self.kNewPinballRecordFlag = {}
    end
    self.kNewPinballRecordFlag[poolID] = true
    -- 记录下落中的奖励数据
    if not self.akFallingBallInfos then
        self.akFallingBallInfos = {}
    end
    if not self.akFallingBallInfos[poolID] then
        self.akFallingBallInfos[poolID] = {["uiMaxID"] = 0}
    end
    local uiRecordIndex = self.akFallingBallInfos[poolID].uiMaxID + 1
    self.akFallingBallInfos[poolID].uiMaxID = uiRecordIndex
    self.akFallingBallInfos[poolID][uiRecordIndex] = {
        ["itemTypeData"] = kItemTypeData,
        ["iNum"] = iCount or 0,
        ["IsNew"] = true,
    }
    return uiRecordIndex
end

-- 设置奖励信息掉落落实
-- 这个接口内会将 self.akFallingBallInfos 内对应位置的奖励取出放入到 真正的奖励记录 中
function PinballDataManager:SetRecordGetRewardFall(uiPoolID, uiRecordIndex)
    if (not uiPoolID) or (not uiRecordIndex)
    or (not self.akFallingBallInfos) or (not self.akFallingBallInfos[uiPoolID])
    or (not self.akFallingBallInfos[uiPoolID][uiRecordIndex]) then
        return
    end
    local kInfoToPush = self.akFallingBallInfos[uiPoolID][uiRecordIndex]
    self.akFallingBallInfos[uiPoolID][uiRecordIndex] = nil
    if uiPoolID == 1 then
        if not self.akItemGotThisRoundForShow then
            self.akItemGotThisRoundForShow = {}
        end
        self.akItemGotThisRoundForShow[#self.akItemGotThisRoundForShow + 1] = kInfoToPush
    else
        if not self.mRewardPoolForShow then
            self.mRewardPoolForShow = {}
        end
        if not self.mRewardPoolForShow[uiPoolID] then
            self.mRewardPoolForShow[uiPoolID] = {}
        end
        self.mRewardPoolForShow[uiPoolID][#self.mRewardPoolForShow[uiPoolID] + 1] = kInfoToPush
    end
end

-- 这个接口返回 self.akFallingBallInfos 与 真正的奖励记录 合并的一份奖励记录数据
-- 并且 self.akFallingBallInfos 中的数据总是排在最后方
function PinballDataManager:GetMergedRewardReocrd(uiPoolID)
    if not uiPoolID then
        return
    end
    local akMergedInfos = {}
    -- 插入实际奖励信息
    local kTarPool = {}
    if uiPoolID == 1 then
        kTarPool = self.akItemGotThisRoundForShow or {}
    elseif self.mRewardPoolForShow then
        kTarPool = self.mRewardPoolForShow[uiPoolID] or {}
    end
    for index, kInfo in ipairs(kTarPool) do
        akMergedInfos[#akMergedInfos + 1] = kInfo
    end
    -- 插入FallingInfos
    local kTarFallingInfos = {}
    if self.akFallingBallInfos then
        kTarFallingInfos = self.akFallingBallInfos[uiPoolID] or {}
    end
    for strKey, kInfo in pairs(kTarFallingInfos) do
        if (strKey ~= "uiMaxID") and kInfo and kInfo.itemTypeData then
            akMergedInfos[#akMergedInfos + 1] = kInfo
        end
    end
    return akMergedInfos
end

-- 将已获得的奖励写入到本地记录
function PinballDataManager:WriteItemGotList()
    -- 对所有有数据变动的池进行数据保存
    if not self.kNewPinballRecordFlag then
        return
    end

    for uiPoolID, bNewFlag in pairs(self.kNewPinballRecordFlag) do
        local kTarQueue = self:GetMergedRewardReocrd(uiPoolID)
        -- 只存规定数量个 SERVER_REWARD_MAX_SAVE_NUM
        local iWriteGotItemNum = SERVER_REWARD_MAX_SAVE_NUM
        local kWriteList = {}
    
        local uiSumCount = #kTarQueue
        local uiStartIndex = 1
        if uiSumCount > iWriteGotItemNum then
            uiStartIndex = uiSumCount - iWriteGotItemNum + 1
        end
        for index = uiStartIndex, uiSumCount, 1 do
            local kInfo = kTarQueue[index]
            if (not kInfo) or (iWriteGotItemNum <= 0) then
                break
            end
            if kInfo.itemTypeData and kInfo.itemTypeData.BaseID
            and kInfo.iNum and (kInfo.iNum > 0) then
                kWriteList[#kWriteList + 1] = {
                    ["i"] = kInfo.itemTypeData.BaseID,
                    ["n"] = kInfo.iNum,
                }
                iWriteGotItemNum = iWriteGotItemNum - 1
            end
        end
        self:SetLocalRec(self:GetPoolKey(uiPoolID), kWriteList, true)
    end

    self.kNewPinballRecordFlag = nil

    self:SaveLocalRec()
end

-- 从本地记录读取已获得的奖励
function PinballDataManager:ReadItemGotList()
    local kReadList = self:GetLocalRec("PinballItemGot") or {}
    self.akItemGotThisRoundForShow = {}
    local kDBItem = TableDataManager:GetInstance():GetTable("Item")
    for index, kInfo in ipairs(kReadList) do
        local kItemTypeData = kDBItem[kInfo.i or 0]
        if kItemTypeData then
            local uiNewIndex = #self.akItemGotThisRoundForShow + 1
            if uiNewIndex > SERVER_REWARD_MAX_SAVE_NUM then
                break
            end
            local kPack = {
                ["itemTypeData"] = kItemTypeData,
                ["iNum"] = kInfo.n or 0,
            }
            self.akItemGotThisRoundForShow[uiNewIndex] = kPack
        end
    end

    -- 读取其他池子（除ID为1外的其他池子）
    self.mRewardPoolForShow = {}
    local hoodleList = TableDataManager:GetInstance():GetTable("Hoodle")
    for poolID, hoodle in pairs(hoodleList) do
        if poolID ~= 1 then
            self.mRewardPoolForShow[poolID] = {}
            local rewardItemForShow = self.mRewardPoolForShow[poolID]
            local kReadList = self:GetLocalRec(self:GetPoolKey(poolID)) or {}
            for index, kInfo in pairs(kReadList) do
                local kItemTypeData = kDBItem[kInfo.i or 0]
                if kItemTypeData then
                    local uiNewIndex = #rewardItemForShow + 1
                    if uiNewIndex > SERVER_REWARD_MAX_SAVE_NUM then
                        break
                    end
                    local kPack = {
                        ["itemTypeData"] = kItemTypeData,
                        ["iNum"] = kInfo.n or 0,
                    }
                    rewardItemForShow[uiNewIndex] = kPack
                end
            end
        end
    end

    self.akFallingBallInfos = nil
    -- return self.akItemGotThisRoundForShow
end

-- 获取poolKey
function PinballDataManager:GetPoolKey(poolID)
    if poolID == 1 then
        return 'PinballItemGot'
    end

    return "PinballItemGot_" .. poolID
end

-- 获取侠客行连射配置键
function PinballDataManager:GetQuickShootSettingKey()
    if self.strQuickShootSettingKey then
        return self.strQuickShootSettingKey
    end
    -- 同一个账号在不同的区服的uid是一样的, 所以要区分不同账号的配置, 需要用区+服+uid
    local strZone = tostring(GetConfig("LoginZone"))
	local strServerKey = string.format("LoginServer_%s", tostring(strZone))
    local strServer = tostring(GetConfig(strServerKey))
    local strPlayerID = tostring(PlayerSetDataManager:GetInstance():GetPlayerID())
    self.strQuickShootSettingKey = string.format("%s_%s_%s_PinballQuickShoot", strZone, strServer, strPlayerID)
    return self.strQuickShootSettingKey
end

-- 设置侠客行快速连射(10连抽)
function PinballDataManager:SetQuickShootState(bOn, bToast)
    local strKey = self:GetQuickShootSettingKey() or ""
    local uiOriState = GetConfig(strKey)
    -- 如果原来没有存储任何值, 设置为0
    if not uiOriState then
        uiOriState = 0
        SetConfig(strKey, 0)
    end
    local uiNewState = bOn and 1 or 0
    if (uiOriState == uiNewState) then
        return
    end
    SetConfig(strKey, uiNewState)
    local winPinball = GetUIWindow("PinballGameUI")
    if winPinball then
        winPinball:InitShootBtn()
    end
    if bToast ~= false then
        SystemUICall:GetInstance():Toast("侠客行快速连投已" .. (bOn and "开启" or "关闭"))
    end
end

-- 获取侠客行快速连射开启状态
function PinballDataManager:GetQuickShootState()
    local strKey = self:GetQuickShootSettingKey() or ""
    return (GetConfig(strKey) == 1)
end

-- 用户是否可以使用10连模式
function PinballDataManager:CanUserUseQuickShoot()
    local bTurnOnQuickShoot = (self:GetQuickShootState() == true)
    -- 做一个数量修正, 如果玩家累计数量没有超过规定数量, 关闭连射
    -- TIPS: 理论上外网不可能出现需要修正的情况, 之前加这个是因为内网有的时候会清数据库, 这段先注释掉了
    -- local iSumAccNum = self:GetHoodleAccNum() or 0
    -- if bTurnOnQuickShoot and (iSumAccNum < SSD_MIN_OPEN_TEN_SHOOT_HOODLE_NUM) then
    --     local strKey = self:GetQuickShootSettingKey() or ""
    --     SetConfig(strKey, 0)
    --     bTurnOnQuickShoot = false
    -- end
    local bPoolHasQuickShootMode = self:GetCurPoolExcelData("IsUseTenShootMode") == TBoolean.BOOL_YES
    return bTurnOnQuickShoot and bPoolHasQuickShootMode
end

-- 提示用户开启十连抽模式
function PinballDataManager:AskForTurnQuickShoot(iAccNumn)
    local strKey = self:GetQuickShootSettingKey() or ""
    local iFlag = GetConfig(strKey)
    -- 如果用户选择开启, flag会设为1, 选择以后再说, flag会设为0
    -- 所以flag如果为0或1, 就表示之前已经提示过玩家了, 不用再提示
    if (iFlag == 0) or (iFlag == 1) then
        return
    end
    if not iAccNumn then
        iAccNumn = SSD_MIN_OPEN_TEN_SHOOT_HOODLE_NUM
    end
    self:SetQuickShootState(false)
    local kMsg = {
        ['title'] = "镶金战鼓",
        ['text'] = string.format("您已累积派出%s个小侠客, 是否开启快速连投模式, 一次击鼓派最多可出%s个小侠客?\n可以在[右上角头像-设置]界面中再次选择开启或关闭。", tostring(iAccNumn), tostring(SSD_ONCE_REPEAT_HOODLE_BALL_NUM)),
        ['leftBtnText'] = "以后再说",
        ['rightBtnText'] = "立即开启",
    }
    local funcCallback = function()
        self:SetQuickShootState(true)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, kMsg, funcCallback, {confirm = true, cancel = true}})
end

-- 将弹珠下行的结果推进结果队列
function PinballDataManager:EnqueueHoodleRetData(kRetData)
    if not self.kRetDataQueue then
        self.kRetDataQueue = {}
    end
    self.kRetDataQueue[#self.kRetDataQueue + 1] = kRetData
end

-- 检查结果队列是否为空
function PinballDataManager:IsHoddleRetDataQueueEmpty()
    if not self.kRetDataQueue then
        return true
    end
    return (#self.kRetDataQueue == 0)
end

-- 获取结果队列
function PinballDataManager:GetHoodleRetDataQueue()
    return clone(self.kRetDataQueue)
end

-- 清空结果队列
function PinballDataManager:ClearHoodleRetDataQueue()
    self.kRetDataQueue = nil
end

-- 侠客行本地记录存储相关
local dkJson = require("Base/Json/dkjson")
local strLocalRecName = "PinballLocalRec"
local strLocalRecPostfix = ".txt"
local kPinballLocalRec = nil

-- 获取存储键
function PinballDataManager:GetLocalRecKey(strOriKey)
    if not self.kLocalRecKeyCache then
        self.kLocalRecKeyCache = {}
    end
    if self.kLocalRecKeyCache[strOriKey] then
        return self.kLocalRecKeyCache[strOriKey]
    end
    local strZone = GetConfig("LoginZone")
    if (not strZone) or (strZone == "") then
        derror("Can't gen pinball data local record key: empty zone")
        return
    end
	local strServerKey = string.format("LoginServer_%s", tostring(strZone))
    local strServer = tostring(GetConfig(strServerKey))
    if (not strServer) or (strServer == "") then
        derror("Can't gen pinball data local record key: empty server")
        return
    end
    local uiPlayerID = PlayerSetDataManager:GetInstance():GetPlayerID()
    if (not uiPlayerID) or (uiPlayerID == 0) then
        derror("Can't gen pinball data local record key: invalid player id")
        return
    end
    local strPlayerID = tostring(uiPlayerID)
    self.kLocalRecKeyCache[strOriKey] = string.format("%s_%s_%s_%s", strZone, strServer, strPlayerID, strOriKey)
    return self.kLocalRecKeyCache[strOriKey]
end

-- 获取本地文件存储位置
function PinballDataManager:GetLocalRecStorePath()
    local strAppPath = IS_WINDOWS and DRCSRef.AppDataPath or DRCSRef.PersistentDataPath
    if (not strAppPath) or (not strLocalRecName) then
        return
    end
    local strTransKey = self:GetLocalRecKey(strLocalRecName)
    if (not strTransKey) or (strTransKey == "") then
        return
    end
    return strAppPath .. '/' .. strTransKey .. strLocalRecPostfix
end

-- 获取本地存储值
function PinballDataManager:GetLocalRec(strKey)
    if not kPinballLocalRec then
        local strDataPath = self:GetLocalRecStorePath()
        if (not strDataPath) or (strDataPath == "") then
            return
        end
        local str = DRCSRef.GameConfig:GetConfig(strDataPath)
        kPinballLocalRec = dkJson.decode(str)
    end
    if not kPinballLocalRec then
        return
    end
    local strTransKey = self:GetLocalRecKey(strKey)
    if (not strTransKey) or (strTransKey == "") then
        return
    end
    return kPinballLocalRec[strTransKey]
end

-- 保存本地存储值
function PinballDataManager:SaveLocalRec(bImmediately)
    if not kPinballLocalRec then
        return
    end
    local strDataPath = self:GetLocalRecStorePath()
    if (not strDataPath) or (strDataPath == "") then
        return
    end
    
    if bImmediately then
        local strData = dkJson.encode(kPinballLocalRec) 
        DRCSRef.GameConfig:SaveConfig(strData, strDataPath)
    else
        -- WARNING: 用协程妥协存储时间，1s后进行
        CS_Coroutine.start(function()
            local strData = dkJson.encode(kPinballLocalRec) 
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5));
            DRCSRef.GameConfig:SaveConfig(strData, strDataPath)
        end)
    end
end

-- 设置本地存储值
function PinballDataManager:SetLocalRec(strKey, kValue)
    if not kPinballLocalRec then
        kPinballLocalRec = {}
    end

    local strTransKey = self:GetLocalRecKey(strKey)
    if not strTransKey then
        return
    end
    kPinballLocalRec[strTransKey] = kValue
end

-- 清空本地存储值
function PinballDataManager:ClearLocalRec(strKey)
    if strKey ~= nil then
        local strTransKey = self:GetLocalRecKey(strKey)
        if (not strTransKey) or (strTransKey == "") then
            return
        end
        kPinballLocalRec[strTransKey] = nil
    else
        kPinballLocalRec = {}
    end
    self:SaveLocalRec()
end

--------------------------[侠客行 全服玩法]--------------------------------------

-- 全服玩法: 通过活动静态数据初始化活动数据
function PinballDataManager:SetServerPlayActivityData(iHoodlePublicBaseID)
    -- 避免重复设置
    if self.iCurSetServerPlayActivityID == iHoodlePublicBaseID then
        return true
    end
    if not iHoodlePublicBaseID then
        return false
    end
    -- 记录当前已经设置的活动id
    self.iCurSetServerPlayActivityID = iHoodlePublicBaseID
    -- 更新活动的时候, 刷新一下积分奖励栏
    LuaEventDispatcher:dispatchEvent("UPDATE_HOODLE_SERVER_PLAY_SCORE")
    return true
end

-- 全服玩法: 缓存奖池数据
function PinballDataManager:CacheRewardPoolData(kOriDatas, uiCurChooseRewardItem)
    local kRewardsData = {['SumNumLookUp'] = {}}
    local kRewardRemainNum = {}
    self.kCurChooseReward = nil
    if (not kOriDatas) or (not kOriDatas[0]) then
        self.kCacheRewardsPoolData = kRewardsData
        self.kRewardRemainNum = kRewardRemainNum
        return
    end
    for index = 0, #kOriDatas do
        local kData = kOriDatas[index]
        local uiItemBaseID = kData.uiItemID or 0
        local iNum = kData.uiTotalNum or 0
        local bIsTop = (kData.bTopReward == 1)
        kRewardsData[#kRewardsData + 1] = {
            ['iItemBaseID'] = uiItemBaseID,
            ['iLimit'] = iNum,
            ['bIsTop'] = bIsTop,
        }
        kRewardsData.SumNumLookUp[uiItemBaseID] = iNum

        -- 设置奖池剩余数量
        local uiRemainNum = iNum - (kData.uiCurNum or 0)
        if uiRemainNum < 0 then
            uiRemainNum = 0
        end
        kRewardRemainNum[uiItemBaseID] = uiRemainNum

        -- 设置当前选中物品
        if uiItemBaseID == uiCurChooseRewardItem then
            self.kCurChooseReward = {['ItemID'] = uiItemBaseID, ['IsTopReward'] = bIsTop}
        end
    end
    self.kCacheRewardsPoolData = kRewardsData
    self.kRewardRemainNum = kRewardRemainNum
end

-- 全服玩法: 缓存奖励队列的数据
function PinballDataManager:CacheRewardsQueueData(kOriData)
    -- 设置当前队列
    local aiItems = {}
    if kOriData and kOriData[0] then
        for index = 0, #kOriData do
            aiItems[#aiItems + 1] =  kOriData[index] or 0
        end
    end
    self.KCurQueue = aiItems
end

-- 全服玩法: 缓存积分兑换奖励数据
function PinballDataManager:CachePointExchangeReward(kOriData)
    local bNeedDropEvent = false
    if self.kCurPointExchangeReward and self.kCurPointExchangeReward[0] and kOriData then
        -- 逐一比较, 若有数据差异, 则需要执行一次ui的刷新
        for index = 0, #self.kCurPointExchangeReward do
            if (not kOriData[index])
            or (not self.kCurPointExchangeReward[index])
            or (self.kCurPointExchangeReward[index].uiItemId ~= kOriData[index].uiItemId) then
                bNeedDropEvent = true
                break
            end
        end
    end
    self.kCurPointExchangeReward = kOriData
    if bNeedDropEvent then
        LuaEventDispatcher:dispatchEvent("UPDATE_HOODLE_SERVER_PLAY_SCORE")
    end
end

-- 全服玩法: 缓存服务器下发的活动时间范围
function PinballDataManager:CacheServerPlayActivityTime(uiBeginTime, uiEndTime)
    self.uiServerPlayBeginTime = uiBeginTime
    self.uiServerPlayEndTime = uiEndTime
end

-- 全服玩法: 获取服务器下发的活动时间范围
function PinballDataManager:GetServerPlayActivityTime()
    return (self.uiServerPlayBeginTime or 0), (self.uiServerPlayEndTime or 0)
end

-- 全服玩法: 缓存服务器下发的活动图路径
function PinballDataManager:CacheServerPlayActivityAdImgPath(strResourcePath)
    self.strResourcePath = strResourcePath
end

-- 全服玩法: 获取服务器下发的活动图路径
function PinballDataManager:GetServerPlayActivityAdImgPath()
    return self.strResourcePath or ""
end

-- 全服玩法: 获取积分兑换奖励数据
function PinballDataManager:GetPointExchangeReward()
    if not self.kCurPointExchangeReward then
        return
    end
    if self.kCurPointExchangeReward[0] then
        self.kCurPointExchangeReward[#self.kCurPointExchangeReward + 1] = self.kCurPointExchangeReward[0]
        self.kCurPointExchangeReward[0] = nil
    end
    table.sort(self.kCurPointExchangeReward, function(a, b)
        return (a.uiPrice or 0) < (b.uiPrice or 0)
    end)
    local aiExchangeItem = {}
    local aiExchangePrice = {}
    for index, kData in ipairs(self.kCurPointExchangeReward) do
        aiExchangeItem[#aiExchangeItem + 1] = kData.uiItemId or 0
        aiExchangePrice[#aiExchangePrice + 1] = kData.uiPrice or 0
    end
    return aiExchangeItem, aiExchangePrice
end

-- 全服玩法: 获取表奖池
function PinballDataManager:GetServerPlayRewardPool()
    return self.kCacheRewardsPoolData
end

-- 全服玩法: 获取奖励余量
function PinballDataManager:GetServerPlayRewardRemain(iItemBaseID)
    if (not self.kRewardRemainNum) or (not iItemBaseID) or (iItemBaseID == 0) then
        return 0
    end
    return self.kRewardRemainNum[iItemBaseID] or 0
end

-- 全服玩法: 获取即将开抢队列
function PinballDataManager:GetServerPlayNextRewardQueue()
    return self.KCurQueue
end

-- 全服玩法: 获取当前选中的奖励物品
function PinballDataManager:GetCurChooseRewardItem()
    if not self.kCurChooseReward then
        return
    end
    return self.kCurChooseReward.ItemID, self.kCurChooseReward.IsTopReward
end

-- 全服玩法: 设置当前进度
function PinballDataManager:SetServerPlayProgress(iCurValue, iMaxValue)
    if (not iCurValue) or (iCurValue < 0) then
        dwarning("[PinballDataManager:SetServerPlayProgress] invalid current value")
        iCurValue = 0
    end
    if (not iMaxValue) or (iMaxValue < 0) then
        dwarning("[PinballDataManager:SetServerPlayProgress] invalid max value")
        iMaxValue = 1
    end
    -- 进度值 0-1
    local fOldProgress = self.fCurProgress or 0
    self.fCurProgress = iCurValue / iMaxValue
    -- 进度从大变小的时候清除一下贡献排行
    if fOldProgress > self.fCurProgress then
        LuaEventDispatcher:dispatchEvent("PINBALL_SERVERPLAY_DEVOTED_MSG_UPDATE", "暂无信息")
    end
end

-- 全服玩法: 获取当前进度
function PinballDataManager:GetServerPlayProgress()
    return self.fCurProgress or 0
end

-- 全服玩法: 设置当前进度推进者
function PinballDataManager:SetServerPlayPushers(akPlayers, iNum)
    if not (akPlayers and iNum) then
        return
    end
    local kPlayerQueue = self.akProgressPusher or {['check'] = {}}
    local kData = nil
    local kPlayerSetMgr = PlayerSetDataManager:GetInstance()
    for index = 0, iNum - 1 do
        kData = akPlayers[index]
        -- 排除掉自己
        if kData and kData.defPlayerId and kData.uiPrecessValue and (kData.defPlayerId ~= kPlayerSetMgr:GetPlayerID()) then
            if not kPlayerQueue.check[kData.defPlayerId] then
                kPlayerQueue.check[kData.defPlayerId] = {}
            end
            if not kPlayerQueue.check[kData.defPlayerId][kData.uiPrecessValue] then
                kPlayerQueue.check[kData.defPlayerId][kData.uiPrecessValue] = true
                kPlayerQueue[#kPlayerQueue + 1] = kData
            end
        end
    end
    self.akProgressPusher = kPlayerQueue
end

-- 全服玩法: 获取下一个进度推进者
function PinballDataManager:GetNextServerPlayPushers()
    if not self.akProgressPusher then
        return
    end
    if not self.iPusherIndex then
        self.iPusherIndex = 0
    end
    if self.iPusherIndex >= #self.akProgressPusher then
        return
    end
    self.iPusherIndex = self.iPusherIndex + 1
    return self.akProgressPusher[self.iPusherIndex]
end

-- 全服玩法: 清空进度推进者数据
function PinballDataManager:ClearServerPlayPushers()
    self.akProgressPusher = nil
    self.iPusherIndex = nil
end

-- 全服玩法: 设置贡献排名玩家
function PinballDataManager:SetServerPlayDevotedPlayers(akPlayers, iNum, uiTotal)
    self:ClearServerPlayDevotedPlayers()
    if (not akPlayers) or (not next(akPlayers)) 
    or (not iNum) or (iNum <= 0) 
    or (not uiTotal) or (uiTotal == 0) then
        return
    end
    -- c arr -> lua arr
    if akPlayers[0] then
        akPlayers[#akPlayers + 1] = akPlayers[0]
        akPlayers[0] = nil
    end
    -- sort by devot
    table.sort(akPlayers, function(a, b)
        local uiDevoteA = a.uiPrecessValue or 0
        local uiDevoteB = b.uiPrecessValue or 0
        if uiDevoteA == uiDevoteB then
            return (a.defPlayerId or 0) > (b.defPlayerId or 0)
        else
            return uiDevoteA > uiDevoteB
        end
    end)
    -- gen string
    local strMsg = ""
    for index, kPlayer in ipairs(akPlayers) do
        strMsg = strMsg .. ((index > 1) and "\n" or "") .. string.format("%d  玩家 %-12s    %5.2f%%", index, kPlayer.acPlayerName or "", (kPlayer.uiPrecessValue or 0) / uiTotal * 100)
    end
    self.strDevotedPlayersMsg = strMsg
    LuaEventDispatcher:dispatchEvent("PINBALL_SERVERPLAY_DEVOTED_MSG_UPDATE", strMsg)
end

-- 全服玩法, 获取贡献排名玩家信息
function PinballDataManager:GetServerPlayDevotedPlayersMsg()
    if (not self.strDevotedPlayersMsg) or (self.strDevotedPlayersMsg == "") then
        return "暂无信息"
    end
    return self.strDevotedPlayersMsg
end

-- 全服玩法, 清空贡献者信息
function PinballDataManager:ClearServerPlayDevotedPlayers()
    self.strDevotedPlayersMsg = nil
end

-- 全服玩法: 请求全服活动数据
function PinballDataManager:RequestServerPlayData()
    SendQueryHoodlePublicInfo()
end

--  全服玩法: 请求夺宝记录数据
function PinballDataManager:RequestServerPlayRecord(iPage)
    SendQueryHoodlePublicRecord(iPage)
end

-- 全服玩法: 设置积分兑换信息
function PinballDataManager:SetExchangeServerRewardInfo(kCanExchange, kItemID2Index)
    if not (kCanExchange and kItemID2Index) then
        return
    end
    self.kServerRewardCanExchange = kCanExchange
    self.kServerRewardItemID2Index = kItemID2Index
end

-- 全服玩法: 获取积分兑换奖励索引映射
function PinballDataManager:GetExchangeServerRewardIndexInfo()
    return self.kServerRewardItemID2Index
end

-- 全服玩法: 清除积分兑换奖励索引映射
function PinballDataManager:ClearExchangeServerRewardIndexInfo()
    self.kServerRewardItemID2Index = {}
end

-- 全服玩法: 检查是否可以兑换积分奖励
function PinballDataManager:CanExchangeServerReward(uiItemID)
    if not self.kServerRewardCanExchange then
        return false
    end
    if (not uiItemID) or (uiItemID == 0) then
        return false
    end
    return (self.kServerRewardCanExchange[uiItemID] == true)
end

-- 全服玩法: 请求兑换积分奖励
function PinballDataManager:RequestExchangeServerReward(uiItemBaseID)
    if not self.kServerRewardItemID2Index then
        return
    end
    if (not uiItemBaseID) or (uiItemBaseID == 0) then
        return 
    end
    local iIndex = self.kServerRewardItemID2Index[uiItemBaseID] or -1
    if iIndex == -1 then
        return
    end
    SendBuyHoodleShopItem(iIndex, uiItemBaseID)
end

-- 全服玩法: 分发数据更新事件
function PinballDataManager:DispatchServerPlayUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_HOODLE_SERVER_PLAY_DATA")
end

-- 全服玩法: 分发获奖事件
-- function PinballDataManager:DispatchServerPlayGetRewardEvent()
--     LuaEventDispatcher:dispatchEvent("UPDATE_HOODLE_SERVER_PLAY_GET_REWARD")
-- end

-- 个人奖池
function PinballDataManager:SetPrivacyPool(data)
    data = data['kPrivacyInfo'] or {}
    
    self.mPrivacyPoolData = {
        CurID = data['dwCurHoodlePrivacyID'] or 0,
        LastNormalNum = data['dwTotalNormalNum'] or 0,
        BossList = data['akChivalrousInfo'] or {},
        ResetTimes = data['dwCurResetNum'] or 0,
        EndTime = data['dwEndTimeStamp'] or 0,
        IsReset = data['bResetReFresh'] == 1
    }

    LuaEventDispatcher:dispatchEvent("UPDATE_HOODLE_PRIVACY_POOL_DATA")
end

function PinballDataManager:ChangeNextPrivacyPool()
    if self.mNextPrivacyPoolData  then
        self.mPrivacyPoolData = self.mNextPrivacyPoolData
        self.mNextPrivacyPoolData = nil
    end
end

function PinballDataManager:GetPrivacyPool()
    return self.mPrivacyPoolData
end