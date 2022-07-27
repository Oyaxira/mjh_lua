AccountSettingUI = class("AccountSettingUI",BaseWindow)
local PoemShowCom = require "UI/PlayerSet/PoemShowUI"
local SpineRoleUI = require 'UI/Role/SpineRoleUI'

local blackColor = DRCSRef.Color(0x2B / 255, 0x2B / 255, 0x2B / 255, 1);
local whiteColor = DRCSRef.Color(0.9, 0.9, 0.9, 1);

local ChooseType = {
    Toggle_title = 1,
    Toggle_name = 2,
    Toggle_draw = 3,
    Toggle_spine = 4,
    Toggle_bg = 5,
    Toggle_music = 6,
    Toggle_poem = 7,
    Toggle_ground = 8,
    Toggle_login = 9,
    Toggle_pet = 10,
    Toggle_HeadBox = 11,
    Toggle_LandLady = 12,
}

-- TableDataManager:GetInstance():GetTable("SkillPerformance")

function AccountSettingUI:ctor(obj)
    self:SetGameObject(obj)
    self:OnCreate();
end

function AccountSettingUI:Init()
    self.chooseToggle = {}
    self.Player_ChangeName = ""

    self.Rect_Info_Box = self:FindChildComponent(self._gameObject,"Info_box","RectTransform")
    self.Rect_Choose_Box = self:FindChildComponent(self._gameObject,"Choose_box","RectTransform")
    self.Obj_PoemShow_Box = self:FindChild(self._gameObject,"Poem_show_box")
    self.PoemShowCom = PoemShowCom.new(self.Obj_PoemShow_Box)
    self.SpineRoleUI = SpineRoleUI.new()

    self.Text_Title = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_title/TMP","Text")
    self.Text_Name = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_name/TMP","Text")
    self.Text_Draw = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_draw/TMP","Text")
    self.Text_Spine = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_spine/TMP","Text")
    self.Text_Bg = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_bg/TMP","Text")
    self.Text_Music = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_music/TMP","Text")
    self.Text_Poem = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_poem/TMP","Text")
    self.Text_ground = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_ground/TMP","Text")
    self.Text_login = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_login/TMP","Text")
    self.Text_pet = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_pet/TMP","Text")
    self.Text_HeadBox = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_HeadBox/TMP","Text")
    self.Text_LandLady = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggle_LandLady/TMP","Text")

    self.chooseToggle.Toggle_Title = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_title","Toggle")
    self.chooseToggle.Toggle_Name = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_name","Toggle")
    self.chooseToggle.Toggle_Draw = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_draw","Toggle")
    self.chooseToggle.Toggle_Spine = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_spine","Toggle")
    self.chooseToggle.Toggle_Bg = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_bg","Toggle")
    self.chooseToggle.Toggle_Music = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_music","Toggle")
    self.chooseToggle.Toggle_Poem = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_poem","Toggle")
    self.chooseToggle.Toggle_ground = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_ground","Toggle")
    self.chooseToggle.Toggle_login = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_login","Toggle")
    self.chooseToggle.Toggle_pet = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_pet","Toggle")
    self.chooseToggle.Toggle_HeadBox = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_HeadBox","Toggle")
    self.chooseToggle.Toggle_LandLady = self:FindChildComponent(self.Rect_Info_Box.gameObject,"Toggles/Toggle_LandLady","Toggle")
    
    for _, value in pairs(self.chooseToggle) do
        local fun = function(bool)
            local comText = self:FindChildComponent(value.gameObject, 'Text_name', 'Text');
            local comName = self:FindChildComponent(value.gameObject, 'TMP', 'Text'); 
			if bool then
                self:ChooseShowContent(ChooseType[value.name])

                comText.color = whiteColor;
                comName.color = whiteColor;
            else
                comText.color = blackColor;
                comName.color = blackColor;
			end
		end
		self:AddToggleClickListener(value,fun,false)
    end

    self.Obj_Choose_Title = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_title")
    self.Obj_Choose_Name = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_name")
    -- self.Obj_Choose_Draw = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_draw")
    -- self.Obj_Choose_Spine = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_spine")
    -- self.Obj_Choose_Bg = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_bg")
    self.Obj_Choose_Music = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_music")
    self.Obj_Choose_Poem = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_poem")
    self.Obj_Choose_Ground = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_ground")
    self.Obj_Choose_Login = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_login")
    self.Obj_Choose_Pet = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_pet")
    self.Obj_Choose_HeadBox = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_HeadBox")
    self.Obj_Choose_LandLady = self:FindChild(self.Rect_Choose_Box.gameObject,"Choose_LandLady")

    --============================================================================================
    --Choose_title
    self.Obj_Tips_NoTitle = self:FindChild(self.Obj_Choose_Title,"Tips_NoTitle")
    self.SC_Title = self:FindChildComponent(self.Obj_Choose_Title,"SC_title","LoopVerticalScrollRect")
    if IsValidObj(self.SC_Title) then
        local fun_Title = function(transform, idx)
            self:OnTitleScrollChange(transform, idx)
        end
        self.SC_Title:RefreshCells()
        self.SC_Title:RefreshNearestCells()
        self.SC_Title:AddListener(fun_Title)
    end

    self.SC_Attribute = self:FindChildComponent(self.Obj_Choose_Title,"SC_attribute","LoopVerticalScrollRect")
    if IsValidObj(self.SC_Attribute) then
        local fun_TitleAttribute = function(transform, idx)
            self:OnTitleAttributeScrollChange(transform, idx)
        end
        self.SC_Attribute:AddListener(fun_TitleAttribute)
    end
    --============================================================================================

    --============================================================================================
    --Choose_Name
    self.Txt_CurPlayerName = self:FindChildComponent(self.Obj_Choose_Name,"Name/Text","Text")
    self.InputField_NewPlayerName = self:FindChildComponent(self.Obj_Choose_Name,"InputField","InputField")
    if IsValidObj(self.InputField_NewPlayerName) then
		local fun = function(str)
			self.Player_ChangeName = str
		end
		self.InputField_NewPlayerName.onEndEdit:AddListener(fun)
    end
    
    self.Btn_ChangeName = self:FindChildComponent(self.Obj_Choose_Name,"Button_change","Button")
    if IsValidObj(self.Btn_ChangeName) then
		local fun = function()
			self:OnClick_ChangeNameButton()
		end
		self:AddButtonClickListener(self.Btn_ChangeName,fun)
    end
    self.Obj_FirstChangeName = self:FindChild(self.Obj_Choose_Name.gameObject,"Text_first")
    self.Obj_CostChangeName = self:FindChild(self.Obj_Choose_Name.gameObject,"CostBuy")
    --============================================================================================

    --============================================================================================
    --Choose_bg
    -- self.SC_Bg = self:FindChildComponent(self.Obj_Choose_Bg,"SC_bg","LoopVerticalScrollRect")
    -- if IsValidObj(self.SC_Bg) then
    --     local fun_Bg = function(transform, idx)
    --         self:OnBgScrollChange(transform, idx)
    --     end
    --     self.SC_Bg:AddListener(fun_Bg)
    -- end
    --============================================================================================
    
    --============================================================================================
    --Choose_music
    self.SC_music = self:FindChildComponent(self.Obj_Choose_Music,"SC_music","LoopVerticalScrollRect")
    if IsValidObj(self.SC_music) then
        local fun_Music = function(transform, idx)
            self:OnMusicScrollChange(transform, idx)
        end
        self.SC_music:AddListener(fun_Music)
    end
    --============================================================================================
    
    --============================================================================================
    --Choose_poem
    self.SC_poem = self:FindChildComponent(self.Obj_Choose_Poem,"SC_poem","LoopVerticalScrollRect")
    if IsValidObj(self.SC_poem) then
        local fun_Poem = function(transform, idx)
            self:OnPoemScrollChange(transform, idx)
        end
        self.SC_poem:AddListener(fun_Poem)
    end
    --============================================================================================
    
    --============================================================================================
    --Choose_Ground
    self.SC_ground = self:FindChildComponent(self.Obj_Choose_Ground,"SC_ground","LoopVerticalScrollRect")
    if IsValidObj(self.SC_ground) then
        local fun_Ground = function(transform, idx)
            self:OnGroundScrollChange(transform, idx)
        end
        self.SC_ground:AddListener(fun_Ground)
    end
    --============================================================================================

    --============================================================================================
    --Choose_Login
    self.SC_login = self:FindChildComponent(self.Obj_Choose_Login,"SC_login","LoopVerticalScrollRect")
    if IsValidObj(self.SC_login) then
        local fun_Login = function(transform, idx)
            self:OnLoginScrollChange(transform, idx)
        end
        self.SC_login:AddListener(fun_Login)
    end
    --============================================================================================

    --============================================================================================
    --Choose_pet
    self.SC_pet = self:FindChildComponent(self.Obj_Choose_Pet,"SC_pet","LoopVerticalScrollRect")
    if IsValidObj(self.SC_pet) then
        local fun_Login = function(transform, idx)
            self:OnPetScrollChange(transform, idx)
        end
        self.SC_pet:AddListener(fun_Login)
    end
    --============================================================================================
    
    --============================================================================================
    --Choose_LandLady
    self.SC_LandLady = self:FindChildComponent(self.Obj_Choose_LandLady,"SC_LandLady","LoopVerticalScrollRect")
    if IsValidObj(self.SC_LandLady) then
        local fun_LandLady = function(transform, idx)
            self:OnLandLadyScrollChange(transform, idx)
        end
        self.SC_LandLady:AddListener(fun_LandLady)
    end
    --============================================================================================
    --
    self.Button_Close = self:FindChildComponent(self._gameObject,"Button_close","Button")
    if IsValidObj(self.Button_Close) then
        local fun = function()
			self:OnClick_Close_Button()
		end
		self:AddButtonClickListener(self.Button_Close,fun)
    end
