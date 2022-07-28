ModelPreviewUI = class("ModelPreviewUI",BaseWindow)
local ModelPlaneViewUI = require 'UI/ModelPreview/ModelPlaneViewUI'
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local IconPreviewUI = require  'UI/ModelPreview/IconPreviewUI'
-- 皮肤数量最大值
function ModelPreviewUI:ctor()
	self.objSpineChangeButton = {}
	self.objSkinToggle = {}
	self.objWeaponButton = {}
	self.objBGPerfabs = {}
	self.iCurSpineIndex = 0
	self.iCurSkinIndex = 0
	self.iCurSpineAnimaitionIndex = 0
	self.iCurBGIndex = 0
	self.Vec3 = DRCSRef.Vec3(1,1,1)
	self.curWeaponBaseID = 412602 --随便给了把武器

	self.iSpineScaleX = 100
	self.iSpineScaleY = 100
	self.iWeaponScaleX = 100
	self.iWeaponScaleY = 100
	self.index2Type = {}
	self.iCurItemType = 0
	self.iCurEnhanceGrade = 0

	self.pressButton=0
	self.pressTimer=0

	self.pointDownTime = 0
	self.iHandleCall = 0
end

function ModelPreviewUI:Init(go)
	self:SetGameObject(go)
	self._gameObject.name="UILayerRoot"
	self.roleModelData =  ModelPreviewDataManager:GetInstance():GetRoleModelData()
	self.kBGData =  ModelPreviewDataManager:GetInstance():GetBattleBG()
	self.kWeaponData = ModelPreviewDataManager:GetInstance():GetWeaponData()
	self.SpineRoleUI = SpineRoleUI.new()
	self.ItemIconUI = ItemIconUI.new()
    self.comGraphicLoopScrollView = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Spines_Node","LoopHorizontalScrollRect")
    if self.comGraphicLoopScrollView then
		local fun = function(transform, idx)
			self:OnScrollChanged(transform, idx)
        end
        self.comGraphicLoopScrollView:AddListener(fun)
	end

    self.comSkinLoopScrollView = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Skins_Node","LoopVerticalScrollRect")
    if self.comSkinLoopScrollView then
		local fun = function(transform, idx)
			self:OnSkinScrollChanged(transform, idx)
        end
        self.comSkinLoopScrollView:AddListener(fun)
	end

	self.comItemLoopScrollView = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Item_Node","LoopVerticalScrollRect")
	self.chooseWeaponImage=self:FindChildComponent(self._gameObject,"OneSpineShowNode/Item_Node/Choose","RectTransform")
    if self.comItemLoopScrollView then
		local fun = function(transform, idx)
			self:OnItemScrollChanged(transform, idx)
        end
        self.comItemLoopScrollView:AddListener(fun)
	end
	--所有的text提示,模型路径、皮肤路径、动作名、背景名
	self.textModlePath = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/ModlePath","Text")
	self.textTexturePath = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/TexturePath","Text")
	self.textAnimaitionText = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/Action_Change/Text_Name","Text") 
	self.textBGName = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/BG_Change/Text_Name","Text")
	--缩放倍数
	self.textSpineScaleX = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/Role_Scale_Node/Scale_Wide/Text_Num","Text")
	self.textSpineScaleY = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/Role_Scale_Node/Scale_Heigh/Text_Num","Text")
	self.textWeaponScaleX = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/Weapon_Scale_Node/Scale_Wide/Text_Num","Text")
	self.textWeaponScaleY = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/Weapon_Scale_Node/Scale_Heigh/Text_Num","Text")
	--武器名
	self.textWeaponEnhanceGrade = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/Waopon_EnhanceGrade_Node/Text_Name","Text")
	self.textWeaponEnhanceGrade.text = self.iCurSpineAnimaitionIndex
	self.textWeaponSteng=self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/WeaponSteng","Text")

	self.textWeaponName =  self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/WeaponName","Text")
	self.textWeaponPath =  self:FindChildComponent(self._gameObject,"OneSpineShowNode/Left_Node/WeaponPath","Text")
	self.BattleGrid =  DRCSRef.FindGameObj("BattleField/BattleGrid")
	self.BattleGridButton = self:FindChildComponent(self._gameObject,"OneSpineShowNode/BattleGridButton","DRButton")
	if	self.BattleGridButton then
		local fun = function()
			local active = self.BattleGrid.gameObject.activeSelf
			self.BattleGrid.gameObject:SetActive(not active)
		end
		self:AddButtonClickListener(self.BattleGridButton,fun)
	end
	--模型界面
	self.btnDRButton =  self:FindChildComponent(self._gameObject,"OneSpineShowNode/DRButton","DRButton")
	if	self.btnDRButton then
		local fun = function()
			ModelPlaneViewUI = ModelPlaneViewUI.new()
			ModelPlaneViewUI:Init(DRCSRef.FindGameObj("UILayerRoot"))
			
			ModelPlaneViewUI:SetData(self)
			ModelPlaneViewUI:RefreshUI()
		end
		self:AddButtonClickListener(self.btnDRButton,fun)
	end
	--图标界面
	self.btnIConButton =  self:FindChildComponent(self._gameObject,"OneSpineShowNode/IConButton","DRButton")
	if	self.btnIConButton then
		local fun = function()
			--把血条和name隐藏
			self.comGraphicLoopScrollView.gameObject:SetActive(false)
			IconPreviewUI = IconPreviewUI.new()
			IconPreviewUI:Init(DRCSRef.FindGameObj("UILayerRoot"),self.comGraphicLoopScrollView)
			IconPreviewUI:RefreshIcon()
		end
		self:AddButtonClickListener(self.btnIConButton,fun)
	end
	self.objSpine = DRCSRef.FindGameObj("BattleField/Battle_ActorNode/ActorNode")
	self.objNode = DRCSRef.FindGameObj("BattleField/Battle_ActorNode")
	self.weaponNode = self:FindChild(self.objSpine,"weapon_Node")
	self.skeletonAnimation = self.objSpine:GetComponent("SkeletonAnimation")
	--角色动作
	local button = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Action_Change/Button_minus")
	if button then
		AddEventTrigger(button,function () self:OnClick_SpineAni_LeftButton() end,DRCSRef.EventTriggerType.PointerDown)
	end
	local button1 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Action_Change/Button_add")
	if button1 then
		AddEventTrigger(button1,function () self:OnClick_SpineAni_RightButton() end,DRCSRef.EventTriggerType.PointerDown)
	end
	--角色缩放

	-- local function OnPrease()
	-- 	self.pointDownTime = os.clock()
	-- 	self.iHandleCall = globalTimer:AddTimer(33,funaddc,-1)
	-- end

	-- PointerDown += function()
	-- 	self.pointDownTime = os.clock()
	-- 	local iTimerIndex = globalTimer:AddTimer(1000,func)

	-- end

	-- PointerUP += function()
	-- 	globalTimer:RemoveTimer(self.iHandleCall)
	-- 	globalTimer:RemoveTimer(self.iTimerIndex)

	-- end 

	local button2 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Role_Scale_Node/Scale_Wide/Button_add")
	
	if button2 then
		RemoveEventTrigger(button2)
		
		AddEventTrigger(button2,function () self:ChangeSpineScale(1,0) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button2,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	local button3 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Role_Scale_Node/Scale_Wide/Button_minus")
	if button3 then
		RemoveEventTrigger(button3)

		AddEventTrigger(button3,function () self:ChangeSpineScale(-1,0) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button3,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	local button4 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Role_Scale_Node/Scale_Heigh/Button_add")
	if button4 then
		RemoveEventTrigger(button4)

		AddEventTrigger(button4,function () self:ChangeSpineScale(0,1) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button4,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	local button5 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Role_Scale_Node/Scale_Heigh/Button_minus")
	if button5 then
		RemoveEventTrigger(button5)

		AddEventTrigger(button5,function () self:ChangeSpineScale(0,-1) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button5,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	--武器缩放
	local button6 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Weapon_Scale_Node/Scale_Wide/Button_add")
	if button6 then
		RemoveEventTrigger(button6)

		AddEventTrigger(button6,function () self:ChangeWeaponScale(1,0) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button6,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)
	end
	local button7 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Weapon_Scale_Node/Scale_Wide/Button_minus")
	if button7 then
		RemoveEventTrigger(button7)

		AddEventTrigger(button7,function () self:ChangeWeaponScale(-1,0) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button7,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	local button8 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Weapon_Scale_Node/Scale_Heigh/Button_add")
	if button8 then
		RemoveEventTrigger(button8)

		AddEventTrigger(button8,function () self:ChangeWeaponScale(0,1) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button8,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	local button9 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Weapon_Scale_Node/Scale_Heigh/Button_minus")
	if button9 then
		RemoveEventTrigger(button9)

		AddEventTrigger(button9,function () self:ChangeWeaponScale(0,-1) end,DRCSRef.EventTriggerType.PointerDown)
		AddEventTrigger(button9,function () self:ReleaseScaleButton() end,DRCSRef.EventTriggerType.PointerUp)

	end
	--武器强化
	local button10 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Waopon_EnhanceGrade_Node/Button_minus")
	if button10 then
		AddEventTrigger(button10,function () self:OnClick_WaoponEnhanceGrade_LeftButton() end,DRCSRef.EventTriggerType.PointerDown)
	end
	local button11 = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/Waopon_EnhanceGrade_Node/Button_add")
	if button11 then
		AddEventTrigger(button11,function () self:OnClick_WaoponEnhanceGrade_RightButton() end,DRCSRef.EventTriggerType.PointerDown)
	end
	--背景切换
	self.buttonBGAdd = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/BG_Change/Button_add")
	if self.buttonBGAdd  then
		AddEventTrigger(self.buttonBGAdd,function () self:OnClickRightBGButton() end,DRCSRef.EventTriggerType.PointerDown)
	end
	self.buttonBGDec = self:FindChild(self._gameObject,"OneSpineShowNode/Left_Node/BG_Change/Button_minus")
	if self.buttonBGDec then
		AddEventTrigger(self.buttonBGDec,function () self:OnClickLeftBGButton() end,DRCSRef.EventTriggerType.PointerDown)
	end

	LANGUAGE_TYPE = 0
	--武器分类下拉框
	local comDropdown = self:FindChildComponent(self._gameObject,"OneSpineShowNode/Dropdown","Dropdown")
	comDropdown.options:Clear();
	

	local tt = CS.UnityEngine.UI.Dropdown.OptionData("全部")
	comDropdown.options:Add(tt);
	self.index2Type[0] = 0
	local iIndex = 1
	for key, value in pairs(self.kWeaponData) do
		if key  ~= 0 then
			self.index2Type[iIndex] = key
			iIndex = iIndex + 1
			local name = GetLanguageByID(ItemTypeDetail_Lang[key]) 
			local tt = CS.UnityEngine.UI.Dropdown.OptionData(name)
			comDropdown.options:Add(tt);
		end
	end
	comDropdown.value = 0
	self.iCurItemType = 0

	local _callback = function(index)
		self:ChangeItemType(index)
	end
	comDropdown.onValueChanged:AddListener(_callback);


	-- self.objSkin_layout = DRCSRef.FindGameObj("UILayerRoot/skin_box/skin_layout")
	-- for i = 1, skin_num_max do
	-- 	self.array_objSkin[i] = self.objSkin_layout.transform:GetChild(i-1).gameObject
	-- 	self.array_objSkin[i]:SetActive(false)
	-- 	self.comSkin_child_Toggle[i] = self.array_objSkin[i]:GetComponent('Toggle')
	-- 	self.objSkin_child_border[i] = self.array_objSkin[i]:FindChild("toggle/border")
	-- 	if IsValidObj(self.comSkin_child_Toggle[i]) and IsValidObj(self.objSkin_child_border[i]) then
	-- 		local fun = function(bool)
	-- 			if bool then
	-- 				self:ChooseSkin(i,false)
	-- 				self.objSkin_child_border[i]:SetActive(true)
	-- 			else
	-- 				self.objSkin_child_border[i]:SetActive(false)
	-- 			end
	-- 		end
	-- 		self.comSkin_child_Toggle[i].onValueChanged:AddListener(fun)
	-- 	end
	-- end

	-- self.SC_Weapon = DRCSRef.FindGameObj("UILayerRoot/SC_Weapon"):GetComponent("LoopVerticalScrollRect")
    -- if IsValidObj(self.SC_Weapon) then
    --     local fun_Weapon = function(transform, idx)
    --         self:OnWeaponScrollChange(transform, idx)
    --     end
    --     self.SC_Weapon:AddListener(fun_Weapon)
	-- end
	
	-- self.imgCG = DRCSRef.FindGameObj("UILayerRoot/CG"):GetComponent("Image")
	-- self.Button.btnLeft_ChangeCG = nil --DRCSRef.FindGameObj("UILayerRoot/ChangeCG/Button_left"):GetComponent("Button")
	-- if IsValidObj(self.Button.btnLeft_ChangeCG) then
	-- 	local fun = function()
	-- 		self:OnClick_Left_Button()
	-- 	end
	-- 	self.Button.btnLeft_ChangeCG.onClick:AddListener(fun)
	-- end
	-- self.Button.btnRight_ChangeCG = nil --DRCSRef.FindGameObj("UILayerRoot/ChangeCG/Button_right"):GetComponent("Button")
	-- if IsValidObj(self.Button.btnRight_ChangeCG) then
	-- 	local fun = function()
	-- 		self:OnClick_Right_Button()
	-- 	end
	-- 	self.Button.btnRight_ChangeCG.onClick:AddListener(fun)
	-- end




end

function ModelPreviewUI:RefreshUI(iInitMode)
	self.iInitMode=iInitMode
	if iInitMode == 1 then
		
	else

	end

	self:RefrsehChooseSpine(1,1)

    if  self.comGraphicLoopScrollView then
		self.comGraphicLoopScrollView.totalCount =  #self.roleModelData
		self.comGraphicLoopScrollView:RefillCells()
	end

	self:ChangeItemType(0)

	self:RefreshSkinChooseNode()
	self:ShowBG(1)
	self:SetWeapon(1)
end

function ModelPreviewUI:RefreshSkinChooseNode()
	if self.comSkinLoopScrollView then
		self.comSkinLoopScrollView.totalCount =  #self.kSkinData
		self.comSkinLoopScrollView:RefillCells()
	end
end

function ModelPreviewUI:OnScrollChanged(item,index)
	index = index + 1
	local nameText = self:FindChildComponent(item.gameObject,"ObjGraphic/BoneFollower/Battle_LifeBar/Normal_LifeBar/Name_Text","Text")
	local followBone = self:FindChildComponent(item.gameObject,"ObjGraphic/BoneFollower","BoneFollowerGraphic")
	

	local modelPath = self.roleModelData[index][1].ModelPath
	if nameText then
		nameText.text = modelPath
	end
	nameText.text=string.gsub(nameText.text,"role_","",1);
	local skeletonGraphic = self:FindChild(item.gameObject,"ObjGraphic")
	if skeletonGraphic then
		DynamicChangeSpine(skeletonGraphic,modelPath)
	end

	--需要放到后面更新，头部name的跟随，确保跟随的骨骼是最新的
	followBone:SetBone("ref_overhead")
	--其他地方不要照着这个写
	local button = item.gameObject:GetComponent("Button")
	if self.objSpineChangeButton[button] == nil then
		local fun = function()
			self:OnClickChangeSpine(button);
		end
		self:AddButtonClickListener(button, fun)
	end
	if button then
		self.objSpineChangeButton[button] = index
	end
end

function ModelPreviewUI:ChangeItemType(iIndex)
	self.iCurItemType = self.index2Type[iIndex]
    if  self.comItemLoopScrollView then
		self.comItemLoopScrollView.totalCount =  #self.kWeaponData[self.iCurItemType]
		self.comItemLoopScrollView:RefillCells()
		
	end

end

function ModelPreviewUI:OnSkinScrollChanged(item,index)
	index = index + 1
	--其他地方不要照着这个写
	local toggle = item.gameObject:GetComponent("Toggle")
	if self.objSkinToggle[toggle] == nil then
		local fun = function(bIsOn)
			if bIsOn then
				self:OnClickChangeSkin(toggle)
			end
		end
		self:AddToggleClickListener(toggle, fun)
	end
	if index == 1 then
		toggle.isOn = true
	else
		toggle.isOn = false
	end

	if toggle then
		self.objSkinToggle[toggle] = index
	end
end

TB_Language =  reloadModule("Data/Language")  

function ModelPreviewUI:OnItemScrollChanged(item,index)
	index = index + 1
	local button = item.gameObject:GetComponent("Button")
	if self.objWeaponButton[button] == nil then
		local fun = function()
			self:OnClickWeapon(button,item.gameObject);
		end
		self:AddButtonClickListener(button, fun)
	end

	if button then
		self.objWeaponButton[button] = index
	end
	
	local kItemData = self.kWeaponData[self.iCurItemType][index]
	if kItemData then
		self.ItemIconUI:UpdateItemIcon(item.gameObject,self.kWeaponData[self.iCurItemType][index])
		
		local languageData = TB_Language[kItemData.NameID]
		local str = ""
		if languageData then
			str = languageData.Ch_Text
		end
		self.ItemIconUI:SetItemNum(item.gameObject,str)
	end
end

function ModelPreviewUI:OnClickChangeSkin(toggle)
	local iIndex = self.objSkinToggle[toggle] 
	self:ChangeSkin(iIndex)
end

function ModelPreviewUI:OnClickWeapon(button,item)
	local iIndex = self.objWeaponButton[button] 
	self:SetWeapon(iIndex)
	--选中
	-- self.chooseWeaponImage.anchoredPosition=DRCSRef.Vec2(self.chooseWeaponImage.anchoredPosition.x,
	-- item.gameObject:GetComponent("RectTransform").anchoredPosition.y)
	self.chooseWeaponImage.gameObject.transform.parent=item.gameObject.transform
	self.chooseWeaponImage.anchoredPosition3D =DRCSRef.Vec3(92,-35,0)
	self.chooseWeaponImage.gameObject.transform.localScale=DRCSRef.Vec3(1,1,1)
	
end

function ModelPreviewUI:SetWeapon(iIndex)
	if not self.hasWeaponBone then
		self.textWeaponName.text = ""
		self.textWeaponPath.text = ""
		return
	end
	self.iCurWeaponIndex = iIndex
	local kData  = self.kWeaponData[self.iCurItemType][iIndex]
	if kData then 
		self.textWeaponName.text = GetLanguageByID(kData.NameID)
		local str = kData.Model
		if str == nil or str == "" then
			str = kData.ItemImg
		end
		self.textWeaponPath.text = str
		
		local spineaniminfo = self.SpineRoleUI:GetAnimInfoByName(self.spineAniData[self.iCurSpineAnimaitionIndex].Name,self.iModleID)
		self.SpineRoleUI:SetEquipItemEX(self.objSpine,nil,  {itemID = kData.BaseID, uiEnhanceGrade = self.iCurEnhanceGrade or 0},spineaniminfo,self.Vec3)
	end
end

function ModelPreviewUI:OnClickChangeSpine(button)
	local iIndex = self.objSpineChangeButton[button] 
	self:RefrsehChooseSpine(iIndex,1)
end

function ModelPreviewUI:ChangeSpineScale(scaleX,scaleY)

	self.pointDownTime = os.clock()
	

	if not self.pressButton then
		self.pressTimer=DRCSRef.Time.time + 0.5
		self.iTimerIndex = globalTimer:AddTimer(500,function() self:Update() end)
	end
	if scaleX==1 then self.pressButton=1 end
	if scaleX==-1 then self.pressButton=2 end
	if scaleY==1 then self.pressButton=3 end
	if scaleY==-1 then self.pressButton=4 end

	local kData = self.kSkinData[self.iCurSkinIndex]	
	if kData.RoleScale then
		self.iSpineScaleX = self.iSpineScaleX + scaleX
		self.iSpineScaleY = self.iSpineScaleY + scaleY
		kData.RoleScale.X = self.iSpineScaleX
		kData.RoleScale.Y = self.iSpineScaleY
		self:SetSpineScale(self.iSpineScaleX,self.iSpineScaleY)
	end
end

function ModelPreviewUI:ReleaseScaleButton()
	self.pressButton=nil
	globalTimer:RemoveTimer(self.iHandleCall)
	globalTimer:RemoveTimer(self.iTimerIndex)
end
--缩放
function ModelPreviewUI:Update()
	if self.iInitMode==1 then
		self:RefreshScale()
	elseif self.iInitMode==2 then
		self.iHandleCall = os.clock()
		self.iHandleCall = globalTimer:AddTimer(50,function() self:RefreshScale() end,-1)
	end
end

function ModelPreviewUI:RefreshScale()
	if not self.pressButton then 
		return
	end

	local now = DRCSRef.Time.time
	if  now < self.pressTimer and self.iInitMode==1 then 
		return
	end

	if self.pressButton==1 then 
		self:ChangeSpineScale(1,0)
		
	elseif self.pressButton==2 then 
		self:ChangeSpineScale(-1,0)

	elseif self.pressButton==3 then 
		self:ChangeSpineScale(0,1)

	elseif self.pressButton==4 then 
		self:ChangeSpineScale(0,-1)

	elseif self.pressButton==5 then 
		self:ChangeWeaponScale(1,0)

	elseif self.pressButton==6 then 
		self:ChangeWeaponScale(-1,0)

	elseif self.pressButton==7 then 
		self:ChangeWeaponScale(0,1)

	elseif self.pressButton==8 then 
		self:ChangeWeaponScale(0,-1)
	end

				-- body
			-- body
		-- body
end
	
function ModelPreviewUI:ChangeWeaponScale(scaleX,scaleY)
	if not self.pressButton then
		self.pressTimer=DRCSRef.Time.time + 0.5
		self.iTimerIndex = globalTimer:AddTimer(500,function() self:Update() end)
	end
	if scaleX==1 then self.pressButton=5 end
	if scaleX==-1 then self.pressButton=6 end
	if scaleY==1 then self.pressButton=7 end
	if scaleY==-1 then self.pressButton=8 end

	local kData = self.kSkinData[self.iCurSkinIndex]	
	if kData.WeaponScale then
		self.iWeaponScaleX = self.iWeaponScaleX + scaleX
		self.iWeaponScaleY = self.iWeaponScaleY + scaleY
		kData.WeaponScale.X = self.iWeaponScaleX
		kData.WeaponScale.Y = self.iWeaponScaleY
		self:SetWeaponScale(self.iWeaponScaleX,self.iWeaponScaleY)
	end
end

function ModelPreviewUI:SetWeaponScale(scaleX,scaleY)
	self.Vec3.x = scaleX / 100
	self.Vec3.y = scaleY / 100
	-- self.objSpine:SetObjLocalScale(scaleX / 100,scaleY / 100,1)
	self.textWeaponScaleX.text = scaleX
	self.textWeaponScaleY.text = scaleY
	
	self.SpineRoleUI:SetWeaponScale(DRCSRef.Vec3(scaleX / 100,scaleY / 100,1))
	--更新
	self:SetWeapon(self.iCurWeaponIndex)

	-- local objWeapon = self:FindChild(self.objSpine,"weapon_Node/New Game Object")
	-- if objWeapon then
	-- 	objWeapon.transform:SetTransLocalScale(scaleX / 100,scaleY / 100,1)
	-- end
end


function ModelPreviewUI:SetSpineScale(scaleX,scaleY)
	self.objSpine:SetObjLocalScale(scaleX / 100,scaleY / 100,1)
	self.textSpineScaleX.text = scaleX
	self.textSpineScaleY.text = scaleY
end

function ModelPreviewUI:RefrsehChooseSpine(iSpineIndex,iSkinIndex)
	if iSpineIndex == self.iCurSpineIndex then
		return
	end
	self.iCurAnimaitionIndex = 1	
	self.iCurSpineIndex  = nil
	self.iCurSkinIndex = nil
	self:ChangeSpine(iSpineIndex)
	self:ChangeSkin(iSkinIndex)
end

function ModelPreviewUI:ChangeSpine(iSpineIndex)
	if iSpineIndex == self.iCurSpineIndex then
		return
	end
	local kData = self.roleModelData[iSpineIndex]
	if kData == nil then
		return
	end
	self.kSkinData = kData
	self.textModlePath.text = self.kSkinData[1].ModelPath
	self.textTexturePath.text = self.kSkinData[1].Texture
	self.iModleID = self.kSkinData[1].BaseID
	self.iCurSpineIndex = iSpineIndex
	local result = DynamicChangeSpine(self.objSpine,self.kSkinData[1].ModelPath)

	local bone = self.skeletonAnimation.Skeleton:FindBone(DEFAULT_SPINE_WEAPON_BONE)
	self.hasWeaponBone = bone
	self.weaponNode.gameObject:SetActive(bone ~= nil)
	
	self:RefreshSpineAnimation()
	self:RefreshSkinChooseNode()
end

function ModelPreviewUI:ChangeSkin(iSkinIndex)
	if self.iCurSkinIndex == iSkinIndex then
		return
	end

	if self.kSkinData == nil or self.kSkinData[iSkinIndex] == nil then
		return
	end
	self.iCurSkinIndex = iSkinIndex
	local kData = self.kSkinData[iSkinIndex]	

	if kData.WeaponScale then
		self.iWeaponScaleX = kData.WeaponScale.X
		self.iWeaponScaleY = kData.WeaponScale.Y
	else
		kData.WeaponScale = { X = 100,Y =100}
		self.iWeaponScaleX = 100
		self.iWeaponScaleY = 100
	end

	if kData.RoleScale then
		self.iSpineScaleX = kData.RoleScale.X
		self.iSpineScaleY = kData.RoleScale.Y
	else
		kData.RoleScale = { X = 100,Y =100}
		self.iSpineScaleX = 100
		self.iSpineScaleY = 100
	end
	self:SetSpineScale(self.iSpineScaleX,self.iSpineScaleY)
	self:SetWeaponScale(self.iWeaponScaleX,self.iWeaponScaleY)
	self.textTexturePath.text = kData.Texture
	ChnageSpineSkin(self.objSpine,kData.Texture)
end

function ModelPreviewUI:RefreshSpineAnimation()
	self.spineAniData = {}
	local skeletonAnimation = self.objSpine:GetComponent("SkeletonAnimation")
	if IsValidObj(skeletonAnimation) then
		for key,value in pairs(skeletonAnimation.skeleton.Data.Animations) do
			if value.Name == 'idle' then
				table.insert(self.spineAniData, 1, value)
			else
				table.insert(self.spineAniData, value)
			end
		end
	end
	self:ShowSpineAnimation(1)
end

function ModelPreviewUI:ShowSpineAnimation(iIndex)
	if self.iCurSpineAnimaitionIndex == iIndex then
		return
	end
	self.iCurSpineAnimaitionIndex = iIndex 
	
	if self.curWeaponBaseID then 
		self:SetWeapon(self.iCurWeaponIndex)
	end

	self.textAnimaitionText.text = self.spineAniData[self.iCurSpineAnimaitionIndex].Name
	local skeletonAnimation = self.objSpine:GetComponent("SkeletonAnimation")
	skeletonAnimation.state:SetAnimation(0, self.spineAniData[self.iCurSpineAnimaitionIndex].Name, true);
end

function ModelPreviewUI:OnClick_SpineAni_LeftButton()
	local temp = self.iCurSpineAnimaitionIndex - 1
	if temp < 1 then
		temp = 1
	end
	self:ShowSpineAnimation(temp)
end

function ModelPreviewUI:OnClick_SpineAni_RightButton()
	local temp = self.iCurSpineAnimaitionIndex + 1
	if temp > #self.spineAniData then
		temp = #self.spineAniData
	end
	self:ShowSpineAnimation(temp)
end

function ModelPreviewUI:ShowBG(iIndex)
	if iIndex == self.iCurBGIndex then
		return
	end
	if self.kBGData and  self.kBGData[iIndex] then
		local sPath =  self.kBGData[iIndex]
		if self.objBGPerfabs[iIndex] == nil then
			self.objBGPerfabs[iIndex] = LoadEffectAndInit("battlebg/" .. sPath .. "/" .. sPath)
		end
		local oldBG = self.objBGPerfabs[self.iCurBGIndex]
		if oldBG then
			oldBG:SetActive(false)
		end
		local newBG = self.objBGPerfabs[iIndex]
		if newBG then
			newBG:SetActive(true)
		end
		self.textBGName.text = sPath
		self.iCurBGIndex = iIndex

		self.buttonBGAdd.gameObject:SetActive(iIndex ~= #self.kBGData)
		self.buttonBGDec.gameObject:SetActive(iIndex ~= 1)
	end
end

function ModelPreviewUI:OnClickLeftBGButton()
	local temp = self.iCurBGIndex - 1
	if temp < 1 then
		temp = 1
	end
	self:ShowBG(temp)
end

function ModelPreviewUI:OnClickRightBGButton()
	local temp = self.iCurBGIndex + 1
	if temp >#self.kBGData then
		temp = #self.kBGData
	end
	self:ShowBG(temp)
end

function ModelPreviewUI:ChangeWeapon(info)
	self.curWeaponBaseID = info.BaseID
	if self.objWeapon then 
		DRCSRef.ObjDestroy(self.objWeapon)
	end
	self.SpineRoleUI:SetEquipItem(self.objSpine, {itemID = info.BaseID, uiEnhanceGrade = self.iCurEnhanceGrade or 0})
	--self.objWeapon = LoadActorSpineWeapon(self.objSpine,"Base_Weapon")
end

function ModelPreviewUI:OnClick_WaoponEnhanceGrade_LeftButton()
	self.iCurEnhanceGrade = self.iCurEnhanceGrade - 5
	if self.iCurEnhanceGrade < 0 then
		self.iCurEnhanceGrade = 0
	end
	self:ShowWeaponEnhanceGradeEffect()
end

function ModelPreviewUI:OnClick_WaoponEnhanceGrade_RightButton()
	self.iCurEnhanceGrade  = self.iCurEnhanceGrade + 5
	if self.iCurEnhanceGrade > 20 then
		self.iCurEnhanceGrade = 20
	end
	self:ShowWeaponEnhanceGradeEffect()
end


function ModelPreviewUI:ShowWeaponEnhanceGradeEffect()
	self.textWeaponEnhanceGrade.text = self.iCurEnhanceGrade
	self.textWeaponSteng.text="+"..self.iCurEnhanceGrade
	self.SpineRoleUI:SetWeaponEnhanceGrade(self.iCurEnhanceGrade)

end

return ModelPreviewUI