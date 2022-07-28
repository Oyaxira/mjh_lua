PinballPool1 = class("PinballPool1", BaseWindow)

local ItemIconUI = require "UI/ItemUI/ItemIconUI"

-- BOSS掉落时间
local DURATION_BOSS = 0.6
-- 五大将掉落时间
local DURATION_LEADER = 0.8
-- 白衣精英掉落时间
local DURATION_ENEMY = 1
-- BOSS掉落延迟
local DELAY_BOSS = 0.6
-- 五大将掉落延迟
local DELAY_LEADER = 0.3
-- 掉落固定Y值（相对）
local TOP = 170
-- 牛肉丸掉落在地上的缩放X
local BOUNCE_SCALE_X = 1.2
-- 牛肉丸掉落在地上的缩放Y
local BOUNCE_SCALE_Y = 0.85
-- 牛肉丸反弹到常规缩放时间
local DURANTION_BOUNCE = 0.12

local RoleState = {
    -- 已经进入左边的池子
    InRight = 1,
    -- 正在进入左边的池子
    InRightPedding = 2
}

function PinballPool1:ctor(obj)
    self:SetGameObject(obj)

    self.mBossList = {}
    local groupBoss = self:FindChild(self._gameObject, "GroupBoss")
    BoxHelper.ForeachNode(
        groupBoss,
        "Boss%d",
        function(index, root)
            self.mBossList[index] = {
                Root = root,
                Item = self:FindChild(root, "PinBallIcon/Icon"),
                Role = self:FindChild(root, "ef_eba_idle"),
                MatIdle = (self:FindChildComponent(root, "ef_eba_idle", "Renderer") or {}).material,
                Die = self:FindChild(root, "Die"),
                Flag = self:FindChild(root, "Flag"),
                InitPosY = root.transform.localPosition.y
            }
        end
    )

    self.mEnemyList = {}
    local groupEnemy = self:FindChild(self._gameObject, "GroupEnemy")
    BoxHelper.ForeachNode(
        groupEnemy,
        "Enemy%d",
        function(index, root)
            self.mEnemyList[index] = {
                Root = root,
                MatIdle = (self:FindChildComponent(root, "ef_eba_idle", "Renderer") or {}).material,
                InitPosX = root.transform.localPosition.x,
                InitPosY = root.transform.localPosition.y
            }
        end
    )

    self.mLabLastNum = self:FindChildComponent(self._gameObject, "LabLastNum", "Text")
    self.mLabTime = self:FindChildComponent(self._gameObject, "LabTime", "Text")
    self.mLabRound = self:FindChildComponent(self._gameObject, "LabRound", "Text")

    self:AddEventListener(
        "UPDATE_HOODLE_PRIVACY_POOL_DATA",
        function()
            self:OnUpdatePoolData()
        end
    )

    -- self:AddButtonClickListener(
    --     self:FindChildComponent(self._gameObject, "BtnRefresh", "Button"),
    --     function()
    --         self:OnClickRefresh()
    --     end
    -- )

    self.mImgBG = self:FindChildComponent(self._gameObject, "ImgBG", "Image")
    self:AddButtonClickListener(
        self:FindChildComponent(self._gameObject, "ImgBG/BtnTip", "Button"),
        function()
            self:OnClickTip()
        end
    )

    self.ItemIconUIInst = ItemIconUI.new()
    self.mAniCount = 0
end

function PinballPool1:OnEnable()
    self.mAniCount = 0
    self:SetRefreshFlag()
end

function PinballPool1:OnDisable()
    DRCSRef.DOTween.Kill(self.__cname)
end

function PinballPool1:SetRefreshFlag()
    self.mRefrehFlag = true
end

