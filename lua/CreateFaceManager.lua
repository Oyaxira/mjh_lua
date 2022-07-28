CreateFaceManager = class("CreateFaceManager")
CreateFaceManager._instance = nil

CreateFaceManager.NET_EVENT = {
    RoleFaceOprRet = "CF_NET_RoleFaceOprRet",
    AllRoleFaceRet = "CF_NET_AllRoleFaceRet",
}

CreateFaceManager.UI_EVENT = {
    UploadFaceDataSuccess = "CF_UI_UploadFaceDataSuccess",
    UnlockNewFacePart = "CF_UI_UnlockNewFacePart",
    UnlockNewModel = "CF_UI_UnlockNewModel",
    DeleteFaceDataSuccess = "CF_UI_DeleteFaceDataSuccess",
}

function CreateFaceManager:GetInstance()
    if CreateFaceManager._instance == nil then
        CreateFaceManager._instance = CreateFaceManager.new()
        CreateFaceManager._instance:Init()
    end

    return CreateFaceManager._instance
end


function CreateFaceManager:ResetManager()
    self.faceData = {} -- 玩家自身捏脸数据缓存
    self.arenaPlayerFaceData = {} -- 擂台其他玩家专用缓存
    self.lastUploadData = {}
    -- 测试用假数据
    -- 酒馆
    -- self.faceData[0] = {
    --     -- 天命之人
    --     [1000027001] = {
    --         ['uiHat'] = 5, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 111,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 158,
    --         ['uiSex'] = 0,
    --         ['uiCGSex'] = 1,
    --         ['uiRoleID'] = 1000027001,
    --     },
    --     -- 男徒弟
    --     [1000001077] = {
    --         ['uiHat'] = 2, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 102,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 9,
    --     },
    --     [1000027035] = {
    --         ['uiHat'] = 2, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 102,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 9,
    --     },
    -- }
    -- -- 宇文庄奇案
    -- self.faceData[1] = {
    --     [1000027001] = {
    --         ['uiHat'] = 2, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 102,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 9,
    --     },
    -- }
    -- -- 魔君乱江湖
    -- self.faceData[2] = {
    --     [1000027001] = {
    --         ['uiHat'] = 5, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 111,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 148,
    --         ['uiSex'] = 0,
    --         ['uiCGSex'] = 0,
    --         ['uiRoleID'] = 1000027001,
    --     },
    --     -- 男主角
    --     [1000001260] = {
    --         ['uiHat'] = 1, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 102,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 704,
    --     },
    -- }
    -- -- 自由模式
    -- self.faceData[7] = {
    --     [1000027001] = {
    --         ['uiHat'] = 2, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 102,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 9,
    --     },
    --     [1000001260] = {
    --         ['uiHat'] = 1, 
    --         ['uiBack'] = 702,
    --         ["uiHairBack"] = 202,
    --         ["uiBody"] = 602,
    --         ["uiFace"] = 302,
    --         ["uiEyebrow"] = 802,
    --         ["uiEye"] = 902,
    --         ["uiMouth"] = 1002,
    --         ["uiNose"] = 1102,
    --         ["uiForeheadAdornment"] = 402,
    --         ["uiFacialAdornment"] = 502,
    --         ["uiHairFront"] = 102,
    --         ["iEyebrowWidth"] = 1,
    --         ["iEyebrowHeight"] = 1,
    --         ["iEyebrowLocation"] = 1,
    --         ["iEyeWidth"] = 1,
    --         ["iEyeHeight"] = 1,
    --         ["iEyeLocation"] = 1,
    --         ["iNoseWidth"] = 1,
    --         ["iNoseHeight"] = 1,
    --         ["iNoseLocation"] = 1,
    --         ["iMouthWidth"] = 1,
    --         ["iMouthHeight"] = 1,
    --         ["iMouthLocation"] = 1,
    --         ["uiModelID"] = 9,
    --     },
    -- }
end

function CreateFaceManager:Clear()
    self:ResetManager()
end

function CreateFaceManager:Init()
    self:ResetManager()
    self:InitData()
    LuaEventDispatcher:addEventListener(CreateFaceManager.NET_EVENT.AllRoleFaceRet, self.OnAllRoleFaceRet, self)        
    LuaEventDispatcher:addEventListener(CreateFaceManager.NET_EVENT.RoleFaceOprRet, self.OnRoleFaceOprRet, self)
