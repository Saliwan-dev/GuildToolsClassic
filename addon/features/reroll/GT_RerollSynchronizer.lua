GT_EventManager:AddEventListener("ADDON_READY", function()
    GT_SynchronizerFactory:CreateSynchronizer("GT_Reroll",
        function() return GT_Data.rerollHistory end,
        function(historyEntry)
            if not IsInTable(GT_Data.rerollHistory, historyEntry) then
                table.insert(GT_Data.rerollHistory, historyEntry)
                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"ADD_REROLL", "REMOVE_REROLL"})
end)
