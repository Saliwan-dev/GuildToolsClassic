local function SetCalendarTab()
    local calendarTab = _G["GT_MainFrameTab3"]

    PanelTemplates_SetTab(calendarTab:GetParent(), calendarTab:GetID())

    if calendarTab:GetParent().tabContentContainer.currentContent ~= nil then
        calendarTab:GetParent().tabContentContainer.currentContent:Hide()
    end

    calendarTab:GetParent().tabContentContainer.currentContent = calendarTab.content
    calendarTab:GetParent().tabContentContainer.currentContent:Show()
end

GameTimeFrame:SetScript("OnMouseUp", function (self, button)
    if button == "LeftButton" then
        GT_MainFrame:SetShown(not GT_MainFrame:IsShown())
        SetCalendarTab()
    end
end)