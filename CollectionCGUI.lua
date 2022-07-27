CollectionCGUI = class('CollectionCGUI', BaseWindow)

local TB_ResourceCG

function CollectionCGUI:ctor()
    TB_ResourceCG = TableDataManager:GetInstance():GetTable("ResourceCG") or {}
end

function CollectionCGUI:SetParent(parent)
    self.parent = parent
end

function CollectionCGUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/CollectionCGUI', self.parent or UI_UILayer, true);
    if obj then
        self:SetGameObject(obj)
	end
end
function CollectionCGUI:Init()
    self.CGTestMode = CollectionDataManager:GetInstance().CGTestMode
    self.comBtn_back = self:FindChildComponent(self._gameObject ,'TransformAdapt_node_left/Button_back','DRButton')
    if self.comBtn_back then
        self:AddButtonClickListener(self.comBtn_back,function()
            OpenWindowImmediately("CollectionUI")
            RemoveWindowImmediately("CollectionCGUI", false)
            LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
        end)
    end
    self.comTextUnlockRecord = self:FindChildComponent(self._gameObject,'Info_Box/TMP_unlock','Text')

    self.objSCFormulalist = self:FindChild(self._gameObject, 'Info_Box/SC_comic/Viewport/Content')
    self.comLoopScrollView = self:FindChildComponent(self._gameObject,"Info_Box/SC_comic","LoopVerticalScrollRect")
    if self.comLoopScrollView then
        self.comLoopScrollView:AddListener(function(...) self:OnFormulaChanged(...) end)
    end

    self.objSCFormulaitem = self:FindChild(self._gameObject, 'Info_Box/SC_comic/CGItem')
    self.objSCFormulaitem:SetActive(false)

    self.objCGPage = self:FindChild(self._gameObject, 'Reading')
    self.btnCGPage_back = self:FindChildComponent(self._gameObject ,'Reading/TransformAdapt_node_left/Button_back','DRButton')
    if self.btnCGPage_back then
        self:AddButtonClickListener(self.btnCGPage_back,function()
            self.curCGData = nil
            self.objCGPage:SetActive(false)
        end)
    end
    self.btnCGPage_left = self:FindChildComponent(self._gameObject ,'Reading/Button_left','DRButton')
    if self.btnCGPage_left then
        self:AddButtonClickListener(self.btnCGPage_left,function()
            self:SetCurCDDataLeft()
        end)
    end
    self.btnCGPage_right = self:FindChildComponent(self._gameObject ,'Reading/Button_right','DRButton')
    if self.btnCGPage_right then
        self:AddButtonClickListener(self.btnCGPage_right,function()
            self:SetCurCDDataRight()
        end)
    end
    self.objCGPage_image = self:FindChildComponent(self.objCGPage ,'Image','Image')
    self.objCGPage_imageButton = self:FindChildComponent(self.objCGPage ,'Image','DRButton')
    self.objCGTitle = self:FindChild(self.objCGPage ,'Title')
    self.objCGAuthor = self:FindChild(self.objCGPage ,'Author')
    self.IsActive = true
    if self.objCGPage_imageButton then
        self:AddButtonClickListener(self.objCGPage_imageButton,function()
            self.btnCGPage_back.gameObject:SetActive(not self.IsActive)
            self.objCGTitle:SetActive(not self.IsActive)
            self.objCGAuthor:SetActive(not self.IsActive)
            self.IsActive = not self.IsActive
            -- self.objCGPage_image2.gameObject:SetActive(true)
            -- self.objCGPage_image2.gameObject.transform:DOLocalMoveX(-21,0.25)
            -- self.objCGPage_image2.gameObject.transform:DR_DOScaleX(1.55,0.25)
            -- self.objCGPage_image2.gameObject.transform:DOLocalMoveY(0,0.25)
            -- self.objCGPage_image2.gameObject.transform:DR_DOScaleY(1.55,0.25)
        end)
    end
    self.objCGPage_image2 = self:FindChildComponent(self.objCGPage ,'Image2','Image')
    self.objCGPage_image2Button = self:FindChildComponent(self.objCGPage ,'Image2','DRButton')
    if self.objCGPage_image2Button then
        self:AddButtonClickListener(self.objCGPage_image2Button,function()
            self.objCGPage_image2.gameObject.transform:DOLocalMoveX(3,0.25)
            self.objCGPage_image2.gameObject.transform:DR_DOScaleX(1,0.25)
            self.objCGPage_image2.gameObject.transform:DOLocalMoveY(-21,0.25)
            self.objCGPage_image2.gameObject.transform:DR_DOScaleY(1,0.25)
            self:AddTimer(250,function()
                self.objCGPage_image2.gameObject:SetActive(false)
            end)
        end)
    end
    self.objCGPage_title = self:FindChildComponent(self.objCGPage ,'Title/Text','Text')
    self.objCGPage_author = self:FindChildComponent(self.objCGPage ,'Author/Text','Text')
end

