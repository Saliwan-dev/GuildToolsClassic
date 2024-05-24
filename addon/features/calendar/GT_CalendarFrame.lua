local monthLabelKeys = {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"}

for key, value in pairs(C_DateAndTime) do
    print(key)
end

local selectedMonth = C_DateAndTime.GetCurrentCalendarTime().month;
local selectedYear = C_DateAndTime.GetCurrentCalendarTime().year;
local selectedDayHighlightFrame = nil

-- INIT IHM

local calendarHeaderBackdrop =
{
    bgFile="Interface\\AddOns\\GuildTools\\resources\\textures\\CALENDARBACKGROUND_HEADER.PNG",
 	tile = true,
 	tileSize = 104,
 	insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

local GT_CalendarHeaderFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CalendarHeaderFrame:SetPoint("TOPLEFT", 2, -30)
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

GT_CalendarFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CalendarFrame:SetPoint("BOTTOMLEFT", 2, 35)
GT_CalendarFrame:SetSize(GT_MainFrame:GetWidth() - 146, GT_MainFrame:GetHeight() - GT_MainFrame_Title:GetHeight() - 53)
GT_CalendarFrame:SetBackdrop(calendarBackdrop)

local shadowFrames = {}
for calendarPosition = 0, 41 do
    local shadowFrame = CreateFrame("Frame", nil, GT_CalendarFrame)
    shadowFrame:SetPoint("TOPLEFT", (calendarPosition % 7) * 58, -math.floor(calendarPosition / 7) * 58)
    shadowFrame:SetSize(58, 58)
    shadowFrame.tex = shadowFrame:CreateTexture()
    shadowFrame.tex:SetAllPoints(true)
    shadowFrame.tex:SetColorTexture(0, 0, 0, 0.5)

    shadowFrames[calendarPosition] = shadowFrame
end

local highlightFrames = {}
for calendarPosition = 0, 41 do
    local highlightFrame = CreateFrame("Frame", nil, GT_CalendarFrame)
    highlightFrame:SetPoint("TOPLEFT", (calendarPosition % 7) * 58, -math.floor(calendarPosition / 7) * 58)
    highlightFrame:SetSize(58, 58)
    highlightFrame.tex = highlightFrame:CreateTexture()
    highlightFrame.tex:SetPoint("CENTER", 0, 0)
    highlightFrame.tex:SetSize(58, 58)
    highlightFrame.tex:SetTexCoord(0, 0.34, 0, 0.68)

    highlightFrame:SetScript("OnEnter", function() highlightFrame.tex:SetTexture("Interface\\Calendar\\Highlights.PNG") end)
    highlightFrame:SetScript("OnLeave", function(self)
        if self ~= selectedDayHighlightFrame then
            highlightFrame.tex:SetTexture(nil)
        end
    end)

    highlightFrames[calendarPosition] = highlightFrame
end

local dayNumberLabels = {}
for calendarPosition = 0, 41 do
    dayNumberLabels[calendarPosition] = GT_UIFactory:CreateLabel(GT_CalendarFrame, (calendarPosition % 7) * 58 + 7, -math.floor(calendarPosition / 7) * 58 - 7, calendarPosition, 9, 1, 1, 1)
end

local currentDayFrame = CreateFrame("Frame", nil, GT_CalendarFrame)
currentDayFrame:SetSize(58, 58)
currentDayFrame:SetFrameLevel(99)
currentDayFrame.tex = currentDayFrame:CreateTexture()
currentDayFrame.tex:SetPoint("CENTER", -3, 5)
currentDayFrame.tex:SetSize(90, 90)
currentDayFrame.tex:SetTexture("Interface\\Calendar\\CurrentDay.PNG")
currentDayFrame.tex:SetTexCoord(0, 0.55, 0, 0.55)

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

local monthFrame = CreateFrame("Frame", nil, GT_CalendarFrame, "BackdropTemplate")
monthFrame:SetPoint("TOP", 0, 48)
monthFrame:SetSize(160, 30)
monthFrame:SetBackdrop(backdrop)

local monthLabel = GT_UIFactory:CreateLabel(monthFrame, 0, 0, "Septembre 2024", 14, 1, 0.8, 0)
monthLabel:ClearAllPoints()
monthLabel:SetPoint("CENTER")

-- SET MONTH

local function SetMonth(month, year)
    monthLabel:SetText(GT_LocaleManager:GetLabel(monthLabelKeys[month]).." "..year)

    local firstDay = GT_DateUtils:GetFirstDayOf(month, year)

    local firstWeekday = firstDay.weekday - 2
    if firstWeekday == -1 then firstWeekday = 6 end

    -- On cherche le nombre de jours dans le mois

    local currentMonthNumberDay = GT_DateUtils:NumberOfDaysInMonth(month, year)

    local previousMonth, previousYear = GT_DateUtils:GetPreviousMonth(month, year)

    local previousMonthNumberDay = GT_DateUtils:NumberOfDaysInMonth(previousMonth, previousYear)

    local nextMonthVisibleDays = 42 - currentMonthNumberDay - firstWeekday

    for calendarPosition = 0, 41 do
        local dayNumber = 0
        if calendarPosition < firstWeekday then
            dayNumber = previousMonthNumberDay - (firstWeekday - calendarPosition) + 1
        elseif calendarPosition < firstWeekday + currentMonthNumberDay then
            dayNumber = calendarPosition - firstWeekday + 1
        else
            dayNumber = calendarPosition - firstWeekday - currentMonthNumberDay + 1
        end

        dayNumberLabels[calendarPosition]:SetText(dayNumber)
    end

    local otherMonthDaysShadows = {}
    for calendarPosition = 0, 41 do
        shadowFrames[calendarPosition]:SetShown(calendarPosition < firstWeekday or calendarPosition >= firstWeekday + currentMonthNumberDay)
    end

    for calendarPosition = 0, 41 do
        highlightFrames[calendarPosition]:SetScript("OnMouseUp", function(self)
            local selectedDay = C_DateAndTime.AdjustTimeByDays(firstDay, calendarPosition - firstWeekday)
            GT_CalendarFrame:notifyDaySelection(selectedDay)
            GT_CalendarActionFrame:SetSelectedDay(selectedDay)
            if selectedDayHighlightFrame ~= nil then selectedDayHighlightFrame.tex:SetTexture(nil) end
            selectedDayHighlightFrame = self
        end)
    end

    local now = C_DateAndTime.GetCurrentCalendarTime()
    if now.month == month and now.year == year then
        local currentDayWithOffset = now.monthDay + firstWeekday - 1
        currentDayFrame:ClearAllPoints()
        currentDayFrame:SetPoint("TOPLEFT", (currentDayWithOffset % 7) * 58, -math.floor(currentDayWithOffset / 7) * 58)
        currentDayFrame:Show()
    else
        currentDayFrame:Hide()
    end
end

SetMonth(selectedMonth, selectedYear)

local nextMonthButton = CreateFrame("Button", nil, monthFrame, "UIPanelButtonTemplate")
nextMonthButton:SetSize(20, 20)
nextMonthButton:SetPoint("LEFT", monthFrame, "RIGHT", 5, 0)
nextMonthButton:SetNormalTexture("Interface\\Glues\\COMMON\\Glue-RightArrow-Button-Up.PNG")
nextMonthButton:SetPushedTexture("Interface\\Glues\\COMMON\\Glue-RightArrow-Button-Down.PNG")
nextMonthButton:SetScript('OnClick', function()
	if selectedMonth < 12 then
        selectedMonth = selectedMonth + 1
    else
        selectedMonth = 1
        selectedYear = selectedYear + 1
    end
	SetMonth(selectedMonth, selectedYear)
end)

local previousMonthButton = CreateFrame("Button", nil, monthFrame, "UIPanelButtonTemplate")
previousMonthButton:SetSize(20, 20)
previousMonthButton:SetPoint("RIGHT", monthFrame, "LEFT", -5, 0)
previousMonthButton:SetNormalTexture("Interface\\Glues\\COMMON\\Glue-LeftArrow-Button-Up.PNG")
previousMonthButton:SetPushedTexture("Interface\\Glues\\COMMON\\Glue-LeftArrow-Button-Down.PNG")
previousMonthButton:SetScript('OnClick', function()
	if selectedMonth > 1 then
        selectedMonth = selectedMonth - 1
    else
        selectedMonth = 12
        selectedYear = selectedYear - 1
    end
	SetMonth(selectedMonth, selectedYear)
end)

GT_CalendarFrame.daySelectionListeners = {}
function GT_CalendarFrame:AddDaySelectionListener(listener)
    table.insert(GT_CalendarFrame.daySelectionListeners, listener)
end

function GT_CalendarFrame:notifyDaySelection(selectedDay)
    for index, listener in ipairs(GT_CalendarFrame.daySelectionListeners) do
        listener(selectedDay)
    end
end