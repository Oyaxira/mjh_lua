local dkJson = require("Base/Json/dkjson")
GuessCoinUI = class('GuessCoinUI', BaseWindow);

function GuessCoinUI:ctor()
end

function GuessCoinUI:Create()
	local obj = LoadPrefabAndInit('LimitShopUI/GuessCoinUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function GuessCoinUI:Init()
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance()
    self.LimitShopManager = LimitShopManager:GetInstance()
    self.LimitShopData = self.LimitShopManager:GetShopShowData()
    self.GuessRoundData = TableDataManager:GetInstance():GetTable("TimeLimitGuessCoinV2")
    
    self.obj_btn_back = self:FindChildComponent(self._gameObject, "Button_close", "Button") 
	if self.obj_btn_back then
		self:RemoveButtonClickListener(self.obj_btn_back)
		self:AddButtonClickListener(self.obj_btn_back, function ()
            RemoveWindowImmediately('GuessCoinUI')
            SendLimitShopOpr(EN_LIMIT_SHOP_GET)
        end)
    end
    self.startData = {1,2,3}
    self.obj_btn_start = self:FindChildComponent(self._gameObject, "Game_panel/Button_start", "Button") 
	if self.obj_btn_start then
		self:RemoveButtonClickListener(self.obj_btn_start)
		self:AddButtonClickListener(self.obj_btn_start, function ()
            self:StartGuess()
        end)
	end
    self.obj_BowlLeft = self:FindChild(self._gameObject,'Game_panel/Table_node/Left')
    self.obj_BowlLeftBtn = self:FindChildComponent(self._gameObject, "Game_panel/Table_node/Left", "Button")
    if self.obj_BowlLeftBtn then
		self:RemoveButtonClickListener(self.obj_BowlLeftBtn)
		self:AddButtonClickListener(self.obj_BowlLeftBtn, function ()
            dprint("####click obj_BowlLeftBtn")
            self:ChooseBowl("Left")
        end)
	end
    self.obj_BowlMiddle = self:FindChild(self._gameObject,'Game_panel/Table_node/Middle')
    self.obj_BowlMiddleBtn = self:FindChildComponent(self._gameObject, "Game_panel/Table_node/Middle", "Button")
    if self.obj_BowlMiddleBtn then
		self:RemoveButtonClickListener(self.obj_BowlMiddleBtn)
		self:AddButtonClickListener(self.obj_BowlMiddleBtn, function ()
            dprint("####click obj_BowlMiddleBtn")
            self:ChooseBowl("Middle")
        end)
	end
    self.obj_BowlRight = self:FindChild(self._gameObject,'Game_panel/Table_node/Right')
    self.obj_BowlRightBtn = self:FindChildComponent(self._gameObject, "Game_panel/Table_node/Right", "Button")
    if self.obj_BowlRightBtn then
		self:RemoveButtonClickListener(self.obj_BowlRightBtn)
		self:AddButtonClickListener(self.obj_BowlRightBtn, function ()
            dprint("####click obj_BowlRightBtn")
            self:ChooseBowl("Right")            
        end)
	end
    
    self.obj_CostCoinText = self:FindChildComponent(self._gameObject,'Game_panel/Button_start/Image/value_bottom/Num',"Text")
    self.nowPos = {self.obj_BowlLeft.transform,self.obj_BowlMiddle.transform,self.obj_BowlRight.transform}
    self.originTransPosX = {self.nowPos[1].position.x,self.nowPos[2].position.x,self.nowPos[3].position.x}
    self.originTransPosY = tonumber(self:FindChild(self.obj_BowlLeft,'Image_bottle').transform.position.y)
    self.moveSpeed = {1,0.75,0.5}
    self:AddEventListener("GET_YAZHURETDATA", function(info)
        self:GetYaZhuRet(info)
    end)
    self:AddEventListener("YAZHURETDATA", function(info)
        self:YaZhuRet(info)
	end)
end

--选择杯子押注
function GuessCoinUI:ChooseBowl(bowlName)
    --关闭所有按钮
    self.obj_btn_start.gameObject:SetActive(false)
    self.obj_btn_back.interactable = false
    self.obj_BowlLeftBtn.interactable = false
    self.obj_BowlMiddleBtn.interactable = false
    self.obj_BowlRightBtn.interactable = false
    -- 2代表中间 开始永远是最大的
    local posIndex = 1
    local maxPosIndex = 1
    for i=1,3 do
        if (self.nowPos[i].name == bowlName) then
            posIndex = i
        end
        if (self.retData[i] == 2) then
            maxPosIndex = i
        end
    end
    -- local resultIndex = self.retData[posIndex]
    -- dprint("###"..resultIndex)    
    if (posIndex ~= maxPosIndex) then
        self:ChangeBowl0Alpha(maxPosIndex)
    end
    self:OpenBowl(posIndex)
    --发送押注消息 
    self:ChooseGuessChoice(posIndex-1)
end

function GuessCoinUI:RefreshUI(info)
    dprint("#### RefreshUI ")    
    --关闭押注按钮
    self.obj_BowlLeftBtn.interactable = false
    self.obj_BowlMiddleBtn.interactable = false
    self.obj_BowlRightBtn.interactable = false
    
    --reset状态：位置 左中右永远按位置开始 透明度 金币数
    if (self.retData~=nil) then
        for i=1,3 do 
            self.startData[i] = tonumber(self.retData[i])
        end
    end
    for i=1,3 do
        self:CloseBowl(i)
        self:ChangeBowl1Alpha(i)
    end
    self:RefreshData()   
end

function GuessCoinUI:RefreshData()
    if not self.gameLevel then
        self.gameLevel = self.LimitShopManager:GetNowGuessCoinGameLevel()
    end
    LuaEventDispatcher:dispatchEvent('UPDATE_GUESSCOIN_BUTTON',self.gameLevel);
    if (self.gameLevel > 3) then
        SystemUICall:GetInstance():Toast("猜旺旺币3局游戏已结束")
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false, nil, "猜旺旺币3局游戏已结束")
        self:AddTimer(300,function()
            RemoveWindowImmediately('GuessCoinUI')
            SendLimitShopOpr(EN_LIMIT_SHOP_GET)
        end)
        local winDialogRec = GetUIWindow("DialogControlUI")
        if winDialogRec then
            winDialogRec:HideBtns()
        end
        return
    end

    for k,v in pairs(self.GuessRoundData) do
        if (v.GameLevel == self.gameLevel and v.GameType == 1) then
            self.CoinCostNum = v.CoinCostNum
            self.LeftCoin = v.LeftCoin
            self.MidCoin = v.MidCoin
            self.RightCoin = v.RightCoin
            self.MoveTime = v.MoveTime
            self.MoveNum = v.MoveNum
            break
        end
    end
    self:SetBowlCoin(1,self.LeftCoin)
    self:SetBowlCoin(2,self.MidCoin)
    self:SetBowlCoin(3,self.RightCoin)
    self.obj_CostCoinText.text = self.CoinCostNum
    self:AddTimer(300,function()
        for i=1,3 do
            self:OpenBowl(i)
        end
        --打开 开始游戏|关闭界面按钮
        self.obj_btn_start.gameObject:SetActive(true)
        self.obj_btn_back.interactable = true
    end)