end

function AccountSettingUI:OnClick_Close_Button()
    self.clickTryBGM = false;
    local tbl_PlayerINfoBGM = TB_PlayerInfoData[PlayerInfoType.PIT_BGM][self.appearanceInfo.bgmID]
    if tbl_PlayerINfoBGM and tbl_PlayerINfoBGM.NameID then
        PlayMusic(tbl_PlayerINfoBGM.ResourceID);
    end 
    --local OnCompelte = function()
    self:SetActive(false);
    --end
    -- 动画我给关掉了，上面隐藏窗口的命令是在动画完成后才执行，所以也一并注释掉了————王伦
    -- self._tween.Left_View_end = Twn_MoveX(self._tween.Left_View_end,self.Rect_Info_Box.transform,-560,0.2,nil)
    -- self._tween.Right_View_end = Twn_MoveX(self._tween.Right_View_end,self.Rect_Choose_Box.transform,750,0.2,nil,OnCompelte)
   
end

function AccountSettingUI:RefreshUI()
    -- 动画我给关掉了————王伦
    -- self.Rect_Info_Box.anchoredPosition = DRCSRef.Vec2(-910,self.Rect_Info_Box.anchoredPosition.y)
    -- self.Rect_Choose_Box.anchoredPosition = DRCSRef.Vec2(1010,self.Rect_Choose_Box.anchoredPosition.y)
    -- self._tween.Left_View = Twn_MoveX(self._tween.Left_View,self.Rect_Info_Box.transform,560,0.2,nil)
    -- self._tween.Right_View = Twn_MoveX(self._tween.Right_View,self.Rect_Choose_Box.transform,-750,0.2,nil)

    self.appearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo()
    self:ShowInfoBox()
    self:ShowChooseBox()

    self:SetActive(true);
end

function AccountSettingUI:ShowInfoBox()
   
    if self.appearanceInfo then

        self.Text_Name.text = self.appearanceInfo.playerName;
        self.InputField_NewPlayerName.text = '请输入姓名';

        local tbl_RoleTitle = TableDataManager:GetInstance():GetTableData("RoleTitle",self.appearanceInfo.titleID)
        if tbl_RoleTitle and tbl_RoleTitle.TitleID then
            self.Text_Title.text = GetLanguageByID(tbl_RoleTitle.TitleID)
        else
            self.Text_Title.text = "未选择"
        end

        local tbl_PlayerINfoBGM = TB_PlayerInfoData[PlayerInfoType.PIT_BGM][self.appearanceInfo.bgmID]
        if tbl_PlayerINfoBGM and tbl_PlayerINfoBGM.NameID then
            self.Text_Music.text = GetLanguageByID(tbl_PlayerINfoBGM.NameID)
        else
            self.Text_Music.text = "未选择"
        end 

        local tbl_PlayerINfoPotry = TB_PlayerInfoData[PlayerInfoType.PIT_POERTY][self.appearanceInfo.poetryID]
        if tbl_PlayerINfoPotry and tbl_PlayerINfoPotry.NameID then
            self.Text_Poem.text = GetLanguageByID(tbl_PlayerINfoPotry.NameID)
        else
            self.Text_Poem.text = "未选择"
        end 
        
        local tbl_PlayerINfoGround = TB_PlayerInfoData[PlayerInfoType.PIT_PEDESTAL][self.appearanceInfo.pedestalID]
        if tbl_PlayerINfoGround and tbl_PlayerINfoGround.NameID then
            self.Text_ground.text = GetLanguageByID(tbl_PlayerINfoGround.NameID)
        else
            self.Text_ground.text = "未选择"
        end 
        
        local tbl_PlayerINfoLogin = TB_PlayerInfoData[PlayerInfoType.PIT_LOGINWORD][self.appearanceInfo.loginWordID]
        if tbl_PlayerINfoLogin and tbl_PlayerINfoLogin.NameID then
            local unlockPool = globalDataPool:getData("UnlockPool");
            if unlockPool and unlockPool[PlayerInfoType.PIT_LOGINWORD] then
                local subTime = unlockPool[PlayerInfoType.PIT_LOGINWORD][tbl_PlayerINfoLogin.BaseID].dwParam - os.time();
                if subTime > 0 then
                    self.Text_login.text = GetLanguageByID(tbl_PlayerINfoLogin.NameID)
                else
                    self.Text_login.text = "未选择"
                end
            end
        else
            self.Text_login.text = "未选择"
        end 

        local tbl_Pet = TableDataManager:GetInstance():GetTableData("Pet",self.appearanceInfo.showPetID)
        if tbl_Pet and tbl_Pet.NameID then
            self.Text_pet.text = GetLanguageByID(tbl_Pet.NameID)
        else
            self.Text_pet.text = "未选择"
        end 

        local tbl_PlayerINfoHeadBox = TB_PlayerInfoData[PlayerInfoType.PIT_HEADBOX][self.appearanceInfo.HeadBoxID]
        if tbl_PlayerINfoHeadBox and tbl_PlayerINfoHeadBox.NameID then
            self.Text_HeadBox.text = GetLanguageByID(tbl_PlayerINfoHeadBox.NameID)
        else
            self.Text_HeadBox.text = "未选择"
        end 
        local tbl_PlayerINfoLandLady = TB_PlayerInfoData[PlayerInfoType.PIT_LANDLADY][ActivityHelper:GetInstance():GetCurActiveLandLady()]
        if tbl_PlayerINfoLandLady and tbl_PlayerINfoLandLady.NameID then
            self.Text_LandLady.text = GetLanguageByID(tbl_PlayerINfoLandLady.NameID)
        else
            self.Text_LandLady.text = "未选择"
        end 
    end
