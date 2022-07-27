DialogRecordDataManager = class("DialogRecordDataManager")
DialogRecordDataManager._instance = nil

local MAX_RECORD_NUM = 500

local FUNC_LISTEN_CLOSE_FAST_CHAT = function()
	DialogRecordDataManager:GetInstance():SetFastChatState(false)
end

function DialogRecordDataManager:GetInstance()
    if DialogRecordDataManager._instance == nil then
		DialogRecordDataManager._instance = DialogRecordDataManager.new()
    end

    return DialogRecordDataManager._instance
end

-- 清空缓存
function DialogRecordDataManager:Clear()
	-- 对话记录缓存
	self.kRecoedQueue = {}
	-- 移除监听
	LuaEventDispatcher:removeEventListener('ACTION_LIST_EMPTY', FUNC_LISTEN_CLOSE_FAST_CHAT)
end

-- kRecInfo = {
-- 	['roleBaseID'] = 0,
-- 	['name'] = "",
-- 	['avatar'] = "",
-- }
function DialogRecordDataManager:RecordDialog(strContent, kRecInfo)
	if (not strContent) or (strContent == "") then
		return
	end
	if not self.kRecoedQueue then
		self.kRecoedQueue = {}
	end
	local kNewRec = {}
	-- 记录类型
	local strType = "System"
	local kRoleMgr = RoleDataManager:GetInstance()
	if kRecInfo then
		if kRecInfo.roleBaseID == kRoleMgr:GetMainRoleTypeID() then
			strType = "Me"
		elseif kRecInfo.avatar and (kRecInfo.avatar ~= "") then
			strType = "Others"
		end
	end
	kNewRec.type = strType
	-- 记录正文
	kNewRec.content = strContent
	-- 其他数据
	if kRecInfo then
		kNewRec.name = kRecInfo.name or ""
		kNewRec.avatar = kRecInfo.avatar or ""
		kNewRec.roleBaseID = kRecInfo.roleBaseID or 0
	end
	-- 插入队列
	self.kRecoedQueue[#self.kRecoedQueue + 1] = kNewRec
end

function DialogRecordDataManager:GetQueue()
	if not self.kRecoedQueue then
		self.kRecoedQueue = {}
	end
	local uiLen = #self.kRecoedQueue
	if uiLen > MAX_RECORD_NUM then
		local kNewQueue = {}
		table.move(self.kRecoedQueue, uiLen - MAX_RECORD_NUM + 1, uiLen, 1, kNewQueue)
		self.kRecoedQueue = kNewQueue
	end
	return self.kRecoedQueue
end

function DialogRecordDataManager:SetDialogSoundPlayState(bOn)
	self.bDialogSoundPlayState = (bOn == true)
end

function DialogRecordDataManager:GetDialogSoundPlayState()
	return (self.bDialogSoundPlayState == true)
end

function DialogRecordDataManager:IsAutoChatOpen()
	return (self.bAutoChatOpen == true)
end

function DialogRecordDataManager:SetAutoChatState(bOn)
	self.bAutoChatOpen = (bOn == true)
	local win = GetUIWindow("DialogControlUI")
	if not win then
		return
	end
	win:UpdateFuncBtnState("AutoChatOpen")
end

function DialogRecordDataManager:IsFastChatOpen()
	return (self.bFastChatOpen == true)
end

function DialogRecordDataManager:SetFastChatState(bOn)
	if self.bFastChatOpen == bOn then
		return
	end
	-- 注册事件
	if (bOn == true) and (not LuaEventDispatcher:HasListener('ACTION_LIST_EMPTY')) then
		LuaEventDispatcher:addEventListener('ACTION_LIST_EMPTY', FUNC_LISTEN_CLOSE_FAST_CHAT)
	end
	-- 修改状态
	self.bFastChatOpen = (bOn == true)
	local win = GetUIWindow("DialogControlUI")
	if not win then
		return
	end
	win:UpdateFuncBtnState("FastChatOpen")
end