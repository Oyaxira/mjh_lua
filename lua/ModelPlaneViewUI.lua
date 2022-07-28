ModelPlaneViewUI = class("ModelPlaneViewUI",BaseWindow)
local NOMAL_SCALE = 30
local DISTANCE_X = 130
local DISTANCE_Y = 150
local FIRST_POS = DRCSRef.Vec2(-310, 50)

local LAYOUT_TYPE = 
{
        [1] = {
            ["Name"] =  "5 X 3",
            ["Row"] = 5,
            ["Count"] = 15,
            ["X"] = 50,
            ["Y"] = 80,
        },
        [2] = {
            ["Name"] =  "4 X 2",
            ["Row"] = 4,
            ["Count"] = 8,
            ["X"] = 100,
            ["Y"] = 160,
        }
}


-- local SORT_TYPE = 
-- {
--         [1] = {
--             ["Name"] =  "默认",
--             ["Data"] =  self._roleModelData,
          
--         },
--         [2] = {
--             ["Name"] =  "门派",
--             ["Data"] = 4,
--         }
--         [3] = {
--             ["Name"] =  "皮肤",
--             ["Data"] = 4,
--         }
-- }


function ModelPlaneViewUI:ctor()
    self.objBGPerfabs = {}
    self.iCurBGIndex = 0
    self.showName=true
end

function ModelPlaneViewUI:Init(go)
    self:InitParms()
    self:InitData()
    self:SetGameObject(go)
    self._gameObject.name="UILayerRoot"
    self.obj_OneSpineShowNode = self:FindChild(self._gameObject,"OneSpineShowNode")
    self.obj_ModelPlaneViewUI = self:FindChild(self._gameObject,"ModelPlaneViewUI")
    self.BattleField =  DRCSRef.FindGameObj("BattleField")
	self.objSpine = DRCSRef.FindGameObj("BattleField/Battle_ActorNode/ActorNode")
    

    self.obj_OneSpineShowNode.gameObject:SetActive(false)
    self.obj_ModelPlaneViewUI.gameObject:SetActive(true)
    self.objSpine.gameObject:SetActive(false)

    self.btn_return = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/btn_return","DRButton")
	self.btn_Rigt = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/btn_Rigt","DRButton")
    self.btn_Left = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/btn_Left","DRButton") 
    self.btn_Name = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/btn_Name","DRButton")
    self.pageText = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/Page","Text")
    self:InitBottom()
    self:InitButtonFunc()

end

