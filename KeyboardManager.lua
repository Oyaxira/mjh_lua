KeyboardManager = class("KeyboardManager")
KeyboardManager._instance = nil

FuncType = {
    NextDialog =1,
    OpenDialogRecord =2,
    SwitchAutoDialog =3,
    ChooseDialogOption=4,
    TurnOver=7,
    SwitchAutoBattle=8,
    ChoosePreSkill=10,
    ChooseNextSkill=11,
    ResetPosition=12,
    ChooseCard=13,
    PickItem=14,
    GoBack=15,
    OpenOrCloseQuestUI=16,
    OpenOrCloseTeamUI=17,
    OpenOrCloseBackpackUI=18,
    OpenOrCloseEvolutionUI=19,
    ESCKey=21,
    SwitchDialog1 = 22,
    SwitchDialog2 = 23,
    SwitchDialog3 = 24,
    SwitchDialogOthers = 25,
    NextDialogByMouse=26,
    SkipDialog = 27,
    EndTurn=28,
    ReselectPos=29,
    ChooseSkillByMouseScroller=30,
    ChooseSkill1=31,
    ChooseSkill2=32,
    ChooseSkill3=33,
    ChooseSkillOthers=34,
    ChangeSkillPage=35,
    InfoTips=36,
    OpenOrCloseCityRoleListUI=37,
    MoveUp=38,
    MoveDown=39,
    MoveLeft=40,
    MoveRight=41,
    MazeLeft=42,
    MazeMid=43,
    MazeRight=44,
    MazePick=45,
    MazeLeave=46,
    Close=47,
    SwitchDialog4=48,
    SwitchDialog5=49,
    SwitchDialog6=50,
    SwitchDialog7=51,
    SwitchDialog8=52,
    SwitchDialog9=53,
    ChooseSkill4=54,
    ChooseSkill5=55,
    ChooseSkill6=56,
    ChooseSkill7=57,
    PreSkillPage=58,
    NextSkillPage=59
}

KeyCode = {
    None = "",
    Backspace="backspace",
    Delete="delete",
    Tab="tab",
    Clear="clear",
    Return="return",
    Pause="pause",
    Escape="escape",
    Space="space",
    Keypad0="[0]",
    Keypad1="[1]",
    Keypad2="[2]",
    Keypad3="[3]",
    Keypad4="[4]",
    Keypad5="[5]",
    Keypad6="[6]",
    Keypad7="[7]",
    Keypad8="[8]",
    Keypad9="[9]",
    KeypadPeriod="[.]",
    KeypadSlash="[/]",
    KeypadMul="[*]",
    KeypadMinus="[-]",
    KeypadPlus="[+]",
    --KeypadEquals="equals",    --小键盘有=吗
    KeypadEnter="enter",
    Up="up",
    Down="down",
    Right="right",
    Left="left",
    Insert="insert",
    Home="home",
    End="end",
    PageUp="page up",
    PageDown="page down",
    F1="f1",
    F2="f2",
    F3="f3",
    F4="f4",
    F5="f5",
    F6="f6",
    F7="f7",
    F8="f8",
    F9="f9",
    F10="f10",
    F11="f11",
    F12="f12",
    F13="f13",
    F14="f14",
    F15="f15",
    Num0="0",
    Num1="1",
    Num2="2",
    Num3="3",
    Num4="4",
    Num5="5",
    Num6="6",
    Num7="7",
    Num8="8",
    Num9="9",
    Minus="-",
    Equals="=",
    Exclaim="!",
    At="@",
    Hash="#",
    Dollar="$",
    Percent="%",
    Caret="^",
    And="&",
    Mul="*",
    LeftRoundBracket="(",
    RightRoundBracket=")",
    Underscore="_",
    Plus="+",
    LeftBracket="[",
    RightBracket="]",
    BackQuote="`",
    LeftCurlyBracket="{",
    RightCurlyBracket="}",
    Tilde="~",
    Semicolon=";",
    Quote="'",
    BackSlash="\\",
    Colon=":",
    DoubleQuote='"',
    Pipe="|",
    Comma=",",
    Period=".",
    Slash="/",
    Less="<",
    Greater=">",
    Question="?",
    A="a",
    B="b",
    C="c",
    D="d",
    E="e",
    F="f",
    G="g",
    H="h",
    I="i",
    J="j",
    K="k",
    L="l",
    M="m",
    N="n",
    O="o",
    P="p",
    Q="q",
    R="r",
    S="s",
    T="t",
    U="u",
    V="v",
    W="w",
    X="x",
    Y="y",
    Z="z",
    Numlock="numlock",
    Capslock="caps lock",
    Scrolllock="scroll lock",
    RightShift="right shift",
    LeftShift="left shift",
    RightCtrl="right ctrl",
    LeftCtrl="left ctrl",
    RightAlt="right alt",
    LeftAlt="left alt",
    --RightCmd="right cmd",
    --LeftCmd="left cmd ",
    RightSuper="right super",
    LeftSuper="left super",
    AltGr="alt gr",
    Compose="compose",
    Help="help",
    PrintScreen="print screen",
    SysReq="sys req",
    Break="break",
    Menu="menu",
    Power="power",
    Euro="euro",
    Undo="undo",
    Mouse0="mouse 0",
    Mouse1="mouse 1",
    Mouse2="mouse 2",
    Mouse3="mouse 3",
    Mouse4="mouse 4",
    Mouse5="mouse 5",
    Mouse6="mouse 6",
}

