GT_Data = {}
GT_Data.guildMembers = {}

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("GUILD_ROSTER_UPDATE")

eventHandler:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "GuildTools" then
		if GT_SavedData == nil then
			GT_SavedData = {}
		end

		if GT_SavedData.rerollHistory == nil then
			GT_SavedData.rerollHistory = {}
		end

        if GT_SavedData.selffoundHistory == nil then
            GT_SavedData.selffoundHistory = {}
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