ItemDispositionUI = class("ItemDispositionUI", BaseWindow)



function ItemDispositionUI:Create(kParent)
	local obj = LoadPrefabAndInit("Module/Disposition",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ItemDispositionUI:Init()
    self.textName = self:FindChildComponent(self._gameObject, "layout/title_box/Name", "Text")
    self.textDisp = self:FindChildComponent(self._gameObject, "layout/title_box/Value", "Text")
    self.textDesc = self:FindChildComponent(self._gameObject, "layout/Desc", "Text")
    self.imgImage = self:FindChildComponent(self._gameObject, "Head/Head_Dispositions/head", "Image");
    self.objCreateFaceParent = self:FindChild(self._gameObject, "Head/Head_Dispositions/CreateHead")
end

function ItemDispositionUI:UpdateDisposition(kDispositionData)
    self.textName.text = RoleDataManager:GetInstance():GetRoleName(kDispositionData.dstRoleID)
    local default_des = RoleDataHelper.GetDispositionDesByValue(kDispositionData.iValue)
    self.textDesc.text = GetLanguagePreset(kDispositionData.DescID, default_des)
    self.textDisp.text = string.format("%0.f", kDispositionData.iValue)
    -- TODO 捏脸21 头像 kDispositionData.dstRoleID
    local iRoleTypeID = kDispositionData.dstRoleID
    local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID() -- 剧本ID(酒馆0)

    local iMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
    local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
    if iRoleTypeID == iMainRoleTypeID then 
        iRoleTypeID = iMainRoleCreateRoleID
    end

    -- 判断有无捏脸数据
    if iRoleTypeID == iMainRoleCreateRoleID and CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeID)then
        if self.objCreateFace then
            self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeID, self.objCreateFaceParent, self.objCreateFace)
            self.objCreateFace:SetActive(true)
        else
            self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeID, self.objCreateFaceParent)
        end
        self.imgImage.gameObject:SetActive(false)
    else
        if self.objCreateFace then
            self.objCreateFace:SetActive(false)
        end
        self.imgImage.gameObject:SetActive(true)
        local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(kDispositionData.dstRoleID)
        if artData then
            if IsValidObj(self.imgImage) then
                self.imgImage.sprite = GetSprite(artData.Head)
            end
        end
    end
end

return ItemDispositionUI