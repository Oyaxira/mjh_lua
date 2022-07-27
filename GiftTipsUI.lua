GiftTipsUI = class("GiftTipsUI",BaseWindow)

function GiftTipsUI:Create()
	local obj = LoadPrefabAndInit("Role/GiftTipsUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end

    self:UpdateData()
end

function GiftTipsUI:Init()
    self.close = self:FindChildComponent(self._gameObject, "close", "Button")

    self.BIQI = self:FindChildComponent(self._gameObject, "BIQI", "Text")
    self.TENGKONG = self:FindChildComponent(self._gameObject, "TENGKONG", "Text")
    self.BIDU = self:FindChildComponent(self._gameObject, "BIDU", "Text")
    self.JIGUANG = self:FindChildComponent(self._gameObject, "JIGUANG", "Text")
    self.SUIYAN = self:FindChildComponent(self._gameObject, "SUIYAN", "Text")
    self.CAIKUANG = self:FindChildComponent(self._gameObject, "CAIKUANG", "Text")
    self.CAIYAO = self:FindChildComponent(self._gameObject, "CAIYAO", "Text")
    self.SHICAISOUGUA = self:FindChildComponent(self._gameObject, "SHICAISOUGUA", "Text")
    self.JINQIANSOUGUA = self:FindChildComponent(self._gameObject, "JINQIANSOUGUA", "Text")


    if self.close then
    self:RemoveButtonClickListener(self.close)
		self:AddButtonClickListener(self.close, function()
      RemoveWindowImmediately("GiftTipsUI",true)
		end)
    end
end

function GiftTipsUI:RefreshUI()
    -- FIXME: 建议把带文字显示的放到 Language 中, 便于后续多语言处理
    self.BIQI.text = '闭气术：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_BiQi)..'级'
    self.TENGKONG.text = '腾空术：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_TenKong)..'级'
    self.BIDU.text = '避毒术：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_BiDu)..'级'
    self.JIGUANG.text = '机关术：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_JiGuan)..'级'
    self.SUIYAN.text = '碎岩术：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_SuiYan)..'级'
    self.CAIKUANG.text = '采矿：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_CaiKuang)..'级'
    self.CAIYAO.text = '采药：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_CaiYao)..'级'
    self.SHICAISOUGUA.text = '食材搜刮：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_ShiCaiSouGua)..'级'
    self.JINQIANSOUGUA.text = '金钱搜刮：'..RoleDataHelper.GetTeammatesAdvGiftsLevel(AdventureType.AT_JinQianSouGua)..'级'
end

function GiftTipsUI:OnEnable()
end

function GiftTipsUI:OnDisable()
end

function GiftTipsUI:OnDestroy()
end

function GiftTipsUI:UpdateData()
end

return GiftTipsUI