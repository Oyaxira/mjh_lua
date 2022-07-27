-- 属性服务
NetCommonAttrib = {};

local urlGetAttrib = 'AttribService.GetAttrib';

function NetCommonAttrib:Init(data)

	local attrib = {};
    attrib.data = data;
    
	local config = NetCommonData.Config;
    local from = '';
    attrib.urlGetAttrib  = from .. urlGetAttrib;

    self.attrib = attrib;
    return attrib;
end

--  查询属性
-- @[]string users  @Validate(min = 1, max = 300)
-- @callback function(string, GetAttribReply) end
function NetCommonAttrib:GetAttrib(users, callback)
    if self.attrib and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            users = users,
        }
    
        AppsManager.Invoker:AsyncCall(self.attrib.urlGetAttrib, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetAttrib(users, r.data, r.code);
        end)
    end
end 

function NetCommonAttrib:OnGetAttrib(users, data, code)
    if code ~= 0 then
        return;
    end

    SocialDataManager:GetInstance():SetQureyOtherPlayerData(data);
end

return NetCommonAttrib;