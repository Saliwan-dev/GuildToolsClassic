local lastDamageSource
local playerGUID

GT_EventManager:AddEventListener("ADDON_READY", function()
    if not IsInTable(GT_HardcoreRealms, GetRealmName()) then
        return
    end

    local eventHandler = CreateFrame("Frame")
    eventHandler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    eventHandler:RegisterEvent("PLAYER_DEAD")
    eventHandler:RegisterEvent("CHAT_MSG_ADDON")
    eventHandler:SetScript("OnEvent", function(self, event, ...)
        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, prefixParam1, prefixParam2, dummyparam, suffixParam1, suffixParam2 = CombatLogGetCurrentEventInfo()

            if not playerGUID then
                playerGUID = UnitGUID("player")
            end

            if destGUID == playerGUID then
                if subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" then
                    GT_HardcoreService:SetLastDamageSource(sourceName)
                elseif subevent == "ENVIRONMENTAL_DAMAGE" then
                    GT_HardcoreService:SetLastDamageSource(prefixParam1)
                end
            end
        end

        if event == "PLAYER_DEAD" then
            GT_HardcoreService:OnPlayerDeath()
        end

        if event == "CHAT_MSG_ADDON" then
            local prefix, message = ...

            if prefix ~= "GT_HC_Death" then
                return
            end

            GT_Logger:Debug("[GT]".."["..prefix.."]"..message)

            local _, _, messageType, name, level, location, source = string.find(message, "([^:]+):([^:]+):([^:]+):([^:]+):(.+)")
            if messageType == "PLAYER_DEATH" then
                GT_HardcoreService:OnGuildMemberDeath(name, level, location, source)
            end
        end
    end)
end)