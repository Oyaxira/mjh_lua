LimitShopDiscountPanalUI = class('LimitShopDiscountPanalUI', BaseWindow);


local BA_DAJINBI = 1
local BA_KANDAO = 2
local BA_BUYOUHUI = 3
function LimitShopDiscountPanalUI:ctor()
    self.bindBtnTable = {}
end

function LimitShopDiscountPanalUI:Create()
	local obj = LoadPrefabAndInit('LimitShopUI/LimitShopDiscountPanalUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function LimitShopDiscountPanalUI:Init()
    self.ItemDataManager = ItemDataManager:GetInstance()
    self.LimitShopManager = LimitShopManager:GetInstance()
   
    
    self.obj_btn_back = self:FindChild(self._gameObject,'Button_close')
    table.insert(self.bindBtnTable, self.obj_btn_back)
    

    self.obj_Action_ActionList = self:FindChild(self._gameObject,'ChooseBuyAction')
    self.obj_Action_ItemList = self:FindChild(self._gameObject,'ItemInfoList')
    self.com_Action_Text = self:FindChildComponent(self._gameObject,'Text','Text')
    self.com_Action_Title = self:FindChildComponent(self._gameObject,'title_box/Text','Text')
    
    self.obj_DiscountList = self:FindChild(self._gameObject,'DiscountList')
    self.com_BtnDetailsScroll = self.obj_DiscountList:GetComponent('LoopVerticalScrollRect')

    local obj_child  = self:FindChild(self.obj_DiscountList,'DiscountChild')
    obj_child:SetActive(false)

    if self.com_BtnDetailsScroll then
        self.com_BtnDetailsScroll:AddListener(function(...) self:OnDetailChanged(...) end)
    end

    self:BindBtnCB();

end

function LimitShopDiscountPanalUI:RefreshUI()
    self.akLimitShopDiscountData =  {}
    self.allDiscountList = self.LimitShopManager:GetDiscountList()
    for i,data in pairs(self.allDiscountList) do 
        table.insert( self.akLimitShopDiscountData, data)
        data.bOutTime = self.LimitShopManager:GetLeftTimeStr(data.iEndTime) and true or false 
    end 

    table.sort( self.akLimitShopDiscountData, function(a,b)
        if a.bOutTime == b.bOutTime then 
            return a.discount < b.discount
        else
            return a.bOutTime
        end 
    end  )

    self.curTime = os.clock()

    self:ShowBuyActionPanalDetails()
end


function LimitShopDiscountPanalUI:OnDetailChanged(gameobj,index)
    -- local iList = self.data_ShowiList 
    local DiscountData =  self.akLimitShopDiscountData and  self.akLimitShopDiscountData[index+1] 
    if not DiscountData then return end 
    local Object = gameobj.gameObject
    local str_sh = DiscountData.discount / 100

    
    Object:SetActive(true)

    local comtext = self:FindChildComponent(Object,'Num','Text')
    comtext.text = str_sh.. '折'
    
    local comtext2 = self:FindChildComponent(Object,'Image/Num','Text')
    comtext2.text = str_sh

    local comtext3 = self:FindChildComponent(Object,'TimeInfo','Text')
    local func = function()
        strleft = self.LimitShopManager:GetLeftTimeStr(DiscountData.iEndTime)
        if strleft then 
            comtext3.text = strleft
        else 
            comtext3.text = '已过期'
        end
    end 
    func()
    table.insert( self._callback_reflash,func)
end

function LimitShopDiscountPanalUI:ShowBuyActionPanalDetails()
    if not  self.akLimitShopDiscountData then return end 
    self._callback_reflash = {}
    self.com_BtnDetailsScroll.totalCount = #self.akLimitShopDiscountData
    self.com_BtnDetailsScroll:RefillCells()
end


function LimitShopDiscountPanalUI:LateUpdate()
    if self._callback_reflash then 
        for ii,func in pairs(self._callback_reflash) do 
            func()
        end
    end 
end 

function LimitShopDiscountPanalUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end
function LimitShopDiscountPanalUI:CommonBind(gameObject, callback)
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

function LimitShopDiscountPanalUI:OnclickBtn(obj, boolHide)
    if obj == self.obj_btn_back then 
        RemoveWindowImmediately('LimitShopDiscountPanalUI')
    end 
end

function LimitShopDiscountPanalUI:OnEnable()
end

function LimitShopDiscountPanalUI:OnDisable()
end

function LimitShopDiscountPanalUI:OnDestroy()
    
end

return LimitShopDiscountPanalUI;