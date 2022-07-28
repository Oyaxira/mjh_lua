CollectionUI = class('CollectionUI', BaseWindow);

local CollectionMartialUI = require 'UI/CollectionUI/CollectionMartialUI';

local SpineRoleUINew = require 'UI/Role/SpineRoleUINew'
local SpineRoleUI = require 'UI/Role/SpineRoleUI'

local CollectionName = {
    -- [CollectionType.CLT_ROLE] = '角色',
    -- [CollectionType.CLT_PET] = '宠物',
    [CollectionType.CLT_MARTIAL] = '武学',
    [CollectionType.CLT_CLAN] = '门派',
    -- [CollectionType.CLT_FORGE] = '配方',
    [CollectionType.CLT_HEIR] = '传家宝',
    [CollectionType.CLT_CG] = '插画',
    [CollectionType.CLT_COMIC] = '漫画'
}
local CollectionName2Point = {
    -- [CollectionType.CLT_ROLE] = '角  色',
    -- [CollectionType.CLT_PET] = '宠  物',
    [CollectionType.CLT_MARTIAL] = '武  学',
    [CollectionType.CLT_CLAN] = '门  派',
    -- [CollectionType.CLT_FORGE] = '配  方',
    [CollectionType.CLT_HEIR] = '传家宝',
    [CollectionType.CLT_CG] = '插  画',
    [CollectionType.CLT_COMIC] = '漫  画'
}
local CollectionUnLockStateLock = {
    [CollectionType.CLT_NULL] = true,
}
local TB_CollectionAchieve 
function CollectionUI:ctor()
    TB_CollectionAchieve = TableDataManager:GetInstance():GetTable("CollectionAchieve") or {}
    self._coms_comname = {}
end

function CollectionUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/CollectionUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function CollectionUI:OnPressESCKey()
    if self.collectionClanUI.detail_panel.activeSelf then
        self.collectionClanUI.detail_panel:SetActive(false)
    elseif self.collectionComicUI.objComicPage.activeSelf then
        self.collectionComicUI.objComicPage:SetActive(false)
    elseif self.collectionCGUI.objCGPage.activeSelf then
        self.collectionCGUI.objCGPage:SetActive(false)
    else
        if self.comBackBtn then
            self.comBackBtn.onClick:Invoke()
        end
    end
end

