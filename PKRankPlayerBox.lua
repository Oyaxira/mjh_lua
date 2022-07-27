PKRankPlayerBox = class("PKRankPlayerBox", BaseBox)

local Util = require("xlua/util")

local Color_Green = DRCSRef.Color(0.86, 0.9, 0.73, 1)

PKRankPlayerBox.State = {
    None = 0,
    NotStart = 1,
    Win = 2,
    Lose = 3
}

function PKRankPlayerBox:ctor(root)
    self:Super(root)

    self.mImgBG = self:FindChildComponent(self.Root, "ImgBG", "Image")

    local playerBox = self:FindChild(self.Root, "PlayerBox")
    self.mPlayerGroup = {
        Root = self:FindChild(playerBox, "PlayerGroup"),
        LabName = self:FindChildComponent(playerBox, "PlayerGroup/LabName", "Text"),
        ImgHead = self:FindChildComponent(playerBox, "PlayerGroup/BtnHead/Mask/ImgHead", "Image")
    }
    self.mNotStartGroup = {
        Root = self:FindChild(playerBox, "NotStartGroup")
    }
    self.mResultGroup = {
        BtnReplay = self:FindChild(playerBox, "ResultGroup/BtnReplay"),
        Win = self:FindChild(playerBox, "ResultGroup/Win"),
        Lose = self:FindChild(playerBox, "ResultGroup/Lose")
    }
    self:RegisterClick(self.mResultGroup.BtnReplay:GetComponent("Button"), self.OnClickReplay)

    self:RegisterClick(self:FindChildComponent(playerBox, "PlayerGroup/BtnHead", "Button"), self.OnClickHead)

    self.mLineBox = self:FindChild(self.Root, "LineBox")
    self.mLineMap = {
        ["1_1"] = self:FindChild(self.mLineBox, "Line1_1"),
        ["1_2"] = self:FindChild(self.mLineBox, "Line1_2"),
        ["2_1"] = self:FindChild(self.mLineBox, "Line2_1"),
        ["2_2"] = self:FindChild(self.mLineBox, "Line2_2")
    }
end

-- Name: 玩家名称
-- Head：玩家头像
-- State：玩家状态
-- LineKey：擂台划线
-- OnClickHead: 头像按钮监听
-- OnClickReplay: 回放监听
function PKRankPlayerBox:Refresh(data)
    if data.Name then
        self.mPlayerGroup.LabName.text = data.Name
    end

    if data.charPicUrl or data.dwModelID then
        GetHeadPicByData(
            data,
            function(sprite)
                if self and self.mPlayerGroup and self.mPlayerGroup.ImgHead then
                    self.mPlayerGroup.ImgHead.sprite = sprite
                end
            end
        )
    end

    if data.State then
        self.mNotStartGroup.Root:SetActive(data.State == PKRankPlayerBox.State.NotStart)
        self.mResultGroup.Win:SetActive(data.State == PKRankPlayerBox.State.Win)
        self.mResultGroup.Lose:SetActive(data.State == PKRankPlayerBox.State.Lose)
        self.mResultGroup.BtnReplay:SetActive(
            data.State == PKRankPlayerBox.State.Win or data.State == PKRankPlayerBox.State.Lose
        )
        self.mPlayerGroup.Root:SetActive(data.State ~= PKRankPlayerBox.State.NotStart)
    end

    if data.LineKey then
        if self.mLineMap[data.LineKey] then
            self.mLineBox:SetActive(true)
            for lineKey, lineObj in pairs(self.mLineMap) do
                lineObj:SetActive(lineKey == data.LineKey)
            end
        else
            self.mLineBox:SetActive(false)
        end
    end

    if data.OnClickHead then
        self.mOnClickHead = data.OnClickHead
    end

    if data.OnClickReplay then
        self.mOnClickReplay = data.OnClickReplay
    end

    if data.ID then
        local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
        self.mImgBG.color = data.ID == ownerID and Color_Green or DRCSRef.Color.white
    end
end

function PKRankPlayerBox:OnClickHead()
    if self.mOnClickHead then
        self.mOnClickHead()
    end
end

function PKRankPlayerBox:OnClickReplay()
    if self.mOnClickReplay then
        self.mOnClickReplay()
    end
end

return PKRankPlayerBox