end

function AccountSettingUI:ShowChooseBox()
    local Toggle_title = nil;
    for _, value in pairs(self.chooseToggle) do
        if value.name == "Toggle_title" then
            Toggle_title = value;
        end
        value.isOn = false;
    end

    if Toggle_title then
        Toggle_title.isOn = true;
    end
end

function AccountSettingUI:ChooseShowContent(type, bRefresh)
    if not type then
        derror("外观选择错误")
        return
    end

    self.CurChooseType = type

    if type == ChooseType.Toggle_title then
        self:ShowTitleContent(bRefresh)
        self.Obj_Choose_Title:SetActive(true)
    else
        self.Obj_Choose_Title:SetActive(false)
    end
    
    if type == ChooseType.Toggle_name then
        self:ShowNameContent()
        self.Obj_Choose_Name:SetActive(true)
    else
        self.Obj_Choose_Name:SetActive(false)
    end
    
    -- if type == ChooseType.Toggle_bg then
    --     self:ShowBgContent()
    --     self.Obj_Choose_Bg:SetActive(true)
    -- else
    --     self.Obj_Choose_Bg:SetActive(false)
    -- end
   
    if type == ChooseType.Toggle_music then
        self:ShowMusicContent(bRefresh)
        self.Obj_Choose_Music:SetActive(true)
    else
        self.Obj_Choose_Music:SetActive(false)
    end
    
    if type == ChooseType.Toggle_poem then
        self:ShowPoemContent(bRefresh)
        self.Obj_Choose_Poem:SetActive(true)
    else
        self.Obj_Choose_Poem:SetActive(false)
    end
    
    if type == ChooseType.Toggle_ground then
        self:ShowGroundContent(bRefresh)
        self.Obj_Choose_Ground:SetActive(true)
    else
        self.Obj_Choose_Ground:SetActive(false)
    end

    if type == ChooseType.Toggle_login then
        self:ShowLoginContent(bRefresh)
        self.Obj_Choose_Login:SetActive(true)
    else
        self.Obj_Choose_Login:SetActive(false)
    end

    if type == ChooseType.Toggle_pet then
        self:ShowPetContent(bRefresh)
        self.Obj_Choose_Pet:SetActive(true)
    else
        self.Obj_Choose_Pet:SetActive(false)
    end

    if type == ChooseType.Toggle_HeadBox then
        self:ShowHeadBoxContent(bRefresh)
        self.Obj_Choose_HeadBox:SetActive(true)
    else
        self.Obj_Choose_HeadBox:SetActive(false)
    end

    if type == ChooseType.Toggle_LandLady then
        self:ShowLandLadyContent(bRefresh)
        self.Obj_Choose_LandLady:SetActive(true)
    else
        self.Obj_Choose_LandLady:SetActive(false)
    end

    if type ~= ChooseType.Toggle_music then
        if self.clickTryBGM then
            local tbl_PlayerINfoBGM = TB_PlayerInfoData[PlayerInfoType.PIT_BGM][self.appearanceInfo.bgmID]
            if tbl_PlayerINfoBGM and tbl_PlayerINfoBGM.NameID then
                PlayMusic(tbl_PlayerINfoBGM.ResourceID);
            end
        end
    end
end

--=====================================================================
function AccountSettingUI:ShowTitleContent(bRefresh)
    if not IsValidObj(self.SC_Title) then
        return
    end

    local UnlockPool = globalDataPool:getData("UnlockPool")
    if UnlockPool and UnlockPool[PlayerInfoType.PIT_TITLE] then

        local auiTitles = {};
        for k, v in pairs(UnlockPool[PlayerInfoType.PIT_TITLE]) do
            if (v.dwTypeID >> 24) & 0xff == 0 then
                local cloneV = clone(v)
                cloneV.dwTypeID = v.dwTypeID & 0xffffff
                table.insert(auiTitles, cloneV);
            end
        end

        self.unlockTitles = {}
        self.UnlockTitleAttributes = {}
        local temp = {}
        local tbl_titleAttr
        for _,value in pairs(auiTitles) do
            table.insert(self.unlockTitles,value)

            tbl_titleAttr = TableDataManager:GetInstance():GetTableData("RoleTitle",value['dwTypeID'])
            if tbl_titleAttr then
                if not temp[tbl_titleAttr.TitleAttr] then
                    temp[tbl_titleAttr.TitleAttr] = 0
                end
                temp[tbl_titleAttr.TitleAttr] = temp[tbl_titleAttr.TitleAttr] + tbl_titleAttr.Value
            end
        end

        for key,value in pairs(temp) do
            table.insert(self.UnlockTitleAttributes,{["titleAttr"] = key,["value"] = value})
        end

        --titles
        if bRefresh then
            self.SC_Title:RefreshCells()
        else
            self.SC_Title:ClearCells()
            self.SC_Title.totalCount = #self.unlockTitles
            self.SC_Title:RefillCells()
        end

        --attribute
        if bRefresh then
            self.SC_Attribute:RefreshCells()
        else
            self.SC_Attribute:ClearCells()
            self.SC_Attribute.totalCount = #self.UnlockTitleAttributes
            self.SC_Attribute:RefillCells()
        end

        self.Obj_Tips_NoTitle:SetActive(false)
    else
        self.Obj_Tips_NoTitle:SetActive(true)
    end
