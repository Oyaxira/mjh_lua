IconPreviewUI = class("IconPreviewUI", BaseWindow)
TB_Language =  reloadModule("Data/Language")  
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

local MAXCOUNT = 5 * 6 
function IconPreviewUI:ctor()
    self.curPage = 0
    self.MAX_PAGE = 0
    self._ItemlData = {}
    self.iCurItemType = 0
    self.objItemButton={}
    self.itemIndex2Type = {}
end

function IconPreviewUI:Create()
end

function IconPreviewUI:Init(gameObject,barAndName)
    self:SetGameObject(gameObject)
    self._gameObject.name="UILayerRoot"
    self._barAndName=barAndName
    self.BattleField =  DRCSRef.FindGameObj("BattleField")
    self.btn_return = self:FindChildComponent(self._gameObject,"IconPreview/btn_Return","DRButton")
	self.btn_Rigt = self:FindChildComponent(self._gameObject,"IconPreview/btn_Rigt","DRButton")
    self.btn_Left = self:FindChildComponent(self._gameObject,"IconPreview/btn_Left","DRButton") 
    self.pageNumber=self:FindChildComponent(self._gameObject,"IconPreview/Page/text","Text")
    self.itemNumber=self:FindChildComponent(self._gameObject,"IconPreview/MaxCount/text","Text")
    self.iconPath=self:FindChildComponent(self._gameObject,"IconPreview/Path/InputField","InputField")

    self.objIconPreview = self:FindChild(self._gameObject,"IconPreview")
    self.objIconPreview.gameObject:SetActive(true)

    self.ItemIconUI = ItemIconUI.new()
    if	self.btn_return then
		local fun = function()
            self:Reset()
        end
        --移除点击监听
        self:RemoveButtonClickListener(self.btn_return)
        --添加监听
		self:AddButtonClickListener(self.btn_return,fun)
    end

    if	self.btn_Rigt then
		local fun = function()
            self:NextPage()
            self:RefreshIcon()
        end
        self:RemoveButtonClickListener(self.btn_Rigt)
		self:AddButtonClickListener(self.btn_Rigt,fun)
    end
    if	self.btn_Left then
		local fun = function()
            self:LastPage()
            self:RefreshIcon()
        end
        self:RemoveButtonClickListener(self.btn_Left)
		self:AddButtonClickListener(self.btn_Left,fun)
    end

    self.comItemLoopScrollView = self:FindChildComponent(self._gameObject,"IconPreview/Item_Node","LoopVerticalScrollRect")
    if self.comItemLoopScrollView then
		local fun = function(transform, idx)
			self:OnItemScrollChanged(transform, idx)
        end
        self.comItemLoopScrollView:AddListener(fun)
    end
    
   --获取Item道具的数据
    local Local_TB_Item = reloadModule("Data/Item")

    local itemType = ItemTypeDetail_Revert
    self._ItemlData[0]={}
    for _,value in pairs(Local_TB_Item) do
        if value then
            if  value["Icon"] == nil  then
                 value["Icon"] = "ItemIcon/icon_que"
             end
            --self._ItemlData[#self._ItemlData + 1] = value
            local type=value.ItemType
            if itemType[type] ~= 0 then
                if self._ItemlData[type] == nil then
                    self._ItemlData[type] = {}
                end
                -- table.insert(self._ItemlData[0],value)
                -- table.insert(self._ItemlData[type],value)
                if self._ItemlData[0][#self._ItemlData[0]]==nil then
                    --table.insert(self._ItemlData,value)
                    table.insert(self._ItemlData[0],value)
                    table.insert(self._ItemlData[type],value)
                end
                if self._ItemlData[0][#self._ItemlData[0]].NameID~=value.NameID or self._ItemlData[0][#self._ItemlData[0]]==nil then
                    --table.insert(self._ItemlData,value)
                    table.insert(self._ItemlData[0],value)
                    table.insert(self._ItemlData[type],value)
                end
            end
        end
    end
    --self.MAX_PAGE = #self._ItemlData[self.iCurItemType] / MAXCOUNT+1
    self:RefreshMaxPage()

    --分类
    local comDropdown = self:FindChildComponent(self._gameObject,"IconPreview/Dropdown","Dropdown")
    comDropdown.options:Clear();
    local tt = CS.UnityEngine.UI.Dropdown.OptionData("全部")
    self.itemIndex2Type[0] = 0
    comDropdown.options:Add(tt);
    local iIndex = 1

    for key, value in pairs(ItemTypeDetail_Lang) do
        if key  ~= 0 then
            self.itemIndex2Type[iIndex] = key
			iIndex = iIndex + 1
            local name = GetLanguageByID(value) 
            local tt = CS.UnityEngine.UI.Dropdown.OptionData(name)
            comDropdown.options:Add(tt);
		end
    end
	comDropdown.value = 0
    self.iCurItemType = 0
    
    local _callback = function(index)
		self:ChangeItemType(index)
	end
    comDropdown.onValueChanged:AddListener(_callback)




    
end

function IconPreviewUI:Reset()
    self.BattleField.gameObject:SetActive(true)
    self.objIconPreview:SetActive(false)
    self._barAndName.gameObject:SetActive(true)
end

function IconPreviewUI:RefreshIcon()
    self.BattleField.gameObject:SetActive(false)
    self.objIconPreview:SetActive(true)

    -- if  self.comItemLoopScrollView then
    --     self.comItemLoopScrollView.totalCount =  MAXCOUNT
    --     self.comItemLoopScrollView:RefillCells()
    -- end
    self:ChangeItemType(0)

    self:RefreshMaxPage()
end

function IconPreviewUI:NextPage()
    self.curPage = self.curPage + 1
    self.curPage = math.fmod(self.curPage, self.MAX_PAGE)
end

function IconPreviewUI:LastPage()
    self.curPage = self.curPage - 1
    if self.curPage < 0 then
        self.curPage = self.curPage  + self.MAX_PAGE
    end
end
function IconPreviewUI:RefreshMaxPage()
    self.MAX_PAGE = #self._ItemlData[self.iCurItemType] / MAXCOUNT+1
end

function IconPreviewUI:ChangeItemType(iIndex)
    self.iCurItemType = self.itemIndex2Type[iIndex]
    self.MAX_PAGE = #self._ItemlData[self.iCurItemType] / MAXCOUNT+1
    if  self.comItemLoopScrollView then
		self.comItemLoopScrollView.totalCount =  #self._ItemlData[self.iCurItemType]
		self.comItemLoopScrollView:RefillCells()
    end
    --更新该类别道具总数text
    self.itemNumber.text=#self._ItemlData[self.iCurItemType]
    self:ResetButtonEffect()
end
function IconPreviewUI:OnClickItem(button)

    local iIndex = self.objItemButton[button] 
    self:ResetButtonEffect(iIndex)
    local effect=self:FindChild(button.gameObject,"Lighteffet")
    
    local isActive=effect.activeSelf
    effect:SetActive(not isActive)

    --路径text显示
    local tName=GetLanguageByID(self._ItemlData[self.iCurItemType][iIndex].NameID);
    self.iconPath.text=tName.."的路径: "..self._ItemlData[self.iCurItemType][iIndex].Icon
end

function IconPreviewUI:ResetButtonEffect(index)
    for bt, idx in pairs(self.objItemButton) do  
        if idx~=index then 
            local effectT=self:FindChild(bt.gameObject,"Lighteffet")
            effectT:SetActive(false)
        end
    end
end

function IconPreviewUI:OnItemScrollChanged(item,index)
    index = index + 1 --+ self.curPage * MAXCOUNT 
    
	local button = item.gameObject:GetComponent("Button")
	if self.objItemButton[button] == nil then
        local fun = function()
			self:OnClickItem(button);
		end
		self:AddButtonClickListener(button, fun)
	end

	if button then
		self.objItemButton[button] = index
    end
    
	local kItemData = self._ItemlData[self.iCurItemType][index]
	if kItemData then
		self.ItemIconUI:UpdateItemIcon(item.gameObject, kItemData)
		local languageData = TB_Language[kItemData.NameID]
		local str = ""
		if languageData then
			str = languageData
        end
        local name=GetLanguageByID(kItemData.NameID);
        self.ItemIconUI:SetItemNum(item.gameObject,name)
        --位置调整
        local nameText=self:FindChildComponent(item.gameObject,"Num","RectTransform")
        nameText.anchoredPosition=DRCSRef.Vec2(nameText.anchoredPosition.x,-52)
        --self.ItemIconUI:SetItemNum(item.gameObject,"222")
	end
end

return IconPreviewUI