function PinballPool1:Refresh(reset --[[=false]])
    if self.mAniCount > 0 then
        return
    end

    self.mRefrehFlag = false

    local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    local poolTable = GetTableData("HoodlePrivacy", poolData["CurID"] or 0) or {}

    -- 切换广告图
    self:SetSpriteAsync(poolTable["BG"] or "", self.mImgBG)

    -- 获取幸运柱存在的单位
    local privacyTypeMap = {}
    local wnd = GetUIWindow("PinballGameUI")
    if wnd then
        -- TODO: 垃圾代码，hack方法不好
        local akLuckyNodeInfoSquence = wnd.akLuckyNodeInfoSquence or {}
        for _, queue in pairs(akLuckyNodeInfoSquence) do
            local firstPrivacyType
            for index, info in pairs(queue) do
                if info and info.privacyType then
                    if not firstPrivacyType then
                        firstPrivacyType = info.privacyType
                        privacyTypeMap[info.privacyType] = RoleState.InRight
                    end

                    if info.privacyType ~= firstPrivacyType then
                        privacyTypeMap[info.privacyType] = RoleState.InRightPedding
                    end
                end
            end
        end
    end

    DRCSRef.DOTween.Kill(self.__cname)
    local bossList = poolData["BossList"] or {}
    for index, boss in pairs(self.mBossList) do
        -- 枚举从2开始
        local privacyType = index + 1
        local data = bossList[privacyType]
        if data and data["uiItemID"] and data["uiItemID"] > 0 then
            -- 刷新状态
            local num = data["uiItemNum"] or 0
            boss.Die:SetActive(num == 0 and (not privacyTypeMap[privacyType]))
            boss.Flag:SetActive(num == 0 and (privacyTypeMap[privacyType] == RoleState.InRight))
            boss.Role.gameObject:SetActive(num > 0 or (privacyTypeMap[privacyType] == RoleState.InRightPedding))

            -- 刷新人物
            local roleConfig = GetTableData("HoodleRole", (5 << 0 | privacyType << 16)) or GetTableData("HoodleRole", 1)

            if roleConfig and boss.MatIdle then
                boss.MatIdle.mainTexture = LoadPrefab(roleConfig["IdlePath"])
            end

            -- 刷新物品
            local itemID = data["uiItemID"] or 0
            local itemData = GetTableData("Item", itemID)
            if itemData then
                boss.Item:SetActive(true)
                self.ItemIconUIInst:UpdateUIWithItemTypeData(boss.Item, itemData)
                self.ItemIconUIInst:HideItemNum(boss.Item)
            else
                boss.Item:SetActive(false)
            end

            boss.Root:SetActive(true)

            local trans = boss.Root.transform
            trans.localPosition = DRCSRef.Vec3(trans.localPosition.x, boss.InitPosY, 0)

            -- 刷新动画
            if reset then
                if privacyType == SHPCT_CHIVALROUS_6 then
                    -- BOSS动画
                    self:pPlayRefreshAni(trans, boss.Item, boss.InitPosY, DELAY_BOSS, DURATION_BOSS)
                else
                    -- 五大将动画
                    self:pPlayRefreshAni(trans, boss.Item, boss.InitPosY, DELAY_LEADER, DURATION_LEADER)
                end
            end
        else
            boss.Root:SetActive(false)
        end
    end

    local lastNormalNum = poolData["LastNormalNum"] or 0
    for index, enemy in pairs(self.mEnemyList) do
        if index <= lastNormalNum then
            -- 刷新人物
            local roleConfig =
                GetTableData("HoodleRole", (5 << 0 | SHPCT_NORMAL << 16)) or GetTableData("HoodleRole", 1)
            if roleConfig and enemy.MatIdle then
                enemy.MatIdle.mainTexture = LoadPrefab(roleConfig["IdlePath"])
            end

            enemy.Root:SetActive(true)

            local trans = enemy.Root.transform
            trans.localPosition = DRCSRef.Vec3(trans.localPosition.x, enemy.InitPosY, 0)

            -- 刷新动画
            if reset then
                self:pPlayRefreshAni(trans, nil, enemy.InitPosY, 0, DURATION_ENEMY)
            end
        else
            enemy.Root:SetActive(false)
        end
    end

    self:pRefreshLastNum()
    self:pRefreshRound()
