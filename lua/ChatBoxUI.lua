ChatBoxUI = class('ChatBoxUI', BaseWindow);
DKJson = require('Base/Json/dkjson')

local LoadingTipStatus = CS.UnityEngine.UI.LoadingTipStatus;

local aHour = 60 * 60;
local aDay = 24 * 60 * 60;
local offSetX = 36;
local offSetY = 20;

local channelColor = {
    [BroadcastChannelType.BCT_System] = DRCSRef.Color(0xf7/0xff, 0xf1/0xff, 0x70/0xff),
    [BroadcastChannelType.BCT_World] = DRCSRef.Color(0x2e/0xff, 0xc9/0xff, 0x42/0xff),
    [BroadcastChannelType.BCT_Town] = DRCSRef.Color(0xff/0xff, 0xff/0xff, 0xff/0xff),
    [BroadcastChannelType.BCT_Script] = DRCSRef.Color(0xff/0xff, 0xff/0xff, 0xff/0xff),
}

local moneyStateColor = {
    ['Enough'] = DRCSRef.Color.white,
    ['NotEnough'] = DRCSRef.Color(1, 0.1628874, 0, 1),
}

local privateColor = DRCSRef.Color(0xb9/0xff, 0x00/0xff, 0xff/0xff)

--[[
    BroadcastChannelType = {
    BCT_Null = 0,
    BCT_World = 1,     --  
    BCT_Script = 2,     --  
    BCT_Town = 3,     -- 
    BCT_System = 4,     --
    BCT_Private = 5,    --
    BCT_All = 6,     --  
}
]]
local channelText = {
    [BroadcastChannelType.BCT_System] = '系统',
    [BroadcastChannelType.BCT_World] = '世界',
    [BroadcastChannelType.BCT_Script] = '剧本',
    [BroadcastChannelType.BCT_Town] = '酒馆',
    [BroadcastChannelType.BCT_Private] = '私聊',
    [BroadcastChannelType.BCT_All] = '综合',
}

function ChatBoxUI:ctor()
    self.TABTable = {};
    self.bindBtnTable = {};
    self.settingToggles = {};
    self.lockTable = {};
    self.panalTable = {}
    self.tempSession = {};
    self.sendBtnTable = {};
    self.curSessionID = nil;
    self.curChannel = nil;
    self.isClickExtendBtn = false;
    self.msgInited = false;
    self.isLock = false;
    self.mornalMsgInited = false;
    self.lockMsgCount = 0;
    self.sessionIndex = 1;
    self.bCreateSession = false;
    self.channel = BroadcastChannelType.BCT_System;

    self.DontDestroy = true --切場景 保證一直不會被銷毀 除非主動調用removeWindow
end

function ChatBoxUI:Create()
	local obj = LoadPrefabAndInit('Interactive/ChatBoxUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function ChatBoxUI:Init()
    self.SocialDataManager = SocialDataManager:GetInstance();
    self.ChatBoxUIDataManager = ChatBoxUIDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance()
    self.TableDataManager = TableDataManager:GetInstance();
    self.MeridiansDataManager = MeridiansDataManager:GetInstance();

    self.objSmallUI = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Small');
    self.objBigUI = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Big');

    --
    self.objExtendBtn = self:FindChild(self.objSmallUI, 'Button_Extend');
    self.objSCSmallChatList = self:FindChild(self.objSmallUI, 'SC_SmallChatList');
    self.comSCSmallStrMsg = self:FindChildComponent(self.objSCSmallChatList, 'StrMsg', 'Text');
    self.objNewMsg = self:FindChild(self.objSmallUI, 'NewMsg');
    
    --
    self.objInput = self:FindChild(self.objBigUI, 'Input');
    self.objInputMsg = self:FindChild(self.objBigUI, 'Input_Msg');
    self.objShrinkBtn = self:FindChild(self.objBigUI, 'Button_Shrink');
    self.left = self:FindChild(self.objBigUI, 'Left');
    self.left:SetActive(false)
    self.chatPrivate = self:FindChild(self.objBigUI, 'Chat_Private');
    self.chatPrivateList = self:FindChild(self.objBigUI, 'Chat_PrivateList');
    self.setting = self:FindChild(self.objBigUI, 'Setting');
    self.objMask = self:FindChild(self.objBigUI, 'Mask');
    self.objSCNormal = self:FindChild(self.objBigUI, 'SC_Normal')

    --
    self.objInputField = self:FindChild(self.objInput, 'InputField');
    self.objInputFieldMsg = self:FindChild(self.objInput, 'InputField_Msg');
    self.objSendBtnWorld = self:FindChild(self.objInput, 'Button_Send_World');
    self.objSendBtnTown = self:FindChild(self.objInput, 'Button_Send_Town');
    self.objSendBtnScript = self:FindChild(self.objInput, 'Button_Send_Script');
    self.objSendBtnPrivate = self:FindChild(self.objInput, 'Button_Send_Private');
    self.objKeyboardBtn = self:FindChild(self.objInput, 'Button_Keyboard');
    self.objVoiceBtn = self:FindChild(self.objInput, 'Button_Voice');
    self.objEmojiBtn = self:FindChild(self.objInput, 'Button_Emoji');
    self.objImageEmoji = self:FindChild(self.objInput, 'Image_Emoji');
    self.objImageEmojiMask = self:FindChild(self.objImageEmoji, 'Mask');
    self.objSCEmoji1 = self:FindChild(self.objImageEmoji, 'SC_Emoji1');
    self.objSCEmoji1Content = self:FindChild(self.objSCEmoji1, 'Viewport/Content');
    self.objSCEmoji2 = self:FindChild(self.objImageEmoji, 'SC_Emoji2');
    self.objSCEmoji2Content = self:FindChild(self.objSCEmoji2, 'Viewport/Content');
    self.objInputFieldEmoji = self:FindChild(self.objImageEmoji, 'InputField_Emoji');
    self.objEmojiTog1 = self:FindChild(self.objInputFieldEmoji, 'Toggle_1');
    self.objEmojiTog2 = self:FindChild(self.objInputFieldEmoji, 'Toggle_2');

    self.objImageEmoji:SetActive(false);

    table.insert(self.sendBtnTable, self.objSendBtnWorld);
    table.insert(self.sendBtnTable, self.objSendBtnTown);
    table.insert(self.sendBtnTable, self.objSendBtnScript);
    table.insert(self.sendBtnTable, self.objSendBtnPrivate);

    --
    self.objTabBox = self:FindChild(self.left, 'Tab_box')
    self.objSettingBtn = self:FindChild(self.left, 'Button_Setting')
    self.objLockBtn = self:FindChild(self.left, 'Button_Lock')
    self.objNewMsgTip = self:FindChild(self.left, 'Image_NewMsgTip')
    self.comSCStrMsg = self:FindChildComponent(self.objSCNormal, 'StrMsg', 'Text')
    
    --
    self.objToggleWorld = self:FindChild(self.objTabBox, 'Toggle_world')
    self.objToggleSystem = self:FindChild(self.objTabBox, 'Toggle_system')
    self.objTogglePrivate = self:FindChild(self.objTabBox, 'Toggle_private')

    --
    self.tip = self:FindChild(self.chatPrivate, 'Tip')
    self.objBackBtn = self:FindChild(self.chatPrivate, 'Button_Back')
    self.objSCPrivateMsgList = self:FindChild(self.chatPrivate, 'SC_PrivateMsgList')

    --
    self.objSCPlayerList = self:FindChild(self.chatPrivateList, 'SC_Player')

    --
    self.objCloseBtn = self:FindChild(self.setting, 'Button_close')
    self.objPanalWorld = self:FindChild(self.setting, 'Panal/Toggle_world')
    self.objPanalSystem = self:FindChild(self.setting, 'Panal/Toggle_system')
    self.objPanalPrivate = self:FindChild(self.setting, 'Panal/Toggle_private')
    self.objPanalDanmaku = self:FindChild(self.setting, 'Panal/Toggle_danmaku')

    --
    table.insert(self.settingToggles, self.objPanalWorld)
    table.insert(self.settingToggles, self.objPanalSystem)
    table.insert(self.settingToggles, self.objPanalPrivate)

    --
    table.insert(self.bindBtnTable, self.objExtendBtn);
    table.insert(self.bindBtnTable, self.objSendBtnWorld);
    table.insert(self.bindBtnTable, self.objSendBtnTown);
    table.insert(self.bindBtnTable, self.objSendBtnScript);
    table.insert(self.bindBtnTable, self.objSendBtnPrivate);
    table.insert(self.bindBtnTable, self.objKeyboardBtn);
    table.insert(self.bindBtnTable, self.objVoiceBtn);
    table.insert(self.bindBtnTable, self.objEmojiBtn);
    table.insert(self.bindBtnTable, self.objShrinkBtn);
    table.insert(self.bindBtnTable, self.objSettingBtn);
    table.insert(self.bindBtnTable, self.objLockBtn);
    table.insert(self.bindBtnTable, self.objBackBtn);
    table.insert(self.bindBtnTable, self.objToggleWorld);
    table.insert(self.bindBtnTable, self.objToggleSystem);
    table.insert(self.bindBtnTable, self.objTogglePrivate);
    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objNewMsgTip);
    table.insert(self.bindBtnTable, self.objMask);
    table.insert(self.bindBtnTable, self.objEmojiTog1);
    table.insert(self.bindBtnTable, self.objEmojiTog2);
    table.insert(self.bindBtnTable, self.objImageEmojiMask);
    table.insert(self.bindBtnTable, self.objNewMsg);

    table.insert(self.bindBtnTable, self.objPanalWorld);
    table.insert(self.bindBtnTable, self.objPanalSystem);
    table.insert(self.bindBtnTable, self.objPanalPrivate);
    table.insert(self.bindBtnTable, self.objPanalDanmaku);

    --
    self:InitSCEmoji();

    --
    self:BindBtnCB();

    -- 初始化语音
    self:InitSpeech()

    --
    -- self:OnClickDefault(nil);
    -- self:OnClickExtenBtn(nil, false);

    --
    -- self.objSmallUI:GetComponent('CanvasGroup').alpha = 0.6;
    self.objBigUI:GetComponent('CanvasGroup').alpha = 0;

    --
    self:AddEventListener('ONEVENT_PUBLICCHAT', function(data)
        if data.eRetType ~= 101 then
            local toast = GetLanguageByID(510000 + data.eRetType);
            toast = toast == '' and '未知错误!' or toast;
            SystemUICall:GetInstance():Toast(toast);
        end
    end);

    self:AddEventListener('ONEVENT_REFPRIVATEUI', function(data)
        self:SetFriendDataSession(data);
    end);

    self:AddEventListener('RequestGvoicePermissionsResult', function(iRetCode)
        if tonumber(iRetCode) == 1 then
            self:OnClickVoiceBtn(obj)
        end
    end)

    --
    -- self:AddNotice({channel = BroadcastChannelType.BCT_System, content = '<link="id_01><u><i><#80ff80>[Insert link text here]</u></i></color></link>'});
    -- self:AddNotice({channel = BroadcastChannelType.BCT_System, content = '<link="id_01><u><i><#80ff80>[Insert link text here]</u></i></color></link>'});
    -- self:AddNotice({channel = BroadcastChannelType.BCT_System, content = '<link="id_01><u><i><#80ff80>[Insert link text here]</u></i></color></link>'});
    -- self:AddNotice({channel = BroadcastChannelType.BCT_System, content = '<link="id_01><u><i><#80ff80>[Insert link text here]</u></i></color></link>'});

    self:OnRefSmallChatList();

    --
    self:InitPlayerSet();

    self:OnClickBtn(self.objToggleSystem, true);
