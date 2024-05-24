local monthLabelKeys = {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"}

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

GT_CreateEventFrame = CreateFrame("Frame", nil, GT_CalendarTabContent, "BackdropTemplate")
GT_CreateEventFrame:SetPoint("TOPLEFT", GT_CalendarTabContent, "TOPRIGHT", -(GT_MainFrame:GetWidth() - GT_CalendarFrame:GetWidth() - 3), 0)
GT_CreateEventFrame:SetSize(250, GT_MainFrame:GetHeight() - 33)
GT_CreateEventFrame:SetFrameLevel(99)
GT_CreateEventFrame:SetBackdrop(backdrop)

GT_CreateEventFrame.closeButton = CreateFrame("Button", nil, GT_CreateEventFrame)
GT_CreateEventFrame.closeButton:SetSize(35, 35)
GT_CreateEventFrame.closeButton:SetPoint("TOPRIGHT", 4, 4)
GT_CreateEventFrame.closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
GT_CreateEventFrame.closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
GT_CreateEventFrame.closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
GT_CreateEventFrame.closeButton:SetScript('OnClick', function()
	GT_CreateEventFrame:Hide()
end)

GT_CreateEventFrame.frameTitle = GT_UIFactory:CreateLocalizedLabel(GT_CreateEventFrame, 0, 0, "calendar.new.event.frame.title", 14, 1, 1, 1)
GT_CreateEventFrame.frameTitle:ClearAllPoints()
GT_CreateEventFrame.frameTitle:SetPoint("TOP", 0, -8)

GT_CreateEventFrame.titleLabel = GT_UIFactory:CreateLocalizedLabel(GT_CreateEventFrame, 5, -40, "calendar.new.event.title", 12, 1, 1, 1)

GT_CreateEventFrame.titleField = CreateFrame("EditBox", nil, GT_CreateEventFrame, "InputBoxTemplate")
GT_CreateEventFrame.titleField:SetSize(190, 12)
GT_CreateEventFrame.titleField:SetPoint("LEFT", GT_CreateEventFrame.titleLabel, "RIGHT", 10, 0)

GT_CreateEventFrame.dateLabel = GT_UIFactory:CreateLocalizedLabel(GT_CreateEventFrame, 5, -65, "calendar.new.event.date", 12, 1, 1, 1)

GT_CreateEventFrame.dateValue = GT_UIFactory:CreateLabel(GT_CreateEventFrame, 0, 0, "", 12, 1, 1, 1)
GT_CreateEventFrame.dateValue:ClearAllPoints()
GT_CreateEventFrame.dateValue:SetPoint("LEFT", GT_CreateEventFrame.dateLabel, "RIGHT", 5, 0)

GT_CreateEventFrame.hourLabel = GT_UIFactory:CreateLocalizedLabel(GT_CreateEventFrame, 5, -90, "calendar.new.event.hour", 12, 1, 1, 1)

GT_CreateEventFrame.hourField = CreateFrame("EditBox", nil, GT_CreateEventFrame, "InputBoxTemplate")
GT_CreateEventFrame.hourField:SetSize(50, 12)
GT_CreateEventFrame.hourField:SetPoint("LEFT", GT_CreateEventFrame.hourLabel, "RIGHT", 10, 0)

GT_CreateEventFrame.hourSeparator = GT_UIFactory:CreateLabel(GT_CreateEventFrame, 0, 0, ":", 12, 1, 1, 1)
GT_CreateEventFrame.hourSeparator:ClearAllPoints()
GT_CreateEventFrame.hourSeparator:SetPoint("LEFT", GT_CreateEventFrame.hourField, "RIGHT", 5, 0)

GT_CreateEventFrame.minuteField = CreateFrame("EditBox", nil, GT_CreateEventFrame, "InputBoxTemplate")
GT_CreateEventFrame.minuteField:SetSize(50, 12)
GT_CreateEventFrame.minuteField:SetPoint("LEFT", GT_CreateEventFrame.hourSeparator, "RIGHT", 10, 0)

GT_CreateEventFrame.descriptionLabel = GT_UIFactory:CreateLocalizedLabel(GT_CreateEventFrame, 5, -115, "calendar.new.event.description", 12, 1, 1, 1)

GT_CreateEventFrame.descriptionField = CreateFrame("ScrollFrame", nil, GT_CreateEventFrame, "InputScrollFrameTemplate");
GT_CreateEventFrame.descriptionField:SetSize(220, 150)
GT_CreateEventFrame.descriptionField:SetPoint("TOPLEFT", 15, -140)
GT_CreateEventFrame.descriptionField.EditBox:SetFontObject("ChatFontNormal")
GT_CreateEventFrame.descriptionField.EditBox:SetMaxLetters(255)
GT_CreateEventFrame.descriptionField.EditBox:SetWidth(220)

GT_CreateEventFrame.createButton = GT_UIFactory:CreateLocalizedButton(GT_CreateEventFrame, 100, 25, "calendar.new.event.create")
GT_CreateEventFrame.createButton:SetPoint("BOTTOM", 0, 8)

GT_CalendarFrame:AddDaySelectionListener(function(selectedDay)
    GT_CreateEventFrame.dateValue:SetText(selectedDay.monthDay.." "..GT_LocaleManager:GetLabel(monthLabelKeys[selectedDay.month]).." "..selectedDay.year)
end)

GT_CreateEventFrame:Hide()