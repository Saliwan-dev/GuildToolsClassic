GT_LocaleManager = {}
GT_LocaleManager.locales = {}
GT_LocaleManager.favoriteLocale = nil

function GT_LocaleManager:AddLabels(category, locale, labels)
    if GT_LocaleManager.locales[category] == nil then
        GT_LocaleManager.locales[category] = {}
    end

    GT_LocaleManager.locales[category][locale] = labels
end

function GT_LocaleManager:GetLabel(key, choosenCategory)
    local category = "default"
    if choosenCategory ~= nil then category = choosenCategory end

    local locale = GetLocale()
    if GT_LocaleManager.favoriteLocale ~= nil then
        locale = GT_LocaleManager.favoriteLocale
    end

    if GT_LocaleManager.locales[category] == nil then
        category = "default"
    end

    if GT_LocaleManager.locales[category][locale] == nil then
        locale = "enUS"
    end

    local labelWithLocale = GT_LocaleManager.locales[category][locale][key]

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