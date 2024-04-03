local backdropInfo =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 4,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

GT_BankListFrame = CreateFrame("Frame", nil, GT_BankTabContent, "BackdropTemplate")
GT_BankListFrame:SetPoint("TOPLEFT")
GT_BankListFrame:SetSize(130, GT_BankTabContent:GetHeight() - 32)
GT_BankListFrame:SetBackdrop(backdropInfo)

local scrollFrame = CreateFrame("ScrollFrame", nil, GT_BankListFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 3, -4)
scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

local scrollChild = CreateFrame("Frame")
scrollFrame:SetScrollChild(scrollChild)
scrollChild:SetWidth(GT_BankListFrame:GetWidth()-18)
scrollChild:SetHeight(1)

GT_BankListFrame.bankCharFrames = {}

function GT_BankListFrame:Clear()
    for index, frame in ipairs(GT_BankListFrame.bankCharFrames) do
        frame:Hide()
    end
end

local function initBankCharFrame(index, name, isSelffound)
    if (GT_BankListFrame.bankCharFrames[index] == nil) then
        GT_BankListFrame.bankCharFrames[index] = CreateFrame("Button", nil, scrollChild)
        GT_BankListFrame.bankCharFrames[index]:SetSize(325, 15)

        GT_BankListFrame.bankCharFrames[index].text = GT_BankListFrame.bankCharFrames[index]:CreateFontString()
        GT_BankListFrame.bankCharFrames[index].text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        GT_BankListFrame.bankCharFrames[index].text:SetPoint("LEFT", 5, 0)
        GT_BankListFrame.bankCharFrames[index].text:SetTextColor(1,0.8,0)

        local highlightTexture = GT_BankListFrame.bankCharFrames[index]:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetAllPoints(true)
        highlightTexture:SetColorTexture(1, 0.8, 0, 0.4)
    end

	GT_BankListFrame.bankCharFrames[index].text:SetText(name)
    GT_BankListFrame.bankCharFrames[index]:SetPoint("TOPLEFT", 0, -15 * (index - 1))
    GT_BankListFrame.bankCharFrames[index]:Show()

	GT_BankListFrame.bankCharFrames[index]:SetScript('OnClick', function()
	    GT_BankDetailFrame:SetSelectedBankChar(name)
	end)
end

local function Update()
    GT_BankListFrame:Clear()

    for index, bankChar in ipairs(GT_BankService:GetBankChars()) do
        initBankCharFrame(index, bankChar)
    end
end

GT_BankListFrame:SetScript("OnShow", function()
    Update()
end)