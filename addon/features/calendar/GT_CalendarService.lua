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
    event.creator = "Toto"
    event.title = "Ceci est un titre relativement long Ceci est un titre relativement long Ceci est un titre relativement long"
    event.date = GT_DateUtils:GetFirstDayOf(5, 2024)
    event.description = "Ceci est une description relativement longue d'environ 200 caractères Ceci est une description relativement longue d'environ 200 caractères Ceci est une description relativement longue d'environ 200 caractères"

    table.insert(events, event)

    local event2 = {}
    event2.id = 2
    event2.creator = "Saliwan"
    event2.title = "Mona full RUN 38+"
    event2.date = GT_DateUtils:GetFirstDayOf(5, 2024)
    event2.description = "Full run Mona (Cimetierre/Bibliothèque/Armurerie/Cathédrale)"

    table.insert(events, event2)

    local eventsForDay = {}

    for index, event in ipairs(events) do
        if date.year == event.date.year and date.month == event.date.month and date.monthDay == event.date.monthDay then
            table.insert(eventsForDay, event)
        end
    end

    return eventsForDay
end