ESX = nil
xPlayer = nil

local job = nil
local grade = 0
local locale = Locales[Config.Locale]
local workoutfit = ''

-- setup framework
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        getESXJobs()
    elseif Config.Framework == 'new_esx' then
        ESX = exports["es_extended"]:getSharedObject()

        getESXJobs()
    end
end)

-- setup wardrobes
Citizen.CreateThread(function()
    while job == nil do
        Citizen.Wait(100)
    end

    for k, v in pairs(Wardrobes) do
        local point = lib.points.new({
            coords = v.coords,
            distance = Config.PointDistance,
            dunak = k .. '_point',
        })

        if Config.Marker then
            setupMarker(k, v)
        end

        if Config.OxTarget then
            setupTarget(k, v)
        else
            setupKeyBind(point, v)
        end

        if Config.TextUI ~= 'none' then
            setupTextUI(point, v)
        end
    end
end)

-- sets up all the things needed for ox_target to work
function setupTarget(name, data)
    local i = 1

    for k, v in pairs(data.polyzones) do
        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = v.rotation,
            debug = Config.DevMode,
            options = {
                {
                    name = 'txc_wardrobe_' .. name .. '_' .. i,
                    data = data,
                    icon = 'fa-solid fa-shirt',
                    label = locale['open_wardrobe_target'],
                    canInteract = function(entity, distance, coords, name)
                        print('ä')
                        if job ~= data.job and data.job ~= 'none' then
                            return false
                        end

                        return true
                    end,
                    onSelect = function(data)
                        print('helo')
                        openWardrobe(data.data)
                    end
                }
            }
        })

        i = i + 1
    end
end

-- sets up all the things needed for keybinding to work
function setupKeyBind(point, data)
    function point:nearby()
        if job == data.job or data.job == 'none' then
            if IsControlJustReleased(0, Config.Key) then
                openWardrobe(data)
            end
        end
    end
end

-- sets up all the things needed for the text ui to work
function setupTextUI(point, data)
    function point:onEnter()
        if job == data.job or data.job == 'none' then
            Config.CustomShowTextUI(locale['open_wardrobe'])
        end
    end

    function point:onExit()
        if job == data.job or data.job == 'none' then
            Config.CustomHideTextUI()
        end
    end
end

-- sets up all the things needed for the marker to work
function setupMarker(k, v)
    local markerPoint = lib.points.new({
        coords = v.coords,
        distance = Config.MarkerDistance,
        dunak = k .. '_marker',
    })

    function markerPoint:nearby()
        if job == v.job or v.job == 'none' then
            DrawMarker(v.marker.type, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.size.x, v.marker.size.y, v.marker.size.z, v.marker.color.r, v.marker.color.g, v.marker.color.b, v.marker.color.a, false, true, 2, true, false, false, false)
        end
    end
end

-- opens the wardrobe menu using ox_lib
function openWardrobe(data)
    lib.hideMenu()

    local elements = {{
        label = locale['civilian_outfit'],
        description = locale['civilian_desc'],
        args = {
            name = '',
            armor = 0,
        },
        icon = 'fa-shirt'
    }}

    for i, v in ipairs(data.options) do
        table.insert(elements, {
            label = v.label,
            description = v.desc,
            args = { 
                name = v.label,
                armor = v.armor or 0, 
                outfit = v.outfits[grade] or v.outfits[0]
            },
            icon = v.icon
        })
    end

    lib.registerMenu({
        id = 'txc_wardrobe_main',
        title = data.label,
        position = Config.MenuPosition,
        options = elements
    }, function(selected, scrollIndex, args)
        local playerPed = PlayerPedId()
        
        cleanPlayer(playerPed)

        if args.name == workoutfit then
            Config.CustomNotify(locale['title'], locale['already_wearing'], 'error')
            return
        end

        if selected == 1 then
            setCivilianOutfit()
        else
            setWorkOutfit(playerPed, args.outfit, args.name)
        end

        SetPedArmour(playerPed, args.armor)
    end)

    lib.showMenu('txc_wardrobe_main')
end

-- removes dirt and blood from the player
function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

-- puts the normal clothes of the player back on
function setCivilianOutfit(playerPed)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)

    Config.CustomNotify(locale['title'], locale['civilian_notify'], 'success')

    workoutfit = ''
end

-- puts the selected outfit on
function setWorkOutfit(playerPed, outfit, name)
    workoutfit = name

    TriggerEvent('skinchanger:getSkin', function(skin)
        local sex = (skin.sex == 0) and "male" or "female"
        local uniform = outfit[sex]

        TriggerEvent('skinchanger:loadClothes', skin, uniform)
    end)

    Config.CustomNotify(locale['title'], replaceSubstring(locale['uniform_notify'], '{outfit}', name), 'success')
end

-- gets the job and grade of a player depend on the framework
function getESXJobs()
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(100)
    end

    while true do
        xPlayer = ESX.GetPlayerData()
            
        job = xPlayer.job.name
        grade = xPlayer.job.grade

        Citizen.Wait(2000)
    end
end

-- replace the outfit name in the locales
function replaceSubstring(str, oldSubstring, newSubstring)
    local index = string.find(str, oldSubstring)

    while index do
      str = string.sub(str, 1, index-1) .. newSubstring .. string.sub(str, index+#oldSubstring)
      index = string.find(str, oldSubstring)
    end

    return str
end
  