end

function ChatBoxUI:InitPlayerSet()
    self.playerID = globalDataPool:getData('PlayerID');
    local chatBoxSetting = GetConfig(tostring(self.playerID) .. '#ChatBoxSetting') or {};
    if self.settingToggles and self.settingToggles[1] then
        self.panalTable[BroadcastChannelType.BCT_World] = chatBoxSetting[tostring(BroadcastChannelType.BCT_World)] or false;
    end
    if self.settingToggles and self.settingToggles[2] then
        self.panalTable[BroadcastChannelType.BCT_System] = chatBoxSetting[tostring(BroadcastChannelType.BCT_System)] or false;
    end
    if self.settingToggles and self.settingToggles[3] then
        self.panalTable[BroadcastChannelType.BCT_Private] = chatBoxSetting[tostring(BroadcastChannelType.BCT_Private)] or false;
    end

    self.panalTable[99] = chatBoxSetting['99'] or false;
end

function ChatBoxUI:RefreshUI(data)
    if data and data.channel then
        self:AddNotice(data);
    end
end

function ChatBoxUI:InitSCEmoji()

    RemoveAllChildren(self.objSCEmoji1Content);
    local emojiSmallDTData = self.ChatBoxUIDataManager:GetEmojiSmallDTData();
    for i = 1, #(emojiSmallDTData) do
        local data = emojiSmallDTData[i];
        local item = LoadPrefabAndInit('Interactive/Item_Emoji', self.objSCEmoji1Content);
        item:GetComponent('Image').sprite = GetSprite(data.ResourcePath);
        local _callback = function(gameObject)
            local comInputField = self.objInputField:GetComponent('InputField');
            comInputField.text = comInputField.text .. data.ExchangeText;
        end
        self:CommonBind(item, _callback)
    end

    RemoveAllChildren(self.objSCEmoji2Content);
    local emojiBigDTData = self.ChatBoxUIDataManager:GetEmojiBigDTData();
    for i = 1, #(emojiBigDTData) do
        local data = emojiBigDTData[i];
        local item = LoadPrefabAndInit('Interactive/Item_Emoji', self.objSCEmoji2Content);
        item:GetComponent('Image').sprite = GetSprite(data.ResourcePath);
        local _callback = function(gameObject)
            if not self.bSendCD then
                local comInputField = self.objInputField:GetComponent('InputField');
                comInputField.text = data.ExchangeText;
                self:OnClickSendBtn();
            end
        end
        self:CommonBind(item, _callback)
    end
end

function ChatBoxUI:AddNotice(data)
    self:AddChannelAllData(data);
    if not self.refreshSmallChatListFlag then 
        self.refreshSmallChatListFlag = true;
        self:AddTimer(500, function()
            self:OnRefSmallChatList();
            self.refreshSmallChatListFlag = false;
        end, 1);
    end
end

function ChatBoxUI:AddChannelAllData(data)

    if not data.channel then
        data.channel = BroadcastChannelType.BCT_System;
    end

    for k, v in pairs(self.panalTable) do
        if k == data.channel and v then
            return;
        end
    end

    if data.channel == BroadcastChannelType.BCT_World then
        self:OnRefNewMsgTip();
    end

    self.ChatBoxUIDataManager:AddChannelAllData(data);
end

function ChatBoxUI:OnRefNewMsgTip()
    local viewport = self:FindChild(self.objSCNormal, 'Viewport')
    local content = self:FindChild(self.objSCNormal, 'Viewport/Content')
    local height = content.transform.rect.height - viewport.transform.rect.height;
    if self.isLock and height > 0 then
        self.lockMsgCount = self.lockMsgCount + 1;

        local cpText = self:FindChildComponent(self.objNewMsgTip, 'Text', 'Text');
        cpText.text = self.lockMsgCount .. '条未读消息';
        self.objNewMsgTip:SetActive(true);
    else
        self.objNewMsgTip:SetActive(false);
        self.lockMsgCount = 0;
    end
end

function ChatBoxUI:OnRefSmallChatList(obj)

    self.smallListData = self.ChatBoxUIDataManager:GetChannelData(BroadcastChannelType.BCT_All);
    self.smallLDCount = #(self.smallListData);

    local lvSC = self.objSCSmallChatList:GetComponent('LoopListView2');
    local scrollRect = self.objSCSmallChatList:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('SmallChat_Item');
            self:OnSmallListScrollChanged(obj.gameObject, index);
            ReBuildRect(obj);
            return obj;
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.smallLDCount, _func);
        else
            lvSC:SetListItemCount(self.smallLDCount, false);
            lvSC:RefreshAllShownItem();
        end 

        lvSC:MovePanelToItemIndex(self.smallLDCount, 0);
        self.lvSCSmall = lvSC;
    end
end