end

function AccountSettingUI:OnTitleScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    local button = item:GetComponent("Button")
    local content = self:FindChildComponent(item.gameObject,"TMP","Text")
    local data = self.unlockTitles[idx + 1]["dwTypeID"]
    if data then
        local tbl_RoleTitle = TableDataManager:GetInstance():GetTableData("RoleTitle",data)
        if tbl_RoleTitle and tbl_RoleTitle.TitleID then
            local str = GetLanguageByID(tbl_RoleTitle.TitleID)
            content.text = str
            content.color = getRankColor(tbl_RoleTitle.TitleRank)
        end

        if data == self.appearanceInfo.titleID then
            self:FindChild(item.gameObject, 'Image_chosen'):SetActive(true);
        else
            self:FindChild(item.gameObject, 'Image_chosen'):SetActive(false);
        end

        local fun = function()
            if data == self.appearanceInfo.titleID then
                return
            end
            SendModifyPlayerAppearance(SMPAT_TITLE,tostring(data))
        end
        self:RemoveButtonClickListener(button)
        self:AddButtonClickListener(button,fun)
    end
end

function AccountSettingUI:OnTitleAttributeScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    local Text_1 = self:FindChildComponent(item.gameObject,"Text_1","Text")
    local Text_2 = self:FindChildComponent(item.gameObject,"Text_2","Text")
    local data = self.UnlockTitleAttributes[idx + 1]
    if data and data.titleAttr and data.value then
        Text_1.text = GetLanguageByEnum(data.titleAttr)
        Text_2.text = "+"..data.value
    end
end
--=====================================================================

--=====================================================================
function AccountSettingUI:ShowNameContent()
    self.Txt_CurPlayerName.text = PlayerSetDataManager:GetInstance():GetPlayerName() or ""
    self.reNameNum = PlayerSetDataManager:GetInstance():GetReNameNum() or 1
    self.Obj_FirstChangeName:SetActive(self.reNameNum == 0)
    self.Obj_CostChangeName:SetActive(self.reNameNum ~= 0)
end

function AccountSettingUI:OnClick_ChangeNameButton()
    local setMgr = PlayerSetDataManager:GetInstance()
    local changeNameSpend = 1000  -- 改名一次消费1000银锭
    local roleHasSliver = setMgr:GetPlayerGold()
    if self.reNameNum == 0 then
        SendModifyPlayerAppearance(SMPAT_NAME,self.Player_ChangeName)
    else
        setMgr:RequestSpendSilver(changeNameSpend, function()
            SendModifyPlayerAppearance(SMPAT_NAME,self.Player_ChangeName)
        end)
    end
end
--=====================================================================

