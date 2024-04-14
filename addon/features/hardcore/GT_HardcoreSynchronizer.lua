local selfFoundSynchronizer

GT_EventManager:AddEventListener("ADDON_READY", function()
    if not IsInTable(GT_HardcoreRealms, GetRealmName()) then
        return
    end

    selfFoundSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_HC_SF",
        GT_HardcoreService.GetUsefullSelffoundData,
        function(historyEntry)
            if not IsInTable(GT_Data.selffoundHistory, historyEntry) then
                table.insert(GT_Data.selffoundHistory, historyEntry)
                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"SELFFOUND_MODIFIED"})
end)