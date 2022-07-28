AdvlootRayCheck = class("AdvlootRayCheck", BaseWindow)

local DISTANCE = 0.05

local TouchPhase = 
{
    Began = 0,
    Moved = 1,
    Stationary = 2,
    Ended = 3,
    Canceled = 4,
}

function AdvlootRayCheck:ctor()

end

function AdvlootRayCheck:Create()
    local obj = LoadPrefabAndInit("Game/lineRender", Scence_Layer, true)
	if obj then
		self:SetGameObject(obj)
    end
end


function AdvlootRayCheck:Init()
    self.comLineRenderer = self._gameObject:GetComponent("LineRenderer")
    -- 设置材质
    self.comLineRenderer.material = LoadPrefab("Materials/UI_LinerRender",typeof(CS.UnityEngine.Material))
    -- 设置颜色
    --self.comLineRenderer:SetColors(Color.red, Color.yellow);
    -- 设置宽度
    self.comLineRenderer.startWidth = 0.1
    self.comLineRenderer.endWidth = 0.3

    --SetWidth(0.1, 0.1);s
    self.iUpdateCheck = false
    self.Length = 0
    self.firstPosition = DRCSRef.Vec3Zero
    self.sercondPosition = DRCSRef.Vec3Zero
    self.isMove = false

    self.bFirstMouseDown = false
    self.bMouseDown = false

    self.positionCount = 0
    self.lastPosition = DRCSRef.Vec3Zero
    self.mouseTrackPositions = {}
    self.iUpdateCheck = false

    self.startDraw = false
end

function AdvlootRayCheck:StartCheck()
    self.iUpdateCheck = true
end

function AdvlootRayCheck:StopCheck()
    self.iUpdateCheck = false
end


function AdvlootRayCheck:OnDestroy()
    
end
function AdvlootRayCheck:OnDestroy()
    
end

function AdvlootRayCheck:Update(deltaTime)

    -- if ((not g_IS_WINDOWS) and DRCSRef.Input.touchCount > 0 and DRCSRef.Input.GetTouch(0).phase == CS.UnityEngine.TouchPhase.Began) then
    --     -- DRCSRef.Log("当前触摸在UI上");
    --     return;
    -- else
    --     -- DRCSRef.Log("当前没有触摸在UI上");
    -- end

    -- 点击
    if (g_IS_WINDOWS and CS.UnityEngine.Input:GetMouseButtonDown(0))
        or ((not g_IS_WINDOWS) and (DRCSRef.Input.touchCount > 0)) then
            self.bFirstMouseDown = true
            self.bMouseDown = true
            self:StartCheck()
            self.startDraw = true
    end

    -- 抬起
    if  (g_IS_WINDOWS and CS.UnityEngine.Input:GetMouseButtonUp(0)) or ((not g_IS_WINDOWS) and DRCSRef.Input.touchCount > 0 and DRCSRef.Input:GetTouch(0).phase == TouchPhase.Ended)
    then 
        self.bMouseDown = false
        self.startDraw = false
        self:OnDrawLine()
    end

    if self.startDraw then
        self:OnDrawLine()
    end
    self.bFirstMouseDown = false
end

function AdvlootRayCheck:OnDrawLine()
    if self.bFirstMouseDown then
        self.positionCount = 0
        self.firstPosition =  self:GetTouchPos2WorldPos()
        self.lastPosition  = self.firstPosition
    end

    if self.bMouseDown then
        self.firstPosition = self:GetTouchPos2WorldPos()
        if DRCSRef.Vec3.Distance(self.firstPosition, self.lastPosition) > DISTANCE then
            self:SavePosition(self.firstPosition)
            self.positionCount = self.positionCount + 1
        end
        self.lastPosition = self.firstPosition
    else
        self.mouseTrackPositions = {}
        self:StopCheck()
    end
    
    self:SetLineRendererPosition()
end

function AdvlootRayCheck:SavePosition(pos)
    if self.positionCount <= 9 then
        for i = self.positionCount, 10 do
            self.mouseTrackPositions[i] = pos
        end
    else
        for i = 0, 9 do
            self.mouseTrackPositions[i] = self.mouseTrackPositions[i + 1]
        end
        self.mouseTrackPositions[10] = pos
    end
end

function AdvlootRayCheck:SetLineRendererPosition()
    
    -- self.comLineRenderer.positionCount = (#self.mouseTrackPositions + 1)
    -- for index = 0, #self.mouseTrackPositions do
    --     if  self.mouseTrackPositions[index] ~= nil then
    --         self.comLineRenderer:SetPosition(index,self.mouseTrackPositions[index])
    --     end
    -- end

    if self.iUpdateCheck then
        self:RayCheck()
    end
end

function AdvlootRayCheck:GetTouchPos2WorldPos()
    local pos
    pos = GetTouchUIPos()

    -- if  g_IS_WINDOWS then
    --     pos = DRCSRef.Input.mousePosition
    -- else
    --     if DRCSRef.Input.touchCount > 0 then
    --         pos = GetTouchUIPos()
    --         --pos = DRCSRef.Input:GetTouch(0).position
    --     end
    -- end
    if pos == nil then
        return DRCSRef.Vec3Zero
    end
    return DRCSRef.Vec3(pos.x,pos.y,16);
    --return UI_Camera:ScreenToWorldPoint(DRCSRef.Vec3(pos.x, pos.y, 1));
end

function AdvlootRayCheck:RayCheck()
    self._gameObject:Raycast(UI_Camera,1)
end

return AdvlootRayCheck