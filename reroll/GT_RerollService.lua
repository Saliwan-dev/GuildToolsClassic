GT_RerollService = {}

function GT_RerollService:AddReroll(mainName, rerollName)
    local historyEntry = GetServerTime()..":ADD_REROLL:"..UnitName("player")..":"..mainName..":"..rerollName

    table.insert(GT_SavedData.rerollHistory, historyEntry)

    GT_EventManager:PublishEvent("ADD_REROLL", historyEntry)
end

function GT_RerollService:RemoveReroll(rerollName)
    local mainName = self:GetMain(rerollName)

    local historyEntry = GetServerTime()..":REMOVE_REROLL:"..UnitName("player")..":"..mainName..":"..rerollName

    table.insert(GT_SavedData.rerollHistory, historyEntry)

    GT_EventManager:PublishEvent("REMOVE_REROLL", historyEntry)
end

function GT_RerollService:GetRerollIndex(mainTable, rerollNameToFind)
    for index, rerollName in ipairs(mainTable) do
        if rerollName == rerollNameToFind then return index end
    end

    return nil
end

function GT_RerollService:GetMain(rerollName)
    table.sort(GT_SavedData.rerollHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
    	return entry1Time < entry2Time
    end)

    local mainName = rerollName

    for index, entry in ipairs(GT_SavedData.rerollHistory) do
        local time, action, fromPlayer, entryMainName, entryRerollName = unpack(StringSplit(entry, ":"))
        if entryRerollName == rerollName then
            if action == "ADD_REROLL" then
                mainName = entryMainName
            elseif action == "REMOVE_REROLL" and entryMainName == mainName then
                mainName = rerollName
            end
        end
    end

    return mainName
end

function GT_RerollService:GetRerolls(selectedMain)
    table.sort(GT_SavedData.rerollHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
    	return entry1Time < entry2Time
    end)

    local historyCompilation = {}

    for index, entry in ipairs(GT_SavedData.rerollHistory) do
        local time, action, fromPlayer, mainName, rerollName = unpack(StringSplit(entry, ":"))
        if mainName == selectedMain then
            if action == "ADD_REROLL" then
                historyCompilation[rerollName] = true
            elseif action == "REMOVE_REROLL" then
                historyCompilation[rerollName] = false
            end
        end
    end

    local rerollNames = {}

    for rerollName, isPresent in pairs(historyCompilation) do
        if isPresent == true then
            table.insert(rerollNames, rerollName)
        end
    end

    return rerollNames
end

function GT_RerollService:IsAReroll(nameToTest)
    return nameToTest ~= self:GetMain(nameToTest)
end
