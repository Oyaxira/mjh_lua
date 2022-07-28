local SpineRoleUINew = require 'UI/Role/SpineRoleUINew'
local _asyncLoadPerfabs = {}
local _asyncLoadScence = {}
-- 记录当前加载的场景数量
local l_loadSceneCount = 0

local _loadedPerfabs = {}
local _loadedSpriteAtlas = {}
local _loadedSpriteAtlas_Common = nil--常驻内存的
local _loadedPerfabs_Common = {}--常驻内存的

local _lastUsePerfabsTimes = {} --最近一次使用时间
local _UnloadPerfabs = {} --删除队列

local BGM_TYPE = {'Maps','Clans','Mazes'}
local _audioBGMHashMap = {}

local _ClassTypeof = 
{
	["Sprite"] = typeof(CS.UnityEngine.Sprite),
	["Texture"] = typeof(CS.UnityEngine.Texture),
	["GameObject"] = typeof(CS.UnityEngine.GameObject),
	["Material"] = typeof(CS.UnityEngine.Material),
	["SkeletonDataAsset"] = typeof(DRCSRef.SkeletonDataAsset),
	["SpriteAtlas"] = typeof(CS.UnityEngine.U2D.SpriteAtlas),
	["DOTweenAnimation"] = typeof(CS.DG.Tweening.DOTweenAnimation),
	["LuaDataBind"] = typeof(CS.GameApp.UI.LuaDataBind),
	["EventTrigger"] = typeof(DRCSRef.EventTrigger),
}




function InitLuaTable()
	local InitLuaTable_GenDataHelper = function(info,name)
		for index,id in ipairs(info[name]) do
			local out = _audioBGMHashMap[info.type][name]
			out[id] = info
		end
	end
	-- 处理下背景音乐数据
	for index,eType in pairs(AudioType) do
		_audioBGMHashMap[eType] = {}
		local info = _audioBGMHashMap[eType]
		for index,name in ipairs(BGM_TYPE) do
			info[name] = {}
		end
	end
	local AudioBGMTable = TableDataManager:GetInstance():GetTable("AudioBGM")
	if (not AudioBGMTable) then
		return
	end


	for baseID,info in pairs(AudioBGMTable) do
		if _audioBGMHashMap[info.type] == nil then 
			DRCSRef.LogError("ERROR:AUDIO TYPE ERROR!")
			return 
		end
		local isDefault = true
		for index,name in ipairs(BGM_TYPE) do
			if info[name] then 
				isDefault = false
				InitLuaTable_GenDataHelper(info,name)
			end
		end
		if isDefault then 
			_audioBGMHashMap[info.type]['default'] = info
		end
	end

end

function InitRoleTable()
	if TB_RoleHash then return end
	TB_RoleHash = {}
	local info = TB_RoleHash
	local TB_roleNew = {}
	for k,roleInfo in pairs(TB_Role) do
		if info[roleInfo.RoleID] == nil then
			info[roleInfo.RoleID] = {}
		end
		info[roleInfo.RoleID][roleInfo.Index] = roleInfo
		TB_roleNew[roleInfo.RoleID] = roleInfo
	end
	TB_Role = TB_roleNew
end

function GetFormatPath(name,iType)
	local sPath = name
	-- if (iType == _ClassTypeof.Sprite or iType == _ClassTypeof.Texture) then
	-- 	sPath = sPath .. ".png"
	-- elseif (iType == _ClassTypeof.GameObject) then
	-- 	sPath = sPath .. ".prefab"
	-- elseif (iType == _ClassTypeof.Material) then
	-- 	sPath = sPath .. ".mat"
	-- elseif (iType == _ClassTypeof.SkeletonDataAsset) then
	-- 	sPath = sPath .. ".asset"
	-- elseif (iType == _ClassTypeof.SpriteAtlas) then
	-- 	sPath = sPath .. ".spriteatlas"
	-- else
	-- 	sPath = sPath .. ".prefab"
	-- end

	return sPath
end

-----这个文件 后面需要扔到c#里去做 并做AssetBundle的处理
--加载并初始化perfab （sPath：UI/UIPrefabs后的路径 parentObj：父级 如果为nil则不设置）
function LoadEffectAndInit(sPath,parentObj,bUseParent)
	local prefab  = LoadPrefab(sPath, _ClassTypeof.GameObject)
	if prefab then
		local transform = nil
		if parentObj ~= nil then
			transform = parentObj.transform
		end
		local obj = DRCSRef.ObjInit(prefab, transform)
		--obj.transform:GetComponent('RectTransform').localPosition = DRCSRef.Vec3Zero
		--local reversepath = string.reverse(sPath)
		-- local loaduiname = nil
		-- if string.find(reversepath,"/") then
		-- 	loaduiname = string.reverse(string.sub(reversepath,1,string.find(reversepath,"/") - 1))
		-- else
		-- 	loaduiname = sPath
		-- end
		return obj
	end
	return nil
end

--加载并初始化perfab （sPath：UI/UIPrefabs后的路径 parentObj：父级 如果为nil则不设置）
function LoadPrefabAndInit(sPath,parentObj,bUseParent)
	local prefab  = LoadPrefab("UI/UIPrefabs/" .. sPath, _ClassTypeof.GameObject)
	if prefab then
		local transform = nil
		if parentObj ~= nil then
			transform = parentObj.transform
		end
		local obj = DRCSRef.ObjInit(prefab, transform)
		--obj.transform:GetComponent('RectTransform').localPosition = DRCSRef.Vec3Zero
		--local reversepath = string.reverse(sPath)
		-- local loaduiname = nil
		-- if string.find(reversepath,"/") then
		-- 	loaduiname = string.reverse(string.sub(reversepath,1,string.find(reversepath,"/") - 1))
		-- else
		-- 	loaduiname = sPath
		-- end
		return obj
	end
	return nil
end

function LoadFramePrefab(sPath,parentObj)
	local prefab  = LoadPrefab("UI/UIFrameAnimation/FramePrefab/"..sPath, _ClassTypeof.GameObject)
	if prefab then
		local obj = DRCSRef.ObjInit(prefab,parentObj.transform)
		-- local reversepath = string.reverse(sPath)
		-- local loaduiname = nil
		-- if string.find(reversepath,"/") then
		-- 	loaduiname = string.reverse(string.sub(reversepath,1,string.find(reversepath,"/") - 1))
		-- else
		-- 	loaduiname = sPath
		-- end
		return obj
	end
	return nil