end

function GuessCoinUI:SwapBowlByList(list,speed)
    CS_Coroutine.start(function()
        for i=1,#list do
            dprint("swap:"..list[i][1].." "..list[i][2])
            self:SwapBowl(tonumber(list[i][1]),tonumber(list[i][2]),speed)
            coroutine.yield(CS.UnityEngine.WaitForSeconds(speed));
            if (i==#list) then
                self.obj_BowlLeftBtn.interactable = true
                self.obj_BowlMiddleBtn.interactable = true
                self.obj_BowlRightBtn.interactable = true
            end
        end
    end)	
end

function GuessCoinUI:SwapBowl(posi,posj,speed)
    local bowl1 = self.nowPos[posi]
    local bowl2 = self.nowPos[posj]
    bowl1:DOMoveX(self.originTransPosX[posj],speed)
    bowl2:DOMoveX(self.originTransPosX[posi],speed)
    self.nowPos[posi] = bowl2
    self.nowPos[posj] = bowl1
end

function GuessCoinUI:OpenBowl(pos)
    local bowl = self:FindChild(self.nowPos[pos].gameObject,'Image_bottle').transform
    bowl:DOMoveY(self.originTransPosY+8,0.2)
end

function GuessCoinUI:CloseBowl(pos)
    local bowl = self:FindChild(self.nowPos[pos].gameObject,'Image_bottle').transform
    bowl:DOMoveY(self.originTransPosY,0.2)
end

function GuessCoinUI:ChangeBowl0Alpha(pos)
    local bowlImage = self:FindChildComponent(self.nowPos[pos].gameObject,'Image_bottle',"Image")
    local targetColor = DRCSRef.Color(1.0, 1.0, 1.0, 125/255)
    bowlImage:DOColor(targetColor,0.5)
end

function GuessCoinUI:ChangeBowl1Alpha(pos)
    local bowlImage = self:FindChildComponent(self.nowPos[pos].gameObject,'Image_bottle',"Image")
    local targetColor = DRCSRef.Color(1.0, 1.0, 1.0, 1.0)
    bowlImage:DOColor(targetColor,0.5)
end

function GuessCoinUI:SetBowlCoin(pos,num)
    local bowl = self.nowPos[pos]
    for i = 1,bowl.childCount - 1 do
        if (num == i and i~=5 ) then
            bowl:GetChild(i-1).gameObject:SetActive(true)
        elseif (num > 4 and i == 5) then
            self:FindChildComponent(bowl:GetChild(i-1).gameObject,"Image_bottom/Text_num","Text").text = tostring(num)
            bowl:GetChild(i-1).gameObject:SetActive(true)
        else
            bowl:GetChild(i-1).gameObject:SetActive(false)
        end
    end
end

function GuessCoinUI:CreateSwapQueue()
    --此局的押注结果 
    local retData = self.LimitShopManager:GetNowGuessCoinGameRetData()
    self.retData = {}
    for i=1,3 do
        self.retData[i] = retData[i]+1
    end
    local result = (retData[1]+1)*100+(retData[2]+1)*10+retData[3]+1
    dprint("###"..result)
    local swapTimes = self.MoveNum
    --偶数次下 从123开始必须加1次移动次数变奇数次才能到达这些结果
    if (swapTimes % 2 == 0) and (result == 213 or result == 132 or result == 321) then
        swapTimes = swapTimes+1
    end
    --奇数次下 从123开始必须加1次移动次数变偶数次才能到达这些结果
    if (swapTimes % 2 == 1) and (result == 123 or result == 312 or result == 231) then
        swapTimes = swapTimes+1
    end
    
    local start = {1,2,3}
    self.SwapBowlList = {}
    local r = 1
    for i=1,swapTimes-1 do
        r = math.random(1,3)
        local swapI = {1,2,3}
        table.remove(swapI,r)
        table.insert(self.SwapBowlList,swapI)
        local temp = start[swapI[1]]
        start[swapI[1]] = start[swapI[2]]
        start[swapI[2]] = temp
    end
    --倒数第二次往服务器发的结果靠
    local swapLast = {}
    for i=1,3 do
        if start[i]~=retData[i]+1 then
            table.insert(swapLast,i)
        end
    end
    table.insert(self.SwapBowlList,swapLast)
    self:SwapBowlByList(self.SwapBowlList,self.moveSpeed[self.gameLevel])
end

--获取押注回调
function GuessCoinUI:GetYaZhuRet(info)
    --获取押注成功失败都会进入这个消息
    --成功 info.acData里有押注结果
    --不成功 info.dwParam=1 旺旺币不足
    --押注的时候金币不足也会回调 此时 info.dwParam=2
    if info then
        if info.acData then
            local data = dkJson.decode(info.acData)
            if data and data['yaZhu'] then
                --扣除旺旺币（仅展示）
                local nowCoin =  self.PlayerSetDataManager:GetPlayerSecondGold() - self.CoinCostNum
                local golddata = {["eMoneyType"] = STLMT_SECONDGOLD,["dwCurNum"] = nowCoin}
                self.PlayerSetDataManager:UpdateCurrency(golddata)            
                local windowBarUI = GetUIWindow("WindowBarUI")
                if windowBarUI then 
                    windowBarUI:UpdateWindow()
                end

                for i=1,3 do
                    self:CloseBowl(i)
                end
                self:AddTimer(1000,function()
                    self:CreateSwapQueue()
                end)
            end
        elseif info.dwParam then
            if (info.dwParam == 1) then
                --SystemUICall:GetInstance():Toast("旺旺币不足！",false)
                self.obj_btn_start.gameObject:SetActive(true)
                self.obj_btn_back.interactable = true 
                --self:RefreshUI(nil)
                RemoveWindowImmediately('GuessCoinUI')
                SendLimitShopOpr(EN_LIMIT_SHOP_GET)
                OpenWindowImmediately("Gold2SecondGoldUI")
            end
        end
    end
end


function GuessCoinUI:YaZhuRet(info)
    --押注回调：
    --押注次数 dwParam
    --是否成功 dwParam2
    --押注获得的旺旺币数目 dwParam3
    if info then
        self.gameLevel = info.dwParam + 1
        --获得旺旺币（仅展示）
        local nowCoin =  self.PlayerSetDataManager:GetPlayerSecondGold() + info.dwParam3
        local golddata = {["eMoneyType"] = STLMT_SECONDGOLD,["dwCurNum"] = nowCoin}
        self.PlayerSetDataManager:UpdateCurrency(golddata)            
        local windowBarUI = GetUIWindow("WindowBarUI")
        if windowBarUI then 
            windowBarUI:UpdateWindow()
        end
    end
    --下一局开始
    self:AddTimer(3000,function()
        self:RefreshUI(nil)
    end)
end

function GuessCoinUI:StartGuess()
    self.obj_btn_start.gameObject:SetActive(false)
    self.obj_btn_back.interactable = false                
    SendLimitShopOpr(EN_LIMIT_SHOP_GETYAZHU)    
end

function GuessCoinUI:ChooseGuessChoice(index)
   --给服务器发下注消息 服务器位置定义是 0 1 2
    SendLimitShopOpr(EN_LIMIT_SHOP_YAZHU,0,index)
end

function GuessCoinUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "GuessCoinUI", 
        ['topBtnState'] = {
            ['bBackBtn'] = false,
            ['bGoodEvil'] = false,
            ['bSilver'] = false,
            ['bCoin'] = false,
        },
        ['bSaveToCache'] = false,
    })
end

function GuessCoinUI:OnDisable()
    RemoveWindowBar('GuessCoinUI')
    self.gameLevel = nil
end


function GuessCoinUI:OnDestroy()
    self:RemoveEventListener('GET_YAZHURETDATA');
    self:RemoveEventListener('YAZHURETDATA');
end

return GuessCoinUI;