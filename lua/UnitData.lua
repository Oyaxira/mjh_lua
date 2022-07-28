UnitData = class("UnitData")

function UnitData:ctor()
    self.iGridX = 0
    self.iGridY = 0
    self.iOldGridX = 0
    self.iOldGridY = 0
    self.iUID = 0  --角色唯一ID
    self.iUnitIndex = 0 --逻辑ID
    self.uiRoleTypeID = 0  --role表baseid
    self.uiModleID = 1  --roleModel表baseid
    self.fMoveTime = 0 --速度为*10000显示后的值
    self.fOptNeedTime = 0 --下次操作需要时间 *10000后的值
    self.iMoveDistance = 3
    self.iFace = -1 --只有 -1 1 -1向左，1向右
    self.iCamp = -1 --se_campa se_campb
    self.iHP = 1
    self.iMP = 1
    self.iMAXHP = 1
    self.iMAXMP = 1
    self.sName = ""
end