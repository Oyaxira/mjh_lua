BarrageUI = class('BarrageUI',BaseWindow)


local  MAXNUMATSAMETIME = 5
local  CUTTINFSCREAMNUM = 13
local  LIMITMAXTIME = 10

local WIDTHFENMU = 42
local MAPFENZHI = {
    {['fenzhi']=2,['speed']=4.5*28},
    {['fenzhi']=9,['speed']=5.3*28},
    {['fenzhi']=20,['speed']=6.3*28},
    {['fenzhi']=30,['speed']=7.3*28},
    {['fenzhi']=42,['speed']=8.5*28}
}
function BarrageUI:ctor()
    self._tween = {}
    self.posList = {}
    self.lastText = {}
    self.WaitngBarrage = {}
    self.ShowingBarrage = {{},{},{},{},{}}
    self.speed = 100
    self.count = 0
end

function BarrageUI:Create()
    local obj = LoadPrefabAndInit("Game/BarrageUI", TIPS_Layer, true)
    if obj then
        self:SetGameObject(obj)
        obj:SetActive(true)
    end
end

function BarrageUI:Init()
    self:RemoveAllChildToPoolAndClearEvent(self._gameObject.transform);

    local PerLineHeight = math.floor(adapt_ui_h / CUTTINFSCREAMNUM)
    self.LineHeightMap = {
        0,PerLineHeight * 1,PerLineHeight * 2,PerLineHeight * 3,PerLineHeight * 4
    }
    self.ScreenWidth = adapt_ui_w
    for i,item in ipairs(MAPFENZHI) do 
        MAPFENZHI[i].length = math.floor(self.ScreenWidth * item.fenzhi / WIDTHFENMU)
    end 
end

function BarrageUI:GetSpeed(iLength)
    if not iLength then 
        return MAPFENZHI[1].speed
    end
    for i,item in ipairs(MAPFENZHI) do 
        if MAPFENZHI[i].length and iLength < MAPFENZHI[i].length then 
            return item.speed
        end 
    end  
    return MAPFENZHI[1].speed
end

function BarrageUI:RefreshUI(text)
    if dnull(text) then
        self:AddBarrage(text)
    end
end
function BarrageUI:ShowLoginBarrage(data)
    local loginWordData = TB_PlayerInfoData[PlayerInfoType.PIT_LOGINWORD];
    if loginWordData[data.iParam1] then
        
        local strText = GetLanguageByID(loginWordData[data.iParam1].TextID);
        strText = string.format(strText, data.acUserName1);

        if loginWordData[data.iParam1].IsBarrage == TBoolean.BOOL_YES then
            self:AddBarrage(strText, loginWordData[data.iParam1]);
        end

        if loginWordData[data.iParam1].IsChatbox == TBoolean.BOOL_YES then
            local chatBoxUI = GetUIWindow('ChatBoxUI');
            if not chatBoxUI then
                OpenWindowImmediately("ChatBoxUI");
                chatBoxUI = GetUIWindow("ChatBoxUI");
            end
            if chatBoxUI then
                local notice = {channel = BroadcastChannelType.BCT_System, content = strText}
                chatBoxUI:AddNotice(notice);
                chatBoxUI:OnRefNormalList(nil);
            end
        end
    end
end
function BarrageUI:ShowRedPacketBarrage(data)
    local redPacketData = {};
    redPacketData.IconPath = 'LoginWord/Icon/img_money_small';
    redPacketData.BottomPicPath = 'LoginWord/Bottom/loginword_bottom_1';
    self:AddBarrage(data, redPacketData);

    local chatBoxUI = GetUIWindow('ChatBoxUI');
    if not chatBoxUI then
        OpenWindowImmediately("ChatBoxUI");
        chatBoxUI = GetUIWindow("ChatBoxUI");
    end
    if chatBoxUI then
        local notice = {channel = BroadcastChannelType.BCT_System, content = data}
        chatBoxUI:AddNotice(notice);
        chatBoxUI:OnRefNormalList(nil);
    end
end
function BarrageUI:AddBarrage(text, data)
    self.BarragePool = self.BarragePool or {} 
    table.insert(self.BarragePool,{
        text = text,
        data = data 
    })
end
function BarrageUI:LateUpdate()
    self:CheckShowBarrage()
