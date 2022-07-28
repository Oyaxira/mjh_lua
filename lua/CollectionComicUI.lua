CollectionComicUI = class('CollectionComicUI', BaseWindow)
local TB_ResourceCG

function CollectionComicUI:ctor()
    TB_ResourceCG = TableDataManager:GetInstance():GetTable("ResourceCG") or {}
end

function CollectionComicUI:SetParent(parent)
    self.parent = parent
end

function CollectionComicUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/CollectionComicUI', self.parent or UI_UILayer, true);
    if obj then
        self:SetGameObject(obj)
	end
end

function CollectionComicUI:Init()
    self.CGTestMode = CollectionDataManager:GetInstance().CGTestMode
    self.comBtn_back = self:FindChildComponent(self._gameObject ,'TransformAdapt_node_left/Button_back','DRButton')
    if self.comBtn_back then
        self:AddButtonClickListener(self.comBtn_back,function()
            -- if self.close_to_collection then
            OpenWindowImmediately("CollectionUI")
            -- end
            RemoveWindowImmediately("CollectionComicUI", false)
            LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_BUTTON")
        end)
    end
    self.comTextUnlockRecord = self:FindChildComponent(self._gameObject,'Info_Box/TMP_unlock','Text')

    self.objSCFormulalist = self:FindChild(self._gameObject, 'Info_Box/SC_comic/Viewport/Content')
    self.comLoopScrollView = self:FindChildComponent(self._gameObject,"Info_Box/SC_comic","LoopVerticalScrollRect")
    if self.comLoopScrollView then
        self.comLoopScrollView:AddListener(function(...) self:OnFormulaChanged(...) end)
    end

    self.objSCFormulaitem = self:FindChild(self._gameObject, 'Info_Box/SC_comic/ComicItem')
    self.objSCFormulaitem:SetActive(false)

    self.objComicPage = self:FindChild(self._gameObject, 'Reading')
    self.btnComicPage_back = self:FindChildComponent(self._gameObject ,'Reading/TransformAdapt_node_left/Button_back','DRButton')
    if self.btnComicPage_back then
        self:AddButtonClickListener(self.btnComicPage_back,function()
            self.hideComicPageFlag = false
            self.hideComicTitleFlag = false
            self.objComicPage:SetActive(false)
            self.curComicPackageData = nil
        end)
    end
    self.btnComicPage_left = self:FindChildComponent(self._gameObject ,'Reading/Button_left','DRButton')
    if self.btnComicPage_left then
        self:AddButtonClickListener(self.btnComicPage_left,function()
            self.hideComicPageFlag = false
            self:SetCurComicDataLeft()
        end)
    end
    self.btnComicPage_right = self:FindChildComponent(self._gameObject ,'Reading/Button_right','DRButton')
    if self.btnComicPage_right then
        self:AddButtonClickListener(self.btnComicPage_right,function()
            self.hideComicPageFlag = false
            self:SetCurComicDataRight()
        end)
    end
    self.objComicPage_image = self:FindChildComponent(self.objComicPage ,'Image','Image')
    self.objComicPage_image_transform = self:FindChildComponent(self.objComicPage ,'Image','RectTransform')
    self.PosX = self.objComicPage_image_transform.localPosition.x
    self.objComicPage_image2 = self:FindChildComponent(self.objComicPage ,'Image2','Image')
    self.objComicPage_image2_transform = self:FindChildComponent(self.objComicPage ,'Image2','RectTransform')
    self.objComicPage_title = self:FindChildComponent(self.objComicPage ,'Title/Text','Text')
    self.objComicPage_titleCanvas = self:FindChildComponent(self.objComicPage ,'Title','CanvasGroup')

    self.objComicPage_page = self:FindChildComponent(self.objComicPage ,'Page/Text','Text')
    self.objComicPage_pageCanvas = self:FindChildComponent(self.objComicPage ,'Page','CanvasGroup')
end

function CollectionComicUI:OnPressESCKey()
    if self.comBtn_back then
        if self.objComicPage.activeSelf then
            self.btnComicPage_back.onClick:Invoke()
        else
	        self.comBtn_back.onClick:Invoke()
        end
    end
end
function CollectionComicUI:InitDatas()
    self.datas_AllList = {}
    self.map_Unlock = {}
    --showlist筛选出每个漫画包的第一张
    self.datas_ShowList = {}
    self.datas_ComicPackageLen = {}
    --按照漫画包的index来赋值showlist的解锁情况
    self.unlock_ShowlList = {}

    local kUnlockPool = globalDataPool:getData("UnlockPool") or {}
    local kComicIndexData = kUnlockPool[PlayerInfoType.PIT_CARICATURE] or {}
    for k,v in pairs(kComicIndexData) do
        self.map_Unlock[k] = true
    end

    if TB_ResourceCG then
        for i,line in pairs(TB_ResourceCG) do
            if line.CGType == CGType.CGT_Comic then
                table.insert(self.datas_AllList,TB_ResourceCG[i])
            end
        end
    end

    self:SortAllList()

    self:SetLockStateForShowList()