function CollectionUI:Init()
    --
    self.CollectionMgr = CollectionDataManager:GetInstance()
    self.objTypeBtn_Role = self:FindChild(self._gameObject,'Role')
    self.objTypeBtn_Pet = self:FindChild(self._gameObject,'Pet')
    self.objTypeBtn_Clan = self:FindChild(self._gameObject,'Clan')
    self.objTypeBtn_Comic = self:FindChild(self._gameObject,'Comic')
    self.objTypeBtn_Martial = self:FindChild(self._gameObject,'Martial')
    self.objTypeBtn_Heirloom = self:FindChild(self._gameObject,'Heirloom')
    self.objTypeBtn_Forge = self:FindChild(self._gameObject,'Forge')
    self.objTypeBtn_CG = self:FindChild(self._gameObject,'CG')
    --
    self.objTypeBtn_Pet_Red = self:FindChild(self.objTypeBtn_Pet,'Button_tag/Image_redPoint')
    self.objTypeBtn_Role_Red = self:FindChild(self.objTypeBtn_Role,'Button_tag/Image_redPoint')
    self.objTypeBtn_Clan_Red = self:FindChild(self.objTypeBtn_Clan,'Button_tag/Image_redPoint')
    self.objTypeBtn_Comic_Red = self:FindChild(self.objTypeBtn_Comic,'Button_tag/Image_redPoint')
    self.objTypeBtn_Martial_Red = self:FindChild(self.objTypeBtn_Martial,'Button_tag/Image_redPoint')
    self.objTypeBtn_Heirloom_Red = self:FindChild(self.objTypeBtn_Heirloom,'Button_tag/Image_redPoint')
    self.objTypeBtn_Forge_Red = self:FindChild(self.objTypeBtn_Forge,'Button_tag/Image_redPoint')
    self.objTypeBtn_CG_Red = self:FindChild(self.objTypeBtn_CG,'Button_tag/Image_redPoint')

    self.comBackBtn = self:FindChildComponent(self._gameObject, 'TabFrame/frame/Btn_exit','DRButton')
    if self.comBackBtn then
        self:AddButtonClickListener(self.comBackBtn,function()
            RemoveWindowImmediately('CollectionUI', false)
            LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
        end)
    end
    self._obj_Par_TypeBtn = {
        -- [CollectionType.CLT_ROLE] = self.objTypeBtn_Role,
        -- [CollectionType.CLT_PET] = self.objTypeBtn_Pet,
        [CollectionType.CLT_MARTIAL] = self.objTypeBtn_Martial,
        [CollectionType.CLT_CLAN] = self.objTypeBtn_Clan,
        -- [CollectionType.CLT_FORGE] = self.objTypeBtn_Forge,
        [CollectionType.CLT_HEIR] = self.objTypeBtn_Heirloom,
        [CollectionType.CLT_CG] = self.objTypeBtn_CG,
        [CollectionType.CLT_COMIC] = self.objTypeBtn_Comic,
    }
    self._obj_bindBtnTable = {}
    self._obj_bindSpaceClick = {}
    self:Init__obj_Par_TypeBtn()
    


    self.obj_PointPanal = self:FindChild(self._gameObject,'main/PointPanal')
    self.obj_PointPanal:SetActive(true)

    self.com_Text_PointsAll = self:FindChildComponent(self.obj_PointPanal,'PointsAll','Text')
    self.com_Text_NextAchieve = self:FindChildComponent(self.obj_PointPanal,'NextAchieve','Text')
    self.obj_PointChild = self:FindChild(self.obj_PointPanal,'PointChild')
    self.obj_PointChild:SetActive(false)
    self.obj_PointsDetail = self:FindChild(self.obj_PointPanal,'PointsDetail')

    self:InitPointsPanal()
	self:AddEventListener("UPDATE_COLLECTION_BUTTON", function(info)
		self:RefreshCollectionRedPoint()
    end)
    self:AddEventListener("UPDATE_COLLECTION_POINT", function(info)
		self:RefreshPointsPanal()
    end)
    self:InitToggles()
    self.collectionCGUI = CollectionCGUI.new()
    self.collectionCGUI:SetGameObject(self:FindChild(self._gameObject,"frame/CollectionCGUI"))
    self.collectionCGUI:Init()
    self.collectionComicUI = CollectionComicUI.new()
    self.collectionComicUI:SetGameObject(self:FindChild(self._gameObject,"frame/CollectionComicUI"))
    self.collectionComicUI:Init()
    self.collectionMartialUI = CollectionMartialUI.new()
    self.collectionMartialUI:SetGameObject(self:FindChild(self._gameObject,"frame/CollectionMartialUI"))
    self.collectionMartialUI:Init()
    self.collectionHeirloomUI = CollectionHeirloomUI.new()
    self.collectionHeirloomUI:SetGameObject(self:FindChild(self._gameObject,"frame/CollectionHeirloomUI"))
    self.collectionHeirloomUI:Init()
    self.collectionClanUI = ClanUI.new()
    self.collectionClanUI:SetGameObject(self:FindChild(self._gameObject,"frame/ClanUI"))
    self.collectionClanUI:Init()
end

