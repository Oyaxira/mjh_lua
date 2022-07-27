BaseWindow = class("BaseWindow")
local Vec3MAX = DRCSRef.Vec3(9999,9999,0)
local Vec3Zero = DRCSRef.Vec3(0,0,0)
local Vec2Half = DRCSRef.Vec2(0.5, 0.5)
local lTransformResourceManager = CS.SG.ResourceManager.Instance.transform

--是否是pc
local appPlatform = CS.UnityEngine.Application.platform
local platEditor = CS.UnityEngine.RuntimePlatform.WindowsEditor
local platPlayer = CS.UnityEngine.RuntimePlatform.WindowsPlayer
g_IS_WINDOWS = (appPlatform == platEditor) or (appPlatform == platPlayer)
g_IS_SIMULATORIOS = false
g_IS_AUTOLOGIN = true

function BaseWindow:ctor()
    self.addTop = true;---打开时将界面置顶
	self.info = nil
	self.toShow = true
	self.oldPosition = nil
	self.poolObj = {}

	self.mBoxList = {}
	self.mBoxPool = {}
end

function BaseWindow:OnCreate(info)
	self.info = info
	self:Create()
	self:Init()
	self:OnEnable()
	self:RefreshUI(info)

	if self._gameObject then
		local canvasGroup = self._gameObject:GetComponent("CanvasGroup")
		if canvasGroup == nil then
			canvasGroup = self._gameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
			canvasGroup.alpha = 1
			
			-- canvasGroup.blocksRaycasts = true
			-- canvasGroup.interactable = true
		end
		local CanvasParent = self._gameObject.transform.parent:GetComponent("Canvas")
		if CanvasParent then 
			local baseLayer = self._gameObject.transform.parent.childCount
			local Canvas
			if self._gameObject:GetComponent(typeof(CS.UnityEngine.Canvas)) == nil then 
				Canvas = self._gameObject:AddComponent(typeof(CS.UnityEngine.Canvas))
				self._gameObject:AddComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
			end
			if Canvas then 
				Canvas.overrideSorting = true
				local layer = baseLayer + 500
				if self.name and WINDOW_ORDER_INFO[self.name] then 
					layer = WINDOW_ORDER_INFO[self.name].order
				end
				Canvas.additionalShaderChannels = 31;
				Canvas.sortingOrder = CanvasParent.sortingOrder +( layer or baseLayer )
			end
			self.transform = self._gameObject.transform
		end
		self:SetSafeWidth()
	end
end

function BaseWindow:SetAlpha(alpha)
	if self._gameObject then
		local canvasGroup = self._gameObject:GetComponent("CanvasGroup")
			canvasGroup.alpha = alpha
	end
end

--资源的创建 放在这里
function BaseWindow:Create()

end

--获取组件统一放到这里  只有首次创建的时候 会调用
function BaseWindow:Init()

end

--刷新信息统一在这里
function BaseWindow:RefreshUI()
	
end

function BaseWindow:SetGameObject(obj, bAutoFit)
	self._gameObject = obj
	if self.name and self.name ~= '' then
		self._gameObject.name = self.name
	end
    self.transform = obj.transform;
	self.rect = self.transform:GetComponent('RectTransform');
	
	-- 对 中心锚点 1280 * 720 大小的窗口 做自动拉伸
	-- 这个做法是为了方便 UI 在设计时，以 1280 * 720 的大小来拼
	if not (self.rect and self.rect.rect) then return end
	if bAutoFit ~= false then
		if self.rect.rect.width == design_ui_w and self.rect.rect.height == design_ui_h and 
		self.rect.anchorMax == Vec2Half and self.rect.anchorMin == Vec2Half then
			 self.rect.anchorMin = DRCSRef.Vec2(0, 0)
			 self.rect.anchorMax = DRCSRef.Vec2(1, 1)
			 self.rect.sizeDelta = DRCSRef.Vec2(0, 0)
		end
	end
	
	-- 对 名字为 BG 的节点 做 Aspect Ratio Fitter - EnvelopeParent
	-- 非常隐性规定的写法，目前已经各自界面配置了。
	-- local bg = self.transform:Find('BG')
	-- if bg and bg.gameObject and bg:GetComponent('AspectRatioFitter') == nil then
	-- 	local ratio = design_ui_w / design_ui_h
	-- 	local comTF = bg:GetComponent('RectTransform')
	-- 	if comTF then
	-- 		ratio = comTF.rect.width / comTF.rect.height
	-- 	end
	-- 	local comARF = bg.gameObject:AddComponent(typeof(DRCSRef.AspectRatioFitter))
	-- 	if comARF then	-- 注意这里 aspectMode 修改会立刻更改 RectTransform 的属性，所以要提前
	-- 		comARF.aspectMode = DRCSRef.AspectMode.EnvelopeParent
	-- 		comARF.aspectRatio = ratio
	-- 	end
	-- end