end

--加载perfab 
function LoadPrefab(sPath,iType, mod)
	if not mod then
		sPath = GetFormatPath(sPath, iType)
	end
	local prefab = nil
	if _loadedPerfabs[sPath] then
		prefab = _loadedPerfabs[sPath] 
		_lastUsePerfabsTimes[sPath] = os.clock()
	elseif _loadedPerfabs_Common[sPath] then
		prefab = _loadedPerfabs_Common[sPath] 
	elseif _UnloadPerfabs[sPath] then
		prefab = _UnloadPerfabs[sPath] 
		_loadedPerfabs[sPath]  = prefab
		_UnloadPerfabs[sPath] = nil
		_lastUsePerfabsTimes[sPath] = os.clock()
	else
		if mod then
			prefab  = DRCSRef.ModLoadImage(string.sub(sPath,2))
		elseif iType then
			prefab  = DRCSRef.AssetBundleLoad(sPath,iType)	
		else
			prefab  = DRCSRef.AssetBundleLoad(sPath)	
		end
		
		if prefab then
			_loadedPerfabs[sPath] = prefab
			_lastUsePerfabsTimes[sPath] = os.clock()
		end
	end	
	return prefab
end

function LoadPrefabAsync(sPath,iType,loadCallback)
	sPath = GetFormatPath(sPath, iType)
	local prefab = nil
	if _loadedPerfabs[sPath] then
		prefab = _loadedPerfabs[sPath]
		_lastUsePerfabsTimes[sPath] = os.clock()
		if loadCallback then
			loadCallback(prefab,sPath)
		end
	elseif _loadedPerfabs_Common[sPath] then
		prefab = _loadedPerfabs_Common[sPath] 
		if loadCallback then
			loadCallback(prefab,sPath)
		end
	elseif _UnloadPerfabs[sPath] then
		prefab = _UnloadPerfabs[sPath] 
		_loadedPerfabs[sPath]  = prefab
		_UnloadPerfabs[sPath] = nil
		_lastUsePerfabsTimes[sPath] = os.clock()
		if loadCallback then
			loadCallback(prefab,sPath)
		end
	else
		if string.byte(sPath, 1) == 58 then --':'			
			local ret = LoadPrefab(sPath,_ClassTypeof.Sprite, 'mod')
			if loadCallback then loadCallback(ret, sPath) end
			return
		end
		local wait = CS.UnityEngine.WaitForSeconds(0.05)
	
		if _asyncLoadPerfabs[sPath] then
			CS_Coroutine.start(function()
				while  _asyncLoadPerfabs[sPath] do
					coroutine.yield(wait)
				end
				prefab = _loadedPerfabs[sPath] 
				_lastUsePerfabsTimes[sPath] = os.clock()
				if loadCallback then
					loadCallback(prefab,sPath)
				end
			end)		
		else
			_asyncLoadPerfabs[sPath] = true
			local resourceRequest = nil
			if iType then
				resourceRequest  = DRCSRef.AssetBundleAsyncLoad(sPath,iType)	
			else
				resourceRequest  = DRCSRef.AssetBundleAsyncLoad(sPath)
			end

			CS_Coroutine.start(function()
				while not resourceRequest.isDone do
					coroutine.yield(wait)
				end
				_asyncLoadPerfabs[sPath] = false
				prefab = resourceRequest.asset
				if prefab then
					_loadedPerfabs[sPath] = prefab
					_lastUsePerfabsTimes[sPath] = os.clock()
				end
				if loadCallback then
					loadCallback(prefab,sPath)
				end
			end)
		end
	end	
end

function GetAtlasSprite(sAtlasName,sSpriteName)
	local sprite = nil
	if sAtlasName == nil or sSpriteName == nil or sSpriteName == "" then
		return sprite
	end
	
	if _loadedSpriteAtlas[sAtlasName] then
		sprite = _loadedSpriteAtlas[sAtlasName]:GetSprite(sSpriteName)
	elseif _loadedSpriteAtlas_Common and _loadedSpriteAtlas_Common[sAtlasName] then
		sprite = _loadedSpriteAtlas_Common[sAtlasName]:GetSprite(sSpriteName)
	else
		local name = "UI/UIAtlas/" .. sAtlasName
		local eType =  _ClassTypeof.SpriteAtlas
		name = GetFormatPath(name, eType)
		local atlas = DRCSRef.AssetBundleLoad(name,eType)
		if (atlas) then
			sprite = atlas:GetSprite(sSpriteName)
			_loadedSpriteAtlas[sAtlasName] = atlas
		end
	end
	return sprite
end


function GetSprite(sSpriteName)
	if sSpriteName == "" or sSpriteName == nil then
		return nil
	end
	if string.byte(sSpriteName, 1) == 58 then --':'
		local ret = LoadPrefab(sSpriteName,_ClassTypeof.Sprite, 'mod')
		return ret
	end
	local sPath = "UI/UISprite/"..sSpriteName
	local sprite = LoadPrefab(sPath,_ClassTypeof.Sprite)	
	return sprite
end

function GetSpriteInResources(sSpriteName)
	if sSpriteName == "" or sSpriteName == nil then
		return nil
	end
	if string.byte(sSpriteName, 1) == 58 then --':'
		local ret = LoadPrefab(sSpriteName,_ClassTypeof.Sprite, 'mod')
		return ret
	end
	return DRCSRef.AssetBundleLoad(sSpriteName, _ClassTypeof.Sprite);
end

function GetHeadPicByData(data,callback)
	if (data and data.charPicUrl ~= nil and data.charPicUrl ~= "") then
		dprint("###Data.charPicUrl###"..data.charPicUrl)
		GetHeadPicByUrl(data.charPicUrl,callback)
	elseif (data and data.dwModelID ~= nil ) then
		dprint("###Data.dwModelID###"..data.dwModelID)
		GetHeadPicByModelId(data.dwModelID,callback)
	else
		--给默认头像
		GetHeadPicByModelId(0,callback)
	end
end

