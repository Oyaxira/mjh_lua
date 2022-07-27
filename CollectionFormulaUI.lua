CollectionFormulaUI = class('CollectionFormulaUI', BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

-- local FORMULA_NAV_TAGS = {'所有','剑','刀','拳','手杖','棍','针匣','扇','衣服','鞋子','饰品','菜肴','医术','暗器','任务'}
local FORMULA_NAV_TAGS = {'所有','剑','刀','拳套','护腿','棍','针匣','扇','衣服','鞋子','饰品','神器','暗器','丹药','菜肴','任务'}

local FORMULA_NAV_CHILD_MAP = {
}
local MAINROLEID = 1
-- ItemTypeDetail_Revert
local TB_ITEM 

function CollectionFormulaUI:ctor()
    self.bindBtnTable = {}
    TB_ITEM = TableDataManager:GetInstance():GetTable("Item") or {}
    
    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
end
function CollectionFormulaUI:SetParent(parent)
    self.parent = parent
end
function CollectionFormulaUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/CollectionFormulaUI', self.parent or UI_UILayer, true);
    if obj then
        self:SetGameObject(obj)
	end
end
function CollectionFormulaUI:Init()
    self.colorTabOnClick = DRCSRef.Color(0.91, 0.91, 0.91, 1)
    self.colorTabUnClick = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1)
    -- self.objButton_back = self:FindChild(self._gameObject, 'Button_back')
    self.comBtn_back = self:FindChildComponent(self._gameObject ,'TransformAdapt_node_left/Button_back','DRButton')
    if self.comBtn_back then 
        self:AddButtonClickListener(self.comBtn_back,function()
            if self.close_to_collection then 
                OpenWindowImmediately("CollectionUI")
            end 
            RemoveWindowImmediately("CollectionFormulaUI", false)
            LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
        end)
    end 
    self.objSCNavLeftlist = self:FindChild(self._gameObject, 'Info_Box/SC_nav/Viewport/Content')
    self.objSCNavLeftitem = self:FindChild(self._gameObject, 'Info_Box/SC_nav/FormulaNavItem')
    self.objSCNavLeftitem:SetActive(false)
    self.objSCNavLeftChild = self:FindChild(self._gameObject, 'Info_Box/SC_nav/FormulaNavChild')
    self.objSCNavLeftChild:SetActive(false)
    self.toggleGroupNavLeft = self.objSCNavLeftlist:GetComponent("ToggleGroup")


    self.comTextUnlockRecord = self:FindChildComponent(self._gameObject,'Info_Box/TMP_unlock','Text')

    self.objSCFormulalist = self:FindChild(self._gameObject, 'Info_Box/Formula_box/SC_formula/Viewport/Content')
    self.comLoopScrollView = self:FindChildComponent(self._gameObject,"Info_Box/Formula_box/SC_formula","LoopVerticalScrollRect")
    if self.comLoopScrollView then
        self.comLoopScrollView:AddListener(function(...) self:OnFormulaChanged(...) end)
    end

    self.objSCFormulaitem = self:FindChild(self._gameObject, 'Info_Box/Formula_box/SC_formula/FormulaItemUI')
    self.objSCFormulaitem:SetActive(false)

    self.objSCMaterialitem = self:FindChild(self._gameObject, 'Info_Box/Formula_box/SC_formula/MaterialItem')
    self.objSCMaterialitem:SetActive(false)
end

function CollectionFormulaUI:InitDatas()
    local TB_FORGEMAKE = TableDataManager:GetInstance():GetTable("ForgeMake") or {}
    self.datas_AllList = TB_FORGEMAKE
    self.map_Unlock = {}
    local forgeNPCData = TableDataManager:GetInstance():GetTableData("ForgeNpc",MAINROLEID)
    if forgeNPCData then
        for index, forgeMakeID in ipairs(forgeNPCData.ForgeMakeIDList) do
            if TB_FORGEMAKE[forgeMakeID] then 
                self.map_Unlock[forgeMakeID] = true
            end
        end
    end
    -- 然后加入玩家解锁的配方
    local kUnlockPool = globalDataPool:getData("UnlockPool") or {}
    local kForgeMakeData = kUnlockPool[STLULT_FORMULA] or {}
    for typeID, data in pairs(kForgeMakeData) do
        if TB_FORGEMAKE[typeID] then 
            self.map_Unlock[typeID] = true
        end
    end
end 

function CollectionFormulaUI:RefreshUI(info)
    self.close_to_collection = info
    self:InitNavTags()
    self:InitDatas()
    self.choseNavStr = '所有'
    self:InitFormulaList()
    
    if self.tog111 then 
        self.tog111.isOn = true 
    end 
    self.tog111 = nil
end