function ModelPlaneViewUI:InitData()
    self._roleModelData = {}
    local Local_TB_RoleModel = reloadModule("Data/ResourceRoleModel")
    for _,value in pairs(Local_TB_RoleModel) do
        if value and value["ModelPath"] then
            local sModelPath = value["ModelPath"]
            self._roleModelData[#self._roleModelData + 1] = value
        end
    end
    self.MAX_PAGE = math.ceil(#self._roleModelData / LAYOUT_TYPE[self.layout]["Count"])

    self.kBGData =  ModelPreviewDataManager:GetInstance():GetBattleBG()

end


function ModelPlaneViewUI:InitBottom()
    self.btn_scale_del = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_scale/btn_scale_del","DRButton")
    self.btn_scale_text = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_scale/Text","Text")
    self.btn_scale_add = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_scale/btn_scale_add","DRButton")

    self.btn_bg_del = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_bg/btn_scale_del","DRButton")
    self.btn_bg_text = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_bg/Text","Text")
    self.btn_bg_add = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_bg/btn_scale_add","DRButton")

    self.btn_sort_del = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_sort/btn_scale_del","DRButton")
    self.btn_sort_text = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_sort/Text","Text")
    self.btn_sort_add = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_sort/btn_scale_add","DRButton")

    self.btn_layout_del = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_layout/btn_scale_del","DRButton")
    self.btn_layout_text = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_layout/Text","Text")
    self.btn_layout_add = self:FindChildComponent(self._gameObject,"ModelPlaneViewUI/obj_bottom/obj_layout/btn_scale_add","DRButton")

    self.obj_Spine = DRCSRef.FindGameObj("UIBase/UILayerRoot/SpineGraphic")

    self.obj_Layout = self:FindChild(self._gameObject,"ModelPlaneViewUI/Layout")
    self.com_gridLayout = self.obj_Layout:GetComponent("GridLayoutGroup")

    self.btn_scale_text.text = self.localScale * 100 .. "%"
    self.btn_layout_text.text = LAYOUT_TYPE[self.layout]["Name"]
    self.com_gridLayout.spacing.x =  LAYOUT_TYPE[self.layout]["X"]
    self.com_gridLayout.spacing.y =  LAYOUT_TYPE[self.layout]["Y"]
end

function ModelPlaneViewUI:InitButtonFunc()
    if	self.btn_return then
		local fun = function()
            self:Reset()
        end
        self:RemoveButtonClickListener(self.btn_return)
		self:AddButtonClickListener(self.btn_return,fun)
    end
    if	self.btn_Rigt then
		local fun = function()
            self:NextSpine()
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_Rigt)
		self:AddButtonClickListener(self.btn_Rigt,fun)
    end
    if	self.btn_Left then
		local fun = function()
            self:LastSpine()
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_Left)
		self:AddButtonClickListener(self.btn_Left,fun)
    end
 
    if	self.btn_Name then
		local fun = function()
            self:ShowAndHideName()
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_Name)
		self:AddButtonClickListener(self.btn_Name,fun)
    end

    if	self.btn_scale_del then
		local fun = function()
            self:SetScale(false)
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_scale_del)
		self:AddButtonClickListener(self.btn_scale_del,fun)
    end
    if	self.btn_scale_add then
		local fun = function()
            self:SetScale(true)
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_scale_add)
		self:AddButtonClickListener(self.btn_scale_add,fun)
    end

    if	self.btn_bg_del then
		local fun = function()
            self:SetBG(false)
        end
        self:RemoveButtonClickListener(self.btn_bg_del)
		self:AddButtonClickListener(self.btn_bg_del,fun)
    end
    if	self.btn_bg_add then
		local fun = function()
            self:SetBG(true)
        end
        self:RemoveButtonClickListener(self.btn_bg_add)
		self:AddButtonClickListener(self.btn_bg_add,fun)
    end

    if	self.btn_sort_del then
		local fun = function()
            self:SetSort(false)
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_sort_del)
		self:AddButtonClickListener(self.btn_sort_del,fun)
    end
    if	self.btn_sort_add then
		local fun = function()
            self:SetSort(true)
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_sort_add)
		self:AddButtonClickListener(self.btn_sort_add,fun)
    end

    if	self.btn_layout_del then
		local fun = function()
            self:SetLayout(false)
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_layout_del)
		self:AddButtonClickListener(self.btn_layout_del,fun)
    end
    if	self.btn_layout_add then
		local fun = function()
            self:SetLayout(true)
            self:RefreshPlane()
        end
        self:RemoveButtonClickListener(self.btn_layout_add)
		self:AddButtonClickListener(self.btn_layout_add,fun)
    end

end

function ModelPlaneViewUI:InitParms()
    self.localScale = 1
    self.bg = ""
    self.sort = ""
    self.layout = 1
    self.curPage = 1;
end

function ModelPlaneViewUI:Reset()
    self.BattleField.gameObject:SetActive(true)
    self.obj_ModelPlaneViewUI.gameObject:SetActive(false)
    self.obj_OneSpineShowNode.gameObject:SetActive(true)
    self.objSpine.gameObject:SetActive(true)
    self:InitParms()
end

function ModelPlaneViewUI:SetScale(bAdd)
    if bAdd then
        self.localScale =  self.localScale + 0.1
    else
        self.localScale = self.localScale - 0.1
    end
    self.btn_scale_text.text = self.localScale * 100 .. "%"
end

