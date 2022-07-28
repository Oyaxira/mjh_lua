AccountInfoUI = class("AccountInfoUI",BaseWindow)

local AccountSettingCom = require 'UI/PlayerSet/AccountSettingUI'
local SpineRoleUI = require 'UI/Role/SpineRoleUI'
local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

local PoemType = {
    title = 1,
    content = 2,
}

local musicNormalPos = DRCSRef.Vec3(-166, -320, 0);
local musicObservePos = DRCSRef.Vec3(-166, -275, 0);

function AccountInfoUI:ctor(obj)
    self.PI = math.acos(-1);
    self.angle = 0;
    self.unitAngle = 2 * self.PI / 10;
    self.shortR = 25;
    self.longR = 300;
    self.rolePos = { width = -200, height = 100 };
    self.mindObj = nil;
    self.SpineRoleUI = SpineRoleUI.new()
    self.bPlayAni = true;

    self:SetGameObject(obj);
end

function AccountInfoUI:Init()
    self.PoemGroup = {}
    self.roleDataManager = RoleDataManager:GetInstance();
    self.playerSetDataManager = PlayerSetDataManager:GetInstance();

	local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
    if shareGroupUI then
        if not MSDKHelper:IsPlayerTestNet()then
            
            local _callback = function(bActive)
                local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
                if serverAndUIDUI and serverAndUIDUI._gameObject then
                    serverAndUIDUI._gameObject:SetActive(bActive);
                end
            end

		    self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
            self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.PINGTAI, _callback);
            
            local canvas = shareGroupUI:GetComponent('Canvas');
            if canvas then
                canvas.sortingOrder = 1298;
            end
        else
            shareGroupUI:SetActive(false);
        end
    end

    self.shareGroupUI = shareGroupUI;

    --commonInfo
    self.Obj_Info_Box = self:FindChild(self._gameObject,"Info_box")
    self.Text_Info_BiaoShi = self:FindChildComponent(self.Obj_Info_Box,"BiaoShi/Text_num","Text")
    self.Text_Info_ZhouMu = self:FindChildComponent(self.Obj_Info_Box,"ZhouMu/Text_num","Text")
    self.Text_Info_JingMai = self:FindChildComponent(self.Obj_Info_Box,"JingMai/Text_num","Text")
    self.Text_Info_WuJian = self:FindChildComponent(self.Obj_Info_Box,"WuJian/Text_num","Text")
    self.Text_Info_ChengJiu = self:FindChildComponent(self.Obj_Info_Box,"ChengJiu/Text_num","Text")
    self.Text_Info_QieCuo = self:FindChildComponent(self.Obj_Info_Box,"QieCuo/Text_num","Text")
    self.Text_Info_HuoYue = self:FindChildComponent(self.Obj_Info_Box,"HuoYue/Text_num","Text")

    --accountSetting
    self.Obj_Account_Setting_Box = self:FindChild(self._gameObject,"Account_setting_box")
    self.AccountSettingCom = AccountSettingCom.new(self.Obj_Account_Setting_Box)
    self.AccountSettingCom:SetActive(false)

    --appearance
    self.Text_PlayerName = self:FindChildComponent(self._gameObject,"Image_name/Text_name","Text")
    self.Obj_RoleSpine = self:FindChild(self._gameObject,"Role_spine/Spine_node/Spine")
    self.Text_MusicName = self:FindChildComponent(self._gameObject,"Music/Text_name","Text")
    self.Obj_Poem = self:FindChild(self._gameObject,"Poem")
    self.Obj_PoemGroupItem = self:FindChild(self.Obj_Poem,"PoemGroupItem")

    --
    self.objImageQQ = self:FindChild(self._gameObject,"Image_Name/Image_QQ")
    self.objImageWeChat = self:FindChild(self._gameObject,"Image_Name/Image_WeChat")
    self.objImageQQ:SetActive(false);
    self.objImageWeChat:SetActive(false);

    self.objTextPlatName = self:FindChild(self._gameObject,"Image_Name/PlatName")
    self.objPlatNameModifySign = self:FindChild(self.objTextPlatName,"Text/btn_change")
    self.textPlatName = self:FindChildComponent(self.objTextPlatName, "Text", "Text")

    self:AddEventListener("Modify_Player_ReNameNum", function()
        self:RefreshAccountName()
    end)
    
    self.headImage = self:FindChildComponent(self._gameObject, "Image_Head/head", "Image");
    self.Vip = self:FindChild(self._gameObject, "Image_Head/Vip");

    
    local objPar = self:FindChild(self._gameObject, "Image_Head/head")
    local objoldbox = self:FindChild(self._gameObject, "Image_Head")
	if not self.objheadboxUI then 
		self.objheadboxUI = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,objPar.transform)
	end 
	if self.objheadboxUI then  
		self.objheadboxUI._gameObject:SetActive(true)
		self.objheadboxUI:SetReplacedHeadBoxUI(objoldbox,false)	
		self.objheadboxUI:SetScale(1)	
		self.objheadboxUI:SetPlayerID()	
    end 
    
    if self.Vip then
        self.Vip:SetActive(false);
    end

    local btnPlatName = self.objTextPlatName:GetComponent("Button")
    self:AddButtonClickListener(btnPlatName, function()
        if self.bIsVisitor == true then
            return
        end
        self:OpenRenameBox()
    end)
    self.objTextPlatTitle = self:FindChild(self._gameObject,"Text_PlatTitle")


    self.ImagePlat = self:FindChild(self._gameObject, 'Image_plat');
    self.ImagePlat1 = self:FindChild(self.ImagePlat,"Image1")
    self.ImagePlat2 = self:FindChild(self.ImagePlat,"Image2")
    self.ImagePlat3 = self:FindChild(self.ImagePlat,"Image3")
    self.ImagePlat4 = self:FindChild(self.ImagePlat,"Image4")
    self.ImagePlat5 = self:FindChild(self.ImagePlat,"Image5")
    self.ImagePlatTable = {};
    table.insert(self.ImagePlatTable, self.ImagePlat1);
    table.insert(self.ImagePlatTable, self.ImagePlat2);
    table.insert(self.ImagePlatTable, self.ImagePlat3);
    table.insert(self.ImagePlatTable, self.ImagePlat4);
    table.insert(self.ImagePlatTable, self.ImagePlat5);

    self.ImageBigPlat = self:FindChild(self._gameObject, 'Image_bigplat');
    self.Obj_BigGround = self:FindChild(self.ImageBigPlat,"Image_BigGround");

    --
    self.objSpine = self:FindChild(self._gameObject,"Spine")
    self.objRole1 = self:FindChild(self.objSpine,"Role_spine (1)")
    self.objRole2 = self:FindChild(self.objSpine,"Role_spine (2)")
    self.objRole3 = self:FindChild(self.objSpine,"Role_spine (3)")
    self.objRole4 = self:FindChild(self.objSpine,"Role_spine (4)")
    self.objRole5 = self:FindChild(self.objSpine,"Role_spine (5)")
    self.objTextDec = self:FindChild(self.objSpine,"Text_Dec")
    self.spineTable = {};
    self.spineTable_Texture = {};
    table.insert(self.spineTable, self.objRole1);
    table.insert(self.spineTable, self.objRole2);
    table.insert(self.spineTable, self.objRole3);
    table.insert(self.spineTable, self.objRole4);
    table.insert(self.spineTable, self.objRole5);
    self.roleProperty = {};
    for i = 1, #(self.spineTable) do
        if not self.roleProperty[i] then
            self.roleProperty[i] = {};
        end
        self.roleProperty[i].pos = self.spineTable[i].transform.localPosition;
        self.roleProperty[i].scale = self.spineTable[i].transform.localScale;
        self.roleProperty[i].sort = self.spineTable[i]:GetComponent('SortingGroup').sortingOrder;
    end
    self.mindObj = self.spineTable[1];
    local spineTable = clone(self.spineTable);
    for i = 1, #(spineTable) do
        local comBtn = spineTable[i]:GetComponent('Button');
        self:AddButtonClickListener(comBtn, function()
            self.clickTarget = spineTable[i];
            local mousePos = GetTouchUIPos();
            self.objSet.transform.localPosition = DRCSRef.Vec3(mousePos.x - 20, mousePos.y + 30, mousePos.z);
            self.objSet:SetActive(true);
            
            if self.clickTarget ~= self.mindObj then
                self.comSetMainBtn:GetComponent('Button').enabled = true;
                setUIGray(self.comSetMainBtn:GetComponent('Image'), false);
            else
                self.comSetMainBtn:GetComponent('Button').enabled = false;
                setUIGray(self.comSetMainBtn:GetComponent('Image'), true);
            end

            --
            if self.bIsVisitor then
                self.comSetMainBtn:GetComponent('Button').enabled = false;
                setUIGray(self.comSetMainBtn:GetComponent('Image'), true);
            end
        end);
    end

    --
    self.objSet = self:FindChild(self._gameObject,"Set")
    self.comImageMaskBtn = self:FindChildComponent(self._gameObject,"Image_Mask","Button")
    self.comWatchBtn = self:FindChildComponent(self._gameObject,"Button_Watch","Button")
    self.comSetMainBtn = self:FindChildComponent(self._gameObject,"Button_SetMain","Button")
    self:AddButtonClickListener(self.comImageMaskBtn,function()
        self.objSet:SetActive(false);
    end)
    self:AddButtonClickListener(self.comWatchBtn,function()
        self.objSet:SetActive(false);
        self.objSpine:SetActive(false);
        self.Obj_RoleSpine:SetActive(false);
        local _callback = function()
            if self and self.IsOpen and self:IsOpen() then
                self.Obj_RoleSpine:SetActive(true);
                self.objSpine:SetActive(true);
                self:OnRefRoleSpine();
            end
        end

        local index = GetStringDataInGameObject(self.clickTarget, 'index');
        local tempT = {};
        local spineSort = self.bIsVisitor and self.ObserveSpineSort or self.spineSort;
        for i = 1, #(spineSort) do
            if spineSort[i] > 0 then
                table.insert(tempT, {uiRoleID = spineSort[i]});
            end
        end
        local info = {};
        info.roleIDs = tempT;
        info.index = tonumber(index);
        
        OpenWindowImmediately("ObserveUI", info);
        local observeUI = GetUIWindow('ObserveUI');
        if observeUI then
            observeUI:SetCallBack(_callback);
        end

    end)
    self:AddButtonClickListener(self.comSetMainBtn,function()
        if self.clickTarget ~= self.mindObj then
            self:OnClickRoleModBtn(self.clickTarget);
        else
            SystemUICall:GetInstance():Toast('已是主角');
        end
    end)

    -- 
    self.objBtnSetting = self:FindChild(self._gameObject,"Button_setting")
	self.Button_Setting = self.objBtnSetting:GetComponent("Button")
	if IsValidObj(self.Button_Setting) then
		local fun = function()
			self:OnClick_SettingButton()
		end
		self:AddButtonClickListener(self.Button_Setting,fun)
    end
    
    --
    self.objButtonTeam = self:FindChild(self._gameObject,"Button_team")
	self.Button_team = self.objButtonTeam:GetComponent("Button")
	if IsValidObj(self.Button_team) then
		local fun = function()
			self:OnClick_TeamButton()
		end
		self:AddButtonClickListener(self.Button_team,fun)
    end

    --
    self.objMusic = self:FindChild(self._gameObject, 'Music');
    self.objText = self:FindChild(self._gameObject, 'Text');