function CollectionFormulaUI:InitNavTags()
    RemoveAllChildren(self.objSCNavLeftlist)
    self.tog111 = nil
    if ForgeMakeType_Revert then 
        FORMULA_NAV_TAGS = {'所有'}
        for strname,etype in pairs(ForgeMakeType_Revert) do 
            if strname ~= '-' then 
                table.insert( FORMULA_NAV_TAGS,strname)
            end 
        end 
    end 
    table.sort( FORMULA_NAV_TAGS, function(a,b)
        if a == '所有' or b == '所有' then 
            return a == '所有'
        else
            return ForgeMakeType_Revert[a] < ForgeMakeType_Revert[b] 
        end
    end )
    for int_i,str_nav in ipairs(FORMULA_NAV_TAGS) do 
        local ObjItem =  CloneObj(self.objSCNavLeftitem, self.objSCNavLeftlist)
        if ObjItem then 
            local comTextName = self:FindChildComponent(ObjItem,'UnClick/Text','Text')
            comTextName.text = str_nav
            -- 父级按钮的tog捆绑
            local objBtnClick = self:FindChild(ObjItem,'UnClick/Click')
            local toggleItem = ObjItem:GetComponent("Toggle")
            self.tog111 = self.tog111 or toggleItem
            if (toggleItem ~= nil) then
                toggleItem.isOn = false
                toggleItem.group = self.toggleGroupNavLeft
                objBtnClick:SetActive(false)
                --comTextName.color = DRCSRef.Color(0.17,0.17,0.17,1)
                self:AddToggleClickListener(toggleItem, function(bIsOn)
                    objBtnClick:SetActive(bIsOn)
                    comTextName.color = bIsOn and DRCSRef.Color.white or DRCSRef.Color(0.17,0.17,0.17,1)
                    self:OnClick_BtnNav_1st(ObjItem,str_nav,bIsOn)
                end)
            end
            ObjItem:SetActive(true)
            -- 若有子集
            local objBtnArrow = self:FindChild(ObjItem,'UnClick/BtnArrow')
            local objBtnChildContent = self:FindChild(ObjItem,'ChildContent')
            RemoveAllChildren(objBtnChildContent)
            objBtnChildContent:SetActive(false)
            local togchild1 = nil
            if FORMULA_NAV_CHILD_MAP[str_nav] then 
                objBtnArrow:SetActive(true)
                for int_j,str_child in ipairs(FORMULA_NAV_CHILD_MAP[str_nav]) do 
                    local ObjChild =  CloneObj(self.objSCNavLeftChild, objBtnChildContent)
                    comTextName = self:FindChildComponent(ObjChild,'Text','Text')
                    comTextName.text = str_child
                    local objBtnClickChild = self:FindChild(ObjChild,'Image_highlight')
                    local toggleChild = ObjChild:GetComponent("Toggle")
                    if (toggleChild ~= nil) then
                        if togchild1 == nil then 
                            togchild1 = toggleChild 
                        end
                        toggleChild.isOn = false
                        toggleChild.group = self.toggleGroupNavLeft
                        objBtnClickChild:SetActive(false)
                        self:AddToggleClickListener(toggleChild, function(bIsOn)      
                            objBtnClickChild:SetActive(bIsOn)
                            self:OnClick_BtnNav_2nd(ObjChild,str_child,bIsOn)
                        end)
                    end
                    ObjChild:SetActive(true)
                end 
                local comBtnArrow = objBtnArrow:GetComponent('DRButton')
                self:AddButtonClickListener(comBtnArrow,function()
                    self.map_NavOpen = self.map_NavOpen or {}
                    
                    local comtwn = comBtnArrow:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
                    if self.map_NavOpen[str_nav] then 
                        self.map_NavOpen[str_nav] = false 
                        objBtnChildContent:SetActive(false)
                        if comtwn then 
                            comtwn:DOPlayBackwards()
                        end
                        if toggleItem then 
                            toggleItem.isOn = true
                        end
                    else 
                        self.map_NavOpen[str_nav] = comBtnArrow 
                        objBtnChildContent:SetActive(true)
                        if comtwn then 
                            comtwn:DOPlayForward()
                        end
                        if togchild1 then 
                            togchild1.isOn = true 
                        end    
                    end 
                end)

            else 
                objBtnArrow:SetActive(false)
            end 
        end 
    end 
end
function CollectionFormulaUI:OnClick_BtnNav_1st(obj,str_nav,bIsOn)
    if self.map_NavOpen and bIsOn then 
        for str,comarrow in pairs(self.map_NavOpen) do
            if comarrow then 
                comarrow.onClick:Invoke()
            end
        end 
        self.map_NavOpen = {}
    end
    if self.choseNavStr ~= str_nav then 
        self.choseNavStr = str_nav
        self:RefreshFormulaList()
    end 
end
function CollectionFormulaUI:OnClick_BtnNav_2nd(obj,str_nav,bIsOn)
    if self.choseNavStr ~= str_nav then 
        self.choseNavStr = str_nav
        self:RefreshFormulaList()
    end 
end
function CollectionFormulaUI:InitFormulaList()
    self:RefreshFormulaList()
