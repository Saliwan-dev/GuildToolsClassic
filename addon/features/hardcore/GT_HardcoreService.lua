GT_HardcoreService = {}

function GT_HardcoreService:SetLastDamageSource(newLastDamageSource)
    self.lastDamageSource = newLastDamageSource
end

function GT_HardcoreService:OnPlayerDeath()
    local playerName = UnitName("player")
    local playerLevel = UnitLevel("player")
    local playerLocation = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name

    local deathMessage = GT_LocaleManager:GetLabel("playerDeath", "hardcore")
                    :gsub("%%player%%", playerName)
                    :gsub("%%level%%", playerLevel)
                    :gsub("%%location%%", playerLocation)

    if self.lastDamageSource == "Falling" then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("falling", "hardcore")
    elseif self.lastDamageSource == "Drowning" then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("drowning", "hardcore")
    elseif self.lastDamageSource == "Fatigue" then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("fatigue", "hardcore")
    elseif self.lastDamageSource == "Fire" then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("fire", "hardcore")
    elseif self.lastDamageSource == "Lava" then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("lava", "hardcore")
    elseif self.lastDamageSource == "Slime" then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("slime", "hardcore")
    elseif self.lastDamageSource ~= nil then
        deathMessage = deathMessage..GT_LocaleManager:GetLabel("slainBy", "hardcore"):gsub("%%enemy%%", self.lastDamageSource)
    end

    SendChatMessage(deathMessage, "GUILD", nil)
    ChatThrottleLib:SendAddonMessage("BULK", "GT_HC_Death", "PLAYER_DEATH:"..playerName..":"..playerLevel..":"..playerLocation..":"..self.lastDamageSource, "GUILD")
end

function GT_HardcoreService:OnGuildMemberDeath(name, level, location, source)
    local deathMessage = GT_LocaleManager:GetLabel("deathAlert", "hardcore")
                                             :gsub("%%player%%", name)
                                             :gsub("%%level%%", level)

    RaidNotice_AddMessage(RaidWarningFrame, deathMessage, ChatTypeInfo["RAID_WARNING"])
end

function GT_HardcoreService:SetSelffound(name, isSelffound)
    local historyEntry = GetServerTime()..":SET_SELFFOUND:"..UnitName("player")..":"..name..":"..tostring(isSelffound)

    table.insert(GT_Data.selffoundHistory, historyEntry)

    GT_EventManager:PublishEvent("SELFFOUND_MODIFIED", historyEntry)
end

function GT_HardcoreService:GetUsefullSelffoundData()
    local lastUsefullEventByChar = {}

    table.sort(GT_Data.selffoundHistory, function(entry1, entry2)
        local entry1Time = string.sub(entry1, 1, 10)
        local entry2Time = string.sub(entry2, 1, 10)
        return entry1Time < entry2Time
    end)

    for index, entry in ipairs(GT_Data.selffoundHistory) do
        local time, action, fromPlayer, entryName, entryIsSelffound = unpack(StringSplit(entry, ":"))

        lastUsefullEventByChar[entryName] = entry
    end

    local dataToSynchronize = {}
    for name, entry in pairs(lastUsefullEventByChar) do
        table.insert(dataToSynchronize, entry)
    end

    return dataToSynchronize
end

function GT_HardcoreService:IsSelffound(name)
    local isSelffound = false

    for index, entry in ipairs(GT_HardcoreService:GetUsefullSelffoundData()) do
        local time, action, fromPlayer, entryName, entryIsSelffound = unpack(StringSplit(entry, ":"))
        if entryName == name then
            isSelffound = entryIsSelffound == "true"
        end
    end

    return isSelffound
end

GT_EventManager:AddEventListener("ADDON_READY", function()
    if not IsInTable(GT_HardcoreRealms, GetRealmName()) then
        return
    end

    C_ChatInfo.RegisterAddonMessagePrefix("GT_HC_Death")

    C_Timer.After(1, function() --On laisse aux buff le temps de se charger (A voir si c'est nécessaire avec le ADDON_READY)
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
    end)
end)