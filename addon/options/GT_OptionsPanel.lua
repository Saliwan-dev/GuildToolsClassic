local GT_OptionsPanel = CreateFrame("Frame")
GT_OptionsPanel.name = "GuildTools"
InterfaceOptions_AddCategory(GT_OptionsPanel)

-- add widgets to the panel as desired
local title = GT_OptionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
title:SetPoint("TOP")
title:SetText("GuildTools")

-- Locale

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

-- Debug

local debugCheckbox = GT_UIFactory:CreateCheckbutton(GT_OptionsPanel, 10, -80, "")
GT_LocaleManager:BindText(getglobal(debugCheckbox:GetName() .. 'Text'), "optionspanel.debugCheckbox")
debugCheckbox:SetScript("OnClick",
    function()
        GT_OptionsService:SaveOption("debug", debugCheckbox:GetChecked())
    end
);

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

    debugCheckbox:SetChecked(GT_OptionsService:GetOption("debug"))
    GT_Logger:SetDebug(GT_OptionsService:GetOption("debug"))
end)

-- J'ai pas trouvé de meilleur endroit pour l'instant
GT_EventManager:AddEventListener("OPTION_UPDATED", function(newOption)
    if newOption.key == "debug" then
        GT_Logger:SetDebug(newOption.value)
    end
end)