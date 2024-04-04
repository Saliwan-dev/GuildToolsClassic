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

GT_AdminPanel = CreateFrame("Frame", nil, GT_AdminTabContent, "BackdropTemplate")
GT_AdminPanel:SetPoint("TOPLEFT")
GT_AdminPanel:SetSize(GT_AdminTabContent:GetWidth() - 8, GT_AdminTabContent:GetHeight() - 32)
GT_AdminPanel:SetBackdrop(backdrop)

GT_AdminPanel.bankCharLabel = GT_UIFactory:CreateLabel(GT_AdminPanel, 10, -10, "", 12, 1, 0.8, 0)
GT_LocaleManager:BindText(GT_AdminPanel.bankCharLabel, "adminpanel.bankcharlabel")

local function ShowAddBankPopup()
    GT_SelectGuildMemberPopup:SetTitle(GT_LocaleManager:GetLabel("addBankCharPopup.title"))
    GT_SelectGuildMemberPopup:SetBlacklist(GT_BankService:GetBankChars())
    GT_SelectGuildMemberPopup:SetCallback(function(newBankName)
        GT_BankService:AddBankChar(newBankName)
        GT_AdminPanel:Update()
    end)
    GT_SelectGuildMemberPopup:Show()
end

GT_AdminPanel.addBankButton = CreateFrame("Button", nil, GT_AdminPanel, "UIPanelButtonTemplate")
GT_AdminPanel.addBankButton:SetSize(20, 20)
GT_AdminPanel.addBankButton:SetPoint("LEFT", GT_AdminPanel.bankCharLabel, "RIGHT", 10, 0)
GT_AdminPanel.addBankButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
GT_AdminPanel.addBankButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
GT_AdminPanel.addBankButton:SetScript('OnClick', function()
	ShowAddBankPopup()
end)

GT_AdminPanel.bankCharFrames = {}

function clearBankCharFrames()
	for index, bankCharFrame in ipairs(GT_AdminPanel.bankCharFrames) do
		bankCharFrame:Hide()
	end
end

function GT_AdminPanel:Update()
	clearBankCharFrames()

    local bankCharNames = GT_BankService:GetBankChars()

	if bankCharNames ~= nil then
		for index, bankCharName in ipairs(bankCharNames) do
			if GT_AdminPanel.bankCharFrames[index] == nil then
				GT_AdminPanel.bankCharFrames[index] = CreateFrame("Frame", nil, GT_AdminPanel)
				GT_AdminPanel.bankCharFrames[index]:SetSize(120, 15)
				GT_AdminPanel.bankCharFrames[index]:SetPoint("TOPLEFT", 10, -15 - (15* index))
				GT_AdminPanel.bankCharFrames[index].text = GT_AdminPanel.bankCharFrames[index]:CreateFontString()
				GT_AdminPanel.bankCharFrames[index].text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
				GT_AdminPanel.bankCharFrames[index].text:SetPoint("LEFT", 25, 0)
				GT_AdminPanel.bankCharFrames[index].text:SetTextColor(1,1,1)
				GT_AdminPanel.bankCharFrames[index].removeButton = CreateFrame("Button", nil, GT_AdminPanel.bankCharFrames[index], "UIPanelButtonTemplate")
				GT_AdminPanel.bankCharFrames[index].removeButton:SetSize(20, 20)
				GT_AdminPanel.bankCharFrames[index].removeButton:SetPoint("LEFT")
				GT_AdminPanel.bankCharFrames[index].removeButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
				GT_AdminPanel.bankCharFrames[index].removeButton:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")

			end

			GT_AdminPanel.bankCharFrames[index].text:SetText(bankCharName)
			GT_AdminPanel.bankCharFrames[index].removeButton:SetScript('OnClick', function()
                GT_BankService:RemoveBankChar(bankCharName)
                self:Update()
            end)
            GT_AdminPanel.bankCharFrames[index]:Show()
		end
	end
end

GT_AdminPanel:SetScript("OnShow", function() GT_AdminPanel:Update() end)