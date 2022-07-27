Gold2SecondGoldUI = class("Gold2SecondGoldUI", BaseWindow)


function Gold2SecondGoldUI:Create()
    local obj = LoadPrefabAndInit("Game/Gold2SecondGoldUI",TIPS_Layer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function Gold2SecondGoldUI:Init()
    -- 
    self.playerSetMgr = PlayerSetDataManager:GetInstance()


    self.obj_Button_close = self:FindChild(self._gameObject,'Button_close')
    self:CommonBind(self.obj_Button_close)
    self.obj_Button_buy = self:FindChild(self._gameObject,'Board/Button_buy')
    self:CommonBind(self.obj_Button_buy)
    self.obj_Button_Add = self:FindChild(self._gameObject,'Board/number/Button_add')
    self:CommonBind(self.obj_Button_Add)
    self.obj_Button_minus = self:FindChild(self._gameObject,'Board/number/Button_minus')
    self:CommonBind(self.obj_Button_minus)
    self.obj_Button_all = self:FindChild(self._gameObject,'Board/number/Button_all')
    self:CommonBind(self.obj_Button_all)


    self.com_HaveNum = self:FindChildComponent(self._gameObject,'Board/HaveNum','Text')

    self.com_ChooseNum = self:FindChildComponent(self._gameObject,'Board/number/Image/Text','Text')
    
    self.com_PriceNum = self:FindChildComponent(self._gameObject,'Board/Button_buy/Number','Text')

    self.com_Title = self:FindChildComponent(self._gameObject,'Board/Bottom/Top/Title','Text')

    if self.com_Title then 
        self.com_Title.text = '【购买旺旺币】'
    end 
    self.MAX_TANS_NUM = 9999
end

function Gold2SecondGoldUI:CommonBind(gameObject, callback)
    if not callback then 
        callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
    end
    local btn = gameObject:GetComponent('Button');
    local tog = gameObject:GetComponent('Toggle');
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)
    end
end

function Gold2SecondGoldUI:OnclickBtn(obj, boolHide)
    if obj == self.obj_Button_close then 
        self:DoExit()
    elseif obj == self.obj_Button_buy then 
        self:BuyBox()
    elseif obj == self.obj_Button_Add then 
        self:OperateNumSelector(1)
        
    elseif obj == self.obj_Button_minus then 
        self:OperateNumSelector(-1)

    elseif obj == self.obj_Button_all then 
        self:OperateNumSelector(0)

    end 
end 

function Gold2SecondGoldUI:OperateNumSelector(iValue)
    -- 正数: 增加, 负数: 减少, 零: 全部 
    if not iValue then return end 
    local iGold = self.playerSetMgr:GetPlayerGold() or 0 
    -- local iGold = 100000
    local max = math.max(1,math.floor(iGold / self.data_price))
    local min = 1 
    if iValue  == 0 then 
        self.data_choosenum  = max 
    else 
        self.data_choosenum = self.data_choosenum + iValue
    end 
    self.data_choosenum = math.min(self.data_choosenum ,max)
    self.data_choosenum = math.max(self.data_choosenum ,min)

    self:RefreshPriceUI()
end

function Gold2SecondGoldUI:RefreshUI(info)
    self.data_choosenum = 1
    self.TB_TimeLimitConfig = TableDataManager:GetInstance():GetTableData("TimeLimitConfig",1)
    self.data_price = self.TB_TimeLimitConfig.BigCoinCovGlod or 180

    local curtime = os.time()
    local CurTime = os.date('*t',curtime)
    -- local iCurD = tonumber(os.date("%d",curtime)) 
    -- local iCurM = tonumber(os.date("%m",curtime)) 
    -- local iCurY = tonumber(os.date("%y",curtime))
    local CurData = {Year=CurTime.year,Month=CurTime.month,Day=CurTime.day} 

    local func_comparetime = function(timea,timeb)
        -- 1 bigger 
        -- -1 smaller
        -- 0 equal
        if timea.Year ~= timeb.Year then 
            return timea.Year > timeb.Year and 1 or -1
        elseif timea.Month ~= timeb.Month then 
            return timea.Month > timeb.Month and 1 or -1
        elseif timea.Day ~= timeb.Day then 
            return timea.Day > timeb.Day and 1 or -1
        else 
            return 0 
        end 
    end 

    local TB_TimeLimitGiftActivity = TableDataManager:GetInstance():GetTable('TimeLimitGiftActivity')
    self.curActivity = nil
    if TB_TimeLimitGiftActivity then 
        for i,TimeLimitGiftActivity in pairs(TB_TimeLimitGiftActivity) do 
            if func_comparetime(CurData,TimeLimitGiftActivity.BeginDate) ~= -1 then 
                if func_comparetime(TimeLimitGiftActivity.EndDate,CurData) ~= -1 then 
                    self.curActivity = TimeLimitGiftActivity
                    break
                end 
            end 
        end 
    end 

    self:RefreshPriceUI()

end

function Gold2SecondGoldUI:RefreshPriceUI()
    self.com_HaveNum.text = string.format('拥有%d',self.playerSetMgr:GetPlayerSecondGold())

    self.com_ChooseNum.text = self.data_choosenum


    self.data_iPrice = self.data_price * self.data_choosenum
    self.com_PriceNum.text = self.data_iPrice

    local content = string.format( "是否花费%d金锭购买%d个旺旺币",self.data_iPrice,self.data_choosenum)
    if self.curActivity then 
        local iFenmu = self.curActivity.BuyNum or 1
        local iFenzi = self.curActivity.GiveNum or 0
        local iSong = math.floor( self.data_choosenum /iFenmu ) * iFenzi
        if iSong > 0 then 
            content = string.format( "%s，并且购买后赠送%d个旺旺币，共得到%d个旺旺币？",content,iSong,iSong + self.data_choosenum   )
        end 
    end 

    self.GeneralBoxContent = {
        ['title'] = '系统提示',
        ['text'] = content,
        ['btnType'] = "gold",
        ['num'] = self.data_iPrice,
    }
end

function Gold2SecondGoldUI:BuyBox()
    local type = GeneralBoxType.Pay_TIP

    local Callback = function()
        self:DoExit()
        PlayerSetDataManager:GetInstance():RequestSpendGold(
            self.data_iPrice,
            function()
                SendLimitShopOpr(EN_LIMIT_SHOP_RECHARGE,nil,self.data_choosenum,nil,nil)
            end
        )
    end
    OpenWindowImmediately('GeneralBoxUI', {type, self.GeneralBoxContent, Callback})
end

function Gold2SecondGoldUI:ClearInput()

end

function Gold2SecondGoldUI:DoExit()
    RemoveWindowImmediately("Gold2SecondGoldUI")
end

return Gold2SecondGoldUI