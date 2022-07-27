local function AccessStrategy(t, k)
    if k == "_pool" then
         assert(false, "you cant't get _pool directly!!!!")
         return nil
    else
         return t._dataSuper[k]
    end   
end

local function SetStrategy(t, k, v)
    assert(false, "you can't set another data in data pool")
end

DataCenterClass = {
    __index = AccessStrategy,
    __newindex = SetStrategy,
}

function DataCenterClass.new()
    local newDataCenter = {
          _pool = {},
          _dataSuper = DataCenterClass,
    }
    
    setmetatable(newDataCenter, DataCenterClass)
    return newDataCenter
end

-- XXXX:setData("label", {b = function() return 1 end, c = 1,}, /*isCover = false*/}
function DataCenterClass:setData(...)
    local arg = {...}
    local label = arg[1]
    local value = arg[2]
    local cover = (#arg > 2) and arg[3] or false
    if self._pool[label] ~= nil then
          if cover then
                self._pool[label] = value
                return true
          else  
                --assert(false, label.." the data has been set before!!!!")
                return false
          end
    else
          self._pool[label] = value
          return true
    end
    return false
end

function DataCenterClass:clear()
    self._pool = {}
end

function DataCenterClass:ClearExcept(tableNameList)
    if (tableNameList == nil or #tableNameList == 0) then
        self:clear()
        return
    end
    for k,v in pairs(self._pool) do
        local bclear = true
        for i = 1, #tableNameList do
            -- 等于此键或以此键开头的, 匹配成功
            if string.find(k, tableNameList[i]) == 1 then
                bclear = false
                break
            end
        end
        if (bclear) then
            self._pool[k] = nil
        end
    end
end

---奇数label，偶数value
function DataCenterClass:setDataBatching(...)
    local arg = {...}
    local argLength = #arg
    local index = 1
    for index = 1, argLength, 2 do
          self._pool[arg[index]] = arg[index + 1]
    end
end

--local value = globalDataPool:getData("label", /*isDelete = false*/)
function DataCenterClass:getData(...)
    local arg = {...}
    local label = arg[1]
    local once = (#arg > 1) and arg[2] or false
    local value = self._pool[label]
    if once then
          self:removeData(label)
    end
    return value
end

function DataCenterClass:removeData(label)
    if self._pool[label] ~= nil then
          self._pool[label] = nil
    end
end

function DataCenterClass:purgeAllData()
    self._pool = {}
end


function DataCenterClass:GetGameState()
    local info = self:getData("GameData") or {}
    return info['eCurState']
end

--TODO where to use it
function SetDataToGlobalPool(label, value)
    if globalDataPool:getData(label) ~= value then
        globalDataPool:setData(label, value, true)
        --dprint("UPDATE_"..label, value)
        -- LuaEventDispatcher:dispatchEvent("UPDATE_"..label, value)
    end
end

local getPath = function()
    local plat = io.readfile("platform.txt")
    return DRCSRef.PersistentDataPath.."/"..plat.."/GameAppConfig.txt"
end

-- 存储本地配置文件
local configData = nil
local dkJson = require("Base/Json/dkjson")

function GetNewConfig(key)
    local str = DRCSRef.GameConfig:GetConfig(getPath())
    configData = dkJson.decode(str)
    if configData == nil then
        return nil
    end
    return configData[key]
end

function GetConfig(key)
    if configData == nil then
        local str = DRCSRef.GameConfig:GetConfig(getPath())
        configData = dkJson.decode(str)
    end
    if (configData == nil) then
        return nil
    end
    return configData[key]
end

function SaveConfig()
    local str = dkJson.encode(configData) 
    DRCSRef.GameConfig:SaveConfig(str,getPath())
end

function SetConfig(key,value,bImmediately)
    -- local dkJson = require("Base/Json/dkjson")
    -- local str = DRCSRef.GameConfig:GetConfig()
    -- local data = dkJson.decode(str)
    if (configData == nil) then
        configData = {}
    end
    configData[key] = value

    if bImmediately then
        SaveConfig()
    else
        globalTimer.bNeedSaveConfig = true
    end
end

function ClearConfig(key)
    if (key ~= nil) then
        configData[key] = nil
    else
        configData = {}
    end
    SaveConfig()
end


-- 存放全局相关
globalDataPool = DataCenterClass.new()
-- 不清理的
systemDataPool = DataCenterClass.new()


-- API:
-- globalDataPool:setData("label", {b = function() return 1 end, c = 1,}, /*isCover = false*/}
-- globalDataPool:setDataBatching("label", {b = "1", c = 1,}, "label1", 1, "label2", "I am a string")
--
-- local value = globalDataPool:getData("label", /*isDelete = false*/)
--
-- globalDataPool:removeData("label")
-- globalDataPool:purgeAllData()


----------------pb 使用例子-------------------
--具体使用方法 参照 https://github.com/starwing/lua-protobuf
-- local pb = require "pb"
-- -- load schema from text
-- local protoc = require "Base/protoc"
-- assert(protoc:load([[
--    message Phone {
--       optional string name        = 1;
--       optional int64  phonenumber = 2;
--    }
--    message Person {
--       optional string name     = 1;
--       optional int32  age      = 2;
--       optional string address  = 3;
--       repeated Phone  contacts = 4;
--    } ]]))

-- -- lua table data
-- local data = {
--    name = "ilse",
--    age  = 18,
--    contacts = {
--       { name = "alice", phonenumber = 12312341234 },
--       { name = "bob",   phonenumber = 45645674567 }
--    }
-- }

-- -- encode lua table data into binary format in lua string and return
-- local bytes = assert(pb.encode("Person", data))
-- dprint(pb.tohex(bytes))

-- -- and decode the binary data back into lua table
-- local data2 = assert(pb.decode("Person", bytes))
-- for k,v in pairs(data2) do 
--     dprint(k.."  "..tostring(v))	
-- end


-- 存储本地设置等信息 例子 unity编辑上 存储路径： Bin\Assets\GameAppConfig.txt
-- local dkJson = require("Base/Json/dkjson")
-- local data = {}
-- data.name = "123"
-- data.tab = {}
-- data.tab[1] = 1
-- data.tab[2] = 2
-- local str = dkJson.encode(data) 
-- DRCSRef.GameConfig:SaveConfig(str)
-- local str1 = DRCSRef.GameConfig:GetConfig()
-- local data1 = dkJson.decode(str1)


-----spine加载例子 self._gameObject 为父节点位置
-- local fun = function(objActor)
-- 	ChangeActorSpineWeaponAsync(objActor,"wq_dao_hupo")
-- end
-- LoadSpineCharacterAsync("role_nanzhu",self._gameObject,fun)


-- local obj = LoadSpineCharacter("role_nanzhu",self._gameObject)
-- ChangeActorSpineWeapon(obj,"wq_dao_hupo")


--spine换装例子  只有贴图位置信息完全一致的 才能这么做
-- ChnageSpineSkin(objSpine.gameObject,"Actor/role_langyabang/role_langyabang_1")


