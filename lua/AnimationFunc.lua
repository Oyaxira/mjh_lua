-- 判断指定spine的GameObject是否有对应的动作
function HasAction(objSpine, actionName)
    if objSpine == nil then 
        return false
    end
    local comSkeletonAnimation = objSpine:GetComponent("SkeletonAnimation")
    local comSkeletonGraphic = objSpine:GetComponent("SkeletonGraphic")
    if comSkeletonAnimation == nil and comSkeletonGraphic == nil then 
        return false
    end
    if comSkeletonAnimation ~= nil then 
        local list = comSkeletonAnimation:GetSkeletonAnimationTimeList()
        for index = 0, list.Count - 1 do 
            local animData = list[index]
            if animData ~= nil and animData.name == actionName then 
                return true
            end
        end
    elseif comSkeletonGraphic ~= nil then
        local list = comSkeletonGraphic:GetSkeletonAnimationTimeList()
        for index = 0, list.Count - 1 do 
            local animData = list[index]
            if animData ~= nil and animData.name == actionName then 
                return true
            end
        end
    end
    return false
end

-- 获取指定spine指定动作指定帧的时间，不传帧名时返回指定动作时间
function getActionFrameTime(uiModelID,actionName,frameName)
    local value_1 = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime", uiModelID)
    if value_1 == nil then return 0 end
    local value_2 = value_1[actionName]
    if value_2 == nil then return 0 end
    if frameName == nil then return value_2[1] or 0 end
    local value_3 = value_2[frameName]
    if value_3 == nil then return 0 end
    return value_3[1] or 0
end

-- 获取指定spine指定动作指定帧的时间，不传帧名时返回指定动作时间
function HasActionFrameTime(uiModelID,actionName)
    local value_1 = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime", uiModelID)
    if value_1 == nil then return false end
    local value_2 = value_1[actionName]
    if value_2 == nil then return false end
    return true
end

_SKILL_OBJECT_POOL = {}
function GetSkillObjectFromPool(sPath,parent)
    local obj 
    if _SKILL_OBJECT_POOL[sPath] and #_SKILL_OBJECT_POOL[sPath] > 0 then
        obj = table.remove(_SKILL_OBJECT_POOL[sPath])
        if not IsValidObj(obj.gameObject) then 
            dprint('123')
        end
        obj.transform:SetParent(parent.transform)
        obj:SetActive(true)
        obj:RestoreScale()
    else
        obj = Object.new(sPath,parent)
        if obj:InitFailed() then 
            return nil
        end
        -- 对旧动画的特殊处理，缩小0.5倍
        if obj.SkeletonAnimation then 
            obj:Scale(0.5)
        end
        obj:SaveScale()
    end
    return obj
end

function ReturnSkillObjectToPool(obj)
    obj:SetActive(false)
    local sPath = obj.prefabPath
    _SKILL_OBJECT_POOL[sPath] = _SKILL_OBJECT_POOL[sPath] or {}
    table.insert(_SKILL_OBJECT_POOL[sPath],obj)
end

-- 临时做法，等战斗资源加载优化后修改
function ClearSkillObjectToPool()
    for k,objects in pairs(_SKILL_OBJECT_POOL) do
        for k,obj in pairs(objects) do
            obj:Destroy()
        end
    end
    _SKILL_OBJECT_POOL = {}
end

-- 添加预制体到指定世界坐标
function AddPrefabToWorldPos(sPath,WorldX,WorldY,WorldZ,depth,parent)
    local TempParent = LogicMain:GetInstance().objActorNode
    local obj = GetSkillObjectFromPool(sPath,parent or TempParent)
    if obj and WorldX and depth then 
        obj:SetPostion(WorldX,WorldY,WorldZ)
        obj:SetSortingOrder(depth)
        return obj
    end
end

-- 添加预制体到指定的unit上，并跟随
function AddPrefabToSpinePos(sPath,x,y,z,boneName,depth,parent,SkeletonRenderer)
    local obj = GetSkillObjectFromPool(sPath,parent)
    if obj then 
        obj:SetPostion(x,y,z)
        if boneName then 
            obj:FollowerBone(boneName,SkeletonRenderer)
        end
        obj:SetSortingOrder(depth)
        return obj
    end
