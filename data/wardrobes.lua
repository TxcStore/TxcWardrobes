--[[
██╗    ██╗ █████╗ ██████╗ ██████╗ ██████╗  ██████╗ ██████╗ ███████╗███████╗
██║    ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝██╔════╝
██║ █╗ ██║███████║██████╔╝██║  ██║██████╔╝██║   ██║██████╔╝█████╗  ███████╗
██║███╗██║██╔══██║██╔══██╗██║  ██║██╔══██╗██║   ██║██╔══██╗██╔══╝  ╚════██║
╚███╔███╔╝██║  ██║██║  ██║██████╔╝██║  ██║╚██████╔╝██████╔╝███████╗███████║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝                                                                  
--]]

Wardrobes = {
    ['main_wardrobe'] = {
        label = 'LSPD Garderobe', -- the title of the wardrobe menu
        job = 'police', -- the job that is allowed to open the wardrobe ('none' for everyone)
        coords = vec3(456.4519, -989.0461, 30.6896),
        polyzones = { -- if you use ox_target this is required
            { -- it is also possible for multiple zones to access the same wardrobe
                coords = vec3(457.66, -987.51, 31.09),
                size = vec3(5.4, 0.5, 1.95),
                rotation = 180
            }
        },
        marker = { -- if you want a marker this is required
            type = 20,
            size = { x = 0.9, y = 0.9, z = 0.9 },
            color = { r = 0, g = 144, b = 255, a = 100 },
        },
        options = { 
            {
                label = 'Uniform', -- the name of the outfit
                desc = 'The regular uniform of a patrol officer.', -- optional description of the outfit
                icon = 'fa-user-tie', -- choose the font awesome icon
                armor = 0, -- if you want to set the player armor (max is 100)
                outfits = {
                    [0] = { -- if you have job grade-dependent uniforms, enter the respective grade (otherwise 0)
                        male = { -- check skinchanger client main.lua for matching elements
                            tshirt_1 = 58,    tshirt_2 = 0,
                            torso_1 = 55,     torso_2 = 0,
                            decals_1 = 0,     decals_2 = 0,
                            arms = 0,
                            pants_1 = 35,     pants_2 = 0,
                            shoes_1 = 25,     shoes_2 = 0,
                            helmet_1 = 46,    helmet_2 = 0,
                            chain_1 = 0,      chain_2 = 0,
                        }, -- leave out parts that you don't want to change
                        female = {
                            tshirt_1 = 35,  tshirt_2 = 0,
                            torso_1 = 48,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 14,
                            pants_1 = 34,   pants_2 = 0,
                            shoes_1 = 27,   shoes_2 = 0,
                            helmet_1 = 45,  helmet_2 = 0,
                            chain_1 = 0,    chain_2 = 0,
                        }
                    }
                }
            }
        }
    }
}