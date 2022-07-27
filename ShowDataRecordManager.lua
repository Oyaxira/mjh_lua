ShowDataRecordManager = class("ShowDataRecordManager")
ShowDataRecordManager._instance = nil


function ShowDataRecordManager:ctor()
    
end

function ShowDataRecordManager:GetInstance()
    if ShowDataRecordManager._instance == nil then
        ShowDataRecordManager._instance = ShowDataRecordManager.new()
        ShowDataRecordManager._instance:ResetManager()
    end

    return ShowDataRecordManager._instance
end

function ShowDataRecordManager:ResetManager()
    self.endRecordDict = {}
end

function ShowDataRecordManager:UpdateEndRecord(retStream)
    local eType = retStream.uiType
    local uiID = retStream.uiID

    if not eType or not uiID then
        return
    end

    self.endRecordDict[eType] = self.endRecordDict[eType] or {}
    self.endRecordDict[eType][uiID] = self.endRecordDict[eType][uiID] or {}

    local record = {}
    record.value1 = retStream.iValue1
    record.value2 = retStream.iValue2
    record.value3 = retStream.iValue3

    table.insert(self.endRecordDict[eType][uiID], record)

    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_SHOWDATA_END_RECORD_DEQUEUE, false, eType, uiID)
end

function ShowDataRecordManager:GetEndRecordValue(eType, uiID, iValueIndex)
    local record = self:GetEndRecord(eType, uiID)

    if record and iValueIndex then
        return record["value"..iValueIndex]
    end

    return nil
end

function ShowDataRecordManager:GetEndRecord(eType, uiID)
    if not eType or not uiID then
        return nil
    end

    local nilTable = {}

    local record = self.endRecordDict[eType] or nilTable
    record = record[uiID] or nilTable
    
    return record[1]
end

function ShowDataRecordManager:EndRecordDequeue(eType, uiID)
    if not eType or not uiID then
        return nil
    end

    local typeRecordDict = self.endRecordDict[eType]

    if typeRecordDict then
        local records = typeRecordDict[uiID]

        if records then
            if #records > 1 then
                table.remove(records, 1)
            else
                typeRecordDict[uiID] = nil
            end
        end
    end

end