GT_EventManager:AddEventListener("ADDON_READY", function()
    GT_SynchronizerFactory:CreateSynchronizer("GT_Achi_Messages",
        GT_AchievementService.GetUsefullData,
        function(historyEntry)
            if not IsInTable(GT_Data.achievementMessageHistory, historyEntry) then
                table.insert(GT_Data.achievementMessageHistory, historyEntry)
                GT_EventManager:PublishEvent("ACHIEVEMENT_MESSAGE_UPDATED_FROM_GUILD")
            end
        end,
        {"UPDATE_ACHIEVEMENT"})
end)