end

-- 获取bone的世界坐标
function GetSpineBoneWorldPos(spine,boneName)
    if spine == nil then return end
    boneName = boneName or "root"
    local skeletonAnimation = spine:GetComponent("SkeletonAnimation")
    local skeleton = skeletonAnimation.skeleton
    local bone = skeleton:FindBone(boneName)
    if bone then --TODO:写工具离线检测
        return bone.WorldX,bone.WorldY 
    end
    return 0,0
end

-- 通过所在格子获取深度
function GetDepthByGridPos(iGridX,iGridY)
    return (SSD_BATTLE_GRID_WIDTH * SSD_BATTLE_GRID_HEIGHT - ((iGridY) * SSD_BATTLE_GRID_WIDTH - iGridX)) * 10
end

-- 不受timescale影响
function MyDOTween(object,tween,...)
    return object[tween](object,...):SetUpdate(DRCSRef.UpdateType.Normal,true)
end



-------- 添加track的辅助接口
function AddTrack(track)
    TimeLineHelper:GetInstance():AddTrack(track)
end

-- 添加单位动作
function AddUnitTrack(unit,startTime,durationTime,animationName)
    AddTrack(UnitAnimationTrack.new(startTime,durationTime,unit,animationName))
end

-- 添加特效动作
function AddObjTrack(object,startTime,durationTime,animationName,bLoop)
    AddTrack(ObjAnimationTrack.new(startTime,durationTime,object,animationName,bLoop))
end

-- 添加tweener控制
function AddTrackTweener(tweener,startTime,durationTime)
    if startTime then 
        AddTrack(TweenerTrack.new(startTime,durationTime,tweener))
    end
end

-- 添加函数控制
function AddTrackUnitFunc(unit,startTime,funcName,...)
    if startTime then 
        AddTrack(UnitFunctionTrack.new(startTime,nil,unit,funcName,...)
    )
    else
        unit[funcName](unit,...)
    end
end

-- 添加函数控制
function AddTrackFunc(startTime,funcName,...)
    AddTrack(FunctionTrack.new(startTime,nil,funcName,...))
end


-- 添加匿名函数
function AddTrackLambda(startTime,Lambda)
    AddTrack(LambdaTrack.new(startTime,nil,Lambda))
end

-- 添加音效
function AddTrackSound(startTime,soundID)
    AddTrack(SoundTrack.new(startTime,nil,soundID))
end
-----------------------------------------------------

--------------------全屏效果---------------------------------
SceneEffectName = {
    "CameraShake",
    "ChangeSceneColor",
    "ScaleCamera",
    "ChangeBattleSpeed",
    "HideBattleSceneLayer",
    "PlayBattleSound",
    "ChangeAttackerSpeed",
    "MoveCameraPosition",
    "FocusCasePosition",
    "FocusAttacker",
}
function ProcessScene(effectInfo,SeBattle_HurtInfo,startTime)
    if effectInfo then 
        local funcName = SceneEffectName[effectInfo[1]]
        local func = _G[funcName]
        if func then 
            func(SeBattle_HurtInfo,startTime,table.unpack(effectInfo,2,100))
        end
    end
end


