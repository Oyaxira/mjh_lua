-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum SkillEffectDescription
require("common");


local SkillEffect= {
  [451402014]={BaseID=451402014,Name=SkillEffectDescription.SED_SkillCondition_SelfSameMaritalSkill,},
  [451402015]={BaseID=451402015,Name=SkillEffectDescription.SED_SkillLogic_ZuiZhongZhiLiaoJiaChengQunTi,EventArg1={0,451402016,},EventArg2={0,451402017,},},
  [451402016]={BaseID=451402016,Name=SkillEffectDescription.SED_Battle_GetEventEffectiveTarget,},
  [451402017]={BaseID=451402017,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={10000000,0,},EventArg3={0,451402018,},},
  [451402018]={BaseID=451402018,Name=SkillEffectDescription.SED_Role_MartialLv_Index,EventArg1={0,451402019,},EventArg2={0,451402020,},},
  [451402019]={BaseID=451402019,},
  [451402020]={BaseID=451402020,Name=SkillEffectDescription.SED_System_GetCurrentEffectMartial,},
  [451403001]={BaseID=451403001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451403002]={BaseID=451403002,Name=SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill,EventArg1={451403003,0,},},
  [451403003]={BaseID=451403003,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451403004,},},
  [451403004]={BaseID=451403004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451403005,},EventArg2={0,451403006,},EventArg3={0,451403016,},},
  [451403005]={BaseID=451403005,Name=SkillEffectDescription.SED_SkillEffect_PlaySpecialEffect,},
  [451403006]={BaseID=451403006,Name=SkillEffectDescription.SED_SkillEffect_ModifyShield,EventArg1={0,451403007,},EventArg2={0,451403008,},},
  [451403007]={BaseID=451403007,},
  [451403008]={BaseID=451403008,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={1,0,},EventArg2={0,451403009,},EventArg3={0,451403013,},},
  [451403009]={BaseID=451403009,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403010,},EventArg3={5000000,0,},},
  [451403010]={BaseID=451403010,Name=SkillEffectDescription.SED_Role_MartialLv_Index,EventArg1={0,451403011,},EventArg2={0,451403012,},},
  [451403011]={BaseID=451403011,},
  [451403012]={BaseID=451403012,Name=SkillEffectDescription.SED_System_GetCurrentEffectMartial,},
  [451403013]={BaseID=451403013,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403014,},EventArg3={500,0,},},
  [451403014]={BaseID=451403014,Name=SkillEffectDescription.SED_Role_GetRoleMaxAttr,EventArg1={0,451403015,},EventArg2={18,0,},},
  [451403015]={BaseID=451403015,},
  [451403016]={BaseID=451403016,Name=SkillEffectDescription.SED_Battle_AddZhenQi,EventArg1={0,451403017,},EventArg2={0,451403018,},},
  [451403017]={BaseID=451403017,},
  [451403018]={BaseID=451403018,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403019,},EventArg3={-10000,0,},},
  [451403019]={BaseID=451403019,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={1,0,},EventArg2={0,451403020,},EventArg3={0,451403024,},},
  [451403020]={BaseID=451403020,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403021,},EventArg3={5000000,0,},},
  [451403021]={BaseID=451403021,Name=SkillEffectDescription.SED_Role_MartialLv_Index,EventArg1={0,451403022,},EventArg2={0,451403023,},},
  [451403022]={BaseID=451403022,},
  [451403023]={BaseID=451403023,Name=SkillEffectDescription.SED_System_GetCurrentEffectMartial,},
  [451403024]={BaseID=451403024,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403025,},EventArg3={500,0,},},
  [451403025]={BaseID=451403025,Name=SkillEffectDescription.SED_Role_GetRoleMaxAttr,EventArg1={0,451403026,},EventArg2={18,0,},},
  [451403026]={BaseID=451403026,},
  [451403027]={BaseID=451403027,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,451403028,},},
  [451403028]={BaseID=451403028,Name=SkillEffectDescription.SED_Null,EventArg1={0,451403029,},EventArg2={0,451403032,},},
  [451403029]={BaseID=451403029,Name=SkillEffectDescription.SED_LogicOperation_Equal,EventArg1={2,0,},EventArg2={0,451403030,},EventArg3={0,451403031,},},
  [451403030]={BaseID=451403030,},
  [451403031]={BaseID=451403031,Name=SkillEffectDescription.SED_Battle_CurrentRoundMoveRole,},
  [451403032]={BaseID=451403032,Name=SkillEffectDescription.SED_LogicOperation_DataCompare,EventArg1={3,0,},EventArg2={0,451403033,},EventArg3={0,451403035,},},
  [451403033]={BaseID=451403033,Name=SkillEffectDescription.SED_Role_GetCurrentRoleAttr,EventArg1={0,451403034,},EventArg2={107,0,},},
  [451403034]={BaseID=451403034,},
  [451403035]={BaseID=451403035,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={1,0,},EventArg2={0,451403036,},EventArg3={0,451403044,},},
  [451403036]={BaseID=451403036,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={1,0,},EventArg2={0,451403037,},EventArg3={0,451403041,},},
  [451403037]={BaseID=451403037,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403038,},EventArg3={5000000,0,},},
  [451403038]={BaseID=451403038,Name=SkillEffectDescription.SED_Role_MartialLv_Index,EventArg1={0,451403039,},EventArg2={0,451403040,},},
  [451403039]={BaseID=451403039,},
  [451403040]={BaseID=451403040,Name=SkillEffectDescription.SED_System_GetCurrentEffectMartial,},
  [451403041]={BaseID=451403041,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451403042,},EventArg3={500,0,},},
  [451403042]={BaseID=451403042,Name=SkillEffectDescription.SED_Role_GetRoleMaxAttr,EventArg1={0,451403043,},EventArg2={18,0,},},
  [451403043]={BaseID=451403043,},
  [451403044]={BaseID=451403044,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={1,0,},EventArg2={0,451403045,},EventArg3={0,451403046,},},
  [451403045]={BaseID=451403045,Name=SkillEffectDescription.SED_Data_GetDataAttr_Kungfubase,EventArg1={348,0,},EventArg2={0,0,},EventArg3={0,0,},EventArg4={0,0,},EventArg5={6,0,},},
  [451403046]={BaseID=451403046,Name=SkillEffectDescription.SED_Data_GetDataAttr_Kungfubase,EventArg1={348,0,},EventArg2={0,0,},EventArg3={0,0,},EventArg4={1,0,},EventArg5={6,0,},},
  [451403047]={BaseID=451403047,Name=SkillEffectDescription.SED_Martial_LockMartial,EventArg1={0,451403048,},EventArg2={10308,0,},},
  [451403048]={BaseID=451403048,},
  [451403049]={BaseID=451403049,Name=SkillEffectDescription.SED_LogicOperation_Equal,EventArg1={2,0,},EventArg2={0,451403050,},EventArg3={0,451403051,},},
  [451403050]={BaseID=451403050,},
  [451403051]={BaseID=451403051,Name=SkillEffectDescription.SED_Battle_CurrentRoundMoveRole,},
  [451403052]={BaseID=451403052,Name=SkillEffectDescription.SED_Martial_UnblockMartial,EventArg1={0,451403053,},EventArg2={10308,0,},},
  [451403053]={BaseID=451403053,},
  [451404001]={BaseID=451404001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451404002]={BaseID=451404002,Name=SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill,EventArg1={451404003,0,},},
  [451404003]={BaseID=451404003,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451404004,},},
  [451404004]={BaseID=451404004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451404005,},EventArg2={0,451404007,},EventArg3={0,451404009,},EventArg4={0,451404010,},},
  [451404005]={BaseID=451404005,Name=SkillEffectDescription.SED_SkillEffect_CountSkillRangeRole,EventArg1={0,451404006,},},
  [451404006]={BaseID=451404006,Name=SkillEffectDescription.SED_System_GetCurrentEffectSkill,},
  [451404007]={BaseID=451404007,Name=SkillEffectDescription.SED_SkillEffect_FilterFriend,EventArg1={0,451404008,},},
  [451404008]={BaseID=451404008,},
  [451404009]={BaseID=451404009,Name=SkillEffectDescription.SED_SkillEffect_LifeSort,},
  [451404010]={BaseID=451404010,Name=SkillEffectDescription.SED_SkillEffect_CureGroup,EventArg1={0,451404011,},EventArg2={0,451404012,},EventArg3={0,0,},EventArg4={0,0,},EventArg5={7150,0,},},
  [451404011]={BaseID=451404011,},
  [451404012]={BaseID=451404012,Name=SkillEffectDescription.SED_Battle_GetCurrentEventEffectiveTarget,},
  [451404013]={BaseID=451404013,Name=SkillEffectDescription.SED_SkillCondition_SelfSameMaritalSkill,},
  [451404014]={BaseID=451404014,Name=SkillEffectDescription.SED_ji4neng2xiao4guo3_zui4zhong1zhi4liao2jia1cheng2chan2ti3,EventArg1={0,451404015,},EventArg2={0,451404016,},},
  [451404015]={BaseID=451404015,Name=SkillEffectDescription.SED_GetCurrentEventParameter,EventArg1={20000,0,},},
  [451404016]={BaseID=451404016,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={5000000,0,},EventArg3={0,451404017,},},
  [451404017]={BaseID=451404017,Name=SkillEffectDescription.SED_Role_MartialLv_Index,EventArg1={0,451404018,},EventArg2={0,451404019,},},
  [451404018]={BaseID=451404018,},
  [451404019]={BaseID=451404019,Name=SkillEffectDescription.SED_System_GetCurrentEffectMartial,},
  [451503001]={BaseID=451503001,Name=SkillEffectDescription.SED_SkillCondition_SelfISAttacked,},
  [451503002]={BaseID=451503002,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451503003,},},
  [451503003]={BaseID=451503003,Name=SkillEffectDescription.SED_Null,EventArg1={0,451503004,},EventArg2={0,451503007,},},
  [451503004]={BaseID=451503004,Name=SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill,EventArg1={451503005,0,},},
  [451503005]={BaseID=451503005,Name=SkillEffectDescription.SED_SkillEffect_AddBuffSingle,EventArg1={0,451503006,},EventArg2={654,0,},EventArg3={10000,0,},},
  [451503006]={BaseID=451503006,},
  [451503007]={BaseID=451503007,Name=SkillEffectDescription.SED_SkillEffect_PlaySpecialEffect,},
  [451505001]={BaseID=451505001,Name=SkillEffectDescription.SED_SkillCondition_SelfISAttacked,},
  [451505002]={BaseID=451505002,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451505003,},},
  [451505003]={BaseID=451505003,Name=SkillEffectDescription.SED_Null,EventArg1={0,451505004,},EventArg2={0,451505007,},},
  [451505004]={BaseID=451505004,Name=SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill,EventArg1={451505005,0,},},
  [451505005]={BaseID=451505005,Name=SkillEffectDescription.SED_SkillEffect_AddBuffSingle,EventArg1={0,451505006,},EventArg2={654,0,},EventArg3={10000,0,},},
  [451505006]={BaseID=451505006,},
  [451505007]={BaseID=451505007,Name=SkillEffectDescription.SED_SkillEffect_PlaySpecialEffect,},
  [451508001]={BaseID=451508001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451508002]={BaseID=451508002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={5000,0,},},
  [451509001]={BaseID=451509001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451509002]={BaseID=451509002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={3750,0,},},
  [451509003]={BaseID=451509003,Name=SkillEffectDescription.SED_SkillCondition_SelfSameSkill,},
  [451509004]={BaseID=451509004,Name=SkillEffectDescription.SED_SkillEffect_AddBuffSingle,EventArg1={0,451509005,},EventArg2={100,0,},EventArg3={20000,0,},},
  [451509005]={BaseID=451509005,},
  [451510001]={BaseID=451510001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451510002]={BaseID=451510002,Name=SkillEffectDescription.SED_SkillLogic_MultisegmentAttackSkill,EventArg1={0,0,},EventArg2={3750,0,},EventArg3={30000,0,},},
  [451510003]={BaseID=451510003,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,451510004,},},
  [451510004]={BaseID=451510004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451510005,},EventArg2={0,451510006,},},
  [451510005]={BaseID=451510005,Name=SkillEffectDescription.SED_SkillCondition_SelfSameMaritalSkill,},
  [451510006]={BaseID=451510006,Name=SkillEffectDescription.SED_Role_OwnBuff,EventArg1={0,451510007,},EventArg2={109,0,},},
  [451510007]={BaseID=451510007,},
  [451510008]={BaseID=451510008,Name=SkillEffectDescription.SED_SkillEffect_MartialExtraPower,EventArg1={0,0,},EventArg2={2000,0,},},
  [451511001]={BaseID=451511001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451511002]={BaseID=451511002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={6000,0,},},
  [451512001]={BaseID=451512001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451512002]={BaseID=451512002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={7500,0,},},
  [451512003]={BaseID=451512003,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,451512004,},},
  [451512004]={BaseID=451512004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451512005,},EventArg2={0,451512006,},},
  [451512005]={BaseID=451512005,Name=SkillEffectDescription.SED_SkillCondition_SelfSameSkill,},
  [451512006]={BaseID=451512006,Name=SkillEffectDescription.SED_Condition_Ture,EventArg1={5000,0,},},
  [451512007]={BaseID=451512007,Name=SkillEffectDescription.SED_SkillEffect_AddBuffGroup,EventArg1={0,451512008,},EventArg2={139,0,},EventArg3={50000,0,},},
  [451512008]={BaseID=451512008,Name=SkillEffectDescription.SED_Battle_GetEventEffectiveTarget,},
  [451513001]={BaseID=451513001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451513002]={BaseID=451513002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={9000,0,},},
  [451513003]={BaseID=451513003,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,451513004,},},
  [451513004]={BaseID=451513004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451513005,},EventArg2={0,451513006,},},
  [451513005]={BaseID=451513005,Name=SkillEffectDescription.SED_SkillCondition_SelfSameSkill,},
  [451513006]={BaseID=451513006,Name=SkillEffectDescription.SED_Condition_Ture,EventArg1={2000,0,},},
  [451513007]={BaseID=451513007,Name=SkillEffectDescription.SED_SkillEffect_AddBuffGroup,EventArg1={0,451513008,},EventArg2={137,0,},EventArg3={200000,0,},},
  [451513008]={BaseID=451513008,Name=SkillEffectDescription.SED_Battle_GetEventEffectiveTarget,},
  [451601001]={BaseID=451601001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451601002]={BaseID=451601002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={4200,0,},},
  [451602001]={BaseID=451602001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451602002]={BaseID=451602002,Name=SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill,EventArg1={451602003,0,},},
  [451602003]={BaseID=451602003,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451602004,},},
  [451602004]={BaseID=451602004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451602005,},EventArg2={0,451602007,},EventArg3={0,451602009,},EventArg4={0,451602010,},EventArg5={0,451602011,},},
  [451602005]={BaseID=451602005,Name=SkillEffectDescription.SED_SkillEffect_CountSkillRangeRole,EventArg1={0,451602006,},},
  [451602006]={BaseID=451602006,Name=SkillEffectDescription.SED_System_GetCurrentEffectSkill,},
  [451602007]={BaseID=451602007,Name=SkillEffectDescription.SED_SkillEffect_FilterFriend,EventArg1={0,451602008,},},
  [451602008]={BaseID=451602008,},
  [451602009]={BaseID=451602009,Name=SkillEffectDescription.SED_SkillEffect_LifeSort,},
  [451602010]={BaseID=451602010,Name=SkillEffectDescription.SED_SkillEffect_PlaySpecialEffect,},
  [451602011]={BaseID=451602011,Name=SkillEffectDescription.SED_SkillEffect_AddBuffGroup,EventArg1={0,451602012,},EventArg2={553,0,},EventArg3={10000,0,},},
  [451602012]={BaseID=451602012,Name=SkillEffectDescription.SED_Battle_GetCurrentEventEffectiveTarget,},
  [451603001]={BaseID=451603001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451603002]={BaseID=451603002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={3750,0,},},
  [451604001]={BaseID=451604001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451604002]={BaseID=451604002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={7000,0,},},
  [451605001]={BaseID=451605001,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,451605002,},},
  [451605002]={BaseID=451605002,Name=SkillEffectDescription.SED_Null,EventArg1={0,451605003,},EventArg2={0,451605005,},EventArg3={0,451605006,},},
  [451605003]={BaseID=451605003,Name=SkillEffectDescription.SED_Logic_DataPrototypeEqual,EventArg1={2,0,},EventArg2={0,451605004,},EventArg3={11909,0,},},
  [451605004]={BaseID=451605004,Name=SkillEffectDescription.SED_System_GetsourceEffectMartial,},
  [451605005]={BaseID=451605005,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451605006]={BaseID=451605006,Name=SkillEffectDescription.SED_SkillCondition_Self,},
  [451605007]={BaseID=451605007,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451605008,},},
  [451605008]={BaseID=451605008,Name=SkillEffectDescription.SED_Null,EventArg1={0,451605009,},EventArg2={0,451605017,},EventArg3={0,451605018,},},
  [451605009]={BaseID=451605009,Name=SkillEffectDescription.SED_Battle_SetTargetList,EventArg1={0,451605010,},},
  [451605010]={BaseID=451605010,Name=SkillEffectDescription.SED_zhan1dou_huo1qu2zhi3ding4fan1wei2wo3fang,EventArg1={0,451605011,},EventArg2={0,451605012,},EventArg3={0,451605013,},EventArg4={0,451605015,},},
  [451605011]={BaseID=451605011,},
  [451605012]={BaseID=451605012,Name=SkillEffectDescription.SED_Data_GetDataAttr,EventArg1={4,0,},EventArg2={31,0,},EventArg3={5,0,},},
  [451605013]={BaseID=451605013,Name=SkillEffectDescription.SED_Data_GetDataAttr,EventArg1={3,0,},EventArg2={29,0,},EventArg3={0,451605014,},},
  [451605014]={BaseID=451605014,},
  [451605015]={BaseID=451605015,Name=SkillEffectDescription.SED_Data_GetDataAttr,EventArg1={3,0,},EventArg2={30,0,},EventArg3={0,451605016,},},
  [451605016]={BaseID=451605016,},
  [451605017]={BaseID=451605017,Name=SkillEffectDescription.SED_SkillEffect_LifeSort,},
  [451605018]={BaseID=451605018,Name=SkillEffectDescription.SED_SkillEffect_AddBuffGroup,EventArg1={0,451605019,},EventArg2={573,0,},EventArg3={10000,0,},},
  [451605019]={BaseID=451605019,Name=SkillEffectDescription.SED_Battle_GetCurrentEventEffectiveTarget,},
  [451701001]={BaseID=451701001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451701002]={BaseID=451701002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={3500,0,},},
  [451702001]={BaseID=451702001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451702002]={BaseID=451702002,Name=SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill,EventArg1={451702003,0,},},
  [451702003]={BaseID=451702003,Name=SkillEffectDescription.SED_LogicOperation_ActionList,EventArg1={0,451702004,},},
  [451702004]={BaseID=451702004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451702005,},EventArg2={0,451702008,},EventArg3={0,451702010,},EventArg4={0,451702011,},EventArg5={0,451702013,},},
  [451702005]={BaseID=451702005,Name=SkillEffectDescription.SED_SkillEffect_SelfRangeTarget,EventArg1={0,451702006,},EventArg2={0,451702007,},},
  [451702006]={BaseID=451702006,},
  [451702007]={BaseID=451702007,Name=SkillEffectDescription.SED_System_GetCurrentEffectSkill,},
  [451702008]={BaseID=451702008,Name=SkillEffectDescription.SED_SkillEffect_FilterEnemy,EventArg1={0,451702009,},},
  [451702009]={BaseID=451702009,},
  [451702010]={BaseID=451702010,Name=SkillEffectDescription.SED_SkillEffect_DistanceSort,},
  [451702011]={BaseID=451702011,Name=SkillEffectDescription.SED_SkillEffect_AddBuffGroup,EventArg1={0,451702012,},EventArg2={138,0,},EventArg3={300000,0,},},
  [451702012]={BaseID=451702012,Name=SkillEffectDescription.SED_Battle_GetCurrentEventEffectiveTarget,},
  [451702013]={BaseID=451702013,Name=SkillEffectDescription.SED_SkillEffect_PlaySpecialEffect,},
  [451703001]={BaseID=451703001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451703002]={BaseID=451703002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={5000,0,},},
  [451704001]={BaseID=451704001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451704002]={BaseID=451704002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={10000,0,},},
  [451704003]={BaseID=451704003,Name=SkillEffectDescription.SED_SkillCondition_SelfSameSkill,},
  [451704004]={BaseID=451704004,Name=SkillEffectDescription.SED_LogicOperation_TraverseUnit,EventArg1={0,451704005,},EventArg2={451704006,0,},},
  [451704005]={BaseID=451704005,Name=SkillEffectDescription.SED_Battle_GetEventEffectiveTarget,},
  [451704006]={BaseID=451704006,Name=SkillEffectDescription.SED_Null,EventArg1={0,451704007,},},
  [451704007]={BaseID=451704007,Name=SkillEffectDescription.SED_LogicOperation_ConditionalBranch,EventArg1={0,451704008,},EventArg2={0,451704014,},},
  [451704008]={BaseID=451704008,Name=SkillEffectDescription.SED_Null,EventArg1={0,451704009,},},
  [451704009]={BaseID=451704009,Name=SkillEffectDescription.SED_LogicOperation_DataCompare,EventArg1={1,0,},EventArg2={0,451704010,},EventArg3={0,451704012,},},
  [451704010]={BaseID=451704010,Name=SkillEffectDescription.SED_Role_GetRoleMaxAttr,EventArg1={0,451704011,},EventArg2={17,0,},},
  [451704011]={BaseID=451704011,},
  [451704012]={BaseID=451704012,Name=SkillEffectDescription.SED_Role_GetRoleMaxAttr,EventArg1={0,451704013,},EventArg2={17,0,},},
  [451704013]={BaseID=451704013,Name=SkillEffectDescription.SED_GetCurrentTraverseUnit,},
  [451704014]={BaseID=451704014,Name=SkillEffectDescription.SED_Null,EventArg1={0,451704015,},},
  [451704015]={BaseID=451704015,Name=SkillEffectDescription.SED_XIDAOZHIDINGWEIZHI_DANGQIANBIANLIDANWEI,},
  [451801001]={BaseID=451801001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451801002]={BaseID=451801002,Name=SkillEffectDescription.SED_SkillLogic_MultisegmentAttackSkill,EventArg1={0,0,},EventArg2={3500,0,},EventArg3={20000,0,},},
  [451803001]={BaseID=451803001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451803002]={BaseID=451803002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={3750,0,},},
  [451803003]={BaseID=451803003,Name=SkillEffectDescription.SED_SkillCondition_SelfSameSkill,},
  [451803004]={BaseID=451803004,Name=SkillEffectDescription.SED_SkillEffect_ReduceZhenQi,EventArg1={0,451803005,},},
  [451803005]={BaseID=451803005,Name=SkillEffectDescription.SED_BasicDataOperation,EventArg1={3,0,},EventArg2={0,451803006,},EventArg3={1500,0,},},
  [451803006]={BaseID=451803006,Name=SkillEffectDescription.SED_Role_GetCurrentRoleAttr,EventArg1={0,451803007,},EventArg2={145,0,},},
  [451803007]={BaseID=451803007,},
  [451901001]={BaseID=451901001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451901002]={BaseID=451901002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={5000,0,},},
  [451902001]={BaseID=451902001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451902002]={BaseID=451902002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={6000,0,},},
  [451903001]={BaseID=451903001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451903002]={BaseID=451903002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={10000,0,},},
  [451903003]={BaseID=451903003,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,451903004,},},
  [451903004]={BaseID=451903004,Name=SkillEffectDescription.SED_Null,EventArg1={0,451903005,},EventArg2={0,451903006,},},
  [451903005]={BaseID=451903005,Name=SkillEffectDescription.SED_SkillCondition_SelfSameSkill,},
  [451903006]={BaseID=451903006,Name=SkillEffectDescription.SED_Condition_Ture,EventArg1={3000,0,},},
  [451903007]={BaseID=451903007,Name=SkillEffectDescription.SED_SkillEffect_AddBuffGroup,EventArg1={0,451903008,},EventArg2={136,0,},EventArg3={200000,0,},},
  [451903008]={BaseID=451903008,Name=SkillEffectDescription.SED_Battle_GetEventEffectiveTarget,},
  [451904001]={BaseID=451904001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [451904002]={BaseID=451904002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={4200,0,},},
  [452001001]={BaseID=452001001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [452001002]={BaseID=452001002,Name=SkillEffectDescription.SED_SkillLogic_RemoteMultisegmentAnQiSkill,EventArg1={0,0,},EventArg2={3500,0,},EventArg3={30000,0,},},
  [452002001]={BaseID=452002001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [452002002]={BaseID=452002002,Name=SkillEffectDescription.SED_SkillLogic_CommonAttackSkill,EventArg1={0,0,},EventArg2={5625,0,},},
  [452002003]={BaseID=452002003,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,452002004,},},
  [452002004]={BaseID=452002004,Name=SkillEffectDescription.SED_Null,EventArg1={0,452002005,},EventArg2={0,452002006,},},
  [452002005]={BaseID=452002005,Name=SkillEffectDescription.SED_SkillCondition_SelfSameMaritalSkill,},
  [452002006]={BaseID=452002006,Name=SkillEffectDescription.SED_Role_OwnBuff,EventArg1={0,452002007,},EventArg2={110,0,},},
  [452002007]={BaseID=452002007,},
  [452002008]={BaseID=452002008,Name=SkillEffectDescription.SED_SkillEffect_MartialExtraPower,EventArg1={0,0,},EventArg2={4500,0,},},
  [452003001]={BaseID=452003001,Name=SkillEffectDescription.SED_SkillCondition_CommonInitiativeUseSkill,},
  [452003002]={BaseID=452003002,Name=SkillEffectDescription.SED_SkillLogic_RemoteMultisegmentAnQiSkill,EventArg1={0,0,},EventArg2={4200,0,},EventArg3={30000,0,},},
  [460000001]={BaseID=460000001,Name=SkillEffectDescription.SED_Logic_Sum,EventArg1={0,460000002,},},
  [460000002]={BaseID=460000002,Name=SkillEffectDescription.SED_Null,EventArg1={0,460000003,},EventArg2={0,460000004,},EventArg3={0,460000006,},},
  [460000003]={BaseID=460000003,Name=SkillEffectDescription.SED_SkillCondition_SelfISAttacked,},
  [460000004]={BaseID=460000004,Name=SkillEffectDescription.SED_Battle_WhetherRolePoZhao,EventArg1={0,460000005,},},
  [460000005]={BaseID=460000005,},
  [460000006]={BaseID=460000006,Name=SkillEffectDescription.SED_Condition_Ture,EventArg1={5000,0,},},
  [460000007]={BaseID=460000007,Name=SkillEffectDescription.SED_SkillLogic_CommonFanJiProcess,EventArg1={20001,0,},EventArg2={5001,0,},},
  [460000008]={BaseID=460000008,Name=SkillEffectDescription.SED_jinengyouxianji_yipinzhidingyouxianji,EventArg1={0,460000009,},EventArg2={0,460000010,},},
  [460000009]={BaseID=460000009,Name=SkillEffectDescription.SED_Data_GetDataAttr,EventArg1={1,0,},EventArg2={21,0,},EventArg3={20001,0,},},
  [460000010]={BaseID=460000010,Name=SkillEffectDescription.SED_Data_GetDataAttr,EventArg1={1,0,},EventArg2={22,0,},EventArg3={20001,0,},},
}

-- export table: SkillEffect
return SkillEffect
