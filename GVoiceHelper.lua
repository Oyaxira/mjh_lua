-- 语音helper流程
-- 处理发送语音：
-- 1. 开始录音 => StartRecord
-- 2. 结束录音并上传 => StopRecord
-- 处理接收语音：
-- 1. 下载录音 => Download
-- 2. 播放录音 => PlayRecord
-- PS：
-- 1. 接口必须要初始化Init
-- 2. 接口必须要主动间隔调用Poll
-- 3. 接口必须要监听Resume和Pause
-- PPS: 根据官方文档，尽量不要自动序列播放语音，不然容易出问题

local util = require("xlua/util")

local GVoiceUtils = CS.GameApp.GVoiceUtils
local ErrorNo = CS.GCloud.GVoice.ErrorNo
local CompleteCode = CS.GCloud.GVoice.CompleteCode
local GCloudVoice = DRCSRef.GCloudVoice

local GVoiceHelper = {}

-- sdk info
local AppID = "515392985"
local AppKey = "be59415a6f6bd66eb9ea1c15de7722d4"
local ServerURL = "udp://cn.voice.gcloudcs.com:10001"

-- timeout config
local ApplyTimeout = 18000
local NetIOTimeout = 10000
local PollInterval = 1

local mVoiceEngine = nil

local mRecordDirPath = DRCSRef.Application.persistentDataPath .. "/record/"
-- TODO: 改成PC平台路径
-- mRecordDirPath = "D://record/"
local mRecordTempPath

-- 上传回调
local mUploadToCallback = {}
-- 下载回调
local mDownloadToCallback = {}
-- 语音转文本回调
local mSpeechToCallback = {}
-- 语音播放结束回调
local mPlayCompleteCallback

-- poll间隔
local mPollTime
-- 停止操作时间
local mStopRecordTime

local mInited = false

-- 初始化，防止没有openID进行初始化
function GVoiceHelper:Init()
    if mInited then
        return
    end

    if not GCloudVoice then
        return
    end

    mVoiceEngine = GCloudVoice:GetEngine()
    mInited = true

    -- 清空本地录音文件
    ClearAll()

    -- 这里openID使用设备id，免得切换账号还要重新设置
    local systemInfo = DRCSRef.GameConfig:GetSystemInfo()
    local _, deviceID = systemInfo:TryGetValue("deviceUId")
    local openID = tostring(deviceID)

    mVoiceEngine:SetAppInfo(AppID, AppKey, openID)
    mVoiceEngine:SetServerInfo(ServerURL)
    mVoiceEngine:Init()
    mVoiceEngine:SetMode(CS.GCloud.GVoice.Mode.Translation)

    mVoiceEngine:SetMicVolume(150)

    -- 注册key
    mVoiceEngine:OnApplyMessageKeyCompleteEvent("+", util.bind(self.OnApplyMessageKeyCompleteEvent, self))

    -- 注册上传录音
    mVoiceEngine:OnUploadReccordFileCompleteEvent("+", util.bind(self.OnUploadReccordFileCompleteEvent, self))

    -- 注册下载录音
    mVoiceEngine:OnDownloadRecordFileCompleteEvent("+", util.bind(self.OnDownloadRecordFileCompleteEvent, self))

    -- 注册播放录音
    mVoiceEngine:OnPlayRecordFilCompleteEvent("+", util.bind(self.OnPlayRecordFilCompleteEvent, self))

    -- 注册语音转文本
    mVoiceEngine:OnSpeechToTextEvent("+", util.bind(self.OnSpeechToTextEvent, self))

    -- 创建独立的文件夹便于维护
    GVoiceUtils.Init(mRecordDirPath)

    -- 申请key
    ApplyMessageKey()
end

-- 所有的回调需要调用这个函数驱动
function GVoiceHelper:Pool()
    if not mInited then
        return
    end

    local now = DRCSRef.Time.time
    if (not mPollTime) or (now - mPollTime > PollInterval) then
        mPollTime = now
        mVoiceEngine:Poll()
    end