KeyCodeName = {
    [KeyCode.None] = "无",
    [KeyCode.Backspace] = "退格键",
    [KeyCode.Delete] = "Del键",
    [KeyCode.Tab] = "Tab键",
    [KeyCode.Clear] = "clear",
    [KeyCode.Return] = "return",
    [KeyCode.Pause] = "pause",
    [KeyCode.Escape] = "Esc键",
    [KeyCode.Space] = "空格键",
    [KeyCode.Keypad0] ="小键盘0",
    [KeyCode.Keypad1] ="小键盘1",
    [KeyCode.Keypad2] ="小键盘2",
    [KeyCode.Keypad3] ="小键盘3",
    [KeyCode.Keypad4] ="小键盘4",
    [KeyCode.Keypad5] ="小键盘5",
    [KeyCode.Keypad6] ="小键盘6",
    [KeyCode.Keypad7] ="小键盘7",
    [KeyCode.Keypad8] ="小键盘8",
    [KeyCode.Keypad9] ="小键盘9",
    [KeyCode.KeypadPeriod] ="小键盘." ,
    [KeyCode.KeypadSlash] ="小键盘/" ,
    [KeyCode.KeypadMul] ="小键盘*" ,
    [KeyCode.KeypadMinus] ="小键盘-",
    [KeyCode.KeypadPlus] ="小键盘+" ,
    [KeyCode.KeypadEnter] = "小键盘Enter",
    [KeyCode.Up] = "↑键",
    [KeyCode.Down] = "↓键",
    [KeyCode.Right] = "→键",
    [KeyCode.Left] = "←键",
    [KeyCode.Insert] = "Ins键",
    [KeyCode.Home] = "Home键",
    [KeyCode.End] = "End键",
    [KeyCode.PageUp] = "上一页键",
    [KeyCode.PageDown] = "下一页键",
    [KeyCode.F1] = "F1",
    [KeyCode.F2] = "F2",
    [KeyCode.F3] = "F3",
    [KeyCode.F4] = "F4",
    [KeyCode.F5] = "F5",
    [KeyCode.F6] = "F6",
    [KeyCode.F7] = "F7",
    [KeyCode.F8] = "F8",
    [KeyCode.F9] = "F9",
    [KeyCode.F10] = "F10",
    [KeyCode.F11] = "F11",
    [KeyCode.F12] = "F12",
    [KeyCode.F13] = "F13",
    [KeyCode.F14] = "F14",
    [KeyCode.F15] = "F15",
    [KeyCode.Num0] = "0",
    [KeyCode.Num1] = "数字键1",
    [KeyCode.Num2] = "数字键2",
    [KeyCode.Num3] = "数字键3",
    [KeyCode.Num4] = "数字键4",
    [KeyCode.Num5] = "数字键5",
    [KeyCode.Num6] = "数字键6",
    [KeyCode.Num7] = "数字键7",
    [KeyCode.Num8] = "数字键8",
    [KeyCode.Num9] = "数字键9",
    [KeyCode.Minus] = "-键",
    [KeyCode.Equals] = "=键",
    [KeyCode.Exclaim] = "!键",
    [KeyCode.At] = "@键",
    [KeyCode.Hash] = "#键",
    [KeyCode.Dollar] = "$键",
    [KeyCode.Percent] = "%键",
    [KeyCode.Caret] = "^键",
    [KeyCode.And] = "&键",
    [KeyCode.Mul] = "*键",
    [KeyCode.LeftRoundBracket] = "(键",
    [KeyCode.RightRoundBracket] = ")键",
    [KeyCode.Underscore] = "_键",
    [KeyCode.Plus] = "+键",
    [KeyCode.LeftBracket] = "[键",
    [KeyCode.RightBracket] = "]键",
    [KeyCode.BackQuote] = "`键",
    [KeyCode.LeftCurlyBracket] = "{键",
    [KeyCode.RightCurlyBracket] = "}键",
    [KeyCode.Tilde] = "~键" ,
    [KeyCode.Semicolon] = ";键" ,
    [KeyCode.Quote] = "'键" ,
    [KeyCode.BackSlash] = "\\键" ,
    [KeyCode.Colon] = ":键" ,
    [KeyCode.DoubleQuote] = '"键' ,
    [KeyCode.Pipe] = "|键" ,
    [KeyCode.Comma] = ",键" ,
    [KeyCode.Period] = ".键" ,
    [KeyCode.Slash] = "/键" ,
    [KeyCode.Less] = "<键" ,
    [KeyCode.Greater] = ">键" ,
    [KeyCode.Question] = "?键" ,
    [KeyCode.A] = "A键",
    [KeyCode.B] = "B键",
    [KeyCode.C] = "C键",
    [KeyCode.D] = "D键",
    [KeyCode.E] = "E键",
    [KeyCode.F] = "F键",
    [KeyCode.G] = "G键",
    [KeyCode.H] = "H键",
    [KeyCode.I] = "I键",
    [KeyCode.J] = "J键",
    [KeyCode.K] = "K键",
    [KeyCode.L] = "L键",
    [KeyCode.M] = "M键",
    [KeyCode.N] = "N键",
    [KeyCode.O] = "O键",
    [KeyCode.P] = "P键",
    [KeyCode.Q] = "Q键",
    [KeyCode.R] = "R键",
    [KeyCode.S] = "S键",
    [KeyCode.T] = "T键",
    [KeyCode.U] = "U键",
    [KeyCode.V] = "V键",
    [KeyCode.W] = "W键",
    [KeyCode.X] = "X键",
    [KeyCode.Y] = "Y键",
    [KeyCode.Z] = "Z键",
    [KeyCode.Numlock] = "NumLock键",
    [KeyCode.Capslock] = "CapsLock键",
    [KeyCode.Scrolllock] = "ScrollLock键",
    [KeyCode.RightShift] = "右Shift键",
    [KeyCode.LeftShift] = "左Shift键",
    [KeyCode.RightCtrl] = "右Ctrl键",
    [KeyCode.LeftCtrl] = "左Ctrl键",
    [KeyCode.RightAlt] = "右Alt键",
    [KeyCode.LeftAlt] = "左Alt键",
    [KeyCode.RightSuper] = "right super",
    [KeyCode.LeftSuper] = "left super",
    [KeyCode.AltGr] = "alt gr",
    [KeyCode.Compose] = "compose",
    [KeyCode.Help] = "help",
    [KeyCode.PrintScreen] = "print screen",
    [KeyCode.SysReq] = "sys req",
    [KeyCode.Break] = "break",
    [KeyCode.Menu] = "menu",
    [KeyCode.Power] = "power",
    [KeyCode.Euro] = "euro",
    [KeyCode.Undo] = "undo",
    [KeyCode.Mouse0] = "mouse 0",
    [KeyCode.Mouse1] = "mouse 1",
    [KeyCode.Mouse2] = "mouse 2",
    [KeyCode.Mouse3] = "mouse 3",
    [KeyCode.Mouse4] = "mouse 4",
    [KeyCode.Mouse5] = "mouse 5",
    [KeyCode.Mouse6] = "mouse 6",
}

