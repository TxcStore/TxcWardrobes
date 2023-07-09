function saveOutfit(name, outfit)
    lib.callback('TxcWardrobes:SavePrivateOutfit', false, function(newOutfitList)
        --exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'outfit saved successfully', 'success')
        savedOutfits = newOutfitList
    end, savedOutfits, outfit, name)
end

function openWardrobe(id)
    local data = Wardrobes[id]

    openMainMenu(data)
end