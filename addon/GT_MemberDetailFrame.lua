local selectedMain = nil
local selectedReroll = nil

local backdropInfo =
{
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 32,
 	edgeSize = 16,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

-- PARENT FRAME

local PARENT_FRAME_WIDTH = 250
local PARENT_FRAME_HEIGHT = 420

GT_MemberDetailFrame = CreateFrame("Frame",nil,GT_MemberListFrame)
GT_MemberDetailFrame:SetWidth(PARENT_FRAME_WIDTH)
GT_MemberDetailFrame:SetHeight(PARENT_FRAME_HEIGHT)
GT_MemberDetailFrame:SetPoint("TOPLEFT", 330, 60)
GT_MemberDetailFrame:Hide()

-- REROLL FRAME

local REROLL_FRAME_HEIGHT = 70

GT_MemberDetailFrame.rerollFrame = CreateFrame("Frame",nil,GT_MemberDetailFrame,"BackdropTemplate")
GT_MemberDetailFrame.rerollFrame:SetWidth(PARENT_FRAME_WIDTH)
GT_MemberDetailFrame.rerollFrame:SetHeight(REROLL_FRAME_HEIGHT)
GT_MemberDetailFrame.rerollFrame:SetBackdrop(backdropInfo)
GT_MemberDetailFrame.rerollFrame:SetBackdropColor(0.1, 0.1, 0.1)
GT_MemberDetailFrame.rerollFrame:SetPoint("TOPLEFT")

GT_MemberDetailFrame.rerollFrame.closeButton = CreateFrame("Button", nil, GT_MemberDetailFrame.rerollFrame)
GT_MemberDetailFrame.rerollFrame.closeButton:SetSize(35, 35)
GT_MemberDetailFrame.rerollFrame.closeButton:SetPoint("TOPRIGHT", 4, 4)
GT_MemberDetailFrame.rerollFrame.closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
GT_MemberDetailFrame.rerollFrame.closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
GT_MemberDetailFrame.rerollFrame.closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
GT_MemberDetailFrame.rerollFrame.closeButton:SetScript('OnClick', function()
	GT_MemberDetailFrame:Hide()
end)

GT_MemberDetailFrame.rerollFrame.selectedLabel = GT_MemberDetailFrame.rerollFrame:CreateFontString()
GT_MemberDetailFrame.rerollFrame.selectedLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
GT_MemberDetailFrame.rerollFrame.selectedLabel:SetPoint("TOPLEFT", 7, -7)
GT_MemberDetailFrame.rerollFrame.selectedLabel:SetTextColor(1,0.8,0)
GT_MemberDetailFrame.rerollFrame.selectedLabel:SetText("Reroll")

GT_MemberDetailFrame.rerollFrame.name = GT_MemberDetailFrame.rerollFrame:CreateFontString()
GT_MemberDetailFrame.rerollFrame.name:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
GT_MemberDetailFrame.rerollFrame.name:SetPoint("TOP", 0, -15)
GT_MemberDetailFrame.rerollFrame.name:SetTextColor(1,1,1)

GT_MemberDetailFrame.rerollFrame.SFCheckbox = GT_UIFactory:CreateCheckbutton(GT_MemberDetailFrame.rerollFrame, 10, -35, "Autonome")
GT_MemberDetailFrame.rerollFrame.SFCheckbox:SetScript("OnClick",
   function()
      GT_HardcoreService:SetSelffound(selectedReroll, GT_MemberDetailFrame.rerollFrame.SFCheckbox:GetChecked())
   end
);

-- MAIN FRAME

GT_MemberDetailFrame.mainFrame = CreateFrame("Frame",nil,GT_MemberDetailFrame,"BackdropTemplate")
GT_MemberDetailFrame.mainFrame:SetWidth(PARENT_FRAME_WIDTH)
GT_MemberDetailFrame.mainFrame:SetHeight(PARENT_FRAME_HEIGHT - REROLL_FRAME_HEIGHT)
GT_MemberDetailFrame.mainFrame:SetBackdrop(backdropInfo)
GT_MemberDetailFrame.mainFrame:SetBackdropColor(0.1, 0.1, 0.1)
GT_MemberDetailFrame.mainFrame:SetPoint("TOPLEFT", 0, - REROLL_FRAME_HEIGHT + 5)

GT_MemberDetailFrame.mainFrame.selectedLabel = GT_MemberDetailFrame.mainFrame:CreateFontString()
GT_MemberDetailFrame.mainFrame.selectedLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
GT_MemberDetailFrame.mainFrame.selectedLabel:SetPoint("TOPLEFT", 7, -7)
GT_MemberDetailFrame.mainFrame.selectedLabel:SetTextColor(1,0.8,0)
GT_MemberDetailFrame.mainFrame.selectedLabel:SetText("Main")

GT_MemberDetailFrame.mainFrame.name = GT_MemberDetailFrame.mainFrame:CreateFontString()
GT_MemberDetailFrame.mainFrame.name:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
GT_MemberDetailFrame.mainFrame.name:SetPoint("TOP", 0, -15)
GT_MemberDetailFrame.mainFrame.name:SetTextColor(1,1,1)

GT_MemberDetailFrame.mainFrame.rerollsLabel = GT_MemberDetailFrame.mainFrame:CreateFontString()
GT_MemberDetailFrame.mainFrame.rerollsLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
GT_MemberDetailFrame.mainFrame.rerollsLabel:SetPoint("TOPLEFT", 10, -40)
GT_MemberDetailFrame.mainFrame.rerollsLabel:SetTextColor(1,0.8,0)
GT_MemberDetailFrame.mainFrame.rerollsLabel:SetText("Rerolls")

GT_MemberDetailFrame.mainFrame.addRerollButton = CreateFrame("Button", "AddRerollButton", GT_MemberDetailFrame.mainFrame, "UIPanelButtonTemplate")
GT_MemberDetailFrame.mainFrame.addRerollButton:SetSize(20, 20)
GT_MemberDetailFrame.mainFrame.addRerollButton:SetPoint("TOPLEFT", 55, -35)
GT_MemberDetailFrame.mainFrame.addRerollButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
GT_MemberDetailFrame.mainFrame.addRerollButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
GT_MemberDetailFrame.mainFrame.addRerollButton:SetScript('OnClick', function()
	if GT_AddRerollPopup:IsShown() then
		GT_AddRerollPopup:Hide()
	else
		GT_AddRerollPopup.mainName = selectedMain
		GT_AddRerollPopup:Show()
	end
end)

GT_AddRerollPopup.addRerollCallback = function(rerollName)
	GT_RerollService:AddReroll(selectedMain, rerollName)
	GT_MemberDetailFrame:Update()
end

GT_MemberDetailFrame.mainFrame.rerollsFrames = {}

function clearRerollsFrames()
	for index, rerollFrame in ipairs(GT_MemberDetailFrame.mainFrame.rerollsFrames) do
		rerollFrame:Hide()
	end
end

function GT_MemberDetailFrame:SetData(rerollName)
    selectedReroll = rerollName
    selectedMain = GT_RerollService:GetMain(rerollName)
    self:Update()
end

function GT_MemberDetailFrame:Update()
    -- Reroll Frame
    GT_MemberDetailFrame.rerollFrame.name:SetText(selectedReroll)

    GT_MemberDetailFrame.rerollFrame.SFCheckbox:SetChecked(GT_HardcoreService:IsSelffound(selectedReroll))

    -- Main Frame
    GT_MemberDetailFrame.mainFrame.name:SetText(selectedMain)

	clearRerollsFrames()

    local rerollNames = GT_RerollService:GetRerolls(selectedMain)

	if rerollNames ~= nil then
		for index, rerollName in ipairs(rerollNames) do
			if GT_MemberDetailFrame.mainFrame.rerollsFrames[index] == nil then
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index] = CreateFrame("Frame", nil, GT_MemberDetailFrame.mainFrame)
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index]:SetSize(120, 15)
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index]:SetPoint("TOPLEFT", 10, -45 - (15* index))
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].text = GT_MemberDetailFrame.mainFrame.rerollsFrames[index]:CreateFontString()
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].text:SetPoint("LEFT", 25, 0)
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].text:SetTextColor(1,1,1)
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].removeRerollButton = CreateFrame("Button", nil, GT_MemberDetailFrame.mainFrame.rerollsFrames[index], "UIPanelButtonTemplate")
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].removeRerollButton:SetSize(20, 20)
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].removeRerollButton:SetPoint("LEFT")
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].removeRerollButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
				GT_MemberDetailFrame.mainFrame.rerollsFrames[index].removeRerollButton:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")

			end

			GT_MemberDetailFrame.mainFrame.rerollsFrames[index].text:SetText(rerollName)
			GT_MemberDetailFrame.mainFrame.rerollsFrames[index].removeRerollButton:SetScript('OnClick', function()
                GT_RerollService:RemoveReroll(rerollName)
                self:Update()
            end)
            GT_MemberDetailFrame.mainFrame.rerollsFrames[index]:Show()
		end
	end
end

GT_EventManager:AddEventListener("REROLL_UPDATED_FROM_GUILD", function()
    GT_MemberDetailFrame:Update()
end)