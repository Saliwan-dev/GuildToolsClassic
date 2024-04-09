local rerollSynchronizer

GT_EventManager:AddEventListener("ADDON_READY", function()
    rerollSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_Reroll",
        GT_RerollService.GetUsefullData,
        function(historyEntry)
            if not IsInTable(GT_Data.rerollHistory, historyEntry) then
                table.insert(GT_Data.rerollHistory, historyEntry)
                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"ADD_REROLL", "REMOVE_REROLL"})
end)