function KeyboardManager:GetInstance()
    if KeyboardManager._instance == nil then
        KeyboardManager._instance = KeyboardManager.new()
        self:Init()
    end
    return KeyboardManager._instance
end

function KeyboardManager:Init()
    self:Load()
    self:UpdateFuncAndKeycodeMap()
    self:InitCondition()
end

function KeyboardManager:AnyKeyPressed()
    for key, value in pairs(KeyCode) do
        if value == "" then
        elseif CS.UnityEngine.Input.GetKey(value) then
            self.currentKeycode = value
            return true
        end
    end
    return false
end

function KeyboardManager:Update(deltaTime)
    if self.isWaitting then
        if self:AnyKeyPressed() then
            self.isWaitting = false
            self.waittingCallback(self.currentKeycode)
        end
    end
end

function KeyboardManager:IsWaittingPresskey()
    return self.isWaitting
end

KEYBOARD_DATA_VERSION = "0.0.0.6"

local DefaultKeySettingsTable =
{
    {
        ["界面名称"] = "对话界面",
        ["按键设置"] = {
            {
                ["功能"] = FuncType.NextDialog,
                ["功能描述"] = "下一句对话",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Space
            },
            {
                ["功能"] = FuncType.SwitchAutoDialog,
                ["功能描述"] = "切换自动对话",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.LeftShift
            },
            {
                ["功能"] = FuncType.SwitchDialog1,
                ["功能描述"] = "选择选项1",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num1
            },
            {
                ["功能"] = FuncType.SwitchDialog2,
                ["功能描述"] = "选择选项2",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num2
            },
            {
                ["功能"] = FuncType.SwitchDialog3,
                ["功能描述"] = "选择选项3",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num3
            },
            {
                ["功能"] = FuncType.SwitchDialog4,
                ["功能描述"] = "选择选项4",
                ["中文描述"] = "数字键4",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num4
            },
            {
                ["功能"] = FuncType.SwitchDialog5,
                ["功能描述"] = "选择选项5",
                ["中文描述"] = "数字键5",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num5
            },
            {
                ["功能"] = FuncType.SwitchDialog6,
                ["功能描述"] = "选择选项6",
                ["中文描述"] = "数字键6",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num6
            },
            {
                ["功能"] = FuncType.SwitchDialog7,
                ["功能描述"] = "选择选项7",
                ["中文描述"] = "数字键7",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num7
            },
            {
                ["功能"] = FuncType.SwitchDialog8,
                ["功能描述"] = "选择选项8",
                ["中文描述"] = "数字键8",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num8
            },
            {
                ["功能"] = FuncType.SwitchDialog9,
                ["功能描述"] = "选择选项9",
                ["中文描述"] = "数字键9",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num9
            },
            {
                ["功能"] = FuncType.NextDialogByMouse,
                ["功能描述"] = "下一句对话",
                ["中文描述"] = "鼠标点击屏幕/鼠标滚轮下滑",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None
            },
            {
                ["功能"] = FuncType.OpenDialogRecord,
                ["功能描述"] = "查看对话记录",
                ["中文描述"] = "鼠标滚轮上滑",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None
            },
            {
                ["功能"] = FuncType.SkipDialog,
                ["功能描述"] = "快进对话",
                ["中文描述"] = "长按空格键",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None,
            },
        },
    },
    {
        ["界面名称"] = "战斗界面",
        ["按键设置"] = {
            {
                ["功能"] = FuncType.EndTurn,
                ["功能描述"] = "立刻结束回合",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.BackQuote
            },
            {
                ["功能"] = FuncType.ReselectPos,
                ["功能描述"] = "重选移动位置",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.W
            },
            {
                ["功能"] = FuncType.ChoosePreSkill,
                ["功能描述"] = "选择上一个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Q
            },
            {
                ["功能"] = FuncType.ChooseNextSkill,
                ["功能描述"] = "选择下一个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.E
            },
            {
                ["功能"] = FuncType.ChooseSkillByMouseScroller,
                ["功能描述"] = "滚轮切换技能",
                ["中文描述"] = "鼠标滚轮上滑/下滑",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None
            },
            {
                ["功能"] = FuncType.ChooseSkill1,
                ["功能描述"] = "选择第1个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num1
            },
            {
                ["功能"] = FuncType.ChooseSkill2,
                ["功能描述"] = "选择第2个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num2
            },
            {
                ["功能"] = FuncType.ChooseSkill3,
                ["功能描述"] = "选择第3个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num3
            },
            {
                ["功能"] = FuncType.ChooseSkill4,
                ["功能描述"] = "选择第4个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num4
            },
            {
                ["功能"] = FuncType.ChooseSkill5,
                ["功能描述"] = "选择第5个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num5
            },
            {
                ["功能"] = FuncType.ChooseSkill6,
                ["功能描述"] = "选择第6个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num6
            },
            {
                ["功能"] = FuncType.ChooseSkill7,
                ["功能描述"] = "选择第7个技能",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num7
            },
            {
                ["功能"] = FuncType.PreSkillPage,
                ["功能描述"] = "技能栏前一页",
                ["中文描述"] = "+键",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Plus
            },
            {
                ["功能"] = FuncType.NextSkillPage,
                ["功能描述"] = "技能栏下一页",
                ["中文描述"] = "-键",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Minus
            },
            {
                ["功能"] = FuncType.InfoTips,
                ["功能描述"] = "查看角色信息",
                ["中文描述"] = "鼠标右键",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None
            },
            {
                ["功能"] = FuncType.SwitchAutoBattle,
                ["功能描述"] = "切换自动战斗",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.LeftShift
            },
        },
    },
    {
        ["界面名称"] = "地图界面",
        ["按键设置"] = {
            {
                ["功能"] = FuncType.OpenOrCloseQuestUI,
                ["功能描述"] = "开/关任务面板",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Q
            },
            {
                ["功能"] = FuncType.OpenOrCloseTeamUI,
                ["功能描述"] = "开/关队伍界面",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.E
            },
            {
                ["功能"] = FuncType.OpenOrCloseBackpackUI,
                ["功能描述"] = "开/关物品界面",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.R
            },
            {
                ["功能"] = FuncType.OpenOrCloseEvolutionUI,
                ["功能描述"] = "开/关演化界面",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.F
            },
            {
                ["功能"] = FuncType.OpenOrCloseCityRoleListUI,
                ["功能描述"] = "开/关信息窗",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.LeftShift
            },
            {
                ["功能"] = FuncType.MoveUp,
                ["功能描述"] = "向上移动",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.W
            },
            {
                ["功能"] = FuncType.MoveDown,
                ["功能描述"] = "向下移动",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.S
            },
            {
                ["功能"] = FuncType.MoveLeft,
                ["功能描述"] = "向左移动",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.A
            },
            {
                ["功能"] = FuncType.MoveRight,
                ["功能描述"] = "向右移动",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.D
            },
        },
    },
    {
        ["界面名称"] = "迷宫界面",
        ["按键设置"] = {
            {
                ["功能"] = FuncType.MazeLeft,
                ["功能描述"] = "选择左侧卡片",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num1
            },
            {
                ["功能"] = FuncType.MazeMid,
                ["功能描述"] = "选择中间卡片",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num2
            },
            {
                ["功能"] = FuncType.MazeRight,
                ["功能描述"] = "选择右侧卡片",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.Num3
            },
            {
                ["功能"] = FuncType.MazePick,
                ["功能描述"] = "拾取画面中物品",
                ["中文描述"] = "",
                ["是否支持自定义"] = true,
                keyCode = KeyCode.BackQuote
            },
            {
                ["功能"] = FuncType.MazeLeave,
                ["功能描述"] = "离开迷宫",
                ["中文描述"] = "Esc键/鼠标右键",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None
            },
        },
    },
    {
        ["界面名称"] = "其他",
        ["按键设置"] = {
            {
                ["功能"] = FuncType.Close,
                ["功能描述"] = "返回/关闭界面",
                ["中文描述"] = "ESC/鼠标右键",
                ["是否支持自定义"] = false,
                keyCode = KeyCode.None
            },

        },
    },
}

