GT_EventManager:AddEventListener("ADDON_READY", function()
    if Prat ~= nil then
        Prat.RegisterChatEvent(Prat, "Prat_PreAddMessage", function(e, message, frame, event)
            if message == nil or message.PLAYERLINK == nil then
                return
            end

            local nameWithRealm = message.PLAYERLINK
            local rerollName = unpack(StringSplit(nameWithRealm, "-"))

            if rerollName == nil then return end

            if string.sub(rerollName, 1, 1) == "[" then
                rerollName = string.sub(rerollName, 2, -2)
            end

            local mainName = GT_RerollService:GetMain(rerollName)
            if rerollName ~= mainName then
                message.ALTNAMES = string.format("(%s)", mainName:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1))
            end
        end)
    end
end)