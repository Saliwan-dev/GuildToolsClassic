local monthLabelKeys = {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"}

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

GT_EventDetailFrame.creatorLabel = GT_UIFactory:CreateLocalizedLabel(GT_EventDetailFrame,0, 0, "calendar.event.label.creator", 12, 0.7, 0.7, 0.7)
GT_EventDetailFrame.creatorLabel:ClearAllPoints()
GT_EventDetailFrame.creatorLabel:SetPoint("TOPLEFT", GT_EventDetailFrame.title, "BOTTOMLEFT", 0, -10)

GT_EventDetailFrame.creatorValue = GT_UIFactory:CreateLabel(GT_EventDetailFrame, 0, 0, "", 12, 1, 1, 1)
GT_EventDetailFrame.creatorValue:ClearAllPoints()
GT_EventDetailFrame.creatorValue:SetPoint("LEFT", GT_EventDetailFrame.creatorLabel, "RIGHT", 2, 0)

GT_EventDetailFrame.dateLabel = GT_UIFactory:CreateLocalizedLabel(GT_EventDetailFrame, 0, 0, "calendar.event.label.date", 12, 0.7, 0.7, 0.7)
GT_EventDetailFrame.dateLabel:ClearAllPoints()
GT_EventDetailFrame.dateLabel:SetPoint("TOPLEFT", GT_EventDetailFrame.creatorLabel, "BOTTOMLEFT", 0, -10)

GT_EventDetailFrame.dateValue = GT_UIFactory:CreateLabel(GT_EventDetailFrame, 0, 0, "", 12, 1, 1, 1)
GT_EventDetailFrame.dateValue:ClearAllPoints()
GT_EventDetailFrame.dateValue:SetPoint("LEFT", GT_EventDetailFrame.dateLabel, "RIGHT", 2, 0)

GT_EventDetailFrame.hourLabel = GT_UIFactory:CreateLocalizedLabel(GT_EventDetailFrame, 0, 0, "calendar.event.label.hour", 12, 0.7, 0.7, 0.7)
GT_EventDetailFrame.hourLabel:ClearAllPoints()
GT_EventDetailFrame.hourLabel:SetPoint("TOPLEFT", GT_EventDetailFrame.dateLabel, "BOTTOMLEFT", 0, -10)

GT_EventDetailFrame.hourValue = GT_UIFactory:CreateLabel(GT_EventDetailFrame, 0, 0, "", 12, 1, 1, 1)
GT_EventDetailFrame.hourValue:ClearAllPoints()
GT_EventDetailFrame.hourValue:SetPoint("LEFT", GT_EventDetailFrame.hourLabel, "RIGHT", 2, 0)

GT_EventDetailFrame.description = GT_UIFactory:CreateLabel(GT_EventDetailFrame, 10, -30, "", 12, 1, 1, 1)
GT_EventDetailFrame.description:SetWidth(180)
GT_EventDetailFrame.description:SetJustifyH("LEFT");
GT_EventDetailFrame.description:ClearAllPoints()
GT_EventDetailFrame.description:SetPoint("TOPLEFT", GT_EventDetailFrame.hourLabel, "BOTTOMLEFT", 0, -10)

GT_EventDetailFrame:Hide()

local function SetEvent(event)
    GT_EventDetailFrame.title:SetText(event.title)

    GT_EventDetailFrame.creatorValue:SetText(event.creator)

    GT_EventDetailFrame.dateValue:SetText(event.date.monthDay.." "..GT_LocaleManager:GetLabel(monthLabelKeys[event.date.month]).." "..event.date.year)

    local minutePre0 = "0"
    if event.date.minute >= 10 then minutePre0 = "" end

    GT_EventDetailFrame.hourValue:SetText(event.date.hour.." : "..minutePre0..event.date.minute)

    GT_EventDetailFrame.description:SetText(event.description)
end

GT_EventManager:AddEventListener("CALENDAR_EVENT_SELECTED", function(event)
    SetEvent(event)

    GT_EventDetailFrame:Show()
end)