end
function BarrageUI:CheckShowBarrage()
    -- 1 检查showing里面 开始后大于规定时间还没有删除的  移除 
    -- 2 检查弹幕池子BarragePool中可以初始化并加入等待序列WaitngBarrage的弹幕 允许则添加
    -- 3 检查等待序列WaitngBarrage中的弹幕 和上条弹幕的是间隔 允许则添加

    -- 1 
    -- local CurTime = os.time()
    -- for i,ShowingBarrages in pairs (self.ShowingBarrage) do 
    --     if ShowingBarrages then 
    --         for ii = #ShowingBarrages,1,-1 do 
    --             local ShowingBarrage = ShowingBarrages[ii]
    --             if ShowingBarrage and CurTime - (ShowingBarrage.starttime or 0) > 10 then 
    --                 DRCSRef.ObjDestroy(ShowingBarrage.obj)
    --                 self.ShowingBarrage[i][ii] = nil        
    --             end 
    --         end 
    --     end 
    -- end 
    -- 2
    if self.BarragePool and #self.BarragePool > 0 then 
        local _iFreeIndex = {}
        local _iCanWaitIndex = {}
        for i=1,MAXNUMATSAMETIME do 
            if (not self.ShowingBarrage[i] or #self.ShowingBarrage[i]== 0) and not self.WaitngBarrage[i] then 
                _iFreeIndex[#_iFreeIndex + 1] = i
            end 
            if not self.WaitngBarrage[i] then 
                _iCanWaitIndex[#_iFreeIndex + 1] = i
            end 
        end 
        local ifreeIndex 
        if #_iFreeIndex ~= 0 then 
            ifreeIndex = math.random( 1,#_iFreeIndex )
            ifreeIndex = _iFreeIndex[ifreeIndex]
        elseif #_iCanWaitIndex ~= 0 then 
            ifreeIndex = math.random( 1,#_iCanWaitIndex )
            ifreeIndex = _iCanWaitIndex[ifreeIndex]
        end
        if ifreeIndex then 
            self:ShowBarrage(self.BarragePool[1],ifreeIndex)
            table.remove( self.BarragePool,1 )
        end 
    end
    -- 3
    local func_AddTween = function(WaitngBarrage,i,XNext,XLast,VLast)
        local obj = WaitngBarrage.obj
        obj:SetActive(true)
        local tween = obj.transform:DOLocalMoveX(-WaitngBarrage.Distance + 640,WaitngBarrage.MoveTime)
        tween:SetEase(CS.DG.Tweening.Ease.Linear)
        local iShowingIndex = #self.ShowingBarrage[i]
        tween:OnComplete(function()
            local window = GetUIWindow('BarrageUI')
            if window then 
                window:ReturnObjToPool(obj)
                local bb = window.ShowingBarrage and window.ShowingBarrage[i] and window.ShowingBarrage[i][1] 
                -- derror('delete tween,Line ：' ..  (i or 0) .. ' ,bbcount:'.. (bb and bb.count or '~') )
                if bb then 
                    table.remove( window.ShowingBarrage[i],1 )
                end
            end
                -- self:ReturnObjToPool(obj)
                -- local bb = self.ShowingBarrage and self.ShowingBarrage[i] and self.ShowingBarrage[i][1] 
                -- -- derror('delete tween,Line ：' ..  (i or 0) .. ' ,bbcount:'.. (bb and bb.count or '~') )
                -- if bb then 
                --     table.remove( self.ShowingBarrage[i],1 )
                -- end
        end)
        -- table.insert( self._tween, {
        --     ['tween'] = tween,
        --     ['starttime'] = CurTime,
        --     ['obj'] = obj} )
    end 
    for i,Barrage in pairs(self.WaitngBarrage) do 
        local iLastShowingIndex = #self.ShowingBarrage[i]
        local LastBarrage = self.ShowingBarrage[i][iLastShowingIndex]
        if not LastBarrage then 
            Barrage.starttime = CurTime
            table.insert( self.ShowingBarrage[i],Barrage )
            func_AddTween(Barrage,i)
            self.WaitngBarrage[i] = nil
        else
            -- 若有多条 则大于每一条
            -- 但是理论仅最后一条即可
            local VLast = LastBarrage.Speed
            local VNext = Barrage.Speed
            local XNext = Barrage.obj.transform.localPosition.x
            local XLast = LastBarrage.obj.transform.localPosition.x
            local Distancesss = XNext - XLast - LastBarrage.width
            local SupDis = (self.ScreenWidth * (VNext -VLast) / VNext)
            if Distancesss > 0 and Distancesss > (SupDis +1)  then 
                -- derror('tween,Line ：' ..  (i or 0) ..',count:'..Barrage.count .. ',VNext ：' ..  (VNext or 0) .. ',VLast：' ..(VLast or 0) .. ',WLast ：' ..  (LastBarrage.width or 0) .. ',XNext ：' ..  (XNext or 0).. ',XLast ：' ..  (XLast or 0) .. ',ScreenWidth ：' ..  (self.ScreenWidth or 0) .. ',Distancesss:'.. (Distancesss or 0).. ',SupDis:'.. (SupDis or 0)  )
                Barrage.starttime = CurTime
                table.insert( self.ShowingBarrage[i],Barrage )
                func_AddTween(Barrage,i,XNext,XLast,VLast)
                self.WaitngBarrage[i] = nil
            end 
        end 
    end 
end
function BarrageUI:ShowBarrage(Barrage,ifreeIndex)
    if not Barrage then 
        return 
    end 

    local text, data = Barrage.text,Barrage.data
    local playerID = globalDataPool:getData('PlayerID');
    local chatBoxSetting = GetConfig(tostring(playerID) .. '#ChatBoxSetting');
    if chatBoxSetting and (chatBoxSetting[99] == true or chatBoxSetting['99'] == true) then
        return;
    end

    local imageObj = self:LoadPrefabFromPool('Game/BarrageUI_Item', self._gameObject.transform);
    if (imageObj == nil) then
        return
    end
    imageObj:SetActive(true)
    local textObj = self:FindChild(imageObj, 'Text')
    local textCompo = textObj:GetComponent("Text");
    if (textCompo == nil) then
        return
    end
    
    local dynImage = self:FindChild(imageObj, 'Image');
    RemoveAllChildren(dynImage);

    self.count = self.count + 1
    -- text = self.count ..  text 
    local childIconObj = self:FindChild(imageObj, 'Image_icon');
    local childBgObj = self:FindChild(imageObj, 'Image_bg');
    childIconObj:SetActive(false);
    childBgObj:SetActive(false);
    if data then
        if data.IconPath and data.IconPath ~= '' then
            childIconObj:SetActive(true);
            childIconObj:GetComponent("Image").sprite = GetSprite(data.IconPath);
        end
        if data.BottomPicPath and data.BottomPicPath ~= '' then
            childBgObj:SetActive(true);
            childBgObj:GetComponent("Image").sprite = GetSprite(data.BottomPicPath);
        end
        
        textCompo.text = text
    else
        if type(text) == 'table' and text.name and text.content then
            
            local t = {}
            for w in string.gmatch(text.content, '%[[a-z0-9A-Z]+%]') do
                table.insert(t, w);
            end
    
            local prefabPath = '';
            local emojiBigDTData = ChatBoxUIDataManager:GetInstance():GetEmojiBigDTData();
            for i = 1, #(t) do
                for j = 1, #(emojiBigDTData) do
                    if t[i] == emojiBigDTData[j].ExchangeText then
                        prefabPath = emojiBigDTData[j].FramePrefabPath;
                        break;
                    end
                end
            end
            
            if prefabPath ~= '' then
                local prefab = LoadFramePrefab(prefabPath, dynImage);
                local deltaX = dynImage.transform.rect.width;
                local deltaY = dynImage.transform.rect.height;
                prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
                prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
                textCompo.text = text.name .. '：';
            else
                textCompo.text = text.name .. '：' .. string.gsub(text.content, '\n', '');
            end

            dynImage:SetActive(true);
        else
            textCompo.text = text;

            dynImage:SetActive(false);
        end
    end

    textObj.transform:GetComponent('ContentSizeFitter'):SetLayoutHorizontal()
    local rect = imageObj.transform:GetComponent('RectTransform')
    if rect then 
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rect)
    end
    imageObj:SetActive(true)
    local width_S = math.floor(self.ScreenWidth)+1
    local randomX = 0
    local posY = self.LineHeightMap[ifreeIndex]
    local randx = 1
    local fx = 0
    rect.transform.localPosition  =  DRCSRef.Vec3(width_S - 640 , posY+100, 0)

    local width_Barrage = rect.rect.width
    local dis = width_S + width_Barrage
    local ispeed = self:GetSpeed(width_Barrage)
    local time = dis/ispeed
    -- local tween = imageObj.transform:DOLocalMoveX(-dis + 640,9)
    -- tween:SetEase(CS.DG.Tweening.Ease.Linear)
    -- tween:OnComplete(function()
    --     DRCSRef.ObjDestroy(imageObj)
    -- end)
    self.WaitngBarrage[ifreeIndex] = {
        ['posy'] = posY,
        ['obj']=imageObj,
        ['width']=width_Barrage,
        ['Speed']=ispeed,
        ['Distance']=dis,
        ['count']=self.count,
        ['MoveTime']=time,
    }
    -- self.lastText[randx] = {['posy'] = posY,['obj']=imageObj,['width']=rect.rect.width}
    -- table.insert( self._tween, tween )
end

-- function BarrageUI:remove(tween)
--     for index, value in ipairs(self._tween) do
--         if value == tween then
--             table.remove(self._tween,index)
--             break
--         end
--     end
-- end

return BarrageUI