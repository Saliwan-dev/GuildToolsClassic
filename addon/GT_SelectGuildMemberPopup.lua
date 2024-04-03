local backdropInfo =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 32,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

GT_SelectGuildMemberPopup = CreateFrame("Frame","GT_SelectGuildMemberPopup",UIParent,"BackdropTemplate")
GT_SelectGuildMemberPopup:SetWidth(320)
GT_SelectGuildMemberPopup:SetHeight(200)
GT_SelectGuildMemberPopup:SetBackdrop(backdropInfo)
GT_SelectGuildMemberPopup:SetPoint("CENTER", 0, 150)
GT_SelectGuildMemberPopup:SetFrameLevel(99)
GT_SelectGuildMemberPopup:EnableMouse(true)

GT_SelectGuildMemberPopup.closeButton = CreateFrame("Button", nil, GT_SelectGuildMemberPopup)
GT_SelectGuildMemberPopup.closeButton:SetSize(35, 35)
GT_SelectGuildMemberPopup.closeButton:SetPoint("TOPRIGHT", 4, 4)
GT_SelectGuildMemberPopup.closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
GT_SelectGuildMemberPopup.closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
GT_SelectGuildMemberPopup.closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
GT_SelectGuildMemberPopup.closeButton:SetScript('OnClick', function()
	GT_SelectGuildMemberPopup:Hide()
end)

GT_SelectGuildMemberPopup.title = GT_SelectGuildMemberPopup:CreateFontString()
GT_SelectGuildMemberPopup.title:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
GT_SelectGuildMemberPopup.title:SetPoint("TOP", 0, -10)
GT_SelectGuildMemberPopup.title:SetTextColor(1,1,1)

function GT_SelectGuildMemberPopup:SetTitle(newTitle)
    GT_SelectGuildMemberPopup.title:SetText(newTitle)
end

GT_SelectGuildMemberPopup.input = CreateFrame("EditBox", nil, GT_SelectGuildMemberPopup, "InputBoxTemplate");
GT_SelectGuildMemberPopup.input:SetSize(290, 1)
GT_SelectGuildMemberPopup.input:SetPoint("TOPLEFT", 15, -40)
GT_SelectGuildMemberPopup.input:SetScript("OnEscapePressed", function() GT_SelectGuildMemberPopup:Hide() end)
GT_SelectGuildMemberPopup:SetScript("OnShow", function()
    GT_SelectGuildMemberPopup.input:SetText("")
end)

function GT_SelectGuildMemberPopup:SetCallback(newCallback)
    self.callback = newCallback
end

GT_SelectGuildMemberPopup.nameFrames = {}
for nameFrameIndex = 1, 6 do 
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex] = CreateFrame("Frame",nil,GT_SelectGuildMemberPopup)
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex]:SetPoint("TOP", 0, -40 -(20*nameFrameIndex))
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex]:SetSize(290,15)
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text = GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex]:CreateFontString()
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text:SetPoint("LEFT", 25, 0)
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text:SetTextColor(1,1,1)
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text:SetText("")
	
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].selectButton = CreateFrame("Button", "AddRerollButton", GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex], "UIPanelButtonTemplate")
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].selectButton:SetSize(20, 20)
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].selectButton:SetPoint("LEFT")
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].selectButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].selectButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
	GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].selectButton:SetScript('OnClick', function()
		GT_SelectGuildMemberPopup:Hide()
		if GT_SelectGuildMemberPopup.callback ~= nil then
			GT_SelectGuildMemberPopup.callback(GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text:GetText())
		end
	end)
end

GT_SelectGuildMemberPopup.blacklist = {}

function GT_SelectGuildMemberPopup:SetBlacklist(newBlacklist)
    self.blacklist = newBlacklist
end

GT_SelectGuildMemberPopup.input:SetScript("OnTextChanged", function(self)
	local input = self:GetText()
	
	local matchingNames = {}
	
	if input ~= "" then
		for index, guildMember in ipairs(GT_Data.guildMembers) do
			if StartWith(string.lower(guildMember.name), string.lower(input))
			    and not IsInTable(GT_SelectGuildMemberPopup.blacklist, guildMember.name)
			then
				table.insert(matchingNames, guildMember.name)
			end
		end
	end
	
	for nameFrameIndex = 1, 6 do
		GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex].text:SetText(matchingNames[nameFrameIndex])
		if matchingNames[nameFrameIndex] == "" or matchingNames[nameFrameIndex] == nil then
			GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex]:Hide()
		else
			GT_SelectGuildMemberPopup.nameFrames[nameFrameIndex]:Show()
		end
	end
end) 

GT_SelectGuildMemberPopup:Hide()