local CurrentKeySettingsTable = {}

function KeyboardManager:GetKeySettingsTable()
    self:Load()
    return CurrentKeySettingsTable
end

function KeyboardManager:IsChanged(uiIndex,btnIndex,keycode)
    return DefaultKeySettingsTable[uiIndex]['按键设置'][btnIndex].keyCode ~= keycode
end

function KeyboardManager:GetDefaultKeyCode(uiIndex,btnIndex)
    return DefaultKeySettingsTable[uiIndex]['按键设置'][btnIndex].keyCode or KeyCode.None
end

FuncAndKeycodeMap = {}

function KeyboardManager:UpdateFuncAndKeycodeMap()
    FuncAndKeycodeMap = {}
    if CurrentKeySettingsTable and next(CurrentKeySettingsTable) then
        for UIIndex, UI in pairs(CurrentKeySettingsTable) do
            if UI["按键设置"] and next(UI["按键设置"]) then
                for btnIndex, btn in pairs(UI["按键设置"]) do
                    if btn["功能"]==nil then
                        derror("功能配置有误")
                    end
                    if btn.keyCode==nil then
                        btn.keyCode=KeyCode.None
                    end
                    FuncAndKeycodeMap[btn["功能"]]=btn.keyCode
                end
            end
        end
    end
