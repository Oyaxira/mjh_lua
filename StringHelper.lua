StringHelper = class("StringHelper")
StringHelper._instance = nil

function StringHelper:GetInstance()
    if StringHelper._instance == nil then
        StringHelper._instance = StringHelper.new()
    end

    return StringHelper._instance
end

--type=
--ret=string
-- 原则上不判断太监的性别，因为除了公公之外已经没有什么适合的称谓来用，而根据以往做mod时的经验，玩家们会非常抵制这个包含调侃和歧视的称呼
-- 目前的做法是，先将称呼换统一为女性，然后再判断性别，假如性别为男，会将称呼换回男性，否则就直接返回，不进行替换
-- 所以结果就是，女性和太监实际上用的都是女性称谓
local NameRule = {
    [0] = {'随机称谓', '随机称谓'},
    --以下为通用的称谓列表，添加之前请先考虑一下替换的称谓是否适合用来随机，如果不适合，请不要加到这里
    --添加完新的通用称谓之后，请将【随机称谓范围】变量的数量+1
    {'少侠', '女侠'},
    {'侠客', '女侠'},
    {'大侠', '女侠'},
    {'哥哥', '姐姐'},
    {'大哥', '大姐'},
    {'兄弟', '姑娘'},
    {'公子', '姑娘'},
    {'兄台', '姑娘'},
    --以下为非通用的称谓列表
    {'他', '她'},
    {'哥', '姐'},
    {'兄', '姐'},
    {'大哥哥', '大姐姐'},
    {'男孩子', '女孩子'},
    {'小哥哥', '小姐姐'},
    {'小哥', '小姐姐'},
    {'小弟', '小妹'},
    {'小兄弟', '小姑娘'},
    {'小弟', '小妹'},
    {'小伙子', '姑娘'},
    {'少年', '少女'},
    {'施主', '女施主'},
    {'小子', '丫头'},
    {'臭小子', '臭丫头'},
    {'黄毛小子', '黄毛丫头'},
    {'师兄', '师姐'},
    {'师哥', '师姐'},
    {'师弟', '师妹'},
}
local NameRuleMAP = {}
for k,v in pairs(NameRule) do
    NameRuleMAP[v[1]] = v[2]
end

local AllNameRule = {}
for k,v in pairs(NameRule) do
    table.insert(AllNameRule, v[1])
    table.insert(AllNameRule, v[2])
end   

local theKeepDialogue = ""

function StringHelper:SetPlot(string_txt)
    theKeepDialogue = string_txt
end

function StringHelper:GetPlot()
    return theKeepDialogue
end 

function StringHelper:GetNameRule()
    return AllNameRule
end

function StringHelper:NameConversion(string_txt)
    if string_txt == nil then 
        return '' 
    end
    local bool_isKeep = false
    local int_Sex = self:GetSex()
    local start,e,string_ConverBefore = string.find(string_txt, "%[(.-)%]")
    local string_result = string_txt
    while start and string_ConverBefore do 
        local string_ConverAfter
        if string_ConverBefore == '随机称谓' then
            string_ConverAfter = NameRule[math.random(1,8)][1]
        elseif NameRuleMAP[string_ConverBefore] then
            if int_Sex == 1 then
                string_ConverAfter = string_ConverBefore
            else
                string_ConverAfter = NameRuleMAP[string_ConverBefore]
            end
        elseif string_ConverBefore == 'db=10010001' then
            string_ConverAfter = RoleDataManager:GetInstance():GetMainRoleName()
        elseif string_ConverBefore == 'keep' then
            bool_isKeep = true
            string_ConverAfter = ''
        end
        if string_ConverAfter then 
            string_result = string.gsub(string_result, '%[' .. string_ConverBefore .. '%]', string_ConverAfter)
            start,e,string_ConverBefore = string.find(string_result, "%[(.-)%]")
            if bool_isKeep then
                self:SetPlot(string_result)
            end
        else
            string_txt = string.sub(string_txt,e+1)
            start,e,string_ConverBefore = string.find(string_txt, "%[(.-)%]")
        end
    end

    return string_result or ''
end

function StringHelper:GetSex()
    local uiSex = RoleDataManager:GetInstance():GetMainRoleSex()
    return uiSex
end

