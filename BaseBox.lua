-- Box基类（所有带root的对象都是Box、例如包裹的物品，排行榜的单行信息等......）
-- TODO: 其实最好不要继承BaseWindow
BaseBox = class("BaseBox", BaseWindow)

local SpriteTypeof = typeof(CS.UnityEngine.Sprite)
local SpritePath = "UI/UISprite/"
local PoolParent = CS.SG.ResourceManager.Instance.transform

function BaseBox:Super(rootOrPrefab)
    local root = nil
    if type(rootOrPrefab) == "string" then
        root = LoadPrefabAndInit(rootOrPrefab, PoolParent)

        if DEBUG_MODE and root == nil then
            derror("[BaseBox] => NoPrefab: " .. rootOrPrefab)
        end
    else
        root = rootOrPrefab
    end

    self:SetGameObject(root)

    self.Root = root
end

function BaseBox:SetParent(parent)
    self.Root.transform:SetParent(parent.transform, false)
end

function BaseBox:SetActive(active)
    self.Root:SetActive(active)
end

function BaseBox:RecordTime()
    self.Time = os.time()
end

function BaseBox:RegisterClick(button, callback, ...)
    if button == nil or callback == nil then
        return
    end

    local args = {...}

    self:AddButtonClickListener(
        button,
        function()
            callback(self, table.unpack(args))
        end
    )
end

function BaseBox:RegisterToggle(toggle, callback, ...)
    if toggle == nil or callback == nil then
        return
    end

    local args = {...}

    self:AddToggleClickListener(
        toggle,
        function(isOn)
            callback(self, isOn, table.unpack(args))
        end
    )
end

function BaseBox:SetSiblingIndex(index)
    self.Root.transform:SetSiblingIndex(index)
end

function BaseBox:SetAsFirstSibling()
    self.Root.transform:SetAsFirstSibling()
end

function BaseBox:SetAsLastSibling()
    self.Root.transform:SetAsLastSibling()
end

-- 用于销毁固定创建的（即初始绑定在预制物的）
function BaseBox:UnLoad()
    if self._button ~= nil then
        for key, value in pairs(self._button) do
            self:RemoveButtonClickListener(key)
        end
        self._button = nil
    end

    if self._toggle ~= nil then
        for key, value in pairs(self._toggle) do
            self:RemoveToggleClickListener(key)
        end
        self._toggle = nil
    end
end

-- 用于销毁动态创建的（即通过BoxPoolManager创建的）
function BaseBox:Dispose()
    if self.Root then
        self:Destroy(true)
        self.Root = nil
    end
end

return BaseBox
