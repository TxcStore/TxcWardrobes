--[[
 ██████╗██╗   ██╗███████╗████████╗ ██████╗ ███╗   ███╗
██╔════╝██║   ██║██╔════╝╚══██╔══╝██╔═══██╗████╗ ████║
██║     ██║   ██║███████╗   ██║   ██║   ██║██╔████╔██║
██║     ██║   ██║╚════██║   ██║   ██║   ██║██║╚██╔╝██║
╚██████╗╚██████╔╝███████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
 ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝                                          
--]]

-- If you don't know what you're doing, don't edit this part of the config

Config.CustomNotify = function(text, subtext, type)
    -- type = can be 'error' or 'success'

    if Config.Notify == 'none' then
        return
    end

    -- if you have a custom notify
    if Config.Notify == 'custom' then
        -- your code
    end

    -- qs notify
    if Config.Notify == 'qs' then
        exports['qs-notify']:Alert(subtext, 1500, type)
    end

    -- okok notify
    if Config.Notify == 'okok' then
        exports['okokNotify']:Alert(text, subtext, 1500, type, false)
    end

    -- ox_lib
    if Config.Notify == 'ox' then
        lib.notify({
            title = text,
            description = subtext,
            position = 'top',
            type = type
        })
    end

    -- default esx
    if Config.Notify == 'esx' then
        ESX.ShowNotification(subtext)
    end
end

Config.CustomShowTextUI = function(text)
    -- if you have a custom text ui
    if Config.TextUI == 'custom' then
        -- your code
    end

    -- okok textui
    if Config.Notify == 'okok' then
        exports['okokTextUI']:Open(text, 'lightblue', 'right')
    end

    -- ox_lib
    if Config.TextUI == 'ox' then
        lib.showTextUI(text, {
            position = "right-center",
            icon = 'fa-shirt',
        })
    end

    -- default esx
    if Config.TextUI == 'esx' then
        ESX.ShowNotification(text)
    end
end

Config.CustomHideTextUI = function()
    -- if you have a custom text ui
    if Config.TextUI == 'custom' then
        -- your code
    end

    -- okok textui
    if Config.Notify == 'okok' then
        exports['okokTextUI']:Close()
    end

    -- ox_lib
    if Config.TextUI == 'ox' then
        lib.hideTextUI()
    end
end

Config.CustomLocale = function(text, toReplace, replaceWith)
    local current = Config.Locale
    local fallback = 'en'

    local locale = Locales[current] or Locales[fallback]
    local string = locale[text] or Locales[fallback][text]
    
    if toReplace and replaceWith then
        string = replaceSubstring(string, toReplace, replaceWith)
    end

    return string
end