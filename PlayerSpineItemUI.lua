PlayerSpineItemUI = class("PlayerSpineItemUI",BaseWindow)

function PlayerSpineItemUI:Create(kInfo)
	if not (kInfo and kInfo.kParent) then
		return
	end
	-- LoadSpineCharacterAsync("TownUI/PlayerSpineItemUI", kInfo.kParent, function(obj)
	-- 	self:OnCreate(obj)
	-- 	self:RefreshUI(kInfo)
	-- end, true)
	local obj = LoadPrefabAndInit("TownUI/PlayerSpineItemInsert", kInfo.kParent, true)
	if obj then
		self:OnCreate(obj)
		-- self:RefreshUI(kInfo)
	end
end

function PlayerSpineItemUI:OnCreate(obj)
	if not obj then
		return
	end
	self:SetGameObject(obj)
	-- get components
	self.objSpot = self:FindChild(self._gameObject, "spot")
	self.objPet = self:FindChild(self._gameObject, "pet_show")
	self.objSpine = self:FindChild(self._gameObject, "spine")
	self.objHeadNode = self:FindChild(self.objSpine, "head_Node")
	self.objTitle = self:FindChild(self.objHeadNode, "Title")
	self.objName = self:FindChild(self.objHeadNode, "Text")
	self.textTitle = self.objTitle:GetComponent("Text")
	self.textName = self.objName:GetComponent("Text")
	self.transObj = self._gameObject:GetComponent("RectTransform")
	self.transSpine = self.objSpine:GetComponent("RectTransform")
	self.v3SpineOriScale = self.transSpine.localScale

	self.transTitle = self.objTitle:GetComponent("RectTransform")
	self.transName = self.objName:GetComponent("RectTransform")
	self.v3NameOriScale = self.transName.localScale
	self.comBoneFollower = self.objHeadNode:GetComponent("BoneFollowerGraphic")
	self.comSkeletonGraphic = self.objSpine:GetComponent("SkeletonGraphic")
	self.objBtn = self:FindChild(self.objSpine, "Button")
	self.btnSpine = self.objBtn:GetComponent("Button")
	self.transBtn = self.objBtn.transform
	-- other param
	self.fFixedPlayerNameScale = 0.6  -- 固定酒馆玩家名字的缩放
	self.bIsFlip = false  -- 模型是否是翻转状态
	self.iObjSpineScale  = 1
	-- pre process
	self:InitEventTrigger(self.transBtn)
	self:RemoveButtonClickListener(self.btnSpine)
	self:AddButtonClickListener(self.btnSpine, function()
		self:OnClickSpine()
	end)
end

-- 初始化EventTrigger行为
function PlayerSpineItemUI:InitEventTrigger(transObj)
	if not transObj then
		return
	end
	RemoveEventTrigger(transObj)

	AddEventTrigger(transObj,function()
		self:OnPointDownSpine()
	end, DRCSRef.EventTriggerType.PointerDown)

	AddEventTrigger(transObj,function()
		self:OnPointUpSpine()
	end, DRCSRef.EventTriggerType.PointerUp)
end

-- 创建在模型上 按下/抬起 时的动画
function PlayerSpineItemUI:CreatePressSpineTwn(bFlip)
	-- args about the animatiopn
	local iFactor = (bFlip == true) and -1 or 1
	local fBeginUniScale = math.abs(self.iObjSpineScale)
	local v3BeginScale = DRCSRef.Vec3(iFactor * fBeginUniScale, fBeginUniScale, fBeginUniScale)
	local v3EndScale = v3BeginScale * 0.9
	local fAnimTime = 0.3
	-- this animation won't kill himself
	return Twn_Scale(nil, self.objSpine, v3BeginScale, v3EndScale, fAnimTime)
end

-- 设置一个spine节点
function PlayerSpineItemUI:UpdateSpineObj(objSpine, roleModelData, animationName, bIsGraphic)
    if not roleModelData then
        return false
    end
    local spine, spineTexture = nil, nil
    if roleModelData ~= nil then 
        spine = roleModelData.Model
        spineTexture = roleModelData.Texture
    end
    if (spine == nil or spine == "")then
        spine = MODEL_DEFAULT_SPINE
    end
    if (spineTexture == nil or spineTexture == "") then
        spineTexture = MODEL_DEFAULT_TEXTURE
    end

    if animationName == nil then
        animationName = ROLE_SPINE_DEFAULT_ANIM
    end
    local bSetRes = false
    if spine then
        bSetRes = DynamicChangeSpine(objSpine, spine, animationName)
    end
    if bSetRes and spineTexture then
        if bIsGraphic == true then
            self._objSpine_Texture = ChnageSpineSkin_Graphic(objSpine, spineTexture)
        else
            self._objSpine_Texture = ChnageSpineSkin(objSpine, spineTexture)
        end
	end
	
	--默认缩放大小 美术表里填的
	local ResourcesModeID = roleModelData.ModelID or 0
    if  ResourcesModeID ~= 0 then
		local res = TableDataManager:GetInstance():GetTableData("ResourceRoleModel",ResourcesModeID)
		local _specialScale = 1
		if res and SpecialBigSpine[res.ModelPath] then 
            _specialScale = SpecialScaleValue
        end
        if  res and res.RoleScale then
            if res.RoleScale.X <= 0  then
                res.RoleScale.X = 100
            end
            if res.RoleScale.Y <= 0  then
                res.RoleScale.Y = 100
            end
            if res.RoleScale.Z <= 0  then
                res.RoleScale.Z = 100
			end
			
            local X = res.RoleScale.X / 100
            local Y = res.RoleScale.Y / 100
			local Z = res.RoleScale.Z / 100
			local oldScale = objSpine.transform.localScale
			if oldScale.x > 50 then --大于50 说明是3d物体显示在 ui上
				X = 100 * X * 0.9
				Y = 100 * Y * 0.9
				Z = 100 * Z * 0.9
			end
			objSpine.transform.localScale = DRCSRef.Vec3(X, Y, Z) * _specialScale
        end
    end
    return bSetRes
