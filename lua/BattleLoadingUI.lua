BattleLoadingUI = class("BattleLoadingUI",BaseWindow)

function BattleLoadingUI:ctor()
	self.objProgress_Text = nil
end

function BattleLoadingUI:Create()
	local obj = LoadPrefabAndInit("Battle/battleloading",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BattleLoadingUI:Init()
    local fun = function(iProcess)
        --self.objProgress_Text.text = math.floor(iProcess * 100)
    end
    self:AddEventListener("LoadSceneProcess", fun, nil, true)
    local fun1 = function()
        RemoveWindowImmediately("BattleLoadingUI",true)
    end
    self:AddEventListener("LoadSceneFinish", fun1, nil, true)
end

function BattleLoadingUI:OnDestroy()
	
end

return BattleLoadingUI