--=====================================================================
function AccountSettingUI:ShowBgContent()
    if not IsValidObj(self.SC_Bg) then
        return
    end

    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = (unlockPool and unlockPool[PlayerInfoType.PIT_CG]) and unlockPool[PlayerInfoType.PIT_CG] or {}
    local IsUnlock = function(bgTypeData)
        local uiTypeID = bgTypeData.BaseID
        if self.unlockBGCheck[uiTypeID] ~= nil then
            return self.unlockBGCheck[uiTypeID]
        end
        local bUnlock = (bgTypeData.StartUnlock == TBoolean.BOOL_YES) or (checkUnlock[uiTypeID] ~= nil)
        self.unlockBGCheck[uiTypeID] = bUnlock
        return bUnlock
    end
    if not self.sortBGData then
        -- 为了防止数据表里面id不连续导致遍历或排序错误, 这里转一遍数组
        self.sortBGData = {}
        for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_CG]) do
            self.sortBGData[#self.sortBGData + 1] = data
        end
    end
    -- 排序会更新与引用加解锁查询表, 所以排序前先清空一次
    self.unlockBGCheck = {}
    local uiWeightA, uiWeightB = 0, 0
    table.sort(self.sortBGData, function(a, b)
        uiWeightA = (IsUnlock(a) and 10000 or 1) * a.BaseID
        uiWeightB = (IsUnlock(b) and 10000 or 1) * b.BaseID
        return uiWeightA > uiWeightB
    end)

    -- TODO
    self.unlockBG = {}
    for i = 1, #(self.sortBGData) do
        if self.unlockBGCheck[self.sortBGData[i].BaseID] then
            table.insert(self.unlockBG, self.sortBGData[i]);
        end
    end

    -- 默认展示所有音乐, 未解锁的展示未锁定态
    self.SC_Bg:ClearCells()
    self.SC_Bg.totalCount = #self.unlockBG
    self.SC_Bg:RefillCells()
end

function AccountSettingUI:OnBgScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    local button = item:GetComponent("Button")
    local Image_bg = self:FindChildComponent(item.gameObject,"Image_bg","Image")
    local Text_name = self:FindChildComponent(item.gameObject,"Text_name","Text")
    local Mark = self:FindChild(item.gameObject,"Mark")
    local Lock = self:FindChild(item.gameObject,"Lock")

    Lock:SetActive(false)
    Mark:SetActive(false)

    local data = self.unlockBG[idx + 1][1]
    if data then
        Mark:SetActive(data == self.appearanceInfo.backGroundID)
        local tbl_PlayerInfoCG = TB_PlayerInfoData[PlayerInfoType.PIT_CG][data]
        if tbl_PlayerInfoCG and tbl_PlayerInfoCG.ResourceID then
            local tbl_ResourceCG = TableDataManager:GetInstance():GetTableData("ResourceCG",tbl_PlayerInfoCG.ResourceID)
            if tbl_ResourceCG and tbl_ResourceCG.CGPath then
                Image_bg.sprite = GetSprite(tbl_ResourceCG.CGPath)
            end
            Text_name.text = GetLanguageByID(tbl_PlayerInfoCG.NameID)
        end

        local fun = function()
            if data == self.appearanceInfo.backGroundID then
                return
            end
            SendModifyPlayerAppearance(SMPAT_BACKGROUND,tostring(data))
        end
        self:RemoveButtonClickListener(button)
        self:AddButtonClickListener(button,fun)
    end
end
--=====================================================================

--=====================================================================
function AccountSettingUI:ShowMusicContent(bRefresh)
    if not IsValidObj(self.SC_music) then
        return
    end

    -- 将音乐数据排个序, 已解锁的显示在最前面, 二级按id排
    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = (unlockPool and unlockPool[PlayerInfoType.PIT_BGM]) and unlockPool[PlayerInfoType.PIT_BGM] or {}
    local IsUnlock = function(musicTypeData)
        local uiTypeID = musicTypeData.BaseID
        if self.unlockMusicCheck[uiTypeID] ~= nil then
            return self.unlockMusicCheck[uiTypeID]
        end
        local bUnlock = (musicTypeData.StartUnlock == TBoolean.BOOL_YES) or (checkUnlock[musicTypeData.BaseID] ~= nil)
        self.unlockMusicCheck[uiTypeID] = bUnlock
        return bUnlock
    end
    if not self.sortMusicData then
        -- 为了防止数据表里面id不连续导致遍历或排序错误, 这里转一遍数组
        self.sortMusicData = {}
        for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_BGM]) do
            self.sortMusicData[#self.sortMusicData + 1] = data
        end
    end
    -- 排序会更新与引用加解锁查询表, 所以排序前先清空一次
    self.unlockMusicCheck = {}
    local uiWeightA, uiWeightB = 0, 0
    table.sort(self.sortMusicData, function(a, b)
        uiWeightA = (IsUnlock(a) and 10000 or 1) * a.BaseID
        uiWeightB = (IsUnlock(b) and 10000 or 1) * b.BaseID
        return uiWeightA > uiWeightB
    end)

    -- TODO
    self.unlockMusic = {}
    for i = 1, #(self.sortMusicData) do
        if self.unlockMusicCheck[self.sortMusicData[i].BaseID] then
            table.insert(self.unlockMusic, self.sortMusicData[i]);
        end
    end

    -- 默认展示所有音乐, 未解锁的展示未锁定态
    if bRefresh then
        self.SC_music:RefreshCells()
    else
        self.SC_music:ClearCells()
        self.SC_music.totalCount = #self.unlockMusic
        self.SC_music:RefillCells()
    end
end

function AccountSettingUI:OnMusicScrollChange(item,idx)
    if not (self.unlockMusic and self.unlockMusic and IsValidObj(item)) then
        return
    end

    --
    if idx % 2 == 0 then
        self:FindChild(item.gameObject,"bg_1"):SetActive(true);
    elseif idx % 2 == 1 then
        self:FindChild(item.gameObject,"bg_1"):SetActive(false);
    end

    local Button_musicName = self:FindChildComponent(item.gameObject,"MusicName","Button")
    local Text_musicName = self:FindChildComponent(item.gameObject,"Text_music_name","Text")
    local Button_musicTry = self:FindChildComponent(item.gameObject,"Try","Button")
    local Button_musicTry_chosen = self:FindChildComponent(item.gameObject,"Try_chosen","Button")

    --# TODO 钱程 设计问题, 旧版本是没解锁的音乐不列出, 这里先不管解锁, 全列出来
    local musicTypeData = self.unlockMusic[idx + 1]
    local musicTypeID = musicTypeData.BaseID
    if musicTypeID then
        if musicTypeData and musicTypeData.NameID then
            Text_musicName.text = GetLanguageByID(musicTypeData.NameID)
        end

        --
        if self.appearanceInfo.bgmID == musicTypeID then
            self:PickItemMusic(self.SC_music.gameObject, item);
        end
        
        local fun_Choose = function()
            self:PickItemMusic(self.SC_music.gameObject, item);

            if musicTypeID == self.appearanceInfo.bgmID then
                return
            end
            SendModifyPlayerAppearance(SMPAT_BGM,tostring(musicTypeID))
        end
        self:RemoveButtonClickListener(Button_musicName)
        self:AddButtonClickListener(Button_musicName,fun_Choose)

        local fun_Try = function()
            self.clickTryBGM = true;
            PlayMusic(musicTypeData.ResourceID);
        end
        self:RemoveButtonClickListener(Button_musicTry)
        self:AddButtonClickListener(Button_musicTry,fun_Try)

        self:RemoveButtonClickListener(Button_musicTry_chosen)
        self:AddButtonClickListener(Button_musicTry_chosen,fun_Try)
    end
end
--=====================================================================

--=====================================================================
function AccountSettingUI:ShowPoemContent(bRefresh)
    if not IsValidObj(self.SC_poem) then
        return
    end
    -- 将诗词数据排个序, 已解锁的显示在最前面, 二级按id排
    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = (unlockPool and unlockPool[PlayerInfoType.PIT_POERTY]) and unlockPool[PlayerInfoType.PIT_POERTY] or {}
    local IsUnlock = function(poemTypeData)
        local uiTypeID = poemTypeData.BaseID
        if self.unlockPoemCheck[uiTypeID] ~= nil then
            return self.unlockPoemCheck[uiTypeID]
        end
        local bUnlock = (poemTypeData.StartUnlock == TBoolean.BOOL_YES) or (checkUnlock[poemTypeData.BaseID] ~= nil)
        self.unlockPoemCheck[uiTypeID] = bUnlock
        return bUnlock
    end
    if not self.sortPoemData then
        -- 为了防止数据表里面id不连续导致遍历或排序错误, 这里转一遍数组
        self.sortPoemData = {}
        for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_POERTY]) do
            self.sortPoemData[#self.sortPoemData + 1] = data
        end
    end
    -- 排序会更新与引用加解锁查询表, 所以排序前先清空一次
    self.unlockPoemCheck = {}
    local uiWeightA, uiWeightB = 0, 0
    table.sort(self.sortPoemData, function(a, b)
        uiWeightA = (IsUnlock(a) and 10000 or 1) * a.BaseID
        uiWeightB = (IsUnlock(b) and 10000 or 1) * b.BaseID
        return uiWeightA > uiWeightB
    end)

    -- TODO
    self.unlockPoetry = {}
    for i = 1, #(self.sortPoemData) do
        if self.unlockPoemCheck[self.sortPoemData[i].BaseID] then
            table.insert(self.unlockPoetry, self.sortPoemData[i]);
        end
    end

    -- 默认展示所有诗词, 未解锁的展示未锁定态
    if bRefresh then
        self.SC_poem:RefreshCells()
    else
        self.SC_poem:ClearCells()
        self.SC_poem.totalCount = #self.unlockPoetry
        self.SC_poem:RefillCells()
    end
end

function AccountSettingUI:OnPoemScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    --
    if idx % 2 == 0 then
        self:FindChild(item.gameObject,"bg_1"):SetActive(true);
    elseif idx % 2 == 1 then
        self:FindChild(item.gameObject,"bg_1"):SetActive(false);
    end

    local Button_poemName = self:FindChildComponent(item.gameObject,"PoemName","Button")
    local Text_poemName = self:FindChildComponent(item.gameObject,"Text_poem_name","Text")
    local Text_poetName = self:FindChildComponent(item.gameObject,"Text_poet_name","Text")
    local Button_poemWatch = self:FindChildComponent(item.gameObject,"Watch","Button")

    --# TODO 钱程 设计问题, 旧版本是没解锁的诗词不列出, 这里先不管解锁, 全列出来
    local poemTypeData = self.unlockPoetry[idx + 1]
    local poemTypeID = poemTypeData.BaseID
    if poemTypeID then
        if poemTypeData and poemTypeData.NameID and poemTypeData.WriterNameID then
            Text_poemName.text = GetLanguageByID(poemTypeData.NameID)
            Text_poetName.text = GetLanguageByID(poemTypeData.WriterNameID)
        end

        --
        if self.appearanceInfo.poetryID == poemTypeID then
            self:PickItemPoetry(self.SC_poem.gameObject, item);
        end

        local fun_Choose = function()
            self:PickItemPoetry(self.SC_poem.gameObject, item);

            if poemTypeID == self.appearanceInfo.poetryID then
                return
            end
            SendModifyPlayerAppearance(SMPAT_POETRY,tostring(poemTypeID))
        end
        self:RemoveButtonClickListener(Button_poemName)
        self:AddButtonClickListener(Button_poemName,fun_Choose)

        local fun_Watch = function()
            self.PoemShowCom:RefreshUI({TB = poemTypeData})
        end
        self:RemoveButtonClickListener(Button_poemWatch)
        self:AddButtonClickListener(Button_poemWatch,fun_Watch)
    end
end
--=====================================================================

--=====================================================================
function AccountSettingUI:ShowGroundContent(bRefresh)
    if not IsValidObj(self.SC_ground) then
        return
    end

    -- 将诗词数据排个序, 已解锁的显示在最前面, 二级按id排
    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = (unlockPool and unlockPool[PlayerInfoType.PIT_PEDESTAL]) and unlockPool[PlayerInfoType.PIT_PEDESTAL] or {}
    local IsUnlock = function(groundTypeData)
        local uiTypeID = groundTypeData.BaseID
        if self.unlockGroundCheck[uiTypeID] ~= nil then
            return self.unlockGroundCheck[uiTypeID]
        end
        local bUnlock = (groundTypeData.StartUnlock == TBoolean.BOOL_YES) or (checkUnlock[groundTypeData.BaseID] ~= nil)
        self.unlockGroundCheck[uiTypeID] = bUnlock
        return bUnlock
    end
    if not self.sortGroundData then
        -- 为了防止数据表里面id不连续导致遍历或排序错误, 这里转一遍数组
        self.sortGroundData = {}
        for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_PEDESTAL]) do
            self.sortGroundData[#self.sortGroundData + 1] = data
        end
    end
    -- 排序会更新与引用加解锁查询表, 所以排序前先清空一次
    self.unlockGroundCheck = {}
    local uiWeightA, uiWeightB = 0, 0
    table.sort(self.sortGroundData, function(a, b)
        uiWeightA = (IsUnlock(a) and 10000 or 1) * a.BaseID
        uiWeightB = (IsUnlock(b) and 10000 or 1) * b.BaseID
        return uiWeightA > uiWeightB
    end)

    -- TODO
    self.unlockGround = {}
    for i = 1, #(self.sortGroundData) do
        if self.unlockGroundCheck[self.sortGroundData[i].BaseID] then
            table.insert(self.unlockGround, self.sortGroundData[i]);
        end
    end
    table.sort(self.unlockGround, function(a, b)
        return a.PicType < b.PicType;
    end)

    -- 默认展示所有诗词, 未解锁的展示未锁定态
    if bRefresh then
        self.SC_ground:RefreshCells()
    else
        self.SC_ground:ClearCells()
        self.SC_ground.totalCount = #self.unlockGround
        self.SC_ground:RefillCells()
    end
end

function AccountSettingUI:OnGroundScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    local groundTypeData = self.unlockGround[idx + 1];
    if groundTypeData then
        local image = self:FindChildComponent(item.gameObject, 'Image_bg', 'Image');
        local name = self:FindChildComponent(item.gameObject, 'Text_name', 'Text');
        local mark = self:FindChild(item.gameObject, 'Mark');
        local button_ground = item.gameObject:GetComponent('Button');
        image.sprite = GetSprite(groundTypeData.PicPath);
        name.text = GetLanguageByID(groundTypeData.NameID);

        if groundTypeData.BaseID == self.appearanceInfo.pedestalID then
            mark:SetActive(true);
        else
            mark:SetActive(false);
        end

        local fun_Choose = function()
            if groundTypeData.BaseID == self.appearanceInfo.pedestalID then
                return;
            end
            SendModifyPlayerAppearance(SMPAT_PEDESTAL,tostring(groundTypeData.BaseID))
        end
        self:RemoveButtonClickListener(button_ground)
        self:AddButtonClickListener(button_ground,fun_Choose)
    end
end
--=====================================================================

--=====================================================================
function AccountSettingUI:ShowPetContent(bRefresh)
    if not IsValidObj(self.SC_login) then
        return
    end

    self.unlockPetData = {};
    local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
    local allPetCardList = CardsUpgradeDataManager:GetInstance():GetEntirePetCardList();
    for k, v in pairs(allPetCardList) do
        if v.unlock then
            local cloneV = clone(v);
            cloneV.tbData = TB_Pet[k];
            table.insert(self.unlockPetData, cloneV);
        end
    end

    table.sort(self.unlockPetData, function(a, b)
        return a.tbData.BaseID < b.tbData.BaseID;
    end)

    --
    table.insert(self.unlockPetData, 1, {});

    --
    if bRefresh then
        self.SC_pet:RefreshCells()
    else
        self.SC_pet:ClearCells()
        self.SC_pet.totalCount = #(self.unlockPetData);
        self.SC_pet:RefillCells()
    end
end

function AccountSettingUI:OnPetScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    local petData = self.unlockPetData[idx + 1];
    if petData then
        local imageBg = self:FindChildComponent(item.gameObject, 'Image_bg', 'Image');
        local imagePet = self:FindChildComponent(item.gameObject, 'Image_pet', 'Image');
        local name = self:FindChildComponent(item.gameObject, 'Text_name', 'Text');
        local mark = self:FindChild(item.gameObject, 'Mark');
        local button_pet = item.gameObject:GetComponent('Button');

        if next(petData) then
            imageBg.gameObject:SetActive(false);
            imagePet.gameObject:SetActive(true);

            local modelData = TableDataManager:GetInstance():GetTableData("RoleModel", petData.tbData.ArtID);
            if modelData then
                imagePet.sprite = GetSpriteInResources(modelData.Texture);
            end
            name.text = GetLanguageByID(petData.tbData.NameID);
    
            if petData.tbData and petData.tbData.BaseID == self.appearanceInfo.showPetID then
                mark:SetActive(true);
            else
                mark:SetActive(false);
            end
        else
            imageBg.gameObject:SetActive(true);
            imagePet.gameObject:SetActive(false);
            
            name.text = '无宠物';
            if self.appearanceInfo.showPetID == 0 then
                mark:SetActive(true);
            else
                mark:SetActive(false);
            end
        end
        
        local fun_Choose = function()
            if petData.tbData and petData.tbData.BaseID == self.appearanceInfo.showPetID then
                return;
            end
            local petID = petData.tbData and petData.tbData.BaseID or 0;
            SendRequestRolePetCardOperate(RPCRT_PET_CARD, RPCOT_SET_PLAT_SHOW_PET_CARD, petID, 0);
        end
        self:RemoveButtonClickListener(button_pet)
        self:AddButtonClickListener(button_pet,fun_Choose)
    end
end
--=====================================================================
-- HEADBOX
--=====================================================================
function AccountSettingUI:ShowHeadBoxContent(bRefresh)
    if not IsValidObj(self.SC_HeadBox) then
        return
    end
    self.dataHeadBoxInst = {}
    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = unlockPool and unlockPool[PlayerInfoType.PIT_HEADBOX] or {}

    
    for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_HEADBOX]) do
        if checkUnlock[data.BaseID] or data.StartUnlock == TBoolean.BOOL_YES then 
            self.dataHeadBoxInst[#self.dataHeadBoxInst + 1] = {
                Id = data.BaseID,
                NameID = data.NameID,
                IconPath = data.IconPath,
                UnlockID = data.UnlockID or 0
            }
        end 
    end
    table.sort( self.dataHeadBoxInst, function(a,b)
        return a.UnlockID < b.UnlockID
    end )

    if bRefresh then
        self.SC_HeadBox:RefreshCells()
    else
        self.SC_HeadBox:ClearCells()
        self.SC_HeadBox.totalCount = #(self.dataHeadBoxInst);
        self.SC_HeadBox:RefillCells()
    end