end

--服务器下发的捏脸数据结构为tFaceData
--客户端组装的捏脸数据结构为tCharacterPartData
function CreateFaceManager:CreateFaceData(iRoleId,iModelId,iSex,iCGSex,tCharacterPartData)
    local roleFaceData = {
                          ["uiHat"] = tCharacterPartData[0] or 0,
                          ["uiBack"] = tCharacterPartData[1] or 0,
                          ["uiHairBack"] = tCharacterPartData[2] or 0,
                          ["uiBody"] = tCharacterPartData[3] or 0,
                          ["uiFace"] = tCharacterPartData[4] or 0,
                          ["uiEyebrow"] = tCharacterPartData[5] or 0,
                          ["uiEye"] = tCharacterPartData[6] or 0,
                          ["uiMouth"] = tCharacterPartData[7] or 0,
                          ["uiNose"] = tCharacterPartData[8] or 0,
                          ["uiForeheadAdornment"] = tCharacterPartData[9] or 0,
                          ["uiFacialAdornment"] = tCharacterPartData[10] or 0,
                          ["uiHairFront"] = tCharacterPartData[11] or 0,
                          ["iEyebrowWidth"] = tCharacterPartData[12] or 0,
                          ["iEyebrowHeight"] = tCharacterPartData[13] or 0,
                          ["iEyebrowLocation"] = tCharacterPartData[14] or 0,
                          ["iEyeWidth"] = tCharacterPartData[15] or 0,
                          ["iEyeHeight"] = tCharacterPartData[16] or 0,
                          ["iEyeLocation"] = tCharacterPartData[17] or 0,
                          ["iNoseWidth"] = tCharacterPartData[18] or 0,
                          ["iNoseHeight"] = tCharacterPartData[19] or 0,
                          ["iNoseLocation"] = tCharacterPartData[20] or 0,
                          ["iMouthWidth"] = tCharacterPartData[21] or 0,
                          ["iMouthHeight"] = tCharacterPartData[22] or 0,
                          ["iMouthLocation"] = tCharacterPartData[23] or 0,
                          ['uiModelID'] = iModelId or 0,
                          ['uiSex'] = iSex or 0,
                          ['uiCGSex'] = iCGSex or 0,
                          ['uiRoleID'] = iRoleId or 0,
                        }
    return roleFaceData
end

-- 服务器通过字符串下发捏脸数据时调用
function CreateFaceManager:CreateFaceDataByTransFromStr(tRoleFaceData)
    local roleFaceData = {
                          ["uiHat"] = tRoleFaceData[1] or 0,
                          ["uiBack"] = tRoleFaceData[2] or 0,
                          ["uiHairBack"] = tRoleFaceData[3] or 0,
                          ["uiBody"] = tRoleFaceData[4] or 0,
                          ["uiFace"] = tRoleFaceData[5] or 0,
                          ["uiEyebrow"] = tRoleFaceData[6] or 0,
                          ["uiEye"] = tRoleFaceData[7] or 0,
                          ["uiMouth"] = tRoleFaceData[8] or 0,
                          ["uiNose"] = tRoleFaceData[9] or 0,
                          ["uiForeheadAdornment"] = tRoleFaceData[10] or 0,
                          ["uiFacialAdornment"] = tRoleFaceData[11] or 0,
                          ["uiHairFront"] = tRoleFaceData[12] or 0,
                          ["iEyebrowWidth"] = tRoleFaceData[13] or 0,
                          ["iEyebrowHeight"] = tRoleFaceData[14] or 0,
                          ["iEyebrowLocation"] = tRoleFaceData[15] or 0,
                          ["iEyeWidth"] = tRoleFaceData[16] or 0,
                          ["iEyeHeight"] = tRoleFaceData[17] or 0,
                          ["iEyeLocation"] = tRoleFaceData[18] or 0,
                          ["iNoseWidth"] = tRoleFaceData[19] or 0,
                          ["iNoseHeight"] = tRoleFaceData[20] or 0,
                          ["iNoseLocation"] = tRoleFaceData[21] or 0,
                          ["iMouthWidth"] = tRoleFaceData[22] or 0,
                          ["iMouthHeight"] = tRoleFaceData[23] or 0,
                          ["iMouthLocation"] = tRoleFaceData[24] or 0,
                          ['uiModelID'] = tRoleFaceData[25] or 0,
                          ['uiSex'] = tRoleFaceData[26] or 0,
                          ['uiCGSex'] = tRoleFaceData[27] or 0,
                          ['uiRoleID'] = tRoleFaceData[28] or 0,
                        }
    return roleFaceData
