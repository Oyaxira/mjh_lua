PinballGameUI = class("PinballGameUI",BaseWindow)
local SpineRoleUI = require 'UI/Role/SpineRoleUI'

local GameSound = {
    ['ShootNormal'] = 4053,
    ['ShootFree'] = 4054,
    ['HitEB'] = 4055,
    ['EnterSlot'] = 4056,
    ['Progress'] = 4057,
}

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local PinballServerPlayUI = require 'UI/TownUI/PinballServerPlayUI'
local PinballPool1 = require 'UI/TownUI/PinballPool1'

local TopRewardTitle = {
    ['Role'] = "Effect/Ui_eff/ef_bosscoming/tex_jsziti",
    ['Pet'] = "Effect/Ui_eff/ef_bosscoming/tex_cwziti",
    ['Item'] = "Effect/Ui_eff/ef_bosscoming/tex_wpziti",
}

function PinballGameUI:ctor()
    self.ItemIconUIInst = ItemIconUI.new()
    self.kSpineRoleUIMgr = SpineRoleUI.new()
    self.mCurPoolID = nil
end

function PinballGameUI:Create()
    local obj = LoadPrefabAndInit("PinBallGameUI/PinballGameUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function PinballGameUI:Init()
    -- 其他数据
    self.bInitFinish = false  -- 是否初始化结束
    self.iMaxRewardEndNum = 0  -- 奖励草个数
    self.i10ShootRewardIndex = 0  -- 10连奖励槽位索引
    self.akLuckyNodeInfoSquence = nil  -- 幸运柱奖励信息的队列
    self.akEndSlotInfoSquence = nil  -- 幸运柱奖励信息的队列
    self.fShootPerTime = 200  -- 10连奖励发射弹珠的时间间隔
    self.iSootingBallCount = 0  -- 奖池切换tab是否禁止点击

    self.objIconRewardBox = nil  -- 终点奖励的物品图标节点
    self.comEffectRewardBox = nil  -- 终点奖励槽粒子特效组件
    self.scrollBar10ShootReward = nil  -- 10连奖励槽
    self.akLuckyNodes = nil  -- 幸运柱子节点

    self.kPinballMgr = PinballDataManager:GetInstance()

    -- 游戏面板
    self.objLoading = self:FindChild(self._gameObject, "Loading")
    self.objGamePanel = self:FindChild(self._gameObject, "GamePanel")
    self.objServerPlay = self:FindChild(self.objGamePanel, "ServerPlay")
    self.PinballServerPlayInst = PinballServerPlayUI.new(self.objServerPlay)

    local objPinballPool1 = self:FindChild(self.objGamePanel, "PinballPool1")
    self.mPinballPool1 = PinballPool1.new(objPinballPool1)
    -- tab栏
    self.objTabs = self:FindChild(self.objGamePanel, "Tabs")
    self.objTabTemp = self:FindChild(self.objGamePanel, "ToggleTemp")
    -- 弹珠台
    self.objPinballBoard = self:FindChild(self._gameObject, "Board")
    self.comPinballPlayer = self.objPinballBoard:GetComponent("PinballPlayer")
    self.comPinballPlayer:SetOnInitEndLuaFunc(function()
        self:OnPinballPlayerInitEnd()
    end)
    self.comPinballPlayer:SetOnTouchEndLuaFunc(function(index, strBallID)
        self:OnPinballTouchEnd(index, strBallID)
    end)
    self.comPinballPlayer:SetOnTouchLuckyNodeLuaFunc(function(index, strBallID)
        self:OnPinballTouchLuckyNode(index, strBallID)
    end)
    self.comPinballPlayer:SetOnShootSucLuaFunc(function()
        self:OnPinballShootSuccessfully()
    end)
    -- 弹珠台特效
    self.objBoardEffect = self:FindChild(self.objPinballBoard, "BoardEffect")
    self.objBoardEffect:SetActive(false)
    -- 弹珠台终点奖励节点
    self.objRewardBox = self:FindChild(self.objPinballBoard, "Boxes")
    self.objRewardBox:SetActive(false)
    self:InitRewardBoxes()
    -- 获取幸运柱
    self:InitLuckyNodes()
    -- 最近获得
    self.objRecentGot = self:FindChild(self.objGamePanel, "GotMsg")
    self.objRecentGot:SetActive(false)
    self.objRecentGotEffect = self:FindChild(self.objRecentGot, "Effect")
    self.eRank2RecentGotEffect = self:InitRecentGotEffect(self.objRecentGotEffect)
    self.objRecentGotNewSign = self:FindChild(self.objRecentGot, "NewSign")
    self.objRecentGotNewSign:SetActive(false)
    self.objRecentGotIcon = self:FindChild(self.objRecentGot, "Icon")
    self.btnRecentGotViewAll = self:FindChildComponent(self.objRecentGot, "ViewAll", DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnRecentGotViewAll, function()
        self:OnClickRecentGotViewAll()
        if self.windowBarInst then
            self.windowBarInst:SetBackBtnState(false)
        end
    end)
    self.btnRecentGotViewAll.interactable = true
    -- 初始化获得物品动画图标
    self.objAnimIcons = self:FindChild(self.objRecentGot, "AnimIcons")
    self:InitAnimIcons()
    -- 初始化奖励全览面板
    self.objViewAll = self:FindChild(self._gameObject, "ViewAll")
    self.mLabRewardTitle =  self:FindChildComponent(self.objViewAll, "PopUpWindow_4/Board/Bottom/Top/Title", DRCSRef_Type.Text)
    self.objViewAll:SetActive(false)
    local objBoard = self:FindChild(self.objViewAll, "Board")
    self.svViewAll = self:FindChildComponent(objBoard, "LoopScrollView", DRCSRef_Type.LoopVerticalScrollRect)
    self.svViewAll:AddListener(function(...) 
        if self:IsOpen() == true then
            self:UpdateViewAllItemUI(...)
        end
    end)
    local btnViewAllClose = self:FindChildComponent(objBoard, "Close", DRCSRef_Type.Button)
    self:AddButtonClickListener(btnViewAllClose, function()
        if self.windowBarInst then
            self.windowBarInst:SetBackBtnState(true)
        end
        self.objViewAll:SetActive(false)
        self.objPinballBoard:SetActive(true)
        -- 枪开始移动
        self.comPinballPlayer:GunStartMove()
    end)
     -- 概率公示
     self.objShowRate = self:FindChild(self.objGamePanel, "ShowRate")
     local btnShowRate = self.objShowRate:GetComponent(DRCSRef_Type.Button)
     self:AddButtonClickListener(btnShowRate, function()
         self:OnClickShowRateTips()
     end)
    -- 发射按钮
    self.objBtnShoot = self:FindChild(self.objGamePanel, "Shoot")

    self.objShootDrum = self:FindChild(self.objBtnShoot, "drum")
    self.objQuickShootDrum = self:FindChild(self.objBtnShoot, "drumQuickShoot")
    self.skeletonShootDrum = self.objShootDrum:GetComponent(DRCSRef_Type.SkeletonGraphic)
    self.skeletonQuickShootDrum = self.objQuickShootDrum:GetComponent(DRCSRef_Type.SkeletonGraphic)
    self.skeletonCurShootDrum = self.skeletonShootDrum

    self.objShootDrumstick = self:FindChild(self.objBtnShoot, "drumstick")
    self.objShootQuickShootDrumstick = self:FindChild(self.objBtnShoot, "drumstickQuickShoot")
    self.skeletonShootDrumstick = self.objShootDrumstick:GetComponent(DRCSRef_Type.SkeletonGraphic)
    self.skeletonShootQuickShootDrumstick = self.objShootQuickShootDrumstick:GetComponent(DRCSRef_Type.SkeletonGraphic)
    self.skeletonCurShootDrumstick = self.skeletonShootDrumstick

    self.objBtnShootRedPoint = self:FindChild(self.objBtnShoot, "RedPoint")
    self.objBtnShootExtraTip = self:FindChild(self.objBtnShoot, "ExtraTip")
    self.textBtnShootExtraTip = self:FindChildComponent(self.objBtnShootExtraTip, "Text", DRCSRef_Type.Text)
    self.objBtnShootNormalBallSign = self:FindChild(self.objBtnShoot, "NormalBallSign")
    self.objBtnShootMeridianSign = self:FindChild(self.objBtnShoot, "MeridianSign")
    self.objBtnShootMeridianSignQuickShoot = self:FindChild(self.objBtnShoot, "MeridianSignQuckShoot")
    self.objBtnShootPrice = self:FindChild(self.objBtnShoot, "Price")
    self.textBtnShootPrice = self.objBtnShootPrice:GetComponent(DRCSRef_Type.Text)
    self.objBtnShootRemain = self:FindChild(self.objBtnShoot, "Remain")
    self.textBtnShootRemain = self.objBtnShootRemain:GetComponent(DRCSRef_Type.Text)
    self.btnShoot = self.objBtnShoot:GetComponent(DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnShoot, function()
        self:OnClickUserBtn()
    end)
    -- 捡垃圾层
    self.objPickItemLayer = self:FindChild(self._gameObject, "PickItemLayer")
    self:InitPickItemLayer()
    -- 高级奖励动画
    self.objTopRewardAnim = self:FindChild(self._gameObject, "TopRewardAnim")
    self.objTopRewardIcon = self:FindChild(self.objTopRewardAnim, "uief_dizuo/Icon")
    self.objTopRewardPet = self:FindChild(self.objTopRewardAnim, "pet")
    self.textTopReward = self:FindChildComponent(self.objTopRewardAnim, "name", DRCSRef_Type.Text)
    self.objTopRewardCG1 = self:FindChild(self.objTopRewardAnim, "cg1")
    self.objTopRewardCG2 = self:FindChild(self.objTopRewardAnim, "cg2")
    self.imgTopRewardCG1 = self.objTopRewardCG1:GetComponent(DRCSRef_Type.Image)
    self.imgTopRewardCG2 = self.objTopRewardCG2:GetComponent(DRCSRef_Type.Image)
    self.imgTopRewardTitle = self:FindChildComponent(self.objTopRewardAnim, "text", DRCSRef_Type.Image)
    self.animTopReward = self.objTopRewardAnim:GetComponent(DRCSRef_Type.Animation)
    self.iAnimTopRewardTime = self.animTopReward.clip.length * 1000

    -- 读取记录在客户端的最近获得数据
    self.kPinballMgr:ReadItemGotList()
    self.objRecentGot:SetActive(true)
    -- 隐藏所有动画图标
    for index, data in ipairs(self.akAnimIcons) do
        data.gameObject:SetActive(false)
    end
    -- 获奖提示
    self.objNotice = self:FindChild(self.objGamePanel, "Notice")
    self.textNotice = self:FindChildComponent(self.objNotice, "Text", DRCSRef_Type.Text)
    self:SetGetRewardNotice()  -- 设置默认通知文本
    -- 注册事件
    self:AddEventListener("PINBALL_GET_DARKGOLD_REWARD", function(info)
        self:OnNotifyGetDarkReward(info.text, info.name)
    end)

    self:AddEventListener("HOODLE_PUBLIC_NOT_READY", function()
        SystemUICall:GetInstance():Toast("侠客行相关服务器不稳定，本玩法暂不可用，其他系统不受影响", false, nil, "PINBALL")
    end)

    -- 最后再读取弹珠台路径数据
    self.comPinballPlayer:Init()  -- 初始化弹珠台控制器

    -- 初始化小球对象池
    self.comPinballPlayer:InitBallPool()

    -- 读取场景
    local keyToBaseID = {}
    local hoodleSceneList = TableDataManager:GetInstance():GetTable('HoodleScene')
    for baseID, scene in pairs(hoodleSceneList) do
        keyToBaseID[scene['Key']] = baseID
    end
    self.mSceneList = {}
    local nodeRoot = self:FindChild(self._gameObject, 'Board/Nodes').transform
    for i = 0, nodeRoot.childCount - 1 do
        local node = nodeRoot:GetChild(i)
        local img = node:GetComponent('Image')
        if img and img.enabled and img.sprite then
            local key = img.sprite.name or ''
            local baseID = keyToBaseID[key]
            if baseID then
                -- 特殊效果
                -- WARNING: 目前按normal和bai来区分的，后期多了可以按
                local effect = nil
                local effectRoot = self:FindChild(node.gameObject, 'Effect')
                if effectRoot then
                    effect = {
                        Bai = self:FindChild(effectRoot, 'Bai'),
                    }
                    if effect.Bai then
                        effect.Bai:SetActive(false)
                    end
                end
                table.insert(self.mSceneList, {Img = img, BaseID = baseID, Effect = effect})
            end
        end
    end
    nodeRoot = self:FindChild(self._gameObject, 'BoardMask').transform
    for i = 0, nodeRoot.childCount - 1 do
        local node = nodeRoot:GetChild(i)
        local img = node:GetComponent('Image')
        if img and img.enabled and img.sprite then
            local key = img.sprite.name or ''
            local baseID = keyToBaseID[key]
            if baseID then
                table.insert(self.mSceneList, {Img = img, BaseID = baseID})
            end
        end
    end

    -- 读取tab
    self.mTabMap = {}
    nodeRoot = self.objTabs.transform
    for i = 0, nodeRoot.childCount - 1 do
        local node = nodeRoot:GetChild(i)
        node = node.gameObject
        local tab = node:GetComponent('Toggle')
        if tab then
            local index = string.sub(node.name, #'Toggle' + 1)
            index = tonumber(index)
            if index then
                self.mTabMap[index] = {
                    Root = node,
                    Toggle = tab,
                    Checkmark = self:FindChild(node, 'Background/Checkmark')
                }

                local labName = self:FindChildComponent(node, 'LabName', 'Text')
                if labName then
                    labName.text = GetLanguageByID((GetTableData('Hoodle', index) or {})['Name'] or 0) 
                end

                self:AddToggleClickListener(tab, function(bIsOn)
                    if bIsOn == true then
                        -- 如果此时禁止切换奖池, 那么不做任何响应
                        if self.iSootingBallCount and (self.iSootingBallCount > 0) then
                            SystemUICall:GetInstance():Toast("请先等待当前小侠客到达目标", false, nil, "PINBALL")
                            return
                        end

                        self:OnClickPoolTab(index)
                    end
                end)
            end
        end
    end

    --! 测试代码  控制面板
    -- self.objTestBtn = self:FindChild(self.objGamePanel, "Test")
    -- self.objTestBtn:SetActive(DEBUG_MODE == true)
    -- if DEBUG_MODE then
    --     self.iTestEnd = -1
    --     self.iTestLuckyNodeFlag = 0
    --     local objCtrlBoard = self:FindChild(self._gameObject, "Control/SimBoardLock")
    --     self.inputEnd = self:FindChildComponent(objCtrlBoard, "End", "InputField")
    --     self.inputLuckyNode = self:FindChildComponent(objCtrlBoard, "LuckyNode", "InputField")
    --     local btnLock = self:FindChildComponent(objCtrlBoard, "Button", "Button")
    --     self:AddButtonClickListener(btnLock, function()
    --         self.iTestEnd = tonumber(self.inputEnd.text)
    --         self.iTestLuckyNodeFlag = tonumber(self.inputLuckyNode.text)
    --         SystemUICall:GetInstance():Toast("锁定终点:" .. self.iTestEnd .. ", 幸运柱碰撞位组: " .. self.iTestLuckyNodeFlag, false, nil, "PINBALL")
    --     end)
    -- end
end

-- 初始化奖励槽
function PinballGameUI:InitRewardBoxes()
    if not self.objRewardBox then
        return
    end
    self.objIconRewardBox = {}  -- 终点奖励的物品图标节点
    self.comEffectRewardBox = {}  -- 终点奖励槽粒子特效组件
    self.scrollBar10ShootReward = nil  -- 10连奖励槽
    local transRewardBox = self.objRewardBox.transform
    local objChildBox = nil
    local index = nil
    for i = 0, transRewardBox.childCount - 1 do
        -- 节点下面有物品图标的, 则为奖励槽, 有进度条的为10连槽, 他们都以名字对应的数字作为数组索引
        objChildBox = transRewardBox:GetChild(i).gameObject
        index = tonumber(objChildBox.transform.name)
        if index then
            local objIcon = self:FindChild(objChildBox, "Icon")
            local objScrollbar = self:FindChild(objChildBox, "Scrollbar")
            if objIcon then
                self.objIconRewardBox[index] = objIcon
                self.iMaxRewardEndNum = self.iMaxRewardEndNum + 1
            elseif objScrollbar then
                self.effectScrollBar10ShootWater = self:FindChildComponent(objChildBox, "EffectWater", DRCSRef_Type.ParticleSystem)
                self.objScrollBar10ShootProgressEffect = self:FindChild(objScrollbar, "SlidingArea/Handle/Effect")
                self.scrollBar10ShootReward = objScrollbar:GetComponent(DRCSRef_Type.Scrollbar)
                self.scrollBar10ShootReward.size = 0
                self.objScrollBar10ShootProgressEffect:SetActive(false)
                self.i10ShootRewardIndex = index
                self.iMaxRewardEndNum = self.iMaxRewardEndNum + 1
            end
            self.comEffectRewardBox[index] = {}
            local comEffect = self:FindChildComponent(objChildBox, "Effect/effect", DRCSRef_Type.ParticleSystem)
            if comEffect then
                self.comEffectRewardBox[index]['particle'] = comEffect
            end
            comEffect = self:FindChildComponent(objChildBox, "Effect", DRCSRef_Type.DOTweenAnimation)
            if comEffect then
                self.comEffectRewardBox[index]['twn'] = comEffect
            end
            self.comEffectRewardBox[index]['MatIdle'] = (self:FindChildComponent(objChildBox, "Effect/ef_woman_idle", 'Renderer') or {}).material
            self.comEffectRewardBox[index]['MatHit'] = (self:FindChildComponent(objChildBox, "Effect/effect", 'Renderer') or {}).material
        end
    end
end

-- 获取幸运柱节点
function PinballGameUI:InitLuckyNodes()
    if not self.objPinballBoard then
        return
    end
    local akRes = {}
    -- 查找枚举 SHBPT_LEFT(1) SHBPT_RIGHT(2) SHBPT_MID(3) 对应的幸运柱
    local transNodes = self:FindChild(self.objPinballBoard, "Nodes").transform
    local trancChildNode = nil
    local objLuckyNode = nil
    local comEffect = nil
    local index = nil
    for i = 0, transNodes.childCount - 1 do
        trancChildNode = transNodes:GetChild(i)
        if trancChildNode.childCount > 0 then
            objLuckyNode = trancChildNode:GetChild(0).gameObject
            -- 幸运柱以自己的索引命名, 索引值对应枚举值
            index = tonumber(objLuckyNode.transform.name)
            if index then
                local progress = self:FindChild(objLuckyNode, "Progress")
                akRes[index] = {
                    ['icon'] = self:FindChild(objLuckyNode, "PinBallIcon"),
                    ['progress'] = {
                        Root = progress,
                        HPList = BoxHelper.GetComponentList('Image', progress, '%d'),
                        HPDiList = BoxHelper.GetComponentList('Image', progress, 'd%d'),
                        LabNum = self:FindChildComponent(progress, 'LabNum', 'Text'),
                    },
                    Root = objLuckyNode,
                    MatIdle = (self:FindChildComponent(objLuckyNode, "ef_eba_idle", 'Renderer') or {}).material,
                    MatHit = (self:FindChildComponent(objLuckyNode, "effectHit", 'Renderer') or {}).material,
                    MatDie = (self:FindChildComponent(objLuckyNode, "effectDie", 'Renderer') or {}).material,
                }
                comEffectHit = self:FindChildComponent(objLuckyNode, "effectHit", DRCSRef_Type.ParticleSystem)
                if comEffectHit then
                    akRes[index]['effectHit'] = comEffectHit
                end
                comEffectDie = self:FindChildComponent(objLuckyNode, "effectDie", DRCSRef_Type.ParticleSystem)
                if comEffectDie then
                    akRes[index]['effectDie'] = comEffectDie
                end
                -- WARNING: 后期扩展，需要按类型扩展
                effect = self:FindChild(objLuckyNode, 'Effect')
                if effect then
                    akRes[index]['Effect'] = {}
                    local effectMap = akRes[index]['Effect']
                    do
                        local trans = effect.transform
                        for i = 0, trans.childCount - 1 do
                            local node = trans:GetChild(i)
                            effectMap[node.name] = node.gameObject
                        end
                    end
                end
                self:SetLuckyNodeProgress(akRes[index].progress, 0, akRes[index].totalHP or 6)
            end
        end
    end
    self.akLuckyNodes = akRes
end

-- 初始化捡垃圾层
function PinballGameUI:InitPickItemLayer()
    if not self.objPickItemLayer then
        return
    end
    local pickItemData = {}
    local objEndPos = self:FindChild(self.objPickItemLayer, "EndPos")
    if objEndPos then
        pickItemData.endPos = objEndPos.transform.localPosition
    end
    local objEndPosServerPlay = self:FindChild(self.objPickItemLayer, "EndPosServerPlay")
    if objEndPosServerPlay then
        pickItemData.endPosServerPlay = objEndPosServerPlay.transform.localPosition
    end
    local objLuckyNodes = self:FindChild(self.objPickItemLayer, "LuckyNodes")
    pickItemData["LuckyNodes"] = {}
    if objLuckyNodes then
        local transLuckyNodes = objLuckyNodes.transform
        local transChild = nil
        for index = 0, transLuckyNodes.childCount - 1 do
            transChild = transLuckyNodes:GetChild(index)
            pickItemData["LuckyNodes"][transChild.name] = {
                ['transform'] = transChild,
                ['gameObject'] = transChild.gameObject,
                ['oriPos'] = transChild.localPosition,
                ['effect'] = self:FindChildComponent(transChild.gameObject, "ef_danzhu_tw", DRCSRef_Type.ParticleSystem),
            }
        end
    end
    local objBoxes = self:FindChild(self.objPickItemLayer, "Boxes")
    pickItemData["Boxes"] = {}
    if objBoxes then
        local transBoxes = objBoxes.transform
        local transChild = nil
        for index = 0, transBoxes.childCount - 1 do
            transChild = transBoxes:GetChild(index)
            pickItemData["Boxes"][transChild.name] = {
                ['transform'] = transChild,
                ['gameObject'] = transChild.gameObject,
                ['oriPos'] = transChild.localPosition,
                ['effect'] = self:FindChildComponent(transChild.gameObject, "ef_danzhu_tw", DRCSRef_Type.ParticleSystem),
            }
        end
    end 
    local objEnemyNodes = self:FindChild(self.objPickItemLayer, "Enemy")
    pickItemData["EnemyNodes"] = {}
    if objEnemyNodes then
        local transEnemyNodes = objEnemyNodes.transform
        local transChild = nil
        for index = 0, transEnemyNodes.childCount - 1 do
            transChild = transEnemyNodes:GetChild(index)
            pickItemData["EnemyNodes"][transChild.name] = {
                ['transform'] = transChild,
                ['gameObject'] = transChild.gameObject,
                ['oriPos'] = transChild.localPosition,
                ['effect'] = self:FindChildComponent(transChild.gameObject, "ef_danzhu_tw", DRCSRef_Type.ParticleSystem),
            }
        end
    end
    
    local pinballPool1 = self:FindChild(self.objPickItemLayer, 'PinballPool1')
    if pinballPool1 then
        for _, key in pairs({'Boss','Enemy','FixedEnemy'}) do
            local pickKey = 'PinballPool1_' .. key
            pickItemData[pickKey] = {}
            local data = pickItemData[pickKey]
            local root = (self:FindChild(pinballPool1, key) or {}).transform
            if root then
                for index = 0, root.childCount - 1 do
                    local node = root:GetChild(index)
                    data[node.name] = {
                        ['transform'] = node,
                        ['gameObject'] = node.gameObject,
                        ['oriPos'] = node.localPosition,
                        ['MatIdle'] = (self:FindChildComponent(node.gameObject, "ef_eba_idle", "Renderer") or {}).material,
                        ['effect'] = self:FindChildComponent(node.gameObject, "ef_danzhu_tw", DRCSRef_Type.ParticleSystem),
                    }
                end
            end
        end
    end

    self.pickItemData = pickItemData
end

-- 初始化最近获得框的特效
function PinballGameUI:InitRecentGotEffect(objParent)
    if not objParent then
        return
    end
    local transParent = objParent.transform
    local transChild = nil
    local ret = {}
    for index = 0, transParent.childCount - 1 do
        transChild = transParent:GetChild(index)
        ret[tonumber(transChild.name)] = transChild:GetComponent(DRCSRef_Type.ParticleSystem)
    end
    return ret
end

-- 初始化获得物品动画图标
function PinballGameUI:InitAnimIcons()
    if not self.objAnimIcons then
        return
    end
    local transAnimIcons = self.objAnimIcons.transform
    local tranIcon = nil
    local akAnimIcons = {}
    for index = 0, transAnimIcons.childCount - 1 do
        tranIcon = transAnimIcons:GetChild(index)
        akAnimIcons[index + 1] = {
            ['transform'] = tranIcon,
            ['gameObject'] = tranIcon.gameObject,
            ['canvasGroup'] = tranIcon:GetComponent(DRCSRef_Type.CanvasGroup)
        }
    end
    self.akAnimIcons = akAnimIcons
    self.iMaxAnimIconsIndex = #akAnimIcons
end

function PinballGameUI:OnEnable()
    self.windowBarInst = OpenWindowBar({
        ['windowstr'] = "PinballGameUI", 
        --['titleName'] = "侠客行",
        ['topBtnState'] = {
            ['bBackBtn'] = true,
            ['bGold'] = true,
            ['bSilver'] = true,
            ['bPinball'] = true,
        },
        ['bSaveToCache'] = true,
    })
    -- 开启物品获得提示
    self.bGetItemToast = true
    -- 开启Toast秘钥模式
    SystemUICall:GetInstance():SetKeyModel("PINBALL")
    -- 清空数据
    self.IsFreeBallRec = {}
    self.iFreeBallCount = 0
    self.iSootingBallCount = 0
    self.btnRecentGotViewAll.interactable = true
    self.objBoardEffect:SetActive(false)
    
    -- self.PinballServerPlayInst:OnEnable()

    self:DoRefreshUI()
end

function PinballGameUI:OnDisable()
    if self.windowBarInst then
        self.windowBarInst = nil
        RemoveWindowBar('PinballGameUI')
    end
    -- 枪停止移动
    self.comPinballPlayer:GunStopMove()
    -- 关闭物品获得提示
    self.bGetItemToast = false
    -- 如果有通过计时器等待表现的球, 关闭所有计时器, 直接发射剩余球
    if self.kShootTimers and next(self.kShootTimers) then
        for kToPush, iTimer in pairs(self.kShootTimers) do
            globalTimer:RemoveTimer(iTimer)
            -- 计时器开启的球都是只做表现的, 
            -- 数据在服务器下行的时候就已经推完
            self:OnRecvShootBallPath(kToPush, false, true)
        end
        self.kShootTimers = {}
    end
    -- 回收所有球
    self.comPinballPlayer:RecAllRunningBallsImmediately()
    -- 关闭Toast秘钥模式
    SystemUICall:GetInstance():CloseKeyModel()
    -- 写入最近获得数据
    self.kPinballMgr:WriteItemGotList()
    -- 缓存当前池的信息
    self.akLuckyNodeInfoSquence = nil
    self.akEndSlotInfoSquence = nil
    -- 刷新导航栏红点
    local winNav = GetUIWindow("NavigationUI")
    if winNav then
        winNav:RefreshPinballRedPoint()
    end
    -- self.PinballServerPlayInst:OnDisable()
    self:Reset()
end

function PinballGameUI:Update()
    if self.mPinballPool1._gameObject.activeSelf then
        self.mPinballPool1:Update()
    end
end

-- 这里不使用原生命周期中的RefreshUI, OnEnable内调用
function PinballGameUI:DoRefreshUI()
    -- 隐藏所有界面, 然后显示加载中
    self.objTabs:SetActive(false)
    self.objServerPlay:SetActive(false)
    self.objBtnShoot:SetActive(false)
    self.objPinballBoard:SetActive(false)
    self.objLoading:SetActive(true)

    self.mPinballPool1._gameObject:SetActive(false)
    self.mPinballPool1:OnDisable()
    -- 先请求目前有哪些池子开放
    SendQueryHoodleLotteryInfo(SHLQT_OPEN_INFO, 0)
    -- 从第一次请求开始, 开启一个5秒的超时, 如果5秒后依然没有连上服务器, 则关闭侠客行
    self:SetTimeOutConter()
end

-- 重置所有池子
function PinballGameUI:Reset()
    self.objServerPlay:SetActive(false)
    self.PinballServerPlayInst:OnDisable()

    self.mPinballPool1._gameObject:SetActive(false)
    self.mPinballPool1:OnDisable()
end

-- 设置超时计时器
function PinballGameUI:SetTimeOutConter()
    if self.iTimeoutConter then
        globalTimer:RemoveTimer(self.iTimeoutConter)
        self.iTimeoutConter = nil
    end
    -- 5s超时
    self.iTimeoutConter = globalTimer:AddTimer(5000, function()
		local win = GetUIWindow("PinballGameUI")
		if win then
			win:CheckTimeOut()
		end
	end)
end

-- 检查超时结果
function PinballGameUI:CheckTimeOut()
    globalTimer:RemoveTimer(self.iTimeoutConter)
    self.iTimeoutConter = nil
    if (IsWindowOpen("LoadingUI") == true) and (IsWindowOpen("PinballGameUI") == true) then
        RemoveWindowImmediately("LoadingUI")
        RemoveWindowImmediately("PinballGameUI")
        SystemUICall:GetInstance():Toast("请求超时", false, nil, "PINBALL")
    end
end

-- 传入一个 SeHoodleSlotDropTipsInfo 结构, 获取其中包含的物品以及数量
function PinballGameUI:GetItemAndCountByItemInfo(kItemInfo)
    if not kItemInfo then
        return nil, 0
    end
    local itemTypeData, iCount = nil, nil
    if kItemInfo.dwCurDropItemID and (kItemInfo.dwCurDropItemID > 0) then
        itemTypeData = TableDataManager:GetInstance():GetTableData("Item", kItemInfo.dwCurDropItemID)
        iCount = kItemInfo.dwCurDropItemNum or 0
    elseif kItemInfo.dwCurCDropBaseID and (kItemInfo.dwCurCDropBaseID > 0) then
        itemTypeData, iCount = self.kPinballMgr:GenItemTypeDataByDropID(kItemInfo.dwCurCDropBaseID)
    end
    return itemTypeData, iCount
end

function PinballGameUI:OnRecvPinballPoolState()
    if IsWindowOpen("PinballGameUI") ~= true then
        return
    end
    if not (self.objTabs and self.objTabTemp) then
        return
    end
    -- 获取之前已经记录选中的池子类型
    local ePoolTypeChosen = self.kPinballMgr:GetCurPoolExcelData("PoolType")

    -- 这个时候已经知道了池子的开放信息
    for _, tab in pairs(self.mTabMap) do
        tab.Root:SetActive(false)
    end
    local TB_Hoodle = TableDataManager:GetInstance():GetTable("Hoodle")
    local selectPoolID
    for index, data in pairs(TB_Hoodle) do
        local tab = self.mTabMap[index]
        if tab and self.kPinballMgr:IsPoolTypeOpen(data.PoolType) then
            local curPoolID = data.BaseID
            
            if not selectPoolID then
                selectPoolID = curPoolID
            end
            
            if tab.Toggle.isOn then
                selectPoolID = curPoolID
            end

            tab.Root:SetActive(true)
        end
    end
    
    self.objTabs:SetActive(true)
    if selectPoolID then
        self:OnClickPoolTab(selectPoolID)
    end
end

-- 选择一个奖池
function PinballGameUI:OnClickPoolTab(iPoolTypeID)
    local TB_Hoodle = TableDataManager:GetInstance():GetTable("Hoodle")
    if not (iPoolTypeID and TB_Hoodle[iPoolTypeID]) then
        return
    end
    -- 是否请求不同的池
    local bRequestAnotherPool = self.kPinballMgr:GetCurPoolExcelID() ~= iPoolTypeID
    -- 请求之前先缓存当前池的数据
    if bRequestAnotherPool and (not self.kPinballMgr:SetCurPoolByID(iPoolTypeID)) then
        return
    end
    local kCurPoolData = self.kPinballMgr:GetCurPoolExcelData()
    if not kCurPoolData then
        return
    end
    self.iMaxLuckyNodeProgress = kCurPoolData.NailTimes or 1
    self.iMax10ShootRewardProgress = kCurPoolData.BurstTimes or 1
    -- 如果有缓存数据, 那么使用缓存数据去初始化ui, 否则, 请求池的数据
    if self.bIsRequesting == true then
        -- 这个标记在收到池子的基础信息之后会被置为false
        SystemUICall:GetInstance():Toast("由于网络原因, 正在处理上一个请求, 请稍后", false, nil, "PINBALL")
        return
    else
        -- 开始请求
        self.bIsRequesting = true
        SendQueryHoodleLotteryInfo(SHLQT_BASE, kCurPoolData.PoolType)
    end
end

-- 收到奖池的基础信息
function PinballGameUI:OnRecvPollBaseInfo()
    if IsWindowOpen("PinballGameUI") ~= true then
        self.bIsRequesting = false
        return
    end
    local kCurPoolData = self.kPinballMgr:GetCurPoolExcelData()
    local kCurPoolBaseInfo = self.kPinballMgr:GetCurPoolBaseInfo()
    if not (kCurPoolData and kCurPoolBaseInfo) then
        self.bIsRequesting = false
        return
    end
    if (not kCurPoolBaseInfo) or (kCurPoolBaseInfo.bOpen ~= 1) then
        SystemUICall:GetInstance():Toast("该奖励池暂未开放!", false, nil, "PINBALL")
        self.bIsRequesting = false
        return
    end
    if not self.bIsRequesting and self.mCurPoolID == kCurPoolData.BaseID then
        -- 刷幸运柱显示
        self:ShowHideLuckyNodes()
        return
    end
    -- 切换池子
    self:ShowPool(kCurPoolData)
    -- 初始化幸运珠
    self:InitLuckyNodesWithPoolBaseInfo(kCurPoolBaseInfo)
    -- 初始化终点奖励槽
    self:InitEndRewardSlotWithPoolBaseInfo(kCurPoolBaseInfo)
    -- 初始化小球样式
    -- TIPS: 这里先注释掉, 尽量不要启用, SetBallStyle->InitBallPool的时候会清空当前小球对象池并将id重新计数
    -- 可能会引发一些错误
    -- local kBallItemID = kCurPoolData.HoodleItem
    -- local TB_Item = TableDataManager:GetInstance():GetTable("Item")
    -- if kBallItemID and TB_Item[kBallItemID] then
    --     self:SetBallStyle(TB_Item[kBallItemID])
    -- end
    -- 初始化发射按钮
    self:InitShootBtn()
    -- 初始化其他主题样式
    
    self.objLoading:SetActive(false)
    self.objBtnShoot:SetActive(true)
    self.objPinballBoard:SetActive(true)
    self.bIsRequesting = false

    -- 枪开始移动
    self.comPinballPlayer:GunStartMove()

    self:PinballLoadOver()

    -- 如果账户存在剩余的免费球, 那么在这个时候全部发射
    if kCurPoolBaseInfo.dwCurPoolFreeHoodleNum
    and (kCurPoolBaseInfo.dwCurPoolFreeHoodleNum > 0) then
        self:Trig10ShootReward(kCurPoolBaseInfo.dwCurPoolFreeHoodleNum)
    end
end

function PinballGameUI:ResetPoolSuccess()
    self.mReseting = false
end

-- 根据池子类型显示奖池（切换左侧的tog，切换右侧的场景）
-- WARNING: 目前是根据池子类型来显示，后期看需求~~~
function PinballGameUI:ShowPool(poolData)
    -- 确定收到卡池了，再对具体的卡池进行刷新
    self:Reset()

    local poolType = poolData.PoolType
    local poolID = poolData.BaseID
    
    self.mCurPoolID = poolID
    self.mReseting = false

    local sceneKey
    -- WARNING: 后期复杂了，背景多了，需要配表咯~~~
    -- 白衣小侠客特殊处理
    if self.mCurPoolID == 5 then
        self.mPinballPool1._gameObject:SetActive(true)
        self.mPinballPool1:OnEnable()
        self.mPinballPool1:SetRefreshFlag()
        sceneKey = 'Bai'
    else
        -- self.objServerPlay:SetActive(true)
        -- self.PinballServerPlayInst:OnEnable()
        self.kPinballMgr:RequestServerPlayData()
        sceneKey = 'Normal'
    end

    -- 切换右侧场景资源
    if self.mSceneList then
        for _, scene in pairs(self.mSceneList) do
            -- 切换图片
            local sceneConfig = GetTableData('HoodleScene', scene.BaseID)
            if sceneConfig and sceneConfig[sceneKey] then
                self:SetSpriteAsync(sceneConfig[sceneKey], scene.Img)
            end

            -- 切换特效
            if scene.Effect and scene.Effect.Bai then
                scene.Effect.Bai:SetActive(sceneKey == 'Bai')
            end
        end
    end

    -- 切换tab
    if self.mTabMap then
        for index, tab in pairs(self.mTabMap) do
            tab.Checkmark:SetActive(index == poolID)
        end
    end

    -- 切换底部奖励池角色
    if self.comEffectRewardBox then
        local roleConfig = GetTableData("HoodleRole", (poolID << 0 | 1000 << 16)) or GetTableData("HoodleRole", 1)
        for _, box in pairs(self.comEffectRewardBox) do
            if box.MatIdle then
                box.MatIdle.mainTexture = LoadPrefab(roleConfig['IdlePath'])
            end

            if box.MatHit then
                box.MatHit.mainTexture = LoadPrefab(roleConfig['HitPath'])
            end
        end
    end
    
    -- 显示最近奖励
    local list = self.kPinballMgr:GetMergedRewardReocrd(self.mCurPoolID) or {}
    if #list > 0 then
        self:UpdateItemIcon(self.objRecentGotIcon, list[#list].itemTypeData)
        self.objRecentGot:SetActive(true)
    else
        
        self.objRecentGot:SetActive(false)
    end
end

-- 初始化发射按钮
function PinballGameUI:InitShootBtn()
    self.objBtnShootNormalBallSign:SetActive(false)
    self.objBtnShootMeridianSign:SetActive(false)
    self.objBtnShootMeridianSignQuickShoot:SetActive(false)
    self.objBtnShootPrice:SetActive(false)
    self.objBtnShootRemain:SetActive(false)
    self.objBtnShootRedPoint:SetActive(false)
    self.objBtnShootExtraTip:SetActive(false)
    self.objShootDrum:SetActive(false)
    self.objQuickShootDrum:SetActive(false)
    self.objShootDrumstick:SetActive(false)
    self.objShootQuickShootDrumstick:SetActive(false)

    local iDialyFreeHoodleNum = self.kPinballMgr:GetDailyFreeHoodleNum() or 0
    local iNormalHoodleNum = self.kPinballMgr:GetNormalHoodleNum() or 0

    -- 如果开启了手动10连发射
    if self.kPinballMgr:CanUserUseQuickShoot() then
        self.objQuickShootDrum:SetActive(true)
        self.objShootQuickShootDrumstick:SetActive(true)
        self.skeletonCurShootDrum = self.skeletonQuickShootDrum
        self.skeletonCurShootDrumstick = self.skeletonShootQuickShootDrumstick
        local iMaxShoot = math.min(SSD_ONCE_REPEAT_HOODLE_BALL_NUM, iDialyFreeHoodleNum + iNormalHoodleNum)
        if iMaxShoot > 0 then
            self.objBtnShootNormalBallSign:SetActive(true)
            self.objBtnShootRemain:SetActive(true)
            -- 当有小侠客余量时, 这里显示发射一次消耗的小侠客数量
            self.textBtnShootRemain.text = string.format("x%d", iMaxShoot)
            if iDialyFreeHoodleNum > 0 then
                self.objBtnShootRedPoint:SetActive(true)
                self.objBtnShootExtraTip:SetActive(true)
                self.textBtnShootExtraTip.text = string.format("已包含免费%d/%d", iDialyFreeHoodleNum, SSD_MAX_DAILY_FREE_LITTLE_WARRIOR_NUM)
            end
        else
            self.objBtnShootPrice:SetActive(true)
            self.objBtnShootMeridianSignQuickShoot:SetActive(true)
            self.textBtnShootPrice.text = self.kPinballMgr:GetUserPaySilver() * SSD_ONCE_REPEAT_HOODLE_BALL_NUM
        end
    else
        self.objShootDrum:SetActive(true)
        self.objShootDrumstick:SetActive(true)
        self.skeletonCurShootDrum = self.skeletonShootDrum
        self.skeletonCurShootDrumstick = self.skeletonShootDrumstick
        if iDialyFreeHoodleNum > 0 then
            self.objBtnShootRedPoint:SetActive(true)
            self.objBtnShootNormalBallSign:SetActive(true)
            self.objBtnShootRemain:SetActive(true)
            self.textBtnShootRemain.text = string.format("免费%d/%d", iDialyFreeHoodleNum, SSD_MAX_DAILY_FREE_LITTLE_WARRIOR_NUM)
        elseif iNormalHoodleNum > 0 then
            self.objBtnShootNormalBallSign:SetActive(true)
            self.objBtnShootRemain:SetActive(true)
            -- 当有小侠客余量时, 这里显示发射一次消耗的小侠客数量
            self.textBtnShootRemain.text = "x1"
        else
            self.objBtnShootPrice:SetActive(true)
            self.objBtnShootMeridianSign:SetActive(true)
            self.textBtnShootPrice.text = self.kPinballMgr:GetUserPaySilver()
        end
    end

    -- 播放一下鼓槌的动画, 清空初始状态...
    SetSkeletonAnimation(self.skeletonCurShootDrumstick, 0, "animation2", false)

    -- 刷新顶部栏小侠客数量
    if self.windowBarInst then
        self.windowBarInst:RefreshPinball()
    end
end

-- 使用奖励池基础数据初始化幸运柱进度与奖励
function PinballGameUI:InitLuckyNodesWithPoolBaseInfo(kPoolBaseInfo)
    -- 初始化幸运柱奖励与进度
    local itemTypeData, iCount = nil, nil
    local curAndNextRewardData = nil
    local akProgressInfo = kPoolBaseInfo.akProgressInfo
    local progressInfo = nil
    local iLuckyNodeIndex = 0
    local kLuckyNode = nil
    local fProgress = nil
    local akSquence = {}
    for index = 0, #akProgressInfo do
        progressInfo = akProgressInfo[index]
        iLuckyNodeIndex = progressInfo.eProgressType
        if self.akLuckyNodes[iLuckyNodeIndex] then
            kLuckyNode = self.akLuckyNodes[iLuckyNodeIndex]
            self:SetLuckyNodeProgress(kLuckyNode.progress, progressInfo.dwCurProgress or 0, progressInfo.dwTotalHPNum or 6)
            curAndNextRewardData = progressInfo.kProgressTip
            
            -- 显隐
            local hide = progressInfo.bHide == 1
            kLuckyNode.Root:SetActive(not hide)

            itemTypeData, iCount = self:GetItemAndCountByItemInfo(curAndNextRewardData)
            if itemTypeData then
                self:UpdateItemIcon(kLuckyNode.icon, itemTypeData, iCount)
                kLuckyNode.icon:SetActive(true)
            else
                kLuckyNode.icon:SetActive(false)
            end
            local privacyType = progressInfo.ePrivacyType or 0
            akSquence[iLuckyNodeIndex] = {
                [1] = {
                    ["uiPoolID"] = self.mCurPoolID,
                    ["kItemInfo"] = curAndNextRewardData,
                    ["progress"] = progressInfo.dwCurProgress or 0,
                    ["totalHP"] = progressInfo.dwTotalHPNum or 6,
                    ['privacyType'] = privacyType,
                    ['hide'] = hide
                }
            }
            if self.mCurPoolID then
                local roleConfig = GetTableData("HoodleRole", (self.mCurPoolID << 0 | privacyType << 16)) or GetTableData("HoodleRole", 1)
                if roleConfig then
                    
                    if kLuckyNode.MatIdle then
                        kLuckyNode.MatIdle.mainTexture = LoadPrefab(roleConfig['IdlePath'])
                    end
                    
                    if kLuckyNode.MatHit then
                        kLuckyNode.MatHit.mainTexture = LoadPrefab(roleConfig['HitPath'])
                    end
                    
                    if kLuckyNode.MatDie then
                        kLuckyNode.MatDie.mainTexture = LoadPrefab(roleConfig['DiePath'])
                    end
                end
            end

            -- 特殊角色特效
            -- WARNGING: 目前只有魔君，后面有扩展可以用唯一类型标识
            local effectMap = kLuckyNode.Effect
            if effectMap then
                for key, effect in pairs(effectMap) do
                    if key == 'Mojun' then
                        effect:SetActive(self.mCurPoolID == 5 and privacyType == SHPCT_CHIVALROUS_6)
                    else
                        effect:SetActive(false)
                    end
                end
            end
        end
    end
    -- 初始化物品队列
    self.akLuckyNodeInfoSquence = akSquence
end

-- 显示隐藏的幸运柱
function PinballGameUI:ShowHideLuckyNodes()
    for index, queue in pairs(self.akLuckyNodeInfoSquence) do
        local luckyNode = self.akLuckyNodes[index]
        if luckyNode then
            luckyNode.Root:SetActive(true)
        end

        for _, info in pairs(queue) do
            info.hide = false
        end
    end
end

-- 使用奖励池基础数据初始化终点槽
function PinballGameUI:InitEndRewardSlotWithPoolBaseInfo(kPoolBaseInfo)
    -- 初始化底部奖励槽
    local itemTypeData, iCount = nil, nil
    local curAndNextRewardData = nil
    local akSlotInfo = kPoolBaseInfo.akSlotInfo
    local kSlotInfo = nil
    local iEndSlotIndex = 0
    local objIcon = nil
    local akSquence = {}
    for index = 0, #akSlotInfo do
        kSlotInfo = akSlotInfo[index]
        iEndSlotIndex = kSlotInfo.dwSlotIndex + 1
        if iEndSlotIndex == self.i10ShootRewardIndex then
            local iProgress = kPoolBaseInfo.dwSpecialSlotProgress or 0
            self.scrollBar10ShootReward.size = iProgress / (self.iMax10ShootRewardProgress or 1)
            akSquence[iEndSlotIndex] = {
                [1] = {
                    ["uiPoolID"] = self.mCurPoolID,
                    ["kItemInfo"] = nil,
                    ["progress"] = iProgress,
                }
            }
            self.objScrollBar10ShootProgressEffect:SetActive(iProgress > 0)
        elseif self.objIconRewardBox[iEndSlotIndex] then
            objIcon = self.objIconRewardBox[iEndSlotIndex]
            curAndNextRewardData = kSlotInfo.kSlotTip
            itemTypeData, iCount = self:GetItemAndCountByItemInfo(curAndNextRewardData)
            if itemTypeData then
                self:UpdateItemIcon(objIcon, itemTypeData, iCount)
                objIcon:SetActive(true)
            else
                objIcon:SetActive(false)
            end
            akSquence[iEndSlotIndex] = {
                [1] = {
                    ["uiPoolID"] = self.mCurPoolID,
                    ["kItemInfo"] = curAndNextRewardData,
                    ["progress"] = 0,
                }
            }
        end
    end
    self.objRewardBox:SetActive(true)
    -- 初始化物品队列
    self.akEndSlotInfoSquence = akSquence
end

-- 侠客行加载结束
function PinballGameUI:PinballLoadOver()
    -- 关闭加载中
    if IsWindowOpen("LoadingUI") then
        RemoveWindowImmediately("LoadingUI")
    end
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_AnimEnd, "PinballGameUI")
end

-- 设置弹珠的样式
-- function PinballGameUI:SetBallStyle(itemTypeData)
--     -- 注意, 这里要设置完弹珠模板之后再初始化控制器的弹珠池
--     self.comPinballPlayer:InitBallPool()
-- end

-- 设置奖励球
function PinballGameUI:UpdateItemIcon(objIcon, kItemTypeData, iNum, bShowName, bShowNewSign)
    if not (objIcon and kItemTypeData) then
        return
    end
    local icon = self:FindChild(objIcon, "Icon")
    self.ItemIconUIInst:UpdateUIWithItemTypeData(icon, kItemTypeData)
    if (not iNum) or (iNum <= 1) then
        self.ItemIconUIInst:HideItemNum(icon)
    else
        self.ItemIconUIInst:SetItemNum(icon, iNum)
    end
    local objName = self:FindChild(objIcon, "Name")
    if bShowName == true then
        objName:GetComponent(DRCSRef_Type.Text).text = getRankBasedText(kItemTypeData.Rank or 1, kItemTypeData.ItemName or '')
        objName:SetActive(true)
    else
        objName:SetActive(false)
    end

    local objNewSign = self:FindChild(objIcon, "NewSign")
    objNewSign:SetActive(bShowNewSign == true)
end

-- 弹珠台控制器初始化完毕
function PinballGameUI:OnPinballPlayerInitEnd()
    self.bInitFinish = true
    -- SystemUICall:GetInstance():Toast("弹珠台初始化结束!", false, nil, "PINBALL")
end

-- 触发10连奖励
function PinballGameUI:Trig10ShootReward(iFreeBallNum)
    if (not iFreeBallNum) or (iFreeBallNum <= 0) then
        return
    end

    self:OnClickShoot(true)
end

-- 弹珠触碰到终点
function PinballGameUI:OnPinballTouchEnd(index, strBallID)
    if (not strBallID) or (strBallID == "") then
        return
    end
    -- 如果是免费球到达终点, 免费球计数减1
    if self.IsFreeBallRec and (self.IsFreeBallRec[strBallID] == true) then
        self.IsFreeBallRec[strBallID] = nil
        self.iFreeBallCount = (self.iFreeBallCount or 0) - 1
        -- 如果场上没有免费求, 关闭火焰特效
        if self.iFreeBallCount <= 0 then
            self.iFreeBallCount = 0
            self.objBoardEffect:SetActive(false)
        end
    end
    -- 关闭奖池切换tab的禁止点击
    local bShootEnd = false
    if (self.iSootingBallCount ~= nil) and (self.iSootingBallCount > 0) then
        self.iSootingBallCount = self.iSootingBallCount - 1
        if self.iSootingBallCount == 0 then
            self.btnRecentGotViewAll.interactable = true
            bShootEnd = true
        end
    end
    -- 小球达到终点表现
    if (not self.akEndSlotInfoSquence) 
    or (not self.objIconRewardBox)
    or (not self.akEndSlotInfoSquence[index])
    -- 队列中至少要有新旧两个数据
    or (#self.akEndSlotInfoSquence[index] <= 1) then
        if bShootEnd then
            self:OnPinballShootEnd()
        end
        return
    end
    local squence = self.akEndSlotInfoSquence[index]
    -- SystemUICall:GetInstance():Toast(strBallID .. "号球到达终点: " .. tostring(index), false, nil, "PINBALL")
    -- 说明：
    -- 一个队列中， 堆积着若干次发射弹珠服务器下发的结果
    -- 每个结果中， 都有表示这次下发时， 当前应该获得的奖励以及下一个应该显示的奖励
    -- 因此， 可以认为， 这个队列的构成类似于一个双向链表， 对于每一个元素来说， E1->next == E2, E1 == E2->pre
    -- 当球砸中终点时， 需要从当前队列中取出第一个数据用来表现为 “获得了一个奖励”， 为了防止队列错乱
    -- 可以总是用下一个数据的 “当前应当获得奖励”（E2->pre）来验证当前用来做表现的数据（E1）是否正确， 如果发生误差， 优先使用E2->pre, 并输出一条log
    local oldInfo = squence[1]  -- 取出一个数据， E1
    table.remove(squence, 1)  -- 移除旧数据 E1
    local newInfo = squence[1]  -- 获取旧数据之后的一个数据， E2
    if index == self.i10ShootRewardIndex then
        local newProgress = newInfo.progress
        self.iMax10ShootRewardProgress = self.iMax10ShootRewardProgress or 1
        local fProgress = newProgress / self.iMax10ShootRewardProgress
        self.scrollBar10ShootReward.size = fProgress
        -- 播放特效
        self.objScrollBar10ShootProgressEffect:SetActive(newProgress > 0)
        self.effectScrollBar10ShootWater:Play()
        if newInfo.max == true then
            -- 进度条满后, 直接替用户发射10个免费球, 用户此时也可以自己发射普通球
            local iFreeBallNum = self.kPinballMgr:GetFreeHoodleNum()
            if iFreeBallNum and (iFreeBallNum > 0) then
                SystemUICall:GetInstance():Toast("神秘侠客前来支援!", false, nil, "PINBALL")
                self:Trig10ShootReward(iFreeBallNum)
                self.kPinballMgr:SetFreeHoodleNum(0)
            end
            -- 播放音效
            PlaySound(GameSound.Progress)
        end
    else
        -- 这里获取E1对于的用来表现为获得的物品数据， 但是为了保险起见， 这里的数据只用来和E2->pre做对比并输出log， 并不真的使用
        -- 实际总是使用E2->pre, 因为E2->pre总是认为是正确的
        local oldItemTypeData, iOldCount = self:GetItemAndCountByItemInfo(oldInfo.kItemInfo)  -- 这里拿到的是E1包含的物品数据
        -- 这里开始拿E2->pre的数据
        local kCurShouldGetItemID = 0
        local kCurShouldGetItemNum = 0
        if newInfo.kItemInfo then
            kCurShouldGetItemID = newInfo.kItemInfo.dwCurRewardItemID or 0
            kCurShouldGetItemNum = newInfo.kItemInfo.dwCurRewardItemNum or 0
        end
        local kCurShouldGetItemBaseData = TableDataManager:GetInstance():GetTableData("Item", kCurShouldGetItemID)
        -- 如果数据错误, 不要继续做表现了
        if not kCurShouldGetItemBaseData then
            local strError = "侠客行终点槽奖励数据错误： 无法获取到id为" .. tostring(kCurShouldGetItemID) .. "的奖励"
            derror(strError)
            return
        end
        -- 用 E1 == E2->pre 的规则做一个队列完整性的检查
        -- 仅输出log, 流程依然继续
        if (oldItemTypeData == nil) or (oldItemTypeData.BaseID ~= kCurShouldGetItemID) then
            -- 出现这个错误通常意味着客户端表现会出现 不符 或 错误, 需要排查客户端与服务器的数据逻辑
            local strError = "侠客行终点槽队列检查错误: 校验数据 " .. tostring(kCurShouldGetItemBaseData.ItemName) .. " 与 " .. tostring(oldItemTypeData and "空物品" or oldItemTypeData.ItemName) .. " 不符"
            derror(strError)
        end
        -- 显示新图标
        local objIcon = self.objIconRewardBox[index]
        if objIcon then
            local itemTypeData, iCount = self:GetItemAndCountByItemInfo(newInfo.kItemInfo)  -- 读取E2包含的物品数据, 用于更新到图标上显示下一个将要获得的物品
            if itemTypeData then
                self:UpdateItemIcon(objIcon, itemTypeData, iCount)
                objIcon:SetActive(true)
            else
                objIcon:SetActive(false)
            end
            self:DynamicPickItemAnim("Boxes", index, kCurShouldGetItemBaseData, kCurShouldGetItemNum, function()
                self:GetItemReward(kCurShouldGetItemBaseData, kCurShouldGetItemNum, oldInfo.uiPoolID, newInfo.uiRecordIndex)
                -- SystemUICall:GetInstance():ShowToastByCacheKey(kCurShouldGetItemBaseData.BaseID)
            end, 0.6)
        else
            self:GetItemReward(kCurShouldGetItemBaseData, kCurShouldGetItemNum, oldInfo.uiPoolID, newInfo.uiRecordIndex)
        end
        -- 播报暗金奖励
        self:SetMyNextGetRewardNotice()
        -- 小球入槽效果
        if self.comEffectRewardBox[index] then
            -- 播放粒子特效
            if self.comEffectRewardBox[index].particle then
                self.comEffectRewardBox[index].particle:Play()
            end
            -- 播放DoTwn动画
            if self.comEffectRewardBox[index].twn then
                self.comEffectRewardBox[index].twn:DORestart()
            end
        end
    end
    if bShootEnd then
        self:OnPinballShootEnd()
    end
    -- 播放音效
    PlaySound(GameSound.EnterSlot)
end

-- 弹珠是否都掉落？
function PinballGameUI:IsAllDone()
    return (self.iSootingBallCount or 0) == 0
end

-- 弹珠触碰到幸运柱
function PinballGameUI:OnPinballTouchLuckyNode(index, strBallID)
    if not (self.akLuckyNodeInfoSquence and self.akLuckyNodes and self.akLuckyNodes[index]) then
        return
    end
    -- 说明：
    -- 一个队列中， 堆积着若干次发射弹珠服务器下发的结果
    -- 每个结果中， 都有表示这次下发时， 当前应该获得的奖励以及下一个应该显示的奖励
    -- 因此， 可以认为， 这个队列的构成类似于一个双向链表， 对于每一个元素来说， E1->next == E2, E1 == E2->pre
    -- 当球砸中终点时， 需要从当前队列中取出第一个数据用来表现为 “获得了一个奖励”， 为了防止队列错乱
    -- 可以总是用下一个数据的 “当前应当获得奖励”（E2->pre）来验证当前用来做表现的数据（E1）是否正确， 如果发生误差， 优先使用E2->pre, 并输出一条log
    local squence = self.akLuckyNodeInfoSquence[index]
    -- 队列中至少要有新旧两个数据
    if not (squence and #squence > 1) then
        return
    end
    -- 播放恶霸受击特效
    local comEffect = self.akLuckyNodes[index]['effectHit']
    if comEffect then
        comEffect:Play()
    end
    -- 播放音效
    PlaySound(GameSound.HitEB)
    -- SystemUICall:GetInstance():Toast(strBallID .. "号球撞柱" .. tostring(index), false, nil, "PINBALL")
    local oldInfo = squence[1]  -- 取出一个数据， E1
    table.remove(squence, 1)  -- 移除旧数据 E1
    local newInfo = squence[1]  -- 获取旧数据之后的一个数据， E2
    if self.akLuckyNodes[index]['progress'] then
        -- 这里的进度条作为血条, 是倒扣的
        local objProgress = self.akLuckyNodes[index].progress
        self:SetLuckyNodeProgress(objProgress, newInfo.progress or 0, newInfo.totalHP or 6)
    end
    -- 判断集齐奖励
    if newInfo.max == true then
        -- 这里获取E1对于的用来表现为获得的物品数据， 但是为了保险起见， 这里的数据只用来和E2->pre做对比并输出log， 并不真的使用
        -- 实际总是使用E2->pre, 因为E2->pre总是认为是正确的
        local oldItemTypeData, iOldCount = self:GetItemAndCountByItemInfo(oldInfo.kItemInfo)
        -- 这里开始拿E2->pre的数据
        local kCurShouldGetItemID = 0
        local kCurShouldGettemNum = 0
        if newInfo.kItemInfo then
            kCurShouldGetItemID = newInfo.kItemInfo.dwCurRewardItemID or 0
            kCurShouldGetItemNum = newInfo.kItemInfo.dwCurRewardItemNum or 0
        end
        local kCurShouldGetItemBaseData = TableDataManager:GetInstance():GetTableData("Item", kCurShouldGetItemID)
        -- 如果数据错误, 不要继续做表现了
        if not kCurShouldGetItemBaseData then
            local strError = "侠客行柱子奖励数据错误： 无法获取到id为" .. tostring(kCurShouldGetItemID) .. "的奖励"
            derror(strError)
            return
        end
        -- 用 E1 == E2->pre 的规则做一个队列完整性的检查
        -- 仅输出log, 流程依然继续
        if (oldItemTypeData == nil) or (oldItemTypeData.BaseID ~= kCurShouldGetItemID) then
            -- 出现这个错误通常意味着客户端表现会出现 不符 或 错误, 需要排查客户端与服务器的数据逻辑
            local strError = "侠客行柱子队列检查错误: 校验数据 " .. tostring(kCurShouldGetItemBaseData.ItemName) .. " 与 " .. tostring(oldItemTypeData and "空物品" or oldItemTypeData.ItemName) .. " 不符"
            derror(strError)
        end
        -- 显隐
        self.akLuckyNodes[index].Root:SetActive(not newInfo.hide)
        -- 显示新图标
        if self.akLuckyNodes[index]['icon'] then
            local objIcon = self.akLuckyNodes[index].icon
            local itemTypeData, iCount = self:GetItemAndCountByItemInfo(newInfo.kItemInfo)  -- 读取E2包含的物品数据, 用于更新到图标上显示下一个将要获得的物品
            if itemTypeData then
                self:UpdateItemIcon(objIcon, itemTypeData, iCount)
                objIcon:SetActive(true)
            else
                objIcon:SetActive(false)
            end
            self:DynamicPickItemAnim("LuckyNodes", index, kCurShouldGetItemBaseData, kCurShouldGetItemNum, function()
                self:GetItemReward(kCurShouldGetItemBaseData, kCurShouldGetItemNum, oldInfo.uiPoolID, newInfo.uiRecordIndex)
            end, 0.6)
        else
            self:GetItemReward(kCurShouldGetItemBaseData, kCurShouldGetItemNum, oldInfo.uiPoolID, newInfo.uiRecordIndex)
        end
        -- 播报暗金奖励
        self:SetMyNextGetRewardNotice()
        -- 播放恶霸死亡特效
        local comEffect = self.akLuckyNodes[index]['effectDie']
        if comEffect then
            comEffect:Play()
        end
        if self.objServerPlay.activeSelf then
            -- 击败一个恶霸, 在左侧提示自己贡献了全服进度
            self.PinballServerPlayInst:CreateNewPusherBubble(true)
            self:DynamicPickItemAnim("EnemyNodes", index, nil, nil, nil, 1)
        elseif self.mPinballPool1._gameObject.activeSelf then
            -- 击败一个恶霸，在左侧显示个人奖池
            self.mPinballPool1:OnPinballTouchLuckyNode(index, oldInfo, newInfo, self.mReseting)
        end
        -- 切换角色
        if self.mCurPoolID then
            local privacyType = newInfo.privacyType or 0
            local roleConfig = GetTableData("HoodleRole", (self.mCurPoolID << 0 | privacyType << 16)) or GetTableData("HoodleRole", 1)
            local kLuckyNode = self.akLuckyNodes[index]
            if roleConfig and kLuckyNode then
                if kLuckyNode.MatIdle then
                    kLuckyNode.MatIdle.mainTexture = LoadPrefab(roleConfig['IdlePath'])
                end
                
                if kLuckyNode.MatHit then
                    kLuckyNode.MatHit.mainTexture = LoadPrefab(roleConfig['HitPath'])
                end
                
                if kLuckyNode.MatDie then
                    kLuckyNode.MatDie.mainTexture = LoadPrefab(roleConfig['DiePath'])
                end
                
                -- 特殊角色特效
                -- WARNGING: 目前只有魔君，后面有扩展可以用唯一类型标识
                local effectMap = kLuckyNode.Effect
                if effectMap then
                    for key, effect in pairs(effectMap) do
                        if key == 'Mojun' then
                            effect:SetActive(self.mCurPoolID == 5 and privacyType == SHPCT_CHIVALROUS_6)
                        else
                            effect:SetActive(false)
                        end
                    end
                end
            end
        end

    end
end

-- 设置一个幸运珠进度条的进度
function PinballGameUI:SetLuckyNodeProgress(objProgress, iCount, totalHP)
    if not objProgress then
        return
    end
    iCount = iCount or 0
    self.iMax10ShootRewardProgress = self.iMax10ShootRewardProgress or 1
    local iReverseIndex = nil
    local hpList = objProgress['HPList'] or {}
    local hpDiList = objProgress['HPDiList'] or {}
    local labNum = objProgress['LabNum']

    local totalNum = #hpList
    local lastHP = totalHP - iCount
    local hpCount = (totalNum - lastHP % totalNum) % totalNum
    local hpNum = math.ceil(lastHP / totalNum)

    local color = GetTableData('HoodleHPColor', math.max(hpNum, 1)) or {}
    for index = totalNum, 1, -1 do
        iReverseIndex = self.iMax10ShootRewardProgress - index + 1
        hpList[index].gameObject:SetActive(iReverseIndex > hpCount)
        hpList[index].color = DRCSRef.Color((color.R or 0)/255, (color.G or 0)/255, (color.B or 0)/255, 1)
    end

    if hpNum > 1 then
        local color = GetTableData('HoodleHPColor', hpNum - 1) or {}
        for index = totalNum, 1, -1 do
            hpDiList[index].gameObject:SetActive(true)
            hpDiList[index].color = DRCSRef.Color((color.R or 0)/255, (color.G or 0)/255, (color.B or 0)/255, 1)
        end
        labNum.gameObject:SetActive(true)
        labNum.text = 'x' .. hpNum
    else
        for index = totalNum, 1, -1 do
            hpDiList[index].gameObject:SetActive(false)
        end
        labNum.gameObject:SetActive(false)
    end
end

-- C#层弹珠发射成功时会执行到这个回调
function PinballGameUI:OnPinballShootSuccessfully()
    -- SystemUICall:GetInstance():Toast("成功发射!", false, nil, "PINBALL")
    -- 开启奖池切换tab的禁止点击
    self.iSootingBallCount = (self.iSootingBallCount or 0) + 1
    self.btnRecentGotViewAll.interactable = false
end

-- 点击用户操作按钮
function PinballGameUI:OnClickUserBtn()
    local bEnough = self.kPinballMgr:GetUserUsableHoodleNum() > 0
    if bEnough then
        self:OnClickShoot()
        return
    end
    -- 付费购买小侠客
    local iSinglePrice = self.kPinballMgr:GetUserPaySilver() or 0
    local bIsQuickShoot = self.kPinballMgr:CanUserUseQuickShoot() == true
    local iNeedSilver = iSinglePrice * (bIsQuickShoot and SSD_ONCE_REPEAT_HOODLE_BALL_NUM or 1)
    -- 付费操作
    local doPay = function()
        PlayerSetDataManager:GetInstance():RequestSpendSilverWithTransCheckBox(iNeedSilver, "PinballTransGoldDontNotice", function()
            -- 现在小侠客直接是固定的价格 250, 不走商城商品购买的逻辑
            self:OnClickShoot()
        end)
    end
    -- 如果用户之前勾选了不再提示, 那么直接扣费
    local bDontNoticeLater = GetConfig("PinballDontNotice") == true
    if bDontNoticeLater then
        doPay()
        return
    end
    -- 弹珠不够就提示购买
    local content = nil
    if bIsQuickShoot then
        content = {
            ['title'] = "小侠客不足",
            ['text'] = string.format("小侠客不足, 是否使用%d银锭?", iNeedSilver),
            ['checkBox'] = "以后不再提醒",
            ['bCheckBox'] = false,
            ['btnType'] = "silver",
            ['btnText'] = "购买",
            ['num'] = iNeedSilver,
        }
    else
        content = {
            ['title'] = "侠客行经脉丹",
            ['text'] = string.format("花费%d银锭购买10经脉经验，可获赠一个小侠客", iNeedSilver),
            ['checkBox'] = "以后不再提醒",
            ['bCheckBox'] = false,
            ['btnType'] = "silver",
            ['btnText'] = "购买",
            ['num'] = iNeedSilver,
        }
    end
    local boxCallback = function()
        doPay()
        -- 记录 以后不再提示
        local win = GetUIWindow("GeneralBoxUI")
        if win then
            local bDontNoticeLater = win:GetCheckBoxState() == true
            SetConfig("PinballDontNotice", bDontNoticeLater)
        end
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.Pay_TIP, content, boxCallback})
end

-- 点击发射
function PinballGameUI:OnClickShoot(bUseFreeBall)
    if self.bInitFinish ~= true then
        SystemUICall:GetInstance():Toast("弹珠台玩法初始化中", false, nil, "PINBALL")
        return
    end
    bUseFreeBall = (bUseFreeBall == true)
    -- 测试代码
    -- if self.iTestEnd and (self.iTestEnd >= 0) then
    --     self.comPinballPlayer:ShootBall(self.iTestEnd, self.iTestLuckyNodeFlag, bUseFreeBall)
    --     return
    -- end
    local ePoolType = self.kPinballMgr:GetCurPoolExcelData("PoolType")
    if not ePoolType then
        return
    end

    local curPoolID
    -- WARNING: 暂时去掉切池逻辑
    -- if self.mPinballPool1._gameObject.activeSelf then
    --     local poolData = PinballDataManager:GetInstance():GetPrivacyPool() or {}
    --     curPoolID = poolData["CurID"]
    -- end

    if (not bUseFreeBall) and (self.kPinballMgr:CanUserUseQuickShoot() == true) then
        SendQueryHoodleLotteryInfo(SHLQT_TEN_LOTTERY, ePoolType, false, curPoolID)
    else
        SendQueryHoodleLotteryInfo(SHLQT_START_LOTTERY, ePoolType, bUseFreeBall, curPoolID)

        -- TODO 数据上报
        MSDKHelper:SetQQAchievementData('clickpinball', 1);
        MSDKHelper:SendAchievementsData('clickpinball');
    end
    -- 播放动画
    SetSkeletonAnimation(self.skeletonCurShootDrum, 0, "animation", false)
    SetSkeletonAnimation(self.skeletonCurShootDrumstick, 0, "animation2", false)
    -- 播放音频
    if bUseFreeBall then
        PlaySound(GameSound.ShootFree)
    else
        PlaySound(GameSound.ShootNormal)
    end
end

-- 弹珠全部都掉落
function PinballGameUI:OnPinballShootEnd()
    -- WARNING: 后期池子多了，复杂了，加入事件分发
    if self.mPinballPool1._gameObject.activeSelf then
        self.mPinballPool1:OnPinballShootEnd()
    end
end

-- 收到服务器的下发结果
function PinballGameUI:OnRecvShootBallPath(kRetData, bEnqueueInfo, bDoShoot)
    if not kRetData then
        return
    end
    local kHitSlotInfo = kRetData.kHitSlotInfo
    local iEnd = kHitSlotInfo.dwSlotIndex + 1
    -- 分析并推入幸运柱奖励信息
    local iLuckyNodeFlag = 0
    local kHitInfo = nil
    for index = 0, kRetData.dwHitBoxNum - 1 do
        kHitInfo = kRetData.akBoxInfo[index]
        iLuckyNodeFlag = iLuckyNodeFlag | (1 << kHitInfo.eProgressType)
        if bEnqueueInfo ~= false then
            self:EnqueueNextLuckyNodeInfo(kHitInfo.eProgressType, kHitInfo)
        end
    end
    -- 推入终点槽奖励信息
    if bEnqueueInfo ~= false then
        self:EnqueueNextEndSlotInfo(iEnd, kRetData)
    end
    -- 弹珠路径下行的时候, 服务器下发弹珠的剩余数量
    -- 这里也是唯一一个记录当前有多少10连球(免费球)的地方
    -- TIPS: 设置球数量以及刷新显示, 完全交给球数量的下行 OnRecv_CMD_GAC_HOODLENUMRET
    self.kPinballMgr:SetHoodleAccNum(kRetData.dwAccForTenShootNum or 0)
    -- 发射球
    if bDoShoot ~= false then
        -- 服务器告知这条路径用的是不是免费球
        local bUseFreeBall = (kRetData.bSpecialHoodle == 1)
        local strBallID = self.comPinballPlayer:ShootBall(iEnd, iLuckyNodeFlag, bUseFreeBall)
        -- SystemUICall:GetInstance():Toast(strBallID .. "号球", false, nil, "PINBALL")
        -- 记录当前发射出去的球是什么球
        if not self.IsFreeBallRec then
            self.IsFreeBallRec = {}
        end
        -- 当前发射的免费球计数
        if bUseFreeBall then
            self.IsFreeBallRec[strBallID] = true
            self.iFreeBallCount = (self.iFreeBallCount or 0) + 1
            -- 播放特效
            self.objBoardEffect:SetActive(true)
        else
            self.IsFreeBallRec[strBallID] = nil
        end
    end
end

-- 收到服务器一组下发结果
function PinballGameUI:OnRecvShootBallPathQueue(kQueue)
    if not (kQueue and (#kQueue > 0)) then
        return
    end
    -- 优先一次性推入所有数据, 表现再使用计时器进行
    if not self.kShootTimers then
        self.kShootTimers = {}
    end
    for index, kRetData in ipairs(kQueue) do
        local kToPush = kRetData
        -- 这一次仅推入数据, 不做表现
        self:OnRecvShootBallPath(kToPush, true, false)
        -- 用计时器延迟做表现
        local iTimer = globalTimer:AddTimer(self.fShootPerTime * index, function()
            local win = GetUIWindow("PinballGameUI")
            if not win then
                return
            end
            win.kShootTimers[kToPush] = nil
            -- 这一次仅做表现, 不推入数据
            win:OnRecvShootBallPath(kToPush, false, true)
        end)
        self.kShootTimers[kToPush] = iTimer
    end
end

-- 将下一个终点槽物品的信息入队
function PinballGameUI:EnqueueNextEndSlotInfo(iIndex, kPathData)
    if (not iIndex) or (not kPathData) or (not kPathData.kHitSlotInfo) then
        return
    end
    if (not self.akEndSlotInfoSquence) or (not self.akEndSlotInfoSquence[iIndex]) then
        return
    end
    local kItemInfo = kPathData.kHitSlotInfo.kSlotTip
    local iNextProgress = kPathData.dwSpecialSlotProgress or 0
    local squence = self.akEndSlotInfoSquence[iIndex]
    -- 如果是10连槽, 那么直接使用上一个数据的进度+1, 否则推入下一个drop id
    if iIndex == self.i10ShootRewardIndex then
        local bMax = false
        local iPreProgress = 0
        local kOldInfo = squence[#squence]
        if kOldInfo and kOldInfo.progress then
            iPreProgress = kOldInfo.progress
        end
        if (iPreProgress > 0) and (iNextProgress == 0) then
            bMax = true
        end
        squence[#squence + 1] = {
            ["uiPoolID"] = self.mCurPoolID,
            ["progress"] = iNextProgress,
            ["max"] = bMax,
        }
    else
        -- 记录实时奖励
        local uiRecordIndex = 0
        local uiCurGetRewardItemBaseID = kItemInfo.dwCurRewardItemID or 0
        local uiCurGetRewardItemNum = kItemInfo.dwCurRewardItemNum or 0
        local kCurGetRewardItemBaseData = TableDataManager:GetInstance():GetTableData("Item", uiCurGetRewardItemBaseID)
        if kCurGetRewardItemBaseData then
            uiRecordIndex = self.kPinballMgr:RecordGetReward(self.mCurPoolID, kCurGetRewardItemBaseData, uiCurGetRewardItemNum)
        end
        -- 服务器会在kItemInfo中告诉客户端 当前应该获得的奖励 与 下一个应该替换的奖励
        squence[#squence + 1] = {
            ["uiPoolID"] = self.mCurPoolID,
            ["uiRecordIndex"] = uiRecordIndex,
            ["kItemInfo"] = kItemInfo,
        }
    end
    self.akEndSlotInfoSquence[iIndex] = squence
end

-- 将下一个幸运柱物品的信息入队
function PinballGameUI:EnqueueNextLuckyNodeInfo(iIndex, kHitInfo)
    if (not iIndex) or (not kHitInfo) then
        return
    end
    if not (self.akLuckyNodeInfoSquence and self.akLuckyNodeInfoSquence[iIndex]) then
        return
    end
    local squence = self.akLuckyNodeInfoSquence[iIndex]
    local kItemInfo = kHitInfo.kProgressTip
    local iNextProgress = kHitInfo.dwCurProgress or 0
    local iPreProgress = 0
    local bPreReset = false
    local kOldInfo = squence[#squence]
    if kOldInfo and kOldInfo.progress then
        iPreProgress = kOldInfo.progress
    end
    if kOldInfo and kOldInfo.reset then
        bPreReset = true
    end
    -- 如果进度从大变成0, 说明进度满了
    local bMax = false
    local uiRecordIndex = 0
    if (iPreProgress > 0) and (iNextProgress == 0) then
        bMax = true
        -- 记录实时奖励
        local uiCurGetRewardItemBaseID = kItemInfo.dwCurRewardItemID or 0
        local uiCurGetRewardItemNum = kItemInfo.dwCurRewardItemNum or 0
        local kCurGetRewardItemBaseData = TableDataManager:GetInstance():GetTableData("Item", uiCurGetRewardItemBaseID)
        if kCurGetRewardItemBaseData then
            uiRecordIndex = self.kPinballMgr:RecordGetReward(self.mCurPoolID, kCurGetRewardItemBaseData, uiCurGetRewardItemNum)
        end
    end
    -- 服务器会在kItemInfo中告诉客户端 当前应该获得的奖励 与 下一个应该替换的奖励
    squence[#squence + 1] = {
        ["uiPoolID"] = self.mCurPoolID,
        ["uiRecordIndex"] = uiRecordIndex,
        ["progress"] = iNextProgress,
        ["totalHP"] = kHitInfo['dwTotalHPNum'] or 6,
        ["max"] = bMax,
        ["kItemInfo"] = kItemInfo,
        ['privacyType'] = kHitInfo['ePrivacyType'] or 0,
        ['hide'] = kHitInfo['bHide'] == 1,
        ['reset'] = (iNextProgress > 0) and bPreReset
    }
    self.akLuckyNodeInfoSquence[iIndex] = squence
    
    -- 为了让左边的动画等到切池的时候再播放（找切池前最后一个幸运柱）
    local hideNum = 0
    local showIndex = 0
    for index, queue in pairs(self.akLuckyNodeInfoSquence) do
        local luckyData = queue[#queue]
        if luckyData then
            if luckyData.hide then
                hideNum = hideNum + 1
            else
                showIndex = index
            end
        end 
    end
    
    -- TODO: 这个标记最好叫服务器给吧，不要让客户端算，非常容易出错
    if hideNum == 2 and iIndex == showIndex then
        squence[#squence]['reset'] = true
        self.mReseting = true
    end
end

-- 设置下一个将要显示的最近获得动画图标
function PinballGameUI:UpdateNextRecentGotAnimIcon(itemTypeData)
    if not (self.akAnimIcons and itemTypeData) then
        return
    end
    if not self.iCurAnimIconIndex then
        self.iCurAnimIconIndex = 0
    end
    local iNextIndex = self.iCurAnimIconIndex + 1
    if iNextIndex > self.iMaxAnimIconsIndex then
        iNextIndex = 1
    end
    local kIcoinData = self.akAnimIcons[iNextIndex]
    if not (kIcoinData and kIcoinData.gameObject) then
        return
    end
    self:UpdateItemIcon(kIcoinData.gameObject, itemTypeData)
end

-- 播放最近获得图标特效
function PinballGameUI:PlayRecentGotIconEffect()
    if not self.akAnimIcons then
        return
    end
    -- 使用预设的几个物品图标进行轮播
    if not self.iCurAnimIconIndex then
        self.iCurAnimIconIndex = 0
    end
    if self.iCurAnimIconIndex >= self.iMaxAnimIconsIndex then
        self.iCurAnimIconIndex = 1
    else
        self.iCurAnimIconIndex = self.iCurAnimIconIndex + 1
    end
    local kIconData = self.akAnimIcons[self.iCurAnimIconIndex]
    if not (kIconData and kIconData.canvasGroup and kIconData.gameObject) then
        return
    end
    kIconData.gameObject:SetActive(true)
    -- 如果之前已经开过这个动画, 直接重播这个动画
    if self.twnRecentGotIconEffect and self.twnRecentGotIconEffect[self.iCurAnimIconIndex] then
        local kEffect = self.twnRecentGotIconEffect[self.iCurAnimIconIndex]
        for index, twn in pairs(kEffect) do
            twn:Restart()
        end
        return
    end
    -- 否则, 新建当前索引对应的动画
    local fTime = 2
    local retEffect = {}
    retEffect[1] = Twn_MoveBy_Y(nil, kIconData.gameObject, 280, fTime)
    retEffect[2] = Twn_CanvasGroupFade(nil, kIconData.canvasGroup, 1, 0, fTime, 0, function()
        kIconData.gameObject:SetActive(false)
    end)
    retEffect[1]:SetAutoKill(false)
    retEffect[2]:SetAutoKill(false)
    if not self.twnRecentGotIconEffect then
        self.twnRecentGotIconEffect = {}
    end
    -- 缓存动画数据
    self.twnRecentGotIconEffect[self.iCurAnimIconIndex] = retEffect
end

-- 播放获得物品的特效
function PinballGameUI:PlayGotSlotEffect(eRank)
    if not (eRank and self.eRank2RecentGotEffect and self.eRank2RecentGotEffect[eRank]) then
        return
    end
    local comEffect = self.eRank2RecentGotEffect[eRank]
    comEffect.gameObject:SetActive(true)
    comEffect:Play()
    self:PlayRecentGotIconEffect()
end

-- 获得一个物品奖励
function PinballGameUI:GetItemReward(kItemBaseData, uiCount, uiPoolID, uiRecordIndex)
    if not kItemBaseData then
        return
    end
    -- 设置奖励信息掉落落实
    if self.kPinballMgr then
        self.kPinballMgr:SetRecordGetRewardFall(uiPoolID, uiRecordIndex)
    end
    -- 记录奖励到面板
    -- self.kPinballMgr:RecordGetReward(uiPoolID, kItemBaseData, uiCount)
    if uiPoolID ~= self.mCurPoolID then
        return
    end
    self:UpdateItemIcon(self.objRecentGotIcon, kItemBaseData)
    self:UpdateNextRecentGotAnimIcon(kItemBaseData)
    self.objRecentGotNewSign:SetActive(true)
    self.objRecentGot:SetActive(true)
    if not self.bGetItemToast then
        return
    end
    -- Toast提示
    local strItemName = kItemBaseData.ItemName or ''
    local strMsg = string.format("获得%s x%d", strItemName, uiCount)
    SystemUICall:GetInstance():Toast(strMsg, false, nil, "PINBALL")
    -- 播放特效
    self:PlayGotSlotEffect(kItemBaseData.Rank)
    if kItemBaseData.Rank >= RankType.RT_DarkGolden then
        self:PlayGetTopRewardAnim(kItemBaseData)
    end
end

-- 播放获得奖励高级特效
function PinballGameUI:PlayGetTopRewardAnim(itemTypeData)
    if not itemTypeData then
        return
    end
    -- 高级奖励特效
    self.animTopReward:Stop()
    if self.iTopRewardTimer then
        self:RemoveTimer(self.iTopRewardTimer)
    end
    -- 设置物品名称
    self.textTopReward.text = itemTypeData.ItemName or ''
    local kTableMgr = TableDataManager:GetInstance()
    local bShowIcon = true
    self.objTopRewardCG1:SetActive(false)
    self.objTopRewardCG2:SetActive(false)
    self.objTopRewardPet:SetActive(false)
    self.objTopRewardIcon:SetActive(false)
    local strTitleImg = TopRewardTitle.Item
    -- 如果是角色卡, 设置立绘
    if itemTypeData.ItemType == ItemTypeDetail.ItemType_RolePieces then
        local uiRoleTypeID = itemTypeData.FragmentRole or 0
        local kRoleTypeData = TB_Role[uiRoleTypeID]
        local strDrawing = RoleDataHelper.GetDrawing(kRoleTypeData)
        if strDrawing and (strDrawing ~= "") then
            self.objTopRewardCG1:SetActive(true)
            self.objTopRewardCG2:SetActive(true)
            self.imgTopRewardCG1.sprite = GetSprite(strDrawing)
            self.imgTopRewardCG2.sprite = GetSprite(strDrawing)
            strTitleImg = TopRewardTitle.Role
        end
    elseif itemTypeData.ItemType == ItemTypeDetail.ItemType_PetPieces then
        local uiPetTypeID = tonumber(itemTypeData.Value1) or 0
        local kPetTypeData = kTableMgr:GetTableData("Pet", uiPetTypeID) or {}
        local uiArtID = kPetTypeData.ArtID or 0
        local kModledata = kTableMgr:GetTableData("RoleModel", uiArtID)
        if kModledata then 
            self.kSpineRoleUIMgr:UpdateBaseSpine(self.objTopRewardPet, uiArtID)
            self.objTopRewardPet:SetActive(true)
            self.objTopRewardPet:SetObjLocalScale(-150, 150, 1)
            bShowIcon = false
            strTitleImg = TopRewardTitle.Pet
        end
    end
    -- 显示图标
    if bShowIcon == true then
        self.objTopRewardIcon:SetActive(true)
        self:UpdateItemIcon(self.objTopRewardIcon, itemTypeData, 1, false, false)
    end
    -- 设置标题
    self.imgTopRewardTitle.sprite = GetSpriteInResources(strTitleImg)
    self.objTopRewardAnim:SetActive(true)
    self.animTopReward:Play()
    self.iTopRewardTimer = self:AddTimer(self.iAnimTopRewardTime, function()
        self.animTopReward:Stop()
        self.objTopRewardAnim:SetActive(false)
    end)
end

-- 点击查看所有已获得的奖励
function PinballGameUI:OnClickRecentGotViewAll()
    self.akShowRewardRecord = self.kPinballMgr:GetMergedRewardReocrd(self.mCurPoolID) or {}
    self.svViewAll.totalCount = #self.akShowRewardRecord
    self.svViewAll:RefillCells()
    self.objViewAll:SetActive(true)
    self.objPinballBoard:SetActive(false)
    self.objRecentGotNewSign:SetActive(false)

    local tabName = GetLanguageByID((GetTableData('Hoodle', self.mCurPoolID or 0) or {})['Name'] or 0) or ''
    self.mLabRewardTitle.text = string.format('【%s奖励记录】', tabName)
end

-- 更新奖励记录子节点
function PinballGameUI:UpdateViewAllItemUI(transform, index)
    if not (transform and index) then
        return
    end
    if not self.akShowRewardRecord then
        return
    end
    local iLen = #self.akShowRewardRecord
    if (iLen == 0) or (index >= iLen) then
        return
    end
    -- 逆序显示
    local kItemData = self.akShowRewardRecord[iLen - index]
    if not kItemData then
        return
    end
    self:UpdateItemIcon(transform.gameObject, kItemData.itemTypeData, kItemData.iNum, true, kItemData.IsNew)
    kItemData.IsNew = nil
end

-- 奖励从起点飞到奖励记录处
function PinballGameUI:DynamicPickItemAnim(key, iIndex, itemTypeData, iNum, endfunc, fDuration, targetPos)
    if not self.pickItemData then
        return
    end

    if not targetPos then
        targetPos = self.pickItemData.endPos
        if key == "EnemyNodes" then
            targetPos = self.pickItemData.endPosServerPlay
        end
    end

    if not targetPos then
        if endfunc then 
            endfunc() 
        end
        return
    end
    local index = tostring(iIndex)
    if not self.pickItemData[key] and self.pickItemData[key][index] then
        if endfunc then endfunc() end
        return
    end
    local stratPos = self.pickItemData[key][index].oriPos
    local comTrans = self.pickItemData[key][index].transform
    local obj = self.pickItemData[key][index].gameObject
    local comEffect = self.pickItemData[key][index].effect
    if not (stratPos and comTrans and obj) then
        if endfunc then endfunc() end
        return
    end
    obj:SetActive(false)
    comEffect:Stop()
    comTrans.localPosition = stratPos
    if itemTypeData then
        self:UpdateItemIcon(obj, itemTypeData, iNum or 1)
    end
    obj:SetActive(true)
    local OnComplete = function()  
        obj:SetActive(false)
        if endfunc then endfunc() end
    end
    Twn_Bezier(comTrans, stratPos, targetPos, 240, OnComplete, 30,fDuration, DRCSRef.Ease.InQuart)
end

-- 点击概率公示Tips
function PinballGameUI:OnClickShowRateTips()
    local rateTip
    if self.mPinballPool1._gameObject.activeSelf then
        rateTip = {
            ['kind'] = 'wide',
            ['title'] = "侠客行-白衣探宝概率公示",
            ['titlecolor'] = DRCSRef.Color.white,
            ['content'] = GetLanguageByID(589),
        }
    else--[[if self.objServerPlay.activeSelf then]]
        rateTip = {
            ['kind'] = 'wide',
            ['title'] = "侠客行-拯救阿月概率公示",
            ['titlecolor'] = DRCSRef.Color.white,
            ['content'] = GetLanguageByID(517),
        }
    end
    OpenWindowImmediately("TipsPopUI", rateTip)
end

-- 接受到获得暗金奖励事件
function PinballGameUI:OnNotifyGetDarkReward(strMsg, strName)
    -- 如果是自己获得了奖励, 那么缓存起来等到球掉落到终点的时候再显示
    -- 否则直接显示
    if strName and (strName ~= "")
    and (strName == PlayerSetDataManager:GetInstance():GetPlayerName(true)) then
        if (not self.kGetDarkRewardNotifyCacheTail)
        or (not self.kGetDarkRewardNotifyCacheHead) then
            self.kGetDarkRewardNotifyCacheHead = {['text'] = strMsg}
            self.kGetDarkRewardNotifyCacheTail = self.kGetDarkRewardNotifyCacheHead
        else
            self.kGetDarkRewardNotifyCacheTail['next'] = {['text'] = strMsg}
            self.kGetDarkRewardNotifyCacheTail = self.kGetDarkRewardNotifyCacheTail['next']
        end
        return
    end
    self:SetGetRewardNotice(strMsg)
end

-- 显示自己的下一条暗金奖励通知
function PinballGameUI:SetMyNextGetRewardNotice()
    if not self.kGetDarkRewardNotifyCacheHead then
        return
    end
    self:SetGetRewardNotice(self.kGetDarkRewardNotifyCacheHead['text'] or "")
    self.kGetDarkRewardNotifyCacheHead = self.kGetDarkRewardNotifyCacheHead['next']
    if not self.kGetDarkRewardNotifyCacheHead then
        self.kGetDarkRewardNotifyCacheTail = nil
    end
end

-- 显示获奖全服通知
function PinballGameUI:SetGetRewardNotice(strMsg)
    self.textNotice.text = strMsg or ""
end

function PinballGameUI:ShowGlobal()
    if self.mPinballPool1._gameObject.activeSelf then
        return
    end

    self.objServerPlay:SetActive(true)
end

function PinballGameUI:OnDestroy()
    -- 强制保存记录
    self.kPinballMgr:SaveLocalRec(true)
    -- 释放弹珠控制台资源
    self.comPinballPlayer:Clear()
    self.ItemIconUIInst:Close()
    self.PinballServerPlayInst:Close()
    self.kSpineRoleUIMgr:Close()
    self.mPinballPool1:Close()
    -- 关闭dotwn动画
    if self.comEffectRewardBox then
        for index, coms in pairs(self.comEffectRewardBox) do
            if coms.twn then
                coms.twn:DOKill()
            end
        end
        self.comEffectRewardBox = nil
    end
    if self.twnRecentGotIconEffect and next(self.twnRecentGotIconEffect) then
        for index, kEffect in pairs(self.twnRecentGotIconEffect) do
            for index, twn in ipairs(kEffect) do
                twn:Kill(false)
            end
        end
        self.twnRecentGotIconEffect = nil
    end
end

return PinballGameUI