end

function AccountSettingUI:OnHeadBoxScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end
    local instdata = self.dataHeadBoxInst[idx+1]
    local imageBox = self:FindChildComponent(item.gameObject, 'Image_box', 'Image');
    local name = self:FindChildComponent(item.gameObject, 'Text_name', 'Text');
    local Btnbutton = item.gameObject:GetComponent('Button');

    if instdata then 
        local sprite = GetSprite(instdata.IconPath)
        if sprite then 
            imageBox.gameObject:SetActive(true)
            imageBox.sprite = sprite
        else 
            imageBox.gameObject:SetActive(false)
        end 

        name.text = GetLanguageByID(instdata.NameID)
        local mark = self:FindChild(item.gameObject, 'Mark');
        if instdata.Id == self.appearanceInfo.HeadBoxID then
            mark:SetActive(true);
        else
            mark:SetActive(false);
        end
        local fun_Choose = function()
            if instdata.Id == self.appearanceInfo.HeadBoxID then
                return;
            end
            SendModifyPlayerAppearance(SMPAT_HEADBOX,tostring(instdata.Id))
        end
        self:RemoveButtonClickListener(Btnbutton)
        self:AddButtonClickListener(Btnbutton,fun_Choose)
    else 
        imageBox.gameObject:SetActive(false)
        name.text = '无头像框'
    end