end

function KeyboardManager:Save(KeySettingsTable)
    SetConfig('KEYBOARD_DATA_VERSION',KEYBOARD_DATA_VERSION)
    SetConfig('ShortcutData',KeySettingsTable,true)
    self:Load()
    self:UpdateFuncAndKeycodeMap()
end

function KeyboardManager:Load()
    local version = GetNewConfig('KEYBOARD_DATA_VERSION')
    if version and version == KEYBOARD_DATA_VERSION then
        CurrentKeySettingsTable = GetNewConfig('ShortcutData')
        self:UpdateFuncAndKeycodeMap()
        if CurrentKeySettingsTable and next(CurrentKeySettingsTable) then
            return CurrentKeySettingsTable
        end
    else
        self:Save(DefaultKeySettingsTable)
        CurrentKeySettingsTable = GetNewConfig('ShortcutData')
    end
    return CurrentKeySettingsTable
end

function KeyboardManager:GetKeyDown(keyCode)
    if self.isWaitting then
        return false
    end

    if not keyCode or keyCode == KeyCode.None then
        return false
    end
    if CS.UnityEngine.Input.GetKeyDown(keyCode) then
        self.currentKeycode = keyCode
        return true
    else
        return false
    end
end

function KeyboardManager:GetKey(keyCode)
    if self.isWaitting then
        return false
    end
    if not keyCode or keyCode == KeyCode.None then
        return false
    end
    if CS.UnityEngine.Input.GetKey(keyCode) then
        self.currentKeycode = keyCode
        return true
    else
        return false
    end
