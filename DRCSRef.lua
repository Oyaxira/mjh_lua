---简化C#的调用
---需要注意,引用命名空间是没有问题的，但运行时调用的对象，需要考虑是否提前引用了
DRCSRef = {}

---UnityEngine
DRCSRef.GameObject = CS.UnityEngine.GameObject
DRCSRef.EventSystems = CS.UnityEngine.EventSystems
DRCSRef.AppDataPath = CS.UnityEngine.Application.dataPath
DRCSRef.Vec3Int = CS.UnityEngine.Vector3Int
DRCSRef.Vec3IntZero = CS.UnityEngine.Vector3Int.zero
DRCSRef.Vec3IntOne = CS.UnityEngine.Vector3Int.one
DRCSRef.Vec3 = CS.UnityEngine.Vector3
DRCSRef.Vec3One = CS.UnityEngine.Vector3.one
DRCSRef.Vec3Zero = CS.UnityEngine.Vector3.zero
DRCSRef.Vec2One = CS.UnityEngine.Vector2.one
DRCSRef.Vec2Zero = CS.UnityEngine.Vector2.zero
DRCSRef.Vec2 = CS.UnityEngine.Vector2
DRCSRef.ObjDestroy = CS.UnityEngine.Object.Destroy
DRCSRef.DestroyImmediate = CS.UnityEngine.Object.DestroyImmediate
DRCSRef.DontDestroyOnLoad = CS.UnityEngine.Object.DontDestroyOnLoad
DRCSRef.ObjInit = CS.UnityEngine.Object.Instantiate
DRCSRef.FindGameObj = DRCSRef.GameObject.Find
DRCSRef.Platform = CS.UnityEngine.RuntimePlatform
DRCSRef.Screen = CS.UnityEngine.Screen
DRCSRef.Application = CS.UnityEngine.Application
DRCSRef.Time = CS.UnityEngine.Time
DRCSRef.LogError = CS.UnityEngine.Debug.LogError
DRCSRef.Log = CS.UnityEngine.Debug.Log
DRCSRef.Quaternion = CS.UnityEngine.Quaternion
DRCSRef.SystemInfo = CS.UnityEngine.SystemInfo
DRCSRef.platform = CS.UnityEngine.Application.platform
DRCSRef.Mathf = CS.UnityEngine.Mathf
DRCSRef.ModGetFileName = CS.Mod.GetFileName
DRCSRef.ModEditImage = CS.Mod.EditImage
DRCSRef.ModGetImage = CS.Mod.GetImage
DRCSRef.ModLoadImage = CS.Mod.LoadImage
DRCSRef.ModRevertImage = CS.Mod.RevertImage
DRCSRef.ResourcesLoad = CS.UnityEngine.Resources.Load
DRCSRef.ResourcesAsyncLoad = CS.UnityEngine.Resources.LoadAsync
DRCSRef.ResourcesUnLoad = CS.UnityEngine.Resources.UnloadAsset
DRCSRef.AssetBundleLoad = CS.UnityEngine.Resources.Load
DRCSRef.AssetBundleAsyncLoad = CS.UnityEngine.Resources.LoadAsync
DRCSRef.AssetBundleUnLoad = CS.AssetBundles.ResourcesEx.UnloadAssetBundle
DRCSRef.UnloadAssets = CS.AssetBundles.ResourcesEx.UnloadUnusedAssets
DRCSRef.EventTrigger = DRCSRef.EventSystems.EventTrigger
DRCSRef.EventTriggerType = DRCSRef.EventSystems.EventTriggerType
DRCSRef.PlayerPrefs = CS.UnityEngine.PlayerPrefs
DRCSRef.deltaTime = CS.UnityEngine.Time.deltaTime
DRCSRef.LogWarning = CS.UnityEngine.Debug.LogWarning
DRCSRef.NetManager = CS.NetManager.Instance
DRCSRef.BoxCollider2D = CS.UnityEngine.BoxCollider2D
DRCSRef.Camera = CS.UnityEngine.Camera
DRCSRef.VideoClip = CS.UnityEngine.Video.VideoClip
DRCSRef.NetMgr = CS.GameApp.NetMgr.Instance
DRCSRef.LogicMgr = CS.GameApp.Logic.Instance
DRCSRef.InputField = CS.UnityEngine.InputField
DRCSRef.LanguageManager = CS.GameApp.LanguageManager
DRCSRef.Color = CS.UnityEngine.Color
DRCSRef.Color32 = CS.UnityEngine.Color32
DRCSRef.GameConfig = CS.GameApp.GameConfig.Instance
DRCSRef.ResourceManager = CS.SG.ResourceManager.Instance
DRCSRef.Input_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
DRCSRef.Input = CS.UnityEngine.Input
DRCSRef.Shader = CS.UnityEngine.Shader
DRCSRef.Material = CS.UnityEngine.Material
DRCSRef.RectTransform = CS.UnityEngine.RectTransform
DRCSRef.EventSystem = CS.EventSystem
DRCSRef.EventSystem_Current = CS.EventSystem.current
DRCSRef.AspectRatioFitter = CS.UnityEngine.UI.AspectRatioFitter
DRCSRef.AspectMode = CS.UnityEngine.UI.AspectRatioFitter.AspectMode
DRCSRef.LayoutRebuilder = CS.UnityEngine.UI.LayoutRebuilder
DRCSRef.TextAsset = CS.UnityEngine.TextAsset
DRCSRef.SpineAtlasAsset = CS.Spine.Unity.SpineAtlasAsset
DRCSRef.SkeletonDataAsset = CS.Spine.Unity.SkeletonDataAsset
DRCSRef.MSDK = CS.GCloud.MSDK.MSDK
DRCSRef.MSDKLogin = CS.GCloud.MSDK.MSDKLogin
DRCSRef.MSDKNotice = CS.GCloud.MSDK.MSDKNotice
DRCSRef.SortingGroup = CS.UnityEngine.Rendering.SortingGroup
DRCSRef.MSDKGroup = CS.GCloud.MSDK.MSDKGroup
DRCSRef.MSDKCrash = CS.GCloud.MSDK.MSDKCrash
DRCSRef.CommonFunction = CS.GameApp.CommonFunction
DRCSRef.SlugManager = CS.GameApp.SlugSDK.SlugManager
DRCSRef.MSDKWebView = CS.GCloud.MSDK.MSDKWebView
DRCSRef.MSDKTools = CS.GCloud.MSDK.MSDKTools
DRCSRef.PersistentDataPath = CS.UnityEngine.Application.persistentDataPath
DRCSRef.StreamingAssetsPath = CS.UnityEngine.Application.streamingAssetsPath
DRCSRef.DHSDKManager = CS.GameApp.DHSDK.DHSDKManager
DRCSRef.HttpDns = CS.GCloud.HttpDns.HttpDnsServiceManager
DRCSRef.MSDKFriend = CS.GCloud.MSDK.MSDKFriend
DRCSRef.MSDKFriendReqInfo = CS.GCloud.MSDK.MSDKFriendReqInfo
DRCSRef.FriendReqType = CS.GCloud.MSDK.FriendReqType
DRCSRef.ScreenShot = CS.UnityEngine.ScreenCapture.CaptureScreenshot
DRCSRef.MSDKUtils = CS.GameApp.MSDKUtils
DRCSRef.ImageInfo = CS.GameApp.ImageInfo
DRCSRef.MSDKWebView = CS.GCloud.MSDK.MSDKWebView
DRCSRef.GCloudVoice = CS.GCloud.GVoice.GCloudVoice
DRCSRef.DownloadHandlerTexture = CS.UnityEngine.Networking.DownloadHandlerTexture
DRCSRef.TssSDK = CS.GCloud.TssSDK.TssSDK
--============ DOTween Animation ============--
DRCSRef.UpdateType = CS.DG.Tweening.UpdateType
DRCSRef.DOTween = CS.DG.Tweening.DOTween
DRCSRef.Ease = CS.DG.Tweening.Ease
DRCSRef.LoopType = CS.DG.Tweening.LoopType
DRCSRef.ScrambleMode = CS.DG.Tweening.ScrambleMode
DRCSRef.PathType = CS.DG.Tweening.PathType
DRCSRef.TssSDKMain = CS.GameApp.TssSDKMain  
DRCSRef.MidasMain = CS.GameApp.MidasMain.Instance
-- DRCSRef.PathMode = CS.DG.Tweening.PathMode
DRCSRef.LineEffect = CS.GameApp.LineEffect
DRCSRef.LuaBehaviour = CS.GameApp.LuaBehaviour