-- 隐藏战斗场景的其他界面
function HideBattleSceneLayer(SeBattle_HurtInfo,startTime,int_hideTime,int_waitTime,boolean_hideAttacker,boolean_hideDefender,boolean_hideOther)
    int_hideTime = int_hideTime or 0 
    int_waitTime = int_waitTime or 0
    startTime = startTime + int_waitTime
    AddTrackFunc(startTime,"ShowBattleScene",false)

    if boolean_hideAttacker then 
        local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
        if attackerUnit then
            AddTrackUnitFunc(attackerUnit,startTime,"Show",false)
        end
    end

    if boolean_hideDefender then 
        local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
        local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
        for i=1,Se_targetsNum do
            local Se_targetInfo = Se_targetsInfo[i-1]
            local targetUnit = UnitMgr:GetInstance():GetUnit(Se_targetInfo.iTargetUnitIndex)
            if targetUnit then
                AddTrackUnitFunc(targetUnit,startTime,"Show",false)
            end
        end
    end

    if boolean_hideOther then 
        dprint("存在使用未处理的特效参数 boolean_hideOther")
    end
    startTime = startTime + int_hideTime

    AddTrackFunc(startTime,"ShowBattleScene",true)

    if boolean_hideAttacker then 
        local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
        if attackerUnit then
            AddTrackUnitFunc(attackerUnit,startTime,"Show",true)
        end
    end

    if boolean_hideDefender then 
        local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
        local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
        for i=1,Se_targetsNum do
            local Se_targetInfo = Se_targetsInfo[i-1]
            local targetUnit = UnitMgr:GetInstance():GetUnit(Se_targetInfo.iTargetUnitIndex)
            if targetUnit then
                AddTrackUnitFunc(targetUnit,startTime,"Show",true)
            end
        end
    end
end

--功能：相机震动
--int_ShakeType : 震动类型， 1 水平 2垂直 3随机
--int_shakePower:震动强度
--int_shakeTime:震动持续 单位ms
--int_waitTime:延迟时间 单位ms
--int_ShakeCount:震动次数 默认10
local MoveCameraPosition_init = nil
local MoveOffset = DRCSRef.Vec3(0,0,0)
local ShakeOffset = DRCSRef.Vec3(0,0,0)
local lVec3_1_0_0 = DRCSRef.Vec3(1,0,0)
local lVec3_0_1_0 = DRCSRef.Vec3(0,1,0)
function CameraShake(SeBattle_HurtInfo,startTime,int_shakePower,int_shakeTime,int_waitTime,int_x,int_y,int_z,int_ShakeCount)
    if UI_Camera == nil then return end
    local camera = UI_Camera
    if MoveCameraPosition_init == nil then 
        MoveCameraPosition_init = camera.transform.position
    end
    startTime = startTime + (int_waitTime or 0)
    int_shakeTime = int_shakeTime or 1000
    int_waitTime = int_waitTime or 0
    
    int_shakeTime = int_shakeTime * 0.001
    int_waitTime = int_waitTime * 0.001

    int_x = (int_x or 0.0) * 1.0
    int_y = (int_y or 0.0) * 1.0
    int_z = (int_z or 0.0) * 1.0
    
    local durWhole = int_shakeTime + int_waitTime
    local int_randTime = int_waitTime
    local tween
    local desc = 1
    tween = DRCSRef.DOTween.To(function(iCurValue)
        if iCurValue > durWhole then
            ShakeOffset.x,ShakeOffset.y,ShakeOffset.z = 0,0,0
            camera.transform.localPosition = MoveCameraPosition_init + MoveOffset
            return
        end
        ShakeOffset.x = (math.random() * 2 * int_x - int_x )*desc
        ShakeOffset.y = (math.random() * 2 * int_y - int_y )*desc
        ShakeOffset.z = (math.random() * 2 * int_z - int_z )*desc
        desc = desc * 0.9
        local p = MoveCameraPosition_init + MoveOffset + ShakeOffset
        camera.transform.localPosition = p
    end, 0, durWhole + 1, durWhole + 1)
    AddTrackTweener(tween,startTime,durWhole)
end

