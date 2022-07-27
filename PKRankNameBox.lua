PKRankNameBox = class("PKRankNameBox", BaseBox)

function PKRankNameBox:ctor(root)
    self:Super("PKUI/PKRankNameBox")

    self.mLabName = self:FindChildComponent(self.Root, "LabName", "Text")
    self.mOriginColor = self.mLabName.color
end

-- Name: 玩家名称
-- Lose: 输了吗？
function PKRankNameBox:Refresh(data)
    if data.Name then
        self.mLabName.text = data.Name
    end

    if data.Lose ~= nil then
        self.mLabName.color = data.Lose and UI_COLOR.red or self.mOriginColor
    end
end

return PKRankNameBox
