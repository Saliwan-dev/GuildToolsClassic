GT_BankService = {}

-- ===== BANK CHARS

function GT_BankService:AddBankChar(bankCharName)
    local historyEntry = GetServerTime()..":ADD_BANKCHAR:"..UnitName("player")..":"..bankCharName

    table.insert(GT_Data.bankCharsHistory, historyEntry)

    GT_EventManager:PublishEvent("ADD_BANKCHAR", historyEntry)
end

function GT_BankService:RemoveBankChar(bankCharName)
    local historyEntry = GetServerTime()..":REMOVE_BANKCHAR:"..UnitName("player")..":"..bankCharName

    table.insert(GT_Data.bankCharsHistory, historyEntry)

    GT_EventManager:PublishEvent("REMOVE_BANKCHAR", historyEntry)
end

function GT_BankService:GetUsefullCharData()
    local lastUsefullEventByChar = {}

    table.sort(GT_Data.bankCharsHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
        return entry1Time < entry2Time
    end)

    for index, entry in ipairs(GT_Data.bankCharsHistory) do
        local time, action, fromPlayer, bankCharName = unpack(StringSplit(entry, ":"))

        lastUsefullEventByChar[bankCharName] = entry
    end

    local dataToSynchronize = {}
    for bankCharName, entry in pairs(lastUsefullEventByChar) do
        table.insert(dataToSynchronize, entry)
    end

    return dataToSynchronize
end

function GT_BankService:GetBankChars()
    local historyCompilation = {}

    for index, entry in ipairs(self:GetUsefullCharData()) do
        local time, action, fromPlayer, bankCharName = unpack(StringSplit(entry, ":"))
        if action == "ADD_BANKCHAR" then
            historyCompilation[bankCharName] = true
        elseif action == "REMOVE_BANKCHAR" then
            historyCompilation[bankCharName] = false
        end
    end

    local bankCharNames = {}

    for bankCharName, isPresent in pairs(historyCompilation) do
        if isPresent == true then
            table.insert(bankCharNames, bankCharName)
        end
    end

    return bankCharNames
end

function GT_BankService:IsBankChar(charName)
    return IsInTable(self:GetBankChars(), charName)
end

-- ===== BANK CONTENT

local lastEventTime = -1;
local lastEventId = 0;

function GT_BankService:AddBankContent(bankCharName, source, quantity, itemLink)
    local currentTime = GetServerTime()
    if currentTime == lastEventTime then
        lastEventId = lastEventId + 1
    else
        lastEventTime = currentTime
        lastEventId = 0
    end

    local historyEntry = "2:"..currentTime..":ADD_BANKCONTENT:"..bankCharName..":"..tostring(lastEventId)..":"..source..":"..quantity..":"..itemLink

    table.insert(GT_Data.bankContentHistory, historyEntry)

    GT_EventManager:PublishEvent("ADD_BANKCONTENT", historyEntry)
end

function GT_BankService:RemoveBankContent(bankCharName, destination, quantity, itemLink)
    local currentTime = GetServerTime()
    if currentTime == lastEventTime then
        lastEventId = lastEventId + 1
    else
        lastEventTime = currentTime
        lastEventId = 0
    end

    local historyEntry = "2:"..currentTime..":REMOVE_BANKCONTENT:"..bankCharName..":"..tostring(lastEventId)..":"..destination..":"..quantity..":"..itemLink

    table.insert(GT_Data.bankContentHistory, historyEntry)

    GT_EventManager:PublishEvent("REMOVE_BANKCONTENT", historyEntry)
end

function GT_BankService:GetBankContentUsefullData()
    local usefullData = {}

    for index, entry in ipairs(GT_Data.bankContentHistory) do
        local _, _, version = string.find(entry, "([^:]+):(.+)")

        if version == "2" then
            table.insert(usefullData, entry)
        end
    end

    return usefullData
end

function GT_BankService:GetBankContent(bankCharName)
    if not GT_BankService:IsBankChar(bankCharName) then
        return {}
    end

    table.sort(self:GetBankContentUsefullData(), function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
        return entry1Time < entry2Time
    end)

    local bankContent = {}

    for index, entry in ipairs(self:GetBankContentUsefullData()) do
        local _, _, version, time, action, entryBankCharName, event_id, sourceOrDest, quantity, link = string.find(entry, "([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):(.+)")

        if entryBankCharName == bankCharName then
            if bankContent[link] == nil then
                bankContent[link] = 0
            end

            if action == "ADD_BANKCONTENT" then
                bankContent[link] = bankContent[link] + quantity
            elseif action == "REMOVE_BANKCONTENT" then
                bankContent[link] = bankContent[link] - quantity
            end
        end
    end

    for itemLink, quantity in pairs(bankContent) do
        if bankContent[itemLink] <= 0 then
            bankContent[itemLink] = nil
        end
    end

    return bankContent
end