--[[
 ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝                                    
--]]

Config = {}

Config.DevMode = false -- only activate this if you're editing the config
Config.Locale = 'de' -- choose your locales (If you've created new locales for other languages, let me know via Discord)
Config.Framework = 'new_esx' -- you can choose between 'esx' and 'new_esx' (v1.9 and above)

Config.Notify = 'esx' -- choose the notification that is displayed when you change your outfit (available options: 'none', 'esx', 'ox', 'okok', 'qs' and 'custom')
Config.TextUI = 'esx' -- the text that is displayed when you enter a zone to change your outfit (available options: 'none', 'esx', 'ox', 'okok' and 'custom')

Config.Key = 38 -- the key with which you can open the wardrobe (default: E)
Config.Marker = true -- if true markers are displayed
Config.OxTarget = false -- if true you can use ox_target to interact with the wardrobe (disables the key above)

Config.PointDistance = 1.5 -- this changes the interaction distance of the wardrobe
Config.MarkerDistance = 10.0 -- this changes the draw distance of markers

Config.Menu = 'oxmenu' -- choose the menu that is displayed when you change your outfit 'oxmenu' and 'oxcontext'
Config.MenuPosition = 'top-right' -- choose between 'top-left', 'top-right', 'bottom-left' and 'bottom-right' ! ONLY FOR OXMENU !

Config.UpdateIntervall = 2000 -- time in ms in which the job and the grade are updated

Config.SavedComponents = { -- choose which components of the clothes are stored in the wardrobe
    -- general
    'torso_1',        'torso_2',
    'tshirt_1',       'tshirt_2',
    'arms',           'arms_2',
    'pants_1',        'pants_2',
    'shoes_1',        'shoes_2',
    -- accessory
    'glasses_1',      'glasses_2',
    'bracelets_1',    'bracelets_2',
    'chain_1',        'chain_2',
    'decals_1',       'decals_2',
    'watches_1',      'watches_2',
    -- headgear
    'helmet_1',       'helmet_2',
    'mask_1',         'mask_2',
    -- other
    'bproof_1',       'bproof_2',
    'bags_1',         'bags_2',
}