end

function AccountInfoUI:GetSpineSortToLocal()
    local akRoleEmbattle = self.roleDataManager:GetRoleEmbattleInfo();
    local roleBattle = akRoleEmbattle[EmBattleSchemeType.EBST_Team];
    if (not roleBattle) or (not roleBattle[1]) then
        return;
    end
    local team = clone(roleBattle[1]);
    local mainRoleID = 0;
    local bHasMainRole = false;
    local appearanceInfo = self.playerSetDataManager:GetAppearanceInfo();
    if appearanceInfo.showRoleID then
        mainRoleID = appearanceInfo.showRoleID;
        
        for i = 1, #(team) do
            if team[i].uiRoleID == mainRoleID then
                bHasMainRole = true;
            end
        end

        if not bHasMainRole or mainRoleID == 0 then
            mainRoleID = self.roleDataManager:GetMainRoleID();
        end
    end

    if self.bIsVisitor then
        team = clone(self.roleDataManager:GetObserveRoleEmbattleInfo());
        mainRoleID = self.roleDataManager:GetMainRoleID();
    end

    self.sortTeam = {};
    for i = 1, #(team) do
        if team[i].uiRoleID == mainRoleID then
            table.insert(self.sortTeam, 1, team[i]);
        else
            table.insert(self.sortTeam, team[i]);
        end
    end

    local tempT = {}; 
    if self.sortTeam then
        for i = 1, 5 do
            tempT[i] = self.sortTeam[i] and self.sortTeam[i].uiRoleID or 0;
        end
    end

    local platSpineSort = clone(GetConfig('PlatSpineSort'));
    if platSpineSort and next(platSpineSort) then
        
        local cloneSortTeam = clone(self.sortTeam);

        -- TODO 先去掉
        for i = 1, #(platSpineSort) do
            local bHas = false;
            for j = 1, #(cloneSortTeam) do
                if platSpineSort[i] == cloneSortTeam[j].uiRoleID then
                    table.remove(cloneSortTeam, j);
                    bHas = true; 
                    break;
                end
            end
            if not bHas then
                platSpineSort[i] = 0;
            end
        end

        -- TODO 后加上
        for i = 1, #(platSpineSort) do
            if platSpineSort[i] == 0 then
                if cloneSortTeam[1] then
                    platSpineSort[i] = table.remove(cloneSortTeam, 1).uiRoleID;
                end
            end
        end 

        -- TODO 说明主角被下了
        if platSpineSort[1] == 0 then
            table.insert(platSpineSort, table.remove(platSpineSort, 1));
        end

        -- TODO 如果主角不在第一个位置上
        if platSpineSort[1] ~= mainRoleID then
            for i = 1, #(platSpineSort) do
                if platSpineSort[i] == mainRoleID then
                    local a = platSpineSort[1];
                    local b = platSpineSort[i];
                    platSpineSort[1] = b;
                    platSpineSort[i] = a;
                    break;
                end
            end
        end
    end

    if self.bIsVisitor then
        self.ObserveSpineSort = tempT;
    else
        self.spineSort = tempT;
    end

    if platSpineSort and next(platSpineSort) then
        if self.bIsVisitor then
            self.ObserveSpineSort = clone(platSpineSort);
        else
            self.spineSort = clone(platSpineSort);
        end
    end
    self:SetSpineSortToLocal();
