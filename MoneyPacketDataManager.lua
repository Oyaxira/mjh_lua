MoneyPacketDataManager = class('MoneyPacketDataManager');
MoneyPacketDataManager._instance = nil;

function MoneyPacketDataManager:GetInstance()
    if MoneyPacketDataManager._instance == nil then
        MoneyPacketDataManager._instance = MoneyPacketDataManager.new();
        MoneyPacketDataManager._instance:Init();
    end

    return MoneyPacketDataManager._instance;
end

function MoneyPacketDataManager:Init()
    self.packetData = {};
end

function MoneyPacketDataManager:getPacketData(data, isRecomment)
    local item = {}
    if not data.param then
        return item
    end
    item.Name = data.param.name or "";
    item.type = data.param.resType or 0;
    item.typeID = data.param.redTypeID or 0;
    item.UID = isRecomment and data.id or data.rid;
    item.charId = data.charId;
    item.mId = data.param.modelID or 0;
    item.token = data.param.token or "";
    item.picture = data.param.pictureUrl or "";

    return item
end

function MoneyPacketDataManager:SetPacketData(data)
    self.packetData = {}

    local getTimes = PlayerSetDataManager:GetInstance():GetRedPacketGetTimes();
    if getTimes >=  SSD_MAX_GETREDPACKETTIMES then
        return;
    end

    if not data.packets then
        return
    end

    local dkJson = require("Base/Json/dkjson")
    for key, value in pairs(data.packets) do
        local params = dkJson.decode(value.param) or {};
        value.param = params;
        local item = self:getPacketData(value,false);
        if item.typeID ~= nil then
            table.insert(self.packetData, item);
        end
    end

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_REDPACKET');
end

function MoneyPacketDataManager:InsertPacketData(data)
    local getTimes = PlayerSetDataManager:GetInstance():GetRedPacketGetTimes();
    if getTimes >=  SSD_MAX_GETREDPACKETTIMES then
        return;
    end
    
    local item = self:getPacketData(data,true);
    if item.typeID ~= nil then
        local bFind = false
        for index, value in ipairs(self.packetData) do
            if value.UID == item.UID then
                bFind = true
                break
            end
        end

        if not bFind then
            table.insert(self.packetData, item);
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_REDPACKET');
        end
    end
end

function MoneyPacketDataManager:DelPacketData(data)
    for index, value in ipairs(self.packetData) do
        if value.UID == data.redPacketUID then
            table.remove(self.packetData, index);
            break  
        end
    end

    --如果显示的红包被领取完，再去拉取
    if self.packetData and #self.packetData < 1 then
        QueryRedPacket();
    end
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_REDPACKET');
end

function MoneyPacketDataManager:GetPacketData()
    return self.packetData;
end

function MoneyPacketDataManager:GetRecketTD(typeID)
    return TableDataManager:GetInstance():GetTableData("RedPacket", typeID);
end

function MoneyPacketDataManager:ClearPacketData()
    self.packetData = {}
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_REDPACKET');
end

return MoneyPacketDataManager;