ArenaUIMatchRecode = class('ArenaUIMatchRecode', BaseWindow);

local MatchType = {'32强赛','16强赛','8强赛','半决赛','决赛', '娱乐赛'}
local MatchType1 = {'32强赛','16强赛','8强赛','半决赛','决赛'}
local MatchType2 = {'16强赛','8强赛','半决赛','决赛'}
local MatchType3 = {'8强赛','半决赛','决赛'}
local Round = {32, 16, 8, 4, 2, 1}
local Round2 = {16, 8, 4, 2}
local Round3 = {8, 4, 2}

local whiteColor = DRCSRef.Color(0.9, 0.9, 0.9, 1);
local blackColor = DRCSRef.Color(0x32 / 255, 0x32 / 255, 0x32 / 255, 1);

function ArenaUIMatchRecode:ctor(info)
    self._script = info;
    self.bindBtnTable = {};
    self.toggleTable = {};
end

function ArenaUIMatchRecode:Create()
    local arenaUI = GetUIWindow('ArenaUI');
        if arenaUI and arenaUI:IsOpen() then
        local obj = LoadPrefabAndInit('ArenaUI/MatchRecode', arenaUI.objArenaUIMatchRecode or UI_UILayer, true);
        if obj then
            self:SetGameObject(obj);
        end
    end
end

function ArenaUIMatchRecode:Init()

    self.ArenaDataManager = ArenaDataManager:GetInstance();
    self.TableDataManager = TableDataManager:GetInstance():GetTable("RoleModel");

    --
    self.objImageMask = self:FindChild(self._gameObject, 'Image_Mask');
    self.objTextTips = self:FindChild(self._gameObject, 'Text_Tips');
    self.objSCLeft = self:FindChild(self._gameObject, 'SC_Left');
    self.objSCRight = self:FindChild(self._gameObject, 'SC_Right');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');

    --
    self.objSCLeftContent = self:FindChild(self.objSCLeft, 'Viewport/Content');
    self.objSCRightContent = self:FindChild(self.objSCRight, 'Viewport/Content');

    --
    table.insert(self.bindBtnTable, self.objImageMask);
    table.insert(self.bindBtnTable, self.objCloseBtn);

    self:BindBtnCB();

end

function ArenaUIMatchRecode:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIMatchRecode:OnclickBtn(obj, boolHide)
    if obj == self.objImageMask or obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function ArenaUIMatchRecode:OnClickCloseBtn(obj)
    RemoveWindowImmediately("ArenaUIMatchRecode");
end

function ArenaUIMatchRecode:OnRefSCLeft()
    
    self:RemoveAllChildToPoolAndClearEvent(self.objSCLeftContent.transform);

    self.toggleTable = {};
    for i = 1, #(self.tMatchType) do
        local objToggle = self:LoadPrefabFromPool('ArenaUI/Toggle_Rank', self.objSCLeftContent);
        table.insert(self.toggleTable, objToggle);

        local comText = self:FindChildComponent(objToggle, 'Text', 'Text');
        comText.text = self.tMatchType[i];

        local _callback = function(gameObject)
            self:OnClickRankToggle(gameObject, self.tRound[i], i);
        end
        self:CommonBind(objToggle, _callback);
    end
end

function ArenaUIMatchRecode:OnClickRankToggle(obj, data, index)
    self:SetTogState(obj);
    self:OnRefSCRight(data, index);
end

function ArenaUIMatchRecode:SetTogState(gameObject)
    for k, v in pairs(self.objSCLeftContent.transform) do
        if gameObject == v.gameObject then
            self:FindChild(v.gameObject, 'Toggle'):SetActive(true);
            self:FindChildComponent(v.gameObject, 'Text', 'Text').color = whiteColor;
        else
            self:FindChild(v.gameObject, 'Toggle'):SetActive(false);
            self:FindChildComponent(v.gameObject, 'Text', 'Text').color = blackColor;
        end
    end
end

