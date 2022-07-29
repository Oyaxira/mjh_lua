CreateFaceUI = class('CreateFaceUI', BaseWindow)

function CreateFaceUI:ctor()

end 

function CreateFaceUI:Create()
    local obj = LoadPrefabAndInit("CreateFace/CreateFaceUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function CreateFaceUI:Init()
    
    self:GetDefaultFaceDataList()

    self.TB_RoleFaceJudge = TableDataManager:GetInstance():GetTable("RoleFaceJudge")
    self.TB_RoleFaceJudgeDefault = TableDataManager:GetInstance():GetTable("RoleFaceJudgeDefault")
    
    self.btnClose =  self:FindChildComponent(self._gameObject,'newFrame/Btn_exit',DRCSRef_Type.Button)
    if self.btnClose then
        self:RemoveButtonClickListener(self.btnClose)
        self:AddButtonClickListener(self.btnClose, function()
            local content = {
                ['title'] = "提示",
                ['text'] = "将放弃当前数据保存，并退出自定义形象功能，确定要退出吗？"
            }
            local callback = function()
                RemoveWindowImmediately("CreateFaceUI")
            end
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
        end)
    end

    self.objLeftArea = {}
    self.objRightArea = {}
    -- leftarea_step1
    self.objLeftArea[1] = self:FindChild(self._gameObject,'LeftArea_Step1')
    self.btnNext =  self:FindChildComponent(self._gameObject,'LeftArea_Step1/Bt_next',DRCSRef_Type.Button)
    if self.btnNext then
        self:RemoveButtonClickListener(self.btnNext)
        self:AddButtonClickListener(self.btnNext, function()
            -- 判断是否被置灰
            if self:HasChooseLockPart() then
                SystemUICall:GetInstance():Toast("请先解锁部件")
            else
                self:SetNowStep(2)
            end
        end)
    end
    self.imgNext = self.btnNext.transform:GetComponent("Image")

    self.btnReset =  self:FindChildComponent(self._gameObject,'LeftArea_Step1/Bt_reset',DRCSRef_Type.Button)
    if self.btnReset then
        self:RemoveButtonClickListener(self.btnReset)
        self:AddButtonClickListener(self.btnReset, function()
            self:InitData()
            self:RefreshFaceByData()
        end)
    end

    self.btnRandom =  self:FindChildComponent(self._gameObject,'LeftArea_Step1/Bt_random',DRCSRef_Type.Button)
    if self.btnRandom then
        self:RemoveButtonClickListener(self.btnRandom)
        self:AddButtonClickListener(self.btnRandom, function()
            self:RandomFaceDataList()
            self:RefreshFaceByData()
        end)
    end

    self.btnSexLeft =  self:FindChildComponent(self._gameObject,'Sex/LeftButton',DRCSRef_Type.Button)
    if self.btnSexLeft then
        self:RemoveButtonClickListener(self.btnSexLeft)
        self:AddButtonClickListener(self.btnSexLeft, function()
            self:ClickChangeDefaultSex()
        end)
    end
    self.imgSexLeftButton = self:FindChildComponent(self._gameObject,'Sex/LeftButton','Image')

    self.btnSexRight =  self:FindChildComponent(self._gameObject,'Sex/RightButton',DRCSRef_Type.Button)
    if self.btnSexRight then
        self:RemoveButtonClickListener(self.btnSexRight)
        self:AddButtonClickListener(self.btnSexRight, function()
            self:ClickChangeDefaultSex()
        end)
    end
    self.imgSexRightButton = self:FindChildComponent(self._gameObject,'Sex/RightButton','Image')


    self.txtSex = self:FindChildComponent(self._gameObject,'Sex/Text',"Text")

    -- rightarea_step1
    self.objRightArea[1] = self:FindChild(self._gameObject,'RightArea_Step1')
    for i=0,11 do
        local strLeftBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/LeftButton'
        local strRightBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/RightButton'
        local btnCharacterPartLeft = self:FindChildComponent(self._gameObject,strLeftBtnName,DRCSRef_Type.Button)
        if btnCharacterPartLeft then
            self:RemoveButtonClickListener(btnCharacterPartLeft)
            self:AddButtonClickListener(btnCharacterPartLeft, function()
                self:ClickAdjustPartButton(i,0)
            end)
        end
        local btnCharacterPartRight = self:FindChildComponent(self._gameObject,strRightBtnName,DRCSRef_Type.Button)
        if btnCharacterPartRight then
            self:RemoveButtonClickListener(btnCharacterPartRight)
            self:AddButtonClickListener(btnCharacterPartRight, function()
                self:ClickAdjustPartButton(i,1)
            end)
        end
        if NEEDSMALLADJUSTPARTLIST[i] then
            local strDetailBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/Bt_detail'
            local btnAdjustDetail = self:FindChildComponent(self._gameObject,strDetailBtnName,DRCSRef_Type.Button)
            if btnAdjustDetail then
                self:RemoveButtonClickListener(btnAdjustDetail)
                self:AddButtonClickListener(btnAdjustDetail, function()
                    self:ClickAdjustDetailButton(i)
                end)
            end
        end
    end

    -- cg
    self.cgPartMale = self:FindChild(self._gameObject,"CG/mask/CG_male")
    self.imgFacePartListMale = {}
    for i=0,11 do
        if NEEDSMALLADJUSTPARTLIST[i] then
            self.imgFacePartListMale[i] = self:FindChildComponent(self._gameObject,"CG/mask/CG_male/"..CHARACTER_PART[i].."/"..CHARACTER_PART[i],"Image")
        else
            self.imgFacePartListMale[i] = self:FindChildComponent(self._gameObject,"CG/mask/CG_male/"..CHARACTER_PART[i],"Image")
        end
    end
    self.cgPartFemale = self:FindChild(self._gameObject,"CG/mask/CG_female")
    self.imgFacePartListFemale = {}
    for i=0,11 do
        if NEEDSMALLADJUSTPARTLIST[i] then
            self.imgFacePartListFemale[i] = self:FindChildComponent(self._gameObject,"CG/mask/CG_female/"..CHARACTER_PART[i].."/"..CHARACTER_PART[i],"Image")
        else
            self.imgFacePartListFemale[i] = self:FindChildComponent(self._gameObject,"CG/mask/CG_female/"..CHARACTER_PART[i],"Image")
        end
    end
    -- detail
    self.detailPart = self:FindChild(self._gameObject,"DetailArea")
    self.btnCloseDetailPart = self:FindChildComponent(self._gameObject,"DetailArea/newFrame/Btn_exit",DRCSRef_Type.Button)
    if self.btnCloseDetailPart then
        self:RemoveButtonClickListener(self.btnCloseDetailPart)
        self:AddButtonClickListener(self.btnCloseDetailPart, function()
            -- local content = {
            --     ['title'] = "提示",
            --     ['text'] = "将放弃当前数据保存，并关闭当前界面，确定要退出吗？"
            -- }
            -- local callback = function()
                self.detailPart:SetActive(false)
                -- 需要恢复到打开界面前的状态
                self.faceDataList = self.oldFaceDataList
                self:RefreshFaceByData()
            -- end
            -- OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
        end)
    end
    self.btnConfirmDetailPart = self:FindChildComponent(self._gameObject,"DetailArea/Bt_confirm",DRCSRef_Type.Button)
    if self.btnConfirmDetailPart then
        self:RemoveButtonClickListener(self.btnConfirmDetailPart)
        self:AddButtonClickListener(self.btnConfirmDetailPart, function()
            self.detailPart:SetActive(false)
        end)
    end
    self.txtDetailTitle = self:FindChildComponent(self._gameObject,"DetailArea/newFrame/Title","Text")
    self.objDetailPoint = {}
    self.objDetailPoint[1] = self:FindChild(self._gameObject,"DetailArea/height")
    self.objDetailPoint[2] = self:FindChild(self._gameObject,"DetailArea/width")
    self.objDetailPoint[3] = self:FindChild(self._gameObject,"DetailArea/position")
    self.barDetail = {}
    self.btnDetailLeft = {}
    self.btnDetailRight = {}
    self.txtDetailPartTitle = {}
    self.txtDetailPartMinNum = {}
    self.txtDetailPartNowNum = {}
    self.txtDetailPartMaxNum = {}
    for i=1,3 do
        self.barDetail[i] = self:FindChildComponent(self.objDetailPoint[i],"adjustBar/Scrollbar",DRCSRef_Type.Scrollbar)
        self.btnDetailLeft[i] = self:FindChildComponent(self.objDetailPoint[i],"adjustBar/LeftButton",DRCSRef_Type.Button)
        self.btnDetailRight[i] = self:FindChildComponent(self.objDetailPoint[i],"adjustBar/RightButton",DRCSRef_Type.Button)
        self.txtDetailPartTitle[i] = self:FindChildComponent(self.objDetailPoint[i],"title","Text")
        self.txtDetailPartMinNum[i] = self:FindChildComponent(self.objDetailPoint[i],"adjustBar/MinNum","Text")
        self.txtDetailPartMaxNum[i] = self:FindChildComponent(self.objDetailPoint[i],"adjustBar/MaxNum","Text")
        self.txtDetailPartNowNum[i] = self:FindChildComponent(self.objDetailPoint[i],"adjustBar/Scrollbar/Sliding Area/Handle/NowNum","Text")
    end

    -- leftarea_step2
    self.objLeftArea[2] = self:FindChild(self._gameObject,'LeftArea_Step2')

    self.objShareButton = self:FindChild(self._gameObject,'LeftArea_Step2/ShareButton')
    -- 提审包隐藏平台能力按钮
	-- if MSDK_MODE == 9 then
		self.objShareButton:SetActive(false)
	-- else
	-- 	self.objShareButton:SetActive(true)
	-- end

    self.btnShareToPlat =  self:FindChildComponent(self._gameObject,'LeftArea_Step2/ShareButton',DRCSRef_Type.Button)
    if self.btnShareToPlat then
        self:RemoveButtonClickListener(self.btnShareToPlat)
        self:AddButtonClickListener(self.btnShareToPlat, function()
            self:SetNowStep(4)
        end)
    end

    self.objShareButtons = self:FindChild(self.objLeftArea[2],'BtnGroup')
    self.btnShareButtonsClose = self:FindChildComponent(self.objLeftArea[2],'BtnGroupClose',DRCSRef_Type.Button)
    if self.btnShareButtonsClose then
        self:RemoveButtonClickListener(self.btnShareButtonsClose)
        self:AddButtonClickListener(self.btnShareButtonsClose, function()
            self:SetNowStep(2)
        end)
    end
    self.objShareButtonQQ1 = self:FindChild(self.objLeftArea[2],'BtnGroup/QQButton')
    self.btnShareButtonQQ1 = self.objShareButtonQQ1:GetComponent(DRCSRef_Type.Button)
    if self.btnShareButtonQQ1 then
        self:RemoveButtonClickListener(self.btnShareButtonQQ1)
        self:AddButtonClickListener(self.btnShareButtonQQ1, function()
            self:Share(1)
        end)
    end
    self.objShareButtonQQ2 = self:FindChild(self.objLeftArea[2],'BtnGroup/QQSpaceButton')
    self.btnShareButtonQQ2 = self.objShareButtonQQ2:GetComponent(DRCSRef_Type.Button)
    if self.btnShareButtonQQ2 then
        self:RemoveButtonClickListener(self.btnShareButtonQQ2)
        self:AddButtonClickListener(self.btnShareButtonQQ2, function()
            self:Share(2)
        end)
    end
    self.objShareButtonWX1 = self:FindChild(self.objLeftArea[2],'BtnGroup/WXButton')
    self.btnShareButtonWX1 = self.objShareButtonWX1:GetComponent(DRCSRef_Type.Button)
    if self.btnShareButtonWX1 then
        self:RemoveButtonClickListener(self.btnShareButtonWX1)
        self:AddButtonClickListener(self.btnShareButtonWX1, function()
            self:Share(3)
        end)
    end
    self.objShareButtonWX2 = self:FindChild(self.objLeftArea[2],'BtnGroup/WXTimeLineButton')
    self.btnShareButtonWX2 = self.objShareButtonWX2:GetComponent(DRCSRef_Type.Button)
    if self.btnShareButtonWX2 then
        self:RemoveButtonClickListener(self.btnShareButtonWX2)
        self:AddButtonClickListener(self.btnShareButtonWX2, function()
            self:Share(4)
        end)
    end

    self.btnBigCG =  self:FindChildComponent(self._gameObject,'LeftArea_Step2/Bt_bigCG',DRCSRef_Type.Button)
    if self.btnBigCG then
        self:RemoveButtonClickListener(self.btnBigCG)
        self:AddButtonClickListener(self.btnBigCG, function()
            self:SetNowStep(3)
        end)
    end

    self.btnBackBeforeStep =  self:FindChildComponent(self._gameObject,'LeftArea_Step2/Bt_back',DRCSRef_Type.Button)
    if self.btnBackBeforeStep then
        self:RemoveButtonClickListener(self.btnBackBeforeStep)
        self:AddButtonClickListener(self.btnBackBeforeStep, function()
            self:SetNowStep(1)
        end)
    end

    self.btnSaveData =  self:FindChildComponent(self._gameObject,'LeftArea_Step2/Bt_next',DRCSRef_Type.Button)
    if self.btnSaveData then
        self:RemoveButtonClickListener(self.btnSaveData)
        self:AddButtonClickListener(self.btnSaveData, function()
            if self:HasChooseLockModel() then
                SystemUICall:GetInstance():Toast("请先解锁模型")
            else
                CreateFaceManager:GetInstance():UploadFaceData(self.storyId,self.roleId,self.modelId,self.sex,self.cgsex,self.faceDataList)
                RemoveWindowImmediately("CreateFaceUI")
            end
        end)
    end
    self.imgSaveData = self.btnSaveData.transform:GetComponent("Image")


    -- rightarea_step2
    self.objRightArea[2] = self:FindChild(self._gameObject,'RightArea_Step2')

    self.objSexPart = self:FindChild(self.objRightArea[2],'sex')
    self.btnGameSexLeftButton = self:FindChildComponent(self.objSexPart,'LeftButton',DRCSRef_Type.Button)
    if self.btnGameSexLeftButton then
        self:RemoveButtonClickListener(self.btnGameSexLeftButton)
        self:AddButtonClickListener(self.btnGameSexLeftButton, function()
            self:ClickChangeGameSex()
        end)
    end
    self.btnGameSexRightButton = self:FindChildComponent(self.objSexPart,'RightButton',DRCSRef_Type.Button)
    if self.btnGameSexRightButton then
        self:RemoveButtonClickListener(self.btnGameSexRightButton)
        self:AddButtonClickListener(self.btnGameSexRightButton, function()
            self:ClickChangeGameSex()
        end)
    end
    self.txtGameSex = self:FindChildComponent(self.objSexPart,'Text','Text')

    self.objSpine = self:FindChild(self.objRightArea[2],'Spine')
    
    self.objModelPart = self:FindChild(self.objRightArea[2],'model')
    self.txtModelName = self:FindChildComponent(self.objModelPart,'SpineName','Text')
    self.objModelLockImage = self:FindChild(self.objModelPart,'LockImage')
    self.objModelLockButton = self:FindChild(self.objModelPart,'LockButton')
    self.btnModelLock = self:FindChildComponent(self.objModelPart,'LockButton',DRCSRef_Type.Button)
    self.txtModelLock = self:FindChildComponent(self.objModelPart,'LockImage/Text','Text')

    self.btnModelLeftButton = self:FindChildComponent(self.objModelPart,'LeftButton',DRCSRef_Type.Button)
    if self.btnModelLeftButton then
        self:RemoveButtonClickListener(self.btnModelLeftButton)
        self:AddButtonClickListener(self.btnModelLeftButton, function()
            self:ClickChangeModel(-1)
        end)
    end

    self.btnModelRightButton = self:FindChildComponent(self.objModelPart,'RightButton',DRCSRef_Type.Button)
    if self.btnModelRightButton then
        self:RemoveButtonClickListener(self.btnModelRightButton)
        self:AddButtonClickListener(self.btnModelRightButton, function()
            self:ClickChangeModel(1)
        end)
    end
    
    -- leftarea_step3
    self.objShareBigPic = self:FindChild(self._gameObject,'ShareBigPic')
    self.txtShareBigPicPlayerInfo = self:FindChildComponent(self._gameObject,'ShareBigPic/Text_playerInfo','Text')
    self.btnShareBigPicBack = self:FindChildComponent(self._gameObject,'ShareBigPic/Bt_back',DRCSRef_Type.Button)
    if self.btnShareBigPicBack then
        self:RemoveButtonClickListener(self.btnShareBigPicBack)
        self:AddButtonClickListener(self.btnShareBigPicBack, function()
            self.objShareBigPic:SetActive(false)
            self.objSpine:SetActive(true)
            self:SetNoticeStop()
            self:SetNowStep(2)
        end)
    end
    self.txtShareBigPicNotice = self:FindChildComponent(self._gameObject,'ShareBigPic/Text_notice','Text')

    --RightArea_Step3
    self.objRightArea[3] = self:FindChild(self._gameObject,'RightArea_Step3')
    self.txtFinalJudge = self:FindChildComponent(self.objRightArea[3],'Text_final','Text')
    self.txtFinalJudgePlayerInfo = self:FindChildComponent(self.objRightArea[3],'Text_playerInfo','Text')


    -- 解锁捏脸组件回调
    self:AddEventListener(CreateFaceManager.UI_EVENT.UnlockNewFacePart,function ()
        self:RefreshFaceByData()
    end)
    -- 解锁模型回调
    self:AddEventListener(CreateFaceManager.UI_EVENT.UnlockNewModel,function ()
        self:ClickChangeModel(0)
    end)


end

function CreateFaceUI:GetDefaultFaceDataList()
    -- 遍历roleface表的时候 对默认重置值进行赋值 同时存储下各个部位的取值范围
    local TB_RoleFace = TableDataManager:GetInstance():GetTable("RoleFace")
    self.faceDataPartRange_Male = {}
    self.faceDataPartBaseid2Index_Male = {}

    self.faceDataPartRange_Female = {}
    self.faceDataPartBaseid2Index_Female = {}

    local index_male = {}
    local index_female = {}
    for index, value in pairs(TB_RoleFace)  do
        local roleFaceData = TableDataManager:GetInstance():GetTableData("RoleFace",index)
        if roleFaceData.Hide == TBoolean.BOOL_NO then
            if not self.faceDataPartRange_Male[roleFaceData.PositionType] then
                self.faceDataPartRange_Male[roleFaceData.PositionType] = {}
                self.faceDataPartBaseid2Index_Male[roleFaceData.PositionType] = {}
                self.faceDataPartRange_Female[roleFaceData.PositionType] = {}
                self.faceDataPartBaseid2Index_Female[roleFaceData.PositionType] = {}
                index_male[roleFaceData.PositionType] = 1
                index_female[roleFaceData.PositionType] = 1
            end
            if roleFaceData.SexLimit == SexType.ST_Female then

                self.faceDataPartRange_Female[roleFaceData.PositionType][index_female[roleFaceData.PositionType]] = index
                --self.faceDataPartBaseid2Index_Female[roleFaceData.PositionType][index] = index_female[roleFaceData.PositionType]
                index_female[roleFaceData.PositionType] = index_female[roleFaceData.PositionType] + 1
            else
                self.faceDataPartRange_Male[roleFaceData.PositionType][index_male[roleFaceData.PositionType]] = index
                --self.faceDataPartBaseid2Index_Male[roleFaceData.PositionType][index] = index_male[roleFaceData.PositionType]
                index_male[roleFaceData.PositionType] = index_male[roleFaceData.PositionType] + 1
            end
        end
    end
    local fun = function (a ,b)
        return a < b
    end
    local index = 1
    for key, value in pairs(self.faceDataPartRange_Female) do
        table.sort(value, fun)
        index = 1
        for _, data in pairs(value) do
            self.faceDataPartBaseid2Index_Female[key][data] = index
            index = index + 1
        end
    end
    for key, value in pairs(self.faceDataPartRange_Male) do
        table.sort(value, fun)
        index = 1
        for _, data in pairs(value) do
            self.faceDataPartBaseid2Index_Male[key][data] = index
            index = index + 1
        end
    end
end

function CreateFaceUI:ResetFaceDataListByCGSex()
    self.faceDataList = {}
    for i=0,23 do
        if i<12 then
            self.faceDataList[i] = CreateFaceManager:GetInstance():GetDefaultDataBySex(self.cgsex,i+1)
            if self.faceDataList[i] == nil then
                self.faceDataList[i] = 0
            end
        else 
            self.faceDataList[i] = 0
        end
    end
    -- self.cgsex代表选择的立绘性别 性别不同随机池和选择的范围不同
    if self.cgsex == SexType.ST_Male then
        self.txtSex.text = "气宇轩昂" 
    else
        self.txtSex.text = "亭亭玉立"
    end
end

function CreateFaceUI:InitData()
    -- 判断如果有已存的数据则用原数据 否则用默认数据
    -- 创角的时候都是看酒馆数据 所以storyId不用当前值
    if self.storyId and self.roleId then
        local storyId = self.storyId
        -- 特殊的 在剧本捏脸界面第一次进去是无数据的 显示为酒馆默认内容
        -- 第二次再进入界面 就应该为存储的那套捏脸数据
        if CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(storyId,self.roleId) == nil then
            storyId = 0
        end
        self.faceDataList = CreateFaceManager:GetInstance():GetCharacterPartDataByStoryIDAndRoleId(storyId,self.roleId)
        self.modelId = CreateFaceManager:GetInstance():GetModelIdByStoryIDAndRoleId(storyId,self.roleId) or 1
        --取模型的性别作为自定义初始化的角色性别
        local TB_CreateRole = TableDataManager:GetInstance():GetTable("CreateRole")
        self.createRoleData = {}
        for key, value in pairs(TB_CreateRole) do
            if value.OldRoleID == self.roleId then
                self.createRoleData = value
                break
            end
        end
        if self.createRoleData then
            self.sex = self.createRoleData.ModelFeMale
            self.cgsex = self.createRoleData.ModelFeMale
        else
            self.sex = SexType.ST_Male
            self.cgsex = SexType.ST_Male
        end
        if self.babyId then
            -- 平台徒弟的性别需要拿真实id去createrole表取 用占位平台id不行
            self.sex = RoleDataManager:GetInstance():GetRoleSexByTypeID(self.babyId) 
        else
            self.sex = RoleDataManager:GetInstance():GetRoleSexByTypeID(self.roleId) --CreateFaceManager:GetInstance():GetSexByStoryIDAndRoleId(storyId,self.roleId) or 
        end
        --self.cgsex = CreateFaceManager:GetInstance():GetCGSexByStoryIDAndRoleId(storyId,self.roleId) or SexType.ST_Male

        self.modelIdIndex = CreateFaceManager:GetInstance():GetNowModelIndex(self.modelId) or 1
        -- self.cgsex代表选择的立绘性别 性别不同随机池和选择的范围不同
        self.cgPartMale:SetActive(false)
        self.cgPartFemale:SetActive(false)
        if self.cgsex == SexType.ST_Male then
            self.txtSex.text = "气宇轩昂"
            self.cgPart = self.cgPartMale
            self.imgFacePartList = self.imgFacePartListMale
        elseif self.cgsex == SexType.ST_Female then
            self.txtSex.text = "亭亭玉立"
            self.cgPart = self.cgPartFemale
            self.imgFacePartList = self.imgFacePartListFemale
        elseif self.cgsex == SexType.ST_Eunuch then
            --太监处理 现在太监模型先按照女性模型一样处理
            self.txtSex.text = "亭亭玉立"
            self.cgPart = self.cgPartFemale
            self.imgFacePartList = self.imgFacePartListFemale
        end
        if self.sex == SexType.ST_Male then
            self.txtGameSex.text = "男"  
        else
            self.txtGameSex.text = "女" 
        end
        self.cgPart:SetActive(true)
    end
    -- 没有捏脸数据时 用默认的
    if self.faceDataList == nil then
        self:ResetFaceDataListByCGSex()
    end
end

function CreateFaceUI:ClickChangeGameSex()
    -- 目前改变性别功能关闭
    -- if self.sex == SexType.ST_Male then
    --     self.sex = SexType.ST_Female 
    --     self.txtGameSex.text = "女"
    -- else
    --     self.sex = SexType.ST_Male
    --     self.txtGameSex.text = "男"  
    -- end
end

function CreateFaceUI:ClickChangeDefaultSex()
    if self.cgsex == SexType.ST_Male then
        self.cgsex = SexType.ST_Female 
    else
        self.cgsex = SexType.ST_Male 
    end
    self.cgPart:SetActive(false)
    if self.cgsex == SexType.ST_Male then
        self.cgPart = self.cgPartMale
        self.imgFacePartList = self.imgFacePartListMale
    else
        self.cgPart = self.cgPartFemale
        self.imgFacePartList = self.imgFacePartListFemale
    end
    self.cgPart:SetActive(true)
    self:ResetFaceDataListByCGSex()
    self:RefreshFaceByData()
end

function CreateFaceUI:RandomFaceDataList()
    -- 初始化读表时 记录下不同部位的范围值 在随机时在范围内随机
    self.faceDataList = {}
    for i=0,23 do
        if i<12 then
            local dataRange
            if self.cgsex == SexType.ST_Male then
                dataRange = self.faceDataPartRange_Male
            else
                dataRange = self.faceDataPartRange_Female
            end
            if dataRange[i+1] == nil then
                self.faceDataList[i] = 0
            else
                local r
                while true do
                    r = math.random(1,#dataRange[i+1])
                    local facePartId = dataRange[i+1][r]
                    -- 判断是否已解锁
                    local facePartData = TableDataManager:GetInstance():GetTableData("RoleFace",facePartId)
                    local initUnlockState = facePartData.InitUnlock
                    if initUnlockState == TBoolean.BOOL_YES then
                        break
                    else
                        local unlockState = UnlockDataManager:GetInstance():HasUnlock(PlayerInfoType.PIT_ROLEFACE,facePartId)
                        if unlockState then
                            break
                        end
                    end
                end
                self.faceDataList[i] = dataRange[i+1][r]
            end
        else
            self.faceDataList[i] = 0
        end
    end
end

-- 点击微调界面
function CreateFaceUI:ClickAdjustDetailButton(iPartIndex)
    self.detailPart:SetActive(true)
    self.oldFaceDataList = {}
    for i=0,23 do
        self.oldFaceDataList[i] = self.faceDataList[i]
    end
    -- 刷新微调界面的cg ui
    local faceData = CreateFaceManager:GetInstance():CreateFaceData(self.roleId,self.modelId,self.sex,self.cgsex,self.faceDataList)
    CreateFaceManager:GetInstance():SetAllPartPicByData(self.detailPart,faceData)

    -- 获取当前微调界面的数据 没有数据则用0
    local partName = NEEDSMALLADJUSTPARTLISTNAME[iPartIndex]
    self.txtDetailTitle.text = "调整"..partName
    self.txtDetailPartTitle[1].text = partName.."宽度"
    self.txtDetailPartTitle[2].text = partName.."高度"
    self.txtDetailPartTitle[3].text = partName.."位置"
    self.sizeDetailPartNum = {}
    local nowPartData = TableDataManager:GetInstance():GetTableData("RoleFace",self.faceDataList[iPartIndex])
    local minDataList = {
        [1] = nowPartData.MinWidth,
        [2] = nowPartData.MinHeight,
        [3] = nowPartData.MinLocation,
    }
    local maxDataList = {
        [1] = nowPartData.MaxWidth,
        [2] = nowPartData.MaxHeight,
        [3] = nowPartData.MaxLocation,
    }
    -- local defaultDataList = {
    --     [1] = nowPartData.DefWidth,
    --     [2] = nowPartData.DefHeight,
    --     [3] = nowPartData.DefLocation,
    -- }
    for i=1,3 do
        -- 读表
        local minNum = minDataList[i]
        local maxNum = maxDataList[i]
        -- 读配置
        local detailPartId = NEEDSMALLADJUSTPARTLISTPART[iPartIndex][i]
        local nowNum = self.faceDataList[detailPartId]
        self.txtDetailPartMinNum[i].text = minNum
        self.txtDetailPartMaxNum[i].text = maxNum
        self.sizeDetailPartNum[i] = {minNum,maxNum}
        -- self.barDetail[i].numberOfSteps = maxNum - minNum
        self:RemoveButtonClickListener(self.btnDetailLeft[i])
        self:AddButtonClickListener(self.btnDetailLeft[i], function()
            self:ClickDetailAdjustButton(iPartIndex,i,0)
        end)
        self:RemoveButtonClickListener(self.btnDetailRight[i])
        self:AddButtonClickListener(self.btnDetailRight[i], function()
            self:ClickDetailAdjustButton(iPartIndex,i,1)
        end)
        self.barDetail[i].onValueChanged:RemoveAllListeners()
        local func = function(value)
            local num = (self.sizeDetailPartNum[i][2] - self.sizeDetailPartNum[i][1]) * (value - 0.5)
            self:OnChangeDetailPart(iPartIndex,i,num)
        end
        self.barDetail[i].onValueChanged:AddListener(func)
        local num = nowNum / (self.sizeDetailPartNum[i][2]-self.sizeDetailPartNum[i][1])
        self.barDetail[i].value = 0.5 + num
    end
end

function CreateFaceUI:ClickDetailAdjustButton(iPartIndex,iIndex,iPos)
    local oldNum = self.faceDataList[NEEDSMALLADJUSTPARTLISTPART[iPartIndex][iIndex]]
    local newNum
    if iPos == 0 then
        --减小
        newNum = oldNum - 1
    elseif iPos == 1 then
        --增大
        newNum = oldNum + 1
    end
    if newNum >= self.sizeDetailPartNum[iIndex][1] and newNum <= self.sizeDetailPartNum[iIndex][2] then
        local num = newNum / (self.sizeDetailPartNum[iIndex][2]-self.sizeDetailPartNum[iIndex][1])
        self.barDetail[iIndex].value = 0.5 + num
    end
end

function CreateFaceUI:OnChangeDetailPart(iPartIndex,iIndex,iNum)
    local value,f = math.modf(iNum)
    if math.abs(f) > 0.5 then 
        if value < 0 then
            value = value - 1 
        else
            value = value + 1 
        end
    end
    -- uibar改变->数据改变->text改变->刷新图片
    self.faceDataList[NEEDSMALLADJUSTPARTLISTPART[iPartIndex][iIndex]] = value
    self.txtDetailPartNowNum[iIndex].text = tostring(value)
    self:RefreshFaceByPartIndex(NEEDSMALLADJUSTPARTLISTPART[iPartIndex][iIndex])
    self:RefreshDetailPartImage(NEEDSMALLADJUSTPARTLISTPART[iPartIndex][iIndex])
end

function CreateFaceUI:RefreshDetailPartImage(iPartIndex)
    -- 刷新微调界面的cg ui
    local faceData = CreateFaceManager:GetInstance():CreateFaceData(self.roleId,self.modelId,self.sex,self.cgsex,self.faceDataList)
    CreateFaceManager:GetInstance():SetAllPartPicByData(self.detailPart,faceData)
end

-- 点击更换部位资源
function CreateFaceUI:ClickAdjustPartButton(iPartIndex,iPos)
    local oldId = self.faceDataList[iPartIndex]
    local newId            
    local faceDataPartRange,faceDataPartBaseid2Index
    if self.cgsex == SexType.ST_Male then
        faceDataPartRange = self.faceDataPartRange_Male[iPartIndex+1]
        faceDataPartBaseid2Index = self.faceDataPartBaseid2Index_Male[iPartIndex+1]
    else
        faceDataPartRange = self.faceDataPartRange_Female[iPartIndex+1]
        faceDataPartBaseid2Index = self.faceDataPartBaseid2Index_Female[iPartIndex+1]
    end
    local maxIndex = #faceDataPartRange
    local oldIndex = faceDataPartBaseid2Index[oldId]
    local newIndex = oldIndex --默认值
    if iPos == 0 then
        -- 减小
        newIndex = oldIndex - 1
        if newIndex < 1 then
            newIndex = maxIndex
        end
    elseif iPos == 1 then
        -- 增大
        newIndex = oldIndex + 1
        if newIndex > maxIndex then
            newIndex = 1
        end
    end
    newId = faceDataPartRange[newIndex]
    local newData = TableDataManager:GetInstance():GetTableData("RoleFace",newId)
    -- i是从0-11 PositionType是从1-12
    -- 保证数据不为空 且还是当前的部位
    if newData and newData.PositionType == iPartIndex+1 then
        -- 根据当前位置替换图片
        -- 读表是否已经是最前最后的图片
        self.faceDataList[iPartIndex] = newId
        self:RefreshFaceByPartIndex(iPartIndex)
    end
end

function CreateFaceUI:RefreshFaceByPartIndex(iPartIndex)
    if iPartIndex<12 then 
        --  图片替换
        local facePartId = self.faceDataList[iPartIndex]
        local facePartData = TableDataManager:GetInstance():GetTableData("RoleFace",facePartId)
        if facePartData and dnull(facePartData.Pic) then
            self.imgFacePartList[iPartIndex].gameObject:SetActive(true)
            self.imgFacePartList[iPartIndex].sprite = GetSprite(facePartData.Pic)
            -- 更新文本
            local txtPartName = self:FindChildComponent(self._gameObject,'RightArea_Step1/'..CHARACTER_PART[iPartIndex]..'/Text',"Text")
            txtPartName.text = facePartData.Name
            txtPartName.color = getRankColor(facePartData.Rank)
            
            local txtLock = self:FindChildComponent(self._gameObject,'RightArea_Step1/'..CHARACTER_PART[iPartIndex]..'/Text_lock',"Text")
            local btnUnLock = self:FindChildComponent(self._gameObject,'RightArea_Step1/'..CHARACTER_PART[iPartIndex]..'/LockButton',"Button")
            -- 判断当前是否已经解锁
            if CreateFaceManager:GetInstance():IsUnlockFacePart(facePartId) then
                txtLock.gameObject:SetActive(false)
                btnUnLock.gameObject:SetActive(false)
                self.lockPartList[iPartIndex] = nil
            else
                txtLock.gameObject:SetActive(true)
                btnUnLock.gameObject:SetActive(true)
                if not dnull(facePartData.UnlockDescription) then
                    txtLock.text = "[RoleFace表缺少解锁描述]"
                else
                    txtLock.text = string.format(facePartData.UnlockDescription,facePartData.Name)
                end
                if btnUnLock then
                    self:RemoveButtonClickListener(btnUnLock)
                    self:AddButtonClickListener(btnUnLock, function()
                        -- 判断解锁条件 如果是银锭就弹框
                        if facePartData.UnlockCostSilver > 0 then
                            local content = {
                                ['title'] = "提示",
                                ['text'] = "解锁【"..facePartData.Name.."】需消耗"..facePartData.UnlockCostSilver.."银锭\n是否要立即解锁？"
                            }
                            local callback = function()
                                PlayerSetDataManager:GetInstance():RequestSpendSilver(facePartData.UnlockCostSilver,function()
                                    CreateFaceManager:GetInstance():UnlockFacePart(self.storyId,facePartId)
                                end)
                            end
                            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
                        else
                            SystemUICall:GetInstance():Toast("解锁条件不满足")
                        end
                    end)
                    
                end
                self.lockPartList[iPartIndex] = true
            end
        else
            if facePartId == nil then
                dprint("该iPartIndex"..iPartIndex.."有误")
            else
                if facePartData == nil then
                    dprint("该id无对应捏脸部位数据"..facePartId)
                elseif dnull(facePartData.Pic) then
                    dprint("该id图片路径填写有误"..facePartId)
                end
                self.imgFacePartList[iPartIndex].gameObject:SetActive(false)
            end
        end
    else
        local rootPart = NEEDSMALLADJUSTPARTLISTROOT[iPartIndex]
        for i=1,3 do
            if NEEDSMALLADJUSTPARTLISTPART[rootPart][i] == iPartIndex then
                iIndex = i
            end
        end
        --  位置微调
	    local comRectTransform = self.imgFacePartList[rootPart].gameObject:GetComponent(DRCSRef_Type.RectTransform)
        if iIndex == 1  then
            comRectTransform.localScale = DRCSRef.Vec3(1 + self.faceDataList[iPartIndex]/50, comRectTransform.localScale.y, 1)
        elseif iIndex == 2 then
            comRectTransform.localScale = DRCSRef.Vec3(comRectTransform.localScale.x, 1 + self.faceDataList[iPartIndex]/50, 1)
        elseif iIndex == 3 then
            comRectTransform:SetTransAnchoredPosition(0, 0 + self.faceDataList[iPartIndex])
        end
    end
    -- 检查是否有选择未解锁部件
    if self:HasChooseLockPart() then
        setUIGray(self.imgNext,true)
    else
        setUIGray(self.imgNext,false)   
    end
end

function CreateFaceUI:RefreshFaceByData()
    self.lockPartList = {}
    for i=0,23 do
        self:RefreshFaceByPartIndex(i)
    end
end

function CreateFaceUI:HasChooseLockPart()
    local sum = 0
    for partId,value in pairs(self.lockPartList) do
        sum = sum + 1
    end
    if sum == 0 then 
        return false
    else
        return true
    end
end

function CreateFaceUI:HasChooseLockModel()
    return self.isModelLock
end

function CreateFaceUI:OnPressESCKey()
    if self.detailPart.gameObject.activeSelf == false then
        if self.btnClose then
            self.btnClose.onClick:Invoke()
        end
    else
        if self.btnCloseDetailPart then
            self.btnCloseDetailPart.onClick:Invoke()
        end
    end
end

function CreateFaceUI:SetNowStep(iStep)
    --step1 捏脸
    --step2 选模型
    --step3 大图界面
    --step4 显示分享按钮组
    --step5 分享界面
    if iStep < 3 then 
        for i=1,2 do
            if i == iStep then
                self.objLeftArea[i]:SetActive(true)
                self.objRightArea[i]:SetActive(true)
            else
                self.objLeftArea[i]:SetActive(false)
                self.objRightArea[i]:SetActive(false)
            end
        end
        -- 特别的step2时依旧需要显示部件
        -- 1 部件选择按钮们
        self.objRightArea[1]:SetActive(true)
        for i=0,11 do
            local strLeftBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/LeftButton'
            local strRightBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/RightButton'
            local btnCharacterPartLeft = self:FindChildComponent(self._gameObject,strLeftBtnName,DRCSRef_Type.Button)
            local imgCharacterPartLeft = self:FindChildComponent(self._gameObject,strLeftBtnName,'Image')
            local btnCharacterPartRight = self:FindChildComponent(self._gameObject,strRightBtnName,DRCSRef_Type.Button)
            local imgCharacterPartRight = self:FindChildComponent(self._gameObject,strRightBtnName,'Image')
            
            local strPartName = 'RightArea_Step1/'..CHARACTER_PART[i]
            local objPart = self:FindChild(self._gameObject,strPartName)
            if iStep == 1 then
                if NEEDSMALLADJUSTPARTLIST[i] then
                    objPart:SetActive(true)
                else
                    -- 恢复灰化
                    btnCharacterPartLeft.interactable = true
                    setUIGray(imgCharacterPartLeft,false)
                    btnCharacterPartRight.interactable = true
                    setUIGray(imgCharacterPartRight,false)
                end
            elseif iStep == 2 then
                if NEEDSMALLADJUSTPARTLIST[i] then
                    objPart:SetActive(false)
                else
                    -- 对按钮灰化处理
                    btnCharacterPartLeft.interactable = false
                    setUIGray(imgCharacterPartLeft,true)
                    btnCharacterPartRight.interactable = false
                    setUIGray(imgCharacterPartRight,true)
                end
            end
        end
        -- 2 选择立绘性别按钮
        if iStep == 1 then
            -- 恢复灰化
            self.btnSexLeft.interactable = true
            setUIGray(self.imgSexLeftButton,false)
            self.btnSexRight.interactable = true
            setUIGray(self.imgSexRightButton,false)
        elseif iStep == 2 then
            -- 对按钮灰化处理
            self.btnSexLeft.interactable = false
            setUIGray(self.imgSexLeftButton,true)
            self.btnSexRight.interactable = false
            setUIGray(self.imgSexRightButton,true)
        end
        -- end

        if iStep == 2 then
            self:ClickChangeModel(0)
        end
    elseif iStep == 3 then
        -- 大图界面
        local faceData = CreateFaceManager:GetInstance():CreateFaceData(self.roleId,self.modelId,self.sex,self.cgsex,self.faceDataList)
        CreateFaceManager:GetInstance():SetAllPartPicByData(self.objShareBigPic,faceData)
        self.objShareBigPic:SetActive(true)
		RemoveWindowImmediately("ServerAndUIDUI")
        self.objSpine:SetActive(false)
        self.objModelPart:SetActive(false)
        self.objSexPart:SetActive(false)
        local strZoneID = GetConfig("LoginZone")
        local strServerNameKey = string.format("LoginServerName_%s", tostring(strZoneID))
        local serverName = GetConfig(strServerNameKey)
        local playerid = globalDataPool:getData("PlayerID")
        self.txtShareBigPicPlayerInfo.text = tostring(serverName).. ':' .. tostring(playerid)
        self:SetNoticeLoop()
    end
    if iStep == 4 then
        self.objLeftArea[2]:SetActive(true)
        self.objShareButtons:SetActive(true)
        self.btnShareButtonsClose.gameObject:SetActive(true)
        if MSDKHelper:IsLoginQQ() then
            self.objShareButtonQQ1:SetActive(true)
            self.objShareButtonQQ2:SetActive(true)
            self.objShareButtonWX1:SetActive(false)
            self.objShareButtonWX2:SetActive(false)
        else
            self.objShareButtonQQ1:SetActive(false)
            self.objShareButtonQQ2:SetActive(false)
            self.objShareButtonWX1:SetActive(true)
            self.objShareButtonWX2:SetActive(true)
        end   
    else
        self.objShareButtons:SetActive(false)
        self.btnShareButtonsClose.gameObject:SetActive(false)
        
    end
    if iStep == 5 then
        -- 分享界面
        self.objRightArea[3]:SetActive(true)
        self.txtFinalJudge.text = self:CreateJudgeDescription()
        local serverName = GetConfig(string.format("LoginServerName_%s", tostring(GetConfig("LoginZone"))))
        local playerid = globalDataPool:getData("PlayerID")
        self.txtFinalJudgePlayerInfo.text = tostring(serverName).. ':' .. tostring(playerid)
        self.objModelPart:SetActive(false)
        self.objSexPart:SetActive(false)
        self.objLeftArea[2]:SetActive(false)
        for i=0,11 do
            local strLeftBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/LeftButton'
            local strRightBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/RightButton'
            local objCharacterPartLeft = self:FindChild(self._gameObject,strLeftBtnName)
            local objCharacterPartRight = self:FindChild(self._gameObject,strRightBtnName)
            if not NEEDSMALLADJUSTPARTLIST[i] then
                objCharacterPartLeft:SetActive(false)
                objCharacterPartRight:SetActive(false)
            end
        end
        self.imgSexLeftButton.gameObject:SetActive(false)
        self.imgSexRightButton.gameObject:SetActive(false)
    elseif iStep == 2 or iStep == 4 then
        -- 非分享界面 状态恢复
        self.objRightArea[3]:SetActive(false)
        self.objModelPart:SetActive(true)
        self.objSexPart:SetActive(true)
        for i=0,11 do
            local strLeftBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/LeftButton'
            local strRightBtnName = 'RightArea_Step1/'..CHARACTER_PART[i]..'/RightButton'
            local objCharacterPartLeft = self:FindChild(self._gameObject,strLeftBtnName)
            local objCharacterPartRight = self:FindChild(self._gameObject,strRightBtnName)
            if not NEEDSMALLADJUSTPARTLIST[i] then
                objCharacterPartLeft:SetActive(true)
                objCharacterPartRight:SetActive(true)
            end
        end
        self.imgSexLeftButton.gameObject:SetActive(true)
        self.imgSexRightButton.gameObject:SetActive(true)
    end
end

function CreateFaceUI:Share(plat)
    -- plat 1qq 2qq空间 3wx 4wx朋友圈
    self:SetNowStep(5)
    local isSpace = false
    if plat == 1 then
    elseif plat == 2 then
        isSpace = true
    elseif plat == 3 then
    elseif plat == 4 then
        isSpace = true
    end
    MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, 11, isSpace, function()
        self:SetNowStep(4)
    end)
end

function CreateFaceUI:CreateJudgeDescription()
    -- 产生评价 先循环遍历rolefacejudge表
    local maxMatchNum = 0
    local maxMatchIndex = 0
    for i=1,#self.TB_RoleFaceJudge do
        if dnull(self.TB_RoleFaceJudge[i].Description) then
            -- 8个参数分别对应 0 11 9 10 4 3 2 1
            local matchNum = 0
            local valueTable = {[0]=self.TB_RoleFaceJudge[i].Param1,
            [11]=self.TB_RoleFaceJudge[i].Param2,
            [9]=self.TB_RoleFaceJudge[i].Param3,
            [10]=self.TB_RoleFaceJudge[i].Param4,
            [4]=self.TB_RoleFaceJudge[i].Param5,
            [3]=self.TB_RoleFaceJudge[i].Param6,
            [2]=self.TB_RoleFaceJudge[i].Param7,
            [1]=self.TB_RoleFaceJudge[i].Param8,}
            local haveToMathch = 0
            for k,v in pairs(valueTable) do
                if v>0 then
                    haveToMathch = haveToMathch + 1
                end
                if self.faceDataList[k] == v then
                    matchNum = matchNum + 1
                end
            end
            if matchNum == haveToMathch and matchNum > maxMatchNum then
                maxMatchNum = matchNum
                maxMatchIndex = self.TB_RoleFaceJudge[i].BaseID
            end
        end
    end
    if maxMatchIndex > 0 then
        return TableDataManager:GetInstance():GetTableData("RoleFaceJudge",maxMatchIndex).Description
    end
    local randomMaxNum = #self.TB_RoleFaceJudgeDefault
    while(true) do
        local randomNum = math.random(1,randomMaxNum)
        local randomData = TableDataManager:GetInstance():GetTableData("RoleFaceJudgeDefault",randomNum)
        if randomData and randomData.Sex == self.cgsex and dnull(randomData.Description) then
            return randomData.Description
        end
    end

end

function CreateFaceUI:SetNoticeLoop()
    self.dotweenSequence = DRCSRef.DOTween.Sequence()
    self.txtShareBigPicNotice.color = DRCSRef.Color(1.0, 1.0, 1.0, 1.0)
    self.dotweenSequence:Append(self.txtShareBigPicNotice:DOColor(DRCSRef.Color(1.0, 1.0, 1.0, 0.0),3))
    self.dotweenSequence:Append(self.txtShareBigPicNotice:DOColor(DRCSRef.Color(1.0, 1.0, 1.0, 1.0),3):SetDelay(3))
    self.dotweenSequence:OnComplete(
        function()
            if self.objShareBigPic.gameObject.activeSelf then
                self:SetNoticeLoop()
                dprint("loop")
            end
        end
    )
    self.dotweenSequence:Play()
end

function CreateFaceUI:SetNoticeStop()
    self.dotweenSequence:Pause()
    self.txtShareBigPicNotice:DOKill()
end

function CreateFaceUI:ClickChangeModel(iPos)
    --iPos -1 左按钮 1 右按钮
    local nowIndex = self.modelIdIndex + iPos
    local allSexModels ={}
    if self.sex == SexType.ST_Male then
        allSexModels = CreateFaceManager:GetInstance():GetAllManModels()
    else
        allSexModels = CreateFaceManager:GetInstance():GetAllWomanModels()
    end
    if nowIndex < 1 then
        nowIndex = #allSexModels
    elseif nowIndex > #allSexModels then
        nowIndex = 1
    end
    self.modelIdIndex = nowIndex
    self.modelId = allSexModels[self.modelIdIndex]
    local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.modelId)
    DynamicChangeSpine(self.objSpine,roleModelData.Model)
    ChnageSpineSkin(self.objSpine,roleModelData.Texture)
    local roleFaceModelData = TableDataManager:GetInstance():GetTableData("RoleFaceModel", self.modelId)
    local roleModelScale = roleFaceModelData.SpineScale
    local comRect = self.objSpine:GetComponent("Transform")
    comRect.localScale = DRCSRef.Vec3(roleModelScale,roleModelScale,roleModelScale)
    self.txtModelName.text = roleFaceModelData.ModelName
    self.txtModelName.color = getRankColor(roleFaceModelData.ModelRank)

    -- 判断是否解锁
    -- Show->Open->InitUnlock->道具->银锭->成就
    -- Show在modellist里已经排除
    if roleFaceModelData.Open == TBoolean.BOOL_YES and CreateFaceManager:GetInstance():IsUnlockModel(self.modelId) then
        self.objModelLockImage:SetActive(false)
        self.objModelLockButton:SetActive(false)
        setUIGray(self.imgSaveData,false)
        self.isModelLock = false
    else
        self.objModelLockImage:SetActive(true)
        self.objModelLockButton:SetActive(true)
        setUIGray(self.imgSaveData,true)
        self.isModelLock = true
        if not dnull(roleFaceModelData.UnlockDescription) then
            self.txtModelLock.text = "[RoleFaceModel表缺少解锁描述]"
        else
            self.txtModelLock.text = roleFaceModelData.UnlockDescription
        end
        if self.btnModelLock then
            self:RemoveButtonClickListener(self.btnModelLock)

            self:AddButtonClickListener(self.btnModelLock, function()
                if roleFaceModelData.Open == TBoolean.BOOL_YES then
                    -- 判断解锁条件 如果是银锭就弹框
                    if roleFaceModelData.UnlockCostSilver > 0 then
                        local content = {
                            ['title'] = "提示",
                            ['text'] = "解锁模型【"..roleFaceModelData.ModelName.."】需消耗"..roleFaceModelData.UnlockCostSilver.."银锭\n是否要立即解锁？"
                        }
                        local callback = function()
                            PlayerSetDataManager:GetInstance():RequestSpendSilver(roleFaceModelData.UnlockCostSilver,function()
                                CreateFaceManager:GetInstance():UnlockModel(self.storyId,self.modelId)
                            end)
                        end
                        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
                    else
                        SystemUICall:GetInstance():Toast("解锁条件不满足")
                    end
                else
                    SystemUICall:GetInstance():Toast("暂未开放解锁")
                end
            end)

            
        end
    end   
end



-- 打开界面时传入storyId 和 roleId
function CreateFaceUI:RefreshUI(info)
    -- 打开不应该info为nil
    if info then
        self.storyId = info["iStoryId"]
        self.roleId = info["iRoleId"]
        if info["iBabyId"] then
            self.babyId = info["iBabyId"]
        else
            self.babyId = nil
        end
    else
        SystemUICall:GetInstance():Toast("storyId、roleId为空 无法打开捏脸界面")
        RemoveWindowImmediately("CreateFaceUI")
        return
    end
    self.detailPart:SetActive(false)
    self:InitData()
    self:RefreshFaceByData()
    self:SetNowStep(1)
end

function CreateFaceUI:OnDestroy()
    self:RemoveEventListener(CreateFaceManager.UI_EVENT.UnlockNewFacePart)
    self:RemoveEventListener(CreateFaceManager.UI_EVENT.UnlockNewModel)
end

return CreateFaceUI