local backdropInfo =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Rock",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local GT_MainFrame = CreateFrame("Frame", "GT_MainFrame", UIParent, "BackdropTemplate")
GT_MainFrame:SetPoint("CENTER", 0, 80)
GT_MainFrame:SetSize(550, 430)
GT_MainFrame:SetBackdrop(backdropInfo)
GT_MainFrame:EnableMouse(true)
GT_MainFrame:Hide()

local titleBackdrop =
{
    bgFile=nil,
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local title = CreateFrame("Frame", "GT_MainFrame_Title", GT_MainFrame, "BackdropTemplate")
title:SetPoint("TOP")
title:SetSize(550, 30)
title:SetBackdrop(titleBackdrop)

local titleLabel = GT_UIFactory:CreateLabel(title, 0, 0, "Guild Tools", 14, 1, 0.8, 0)
titleLabel:ClearAllPoints()
titleLabel:SetPoint("CENTER", 0, -1)

local closeButton = CreateFrame("Button", nil, GT_MainFrame)
closeButton:SetSize(35, 35)
closeButton:SetPoint("TOPRIGHT", 4, 4)
closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
closeButton:SetScript('OnClick', function()
	GT_MainFrame:Hide()
end)

-- Members Tab

GT_GuildMembersTabContent = CreateFrame("Frame", "GT_GuildMembersTabContent", GT_MainFrame)
GT_GuildMembersTabContent:SetSize(GT_MainFrame:GetWidth(), GT_MainFrame:GetHeight())
GT_GuildMembersTabContent:SetPoint("TOPLEFT", 5, -27)
GT_GuildMembersTabContent:Hide()

local membersTab = GT_UIFactory:AddTab(GT_MainFrame, "", GT_GuildMembersTabContent)
GT_LocaleManager:BindText(membersTab, "mainframe.tabs.members")

-- Bank Tab

GT_BankTabContent = CreateFrame("Frame", "GT_BankTabContent", GT_MainFrame)
GT_BankTabContent:SetSize(GT_MainFrame:GetWidth(), GT_MainFrame:GetHeight())
GT_BankTabContent:SetPoint("TOPLEFT", 5, -27)
GT_BankTabContent:Hide()

local bankTab = GT_UIFactory:AddTab(GT_MainFrame, "", GT_BankTabContent)
GT_LocaleManager:BindText(bankTab, "mainframe.tabs.bank")

-- Calendar Tab

GT_CalendarTabContent = CreateFrame("Frame", "GT_CalendarTabContent", GT_MainFrame)
GT_CalendarTabContent:SetSize(GT_MainFrame:GetWidth(), GT_MainFrame:GetHeight())
GT_CalendarTabContent:SetPoint("TOPLEFT", 5, -27)
GT_CalendarTabContent:Hide()

local calendarTab = GT_UIFactory:AddTab(GT_MainFrame, "", GT_CalendarTabContent)
GT_LocaleManager:BindText(calendarTab, "mainframe.tabs.calendar")

-- Admin Tab

GT_AdminTabContent = CreateFrame("Frame", "GT_AdminTabContent", GT_MainFrame)
GT_AdminTabContent:SetSize(GT_MainFrame:GetWidth(), GT_MainFrame:GetHeight())
GT_AdminTabContent:SetPoint("TOPLEFT", 5, -27)
GT_AdminTabContent:Hide()

local adminTab = GT_UIFactory:AddTab(GT_MainFrame, "", GT_AdminTabContent)
GT_LocaleManager:BindText(adminTab, "mainframe.tabs.admin")

-- BOUTON SUR LE PANEL DE GUILDE...  A DEPLACER DANS UN AUTRE FICHIER

local guildPanelButtonBackdrop =
{
    bgFile=nil,
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 40,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local GuildPanelButton = CreateFrame("Button", nil, GuildFrame, "BackdropTemplate")
GuildPanelButton:SetSize(40, 40)
GuildPanelButton:SetPoint("TOPRIGHT", 41, -350)
GuildPanelButton:SetNormalTexture("Interface\\AddOns\\GuildTools\\resources\\GuildTools_Logo_Background.png")
GuildPanelButton:SetPushedTexture("Interface\\AddOns\\GuildTools\\resources\\GuildTools_Logo_Background.png")
GuildPanelButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
GuildPanelButton:SetFrameLevel(98)
GuildPanelButton:SetScript('OnClick', function()
	GT_MainFrame:SetShown(not GT_MainFrame:IsShown())
end)

local borderFrame = CreateFrame("Frame", nil, GuildPanelButton, "BackdropTemplate")
borderFrame:SetPoint("TOPLEFT", -4, 4)
borderFrame:SetSize(48, 48)
borderFrame:SetBackdrop(guildPanelButtonBackdrop)
borderFrame:SetFrameLevel(99)

-- Allow to close frame with escape button
table.insert(UISpecialFrames, "GT_MainFrame")

GT_EventManager:AddEventListener("ADDON_READY", function()
    adminTab:SetShown(C_GuildInfo.CanEditOfficerNote()) --Show the tab if player has edit_officer_note flag
end)