function CollectionUI:InitToggles()
    self.objTab_box = self:FindChild(self._gameObject,"TabFrame/WindowTabUI/TransformAdapt_node_right/Tab_box")
    self.objFrame = self:FindChild(self._gameObject,"frame")
    self.Toggle_stats = self:FindChildComponent(self.objTab_box,"Toggle_stats","Toggle")
    self.Image_stats_bac = self:FindChild(self.objTab_box, "Toggle_stats/bac")
    if self.Toggle_stats then
        local objMainFrame = self:FindChild(self.objFrame, "main")
        local fun = function(bool)
            self.Image_stats_bac:SetActive(bool)
            objMainFrame:SetActive(bool)
            if bool then
                
            end
        end
        self:AddToggleClickListener(self.Toggle_stats,fun)
    end

    self.Toggle_CG = self:FindChildComponent(self.objTab_box,"Toggle_CG","Toggle")
    self.Image_CG_bac = self:FindChild(self.objTab_box, "Toggle_CG/bac")
    self.objCollectionCGUI = self:FindChild(self.objFrame,"CollectionCGUI")
    if self.Toggle_CG then
        local fun = function(bool)
            self.Image_CG_bac:SetActive(bool)
            self.objCollectionCGUI:SetActive(bool)
            if bool then
                
            end
        end
        self:AddToggleClickListener(self.Toggle_CG,fun)
    end

    self.Toggle_comic = self:FindChildComponent(self.objTab_box,"Toggle_comic","Toggle")
    self.Image_comic_bac = self:FindChild(self.objTab_box, "Toggle_comic/bac")
    self.objCollectionComicUI = self:FindChild(self.objFrame,"CollectionComicUI")
    if self.Toggle_comic then
        local fun = function(bool)
            self.Image_comic_bac:SetActive(bool)
            self.objCollectionComicUI:SetActive(bool)
            if bool then
                
            end
        end
        self:AddToggleClickListener(self.Toggle_comic,fun)
    end

    self.Toggle_martial = self:FindChildComponent(self.objTab_box,"Toggle_martial","Toggle")
    self.Image_martial_bac = self:FindChild(self.objTab_box, "Toggle_martial/bac")
    self.objCollectionMartialUI = self:FindChild(self.objFrame,"CollectionMartialUI")
    if self.Toggle_martial then
        local fun = function(bool)
            self.Image_martial_bac:SetActive(bool)
            self.objCollectionMartialUI:SetActive(bool)
            if bool then
                self.collectionMartialUI:OnEnable()
            else
                self.collectionMartialUI:OnDisable()
            end
        end
        self:AddToggleClickListener(self.Toggle_martial,fun)
    end

    self.Toggle_heirloom = self:FindChildComponent(self.objTab_box,"Toggle_heirloom","Toggle")
    self.Image_heirloom_bac = self:FindChild(self.objTab_box, "Toggle_heirloom/bac")
    self.objCollectionHeirloomUI = self:FindChild(self.objFrame,"CollectionHeirloomUI")
    if self.Toggle_heirloom then
        local fun = function(bool)
            self.Image_heirloom_bac:SetActive(bool)
            self.objCollectionHeirloomUI:SetActive(bool)
            if bool then
                
            end
        end
        self:AddToggleClickListener(self.Toggle_heirloom,fun)
    end

    self.Toggle_clan = self:FindChildComponent(self.objTab_box,"Toggle_clan","Toggle")
    self.Image_clan_bac = self:FindChild(self.objTab_box, "Toggle_clan/bac")
    self.objCollectionClanUI = self:FindChild(self.objFrame,"ClanUI")
    if self.Toggle_clan then
        local fun = function(bool)
            self.Image_clan_bac:SetActive(bool)
            self.objCollectionClanUI:SetActive(bool)
            if bool then
                
            end
        end
        self:AddToggleClickListener(self.Toggle_clan,fun)
    end
end

function CollectionUI:InitPointsPanal()
    RemoveAllChildren(self.obj_PointsDetail)
    self._coms_comname = {}
    if CollectionName then 
        for inum=1,8 do 
            if CollectionName[inum] then 
                local str =  CollectionName[inum]
                ui_clone = CloneObj(self.obj_PointChild, self.obj_PointsDetail)
                ui_clone:SetActive(true)
                local comname = self:FindChildComponent(ui_clone,'Name','Text')
                comname.text = CollectionName2Point[inum]
                local comvalue = self:FindChildComponent(ui_clone,'Scrollbar/Value','Text')
                local comScroll = self:FindChildComponent(ui_clone,'Scrollbar','Scrollbar')
                self._coms_comname[inum] = {
                    value = comvalue,
                    scroll = comScroll,
                }
            end 
        end 
    end
end
function CollectionUI:RefreshPointsPanal()
    self.aiCollectionPoint = self.CollectionMgr:GetPointsDetails()

    local iscoreall = 0

    for etype,_coms in pairs( self._coms_comname) do 
        local iscore = self.aiCollectionPoint[etype] or 0
        local iscoremax = self.CollectionMgr:GetPointMaxByCollectionType(etype)
        iscoreall = iscoreall + iscore
        iscoremax = math.max( iscoremax,iscore )
        if _coms.value then 
            _coms.value.text = iscore .. '/' .. iscoremax
        end 
        if _coms.scroll then 
            _coms.scroll.size = iscore / iscoremax
        end 
    end 
    self.com_Text_PointsAll.text = iscoreall
    local strnext = nil 
    if TB_CollectionAchieve then 
        for i=1,#TB_CollectionAchieve do 
            local CollectionAchieve = TB_CollectionAchieve[i]
            if CollectionAchieve.AchievePoint > iscoreall then 
                strnext = string.format('下级成就要求：%d',CollectionAchieve.AchievePoint) 
                break 
            end 
        end 
    end 
    if strnext == nil then 
        strnext = ''
    end
    self.com_Text_NextAchieve.text = strnext
