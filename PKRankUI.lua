PKRankUI = class("PKRankUI", BaseWindow)

local Util = require("xlua/util")

local PKRankBox = require("UI/PKUI/PKRankBox")

local PKRankNameBox = require("UI/PKUI/PKRankNameBox")

function PKRankUI:ctor()
    local obj = LoadPrefabAndInit("PKUI/PKRankUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKRankUI:Create()
    local index = 1

    self.mRankRoot = self:FindChild(self._gameObject, "RankGroup/ScrollRank/Viewport/Content")

    local rankTitle = self:FindChild(self._gameObject, "RankGroup/RankTitle")
    self.mLabRankTitleList = BoxHelper.GetComponentList("Text", rankTitle, "RankTitle%d/LabName")

    self.mBtnPre = self:FindChild(rankTitle, "BtnPre")
    self:AddButtonClickListener(self.mBtnPre:GetComponent("Button"), Util.bind(self.OnClickRankPre, self))

    self.mBtnNext = self:FindChild(rankTitle, "BtnNext")
    self:AddButtonClickListener(self.mBtnNext:GetComponent("Button"), Util.bind(self.OnClickRankNext, self))

    self.mNameRoot = self:FindChild(self._gameObject, "NameGroup/ScrollName/Viewport/Content")
end

function PKRankUI:Init()
end

function PKRankUI:OnEnable()
    OpenWindowBar(
        {
            ["windowstr"] = "PKRankUI",
            ["bSaveToCache"] = false
        }
    )
end

function PKRankUI:OnDisable()
    RemoveWindowBar("PKRankUI")
end

-- Index = 1,
-- NextRound = 2,
-- RankTitleList = {"64", "32", "16", "8", "6", "2"},
-- RankNumList = {64, 32, 16, 8, 6, 2},
-- ShowColNum = {4, 2, 1},
-- PlayerList = playerList,
-- KeyToBattle = keyToBattle
function PKRankUI:RefreshUI(data)
    -- 把数据转一下
    local totalRound = #data.RankNumList
    local roundToPlayerList = {}
    for round = 1, totalRound do
        roundToPlayerList[round] = {}
    end
    for playerIndex = 1, #data.PlayerList do
        local playerData = data.PlayerList[playerIndex]
        local loseRound = playerData.LoseRound

        if loseRound then
            for round = 1, loseRound - 1 do
                table.insert(roundToPlayerList[round], playerData)
            end
        else
            for round = 1, data.NextRound do
                table.insert(roundToPlayerList[round], playerData)
            end
        end
    end
    self.mRoundToPlayerList = roundToPlayerList

    self.mRankData = data
    self:ShowRank()
    self:ShowPlayer()

    -- 打开窗口的时候，重置下名字的滚动条
    self.mNameRoot.transform.localPosition = DRCSRef.Vec3Zero
end

function PKRankUI:OnDestroy()
    self.mRankData = nil
end

function PKRankUI:OnClickClose()
    RemoveWindowImmediately("PKRankUI")
end

-- 显示左边的排位
function PKRankUI:ShowRank()
    local data = self.mRankData

    local diffRankTitle = #self.mLabRankTitleList - 1
    local minIndex = 1
    local maxIndex = #data.RankTitleList - diffRankTitle
    data.Index = math.min(math.max(data.Index, minIndex), maxIndex)

    self.mBtnPre:SetActive(data.Index > minIndex)
    self.mBtnNext:SetActive(data.Index < maxIndex)

    self:UnloadBoxPool(PKRankBox)

    -- 刷新RankTitle
    for col = 1, 1 + diffRankTitle do
        local round = col + data.Index - 1
        self.mLabRankTitleList[col].text = data.RankTitleList[round]
    end

    -- 刷新玩家信息
    local maxColNum = data.ShowColNum[1]
    local maxRankNum = math.floor(data.RankNumList[data.Index] / maxColNum)
    for row = 1, maxRankNum do
        local rankBox = self:GetBox(PKRankBox, self.mRankRoot)

        local rowData = {}
        for col = 1, #data.ShowColNum do
            rowData[col] = {}

            local round = col + data.Index - 1
            local colNum = data.ShowColNum[col]

            local playerDataList = self.mRoundToPlayerList[round]
            local playerList = rowData[col]

            local playerStartIndex = (row - 1) * colNum
            for playerIndex = playerStartIndex + 1, playerStartIndex + colNum do
                local playerData = playerDataList[playerIndex]
                local lienKey = tostring(col) .. "_" .. tostring((playerIndex - 1) % 2 + 1)
                if playerData then
                    -- 计算玩家的状态
                    local state = PKRankPlayerBox.State.None
                    if playerData.LoseRound and playerData.LoseRound == round + 1 then
                        state = PKRankPlayerBox.State.Lose
                    elseif
                        (playerData.LoseRound and playerData.LoseRound < data.NextRound + 1) or
                            (playerData.LoseRound == nil and round < data.NextRound)
                     then
                        state = PKRankPlayerBox.State.Win
                    end
                    table.insert(
                        playerList,
                        {
                            ID = playerData.ID,
                            Name = playerData.Name,
                            charPicUrl = playerData.charPicUrl,
                            dwModelID = playerData.dwModelID,
                            State = state,
                            LineKey = lienKey,
                            OnClickHead = function()
                                self:OnClickHead(playerData)
                            end,
                            OnClickReplay = function()
                                self:OnClickReplay(round + 1, data.KeyToBattle, playerData)
                            end
                        }
                    )
                else
                    table.insert(
                        playerList,
                        {
                            State = PKRankPlayerBox.State.NotStart,
                            LineKey = lienKey,
                            OnClickHead = nil,
                            OnClickBattle = nil
                        }
                    )
                end
            end
        end

        rankBox:Refresh(rowData)
    end

    -- 滚动条归位
    self.mRankRoot.transform.localPosition = DRCSRef.Vec3Zero
end

-- 显示右边的玩家名字列表
function PKRankUI:ShowPlayer()
    local data = self.mRankData

    local winIndex = 0
    local loseIndex = #data.PlayerList
    self:UnloadBoxPool(PKRankNameBox)
    for index, playerData in pairs(data.PlayerList) do
        -- if not playerData.Robot then
        local nameBox = self:GetBox(PKRankNameBox, self.mNameRoot)
        local lose = playerData.LoseRound and playerData.LoseRound > 0 or false

        -- 刷新box
        nameBox:Refresh(
            {
                Name = playerData.Name,
                Lose = lose
            }
        )

        -- 排序（淘汰置底）
        if lose then
            nameBox:SetSiblingIndex(loseIndex)
            loseIndex = loseIndex - 1
        else
            nameBox:SetSiblingIndex(winIndex)
            winIndex = winIndex + 1
        end
        -- end
    end
end

function PKRankUI:OnClickRankPre()
    self.mRankData.Index = self.mRankData.Index - 1
    self:ShowRank()
end

function PKRankUI:OnClickRankNext()
    self.mRankData.Index = self.mRankData.Index + 1
    self:ShowRank()
end

function PKRankUI:OnClickHead(playerData)
    dprint("OnClickHead: " .. playerData.Name)

    PKManager:GetInstance():ShowPVPWatchUI(playerData.ID)
end

function PKRankUI:OnClickReplay(round, keyToBattle, playerData)
    local battleID = keyToBattle[round .. "_" .. playerData.ID]
    if battleID then
        PKManager:GetInstance():RequestRecord(battleID)
    end
end

return PKRankUI
