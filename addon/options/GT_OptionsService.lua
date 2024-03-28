GT_OptionsService = {}

function GT_OptionsService:SaveOption(key, value)
    GT_SavedData.options[key] = value
    GT_EventManager:PublishEvent("OPTION_UPDATED", {["key"] = key, ["value"] = value})
end

function GT_OptionsService:GetOption(key)
    return GT_SavedData.options[key]
end