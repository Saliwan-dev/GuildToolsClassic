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

GT_CalendarActionFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CalendarActionFrame:SetPoint("TOPRIGHT", -8, 0)
GT_CalendarActionFrame:SetSize(GT_MainFrame:GetWidth() - GT_CalendarFrame:GetWidth() - 11, GT_MainFrame:GetHeight() - 33)
GT_CalendarActionFrame:SetBackdrop(backdrop)

local selectedDayLabel = GT_UIFactory:CreateLabel(GT_CalendarActionFrame,  0, 0, "", 12, 1, 1, 1)
selectedDayLabel:ClearAllPoints()
selectedDayLabel:SetPoint("TOP", 0, -12)

function GT_CalendarActionFrame:SetSelectedDay(newSelectedDay)
    selectedDay = newSelectedDay

    selectedDayLabel:SetText(selectedDay.monthDay.." "..GT_LocaleManager:GetLabel(monthLabelKeys[selectedDay.month]).." "..selectedDay.year)
end