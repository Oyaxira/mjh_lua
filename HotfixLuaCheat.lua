function HotFixTest()
    dprint('--HotFixTest--',3)
end

function ReleasePoolSmart()
    dprint('--ReleasePoolSmart--',1)
    DRCSRef.ResourceManager:ReleasePoolSmart(120)
    ClearSkillObjectToPool()
end

function RunKungfuTest()
    DisplayActionManager:GetInstance():MazeShowBubble(0, 1000001208, "contentStrcontentStr")
end

function OpenTaskUI()
    WINDOW_ORDER_INFO['TaskUI'].order = 400
    OpenWindowImmediately("TaskUI")
end

function CloseTaskUI()
    WINDOW_ORDER_INFO['TaskUI'].order = 300
    RemoveWindowImmediately("TaskUI")
end

function TestTween()
    local kUnit = UnitMgr:GetInstance():GetUnit(3)
    for i=1,1 do
        -- kUnit:ShowNumber(10,COLOR_BATTLE_ZHENQI,false)
        BattleCamera:DOShakePosition(1, DRCSRef.Vec3(1,1,1),10,90,false)
    end
end

function OpenMemorise()
    OpenWindowImmediately("MemoriesUI")
end

function CloseMemorise()
    RemoveWindowImmediately("MemoriesUI")
end

function OpenComicPlotUI()
    OpenWindowImmediately("ComicPlotUI")
end

function OpenChoiceUI()
    OpenWindowImmediately("ChoiceUI")
end

function CloseComicPlotUI()
    RemoveWindowImmediately("ComicPlotUI")
end

function MakeErrorBugly()
    local a = 1/0
    local b = 1 + nil
    return a + b
end

function MakeErrorBuglyXPCall()
    xpcall(MakeErrorBugly,showError)
end

function LiuMaiTest()
    package.loaded["Animation/EffectType/QiShiErFengFeiJianAnimation"] = nil
    QiShiErFengFeiJianAnimation = require ("Animation/EffectType/QiShiErFengFeiJianAnimation")
    TimeLineHelper:GetInstance().SkillEffectTypeMap[6] = QiShiErFengFeiJianAnimation.new()
end

function ChangeFPS(num)
    num = num or 60
    CS.UnityEngine.Application.targetFrameRate = num
end

function TestCrash()
    HandMakeCrash()
end

function Test_DoTween_SetRelative()
    BattleCamera.transform:DOMove(DRCSRef.Vec3(0,1,0),1):SetRelative()
    BattleCamera.transform:DOMove(DRCSRef.Vec3(1,0,0),1):SetRelative()
end

function Test_ShowState()
    PlayButtonSound("EventBattleWin")
    -- MoveCameraPosition(nil,0,-1,-1,0,1000,0,1000)
end

local IsNotAllSimpleChinese = function(str)
	local strList = {utf8.codepoint(str,1,-1)}
    for i=1,#strList do
        strList[i] = utf8.char(strList[i])
	end
	local hanziConvertDict = reloadModule('Base/hanziConvertDict')
	for i=1,#strList do
		if not hanziConvertDict[strList[i]] then 
			return true
		end
	end
	return false
end

function Test_Check_Name_SimpleChinese()
	local TB_RoleName = TableDataManager:GetInstance():GetTable("RoleName")
    for int_i = 1, #TB_RoleName do
        for family_id = TB_RoleName[int_i].MinTextID,TB_RoleName[int_i].MaxTextID do
			family_name = GetLanguageByID(family_id)
            if IsNotAllSimpleChinese(family_name) then 
                DRCSRef.Log(family_name)
            end
        end
	end
end

function Test_Check_Language_SimpleChinese()
    local TB_Language = require("Data/Language")

    for k,info in pairs(TB_Language) do
        family_name = info.Ch_Text
        if IsNotAllSimpleChinese(family_name) then 
            DRCSRef.Log(family_name)
        end
	end
end

function Testparnum(more)
    ParticleSystems = DRCSRef.FindGameObj("UILayerRoot"):GetComponentsInChildren(DRCSRef_Type.ParticleSystem)
	comParticleSystemList = ArrayToTable(ParticleSystems)
    for i=1, #comParticleSystemList do
        local num = comParticleSystemList[i].main.maxParticles
        if more then 
            comParticleSystemList[i].main.maxParticles = num * 2
        else
            comParticleSystemList[i].main.maxParticles = num / 2 
        end
    end

end

function TestBattleAI()
    BattleAIDataManager:GetInstance():Clear()
end

function TestShopBeg(value1, value2)
    ShoppingDataManager:GetInstance():SetBegValue({ iValue = tonumber(value1 or 0), iSelfValue = tonumber(value2 or 0) });
