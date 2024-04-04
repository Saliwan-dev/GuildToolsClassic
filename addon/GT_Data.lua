GT_Data = {}
GT_Data.guildMembers = {}

local realmName = GetRealmName()

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("GUILD_ROSTER_UPDATE")

eventHandler:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then

        local guildName = GetGuildInfo("player")
        if (guildName == nil) then
            print("Aucune guilde trouvée !")
            return
        end

		if GT_SavedData == nil then
			GT_SavedData = {}
		end

		if GT_SavedData.options == nil then
		    GT_SavedData.options = {}
		end

		if GT_SavedData.options.minimapButton == nil then
            GT_SavedData.options.minimapButton = {}
        end

        if GT_SavedData.options.minimapButton.minimapPos == nil then
            GT_SavedData.options.minimapButton.minimapPos = 200
        end

		if GT_SavedData[realmName] == nil then
            GT_SavedData[realmName] = {}
        end

        if GT_SavedData[realmName][guildName] == nil then
            GT_SavedData[realmName][guildName] = {}
        end

		if GT_SavedData[realmName].rerollHistory == nil then
            if GT_SavedData.rerollHistory ~= nil then --Recuperation des datas de la 0.0.2
                GT_SavedData[realmName].rerollHistory = GT_SavedData.rerollHistory
                GT_SavedData.rerollHistory = nil
            else
			    GT_SavedData[realmName].rerollHistory = {}
			end
		end

        if GT_SavedData[realmName].selffoundHistory == nil then
            if GT_SavedData.selffoundHistory ~= nil then --Recuperation des datas de la 0.0.2
                GT_SavedData[realmName].selffoundHistory = GT_SavedData.selffoundHistory
                GT_SavedData.selffoundHistory = nil
            else
                GT_SavedData[realmName].selffoundHistory = {}
            end
        end

        if GT_SavedData[realmName][guildName].bankCharsHistory == nil then
            GT_SavedData[realmName][guildName].bankCharsHistory = {}
        end

        if GT_SavedData[realmName][guildName].bankContentHistory == nil then
            GT_SavedData[realmName][guildName].bankContentHistory = {}
        end

        GT_Data.rerollHistory = GT_SavedData[realmName].rerollHistory
        GT_Data.selffoundHistory = GT_SavedData[realmName].selffoundHistory
        GT_Data.bankCharsHistory = GT_SavedData[realmName][guildName].bankCharsHistory
        GT_Data.bankContentHistory = GT_SavedData[realmName][guildName].bankContentHistory

        -- PER CHARACTER DATA

        if GT_CharacterSavedData == nil then
            GT_CharacterSavedData = {}
        end

        if GT_CharacterSavedData.bankContent == nil then
            GT_CharacterSavedData.bankContent = {}
        end
    end

    if event == "GUILD_ROSTER_UPDATE" then
        GT_Data.guildMembers = {}

        numGuildMembers, numOnlineGuildMembers = GetNumGuildMembers()

        for guildMemberIndex = 1, numGuildMembers, 1 do
        	local nameWithRealm, rank, rankIndex, level, class, zone, note, officernote, isOnline = GetGuildRosterInfo(guildMemberIndex)
        	local name = string.sub(nameWithRealm, 1, string.find(nameWithRealm, "-") - 1)
        	local guildMember = {}
        	guildMember.name = name
        	guildMember.isOnline = isOnline
        	table.insert(GT_Data.guildMembers, guildMember)
        end

        table.sort(GT_Data.guildMembers, function(guildMember1, guildMember2)
        	if guildMember1.isOnline and not guildMember2.isOnline then return true end
        	if guildMember2.isOnline and not guildMember1.isOnline then return false end
        	return guildMember1.name < guildMember2.name
        end)
    end
end)

GuildRoster()