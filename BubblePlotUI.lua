BubblePlotUI = class("BubblePlotUI")

function BubblePlotUI:ctor()
    self.gameObject = nil
end

function BubblePlotUI:Clear()
    self:ClearTimer()
    DRCSRef.ObjDestroy(self.gameObject)
    for k, v in pairs(self) do
        self[k] = nil
    end
end

function BubblePlotUI:ClearTimer()
    if self.mTimer then
        globalTimer:RemoveTimer(self.mTimer)
        self.mTimer = nil
    end
end

function BubblePlotUI:Init(parentObj,boneX,boneY)
    if (parentObj == nil) then
        return
    end
    if self.gameObject == nil then 
        self.gameObject = LoadPrefabAndInit("CommonUI/BubbleUI", parentObj.gameObject)
    else
        self.gameObject.transform:SetParent(parentObj.gameObject.transform)
    end
    self.gameObject.transform.localScale= DRCSRef.Vec3(0.01, 0.01, 0.01)
    self.RectTransform = self.gameObject:GetComponent("RectTransform")
    if boneX == nil then 
        if parentObj and parentObj.skeleton then 
            local bone = parentObj.skeleton:FindBone("ref_overhead")
            if bone then 
                boneX,boneY= bone.WorldX,bone.WorldY
            end
        end
    end
    self.gameObject.transform.localPosition = DRCSRef.Vec3(boneX or 0,boneY or 0)
    self.desc = self.gameObject:FindChildComponent("desc", "Text")
    self.CanvasGroup = self.gameObject:GetComponent("CanvasGroup")
    self.comCanvas = self.gameObject:GetComponent("Canvas")
    self.gameObject:SetActive(false)
end

function BubblePlotUI:AddCanvas()
    if self.gameObject == nil and self.comCanvas then 
        return
    end
    self.comCanvas = self.gameObject:AddComponent(typeof(CS.UnityEngine.Canvas))
end

function BubblePlotUI:SetPos(boneX,boneY)
    if self.gameObject == nil then 
        return
    end
    self.gameObject.transform.localPosition = DRCSRef.Vec3(boneX or 0,boneY or 0)
end
function BubblePlotUI:SetDepth(depth)
    if self.comCanvas == nil then 
        return
    end
    self.comCanvas.sortingOrder = depth
end

function BubblePlotUI:Hide()
    self:ClearTimer()
    self.gameObject:SetActive(false)
end

function BubblePlotUI:ShowDoText(bubbleStr,showtime)
    if self.CanvasGroup then
        self.CanvasGroup:DR_DOFade(1,0.5)
    end
    if self.gameObject then
        self.gameObject:SetActive(true)
    end
    if self.desc then
        self.desc.text = bubbleStr
    end
    --self.CanvasGroup.alpha = 1
    -- local dura = string.utf8len(bubbleStr) * (1 / 50)
    -- dura = dura > showtime and showtime or dura
    -- self.desc:DOText(tostring(bubbleStr), dura, true, DRCSRef.ScrambleMode.None, ""):SetEase(DRCSRef.Ease.Linear):OnComplete(function()
    -- end)

    self:ClearTimer()

    self.mTimer = globalTimer:AddTimer(showtime * 1000,function()
        if self.CanvasGroup ~= nil then 
            self.CanvasGroup:DOFade(0,0.5):OnComplete(function()
                if self.gameObject then 
                    self.gameObject:SetActive(false)
                end
            end)
        end
        self.mTimer = nil
    end)
end

return BubblePlotUI