end
--=====================================================================
-- LandLady
--=====================================================================
function AccountSettingUI:ShowLandLadyContent(bRefresh)
    if not IsValidObj(self.SC_LandLady) then
        return
    end
    self.dataLandLadyInst = {}
    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = unlockPool and unlockPool[PlayerInfoType.PIT_LANDLADY] or {}

    
    for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_LANDLADY]) do
        if checkUnlock[data.BaseID] or data.StartUnlock == TBoolean.BOOL_YES or data.BaseID == ActivityHelper:GetInstance():GetCurActiveLandLady() then 
            self.dataLandLadyInst[#self.dataLandLadyInst + 1] = {
                Id = data.BaseID,
                NameID = data.NameID,
                IconPath = data.IconPath,
                IfUnlock = checkUnlock[data.BaseID] or data.StartUnlock == TBoolean.BOOL_YES and true or false ,
                UnlockID = data.UnlockID or 0
            }
        end 
    end
    table.sort( self.dataLandLadyInst, function(a,b)
        return a.UnlockID < b.UnlockID
    end )

    if bRefresh then
        self.SC_LandLady:RefreshCells()
    else
        self.SC_LandLady:ClearCells()
        self.SC_LandLady.totalCount = #(self.dataLandLadyInst);
        self.SC_LandLady:RefillCells()
    end
end

function AccountSettingUI:OnLandLadyScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end
    local instdata = self.dataLandLadyInst[idx+1]
    local Image_Lady = self:FindChildComponent(item.gameObject, 'Image_Lady', 'Image');
    local name = self:FindChildComponent(item.gameObject, 'Text_name', 'Text');
    local Btnbutton = item.gameObject:GetComponent('Button');

    if instdata then 
        local sprite = GetSprite(instdata.IconPath)
        if sprite then 
            Image_Lady.gameObject:SetActive(true)
            Image_Lady.sprite = sprite
        else 
            Image_Lady.gameObject:SetActive(false)
        end 

        name.text = GetLanguageByID(instdata.NameID)
        local mark = self:FindChild(item.gameObject, 'Mark');
        if instdata.Id == ActivityHelper:GetInstance():GetCurActiveLandLady() then
            mark:SetActive(true);
        else
            mark:SetActive(false);
        end
        local fun_Choose = function()
            if instdata.Id == ActivityHelper:GetInstance():GetCurActiveLandLady() then
                return;
            end
            if  ActivityHelper:GetInstance():GetCurFestivalLandLady() ~= 0 then 
                SystemUICall:GetInstance():Toast('活动期间暂不允许主动切换老板娘')
            else
                SendModifyPlayerAppearance(SMPAT_LANDLADY,tostring(instdata.Id))
            end
        end
        self:RemoveButtonClickListener(Btnbutton)
        self:AddButtonClickListener(Btnbutton,fun_Choose)

        local obj_Festival = self:FindChild(item.gameObject,'Text_Festival')
        obj_Festival:SetActive(not instdata.IfUnlock and instdata.Id == ActivityHelper:GetInstance():GetCurFestivalLandLady())
    else 
        Image_Lady.gameObject:SetActive(false)
        name.text = '无老板娘'
    end

