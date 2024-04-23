local MICROSECONDS_IN_A_DAY = 1e6 * 60 * 60 * 24

GT_DateUtils = {}

function GT_DateUtils:NumberOfDaysInMonth(month, year)
    if month < 1 or month > 12 then
        error()
    end

    if month == 1 then return 31 end
    if month == 2 and isAnneeBissextile(year) then return 29 end
    if month == 2 then return 28 end
    if month == 3 then return 31 end
    if month == 4 then return 30 end
    if month == 5 then return 31 end
    if month == 6 then return 30 end
    if month == 7 then return 31 end
    if month == 8 then return 31 end
    if month == 9 then return 30 end
    if month == 10 then return 31 end
    if month == 11 then return 30 end
    if month == 12 then return 31 end

    return -1
end

local function isAnneeBissextile(year)
    if year % 4 ~= 0 then
        return false
    end

   if year % 100 ~= 0 then
        return true
   end

   return year % 400 == 0
end