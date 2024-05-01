local MICROSECONDS_IN_A_DAY = 1e6 * 60 * 60 * 24

GT_DateUtils = {}

local function IsInFuture(month, year)
    local now = C_DateAndTime.GetCurrentCalendarTime()

    if year > now.year then return true end
    if year < now.year then return false end
    if month > now.month then return true end
    if month < now.month then return false end

    return false
end

function GT_DateUtils:GetFirstDayOf(month, year)
    local now = C_DateAndTime.GetCurrentCalendarTime()
    local currentDate = C_DateAndTime.AdjustTimeByDays(now, 1 - now.monthDay)

    local isAskedDateInFuture = IsInFuture(month, year)

    while currentDate.year ~= year or currentDate.month ~= month do
        if isAskedDateInFuture then
            currentDate = C_DateAndTime.AdjustTimeByDays(currentDate, self:NumberOfDaysInMonth(currentDate.month, currentDate.year)) --Add a month
        else
            local previousMonth, previousYear = self:GetPreviousMonth(currentDate.month, currentDate.year)
            currentDate = C_DateAndTime.AdjustTimeByDays(currentDate, -self:NumberOfDaysInMonth(previousMonth, previousYear)) --Substract a month
        end
    end

    return currentDate
end

function GT_DateUtils:GetPreviousMonth(month, year)
    local previousMonth, previousYear
    if month > 1 then
        previousMonth = month - 1
        previousYear = year
    else
        previousMonth = 12
        previousYear = year - 1
    end

    return previousMonth, previousYear
end

local function IsLeapYear(year)
    if year % 4 ~= 0 then
        return false
    end

   if year % 100 ~= 0 then
        return true
   end

   return year % 400 == 0
end

function GT_DateUtils:NumberOfDaysInMonth(month, year)
    if month < 1 or month > 12 then
        error()
    end

    if month == 1 then return 31 end
    if month == 2 and IsLeapYear(year) then return 29 end
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