local monthLabelKeys = {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"}

local selectedDay

local backdrop =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 4,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local eventBackdrop =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Rock",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

GT_CalendarActionFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CalendarActionFrame:SetPoint("TOPRIGHT", -8, 0)
GT_CalendarActionFrame:SetSize(GT_MainFrame:GetWidth() - GT_CalendarFrame:GetWidth() - 11, GT_MainFrame:GetHeight() - 33)
GT_CalendarActionFrame:SetBackdrop(backdrop)

local selectedDayLabel = GT_UIFactory:CreateLabel(GT_CalendarActionFrame,  0, 0, "", 12, 1, 1, 1)
selectedDayLabel:ClearAllPoints()
selectedDayLabel:SetPoint("TOP", 0, -12)

local createEventButton = GT_UIFactory:CreateLocalizedButton(GT_CalendarActionFrame, 120, 25, "calendar.new.event")
createEventButton:SetPoint("TOP", 0, -35)
createEventButton:SetScript('OnClick', function()
	GT_CreateEventFrame:Show()
end)
createEventButton:Hide()

local function ShowEvent(event, index)
    local eventFrame = CreateFrame("Frame", nil, GT_CalendarActionFrame, "BackdropTemplate")
    eventFrame:SetSize(127, 60)
    eventFrame:SetBackdrop(eventBackdrop)
    eventFrame:SetPoint("TOPLEFT", 3, -70 + (index - 1) * -65)

    eventFrame.title = GT_UIFactory:CreateLabel(eventFrame, 0, 0, event.title, 12, 1, 0.8, 0)
    eventFrame.title:ClearAllPoints()
    eventFrame.title:SetPoint("TOP", 0, -8)
    eventFrame.title:SetSize(115, 40)

    eventFrame:SetScript("OnMouseDown", function()
        GT_EventManager:PublishEvent("CALENDAR_EVENT_SELECTED", event)
    end)
end

function GT_CalendarActionFrame:SetSelectedDay(newSelectedDay)
    selectedDay = newSelectedDay

    selectedDayLabel:SetText(selectedDay.monthDay.." "..GT_LocaleManager:GetLabel(monthLabelKeys[selectedDay.month]).." "..selectedDay.year)

    for index, event in ipairs(GT_CalendarService:GetEventsForDay(selectedDay)) do
        ShowEvent(event, index)
    end

    createEventButton:Show()
end