end

--设置 加载在其他layer 但是属于这个ui的物体
function BaseWindow:SetOtherLayerObj(obj)
	if 	self._objOtherLayerObj == nil then--加载在其他层级的物体 需要一同删除的
		self._objOtherLayerObj = {} 
	end
	self._objOtherLayerObj[#self._objOtherLayerObj + 1] = {obj,nil}
end

function BaseWindow:GetGameObject()
    return self._gameObject
end

function BaseWindow:SetActive(bVisible)   
	local bOnshow  = self.toShow 
	
	local canvasGroup = nil
	if IsValidObj(self._gameObject) then
		canvasGroup = self._gameObject:GetComponent("CanvasGroup")
		if canvasGroup == nil then
			canvasGroup = self._gameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
				canvasGroup.alpha = 1
			

			-- canvasGroup.blocksRaycasts = true
			-- canvasGroup.interactable = true
		end
        ----self._gameObject:SetActive(bVisible)
		
		--如果是缓存的界面 则每次打开在最上层
		if	self.addTop and not WINDOW_ORDER_INFO[self.name] then
			self.transform:SetAsLastSibling();
		end

		self.toShow = bVisible

		if self._objOtherLayerObj == nil then
			self._objOtherLayerObj = {}
		end
		if not bOnshow and self.toShow then
			self.transform.localPosition = self.oldPosition
			if canvasGroup then
				-- canvasGroup.blocksRaycasts = true
				-- canvasGroup.interactable = true
				if self.name~="StoryUI" then
					canvasGroup.alpha = 1
				end

			end

			self:OnEnable()
			local iCount = #self._objOtherLayerObj
			for i= iCount,1,-1 do
				if self._objOtherLayerObj[i] then
					self._objOtherLayerObj[i][1].transform:SetAsFirstSibling(); -- 这里是反向遍历，后加的显示在前面，需要使用First
					self._objOtherLayerObj[i].gameObject:SetActive(true)
					-- self._objOtherLayerObj[i][1].transform.position = self._objOtherLayerObj[i][2]
				end
			end
		elseif not bVisible and bOnshow  then
			if canvasGroup then
				self.oldPosition = self.transform.localPosition
				self.transform.localPosition = Vec3MAX
				
				if self.name~="StoryUI" then
					canvasGroup.alpha = 0
				end
				-- canvasGroup.blocksRaycasts = false
				-- canvasGroup.interactable = false
			end

			self:OnDisable()
			for k,v in pairs(self._objOtherLayerObj) do
				if v then
					self._objOtherLayerObjVisible[k] =  v.gameObject.activeSelf
					v.gameObject:SetActive(false)
					-- self._objOtherLayerObj[i][2] = v.transform.position
					-- v.transform.position = Vec3MAX
				end
			end
		end
	else
		if DEBUG_MODE then
			derror("object has destory ,but you want to use it :" .. tostring(self.name))
		end
	end
end


function BaseWindow:SetTop()
	if self.transform then
		self.transform:SetAsLastSibling()
	end
end

function BaseWindow:IsOpen()
    return self.toShow
end

function BaseWindow:IsActive()
    if self._gameObject and self.toShow and self._gameObject.activeSelf == true then
        return true
    end
    return false
end

function BaseWindow:AddTimer(delay,func,times,infoTable)
	if self._timeHandle == nil then
		self._timeHandle = {}
	end
	local iTimerIndex = globalTimer:AddTimer(delay,func,times,infoTable)
	self._timeHandle[#self._timeHandle + 1] = iTimerIndex
	return iTimerIndex
end

function BaseWindow:RemoveTimer(iIndex)
	if type(iIndex) ~= 'number' then 
		return
	end
	globalTimer:RemoveTimer(iIndex)
end

function BaseWindow:AddEventListener(eventName, funCall, dontDestory, isTriggerOnce, forbidReapeat ,bIngoreIsOpen)
	if self._eventHandle == nil then
		self._eventHandle = {}
	end
	if self._eventHandle[eventName] == nil then
		self._eventHandle[eventName] = {}
	end
	if forbidReapeat and self:HasEventListener(eventName) then 
		return
	end

	local fun = function (info)
		if funCall and (bIngoreIsOpen or self:IsOpen()) then
			funCall(info)
		end
	end
	table.insert(self._eventHandle[eventName], fun)
	LuaEventDispatcher:addEventListener(eventName, fun, nil , dontDestory, isTriggerOnce)	
	-- LuaEventDispatcher:addEventListener(eventName, funCall, dontDestory, isTriggerOnce)
end

function BaseWindow:RemoveEventListener(eventName)
	if self._eventHandle == nil then
		return
	end
	if self._eventHandle[eventName] == nil then
		return 
	end
	for _, callback in ipairs(self._eventHandle[eventName]) do 
		LuaEventDispatcher:removeEventListener(eventName, callback)
	end
	self._eventHandle[eventName] = nil
end

function BaseWindow:HasEventListener(eventName)
	if self._eventHandle == nil then
		return false
	end
	if self._eventHandle[eventName] == nil then
		return false
	end
	return self._eventHandle[eventName] ~= nil and #self._eventHandle[eventName] > 0
end

-- 注意：按钮不能在UI销毁前删除
function BaseWindow:AddButtonClickListener(kButton,funCall,saveButtonInfo)
	if kButton == nil or funCall == nil then
		return
	end
	if self._button == nil then--所有添加了 监听的button
		self._button = {}
	end

	-- local clickfunc = function()
	-- 	GuideDataManager:GetInstance():ButtonClicked(kButton.gameObject)
	-- 	funCall()
	-- end
	if self._button[kButton] ~= nil then
		if DEBUG_MODE then
			DRCSRef.LogError("button has listener,but add it again  :"..debug.traceback())
		end
		return
	end

	if  saveButtonInfo ~= false then 
		self._button[kButton] = true
	end

	kButton.onClick:AddListener(funCall)
	if DEBUG_BUTTON_LISTENER then
		LogButtonListenerInfo(kButton)
	end
end

function BaseWindow:RemoveButtonClickListener(kButton,bDel)
	if kButton == nil or not IsValidObj(kButton) then
		return
	end
	kButton.onClick:RemoveAllListeners()
	kButton.onClick:Invoke()
	if DEBUG_BUTTON_LISTENER then
		RemoveButtonListenerInfo(kButton)
	end
	if bDel ~= false  and self._button  and self._button[kButton] then
		self._button[kButton] = nil
	end
end

function BaseWindow:SetParent(transParent)
    self._gameObject.transform:SetParent(transParent,false)
end

function BaseWindow:ToPoolClear()
    
end

function BaseWindow:ReturnToPool()
	if IsValidObj(lTransformResourceManager) then
		self._gameObject.transform:SetParent(lTransformResourceManager, false)
		self.rect.anchorMin = Vec2Half
		self.rect.anchorMax = Vec2Half
		self.rect.localPosition = Vec3Zero
	end
end

-- 注意：不能在UI销毁前删除
function BaseWindow:AddToggleClickListener(kToggle,funCall)
	if kToggle == nil or funCall == nil then
		return
	end
	if self._toggle  == nil then  --所有添加了 监听的toggle
		self._toggle = {}
	end

	if self._toggle[kToggle] then
		if DEBUG_MODE then
			DRCSRef.LogError("toggle has listener,but add it again  :"..debug.traceback())
		end
		return
	end
	local fun = function(bool)
		-- 点击隐藏Target图片的逻辑最好放到各自的逻辑里面，不要做这样的隐性约定
		-- if boolHide ~= false and kToggle.targetGraphic then
		-- 	kToggle.targetGraphic.gameObject:SetActive(not bool)
		-- end
		funCall(bool)
	end
	kToggle.onValueChanged:AddListener(fun)
	self._toggle[kToggle] = true
end

function BaseWindow:RemoveToggleClickListener(kToggle,bDel)
	if kToggle == nil then
		return
	end

	if not self._toggle then
		self._toggle = {}
	end
	
	if self._toggle[kToggle] then
		if kToggle and not IsValidObj(kToggle) then
			DRCSRef.LogError("toggle has destory,but you use it  :"..debug.traceback())
		end

		if kToggle and IsValidObj(kToggle) then
			kToggle.onValueChanged:RemoveAllListeners()
			kToggle.onValueChanged:Invoke()	
		end	
		if bDel ~= false then
			self._toggle[kToggle] = nil
		end
	end
end

--刘海屏适配
function BaseWindow:SetSafeWidth()
	-- local leftNodeTrans =  self._gameObject:FindChildComponent("TransformAdapt_node_left","Transform")
	-- if leftNodeTrans then
	-- 	local pos = leftNodeTrans.localPosition
	-- 	leftNodeTrans:SetTransLocalPosition(pos.x + UI_LEFT_WIDTH,pos.y,pos.z)
	-- end

	-- local rightNodeTrans =  self._gameObject:FindChildComponent("TransformAdapt_node_right","Transform")
	-- if rightNodeTrans then
	-- 	local pos = rightNodeTrans.localPosition
	-- 	rightNodeTrans:SetTransLocalPosition(pos.x + UI_RIGHT_WIDTH ,pos.y,pos.z)
	-- end
end

function BaseWindow:Update(deltaTime)

end

function BaseWindow:LateUpdate()--会在所有update执行完毕后执行，包括c#的update
	
end

--界面隐藏的时候 会调用
function BaseWindow:OnDisable()

end

--打开的时候会调用
function BaseWindow:OnEnable()

end

---复写需调用父类的OnDestroy,给单局关闭所有界面调用，主动删除界面必须调用CloseUIWindow("XXX")
function BaseWindow:Destroy(bItemClass)
    self:Close(bItemClass,true)
end

--界面删除的时候调用
function BaseWindow:OnDestroy()
    
end
--从池里加载spine
function BaseWindow:LoadSpineFromPool(sPath,kParentTrans,isSpecialPath)
	local obj = LoadSpineFromPool(sPath,kParentTrans,isSpecialPath)
	if obj then
		table.insert(self.poolObj,obj)
	end
	return obj
end

--从池里加载prefab
function BaseWindow:LoadPrefabFromPool(sPath,kParentTrans)
	local obj = LoadPrefabFromPool(sPath,kParentTrans)
	if obj then
		table.insert(self.poolObj,obj)
	end
	return obj
end

-- 使用一个节点为模板从池里加载对象
function BaseWindow:LoadGameObjFromPool(obj, kParentTrans)
	if not kParentTrans then
		return
	end
	local obj = LoadGameObjFromPool(obj,kParentTrans.gameObject)
	if obj then
		table.insert(self.poolObj,obj)
	end
	return obj
end

--把spine返回池子
function BaseWindow:ReturnObjToPool(obj)
	if obj then
		for k,v in ipairs(self.poolObj) do
			if v == obj then
				if IsValidObj(obj) then
					DRCSRef.ResourceManager:ReturnObjectToPool(obj)
				end
				table.remove(self.poolObj,k)
				break
			end
		end
	end
end

function BaseWindow:ReturnAllObjToPool()
	for k,v in ipairs(self.poolObj) do
		if IsValidObj(v) then
			DRCSRef.ResourceManager:ReturnObjectToPool(v)
		end
	end
	self.poolObj = {}
end

function BaseWindow:RemoveAllChildToPool(transform)
	local iCount = transform.childCount
	if iCount > 0 then
		for i = iCount - 1,0,-1  do
			self:ReturnObjToPool(transform:GetChild(i).gameObject)
		end
	end
end

function BaseWindow:RemoveAllChildToPoolAndClearEvent(transform, to)
	if not transform then
		return
	end
	local index = to or 0
	local objChild = nil
	local btn, tog = nil, nil
	for i = transform.childCount - 1, index, -1 do
		objChild = transform:GetChild(i).gameObject
		tog = objChild:GetComponent('Toggle')
		if (tog ~= nil) and (self._toggle ~= nil) then
			self:RemoveToggleClickListener(tog,true)
		end
		btn = objChild:GetComponent('Button')
		if (btn ~= nil) and (self._button ~= nil) then
			if self._button[btn] then
				btn.onClick:RemoveAllListeners()
				btn.onClick:Invoke()
				self._button[btn] = nil
			end
		end
		ReturnObjectToPool(objChild)
	end
end

local spriteTypeof = typeof(CS.UnityEngine.Sprite)
local sSpritePath = "UI/UISprite/"
function BaseWindow:SetSpriteAsync(sPath,spriteComnpent,onLoad)
	if string.byte(sPath, 1) ~= 58 then --':'
		sPath = sSpritePath..sPath
	end
	local fun = function(sprite)
		if IsValidObj(spriteComnpent) then
			if sprite ~= nil  then
				spriteComnpent.sprite = sprite
				if onLoad then
					onLoad()
				end
			else
				DRCSRef.Log("SetSpriteAsync is nil"..sPath)
			end
		end
	end
	LoadPrefabAsync(sPath,spriteTypeof,fun)	
end

---主动删除界面必须调用CloseUIWindow("XXX")或者上面的接口DestroyUI()，这个只能复写时放在OnDestroy中
function BaseWindow:Close(bItemClass)
	if self._classType ~= nil and bItemClass == nil then
		if DEBUG_MODE then
			showError("itemClass的删除 需要通过管理类!")
		end
		return
	end

    if self.toShow then
		self.toShow = false
		self:OnDisable()
    end
	self:OnDestroy()
	self:ReturnAllObjToPool()
	UnloadAllBoxPool(self)
	if self._button ~= nil then
		for key, value in pairs(self._button) do
			self:RemoveButtonClickListener(key)
		end
		self._button = nil
	end

	if self._toggle ~= nil then
		for key, value in pairs(self._toggle) do
			self:RemoveToggleClickListener(key)
		end
		self._toggle  = nil
	end

    --WindowsManager:GetInstance().loadAsynList = {};
    if self._gameObject then
        DRCSRef.ObjDestroy(self._gameObject)
        self._gameObject = nil
    end
	if self._objOtherLayerObj ~= nil then
		for k,v in pairs(self._objOtherLayerObj) do
			if v then
				DRCSRef.ObjDestroy(v)
			end
		end
	end

	if self._timeHandle ~= nil then
		for k,v in pairs(self._timeHandle) do
			globalTimer:RemoveTimer(v)
		end
	end
	
	if self._eventHandle ~= nil then
		for k,v in pairs(self._eventHandle) do
			for kk,vv in pairs(v) do
				LuaEventDispatcher:removeEventListener(k,vv)
			end
		end
	end

	-- 注销box池子
	UnloadBoxList(self)

	--注销Tween动画
	if self._tween then
		for k,v in pairs(self._tween) do
            if v then
				v.onComplete = nil
				v:Kill(false)
            end
		end
		self._tween = nil
	end
	
	---注销协程
	if  self._coroutine then
        for k,v in pairs(self._coroutine) do
            if v then
                CS_Coroutine.stop(v)
            end
        end
        self._coroutine = nil
    end

    for k, v in pairs(self) do
        self[k] = nil;
    end
	setmetatable(self, nil)
end

--返回objRoot节点下 名称为 szChildName 节点的GameObject，若有同名的。则返回最上层的那一个
function BaseWindow:FindChild(objRoot, szChildName)
	if objRoot == nil then
		return nil
	else
		return objRoot:FindChild(szChildName)
	end
end

--返回objRoot节点下 名称为 szChildName 节点的Component，若有同名的。则返回最上层的那一个
function BaseWindow:FindChildComponent(objRoot, szChildName,szComponentType)
	if objRoot == nil then
		return nil
	else
		return objRoot:FindChildComponent(szChildName,szComponentType)
	end
end

function BaseWindow:HideAllObjectInPool(objectPool)
    if not objectPool then 
        return
    end
    for _, object in ipairs(objectPool) do 
        object:SetActive(false)
    end
end

function BaseWindow:GetObjectFromPool(objectPool, objectOrigin, objectParent)
    if not objectPool then 
        return nil
    end
    for _, object in ipairs(objectPool) do 
        if not object.gameObject.activeSelf then 
            return object
        end
    end
    local newObject = CloneObj(objectOrigin, objectParent)
    table.insert(objectPool, newObject)
    return newObject
end

function BaseWindow:CommonBind(gameObject, callback)
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

function BaseWindow:RemoveSuperSC2Listener(scTable)

	if scTable then
		local funcNameT = {
			'mOnBeginDragAction',
			'mOnDragingAction',
			'mOnEndDragAction',
			'mOnGetItemByIndex',
		}
	
		for i = 1, #(scTable) do
			for j = 1, #(funcNameT) do
				if scTable[i][funcNameT[j]] then
					scTable[i][funcNameT[j]] = nil;
				end
			end
		end
	end

end

function LogButtonListenerInfo(uiNode)
	if uiNode == nil or uiNode.gameObject == nil then 
		return
	end
	buttonListenerDict = buttonListenerDict or {}
	buttonListenerDict[uiNode.gameObject] = {
		traceback = debug.traceback()
	}
end

function RemoveButtonListenerInfo(uiNode)
	if buttonListenerDict == nil or uiNode == nil or uiNode.gameObject == nil then 
		return
	end
	buttonListenerDict[uiNode.gameObject] = nil
end

function ShowAllUnremovedButtonListenerInfo()
	if not buttonListenerDict then
		return
	end
	for button, info in pairs(buttonListenerDict) do 
		derror('Unremoved button listener from ' .. info.traceback)
	end
end

--region: BoxPool相关代码
function BaseWindow:BuildBoxList(boxClass, root, formatKey, startIndex, param)
	local boxList = BoxHelper.GetBoxList(boxClass, root, formatKey, startIndex, param)
	for _, box in pairs(boxList) do
		table.insert(self.mBoxList, box)
	end
	return boxList
end

function UnloadBoxList(self)
	for _, box in pairs(self.mBoxList) do
		box:UnLoad()
	end
	self.mBoxList = {}
end

function BaseWindow:GetBox(boxClass, parent)
	local key = (self.name or '') .. '_' .. (boxClass['__cname'] or '')
	local box =	BoxPoolManager:GetInstance():Get(key, boxClass, parent)
	self.mBoxPool[key] = true
	return box
end

function BaseWindow:UnloadBoxPool(boxClass)
	local key = (self.name or '') .. '_' .. (boxClass['__cname'] or '')
	BoxPoolManager:GetInstance():Clear(key)
end

function BaseWindow:RemoveSelfWindow(bSaveToCache)
	RemoveWindowImmediately(self.name, bSaveToCache)
end
function UnloadAllBoxPool(self)
	for key, _ in pairs(self.mBoxPool) do
		BoxPoolManager:GetInstance():Clear(key)
	end
	self.mBoxPool = {}
end
--endreigon