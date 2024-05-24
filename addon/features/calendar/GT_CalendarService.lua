GT_CalendarService = {}

function GT_CalendarService:CreateEvent()

end

function GT_CalendarService:GetEventsBetween(startDate, endDate)
    local events = {}

    local event = {}
    event.id = 1
    event.title = "Titre de l'event"
    event.date = GT_DateUtils:GetFirstDayOf(5, 2024)
    event.description = "Description de l'event"

    table.insert(events, event)

    return events
end

function GT_CalendarService:GetEventsForDay(date)
    local events = {}

    local event = {}
    event.id = 1
    event.title = "Titre de l'event"
    event.date = GT_DateUtils:GetFirstDayOf(5, 2024)
    event.description = "Description de l'event"

    table.insert(events, event)

    return events
end