end

function AccountInfoUI:SetSpineSortToLocal()
    if not self.bIsVisitor then
        SetConfig('PlatSpineSort', self.spineSort, true);
    end
end

function AccountInfoUI:RefreshUI(info)
    info = info or {}
    self.kCacheInfo = info
    -- 访客模式
    self.bIsVisitor = (info.bIsVisitor == true)
    self.objBtnSetting:SetActive(not self.bIsVisitor)
    self.objButtonTeam:SetActive(not self.bIsVisitor)
    self.objPlatNameModifySign:SetActive(not self.bIsVisitor)
    -- 刷新界面数据
    self:RefreshBaseInfo()
    self:RefreshAppearance()

    --
	RoleDataManager:GetInstance():SetObserveData(self.bIsVisitor);
	GiftDataManager:GetInstance():SetObserveData(self.bIsVisitor);
	ItemDataManager:GetInstance():SetObserveData(self.bIsVisitor);
    MartialDataManager:GetInstance():SetObserveData(self.bIsVisitor);
    
    self:RefreshHeadBoxUI()

    --
    self.spineTable = {};
    table.insert(self.spineTable, self.objRole1);
    table.insert(self.spineTable, self.objRole2);
    table.insert(self.spineTable, self.objRole3);
    table.insert(self.spineTable, self.objRole4);
    table.insert(self.spineTable, self.objRole5);
    self.mindObj = self.spineTable[1];
    for i = 1, #(self.spineTable) do
        self.spineTable[i].transform.localPosition = self.roleProperty[i].pos;
        self.spineTable[i].transform.localScale = self.roleProperty[i].scale;
        self.spineTable[i]:GetComponent('SortingGroup').sortingOrder = self.roleProperty[i].sort;
        SetStringDataInGameObject(self.spineTable[i], 'index', '');
    end

    -- if self.bIsVisitor then
        self:OnRefRoleSpine();
    -- end

    self:SetShowState();

    --
    self:RefPrivilegeUI();
