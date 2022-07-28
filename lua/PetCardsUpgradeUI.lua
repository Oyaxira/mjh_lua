PetCardsUpgradeUI = class('PetCardsUpgradeUI', BaseWindow)

local SpineRoleUI = require 'UI/Role/SpineRoleUI'
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'



local NAV_TPYE = {
    RANK = 1,
    GRADE = 2,
    PIECE = 3,
}
local SORT_TPYE = {
    SEQUENCE = 1,
    INVERTE = 2,
}
local TB_Pet 
local COLOR_WHITE = DRCSRef.Color(1, 1, 1, 1)
local COLOR_BlACK = DRCSRef.Color(0, 0, 0, 0.8)

local next_grade = function(igrade, rank)
    igrade = igrade or 0

    --
    local grade = CardsUpgradeDataManager:GetInstance():GetUpgrade(1, rank);
    if igrade >= grade then
        return grade;
    end

    return math.min(igrade + 1,10) 
end
local SORT_NAV_TYPE_FUNC_MAP 
function PetCardsUpgradeUI:ctor()
	local obj = LoadPrefabAndInit('CardsUpgradeUI/PetCardsUpgradeUI', UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
	self.SpineRoleUI = SpineRoleUI.new()
    self.ItemIconUI = ItemIconUI.new()

    TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
end
function PetCardsUpgradeUI:Create()
end
function PetCardsUpgradeUI:Init()
    self.objWindowTabUI = self:FindChild(self._gameObject, 'WindowTabUI')
    self.comButton_back = self:FindChildComponent(self._gameObject, 'TransformAdapt_node_left/Button_back','Button')
    if self.comButton_back then
        self:AddButtonClickListener(self.comButton_back,function ()
            if self.close_to_collection then 
                OpenWindowImmediately("CollectionUI")
            end
            if self.iRetCollectionPoint then 
                SendUpdateCollectionPoint()
            end 
            RemoveWindowImmediately("PetCardsUpgradeUI", false)	
            LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
        end)
    end
    
        --
    self.objActor_BaseInfoSpine = self:FindChild(self._gameObject, 'PetInfo/PetSpinePanal/Base_Actor')
    self.InitScale = self.objActor_BaseInfoSpine.transform.localScale

    self.comEffect_lvup = self:FindChildComponent(self._gameObject, 'PetInfo/PetSpinePanal/ef_lv_up','ParticleSystem')

    self.comText_BaseInfoName =  self:FindChildComponent(self._gameObject, 'PetInfo/PetSpinePanal/Text_Name',"Text")
    
    self.objGradeInfoPanal =  self:FindChild(self._gameObject, 'GradeInfoPanal')
    self.objGradeinfo_1 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/1')
    self.objGradeinfo_2 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/2')
    self.objGradeinfo_3 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/3')
    self.objGradeinfo_4 =  self:FindChild(self.objGradeInfoPanal, 'GradeList/4')



    self.obj_PetHeadsPanal = self:FindChild(self._gameObject,'PetInfo/PetHeadsPanal')
    self.objBtnHeadList =  self:FindChild(self.obj_PetHeadsPanal, 'headlist/Content')

    self.comHeadListLoopScrollView = self:FindChildComponent(self.obj_PetHeadsPanal,"headlist","LoopVerticalScrollRect")
    if self.comHeadListLoopScrollView then
        self.comHeadListLoopScrollView:AddListener(function(...) self:OnHeadListChanged(...) end)
    end

    self.objBtn_GradeUp =  self:FindChild(self.objGradeInfoPanal, 'Button_GradeUP')
    self.ComBtn_GradeUp_text = self:FindChildComponent(self.objBtn_GradeUp,"Text","Text")

    self.objBtn_GradeUp_extext = self:FindChild(self.objGradeInfoPanal,"UpgradeNeeds/1")
    self.objBtn_GradeUp_extext2 = self:FindChild(self.objGradeInfoPanal,"UpgradeNeeds/2")

    self.ComBtn_GradeUpScrollBar_text = self:FindChildComponent(self.objBtn_GradeUp,"Scrollbar/Value","Text")
    self.objBtn_GradeUpScrollBar = self:FindChild(self.objBtn_GradeUp,"Scrollbar")
    self.ComBtn_GradeUpScrollBar = self.objBtn_GradeUpScrollBar:GetComponent("Scrollbar")
    -- self.objBtn_GradeUpScrollBar_shine = self:FindChild(self.objBtn_GradeUp,'Scrollbar/shine')
    self.comBtn_GradeUp = self.objBtn_GradeUp:GetComponent('DRButton')
    if self.comBtn_GradeUp then
        local fun = function()
            self:Onclick_Btn_GradeUp()
        end
        self:AddButtonClickListener(self.comBtn_GradeUp,fun)
    end
    self.objBtn_Use =  self:FindChild(self._gameObject, 'PetInfo/PetSpinePanal/button_use')
    self.comBtn_Use = self.objBtn_Use:GetComponent('DRButton')
    if self.comBtn_Use then
        local fun = function()
            self:Onclick_Btn_Use()
        end
        self:AddButtonClickListener(self.comBtn_Use,fun)
    end
    
    self.objBtn_Info =  self:FindChild(self.obj_PetHeadsPanal, 'Info_Button')
    self.objCanChooseText =  self:FindChild(self.obj_PetHeadsPanal, 'Text')
    self.comBtn_Info = self.objBtn_Info:GetComponent('DRButton')
    if self.comBtn_Info then
        local fun = function()
            self:Onclick_Btn_Info()
        end
        self:AddButtonClickListener(self.comBtn_Info,fun)
    end
    


    self.objPetList = self:FindChild(self._gameObject, 'PetList')
    self.objSC_Panal = self:FindChild(self._gameObject, 'PetList/SC_Panal')
    self.comLoopScrollView = self:FindChildComponent(self.objSC_Panal,"LoopScrollView","LoopVerticalScrollRect")
    if self.comLoopScrollView then
        self.comLoopScrollView:AddListener(function(...) self:OnPetCardChanged(...) end)
    end

    self.CardsMgr = CardsUpgradeDataManager:GetInstance()
    self.GiftsTB = TableDataManager:GetInstance():GetTable("Gift")
    self.comRankInitBG = {}
    for i=1,8 do 
        self.comRankInitBG[i] = self:FindChildComponent(self._gameObject,"PetList/RankBG/"..i,"Image")
    end

    self.objBtnMyPets = self:FindChild(self.objPetList,'button_allprts')
    self.comBtnMyPets = self.objBtnMyPets:GetComponent('DRButton')
    if self.comBtnMyPets then
        local fun = function()
            self:Onclick_Btn_ShowMyPets()
        end
        self:AddButtonClickListener(self.comBtnMyPets,fun)
    end

    self.objMyPetsPanal = self:FindChild(self._gameObject,'MyPetsPanal')
    self.objMyPetsPanal:SetActive(false)
    
    self.comBtnMyPetsPanalClose = self:FindChildComponent(self.objMyPetsPanal,'Button_close','DRButton')
    if self.comBtnMyPetsPanalClose then
        local fun = function()
            self.objMyPetsPanal:SetActive(false)
        end
        self:AddButtonClickListener(self.comBtnMyPetsPanalClose,fun)
    end
    self.comMyPetsLoopScrollView = self:FindChildComponent(self.objMyPetsPanal,"PetsList","LoopVerticalScrollRect")
    if self.comMyPetsLoopScrollView then
        self.comMyPetsLoopScrollView:AddListener(function(...) self:OnMyPetsCardChanged(...) end)
    end
    
    self.rootRankInitlINE = {
        'CardRank/card_rank_white',
        'CardRank/card_rank_green',
        'CardRank/card_rank_blue',
        'CardRank/card_rank_purple',
        'CardRank/card_rank_orange',
        'CardRank/card_rank_golden',
        'CardRank/card_rank_dark-gold',
    }
    self.imgRankInitlINE = {}
    for i ,v in ipairs(self.rootRankInitlINE) do 
        self.imgRankInitlINE[i] = GetSprite(v,typeof(CS.UnityEngine.Sprite))
    end 
	self:AddEventListener("UPDATE_CARDSUPGRADE_UI", function(info)
		self:SetNeedUpdateData(true)
    end)
    
    --讨论区
    self.btnDiscuss = self:FindChildComponent(self._gameObject,"Button_discuss","Button")
    if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_PET) then
        self.btnDiscuss.gameObject:SetActive(true)
        self:AddButtonClickListener(self.btnDiscuss, function()
            local targetId = self:GetCurPetCardData().rootid
            if (targetId == nil) then
                targetId = self:GetCurPetCardData().Petid
            end
            local articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_PET,targetId)
            if (articleId == nil) then
                SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
            else
                OpenWindowImmediately("DiscussUI",articleId)
            end
        end)
    else
        self.btnDiscuss.gameObject:SetActive(false)
    end
