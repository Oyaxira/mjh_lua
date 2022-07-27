NoticeDialogUI = class("NoticeDialogUI",BaseWindow)

function NoticeDialogUI:ctor()

end

function NoticeDialogUI:Create()
	local obj = LoadPrefabAndInit("TipsUI/NoticeDialogUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function NoticeDialogUI:Init()
    self.comBGButton = self:FindChildComponent(self._gameObject, 'G_BgBtn', 'Button')
    self.comNameText = self:FindChildComponent(self._gameObject, 'G_Name', 'Text')
    self.comContentText = self:FindChildComponent(self._gameObject, 'G_Content', 'Text')
    self.comOkText = self:FindChildComponent(self._gameObject, 'G_OKText', 'Text')
    self.comOkButton = self:FindChildComponent(self._gameObject, 'G_BtnOK', 'Button')
    self.objOKButton = self:FindChild(self._gameObject, 'G_BtnOK')

    self:AddButtonClickListener(self.comBGButton, function()
        RemoveWindowImmediately("NoticeDialogUI",true)
    end)
end

function NoticeDialogUI:OnClick_BlackBG()
	RemoveWindowImmediately("NoticeDialogUI",true)
end

function NoticeDialogUI:RefreshUI(notice)
    -- public string msg_id; /* 公告id */
    -- //public string mAppId ; /* appid */
    -- public string open_id; /* 用户open_id */
    -- public string msg_url; /* 公告跳转链接 */
    -- public int msg_type; /* 公告展示类型，滚动弹出 */
    -- public string msg_scene; /* 公告展示的场景，管理端后台配置 */
    -- public string start_time; /* 公告有效期开始时间 */
    -- public string end_time; /* 公告有效期结束时间 */
    -- public string update_time; /* 公告更新时间 */
    -- public int content_type;/* 公告内容类型，eMSG_NOTICETYPE */
    -- public int msg_order;/*公告优先级 */
    -- /*文本公告特殊字段 */
    -- public string msg_title; /* 公告标题 */
    -- public string msg_content;/* 公告内容 */
    if notice then
        self.comNameText.text = notice.msg_title or "error"
        self.comContentText.text = notice.msg_content or "error"
        self.comOkText.text = "跳转"
        self:RemoveButtonClickListener(self.comOkButton)
        self:AddButtonClickListener(self.comOkButton, function()
            SDKHelper:SDKOpenUrl(notice.msg_url or "www.baidu.com")
        end)
    end
    
end

function NoticeDialogUI:OnDestroy()
	
end

return NoticeDialogUI