ShareUI = class('ShareUI', BaseWindow);
local dkJson = require("Base/Json/dkjson")
local msdkCombineFriendList = {}
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

g_ShareFriendClickReward = false

function ShareUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function ShareUI:Create()
	local obj = LoadPrefabAndInit('TownUI/ShareUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function ShareUI:Init()
    self.objFriendList = self:FindChild(self._gameObject,"FriendsList")
    self.comFriendList = self.objFriendList:GetComponent("LoopHorizontalScrollRect")
	if self.comFriendList then
		self.comFriendList:AddListener(function(...) self:UpdateFriendGroup(...) end)
    end
    
    self.rewardBtn = self:FindChildComponent(self._gameObject,"Button_get","DRButton") 
    if self.rewardBtn then 
        local fun = function()
            self:OnClick_Btn_Reward()
        end
        self:AddButtonClickListener(self.rewardBtn,fun)
    end 
    if (g_ShareFriendClickReward) then
        setUIGray(self.rewardBtn:GetComponent("Image"),true)
    else
        setUIGray(self.rewardBtn:GetComponent("Image"),false)
    end
    self.closeBtn = self:FindChildComponent(self._gameObject,"Button_close","DRButton") 
    if self.closeBtn then 
        local fun = function()
			RemoveWindowImmediately('ShareUI')
        end
        self:AddButtonClickListener(self.closeBtn,fun)
    end

    self.objReward1 = self:FindChild(self._gameObject,"Reward_1")
    self.objReward2 = self:FindChild(self._gameObject,"Reward_2")
    self.objReward3 = self:FindChild(self._gameObject,"Reward_3")
    self.objRewardGet1 = self:FindChild(self.objReward1,"Image_get")
    self.objRewardGet2 = self:FindChild(self.objReward2,"Image_get")
    self.objRewardGet3 = self:FindChild(self.objReward3,"Image_get")
    self.objRewardGet1:SetActive(false)
    self.objRewardGet2:SetActive(false)
    self.objRewardGet3:SetActive(false)
    self.textNumber = self:FindChildComponent(self._gameObject,"Text_num","Text") 

    self:InitShareItem()
    self:InitShareCount()
end

function ShareUI:InitShareItem()
    self.objRewardItems = {}
    for index = 1, 3 do
        table.insert(self.objRewardItems, self:FindChild(self._gameObject, string.format("Reward_%d/ItemIconUI", index)))
        self.objRewardItems[index]:SetActive(true)
    end
    local activityBaseData = TableDataManager:GetInstance():GetTableData("ActivityBase", 1003)
    if (not activityBaseData or not activityBaseData.RewardItems) then
        return
    end

    for index = 1, #activityBaseData.RewardItems do
        if (self.objRewardItems[index] and activityBaseData.RewardItems[index] ) then
            local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",activityBaseData.RewardItems[index]["ItemId"])
            self.ItemIconUI:UpdateUIWithItemTypeData(self.objRewardItems[index], itemTypeData)
            self.ItemIconUI:SetItemNum(self.objRewardItems[index], activityBaseData.RewardItems[index]["ItemNum"], activityBaseData.RewardItems[index]["ItemNum"] <= 1)
        end
    end
end

function ShareUI:InitShareCount()
    local data = CS.UnityEngine.PlayerPrefs.GetString('SHARE_COUNT_'..tostring(MSDKHelper:GetOpenID()))
    if data and data ~= '' then
        local json = dkJson.decode(data)
        local ts = json['ts']
        if MSDKHelper:IsSameDay(ts, GetCurServerTimeStamp()) ~= true then
            MSDKHelper:SetShareCount(0)
        else
            MSDKHelper:SetShareCount(json['count'])
        end
    else
        MSDKHelper:SetShareCount(0)
    end
    
    self:SetShareCount()
end

function ShareUI:SaveShareCount()
    local json = {
        ['ts'] = GetCurServerTimeStamp(),
        ['count'] = MSDKHelper:GetShareCount()
    }
    local jsonStr = dkJson.encode(json)
    CS.UnityEngine.PlayerPrefs.SetString('SHARE_COUNT_'..tostring(MSDKHelper:GetOpenID()), jsonStr)
end

function ShareUI:UpdateFriendGroup(transform, index)
	if not (msdkCombineFriendList and transform and index) then
		return
	end
	local objGroup = transform.gameObject
	local objInfo = msdkCombineFriendList[index+1]
	if not (objInfo and objGroup) then
		return
    end
    local objNode_button = self:FindChildComponent(objGroup, "Button_share", "DRButton")
    self:RemoveButtonClickListener(objNode_button)
    self:AddButtonClickListener(objNode_button, function ()
        local channel = MSDKHelper:GetChannel()
        local shareCallBack = function()
        end
        if (channel == "WeChat") then
            MSDKHelper:ShareInviteToWX(objInfo.sopenid, shareCallBack)
        elseif (channel == "QQ") then
            MSDKHelper:ShareInviteToQQ(objInfo.sopenid, shareCallBack)
        end	
        self:OnShareSuccess()
    end)
	self:FindChildComponent(objGroup, "Text_name", "Text").text = objInfo.nick_name
	local objHeadPic = self:FindChildComponent(objGroup,"Head/Mask/Image","Image")
	local picSize = ""
	if (MSDKHelper:GetChannelId()==1) then
		picSize = "/46"
    end
    if (objInfo.head_img_url) then
        GetHeadPicByUrl(objInfo.head_img_url..picSize,function(sprite)
            objHeadPic.sprite = sprite
        end)
    end
end

function ShareUI:OnShareSuccess()
    dprint('OnShareSuccess')
    MSDKHelper:SetShareCount(MSDKHelper:GetShareCount() + 1)
    self:SetShareCount()
end

function ShareUI:SetShareCount()
    local shareCount = MSDKHelper:GetShareCount()
    if shareCount > 6 then
        shareCount = 6
    end
    self.textNumber.text = '已邀请<color=#2b851c>'..tostring(shareCount)..'</color>/6人'
    if shareCount >= 1 then
        self.objRewardGet1:SetActive(true)
    end
    if shareCount >= 3 then
        self.objRewardGet2:SetActive(true)
    end
    if shareCount >= 6 then
        self.objRewardGet3:SetActive(true)
    end
end

function ShareUI:OnClick_Btn_Reward()
    if (g_ShareFriendClickReward) then
        SystemUICall:GetInstance():Toast('您已领取过奖励')
        return
    end
    local shareCount = MSDKHelper:GetShareCount()
    if shareCount > 6 then
        shareCount = 6
    end

    if (shareCount <= 0) then
        SystemUICall:GetInstance():Toast('您还未分享过好友')
        return
    end

    local sendActivity = function()
        SendActivityOper(SAOT_EVENT, 0, SATET_SHAREFRIEND, shareCount)
        SendActivityOper(SAOT_RECEIVE, 1003, shareCount)
        -- 这里设置按钮变灰
        g_ShareFriendClickReward = true
        setUIGray(self.rewardBtn:GetComponent("Image"),true)
    end

    if (shareCount < 6) then
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, "您并没有分享完毕全部的6位好友,此时领取将无法获得顶级奖励,确定领取奖励吗?",sendActivity})
    else
        sendActivity()
    end
end

function ShareUI:FriendListFreshData()
	if MSDKHelper then
        local callback = function(list)
			msdkCombineFriendList = list
            self.comFriendList.totalCount = #msdkCombineFriendList
			self.comFriendList:RefillCells()
		end
		MSDKHelper:GetRecallFriendList(callback) 
	end
end

function ShareUI:RefreshUI(info)
	self:FriendListFreshData()
end

function ShareUI:OnEnable()

end

function ShareUI:OnDestroy()
    self:SaveShareCount()
    self.ItemIconUI:Close()
end

function ShareUI:OnDisable()
    self:SaveShareCount()
end

return ShareUI;