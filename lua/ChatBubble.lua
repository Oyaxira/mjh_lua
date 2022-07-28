ChatBubble = class('ChatBubble', BaseWindow);

function ChatBubble:ctor(info)
    self.bubbleCache = {};
    self.bubbleInstDict = {};

    if not info then
        return;
    end
    self.parent = info.parent;
end

function ChatBubble:Create()
	local obj = LoadPrefabAndInit('TownUI/ChatBubble', self.parent or UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
    
end

function ChatBubble:Init()
    
end

function ChatBubble:RefreshUI(bubbleInfo)
    if type(bubbleInfo) == 'table' then
        self:AddChatBubble(bubbleInfo);
    end
end

function ChatBubble:OnDisable()

end

function ChatBubble:OnEnable()

end

function ChatBubble:OnDestroy()

end

function ChatBubble:AddChatBubble(bubbleInfo)

    local curchatCount = #(self.bubbleCache);
    if curchatCount >= MAX_TOAST_COUNT then 
        table.insert(self.bubbleCache, bubbleInfo);
        return;
    end

    local chatInst = self:GetAvaliableBubbleInst();
    if chatInst == nil then
        return;
    end

    local comRect = chatInst:GetComponent('RectTransform');
    local objText = self:FindChild(chatInst, 'Text');
    local comTextRect = objText:GetComponent('RectTransform');
    local comText = objText:GetComponent('Text');

    self:ResetBubbleInst(chatInst);
    if tonumber(bubbleInfo['text']) ~= nil then
        languageID = tonumber(bubbleInfo['text']);
        bubbleInfo['text'] = GetLanguageByID(languageID) or '';
    end
    comText.text = bubbleInfo['text'];

    DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(comTextRect);
    comRect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, comTextRect.rect.width + 10);
    comRect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, comTextRect.rect.height + 8);
    
    local comCanvasGroup = chatInst:GetComponent("CanvasGroup");
    local tween = Twn_CanvasGroupFade(nil, comCanvasGroup, 0, 1, 0.5, 0, function()
        local tween1 = Twn_CanvasGroupFade(nil, comCanvasGroup, 1, 0, 0.5, 3, function()
            if chatInst.gameObject then 
                chatInst.gameObject:SetActive(false);
            end
            local chatBubble = GetUIWindow("ChatBubble")
            if chatBubble then
                chatBubble:ShowNextBubble()
            end
        end);
    end);
end

function ChatBubble:ShowNextBubble()
    if not next(self.bubbleCache) then
        return;
    end

    local bubbleInfo = table.remove(self.bubbleCache, 1);
    self:AddChatBubble(bubbleInfo);
end

function ChatBubble:GetAvaliableBubbleInst()

    self.bubbleInstDict = self.bubbleInstDict or {};
    for _, bubbleInst in ipairs(self.bubbleInstDict) do 
        if not bubbleInst.gameObject.activeSelf then 
            return bubbleInst;
        end
    end

    local bubbleInst = LoadPrefabAndInit("TownUI/ChatBubble_Item", self._gameObject, true);
    table.insert(self.bubbleInstDict, bubbleInst);
    return bubbleInst;
end

function ChatBubble:ResetBubbleInst(bubbleInst)
    bubbleInst.transform:SetAsLastSibling();
    bubbleInst:SetActive(true);
    local comCanvasGroup = bubbleInst:GetComponent("CanvasGroup");
    comCanvasGroup.alpha = 0;
end

return ChatBubble;