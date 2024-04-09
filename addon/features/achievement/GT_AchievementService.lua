GT_AchievementService = {}

local sendMessageSync = false
local dungeonAchievementMessageToSend = nil

local localeDungeonKeyByBossId = {
    ["11519"] = "RFC",
    ["639"] = "DM",
    ["3654"] = "WC",
    ["4275"] = "SFK",
    ["4829"] = "BFD",
    ["1716"] = "Stockade",
    ["4421"] = "RFK",
    ["7800"] = "Gnomeregan",
    ["4543"] = "SM_G",
    ["6487"] = "SM_L",
    ["3975"] = "SM_A",
    --["3977"] = "SM_C",
    ["299"] = "SM_C",
    ["7358"] = "RFD",
    ["2748"] = "Uldaman",
    ["7267"] = "ZF",
    ["12201"] = "Maraudon",
    ["5709"] = "ST",
    ["9019"] = "BRD",
    ["10813"] = "Stratholme_L",
    ["10440"] = "Stratholme_U",
    ["9568"] = "LBRS",
    ["10363"] = "UBRS",
    ["11492"] = "DM_E",
    ["11486"] = "DM_W",
    ["11501"] = "DM_N",
    ["1853"] = "Scholomance",
}

local function SendGuildMessage(message)
    SendChatMessage(message, "GUILD", nil)
end

local function ConcatPartyNames(names)
    local numberOfNames = TableLength(names)
    local result = names[1]

    if numberOfNames < 2 then
        return result
    end

    if numberOfNames > 2 then
        for i = 2,numberOfNames - 1 do
            result = result..", "..names[i]
        end
    end

    result = result.." "..GT_LocaleManager:GetLabel("and").." "..names[numberOfNames]

    return result
end

function GT_AchievementService:OnLevelUp(level)
    if level % 10 == 0 or level > 50 then
        SendGuildMessage(GT_LocaleManager:GetLabel("up", "achievement"):gsub("%%player%%", UnitName("player")):gsub("%%level%%", level))
    end
end

function GT_AchievementService:OnKill(destGUID, destName)
    local myName = UnitName("player")
    local _, _, server_id, instance_id, zone_uid, npc_id, spawn_uid = unpack(StringSplit(destGUID, "%-"))

    if localeDungeonKeyByBossId[npc_id] == nil then
        return
    end

    dungeonAchievementMessageToSend = {}
    dungeonAchievementMessageToSend.bossName = destName
    dungeonAchievementMessageToSend.groupMembers = {}
    dungeonAchievementMessageToSend.messageCandidates = {}

    table.insert(dungeonAchievementMessageToSend.groupMembers, myName)
    for i=1,4 do
        if UnitName('party'..i) then
            local partyMemberName = UnitName('party'..i)
            table.insert(dungeonAchievementMessageToSend.groupMembers, partyMemberName)
        end
    end

    ChatThrottleLib:SendAddonMessage("BULK", "GT_Achievement", "CAN_SEND_KILL_MESSAGE:"..myName..":"..npc_id, "PARTY")
end

local function OnKillSyncMessage(messageData)
    local _, _, senderName, bossId = string.find(messageData, "([^:]+):(.+)")

    table.insert(dungeonAchievementMessageToSend.messageCandidates, senderName)

    if not sendMessageSync then
        sendMessageSync = true
        C_Timer.After(1, function()
            table.sort(dungeonAchievementMessageToSend.messageCandidates)
            if dungeonAchievementMessageToSend.messageCandidates[1] == UnitName("player") then
                local groupeText = ConcatPartyNames(dungeonAchievementMessageToSend.groupMembers)
                local bossName = dungeonAchievementMessageToSend.bossName
                local dungeonName = GT_LocaleManager:GetLabel(localeDungeonKeyByBossId[bossId], "dungeon")
                local message = GT_LocaleManager:GetLabel("killBoss", "achievement")
                    :gsub("%%group%%", groupeText)
                    :gsub("%%npc%%", bossName)
                    :gsub("%%dungeon%%", dungeonName)
                SendGuildMessage(message)
            end
            sendMessageSync = false
            dungeonAchievementMessageToSend = nil
        end)
    end
end

eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("CHAT_MSG_ADDON")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        local prefix, message = ...

        if prefix ~= "GT_Achievement" then
            return
        end

        GT_Logger:Debug("[GT]".."["..prefix.."]"..message)

        local _, _, messageType, messageData = string.find(message, "([^:]+):(.+)")
        if messageType == "CAN_SEND_KILL_MESSAGE" then
            OnKillSyncMessage(messageData)
        end
    end
end)

GT_EventManager:AddEventListener("ADDON_READY", function()
    C_ChatInfo.RegisterAddonMessagePrefix("GT_Achievement")
end)