function GetHeadPicByUrl(url,callback)
	CS_Coroutine.start(function()
		local webRequest = CS.UnityEngine.Networking.UnityWebRequest(url)
		local tex = DRCSRef.DownloadHandlerTexture(true)
		webRequest.downloadHandler = tex
		coroutine.yield(webRequest:SendWebRequest());
		if webRequest.isHttpError or webRequest.isNetworkError then
			dprint('ERROR downloadtexture : ' .. webRequest.error);
			GetHeadPicByModelId(0,callback);
		else 
			local texture = tex.texture;
			local rect = CS.UnityEngine.Rect(0,0,texture.width,texture.height);
			local v2 = CS.UnityEngine.Vector2(0.5,0.5);
			local sprite = CS.UnityEngine.Sprite.Create(texture,rect,v2);
			if callback ~= nil then
				callback(sprite)
			end
		end
	end)
end

function GetHeadPicByModelId(modelid,callback)
	--modelid=0表示没设置过modelid 给默认头像
	local spriteName = "CharacterHead/major/head_major_nanzhu01"
	if modelid ~= 0 then
		local modelData = TableDataManager:GetInstance():GetTableData("RoleModel", tonumber(modelid))
		if modelData then
			spriteName = modelData.Head;
		end
	end
	if (callback ~= nil) then 
		dprint("###Data.dwModelID.GetSpriteName###"..spriteName)
		callback(GetSprite(spriteName))
	end
end

function UnModSprite(sSpriteName)
	if sSpriteName == "" or sSpriteName == nil then
		return nil
	end
	if string.byte(sSpriteName, 1) == 58 then --':'
		_loadedPerfabs[sSpriteName] = nil
	end	
end

--[todo] 资源卸载回头需要重新做一下
local function UnLoadPrefab()
	for k,v in pairs(_loadedPerfabs) do
		_loadedPerfabs[k] = nil
	end

	for k,v in pairs(_UnloadPerfabs) do
		_UnloadPerfabs[k] = nil
	end
	_UnloadPerfabs = {}
	_loadedPerfabs = {}
	_lastUsePerfabsTimes = {}
end

local function UnLoadAtlasSprote()
	for k,v in pairs(_loadedSpriteAtlas) do
		DRCSRef.ResourcesUnLoad(v)
	end
	_loadedSpriteAtlas = {}
end

local _UnloadPerfab = {}

function UnLoadAll(clearPool, dontdestroyWindow)
	WindowsManager:GetInstance():DestroyAll(dontdestroyWindow)
	UnLoadPrefab()
	UnLoadAtlasSprote()
	collectgarbage("collect")
	if clearPool == true then
		DRCSRef.ResourceManager:ReleasePoolSmart(UPDATE_UNLOAD_POOL)
	end
	DRCSRef.UnloadAssets()
	WindowsManager:GetInstance():clearChangeSceneNoClose()
end

-----定时删除
local UpdateUnload = function ()
	local curTime = os.clock()
	local time = UPDATE_UNLOAD_ASSET
	for k ,v in pairs(_lastUsePerfabsTimes) do
		if curTime - v > time  then
			_UnloadPerfabs[k] = _loadedPerfabs[k]
			_loadedPerfabs[k] = nil
		end
	end
end
--定时清除pool内容：注意softmask会有tempbuff的残留，如果缓存着 会导致内存下不来
local UpdateReleasePool = function()
	DRCSRef.ResourceManager:ReleasePoolSmart(UPDATE_UNLOAD_POOL)
end
globalTimer:AddTimer(30*1000,UpdateReleasePool,-1)
globalTimer:AddTimer(30*1000,UpdateUnload,-1)

function UpdateUnloadPerfabAsset()
	for k ,v in pairs(_UnloadPerfabs) do
		--DRCSRef.ResourcesUnLoad(v)
		_UnloadPerfabs[k] = nil
		break
	end
end

function print_func_ref_by_csharp()
	local tt = require ("xlua/util")
	tt.print_func_ref_by_csharp()
end

-----定时删除
function CallCollectGC()
	collectgarbage("collect")
	DRCSRef.UnloadAssets()
end

function CallUnloadUnusedAssets()
	DRCSRef.Log("CallUnloadUnusedAssets")
	CS.UnityEngine.Resources.UnloadUnusedAssets();
end

function ChangeScenceByQueue(sScenceName,notDestroyWindow,func,insertQueueHead)
	DisplayActionManager:GetInstance():AddAction(DisplayActionType.COMMON_CHANGE_SCENE, false, sScenceName, notDestroyWindow, func)
end

function ChangeScenceImmediately(sScenceName,notDestroyWindow,func)
	g_currentScene = sScenceName
	UnLoadAll(true,notDestroyWindow)
	LoadScencePreUI(sScenceName)
	LoadSceneAsync(sScenceName,func)
	WindowsManager:GetInstance():clearChangeSceneNoClose()
end

function LoadScencePreUI(sScenceName)
	if WINDOW_PRELOAD_UI and WINDOW_PRELOAD_UI[sScenceName] then
		local laodUI = WINDOW_PRELOAD_UI[sScenceName]["Perfabs"]
		if laodUI ~= nil then
			for key, value in pairs(laodUI) do
				LoadPrefabAsync(value,nil)
			end
		end
		local atals = WINDOW_PRELOAD_UI[sScenceName]["Atlas"]
		if atals ~= nil then
			for key, value in pairs(atals) do
				_loadedSpriteAtlas[key] = LoadPrefabAsync(value,_ClassTypeof.SpriteAtlas)
			end
		end

		if sScenceName~= "Login" and _loadedSpriteAtlas_Common == nil then
			_loadedSpriteAtlas_Common = {}
			local atals = WINDOW_PRELOAD_COMMON["Atlas"]
			for key, value in pairs(atals) do
				_loadedSpriteAtlas_Common[key] = LoadPrefabAsync(value,_ClassTypeof.SpriteAtlas)
			end
		
			local perfabs = WINDOW_PRELOAD_COMMON["Perfabs"]
			for key, value in pairs(perfabs) do
				_loadedPerfabs_Common[key] = LoadPrefabAsync(key)
			end
		end
	end
end

