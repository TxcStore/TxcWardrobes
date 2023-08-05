fx_version 'cerulean'
use_fxv2_oal 'yes'
games { 'gta5' }
lua54 'yes'

author 'TxcStore'
description 'One of the most versatile wardrobe systems out there, which is compatible with the ESX framework. It offers high customisability, in terms of interactions and the visuals itself.' 
version '0.9.5 Pre-Release'

dependencies {
    'ox_lib',
    'skinchanger',
    -- 'TxcBase' -- optional
    -- 'ox_target' -- optional
}

client_scripts {
    'data/config.lua',
    'data/custom.lua',
    'data/wardrobes.lua',
    'data/locales.lua',
    
    'client/client.lua',
    'client/exports.lua'
}

exports {
    'saveOutfit',
    'openWardrobe'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

    'data/config.lua',
    'data/custom.lua',
    'data/wardrobes.lua',
    'data/locales.lua',

    'server/server.lua'
}

escrow_ignore {
    'data/*.lua',
    'client/*.lua',
    'server/*.lua'
}