end

-- TODO: 语音引擎暂停
function GVoiceHelper:Pause()
    if not mInited then
        return
    end
    return mVoiceEngine:Pause()
end

-- TODO: 语音引擎恢复
function GVoiceHelper:Resume()
    if not mInited then
        return
    end
    return mVoiceEngine:Resume()
end

-- 开始录音（关联按下事件）
function GVoiceHelper:StartRecord()
    -- 停止播放
    self:StopPlay()

    local fileID = math.floor(DRCSRef.Time.time * 1000)
    mRecordTempPath = GetFilePath(fileID)
    local errorNo = mVoiceEngine:StartRecording(mRecordTempPath)

    -- 如果还在录音先停止
    if errorNo == ErrorNo.RecordingErr then
        self:StopRecord()
        -- 重新录制
        errorNo = mVoiceEngine:StartRecording(mRecordTempPath)
    end

    -- 成功就说明录音开始咯
    if errorNo == ErrorNo.Succ then
        -- 开启静音
        SetMute(true)
        return true
    end

    return false
end

-- 结束录音（关联抬起事件）
function GVoiceHelper:StopRecord(callback)
    local errorNo = mVoiceEngine:StopRecording()

    -- 结束静音
    SetMute(false)

    if errorNo ~= ErrorNo.Succ then
        return false
    end

    if callback then
        local seconds = GVoiceUtils.GetSeconds(mRecordTempPath) or 0
        if seconds >= 1 then
            mUploadToCallback[mRecordTempPath] = callback
            Upload(mRecordTempPath)
        end
    end

    return true
end

-- 开始播放录音（只有当下载后才能播放，不然通过下载=>播放的流程容易出问题）
function GVoiceHelper:StartPlay(fileID, callback)
    local filePath = GetFilePath(fileID)
    if GVoiceUtils.Exists(filePath) then
        return GVoiceHelper:StartPlayEx(filePath, callback)
    end
    return false
end

-- 播放录音接口
function GVoiceHelper:StartPlayEx(filePath, callback)
    -- 停止上次的播放
    self:StopPlay()

    -- 开始这次的播放
    if mVoiceEngine:PlayRecordedFile(filePath) == ErrorNo.Succ then
        mPlayCompleteCallback = callback

        -- 开启静音
        SetMute(true)
        return true
    end
    return false
end

-- 停止播放录音
function GVoiceHelper:StopPlay()
    -- 结束静音
    SetMute(false)

    if mPlayCompleteCallback then
        mPlayCompleteCallback()
        mPlayCompleteCallback = nil
    end

    return mVoiceEngine:StopPlayFile() == ErrorNo.Succ
end

-- 下载录音
-- TODO: 下载异常需要处理吗？
-- TODO: 1. DownloadErr(下载出错) 2. HttpBusy(网络拥塞)
function GVoiceHelper:Download(fileID, callback)
    local filePath = GetFilePath(fileID)
    -- 文件存在，则直接回调
    if GVoiceUtils.Exists(filePath) then
        local seconds = GVoiceUtils.GetSeconds(filePath) or 0
        callback(seconds)
        return true
    elseif mVoiceEngine then
        local errorNo = mVoiceEngine:DownloadRecordedFile(fileID, GetFilePath(fileID), NetIOTimeout)
        if errorNo ~= ErrorNo.Succ then
            return false
        end

        mDownloadToCallback[fileID] = callback
        return true
    end
end

-- 关闭接口
function GVoiceHelper:Close()
    mUploadToCallback = {}
    mSpeechToCallback = {}
    mDownloadToCallback = {}
    self:StopPlay()
end

-- 注销接口（将会清空录音文件）
-- TODO: 重连和登出清空，目前暂时只在初始化的时候清空
function GVoiceHelper:Dispose()
    self:Close()
    ClearAll()
end

