local dkJson = require("Base/Json/dkjson")
MartialScreenUI = class('MartialScreenUI', BaseWindow);

local BaseLevelLimitUp = 10
function MartialScreenUI:ctor()
end

function MartialScreenUI:Create()
	local obj = LoadPrefabAndInit('CollectionUI/MartialScreenUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function MartialScreenUI:Init()
    -- 点击关闭
    self.objRaycast = self:FindChild(self._gameObject,"raycast")
    AddEventTrigger(self.objRaycast,function()
        local collectionUI = GetUIWindow("CollectionUI")
        local collectionMartialUI = nil
        if collectionUI then
            collectionMartialUI = collectionUI.collectionMartialUI
        end
        if collectionMartialUI then
            collectionMartialUI:SetScreenToggle(false)
        end
        RemoveWindowImmediately("MartialScreenUI")
    end)

    self.objBgImage = self:FindChildComponent(self._gameObject,"BG",DRCSRef_Type.RectTransform)

    --武学类别toggle
    self.objTypeNode = self:FindChild(self._gameObject,"root/TypeNode")
    self.objTypeToggleNode = self:FindChild(self._gameObject,"root/TypeNode/TypeToggle")
    self.comTypeAllToggle = self:FindChildComponent(self.objTypeToggleNode,"All",DRCSRef_Type.Toggle)

    self:AddToggleClickListener(self.comTypeAllToggle,function(bIsOn)
        self:OnClickToggle("type",0,bIsOn)
    end)
    self.objTypeToggleList = {}
    for i=1,10 do
        local typeTog = self:FindChildComponent(self.objTypeToggleNode,tostring(i),DRCSRef_Type.Toggle)
        self.objTypeToggleList[tostring(i)] = typeTog
        self:AddToggleClickListener(typeTog, function(bIsOn)
            self:OnClickToggle("type",i,bIsOn)
        end)
    end
    -- 武学品质toggle
    self.objRankNode = self:FindChild(self._gameObject,"root/RankNode")
    self.objRankToggleNode = self:FindChild(self._gameObject,"root/RankNode/RankToggle")
    self.rankAll = self:FindChildComponent(self.objRankToggleNode,"All",DRCSRef_Type.Toggle)
    self:AddToggleClickListener(self.rankAll, function(bIsOn)
        self:OnClickToggle("rank",0,bIsOn)
    end)
    self.objRankToggleList = {}
    for i=1,7 do
        local rankTog = self:FindChildComponent(self.objRankToggleNode,tostring(i),DRCSRef_Type.Toggle)
        self.objRankToggleList[tostring(i)] = rankTog
        self:AddToggleClickListener(rankTog, function(bIsOn)
            self:OnClickToggle("rank",i,bIsOn)
        end)
    end
    
    -- 武学等级toggle
    self.objLevelNode = self:FindChild(self._gameObject,"root/LevelNode")
    self.objLevelToggleNode = self:FindChild(self._gameObject,"root/LevelNode/LevelToggle")
    self.levelAll = self:FindChildComponent(self.objLevelToggleNode,"All",DRCSRef_Type.Toggle)
    self:AddToggleClickListener(self.levelAll, function(bIsOn)
        self:OnClickToggle("level",0,bIsOn)
    end)
    self.objLevelToggleList = {}
    for i=1,2 do
        local levelTog = self:FindChildComponent(self.objLevelToggleNode,tostring(i),DRCSRef_Type.Toggle)
        self.objLevelToggleList[tostring(i)] = levelTog
        self:AddToggleClickListener(levelTog, function(bIsOn)
            self:OnClickToggle("level",i,bIsOn)
        end)
    end

    -- 门派toggle
    self.objClanNode = self:FindChild(self._gameObject,"root/ClanNode")
    self.objClanToggleNode = self:FindChild(self._gameObject,"root/ClanNode/ClanToggle")
    self.clanAll = self:FindChildComponent(self.objClanToggleNode,"All",DRCSRef_Type.Toggle)
    self:AddToggleClickListener(self.clanAll, function(bIsOn)
        self:OnClickToggle("clan",0,bIsOn)
    end)
    
    -- 门派筛选项需要动态生成 根据确实存在的门派秘籍数目
    self.objClansTogglesRoot = self:FindChild(self.objClanToggleNode,"ClansToggles")
    self.objClanItemCloneFrom = self:FindChild(self.objClanToggleNode,"Other")

    self.collectionDataManager = CollectionDataManager:GetInstance()
    self.toggleChange = false
end


function MartialScreenUI:SetChooseListFromCollectionScreenList()
    local typeChooseList = self.collectionDataManager:GetMartialScreenList(4)
    self.comTypeAllToggle.isOn = typeChooseList["All"]
    for k,v in pairs(self.objTypeToggleList) do
        v.isOn = typeChooseList[k]
    end
    local rankChooseList = self.collectionDataManager:GetMartialScreenList(1)
    self.rankAll.isOn = rankChooseList["All"]
    for k,v in pairs(self.objRankToggleList) do
        v.isOn = rankChooseList[k]
    end
    local levelChooseList = self.collectionDataManager:GetMartialScreenList(2)
    self.levelAll.isOn = levelChooseList["All"]
    for k,v in pairs(self.objLevelToggleList) do
        v.isOn = levelChooseList[k]
    end
    local clanChooseList = self.collectionDataManager:GetMartialScreenList(3)
    self.clanAll.isOn = clanChooseList["All"]
    if self.objClanToggleList then
        for k,v in pairs(self.objClanToggleList) do
            v.isOn = clanChooseList[k]
        end
    end
end

function MartialScreenUI:OnClickToggle(name,index,isOn)
    -- name "rank" "level" "clan"
    -- index 0=全部 clan中有-1=其他
    -- 根据点击的筛选选项重新生成list 更新到collectionDataManager中
    -- 调用ui刷新

    local toggleList,toggleAll,toggleObjList
    if (string.find(name,"rank")) then
        toggleList = self.collectionDataManager:GetMartialScreenList(1)
        toggleObjList = self.objRankToggleList
        toggleAll = self.rankAll
    elseif  (string.find(name,"level")) then
        toggleList = self.collectionDataManager:GetMartialScreenList(2)
        toggleObjList = self.objLevelToggleList
        toggleAll = self.levelAll
    elseif  (string.find(name,"clan")) then
        toggleList = self.collectionDataManager:GetMartialScreenList(3)
        toggleObjList = self.objClanToggleList
        toggleAll = self.clanAll
    else
        toggleList = self.collectionDataManager:GetMartialScreenList(4)
        toggleObjList = self.objTypeToggleList
        toggleAll = self.comTypeAllToggle
    end

    if (toggleList and toggleAll) then
        if (index == 0) then
            toggleList["All"] = isOn
            if isOn then
                --全部被勾上 则 其他都默认不勾
                for k,v in pairs(toggleList) do
                    if k ~= "All" then
                        toggleList[k] = false
                        toggleObjList[k].isOn = false
                    end
                end
            end
        else
            toggleList[tostring(index)] = isOn    
            if toggleAll.isOn then
                toggleList["All"] = false
                toggleAll.isOn = false
            end
        end  
        if not isOn then
            local allFalse = true
            for k,v in pairs(toggleList) do
                if v then
                    allFalse = false
                    break
                end
            end
            if allFalse then
                toggleList["All"] = true
                toggleAll.isOn = true
            end
        end 
    end 
    self.toggleChange = true
end

function MartialScreenUI:RefreshUI(info)
    local martialList = info.martialData
    self.tabIndex = info.tabIndex

    --------- 根据list内容设置筛选选项是否显示 ---------
    self.clanScreenFlag = true
    -- 此时是“所有”tap时，不显示门派筛选
    if self.tabIndex == DepartEnumType.DET_All then
        self.clanScreenFlag = false
    end

    self.levelScreenFlag = false
    local clanChooseItemList = {}
    local clanChooseRevertList = {}
    local martialListCount = 0
    for k,v in pairs(martialList) do
        -- 按等级筛选 没有>20级的，不显示筛选    
        if (v.level + BaseLevelLimitUp >= 20) then
            self.levelScreenFlag = true
        end
        if (self.clanScreenFlag) then
            -- 没有金、暗金门派武学时，不显示门派筛选
            local clanTypeData = TB_Clan[v.martialData.ClanID]
            if clanTypeData and clanTypeData.Rank and (clanTypeData.Rank == RankType.RT_Golden or clanTypeData.Rank == RankType.RT_DarkGolden) then
                -- 存入门派信息
                if not clanChooseRevertList[v.martialData.ClanID] then
                    clanChooseItemList[#clanChooseItemList+1] = clanTypeData
                    clanChooseRevertList[v.martialData.ClanID] = true
                end
            end
        end
        martialListCount = martialListCount + 1
    end
    if #clanChooseItemList == 0 then
        self.clanScreenFlag = false
    end

    if not self.levelScreenFlag then
        self.objLevelNode:SetActive(false)
    else 
        self.objLevelNode:SetActive(true)
    end

    local clanCountColunm = 0
    if not self.clanScreenFlag then
        self.objClanNode:SetActive(false)
    else
        self.objClanNode:SetActive(true)
        if self.objClanToggleList then 
            for k ,v in pairs(self.objClanToggleList) do
                local toggleClone = v:GetComponent(DRCSRef_Type.Toggle)
                self:RemoveToggleClickListener(toggleClone)
            end
        end
        RemoveAllChildren(self.objClansTogglesRoot)
        self.objClanToggleList = {}
        local count = #clanChooseItemList
        -- 判断是否增加“其他”筛选项
        if (#clanChooseItemList ~= martialListCount) then
            count = #clanChooseItemList+1
        end
        for i=1,count do
            local objNewClanToggle = CloneObj(self.objClanItemCloneFrom,self.objClansTogglesRoot.transform)
            objNewClanToggle:SetActive(true)
            local newClanToggleNameTxt = self:FindChildComponent(objNewClanToggle,"Label",DRCSRef_Type.Text)
            local newClanToggleClick = objNewClanToggle:GetComponent(DRCSRef_Type.Toggle)
            if i == #clanChooseItemList+1 then
                objNewClanToggle.name = "-1"
                newClanToggleNameTxt.text = "其他"
                self:AddToggleClickListener(newClanToggleClick, function(bIsOn)
                    self:OnClickToggle("clan",-1,bIsOn)
                end)       
            else
                objNewClanToggle.name = tostring(clanChooseItemList[i].BaseID)
                newClanToggleNameTxt.text = tostring(clanChooseItemList[i].ClanAbbreviation)
                self:AddToggleClickListener(newClanToggleClick, function(bIsOn)
                    self:OnClickToggle("clan",clanChooseItemList[i].BaseID,bIsOn)
                end)
            end
            self.objClanToggleList[objNewClanToggle.name] = newClanToggleClick
        end
        if count>4 then
            clanCountColunm = math.ceil((count - 4) / 4)
        end
    end    
    --------- 根据list内容设置筛选选项是否显示 ---------
    -- 根据collection里的list来配置筛选选项
    self:SetChooseListFromCollectionScreenList()

    --设置bg图片高度
    if not self.levelScreenFlag and not self.clanScreenFlag then
        self.objBgImage.sizeDelta = DRCSRef.Vec2(self.objBgImage.rect.width, 150+190)
    elseif self.levelScreenFlag and self.clanScreenFlag then
        self.objBgImage.sizeDelta = DRCSRef.Vec2(self.objBgImage.rect.width, 150+400 + clanCountColunm * 50)
    else
        self.objBgImage.sizeDelta = DRCSRef.Vec2(self.objBgImage.rect.width, 150+290 + clanCountColunm * 50)  -- 50为单个高度
    end
end

function MartialScreenUI:Update()
    if self.toggleChange then
        self.toggleChange = false
        local collectionUI = GetUIWindow("CollectionUI")
        local collectionMartialUI = nil
        if collectionUI then
            collectionMartialUI = collectionUI.collectionMartialUI
        end
        if collectionMartialUI then
            collectionMartialUI:OnRefRightLeftSCList(self.tabIndex)
            collectionMartialUI:RefreshByFirstItem()
        end
    end
end

function MartialScreenUI:OnDisable()
end


function MartialScreenUI:OnDestroy()
end

return MartialScreenUI;