end
--=====================================================================
--=====================================================================
function AccountSettingUI:ShowLoginContent(bRefresh)
    if not IsValidObj(self.SC_login) then
        return
    end

    -- 将诗词数据排个序, 已解锁的显示在最前面, 二级按id排
    local unlockPool = globalDataPool:getData("UnlockPool")
    local checkUnlock = (unlockPool and unlockPool[PlayerInfoType.PIT_LOGINWORD]) and unlockPool[PlayerInfoType.PIT_LOGINWORD] or {}
    local IsUnlock = function(loginTypeData)
        local uiTypeID = loginTypeData.BaseID
        if self.unlockLoginCheck[uiTypeID] ~= nil then
            return self.unlockLoginCheck[uiTypeID]
        end
        local bUnlock = (loginTypeData.StartUnlock == TBoolean.BOOL_YES) or (checkUnlock[loginTypeData.BaseID] ~= nil)
        self.unlockLoginCheck[uiTypeID] = bUnlock == true and checkUnlock[loginTypeData.BaseID] or nil;
        return bUnlock
    end
    if not self.sortLoginData then
        -- 为了防止数据表里面id不连续导致遍历或排序错误, 这里转一遍数组
        self.sortLoginData = {}
        for _, data in pairs(TB_PlayerInfoData[PlayerInfoType.PIT_LOGINWORD]) do
            self.sortLoginData[#self.sortLoginData + 1] = data
        end
    end
    -- 排序会更新与引用加解锁查询表, 所以排序前先清空一次
    self.unlockLoginCheck = {}
    local uiWeightA, uiWeightB = 0, 0
    table.sort(self.sortLoginData, function(a, b)
        uiWeightA = (IsUnlock(a) and 10000 or 1) * a.BaseID
        uiWeightB = (IsUnlock(b) and 10000 or 1) * b.BaseID
        return uiWeightA > uiWeightB
    end)

    -- TODO
    self.unlockLogin = {}
    for i = 1, #(self.sortLoginData) do
        if self.unlockLoginCheck[self.sortLoginData[i].BaseID] then
            table.insert(self.unlockLogin, self.sortLoginData[i]);
        end
    end

    --
    if bRefresh then
        self.SC_login:RefreshCells()
    else
        self.SC_login:ClearCells()
        self.SC_login.totalCount = #self.unlockLogin
        self.SC_login:RefillCells()
    end
end

function AccountSettingUI:OnLoginScrollChange(item,idx)
    if not IsValidObj(item) then
        return
    end

    local loginTypeData = self.unlockLogin[idx + 1];
    if loginTypeData then
        local icon = self:FindChild(item.gameObject, 'Icon');
        local imageBg = self:FindChildComponent(icon, 'Image_bg', 'Image');
        local imageIcon = self:FindChildComponent(icon, 'Image_icon', 'Image');
        local marquee = self:FindChildComponent(icon, 'Marquee2', 'Marquee');
        local time = self:FindChildComponent(item.gameObject, 'Text_time', 'Text');
        local button_login = self:FindChildComponent(item.gameObject, 'DRButton', 'Button');

        local playerName = PlayerSetDataManager:GetInstance():GetPlayerName();
        local strText = string.format(GetLanguageByID(loginTypeData.TextID), playerName);
        marquee.text = strText;

        imageBg.sprite = GetSprite(loginTypeData.BottomPicPath);
        imageBg.gameObject:SetActive(loginTypeData.BottomPicPath ~= '');
        imageIcon.sprite = GetSprite(loginTypeData.IconPath);
        imageIcon.gameObject:SetActive(loginTypeData.IconPath ~= '');

        local subTime = self.unlockLoginCheck[loginTypeData.BaseID].dwParam - os.time();
        item.gameObject:SetActive(subTime > 0);
        local d = math.floor(subTime / 60 / 60 / 24);
        local h = math.floor(subTime / 60 / 60 % 24);
        time.text = string.format('有效时间：%d天%d小时', d, h > 1 and h or 1);
        if loginTypeData.ActiveTime == 5000 then
            time.text = '有效时间：永久';
        end

        if loginTypeData.BaseID == self.appearanceInfo.loginWordID then
            self:FindChild(item.gameObject, 'Image_chosen'):SetActive(true);
            time.color = DRCSRef.Color(0.91,0.91,0.91,1);
        else
            self:FindChild(item.gameObject, 'Image_chosen'):SetActive(false);
            time.color = DRCSRef.Color(0.5058824,0.4235294,0.3568628,1);
        end

        local fun_Choose = function()
            if loginTypeData.BaseID == self.appearanceInfo.loginWordID then
                return;
            end
            SendModifyPlayerAppearance(SMPAT_LOGINWORD,tostring(loginTypeData.BaseID))
        end
        self:RemoveButtonClickListener(button_login)
        self:AddButtonClickListener(button_login,fun_Choose)
    end
end
--=====================================================================

function AccountSettingUI:PickItemMusic(parent, obj)
    local content = self:FindChild(parent, 'Content');
    for k, v in pairs(content.transform) do
        if obj and obj == v then
            self:FindChildComponent(v.gameObject, 'MusicName/Text_music_name', 'Text').color = whiteColor;
            self:FindChild(v.gameObject, 'Image_chosen'):SetActive(true);
            self:FindChild(v.gameObject, 'Try_chosen'):SetActive(true);
        else
            self:FindChildComponent(v.gameObject, 'MusicName/Text_music_name', 'Text').color = blackColor;
            self:FindChild(v.gameObject, 'Image_chosen'):SetActive(false);
            self:FindChild(v.gameObject, 'Try_chosen'):SetActive(false);
        end
    end
end

function AccountSettingUI:PickItemPoetry(parent, obj)
    local content = self:FindChild(parent, 'Content');
    for k, v in pairs(content.transform) do
        if obj and obj == v then
            self:FindChildComponent(v.gameObject, 'PoemName/Text_poem_name', 'Text').color = whiteColor;
            self:FindChildComponent(v.gameObject, 'PoemName/Text_poet_name', 'Text').color = whiteColor;
            self:FindChild(v.gameObject, 'Image_chosen'):SetActive(true);
            self:FindChild(v.gameObject, 'Try_chosen'):SetActive(true);
        else
            self:FindChildComponent(v.gameObject, 'PoemName/Text_poem_name', 'Text').color = blackColor;
            self:FindChildComponent(v.gameObject, 'PoemName/Text_poet_name', 'Text').color = blackColor;
            self:FindChild(v.gameObject, 'Image_chosen'):SetActive(false);
            self:FindChild(v.gameObject, 'Try_chosen'):SetActive(false);
        end
    end
end

function AccountSettingUI:OnEnable()
    self._gameObject:SetActive(true)
    self:AddEventListener("Modify_Player_Appearance", function() 
        self:OnRefCurPage();
    end)
    self:AddEventListener("Modify_Player_ReNameNum", function()
        self:ShowNameContent()
    end)
end

function AccountSettingUI:OnRefCurPage()
    self.appearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo()
    self:ShowInfoBox()
    self:ChooseShowContent(self.CurChooseType, true)
end

function AccountSettingUI:OnDisable()
    self._gameObject:SetActive(false)
    self:RemoveEventListener('Modify_Player_Appearance');
    self:RemoveEventListener('Modify_Player_ReNameNum');

end

function AccountSettingUI:OnDestroy()
    self.PoemShowCom:Close()

    self.InputField_NewPlayerName.onEndEdit:RemoveAllListeners()
    self.InputField_NewPlayerName.onEndEdit:Invoke()
end

return AccountSettingUI