end

function CreateFaceManager:CreateCharacterPartData(tFaceData)
    local characterPartData = {[0] = tFaceData['uiHat'],
                               [1] = tFaceData['uiBack'],
                               [2] = tFaceData["uiHairBack"],
                               [3] = tFaceData["uiBody"], -- body(身体)
                               [4] = tFaceData["uiFace"],
                               [5] = tFaceData["uiEyebrow"],
                               [6] = tFaceData["uiEye"],
                               [7] = tFaceData["uiMouth"],
                               [8] = tFaceData["uiNose"],
                               [9] = tFaceData["uiForeheadAdornment"],
                               [10] = tFaceData["uiFacialAdornment"], -- facial_adornment(面饰)
                               [11] = tFaceData["uiHairFront"],
                               [12] = tFaceData["iEyebrowWidth"],
                               [13] = tFaceData["iEyebrowHeight"],
                               [14] = tFaceData["iEyebrowLocation"],
                               [15] = tFaceData["iEyeWidth"],
                               [16] = tFaceData["iEyeHeight"],
                               [17] = tFaceData["iEyeLocation"],
                               [18] = tFaceData["iNoseWidth"],
                               [19] = tFaceData["iNoseHeight"],
                               [20] = tFaceData["iNoseLocation"],
                               [21] = tFaceData["iMouthWidth"],
                               [22] = tFaceData["iMouthHeight"],
                               [23] = tFaceData["iMouthLocation"],
                            }
    return characterPartData
end

--- 网络回调 ----

function CreateFaceManager:OnAllRoleFaceRet(tData)
    -- 查询后返回当前剧本和角色的捏脸数据
    -- 删档结档后也通过这个回调返回刷新数据
    if tData then
        local iNum = tData['iNum']
        local dwSeqNum = tData['dwSeqNum']
        local akRoleFaceData = tData['akRoleFaceData']
        -- 下发剧本id
        local uiScriptID = tData['uiScriptID']
        if iNum > 0 then
            self.faceData[uiScriptID] = {}
            for index, faceData in pairs(akRoleFaceData) do
                self.faceData[uiScriptID][faceData['uiRoleID']] = faceData
            end
        elseif iNum == 0 then
            self.faceData[uiScriptID] = {}
        end

    end
end

