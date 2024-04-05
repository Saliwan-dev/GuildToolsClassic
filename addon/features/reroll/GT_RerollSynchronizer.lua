local rerollSynchronizer

GT_EventManager:AddEventListener("ADDON_READY", function()
    rerollSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_Reroll",
        function() return GT_Data.rerollHistory end,
        function(historyEntry)
            if not IsInTable(GT_Data.rerollHistory, historyEntry) then
                table.insert(GT_Data.rerollHistory, historyEntry)
                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"ADD_REROLL", "REMOVE_REROLL"},
        GT_OptionsService:GetOption("debug"))
end)

GT_EventManager:AddEventListener("OPTION_UPDATED", function(newOption)
    if newOption.key == "debug" and rerollSynchronizer ~= nil then
        rerollSynchronizer.debug = newOption.value
    end
end)