end

function PinballPool1:OnPinballTouchLuckyNode(index, oldInfo, newInfo, reseting)
    -- 替换后角色
    local privacyType = newInfo.privacyType

    local wnd = GetUIWindow("PinballGameUI")
    if not wnd then
        return
    end

    -- 个人奖池切池，左边的动画
    if oldInfo.reset then
        self:Refresh(true)
        wnd:ResetPoolSuccess()
    elseif not reseting then
        self:SetRefreshFlag()
    end

    -- TODO: 这写法很垃圾~~~属于hack写法
    local pickItemData = wnd.pickItemData
    if not pickItemData then
        return
    end

    local targetPos = ((pickItemData["LuckyNodes"] or {})[tostring(index)] or {}).oriPos
    if not targetPos then
        return
    end

    if privacyType == SHPCT_NORMAL then
        local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
        local lastNum = poolData["LastNormalNum"] or 0
        local total = #self.mEnemyList
        -- 白衣精英
        if lastNum >= total then
            local enemyIndex = nil
            for key, obj in pairs(pickItemData["PinballPool1_FixedEnemy"]) do
                if not obj.gameObject.activeSelf then
                    enemyIndex = tonumber(key)
                    break
                end
            end

            if enemyIndex then
                local matIdle = ((pickItemData["PinballPool1_FixedEnemy"] or {})[tostring(enemyIndex)] or {})["MatIdle"]
                if matIdle then
                    local roleConfig =
                        GetTableData("HoodleRole", (5 << 0 | SHPCT_NORMAL << 16)) or GetTableData("HoodleRole", 1)
                    matIdle.mainTexture = LoadPrefab(roleConfig["IdlePath"])
                end
                wnd:DynamicPickItemAnim("PinballPool1_FixedEnemy", enemyIndex, nil, nil, nil, 0.6, targetPos)
            end
        else
            local matIdle = ((pickItemData["PinballPool1_Enemy"] or {})[tostring(lastNum + 1)] or {})["MatIdle"]
            if matIdle then
                local roleConfig =
                    GetTableData("HoodleRole", (5 << 0 | SHPCT_NORMAL << 16)) or GetTableData("HoodleRole", 1)
                matIdle.mainTexture = LoadPrefab(roleConfig["IdlePath"])
            end
            wnd:DynamicPickItemAnim("PinballPool1_Enemy", lastNum + 1, nil, nil, nil, 0.6, targetPos)
        end
    elseif privacyType >= SHPCT_CHIVALROUS_1 and privacyType <= SHPCT_CHIVALROUS_6 then
        -- BOSS和五大将
        local matIdle = ((pickItemData["PinballPool1_Boss"] or {})[tostring(privacyType - 1)] or {})["MatIdle"]
        if matIdle then
            local roleConfig = GetTableData("HoodleRole", (5 << 0 | privacyType << 16)) or GetTableData("HoodleRole", 1)
            matIdle.mainTexture = LoadPrefab(roleConfig["IdlePath"])
        end
        wnd:DynamicPickItemAnim("PinballPool1_Boss", privacyType - 1, nil, nil, nil, 0.6, targetPos)
    end
end

function PinballPool1:OnUpdatePoolData()
    -- local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    -- -- 奖池重置得等弹珠都掉落了才能表现
    -- if poolData.IsReset then
    --     PinballDataManager:GetInstance():ChangeNextPrivacyPool()
    -- end
end

function PinballPool1:OnClickRefresh()
    local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}

    local bossList = poolData["BossList"] or {}
    local boss = bossList[SHPCT_CHIVALROUS_6]

    local num = boss and boss["uiItemNum"] or 0
    if num > 0 then
        SystemUICall:GetInstance():Toast("打败白衣魔君后，允许重置奖池", false, nil, "PINBALL")
    else
        OpenWindowImmediately(
            "GeneralBoxUI",
            {
                GeneralBoxType.COMMON_TIP,
                "是否将白衣教大厅重置到初始状态？",
                function()
                    SystemUICall:GetInstance():Toast("功能待开发", false, nil, "PINBALL")
                end
            }
        )
    end
