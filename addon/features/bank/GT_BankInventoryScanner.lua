function GetInventoryContentWithoutBoundItems()
    local inventoryContent = {}

    for bagID = 0, 4 do
        local numSlot = C_Container.GetContainerNumSlots(bagID)
        for slot = 1, numSlot do
            local containerInfo = C_Container.GetContainerItemInfo(bagID, slot)
            if containerInfo ~= nil and containerInfo.isBound == false then
                if inventoryContent[containerInfo.hyperlink] == nil then
                    inventoryContent[containerInfo.hyperlink] = 0
                end
                inventoryContent[containerInfo.hyperlink] = inventoryContent[containerInfo.hyperlink] + containerInfo.stackCount
            end
        end
    end

    return inventoryContent
end

local function UpdateLocalSavedBankData()
    local bankContent = {}

    local bagIds = {-1, 5, 6, 7, 8, 9, 10}

    for index, bagID in ipairs(bagIds) do
        local numSlot = C_Container.GetContainerNumSlots(bagID)
        for slot = 1, numSlot do
            local containerInfo = C_Container.GetContainerItemInfo(bagID, slot)
            if containerInfo ~= nil and containerInfo.isBound == false then
                if bankContent[containerInfo.hyperlink] == nil then
                    bankContent[containerInfo.hyperlink] = 0
                end
                bankContent[containerInfo.hyperlink] = bankContent[containerInfo.hyperlink] + containerInfo.stackCount
            end
        end
    end

    GT_CharacterSavedData.bankContent = bankContent
end

local function SynchronizeWithAddonData()
    UpdateLocalSavedBankData()

    local myName = UnitName("player")

    if not GT_BankService:IsBankChar(myName) then
        return
    end

    local inventoryAndBankContent = GetInventoryContentWithoutBoundItems()

    -- Add bank content to inventory content
    for itemLink, quantity in pairs(GT_CharacterSavedData.bankContent) do
        if inventoryAndBankContent[itemLink] == nil then
            inventoryAndBankContent[itemLink] = 0
        end
        inventoryAndBankContent[itemLink] = inventoryAndBankContent[itemLink] + quantity
    end

    local addonSavedContent = GT_BankService:GetBankContent(myName)

    local itemsToAdd = {}
    for itemLink, quantity in pairs(inventoryAndBankContent) do
        if addonSavedContent[itemLink] == nil then
            itemsToAdd[itemLink] = quantity
        elseif addonSavedContent[itemLink] < quantity then
            itemsToAdd[itemLink] = quantity - addonSavedContent[itemLink]
        end
    end

    local itemsToRemove = {}
    for itemLink, quantity in pairs(addonSavedContent) do
        if inventoryAndBankContent[itemLink] == nil then
            itemsToRemove[itemLink] = quantity
        elseif inventoryAndBankContent[itemLink] < quantity then
            itemsToRemove[itemLink] = quantity - inventoryAndBankContent[itemLink]
        end
    end

    for itemLink, quantity in pairs(itemsToAdd) do
        GT_BankService:AddBankContent(myName, "nil", quantity, itemLink)
    end

    for itemLink, quantity in pairs(itemsToRemove) do
        GT_BankService:RemoveBankContent(myName, "nil", quantity, itemLink)
    end
end

local function OnBankFrameClosed()
    UpdateLocalSavedBankData()
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("BANKFRAME_OPENED")
eventHandler:RegisterEvent("BANKFRAME_CLOSED")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "BANKFRAME_OPENED" then
        SynchronizeWithAddonData()
    elseif event == "BANKFRAME_CLOSED" then
        OnBankFrameClosed()
    end
end)

GT_EventManager:AddEventListener("BANKCHAR_UPDATED_FROM_GUILD", function(historyEntry)
    local _, _, time, action, from, bankChar = string.find(historyEntry, "([^:]+):([^:]+):([^:]+):(.+)")
    if action == "ADD_BANKCHAR" and bankChar == UnitName("player") then
        SynchronizeWithAddonData()
    end
end)

GT_EventManager:AddEventListener("ADD_BANKCHAR", function(historyEntry)
    local _, _, time, action, from, bankChar = string.find(historyEntry, "([^:]+):([^:]+):([^:]+):(.+)")
    if action == "ADD_BANKCHAR" and bankChar == UnitName("player") then
        SynchronizeWithAddonData()
    end
end)