end

-- 需要提供的参数列表:
-- kData = {
-- 	-- model set
-- 	['bSpotOn'] = #Boolean#,
-- 	['bIsFlip'] = #Boolean#,
-- 	-- pure data
-- 	['v3ParentScale'] = #Vector3#,
-- 	['kTarModelData'] = #ModelData#,
-- 	['acPlayerName'] =  #PlayerName#,
-- 	['defPlyID'] = #PlayerID#,
-- 	['IsME'] = #IsThisMyData?#,
-- 	['kPetModelData'] = #PetModelData#,
-- 	['bRefreshPetOnly'] = #JustRefreshPetSpine#,
-- }
function PlayerSpineItemUI:RefreshUI(kData)
	if not (kData and self.objSpine) then
		return
	end
	-- 宠物, 默认关闭
	self.objPet:SetActive(false)
	if kData.kPetModelData then
		local bSetRes = self:UpdateSpineObj(self.objPet, kData.kPetModelData, nil, true)
		self.objPet:SetActive(bSetRes)
	end
	-- 如果只刷新宠物, 那么这里就直接返回
	if kData.bRefreshPetOnly == true then
		return
	end
	-- 灯光
	self.objSpot:SetActive(kData.bSpotOn == true)
	-- 设置模型
	-- 如果玩家没有设置模型, 那么默认显示田小六的模型
	if not kData.kTarModelData then
		kData.kTarModelData = TableDataManager:GetInstance():GetTableData("RoleModel", 1)
	end
	local bSetRes = self:UpdateSpineObj(self.objSpine, kData.kTarModelData, nil, true)
	self.objSpine:SetActive(bSetRes)
	-- 如果模型没有设置成功, 就没有必要继续下去了
	if not bSetRes then
		return
	end
	self.bIsFlip = (kData.bIsFlip == true)
	-- 执行Spine翻转
	local v3OriSpineScale = self.transSpine.localScale
	local fOriSpineScaleX = math.abs(v3OriSpineScale.x)
	v3OriSpineScale.x = (self.bIsFlip and -1 or 1) * fOriSpineScaleX
	self.iObjSpineScale = v3OriSpineScale.x 
	self.transSpine.localScale = v3OriSpineScale

	-- 设置名字
	self.textName.text = kData.acPlayerName or ""

	-- 名字的翻转
	local fXNameScale = self.iObjSpineScale < 0 and -1 or 1

	-- 名字的缩放固定
	local v3ParentScale = kData.v3ParentScale or DRCSRef.Vec3One
	local fProcessedYZScale = math.abs(self.fFixedPlayerNameScale / v3ParentScale.x / v3OriSpineScale.x)
	self.transName.localScale = DRCSRef.Vec3(fXNameScale * fProcessedYZScale, fProcessedYZScale , 1)
	self.transTitle.localScale = DRCSRef.Vec3(fXNameScale * fProcessedYZScale, fProcessedYZScale , 1)

	-- 重新给follower的属性赋值, 刷新over_head的位置
	self.comBoneFollower.enabled = true
	self.comBoneFollower.SkeletonGraphic = self.comSkeletonGraphic

	-- 点击模型行为
	local titleID = 0
	self.objTitle:SetActive(false);
	if kData.IsME then
		self.defPlyID = nil
		local appearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo();
		if appearanceInfo then
			titleID = appearanceInfo.titleID or 0
		end
	else
		self.defPlyID = kData.defPlyID
		titleID = kData.titleID or 0
	end
	self.objTitle:SetActive(false);
	local tbl_RoleTitle = TableDataManager:GetInstance():GetTableData("RoleTitle", titleID);
	if tbl_RoleTitle and tbl_RoleTitle.TitleID then
		self.objTitle:SetActive(true);
		self.textTitle.text = GetLanguageByID(tbl_RoleTitle.TitleID)
	end

	self.transObj.localPosition = DRCSRef.Vec3Zero
end

-- 点击Spine产生的行为
function PlayerSpineItemUI:OnClickSpine()
	if not self.defPlyID then
		return
	end
	ChallengeFrom = ChallengeFromType.PlayerList;
	SendGetPlatPlayerDetailInfo(self.defPlyID, RLAYER_REPORTON_SCENE.UserBoard)
end

-- 鼠标/手指在模型上 按下时的操作
function PlayerSpineItemUI:OnPointDownSpine()
	if self.bIsFlip == true then
		if self.twnPressSpineFlip then
			self.twnPressSpineFlip:Play()
		else
			self.twnPressSpineFlip = self:CreatePressSpineTwn(true)
		end
	else
		if self.twnPressSpine then
			self.twnPressSpine:Play()
		else
			self.twnPressSpine = self:CreatePressSpineTwn(false)
		end
	end
end

-- 鼠标/手指在模型上 抬起时的操作
function PlayerSpineItemUI:OnPointUpSpine()
	if self.bIsFlip == true then
		if self.twnPressSpineFlip then
			self.twnPressSpineFlip:Rewind()
		end
	else
		if self.twnPressSpine then
			self.twnPressSpine:Rewind()
		end
	end
end

-- 销毁时执行一些清理工作
function PlayerSpineItemUI:OnDestroy()
	if self.twnPressSpine then
		self.twnPressSpine:Kill(false)
	end
	if self.twnPressSpineFlip then
		self.twnPressSpineFlip:Kill(false)
	end
	RemoveEventTrigger(self.transBtn)
end

return PlayerSpineItemUI