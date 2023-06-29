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