-- 场景初始颜色
ChangeSceneColor_init = {}
-- 战斗场景变色
function ChangeSceneColor(SeBattle_HurtInfo,startTime,color_finalcolor,int_fadeinTime,int_waitTime,int_continueTime,int_fadeoutTime,boolean_add, changeRole)
    int_fadeinTime = int_fadeinTime or 0 
    int_waitTime = int_waitTime or 0
    int_continueTime = int_continueTime or 0
    int_fadeoutTime = int_fadeoutTime or int_fadeinTime
    startTime = startTime + (int_waitTime or 0)

    local resumeTime = startTime + int_fadeinTime + int_continueTime
    local finalColor = ColorHex2RGB(color_finalcolor)

    --  记录攻击者和受击者
    if changeRole then
        local keyUnitMap = {}
        if SeBattle_HurtInfo then
            keyUnitMap[SeBattle_HurtInfo.iOwnerUnitIndex] = true
    
            local damageNum = SeBattle_HurtInfo.iSkillDamageData
            local dameageList = SeBattle_HurtInfo.akSkillDamageData
            for i=1, damageNum do
                local targetInfo = dameageList[i-1]
                keyUnitMap[targetInfo.iTargetUnitIndex] = true
            end
            
            local unitList = UnitMgr:GetInstance():GetAllUnit()
            if unitList then 
                for k,unitInfo in pairs(unitList) do
                    if keyUnitMap[unitInfo:GetUnitIndex()] ~= true then
                        AddTrackLambda(startTime, function()
                            ColorOutShaps(unitInfo.gameObject, int_fadeinTime / 1000, DRCSRef.Color.black, finalColor)
                        end)
                        
                        AddTrackLambda(resumeTime, function()
                            ColorOutShaps(unitInfo.gameObject, int_fadeoutTime / 1000, DRCSRef.Color.black, DRCSRef.Color.white)
                        end)
                    end
                end
            end
        end
    end

    local btbg_thl = LogicMain:GetInstance().battleSceneBG
    if btbg_thl then 
        local transform_btbg_thl = btbg_thl.transform
        for i=1,transform_btbg_thl.childCount do
            local kSpriteRenderer= transform_btbg_thl:GetChild(i-1):GetComponent("SpriteRenderer")	
            if kSpriteRenderer then
                local color = kSpriteRenderer.color
                if ChangeSceneColor_init[i] == nil then 
                    ChangeSceneColor_init[i] = color--DRCSRef.Color(color.r,color.g,color.b,color.a)
                end

                local tweener = kSpriteRenderer:DOColor(finalColor,int_fadeinTime/1000)
                AddTrackTweener(tweener,startTime,startTime)
                
                tweener = kSpriteRenderer:DOColor(ChangeSceneColor_init[i],int_fadeoutTime/1000)
                AddTrackTweener(tweener,resumeTime,resumeTime+int_fadeoutTime)
            end
        end
    end
end

--功能：相机移动
--int_movePosX:x方向移动，不移动可以不填 世界坐标！
--int_movePosY:y方向移动，不移动可以不填 世界坐标！
--int_movePosZ:z方向移动，不移动可以不填 世界坐标！
--int_iMoveTime:移动时间
--int_waitTime:延迟时间 单位ms
--bool_finalGoBack:动画完成后是否回到初始位置
--int_keepTime:停顿时间 单位ms
function MoveCameraPosition(SeBattle_HurtInfo,startTime,int_movePosX,int_movePosY,int_movePosZ,int_iMoveTime,int_waitTime,int_gobackTime,int_keepTime)
    if UI_Camera == nil then return end
    startTime = startTime + (int_waitTime or 0)
    local camera = UI_Camera
    if MoveCameraPosition_init == nil then 
        MoveCameraPosition_init = camera.transform.localPosition
    end
    int_movePosZ = (int_movePosZ or 0)
    int_movePosX = (int_movePosX or 0)
    int_movePosY = (int_movePosY or 0)
    int_iMoveTime = int_iMoveTime or 1000
    int_waitTime = int_waitTime or 0
    int_gobackTime = int_gobackTime or 0
    int_keepTime = int_keepTime or 0

    int_iMoveTime = int_iMoveTime * 0.001
    int_waitTime = int_waitTime * 0.001
    int_gobackTime = int_gobackTime * 0.001
    int_keepTime = int_keepTime * 0.001
    if int_iMoveTime < 0.001 then
        int_iMoveTime = 0.001
    end
    local durGo = int_iMoveTime + int_waitTime
    local durKeep = durGo + int_keepTime
    local durWhole = durKeep + int_gobackTime
    local endPos = DRCSRef.Vec3(int_movePosX,int_movePosY, int_movePosZ)
    local speed = endPos / int_iMoveTime
    local speed2 = 0
    if int_gobackTime > 0.001 then
        speed2 = endPos/ int_gobackTime
    end
    local tween
    tween = DRCSRef.DOTween.To(function(iCurValue)        
        if iCurValue >= durWhole then
            MoveOffset.x,MoveOffset.y,MoveOffset.z = 0,0,0
            camera.transform.localPosition = MoveCameraPosition_init + ShakeOffset
            
            --local p = camera.transform.localPosition
            --derror(p.x, p.y, p.z,iCurValue, 'eee')
            return
        end

        if iCurValue < int_waitTime then
            return
        end
        if iCurValue < durGo then
            MoveOffset = speed * (iCurValue - int_waitTime)
        elseif iCurValue < durKeep then
        else
            MoveOffset = endPos - speed2 * (iCurValue - durKeep)
        end

        camera.transform.localPosition = MoveCameraPosition_init + MoveOffset + ShakeOffset        
    end, 0, durWhole + 1, durWhole + 1)
