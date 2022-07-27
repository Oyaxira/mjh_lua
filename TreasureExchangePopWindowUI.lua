TreasureExchangePopWindowUI = class("TreasureExchangePopWindowUI",BaseWindow)


function TreasureExchangePopWindowUI:ctor()
    
end

function TreasureExchangePopWindowUI:Create()
	local obj = LoadPrefabAndInit("TreasureExchangeUI/TreasureExchangePopWindowUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TreasureExchangePopWindowUI:Init()
    self.comText_ActiveDate = self:FindChildComponent(self._gameObject,'Root/AD/Date','Text')

    self.PlayerSetDataMgr = PlayerSetDataManager:GetInstance()
    self.ActivityHelper = ActivityHelper:GetInstance()

end
function TreasureExchangePopWindowUI:OnCallBackFunction()

end 
function TreasureExchangePopWindowUI:RefreshUI(info)

    self.icon1 = info.icon1
    self.Num1 = info.Num1 or 0
    self.icon2 = info.icon2
    self.Num2 = info.Num2 or 0
    self.iActivityID = info.iActivityID or 0
    

    local com_Itemicon1 = self:FindChildComponent(self._gameObject,'Item1/icon','Image') 
    local com_Itemicon2 = self:FindChildComponent(self._gameObject,'Item2/icon','Image') 
    self:SetSpriteAsync(self.icon1,com_Itemicon1)
    self:SetSpriteAsync(self.icon2,com_Itemicon2)


    local com_ItemHavaNum1 = self:FindChildComponent(self._gameObject,'Item1/Text','Text') 
    local com_ItemHavaNum2 = self:FindChildComponent(self._gameObject,'Item2/Text','Text') 
    com_ItemHavaNum1.text = self.PlayerSetDataMgr:GetTreasureExchangeValue(1)
    com_ItemHavaNum2.text = self.PlayerSetDataMgr:GetTreasureExchangeValue(2)

    local com_Btnicon1 = self:FindChildComponent(self._gameObject,'Button1/Image_yinding','Image') 
    local com_Btnicon2 = self:FindChildComponent(self._gameObject,'Button2/Image_yinding','Image') 
    self:SetSpriteAsync(self.icon1,com_Btnicon1)
    self:SetSpriteAsync(self.icon2,com_Btnicon2)

    local com_BtnNumber1 = self:FindChildComponent(self._gameObject,'Button1/Number','Text') 
    local com_BtnNumber2 = self:FindChildComponent(self._gameObject,'Button2/Number','Text') 
    com_BtnNumber1.text = self.Num1 or 0
    com_BtnNumber2.text = self.Num2 or 0

    local obj_Btn1 = self:FindChild(self._gameObject,'Button1') 
    local obj_Btn2 = self:FindChild(self._gameObject,'Button2') 
    self:CommonBind(obj_Btn1,function()
        SendActivityOper(SAOT_EVENT,self.iActivityID,SATET_REFRESH_EXCHANGE,0)
        self:exit()
    end )
    self:CommonBind(obj_Btn2,function()
        SendActivityOper(SAOT_EVENT,self.iActivityID,SATET_REFRESH_EXCHANGE,1)
        self:exit()
    end )


    local obj_BtnQuit = self:FindChild(self._gameObject,'PopUpWindow_2/Board/Button_close') 
    self:CommonBind(obj_BtnQuit,function()
        self:exit()
    end )
end
function TreasureExchangePopWindowUI:exit()
    RemoveWindowImmediately('TreasureExchangePopWindowUI')
end

function TreasureExchangePopWindowUI:OnEnable()
end

function TreasureExchangePopWindowUI:OnDisable()
end

function TreasureExchangePopWindowUI:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent('Button')
    local tog = gameObject:GetComponent('Toggle')
    if btn then
        local _callback = function()
            callback(gameObject)
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback)
    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide)
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)
    end
end

function TreasureExchangePopWindowUI:OnDestroy()

end
return TreasureExchangePopWindowUI
