local GuildToolsLDB = LibStub("LibDataBroker-1.1"):NewDataObject("GuildTools", {
	type = "launcher",
	text = "GuildTools",
	icon = "Interface\\AddOns\\GuildTools\\resources\\GuildTools_Logo_Background.png",
    OnTooltipShow = function(tooltip)
        tooltip:AddDoubleLine("GuildTools", "|cffFFFFFFv{{version}}|r");
        tooltip:AddLine("|cffFFFFFF"..GT_LocaleManager:GetLabel("leftclick").." : |r"..GT_LocaleManager:GetLabel("open").." GuildTools")
        tooltip:AddLine("|cffFFFFFF"..GT_LocaleManager:GetLabel("rightclick").." : |r"..GT_LocaleManager:GetLabel("open").." "..GT_LocaleManager:GetLabel("options"))
    end,
	OnClick = function(clickedframe, button)
	    if button == "RightButton" then
	        InterfaceOptionsFrame:Show()
            InterfaceOptionsFrame_OpenToCategory("GuildTools")
	    else
		    GT_MainFrame:SetShown(not GT_MainFrame:IsShown())
		end
	end,
})

local libDbIcon = LibStub("LibDBIcon-1.0")

GT_EventManager:AddEventListener("ADDON_READY", function()
    libDbIcon:Register("GuildTools", GuildToolsLDB, GT_SavedData.options.minimapButton);
end)