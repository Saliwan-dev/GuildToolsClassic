GT_BankDetailFrame = CreateFrame("Frame", nil, GT_BankTabContent)
GT_BankDetailFrame:SetSize(GT_BankTabContent:GetWidth() - GT_BankListFrame:GetWidth(), GT_BankTabContent:GetHeight() - 30)
GT_BankDetailFrame:SetPoint("TOPLEFT", GT_BankListFrame, "TOPRIGHT")
GT_BankDetailFrame:Hide()

local selectedBankCharLabel = GT_UIFactory:CreateLabel(GT_BankDetailFrame, 0, 0, "", 16, 1, 1, 1)
selectedBankCharLabel:ClearAllPoints()
selectedBankCharLabel:SetPoint("TOP", 0, -7)

local selectedBankChar = ""

local itemCount = 0

function GT_BankDetailFrame:SetSelectedBankChar(newSelectedBankChar)
    selectedBankChar = newSelectedBankChar

    self:Update()
end

function GT_BankDetailFrame:Update()
    selectedBankCharLabel:SetText(selectedBankChar)

    itemCount = 0

    GT_BankDetailFrame:Show()
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

    itemFrame = CreateFrame("Frame", nil, scrollChild)
    itemFrame:SetSize(40, 40)
    itemFrame:SetPoint("TOPLEFT",2 + 44.5 * (itemCount % 8),-2 - 44.5 * math.floor(itemCount / 8))

    itemFrame.tex = itemFrame:CreateTexture()
    itemFrame.tex:SetAllPoints(true)
    itemFrame.tex:SetTexture(itemTexture)

    itemFrame.quantityLabel = GT_UIFactory:CreateLabel(itemFrame, 0, 0, "", 12, 1, 1, 1)
    itemFrame.quantityLabel:ClearAllPoints()
    itemFrame.quantityLabel:SetPoint("TOPRIGHT", itemFrame, "BOTTOMRIGHT", -2, 15)
    itemFrame.quantityLabel:SetText(tostring(quantity))
    itemFrame.quantityLabel:SetShown(quantity ~= 1)

    highlightFrame = CreateFrame("Button", nil, itemFrame)
    highlightFrame:SetSize(40, 40)
    highlightFrame:SetPoint("CENTER")
    highlightFrame:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square.PNG")
    highlightFrame:SetPushedTexture("Interface/Buttons/UI-Quickslot-Depress.PNG")

    highlightFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetHyperlink("item:"..itemId..":0:0:0:0:0:0:0")
    end)

    highlightFrame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    highlightFrame:SetScript("OnClick", function(self)
        print(itemTexture)
    end)

    scrollChild:SetSize(GT_BankContentFrame:GetWidth(), 44.5 * math.max(7, (math.floor(itemCount / 8) + 1)))

    itemCount = itemCount + 1
end

for bagID = 0, 4 do
    local numSlot = C_Container.GetContainerNumSlots(bagID)
    print(numSlot)
    for slot = 1, numSlot do
        local containerInfo = C_Container.GetContainerItemInfo(bagID, slot)
        if containerInfo ~= nil then
            AddItem(containerInfo.hyperlink, containerInfo.stackCount)
        end
    end
end