end

function KeyboardManager:StartWaittingPressKey(callback)
    self.isWaitting = true
    self.waittingCallback = callback
end

function KeyboardManager:ContinueWaittingPressKey()
    self.isWaitting = true
end

function KeyboardManager:GetKeyCodeByFuncName(funcName)
    if not ( FuncAndKeycodeMap and next(FuncAndKeycodeMap) )then
        self:UpdateFuncAndKeycodeMap()
    end
    return FuncAndKeycodeMap[funcName] or "未配置此功能"
end

function KeyboardManager:ResetKeyboardSettings()
    self:Save(DefaultKeySettingsTable)
end

function KeyboardManager:InitCondition()
    --TODO 将分散于各个UI update中快捷键的if逻辑统一至此维护
    self.OpenOrCloseQuestUIInvalidCondition = function()
        return IsAnyWindowOpen({"PlayerSetUI","DialogChoiceUI","GeneralBoxUI","MarryUI","SelectUI","MapUnfoldUI","MazeEntryUI","TitleSelectUI","RandomRollUI"})
    end
    --暂时都和任务面板的条件相同
    self.OpenOrCloseTeamUIInvalidCondition = function()
        return self.OpenOrCloseQuestUIInvalidCondition()
    end

    self.OpenOrCloseBackpackUIInvalidCondition = function()
        return self.OpenOrCloseQuestUIInvalidCondition()
    end

    self.OpenOrCloseEvolutionUIInvalidCondition = function()
        return self.OpenOrCloseQuestUIInvalidCondition()
    end

    self.OpenOrCloseCityRoleListUIInvalidCondition = function()
        return self.OpenOrCloseQuestUIInvalidCondition()
    end

    self.MoveUpInvalidCondition = function()
        return IsAnyWindowOpen({"PlayerSetUI","DialogChoiceUI","TaskUI","CharacterUI","StorageUI","DialogRecordUI","CollectionUI","EvolutionUI","GeneralBoxUI",
        "MarryUI","SelectUI","MapUnfoldUI","MazeEntryUI","TitleSelectUI","MartialSelectUI", "SwornUI", "SetNicknameUI","RandomRollUI"})
    end
    self.MoveDownInvalidCondition = function()
        return self.MoveUpInvalidCondition()
    end
    self.MoveLeftInvalidCondition = function()
        return self.MoveUpInvalidCondition()
    end
    self.MoveRightInvalidCondition = function()
        return self.MoveUpInvalidCondition()
    end
    self.ShortcutInvalidTable = {
        [FuncType.OpenOrCloseQuestUI] = self.OpenOrCloseQuestUIInvalidCondition,
        [FuncType.OpenOrCloseTeamUI] = self.OpenOrCloseTeamUIInvalidCondition,
        [FuncType.OpenOrCloseBackpackUI] = self.OpenOrCloseBackpackUIInvalidCondition,
        [FuncType.OpenOrCloseEvolutionUI] = self.OpenOrCloseEvolutionUIInvalidCondition,
        [FuncType.OpenOrCloseCityRoleListUI] = self.OpenOrCloseCityRoleListUIInvalidCondition,
        [FuncType.MoveUp] = self.MoveUpInvalidCondition,
        [FuncType.MoveDown] = self.MoveDownInvalidCondition,
        [FuncType.MoveLeft] = self.MoveLeftInvalidCondition,
        [FuncType.MoveRight] = self.MoveRightInvalidCondition,
    }
end