------- type类型-------

DRCSRef_Type = 
{
    ["AspectRatioFitter"] = typeof(CS.UnityEngine.UI.AspectRatioFitter),

    ["Sprite"] =  typeof(CS.UnityEngine.Sprite),
    ["Texture"] =  typeof(CS.UnityEngine.Texture),
    ["Material"] =  typeof(CS.UnityEngine.Material),
    ["SpriteRenderer"] =  typeof(CS.UnityEngine.SpriteRenderer),
    ["ParticleSystem"] =  typeof(CS.UnityEngine.ParticleSystem),
    ["Canvas"] =  typeof(CS.UnityEngine.Canvas),
    ["CanvasGroup"] =  typeof(CS.UnityEngine.CanvasGroup),
    ["RectTransform"] =  typeof(CS.UnityEngine.RectTransform),
    ["Transform"] =  typeof(CS.UnityEngine.Transform),
    ["Animation"] =  typeof(CS.UnityEngine.Animation),
    

    ["Text"] =  typeof(CS.UnityEngine.UI.Text),
    ["Button"] =  typeof(CS.UnityEngine.UI.Button),
    ["Toggle"] =  typeof(CS.UnityEngine.UI.Toggle),
    ["Image"] =  typeof(CS.UnityEngine.UI.Image),
    ["Scrollbar"] =  typeof(CS.UnityEngine.UI.Scrollbar),
    ["LoopVerticalScrollRect"] =  typeof(CS.UnityEngine.UI.LoopVerticalScrollRect),
    ["LoopHorizontalScrollRect"] = typeof(CS.UnityEngine.UI.LoopHorizontalScrollRect),
    ["ContentSizeFitter"] =  typeof(CS.UnityEngine.UI.ContentSizeFitter),
    ["Dropdown"] =  typeof(CS.UnityEngine.UI.Dropdown),
    ["ToggleGroup"] =  typeof(CS.UnityEngine.UI.ToggleGroup),
    ["GridLayoutGroup"] =  typeof(CS.UnityEngine.UI.GridLayoutGroup),
    ["HorizontalLayoutGroup"] =  typeof(CS.UnityEngine.UI.HorizontalLayoutGroup),
    ["LayoutElement"] =  typeof(CS.UnityEngine.UI.LayoutElement),
    ["InputField"] =  typeof(CS.UnityEngine.UI.InputField),
    ["Slider"] = typeof(CS.UnityEngine.UI.Slider),
    ["Outline"] =  typeof(CS.Outline),
    
    ["SkeletonRenderSeparator"] =  typeof(CS.Spine.Unity.Modules.SkeletonRenderSeparator),
    ["SkeletonGhost"] =  typeof(CS.Spine.Unity.Modules.SkeletonGhost),
    ["SkeletonAnimation"] =  typeof(CS.Spine.Unity.SkeletonAnimation),
    ["SkeletonRenderer"] =  typeof(CS.Spine.Unity.SkeletonRenderer),
    ["SkeletonGraphic"] =  typeof(CS.Spine.Unity.SkeletonGraphic),
    ["BoneFollower"] =  typeof(CS.Spine.Unity.BoneFollower),
   
    ["SortingGroup"] =  typeof(DRCSRef.SortingGroup),
    ["DOTweenAnimation"] =  typeof( CS.DG.Tweening.DOTweenAnimation),
    ["DOTweenPath"] =  typeof( CS.DG.Tweening.DOTweenPath),
   
    ["LineEffect"] = typeof(DRCSRef.LineEffect),

    ["Type_EmojiText"] = typeof(CS.GameApp.EmojiText),
}

ShaderProperyId_MainTex = DRCSRef.Shader.PropertyToID("_MainTex")
DRCSRef_TouchPhase_Began = CS.UnityEngine.TouchPhase.Began
DRCSRef_TouchPhase_Ended = CS.UnityEngine.TouchPhase.Ended 