end
function PetCardsUpgradeUI:RefreshUI(info)
    -- self.allPetCardList = self.CardsMgr:GetEntirePetCardList()
    self:InitDataList()
    self.close_to_collection = info
    self:InitMapItemPet()
end
function PetCardsUpgradeUI:Update()
    if self.iNeedUpdateData then 
        self.iNeedUpdateData = false
        self:InitDataList(true)
    end
    if self.iUpdateFlag == 1 then 
        -- 刷新列表
        dprint('PetCardsUpgradeUI  .. Update  1 RefreashList')
        self.iUpdateFlag = 0
        self:RefreashList()
    elseif self.iUpdateFlag == 2 then 
        -- 刷新属性
        dprint('PetCardsUpgradeUI  .. Update  2 RefreashInfo')
        self.iUpdateFlag = 0
        self:RefreashInfo()
        self:RefreashGradeInfo()
    end 
end
-- 刷新整个界面
function PetCardsUpgradeUI:SetNeedUpdateData(bool)
    self.iNeedUpdateData = bool
    self.iRetCollectionPoint = true
end
function PetCardsUpgradeUI:func_get_sort_num(petdata,indexroot )
        local ineed = self.CardsMgr:GetGradeNeedPiece(next_grade(petdata.grade, petdata.rank),true)
        if petdata.chain and #petdata.chain ~= 0 then 
            if petdata.grade == 0 and petdata.piece == 0 then 
                return 1
            elseif petdata.grade <= 4 then 
                if  ineed <= petdata.piece then 
                    return petdata.grade == 4 and 4 or 3
                else 
                    return 2
                end
            elseif indexroot then 
                local max = 2
                for index,chidid in ipairs(petdata.chain) do
                    local num_a = self:func_get_sort_num(self:GetCurPetCardData(indexroot,index + 1))
                    max = math.max(num_a,max)
                end 
                return max 
            else 
                return 1
            end
        else 
            local petexcel = petdata.Petdata
            if petexcel == nil then 
                return 1 
            end
            local ineed_jinjie = 0
            local iUnlockBaseGrade = math.max(petdata.grade,5 )
            local iNextGrade = next_grade(iUnlockBaseGrade, petdata.orgRank)
            if petexcel and petexcel.cardItem2 and petexcel.cardItem2 ~= 0 then 
                ineed_jinjie = self.CardsMgr:GetGradeNeedPiece(iNextGrade,true,true)
            end
            if petdata.grade == iNextGrade then 
                return 0 
            end
            if petdata.grade < 6 and not petdata.unlock then 
                ineed = 0 
            end 
            if ineed_jinjie <= petdata.piece and petdata.unlock and ineed <= petdata.root_piece then 
                if petdata.grade <= 5 then 
                    return 5 
                elseif petdata.grade == 10 then 
                    return 2
                else
                    return 3
                end 
            else 
                return 2
            end 
        end 
    end
