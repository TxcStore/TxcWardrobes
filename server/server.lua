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

-- handle player join
lib.callback.register('TxcWardrobes:HandlePlayerJoin', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local result = MySQL.query.await('SELECT * FROM `txc_wardrobes` WHERE id = ?', { identifier })
    
    if not result[1] then
        MySQL.insert('INSERT INTO `txc_wardrobes` (id, job, outfits) VALUES (?, ?, ?)', { identifier, 0, json.encode({}) })
        Config.CustomPrint("new entry for '" .. identifier .. "' created", 'info') 

        result = {}
    else
        result = json.decode(result[1].outfits)
    end

    return result
end)

-- save new private outfit
lib.callback.register('TxcWardrobes:SavePrivateOutfit', function(source, outfitList, outfitToSave, outfitName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    table.insert(outfitList, { name = outfitName, outfit = outfitToSave })
    Config.CustomPrint("new outfit '" .. outfitName .. "' for '" .. identifier .. "' saved", 'info')

    local result = MySQL.update('UPDATE `txc_wardrobes` SET outfits = ? WHERE id = ?', { json.encode(outfitList), identifier })

    return outfitList
end)

-- rename private outfit
lib.callback.register('TxcWardrobes:RenamePrivateOutfit', function(source, outfitList, uuid, outfitName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    outfitList[uuid].name = outfitName
    Config.CustomPrint("outfit from '" .. identifier .. "' to '" .. outfitName .. "' renamed", 'info')

    local result = MySQL.update('UPDATE `txc_wardrobes` SET outfits = ? WHERE id = ?', { json.encode(outfitList), identifier })

    return outfitList
end)

-- delete private outfit
lib.callback.register('TxcWardrobes:DeletePrivateOutfit', function(source, outfitList, uuid)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    table.remove(outfitList, uuid)
    Config.CustomPrint("outfit from '" .. identifier .. "' with id '" .. uuid .. "' deleted", 'info') 

    local result = MySQL.update('UPDATE `txc_wardrobes` SET outfits = ? WHERE id = ?', { json.encode(outfitList), identifier })

    return outfitList
end)
