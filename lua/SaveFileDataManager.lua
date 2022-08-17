SaveFileDataManager = class("SaveFileDataManager")
SaveFileDataManager._instance = nil

function SaveFileDataManager:GetInstance()
    if SaveFileDataManager._instance == nil then
        SaveFileDataManager._instance = SaveFileDataManager.new()
        SaveFileDataManager._instance:Init()
    end

    return SaveFileDataManager._instance
end

function SaveFileDataManager:Init()
    --名字 --图片
    self.akSaveFile = {}
end

function SaveFileDataManager:UpdateSaveFileInfo()
    local file = {}
    self.akSaveFile = {}
    self.akSaveFile[1] = {"自动", nil}
    file = DicToLuaTable(DRCSRef.SaveFile.LoadSaveFileInfoByPath("SaveFile"))
    for key, value in pairs(file) do
        local Time = DRCSRef.SaveFile.GetFileWriteTime(value) or 0
        local spirte = DRCSRef.SaveFile.LoadByIo(value)
        self.akSaveFile[#self.akSaveFile + 1] = {key, spirte,Time}
    end
end

function SaveFileDataManager:GetSaveFileInfo()
    if not next(self.akSaveFile) then
        self:UpdateSaveFileInfo()
    end
    return self.akSaveFile
end

function SaveFileDataManager:SetSaveFileRet(kRetData)
    if not kRetData then
        return
    end
    if kRetData.eOptType == SSFRT_OPEN_SAVE_FILE then
        return
    end
    local bShow = false
    if kRetData.bSuccess == 1 then
        SystemUICall:GetInstance():Toast("操作成功")
        
        if kRetData.eOptType == SSFRT_NEW_FILE or kRetData.eOptType == SSFRT_SAVE_FILE  then
            local SaveFileUI = GetUIWindow("SaveFileUI")
            if SaveFileUI and SaveFileUI:IsOpen() then
                bShow = true
                RemoveWindowImmediately("SaveFileUI")
            end
            if DEBUG_MODE then
                StartScreenShot("SaveFile/"..kRetData.acFilePath)
            else
                StartScreenShot("../SaveFile/"..kRetData.acFilePath)
            end
        end
        if kRetData.eOptType == SSFRT_DELETE_FILE then
            bShow = true
        end
        if kRetData.eOptType == SSFRT_LOAD_FILE then
            self:ProecessLoadSaveFile()
        else
            globalTimer:AddTimer(500, function ()
                if bShow then
                    self:UpdateSaveFileInfo()
                    local SaveFileUI = OpenWindowImmediately("SaveFileUI")
                    if SaveFileUI then
                        SaveFileUI:UpdateFileInfo()
                    end
                end
                self:HideLoading()
            end)
        end
    else
        SystemUICall:GetInstance():Toast("操作失败")
        self:HideLoading()
    end
end


function SaveFileDataManager:HideLoading()
    local LoadingUI = GetUIWindow("LoadingUI")
    if LoadingUI and LoadingUI:IsOpen() then
        RemoveWindowImmediately("LoadingUI")
    end
end

--新建存档Start
function SaveFileDataManager:SendNewSaveFile(strFileName)
    --向服务器发送新建存档请求，再回调成果时候截图，放入同一个文件下
    SendSaveFileOpt(SSFRT_NEW_FILE, strFileName,false)
    globalTimer:AddTimer(2000, function ()
        self:HideLoading()
    end)
end

--新建存档End

--覆盖存档Start
function SaveFileDataManager:SendSaveFile(strFileName)
    SendSaveFileOpt(SSFRT_SAVE_FILE, strFileName)
end

--覆盖存档End

--加载存档Start
function SaveFileDataManager:SendLoadSaveFile(strFileName)
    if GetGameState() ~= -1 then
       -- 如果这个时候临时背包中还有物品, 那么在返回酒馆的时候给个提示
		local tempItems = ItemDataManager:GetInstance():GetTempBackpackItems() or {}
		if #tempItems > 0 then
			local msg = "加载存档需要返回标题界面，临时背包中还有物品, 离开剧本就会消失, 确定要返回标题吗？"
			local boxCallback = function()
				SendClickQuitStoryCMD()
			end
			OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg or "", boxCallback})
		else
			local _callback = function()
				SendClickQuitStoryCMD();
			end
			OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '加载存档需要返回标题界面，是否要返回标题画面？', _callback });
		end
        return
    end
    if strFileName == "自动" then
        self:ProecessLoadSaveFile()
        return
    end
    OpenWindowImmediately("LoadingUI")
    SendSaveFileOpt(SSFRT_LOAD_FILE, strFileName)
end

function SaveFileDataManager:ProecessLoadSaveFile()
    OpenWindowImmediately("LoadingUI")
    ResetGame(true)
    globalTimer:AddTimer(500, function ()
        local LoginUI = GetUIWindow("LoginUI")
        if LoginUI then
            LoginUI:OnclickVisitorLogin()
        end
        globalDataPool:setData("GameMode","ServerMode")
        local index = GetConfig("index") or 1
        index = index + 1
        SetConfig("index", index, true)
        OnGameNetConnected()
        self:HideLoading()
    end)
end
--加载存档End

--删除存档Start
function SaveFileDataManager:SendDelectSaveFile(strFileName)
    OpenWindowImmediately("LoadingUI")
    SendSaveFileOpt(SSFRT_DELETE_FILE, strFileName)
end

--删除存档End



return SaveFileDataManager