function ChatBoxUI:OnSmallListScrollChanged(gameObject, idx)
    gameObject:SetActive(true);
    local smallListData = self.ChatBoxUIDataManager:GetChannelData(BroadcastChannelType.BCT_All);
    local data = smallListData[idx + 1];
    if data then
        self:SetSingleSmallListUI(gameObject, data);
    else
        derror('ChatBoxUI error, data count = %d, idx = %d', #(smallListData), idx + 1);
    end
end

function ChatBoxUI:SetSingleSmallListUI(gameObject, data)
    local tmpChannel = self:FindChildComponent(gameObject, 'Image/TextMeshPro Text', 'Text');
    local tmpContent = self:FindChildComponent(gameObject, 'TextMeshPro_content', 'Text');
    local tmpPlayer = self:FindChild(gameObject, 'TextMeshPro_player');
    local tmpPicture = self:FindChild(gameObject, 'TextMeshPro_picture');
    tmpContent.gameObject:SetActive(true);
    tmpPicture:SetActive(false);
    RemoveAllChildren(tmpPicture);

    if data and data.content then
        tmpChannel.text = channelText[data.channel];
        tmpChannel.color = channelColor[data.channel];
    
        local _subText = function(strText, len)
            if gameObject.name == 'SmallChat_Item(Clone)' then

                for w in string.gmatch(strText, '</*color.->') do
                    strText = string.gsub(strText, w, '');
                end

                if string.utf8len(strText) > len then
                    strText = string.utf8sub(strText, 1, len);
                    strText = strText .. '...';
                end
            end
            return strText;
        end

        local _formatText = function(channel, tmpPlayer, tmpContent)
            if tmpContent.m_OutputText and gameObject.name == 'SmallChat_Item(Clone)' then
                self.comSCSmallStrMsg.text = tmpContent.m_OutputText;
                local subLen =  180;
                if channel ~= BroadcastChannelType.BCT_System then
                    subLen = 180 - (tmpPlayer:GetComponent('Text').preferredWidth + 4);
                end
    
                local index = 0;
                for i = 1, string.utf8len(tmpContent.m_OutputText) do
                    self.comSCSmallStrMsg.text = string.utf8sub(tmpContent.m_OutputText, 1, i);
                    if self.comSCSmallStrMsg.preferredWidth > subLen then
                        index = i - 1;
                        break;
                    end
                end
    
                if index == 0 then
                    index = string.utf8len(tmpContent.m_OutputText);
                end
    
                local t = {}
                for w in string.gmatch(data.content, '%[[a-z0-9A-Z]+%]') do
                    table.insert(t, w);
                end
    
                local matchT = {};
                local emojiSmallDTData = self.ChatBoxUIDataManager:GetEmojiSmallDTData();
                for i = 1, #(t) do
                    for j = 1, #(emojiSmallDTData) do
                        if t[i] == emojiSmallDTData[j].ExchangeText then
                            table.insert(matchT, emojiSmallDTData[j].ExchangeText);
                        end
                    end
                end
    
                if #(matchT) > 0 then
                    for i = 1, #(matchT) do
                        local l, r = string.find(data.content, string.sub(matchT[i], 2, -2));
                        if l - 1 <= index then
                            local len = string.utf8len(matchT[i]);
                            index = index + len - 1;
                        end 
                    end
                end
                tmpContent.text = _subText(data.content, index);
            else
                tmpContent.text = data.content;
            end
        end

        if data.channel == BroadcastChannelType.BCT_System then
            tmpPlayer:SetActive(false);
            tmpContent.text = data.content;
            _formatText(data.channel, tmpPlayer, tmpContent);
        else
            -- TODO 没有id字段
            if data then
                local jsonData = data;
                if jsonData and jsonData.id then
                    tmpPlayer:SetActive(true);
                    local cp = tmpPlayer:GetComponent('Text');
                    cp.text = jsonData.name .. '：';
                    tmpContent.text = jsonData.content;
                    _formatText(jsonData.channel, tmpPlayer, tmpContent);

                    -- local _callback = function()
                    --     SendGetPlatPlayerDetailInfo(jsonData.id)
                    -- end
                    -- self:CommonBind(tmpPlayer, _callback);
                end
            end
        end

        local t = {}
        for w in string.gmatch(data.content, '%[[a-z0-9A-Z]+%]') do
            table.insert(t, w);
        end

        local prefabPath = '';
        local emojiBigDTData = self.ChatBoxUIDataManager:GetEmojiBigDTData();
        for i = 1, #(t) do
            for j = 1, #(emojiBigDTData) do
                if t[i] == emojiBigDTData[j].ExchangeText then
                    prefabPath = emojiBigDTData[j].FramePrefabPath;
                    break;
                end
            end
        end

        if prefabPath ~= '' then
            tmpContent.gameObject:SetActive(false);
            tmpPicture:SetActive(true);
    
            local prefab = LoadFramePrefab(prefabPath, tmpPicture);
            local deltaX = tmpPicture.transform.rect.width;
            local deltaY = tmpPicture.transform.rect.height;
            prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
            prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
        end

        local _callback = function(gameObject)
            self:OnClickExtenBtn(nil, true);
            local obj = self.objToggleWorld;
            if data.channel == BroadcastChannelType.BCT_System then
                obj = self.objToggleSystem;
            end
            self:OnClickDefault(obj);
        end
        self:CommonBind(gameObject, _callback);
    end
end

function ChatBoxUI:OnNormalListScrollChanged(gameObject, idx)
    local channelData = self.ChatBoxUIDataManager:GetChannelData(self.channel);
    local data = channelData[idx + 1];
    if data then
        if data.channel == BroadcastChannelType.BCT_World then
            self:SetSingleNormalListUI(gameObject, data);
        else
            self:SetSingleSmallListUI(gameObject, data);
        end
    end
end

function ChatBoxUI:SetSingleNormalListUI(gameObject, data)
    local tmpHead = self:FindChild(gameObject, 'Head');
    local tmpHeadImage = self:FindChild(tmpHead, 'Head/Mask/Image');
    local tmpImageMsg = self:FindChild(gameObject, 'Image/Image_Msg');
    local tmpPlayer = self:FindChild(gameObject, 'Image/Image_Name/Text');
    local tmpContent = self:FindChildComponent(tmpImageMsg, 'StrMsg', 'Text');
    local tmpPicMSg = self:FindChild(tmpImageMsg, 'PicMSg');
    RemoveAllChildren(tmpPicMSg);

    if data and data.content then
        -- tmpChannel.text = channelText[data.channel];
        -- tmpChannel.color = channelColor[data.channel];
    
        ---- 加入语音 start ----
        local tempSpeechMsg = self:FindChild(tmpImageMsg, 'SpeechMsg');
        local tempLabSpeechTime = self:FindChildComponent(tempSpeechMsg, 'LabTime', 'Text');

        -- TODO: 这里tempContent的y坐标会更改，所以套用tmpPicMSg的坐标
        local contentY = tmpPicMSg.transform.localPosition.y
        local speechHeightDiff = 0

        -- 语音标识
        local speechFileID = data.speech
        local speech = speechFileID and speechFileID ~= ''
        if speech then
            -- 自动下载语音（不下载的话不知道录音时间，看需求）
            GVoiceHelper:Download(speechFileID, 
                function (seconds)
                    tempLabSpeechTime.text = tostring(math.ceil(seconds) or 1) .. '秒';
                end    
            );

            -- 更改聊天框坐标和背景高度
            speechHeightDiff = tempSpeechMsg.transform.rect.height
            contentY = contentY - speechHeightDiff
        end

        -- 设置文本聊天框y坐标
        tmpContent.transform.localPosition = DRCSRef.Vec3(tmpContent.transform.localPosition.x, contentY, 0)
        
        -- 注册点击事件（为了复用注册所有点击事件，目前只有语音有用到）
        self:CommonBind(tmpImageMsg, 
            function ()
                if speech then
                    GVoiceHelper:StartPlay(speechFileID)
                end
            end
        )

        -- 设置语音框显隐
        tempSpeechMsg:SetActive(speech);

        ---- 加入语音 end ----

        if data.channel == BroadcastChannelType.BCT_System then
            tmpContent.text = data.content;
            tmpPlayer:SetActive(false);
        else
            -- TODO 没有id字段
            if data then
                local jsonData = data;
                if jsonData and jsonData.id then
                    tmpContent.text = jsonData.content;
                    local cp = tmpPlayer:GetComponent('Text');
                    cp.text = jsonData.name;
                    tmpPlayer:SetActive(true);
                
                    --
                    local callback = function(sprite)
                        local uiWindow = GetUIWindow("ChatBoxUI")
                        if (uiWindow and tmpHeadImage) then
                            tmpHeadImage:GetComponent('Image').sprite = sprite
                        end
                    end
                    local pjsondata = {
                        ['dwModelID'] = tonumber(jsonData.modelid),
                        ['charPicUrl'] = jsonData.pictureUrl
                    }
                    GetHeadPicByData(pjsondata, callback)

                    local _callback = function()
                        ChallengeFrom = ChallengeFromType.Chat;
                        SendGetPlatPlayerDetailInfo(jsonData.id, RLAYER_REPORTON_SCENE.WordChat, jsonData.content)
                    end
                    self:CommonBind(tmpHead, _callback);


                end
                if jsonData and jsonData.headboxid then
                    self.objs_headboxInst = self.objs_headboxInst or {}

                    local tempaddpar = self:FindChild(tmpHead, 'Head')
                    if tempaddpar and not self.objs_headboxInst[tempaddpar] then 
                        self.objs_headboxInst[tempaddpar] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,tempaddpar.transform)
                    end 
                    if self.objs_headboxInst[tempaddpar] then 
                        self.objs_headboxInst[tempaddpar]._gameObject:SetActive(true)
                        self.objs_headboxInst[tempaddpar]:SetReplacedHeadBoxUI(tempaddpar)
                        self.objs_headboxInst[tempaddpar]:SetScale(1)
                        self.objs_headboxInst[tempaddpar]:SetHeadBoxID(jsonData.headboxid)
                    end 
                end 
            end
        end

        local t = {}
        for w in string.gmatch(data.content or "", '%[[a-z0-9A-Z]+%]') do
            table.insert(t, w);
        end

        local prefabPath = '';
        local emojiBigDTData = self.ChatBoxUIDataManager:GetEmojiBigDTData();
        for i = 1, #(t) do
            for j = 1, #(emojiBigDTData) do
                if t[i] == emojiBigDTData[j].ExchangeText then
                    prefabPath = emojiBigDTData[j].FramePrefabPath;
                    break;
                end
            end
        end

        if prefabPath ~= '' then
            tmpContent.text = '';
    
            local prefab = LoadFramePrefab(prefabPath, tmpPicMSg);
            local deltaX = tmpPicMSg.transform.rect.width;
            local deltaY = tmpPicMSg.transform.rect.height;
            prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
            prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
            deltaX = deltaX + offSetX;
            deltaY = deltaY + offSetY;
            tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
            tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
        else
            self.comSCStrMsg.text = tmpContent.m_OutputText;
            local sizeDelta = self.comSCStrMsg.transform.sizeDelta;
            local width = self.comSCStrMsg.preferredWidth;
            local deltaX = (width > sizeDelta.x and sizeDelta.x or width) + offSetX;
            local deltaY = self.comSCStrMsg.preferredHeight + offSetY;
            deltaY = speech and (deltaY + speechHeightDiff) or deltaY
            tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
            tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
        end
    end
