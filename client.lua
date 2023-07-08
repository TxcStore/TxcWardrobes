ESX = nil
xPlayer = nil

local job = nil
local grade = 0
local workoutfit = ''

local savedOutfits = {}

-- setup framework
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    elseif Config.Framework == 'new_esx' then
        ESX = exports["es_extended"]:getSharedObject()
    end

    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(100)
    end

    getOutfits()
    getESXJobs()
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
                    label = Config.CustomLocale('open_wardrobe'),
                    canInteract = function(entity, distance, coords, name)
                        if job ~= data.job and data.job ~= 'none' then
                            return false
                        end

                        return true
                    end,
                    onSelect = function(data)
                        openMainMenu(data.data)
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
        if ( job == data.job or data.job == 'none' ) and ( grade >= data.grade or data.grade == 0 ) then
            if IsControlJustReleased(0, Config.Key) then
                openMainMenu(data)
            end
        end
    end
end

-- sets up all the things needed for the text ui to work
function setupTextUI(point, data)
    function point:onEnter()
        if ( job == data.job or data.job == 'none' ) and ( grade >= data.grade or data.grade == 0 ) then
            Config.CustomShowTextUI(Config.CustomLocale('open_key') .. Config.CustomLocale('open_wardrobe'))
        end
    end

    function point:onExit()
        if ( job == data.job or data.job == 'none' ) and ( grade >= data.grade or data.grade == 0 ) then
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
        if ( job == v.job or v.job == 'none' ) and ( grade >= v.grade or v.grade == 0 ) then
            DrawMarker(v.marker.type, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.size.x, v.marker.size.y, v.marker.size.z, v.marker.color.r, v.marker.color.g, v.marker.color.b, v.marker.color.a, false, true, 2, true, false, false, false)
        end
    end
end

-- opens the main menu
function openMainMenu(data)
    lib.hideMenu()
    lib.hideContext()

    Citizen.Wait(50)

    if Config.Menu == 'oxmenu' then
        lib.registerMenu({
            id = 'txc_wardrobe_main',
            title = data.label,
            position = Config.MenuPosition,
            options = {
                {
                    label = Config.CustomLocale('saved_outfits'),
                    description = Config.CustomLocale('saved_outfits_desc'),
                    args = { 'saved_outfits' },
                    icon = 'fa-floppy-disk'
                },
                {
                    label = Config.CustomLocale('society_outfits'),
                    description = Config.CustomLocale('society_outfits_desc'),
                    args = { 'society_outfits' },
                    icon = 'fa-briefcase'
                },
            }
        }, function(selected, scrollIndex, args)
            if args[1] == 'saved_outfits' then
                openSavedOutfits(data)
            end

            if args[1] == 'society_outfits' then
                openSocietyWardrobe(data)
            end
        end)
    
        lib.showMenu('txc_wardrobe_main')
    end

    if Config.Menu == 'oxcontext' then
        lib.registerContext({
            id = 'txc_wardrobe_main',
            title = data.label,
            position = Config.MenuPosition,
            options = {
                {
                    title = Config.CustomLocale('saved_outfits'),
                    description = Config.CustomLocale('saved_outfits_desc'),
                    args = { },
                    icon = 'fa-floppy-disk',
                    onSelect = function(args)
                        print('hallo')
                        openSavedOutfits(data)
                    end,
                },
                {
                    title = Config.CustomLocale('society_outfits'),
                    description = Config.CustomLocale('society_outfits_desc'),
                    args = { },
                    icon = 'fa-briefcase',
                    onSelect = function(args)
                        openSocietyWardrobe(data)
                    end,
                },
            }
        })

        lib.showContext('txc_wardrobe_main')
    end
end

function openSavedOutfits(data)
    lib.hideMenu()
    lib.hideContext()

    Citizen.Wait(50)

    if Config.Menu == 'oxmenu' then
        local elements = {{
            label = Config.CustomLocale('save_outfit_title'),
            description = Config.CustomLocale('save_outfit_desc'),
            args = { type = 'saveoutfit' },
            icon = 'fa-download'
        }}

        if not savedOutfits[1] then
            table.insert(elements, {
                label = Config.CustomLocale('no_saved_clothes'),
                description = Config.CustomLocale('no_saved_clothes_desc'),
                args = { type = 'nooutfits' },
                icon = 'fa-circle-xmark',
                close = false
            })
        else
            for k, v in pairs(savedOutfits) do
                table.insert(elements, {
                    label = v.name,
                    args = { 
                        type = 'private',
                        name = v.name, 
                        armor = 0,
                        outfit = v.outfit,
                        uuid = k
                    },
                    icon = 'fa-shirt',
                    values = { Config.CustomLocale('put_on_outfit'), Config.CustomLocale('rename_outfit'), Config.CustomLocale('delete_outfit') },
                    defaultIndex = 1
                })
            end
        end

        lib.registerMenu({
            id = 'txc_wardrobe_saved',
            title = data.label,
            position = Config.MenuPosition,
            options = elements,
            onClose = function()
                openMainMenu(data)
            end
        }, function(selected, scrollIndex, args)
            if args.type == 'saveoutfit' then
                local input = lib.inputDialog(Config.CustomLocale('save_outfit_title'), { 
                    {type = 'input', label = Config.CustomLocale('input_outfit_name'), description = Config.CustomLocale('input_outfit_desc'), required = true, min = 3, max = 20, placeholder = Config.CustomLocale('input_placeholder') }
                })
 
                if not input then
                    openSavedOutfits(data) 
                    return 
                end

                TriggerEvent('skinchanger:getSkin', function(skin)
                    local outfit = {}

                    for k, v in pairs(Config.SavedComponents) do
                        outfit[v] = skin[v]
                    end

                    lib.callback('TxcWardrobes:SavePrivateOutfit', false, function(newOutfitList)
                        --exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'outfit saved successfully', 'success')
                        savedOutfits = newOutfitList

                        Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('outfit_save_success'), 'error')

                        openSavedOutfits(data)
                    end, savedOutfits, outfit, input[1])
                end)
            elseif args.type == 'private' then
                if scrollIndex == 1 then -- put on
                    executeOutfitChange(args.type, args.name, args.outfit, args.armor)

                    openSavedOutfits(data)
                elseif scrollIndex == 2 then -- rename
                    local input = lib.inputDialog(Config.CustomLocale('rename_outfit_title'), { 
                        {type = 'input', label = Config.CustomLocale('input_outfit_name'), description = Config.CustomLocale('input_outfit_desc'), required = true, min = 3, max = 20, placeholder = Config.CustomLocale('input_placeholder') }
                    })
     
                    if not input then
                        openSavedOutfits(data)
                        return 
                    end

                    lib.callback('TxcWardrobes:RenamePrivateOutfit', false, function(newOutfitList)
                        --exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'outfit renamed successfully', 'success')
                        savedOutfits = newOutfitList

                        Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('outfit_rename_success', '{name}', input[1]), 'success')

                        openSavedOutfits(data)
                    end, savedOutfits, args.uuid, input[1])
                elseif scrollIndex == 3 then -- delete
                    lib.callback('TxcWardrobes:DeletePrivateOutfit', false, function(newOutfitList)
                        --exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'outfit deleted successfully', 'success')
                        savedOutfits = newOutfitList

                        Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('outfit_delete_success'), 'success')

                        openSavedOutfits(data)
                    end, savedOutfits, args.uuid)
                end
            end
        end)
    
        lib.showMenu('txc_wardrobe_saved')
    end
