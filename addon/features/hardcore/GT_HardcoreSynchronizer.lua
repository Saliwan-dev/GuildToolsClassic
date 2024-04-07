local selfFoundSynchronizer

GT_EventManager:AddEventListener("ADDON_READY", function()
    selfFoundSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_HC_SF",
        function() return GT_Data.selffoundHistory end,
        function(historyEntry)
            if not IsInTable(GT_Data.selffoundHistory, historyEntry) then
                table.insert(GT_Data.selffoundHistory, historyEntry)
                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"SELFFOUND_MODIFIED"})
end)