local rerollSynchronizer

local function GetDataToSynchronize()
    local lastUsefullEventByReroll = {}
    local currentMainByReroll = {}

    table.sort(GT_Data.rerollHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
        return entry1Time < entry2Time
    end)

    for index, entry in ipairs(GT_Data.rerollHistory) do
        local time, action, fromPlayer, mainName, rerollName = unpack(StringSplit(entry, ":"))

        if action == "ADD_REROLL" then
            currentMainByReroll[rerollName] = mainName
            lastUsefullEventByReroll[rerollName] = entry
        elseif action == "REMOVE_REROLL" and (currentMainByReroll[rerollName] == mainName or currentMainByReroll[rerollName] == nil) then
            lastUsefullEventByReroll[rerollName] = entry
        end
    end

    local dataToSynchronize = {}
    for rerollName, entry in pairs(lastUsefullEventByReroll) do
        table.insert(dataToSynchronize, entry)
    end

    return dataToSynchronize
end

GT_EventManager:AddEventListener("ADDON_READY", function()
    rerollSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_Reroll",
        GetDataToSynchronize,
        function(historyEntry)
            if not IsInTable(GT_Data.rerollHistory, historyEntry) then
                table.insert(GT_Data.rerollHistory, historyEntry)
                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"ADD_REROLL", "REMOVE_REROLL"})
end)