end

function ChatBoxUI:OnClickPrivateChatListItem(obj, sessid)
    local session = self.ChatBoxUIDataManager:GetSessionByID(sessid);
    if session then
        local otherMember = self.ChatBoxUIDataManager:GetOtherMember(session.members);
        if otherMember then
            local playerData = self.SocialDataManager:GetOtherPlayerData(otherMember);
            if playerData then
                local comText2 = self:FindChildComponent(self.tip, 'Text2', 'Text');
                comText2.text = playerData.name;
                self:OnRefPrivateMsgListUI(obj, sessid);
            end
        end
    end
end

function ChatBoxUI:OnRefNewMsgUI()

    local sessid = 0;
    local sessidList = {};
    local requestMember = {};
    local redPoint = self.ChatBoxUIDataManager:GetRedPoint();
    for k, v in pairs(redPoint) do
        if v > 0 then
            sessid = k;
            table.insert(sessidList, k);
            local session = self.ChatBoxUIDataManager:GetSessionByID(k);
            if session then
                local otherMember = self.ChatBoxUIDataManager:GetOtherMember(session.members);
                if otherMember then
                    table.insert(requestMember, tostring(otherMember));
                end
            end
        end
    end
    
    local _callback = function()
        local count = self.ChatBoxUIDataManager:GetRedPointCount();
        self.objNewMsg:SetActive(count > 0);

        if count > 0 then
            local eventsData = self.ChatBoxUIDataManager:GetEventsDataBySessionID(sessid);
            if eventsData and next(eventsData) then
                local jsonData = DKJson.decode(eventsData[#(eventsData)].data);
                if jsonData then
                    local callback = function(sprite)
                        local uiWindow = GetUIWindow("ChatBoxUI")
                        if (uiWindow) then
                            local comHeadImage = self:FindChild(self.objNewMsg, 'Head/Mask/Image');
                            comHeadImage:GetComponent('Image').sprite = sprite
                        end
                    end
                    local pjsondata = {
                        ['dwModelID'] = tonumber(jsonData.modelid),
                        ['charPicUrl'] = jsonData.pictureUrl
                    }
                    GetHeadPicByData(pjsondata, callback)
                    
                    if jsonData and jsonData.headboxid then
                        self.objs_headboxInst = self.objs_headboxInst or {}
                        
                        local tmpHeadImage = self:FindChild(self.objNewMsg, 'Head')
                        if tmpHeadImage and not self.objs_headboxInst[tmpHeadImage] then 
                            self.objs_headboxInst[tmpHeadImage] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,tmpHeadImage.transform)
                        end 
                        if self.objs_headboxInst[tmpHeadImage] then 
                            self.objs_headboxInst[tmpHeadImage]._gameObject:SetActive(true)
                            self.objs_headboxInst[tmpHeadImage]:SetReplacedHeadBoxUI(tmpHeadImage)
                            self.objs_headboxInst[tmpHeadImage]:SetScale(1)
                            self.objs_headboxInst[tmpHeadImage]:SetHeadBoxID(jsonData.headboxid)
                        end 
                    end 
                end
            end
        end
    end

    if #(requestMember) > 0 then
        self.SocialDataManager:QueryFriendInfo(requestMember, _callback);
    else
        self.objNewMsg:SetActive(false);
    end

    -- local count = self.ChatBoxUIDataManager:GetRedPointCount();
    -- self.objNewMsg:SetActive(count > 0);
end

function ChatBoxUI:OnRefPrivateRedPointCount()
    local count = self.ChatBoxUIDataManager:GetRedPointCount();
    local redPoint = self:FindChild(self.objTogglePrivate, 'Image_redPoint');
    if count > 0 then
        self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
        redPoint:SetActive(true);
    else
        redPoint:SetActive(false);
    end 
end

function ChatBoxUI:OnRefPrivateMsgListUI(obj, sessid)
    self.playerID = globalDataPool:getData('PlayerID');
    self.curSessionID = sessid;
    self.eventsData = self.ChatBoxUIDataManager:GetEventsDataBySessionID(sessid);
    self.eventsDCount = #(self.eventsData);

    --
    if self.eventsDCount > 0 then
        self.ChatBoxUIDataManager:ResetRedPointBySessionID(sessid);
        local eventData = self.eventsData[self.eventsDCount];
        NetCommonChat:AckSessionVer(sessid, eventData.version);
    end

    local lvSC = self.objSCPrivateMsgList:GetComponent('LoopListView2');
    local scrollRect = self.objSCPrivateMsgList:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = nil;
            local data = self.eventsData[index + 1];
            if data.userid == self.playerID then
                obj = item:NewListViewItem('ItemPrefab2');
            else
                obj = item:NewListViewItem('ItemPrefab1');
            end

            self:OnRefMsg(obj.gameObject, index);
            ReBuildRect(obj);
            return obj;
        end

        if not self.inited3 then
            self.inited3 = true;
            lvSC:InitListView(self.eventsDCount, _func);
        else
            lvSC:SetListItemCount(self.eventsDCount, false);
            lvSC:RefreshAllShownItem();
        end 

        lvSC:MovePanelToItemIndex(self.eventsDCount, 0);

        self.lvSCPrivateMsg = lvSC;
    end
end

function ChatBoxUI:OnRefMsg(gameObject, idx)

    local eventsData = self.ChatBoxUIDataManager:GetEventsDataBySessionID(self.curSessionID);
    local data = eventsData[idx + 1];
    local jsonData = DKJson.decode(data.data);

    if not jsonData then
        return;
    end

    -- local chatItem = self:FindChild(gameObject, 'Chat_item');
    -- local chatTime = self:FindChild(gameObject, 'Chat_time');
    -- chatTime:SetActive(false);

    local isToday = function(timestamp)
        timestamp = tonumber(timestamp);
        local today = os.date('*t');
        local formatTime = {
            day = today.day,
            month = today.month,
            year = today.year,
            hour = 0,
            minute = 0,
            second = 0,
        }
        local secondOfToday = os.time(formatTime);
        if (timestamp >= secondOfToday) and (timestamp < secondOfToday + aDay) then
            return true;
        else
            return false;
        end
    end

    -- local time = 0;
    -- if self.lastData then
    --     time = tonumber(data.time) - tonumber(self.lastData.time);
    -- end

    --
    -- local _func = function(date)
    --     local tmp = self:FindChild(chatTime, 'TextMeshPro_time');
    --     local cp = tmp:GetComponent('Text');
    --     cp.text = date;
    --     chatTime:SetActive(true);
    -- end

    -- if isToday(data.time) then
    --     if (time / aHour) >= 2 then
    --         local time = os.date("%H:%M", data.time);
    --         _func(time);
    --     end
    -- else
    --     if (time / aHour) >= 2 then
    --         local time = os.date("%m-%d %H:%M", data.time);
    --         _func(time);
    --     end
    -- end

    roleText = jsonData.name or '';

    -- local tmpPlayer = self:FindChildComponent(chatItem, 'TextMeshPro_player', 'Text');
    -- local tmpContent = self:FindChildComponent(chatItem, 'TextMeshPro_content', 'Text');
    local tmpHead = self:FindChild(gameObject, 'Head');
    local tmpHeadImage = self:FindChild(tmpHead, 'Head/Mask/Image');
    local tmpImageMsg = self:FindChild(gameObject, 'Image/Image_Msg');
    local tmpPlayer = self:FindChild(gameObject, 'Image/Image_Name/Text');
    local tmpContent = self:FindChildComponent(tmpImageMsg, 'StrMsg', 'Text');
    local tmpPicMSg = self:FindChild(tmpImageMsg, 'PicMSg');
    RemoveAllChildren(tmpPicMSg);

    
    if jsonData and jsonData.headboxid then
        self.objs_headboxInst = self.objs_headboxInst or {}
        local tempheadboxpar = self:FindChild(tmpHead, 'Head')
        if tempheadboxpar and not self.objs_headboxInst[tempheadboxpar] then 
            self.objs_headboxInst[tempheadboxpar] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,tempheadboxpar.transform)
        end 
        if self.objs_headboxInst[tempheadboxpar] then 
            self.objs_headboxInst[tempheadboxpar]._gameObject:SetActive(true)
            self.objs_headboxInst[tempheadboxpar]:SetReplacedHeadBoxUI(tempheadboxpar)
            self.objs_headboxInst[tempheadboxpar]:SetScale(1)
            self.objs_headboxInst[tempheadboxpar]:SetHeadBoxID(jsonData.headboxid)
        end 
    end 

    ---- 加入语音 start ----
    local tempSpeechMsg = self:FindChild(tmpImageMsg, 'SpeechMsg');
    local tempLabSpeechTime = self:FindChildComponent(tempSpeechMsg, 'LabTime', 'Text');

    -- TODO: 这里tempContent的y坐标会更改，所以套用tmpPicMSg的坐标
    local contentY = tmpPicMSg.transform.localPosition.y
    local speechHeightDiff = 0

    -- 语音标识
    local speechFileID = jsonData.speech
    local speech = speechFileID and speechFileID ~= ''
    if speech then
        -- 自动下载语音（不下载的话不知道录音时间，看需求）
        GVoiceHelper:Download(speechFileID, 
            function (seconds)
                tempLabSpeechTime.text = tostring(math.ceil(seconds) or 1) .. '秒';
            end    
        );

        -- 更改聊天框坐标和背景高度
        speechHeightDiff = tempSpeechMsg.transform.rect.height
        contentY = contentY - speechHeightDiff
    end

    -- 设置文本聊天框y坐标
    tmpContent.transform.localPosition = DRCSRef.Vec3(tmpContent.transform.localPosition.x, contentY, 0)
    
    -- 注册点击事件（为了复用注册所有点击事件，目前只有语音有用到）
    self:CommonBind(tmpImageMsg, 
        function ()
            if speech then
                GVoiceHelper:StartPlay(speechFileID)
            end
        end
    )

    -- 设置语音框显隐
    tempSpeechMsg:SetActive(speech);

    ---- 加入语音 end ----

    tmpPlayer:GetComponent('Text').text = roleText;
    tmpContent.text = jsonData.content or '';

    local callback = function(sprite)
        local uiWindow = GetUIWindow("ChatBoxUI")
        if (uiWindow and tmpHeadImage) then
            tmpHeadImage:GetComponent('Image').sprite = sprite
        end
    end
    local pjsondata = {
        ['dwModelID'] = tonumber(jsonData.modelid),
        ['charPicUrl'] = jsonData.pictureUrl
    }
    GetHeadPicByData(pjsondata, callback)

    local t = {}
    for w in string.gmatch(jsonData.content, '%[[a-z0-9A-Z]+%]') do
        table.insert(t, w);
    end

    local prefabPath = '';
    local emojiBigDTData = self.ChatBoxUIDataManager:GetEmojiBigDTData();
    for i = 1, #(t) do
        for j = 1, #(emojiBigDTData) do
            if t[i] == emojiBigDTData[j].ExchangeText then
                prefabPath = emojiBigDTData[j].FramePrefabPath;
                break;
            end
        end
    end

    if prefabPath ~= '' then
        tmpContent.text = '';

        local prefab = LoadFramePrefab(prefabPath, tmpPicMSg);
        local deltaX = tmpPicMSg.transform.rect.width;
        local deltaY = tmpPicMSg.transform.rect.height;
        prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
        prefab.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
        deltaX = deltaX + offSetX;
        deltaY = deltaY + offSetY;
        tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
        tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
    else
        self.comSCStrMsg.text = tmpContent.m_OutputText;
        local sizeDelta = self.comSCStrMsg.transform.sizeDelta;
        local width = self.comSCStrMsg.preferredWidth;
        local deltaX = (width > sizeDelta.x and sizeDelta.x or width) + offSetX;
        local deltaY = self.comSCStrMsg.preferredHeight + offSetY;
        deltaY = speech and (deltaY + speechHeightDiff) or deltaY
        tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, deltaX);
        tmpImageMsg.transform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, deltaY);
    end

    --
    local _callback = function()
        ChallengeFrom = ChallengeFromType.Chat;
        SendGetPlatPlayerDetailInfo(jsonData.id, RLAYER_REPORTON_SCENE.PrivateChat, jsonData.content)
    end
    self:CommonBind(tmpHead, _callback);

    self.lastData = data;
