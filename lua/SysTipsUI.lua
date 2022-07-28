SysTipsUI = class('SysTipsUI', BaseWindow)

function SysTipsUI:ctor()

end

function SysTipsUI:Create()
	local obj = LoadPrefabAndInit('TipsUI/System_Tips', TIPS_Layer);
	if obj then
		self:SetGameObject(obj);
    end
end

function SysTipsUI:Init()
	self.DontDestroy = true;
	self.objText = self:FindChild(self._gameObject, 'Text');
end

function SysTipsUI:RefreshUI(info)

end

function SysTipsUI:OnEnable()
	self:AddEventListener('ONEVENT_REF_SYSTEM_TIPS_UI', function()
		self:OnRefUI();
	end)
end

function SysTipsUI:OnRefUI()
	local _func = nil;
	_func = function()
		local sysData = PlayerSetDataManager:GetInstance():GetSystemTipsData();
		if sysData and #(sysData) > 0 then
			if not self.moveEnd then
				self.moveEnd = true;
	
				self.objText:GetComponent('Text').text = table.remove(sysData, 1);
				local rtf = self.objText:GetComponent('RectTransform');
				DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf);
				local moveX = self._gameObject.transform.rect.width + rtf.rect.width;
				self.objText.transform.localPosition = DRCSRef.Vec3(moveX / 2 + 100, 0, 0);
	
				local sequence = DRCSRef.DOTween.Sequence();
				sequence:Append(self.objText.transform:DOLocalMoveX(-moveX / 2 - 100, moveX / 100):SetEase(DRCSRef.Ease.Linear));
				sequence:AppendCallback(function()
					self.moveEnd = false;
					_func();
				end);
			end
		else
			RemoveWindowImmediately("SysTipsUI")			
		end
	end
	_func();
end

function SysTipsUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_SYSTEM_TIPS_UI');
end

function SysTipsUI:OnDestroy()

end

return SysTipsUI