end

-------- 资源加载测试
function TestLoad()
    -- local sPath = "UI/UIPrefabs/Battle/bossComing"
    local sPath = "UI/UISprite/MapBG/sc_bg_bai2tuo2shan1"
    local lt = os.clock()
    -- for i=1,10000 do
        local prefab = DRCSRef.AssetBundleLoad(sPath, typeof(CS.UnityEngine.Texture))

    -- end
    DRCSRef.Log(prefab:GetType())
    DRCSRef.Log("spend " .. os.clock() - lt)
end

function TestRePlay()
    local path = "Effect/Eff/com/LaserEffect"
    local prefab = LoadPrefab(path, typeof(CS.UnityEngine.GameObject))
    local obj = DRCSRef.ObjInit(prefab,TIPS_Layer.transform)
    local lineEffect = CreateLineEffect(obj,2,2,0.4,0)
    lineEffect:SetBeginPos(-6,0,0)
    lineEffect:SetEndPos(6,0,0)
    lineEffect:StartDraw()
    --lineEffect:SetRadianPos(radianPosX,radianPosY,radianPosZ)
end

function TextJson()
    local configData = {[0] = 0,[1] = 1,[2] = 2,[3] = 3}
    local dkJson = require("Base/Json/dkjson")
    local str = dkJson.encode(configData) 
    DRCSRef.Log(str)
    local info = dkJson.decode(str)
    print(info[1])
end

--[[------------------------------------------------------------------------------
-** 设置table只读 出现改写会抛出lua error
-- 用法 local cfg_proxy = read_only(cfg)  retur cfg_proxy
-- 增加了防重置设置read_only的机制
-- lua5.3支持 1）table库支持调用元方法，所以table.remove table.insert 也会抛出错误，
--               2）不用定义__ipairs 5.3 ipairs迭代器支持访问元方法__index，pairs迭代器next不支持故需要元方法__pairs
-- 低版本lua此函数不能完全按照预期工作
*]]
function read_only(inputTable)
    local travelled_tables = {}
    local function __read_only(tbl)
        if not travelled_tables[tbl] then
            local tbl_mt = getmetatable(tbl)
            if not tbl_mt then
                tbl_mt = {}
                setmetatable(tbl, tbl_mt)
            end

            local proxy = tbl_mt.__read_only_proxy
            if not proxy then
                proxy = {}
                tbl_mt.__read_only_proxy = proxy
                local proxy_mt = {
                    __index = tbl,
                    __newindex = function (t, k, v) error("error write to a read-only table with key = " .. tostring(k)) end,
                    __pairs = function (t) return pairs(tbl) end,
                    -- __ipairs = function (t) return ipairs(tbl) end,   5.3版本不需要此方法
                    __len = function (t) return #tbl end,
                    __read_only_proxy = proxy
                }
                setmetatable(proxy, proxy_mt)
            end
            travelled_tables[tbl] = proxy
            for k, v in pairs(tbl) do
                if type(v) == "table" then
                    tbl[k] = __read_only(v)
                end
            end
        end
        return travelled_tables[tbl]
    end
    return __read_only(inputTable)
end

function CheatQMPI()
    MidasHelper:QueryMPInfo()
end

function SendFakeBuyStoreMsg(...)
    local params = {...}
    local shopID = tonumber(params[1])
    local itemID = tonumber(params[2])
    local itemCount = tonumber(params[3])
    local mapID = tonumber(params[4])
    local mazeBaseID = tonumber(params[5])
    local roleBaseID = tonumber(params[6])
    local akItemList = {}
    akItemList[0] = {
        ['uiItemID'] = itemID,
        ['uiItemNum'] = itemCount or 1,
    }
    SendClickShop(CST_BUY, shopID, 1, akItemList, mapID, mazeBaseID, roleBaseID)
end

function SendFakeSellStoreMsg(...)
    local params = {...}
    local shopID = tonumber(params[1])
    local itemID = tonumber(params[2])
    local itemCount = tonumber(params[3])
    local mapID = tonumber(params[4])
    local mazeBaseID = tonumber(params[5])
    local roleBaseID = tonumber(params[6])
    local akItemList = {}
    akItemList[0] = {
        ['uiItemID'] = itemID,
        ['uiItemNum'] = itemCount or 1,
    }
    SendClickShop(CST_SELL, shopID, 1, akItemList, mapID, mazeBaseID, roleBaseID)
end

function SendFakeBuyMallRackMsg(...)
    local params = {...}
    local shopID = tonumber(params[1])
    local iDiscount = tonumber(params[2])
    SendPlatShopMallBuyItem(shopID, iDiscount)