end

-- 私聊列表界面刷新
function ChatBoxUI:OnRefPrivateListUI(obj)
    -- 获取会话列表
    self.sessionList = self.ChatBoxUIDataManager:GetSessionList();
    self.sessionCount = #(self.sessionList);
    -- 分两列显示
    self.sessionListMod = self.sessionCount % 2;
    self.sessionListCount = math.ceil(self.sessionCount / 2);

    local lvSC = self.objSCPlayerList:GetComponent('LoopListView2');
    local scrollRect = self.objSCPlayerList:GetComponent('ScrollRect');
    if lvSC then
        -- List初始化
        local _func = function(item, index)
            local obj = item:NewListViewItem('Chat_PlayerList_Item');
            -- list创建刷新方法
            self:OnPlayerListScrollChanged(obj.gameObject, index);
            -- 相当于refill
            ReBuildRect(obj);
            return obj;
        end

        local _func1 = function()
        end

        local _func2 = function()
        end

        local _func3 = function()
        end

        if not self.inited4 then
            self.inited4 = true;
            lvSC:InitListView(self.sessionListCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.sessionListCount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCPlayerList = lvSC;
    end
end

-- 私聊列表单个Item刷新
function ChatBoxUI:OnPlayerListScrollChanged(obj, idx)

    local _func = function(child, i)
        local sessionList = self.ChatBoxUIDataManager:GetSessionList();
        local dataIndex = (idx * 2) + (i + 1);
        -- 获取当前会话
        local session = sessionList[dataIndex];
        if session then
            local otherMember = self.ChatBoxUIDataManager:GetOtherMember(session.members);
            if otherMember then
                -- 获取私聊对象数据
                local otherPlayerData = self.SocialDataManager:GetOtherPlayerData(otherMember);
                if otherPlayerData then
                    otherPlayerData.redPointCount = self.ChatBoxUIDataManager:GetRedPointBySessionID(session.sessid);
                    -- 用数据刷新好友ui
                    self:SetSinglePlayerListUI(child.gameObject, otherPlayerData);
                    -- 设置聊天按钮click方法
                    local btn = self:FindChild(child.gameObject, 'Button');
                    local _callback = function(gameObject, boolHide)
                        if gameObject == btn then
                            local bFriend = SocialDataManager:GetInstance():GetFriendDataByID(otherPlayerData.uid);
                            self:OnClickFriendListItem(child.gameObject, otherPlayerData, bFriend);
                        end
                    end
                    self:CommonBind(btn, _callback);
                end
            end
        end
    end

    --
    if idx == (self.sessionListCount - 1) then
        for i = 0, 1 do
            local child = obj.transform:GetChild(i);
            if child then
                if i < self.sessionListMod or self.sessionListMod == 0 then
                    child.gameObject:SetActive(true);
                    _func(child, i);
                else
                    child.gameObject:SetActive(false);
                end
            end
        end
    else
        for i = 0, 1 do
            local child = obj.transform:GetChild(i);
            if child then
                child.gameObject:SetActive(true);
                _func(child, i);
            end
        end
    end
end

-- 私聊界面好友信息的刷新
function ChatBoxUI:SetSinglePlayerListUI(obj, info)

    if not info then
        return;
    end

    if not info.ext then
        info.ext = {};
    end

    local iconRich = self:FindChild(obj, 'Icon_rich');
    local textName = self:FindChild(obj, 'Text_name');
    local textOnline = self:FindChild(obj, 'Text_online');
    local offline = self:FindChild(obj, 'Offline');
    local redPoint = self:FindChild(obj, 'Image_redPoint');
    local headImage = self:FindChild(obj, 'Head/Mask/Image');
    local objhead = self:FindChild(obj, 'Head');

    local bRMBPlayer = tonumber(info.ext.dwRMBPlayer or 0);
    iconRich:SetActive(bRMBPlayer > GetCurServerTimeStamp());

    
    if info and info.ext.dwHeadBoxID then
        self.objs_headboxInst = self.objs_headboxInst or {}
        if not self.objs_headboxInst[objhead] then 
            self.objs_headboxInst[objhead] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,objhead.transform)
        end 
        if self.objs_headboxInst[objhead] then 
            self.objs_headboxInst[objhead]._gameObject:SetActive(true)
            self.objs_headboxInst[objhead]:SetReplacedHeadBoxUI(objhead)
            self.objs_headboxInst[objhead]:SetScale(1)
            self.objs_headboxInst[objhead]:SetHeadBoxID(info.ext.dwHeadBoxID)
        end 
    end 

    textName:GetComponent('Text').text = info.name;
    
    textOnline:GetComponent('Text').text = info.online and '在线' or '离线';
    offline:SetActive(not info.online);

    redPoint:SetActive(info.redPointCount > 0);
    self:FindChildComponent(redPoint, 'Text', 'Text').text = info.redPointCount;

    if info.ext.sprite then
        headImage:GetComponent('Image').sprite = info.ext.sprite;
    end