local o_fontstyle = {
        {
            ['name']=0x1f05001d,
            ['showname']='阴性',
            ['prefix']='新标准',
            ['postfix']='阴性词条',
            ['color']=0xba9a66,
        },
        {
            ['name']=0x1f05001c,
            ['showname']='阳性',
            ['prefix']='新标准',
            ['postfix']='阳性词条',
            ['color']=0x3062ee,
        },
        {
            ['name']=0x1f050015,
            ['showname']='未解锁红',
            ['id']=14,
            ['color']=0xff,
            ['outlineThick']=1,
        },
        {
            ['name']=0x1f050014,
            ['showname']='品级绿',
            ['id']=1,
            ['color']=0x58d46c,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050013,
            ['showname']='品级蓝',
            ['id']=1,
            ['color']=0xffc580,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050012,
            ['showname']='品级紫',
            ['id']=1,
            ['color']=0xf56ac2,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050011,
            ['showname']='品级橙',
            ['id']=1,
            ['color']=0x26a1ff,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050010,
            ['showname']='品级金',
            ['id']=1,
            ['color']=0x60dff8,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f05000f,
            ['showname']='品级暗金',
            ['id']=1,
            ['color']=0x78afbe,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050016,
            ['showname']='品级白',
            ['id']=1,
            ['color']=0xffffff,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050001,
            ['showname']='白色',
            ['id']=1,
            ['prefix']='系统',
            ['color']=0xffffff,
        },
        {
            ['name']=0x1f050002,
            ['showname']='黑色',
            ['id']=2,
            ['prefix']='系统',
            ['color']=0xc0a08,
        },
        {
            ['name']=0x1f050003,
            ['showname']='红色',
            ['id']=3,
            ['prefix']='新标准',
            ['postfix']='警示 禁止',
            ['color']=0xC53926,
        },
        {
            ['name']=0x1f050004,
            ['showname']='蓝色',
            ['id']=4,
            ['color']=0xe3a661,
        },
        {
            ['name']=0x1f050005,
            ['showname']='黄色',
            ['id']=5,
            ['color']=0x74dbe6,
        },
        {
            ['name']=0x1f050006,
            ['showname']='绿色',
            ['id']=6,
            ['color']=0x33a04c,
        },
        {
            ['name']=0x1f050027,
            ['showname']='绿色2',
            ['id']=6,
            ['postfix']='加点',
            ['color']=0x2d8a3a,
        },
        {
            ['name']=0x1f050007,
            ['showname']='紫色',
            ['id']=7,
            ['color']=0xff81ae,
        },
        {
            ['name']=0x1f050008,
            ['showname']='橙色',
            ['id']=8,
            ['color']=0x1f97fd,
        },
        {
            ['name']=0x1f050009,
            ['showname']='灰色',
            ['id']=9,
            ['color']=0x7f7f7f,
        },
        {
            ['name']=0x1f05001f,
            ['showname']='亮灰',
            ['id']=9,
            ['color']=0xbcbcbc,
        },
        {
            ['name']=0x1f05000a,
            ['showname']='深蓝',
            ['id']=10,
            ['color']=0x783314,
        },
        {
            ['name']=0x1f05000b,
            ['showname']='深红',
            ['id']=11,
            ['color']=0x500aae,
        },
        {
            ['name']=0x1f05000c,
            ['showname']='描边',
            ['id']=12,
            ['prefix']='新标准',
            ['postfix']='一级标题',
            ['color']=0xffffff,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f05000d,
            ['showname']='米色',
            ['id']=13,
            ['color']=0xa5cce2,
        },
        {
            ['name']=0x1f05002a,
            ['showname']='金色',
            ['id']=13,
            ['color']=0xfaec1,
        },
        {
            ['name']=0x1f05000e,
            ['showname']='深灰色',
            ['id']=14,
            ['prefix']='新标准',
            ['postfix']='普通内容',
            ['color']=0x525353,
        },
        {
            ['name']=0x1f050028,
            ['showname']='浅灰色',
            ['id']=14,
            ['prefix']='新标准',
            ['postfix']='普通内容',
            ['color']=0x9ea0a0,
        },
        {
            ['name']=0x1f05001e,
            ['showname']='棕色',
            ['id']=14,
            ['color']=0x1b6c8d,
        },
        {
            ['name']=0x1f050026,
            ['showname']='叶绿',
            ['prefix']='新标准',
            ['postfix']='推荐 满足要求',
            ['color']=0x2d8a68,
        },
        {
            ['name']=0x1f050025,
            ['showname']='亮蓝',
            ['prefix']='新标准',
            ['postfix']='点击提示',
            ['color']=0xebee55,
        },
        {
            ['name']=0x1f050029,
            ['showname']='浅蓝色',
            ['prefix']='新标准',
            ['postfix']='普通内容',
            ['color']=0xeae883,
        },
        {
            ['name']=0x1f050024,
            ['showname']='酒红色',
            ['id']=14,
            ['prefix']='新标准',
            ['postfix']='普通内容',
            ['color']=0x3a3a4e,
        },
        {
            ['name']=0x1f050019,
            ['showname']='负面评价',
            ['id']=14,
            ['color']=0xc138ea,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050018,
            ['showname']='正面评价',
            ['id']=14,
            ['color']=0x2ed01,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f05001b,
            ['showname']='蓝灰色',
            ['color']=0x64513e,
        },
        {
            ['name']=0x1f050021,
            ['showname']='描边灰',
            ['color']=0xd6dadc,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f05001a,
            ['showname']='任务进度',
            ['id']=14,
            ['color']=0x4955d,
        },
        {
            ['name']=0x1f050023,
            ['showname']='天赋数字',
            ['id']=14,
            ['color']=0x343535,
        },
        {
            ['name']=0x1f050022,
            ['showname']='天赋文字',
            ['id']=14,
            ['color']=0x3a3a4e,
        },
        {
            ['name']=0x1f050020,
            ['showname']='GM公告',
            ['id']=14,
            ['color']=0x2e2eff,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050017,
            ['showname']='结算经验',
            ['id']=14,
            ['color']=0xfed302,
            ['outlineThick']=2,
        },
        {
            ['name']=0x1f050030,
            ['showname']='品质黄',
            ['color']=0x74dbe6,
            ['outlineThick']=1,
        }
    }

    function StringHelper:StringToColor(str)
        local s = string.sub(str,3,-1)
        -- s = string.format("%06s", s)
        while string.len(s) < 6 do
            s = '0'..s
        end
        ---
        local r = 0
        local g = 0
        local b = 0
        local color 
        ---
        r = string.sub(s,1,2)
        g = string.sub(s,3,4)
        b = string.sub(s,5,6)
        color = b..g..r
        return color
        --DRCSRef.Color(r/255, g/255, b/255, 1)
    end

    function StringHelper:RichTextConversion(string_txt)
        if string_txt then
        else
            return ''
        end
        local start,e,string_ConverBefore = string.find(string_txt, "%[(.-)%]")
        if  string_ConverBefore == nil then
            string_txt = string.gsub(string_txt,  "%{", "[")
            string_txt = string.gsub(string_txt,  "%}", "]")
            return string_txt
        else
    
            local string_ConverAfter
            for i,v in ipairs(o_fontstyle) do
                local _font = v
                    if string_ConverBefore == "00" then
                    local _color_left =  "<color=FFFFFF>"
                    string_ConverAfter = string.gsub(string_txt,  "%[(.-)%]", _color_left,1)
    
                    local next_start,next_e,next_string_ConverBefore = string.find(string_txt, "%[(.-)%]")
                    local _color_right =  "</color>"
    
                    if  next_string_ConverBefore == nil then
                        string_ConverAfter = string_ConverAfter.._color_right
                    else   
                        string_ConverAfter = string.gsub(string_ConverAfter,  "%[(.-)%]", _color_right,1)
                    end
                else
                    local count = tonumber('0x' .. string_ConverBefore)
                    if (count and math.ceil(0x1f050000 + count) == v.name) or string_ConverBefore == _font['id']then
                        if math.ceil(0x1f050000 + count) == v.name then
                            --替换
                            --dprint("替换")
                            local _color_left =  string.format("<color=#%s>",self:StringToColor(string.format("%#x",v.color)))
                            -- <color=#00ffffff>     </color>
                            string_ConverAfter = string.gsub(string_txt,  "%[(.-)%]", _color_left,1)
                            local next_start,next_e,next_string_ConverBefore = string.find(string_ConverAfter, "%[(.-)%]")
                            local _color_right =  "</color>"
    
                            if  next_string_ConverBefore == "00" then
                                string_ConverAfter = string.gsub(string_ConverAfter,  "%[(.-)%]", _color_right.."<color=FFFFFF>",1)
                                next_start,next_e,next_string_ConverBefore = string.find(string_ConverAfter, "%[(.-)%]")
                                if  next_string_ConverBefore == nil then
                                    return string_ConverAfter.._color_right
                                end
                            elseif  next_string_ConverBefore == nil then
                                return string_ConverAfter.._color_right
                            else
                                string_ConverAfter = string.gsub(string_ConverAfter,  "%[(.-)%]", _color_right,1)
                            end
                            break
                        end
                    else
                           --db=10010001
                        --暂时先将[db=1001001] 替换成{db = 1001001}
                        --后续再全部替换回去
                        local temp =  string.format("{%s}",string_ConverBefore)
                        string_ConverAfter = string.gsub(string_txt,  "%[(.-)%]", temp,1)
                    end
                end
            end
            return self:RichTextConversion(string_ConverAfter)
        end
    end


    function StringHelper:StringToColor(str)
        local s = string.sub(str,3,-1)
        -- s = string.format("%06s", s)
        while string.len(s) < 6 do
            s = '0'..s
        end
        ---
        local r = 0
        local g = 0
        local b = 0
        local color 
        ---
        r = string.sub(s,1,2)
        g = string.sub(s,3,4)
        b = string.sub(s,5,6)
        color = b..g..r
        return color
        --DRCSRef.Color(r/255, g/255, b/255, 1)
    end
    