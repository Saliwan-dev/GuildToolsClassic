local backdrop =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local GT_EventDetailFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_EventDetailFrame:SetSize(200, GT_CalendarTabContent:GetHeight() - 25)
GT_EventDetailFrame:SetPoint("TOPLEFT", GT_CalendarTabContent, "TOPRIGHT", -11, 2)
GT_EventDetailFrame:SetBackdrop(backdrop)

local closeButton = CreateFrame("Button", nil, GT_EventDetailFrame)
closeButton:SetSize(35, 35)
closeButton:SetPoint("TOPRIGHT", 4, 4)
closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
closeButton:SetScript('OnClick', function()
	GT_EventDetailFrame:Hide()
end)

GT_EventDetailFrame.title = GT_UIFactory:CreateLabel(GT_EventDetailFrame, 0, 0, "", 12, 1, 0.8, 0)
GT_EventDetailFrame.title:ClearAllPoints()
GT_EventDetailFrame.title:SetPoint("TOP", 0, -15)
GT_EventDetailFrame.title:SetWidth(180)

GT_EventDetailFrame.description = GT_UIFactory:CreateLabel(GT_EventDetailFrame, 10, -30, "", 12, 1, 1, 1)
GT_EventDetailFrame.description:SetWidth(180)
GT_EventDetailFrame.description:SetJustifyH("LEFT");

GT_EventDetailFrame:Hide()

local function SetEvent(event)
    GT_EventDetailFrame.title:SetText(event.title)

    GT_EventDetailFrame.description:SetText(event.description)
    GT_EventDetailFrame.description:ClearAllPoints()
    GT_EventDetailFrame.description:SetPoint("TOPLEFT", 10, -25 -GT_EventDetailFrame.title:GetHeight())
end

GT_EventManager:AddEventListener("CALENDAR_EVENT_SELECTED", function(event)
    SetEvent(event)

    GT_EventDetailFrame:Show()
end)