local bankCharSynchronizer
local bankContentSynchronizer

GT_EventManager:AddEventListener("ADDON_READY", function()
    bankCharSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_BankChars",
        function()
            return GT_Data.bankCharsHistory
        end,
        function(historyEntry)
            if not IsInTable(GT_Data.bankCharsHistory, historyEntry) then
                table.insert(GT_Data.bankCharsHistory, historyEntry)
                GT_EventManager:PublishEvent("BANKCHAR_UPDATED_FROM_GUILD", historyEntry)
            end
        end,
        {"ADD_BANKCHAR", "REMOVE_BANKCHAR"},
        GT_OptionsService:GetOption("debug"))

    bankContentSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_BankContent",
        function()
            return GT_Data.bankContentHistory
        end,
        function(historyEntry)
            if not IsInTable(GT_Data.bankContentHistory, historyEntry) then
                table.insert(GT_Data.bankContentHistory, historyEntry)
                --GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
            end
        end,
        {"ADD_BANKCONTENT", "REMOVE_BANKCONTENT"},
        GT_OptionsService:GetOption("debug"))
end)

GT_EventManager:AddEventListener("OPTION_UPDATED", function(newOption)
    if newOption.key == "debug" then
        if bankCharSynchronizer ~= nil then
            bankCharSynchronizer.debug = newOption.value
        end

        if bankContentSynchronizer ~= nil then
            bankContentSynchronizer.debug = newOption.value
        end
    end
end)