end

-- 点击私聊界面头像 刷新私聊聊天界面
function ChatBoxUI:OnClickFriendListItem(obj, info, bFriend)
    -- 限制在会话拉取结束后才能开始聊天
    if self.ChatBoxUIDataManager:GetSessionGetFinishFlag() then
        local _callback = function()
            local session = self.ChatBoxUIDataManager:HasSession(info.uid);
            if session then
                self.chatPrivate:SetActive(true);
                self.chatPrivateList:SetActive(false);
                self.objInput:SetActive(true);
                self:OnClickPrivateChatListItem(nil, session.sessid);
                self.ChatBoxUIDataManager:ResetRedPointBySessionID(session.sessid);
                self:OnRefPrivateRedPointCount();
            else
                if not self.bCreateSession and info.uid and info.uid ~= '' then
                    self.bCreateSession = true;
                    local name = bFriend and 'FChat' or 'NChat';
                    NetCommonChat:CreateSession({ tostring(info.uid) }, name);
                end
            end
        
            --
            if obj then
                local parent = obj.transform.parent.gameObject;
                local redPoint = self:FindChild(parent, 'Image_redPoint');
                redPoint:SetActive(false);
            end
        end
        self.SocialDataManager:QueryFriendInfo({ tostring(info.uid) }, _callback);
    else
        SystemUICall:GetInstance():Toast('聊天模块正在初始化，请稍后再试')
    end
end

function ChatBoxUI:SetFriendDataSession(session)
    if session then
        self.bCreateSession = false;
        session.version = 0;
        self.chatPrivate:SetActive(true);
        self.chatPrivateList:SetActive(false);
        self.objInput:SetActive(true);
        self:OnClickPrivateChatListItem(nil, session.sessid);
    end
end

function ChatBoxUI:SetCurSessionID(sessid)
    self.curSessionID = sessid;
end

function ChatBoxUI:GetCurSessionID()
    return self.curSessionID;
end

function ChatBoxUI:OnClickBtn(obj, boolHide)
    if obj == self.objExtendBtn then
        self:OnClickExtenBtn(obj, true);

    elseif obj == self.objSendBtnWorld or obj == self.objSendBtnTown or obj == self.objSendBtnScript or obj == self.objSendBtnPrivate then
        self:OnClickSendBtn(obj);

    elseif obj == self.objShrinkBtn or obj == self.objMask then
        self:OnClickExtenBtn(obj, false);

    elseif obj == self.objSettingBtn then
        self:OnClickSettingBtn();

    elseif obj == self.objLockBtn then
        self:OnClickLockBtn(obj);
    
    elseif obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    elseif obj == self.objBackBtn then
        self:OnClickBackBtn(obj);

    elseif obj == self.objToggleWorld then
        if boolHide then
            self:OnClickToggleWorld(obj);
        end

    elseif obj == self.objToggleSystem then
        if boolHide then
            self:OnClickToggleSystem(obj);
        end

    elseif obj == self.objTogglePrivate then
        if boolHide then
            self:OnClickTogglePrivate(obj);
        end
    
    elseif obj == self.objPanalWorld then
        self:OnRefSetting(obj, boolHide);

    elseif obj == self.objPanalSystem then
        self:OnRefSetting(obj, boolHide);

    elseif obj == self.objPanalDanmaku then
        self:OnRefSetting(obj, boolHide);

    elseif obj == self.objPanalPrivate then
        self:OnRefSetting(obj, boolHide);
    
    elseif obj == self.objNewMsgTip then
        self:OnClickNewMsgTip(obj);

    elseif obj == self.objEmojiBtn or obj == self.objImageEmojiMask then
        self:OnClickEmojiBtn(obj);

    elseif obj == self.objEmojiTog1 then
        self:OnClickEmojiTog(obj);

    elseif obj == self.objEmojiTog2 then
        self:OnClickEmojiTog(obj);

    elseif obj == self.objVoiceBtn then
        self:OnClickVoiceBtn(obj);

    elseif obj == self.objKeyboardBtn then
        self:OnClickKeyboardBtn(obj);

    elseif obj == self.objNewMsg then
        self:OnClickNewMsg(obj);

    end
end

function ChatBoxUI:OnClickNewMsg()
    self:OnClickExtenBtn(nil, true);
    self:OnClickDefault(self.objTogglePrivate);
end

function ChatBoxUI:OnClickVoiceBtn(obj)
    -- 初始化GVoice  
    if not  self.bInitGVoice then
        if DRCSRef.CommonFunction.GVoiceRequestDynamicPermissions() == 0 then
            self.bInitGVoice = true
        end
    end

    if self.bInitGVoice then
        GVoiceHelper:Init()  
        self.objVoiceBtn:SetActive(false);
        self.objInputFieldMsg:SetActive(true);
    end
end

function ChatBoxUI:OnClickKeyboardBtn(obj)
    self.objVoiceBtn:SetActive(true);
    self.objInputFieldMsg:SetActive(false);
end

function ChatBoxUI:OnClickEmojiTog(obj)
    if obj == self.objEmojiTog1 then
        self.objSCEmoji1:SetActive(true);
        self.objSCEmoji2:SetActive(false);
    elseif obj == self.objEmojiTog2 then
        self.objSCEmoji1:SetActive(false);
        self.objSCEmoji2:SetActive(true);
    end
end

function ChatBoxUI:OnClickEmojiBtn(obj)
    if self.objImageEmoji.activeSelf then
        self.objImageEmoji:SetActive(false);
    else
        self.objImageEmoji:SetActive(true);
    end
end

function ChatBoxUI:OnClickNewMsgTip()
    self.isLock = false;
    self:SetLockState();
    self.lockMsgCount = 0;
    self.objNewMsgTip:SetActive(false);
    self.lvSCNormal:MovePanelToItemIndex(self.channelDCount, 0);
end

function ChatBoxUI:OnRefSetting(obj, boolHide)

    if self.settingToggles and self.settingToggles[1] then
        self.panalTable[BroadcastChannelType.BCT_World] = self.settingToggles[1]:GetComponent('Toggle').isOn;
    end
    if self.settingToggles and self.settingToggles[2] then
        self.panalTable[BroadcastChannelType.BCT_System] = self.settingToggles[2]:GetComponent('Toggle').isOn;
    end
    if self.settingToggles and self.settingToggles[3] then
        self.panalTable[BroadcastChannelType.BCT_Private] = self.settingToggles[3]:GetComponent('Toggle').isOn;
    end

    self.panalTable[99] = self.objPanalDanmaku:GetComponent('Toggle').isOn;

    self.playerID = globalDataPool:getData('PlayerID');
    SetConfig(tostring(self.playerID) .. '#ChatBoxSetting', self.panalTable, true);
end

function ChatBoxUI:OnRefWorldBtnState()
    if self.MeridiansDataManager:GetSumLevel() >= SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL then
        local objStyle1 = self:FindChild(self.objSendBtnWorld, 'Style1');
        local objStyle2 = self:FindChild(self.objSendBtnWorld, 'Style2');
        objStyle1:SetActive(false);
        objStyle2:SetActive(false);
        if self.MeridiansDataManager:GetSumLevel() >= SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL then
            objStyle1:SetActive(true);
        else
            objStyle2:SetActive(true);
        end
    end
end

function ChatBoxUI:OnClickExtenBtn(obj, active)

    if active then
        self.objBigUI.transform:DR_DOLocalMoveX(640, 0.3);

        self.objBigUI:GetComponent('CanvasGroup').alpha = 1;
        self.objMask:SetActive(true);
    else
        self.objBigUI.transform:DR_DOLocalMoveX(-300, 0.2);
        self.objMask:SetActive(false);
        self.objImageEmoji:SetActive(false);
        self.setting:SetActive(false);

        local _callback = function()
            self:OnClickDefault(nil);
            self.objBigUI:GetComponent('CanvasGroup').alpha = 0;
        end
        globalTimer:AddTimer(200, _callback, 1);
    end

    if not active then
        self:OnRefNewMsgUI(nil);
    end

    self:OnRefWorldBtnState();
    self:OnRefNormalList();

    self.isClickExtendBtn = active;
end

function ChatBoxUI:SetToggleState(obj)
    -- local tempTable = {};
    -- table.insert(tempTable, self.objToggleWorld)
    -- table.insert(tempTable, self.objToggleSystem)
    -- table.insert(tempTable, self.objTogglePrivate)

    -- for i = 1, #(tempTable) do
    --     if obj == tempTable[i] then
    --         tempTable[i]:GetComponent('Toggle').isOn = true;
    --     else
    --         tempTable[i]:GetComponent('Toggle').isOn = false;
    --     end
    -- end

    if obj then
        obj:GetComponent('Toggle').isOn = true;
    end
