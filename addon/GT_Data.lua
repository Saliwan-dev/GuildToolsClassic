GT_Data = {}
GT_Data.guildMembers = {}
GT_Data.isAddonReady = false

local realmName = GetRealmName()
local guildName

local function InitData()
    if GT_SavedData == nil then GT_SavedData = {} end
    if GT_SavedData.options == nil then GT_SavedData.options = {} end
    if GT_SavedData[realmName] == nil then GT_SavedData[realmName] = {} end
    if GT_SavedData[realmName][guildName] == nil then GT_SavedData[realmName][guildName] = {} end

    if GT_SavedData[realmName][guildName].rerollHistory == nil then
        if GT_SavedData[realmName].rerollHistory ~= nil then -- Recuperation des datas de la 0.0.5
            GT_SavedData[realmName][guildName].rerollHistory = GT_SavedData[realmName].rerollHistory
            GT_SavedData[realmName].rerollHistory = nil
            GT_SavedData.rerollHistory = nil
        elseif GT_SavedData.rerollHistory ~= nil then --Recuperation des datas de la 0.0.2
            GT_SavedData[realmName][guildName].rerollHistory = GT_SavedData.rerollHistory
            GT_SavedData.rerollHistory = nil
        else
            GT_SavedData[realmName][guildName].rerollHistory = {}
        end
    end

    if GT_SavedData[realmName][guildName].selffoundHistory == nil then
        if GT_SavedData[realmName].selffoundHistory ~= nil then -- Recuperation des datas de la 0.0.5
            GT_SavedData[realmName][guildName].selffoundHistory = GT_SavedData[realmName].selffoundHistory
            GT_SavedData[realmName].selffoundHistory = nil
            GT_SavedData.selffoundHistory = nil
        elseif GT_SavedData.selffoundHistory ~= nil then --Recuperation des datas de la 0.0.2
            GT_SavedData[realmName][guildName].selffoundHistory = GT_SavedData.selffoundHistory
            GT_SavedData.selffoundHistory = nil
        else
            GT_SavedData[realmName][guildName].selffoundHistory = {}
        end
    end

    if GT_SavedData[realmName][guildName].bankCharsHistory == nil then GT_SavedData[realmName][guildName].bankCharsHistory = {} end
    if GT_SavedData[realmName][guildName].bankContentHistory == nil then GT_SavedData[realmName][guildName].bankContentHistory = {} end

    -- Alias
    GT_Data.rerollHistory = GT_SavedData[realmName][guildName].rerollHistory
    GT_Data.selffoundHistory = GT_SavedData[realmName][guildName].selffoundHistory
    GT_Data.bankCharsHistory = GT_SavedData[realmName][guildName].bankCharsHistory
    GT_Data.bankContentHistory = GT_SavedData[realmName][guildName].bankContentHistory

    -- PER CHARACTER DATA

    if GT_CharacterSavedData == nil then GT_CharacterSavedData = {} end
    if GT_CharacterSavedData.bankContent == nil then GT_CharacterSavedData.bankContent = {} end
    if GT_CharacterSavedData.options == nil then GT_CharacterSavedData.options = {} end
    if GT_CharacterSavedData.options.minimapButton == nil then GT_CharacterSavedData.options.minimapButton = {} end
    if GT_CharacterSavedData.options.minimapButton.minimapPos == nil then
        if GT_SavedData.options.minimapButton ~= nil and GT_SavedData.options.minimapButton.minimapPos ~= nil then --Recuperation des datas de la 0.1.1
            GT_CharacterSavedData.options.minimapButton.minimapPos = GT_SavedData.options.minimapButton.minimapPos
        else
            GT_CharacterSavedData.options.minimapButton.minimapPos = 200
        end
    end

    GuildRoster()

    GT_Data.isAddonReady = true
    GT_EventManager:PublishEvent("ADDON_READY")
end

local function InitDataAfterGettingGuildName()
    local maxTimeToWait = 10
    local currentTime = 0

    C_Timer.NewTicker(1, function(self)
        guildName = GetGuildInfo("player")
        if guildName ~= nil then
            self:Cancel()
            InitData()
        end
        currentTime = currentTime + 1

        if currentTime == maxTimeToWait then
            self:Cancel()
            guildName = "nil"
            InitData()
        end
    end, maxTimeToWait)
end

local function OnGuildRosterUpdate()
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

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("GUILD_ROSTER_UPDATE")
eventHandler:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "GuildTools" then
        InitDataAfterGettingGuildName()
    elseif event == "GUILD_ROSTER_UPDATE" then
        OnGuildRosterUpdate()
    end
end)