end

function AccountInfoUI:RefPrivilegeUI()
    if not MSDKHelper:IsPlayerTestNet() then
        if MSDKHelper:IsLoginWeChat() then
            if MSDKHelper:IsOpenWXPrivilege() then
                self.objImageWeChat:SetActive(true);
            end
        elseif MSDKHelper:IsLoginQQ() then
            if MSDKHelper:IsOpenQQPrivilege() then
                self.objImageQQ:SetActive(true);
            end
        end
    end

    if self.bIsVisitor then
        self.objImageQQ:SetActive(false);
        self.objImageWeChat:SetActive(false);

        if self.shareGroupUI then
            self.shareGroupUI:SetActive(false);
        end
    else
        if self.shareGroupUI then
            self.shareGroupUI:SetActive(true);
        end
    end
end

function AccountInfoUI:SetShowState()

    self.objText:SetActive(true);
    self.objBtnSetting:SetActive(true);
    self.objButtonTeam:SetActive(true);
    --self.objMusic.transform.localPosition = musicNormalPos;
    if self.bIsVisitor then
        --self.objMusic.transform.localPosition = musicObservePos;
        self.objText:SetActive(false);
        self.objBtnSetting:SetActive(false);
        self.objButtonTeam:SetActive(false);
    end
end

function AccountInfoUI:OnRefRoleSpine()
    self:GetSpineSortToLocal();

    local spineSort = nil;
    if self.bIsVisitor then
        spineSort = self.ObserveSpineSort;
    else
        spineSort = self.spineSort;
    end

    if spineSort then
        self.objTextDec:SetActive(false);

        if (not next(self.sortTeam)) and (not self.bIsVisitor) then
            local mainRoleID = self.roleDataManager:GetMainRoleID();
            table.insert(self.sortTeam, {uiRoleID = mainRoleID});
        end

        local Local_TB_RoleModel = TableDataManager:GetInstance():GetTable("RoleModel")
        for i = 1, #(self.spineTable) do
            if spineSort[i] > 0 then
                self.spineTable[i]:SetActive(true);
                self.ImagePlatTable[i]:SetActive(true);

                if GetStringDataInGameObject(self.spineTable[i], 'index') == '' then
                    SetStringDataInGameObject(self.spineTable[i], 'index', tostring(i));
                end

                local roleData = self.roleDataManager:GetRoleData(spineSort[i]);
                local dbData = self.roleDataManager:GetRoleTypeDataByID(spineSort[i]);
                local artData = self.roleDataManager:GetRoleArtDataByID(spineSort[i]);
                local strTitle = self.roleDataManager:GetRoleTitleStr(spineSort[i]);
                local strName = self.roleDataManager:GetRoleName(spineSort[i], true);
                
                if roleData and dbData and artData then
                    if roleData.uiFragment == 1 then
                        strName = self.roleDataManager:GetMainRoleName();
                    end
                    if strTitle then
                        strName = strTitle .. '·' .. strName;
                    end
                    
                    local comName = self:FindChildComponent(self.spineTable[i], 'Spine_node/Spine/name_Node/Text_name', 'Text');
                    comName.text = strName;
                    comName.color = getRankColor(roleData.uiRank);

                    local modelData = Local_TB_RoleModel[artData.BaseID];
                    if modelData then
                        local spine = self:FindChild(self.spineTable[i], 'Spine_node/Spine');
                        DynamicChangeSpine(spine, modelData.Model);
                        --scale 
                        local scale = GetRoleScale(modelData)
                        local fixScale = self.roleProperty[i].scale
                        local objChangeScale = self:FindChild(self.spineTable[i], 'Spine_node')
                        spine.gameObject:SetObjLocalScale(scale.x * 65 , scale.y * 65, scale.z * 65)
                        self.spineTable_Texture[i] = ChnageSpineSkin(spine, modelData.Texture);
                    end

                else
                    self.spineTable[i]:SetActive(false);
                    -- self.ImagePlatTable[i]:SetActive(false);
                end
            else
                self.spineTable[i]:SetActive(false);
                -- self.ImagePlatTable[i]:SetActive(false);
            end
        end

        self:RefreshPet();
    end
