PKRankBox = class("PKRankBox", BaseBox)

local PKRankPlayerBox = require("UI/PKUI/PKRankPlayerBox")

function PKRankBox:ctor()
    self:Super("PKUI/PKRankBox")

    self.mRowList = {}
    local rowIndex = 1
    while true do
        local rowNode = self:FindChild(self.Root, "Row" .. rowIndex)
        if not rowNode then
            break
        end

        self.mRowList[rowIndex] = {
            Root = rowNode,
            PlayerBoxList = self:BuildBoxList(PKRankPlayerBox, rowNode, "PlayerBox%d")
        }

        rowIndex = rowIndex + 1
    end
end

-- data =
-- {
--     {PlayerData, PlayerData, PlayerData, PlayerData},
--     {PlayerData, PlayerData},
--     {PlayerData}
-- }
function PKRankBox:Refresh(data)
    for rowIndex = 1, #self.mRowList do
        local row = self.mRowList[rowIndex]
        local rowData = data[rowIndex]
        if rowData then
            row.Root:SetActive(true)

            local playerBoxList = row.PlayerBoxList
            for playerIndex = 1, #playerBoxList do
                local playerBox = playerBoxList[playerIndex]
                local playerData = rowData[playerIndex]

                if playerData then
                    playerBox:SetActive(true)
                    playerBox:Refresh(playerData)
                else
                    playerBox:SetActive(false)
                end
            end
        else
            row.Root:SetActive(false)
        end
    end
end

return PKRankBox
