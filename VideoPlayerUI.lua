VideoPlayerUI = class("VideoPlayerUI",BaseWindow)

function VideoPlayerUI:ctor()
end

function VideoPlayerUI:Create()
	local obj = LoadPrefabAndInit("Logon/VideoPlayerUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function VideoPlayerUI:Init()
	self.comVideoPlayer = self:FindChildComponent(self._gameObject, "RawImage", "VideoPlayer")
	self.comRowImage = self:FindChildComponent(self._gameObject, "RawImage", "RawImage")
	self.comVideoPlayer.targetCamera =  DRCSRef.Camera.main
	--self.comVideoPlayer.renderMode = UnityEngine.Video.VideoRenderMode.CameraNearPlane;
	self.comBgButton = self:FindChildComponent(self._gameObject, "Bg_Button", "Button")
	self:AddButtonClickListener(self.comBgButton,function()
		self.comVideoPlayer:Stop()
		RemoveWindowByQueue("VideoPlayerUI")
	end)

	self.comVideoPlayer:loopPointReached("+", self.LoopPointReached)
end

function VideoPlayerUI:LoopPointReached()
	RemoveWindowByQueue("VideoPlayerUI")
end

function VideoPlayerUI:RefreshUI(path)
	if path then
		local videoclip = LoadPrefab(path)
		if videoclip then
			self.comVideoPlayer.clip = videoclip
			self.comVideoPlayer:Play()
		end
	else
		self.comVideoPlayer:Play()
	end
	
end

function VideoPlayerUI:OnDestroy()
	self.comVideoPlayer:loopPointReached("-", self.LoopPointReached)
end

return VideoPlayerUI