end

function AccountInfoUI:RefreshPet()
    local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
    local Local_TB_RoleModel = TableDataManager:GetInstance():GetTable("RoleModel")
    local PlatShowInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo() or {}
    local iCurShowID = PlatShowInfo.showPetID or 0
    
    if self.bIsVisitor and self.kCacheInfo then
        iCurShowID = self.kCacheInfo.kAppearanceInfo.dwShowPetID or 0;
    end

    if iCurShowID ~= 0 then 
        iCurShowID = TB_Pet[iCurShowID] and TB_Pet[iCurShowID].ArtID
    end 

    local petspine = self:FindChild(self.objSpine, 'pet_show');
    modelData = Local_TB_RoleModel[iCurShowID];

    if #self.spineTable > 0 and modelData then 
        petspine:SetActive(true)
        self.objPet_Show_Texture = self.SpineRoleUI:UpdateBaseSpine(petspine, iCurShowID, ROLE_SPINE_DEFAULT_ANIM)
        local sca = petspine.transform.localScale 
        petspine.transform.localScale = DRCSRef.Vec3(80 * sca.x,80* sca.y,80 * sca.z);
    else 
        petspine:SetActive(false)
    end
end

function AccountInfoUI:RefreshBaseInfo()
    if (self.bIsVisitor == true) and self.kCacheInfo then
        self.Text_Info_BiaoShi.text = self.kCacheInfo.defPlyID or 0
        local commonInfo = self.kCacheInfo.kCommInfo
        if commonInfo then
            self.Text_Info_ZhouMu.text = commonInfo.dwWeekRoundTotalNum or 0
            self.Text_Info_JingMai.text = commonInfo.dwMeridiansLvl or 0
            self.Text_Info_ChengJiu.text = commonInfo.dwAchievePoint or 0
            self.Text_Info_HuoYue.text = commonInfo.dwALiveDays or 0
            self.Text_Info_QieCuo.text = commonInfo.challengeWinTimes or 0
            local dwNormal = commonInfo.dwNormalHighTowerMaxNum or 0;
            local dwBlood = commonInfo.dwBloodHighTowerMaxNum or 0;
            local dwRegiment = commonInfo.dwRegimentHighTowerMaxNum or 0;
            self.Text_Info_WuJian.text = string.format('%d/%d/%d', dwNormal, dwBlood, dwRegiment);
        end
    else
        self.Text_Info_BiaoShi.text = PlayerSetDataManager:GetInstance():GetPlayerID()
        local commonInfo = PlayerSetDataManager:GetInstance():GetCommonInfo()
        local jingMaiLevel = MeridiansDataManager:GetInstance():GetSumLevel()
        if commonInfo then
            self.Text_Info_ZhouMu.text = commonInfo.weekRoundTotalNum or 0
            self.Text_Info_JingMai.text = jingMaiLevel;
            self.Text_Info_HuoYue.text = commonInfo.aLiveDays or 0
            self.Text_Info_QieCuo.text = commonInfo.challengeWinTimes or 0
            local dwNormal = commonInfo.dwNormalHighTowerMaxNum or 0;
            local dwBlood = commonInfo.dwBloodHighTowerMaxNum or 0;
            local dwRegiment = commonInfo.dwRegimentHighTowerMaxNum or 0;
            self.Text_Info_WuJian.text = string.format('%d/%d/%d', dwNormal, dwBlood, dwRegiment);
        end
        self.Text_Info_ChengJiu.text = AchieveDataManager:GetInstance():GetAllAchievePoint() or 0
    end

    local comTitle = self.objTextPlatTitle:GetComponent('Text');
    self:RefreshAccountName()
