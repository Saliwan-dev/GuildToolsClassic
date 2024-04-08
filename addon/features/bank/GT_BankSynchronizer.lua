local bankCharSynchronizer
local bankContentSynchronizer

local function GetCharDataToSynchronize()
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

GT_EventManager:AddEventListener("ADDON_READY", function()
    bankCharSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_BankChars",
        GetCharDataToSynchronize,
        function(historyEntry)
            if not IsInTable(GT_Data.bankCharsHistory, historyEntry) then
                table.insert(GT_Data.bankCharsHistory, historyEntry)
                GT_EventManager:PublishEvent("BANKCHAR_UPDATED_FROM_GUILD", historyEntry)
            end
        end,
        {"ADD_BANKCHAR", "REMOVE_BANKCHAR"})

    bankContentSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_BankContent",
        function()
            return GT_Data.bankContentHistory
        end,
        function(historyEntry)
            if not IsInTable(GT_Data.bankContentHistory, historyEntry) then
                table.insert(GT_Data.bankContentHistory, historyEntry)
                GT_EventManager:PublishEvent("BANKCONTENT_UPDATED_FROM_GUILD", historyEntry)
            end
        end,
        {"ADD_BANKCONTENT", "REMOVE_BANKCONTENT"})
end)