end

function ChatBoxUI:OnClickDefault(obj)
    self.chatPrivate:SetActive(false);
    -- self:SetToggleState(obj or self.objToggleSystem);
    -- self:OnClickBtn(obj or self.objToggleWorld, true);
    self:OnRefPrivateRedPointCount();
end

function ChatBoxUI:SetSendBtnActive(gameObject)
    for i = 1, #(self.sendBtnTable) do
        if gameObject == self.sendBtnTable[i] then
            self.sendBtnTable[i]:SetActive(true);
        else
            self.sendBtnTable[i]:SetActive(false);
        end
    end
end

function ChatBoxUI:SetSendBtnCost()
    local iSilverRemain = PlayerSetDataManager:GetInstance():GetPlayerSliver() or 0
    local iChatCost = 1  -- 发送一次花一银锭
    local bEnough = (iSilverRemain >= iChatCost)

    local objStyle2 = self:FindChild(self.objSendBtnWorld, 'Style2');
    local objText = self:FindChild(objStyle2, 'Consume/Text');
    local comTextStyle2 = objText:GetComponent('Text');
    comTextStyle2.color = bEnough and moneyStateColor.Enough or moneyStateColor.NotEnough;
end

-- 世界频道刷新
function ChatBoxUI:OnRefNormalList(obj)
    self.playerID = globalDataPool:getData('PlayerID');
    self.channelData = self.ChatBoxUIDataManager:GetChannelData(self.channel);
    self.channelDCount = #(self.channelData);

    local lvSC = self.objSCNormal:GetComponent('LoopListView2');
    local scrollRect = self.objSCNormal:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = nil;
            local data = self.channelData[index + 1];
            if data.channel == BroadcastChannelType.BCT_World then
                if data.id == self.playerID then
                    obj = item:NewListViewItem('ItemPrefab2');
                else
                    obj = item:NewListViewItem('ItemPrefab1');
                end
            else
                obj = item:NewListViewItem('BigChat_item');
            end

            if obj then
                self:OnNormalListScrollChanged(obj.gameObject, index);
                ReBuildRect(obj);
            end

            return obj;
        end
        
        local _func1 = function()
        end

        local _func2 = function()
        end
        
        local _func3 = function()
            local content = self:FindChild(self.objSCNormal, 'Viewport/Content')
            local sizeDelta = content.transform.rect.height - self.objSCNormal.transform.rect.height;
            local positionY = content.transform.sizeDelta.y - self.objSCNormal.transform.rect.height;
            local percent = 1 - (positionY - 10) / sizeDelta;
            if scrollRect.verticalNormalizedPosition > 0 then
                if scrollRect.verticalNormalizedPosition > percent then
                    self.isLock = true;
                end
            else
                self.isLock = false;
                self:OnClickNewMsgTip();
            end
            self:SetLockState();
        end
        
        if not self.inited1 then
            self.inited1 = true;
            lvSC:InitListView(self.channelDCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.channelDCount, false);
            lvSC:RefreshAllShownItem();
        end 

        if not self.isLock then
            lvSC:MovePanelToItemIndex(self.channelDCount, 0);
        end
    end

    self.lvSCNormal = lvSC;
end

function ChatBoxUI:OnClickToggleWorld(obj)
    self:OnClickToggleSystem(obj)
    -- self.objSCNormal:SetActive(true);
    -- self.chatPrivate:SetActive(false);
    -- self.chatPrivateList:SetActive(false);
    -- self.objInput:SetActive(true);
    -- self.objInputMsg:SetActive(false);
    -- self.channel = BroadcastChannelType.BCT_World;
    -- self.isLock = false;
    -- self:SetLockState();
    -- self:OnRefNormalList();
    -- self:SetSendBtnCost();
    -- self:SetSendBtnActive(self.objSendBtnWorld);
end

function ChatBoxUI:OnClickToggleSystem(obj)
    self.objSCNormal:SetActive(true);
    self.chatPrivate:SetActive(false);
    self.chatPrivateList:SetActive(false);
    self.objInput:SetActive(false);
    self.objInputMsg:SetActive(false);
    self.channel = BroadcastChannelType.BCT_System;
    self.isLock = false;
    self:SetLockState();
    self:OnRefNormalList();
end

function ChatBoxUI:OnClickTogglePrivate(obj)
    self.objSCNormal:SetActive(false);
    self.chatPrivate:SetActive(false);
    self.chatPrivateList:SetActive(true);
    self.objInput:SetActive(false);
    self.objInputMsg:SetActive(false);
    self.channel = BroadcastChannelType.BCT_Private;
    self:SetSendBtnActive(self.objSendBtnPrivate);
    
    local _callback = function()
        self:OnRefPrivateListUI();
    end
    local sessionList = self.ChatBoxUIDataManager:GetSessionList();
    if #(sessionList) > 0 then
        self.ChatBoxUIDataManager:QuerySessionListMemberInfo(_callback);
    else
        _callback();
    end
end

function ChatBoxUI:OnClickSettingBtn(obj)

    if self.objPanalWorld then
        self.objPanalWorld:GetComponent('Toggle').isOn = self.panalTable[BroadcastChannelType.BCT_World];
    end
    if self.objPanalSystem then
        self.objPanalSystem:GetComponent('Toggle').isOn = self.panalTable[BroadcastChannelType.BCT_System];
    end
    if self.objPanalPrivate then
        self.objPanalPrivate:GetComponent('Toggle').isOn = self.panalTable[BroadcastChannelType.BCT_Private];
    end

    self.objPanalDanmaku:GetComponent('Toggle').isOn = self.panalTable[99];

    self.setting:SetActive(true);
end

function ChatBoxUI:OnClickCloseBtn(obj)
    self.setting:SetActive(false);
end

function ChatBoxUI:SetLockState()
    local bg = self:FindChild(self.objLockBtn, 'Image_BG');
    local lock = self:FindChild(self.objLockBtn, 'Image_Lock');
    local unlock = self:FindChild(self.objLockBtn, 'Image_Unlock');

    if self.isLock then
        bg:SetActive(true);
        lock:SetActive(true);
        unlock:SetActive(false);
    else
        bg:SetActive(false);
        lock:SetActive(false);
        unlock:SetActive(true);
    end
end

function ChatBoxUI:OnClickLockBtn(obj)
    self.lockTable = {};
    for i = 1, #(self.settingToggles) do
        local cp = self.settingToggles[i]:GetComponent('Toggle');
        self.lockTable[self.settingToggles[i].name] = cp.isOn;
    end

    self.isLock = not self.isLock;

    self:SetLockState();
end

function ChatBoxUI:OnClickBackBtn(obj)
    -- self:OnClickTogglePrivate(nil);
    self:OnRefPrivateRedPointCount();
end

function ChatBoxUI:CDTime(cdTime)
    local objStyle1 = self:FindChild(self.objSendBtnWorld, 'Style1');
    local objStyle2 = self:FindChild(self.objSendBtnWorld, 'Style2');
    local objStyle3 = self:FindChild(self.objSendBtnWorld, 'Style3');
    if self.MeridiansDataManager:GetSumLevel() >= SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL then
        objStyle1:SetActive(false);
    else
        objStyle2:SetActive(false);
    end
    objStyle3:SetActive(true);

    self.bSendCD = true;
    self.objSendBtnWorld:GetComponent('Button').enabled = false;
    setUIGray(self.objSendBtnWorld:GetComponent('Image'), true);

    local times = cdTime + 1;
    local comText = self:FindChildComponent(objStyle3, 'Text_Send3', 'Text');

    local wait = CS.UnityEngine.WaitForSeconds(1);
    CS_Coroutine.start(function()
        while cdTime - times < cdTime - 1 do
            times = times - 1;
            comText.text = times .. "秒";
            coroutine.yield(wait);
        end

        local chatBoxUI = GetUIWindow('ChatBoxUI');
        if chatBoxUI then
            self.bSendCD = false;
            self:SetSendBtnCost();
            if self.MeridiansDataManager:GetSumLevel() >= SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL then
                objStyle1:SetActive(true);
            else
                objStyle2:SetActive(true);
            end
            objStyle3:SetActive(false);
            self.objSendBtnWorld:GetComponent('Button').enabled = true;
            setUIGray(self.objSendBtnWorld:GetComponent('Image'), false);
        end
    end)
end