end

function AccountInfoUI:RefreshHeadBoxUI()
    if self.bIsVisitor then 
        self.objheadboxUI:SetHeadBoxID(self.kCacheInfo and self.kCacheInfo.kAppearanceInfo and self.kCacheInfo.kAppearanceInfo.dwHeadBoxID)
    else
        self.objheadboxUI:SetPlayerID()

    end 
end

function AccountInfoUI:RefreshAccountName()
    self.textPlatName.text = PlayerSetDataManager:GetInstance():GetPlayerName()
end

function AccountInfoUI:RefreshAppearance()
    dprint("#####RefreshAppearance")
    local AppearanceInfo = nil
    if (self.bIsVisitor == true) and self.kCacheInfo then
        AppearanceInfo = self.kCacheInfo.kAppearanceInfo
    else
        AppearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo()
    end
    if not AppearanceInfo then
        return
    end
    local strName = nil
    local iTitleID = nil
    local iModelID = nil
    local iBGMID = nil
    local iPoetryID = nil
    local iPaintingID = nil
    local iBbackGroundID = nil
    if self.bIsVisitor == true then
        strName = AppearanceInfo.acPlayerName
        iTitleID = AppearanceInfo.dwTitleID or 0
        iModelID = AppearanceInfo.dwModelID or 0
        iBGMID = AppearanceInfo.dwBGMID or 0
        iPoetryID = AppearanceInfo.dwPoetryID or 0
        iPaintingID = AppearanceInfo.dwPaintingID or 0
        iBbackGroundID = AppearanceInfo.dwBackGroundID or 0
        iPedestalID = AppearanceInfo.dwPedestalID or 0
        iCharPicUrl = AppearanceInfo.charPicUrl or ""

        local kCommonInfo = self.kCacheInfo.kCommInfo
        if kCommonInfo and (kCommonInfo.bUnlockHouse == 0) then
            strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(self.kCacheInfo.defPlyID or 0)
        end
        if (not strName) or (strName == "") then
            strName = STR_ACCOUNT_DEFAULT_NAME
        end
    else
        strName = AppearanceInfo.playerName or ""
        iTitleID = AppearanceInfo.titleID or 0
        iModelID = AppearanceInfo.modelID or 0
        iBGMID = AppearanceInfo.bgmID or 0
        iPoetryID = AppearanceInfo.poetryID or 0
        iPaintingID = AppearanceInfo.paintingID or 0
        iBbackGroundID = AppearanceInfo.backGroundID or 0
        iPedestalID = AppearanceInfo.pedestalID or 0
        iCharPicUrl = AppearanceInfo.charPicUrl or ""

    end

    -- title
    local tbl_RoleTitle = TableDataManager:GetInstance():GetTableData("RoleTitle",iTitleID)
    if tbl_RoleTitle and tbl_RoleTitle.TitleID > 0 then
        strName = GetLanguageByID(tbl_RoleTitle.TitleID) .. "·" .. strName
    end
    self.Text_PlayerName.text = strName
    self.textPlatName.text = strName


    -- bgm
    local tbl_PlayerInfoBGM = TB_PlayerInfoData[PlayerInfoType.PIT_BGM][iBGMID]
    if tbl_PlayerInfoBGM and tbl_PlayerInfoBGM.NameID then
        self.Text_MusicName.text = GetLanguageByID(tbl_PlayerInfoBGM.NameID)
        PlayMusic(tbl_PlayerInfoBGM.ResourceID);
    else
        self.Text_MusicName.text = "无歌曲"
    end

    -- poetry
    local tbl_PlayerInfoPoetry = TB_PlayerInfoData[PlayerInfoType.PIT_POERTY][iPoetryID]
    if tbl_PlayerInfoPoetry then
        self.Obj_Poem:SetActive(true);
        self:FormatPoetry(tbl_PlayerInfoPoetry)
    else
        self.Obj_Poem:SetActive(false);
    end

    -- ground
    local tbl_PlayerInfoGround = TB_PlayerInfoData[PlayerInfoType.PIT_PEDESTAL][iPedestalID]
    if tbl_PlayerInfoGround then
        self:SetGround(tbl_PlayerInfoGround);
    else
        tbl_PlayerInfoGround = TB_PlayerInfoData[PlayerInfoType.PIT_PEDESTAL][10060001];
        self:SetGround(tbl_PlayerInfoGround);
    end
    self:RefreshHeadImage()
end

function AccountInfoUI:SetGround(tbl_PlayerInfoGround)

    if tbl_PlayerInfoGround.PicType == 0 then
        for i = 1, #(self.ImagePlatTable) do
            local image = self.ImagePlatTable[i]:GetComponent('Image');
            image.sprite = GetSprite(tbl_PlayerInfoGround.ShowPath);
            if self.platActive then
                self.ImagePlatTable[i]:SetActive(self.platActive[i]);
            end
        end

        self.Obj_BigGround:SetActive(false);
    elseif tbl_PlayerInfoGround.PicType == 1 then
        for i = 1, #(self.ImagePlatTable) do
            if not self.platActive then
                self.platActive = {};
            end
            self.platActive[i] = self.ImagePlatTable[i].activeSelf;
            self.ImagePlatTable[i]:SetActive(false);
        end
        
        self.Obj_BigGround:GetComponent('Image').sprite = GetSprite(tbl_PlayerInfoGround.ShowPath);
        self.Obj_BigGround:SetActive(true);
    end

