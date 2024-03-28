local backdropInfo =
{
    bgFile="Interface/FrameGeneral/UI-Background-Rock",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local GT_MainFrame = CreateFrame("Frame", "GT_MainFrame", UIParent, "BackdropTemplate")
GT_MainFrame:SetPoint("CENTER", 0, 80)
GT_MainFrame:SetSize(550, 400)
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
--GuildPanelButton:SetPoint("TOPLEFT", 60, -20)
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

table.insert(UISpecialFrames, "GT_MainFrame")