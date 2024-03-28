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

GT_AddRerollPopup = CreateFrame("Frame","GT_AddRerollPopup",UIParent,"BackdropTemplate")
GT_AddRerollPopup:SetWidth(320)
GT_AddRerollPopup:SetHeight(200)
GT_AddRerollPopup:SetBackdrop(backdropInfo)
GT_AddRerollPopup:SetPoint("CENTER", 0, 150)
GT_AddRerollPopup:SetFrameLevel(99)
GT_AddRerollPopup:EnableMouse(true)

GT_AddRerollPopup.mainName = ""

GT_AddRerollPopup.closeButton = CreateFrame("Button", nil, GT_AddRerollPopup)
GT_AddRerollPopup.closeButton:SetSize(35, 35)
GT_AddRerollPopup.closeButton:SetPoint("TOPRIGHT", 4, 4)
GT_AddRerollPopup.closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
GT_AddRerollPopup.closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
GT_AddRerollPopup.closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
GT_AddRerollPopup.closeButton:SetScript('OnClick', function()
	GT_AddRerollPopup:Hide()
end)

GT_AddRerollPopup.title = GT_AddRerollPopup:CreateFontString()
GT_AddRerollPopup.title:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
GT_AddRerollPopup.title:SetPoint("TOP", 0, -10)
GT_AddRerollPopup.title:SetTextColor(1,1,1)

GT_AddRerollPopup.input = CreateFrame("EditBox", nil, GT_AddRerollPopup, "InputBoxTemplate");
GT_AddRerollPopup.input:SetSize(290, 1)
GT_AddRerollPopup.input:SetPoint("TOPLEFT", 15, -40)
GT_AddRerollPopup.input:SetScript("OnEscapePressed", function() GT_AddRerollPopup:Hide() end)
GT_AddRerollPopup:SetScript("OnShow", function()
    GT_AddRerollPopup.title:SetText("Ajout d'un reroll à "..GT_AddRerollPopup.mainName)
    GT_AddRerollPopup.input:SetText("")
end)

GT_AddRerollPopup.nameFrames = {}
for nameFrameIndex = 1, 6 do 
	GT_AddRerollPopup.nameFrames[nameFrameIndex] = CreateFrame("Frame",nil,GT_AddRerollPopup)
	GT_AddRerollPopup.nameFrames[nameFrameIndex]:SetPoint("TOP", 0, -40 -(20*nameFrameIndex))
	GT_AddRerollPopup.nameFrames[nameFrameIndex]:SetSize(290,15)
	GT_AddRerollPopup.nameFrames[nameFrameIndex].text = GT_AddRerollPopup.nameFrames[nameFrameIndex]:CreateFontString()
	GT_AddRerollPopup.nameFrames[nameFrameIndex].text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	GT_AddRerollPopup.nameFrames[nameFrameIndex].text:SetPoint("LEFT", 25, 0)
	GT_AddRerollPopup.nameFrames[nameFrameIndex].text:SetTextColor(1,1,1)
	GT_AddRerollPopup.nameFrames[nameFrameIndex].text:SetText("")
	
	GT_AddRerollPopup.nameFrames[nameFrameIndex].addRerollButton = CreateFrame("Button", "AddRerollButton", GT_AddRerollPopup.nameFrames[nameFrameIndex], "UIPanelButtonTemplate")
	GT_AddRerollPopup.nameFrames[nameFrameIndex].addRerollButton:SetSize(20, 20)
	GT_AddRerollPopup.nameFrames[nameFrameIndex].addRerollButton:SetPoint("LEFT")
	GT_AddRerollPopup.nameFrames[nameFrameIndex].addRerollButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
	GT_AddRerollPopup.nameFrames[nameFrameIndex].addRerollButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
	GT_AddRerollPopup.nameFrames[nameFrameIndex].addRerollButton:SetScript('OnClick', function()
		GT_AddRerollPopup:Hide()
		if GT_AddRerollPopup.addRerollCallback ~= nil then
			GT_AddRerollPopup.addRerollCallback(GT_AddRerollPopup.nameFrames[nameFrameIndex].text:GetText())
		end
	end)
end


GT_AddRerollPopup.input:SetScript("OnTextChanged", function(self)
	local input = self:GetText()
	
	local matchingNames = {}
	
	if input ~= "" then
		for index, guildMember in ipairs(GT_Data.guildMembers) do
			if StartWith(string.lower(guildMember.name), string.lower(input))
			    and not GT_RerollService:IsAReroll(guildMember.name) -- On ne peut pas ajouter un perso qui est déjà un reroll
			    and next(GT_RerollService:GetRerolls(guildMember.name)) == nil -- On ne peut pas ajouter un perso qui a déjà des rerolls
			    and guildMember.name ~= GT_AddRerollPopup.mainName -- On ne peut pas ajouter un perso en reroll à lui même
			then
				table.insert(matchingNames, guildMember.name)
			end
		end
	end
	
	for nameFrameIndex = 1, 6 do
		GT_AddRerollPopup.nameFrames[nameFrameIndex].text:SetText(matchingNames[nameFrameIndex])
		if matchingNames[nameFrameIndex] == "" or matchingNames[nameFrameIndex] == nil then
			GT_AddRerollPopup.nameFrames[nameFrameIndex]:Hide()
		else
			GT_AddRerollPopup.nameFrames[nameFrameIndex]:Show()
		end
	end
end) 

GT_AddRerollPopup:Hide()
