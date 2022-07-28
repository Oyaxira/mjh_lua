CollectionHeirloomUI = class('CollectionHeirloomUI', BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

local FORMULA_NAV_TAGS = {}--'所有','白','绿','蓝','紫','橙','金','暗金','五彩'}

local FORMULA_NAV_CHILD_MAP = {
}
local MAINROLEID = 1
-- ItemTypeDetail_Revert
local TB_ITEM

function CollectionHeirloomUI:ctor()
    self.bindBtnTable = {}
    TB_ITEM = TableDataManager:GetInstance():GetTable("Item") or {}

    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
end
function CollectionHeirloomUI:SetParent(parent)
    self.parent = parent
end
function CollectionHeirloomUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/CollectionHeirloomUI', self.parent or UI_UILayer, true);
    if obj then
        self:SetGameObject(obj)
	end
end
function CollectionHeirloomUI:Init()

    self.comBtn_back = self:FindChildComponent(self._gameObject ,'TransformAdapt_node_left/Button_back','DRButton')
    if self.comBtn_back then
        self:AddButtonClickListener(self.comBtn_back,function()
            if self.close_to_collection then
                OpenWindowImmediately("CollectionUI")
            end
            RemoveWindowImmediately("CollectionHeirloomUI", false)
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

    --self.objSCMaterialitem = self:FindChild(self._gameObject, 'Info_Box/Formula_box/SC_formula/MaterialItem')
    --self.objSCMaterialitem:SetActive(false)
end
function CollectionHeirloomUI:OnPressESCKey()
    if self.comBtn_back then
	    self.comBtn_back.onClick:Invoke()
    end
end

function CollectionHeirloomUI:InitDatas()
    self.datas_AllList = {}
    self.map_Unlock = {}
    local TB_Item = TableDataManager:GetInstance():GetTable("Item") or {}
    if TB_Item then
        for index, data in pairs(TB_Item) do
            if data.ClanTreasure ~= 0 or data.PersonalTreasure ~= 0 then
                --当某个传家宝物品的这一列【不为空】且【不等于自身ID】，则不会被视作一个要加入收藏的传家宝
                if not (data.OrigItemID~= 0 and data.OrigItemID ~= data.BaseID) then
                    table.insert(self.datas_AllList,TB_ITEM[index])
                end
            end
        end
    end

    local kUnlockPool = globalDataPool:getData("UnlockPool") or {}
    local kTreasureData = kUnlockPool[PlayerInfoType.PIT_CHUANJIABAO] or {}
    for typeID, data in pairs(kTreasureData) do
        if TB_Item[typeID] then
            self.map_Unlock[typeID] = true
        end
    end
end

function CollectionHeirloomUI:RefreshUI(info)
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

function CollectionHeirloomUI:InitNavTags()
    RemoveAllChildren(self.objSCNavLeftlist)
    self.tog111 = nil
    if RankType_Revert then
        FORMULA_NAV_TAGS = {'所有'}
        for strname,etype in pairs(RankType_Revert) do
            if strname ~= '-' and strname ~= '五彩' and strname ~= '精良暗金' and strname ~= '优秀暗金' then
                table.insert( FORMULA_NAV_TAGS,strname)
            end
        end
    end
    table.sort( FORMULA_NAV_TAGS, function(a,b)
        if a == '所有' or b == '所有' then
            return a == '所有'
        else
            return RankType_Revert[a] < RankType_Revert[b]
        end
    end )
    for int_i,str_nav in ipairs(FORMULA_NAV_TAGS) do
        local ObjItem =  CloneObj(self.objSCNavLeftitem, self.objSCNavLeftlist)
        if ObjItem then
            local comTextName = self:FindChildComponent(ObjItem,'UnClick/Text','Text')
            comTextName.text = str_nav
            local rankColor = RANK_COLOR[RankType_Revert[str_nav]]
            if (rankColor) then
                comTextName.color = rankColor
            end

            -- 父级按钮的tog捆绑
            local objBtnClick = self:FindChild(ObjItem,'UnClick/Click')
            local toggleItem = ObjItem:GetComponent("Toggle")
            self.tog111 = self.tog111 or toggleItem
            if (toggleItem ~= nil) then
                toggleItem.isOn = false
                toggleItem.group = self.toggleGroupNavLeft
                objBtnClick:SetActive(false)
                self:AddToggleClickListener(toggleItem, function(bIsOn)
                    objBtnClick:SetActive(bIsOn)
                    if (not rankColor) then
                        comTextName.color = bIsOn and DRCSRef.Color.white or DRCSRef.Color(1,1,1,1)
                    end
                    self:OnClick_BtnNav_1st(ObjItem,str_nav,bIsOn)
                end)
            end
            ObjItem:SetActive(true)
        end
    end
end
function CollectionHeirloomUI:OnClick_BtnNav_1st(obj,str_nav,bIsOn)
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

function CollectionHeirloomUI:InitFormulaList()
    self:RefreshFormulaList()
end
function CollectionHeirloomUI:RefreshFormulaList()
    self.datas_showing_list = {}
    self.choseNavStr = self.choseNavStr or '所有'
    local tab_show_all = {}
    local itemMgr = ItemDataManager:GetInstance()
    local iNumAll = 0
    local iNumUnlock = 0
    for iI,treasureItem in pairs(self.datas_AllList) do
        if treasureItem then
            if self.choseNavStr == '所有' or self:IsRankEqual(RankType_Revert[self.choseNavStr],treasureItem.Rank) == true then
                table.insert(self.datas_showing_list,treasureItem)
                iNumAll = iNumAll + 1
                if self.map_Unlock[treasureItem.BaseID or 0] then
                    iNumUnlock = iNumUnlock + 1
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
        local iitema = TB_ITEM[a.BaseID or 0]
        local iitemb = TB_ITEM[b.BaseID or 0]
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

function CollectionHeirloomUI:IsRankEqual(srcRank, dstRank)
    if (not srcRank or not dstRank) then
        return false
    end

    if (srcRank == dstRank) then
        return true
    end

    local rankConvertList = {RankType.RT_DarkGolden, RankType.RT_MultiColor, RankType.RT_ThirdGearDarkGolden}
    local srcRankEqual = false
    local dstRankEqual = false
    for i = 1,#rankConvertList do
        if (srcRank == rankConvertList[i]) then
            srcRankEqual = true
        end
    end
    if (not srcRankEqual) then
        return false
    end
    for i = 1,#rankConvertList do
        if (dstRank == rankConvertList[i]) then
            dstRankEqual = true
        end
    end
    if (not dstRankEqual) then
        return false
    end

    return true
end

function CollectionHeirloomUI:OnFormulaChanged(gameobj,index)
    local dataTreasure = self.datas_showing_list[index + 1]
    local objFormula = gameobj.gameObject
    if dataTreasure == nil then
        return
    end
    local comTextName = self:FindChildComponent(objFormula,'Text_title','Text')
    comTextName.text = getRankBasedText(dataTreasure.Rank, dataTreasure.ItemName or '')
    local objItemicon = self:FindChild(objFormula,'ItemIconUI')
    self.ItemIconUI:SetCanSaveButton(false)
    self.ItemIconUI:UpdateUIWithItemTypeData(objItemicon, dataTreasure)
    local combg = self:FindChildComponent(objFormula, "bg", "Image")
    setUIGray(combg,self.map_Unlock[dataTreasure.BaseID or 0] or false )

    local comdesc = self:FindChildComponent(objFormula, "Text_desc", "Text")
    local comImgLock = self:FindChild(objFormula, "Image_lock")
    local objMaterialList = self:FindChild(objFormula,'MaterialList/Content')
    local comBtn = self:FindChildComponent(objFormula,'ItemIconUI','Button')

    if self.map_Unlock[dataTreasure.BaseID or 0] then
        --comBtn.interactable = true
        objMaterialList:SetActive(true)
        comImgLock:SetActive(false)
        comdesc.text = ''
        local transformMl = objMaterialList.transform
        for i = transformMl.childCount - 1 ,0 ,-1 do
            local child = transformMl:GetChild(i)
            child = child and child.gameObject
            child:SetActive(false)
        end
    else
        -- 未解锁
        --comBtn.interactable = false
        objMaterialList:SetActive(false)
        comImgLock:SetActive(true)
        comdesc.text = '未解锁'

    end
end

function CollectionHeirloomUI:OnDisable()

end

function CollectionHeirloomUI:OnEnable()

end

function CollectionHeirloomUI:OnDestroy()

end

return CollectionHeirloomUI;