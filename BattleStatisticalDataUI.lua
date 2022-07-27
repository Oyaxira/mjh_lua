local dkJson = require("Base/Json/dkjson")
BattleStatisticalDataUI = class('BattleStatisticalDataUI', BaseWindow);

function BattleStatisticalDataUI:ctor()
end

function BattleStatisticalDataUI:Create()
	local obj = LoadPrefabAndInit('Battle/BattleRecordUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function BattleStatisticalDataUI:InitData()
    self.LogicMain = LogicMain:GetInstance()
    local dataList = self.LogicMain:GetStatisticalDamage()
    self.leftDataList = {}
    self.rightDataList = {}
    self.leftTotalDamage = 0
    self.rightTotalDamage = 0
    self.leftTotalInjure = 0
    self.rightTotalInjure = 0
    self.victoryCamp = 1
    if (dataList~=nil) then
        for k,v in pairs(dataList) do
            if (v.sCamp == 1 or v.sCamp == 3) then
                table.insert(self.leftDataList,v)
                self.leftTotalDamage = self.leftTotalDamage + v.iDamage
                self.leftTotalInjure = self.leftTotalInjure + v.iHurt
            elseif (v.sCamp == 2) then
                table.insert(self.rightDataList,v)
                self.rightTotalDamage = self.rightTotalDamage + v.iDamage
                self.rightTotalInjure = self.rightTotalInjure + v.iHurt
            end
        end
        local sort_func = function(a,b)
            local ida = a.iDamage or 0
            local idb = b.iDamage or 0
            if (ida ~= idb) then
                return ida > idb
            end
            local iha = a.iHurt or 0
            local ihb = b.iHurt or 0
            return iha > ihb
        end
        table.sort(self.leftDataList,sort_func)
        table.sort(self.rightDataList,sort_func)
        self.victoryCamp = self.LogicMain:GetBattleVictoryCamp()
    end
end

function BattleStatisticalDataUI:Init()
    
    self.dataPanel = self:FindChild(self._gameObject,"Data_panel")
    self.leftDataPanel = self:FindChild(self.dataPanel,"Left_date/SC_role_date")
    self.rightDataPanel = self:FindChild(self.dataPanel,"Right_date/SC_role_date")
    
    self.leftDataLoopScrollView = self:FindChildComponent(self.dataPanel,"Left_date/SC_role_date","LoopVerticalScrollRect")
    if self.leftDataLoopScrollView then
        self.leftDataLoopScrollView:AddListener(function(...) self:OnLeftDataChanged(...) end)
    end
    self.objLeftRoleList = self:FindChild(self.leftDataPanel, "Content")
    self.objLeftRoleItem = self:FindChild(self.leftDataPanel, 'Content/BattleRecord_leftItem')
    self.objLeftRoleItem:SetActive(false)
    
    self.rightDataLoopScrollView = self:FindChildComponent(self.dataPanel,"Right_date/SC_role_date","LoopVerticalScrollRect")
    if self.rightDataLoopScrollView then
        self.rightDataLoopScrollView:AddListener(function(...) self:OnRightDataChanged(...) end)
    end
    self.objRightRoleList = self:FindChild(self.rightDataPanel, "Content")
    self.objRightRoleItem = self:FindChild(self.rightDataPanel, 'Content/BattleRecord_rightItem')
    self.objRightRoleItem:SetActive(false)

    self:InitData()

    if self.leftDataLoopScrollView then
        self.leftDataLoopScrollView.totalCount = getTableSize(self.leftDataList)
        self.leftDataLoopScrollView:RefillCells()
    end

    if self.rightDataLoopScrollView then
        self.rightDataLoopScrollView.totalCount = getTableSize(self.rightDataList)
        self.rightDataLoopScrollView:RefillCells()
    end

    self.leftCampResult_win = self:FindChild(self.dataPanel,"Left_state/Image_v")
    self.leftCampResult_lose = self:FindChild(self.dataPanel,"Left_state/Image_f")
    self.rightCampResult_win = self:FindChild(self.dataPanel,"Right_state/Image_v")
    self.rightCampResult_lose = self:FindChild(self.dataPanel,"Right_state/Image_f")

    if (self.victoryCamp == 1) then
        self.leftCampResult_win:SetActive(true)
        self.leftCampResult_lose:SetActive(false)
        self.rightCampResult_win:SetActive(false)
        self.rightCampResult_lose:SetActive(true)
    else
        self.leftCampResult_win:SetActive(false)
        self.leftCampResult_lose:SetActive(true)
        self.rightCampResult_win:SetActive(true)
        self.rightCampResult_lose:SetActive(false)
    end

    self.battleLogPart = self:FindChild(self._gameObject,"BattleLog")
    self.battleLogPart:SetActive(true)
    self.battleLogPart.transform:SetTransLocalPosition(-9999,-9999,0)
    
    self.battleLogLoopScrollView = self:FindChildComponent(self.battleLogPart,"MainNode/SC_log","LoopVerticalScrollRect")
    if self.battleLogLoopScrollView then
        self.battleLogLoopScrollView:AddListener(function(...) self:OnBattleLogDataChanged(...) end)
    end

    self.battlelog = self.LogicMain:GetBattleLog()
    if (self.battlelog) then
        self.battleLogLoopScrollView.totalCount = getTableSize(self.battlelog)
        self.battleLogLoopScrollView:RefillCells()
    end

    self.logButton = self:FindChildComponent(self.dataPanel,"Button_log","Button")
    self:RemoveButtonClickListener(self.logButton)
    self:AddButtonClickListener(self.logButton, function()
        self.battleLogPart.transform:SetTransLocalPosition(0,0,0)
        self.battleLogLoopScrollView.verticalNormalizedPosition = 0
        self.battleLogLoopScrollView:RefillCells()
    end)

    self.battleLogCloseBtn = self:FindChildComponent(self.battleLogPart,"MainNode/ButtonClose","Button")
    self:RemoveButtonClickListener(self.battleLogCloseBtn)
    self:AddButtonClickListener(self.battleLogCloseBtn, function()
        self.battleLogPart.transform:SetTransLocalPosition(-9999,-9999,0)
    end)

end

function BattleStatisticalDataUI:OnBattleLogDataChanged(gameobj,index)
    local objtext = self:FindChildComponent(gameobj.gameObject,"Text","Text")
    objtext.text = self.battlelog[index+1]
end

function BattleStatisticalDataUI:OnLeftDataChanged(gameobj,index)
    if (self.leftDataList ~= nil) then
        local playerData = self.leftDataList[index+1]
        local obj = gameobj.gameObject
        local playerName = self:FindChildComponent(obj,'Text_name','Text')
        playerName.text = playerData.sName
        local playerDamage = self:FindChildComponent(obj,'Text_damage','Text')
        playerDamage.text = playerData.iDamage
        local playerInjure = self:FindChildComponent(obj,'Text_injured','Text')
        playerInjure.text = playerData.iHurt
        local playerRound = self:FindChildComponent(obj,'Text_turn','Text')
        playerRound.text = "存活:"..playerData.iSurviveRound.."回合"
        local playerHeadPic = self:FindChildComponent(obj,'Role_Head/head','Image')
        playerHeadPic.sprite = GetSprite(playerData.sHeadPath)
        local damagePercent = 0
        if (self.leftTotalDamage ~= 0) then
            --四舍五入
            damagePercent= math.floor(playerData.iDamage / self.leftTotalDamage * 100 + 0.5)
        end
        local playerDamagePercentScrollbar = self:FindChildComponent(obj,'Scrollbar_damage','Scrollbar')
        playerDamagePercentScrollbar.size = damagePercent/100
        local playerDamagePercentNum = self:FindChildComponent(obj,'Scrollbar_damage/Num_percent','Text')
        playerDamagePercentNum.text = damagePercent.."%"
        local injurePercent = 0
        if (self.leftTotalInjure ~= 0) then
            --四舍五入
            injurePercent = math.floor(playerData.iHurt / self.leftTotalInjure * 100 + 0.5)
        end
        local playerInjurePercentScrollbar = self:FindChildComponent(obj,'Scrollbar_injured','Scrollbar')
        playerInjurePercentScrollbar.size = injurePercent/100
        local playerInjurePercentNum = self:FindChildComponent(obj,'Scrollbar_injured/Num_percent','Text')
        playerInjurePercentNum.text = injurePercent.."%"
    end
end

function BattleStatisticalDataUI:OnRightDataChanged(gameobj,index)
    if (self.rightDataList ~= nil) then
        local playerData = self.rightDataList[index+1]
        local obj = gameobj.gameObject
        local playerName = self:FindChildComponent(obj,'Text_name','Text')
        playerName.text = playerData.sName
        local playerDamage = self:FindChildComponent(obj,'Text_damage','Text')
        playerDamage.text = playerData.iDamage
        local playerInjure = self:FindChildComponent(obj,'Text_injured','Text')
        playerInjure.text = playerData.iHurt
        local playerRound = self:FindChildComponent(obj,'Text_turn','Text')
        playerRound.text = "存活:"..playerData.iSurviveRound.."回合"

        
        local playerHeadPic = self:FindChildComponent(obj,'Role_Head/head','Image')
        playerHeadPic.sprite = GetSprite(playerData.sHeadPath)
        local damagePercent = 0
        if (self.rightTotalDamage ~= 0) then
            --四舍五入
            damagePercent= math.floor(playerData.iDamage / self.rightTotalDamage * 100 + 0.5)
        end
        local playerDamagePercentScrollbar = self:FindChildComponent(obj,'Scrollbar_damage','Scrollbar')
        playerDamagePercentScrollbar.size = damagePercent/100
        local playerDamagePercentNum = self:FindChildComponent(obj,'Scrollbar_damage/Num_percent','Text')
        playerDamagePercentNum.text = damagePercent.."%"
        local injurePercent = 0
        if (self.rightTotalInjure ~= 0) then
            --四舍五入
            injurePercent = math.floor(playerData.iHurt / self.rightTotalInjure * 100 + 0.5)
        end
        local playerInjurePercentScrollbar = self:FindChildComponent(obj,'Scrollbar_injured','Scrollbar')
        playerInjurePercentScrollbar.size = injurePercent/100
        local playerInjurePercentNum = self:FindChildComponent(obj,'Scrollbar_injured/Num_percent','Text')
        playerInjurePercentNum.text = injurePercent.."%"
    end
end

function BattleStatisticalDataUI:RefreshUI(info)
    self:InitData()
end

function BattleStatisticalDataUI:OnEnable()
    
    local wnd = GetUIWindow("WindowBarUI")
    if wnd then
        wnd:ClearSecondConfirm()
    end
    OpenWindowBar({
        ['windowstr'] = "BattleStatisticalDataUI", 
        ['bSaveToCache'] = false,
    })
end

function BattleStatisticalDataUI:OnDisable()
    RemoveWindowBar('BattleStatisticalDataUI')
end

function BattleStatisticalDataUI:OnDestroy()
    
end

return BattleStatisticalDataUI