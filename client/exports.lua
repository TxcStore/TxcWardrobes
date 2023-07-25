function saveOutfit(name, outfit, notify)
    local outfitToSave = {}

    for k, v in pairs(Config.SavedComponents) do
        outfitToSave[v] = outfit[v]
    end

    lib.callback('TxcWardrobes:SavePrivateOutfit', false, function(newOutfitList)
        --exports['TxcBase']:debugPrint(GetCurrentResourceName(), 'outfit saved successfully', 'success')
        savedOutfits = newOutfitList

        if notify then
            Config.CustomNotify(Config.CustomLocale('title'), Config.CustomLocale('outfit_save_success'), 'success')
        end
    end, savedOutfits, outfitToSave, name)
end

function openWardrobe(id)
    local data = Wardrobes[id]

    openMainMenu(data)
end