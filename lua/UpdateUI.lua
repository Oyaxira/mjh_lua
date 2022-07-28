local GCloudHelper = require "GCloudHelper"

UpdateUI = class("UpdateUI",BaseWindow)

function UpdateUI:ctor()

end

function UpdateUI:Create()
	local obj = LoadPrefabAndInit("Logon/UpdateUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function UpdateUI:Init()
    self.needStop = false
    self.DolphinCallBackInterface = {
        OnNoticeNewVersionInfo = function(_, newVersionInfo)
            dprint(newVersionInfo)
            if newVersionInfo.isCurrentNewest then
                self.needStop = true
                self:AddLog("当前版本已经最新")
            else
                local strinfo = string.format("获取到新版本:%s,需要的下载大小是:%0.2fM",newVersionInfo.versionStr,newVersionInfo.needDownloadSize/1024/1024)
                self:AddLog(strinfo)
                GCloudHelper:ContinueUpdate()
            end
        end,
        
        OnUpdateProgressInfo = function(_, msg, nowSize, totalSize, isDownloading)
            self.comProgress_Text.text = string.format( "%s %0.f : %0.f %s", msg, nowSize, totalSize, tostring(isDownloading))
        end,
    
        OnUpdateMessageBoxInfo = function(_, msg, msgBoxType, isError, errorCode)
            dprint('===================== start =========================')
            dprint(msg)
            dprint('===================== end =========================')
            self:AddLog("OnUpdateMessageBoxInfo:" .. msg .. tostring(isError) .. tostring(errorCode))
        end,
    
        OnNoticeInstallApk = function(_, apkPath)
            dprint(apkPath)
            self.needStop = true
            self:AddLog("安装路径 " .. apkPath)
            GCloudHelper:InstallApk(apkPath)
        end,
    
        OnNoticeUpdateSuccess = function(_)
            self.needStop = true
            self:AddLog("更新成功")
        end,
        OnNoticeChangeSourceVersion = function(_,newVersionStr)
            dprint(newVersionStr)
            self:AddLog("代码更新成功,新版本号为 " .. tostring(newVersionStr))
        end,
        OnNoticeFirstExtractSuccess = function(_)
            dprint('OnNoticeFirstExtractSuccess')
            self:AddLog("整包解压成功")
        end,
    }

    GCloudHelper:InitSDK(1817197254, "8cae917ec471ef212b2cfaa69c4db4ec")
    dprint('===================== start =========================')
    dprint(GCloudHelper.ErrorString)
    dprint('===================== end =========================')
    self.comLog_Text = self:FindChildComponent(self._gameObject,"Text","Text")
    self.comLog_Text.text = ''
	self.comProgress_Text = self:FindChildComponent(self._gameObject,"Progress","Text")
    self.comApk_Button = self:FindChildComponent(self._gameObject,"Apk","Button")
	if self.comApk_Button then
        self:AddButtonClickListener(self.comApk_Button,function()
            GCloudHelper:DoAppUpdate(self.DolphinCallBackInterface)
        end)
    end
    
    self.comSource_Button = self:FindChildComponent(self._gameObject,"Source","Button")
	if self.comSource_Button then
        self:AddButtonClickListener(self.comSource_Button,function()
            GCloudHelper:DoSourceUpdate(self.DolphinCallBackInterface)
        end)
    end
    
    self.comClose_Button = self:FindChildComponent(self._gameObject,"Close","Button")
	if self.comClose_Button then
        self:AddButtonClickListener(self.comClose_Button,function()
            GCloudHelper:StopUpdate()
            RemoveWindowImmediately("UpdateUI")
        end)
	end
end

function UpdateUI:AddLog(log)
    if self.comLog_Text then
        self.comLog_Text.text = self.comLog_Text.text .. log .. '\n'
    end
end

function UpdateUI:Update()
    GCloudHelper:DownloadUpdate()
    if self.needStop then
        GCloudHelper:StopUpdate()
        self.needStop = false
    end
end

function UpdateUI:RefreshUI()
   
end

function UpdateUI:OnDestroy()
	
end

return UpdateUI