end

function AccountInfoUI:FormatPoetry(tbl_PlayerInfoPoetry)
    local content = GetLanguageByID(tbl_PlayerInfoPoetry.TextID)
    local poetryArray = self:PoetryString2Array(content)
    local title = GetLanguageByID(tbl_PlayerInfoPoetry.NameID)
    if title and poetryArray and (#poetryArray > 0) then
        local leftIndex = string.find(title, "《")
        local rightIndex = string.find(title, "》")
        local len = string.len("《")
        title = string.sub(title, leftIndex + len, rightIndex - 1)
        local poem = {}
        local num = #poetryArray
        for i = 1,num + 1 do
            if i ~= num + 1 then
                poem[i] = {["txt"] = poetryArray[i], ["index"] = i, ["flag"] = PoemType.content}
            else
                poem[i] = {["txt"] = title, ["index"] = 0, ["flag"] = PoemType.title}
            end
        end
        self:ShowPoetry(poem)
    end
end

function AccountInfoUI:PoetryString2Array(str)
    if (not str) or (str == "") then
        return
    end
    
    str = "|"  .. str .. "|"
    tabStr = string.split(str, "#")
    local ret = {}
    table.move(tabStr, 2, #tabStr - 1, #ret + 1, ret)
    for i = 1, #(ret) do
        ret[i] = string.gsub(ret[i], '\n','')
        ret[i] = string.sub(ret[i], 1, string.len(ret[i]) - 3);
    end

    return ret
end

function AccountInfoUI:ShowPoetry(array)

    self:RemoveAllChildToPool(self.Obj_Poem.transform);
    self.PoemGroup = {};

    local count = 0
    table.sort(array,function(a,b) return a.index > b.index end)
    for key,value in pairs(array) do
        if value then 
            if not self.PoemGroup[value.index] then
                self.PoemGroup[value.index] = self:LoadPrefabFromPool('PlayerSetUI/PoemGroupItem', self.Obj_Poem);
            end

            local Text_sym = self:FindChild(self.PoemGroup[value.index],"Text_sym")
            local Text = self:FindChildComponent(self.PoemGroup[value.index],"Text","Text")
            Text_sym:SetActive(value.flag == PoemType.title)
            Text.text = value.txt
            count = count + 1
        end
    end

    local num = 1
    for key,value in pairs(self.PoemGroup) do
        if num > count then
            value:SetActive(false)
        else
            value:SetActive(true)
        end
        num = num + 1
    end

end

function AccountInfoUI:OnClick_SettingButton()
    self.AccountSettingCom:RefreshUI()
end

function AccountInfoUI:OnClick_TeamButton()
    local objCloseBtn = self:FindChild(self._gameObject.transform.parent.gameObject, 'Button_back');
    objCloseBtn:SetActive(false);
    self.Obj_RoleSpine:SetActive(false);
    self.objSpine:SetActive(false);
    
    local _callback = function()
        if self and self.IsOpen and self:IsOpen() then
            self.bPlayAni = false;
            objCloseBtn:SetActive(true);
            self.Obj_RoleSpine:SetActive(true);
            self.objSpine:SetActive(true);
            self:OnRefRoleSpine();
        end
    end

    OpenWindowImmediately("RoleEmbattleUI");
    local roleEmbattleUI = GetUIWindow("RoleEmbattleUI");
    if roleEmbattleUI then
        roleEmbattleUI:SetType(2);
        roleEmbattleUI:OnRefUIByPlayerSetting();
        roleEmbattleUI:SetCallBack(_callback);
    end
end

function AccountInfoUI:OnClickRoleModBtn(obj)
    local index = tonumber(GetStringDataInGameObject(obj, 'index'));
    if self.spineSort and self.spineSort[index] then
        self.bPlayAni = true;
        local uiRoleID = self.spineSort[index];
        SendModifyPlayerAppearance(SMPAT_SHOWROLE, tostring(uiRoleID))

        local tempDA = self.spineSort[1];
        local tempDB = self.spineSort[index];
        self.spineSort[1] = tempDB;
        self.spineSort[index] = tempDA;
        self:SetSpineSortToLocal();
    end 
end

function AccountInfoUI:PlayAni()
    local obj = self.clickTarget;
    local mindObj = self.mindObj;

    if (not obj) or (not mindObj) then
        return;
    end

    local animationDuration = 0.5;
    local pathType = CS.DG.Tweening.PathType.CatmullRom;
    local pathMode = CS.DG.Tweening.PathMode.Sidescroller2D;

    local scale1 = obj.transform.localScale;
    local pos1 = obj.transform.localPosition;
    local scale2 = mindObj.transform.localScale;
    local pos2 = mindObj.transform.localPosition;
    local pos3 = DRCSRef.Vec3(pos1.x, pos2.y, 0);
    local pathTable1 = {};
    table.insert(pathTable1, pos1);
    table.insert(pathTable1, pos3);
    table.insert(pathTable1, pos2);

    local seq1 = DRCSRef.DOTween.Sequence();
    seq1:Insert(obj.transform:DOLocalPath(pathTable1, animationDuration, pathType, pathMode));
    seq1:Insert(obj.transform:DOScale(DRCSRef.Vec3(scale2.x, scale2.y, scale2.z), animationDuration));
    seq1.onComplete = function()
        dprint('onComplete1');
        
        local comOrder1 = obj:GetComponent('SortingGroup');
        local comOrder2 = self.mindObj:GetComponent('SortingGroup');
        local order1 = comOrder1.sortingOrder;
        
        local order2 = comOrder2.sortingOrder;

        -- self.mindObj = obj;
        comOrder2.sortingOrder = order1;
        comOrder1.sortingOrder = order2;

        local index = tonumber(GetStringDataInGameObject(obj, 'index'));
        index = tonumber(GetStringDataInGameObject(self.spineTable[index], 'index'));
        local mindObjIndex = tonumber(GetStringDataInGameObject(self.mindObj, 'index'));
        mindObjIndex = tonumber(GetStringDataInGameObject(self.spineTable[mindObjIndex], 'index'));
        
        SetStringDataInGameObject(obj, 'index', tostring(mindObjIndex));
        SetStringDataInGameObject(self.mindObj, 'index', tostring(index));

        local tempSpineA = self.spineTable[index];
        local tempSpineB = self.spineTable[mindObjIndex];
        self.spineTable[index] = tempSpineB;
        self.spineTable[mindObjIndex] = tempSpineA;

        self.mindObj = obj;

        self.objSet:SetActive(false);
    end;
   
    local pathTable2 = {};
    table.insert(pathTable2, pos2);
    table.insert(pathTable2, pos3);
    table.insert(pathTable2, pos1);
    local seq2 = DRCSRef.DOTween.Sequence();
    seq2:Insert(mindObj.transform:DOLocalPath(pathTable2, animationDuration, pathType, pathMode));
    seq2:Insert(mindObj.transform:DOScale(DRCSRef.Vec3(scale1.x, scale1.y, scale1.z), animationDuration));
    seq2.onComplete = function()
        dprint('onComplete2');
    end;
end

function AccountInfoUI:OnEnable()
    self:AddEventListener("Modify_Player_Appearance", function(info) 
        if info.eModifyType == SMPAT_SHOWROLE then
            if self.bPlayAni then
                self:PlayAni();
            end
        else
            self:RefreshAppearance()
        end
    end)
    self:AddEventListener('ONEVENT_REF_ANI', function(info)
        -- self:PlayAni();
    end);
    self:AddEventListener('ONEVENT_REF_PLAYERSPINE', function(info)
        self:OnRefRoleSpine();
    end);
    self:AddEventListener('Modify_UseTencentHeadPic', function(info)
        self:RefreshHeadImage();
	end);
end

function AccountInfoUI:OnDisable()
    self:RemoveEventListener('Modify_Player_Appearance');
    self:RemoveEventListener('Modify_UseTencentHeadPic');
    self:RemoveEventListener('ONEVENT_REF_ANI');
    self:RemoveEventListener('ONEVENT_REF_PLAYERSPINE');
end

-- 打开改名界面
function AccountInfoUI:OpenRenameBox()
    OpenWindowImmediately("RenameBoxUI")
end

function AccountInfoUI:OnDestroy()
    self.AccountSettingCom:Close()
    self.SpineRoleUI:Close()

    if self.TencentShareButtonGroupUI then
		self.TencentShareButtonGroupUI:Close();
    end
    LuaClassFactory:GetInstance():ReturnAllUIClass({self.objheadboxUI})

end

--刷新头像
function AccountInfoUI:RefreshHeadImage()
    dprint("##### RefreshHeadImage")
    
    local callback = function(sprite)
        local uiWindow = GetUIWindow("PlayerSetUI")
		if (uiWindow and uiWindow.AccountInfoCom) then
            if (self.headImage ~= nil) then
                self.headImage.sprite = sprite
            end
        end
	end 
    local pjsondata = {}
    if self.bIsVisitor then
        GetHeadPicByData(self.kCacheInfo.kAppearanceInfo, callback)
    else
        MSDKHelper:SetHeadPic(callback)
    end

    local bVIP = TreasureBookDataManager:GetInstance():GetTreasureBookVIPState();
    if self.Vip then
        self.Vip:SetActive(bVIP)
    end
end

return AccountInfoUI