end

function PinballPool1:Update()
    local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    local uiEndTimeStamp = poolData["EndTime"] or 0
    local uiCurTimeStamp = GetCurServerTimeStamp()
    local iDelta = uiEndTimeStamp - uiCurTimeStamp
    if iDelta < 0 then
        self.mLabTime.text = "即将切换至下一期"
        return
    end
    local kTimers = {}
    local iDaySec = 24 * 3600
    if iDelta > iDaySec then
        local iDay = math.floor(iDelta / iDaySec)
        iDelta = iDelta - iDaySec * iDay
        kTimers[#kTimers + 1] = string.format("%d天", iDay)
    end
    if iDelta > 3600 then
        local iHour = math.floor(iDelta / 3600)
        iDelta = iDelta - 3600 * iHour
        kTimers[#kTimers + 1] = string.format("%d时", iHour)
    end
    if iDelta > 60 then
        local iMin = math.floor(iDelta / 60)
        iDelta = iDelta - 60 * iMin
        kTimers[#kTimers + 1] = string.format("%d分", iMin)
    end
    if iDelta > 0 then
        kTimers[#kTimers + 1] = string.format("%d秒", iDelta)
    end
    self.mLabTime.text = string.format("%s%s后到期", kTimers[1] or "", kTimers[2] or "")

    if self.mRefrehFlag then
        self:Refresh()
    end
end

function PinballPool1:OnDestroy()
    self.ItemIconUIInst:Close()
end

-- 弹珠全部都掉落
function PinballPool1:OnPinballShootEnd()
    -- local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    -- -- 奖池重置了
    -- if poolData.IsReset then
    --     self:ChangeNextPrivacyPool()
    -- end
end

function PinballPool1:OnClickTip()
    local rateTip = {
        ["kind"] = "wide",
        ["title"] = "定期刷新规则",
        ["titlecolor"] = DRCSRef.Color.white,
        ["content"] = GetLanguageByID(590)
    }
    OpenWindowImmediately("TipsPopUI", rateTip)
end

function PinballPool1:pRefreshLastNum()
    local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    local num = poolData["LastNormalNum"] or 0
    self.mLabLastNum.text = string.format("剩余白衣教精英: %d", num)
end

function PinballPool1:pRefreshRound()
    local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    local num = poolData["ResetTimes"] or 0
    self.mLabRound.text = string.format("本期已剿灭数: %d", num)
end

function PinballPool1:pPlayRefreshAni(trans, item, initPosY, delay, duration)
    trans.localPosition = DRCSRef.Vec3(trans.localPosition.x, TOP, 0)
    trans.localScale = DRCSRef.Vec3Zero
    if item then
        item:SetActive(false)
    end

    -- 下牛肉丸动画
    self.mAniCount = self.mAniCount + 1
    trans:DOKill()
    local sequence = DRCSRef.DOTween.Sequence()
    sequence:Append(trans:DOScale(1, 0):SetDelay(delay))
    sequence:Append(trans:DOLocalMoveY(initPosY, duration):SetEase(DRCSRef.Ease.InQuart))
    sequence:Append(
        trans:DOScale(DRCSRef.Vec3(BOUNCE_SCALE_X, BOUNCE_SCALE_Y, 1), DURANTION_BOUNCE):SetEase(DRCSRef.Ease.OutQuad)
    )
    sequence:Append(trans:DOScale(1, DURANTION_BOUNCE):SetEase(DRCSRef.Ease.InQuad))
    sequence:OnComplete(
        function()
            if item then
                item:SetActive(true)
            end

            self.mAniCount = self.mAniCount - 1
        end
    )
    -- sequence.PrependInterval(delay)
    sequence:SetId(self.__cname)
    sequence:Play()
end

return PinballPool1
