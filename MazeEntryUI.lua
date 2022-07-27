MazeEntryUI = class('MazeEntryUI', BaseWindow)

local MOVE_TIME = 200

function MazeEntryUI:Create()
    local obj = LoadPrefabAndInit("Game/MazeEntryUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function MazeEntryUI:OnPressESCKey()
    if self.close_btn then
        self.close_btn.onClick:Invoke()
    end
end

function MazeEntryUI:Init()
    self.confirm_btn = self:FindChildComponent(self._gameObject, "Button_submit", DRCSRef_Type.Button)
    self.close_btn = self:FindChildComponent(self._gameObject, "Btn_exit", DRCSRef_Type.Button)
    self.name = self:FindChildComponent(self._gameObject, "name", "Text")
    self.bg = self:FindChildComponent(self._gameObject, "bg", "Image")
    self.cost = self:FindChildComponent(self._gameObject, "costText", "Text")
    self.level = self:FindChildComponent(self._gameObject, "levelText", "Text")
    self.drop = self:FindChild(self._gameObject, "Content")

    self.map = GetUIWindow('TileBigMap')
    if self.confirm_btn then
        self:AddButtonClickListener(self.confirm_btn,function()
            SendEnterMaze(self.mazeID)
            if self.map then
                MyDOTween(self.map._gameObject.transform,'DOScale',DRCSRef.Vec3(1.3, 1.3, 1),0.35)
				OpenWindowImmediately("BigMapCloudAnimUI", true)
            end
            RemoveWindowImmediately("MazeEntryUI",false)
		end)
    end

    if self.close_btn then
        self:AddButtonClickListener(self.close_btn,function()
            RemoveWindowImmediately("MazeEntryUI",false)
		end)        
    end

    --数据
    self.mazeID = nil
    self.objList = {}
end

function MazeEntryUI:RefreshUI(info)
    self.mazeID = info
    local mazeData = TableDataManager:GetInstance():GetTableData("Maze", tonumber(self.mazeID))
    local mazeArtData = MazeDataManager:GetInstance():GetMazeArtDataByTypeID(self.mazeID)
    if mazeData and mazeArtData then
        self.data = mazeData
        self.name.text = GetLanguageByID(mazeData.Name)
        if mazeData.CostTime ~= nil and mazeData.CostTime ~= 0 then
            self.cost.text = mazeData.CostTime.."日"
        else
            self.cost.text = "无耗时"
        end
        self.bg.sprite = GetSprite(mazeArtData.BGImg)
        local levels = mazeData.AdviceLevel
        local dropList = mazeData.Drop
        if levels and #levels > 0 then
            local str = ""
            for i=1,#levels do
                str = str..levels[i]
                if i < #levels then
                    str = str.."、"
                end
            end
            self.level.text = str
        end
        if dropList and #dropList > 0 then
            for i=1, #dropList do
                local tempItemData = TableDataManager:GetInstance():GetTableData("Item",dropList[i])
                local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,self.drop.transform)
                kItem:UpdateUIWithItemTypeData(tempItemData)
                table.insert(self.objList, kItem)
            end
        end
    end
end

function MazeEntryUI:OnEnable()
    if self.map and not self.map.wait_event then
        self.map.wait_event = 0
    end
end

function MazeEntryUI:OnDisable()
    if self.map and self.map.wait_event == 0 then
        self.map.wait_event = nil
    end
end

function MazeEntryUI:OnDestroy()
    self.objList ={}
end

return MazeEntryUI