end

function FocusAttacker(SeBattle_HurtInfo,startTime,int_iMoveTime,int_waitTime,int_gobackTime,int_keepTime)
    startTime = startTime + (int_waitTime or 0)
    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit then
        local targetPos = GetPosByGrid(attackerUnit.iGridX,attackerUnit.iGridY)
        MoveCameraPosition(SeBattle_HurtInfo,startTime,targetPos.x,targetPos.y,targetPos.z,int_iMoveTime,int_waitTime,int_gobackTime,int_keepTime)
    end
end

function FocusCasePosition(SeBattle_HurtInfo,startTime,int_iMoveTime,int_waitTime,int_gobackTime,int_keepTime)
    startTime = startTime + (int_waitTime or 0)
    local targetPos = GetPosByGrid(SeBattle_HurtInfo.iCastPosX,SeBattle_HurtInfo.iCastPosY)
    MoveCameraPosition(SeBattle_HurtInfo,startTime,targetPos.x,targetPos.y,targetPos.z,int_iMoveTime,int_waitTime,int_gobackTime,int_keepTime)
end

function ScaleCamera(SeBattle_HurtInfo,startTime,number_scale,int_moveTime,int_waitTime)
    MoveCameraPosition(SeBattle_HurtInfo,startTime,0,0,0.4 * (number_scale or 0),int_moveTime,int_waitTime)
end


function ChangeBattleSpeed(SeBattle_HurtInfo,startTime,number_speed,int_time,int_waitTime)
    startTime = startTime + (int_waitTime or 0)
    AddTrackFunc(startTime,"SetSpeed",SPEED_TYPE.SKILL,number_speed)
    startTime = startTime + (int_time or 0)
    AddTrackFunc(startTime,"SetSpeed",SPEED_TYPE.SKILL,0)
end

function PlayBattleSound(SeBattle_HurtInfo,startTime,int_id,int_waitTime)
    if int_id then 
        startTime = startTime + (int_waitTime or 0)
        AddTrackSound(startTime,int_id)
    end
end

function ChangeAttackerSpeed(SeBattle_HurtInfo,startTime,int_timeScale,int_time,int_waitTime)
    startTime = startTime + (int_waitTime or 0)
    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit then
        attackerUnit:SetTimeScaleParam(int_timeScale)
        AddTrackUnitFunc(attackerUnit,startTime,"SetTimeScale",int_timeScale)
        if int_time == nil or int_time == 0 then int_time = 10 end
        startTime = startTime + int_time 
        AddTrackUnitFunc(attackerUnit,startTime,"SetTimeScale",1)
    end
end


function ShowBattleUI(boolean_show)
    local kBattleUI = GetUIWindow("BattleUI")
    if kBattleUI then 
        -- kBattleUI:SetActive(boolean_show)
        if boolean_show then 
            kBattleUI:ShowUI(true)
            -- kBattleUI.transform.localScale = DRCSRef.Vec3One
        else
            kBattleUI:HideUI(true)
            -- kBattleUI.transform.localScale = vec3Away
        end
        -- WindowsManager:GetInstance().bWindowsLayerNeedUpdate = true
    end
end

function ShowBattleUIDialogueUI(bShow)
    ShowBattleUI(bShow)
    -- UnitMgr:GetInstance():HideLife(not bShow)
end

function ShowBattleScene(boolean_show)
    local objCamera = LogicMain:GetInstance().battleSceneBG
    if objCamera then 
        objCamera:SetActive(boolean_show)
    end