end

-- opens the wardrobe menu using ox_lib
function openSocietyWardrobe(data)
    lib.hideMenu()
    lib.hideContext()

    Citizen.Wait(50)

    if Config.Menu == 'oxmenu' then
        local elements = {{
            label = Config.CustomLocale('civilian_outfit'),
            description = Config.CustomLocale('civilian_desc'),
            args = {
                type = 'civ',
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
                    type = 'work',
                    name = v.label,
                    armor = v.armor or 0, 
                    outfit = v.outfits[grade] or v.outfits[0]
                },
                icon = v.icon
            })
        end

        lib.registerMenu({
            id = 'txc_wardrobe_society',
            title = data.label,
            position = Config.MenuPosition,
            options = elements,
            onClose = function()
                openMainMenu(data)
            end
        }, function(selected, scrollIndex, args)
            executeOutfitChange(args.type, args.name, args.outfit, args.armor)
        end)
    
        lib.showMenu('txc_wardrobe_society')
    end

    if Config.Menu == 'oxcontext' then
        local elements = {{
            title = Config.CustomLocale('civilian_outfit'),
            description = Config.CustomLocale('civilian_desc'),
            icon = 'fa-shirt',
            args = {
                type = 'civ',
                name = '',
                armor = 0,
            },
            onSelect = function(args)
                executeOutfitChange(args.type, args.name, args.outfit, args.armor)
            end,
        }}
    
        for i, v in ipairs(data.options) do
            table.insert(elements, {
                title = v.label,
                description = v.desc,
                icon = v.icon,
                args = { 
                    type = 'work',
                    name = v.label,
                    armor = v.armor or 0, 
                    outfit = v.outfits[grade] or v.outfits[0]
                },
                onSelect = function(args)
                    executeOutfitChange(args.type, args.name, args.outfit, args.armor)
                end,
            })
        end

        lib.registerContext({
            id = 'txc_wardrobe_society',
            title = data.label,
            options = elements
        })

        lib.showContext('txc_wardrobe_society')
    end
end

function executeOutfitChange(type, name, outfit, armor)
    local playerPed = PlayerPedId()
            
    cleanPlayer(playerPed)

    if name == workoutfit then
        Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('already_wearing'), 'error')
        return
    end

    if type == 'civ' then
        setCivilianOutfit()
    elseif type == 'private' then
        setPrivateOutfit(playerPed, outfit, name)
    else
        setWorkOutfit(playerPed, outfit, name)
    end

    SetPedArmour(playerPed, armor)
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

    Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('civilian_notify'), 'success')

    workoutfit = ''
end

-- puts the selected outfit on
function setPrivateOutfit(playerPed, outfit, name)
    workoutfit = name

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('skinchanger:loadClothes', skin, outfit)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('esx_skin:save', skin)
        end)
    end)

    Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('outfit_notify', '{outfit}', name), 'success')
end

-- puts the selected outfit on
function setWorkOutfit(playerPed, outfit, name)
    workoutfit = name

    TriggerEvent('skinchanger:getSkin', function(skin)
        local sex = (skin.sex == 0) and "male" or "female"
        local uniform = outfit[sex]

        TriggerEvent('skinchanger:loadClothes', skin, uniform)
    end)

    Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('outfit_notify', '{outfit}', name), 'success')
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

        Citizen.Wait(Config.UpdateIntervall)
    end
end

function getOutfits()
    local outfitList = lib.callback.await('TxcWardrobes:HandlePlayerJoin')

    savedOutfits = json.decode(outfitList[1].outfits)
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

RegisterCommand('txctest', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        
    end)

    TriggerEvent('skinchanger:getSkin', function(skin)
        print(skin.shoes_1)
        local sex = (skin.sex == 0) and "male" or "female"
        local uniform = { shoes_1 = 20 }

        TriggerEvent('skinchanger:loadClothes', skin, uniform)
        TriggerEvent('skinchanger:getSkin', function(skin)

            print(skin.shoes_1)
        end)
    end)
end, false)