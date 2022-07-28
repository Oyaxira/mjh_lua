AllRewardWindowUI = class("AllRewardWindowUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'



function AllRewardWindowUI:ctor()

end

function AllRewardWindowUI:Create()
	local obj = LoadPrefabAndInit("ActivityCommonUI/AllRewardWindowUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function AllRewardWindowUI:Init()    
    self.ItemIconUI = ItemIconUI.new()
    self.ItemDataManager = ItemDataManager:GetInstance()
    
    self.objButton_close = self:FindChild(self._gameObject,'PopUpWindow/Board/Button_close')
    self:CommonBind(self.objButton_close,function()
        self:CloseUI()
    end )

    self.comloopscrollview = self:FindChildComponent(self._gameObject,'SC_Reward',DRCSRef_Type.LoopVerticalScrollRect)
    if self.comloopscrollview then
        self.comloopscrollview:AddListener(function(...) self:OnItemChanged(...) end)
    end
end

function AllRewardWindowUI:RefreshUI(infoTable)
    if not infoTable or not infoTable.iStage then 
        self:CloseUI()
        return
    end
    self.iStage = infoTable.iStage

    self.rewarditem_Map = {}
    self._Point = {}
    for iIndex,IPoint in ipairs(infoTable.activity.StageGoal) do 
        if not self.rewarditem_Map[IPoint] then 
            self._Point[#self._Point+1] = IPoint
            self.rewarditem_Map[IPoint] = {}
        end 
        if infoTable.activity.RewardItems[iIndex] then 
            self.rewarditem_Map[IPoint][#self.rewarditem_Map[IPoint] +1] =  infoTable.activity.RewardItems[iIndex]
        end 
    end 
    table.sort( self._Point )

    self.comloopscrollview.totalCount = #self._Point
    self.comloopscrollview:RefillCells()
end
function AllRewardWindowUI:OnItemChanged(transform,index)
    local objChild = transform.gameObject
    local iPoint = self._Point[index+1]
    if not iPoint then 
        return 
    end 
    local dataRewarditem = self.rewarditem_Map[iPoint]
    if not dataRewarditem then 
        return 
    end 
    local comText_value = self:FindChildComponent(objChild,'Text_value','Text')
    comText_value.text = iPoint

    local objImageDone = self:FindChild(objChild,'Image_bottom_done')
    local bGot = self.iStage >= (index+1)
    objImageDone:SetActive(bGot)


    local objRewardNode = self:FindChild(objChild,'RewardNode')
    for iIndex = 1, objRewardNode.transform.childCount  do
        local objchild = objRewardNode.transform:GetChild(iIndex-1).gameObject
        if objchild then  
            local iRewarditemID = dataRewarditem[iIndex].ItemId
            local iRewarditemNum = dataRewarditem[iIndex].ItemNum
            
            if iRewarditemID and iRewarditemNum then 
                objchild:SetActive(true)
                local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(iRewarditemID)
                self.ItemIconUI:UpdateUIWithItemTypeData(objchild, ItemTypeData)
                self.ItemIconUI:SetItemNum(objchild, iRewarditemNum > 1 and iRewarditemNum or '')    
                local objGotReward  = self:FindChild(objchild, "GotReward")
                objGotReward:SetActive(bGot)
            else
                objchild:SetActive(false)
            end 
        end 
    end
end

function AllRewardWindowUI:CloseUI()
    RemoveWindowImmediately("AllRewardWindowUI")
end
function AllRewardWindowUI:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent(DRCSRef_Type.Button);
    local tog = gameObject:GetComponent(DRCSRef_Type.Toggle);
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
function AllRewardWindowUI:OnDestroy()
    self.ItemIconUI:Close()
end

return AllRewardWindowUI