function ModelPlaneViewUI:SetBG(bAdd)
    local temp = self.iCurBGIndex
    if bAdd then
        self.modelPreviewUI:OnClickRightBGButton()
    else
        self.modelPreviewUI:OnClickLeftBGButton()
    end

    self.btn_bg_text.text = self.modelPreviewUI.textBGName.text
    self.btn_bg_add.gameObject:SetActive(self.modelPreviewUI.iCurBGIndex ~= #self.modelPreviewUI.kBGData)
    self.btn_bg_del.gameObject:SetActive(self.modelPreviewUI.iCurBGIndex ~= 1)
end

function ModelPlaneViewUI:SetSort(bAdd)
end

function ModelPlaneViewUI:SetLayout(bAdd)
    if bAdd then
        self.layout = self.layout + 1 
    else
        self.layout = self.layout - 1
        if self.layout==0 then
            self.layout=#LAYOUT_TYPE
        end
    end

    self.layout = math.fmod(self.layout - 1, #LAYOUT_TYPE) + 1
    self.btn_layout_text.text = LAYOUT_TYPE[self.layout]["Name"]
    self.MAX_PAGE = #self._roleModelData / LAYOUT_TYPE[self.layout]["Count"]
    self.com_gridLayout:SetSpacing(LAYOUT_TYPE[self.layout]["X"],LAYOUT_TYPE[self.layout]["Y"])

end

function ModelPlaneViewUI:SetData(modelPreviewUI)
    self.modelPreviewUI = modelPreviewUI
end

function ModelPlaneViewUI:RefreshUI()
    self:RefreshPlane()
end

function ModelPlaneViewUI:NextSpine()
    self.curPage = self.curPage + 1
    if self.curPage>self.MAX_PAGE then self.curPage=1 end

    --self.curPage = math.fmod(self.curPage, self.MAX_PAGE)
end

function ModelPlaneViewUI:LastSpine()
    self.curPage = self.curPage - 1
    if self.curPage < 1 then
        --self.curPage=1
        self.curPage = self.MAX_PAGE
    end
end

function ModelPlaneViewUI:ShowAndHideName()
    self.showName=not self.showName
end

function ModelPlaneViewUI:RefreshPlane()
    self:RemoveSpineGraphic()
    self.com_gridLayout.constraintCount =  LAYOUT_TYPE[self.layout]["Row"]
    self.Count = LAYOUT_TYPE[self.layout]["Count"]
    self.BattleField.gameObject:SetActive(false)

    self.pageText.text=math.floor(self.curPage).."/"..self.MAX_PAGE

    for index = 1, self.Count do
        local item = CloneObj(self.obj_Spine,self.obj_Layout)

        local overHead = self:FindChild(item.gameObject,"ObjGraphic/BoneFollower/Battle_LifeBar/Normal_LifeBar")
        local nameText = self:FindChildComponent(item.gameObject,"ObjGraphic/BoneFollower/Battle_LifeBar/Normal_LifeBar/Name_Text","Text")
        local followBone=self:FindChildComponent(item.gameObject,"ObjGraphic/BoneFollower","BoneFollowerGraphic")
        
        local curIndex = index + (self.curPage - 1) *  LAYOUT_TYPE[self.layout]["Count"]
        if curIndex > #self._roleModelData then
            return
        end
        local tb_roleModel = self._roleModelData[curIndex]
        if tb_roleModel==nil then return end
        local modelPath = tb_roleModel.ModelPath

        if self.showName then
            overHead:SetActive(true)

            local splitPath=string.split(tb_roleModel.Texture,"/")
            if nameText and tb_roleModel.Texture then
                for index, value in pairs(splitPath) do
                    -- 只取路径名最后一段
                    nameText.text = value
                end
                --nameText.text = tb_roleModel.Texture
            end
        else 
            
            overHead:SetActive(false)
        end
        nameText.text=string.gsub(nameText.text,"role_","",1);
        local skeletonGraphic = self:FindChild(item.gameObject,"ObjGraphic")
        if skeletonGraphic then
            DynamicChangeSpine(skeletonGraphic,modelPath)
            ChnageSpineSkin_Graphic(skeletonGraphic,tb_roleModel.Texture)
        end
        self:SetSpineScale(tb_roleModel, item)

        --需要放到后面更新，头部name的跟随，确保跟随的骨骼是最新的
        followBone:SetBone("ref_overhead")

    end
    self.btn_bg_text.text = self.modelPreviewUI.textBGName.text
end

function ModelPlaneViewUI:RemoveSpineGraphic()
    RemoveAllChildren(self.obj_Layout)
end

function ModelPlaneViewUI:SetSpineScale(tb_roleModel, obj_Spine)
    local scale_X = 1
    local scale_Y = 1
    if tb_roleModel and tb_roleModel.RoleScale then
        scale_X = scale_X * tb_roleModel.RoleScale.X / 100
        scale_Y = scale_Y * tb_roleModel.RoleScale.Y / 100
    end

    obj_Spine:SetObjLocalScale(1 * scale_X * self.localScale , 1 * scale_Y * self.localScale ,1)

end



return ModelPlaneViewUI