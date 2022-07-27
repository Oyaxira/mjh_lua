PKTipUI = class("PKTipUI", BaseWindow)

local Util = require("xlua/util")

function PKTipUI:ctor()
    local obj = LoadPrefabAndInit("PKUI/PKTipUI", TIPS_Layer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKTipUI:Create()
    self.mLabCurTip = self:FindChildComponent(self._gameObject, "LabCurTip", "Text")
    self.mLabNextTip = self:FindChildComponent(self._gameObject, "LabNextTip", "Text")

    self.mLabTime = self:FindChildComponent(self._gameObject, "LabTime", "Text")

    local objWatch = self:FindChild(self._gameObject, "RoleEmbattleItemUI")
    self.mWatchGroup = {
        Root = objWatch,
        LabName = self:FindChildComponent(objWatch, "Name_Text", "Text"),
        ImgHead = self:FindChildComponent(objWatch, "Head_Dispositions/head", "Image")
    }
    self:AddButtonClickListener(
        self:FindChildComponent(objWatch, "Button_Watch1", "Button"),
        Util.bind(self.OnClickWatch, self)
    )
    self:AddButtonClickListener(
        self:FindChildComponent(objWatch, "Button_Watch2", "Button"),
        Util.bind(self.OnClickWatch, self)
    )

    local btnSelect = self:FindChild(self._gameObject, "BtnSelect")
    self.mBtnSelect = {
        Root = btnSelect,
        Img = btnSelect:GetComponent("Image"),
        LabName = self:FindChildComponent(btnSelect, "LabName", "Text")
    }
    self:AddButtonClickListener(self.mBtnSelect.Root:GetComponent("Button"), Util.bind(self.OnClickSelect, self))
    self:SetSelectActive(false)
end

function PKTipUI:Init()
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RoundStart, self.OnRoundStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RoundEnd, self.OnRoundEnd, self)

    local pkConfig = GetTableData("PKConfig", 1) or {}
    if pkConfig["PreSelect"] == 1 then
        LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.PreSelect, self.OnPreSelect, self)
        LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RefreshPreSelect, self.OnRefreshPreSelect, self)
    end
end

function PKTipUI:OnDestroy()
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RoundStart, self.OnRoundStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RoundEnd, self.OnRoundEnd, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.PreSelect, self.OnPreSelect, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RefreshPreSelect, self.OnRefreshPreSelect, self)
end

function PKTipUI:RefreshUI()
end

function PKTipUI:OnEnable()
    -- 刷新界面
    self:Reset()
end

function PKTipUI:OnDisable()
end

function PKTipUI:Update()
    local roomData = PKManager:GetInstance():GetRoomData()
    if roomData and roomData.EndTime then
        self:RefreshTime(roomData.EndTime)
    end
end

-- 根据PKManager重置界面
function PKTipUI:Reset()
    local roomData = PKManager:GetInstance():GetRoomData()
    if roomData then
        self:OnRoundStart(roomData)
    else
        self:Hide()
    end
end