function CreateFaceManager:OnRoleFaceOprRet(tData)
    -- 操作后返回操作结果
    if tData then
        local nResult = tData['nResult']
        local dwSeqNum = tData['dwSeqNum']
        local eOprType = tData['eOprType']
        local iStoryId = tData['uiScriptID']
        local iParam = tData['uiParam']
        if nResult == SRFT_SUCCEED then
            if eOprType == SRFT_UPLOAD then 
                local uploadStoryId = self.lastUploadData['iStoryId']
                local uploadRoleId = self.lastUploadData['tFaceData']['uiRoleID']
                local uploadFaceData = self.lastUploadData['tFaceData']
                if not self.faceData[uploadStoryId] then
                    self.faceData[uploadStoryId] = {}
                end
                self.faceData[uploadStoryId][uploadRoleId] = uploadFaceData
                SystemUICall:GetInstance():Toast("上传捏脸数据成功")
			    LuaEventDispatcher:dispatchEvent(CreateFaceManager.UI_EVENT.UploadFaceDataSuccess)
            elseif eOprType == SRFT_UNLOCK_ROLEFACE then
                SystemUICall:GetInstance():Toast("捏脸部件解锁成功")
			    LuaEventDispatcher:dispatchEvent(CreateFaceManager.UI_EVENT.UnlockNewFacePart)
            elseif eOprType == SRFT_DELETE then
                SystemUICall:GetInstance():Toast("删除捏脸数据成功")
			    LuaEventDispatcher:dispatchEvent(CreateFaceManager.UI_EVENT.DeleteFaceDataSuccess)
                local iRoleId = iParam
                if self.faceData[iStoryId] and self.faceData[iStoryId][iRoleId] then
                    self.faceData[iStoryId][iRoleId] = nil
                end
            elseif eOprType == SRFT_UNLOCK_MODEL then
                SystemUICall:GetInstance():Toast("捏脸模型解锁成功")
			    LuaEventDispatcher:dispatchEvent(CreateFaceManager.UI_EVENT.UnlockNewModel)
            end
        else
            if nResult == SRFT_FAILED then
                if eOprType == SRFT_UPLOAD then 
                    SystemUICall:GetInstance():Toast("上传捏脸数据失败")
                elseif oprType == SRFT_UNLOCK_ROLEFACE then
                    SystemUICall:GetInstance():Toast("捏脸部件解锁失败")   
                elseif oprType == SRFT_UNLOCK_MODEL then
                    SystemUICall:GetInstance():Toast("捏脸模型解锁失败")                
                end
            elseif nResult == SRFT_SCRIPT_NOT_EXIST then
                SystemUICall:GetInstance():Toast("捏脸剧本ID不存在")                
            elseif nResult == SRFT_ROLE_NOT_EXIST then
                SystemUICall:GetInstance():Toast("捏脸角色不存在")  
            elseif nResult == SRFT_ROLEFACE_NOT_EXIST then
                SystemUICall:GetInstance():Toast("解锁或捏脸部位不存在")  
            elseif nResult == SRFT_ROLEFACE_NOT_SILVER then
                SystemUICall:GetInstance():Toast("解锁不需要银锭")  
            elseif nResult == SRFT_ROLEFACE_UNLOCKED then
                SystemUICall:GetInstance():Toast("已经解锁") 
            elseif nResult == SRFT_ROLEFACE_NOT_ENOUGH then
                SystemUICall:GetInstance():Toast("解锁银锭不足")  
            elseif nResult == SRFT_ROLEFACE_HIDE then
                SystemUICall:GetInstance():Toast("捏脸角色部位隐藏")  
            elseif nResult == SRFT_ROLEFACE_LOCKED then
                SystemUICall:GetInstance():Toast("捏脸角色部位未解锁")  
            elseif nResult == SRFT_ROLEFACE_SEXLIMIT then
                SystemUICall:GetInstance():Toast("捏脸角色部位性别不匹配")  
            elseif nResult == SRFT_ROLEFACE_LIMIT then
                SystemUICall:GetInstance():Toast("捏脸角色部位宽高位置超过限制")  
            elseif nResult == SRFT_ROLEFACE_POSITION_ERR then
                SystemUICall:GetInstance():Toast("捏脸角色部位不匹配")  
            elseif nResult == SRFT_ROLEFACE_MODEL_NOT_EXIST then
                SystemUICall:GetInstance():Toast("捏脸模型不存在")
            elseif nResult == SRFT_ROLEFACE_MODEL_NOT_OPEN then
                SystemUICall:GetInstance():Toast("捏脸模型未开放解锁")
            elseif nResult == SRFT_ROLEFACE_MODEL_NOT_SILVER then
                SystemUICall:GetInstance():Toast("解锁捏脸模型不需要银锭")  
            elseif nResult == SRFT_ROLEFACE_MODEL_UNLOCKED then
                SystemUICall:GetInstance():Toast("捏脸模型已经解锁")  
            elseif nResult == SRFT_ROLEFACE_MODEL_NOT_ENOUGH then
                SystemUICall:GetInstance():Toast("解锁捏脸模型银锭不足")  
            elseif nResult == SRFT_ROLEFACE_MODEL_LOCKED then
                SystemUICall:GetInstance():Toast("捏脸模型未解锁") 
            elseif nResult == SRFT_ROLEFACE_SEX_ERROR then
                SystemUICall:GetInstance():Toast("捏脸性别不匹配") 
            end
        end
    end
end

--- 网络回调 ----

------- 网络方法 -------

-- 读取数据 (默认还是服务器存储) 参数：剧本id 酒馆即剧本id为0
function CreateFaceManager:DownloadFaceData(iStoryId)
    SendCreateFaceOperate(iStoryId,SRFT_QUERY,0,self:GetDefaultNilData())
    -- 回调OnRecv_CMD_GAC_ALLROLEFACERET
end

-- 上传数据 参数：剧本id 角色id 模型id 数据 
function CreateFaceManager:UploadFaceData(iStoryId,iRoleId,iModelId,iSex,iCGSex,tCharacterPartData)
    local faceData = self:CreateFaceData(iRoleId,iModelId,iSex,iCGSex,tCharacterPartData)
    SendCreateFaceOperate(iStoryId,SRFT_UPLOAD,0,faceData)
    self.lastUploadData = {['iStoryId'] = iStoryId,['tFaceData'] = faceData}
    -- 回调OnRecv_CMD_GAC_ROLEFACEOPRRET
