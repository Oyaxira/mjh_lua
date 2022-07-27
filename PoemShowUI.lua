PoemShowUI = class("PoemShowUI",BaseWindow)

function PoemShowUI:ctor(obj)
    self:SetGameObject(obj)
    self:Init()
end

function PoemShowUI:Init()
    self.Text_Title = self:FindChildComponent(self._gameObject,"Text_name","Text")
    self.Text_PoetName = self:FindChildComponent(self._gameObject,"Text_poet_name","Text")
    self.Text_poemContent = self:FindChildComponent(self._gameObject,"Scroll View/Viewport/Content/Text","Text")

    self.Button_Close = self:FindChildComponent(self._gameObject,"Button_close","Button")
    if IsValidObj(self.Button_Close) then
        local fun = function()
			self:OnClick_Close_Button()
		end
		self:AddButtonClickListener(self.Button_Close,fun)
    end

    self.Button_Black = self:FindChildComponent(self._gameObject,"Black","Button")
    if IsValidObj(self.Button_Black) then
        local fun = function()
			self:OnClick_Close_Button()
		end
		self:AddButtonClickListener(self.Button_Black,fun)
    end
end

function PoemShowUI:RefreshUI(info)
    if not info or not info.TB then
        return
    end
    
    self.Text_Title.text = GetLanguageByID(info.TB.NameID)
    self.Text_PoetName.text = GetLanguageByID(info.TB.WriterNameID)
    local str = GetLanguageByID(info.TB.TextID)
    if str and (str ~= "") then
        str = "|"  .. str .. "|"
        tabStr = string.split(str, "#")
        table.insert(tabStr, 2, "<color=#913e2b>")
        table.insert(tabStr, #tabStr, "</color>")
        str = string.gsub(table.concat(tabStr, ""), "|", "")
    end
    self.Text_poemContent.text = str or ""

    self._gameObject:SetActive(true)
end

function PoemShowUI:OnClick_Close_Button()
    self._gameObject:SetActive(false)
end

function PoemShowUI:OnDestroy()
    dprint("poemShow close")
end

return PoemShowUI