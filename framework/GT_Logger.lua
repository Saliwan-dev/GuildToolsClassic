GT_Logger = {}
GT_Logger.debug = false

function GT_Logger:SetDebug(isDebug)
    self.debug = isDebug
end

function GT_Logger:Debug(message)
    if self.debug then
        print(message)
    end
end