GT_HardcoreService = {}

function GT_HardcoreService:SetSelffound(name, isSelffound)
    local historyEntry = GetServerTime()..":SET_SELFFOUND:"..UnitName("player")..":"..name..":"..tostring(isSelffound)

    table.insert(GT_SavedData.selffoundHistory, historyEntry)

    GT_EventManager:PublishEvent("SELFFOUND_MODIFIED", historyEntry)
end

function GT_HardcoreService:IsSelffound(name)
    local isSelffound = false

    table.sort(GT_SavedData.selffoundHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
    	return entry1Time < entry2Time
    end)

    for index, entry in ipairs(GT_SavedData.selffoundHistory) do
        local time, action, fromPlayer, entryName, entryIsSelffound = unpack(StringSplit(entry, ":"))
        if entryName == name then
            isSelffound = entryIsSelffound == "true"
        end
    end

    return isSelffound
end