end

--战斗开始效果
function BattleBeginEffect()
    local BattleBeginUI = LoadSpineFromPool("UI/UIPrefabs/Battle/BattleBegin",TIPS_Layer,true)
    local BattleBeginUI_SkeletonGraphic = BattleBeginUI:GetComponent("SkeletonGraphic")
    if BattleBeginUI_SkeletonGraphic and BattleBeginUI_SkeletonGraphic.skeletonDataAsset then 
        local skeletonData = BattleBeginUI_SkeletonGraphic.skeletonDataAsset:GetSkeletonData(false)
        local AnimationData = skeletonData:FindAnimation('animation')
        local BattleBeginUI_time = AnimationData.Duration*1000 + 100
        AddTrackFunc(0,"PlayButtonSound",'EventBattle')
        AddTrackFunc(0,"SetSkeletonAnimation",BattleBeginUI_SkeletonGraphic, 0, 'animation', false)
        AddTrackFunc(BattleBeginUI_time,"ReturnObjectToPool",BattleBeginUI)
        return BattleBeginUI_time
    end
    return 0
end

function BossComingEffect(name,icon)
    bossUI:SetActive(true)
    bossUI_AnimationData:Stop()
    bossUI_Icon2.sprite = GetSprite(icon)
    bossUI_Icon.sprite = GetSprite(icon)
    bossUI_bossName.text = name
    bossUI_AnimationData:Play()
end

-- boss入场效果
function BossEnterScene(bossList)
    local startTime = BattleBeginEffect()
    if bossList then 
        if not bossUI then
            bossUI = LoadPrefabAndInit("Battle/bossComing",TIPS_Layer,true)
            bossUI_Icon2 = bossUI:FindChildComponent("cg1","Image")
            bossUI_Icon = bossUI:FindChildComponent("cg2","Image")
            bossUI_bossName = bossUI:FindChildComponent("name", "Text")
            bossUI_AnimationData = bossUI:GetComponent(typeof(CS.UnityEngine.Animation))
            bossUI_length = bossUI_AnimationData.clip.length * 1000
            bossUI:SetActive(false)
        end
        for i=1,#bossList do
            local strPath = ""
            local namestr = ""
            local tbl_Role = TB_Role[bossList[i]]
            if tbl_Role then
                local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", tbl_Role.ArtID)
                strPath = typeData and typeData.Drawing or ""
                namestr = GetLanguageByID(tbl_Role.NameID) or ""
            end
            AddTrackLambda(startTime,function()
                BossComingEffect(namestr,strPath)
            end)
            startTime = startTime + bossUI_length
        end
        AddTrackLambda(startTime,function()
            bossUI:SetActive(false)
        end)
    end
    -- AddTrackFunc(0,"PlayButtonSound",'EventBoss')
    -- 战斗开始plot
    -- AnimationMgr:GetInstance():ShowZhanDouKaiShiPlot()
    LogicMain:GetInstance():ReleaseQuitBattle()
    return startTime
end

function EnterBattletTansitions()
    if _battletTansitions == nil then 
        _battletTansitions = LoadPrefabAndInit("Battle/BattletTansitions",UI_UILayer)
    end
    if _battletTansitions == nil then 
        return
    end
    if IS_WINDOWS then
        screen_radio = DRCSRef.Screen.width/DRCSRef.Screen.height -- PC上动态计算
    end
    _battletTansitions_w = 2000
    if screen_radio > design_radio then 
        _battletTansitions_w = _battletTansitions_w * screen_radio/design_radio
    end
    _battletTansitions:SetObjLocalPosition(_battletTansitions_w,0,0)
    MyDOTween(_battletTansitions.transform,'DOLocalMoveX',0,0.5)
end

function LeaveBattletTansitions()
    if _battletTansitions == nil then 
        return
    end
    MyDOTween(_battletTansitions.transform,'DOLocalMoveX',-_battletTansitions_w,0.5)
end

function SetHashValueByXY(tab,x,y,value)
    tab[x*100+y] = value
end

function GetHashValueByXY(tab,x,y)
    return tab[x*100+y]
end