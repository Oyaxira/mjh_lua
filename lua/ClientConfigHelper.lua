local dkJson = require("Base/Json/dkjson")

ClientConfigHelper = class('ClientConfigHelper')
ClientConfigHelper._instance = nil

function ClientConfigHelper:GetInstance()
    if ClientConfigHelper._instance == nil then
        ClientConfigHelper._instance = ClientConfigHelper.new()
        ClientConfigHelper._instance:Init()
    end

    return ClientConfigHelper._instance
end

function ClientConfigHelper:Init()
    self.openConfig = true
end

-- 初始化Http客户端的配置项
function ClientConfigHelper:InitHttpClientConfig()
    local url = "https://clientconfig.wdxk.qq.com/client.json"
    HttpHelper:HttpGet(url, function(result)
        if (result == nil) then
            derror("GetIOSCheckVersion result nil")
            return
        end 
        if (result.data == nil) then
            derror("GetIOSCheckVersion result.data nil , error:"..result.error)
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("GetIOSCheckVersion result.data after json nil or code=nil")
            return
        end
        ClientConfigHelper:GetInstance():_SetConfig(resultData)
    end)
end

-- 判定是否显示提审状态
function ClientConfigHelper:ShowIOSCheckVersionState()
    if (not self:IsOpen())then
        return false
    end

    if (not self.result) then
        return false
    end

    if (not self.result.IOSCheckVersion) then
        return false
    end
    for i=1,#self.result.IOSCheckVersion do
        if VersionCodeCompare(self.result.IOSCheckVersion[i],CLIENT_VERSION) == 0 then
            return true
        end
    end

    return false
end

-- 根据http返回设置回调
function ClientConfigHelper:_SetConfig(result)
    self.result = result
end

-- 是否开启了功能
function ClientConfigHelper:IsOpen()
    return (self.openConfig == true)
end

return ClientConfigHelper