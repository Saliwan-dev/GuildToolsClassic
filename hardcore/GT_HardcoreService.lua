GT_HardcoreService = {}

function GT_HardcoreService:SetSelffound(name, isSelffound)
    local historyEntry = GetServerTime()..":SET_SELFFOUND:"..UnitName("player")..":"..name..":"..tostring(isSelffound)

    table.insert(GT_Data.selffoundHistory, historyEntry)

    GT_EventManager:PublishEvent("SELFFOUND_MODIFIED", historyEntry)
end

function GT_HardcoreService:IsSelffound(name)
    local isSelffound = false

    table.sort(GT_Data.selffoundHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
    	return entry1Time < entry2Time
    end)

    for index, entry in ipairs(GT_Data.selffoundHistory) do
        local time, action, fromPlayer, entryName, entryIsSelffound = unpack(StringSplit(entry, ":"))
        if entryName == name then
            isSelffound = entryIsSelffound == "true"
        end
    end

    return isSelffound
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("CHAT_MSG_ADDON")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local isLogin, isReload = ...
        if isLogin then
            --Set Selffound data auto
            local playerName = UnitName("player")
            local hasSelffoundBuff = false

            local buffIndex = 1
            while true do
                local spellId = select(10, UnitBuff("player", buffIndex))

                if spellId == nil or buffIndex > 100 then
                    break
                end

                if spellId == 431567 then
                    hasSelffoundBuff = true
                    break
                end

                buffIndex = buffIndex + 1
            end

            local isSelffoundInAddonData = GT_HardcoreService:IsSelffound(playerName)

            if hasSelffoundBuff ~= isSelffoundInAddonData then
                GT_HardcoreService:SetSelffound(playerName, hasSelffoundBuff)
            end
        end
    end
end)