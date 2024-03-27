GT_LocaleManager = {}
GT_LocaleManager.locales = {}
GT_LocaleManager.favoriteLocale = nil

function GT_LocaleManager:GetLabel(key)
    --print("Calcul du label "..key)
    --print("Locale favorite "..tostring(GT_LocaleManager.favoriteLocale))

    local locale = "enUS"
    if GT_LocaleManager.favoriteLocale ~= nil then
        locale = GT_LocaleManager.favoriteLocale
    end

    if GT_LocaleManager.locales[locale] == nil then
        --print(locale)
        GT_LocaleManager.locales[locale] = {}
    end

    --print(GT_LocaleManager.locales[locale][key])
    local labelWithLocale = GT_LocaleManager.locales[locale][key]

    if labelWithLocale == nil then
        labelWithLocale = GT_LocaleManager.locales["enUS"][key]
    end

    if labelWithLocale == nil then
        labelWithLocale = "%"..key.."%"
    end

    return labelWithLocale
end

local labelsToSet = {}
function GT_LocaleManager:BindText(object, key, callback)
    local labelToSet = {}
    labelToSet.object = object
    labelToSet.key = key
    labelToSet.callback = callback
    table.insert(labelsToSet, labelToSet)
end

function GT_LocaleManager:UpdateLabels()
    for index, labelToSet in ipairs(labelsToSet) do
        labelToSet.object:SetText(GT_LocaleManager:GetLabel(labelToSet.key))
        if labelToSet.callback ~= nil then
            labelToSet.callback()
        end
    end
end

function GT_LocaleManager:SetFavoriteLocale(locale)
    self.favoriteLocale = locale
    self:UpdateLabels()
end