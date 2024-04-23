GT_UIFactory = {}

local uniquealyzer = 1;

function GT_UIFactory:CreateCheckbutton(parent, x_loc, y_loc, displayname)
	uniquealyzer = uniquealyzer + 1;

	local checkbutton = CreateFrame("CheckButton", "GT_Checkbutton_0" .. uniquealyzer, parent, "ChatConfigCheckButtonTemplate");
	checkbutton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkbutton:GetName() .. 'Text'):SetText(displayname);
	getglobal(checkbutton:GetName() .. 'Text'):SetPoint("TOPLEFT",25,-5);

	return checkbutton;
end

function GT_UIFactory:CreateLabel(parent,  x_loc, y_loc, text, fontSize, r, g, b)
    local label = parent:CreateFontString()
    label:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
    label:SetPoint("TOPLEFT", x_loc, y_loc)
    label:SetTextColor(r,g,b)
    label:SetText(text)

    return label
end

function GT_UIFactory:CreateLocalizedLabel(parent,  x_loc, y_loc, key, fontSize, r, g, b)
    local label = self:CreateLabel(parent,  x_loc, y_loc, "", fontSize, r, g, b)
    GT_LocaleManager:BindText(label, key)

    return label
end

local function Tab_OnClick(self)
    PanelTemplates_SetTab(self:GetParent(), self:GetID())

    if self:GetParent().tabContentContainer.currentContent ~= nil then
        self:GetParent().tabContentContainer.currentContent:Hide()
    end

    self:GetParent().tabContentContainer.currentContent = self.content
    self:GetParent().tabContentContainer.currentContent:Show()
end

function GT_UIFactory:AddTab(frame, tabName, content)
    if frame.numTabs == nil then
        frame.numTabs = 1
    else
        frame.numTabs = frame.numTabs + 1
    end

    if frame.tabContentContainer == nil then
        frame.tabContentContainer = CreateFrame("Frame", nil, frame)
        frame.tabContentContainer:SetAllPoints(frame)
    end

    local tabId = frame.numTabs
    local frameName = frame:GetName()

    local tab = CreateFrame("Button", frameName.."Tab"..tabId, frame, "CharacterFrameTabButtonTemplate")
    tab:SetID(tabId)
    tab:SetText(tabName)
    tab:SetScript("OnClick", Tab_OnClick)
    if tabId == 1 then
        tab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 2, 4)
    else
        tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(tabId - 1)], "TOPRIGHT", -14, 0)
    end

    tab.content = content
    tab.content:Hide()

    Tab_OnClick(_G[frameName.."Tab1"])

    return tab
end