ShoppingDataManager = class('ShoppingDataManager');
ShoppingDataManager._instance = nil;

function ShoppingDataManager:GetInstance()
    if ShoppingDataManager._instance == nil then
        ShoppingDataManager._instance = ShoppingDataManager.new();
        ShoppingDataManager._instance:Init();
    end

    return ShoppingDataManager._instance;
end

function ShoppingDataManager:Init()
    self.shopData = {};
    self.begValue = 0;
    self.selfBegValue = 0;

end

function ShoppingDataManager:ResetShopData()
    self.shopData = {};
end

function ShoppingDataManager:SetShopData(data)
    local luaTable = table_c2lua(data.akItem);
    if not self.shopData[data.uiType] then
        self.shopData[data.uiType] = {};
    end

    self.shopData[data.uiType] = luaTable;

    self.auiValidRacks = data.auiValidRacks

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_SHOPDATA', data);

end

function ShoppingDataManager:GetShopData(uiType)

    if not self.shopData[uiType] then
        return nil;
    end

    local _sort = function(a, b)
        -- local aD = self:GetRackData(a.uiShopID);
        -- local bD = self:GetRackData(b.uiShopID);

        if a and b then
            return a.iSort < b.iSort;
        end
        
        return false;
    end
    table.sort(self.shopData[uiType], _sort);
    return self.shopData[uiType];
end
function ShoppingDataManager:GetIfShopTypeShowInMallUI(etype)
    if not etype or etype == RackItemType.RTT_FESTIVAL then 
        return false 
    end 
    return true 
end
function ShoppingDataManager:GetShopDataBy(baseID, sendQuery)
    local data = self:GetRackData(baseID);
    if data and self.shopData[data.Type] then
        for i = 1, #(self.shopData[data.Type]) do
            if self.shopData[data.Type][i].uiShopID == baseID then
                return self.shopData[data.Type][i];
            end
        end
    elseif sendQuery ~= false then
        SendPlatShopMallQueryItem(data.Type);
    end
end

function ShoppingDataManager:GetRackData(baseID)
    return TableDataManager:GetInstance():GetTableData("Rack",baseID)
end

function ShoppingDataManager:SetBegValue(kRetData)
    self.begValue = kRetData.iValue;
    self.selfBegValue = kRetData.iSelfValue;
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_BEGDATA', value);
end

function ShoppingDataManager:GetBegValue()
    return self.begValue or 0;
end

function ShoppingDataManager:GetSelfBegValue()
    return self.selfBegValue or 0;
end

function ShoppingDataManager:GetTBGlobalBeg()
    return TableDataManager:GetInstance():GetTable("GlobalBeg")
end

function ShoppingDataManager:GetFormatGetData()
    local begValue = self:GetBegValue();
    local tbData = self:GetTBGlobalBeg();
    local unlockIndex = 0;
    local tpTable = {};
    for i = 1, #(tbData) do
        if begValue >= tbData[i].NeedMoney then
            table.insert(tpTable, tbData[i]);
        end
    end
    return tpTable;
end

function ShoppingDataManager:GetNextGetData()
    local begValue = self:GetBegValue();
    local tbData = self:GetTBGlobalBeg();
    for i = 1, #(tbData) do
        if begValue < tbData[i].NeedMoney then
            return tbData[i];
        end
    end

    return tbData[#(tbData)];
end

-- 判断红点 是否显示 目前只有道具类的免费页签
-- 依赖函数CheckIfUITogShow 暂未完整实现 也只有道具类的功能
function ShoppingDataManager:CheckIfHasFreeRackByType(eType)
    eType = eType or RackItemType.RIT_ITEM
    local rackList = self:GetShopData(eType)
    if rackList then 
        if self:CheckIfUITogShow(eType) then  
            local luaTable = table_c2lua(self.auiValidRacks or {});
            local bFind = false;
            for iIndex = 1, #(luaTable) do
                if luaTable[iIndex] == eType then
                    bFind = true
                    break
                end
            end
            if bFind then  
                for iIndex,dataMallItem in ipairs(rackList) do 
                    if dataMallItem.iFinalPrice == 0 and dataMallItem.iCanBuyCount > 0 then 
                        return true 
                    end 
                end 
            end 
        end
    else
        SendPlatShopMallQueryItem(eType)
    end 
    return false 
end
-- 判断商店界面的页签是否显示
function ShoppingDataManager:CheckIfUITogShow(eType)
    local mSumLevel = MeridiansDataManager:GetInstance():GetSumLevel()

    if eType == RackItemType.RIT_ITEM then 
        local gold = PlayerSetDataManager:GetInstance():GetPlayerGold()
        return mSumLevel >= 10 or gold > 0 
    elseif eType == RackItemType.RIT_CANZHANG then 
        local bIsVip = TreasureBookDataManager:GetInstance():GetTreasureBookVIPState()
        return mSumLevel >= 10 or bIsVip 
    elseif eType == RackItemType.RIT_DRINK then 
        local jiuquan = PlayerSetDataManager:GetInstance():GetPlayerDrinkMoney()
        return mSumLevel >= 60 or jiuquan >= 1 
    elseif eType == RackItemType.RIT_EXCHANGE then 
        local jiFenPlat = PlayerSetDataManager:GetInstance():GetPlayerPlatScore()
        return mSumLevel >= 60 or jiFenPlat >= 1 
    elseif eType == RackItemType.RIT_ACTIVITY then 
        local jiFenActive = PlayerSetDataManager:GetInstance():GetPlayerActiveScore()
        return mSumLevel >= 60 or jiFenActive >= 1 
    end
    return false 
end


return ShoppingDataManager;