local dkJson = require("Base/Json/dkjson")
ClickDiscountUI = class('ClickDiscountUI', BaseWindow);

function ClickDiscountUI:ctor()
    self.role_muzhuangs_anim={}
end

function ClickDiscountUI:Create()
	local obj = LoadPrefabAndInit('LimitShopUI/ClickDiscountUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function ClickDiscountUI:GetState()
    local playerID = globalDataPool:getData('PlayerID');
    return GetConfig(tostring(playerID).."#ClickDiscount_State")
end

function ClickDiscountUI:SetState(stateName)
    local playerID = globalDataPool:getData('PlayerID');
    SetConfig(tostring(playerID).."#ClickDiscount_State",stateName)
end

function ClickDiscountUI:Init()
    self.state = self:GetState()
    if (self.state == nil) then
        self:SetState("bargainClickPanel")
    end
	self.LimitShopManager = LimitShopManager:GetInstance()
    self.LimitShopData = TableDataManager:GetInstance():GetTable("TimeLimitConfig")[1]
    --BigCoinCovGlod=180,TriggerLv=24,CountDown=30,RequireNum=15,CutGoldNum=170,ActivityTime=120,}
    self.obj_btn_back = self:FindChildComponent(self._gameObject, "Button_close", "Button") 
	if self.obj_btn_back then
		self:RemoveButtonClickListener(self.obj_btn_back)
        self:AddButtonClickListener(self.obj_btn_back, function ()
            self:CloseUI(0)
        end)
    end
    self.discountAnim=self._gameObject:GetComponent("Animator")


    self.obj_panel_bargainClick = self:FindChild(self._gameObject,"Panel_barginClick")

    self.role_muzhuangs_anim[#self.role_muzhuangs_anim+1]=self:FindChildComponent(self.obj_panel_bargainClick,"bg4/muzhuang01/ObjGraphic","SkeletonGraphic")
    self.role_muzhuangs_anim[#self.role_muzhuangs_anim+1]=self:FindChildComponent(self.obj_panel_bargainClick,"bg4/muzhuang02/ObjGraphic","SkeletonGraphic")
    self.role_muzhuangs_anim[#self.role_muzhuangs_anim+1]=self:FindChildComponent(self.obj_panel_bargainClick,"bg4/muzhuang03/ObjGraphic","SkeletonGraphic")


    self.ef_glow1=self:FindChildComponent(self.obj_panel_bargainClick,"ef_hdjdglow2","ParticleSystem")
    self.txt_bargainCountDown = self:FindChildComponent(self.obj_panel_bargainClick,"Text_countdown","Text")
    self.obj_woodBlood = self:FindChild(self.obj_panel_bargainClick,"HP/Sliding Area/Handle")
    self.obj_woodBlood.transform.localScale= DRCSRef.Vec3(1, 1, 1)
    self.txt_originPrice = self:FindChildComponent(self.obj_panel_bargainClick,"Text_price","Text")
    self.txt_originPrice.text = "价值"..self.LimitShopData.BigCoinCovGlod.."金锭"
    self.btn_barginClick = self:FindChildComponent(self.obj_panel_bargainClick,"Button_bargain","Button")
    setUIGray(self.btn_barginClick:GetComponent("Image"),false)
    self.btn_barginClick.enabled = true

    if self.btn_barginClick then
		self:RemoveButtonClickListener(self.btn_barginClick)
        self:AddButtonClickListener(self.btn_barginClick, function ()
            self:ClickBargain()
        end)
    end
    self.txt_clickBargainTime = self:FindChildComponent(self.obj_panel_bargainClick,"Button_bargain/Num","Text")
    self.clickNum = 0
    self.clickWoodAni1 = self:FindChildComponent(self.obj_panel_bargainClick,"wood1","ParticleSystem")
    self.clickWoodAni2 = self:FindChildComponent(self.obj_panel_bargainClick,"wood2","ParticleSystem")
    self.clickWoodAni3 = self:FindChildComponent(self.obj_panel_bargainClick,"wood3","ParticleSystem")

    self.obj_panel_shareOrBuy = self:FindChild(self._gameObject,"Panel_shareOrBuy")
    self.ef_glow2=self:FindChildComponent(self.obj_panel_shareOrBuy,"ef_hdjdglow","ParticleSystem")
    -- self.txt_percent = self:FindChildComponent(self.obj_panel_shareOrBuy,"Text_percent","Text")
    -- local percent = (self.LimitShopData.BigCoinCovGlod - self.LimitShopData.CutGoldNum)/self.LimitShopData.BigCoinCovGlod * 100
    -- self.txt_percent.text = string.format("%.2f",percent).."%"
    self.img_percent1 = self:FindChild(self.obj_panel_shareOrBuy,"Image_title/Image1")
    self.img_percent2 = self:FindChild(self.obj_panel_shareOrBuy,"Image_title/Image2")
    self.bar_percent = self:FindChildComponent(self.obj_panel_shareOrBuy,"process","Scrollbar")
    self.text_percent = self:FindChildComponent(self.obj_panel_shareOrBuy,"process/Image/Text","Text")
    self.txt_bargainOverPrice = self:FindChildComponent(self.obj_panel_shareOrBuy,"Text_price","Text")
    self.txt_bargainOverPrice.text = self.LimitShopData.CutGoldNum
    self.txt_buyCountDown = self:FindChildComponent(self.obj_panel_shareOrBuy,"Text_time","Text")
    self.btn_shareClick = self:FindChildComponent(self.obj_panel_shareOrBuy,"Button_share","Button")
    if self.btn_shareClick then
		self:RemoveButtonClickListener(self.btn_shareClick)
        self:AddButtonClickListener(self.btn_shareClick, function ()
            self:ShareBargain()
        end)
    end
    self.txt_shareTime = self:FindChildComponent(self.obj_panel_shareOrBuy,"Button_share/Num","Text")
    self.txt_shareText = self:FindChildComponent(self.obj_panel_shareOrBuy,"Button_share/Text","Text")
    self:GetShareNum()

    self.btn_buyCoinClick = self:FindChildComponent(self.obj_panel_shareOrBuy,"Button_buy","Button")
    if self.btn_buyCoinClick then
		self:RemoveButtonClickListener(self.btn_buyCoinClick)
        self:AddButtonClickListener(self.btn_buyCoinClick, function ()
            self:BuyOrGetCoin(false)
        end)
    end
    self.txt_coinOriginPrice = self:FindChildComponent(self.obj_panel_shareOrBuy,"Button_buy/Text_originPrice","Text")
    self.txt_coinOriginPrice.text = self.LimitShopData.BigCoinCovGlod
    self.txt_coinBargainPrice = self:FindChildComponent(self.obj_panel_shareOrBuy,"Button_buy/Text_originPrice/Text_bargainPrice","Text")
    self.txt_coinBargainPrice.text = self.LimitShopData.BigCoinCovGlod - self.LimitShopData.CutGoldNum

    self.obj_panel_clickOver = self:FindChild(self._gameObject,"Panel_clickOver")
    self.btn_restart = self:FindChildComponent(self.obj_panel_clickOver,"Button_restart","Button")
    if self.btn_restart then
		self:RemoveButtonClickListener(self.btn_restart)
        self:AddButtonClickListener(self.btn_restart, function ()
            self:RefreshUI(nil)
        end)
    end
    self.btn_giveup = self:FindChildComponent(self.obj_panel_clickOver,"Button_giveup","Button")
    if self.btn_giveup then
		self:RemoveButtonClickListener(self.btn_giveup)
        self:AddButtonClickListener(self.btn_giveup, function ()
            self:CloseUI(0)
        end)
    end

    self.countdown_SkeletonGraphic = self:FindChildComponent(self._gameObject,"CountDown_node/Spine_countdown","SkeletonGraphic")

    self:AddEventListener("CLICKDISCOUNT_SHARE", function(info)
        self:ShareBargainCallback(info)
	end)
    self:AddEventListener("CLICKDISCOUNT_BUYORGET", function()
        self:BuyOrGetCoinCallback()
	end)
end


function ClickDiscountUI:RefreshUI(info)
    self.state = self:GetState()
    if self.state == "bargainClickPanel" then
        self.obj_panel_bargainClick.gameObject:SetActive(false)
        self.obj_panel_shareOrBuy.gameObject:SetActive(false)

        --只刷新这个panel的东西
        --先播放321
        self.countdownFlag = 0
        self:PlayCountdown321()
        --重新进click清零 时间也重新开始
        self.timer = self:AddTimer(3000,function()
            self.obj_panel_bargainClick.gameObject:SetActive(true)
            self.ef_glow1.gameObject:SetActive(true)

            self.countdownFlag = 1
            self.startclicktime = os.time()
            self.clickNum = 0
            self.obj_woodBlood.transform.localScale= DRCSRef.Vec3(1, 1, 1)
            self.txt_clickBargainTime.text = self.clickNum.."/"..self.LimitShopData.RequireNum
            self.clickWoodAni1.gameObject:SetActive(false)
            self.clickWoodAni2.gameObject:SetActive(false)
            self.clickWoodAni3.gameObject:SetActive(false)
        end)
    else
        self.countdownFlag = 1
        self.countdown_SkeletonGraphic.gameObject:SetActive(false)
        self.obj_panel_bargainClick.gameObject:SetActive(false)
        self.obj_panel_shareOrBuy.gameObject:SetActive(true)
        --self.obj_panel_shareOrBuy.transform:DOScale(DRCSRef.Vec3(0.3,0.3,1),0.3):From()

        self.discountAnim:SetTrigger("Start")
        self.ef_glow1.gameObject:SetActive(false)
        self.ef_glow2.gameObject:SetActive(true)
        self.ef_glow2:Play()
        if self.shareNum == 2 then
            self:ShareState(true)
        else
            self:ShareState(false)
        end
        self.txt_buyCountDown.text = self.LimitShopManager:GetLeftTimeStr(self.LimitShopManager:GetShareEndTime()).."后过期"
    end
    self.obj_panel_clickOver.gameObject:SetActive(false)    
end

--获取当前已分享次数
function ClickDiscountUI:GetShareNum()
    self.shareNum = 0
    if self.LimitShopManager.share then
        if self.LimitShopManager.share.shareNum then
            self.shareNum = self.LimitShopManager.share.shareNum
        end
    end
end

--分享按钮
function ClickDiscountUI:ShareBargain()
    if (self.shareNum>=2) then
        self:BuyOrGetCoin(true)
    else
        SendLimitShopOpr(EN_LIMIT_SHOP_FIRSTSHARE)
        
    end
end

--分享回调
function ClickDiscountUI:ShareBargainCallback(info)
    if info then
        self.shareNum = tonumber(info.dwParam2)
        if self.shareNum == 2 then
            self:ShareState(true)
        else
            self.txt_shareTime.text = self.shareNum.."/2"
        end
    end
end

function ClickDiscountUI:ShareState(isFinished)
    if (isFinished) then
        self.txt_shareText.text = "      免费领取"
        self.txt_shareTime.gameObject:SetActive(false)
        --购买按钮变灰
        setUIGray(self.btn_buyCoinClick:GetComponent("Image"),true)
        self.btn_buyCoinClick.enabled = false
        --修改图片
        self.txt_bargainOverPrice.text = self.LimitShopData.BigCoinCovGlod
        self.img_percent1:SetActive(false)
        self.img_percent2:SetActive(true)
        self.bar_percent.size = 1
        self.text_percent.text = "免费领取"
    else
        self.txt_shareText.text = "分享2位好友即可免费领取"
        self.txt_shareTime.gameObject:SetActive(true)
        self.txt_shareTime.text = self.shareNum.."/2"
        --购买按钮
        setUIGray(self.btn_buyCoinClick:GetComponent("Image"),false)
        self.btn_buyCoinClick.enabled = true
        --修改图片
        self.txt_bargainOverPrice.text = self.LimitShopData.CutGoldNum
        self.img_percent1:SetActive(true)
        self.img_percent2:SetActive(false)
        self.bar_percent.size = self.LimitShopData.CutGoldNum / self.LimitShopData.BigCoinCovGlod
        self.text_percent.text = "即将砍成"
    end

end

--购买获得旺旺币按钮 / 免费获得旺旺币
function ClickDiscountUI:BuyOrGetCoin(forFree)
    -- ReCharge(int bigGold, bool bFristShareBuy)
    if (forFree) then
        SendLimitShopOpr(EN_LIMIT_SHOP_RECHARGE,0,1,1)
    else
        PlayerSetDataManager:GetInstance():RequestSpendGold(10, function()
            SendLimitShopOpr(EN_LIMIT_SHOP_RECHARGE,0,1,1)
        end)
    end
end

--购买获得旺旺币的成功回调 失败金锭不足会自动提示
function ClickDiscountUI:BuyOrGetCoinCallback()
    --成功 关闭界面
    SystemUICall:GetInstance():Toast("成功获得旺旺币1个")
    self:CloseUI(1)
end

function ClickDiscountUI:ChangeState()
    self:SetState("shareOrBuyPanel")
    self.state = "shareOrBuyPanel"
    self:RefreshUI(nil)
end

--播放砍木桩刀光特效
function ClickDiscountUI:PlayWoodAnimation(clickStage,callBack)
    self.clickWoodAni1.gameObject:SetActive(true)
    self.clickWoodAni2.gameObject:SetActive(true)
    self.clickWoodAni3.gameObject:SetActive(true)
    self.clickWoodAni1:Play()
    self.clickWoodAni2:Play()
    self.clickWoodAni3:Play()

    --受击打和准备动作动画名
    local actionName='injured'
    local standName='prepare'

    if clickStage==1 then
        actionName='injured'
        standName='prepare'
    elseif clickStage==2 then
        actionName='injured2'
        standName='prepare_f'
    elseif clickStage==3 then
        actionName='injured3'
        standName='prepare_l'
    elseif clickStage==4 then
        actionName='injured4'
        standName=nil
    end

    --role
    for key, skeletonGraphic in pairs(self.role_muzhuangs_anim) do
        skeletonGraphic.AnimationState:SetAnimation(0, actionName, false)
        if standName ~=nil then
            skeletonGraphic.AnimationState:AddAnimation(0,standName,true,0)
        end
        if callBack then
            self.timer2=globalTimer:AddTimer(1000,callBack)
            --skeletonGraphic.AnimationState.Complete=callBack
        end
    end

end

function ClickDiscountUI:ClickBargain()
    local clickStage=0
    if (self.clickNum < self.LimitShopData.RequireNum) then
        self.clickNum = self.clickNum + 1
        self.txt_clickBargainTime.text = self.clickNum.."/"..self.LimitShopData.RequireNum    
        local scale = 1 - self.clickNum/self.LimitShopData.RequireNum
        self.obj_woodBlood.transform.localScale= DRCSRef.Vec3(scale, 1, 1)
        --1-4 第一阶段 5-9第二阶段 10-14 第三阶段 15爆
        if self.clickNum>=1 and self.clickNum<=4 then
            clickStage=1
        elseif self.clickNum>=5 and self.clickNum<=9 then
            clickStage=2
        elseif self.clickNum>=10 and self.clickNum<=14 then
            clickStage=3
        else
            clickStage=4
        end
        if (clickStage < 4) then
            self:PlayWoodAnimation(clickStage,nil)
        else
            setUIGray(self.btn_barginClick:GetComponent("Image"),true)
            self.btn_barginClick.enabled = false    
            self:PlayWoodAnimation(clickStage,function() self:ChangeState() end)
        end
    end    
end

function ClickDiscountUI:PlayCountdown321(info)
    SetSkeletonAnimation(self.countdown_SkeletonGraphic, 0, 'animation', false)

end

function ClickDiscountUI:Update()
    if (self.state == "bargainClickPanel" and self.countdownFlag == 1) then
        if (os.time() - self.startclicktime < self.LimitShopData.CountDown) then
            local cur = self.LimitShopData.CountDown - (os.time() - self.startclicktime)
            self.txt_bargainCountDown.text = string.format("%d",cur).."秒后结束"
        else
            if (self.clickNum>0) then
                self:ChangeState()
            else
                self.state = "clickOverPanel"
                self.obj_panel_clickOver.gameObject:SetActive(true)
            end
        end
    elseif (self.state == "shareOrBuyPanel") then
        local str = self.LimitShopManager:GetLeftTimeStr(self.LimitShopManager:GetShareEndTime())
        if str then 
            str = str .. "后过期"
        else 
            str = ''
        end
        self.txt_buyCountDown.text = str
    end
end

function ClickDiscountUI:CloseUI(isSuccess)
    RemoveWindowImmediately('ClickDiscountUI')
    if isSuccess == 1 then
        --参数2 代表成功1失败2 
        -- SendLimitShopAction(2,1)         
        -- DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_LIMITSHOP, false)
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_OPENLIMITSHOP, false)

    else
        --消息相关
        --参数2 代表成功1失败2 
        -- SendLimitShopAction(2,2) 
    end

end

function ClickDiscountUI:OnDisable()
    if self.timer then
        self:RemoveTimer(self.timer);
        self.timer = nil;
    end
    if self.timer2 then
        self:RemoveTimer(self.timer2);
        self.timer2 = nil;
    end
end


function GuessCoinUI:OnDestroy()
    self:RemoveEventListener('CLICKDISCOUNT_SHARE');
end

return ClickDiscountUI;