end

function CollectionComicUI:RefreshUI(info)
    self:InitDatas()
    self:RefreshFormulaList()
end

--按comicindex 和 baseid 对alllist 进行排序
function CollectionComicUI:SortAllList()
    local sort_func = function(a,b)
        local ida = b.ComicIndex
        local idb = a.ComicIndex
        if ida ~= idb then
            return ida > idb
        end
        local iranka = b.BaseID
        local irankb = a.BaseID
        return iranka > irankb
    end
    table.sort(self.datas_AllList,sort_func)
end

--根据每张漫画的解锁状态刷新漫画包的解锁状态
function CollectionComicUI:SetLockStateForShowList()
    local comicIndex = nil
    local fresh = false
    if (#self.datas_ShowList ~= 0) then
        fresh = true
    end
    for index,value in pairs(self.datas_AllList) do
        if (value.ComicIndex ~= comicIndex) then
            if (not fresh) then
                table.insert(self.datas_ShowList,self.datas_AllList[index])
                self.datas_ComicPackageLen[value.ComicIndex] = 1
            end
            comicIndex = value.ComicIndex
            if self.CGTestMode then
                self.unlock_ShowlList[value.ComicIndex] = true
            else
                self.unlock_ShowlList[value.ComicIndex] = false
            end

        else
            if (not fresh) then
                self.datas_ComicPackageLen[value.ComicIndex] = self.datas_ComicPackageLen[value.ComicIndex]+1
            end
        end
        if (self.map_Unlock[value.ComicIndex] and not self.unlock_ShowlList[value.ComicIndex]) then
            self.unlock_ShowlList[value.ComicIndex] = true
        end
    end
end

function CollectionComicUI:RefreshFormulaList()
    self:SetLockStateForShowList()
    local iNumAll = 0
    local iNumUnlock = 0
    for index,item in pairs(self.datas_ShowList) do
        if item then
            iNumAll = iNumAll + 1
            if self.unlock_ShowlList[item.ComicIndex] then
                iNumUnlock = iNumUnlock + 1
            end
        end
    end
    self.comTextUnlockRecord.text = '已解锁:' .. iNumUnlock .. '/' .. iNumAll
    if self.comLoopScrollView then
        self.comLoopScrollView.totalCount = getTableSize(self.datas_ShowList)
        self.comLoopScrollView:RefillCells()
    end
end

function CollectionComicUI:OnFormulaChanged(gameobj,index)
    local dataComicPackage = self.datas_ShowList[index + 1]
    local objComicPackage = gameobj.gameObject
    if dataComicPackage == nil then
        return
    end
    local comTextName = self:FindChildComponent(objComicPackage,'Text_name','Text')
    comTextName.text = GetLanguageByID(dataComicPackage.CGName).."("..self.datas_ComicPackageLen[dataComicPackage.ComicIndex]..")"
    local combg = self:FindChildComponent(objComicPackage, "Mask/Image", "Image")
    combg.sprite = GetSprite(dataComicPackage.CGPath)
    local comImgLock = self:FindChild(objComicPackage, "Image_lock")
    local comBtn = objComicPackage:GetComponent("Button")
    local comImgNew = self:FindChild(objComicPackage, "Image_new")
    comImgNew:SetActive(false)

    if self.unlock_ShowlList[dataComicPackage.ComicIndex] then
        self:RemoveButtonClickListener(comBtn)
        self:AddButtonClickListener(comBtn,function()
            self.curComicPackageData = dataComicPackage
            self:ClickComicPackage()
            self.objComicPage:SetActive(true)
        end)
        comImgLock:SetActive(false)
    else
        -- 未解锁
        self:RemoveButtonClickListener(comBtn)
        self:AddButtonClickListener(comBtn,function()
            SystemUICall:GetInstance():Toast('这部分漫画还未解锁')
        end)
        comImgLock:SetActive(true)

    end
end

function CollectionComicUI:FlipComic(rotate)

end


function CollectionComicUI:ShowComicReadTitle()
    self.hideComicTitleFlag = false
    self.objComicPage_titleCanvas:DR_DOFade(1, 0.1)
end

function CollectionComicUI:HideComicReadTitle_func()
    self.hideComicTitleFlag = false
    self.objComicPage_titleCanvas:DR_DOFade(0, 0.3)
end

function CollectionComicUI:HideComicReadTitle(delayTime)
    self.hideComicTitleFlag = true
    self.hideComicTitleDelayTime = delayTime
    self.hideComicTitleStartTime = os.clock()
end

function CollectionComicUI:ShowComicReadPage()
    self.hideComicPageFlag = false
    self.objComicPage_pageCanvas:DR_DOFade(1, 0.1)
end

function CollectionComicUI:HideComicReadPage_func()
    self.hideComicPageFlag = false
    self.objComicPage_pageCanvas:DR_DOFade(0, 0.3)
end

--新的hide命令会覆盖旧的 不分时间长短
function CollectionComicUI:HideComicReadPage(delayTime)
    self.hideComicPageFlag = true
    self.hideComicPageDelayTime = delayTime
    self.hideComicPageStartTime = os.clock()
end

function CollectionComicUI:SetCurComicDataLeft()
    if (self.hideComicTitleFlag) then
        self:HideComicReadTitle(0.1)
    end
    local leftData = nil
    for index,data in pairs (self.curComicPackageDataList) do
        if (data.BaseID == self.curComicPackageData.BaseID) then
            break
        end
        leftData = data
    end
    if (not leftData) then
        SystemUICall:GetInstance():Toast('已经是第一页了')
        self:ShowComicReadPage()
        self:HideComicReadPage(0.5)
    else
        self.curComicIndex = self.curComicIndex - 1
        self:FreshComicPage(-1,leftData)
    end
end

function CollectionComicUI:SetCurComicDataRight()
    if (self.hideComicTitleFlag) then
        self:HideComicReadTitle(0.1)
    end
    local rightData = nil
    for index,data in pairs (self.curComicPackageDataList) do
        if (data.BaseID > self.curComicPackageData.BaseID) then
            rightData = data
            break
        end
    end
    if (not rightData) then
        SystemUICall:GetInstance():Toast('已经是最后一页了')
        self:ShowComicReadPage()
        self:HideComicReadPage(0.5)
    else
        self.curComicIndex = self.curComicIndex + 1
        self:FreshComicPage(1,rightData)
    end
end

function CollectionComicUI:FreshComicPage(index,newData)
    if (index ~= 0) then
        self.curComicPackageData = newData
        --左右翻页的时候 先将image2放在image的位置复制为当前漫画
        --再将image更新为下一个漫画
        --对image image2进行平移动画
        self.objComicPage_image2.sprite = self.objComicPage_image.sprite
        self.objComicPage_image2_transform.localPosition = self.objComicPage_image_transform.localPosition
    end
    if self.curComicPackageData then
        self.objComicPage_image.sprite = GetSprite(self.curComicPackageData.CGPath)
        if (index ~= 0) then
            local newPos = self.objComicPage_image_transform.localPosition + DRCSRef.Vec3(1280 * index,0,0)
            local newPos2x = self.objComicPage_image_transform.localPosition.x + 1280 * index * -1
            self.objComicPage_image_transform.localPosition = newPos
            self.objComicPage_image_transform:DR_DOLocalMoveX(self.PosX,0.2)
            self.objComicPage_image2_transform:DR_DOLocalMoveX(newPos2x,0.2)
        end
        self.objComicPage_page.text = self.curComicIndex.."/"..#self.curComicPackageDataList
        self:ShowComicReadPage()
        self:HideComicReadPage(0.5)
    end

end


function CollectionComicUI:ClickComicPackage()
    self.curComicIndex = 1
    self.curComicPackageDataList = {}
    for index,value in pairs(self.datas_AllList) do
        if (value.ComicIndex == self.curComicPackageData.ComicIndex) then
            table.insert(self.curComicPackageDataList,self.datas_AllList[index])
        end
    end
    local sort_func = function(a,b)
        local iranka = b.BaseID
        local irankb = a.BaseID
        return iranka > irankb
    end
    table.sort(self.curComicPackageDataList,sort_func)
    self.objComicPage_title.text = GetLanguageByID(self.curComicPackageData.CGName)
    self:FreshComicPage(0,nil)
    self:ShowComicReadTitle()
    self:HideComicReadTitle(2)
    self:HideComicReadPage(2)
end

function CollectionComicUI:Update()
    if (self.hideComicTitleFlag) then
        if (os.clock() - self.hideComicTitleStartTime > self.hideComicTitleDelayTime) then
            self:HideComicReadTitle_func()
        end
    end
    if (self.hideComicPageFlag) then
        if (os.clock() - self.hideComicPageStartTime > self.hideComicPageDelayTime) then
            self:HideComicReadPage_func()
        end
    end
end

function CollectionComicUI:OnDisable()

end

function CollectionComicUI:OnEnable()

end

function CollectionComicUI:OnDestroy()

end

return CollectionComicUI;