end
function CollectionFormulaUI:RefreshFormulaList()
    self.datas_showing_list = {}
    self.choseNavStr = self.choseNavStr or '所有'
    local tab_show_all = {}
    local itemMgr = ItemDataManager:GetInstance()
    local iNumAll = 0
    local iNumUnlock = 0
    for iI,forgeMakeItem in pairs(self.datas_AllList) do 
        local item =  TB_ITEM[forgeMakeItem.TargetItemID or 0] 
        if item then 
            local type = item.ItemType 
            -- if self.choseNavStr == '所有' or itemMgr:IsTypeEqual(type,ItemTypeDetail_Revert[self.choseNavStr]) then 
            if self.choseNavStr == '所有' or ForgeMakeType_Revert[self.choseNavStr] == forgeMakeItem.ForgeType then 
                if forgeMakeItem.IsInvisible ~= TBoolean.BOOL_YES then 
                    table.insert(self.datas_showing_list,forgeMakeItem)
                    iNumAll = iNumAll + 1
                    if self.map_Unlock[forgeMakeItem.BaseID or 0] then 
                        iNumUnlock = iNumUnlock + 1
                    end
                end
            end
        end 
    end
    self.comTextUnlockRecord.text = '已解锁:' .. iNumUnlock .. '/' .. iNumAll
    local sort_func = function(a,b)
        local ida = a.BaseID or 0
        local idb = b.BaseID or 0
        if self.map_Unlock[ida] ~= self.map_Unlock[idb] then 
            return self.map_Unlock[ida] and true or false 
        end 
        local iitema = TB_ITEM[a.TargetItemID or 0] 
        local iitemb = TB_ITEM[b.TargetItemID or 0] 
        local iranka = iitema and iitema.Rank or 0
        local irankb = iitemb and iitemb.Rank or 0
        return iranka > irankb
    end
    table.sort(self.datas_showing_list,sort_func)
    if self.comLoopScrollView then
        self.obj_card_list = {}
        self.comLoopScrollView.totalCount = getTableSize(self.datas_showing_list)
        self.comLoopScrollView:RefillCells()
    end
end

function CollectionFormulaUI:OnFormulaChanged(gameobj,index)
    local dataForgeMake = self.datas_showing_list[index + 1]
    local objFormula = gameobj.gameObject
    local dataItem =  TB_ITEM[dataForgeMake.TargetItemID or 0] 
    if dataForgeMake == nil or dataItem == nil then 
        return 
    end 
    local comTextName = self:FindChildComponent(objFormula,'Text_title','Text')
    comTextName.text = getRankBasedText(dataItem.Rank, dataItem.ItemName or '')
    local objItemicon = self:FindChild(objFormula,'ItemIconUI')
    self.ItemIconUI:SetCanSaveButton(false)
    self.ItemIconUI:UpdateUIWithItemTypeData(objItemicon, dataItem)
    local combg = self:FindChildComponent(objFormula, "bg", "Image")
    setUIGray(combg,self.map_Unlock[dataForgeMake.BaseID or 0] or false ) 

    local comdesc = self:FindChildComponent(objFormula, "Text_desc", "Text")
    local comImgLock = self:FindChild(objFormula, "Image_lock")
    local objMaterialList = self:FindChild(objFormula,'MaterialList/Content')
    local comBtn = self:FindChildComponent(objFormula,'ItemIconUI','Button')
    
    if self.map_Unlock[dataForgeMake.BaseID or 0] then 
        -- comBtn.interactable = true
        objMaterialList:SetActive(true)
        comImgLock:SetActive(false)
        comdesc.text = ''
        local transformMl = objMaterialList.transform
        for i = transformMl.childCount - 1 ,0 ,-1 do 
            local child = transformMl:GetChild(i)
            child = child and child.gameObject
            child:SetActive(false)
        end 
        if dataForgeMake.Makings and #dataForgeMake.Makings > 0 then 
            for int_m,makeingsid in pairs(dataForgeMake.Makings) do 
                local iNeed = dataForgeMake.MakingsCounts[int_m] or 1
                local dataMaking =  TB_ITEM[makeingsid or 0] 
                local objMaking
                if transformMl.childCount < int_m then 
                    objMaking = CloneObj(self.objSCMaterialitem, objMaterialList)
                else
                    objMaking = transformMl:GetChild(int_m -1) 
                end 
                objMaking = objMaking.gameObject
                objMaking:SetActive(true)
                local objMakingIcon = self:FindChild(objMaking,'ItemIconUI')
                self.ItemIconUI:SetCanSaveButton(false)
                self.ItemIconUI:UpdateUIWithItemTypeData(objMakingIcon, dataMaking)
                local comMakingNum = self:FindChildComponent(objMaking,'ItemIconUI/Num','Text')
                comMakingNum.text = iNeed
            end
        end 
    else 
        -- 未解锁
        -- comBtn.interactable = false
        objMaterialList:SetActive(false)
        comImgLock:SetActive(true)
        comdesc.text = '未解锁'
    end 
end

function CollectionFormulaUI:OnDisable()

end

function CollectionFormulaUI:OnEnable()
    
end

function CollectionFormulaUI:OnDestroy()
   
end

return CollectionFormulaUI;