end

-- 银锭解锁某部件 参数：RoleFace表id
function CreateFaceManager:UnlockFacePart(iStoryId,iBaseId)
    SendCreateFaceOperate(iStoryId,SRFT_UNLOCK_ROLEFACE,iBaseId,self:GetDefaultNilData())
    -- 回调OnRecv_CMD_GAC_ROLEFACEOPRRET
end

-- 银锭解锁某模型 参数：RoleFaceModel表id
function CreateFaceManager:UnlockModel(iStoryId,iModelId)
    SendCreateFaceOperate(iStoryId,SRFT_UNLOCK_MODEL,iModelId,self:GetDefaultNilData())
    -- 回调OnRecv_CMD_GAC_ROLEFACEOPRRET
end

-- 删除数据 参数：剧本id 角色id
function CreateFaceManager:DeleteFaceData(iStoryId,iRoleId)
    SendCreateFaceOperate(iStoryId,SRFT_DELETE,iRoleId,self:GetDefaultNilData())
    -- 回调OnRecv_CMD_GAC_ROLEFACEOPRRET
end

------- 网络方法 -------

function CreateFaceManager:InitData()
    self.allModels = {}
    local TB_RoleFaceModel = TableDataManager:GetInstance():GetTable("RoleFaceModel")
    for index, value in pairs(TB_RoleFaceModel) do
        -- body
        if value.Show == TBoolean.BOOL_YES then
            table.insert(self.allModels,value.BaseID)
        end
    end
    table.sort(self.allModels,function(a,b)
        local dataA = TableDataManager:GetInstance():GetTableData("RoleFaceModel",a)
        local dataB = TableDataManager:GetInstance():GetTableData("RoleFaceModel",b)
        if dataA.CreateRoleID ~= dataB.CreateRoleID then
            return dataA.CreateRoleID < dataB.CreateRoleID
        else
            return a < b
        end
    end)
    self.allManModels = {}
    self.allWomanModels = {}
    for key, value in pairs(self.allModels) do
        local dataValue = TableDataManager:GetInstance():GetTableData("RoleFaceModel",value)
        if dataValue.SexLimit == SexType.ST_Male then
            table.insert(self.allManModels,value)
        else
            table.insert(self.allWomanModels,value)
        end
    end
    self.defaultMaleData = {}
    self.defaultFemaleData = {}
    local TB_RoleFaceDefault = TableDataManager:GetInstance():GetTable("RoleFaceDefault")
    for index, value in pairs(TB_RoleFaceDefault) do
        if value.SexLimit == SexType.ST_Male then
            self.defaultMaleData[value.PositionType] = value.RoleFaceBaseID
        else
            self.defaultFemaleData[value.PositionType] = value.RoleFaceBaseID
        end
    end
end

function CreateFaceManager:GetDefaultDataBySex(sex,iPositionType)
    if sex == SexType.ST_Male then
        return self.defaultMaleData[iPositionType]
    else
        return self.defaultFemaleData[iPositionType]
    end
end

function CreateFaceManager:GetAllModels()
    return self.allModels
end

function CreateFaceManager:GetAllManModels()
    return self.allManModels
end

function CreateFaceManager:GetAllWomanModels()
    return self.allWomanModels
end

function CreateFaceManager:GetNowModelIndex(iModelId)
    if self.allModels then
        for i=0,#self.allModels do
            if self.allModels[i] == iModelId then
                return i
            end
        end
    end
    return nil
end

function CreateFaceManager:GetDefaultNilData()
    -- 上行消息的结构体参数不能为nil 所以构造一个假的传
    return self:CreateFaceData(0,1,0,0,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
end

-- 提供头像接口 参数：剧本id roleid 父节点 已有obj 是否半身像
function CreateFaceManager:GetCreateFaceHeadImage(iStoryId,iRoleId,objParent,objOldHead,bHalfBody)
    local tFaceData = self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)
    if tFaceData then
        return self:GetCreateFaceHeadImageByData(tFaceData,objParent,objOldHead,bHalfBody)
    end
end

