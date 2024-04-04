local beforeMailInventory = {}

local function OnMailShow()
    beforeMailInventory = GetInventoryContentWithoutBoundItems()
end

local function OnMailClosed()
    local myName = UnitName("player")

    if not GT_BankService:IsBankChar(myName) then
        return
    end

    local afterMailInventory = GetInventoryContentWithoutBoundItems()

    local itemsToAdd = {}
    for itemLink, quantity in pairs(afterMailInventory) do
        if beforeMailInventory[itemLink] == nil then
            itemsToAdd[itemLink] = quantity
        elseif beforeMailInventory[itemLink] < quantity then
            itemsToAdd[itemLink] = quantity - beforeMailInventory[itemLink]
        end
    end

    local itemsToRemove = {}
    for itemLink, quantity in pairs(beforeMailInventory) do
        if afterMailInventory[itemLink] == nil then
            itemsToRemove[itemLink] = quantity
        elseif afterMailInventory[itemLink] < quantity then
            itemsToRemove[itemLink] = quantity - afterMailInventory[itemLink]
        end
    end

    for itemLink, quantity in pairs(itemsToAdd) do
        GT_BankService:AddBankContent(myName, "nil", quantity, itemLink) --Need some work to get mail "from"
    end

    for itemLink, quantity in pairs(itemsToRemove) do
        GT_BankService:RemoveBankContent(myName, "nil", quantity, itemLink) --Need some work to get mail "to"
    end
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
eventHandler:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
eventHandler:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and arg1 == 17 then
        OnMailShow()
    elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and arg1 == 17 then
        OnMailClosed()
    end
end)