-- init data list and level(PIECE) to show
function PetCardsUpgradeUI:InitDataList(brefreash)
    self.allPetCardList = self.CardsMgr:GetEntirePetCardList()

    self.dataPetCardList = {}
    self.mapPetCardList ={} -- 宠物id 索引
    for iPetid,instdata in pairs(self.allPetCardList) do
        if iPetid and TB_Pet[iPetid] and instdata.chain and #instdata.chain > 0 then 
            table.insert(self.dataPetCardList,{
                Petid = iPetid,
                Petdata = TB_Pet[iPetid],
                grade = instdata.level or 0,
                piece = instdata.piece or 0,
                ifchose = instdata.ifchose,
                root_piece = instdata.root_piece,
                choseid = instdata.choseid,
                chain = instdata.chain,
                rootid = instdata.rootid,
                rank = TB_Pet[iPetid].Rank,
                index = #self.dataPetCardList + 1,
                unlock = instdata.unlock
            })
            self.mapPetCardList[iPetid] = self.dataPetCardList[#self.dataPetCardList]
        end 
    end

    if self.bNoNeedResort then 
        for i=1,#self.sort_list do
            local sortinfo = self.sort_list[i]
            local iPetid = sortinfo.iPetid
            self.mapPetCardList[iPetid].sort_num = sortinfo.sort_num
            self.sort_list[i].cardlist_index = self.mapPetCardList[iPetid].index
        end
    else
        self.bNoNeedResort = false
        self.sort_list = {}
        local temptable = {}
        for i,petdata in ipairs(self.dataPetCardList) do 
            local sort_num = self:func_get_sort_num(petdata,i)
            if sort_num > 1 then 
                self.bNoNeedResort = true 
            end
            table.insert( self.sort_list, {
                cardlist_index = i,
                sort_num = sort_num,
                iPetid = petdata.Petid,
            })
            petdata.sort_num = sort_num 
        end
        table.sort(self.sort_list,function(a,b)
            return a.sort_num > b.sort_num
        end)
        if self.bNoNeedResort and self.pet_choose_num == 1 then 
            self.data_Chose_Index = nil
            if self.old_choseid then 
                for i,v in ipairs(self.sort_list) do 
                    if v and v.iPetid == self.old_choseid then 
                        self.data_Chose_Index = v.cardlist_index
                        break
                    end
                end 
            end 
            if not self.data_Chose_Index then 
                self.data_Chose_Index = self.sort_list[1].cardlist_index
            end 
            -- self.pet_choose_num = self:Get_First_ChoseIndex() 
            self.need_change_petindex = true
        end

    end 
    if self.need_change_petindex then 
        self.pet_choose_num = self:Get_First_ChoseIndex() 
        self.need_change_petindex = false 
    end 
        
    self.iUpdateFlag = 1
end
-- chose the first DATA AS INIT ONE
function PetCardsUpgradeUI:RefreashList()
    local sort_func 
    local tar_list 
    if self.comLoopScrollView then
        self.obj_card_list = {}
        self.comLoopScrollView.totalCount = getTableSize(self.dataPetCardList)
        self.comLoopScrollView:RefillCells()
        self:RefreashChoseCard()
    end 
    if #self.dataPetCardList > 0 and self.data_Chose_Index == nil then 
        self.data_Chose_Index = self.sort_list[1].cardlist_index
        self.pet_choose_num = self:Get_First_ChoseIndex(self.data_Chose_Index)
    end 
    self.iUpdateFlag = 2
    
    self:RefreashChoseCard()
end
function PetCardsUpgradeUI:OnMyPetsCardChanged(gameobj,index)
    
    local objPetCardItem = gameobj.gameObject
    local instdata = self.datas_MyPetsAll[index + 1]

    local str_Petname = GetLanguageByID(instdata.Petdata.NameID) or ''
    local comName = self:FindChildComponent(objPetCardItem,'Name','Text')
    comName.text = getRankBasedText(instdata.Petdata.Rank,str_Petname .. '宠物卡')

    local comBtnImage = self:FindChildComponent(objPetCardItem,'ItemIconUI','DRButton')
    -- self:RemoveButtonClickListener(comBtnImage)
    -- self:AddButtonClickListener(comBtnImage,function()
    --     local str_tips = {}
    --     local str_tile = string.format('《%s》宠物卡',str_Petname)
    --     str_tips.title = getRankBasedText(instdata.Petdata.Rank,str_tile)
    --     local petdata = self.allPetCardList[instdata.Petid]
    --     if not petdata then return end 
    --     if not petdata.rootid  then 
    --         str_tips.content = string.format('  获得宠物%s,如已有该宠物，可消耗一定数量在成就-宠物界面提升宠物的修行等级。',str_Petname)
    --     else
    --         local rootid = petdata.rootid
    --         local excelpet = TB_Pet[rootid or 0]
    --         local str_PetnameRoot = GetLanguageByID(excelpet.NameID) or ''
    --         str_tips.content = string.format("  宠物%s的修行等级达到5级时，可在成就-宠物界面使用本卡解锁新造型“%s”。", str_PetnameRoot,str_Petname)
    --     end 
    --     OpenWindowImmediately("TipsPopUI", str_tips)
    -- end)

    local itemdata = self.map_petid_2_itemdata[instdata.Petid]
    self.ItemIconUI:UpdateUIWithItemTypeData(comBtnImage.gameObject, itemdata)
    local comNum = self:FindChildComponent(objPetCardItem,'ItemIconUI/Num','Text')
    comNum.text = instdata.piece or 0

end
function PetCardsUpgradeUI:InitMapItemPet()
    local TB_Item = TableDataManager:GetInstance():GetTable("Item") or {}
    self.map_petid_2_itemdata = {}
    for i,item in pairs(TB_Item) do 
        if item.EffectType == EffectType.ETT_PetCard and item.Value1 then 
            self.map_petid_2_itemdata[tonumber(item.Value1)] = item
        end 
    end 
end 
function PetCardsUpgradeUI:OnPetCardChanged(gameobj,index)
    
    index = self.sort_list[index + 1].cardlist_index
    local dataitem = self:GetCurPetCardData(index,0)
    local objPetCardItem = gameobj.gameObject
    local objInfo = self:FindChild(objPetCardItem,'Info')
    local comImgBG = self:FindChildComponent(objPetCardItem,"ImgBG","Image") 
    local comImgRankUP = self:FindChildComponent(objPetCardItem,"Rank/Image_up","Image") 
    local comImgRankDOWN = self:FindChildComponent(objPetCardItem,"Rank/Image_down","Image") 

    self.obj_card_list = self.obj_card_list or {}
    self.obj_card_list[index] = objPetCardItem

    if not dataitem then 
        comImgBG.sprite = self.comRankInitBG[8] and self.comRankInitBG[8].sprite
        comImgRankUP.sprite = self.imgRankInitlINE[1]
        comImgRankDOWN.sprite = self.imgRankInitlINE[1]
        objInfo:SetActive(false)
        return 
    end 
    local iRank = dataitem.rank or 1
    if iRank == 0 then iRank = 1 end
    comImgBG.sprite = self.comRankInitBG[iRank] and self.comRankInitBG[iRank].sprite
    comImgRankUP.sprite = self.imgRankInitlINE[iRank]
    comImgRankDOWN.sprite = self.imgRankInitlINE[iRank]
    objInfo:SetActive(true)

    local ComText_title = self:FindChildComponent(objPetCardItem,"Info/Text_title","Text")
    local str_Petname = GetLanguageByID(dataitem.Petdata.NameID) or ''
    if str_Petname == '' then 
        str_Petname = '无'
    end
    if dataitem.grade and dataitem.grade > 0 then 
        str_Petname = str_Petname .. '+' .. dataitem.grade 
    end
    ComText_title.text =  str_Petname
    ComText_title.color = getRankColor(dataitem.Petdata.Rank)

    -- local ComText_grade = self:FindChildComponent(objPetCardItem,"Info/Text_grade","Text")
    -- ComText_grade.text =  string.format('+%d  ',dataitem.grade or 0)
    -- ComText_grade.color = getRankColor(dataitem.Petdata.Rank)

    local ComScrollBar_text = self:FindChildComponent(objPetCardItem,"Info/Scrollbar/Value","Text")
    local ComScrollBar = self:FindChildComponent(objPetCardItem,"Info/Scrollbar","Scrollbar")
    local ineed = self.CardsMgr:GetGradeNeedPiece(next_grade(dataitem.grade, dataitem.orgRank),true)
    local ipiece = dataitem.root_piece or dataitem.piece or 0
    ComScrollBar_text.text  = ipiece .. '/' .. ineed
    ComScrollBar.size = ipiece / ineed
    local obj_imageup = self:FindChild(objPetCardItem,'img_up')
    local rootitem = self:GetCurPetCardData(index,1)

    local sort_num = self:func_get_sort_num(rootitem,rootitem and rootitem.index)
    obj_imageup:SetActive(sort_num > 2)

    local ComImage_imgCG = self:FindChildComponent(objPetCardItem,"Info/head","Image")
    
    if ComImage_imgCG then 
        local kModledata = TableDataManager:GetInstance():GetTableData("RoleModel", dataitem.Petdata.ArtID)
        if kModledata then
            local kPath = kModledata.Head or ""
            ComImage_imgCG.sprite = GetSprite(kPath)
        end
    end
    local obj_imagelock = self:FindChild(objPetCardItem,'img_lock')
    obj_imagelock:SetActive(not dataitem.unlock)

    local comDRButton = self:FindChildComponent(objPetCardItem,"ImgBG","DRButton") 
    local comdark = self:FindChild(objPetCardItem,'ImgBG_chose')
    self:RemoveButtonClickListener(comDRButton)
    self:AddButtonClickListener(comDRButton, function() 
        self:OnClick_Chose_Card(index)
        if comdark then 
            comdark:SetActive(true)
        end
    end)
    if comdark then 
        comdark:SetActive( index == self.data_Chose_Index)
    end
    
    ---  TODO: 碎片
end
function PetCardsUpgradeUI:OnClick_Chose_Card(index)
    self.data_Chose_Index = index 
    self.pet_choose_num = self:Get_First_ChoseIndex(index)
    self.iUpdateFlag = 2
    self.old_choseid = nil
    self.old_grade = nil
    self:RefreashChoseCard()
end
function PetCardsUpgradeUI:RefreashChoseCard()
    if self.obj_card_list then 
        -- TODO 优化列表
        for i,v in pairs(self.obj_card_list) do 
            local com = self:FindChild(v,'ImgBG_chose')
            if com then 
                com:SetActive(false)
            end
        end 
        if self.obj_card_list[self.data_Chose_Index] then 
            local com = self:FindChild(self.obj_card_list[self.data_Chose_Index],'ImgBG_chose')
            if com then 
                com:SetActive(true)
            end
        end 
    end  
end
function PetCardsUpgradeUI:Get_First_ChoseIndex(index)
    local dataitem = self:GetCurPetCardData(index,1)
    if dataitem then 
        if dataitem.grade >= 5 then 
            if dataitem.chain and #dataitem.chain > 0 then 
                if dataitem.choseid then 
                    for iret,childid in ipairs(dataitem.chain) do 
                        if childid == dataitem.choseid then 
                            return iret + 1 
                        end 
                    end 
                    return 2
                end
            end
        end
    end 
    return 1
end 
function PetCardsUpgradeUI:RefreashInfo()
    local dataitem = self:GetCurPetCardData()
    local str_Petname = GetLanguageByID(dataitem.Petdata.NameID) or ''
    if str_Petname == '' then 
        str_Petname = '无'
    end
    local icur_grade = dataitem.grade or 0
    if dataitem.rootid and icur_grade == 0 then 
        icur_grade = 5 
    end

    if icur_grade > 0 then 
        str_Petname =  string.format('%s +%d  ',str_Petname,icur_grade)
    end 
    if self.old_grade then 
        if self.old_grade < dataitem.grade then 
            if self.old_grade == 4 then 
                self:ShowJinJieBox(dataitem)
            end 
            self.comEffect_lvup.gameObject:SetActive(true)
            self.comEffect_lvup:Play()
            self.old_grade = nil
        end
    end 
    self.comText_BaseInfoName.text = str_Petname
    self.comText_BaseInfoName.color = getRankColor(dataitem.Petdata.Rank)

    self.objActor_BaseInfoSpine_Texture = self.SpineRoleUI:UpdateBaseSpine(self.objActor_BaseInfoSpine, dataitem.Petdata.ArtID, ROLE_SPINE_DEFAULT_ANIM)
    self.objActor_BaseInfoSpine.transform.localScale = DRCSRef.Vec3(self.InitScale.x,self.InitScale.y,self.InitScale.z);
    self.objActor_BaseInfoSpine:SetActive(true)


    self.objBtn_Info:SetActive(false)
    self.objCanChooseText:SetActive(true)
    if dataitem.chain and #dataitem.chain > 0 then 
        if dataitem.grade <= 5 then 
            -- self.objBtn_Info:SetActive(true)
            self.objCanChooseText:SetActive(false)
        end
        self.objBtn_Use:SetActive(false)
    elseif dataitem.ifchose or not dataitem.unlock then 
        self.objBtn_Use:SetActive(false)
    else 
        self.objBtn_Use:SetActive(dataitem.grade ~= 0)
    end 

    -- local PlatShowInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo() or {}
    -- local iCurShowID = PlatShowInfo.showPetID or 0
    -- self.objBtn_Show:SetActive(dataitem.unlock and iCurShowID ~= dataitem.Petid)

    --  刷新下方按钮
    --  如果是没等级的根 解锁 
    --  如果是没等级的子 进阶 显示额外 
    --  如果材料不够 前面加不可 
    --  如果是子 再加进阶的需求

    local ineed = self.CardsMgr:GetGradeNeedPiece(next_grade(dataitem.grade, dataitem.orgRank),true)
    local ipiece = dataitem.root_piece or dataitem.piece or 0
    local string_base = '升级'
    local string_ex
    local string_ex2 
    local bool_ex = false 
    local bool_ex2 = false 
    
    self.str_unabletoast = nil
    self.ComBtn_GradeUp_text.alignment = CS.UnityEngine.TextAnchor.MiddleCenter

    if dataitem.grade == next_grade(dataitem.grade, dataitem.orgRank) then 
        string_base = '已满级'
        self.str_unabletoast = '已满级'
    elseif dataitem.chain and #dataitem.chain > 0 then 
        -- 初始宠物
        local strName = GetLanguageByID(dataitem.Petdata.NameID)
        string_ex = string.format( "%s宠物卡(%d/%d)",strName,dataitem.piece,ineed)
        bool_ex = dataitem.piece >= ineed
        if dataitem.piece < ineed then 
            self.str_unabletoast = string.format( "《%s》宠物卡不足",strName)
        end
    else
        -- 进阶宠物
        local petexcel = dataitem.Petdata
        local root_id = dataitem.rootid
        local rootexcel = self.mapPetCardList and self.mapPetCardList[root_id] and self.mapPetCardList[root_id].Petdata
        local ineed_jinjie = 0

        local strNameRoot = GetLanguageByID(rootexcel.NameID)
        local strNameChild = GetLanguageByID(petexcel.NameID)

        string_ex = string.format( "%s宠物卡(%d/%d)",strNameRoot,dataitem.root_piece,ineed)
        bool_ex = dataitem.root_piece and dataitem.root_piece > ineed

        if petexcel and petexcel.cardItem2 and petexcel.cardItem2 ~= 0 then 
            ineed_jinjie = self.CardsMgr:GetGradeNeedPiece(next_grade(math.max(dataitem.grade,5), dataitem.rank),true,true)
        end
        if dataitem.grade < 5 then 
            string_base = '解锁'
            string_ex = nil
            bool_ex = false
        elseif dataitem.root_piece and dataitem.root_piece < ineed then 
            self.str_unabletoast = string.format( "《%s》宠物卡不足",strNameRoot)
        end
        if dataitem.piece and dataitem.piece < ineed_jinjie then 
            if self.str_unabletoast then 
                self.str_unabletoast = string.format( "《%s》宠物卡，%s",strNameChild,self.str_unabletoast)
            else 
                self.str_unabletoast = string.format( "《%s》宠物卡不足",strNameChild)
            end
        end
        

        if ineed_jinjie > 0 then 
            string_ex2 = string.format( "%s宠物卡(%d/%d)",strNameChild,dataitem.piece or 0,ineed_jinjie )
            bool_ex2 = dataitem.piece and dataitem.piece >= ineed_jinjie 
        end
    end
    if self.str_unabletoast ~= nil then 
        if string_base ~= '已满级' then 
            string_base = '不可' .. string_base 
        end
        setUIGray(self.objBtn_GradeUp:GetComponent('Image'), true)
    else
        setUIGray(self.objBtn_GradeUp:GetComponent('Image'), false)
    end 
    local funcsetneed = function(obj,strText,boolfit)
        if strText ~= nil then 
            obj:SetActive(true)
            local comtext = self:FindChildComponent(obj,'EX_Text','Text')
            if comtext then 
                comtext.text = strText 

            end
            local comImage = self:FindChildComponent(obj,"img", DRCSRef_Type.Image)
            if comImage then 
                if boolfit then 
                    comImage.color = COLOR_VALUE[COLOR_ENUM.Douzi_brown]
                else
                    comImage.color = COLOR_VALUE[COLOR_ENUM.White]
                end
            end
            if comtext then 
                comtext.text = strText 
            end
        else
            obj:SetActive(false)
        end 
    end 
    self.ComBtn_GradeUp_text.text = string_base
    funcsetneed(self.objBtn_GradeUp_extext,string_ex,bool_ex)
    funcsetneed(self.objBtn_GradeUp_extext2,string_ex2,bool_ex2)

    local comobj = self:FindChildComponent(self.objGradeInfoPanal,"UpgradeNeeds",'RectTransform')
    if comobj then 
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(comobj)
    end
    ------------------------ 刷新宠物进化链头像
    -- local func_init_head = function(obj,instdata,boolchose) 
        
    -- end
    -- 抽单独的函数 刷新头像列表 别的info都是 改下结构
    -- for i=1,5 do 
    --     self._obj_pet_head[i]:SetActive(false)
    -- end 
    dataitem = self:GetCurPetCardData(nil,1)
    if dataitem.grade < 5 then 
        self.obj_PetHeadsPanal:SetActive(false)
    else 
        
        self.obj_PetHeadsPanal:SetActive(true)
        self.datas_HeadList = {}
        local chain = dataitem.chain or {}
        for i=1,#chain do 
            local instdataL = self:GetCurPetCardData(nil,i+1)
            -- if instdataL.unlock then 
                table.insert( self.datas_HeadList,instdataL)
            -- end 
            -- func_init_head(self._obj_pet_head[i+1],self:GetCurPetCardData(nil,i+1),self.pet_choose_num == i + 1)
        end
        
        self.comHeadListLoopScrollView.totalCount = getTableSize(self.datas_HeadList)
        self.comHeadListLoopScrollView:RefillCells()
    end
end
function PetCardsUpgradeUI:OnHeadListChanged(obj,index)
    obj = obj.gameObject
    local instdata = self.datas_HeadList[index+1]
    if not instdata or not instdata.unlock then 
        obj:SetActive(false)
        return 
    else
        obj:SetActive(true)
    end
    local kModledata = TableDataManager:GetInstance():GetTableData("RoleModel", instdata.Petdata.ArtID)
    local headImage = self:FindChildComponent(obj,"Mask/Image","Image")
    local headimg_up = self:FindChild(obj,"img_up")
    local headimg_lock = self:FindChild(obj,"Mask/img_lock")
    local headimg_chose = self:FindChild(obj,"img_chose")
    local headimg_Using = self:FindChild(obj,"imgUsing")
    local comHeadName = self:FindChildComponent(obj,"nameinfo/Name","Text")

    local str_Petname = GetLanguageByID(instdata.Petdata.NameID) or ''

    comHeadName.text = str_Petname
    comHeadName.color = getRankColor(instdata.Petdata.Rank)

    local combtnchoose = self:FindChildComponent(obj,'Btn_choose',"DRButton")
    if combtnchoose then 
        self:RemoveButtonClickListener(combtnchoose)
        self:AddButtonClickListener(combtnchoose,function ()
            self:Onclick_Btn_HeadCard(index+2)
        end)
    end 
    local objUnlock = self:FindChild(obj,'nameinfo/Unlock')
    if  instdata.chain and #instdata.chain > 0 then 
        objUnlock:SetActive(false)
    elseif instdata.grade < 5 then 
        objUnlock:SetActive(true)
    else
        objUnlock:SetActive(false)
    end 

    if headImage and kModledata then
        local kPath = kModledata.Head or ""
        headImage.sprite = GetSprite(kPath)
    end
    obj:SetActive(true)
    local sortindex = self:func_get_sort_num(instdata)
    headimg_up:SetActive(sortindex > 2)
    headimg_lock:SetActive(false)
    headimg_Using:SetActive(instdata.ifchose)
    if headImage and instdata.unlock then 
        headImage.color = COLOR_WHITE
    else 
        headimg_lock:SetActive(true)
        headImage.color = COLOR_BlACK
    end 
    headimg_chose:SetActive((self.pet_choose_num == index + 2) or false )
end
function PetCardsUpgradeUI:RefreashGradeInfo()
    local dataitem = self:GetCurPetCardData()
    local ibaseid = dataitem.Petid
    local icur_grade = dataitem.grade or 0
    if dataitem.rootid then 
        icur_grade = math.max( 5,icur_grade )
    end
    local bool_fit = self.str_unabletoast == nil and true or false 
    local _info = self.CardsMgr:GetPetCardDesc(ibaseid,icur_grade,bool_fit)
    
    local boolhide = false 
    for i=1,4 do 
        local info = _info[i]
        if not info then boolhide = true end 
        info = info or {}
        if boolhide then 
            info.lock = false 
            info.up = false 
            info.num = false 
            info.basedesc = ''
            info.nextNum = ''
        end
        if info and info.lock then 
            boolhide = true 
        end
        -- 
        if (dataitem.grade == 0 or not dataitem.unlock) and icur_grade == 5 and info.basedesc ~= '' then 
            if  info.lock then
                info.lock = false 
                info.up = false 
                info.num = false 
                info.basedesc = ''
                info.nextNum = ''
            else
                info.lock = true 
                info.up = true
                info.num = true 
                info.nextNum = '解锁'
            end

        end
        self:RefreashGradeInfoPerLine(self['objGradeinfo_'..i],info)
    end 
    
end
function PetCardsUpgradeUI:RefreashGradeInfoPerLine(obj,info)
    if not obj then return end 
    info = info or {}
    local strBase = info.basedesc
    local strNext = info.nextNum
    local bLockVisble = info.lock
    local bUpVisble = info.up
    local bNumVisble = info.num

    local com_base = self:FindChildComponent(obj,'Text_base','Text') 
    com_base.text = strBase
    if bNumVisble then 
        local com_next = self:FindChildComponent(obj,'Text_next','Text') 
        com_next.text = strNext
    end
    local obj_next = self:FindChild(obj,'Text_next')
    obj_next:SetActive(bNumVisble)
    local obj_img_add = self:FindChild(obj,'img_add')
    obj_img_add:SetActive(bUpVisble)
    local obj_img_lock = self:FindChild(obj,'img_lock')
    obj_img_lock:SetActive(bLockVisble)
    -- lock up
    -- 230 166 
    -- 176 220
    local vec3_up
    local vec3_lock
    if bUpVisble and bLockVisble then 
        vec3_lock = DRCSRef.Vec3(155,0,0)
        vec3_up = DRCSRef.Vec3(199,0,0)
    else
        vec3_lock = DRCSRef.Vec3(230,0,0)
        vec3_up = DRCSRef.Vec3(166,0,0)

    end 
    obj_img_lock:GetComponent('RectTransform').localPosition = vec3_lock
    obj_img_add:GetComponent('RectTransform').localPosition = vec3_up
end 
function PetCardsUpgradeUI:Onclick_Btn_GradeUp()
    local dataitem_root = self:GetCurPetCardData(nil,1)
    local dataitem = self:GetCurPetCardData()
    local cardid = dataitem.Petid 

    --
    if dataitem.grade >= self.CardsMgr:GetUpgrade(1, dataitem.orgRank) then
        SystemUICall:GetInstance():Toast("已达等级上限")
        return;
    end

    if self.str_unabletoast then 
        SystemUICall:GetInstance():Toast(self.str_unabletoast)
        return 
    end
    if cardid and cardid ~= 0 then 
        -- TODO: 统一接口
        if dataitem_root ~= dataitem then 
            if dataitem.grade == 0 then 
                if dataitem_root.grade >= 5 then  
                    SendRequestRolePetCardOperate(RPCRT_PET_CARD, RPCOT_EVOLVE_PET_CARD, dataitem_root.Petid, cardid)
                end
            else 
                SendRequestRolePetCardOperate(RPCRT_PET_CARD, RPCOT_LEVEL_UP_PET_CARD, cardid, 0)
            end
        else
            SendRequestRolePetCardOperate(RPCRT_PET_CARD, RPCOT_LEVEL_UP_PET_CARD, cardid, 0)
            self.need_change_petindex = dataitem.grade < 5
        end 
    end
    self.old_choseid = dataitem_root.Petid
    self.old_grade = dataitem.grade
end
function PetCardsUpgradeUI:Onclick_Btn_Use()
    local dataitem_root = self:GetCurPetCardData(nil,1)
    local dataitem = self:GetCurPetCardData()
    local cardid = dataitem.Petid 
    if cardid and cardid ~= 0 then 
        -- TODO: 统一接口
        SendRequestRolePetCardOperate(RPCRT_PET_CARD, RPCOT_SET_USE_PET_CARD, dataitem_root.Petid, cardid) 

        -- TODO 
        self:ResetPetToBattle(cardid);
    end
end
function PetCardsUpgradeUI:Onclick_Btn_Info()
    local dataitem_root = self:GetCurPetCardData(nil,1)
    -- local dataitem = self:GetCurPetCardData()
    local cardid = dataitem_root.Petid 
    if dataitem_root  then 
        if dataitem_root.chain and #dataitem_root.chain > 0 then 
            local content = {'该宠物拥有以下进阶宠物卡，宠物修行等级达到5级时可用于解锁对应造型','  '}
            for i,childid in ipairs(dataitem_root.chain) do 
                local childdata = self:GetCurPetCardData(nil,i+1)
                local child = childdata.Petdata 
                if childdata.piece and childdata.piece > 0 then 
                    local str_Petname = GetLanguageByID(child.NameID) or ''
                    if str_Petname == '' then 
                        str_Petname = '无'
                    end
                    if child and childdata.rank then 
                        content[#content+1] = string.format("%s <color=#FFFFFF>：%d</color>", getRankBasedText(childdata.rank, str_Petname), childdata.piece)
                    end 
                end 
            end 
            if #content == 2 then 
                content[#content+1] = '<color=#A0A09E>该宠物暂未收集到进阶宠物卡</color>'
            end
            local tips = {
                ['title'] = '进阶宠物卡',
                ['content'] = table.concat( content, "\n" )
            }
            OpenWindowImmediately("TipsPopUI", tips)
        end 
    end 
end
function PetCardsUpgradeUI:Onclick_Btn_ShowMyPets()
    self.objMyPetsPanal:SetActive(true)

    -- if not self.datas_MyPetsAll then 
    self.datas_MyPetsAll = {}
    for iPetid,instdata in pairs(self.allPetCardList) do 
        if instdata.piece and instdata.piece > 0 then 
            table.insert( self.datas_MyPetsAll, {
                Petid = iPetid,
                Petdata = TB_Pet[iPetid],
                piece = instdata.piece,
            })
        end
    end 
    -- end 
    if self.comMyPetsLoopScrollView then
        self.comMyPetsLoopScrollView.totalCount = getTableSize(self.datas_MyPetsAll)
        self.comMyPetsLoopScrollView:RefillCells()
        self:RefreashChoseCard()
    end 
end
function PetCardsUpgradeUI:Onclick_Btn_Show()
    local dataitem_root = self:GetCurPetCardData(nil,1)
    local dataitem = self:GetCurPetCardData()
    local cardid = dataitem.Petid 
    if cardid and cardid ~= 0 then 
        SendRequestRolePetCardOperate(RPCRT_PET_CARD, RPCOT_SET_PLAT_SHOW_PET_CARD, cardid, 0) 
    end
end
function PetCardsUpgradeUI:Onclick_Btn_HeadCard(i)
    self.pet_choose_num = i 
    self.iUpdateFlag = 2
end
-- 统一用该接口获取 当前展示的宠物卡信息
function PetCardsUpgradeUI:GetCurPetCardData(iIndex,ifenzhi)
    if not self.dataPetCardList or not self.allPetCardList then 
        self:InitDataList()
    end
    iIndex = iIndex or self.data_Chose_Index  
    ifenzhi = ifenzhi or self.pet_choose_num or self:Get_First_ChoseIndex(iIndex) 
    local rootpetdata = self.dataPetCardList[iIndex] or {}
    if ifenzhi == 1 then 
        -- 本身
        return rootpetdata 
    end 
    -- 
    local iShowID = 1
    if ifenzhi == 0 then 
        iShowID = rootpetdata and rootpetdata.choseid
    else 
        local chain = rootpetdata and rootpetdata.chain
        if chain and #chain > 0 and chain[ifenzhi-1] then 
            iShowID = chain[ifenzhi-1] 
        end 
    end
    local instdata = self.allPetCardList[iShowID]
    if instdata then 
        local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
        return {
            Petid = iShowID,
            Petdata = TB_Pet[iShowID],
            grade = instdata.level or 0,
            piece = instdata.piece or 0,
            ifchose = instdata.ifchose,
            unlock = instdata.unlock or false,
            root_piece = instdata.root_piece,
            rootid = instdata.rootid,
            rank = TB_Pet[iShowID].Rank,
            sort_num = rootpetdata.sort_num or 0,
            orgRank = rootpetdata.rank,
        }
    end
    return {}
end

function PetCardsUpgradeUI:ShowJinJieBox(dataitem)
    local rootid = dataitem.rootid
    local rootitem = self.mapPetCardList and self.mapPetCardList[rootid]
    local rootexcel = rootitem and rootitem.Petdata
    local petexcel = dataitem.Petdata

    if not rootexcel or not petexcel then 
        return 
    end
    local tipscontent = ''

    local strNameRoot = GetLanguageByID(rootexcel.NameID)
    tipscontent = string.format( "恭喜，%s的修行等级提升到了5级<color=%s>",strNameRoot,UI_COLOR_STR['green'])

    local strNameChild = GetLanguageByID(petexcel.NameID)
    tipscontent = string.format( "%s\n\n进化为新的造型%s",tipscontent,strNameChild)
    
    tipscontent = string.format( "%s\n宠物品质提升",tipscontent)
    tipscontent = string.format( "%s\n解锁新的助战能力",tipscontent)
    tipscontent = string.format( "%s\n可以更换本宠物的造型了",tipscontent)

    tipscontent = string.format( "%s</color>",tipscontent)

    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {text = tipscontent,title = '修行等级提升'}})
end

function PetCardsUpgradeUI:OnDisable()

end
function PetCardsUpgradeUI:OnEnable()
end
function PetCardsUpgradeUI:OnDestroy()
    self:RemoveEventListener('UPDATE_CARDSUPGRADE_UI')
    self.ItemIconUI:Close()

end

function PetCardsUpgradeUI:ResetPetToBattle(petTypeID)
	local akRoleEmbattle = RoleDataManager:GetInstance():GetRoleEmbattleInfo();
    local akPetBaseTable = CardsUpgradeDataManager:GetInstance():GetEntirePetCardList();
	if akRoleEmbattle[EmBattleSchemeType.EBST_ArenaHelp] then
        local embattleData = akRoleEmbattle[EmBattleSchemeType.EBST_ArenaHelp][1];
		local temp = {};
		for i = 1, #(embattleData) do
			if akPetBaseTable[embattleData[i].uiRoleID].rootid == akPetBaseTable[petTypeID].rootid then
				embattleData[i].uiRoleID = petTypeID;
				temp[i - 1] = embattleData[i];
			end
		end
	end
end

return PetCardsUpgradeUI;