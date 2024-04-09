local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_LEVEL_UP")
eventHandler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LEVEL_UP" then
        GT_AchievementService:OnLevelUp(...)
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

        if subevent == "PARTY_KILL" then
            GT_AchievementService:OnKill(destGUID, destName)
        end
    end
end)