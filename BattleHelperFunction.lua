
function IsInBattleGrid(gridX,gridY)
    return gridX >= 1 and gridX <= SSD_BATTLE_GRID_WIDTH and gridY>=1 and gridY <=SSD_BATTLE_GRID_HEIGHT
end


function GetPosByGrid(gridX,gridY,isAssist)
    if IsInBattleGrid(gridX,gridY) then 
        return GRID_POS[gridX][gridY]
    end

    return GRID_POS[1][1]
end


function GetAssistPosByGrid(gridX,gridY,isAssist)
    if isAssist then
        if isAssist == 1 then
            if gridX >= 1 and gridX <= SSD_BATTLE_GRID_WIDTH and gridY>=1 and gridY <=SSD_BATTLE_GRID_HEIGHT + 2 then
                return GRID_POS[gridX][gridY]
            end
        elseif isAssist == 2 then
            gridX = gridX - 100 
            gridY = 6 - (gridY - 100)
            local pos = GetPosByGrid(1,gridY)
            return DRCSRef.Vec3(pos.x- gridX,pos.y,pos.z)
        end
    end
    return GRID_POS[1][1]
end

function IsSameCamp(eCampA,eCampB)
    if eCampA == SE_CAMPA or eCampA == SE_CAMPC then
        return (eCampB == SE_CAMPA or eCampB == SE_CAMPC)
    else
        return eCampA == eCampB
    end
end