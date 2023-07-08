ESX = nil
local mySQLReady = false

-- setup framework
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    elseif Config.Framework == 'new_esx' then
        ESX = exports["es_extended"]:getSharedObject()
    end
end)

-- setup database
Citizen.CreateThread(function()
    MySQL.insert.await("CREATE TABLE IF NOT EXISTS txc_wardrobes (id VARCHAR(50) NOT NULL, job TINYINT(1) NOT NULL DEFAULT 0, outfits LONGTEXT DEFAULT '[]', PRIMARY KEY (id))", {})
    exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'database established', 'success')
    mySQLReady = true
end)

-- handle player join
lib.callback.register('TxcWardrobes:HandlePlayerJoin', function(source)
    while not mySQLReady do
        Citizen.Wait(0)
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local result = MySQL.query.await('SELECT * FROM `txc_wardrobes` WHERE id = ?', { identifier })
    
    if not result[1] then
        MySQL.insert('INSERT INTO `txc_wardrobes` (id, job, outfits) VALUES (?, ?, ?)', { identifier, 0, json.encode({}) })
        exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'new entry for ' .. identifier .. ' created', 'info')
        result = {}
    end

    return result
end)

-- save new private outfit
lib.callback.register('TxcWardrobes:SavePrivateOutfit', function(source, outfitList, outfitToSave, outfitName)
    while not mySQLReady do
        Citizen.Wait(0)
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    table.insert(outfitList, { name = outfitName, outfit = outfitToSave })
    local result = MySQL.update.await('UPDATE `txc_wardrobes` SET outfits = ? WHERE id = ?', { json.encode(outfitList), identifier })

    return outfitList
end)

-- rename private outfit
lib.callback.register('TxcWardrobes:RenamePrivateOutfit', function(source, outfitList, uuid, outfitName)
    while not mySQLReady do
        Citizen.Wait(0)
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    --table.remove(outfitList, uuid)
    outfitList[uuid].name = outfitName

    local result = MySQL.update.await('UPDATE `txc_wardrobes` SET outfits = ? WHERE id = ?', { json.encode(outfitList), identifier })

    return outfitList
end)

-- delete private outfit
lib.callback.register('TxcWardrobes:DeletePrivateOutfit', function(source, outfitList, uuid)
    while not mySQLReady do
        Citizen.Wait(0)
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    table.remove(outfitList, uuid)

    local result = MySQL.update.await('UPDATE `txc_wardrobes` SET outfits = ? WHERE id = ?', { json.encode(outfitList), identifier })

    return outfitList
end)
