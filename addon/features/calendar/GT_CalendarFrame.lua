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

local monthFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
monthFrame:SetPoint("LEFT", 10, 0)
monthFrame:SetSize(120, 30)
monthFrame:SetBackdrop(backdrop)

local monthLabel = GT_UIFactory:CreateLabel(monthFrame, 0, 0, "Septembre", 14, 1, 0.8, 0)
monthLabel:ClearAllPoints()
monthLabel:SetPoint("CENTER")

local calendarHeaderBackdrop =
{
    bgFile="Interface\\AddOns\\GuildTools\\resources\\textures\\CALENDARBACKGROUND_HEADER.PNG",
 	tile = true,
 	tileSize = 104,
 	insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

local GT_CalendarHeaderFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CalendarHeaderFrame:SetPoint("TOPRIGHT", -12, 0)
GT_CalendarHeaderFrame:SetSize(GT_MainFrame:GetWidth() - 146, 23)
GT_CalendarHeaderFrame:SetBackdrop(calendarHeaderBackdrop)

local dayKeys = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }
for dayIndex, dayKey in ipairs(dayKeys) do
    local dayHeaderFrame = CreateFrame("Frame", nil, GT_CalendarHeaderFrame)
    dayHeaderFrame:SetSize(GT_CalendarHeaderFrame:GetWidth() / 7, 23)
    dayHeaderFrame:SetPoint("LEFT", (dayIndex - 1) * (GT_CalendarHeaderFrame:GetWidth() / 7), 0)

    local dayLabel = GT_UIFactory:CreateLocalizedLabel(dayHeaderFrame, 0, 0, dayKey, 9, 1, 1, 1)
    dayLabel:ClearAllPoints()
    dayLabel:SetPoint("CENTER", 0, 1)
end

local calendarBackdrop =
{
    bgFile="Interface\\AddOns\\GuildTools\\resources\\textures\\CALENDARBACKGROUND.PNG",
 	tile = true,
 	tileSize = 104,
 	insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

local GT_CalendarFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CalendarFrame:SetPoint("BOTTOMRIGHT", -12, 35)
GT_CalendarFrame:SetSize(GT_MainFrame:GetWidth() - 146, GT_MainFrame:GetHeight() - GT_MainFrame_Title:GetHeight() - 23)
GT_CalendarFrame:SetBackdrop(calendarBackdrop)

local date = C_DateAndTime.GetCurrentCalendarTime();
local weekday = date.weekday - 2
if weekday == -1 then weekday = 6 end

-- On cherche le jour de la semaine du premier jour du mois

local weekday1 = (weekday - (date.monthDay - 1)) % 7
while weekday1 < 0 do
    weekday1 = weekday1 + 7
end

weekday1 = 2

-- On cherche le nombre de jours dans le mois

local currentMonthNumberDay = GT_DateUtils:NumberOfDaysInMonth(date.month, date.year)

local previousMonth
if date.month == 1 then previousMonth = 12 else previousMonth = date.month - 1 end

local previousMonthNumberDay = GT_DateUtils:NumberOfDaysInMonth(previousMonth, date.year - 1)

-- Nombre de jours à compléter

local nextMonthVisibleDays = 42 - currentMonthNumberDay - weekday1

-- IHM

for calendarPosition = 0, 41 do
    local dayNumber = 0
    if calendarPosition < weekday1 then
        dayNumber = previousMonthNumberDay - (weekday1 - calendarPosition) + 1
    elseif calendarPosition < weekday1 + currentMonthNumberDay then
        dayNumber = calendarPosition - weekday1 + 1
    else
        dayNumber = calendarPosition - weekday1 - currentMonthNumberDay + 1
    end

    GT_UIFactory:CreateLabel(GT_CalendarFrame, (calendarPosition % 7) * 58 + 7, -math.floor(calendarPosition / 7) * 58 - 7, tostring(dayNumber), 9, 1, 1, 1)
end

local otherMonthDaysShadows = {}
for calendarPosition = 0, 41 do
    local shadowFrame = CreateFrame("Frame", nil, GT_CalendarFrame)
    shadowFrame:SetPoint("TOPLEFT", (calendarPosition % 7) * 58, -math.floor(calendarPosition / 7) * 58)
    shadowFrame:SetSize(58, 58)
    shadowFrame.tex = shadowFrame:CreateTexture()
    shadowFrame.tex:SetAllPoints(true)
    shadowFrame.tex:SetColorTexture(0, 0, 0, 0.5)

    shadowFrame:SetShown(calendarPosition < weekday1 or calendarPosition >= weekday1 + currentMonthNumberDay)
end

local currentDayWithOffset = date.monthDay + weekday1 - 1
local currentDayFrame = CreateFrame("Frame", nil, GT_CalendarFrame)
currentDayFrame:SetPoint("TOPLEFT", (currentDayWithOffset % 7) * 58, -math.floor(currentDayWithOffset / 7) * 58)
currentDayFrame:SetSize(58, 58)
currentDayFrame:SetFrameLevel(99)
currentDayFrame.tex = currentDayFrame:CreateTexture()
currentDayFrame.tex:SetPoint("CENTER", -3, 5)
currentDayFrame.tex:SetSize(90, 90)
currentDayFrame.tex:SetTexture("Interface\\Calendar\\CurrentDay.PNG")
currentDayFrame.tex:SetTexCoord(0, 0.55, 0, 0.55)