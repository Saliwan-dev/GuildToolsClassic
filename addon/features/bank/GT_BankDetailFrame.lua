GT_BankDetailFrame = CreateFrame("Frame", nil, GT_BankTabContent)
GT_BankDetailFrame:SetSize(GT_BankTabContent:GetWidth() - GT_BankListFrame:GetWidth(), GT_BankTabContent:GetHeight() - 30)
GT_BankDetailFrame:SetPoint("TOPLEFT", GT_BankListFrame, "TOPRIGHT")
GT_BankDetailFrame:Hide()

local selectedBankCharLabel = GT_UIFactory:CreateLabel(GT_BankDetailFrame, 0, 0, "", 16, 1, 1, 1)
selectedBankCharLabel:ClearAllPoints()
selectedBankCharLabel:SetPoint("TOP", 0, -7)

local selectedBankChar = ""

local itemCount = 0

GT_BankDetailFrame.itemFrames = {}

function GT_BankDetailFrame:SetSelectedBankChar(newSelectedBankChar)
    selectedBankChar = newSelectedBankChar

    self:Update()
end

local bankContentBackdrop =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 80,
 	edgeSize = 16,
 	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

GT_BankContentFrame = CreateFrame("Frame", nil, GT_BankDetailFrame, "BackdropTemplate")
GT_BankContentFrame:SetSize(390, 324)
GT_BankContentFrame:SetPoint("CENTER", -4, -5)
GT_BankContentFrame:SetBackdrop(bankContentBackdrop)

local scrollFrame = CreateFrame("ScrollFrame", nil, GT_BankContentFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 5, -6)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 6)

local scrollChildBackdrop =
{
    bgFile="Interface\\AddOns\\GuildTools\\resources\\textures\\BagSlots.PNG",
 	tile = true,
 	tileSize = 80,
 	insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

local scrollChild = CreateFrame("Frame", nil, nil, "BackdropTemplate")
scrollFrame:SetScrollChild(scrollChild)
scrollChild:SetSize(GT_BankContentFrame:GetWidth(), 500)
scrollChild:SetBackdrop(scrollChildBackdrop)

local function AddItem(itemLink, quantity)
    local _, _, Color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4,
        Suffix, Unique, LinkLvl, Name = string.find(itemLink,
        "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

    local itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
    itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
    expacID, setID, isCraftingReagent =
        GetItemInfo(itemId)

    local frameIndex = itemCount + 1
    if GT_BankDetailFrame.itemFrames[frameIndex] == nil then
        GT_BankDetailFrame.itemFrames[frameIndex] = CreateFrame("Frame", nil, scrollChild)
        GT_BankDetailFrame.itemFrames[frameIndex]:SetSize(40, 40)
        GT_BankDetailFrame.itemFrames[frameIndex]:SetPoint("TOPLEFT",2 + 44.5 * (itemCount % 8),-2 - 44.5 * math.floor(itemCount / 8))

        GT_BankDetailFrame.itemFrames[frameIndex].tex = GT_BankDetailFrame.itemFrames[frameIndex]:CreateTexture()
        GT_BankDetailFrame.itemFrames[frameIndex].tex:SetAllPoints(true)

        GT_BankDetailFrame.itemFrames[frameIndex].quantityLabel = GT_UIFactory:CreateLabel(GT_BankDetailFrame.itemFrames[frameIndex], 0, 0, "", 12, 1, 1, 1)
        GT_BankDetailFrame.itemFrames[frameIndex].quantityLabel:ClearAllPoints()
        GT_BankDetailFrame.itemFrames[frameIndex].quantityLabel:SetPoint("TOPRIGHT", GT_BankDetailFrame.itemFrames[frameIndex], "BOTTOMRIGHT", -2, 15)

        GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame = CreateFrame("Button", nil, GT_BankDetailFrame.itemFrames[frameIndex])
        GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame:SetSize(40, 40)
        GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame:SetPoint("CENTER")
        GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square.PNG")
        GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame:SetPushedTexture("Interface/Buttons/UI-Quickslot-Depress.PNG")
    end

    GT_BankDetailFrame.itemFrames[frameIndex].tex:SetTexture(itemTexture)

    GT_BankDetailFrame.itemFrames[frameIndex].quantityLabel:SetText(tostring(quantity))
    GT_BankDetailFrame.itemFrames[frameIndex].quantityLabel:SetShown(quantity ~= 1)

    GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetHyperlink("item:"..itemId..":0:0:0:0:0:0:0")
    end)

    GT_BankDetailFrame.itemFrames[frameIndex].highlightFrame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    GT_BankDetailFrame.itemFrames[frameIndex]:Show()

    itemCount = itemCount + 1

    scrollChild:SetSize(GT_BankContentFrame:GetWidth(), 44.5 * math.max(7, (math.floor(itemCount / 8) + 1)))
end

local function Clear()
    for index, itemFrame in ipairs(GT_BankDetailFrame.itemFrames) do
        itemFrame:Hide()
    end

    itemCount = 0
end

function GT_BankDetailFrame:Update()
    selectedBankCharLabel:SetText(selectedBankChar)

    Clear()

    local bankContent = GT_BankService:GetBankContent(selectedBankChar)

    for link, quantity in pairs(bankContent) do
        AddItem(link, quantity)
    end
end

GT_BankDetailFrame:SetScript("OnShow", function()
    GT_BankDetailFrame:Update()
end)