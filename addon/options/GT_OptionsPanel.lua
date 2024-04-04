local GT_OptionsPanel = CreateFrame("Frame")
GT_OptionsPanel.name = "GuildTools"
InterfaceOptions_AddCategory(GT_OptionsPanel)

-- add widgets to the panel as desired
local title = GT_OptionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
title:SetPoint("TOP")
title:SetText("GuildTools")

local localeDropDown = CreateFrame("FRAME", "OptionLocaleDropDown", GT_OptionsPanel, "UIDropDownMenuTemplate")
localeDropDown:SetPoint("TOPLEFT", 60, -43)
UIDropDownMenu_SetWidth(localeDropDown, 100)

local localeLabel = GT_UIFactory:CreateLabel(GT_OptionsPanel, 10, -50, "Langue", 12, 1, 1, 1)
GT_LocaleManager:BindText(localeLabel, "optionspanel.localelabel", function()
    localeDropDown:SetPoint("TOPLEFT", localeLabel:GetStringWidth() + 5, -43)
end)

function localeDropDown:OnNewValue(newValue)
    UIDropDownMenu_SetText(localeDropDown, newValue)
    GT_OptionsService:SaveOption("locale", newValue)
    GT_LocaleManager:SetFavoriteLocale(newValue)
    CloseDropDownMenus()
end

GT_EventManager:AddEventListener("ADDON_READY", function()
    local favoriteLocale = GT_OptionsService:GetOption("locale")
    GT_LocaleManager:SetFavoriteLocale(favoriteLocale)

    UIDropDownMenu_SetText(localeDropDown, favoriteLocale)

    UIDropDownMenu_Initialize(localeDropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.func = function(self, arg1, arg2, checked) localeDropDown:OnNewValue(arg1) end

        info.text, info.arg1, info.checked = "frFR", "frFR", GT_OptionsService:GetOption("locale") == "frFR"
        info.menuList, info.hasArrow = 1, false
        UIDropDownMenu_AddButton(info)

        info.text, info.arg1, info.checked = "enUS", "enUS", GT_OptionsService:GetOption("locale") == "enUS"
        info.menuList, info.hasArrow = 2, false
        UIDropDownMenu_AddButton(info)
    end)
end)