-- 红包服务
NetCommonRedPacket = {};

local urlLatestRedPacket = 'RedPacketService.LatestRedPacket';

function NetCommonRedPacket:Init(data)

	local redPacket = {};
    redPacket.data = data;
    
    local from = '';
    redPacket.urlLatestRedPacket  = from .. urlLatestRedPacket;

    self.redPacket = redPacket;
    return redPacket;
end

-- 获得最新红包列表
function NetCommonRedPacket:GetLatestRedPacket()
    if self.redPacket and AppsManager and AppsManager.Invoker and 
        (NetCommonData.Config.appid and  NetCommonData.Config.appid ~= 0 and NetCommonData.Config.appid ~= "") then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.redPacket.data.userid,
            num = 10
        }

        AppsManager.Invoker:AsyncCall(self.redPacket.urlLatestRedPacket, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetRedPacketList(r.data, r.code);
        end)
    end
end

function NetCommonRedPacket:OnGetRedPacketList(data, code)
    if code ~= 0 then
        return;
    end
    MoneyPacketDataManager:GetInstance():SetPacketData(data);
end

return NetCommonRedPacket;