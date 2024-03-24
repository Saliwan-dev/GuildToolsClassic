GT_EventManager = {}
GT_EventManager.listeners = {}

function GT_EventManager:AddEventListener(eventType, listener)
    if GT_EventManager.listeners[eventType] == nil then
        GT_EventManager.listeners[eventType] = {}
    end

    table.insert(GT_EventManager.listeners[eventType], listener)
end

function GT_EventManager:PublishEvent(eventType, data)
    if GT_EventManager.listeners[eventType] == nil then
        return
    end

    for index, listener in ipairs(GT_EventManager.listeners[eventType]) do
        listener(data)
    end
end