end
function CollectionUI:RefreshCollectionRedPoint()
    if self.objTypeBtn_Role_Red then 
        local bActive = CardsUpgradeDataManager:GetInstance():CheckRoleCardsExsUpGrade() 
        self.objTypeBtn_Role_Red:SetActive(bActive)
    end 
    if self.objTypeBtn_Pet_Red then 
        local bActive = CardsUpgradeDataManager:GetInstance():CheckPetCardsExsUpGrade()
        self.objTypeBtn_Pet_Red:SetActive(bActive)
    end 
    if self.objTypeBtn_Clan_Red then  
        local bActive = ClanDataManager:GetInstance():CheckHasNewData()
        self.objTypeBtn_Clan_Red:SetActive(bActive)
    end
    if self.objTypeBtn_Comic_Red then  
        self.objTypeBtn_Comic_Red:SetActive(false)
    end
    if self.objTypeBtn_Martial_Red then  
        self.objTypeBtn_Martial_Red:SetActive(false)
    end
    if self.objTypeBtn_Heirloom_Red then  
        self.objTypeBtn_Heirloom_Red:SetActive(false)
    end
    if self.objTypeBtn_Forge_Red then  
        self.objTypeBtn_Forge_Red:SetActive(false)
    end
    if self.objTypeBtn_CG_Red then  
        self.objTypeBtn_CG_Red:SetActive(false)
    end
end
function CollectionUI:Init__obj_Par_TypeBtn()
    for iType = 1,8 do 
        local objTypeBtn = self._obj_Par_TypeBtn[iType] 
        if objTypeBtn then 
            -- com也缓存
            local comTypeBtnName = self:FindChildComponent(objTypeBtn,'Button_tag/Name','Text')
            if comTypeBtnName then 
                comTypeBtnName.text =  CollectionName[iType]
            end 
            local comTypeBtnImg = self:FindChildComponent(objTypeBtn,'img','Image')
            local objTypeBtnLock = self:FindChild(objTypeBtn,'img/lock')
            if self:GetBtnUnLock(iType) then 
                comTypeBtnImg.color = ITEM_INFO_SELECT_COLOR['on']
                objTypeBtnLock:SetActive(false)
            else 
                comTypeBtnImg.color = UI_COLOR['lightgrey']
                objTypeBtnLock:SetActive(true)
            end 
            if iType == CollectionType.CLT_FORGE then 
                -- 炉子额外灰
                local comTypeBtnImg_ex = self:FindChildComponent(objTypeBtn,'img_ex','Image')
                if self:GetBtnUnLock(iType) then 
                    comTypeBtnImg_ex.color = ITEM_INFO_SELECT_COLOR['on']
                else 
                    comTypeBtnImg.color = UI_COLOR['lightgrey']
                end 
            end 
            local comBtnTypeTag = self:FindChildComponent(objTypeBtn,'Button_tag','DRButton')
            self._obj_bindBtnTable[iType] = comBtnTypeTag
            self:AddButtonClickListener(comBtnTypeTag,function()
                self:OnClickBtnTypeTag(iType)
            end )
            local comBtnSpaceClick = self:FindChildComponent(objTypeBtn,'ClickSpace','DRButton')
            self._obj_bindSpaceClick[iType] = comBtnSpaceClick
            self:AddButtonClickListener(comBtnSpaceClick,function()
                self:OnClickBtnTypeTag(iType)
            end )

        end 
    end 
end 
function CollectionUI:OnClickBtnTypeTag(iType)
    -- RemoveWindowImmediately('CollectionUI', true)
    if self:GetBtnUnLock(iType) then  

        if iType == CollectionType.CLT_ROLE then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately('RoleCardsUpgradeUI',true)
        elseif iType == CollectionType.CLT_PET then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately('PetCardsUpgradeUI',true)
        elseif iType == CollectionType.CLT_CLAN then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately("ClanUI", {isShowOnly = true})
            local ClanUI = GetUIWindow("ClanUI")
            if ClanUI then
                ClanUI:SetCloseCallBack(function()
                    OpenWindowImmediately("CollectionUI")
                end ) 
            end 
        elseif iType == CollectionType.CLT_MARTIAL then
            OpenWindowImmediately('CollectionMartialUI',true)
        elseif iType == CollectionType.CLT_COMIC then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately('CollectionComicUI',true)
        elseif iType == CollectionType.CLT_HEIR then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately('CollectionHeirloomUI',true)
        elseif iType == CollectionType.CLT_FORGE then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately('CollectionFormulaUI',true)
        elseif iType == CollectionType.CLT_CG then
            RemoveWindowImmediately('CollectionUI', true)
            OpenWindowImmediately('CollectionCGUI',true)
        end
    end