function CollectionCGUI:OnPressESCKey()
    if self.comBtn_back then
        if self.objCGPage_image2.gameObject.activeSelf then
            self.objCGPage_image2Button.onClick:Invoke()
        elseif self.objCGPage.activeSelf then
            self.btnCGPage_back.onClick:Invoke()
        else
	        self.comBtn_back.onClick:Invoke()
        end
    end
end

function CollectionCGUI:SetCurCDDataLeft()
    local leftData = nil
    for index,data in pairs (self.datas_AllList) do
        if (data.BaseID == self.curCGData.BaseID) then
            break
        end
        if (self.map_Unlock[data.BaseID]) then
            leftData = data
        end
    end
    if (not leftData) then
        SystemUICall:GetInstance():Toast('已经是第一张插画了')
    else
        self.curCGData = leftData
        self:ClickCG()
    end
end

function CollectionCGUI:SetCurCDDataRight()
    local rightData = nil
    for index,data in pairs (self.datas_AllList) do
        if (data.BaseID > self.curCGData.BaseID) then
            if (self.map_Unlock[data.BaseID]) then
                rightData = data
                break
            end
        end
    end
    if (not rightData) then
        SystemUICall:GetInstance():Toast('已经是最后一张插画了')
    else
        self.curCGData = rightData
        self:ClickCG()
    end
end

function CollectionCGUI:InitDatas()
    self.datas_AllList = {}
    self.map_Unlock = {}

    if TB_ResourceCG then
        for i,line in pairs(TB_ResourceCG) do
            if line.CGType == CGType.CGT_CG then
                table.insert(self.datas_AllList,TB_ResourceCG[i])
                if (self.CGTestMode) then
                    self.map_Unlock[TB_ResourceCG[i].BaseID] = true
                end
            end
        end
    end
    if (not self.CGTestMode) then
        local kUnlockPool = globalDataPool:getData("UnlockPool") or {}
        local kTreasureData = kUnlockPool[PlayerInfoType.PIT_CG] or {}
        for typeID, data in pairs(kTreasureData) do
            if TB_ResourceCG[typeID] then
                self.map_Unlock[typeID] = true
            end
        end
    end
end

function CollectionCGUI:RefreshUI(info)
    self:InitDatas()
    self:InitFormulaList()
end

function CollectionCGUI:InitFormulaList()
    self:RefreshFormulaList()
end

function CollectionCGUI:RefreshFormulaList()
    local itemMgr = ItemDataManager:GetInstance()
    local iNumAll = 0
    local iNumUnlock = 0
    for index,item in pairs(self.datas_AllList) do
        if item then
            iNumAll = iNumAll + 1
            if self.map_Unlock[item.BaseID or 0] then
                iNumUnlock = iNumUnlock + 1
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
        local iranka = idb
        local irankb = ida
        return iranka > irankb
    end
    table.sort(self.datas_AllList,sort_func)
    if self.comLoopScrollView then
        self.obj_card_list = {}
        self.comLoopScrollView.totalCount = getTableSize(self.datas_AllList)
        self.comLoopScrollView:RefillCells()
    end
end

function CollectionCGUI:OnFormulaChanged(gameobj,index)
    local dataTreasure = self.datas_AllList[index + 1]
    local objFormula = gameobj.gameObject
    if dataTreasure == nil then
        return
    end
    local comTextName = self:FindChildComponent(objFormula,'Text_name','Text')
    comTextName.text = GetLanguageByID(dataTreasure.CGName)
    local combg = self:FindChildComponent(objFormula, "Mask/Image", "Image")
    combg.sprite = GetSprite(dataTreasure.CGPath)
    local comImgLock = self:FindChild(objFormula, "Image_lock")
    local comBtn = objFormula:GetComponent("Button")
    local comImgNew = self:FindChild(objFormula, "Image_new")
    comImgNew:SetActive(false)

    if self.map_Unlock[dataTreasure.BaseID or 0] then
        self:RemoveButtonClickListener(comBtn)
        self:AddButtonClickListener(comBtn,function()
            self.curCGData = dataTreasure
            self:ClickCG()
            self.objCGPage:SetActive(true)
        end)
        comImgLock:SetActive(false)
    else
        -- 未解锁
        self:RemoveButtonClickListener(comBtn)
        self:AddButtonClickListener(comBtn,function()
            SystemUICall:GetInstance():Toast('该插画还未解锁')
        end)
        comImgLock:SetActive(true)
    end
end



function CollectionCGUI:ClickCG()
    if self.curCGData then
        self.objCGPage_image.sprite = GetSprite(self.curCGData.CGPath)
        self.objCGPage_image2.sprite = GetSprite(self.curCGData.CGPath)
        self.objCGPage_image2.gameObject:SetActive(false)
        self.objCGPage_title.text = GetLanguageByID(self.curCGData.CGName)
        self.objCGPage_author.text = "画家："..GetLanguageByID(self.curCGData.ArtistName)
    end
end


function CollectionCGUI:OnDisable()

end

function CollectionCGUI:OnEnable()

end

function CollectionCGUI:OnDestroy()

end

return CollectionCGUI;