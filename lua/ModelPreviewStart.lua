require("Base/LuaPanda/LuaPanda")
require "Base/Functions"
require "RequireLoad"

LuaPanda.start("127.0.0.1",8818)

local modelPreviewUI

function start()
    dprint("[Main]->Game  start")
end

function awake()
    reloadGameModules()
    reloadModule("UI/ModelPreview/ModelPreviewUI")
    reloadModule("UI/ModelPreview/ModelPreviewDataManager")
    reloadModule("UI/ModelPreview/ModelPlaneViewUI")
    --reloadModule("UI/ModelPreview/IconPreviewUI")
    dprint("Model Preview Start")

    modelPreviewUI = ModelPreviewUI.new()
    modelPreviewUI:Init(DRCSRef.FindGameObj("UILayerRoot"))
    modelPreviewUI:RefreshUI(1)
    modelPreviewUI:RefreshScale()
end
 
function update(deltaTime)
    modelPreviewUI:Update(deltaTime)
end

function lateUpdate()
   
end

function ondestroy()
    modelPreviewUI:Close()
end