function PKTipUI:RefreshTip(round)
    local pkProcess = GetTableData("PKProcess", round) or {}
    self.mLabCurTip.text = pkProcess.NameID ~= nil and GetLanguageByID(pkProcess.NameID) or ""

    local nextRound = round + 1
    pkProcess = GetTableData("PKProcess", nextRound) or {}
    self.mLabNextTip.text = pkProcess.NameID ~= nil and GetLanguageByID(pkProcess.NameID) or ""

    -- 筛选出下一轮的战斗
    self.mWatchGroup.Root:SetActive(false)
    self.mWatchPlayer = nil
    self.mWatchBoss = nil
    local pkProcessDetialList = TableDataManager:GetInstance():GetTable("PKProcessDetail")
    for _, pkProcessDetial in pairs(pkProcessDetialList) do
        if pkProcessDetial.RoundID == nextRound then
            if pkProcessDetial.EventID == 4 then
                -- PVE
                local roomData = PKManager:GetInstance():GetRoomData()
                local fightID = roomData["FightID"] or 0
                if fightID == 0 then
                    break
                end

                local battleData = GetTableData("Battle", fightID) or {}
                local roleTypeID = (battleData["BossList"] or {})[1] or 0
                local role = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleTypeID)
                local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)

                if role and artData then
                    self.mWatchGroup.LabName.text = GetLanguageByID(role["NameID"])
                    self:SetSpriteAsync(artData.Head, self.mWatchGroup.ImgHead)

                    self.mWatchBoss = roleTypeID

                    self.mWatchGroup.Root:SetActive(true)
                end
                break
            elseif pkProcessDetial.EventID == 5 then
                -- PVP
                local roomData = PKManager:GetInstance():GetRoomData()
                local playerID = roomData["NextBattlePlayerID"]
                local playerList = roomData["PlayerList"] or {}

                if playerID then
                    for _, player in pairs(playerList) do
                        player = player["kPlyData"] or {}
                        if player["defPlayerID"] == playerID then
                            self.mWatchGroup.LabName.text = player["acPlayerName"]
                            GetHeadPicByData(
                                player,
                                function(sprite)
                                    self.mWatchGroup.ImgHead.sprite = sprite
                                end
                            )
                            self.mWatchPlayer = playerID
                            self.mWatchGroup.Root:SetActive(true)
                            break
                        end
                    end
                else
                    local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
                    local battlePlayer = nil
                    for i = 0, #playerList, 2 do
                        local battlePlayer1 = (playerList[i] or {})["kPlyData"] or {}
                        local battlePlayer2 = (playerList[i + 1] or {})["kPlyData"] or {}
                        local battlePlayerID1 = battlePlayer1["defPlayerID"]
                        local battlePlayerID2 = battlePlayer2["defPlayerID"]

                        if battlePlayerID1 == ownerID then
                            battlePlayer = battlePlayer2
                            break
                        elseif battlePlayerID2 == ownerID then
                            battlePlayer = battlePlayer1
                            break
                        end
                    end

                    if battlePlayer then
                        self.mWatchGroup.LabName.text = battlePlayer["acPlayerName"]
                        GetHeadPicByData(
                            battlePlayer,
                            function(sprite)
                                local uiWindow = GetUIWindow("PKTipUI")
                                if (uiWindow) then
                                    self.mWatchGroup.ImgHead.sprite = sprite
                                end
                            end
                        )

                        self.mWatchPlayer = battlePlayer["defPlayerID"]
                        self.mWatchGroup.Root:SetActive(true)
                    end
                end
                break
            end
        end
    end
end

function PKTipUI:RefreshTime(endTime)
    local diffTime = endTime - os.time()
    self.mLabTime.text = tostring(math.max(0, math.ceil(diffTime)))
end

function PKTipUI:Hide()
    self.mLabCurTip.text = ""
    self.mLabNextTip.text = ""
    self.mLabTime.text = ""
end

function PKTipUI:OnRoundStart(data)
    if data and data.EndTime then
        self:RefreshTime(data.EndTime)
    end

    local roomData = PKManager:GetInstance():GetRoomData() or {}
    local round = roomData["RoundID"] or 0
    self:RefreshTip(round)
end

function PKTipUI:OnRoundEnd()
end

function PKTipUI:OnClickWatch()
    if self.mWatchBoss then
        PKManager:GetInstance():ShowPVEWatchUI(self.mWatchBoss)
    elseif self.mWatchPlayer then
        PKManager:GetInstance():ShowPVPWatchUI(self.mWatchPlayer)
    end
end

function PKTipUI:OnClickSelect()
    if not self:GetSelectActive() then
        SystemUICall:GetInstance():Toast("选卡已结束", false)
        return
    end

    local endType = PKManager:GetInstance():GetEndType()
    if endType == PKManager.END_TYPE.Die then
        return
    end
    
    OpenWindowImmediately("PKSelectUI")
end

function PKTipUI:OnPreSelect(show)
    self:SetSelectActive(show)

    self:OnRefreshPreSelect()
end

function PKTipUI:OnRefreshPreSelect()
    if self.mBtnSelect.Root.activeSelf then
        local endType = PKManager:GetInstance():GetEndType()

        local tip = "提前选卡"
        local selectActive = self:GetSelectActive()

        if endType == PKManager.END_TYPE.Die then
            tip = "已淘汰,不能选卡"
            selectActive = false
        end

        self.mBtnSelect.LabName.text = tip
        setUIGray(self.mBtnSelect.Img, not selectActive)
    end
end

function PKTipUI:SetSelectActive(active)
    self.mBtnSelect.Root:SetActive(active)
end

function PKTipUI:GetSelectActive()
    local playerData = PKManager:GetInstance():GetPlayerData()
    if playerData then
        local round = playerData["RoundID"]
        if (round or 0) == 0 then
            return false
        end

        return true
    end

    return false
end

return PKTipUI
