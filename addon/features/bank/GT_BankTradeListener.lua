local beforeTradeInventory = {}

local tradeInProgress = false
local tradeTarget = nil

local function OnTradeShow()
    beforeTradeInventory = GetInventoryContentWithoutBoundItems()

    tradeInProgress = true
    tradeTarget = UnitName("NPC")
end

local function OnTradeClosed()
    if tradeInProgress == false then --Workaround to manage double TRADE_CLOSED_EVENT
        return
    end

    tradeInProgress = false

    local myName = UnitName("player")

    if not GT_BankService:IsBankChar(myName) then
        return
    end

    C_Timer.After(1, function()
        local afterTradeInventory = GetInventoryContentWithoutBoundItems()

        local itemsToAdd = {}
        for itemLink, quantity in pairs(afterTradeInventory) do
            if beforeTradeInventory[itemLink] == nil then
                itemsToAdd[itemLink] = quantity
            elseif beforeTradeInventory[itemLink] < quantity then
                itemsToAdd[itemLink] = quantity - beforeTradeInventory[itemLink]
            end
        end

        local itemsToRemove = {}
        for itemLink, quantity in pairs(beforeTradeInventory) do
            if afterTradeInventory[itemLink] == nil then
                itemsToRemove[itemLink] = quantity
            elseif afterTradeInventory[itemLink] < quantity then
                itemsToRemove[itemLink] = quantity - afterTradeInventory[itemLink]
            end
        end

        for itemLink, quantity in pairs(itemsToAdd) do
            GT_BankService:AddBankContent(myName, tradeTarget, quantity, itemLink)
        end

        for itemLink, quantity in pairs(itemsToRemove) do
            GT_BankService:RemoveBankContent(myName, tradeTarget, quantity, itemLink)
        end
    end)
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("TRADE_SHOW")
eventHandler:RegisterEvent("TRADE_CLOSED")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "TRADE_SHOW" then
        OnTradeShow()
    elseif event == "TRADE_CLOSED" then
        OnTradeClosed()
    end
end)