function LoadSceneAsync(sScenceName,func)
	local wait = CS.UnityEngine.WaitForSeconds(0.06)
	if _asyncLoadScence[sScenceName] then
		LuaEventDispatcher:addEventListener('LoadSceneFinish', function()
			if func then
				func()
			end
		end, nil, nil, true)
	else
		_asyncLoadScence[sScenceName] = true
		l_loadSceneCount = l_loadSceneCount + 1
		local resourceRequest = nil
		resourceRequest  = CS.UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(sScenceName);
		local oneProgress = 50 / #_asyncLoadPerfabs
		CS_Coroutine.start(function()
			while not resourceRequest.isDone or #_asyncLoadPerfabs > 0 do
				local iprogress = resourceRequest.progress / 2 + oneProgress * #_asyncLoadPerfabs
				if iprogress < 0 then
					iprogress = 0
				end
				LuaEventDispatcher:dispatchEvent("LoadSceneProcess",resourceRequest.progress - #_asyncLoadPerfabs * 5)
				coroutine.yield(wait)
			end
			_asyncLoadScence[sScenceName] = false
			l_loadSceneCount = l_loadSceneCount - 1
			if l_loadSceneCount < 0 then 
				l_loadSceneCount = 0
			end
			if func then
				func()
			end
			LuaEventDispatcher:dispatchEvent("LoadSceneFinish",sScenceName)
			ProcessGameLogicShowCmdCache()
		end)
	end
end

function IsLoadingSceneAsync()
	return l_loadSceneCount > 0
end

-- 移除所有孩子
function RemoveAllChildren(obj)
	if obj and obj.gameObject ~= nil then
		obj.gameObject:RemoveAllChildren()
	end
    -- local t = obj.transform
    -- for int_i = t.childCount - 1, 0, -1 do
	-- 	DRCSRef.ObjDestroy(t:GetChild(int_i).gameObject)
    --     --DRCSRef.ResourcesUnLoad(v)
    -- end
end

-- 移除所有孩子
function RemoveAllChildrenImmediate(obj)
	if obj and obj.gameObject ~= nil then
		obj.gameObject:RemoveAllChildrenImmediate()
	end
    -- local t = obj.transform
    -- for int_i = t.childCount - 1, 0, -1 do
	-- 	DRCSRef.DestroyImmediate(t:GetChild(int_i).gameObject, true)
    --     --DRCSRef.ResourcesUnLoad(v)
    -- end
end

-- 移除所有孩子和事件
function RemoveAllChildrenAndEventImmediate(uiScript, obj, to)
	local transform = obj.transform;
	local index = to and to or 0;
	for i = transform.childCount - 1, index, -1 do
		local go = transform:GetChild(i).gameObject;
		local btn = go:GetComponent('Button');
		local tog = go:GetComponent('Toggle');
		if (tog ~= nil) and (uiScript._toggle ~= nil) then
			for k, v in pairs(uiScript._toggle) do			
				if tog == uiScript._toggle[k] then
					tog.onValueChanged:RemoveAllListeners();
					tog.onValueChanged:Invoke();
					table.remove(uiScript._toggle, k);
					break;
				end
			end
		end

		if (btn ~= nil) and (uiScript._button ~= nil) then
			for k, v in pairs(uiScript._button) do	
				if btn == uiScript._button[k] then
					btn.onClick:RemoveAllListeners();
					btn.onClick:Invoke();
					table.remove(uiScript._button, k);
					break;
				end
			end
		end
		DRCSRef.DestroyImmediate(go, true);
	end
end

-- 移除所有按钮孩子
function RemoveAllButtonChildren(obj)
    local t = obj.transform
	for int_i = t.childCount - 1, 0, -1 do
		local objChild = t:GetChild(int_i).gameObject
		local comButton = objChild:GetComponent('Button')
		if comButton then 
			comButton.onClick:RemoveAllListeners()
			comButton.onClick:Invoke()
		end
		DRCSRef.ObjDestroy(t:GetChild(int_i).gameObject)
        --DRCSRef.ResourcesUnLoad(v)
    end
end

function CloneObj(cloneObj,parentObj)
	if cloneObj == nil or parentObj == nil then
		return
	end
	local obj = DRCSRef.ObjInit(cloneObj,parentObj.transform)
	local comRectTransform = obj.transform:GetComponent('RectTransform')
	if comRectTransform then
		comRectTransform.localPosition = parentObj.transform:GetComponent('RectTransform').localPosition
	end
	return obj
end

--根据枚举获取对应 语言  LANGUAGE_TYPE c#中设置过来的
function GetLanguageByEnum(iEnumID)
	return GetLanguageByID(AttrType_Lang[iEnumID])
end

function GetLanguageByTableData(TB_X,id)
    if TB_X and id and TB_X[id] and TB_X[id].NameID then 
        return GetLanguageByID(TB_X[id].NameID)
    end
    return "" 
end

-- 给物体添加响应
function AddEventTrigger(objTransform,callBack,eventType)
	local eventTrigger = objTransform:GetComponent("EventTrigger")
	if eventTrigger == nil then
		eventTrigger = objTransform.gameObject:AddComponent(_ClassTypeof.EventTrigger)
	end
		
	eventType = eventType and eventType or DRCSRef.EventTriggerType.PointerClick
	local entry = DRCSRef.EventTrigger.Entry(); 
	entry.eventID = eventType; 
	entry.callback:AddListener(callBack); 
	eventTrigger.triggers:Add(entry);
end

function RemoveEventTrigger(objTransform)
	if not IsValidObj(objTransform) then
		return
	end
	local eventTrigger = objTransform:GetComponent("EventTrigger")
	if eventTrigger == nil then
		return
	end
	eventTrigger.triggers:Clear()
end

function StopDoTween(obj)
	local iNum = obj.transform.childCount
	for i = 0, iNum -1  do
		local kChild = obj.transform:GetChild(i)
		kChild.transform:DOPause()
	end
end

--播放根节点下的 所有dotween
function PlayDoTween(obj)
	local iNum = obj.transform.childCount
	for i = 0, iNum -1  do
		local kChild = obj.transform:GetChild(i)
		kChild.transform:DOPlay()
	end
end

--播放根节点下的  所有animation
function PlayDoAnimation(obj)
	local iNum = obj.transform.childCount
	for i = 0, iNum -1  do
		local kComponents= obj.transform:GetChild(i):GetComponents(_ClassTypeof.DOTweenAnimation)	
		if kComponents and kComponents.Length > 0 then
			for i=1, kComponents.Length do
				local animation = kComponents[i-1]
				if animation then
					animation:DOPlay()
				end
			end
		end	
	end
end

function ReStartDoAnimation(obj)
	local iNum = obj.transform.childCount
	for i = 0, iNum -1  do
		local kComponents= obj.transform:GetChild(i):GetComponents(_ClassTypeof.DOTweenAnimation)	
		if kComponents and kComponents.Length > 0 then
			for i=1, kComponents.Length do
				local animation = kComponents[i-1]
				if animation then
					animation:DORestart()
				end
			end
		end	
	end
end

function RewindDoAnimation(obj)
	local iNum = obj.transform.childCount
	for i = 0, iNum -1  do
		local kComponents= obj.transform:GetChild(i):GetComponents(_ClassTypeof.DOTweenAnimation)	
		if kComponents and kComponents.Length > 0 then
			for i=1, kComponents.Length do
				local animation = kComponents[i-1]
				if animation then
					animation:DORewind()
				end
			end
		end	
	end
end

function RewindSelfDoAnim(obj)
	local kComponents= obj:GetComponents(_ClassTypeof.DOTweenAnimation)	
	if kComponents and kComponents.Length > 0 then
		for i=1, kComponents.Length do
			local animation = kComponents[i-1]
			if animation then
				animation:DORewind()
			end
		end
	end	
end

function StopDoAnimation(obj)
	local iNum = obj.transform.childCount
	for i = 0, iNum -1  do
		local kComponents= obj.transform:GetChild(i):GetComponents(_ClassTypeof.DOTweenAnimation)	
		if kComponents and kComponents.Length > 0 then
			for i=1, kComponents.Length do
				local animation = kComponents[i-1]
				if animation then
					animation:DOPause()
				end
			end
		end	
	end
end

local kActorSkeletionDataPath = "Actor/%s/%s_SkeletonData"
local kActorSkeletionDataName = "%s_SkeletonData"
local GetSpineDataName = function(spineDataPath)
	local spineDataName = spineDataPath or ''
	while string.find(spineDataName, '/') do 
		local pos = string.find(spineDataName, '/')
		spineDataName = string.sub(spineDataName, pos + 1)
	end
	return spineDataName
end

-- 替换obj上的spine动画
function DynamicChangeSpine(objSpine, newSkeletonDataPath, animationName)
	--做个处理 防止上层逻辑 在把obj返回缓存池，缓存池删除obj后  上层逻辑仍然在使用
	if not IsValidObj(objSpine) then 
		return
	end
	local newSkeletonDataName = GetSpineDataName(newSkeletonDataPath)
	local newSkeletonDataFullPath = string.format(kActorSkeletionDataPath, newSkeletonDataPath,newSkeletonDataName) 
	if animationName == nil then
		animationName = ROLE_SPINE_DEFAULT_ANIM
	end
	return DynamicChangeSpineFullPath(objSpine, newSkeletonDataFullPath, animationName)
end

-- 替换obj上的spine动画, 参数为完整路径
function DynamicChangeSpineFullPath(objSpine, newSkeletonDataFullPath, animationName)
	local skeletonAnim = objSpine:GetComponent("SkeletonAnimation")
	local skeletonGrap = objSpine:GetComponent("SkeletonGraphic")
	if not (skeletonAnim or skeletonGrap) then
		return
	end
	local skeletonCom = skeletonAnim or skeletonGrap
	local start_t = os.clock()
	local loadSpine = LoadPrefab(newSkeletonDataFullPath, _ClassTypeof.SkeletonDataAsset)
	dprint("load spine",newSkeletonDataFullPath,os.clock() - start_t)
	if not loadSpine then
		derror("未找到模型数据", newSkeletonDataFullPath)
		if newSkeletonDataFullPath ~= MODEL_DEFAULT_SPINE then
			return DynamicChangeSpine(objSpine, MODEL_DEFAULT_SPINE, animationName)
		else
			return false
		end
	end
	if skeletonCom then
		skeletonCom.skeletonDataAsset = loadSpine
		skeletonCom:Initialize(true)
		if skeletonAnim and HasAction(skeletonAnim.gameObject, animationName) then 
			skeletonAnim:ClearState()
			skeletonAnim.AnimationState:SetAnimation(0,animationName,true)

			-- skeletonAnim.AnimationName = animationName
			-- skeletonAnim.loop = true
			-- skeletonAnim:Initialize(true)
		end
	end
	dprint("Initialize spine",newSkeletonDataFullPath,os.clock() - start_t)
	return true
end

-- spine 是否正在播放动画
function IsSpinePlayAnim(objSpine, animationName)
	local skeletonAnim = objSpine:GetComponent("SkeletonAnimation")
	if skeletonAnim == nil then
		return false
	end
	if skeletonAnim then
		return skeletonAnim.AnimationName == animationName
	end
	return false
end

-- 判断是否是同一个 Spine
function IsSameSpine(objSpine, spineDataPath)
	if not (objSpine and spineDataPath) then 
		return false
	end
	local spineDataName = GetSpineDataName(spineDataPath)
	local skeletonDataName = string.format(kActorSkeletionDataName, spineDataName) 
	local comSkeletonGraphic = objSpine:GetComponent("SkeletonAnimation")
	if comSkeletonGraphic and comSkeletonGraphic.skeletonDataAsset and comSkeletonGraphic.skeletonDataAsset.name == skeletonDataName then 
		return true
	end
	return false
end

local rootTransform = nil
function ObjectInitFormPool(kPath,kParent)
	local obj = DRCSRef.ResourceManager:GetObjectFromPool(kPath,true,1)
	if obj then
		if kParent then
			obj.transform:SetParent(kParent.transform)
		else
			if rootTransform == nil then
				rootTransform = DRCSRef.FindGameObj('UIBase').parent
			end
			obj.transform:SetParent(rootTransform)
		end
		obj.transform.localScale = DRCSRef.Vec3One 
		obj.transform.localPosition = DRCSRef.Vec3Zero 
	end
	return obj
end

local kActorPath = "Actor/%s/%s_prefab"
--kPath 文件夹名称  parentObj父物体 
function LoadSpineFromPool(kPath,parentObj,isSpecialPath)
	kPath = isSpecialPath and kPath or string.format(kActorPath,kPath,kPath)
	kPath = GetFormatPath(kPath, _ClassTypeof.GameObject)
	return ObjectInitFormPool(kPath,parentObj)
end

--kPath 文件夹名称  parentObj父物体 
function LoadSpineCharacter(kPath,parentObj,isSpecialPath)
	kPath = isSpecialPath and kPath or string.format(kActorPath,kPath,kPath)
	local prefab = LoadPrefab(kPath, _ClassTypeof.GameObject)
	if prefab then
		local obj = DRCSRef.ObjInit(prefab,parentObj.transform)
		return obj
	end
	return nil
end

function LoadSpineCharacterNew(kPath,parentObj,isSpecialPath,roleData)
	kPath = isSpecialPath and kPath or string.format(kActorPath,kPath,kPath)
	local prefab = LoadPrefab(kPath, _ClassTypeof.GameObject)
	if prefab then
		local EmptyObject = DRCSRef.GameObject(kPath)
		EmptyObject.transform:SetParent(parentObj.transform)
		local obj = DRCSRef.ObjInit(prefab,EmptyObject.transform)
		local spineRoleUINew = SpineRoleUINew.new(false)
		spineRoleUINew:Init(roleData,EmptyObject,obj)
    	spineRoleUINew:UpdateRoleSpine()
		return spineRoleUINew
	end
	return nil
end

function LoadPrefabFromPool(sPath,parentObj,bAllPath)
	local kPath = sPath
	if not bAllPath then
		kPath = "UI/UIPrefabs/" .. sPath
	end

	kPath = GetFormatPath(kPath, _ClassTypeof.GameObject)

	return ObjectInitFormPool(kPath,parentObj)
end

function LoadGameObjFromPool(obj,parentObj)
	if obj ~= nil then
		return ObjectInitFormPool(obj,parentObj)
	end
	return nil
end

function ReturnObjectToPool(obj,bActive)
	if bActive == nil then
		bActive = true
	end

	if obj and obj.gameObject then
		obj.gameObject:SetActive(bActive)
		DRCSRef.ResourceManager:ReturnObjectToPool(obj)
	end
end


function LoadSpineCharacterAsync(sPath,parentObj,callBack,isSpecialPath)
	sPath = isSpecialPath and sPath or string.format(kActorPath,sPath,sPath)
	local fun = function (prefab)
		local obj = nil
		if prefab then
			obj = DRCSRef.ObjInit(prefab,parentObj.transform)
		end	
		if callBack then
			callBack(obj)
		end
	end
	LoadPrefabAsync(sPath,nil,fun)
end

local kWeaponPath = "Weapon/%s/%s_prefab"
function LoadActorSpineWeapon(objActor,sWeaponPath)
	if objActor == nil then
		DRCSRef.LogError("objActor is null")
		return 
	end
	local objWeaponRoot = objActor:FindChild("weapon_Node")
	if objWeaponRoot == nil then
		DRCSRef.LogError("没有weapon_Node 挂点")
		return 
	end
	sWeaponPath = string.format(kWeaponPath,sWeaponPath,sWeaponPath)
	local prefab = LoadPrefab(sWeaponPath, _ClassTypeof.GameObject)
	if prefab then
		local obj = DRCSRef.ObjInit(prefab,objWeaponRoot.transform)
		return obj
	end
end

function LoadActorSpineWeaponAsync(objActor,sWeaponPath,callBack)
	if objActor == nil then
		DRCSRef.LogError("objActor is null")
		return 
	end
	local objWeaponRoot = objActor:FindChild("weapon_Node")
	if objWeaponRoot == nil then
		DRCSRef.LogError("没有weapon_Node 挂点")
		return 
	end

	sWeaponPath = string.format(kWeaponPath,sWeaponPath,sWeaponPath)
	local fun = function (prefab)
		local obj = nil
		if prefab then
			obj = DRCSRef.ObjInit(prefab,objWeaponRoot.transform)
		end	
		if callBack then
			callBack(obj)
		end
	end
	LoadPrefabAsync(sWeaponPath,nil,fun)
end

function PreLoadPerfabAsync(_path)	
	for k,v in pairs(_path) do
		LoadPrefabAsync(v,nil)
	end	
end

function ChnageSpineSkin_Graphic(objSpine,sTexturePath)
	local comGraphic = objSpine:GetComponent("SkeletonGraphic")
	if comGraphic == nil then
		dprint("没有 SkeletonGraphic控件")
		return
	end

	local texture = LoadPrefab(sTexturePath,_ClassTypeof.Texture)	
	if texture == nil then
		dprint("找不到图片"..sTexturePath)
		return
	end
	comGraphic.OverrideTexture = texture;
end


--spine换装
--只有贴图位置信息跟原贴图完全一致的 才能这么做
--只有 SkeletonAnimation 或者 SkeletonMesh 才能使用
--objSpine spine物体，sTexturePath 贴图路径 注意统一文件夹下 不许重名
--返回 textrue 需要缓存
function ChnageSpineSkin(objSpine,sTexturePath)
	local  mesh = objSpine:GetComponent("MeshRenderer")
	if mesh == nil then
		dprint("没有 MeshRenderer控件")
		return
	end

	-- local ani = objSpine:GetComponent("SkeletonAnimation")
	-- if ani == nil then
	-- 	dprint("没有 SkeletonAnimation 控件")
	-- 	return
	-- end
	-- if ani.SkeletonDataAsset == nil then
	-- 	dprint("没有 SkeletonDataAsset")
	-- 	return
	-- end
	
	local texture = LoadPrefab(sTexturePath,_ClassTypeof.Texture)
	
	if texture == nil then
		dprint("找不到图片"..sTexturePath)
		return
	end

	ReplaceTextureForSkinNew(objSpine,texture)
	return texture
	-- ReplaceTextureForSkin(ani,texture)
end
-- 取代旧的换肤代码
function ReplaceTextureForSkinNew(objSpine,texture)
	local spineShader = objSpine:GetComponent("Renderer")
	local PropertyBlock = CS.UnityEngine.MaterialPropertyBlock()
	spineShader:GetPropertyBlock(PropertyBlock)
	PropertyBlock:SetTexture(ShaderProperyId_MainTex, texture);
	spineShader:SetPropertyBlock(PropertyBlock);
end
function ReplaceTextureForSkin(ani,texture)
	--存在字符串计算以及SpineAtlasAsset实例化消耗，可以考虑后期空间换时间
	--todo扔到C#层
	--todo异步处理
	local textures = {}
	table.insert(textures,texture)
	local atlasText = ani.SkeletonDataAsset.atlasAssets[0].atlasFile
	local atlasString = atlasText.text
	atlasString = string.gsub(atlasString,"\r", "")
	local atlasLines = string.split(atlasString,'\n')
	local rt
	local newAtlasString = atlasText.text
	if #atlasLines > 1 then
		local temp = string.gsub(newAtlasString,string.trim(atlasLines[1]),texture.name..'.png')
		rt = DRCSRef.TextAsset(temp)
	end

	local skeletonJson = ani.SkeletonDataAsset.skeletonJSON
	local spineShader = DRCSRef.Shader.Find("Spine/Skeleton")
	if (spineShader == nil) then
		derror("模型数据加载失败")
		return
	end
	local material = DRCSRef.Material(spineShader)
	material:CopyPropertiesFromMaterial(ani.SkeletonDataAsset.atlasAssets[0].PrimaryMaterial)
	local runtimeAtlasAsset = DRCSRef.SpineAtlasAsset.CreateRuntimeInstance(rt, textures, material, true)
	local runtimeSkeletonDataAsset = DRCSRef.SkeletonDataAsset.CreateRuntimeInstance(skeletonJson, runtimeAtlasAsset, true)
	ani.skeletonDataAsset = runtimeSkeletonDataAsset
	ani:Initialize(true)
end

function SetSkeletonAnimation(skeletonAnimation, trackIndex, animationName, isLoop, endCallback)
	if skeletonAnimation == nil then 
		return
	end
	globalTimer:AddTimer(40, function()
		if IsValidObj(skeletonAnimation) and skeletonAnimation.AnimationState ~= nil then 
			if skeletonAnimation.loop ~= nil then
				skeletonAnimation.loop = isLoop
			end
			if skeletonAnimation.ClearState then
				skeletonAnimation:ClearState()
			end
			if skeletonAnimation.AnimationName then  
				skeletonAnimation.AnimationName = animationName -- 原生接口有安全处理
			else
				skeletonAnimation.AnimationState:SetAnimation(trackIndex, animationName, isLoop)
			end
			if type(endCallback) == 'function' then 
				endCallback()
			end
		else
			showError('AnimationState is nil!\n')
		end
    end)
end


-- 在物体上记录 uint 数据
function SetUIntDataInGameObject(obj, key, data)
	if not (obj ~= nil and type(key) == 'string' and type(data) == 'number') then 
		return 
	end
	local comLuaDataBind = obj.gameObject:GetComponent('LuaDataBind')
	if comLuaDataBind == nil then 
		comLuaDataBind = obj.gameObject:AddComponent(_ClassTypeof.LuaDataBind)
	end
	data = math.floor(data)
	comLuaDataBind:SetUInt(key, data)
end

-- 在物体上记录 float 数据
function SetFloatDataInGameObject(obj, key, data)
	if not (obj ~= nil and type(key) == 'string' and type(data) == 'number') then 
		return 
	end
	local comLuaDataBind = obj.gameObject:GetComponent('LuaDataBind')
	if comLuaDataBind == nil then 
		comLuaDataBind = obj.gameObject:AddComponent(_ClassTypeof.LuaDataBind)
	end
	comLuaDataBind:SetFloat(key, data)
end

-- 在物体上记录 string 数据
function SetStringDataInGameObject(obj, key, data)
	if not (obj ~= nil and type(key) == 'string' and type(data) == 'string') then 
		return 
	end
	local comLuaDataBind = obj.gameObject:GetComponent('LuaDataBind')
	if comLuaDataBind == nil then 
		comLuaDataBind = obj.gameObject:AddComponent(_ClassTypeof.LuaDataBind)
	end
	comLuaDataBind:SetString(key, data)
end

-- 从物体获取记录的 uint 数据
function GetUIntDataInGameObject(obj, key) --obj 是 gameobject 或者 transform都可以
	if not (obj ~= nil and type(key) == 'string') then 
		return 0
	end
	return obj:GetUIntDataInGameObject(key)
end

-- 从物体获取记录的 float 数据
function GetFloatDataInGameObject(obj)
	if not (obj ~= nil and type(key) == 'string') then 
		return 0
	end
	local comLuaDataBind = obj.gameObject:GetComponent('LuaDataBind')
	if comLuaDataBind == nil then 
		return 0
	end
	return comLuaDataBind:GetFloat(key)
end

-- 从物体获取记录的 string 数据
function GetStringDataInGameObject(obj, key)
	if not (obj ~= nil and type(key) == 'string') then 
		return ""
	end
	return obj:GetStringDataInGameObject(key)
end

---------------- MUSIC
_SOUND_TRACK = {}
local l_FMODManager = CS.GameApp.FMODManager
function PlayMusic(resourceBgmID)
	local func = function()
		if resourceBgmID == nil then return end
		if resourceBgmID == 1 then 
			StopMusic()
			return 
		end
		local data = TableDataManager:GetInstance():GetTableData("ResourceBGM",resourceBgmID)
		if data then
			l_FMODManager.PlayMusic(data.BGMPath,data.Bank);
		else
			dprint("TB_ResourceBGM : is null"..resourceBgmID)
		end
	end
	xpcall(func,showError)
end

function StopMusic()
	l_FMODManager.StopMusic()
end

function PlaySound(resourceBgmID)
	local func = function ()
		if resourceBgmID == nil then return 0 end
		local data = TableDataManager:GetInstance():GetTableData("ResourceBGM",resourceBgmID)
		if data then
			local iKey = resourceBgmID
			local length = l_FMODManager.Play2DSound(data.BGMPath,data.Bank,iKey);
			return length
		else
			dprint("TB_ResourceBGM : is null"..resourceBgmID)
		end
	end

	local err,ret = xpcall(func,showError)
	return ret or 0
end

local VOCAL_LAST = 0
function PlayVocal(resourceBgmID)
	if VOCAL_LAST ~= 0 then
		l_FMODManager.StopPlaySound(VOCAL_LAST,true)
	end

	local func = function ()
		if resourceBgmID == nil then return 0 end
		local data = TableDataManager:GetInstance():GetTableData("ResourceBGM",resourceBgmID)
		if data then
			VOCAL_LAST = resourceBgmID
			local iKey = resourceBgmID
			local length = l_FMODManager.Play2DSound(data.BGMPath,data.Bank,iKey);
			return length
		else
			dprint("TB_ResourceBGM : is null"..resourceBgmID)
		end
	end

	local err,ret = xpcall(func,showError)
	return ret or 0
end

function StopSound(resourceBgmID)
	if resourceBgmID then 
		CS.GameApp.FMODManager.StopPlaySound(resourceBgmID);
	end
end

PlayAudioByType = function(bgmID,audioType)
	if audioType == AudioType.AudioType_Music then
		PlayMusic(bgmID)
		return true
	else
		if bgmID == 1 then 
			if _SOUND_TRACK[audioType] then 
				StopSound(_SOUND_TRACK[audioType])
			end
			return true
		end
		if _SOUND_TRACK[audioType] == bgmID then 
			-- 一样不处理
			return true
		end
		-- 对音频分轨处理
		if _SOUND_TRACK[audioType] then 
			StopSound(_SOUND_TRACK[audioType])
		end
		_SOUND_TRACK[audioType] = bgmID
		PlaySound(bgmID)
		return true
	end
	return false
end

local PlayBGMMusicHelper = function(name,id,audioType)
	local tableAudioBGM = TableDataManager:GetInstance():GetTable("AudioBGM")
	if (not tableAudioBGM) then
		return
	end
	local audioInfo = _audioBGMHashMap[audioType]
	if audioInfo == nil or audioInfo[name] == nil then return end
	local info = audioInfo[name][id]
	if info == nil and name == "Maps" and audioType == AudioType.AudioType_Music then 
		info = tableAudioBGM[DEFAULT_BGM_MAPID]
	end
	if info then 
		local resourceBgmID = info.ResourceBGM
		local tagID = info.ReplaceTag
		local tagValue = info.ReplaceTagValue
		if tagID and #tagID > 0 and tagValue and #tagValue == #tagID then 
			local l_TaskTagManager = TaskTagManager:GetInstance()
			for i=1,#tagID do
				if l_TaskTagManager:TagIsValue(tagID[i],tagValue[i]) then 
					resourceBgmID = info.ReplaceBGM[i] or 0
					break
				end
			end
		end
		return PlayAudioByType(resourceBgmID,audioType)
	end
	return false
end

local function PlayMusicHelperSubMaze(audioType)
	local curMazeID = MazeDataManager:GetInstance():GetCurMazeTypeID()
	if curMazeID and curMazeID ~= 0 then
		if PlayBGMMusicHelper("Mazes",curMazeID,audioType) then
			G_Last_city_bgmID = nil
			return
		end
	end
	-- 播放默认音效
	if _audioBGMHashMap[audioType] and _audioBGMHashMap[audioType]["default"] then 
		PlayAudioByType(_audioBGMHashMap[audioType]["default"].ResourceBGM,audioType)
	end
end

function PlayMusicHelper(isMaze)
	for index,eType in pairs(AudioType) do
		if isMaze then 
			PlayMusicHelperSubMaze(eType)
		else
			PlayMusicHelperSub(eType)
		end
	end
end

function PlayMusicHelperSub(audioType)
	local uiClanTypeID = CityDataManager:GetInstance():GetCurClanTypeID()
	if uiClanTypeID and uiClanTypeID ~= 0 then 
		if PlayBGMMusicHelper("Clans",uiClanTypeID,audioType) then 
			return
		end
	end

	local uiCurMap = MapDataManager:GetInstance():GetCurMapID()
	if uiCurMap and uiCurMap ~= 0 then 
		if PlayBGMMusicHelper("Maps",uiCurMap,audioType) then 
			return
		end
	end

	-- 播放默认音效
	if _audioBGMHashMap[audioType] and _audioBGMHashMap[audioType]["default"] then 
		PlayAudioByType(_audioBGMHashMap[audioType]["default"].ResourceBGM,audioType)
	end
end

local _oldDialogueSoundID = nil
function StopDialogueSound()
	if _oldDialogueSoundID then 
		StopSound(_oldDialogueSoundID)
	end
end

function PlayDialogueSound(resourceBgmID)
	local iLength = nil
	if resourceBgmID and resourceBgmID ~= 0 then 
		StopDialogueSound()
		_oldDialogueSoundID = resourceBgmID
		iLength = PlaySound(resourceBgmID)
	end
	return iLength or 0
end

function PlayNPCSound(roleTypeID)
	local roleData = TB_Role[roleTypeID]
	if roleData then 
		PlayDialogueSound(roleData.helloSound)
	end
end

function PlayButtonSound(attrName)
	local AudioUIData = TableDataManager:GetInstance():GetTableData("AudioUI", 1)
	if AudioUIData then 
		PlaySound(AudioUIData[attrName])
	end
end


function GetAudioSoundID(attrName)
	local AudioUIData = TableDataManager:GetInstance():GetTableData("AudioUI", 1)
	if AudioUIData then 
		return AudioUIData[attrName]
	end
end

function StopButtonSound(attrName)
	local AudioUIData = TableDataManager:GetInstance():GetTableData("AudioUI", 1)
	if AudioUIData then 
		StopSound(AudioUIData[attrName])
	end
end

function SetDefaultButtonSound()
	local AudioUIData = TableDataManager:GetInstance():GetTableData("AudioUI", 1)
	if AudioUIData and AudioUIData['ButtonDefault'] then 
		local data = TableDataManager:GetInstance():GetTableData("ResourceBGM",AudioUIData['ButtonDefault'])
		if data then
			CS.DRButton.SetDefaultSound(data.BGMPath,data.Bank)
		end
	end
end

function ClearScriptMusicInfo()
	G_Last_city_bgmID = nil
end