-- 提供头像接口 参数：下发的tFaceData 用于其他玩家的头像数据
function CreateFaceManager:GetCreateFaceHeadImageByData(tFaceData,objParent,objOldHead,bHalfBody)
    local objHead = nil
    if objOldHead then
        objHead = objOldHead
    else
        if bHalfBody then
            objHead = LoadPrefabAndInit("CreateFace/Create_HalfBody", objParent, true)
        else
            objHead = LoadPrefabAndInit("CreateFace/Create_Head", objParent, true)
        end
    end
    self:SetAllPartPicByData(objHead,tFaceData)
    return objHead
end

-- 提供立绘接口 参数：数据
function CreateFaceManager:GetCreateFaceCGImage(iStoryId,iRoleId,objParent,objOldCG)
    local tFaceData = self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)
    if tFaceData then
        return self:GetCreateFaceCGImageByData(tFaceData,objParent,objOldCG)
    end
end

-- 提供立绘接口 参数：下发的tFaceData 用于其他玩家的头像数据
function CreateFaceManager:GetCreateFaceCGImageByData(tFaceData,objParent,objOldCG)
    local objCG = nil
    if objOldCG then
        objCG = objOldCG
    else
        objCG = LoadPrefabAndInit("CreateFace/Create_CG", objParent, true)
    end
    self:SetAllPartPicByData(objCG,tFaceData)
    return objCG
end

-- 获取特定剧本id 角色id的捏脸数据
function CreateFaceManager:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)
    if self.faceData[iStoryId] then
        if self.faceData[iStoryId][iRoleId] then
            return self.faceData[iStoryId][iRoleId]
        else 
            return nil
        end
    end
    return nil
end

--获得特定剧本id 角色id的评分标签值
--cuteValue 可爱数值  cruelValue  凶狠值   happyValue 欢乐值   beautyValue   美丽值  handsomeValue  帅气值
--TODO 暂时不需要
-- function CreateFaceManager:GetTagDataByStoryIDAndRoleId(iStoryId,iRoleId)
--     local faceData = self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)
--     local tabTag = {cuteValue = 0, cruelValue = 0, happyValue = 0, beautyValue = 0, handsomeValue = 0}
--     for key, value in pairs(faceData) do
--         ["uiHat"] = tCharacterPartData[0] or 0,
--         ["uiBack"] = tCharacterPartData[1] or 0,
--         ["uiHairBack"] = tCharacterPartData[2] or 0,
--         ["uiBody"] = tCharacterPartData[3] or 0,
--         ["uiFace"] = tCharacterPartData[4] or 0,
--         ["uiEyebrow"] = tCharacterPartData[5] or 0,
--         ["uiEye"] = tCharacterPartData[6] or 0,
--         ["uiMouth"] = tCharacterPartData[7] or 0,
--         ["uiNose"] = tCharacterPartData[8] or 0,
--         ["uiForeheadAdornment"] = tCharacterPartData[9] or 0,
--         ["uiFacialAdornment"] = tCharacterPartData[10] or 0,
--         ["uiHairFront"] = tCharacterPartData[11] or 0,

--     end
-- end

function CreateFaceManager:GetPartTag(baseID)
    local roleFaceData = TableDataManager:GetInstance():GetTableData("RoleFace",baseID)
    if roleFaceData then
        if roleFaceData.BodyTag then
            return roleFaceData.BodyTag
        else
            return false
        end
    end
    return false
end

-- 获取特定剧本id 角色id的捏脸数据
function CreateFaceManager:GetCharacterPartDataByStoryIDAndRoleId(iStoryId,iRoleId)
    if self.faceData[iStoryId] then
        if self.faceData[iStoryId][iRoleId] then
            return self:CreateCharacterPartData(self.faceData[iStoryId][iRoleId])
        else 
            return nil
        end
    end
    return nil
end

function CreateFaceManager:GetModelIdByStoryIDAndRoleId(iStoryId,iRoleId)
    if self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId) then
        return self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)["uiModelID"]
    end
    return nil
end

function CreateFaceManager:GetSexByStoryIDAndRoleId(iStoryId,iRoleId)
    if self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId) then
        return self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)["uiSex"]
    end
    return nil
end

function CreateFaceManager:GetCGSexByStoryIDAndRoleId(iStoryId,iRoleId)
    if self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId) then
        return self:GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleId)["uiCGSex"]
    end
    return nil
end