-- 注册key回调
function GVoiceHelper:OnApplyMessageKeyCompleteEvent(completeCode)
    dprint("[GVoiceHelper] -> OnApplyMessageKeyCompleteEvent CompleteCode: " .. tostring(completeCode))
end

-- 注册上传录音
function GVoiceHelper:OnUploadReccordFileCompleteEvent(completeCode, filePath, fileID)
    dprint(
        "[GVoiceHelper] -> OnUploadReccordFileCompleteEvent filePath: " ..
            filePath .. ", fileID: " .. fileID .. ", CompleteCode: " .. tostring(completeCode)
    )

    -- 需要把filePath改成对应的fileID的路径，这样自己的录音可以不用再下载
    GVoiceUtils.Move(filePath, GetFilePath(fileID))

    local callback = mUploadToCallback[mRecordTempPath]
    if callback then
        if completeCode == CompleteCode.UploadRecordDone then
            SpeechToText(
                fileID,
                function(result)
                    callback(fileID, result)
                end
            )
        end

        -- 因为短期内会释放，所以没必要移位删除
        mUploadToCallback[mRecordTempPath] = nil
    end
end

-- 注册下载录音
function GVoiceHelper:OnDownloadRecordFileCompleteEvent(completeCode, filePath, fileID)
    dprint(
        "[GVoiceHelper] -> OnDownloadRecordFileCompleteEvent filePath: " ..
            filePath .. ", fileID: " .. fileID .. ", CompleteCode: " .. tostring(completeCode)
    )

    -- 下载完播放
    local callback = mDownloadToCallback[fileID]
    if callback then
        if completeCode == CompleteCode.DownloadRecordDone then
            local seconds = GVoiceUtils.GetSeconds(filePath) or 0
            callback(seconds)
        end

        -- 因为短期内会释放，所以没必要移位删除
        mDownloadToCallback[fileID] = nil
    end
end

-- 注册播放录音
function GVoiceHelper:OnPlayRecordFilCompleteEvent(completeCode, filePath)
    dprint("[GVoiceHelper] -> OnPlayRecordFilCompleteEvent")

    if mPlayCompleteCallback then
        mPlayCompleteCallback()
        mPlayCompleteCallback = nil
    end

    -- 结束静音
    SetMute(false)
end

-- 注册语音转文本
function GVoiceHelper:OnSpeechToTextEvent(completeCode, fileID, result)
    dprint(
        "[GVoiceHelper] -> OnSpeechToTextEvent fileID: " ..
            fileID .. ", result: " .. result .. ", CompleteCode: " .. tostring(completeCode)
    )

    local callback = mSpeechToCallback[fileID]
    if callback then
        if completeCode == CompleteCode.STTSucc then
            callback(result)
        end

        -- 因为短期内会释放，所以没必要移位删除
        mSpeechToCallback[fileID] = nil
    end
end

-- 申请key（初始化后调用一次）
function ApplyMessageKey()
    mVoiceEngine:ApplyMessageKey(ApplyTimeout)
end

-- 上传录音
-- TODO: 上传异常需要处理吗？
-- TODO: 1. UploadErr(上传出错) 2. RecordingErr(正在进行录音) 3. HttpBusy(网络拥塞)
function Upload(filePath)
    return mVoiceEngine:UploadRecordedFile(filePath, NetIOTimeout) == ErrorNo.Appl
end

-- 语音转文本
function SpeechToText(fileID, callback)
    if mVoiceEngine:SpeechToText(fileID) == ErrorNo.Succ then
        mSpeechToCallback[fileID] = callback
        return true
    end
    return false
end

-- 根据fileID获取绝对路径
function GetFilePath(fileID)
    return mRecordDirPath .. fileID .. ".dat"
end

-- 清空文件
function ClearAll()
    GVoiceUtils.ClearAll(mRecordDirPath)
end

-- 开启静音
function SetMute(mute)
    CS.GameApp.FMODManager.SetMuteMusic(mute)
    CS.GameApp.FMODManager.SetMuteSound(mute)
end

return GVoiceHelper