function ArenaUIMatchRecode:OnRefSCRight(data, index)

    if not self.info then
        return;
    end

    local battleData = self.ArenaDataManager:GetBattleDataBy(self.info.dwMatchType, self.info.dwMatchID);
    self.battleData = battleData[data];
    
    if not self.battleData or data < self.info.dwRoundID then
        self.battleData = {};
    end

    if index == #(Round) then
        self.battleData = self.ArenaDataManager:GetJokeData();
        if self.info.uiSignUpPlace ~= 100 then
            SystemUICall:GetInstance():Toast('我没有参加娱乐赛');
        end 
    else
        if self.battleData and not next(self.battleData) then
            SystemUICall:GetInstance():Toast('比赛尚未开始');
        end
    end

    local lvSC = self.objSCRight:GetComponent('LoopListView2');
    local scrollRect = self.objSCRight:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_Right');
            self:OnScrollChanged(obj.gameObject, self.battleData[index + 1], index);
            return obj;
        end
        
        self.count = getTableSize2(self.battleData);
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.count, _func);
        else
            lvSC:SetListItemCount(self.count, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCRight = lvSC;
    end
end

function ArenaUIMatchRecode:OnScrollChanged(gameObject, data, index)
    gameObject:SetActive(true);
    self:SetItemSingle(gameObject, data);
end

function ArenaUIMatchRecode:SetItemSingle(gameObject, data)

    if not data then
        return;
    end

    local tbMatchData = self.ArenaDataManager:GetTBMatchData() or {};
    local tempData = tbMatchData[self.info.dwMatchType];
    
    if not tempData then
        return;
    end

    local objPlayer1 = self:FindChild(gameObject, 'Player1');
    local objPlayer2 = self:FindChild(gameObject, 'Player2');
    local objPlayBtn = self:FindChild(gameObject, 'Button_Play');
    local objImage = self:FindChild(gameObject, 'Image');
    
    --
    local objPlayBtn1 = self:FindChild(objPlayer1, 'Button_Head');
    local objImageOdds1 = self:FindChild(objPlayer1, 'Image_Odds');
    local objImageVic1 = self:FindChild(objPlayer1, 'Image_Vic');
    local objImageDef1 = self:FindChild(objPlayer1, 'Image_Def');
    local objTextName1 = self:FindChild(objPlayer1, 'Text_Name');
    local objImage1 = self:FindChild(objPlayer1, 'Image');
    local objHeadImage1 = self:FindChild(objPlayer1, 'Head/Mask/Image');
    local objTextMul1 = self:FindChild(objImageOdds1, 'Text_Mul');
    
    --
    local objPlayBtn2 = self:FindChild(objPlayer2, 'Button_Head');
    local objImageOdds2 = self:FindChild(objPlayer2, 'Image_Odds');
    local objImageVic2 = self:FindChild(objPlayer2, 'Image_Vic');
    local objImageDef2 = self:FindChild(objPlayer2, 'Image_Def');
    local objTextName2 = self:FindChild(objPlayer2, 'Text_Name');
    local objImage2 = self:FindChild(objPlayer2, 'Image');
    local objHeadImage2 = self:FindChild(objPlayer2, 'Head/Mask/Image');
    local objTextMul2 = self:FindChild(objImageOdds2, 'Text_Mul');

    --
    local _callbackHead1 = function(obj)
        if not data.isJok then
            SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA, self.info.dwMatchType, self.info.dwMatchID, data.dwRoundID, data.dwBattleID, data.kPly1Data.defPlayerID);
        else
            SystemUICall:GetInstance():Toast('娱乐赛无法观察');
        end
    end
    self:CommonBind(objPlayBtn1, _callbackHead1);
    
    local _callbackHead2 = function(obj)
        if not data.isJok then
            SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA, self.info.dwMatchType, self.info.dwMatchID, data.dwRoundID, data.dwBattleID, data.kPly2Data.defPlayerID);
        else
            SystemUICall:GetInstance():Toast('娱乐赛无法观察');
        end
    end
    self:CommonBind(objPlayBtn2, _callbackHead2);

    --
    local _callbackPlay = function(obj)
        ArenaDataManager:GetInstance():RePlay(self.info.dwMatchType, self.info.dwMatchID,data)
    end
    self:CommonBind(objPlayBtn, _callbackPlay);

    --
    local totalMoney = data.dwPly1BetRate + data.dwPly2BetRate;
    local bShowBet = (tempData.CanBet > 0) or (not data.isJoke);
    objTextName1:GetComponent('Text').text = data.kPly1Data.acPlayerName;
    local betRate1 = (totalMoney * 0.9) / (data.dwPly1BetRate);
    betRate1 = betRate1 < 1.01 and 1.01 or betRate1;
    objTextMul1:GetComponent('Text').text = string.format('%0.02f', betRate1);
    objTextMul1:SetActive(bShowBet);
    objTextName2:GetComponent('Text').text = data.kPly2Data.acPlayerName;
    local betRate2 = (totalMoney * 0.9) / (data.dwPly2BetRate);
    betRate2 = betRate2 < 1.01 and 1.01 or betRate2;
    objTextMul2:GetComponent('Text').text = string.format('%0.02f', betRate2);
    objTextMul2:SetActive(bShowBet);

    local modelData1 = self.TableDataManager[data.kPly1Data.dwModelID];
    local modelData2 = self.TableDataManager[data.kPly2Data.dwModelID];
    if modelData1 then
        local comImage = objHeadImage1:GetComponent('Image');
        comImage.sprite = GetSprite(modelData1.Head);
    end
    if modelData2 then
        local comImage = objHeadImage2:GetComponent('Image');
        comImage.sprite = GetSprite(modelData2.Head);
    end

    if data.defPlyWinner == 0 and not data.isJoke then
        objImageVic1:SetActive(false);
        objImageDef1:SetActive(false);
        objImage1:SetActive(false);
        objImageVic2:SetActive(false);
        objImageDef2:SetActive(false);
        objImage2:SetActive(false);
        objPlayBtn:SetActive(false);
        objImage:SetActive(true);
    else
        objPlayBtn:SetActive(data.isJoke ~= 1);
        objImage:SetActive(data.isJoke == 1);
        if data.defPlyWinner == data.kPly1Data.defPlayerID then
            objImageVic1:SetActive(true);
            objImageDef1:SetActive(false);
            objImageVic2:SetActive(false);
            objImageDef2:SetActive(true);
        else
            objImageVic1:SetActive(false);
            objImageDef1:SetActive(true);
            objImageVic2:SetActive(true);
            objImageDef2:SetActive(false);
        end
    end

    if data.defBetPlyID == 0 then
        objImage1:SetActive(false);
        objImage2:SetActive(false);
    else
        if data.defBetPlyID == data.kPly1Data.defPlayerID then
            objImage1:SetActive(true);
            objImage2:SetActive(false);
        else
            objImage1:SetActive(false);
            objImage2:SetActive(true);
        end
    end
end

function ArenaUIMatchRecode:RefreshUI(info)
    self.info = info;
    self.tRound = Round;
    self.tMatchType = MatchType;
    if self.info.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        self.tRound = Round3;
        self.tMatchType = MatchType3;
    elseif self.info.dwMatchType == ARENA_TYPE.DA_ZHONG then
        self.tRound = Round2;
        self.tMatchType = MatchType2;
    elseif self.info.dwMatchType > ARENA_TYPE.DA_SHI then
        self.tRound = Round;
        self.tMatchType = MatchType1;
    end

    self:OnRefSCLeft();
    self:OnClickRankToggle(self.toggleTable[1], self.tRound[1], 1);
end

function ArenaUIMatchRecode:OnDisable()

end

function ArenaUIMatchRecode:OnEnable()

end

function ArenaUIMatchRecode:OnDestroy()
    if self.lvSCRight then
        self.lvSCRight.mOnGetItemByIndex = nil;
    end
end

return ArenaUIMatchRecode;