function CreateFaceManager:GetCGSexByData(tFaceData)
    if tFaceData and tFaceData["uiCGSex"] then    
        return tFaceData["uiCGSex"]
    end
    return nil
end

-- 清空特定剧本id 角色id的捏脸数据
function CreateFaceManager:ClearFaceDataByStoryIDAndRoleId(iStoryId, iRoleId)
    if self.faceData[iStoryId] and self.faceData[iStoryId][iRoleId] then
        self.faceData[iStoryId][iRoleId] = nil
    end
    return nil
end

function CreateFaceManager:SetAllPartPicByData(objRoot,tFaceData)
    local cgSex = tFaceData['uiCGSex']
    local characterPartData = self:CreateCharacterPartData(tFaceData)
    local objMalePart = objRoot:FindChild("CG/mask/CG_male")
    local objFemalePart = objRoot:FindChild("CG/mask/CG_female")
    local objNowRoot
    if cgSex == SexType.ST_Male then
        objNowRoot = objMalePart
        objMalePart:SetActive(true)
        objFemalePart:SetActive(false)
    else
        objNowRoot = objFemalePart
        objMalePart:SetActive(false)
        objFemalePart:SetActive(true)
    end
    local imgFacePartList = {}
    for iPartIndex = 0, 23 do
        if NEEDSMALLADJUSTPARTLIST[iPartIndex] then
            imgFacePartList[iPartIndex] = objNowRoot:FindChildComponent(CHARACTER_PART[iPartIndex].."/"..CHARACTER_PART[iPartIndex],"Image")
        else
            imgFacePartList[iPartIndex] = objNowRoot:FindChildComponent(CHARACTER_PART[iPartIndex],"Image")
        end
    end
    for iPartIndex = 0, 23 do
        if iPartIndex < 12 then 
            --  图片替换
            local facePartId = characterPartData[iPartIndex]
            local facePartData = TableDataManager:GetInstance():GetTableData("RoleFace",facePartId)
            if facePartData and dnull(facePartData.Pic) then
                imgFacePartList[iPartIndex].gameObject:SetActive(true)
                imgFacePartList[iPartIndex].sprite = GetSprite(facePartData.Pic)
            else
                if facePartId == nil then
                    dprint("该iPartIndex"..iPartIndex.."有误")
                else
                    if facePartData == nil then
                        dprint("该id无对应捏脸部位数据"..facePartId)
                    elseif dnull(facePartData.Pic) then
                        dprint("该id图片路径填写有误"..facePartId)
                    end
                    imgFacePartList[iPartIndex].gameObject:SetActive(false)
                end
            end
        else
            -- 对应部件下标值
            local rootPartIndex = NEEDSMALLADJUSTPARTLISTROOT[iPartIndex]
            for i=1,3 do
                if NEEDSMALLADJUSTPARTLISTPART[rootPartIndex][i] == iPartIndex then
                    -- iIndex区分是宽度、高度还是位置值
                    iIndex = i
                end
            end
            
            -- 部件微调数值
            local dataNum = characterPartData[iPartIndex]
            -- 部件id
            local rootPartId = characterPartData[rootPartIndex]
            -- 对数值进行检查调整
            -- dataNum = self:CheckWrongDataAndAdjust(dataNum,rootPartId,iIndex)

            --  位置微调刷新
            local comRectTransform = imgFacePartList[rootPartIndex].gameObject:GetComponent(DRCSRef_Type.RectTransform)
            if iIndex == 1  then
                comRectTransform.localScale = DRCSRef.Vec3(1 + dataNum/50, comRectTransform.localScale.y, 1)
            elseif iIndex == 2 then
                comRectTransform.localScale = DRCSRef.Vec3(comRectTransform.localScale.x, 1 + dataNum/50, 1)
            elseif iIndex == 3 then
                comRectTransform:SetTransAnchoredPosition(0, 0 + dataNum)
            end
        end
    end
end

-- 服务器格式FaceData转Json
-- ['uiModelID'] = iModelId or 0,
-- ['uiSex'] = iSex or 0,
-- ['uiCGSex'] = iCGSex or 0,
-- ['uiRoleID'] = iRoleId or 0,
function CreateFaceManager:CreateJsonStringByFaceData(tFaceData)
    local characterPartData = self:CreateCharacterPartData(tFaceData)
    local jsonString = ""
    for i = 0, #characterPartData do
        jsonString = jsonString .. tostring(characterPartData[i]) .. "_"  
    end
    -- 最后按顺序加上uiModelID uiSex uiCGSex uiRoleID
    jsonString = jsonString .. tostring(tFaceData["uiModelID"]) .. "_" .. tostring(tFaceData["uiSex"]).. "_"  .. tostring(tFaceData["uiCGSex"]).. "_"  .. tostring(tFaceData["uiRoleID"])
    return jsonString