end
function CollectionUI:GetBtnUnLock(eType)
    if CollectionUnLockStateLock[eType or 0] then 
        return false 
    else 
        return true 
    end 
end
function CollectionUI:OnClickBackBtn(obj)

end


function CollectionUI:RefreshUI()
    CardsUpgradeDataManager:GetInstance():RequestAllDatas()
    self:RefreshCollectionRedPoint()
    self:RefreshPointsPanal()
    self:RefreshSpine()
    self.collectionCGUI:RefreshUI()
    self.collectionComicUI:RefreshUI()
    self.collectionMartialUI:RefreshUI()
    self.collectionHeirloomUI:RefreshUI()
    local info = {
        isShowOnly = true
    }
    self.collectionClanUI:RefreshUI(info)
end


function CollectionUI:RefreshSpine()
    
    self.objActor_BaseInfoSpine = self:FindChild(self._gameObject, 'SpineRoot/Base_Actor')
    self.spineRoleUINew = SpineRoleUINew.new()
    self.spineRoleUINew:SetGameObject(self:FindChild(self._gameObject, 'SpineRoot'))
    self.spineRoleUINew:SetSpine(self.objActor_BaseInfoSpine,false)
    self.spineRoleUINew:SetDefaultScale(95)

    -- local PlatShowInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo() or {}
    -- local iroleid = PlatShowInfo.showRoleID 
    -- local roleData = RoleDataManager:GetInstance():GetRoleData(iroleid)

    -- if  not roleData then 
        -- self.spineRoleUINew:SetRoleDataByBaseID(1000001260)
        self.spineRoleUINew:OnlySetModelID(10)
    -- else 
    --     self.spineRoleUINew:SetRoleDataByUID(iroleid)
    -- end
    self.spineRoleUINew:UpdateRoleSpine()



    
	self.SpineRoleUI = SpineRoleUI.new()
    self.objPet_BaseInfoSpine = self:FindChild(self._gameObject, 'SpineRoot/Pet_Actor')

    local kBaseInfo = TreasureBookDataManager:GetInstance():GetTreasureBookBaseInfo()
    local petid = 201
    if kBaseInfo and kBaseInfo.iCurBookID then 
        local kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",kBaseInfo.iCurBookID)
        petid = kTreasureBook and kTreasureBook.CurMainShowPet or 201 
    end 
    if self.SpineRoleUI and self.objPet_BaseInfoSpine and self.objPet_BaseInfoSpine then
        local Petdata = GetTableData('Pet',petid )
        self.objPet_BaseInfoSpine_Texture = self.SpineRoleUI:UpdateBaseSpine(self.objPet_BaseInfoSpine, Petdata.ArtID, ROLE_SPINE_DEFAULT_ANIM)
        self.objPet_BaseInfoSpine.transform.localScale = DRCSRef.Vec3(130,130,130);
        self.objPet_BaseInfoSpine:SetActive(true)
    end
end


function CollectionUI:OnEnable()
    -- OpenWindowBar({
    --     ['windowstr'] = "CollectionUI", 
    --     ['topBtnState'] = {
    --         ['bBackBtn'] = true,
    --         ['bGoodEvil'] = false,
    --         ['bSilver'] = false,
    --         ['bCoin'] = false,
    --     },
    --     ['bSaveToCache'] = false,
    -- })
end

function CollectionUI:OnDisable()
    self.collectionMartialUI:OnDisable()
    -- RemoveWindowBar('CollectionUI')
    -- LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
end

function CollectionUI:OnDestroy()
    self.collectionMartialUI:OnDestroy()
    self.collectionClanUI:OnDestroy()
    self.spineRoleUINew:Close()
    self.spineRoleUINew = nil
    self.SpineRoleUI:Close()
    self.SpineRoleUI = nil
end

return CollectionUI;