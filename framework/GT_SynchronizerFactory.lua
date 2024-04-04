GT_SynchronizerFactory = {}

-- prefix : Le préfixe des messages SendAddonMessage
-- getDataFunction : Une function qui renvoie la table des datas à synchronizer
-- saveDataFunction : Une fonction qui prend le message et enregistre les données
-- eventToSendMessage : Une table des events sur lesquel il y a une synchronization à faire
function GT_SynchronizerFactory:CreateSynchronizer(prefix, getDataFunction, saveDataFunction, eventToSendMessage)
    local synchronizer = {}
    synchronizer.prefix = prefix
    synchronizer.getDataFunction = getDataFunction
    synchronizer.saveDataFunction = saveDataFunction
    synchronizer.eventToSendMessage = eventToSendMessage

    -- HASH
    function synchronizer:GetHash()
        if self.hash ~= nil then
            return self.hash
        end

        local m = md5.new()

        local stringToHash = ""
        for index, savedEntry in ipairs(self.getDataFunction()) do
            stringToHash = stringToHash..savedEntry
        end

        local hashAsInt = 0
        for char = 1, string.len(stringToHash) do
            hashAsInt = hashAsInt + string.byte(stringToHash, char)
        end

        self.hash = tostring(hashAsInt)

        return self.hash
    end

    function synchronizer:InvalidateHash()
        self.hash = nil
    end

    -- SEND
    for index, event in ipairs(synchronizer.eventToSendMessage) do
        GT_EventManager:AddEventListener(event, function(historyEntry)
            synchronizer:InvalidateHash()
            ChatThrottleLib:SendAddonMessage("NORMAL", prefix, "NEW_EVENT:"..historyEntry, "GUILD")
        end)
    end

    function synchronizer:SendAllData()
        for index, historyEntry in ipairs(self.getDataFunction()) do
            ChatThrottleLib:SendAddonMessage("BULK", self.prefix, "NEW_EVENT:"..historyEntry, "GUILD")
        end
    end

    -- RECEIVE

    synchronizer.playerNameByHash = {}
    synchronizer.syncNeeded = false
    synchronizer.eventHandler = CreateFrame("Frame")
    synchronizer.eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
    synchronizer.eventHandler:RegisterEvent("CHAT_MSG_ADDON")
    synchronizer.eventHandler:SetScript("OnEvent", function(self, event, ...)
        if event == "CHAT_MSG_ADDON" then
            local prefix, message = ...

            if prefix ~= synchronizer.prefix then
                return
            end

            print("[GT]".."["..prefix.."]"..message)

            local splitedMessage = StringSplit(message, ":")
            local messageType = unpack(splitedMessage)
            if messageType == "NEW_EVENT" then
                synchronizer:InvalidateHash()
                local historyEntry = string.sub(message, 11, -1)
                synchronizer.saveDataFunction(historyEntry)
            end

            if messageType == "CHECK_SYNC" then
                ChatThrottleLib:SendAddonMessage("NORMAL", synchronizer.prefix, "MY_HASH:"..UnitName("player")..":"..synchronizer:GetHash(), "GUILD")
                synchronizer.playerNameByHash = {}
                synchronizer.syncNeeded = false
            end

            if StartWith(message, "MY_HASH") then
                local messageType, playerName, hash = unpack(StringSplit(message, ":"))

                if synchronizer.playerNameByHash[hash] == nil then
                    synchronizer.playerNameByHash[hash] = {}
                end

                table.insert(synchronizer.playerNameByHash[hash], playerName)

                local myHash = synchronizer:GetHash()

                if synchronizer.syncNeeded == false and hash ~= myHash then
                    synchronizer.syncNeeded = true
                    C_Timer.After(5, function()
                        table.sort(synchronizer.playerNameByHash[myHash])
                        if synchronizer.playerNameByHash[myHash][1] == UnitName("player") then
                            synchronizer:SendAllData()
                        end
                    end)
                end
            end
        end

        if event == "PLAYER_ENTERING_WORLD" then
            local isLogin, isReload = ...
            if isLogin or isReload then
                C_ChatInfo.RegisterAddonMessagePrefix(synchronizer.prefix)
            end

            ChatThrottleLib:SendAddonMessage("BULK", synchronizer.prefix, "CHECK_SYNC", "GUILD")
        end
    end)
end