end

-- Json转服务器格式FaceData
function CreateFaceManager:CreateFaceDataByJsonString(sJson)
    if not dnull(sJson) then
        return nil
    end
    local tCharacterPartData = string.split(sJson, "_")
    for i = 1, #tCharacterPartData do
        tCharacterPartData[i] = tonumber(tCharacterPartData[i])
    end
    local faceData = self:CreateFaceDataByTransFromStr(tCharacterPartData)
    -- 排除uiRoleID为0的数据
    if faceData.uiRoleID == 0 then 
        return nil
    end
    return faceData
end

function CreateFaceManager:IsOpenCreateFace()
    local bOpen = IsModuleEnable(SM_ROLEFACE)
    return bOpen
end

-- 判断当前捏脸部件是否已解锁
function CreateFaceManager:IsUnlockFacePart(iBaseID)
    local facePartId = iBaseID
    local facePartData = TableDataManager:GetInstance():GetTableData("RoleFace",facePartId)
    if facePartData.InitUnlock == TBoolean.BOOL_YES then
        return true
    else
        local unlockState = UnlockDataManager:GetInstance():HasUnlock(PlayerInfoType.PIT_ROLEFACE,facePartId)
        if unlockState then
            return true
        else
            if facePartData.UnlockCostSilver > 0 then
                return false
            elseif facePartData.UnlockAchieve > 0 then
                if AchieveDataManager:GetInstance():IsAchieveMade(facePartData.UnlockAchieve) then
                    return true                    
                end
            elseif facePartData.UnlockDLC > 0 then
                if DRCSRef.LogicMgr:GetInfo("dlc", facePartData.UnlockDLC) == 1 then
                    return true
                end
            end
        end
    end
    return false
end

-- 判断当前捏脸模型是否已解锁
function CreateFaceManager:IsUnlockModel(iBaseID)
    -- Show->Open->InitUnlock->道具->银锭->成就
    local modelId = iBaseID
    local modelData = TableDataManager:GetInstance():GetTableData("RoleFaceModel",modelId)
    if modelData.InitUnlock == TBoolean.BOOL_YES then
        return true
    else
        local unlockState = UnlockDataManager:GetInstance():HasUnlock(PlayerInfoType.PIT_ROLEFACE_MODEL,modelId)
        if unlockState then
            return true
        else
            if modelData.UnlockCostSilver > 0 then
                return false
            elseif modelData.UnlockAchieve > 0 then
                if AchieveDataManager:GetInstance():IsAchieveMade(modelData.UnlockAchieve) then
                    return true
                end
            elseif modelData.UnlockDLC > 0 then
                if DRCSRef.LogicMgr:GetInfo("dlc", modelData.UnlockDLC) == 1 then
                    return true
                end
            end
        end
    end
    return false
end

-- 因服务器存储失误造成部分上传公共服的数据会超出上限导致错误 客户端层做出检测校正(在数据下限做出调整并与错误数据重合时 可能会有错误 目前下限为-10 错误数据多数为-100多)
-- 检查异常数据并校正
function CreateFaceManager:CheckWrongDataAndAdjust(iNum,iPartId,iIndex)
    local nowPartData = TableDataManager:GetInstance():GetTableData("RoleFace",iPartId)
    local limitMinNum,defaultNum
    if iIndex == 1 then
        limitMinNum = nowPartData.MinWidth
        defaultNum = nowPartData.DefWidth
    elseif iIndex == 2 then
        limitMinNum = nowPartData.MinHeight
        defaultNum = nowPartData.DefHeight
    else
        limitMinNum = nowPartData.MinLocation
        defaultNum = nowPartData.DefLocation
    end
    if iNum < limitMinNum then
        -- 获得数据小于下限
        -- 特殊处理
        iNum = (iNum + 128)*(-1)
        -- 如果处理后的值还是小于下限 则给默认值
        if iNum < limitMinNum then
            iNum = defaultNum
        end
    end
    return iNum
end


