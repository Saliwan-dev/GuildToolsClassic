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

GT_AdminPanel = CreateFrame("Frame", "GT_AdminPanel", GT_AdminTabContent)
GT_AdminPanel:SetPoint("TOPLEFT", 0, -30)
GT_AdminPanel:SetSize(GT_AdminTabContent:GetWidth() - 8, GT_AdminTabContent:GetHeight() - 62)

local banksAdminPanel = CreateFrame("Frame", nil, GT_AdminPanel, "BackdropTemplate")
banksAdminPanel:SetPoint("TOPLEFT")
banksAdminPanel:SetSize(GT_AdminPanel:GetWidth(), GT_AdminPanel:GetHeight())
banksAdminPanel:SetBackdrop(backdrop)

banksAdminPanel.bankCharLabel = GT_UIFactory:CreateLabel(banksAdminPanel, 10, -10, "", 12, 1, 0.8, 0)
GT_LocaleManager:BindText(banksAdminPanel.bankCharLabel, "adminpanel.bankcharlabel")

local function ShowAddBankPopup()
    GT_SelectGuildMemberPopup:SetTitle(GT_LocaleManager:GetLabel("addBankCharPopup.title"))
    GT_SelectGuildMemberPopup:SetBlacklist(GT_BankService:GetBankChars())
    GT_SelectGuildMemberPopup:SetCallback(function(newBankName)
        GT_BankService:AddBankChar(newBankName)
        banksAdminPanel:Update()
    end)
    GT_SelectGuildMemberPopup:Show()
end

banksAdminPanel.addBankButton = CreateFrame("Button", nil, banksAdminPanel, "UIPanelButtonTemplate")
banksAdminPanel.addBankButton:SetSize(20, 20)
banksAdminPanel.addBankButton:SetPoint("LEFT", banksAdminPanel.bankCharLabel, "RIGHT", 10, 0)
banksAdminPanel.addBankButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
banksAdminPanel.addBankButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
banksAdminPanel.addBankButton:SetScript('OnClick', function()
	ShowAddBankPopup()
end)

banksAdminPanel.bankCharFrames = {}

function clearBankCharFrames()
	for index, bankCharFrame in ipairs(banksAdminPanel.bankCharFrames) do
		bankCharFrame:Hide()
	end
end

function banksAdminPanel:Update()
	clearBankCharFrames()

    local bankCharNames = GT_BankService:GetBankChars()

	if bankCharNames ~= nil then
		for index, bankCharName in ipairs(bankCharNames) do
			if banksAdminPanel.bankCharFrames[index] == nil then
				banksAdminPanel.bankCharFrames[index] = CreateFrame("Frame", nil, banksAdminPanel)
				banksAdminPanel.bankCharFrames[index]:SetSize(120, 15)
				banksAdminPanel.bankCharFrames[index]:SetPoint("TOPLEFT", 10, -15 - (15* index))
				banksAdminPanel.bankCharFrames[index].text = banksAdminPanel.bankCharFrames[index]:CreateFontString()
				banksAdminPanel.bankCharFrames[index].text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
				banksAdminPanel.bankCharFrames[index].text:SetPoint("LEFT", 25, 0)
				banksAdminPanel.bankCharFrames[index].text:SetTextColor(1,1,1)
				banksAdminPanel.bankCharFrames[index].removeButton = CreateFrame("Button", nil, banksAdminPanel.bankCharFrames[index], "UIPanelButtonTemplate")
				banksAdminPanel.bankCharFrames[index].removeButton:SetSize(20, 20)
				banksAdminPanel.bankCharFrames[index].removeButton:SetPoint("LEFT")
				banksAdminPanel.bankCharFrames[index].removeButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
				banksAdminPanel.bankCharFrames[index].removeButton:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")

			end

			banksAdminPanel.bankCharFrames[index].text:SetText(bankCharName)
			banksAdminPanel.bankCharFrames[index].removeButton:SetScript('OnClick', function()
                GT_BankService:RemoveBankChar(bankCharName)
                self:Update()
            end)
            banksAdminPanel.bankCharFrames[index]:Show()
		end
	end
end

banksAdminPanel:SetScript("OnShow", function() banksAdminPanel:Update() end)

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

    local tab = CreateFrame("Button", frameName.."Tab"..tabId, frame, "TabButtonTemplate")
    tab:SetID(tabId)
    tab:SetText(tabName)
    PanelTemplates_TabResize(tab, 0);
    tab:SetWidth(tab:GetTextWidth() + 31);
    tab:SetScript("OnClick", Tab_OnClick)
    tab:SetFrameLevel(99)
    if tabId == 1 then
        tab:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 2, 0)
    else
        tab:SetPoint("BOTTOMLEFT", _G[frameName.."Tab"..(tabId - 1)], "BOTTOMRIGHT", 4, 0)
    end

    tab.content = content
    tab.content:Hide()

    Tab_OnClick(_G[frameName.."Tab1"])

    return tab
end

local bankAdminTab = GT_UIFactory:AddTab(GT_AdminPanel, GT_LocaleManager:GetLabel("adminframe.tabs.bank"), banksAdminPanel)
GT_LocaleManager:BindText(bankAdminTab, "adminframe.tabs.bank")