end

function SendFakeCarryAchieveRewardMsg(...)
    local params = {...}
    local achieveRewardIDList = {}
    for _, achieveRewardID in ipairs(params) do 
        table.insert(achieveRewardIDList, tonumber(achieveRewardID))
    end
    -- 先发送难度选择消息
    SendClickDiffChoose(g_selectStoryDiff or 1)
    -- 再发送成就选择消息
    SendAchieveRewardScript(achieveRewardIDList)
    -- 再发送创角消息
    SendClickCreateMainRole()
    -- 创角比较特殊,服务器端是队列的形式,需要做Loading
    OpenWindowImmediately("LoadingUI")
    g_CreateRoleWaitingLoadingFlag = true
    -- 这里做一个Timer
    globalTimer:AddTimer(5000, function()
        if(g_CreateRoleWaitingLoadingFlag) then
            SystemUICall:GetInstance():Toast("本次创建角色失败，请重新开启游戏。若多次失败，请在官方Q群（423860584）联系客服阿月进行反馈。")
        end
    end, 1);
    RemoveWindowImmediately("AchieveRewardUI",false)
end

function SendFakeCarryAchieveRewardMsg(...)
    SendClickItemForgeCMD(103, 20, 10)
end

function GMOpenStoreUI(...)
    OpenWindowImmediately("StoreUI", 59)
end

function SendFakeForgeItemMsg(...)
    local params = {...}
    local forgeMakeID = tonumber(params[1])
    local forgeNpcID = tonumber(params[2])
    local itemCount = tonumber(params[3])
    local mapID = tonumber(params[4])
    local mazeBaseID = tonumber(params[5])
    local roleBaseID = tonumber(params[6])
    SendClickItemForgeCMD(forgeMakeID, forgeNpcID, itemCount, mapID, mazeBaseID, roleBaseID)
end

function SendSomeAutoBattleMsg(...)
    local params = {...}
    local count = tonumber(params[1])
    if count <= 0 then 
        count = 1
    end
    for i = 1, count do 
        local data = EncodeSendSeGC_Click_Battle_Auto(0)
        local iSize = data:GetCurPos()
        NetGameCmdSend(SGC_CLICK_BATTLE_AUTO,iSize,data)
    end
end

function SendCheatShopBuyCmd(...)
    local params = {...}
    local typeid = tonumber(params[1])
    local count = tonumber(params[2])

    for i = 1, count do
        SendPlatShopMallBuyItem(typeid, 1)
    end
end

function SendFakePickMapAdvLootMsg(...)
    local params = {...}
    local mapID = tonumber(params[1]) or 0
    local advLootIndex = tonumber(params[2]) or 0
    AdvLootManager:GetInstance():PickUpAdvLoot(0, mapID, advLootIndex, advLootIndex, advLootIndex)
end

function SendFakePickMapDynAdvLootMsg(...)
    local params = {...}
    local advLootID = tonumber(params[1]) or 0
    AdvLootManager:GetInstance():PickUpAdvLoot(3, advLootID, advLootID, advLootID, advLootID)
end

function SendFakePickMazeAdvLootMsg(...)
    local params = {...}
    local advLootID = tonumber(params[1]) or 0
    AdvLootManager:GetInstance():PickUpAdvLoot(1, advLootID, advLootID, advLootID, advLootID)
end

function SendFakePickMazeDynAdvLootMsg(...)
    local params = {...}
    local advLootID = tonumber(params[1]) or 0
    AdvLootManager:GetInstance():PickUpAdvLoot(2, advLootID, advLootID, advLootID, advLootID)
end

function SendFakeSelectSubmitItem(...)
    local params = {...}
    local taskID = tonumber(params[1]) or 0
    local taskEdgeID = tonumber(params[2]) or 0
    local finalSubmitItem1 = tonumber(params[3]) or 0
    local finalSubmitItemCount1 = tonumber(params[4]) or 0
    local finalSubmitItem2 = tonumber(params[5]) or 0
    local finalSubmitItemCount2 = tonumber(params[6]) or 0
    local count = 0
    local finalSubmit = {}
    if finalSubmitItem1 ~= 0 then 
        finalSubmit[count] = {
            uiItemID = finalSubmitItem1,
            uiItemNum = finalSubmitItemCount1
        }
        count = count + 1
    end
    if finalSubmitItem2 ~= 0 then 
        finalSubmit[count] = {
            uiItemID = finalSubmitItem2,
            uiItemNum = finalSubmitItemCount2
        }
        count = count + 1
    end
    SendSelectSubmitItem(taskID, taskEdgeID, count, finalSubmit)
end

