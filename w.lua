
getgenv().wl = true
local Enviroment = getfenv()
    local syntc = true
    local synws = false

        local functionCalled = false;
        setfenv(0, {tostring = function() while true do end end})
        xpcall(syn.request, function(s)
            functionCalled = true
            if s and s ~= "bad argument #1 to '?' (table expected, got no value)" then
                getgenv().wl = false
            end
        end)
        setfenv(0, Enviroment)
        if not functionCalled and syntc then
            getgenv().wl = false
        end
        functionCalled = false
        setfenv(0, {tostring = function() while true do end end})
        local Success, Data = pcall(syn.request)
        if (not synws == Success) or synws ~= Success then
            getgenv().wl = false
        end
        setfenv(0, Enviroment)
        if Data ~= "bad argument #1 to '?' (table expected, got no value)" then
            getgenv().wl = false
        end

    local xpcalltc = true
    local xpcallws = false

        local functionCalled = false;
        setfenv(0, {tostring = function() while true do end end})
        xpcall(xpcall, function(s)
            functionCalled = true
            if s and s ~= "missing argument #2 to 'xpcall' (function expected)" then
                getgenv().wl = false
            end
        end)
        setfenv(0, Enviroment)
        if not functionCalled and xpcalltc then
            getgenv().wl = false
        end
        functionCalled = false
        setfenv(0, {tostring = function() while true do end end})
        local Success, Data = pcall(xpcall)
        if (not xpcallws == Success) or xpcallws ~= Success then
            getgenv().wl = false
        end
        setfenv(0, Enviroment)
        if Data ~= "missing argument #2 to 'xpcall' (function expected)" then
            getgenv().wl = false
        end
        
        if getgenv().wl then
            warn("passed")
            else
            warn("failed")
        end
        