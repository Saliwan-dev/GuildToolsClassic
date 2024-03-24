function StringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t={}

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function StringJoin(strings, sep)
    if sep == nil then
        sep = "%s"
    end

    if strings == nil or table.len(strings) == 0 then
        return ""
    end

    if table.len(strings) == 1 then
        return strings[1]
    end

    local result = strings[1]

    for index = 2, table.len(strings) do
        result = result..":"..strings[index]
    end
end

function StartWith(string, startPattern)
    return string.sub(string, 1, string.len(startPattern)) == startPattern
end

function IsInTable(table, element)
    for index, tableElement in ipairs(table) do
        if tableElement == element then return true end
    end

    return false
end
