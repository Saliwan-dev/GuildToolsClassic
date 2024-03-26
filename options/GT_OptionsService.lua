local GT_OptionsPanel = CreateFrame("Frame")
GT_OptionsPanel.name = "GuildTools"
InterfaceOptions_AddCategory(GT_OptionsPanel)

-- add widgets to the panel as desired
local title = GT_OptionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
title:SetPoint("TOP")
title:SetText("GuildTools")