function ChatBoxUI:SendMessageWord(content,speech)
    self.playerID = globalDataPool:getData('PlayerID');
    local comInputField = self.objInputField:GetComponent('InputField');
    local data = {
        content = filter_spec_chars(content, Symbol()) or '',
        speech = speech or '',
        id = tostring(self.playerID),
        name = self.PlayerSetDataManager:GetPlayerName(),
        modelid = tostring(self.PlayerSetDataManager:GetModelID()),
        pictureUrl = self.PlayerSetDataManager:GetCharPictureUrl(),
        headboxid = tostring(self.PlayerSetDataManager:GetHeadBoxID()),
    };

    local kTalkInfo = {};
    kTalkInfo.defPlyID = 0;
    kTalkInfo.acSessionID = '0';
    kTalkInfo.acOpenID = '0';
    kTalkInfo.acVOpenID = '0';
    
    self.objImageEmoji:SetActive(false);
    if not self:GetPrivateOpen() then
        local channel = self.channel;
        local encodeData = DKJson.encode(data);
        SendBroadcastNotice(channel, encodeData, kTalkInfo);
    else
        if not self.curSessionID then
            SystemUICall:GetInstance():Toast('请选择聊天对象');
            return;
        end

        if not PlayerSetDataManager:GetInstance():GetTXCreditSceneLimit(TCSSLS_PRIVATE_CHAT) then 
            OnRecv_TencentCredit_SceneLimit(1,{dwParam = TCSSLS_PRIVATE_CHAT})
            return;
        end
        RequestPrivateChatSceneLimit()
        
        -- TODO 私聊
        local sortDataKey = {'1#content', '2#id', '3#name', '4#modelid', '5#pictureUrl', '6#speech','7#headboxid'};
        local encodeData = DKJson.encode(data);
        local index = 0;
        local tempStr = encodeData;
        local tempTable = {};
        for w in string.gmatch(tempStr, '(".-":".-")') do
            index = index + 1;
            table.insert(tempTable, w);
        end
    
        local sortStrKey = '{1#content,2#id,3#name,4#modelid,5#pictureUrl,6#speech,7#headboxid}';
        for i = 1, #(sortDataKey) do
            for j = 1, #(tempTable) do
                if i .. '#' .. string.match(tempTable[j], '"(.-)":') == sortDataKey[i] then
                    sortStrKey = string.gsub(sortStrKey, sortDataKey[i], tempTable[j]);
                end
            end
        end
        local session = self.ChatBoxUIDataManager:GetSessionByID(self.curSessionID);
        if session then
            local otherMember = self.ChatBoxUIDataManager:GetOtherMember(session.members);
            local otherData = self.SocialDataManager:GetOtherPlayerData(otherMember);
            if otherData then
                kTalkInfo.defPlyID = tonumber(otherMember);
                kTalkInfo.acSessionID = self.curSessionID;
                kTalkInfo.acOpenID = (otherData.ext and otherData.ext.acOpenID) or kTalkInfo.acOpenID;
                kTalkInfo.acVOpenID = (otherData.ext and otherData.ext.acVOpenID) or kTalkInfo.acVOpenID;
                SendBroadcastNotice(SPCCT_PRIVATE, sortStrKey, kTalkInfo);
            end
        end
    end

    --
    if self.channel == BroadcastChannelType.BCT_World then
        self:CDTime(3);
    end

    comInputField.text = '';
end

function ChatBoxUI:OnClickSendBtn(obj, speechFileID, speechContent)

    if not IsGameServerMode() then
        SystemUICall:GetInstance():Toast('请检测网路是否链接');
        return;
    end
    
    local content = nil;
    local speech = nil;
    local comInputField = self.objInputField:GetComponent('InputField');
    if not speechFileID then
        content = comInputField.text;
        if content == '' then
            SystemUICall:GetInstance():Toast('请输入文字');
            return;
        end
    else
        speech = speechFileID;
        -- 防止语音翻译为空
        content = speechContent;
        if speech == '' or speech == nil then
            SystemUICall:GetInstance():Toast('语言消息不能为空');
            return;
        end
    end

    if not speechFileID and string.utf8len(content) > 30 then 
        SystemUICall:GetInstance():Toast('输入内容超过字数限制(30)');
        return;
    end 

    if self.channel == BroadcastChannelType.BCT_World then
        local getPlayerSliver = self.PlayerSetDataManager:GetPlayerSliver();
        if getPlayerSliver <= 0 and SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL > 0 then
            self.PlayerSetDataManager:RequestSpendSilver(1,function()
                self:SendMessageWord(content,speech)
            end)
            return
        else
            local playerid = tostring(globalDataPool:getData("PlayerID"));
            local _callback = function()
                local generalBoxUI = GetUIWindow('GeneralBoxUI');
                if generalBoxUI and generalBoxUI:GetCheckBoxState() then
                    SetConfig(playerid .. '#HideChatBoxSend', true);
                end
                self:SendMessageWord(content,speech);
            end
            
            if GetConfig(playerid .. '#HideChatBoxSend') then
                self:SendMessageWord(content,speech);
            else
                if self.MeridiansDataManager:GetSumLevel() >= SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL then
                    self:SendMessageWord(content,speech);
                else
                    local strText = string.format('是否花费1银锭发送世界聊天？\n经脉等级%d级以后免费！', SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL);
                    OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strText, _callback, { confirm = 1, cancel = 1, close = 1, checkBox = 1 } });
                end
            end
            return;
        end
    end

    self:SendMessageWord(content,speech)
end

function ChatBoxUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnClickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ChatBoxUI:GetPrivateOpen()
    return self.chatPrivate.activeSelf;
end

function ChatBoxUI:OnEnable()
    local pos = self._gameObject.transform.localPosition;
    self._gameObject.transform.localPosition = DRCSRef.Vec3(pos.x, pos.y, 0);

    --RequestPrivateChatSceneLimit()
end

function ChatBoxUI:OnDisable()

end

function ChatBoxUI:OnDestroy()

    local funcNameT = {
        'mOnBeginDragAction',
        'mOnDragingAction',
        'mOnEndDragAction',
        'mOnGetItemByIndex',
    }

    local lvSCT = {};
    table.insert(lvSCT, self.lvSCNormal);
    table.insert(lvSCT, self.lvSCPlayerList);

    for i = 1, #(lvSCT) do
        for j = 1, #(funcNameT) do
            lvSCT[i][funcNameT[j]] = nil;
        end
    end

    if self.lvSCSmall then
        self.lvSCSmall.mOnGetItemByIndex = nil;
    end
    if self.lvSCPrivateMsg then
        self.lvSCPrivateMsg.mOnGetItemByIndex = nil;
    end

    LuaClassFactory:GetInstance():ReturnAllUIClass(self.objs_headboxInst or {})

end

-- Speech start
function ChatBoxUI:InitSpeech()
    dprint('ChatBoxUI:InitSpeech');

    -- 语音动画
    local speechRoot = self:FindChild(self._gameObject, 'SpeechRoot');
    self.mSpeechAni = self:FindChild(speechRoot, 'SpeechAni');
    self.mSpeechCancel = self:FindChild(speechRoot, 'SpeechCancel');
    self.mSpeechAni:SetActive(false);
    self.mSpeechCancel:SetActive(false);

    -- TODO: 引用需要放在文件最顶端吗？
    local util = require("xlua/util")
    local speechButton = self.objInputFieldMsg:GetComponent("SpeechButton")
    speechButton:Register(util.bind(self.OnClickStartRecord, self), util.bind(self.OnClickStopRecord, self), util.bind(self.OnCancelRecord, self), util.bind(self.OnRecordMoveUp, self))
end

local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown

function ChatBoxUI:Update()
    -- GVoice更新，用于定时检测回调
    if IsNotInGuide() and GetKeyDownByFuncType(FuncType.OpenOrCloseCityRoleListUI) then
        if self.isExtend then
            self:OnClickExtenBtn(self.objShrinkBtn, false);
            self.isExtend=false
        else
            self:OnClickExtenBtn(self.objExtendBtn, true);
            self.isExtend=true
        end
    end

    GVoiceHelper:Pool()
    
end

function ChatBoxUI:OnClickStartRecord()
    dprint("OnClickStartRecord")
    if GVoiceHelper:StartRecord() then
        self:ShowSpeechState(true, false);
    end
end

function ChatBoxUI:OnClickStopRecord()
    dprint("OnClickStopRecord")

    self:ShowSpeechState(false, false);

    GVoiceHelper:StopRecord(
        function(fileID, result)
            local len = string.len(result)
            -- GVoice转的空文本并非是空字符，是ASCII码为0的字符
            if len > 1 or (len == 1 and string.byte(result) ~= 0) then
                self:OnClickSendBtn(nil, fileID, result);
            end
        end
    )
end

function ChatBoxUI:OnCancelRecord()
    dprint("OnCancelRecord")

    self:ShowSpeechState(false, false);
    
    GVoiceHelper:StopRecord();
end

-- 直接传moveUp会卡住，难道是因为不是bool类型？
function ChatBoxUI:OnRecordMoveUp(moveUp)
    self:ShowSpeechState(moveUp == false, moveUp == true);
end

function ChatBoxUI:ShowSpeechState(showAni, showCancel)
    self.mSpeechCancel:SetActive(showCancel);
    self.mSpeechAni:SetActive(showAni);
end

-- Speech end

return ChatBoxUI
