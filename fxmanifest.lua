fx_version 'cerulean'
use_fxv2_oal 'yes'
games { 'gta5' }
lua54 'yes'

author 'TxcStore'
description 'One of the most versatile wardrobe systems out there, which is compatible with the ESX framework. It offers high customisability, in terms of interactions and the visuals itself.' 
version '0.9.2 Pre-Release'

dependencies {
    'ox_lib',
    'skinchanger',
    -- 'TxcBase' -- coming soon
    -- 'ox_target' -- optional
}

client_scripts {
    'data/config.lua',
    'data/custom.lua',
    'data/wardrobes.lua',
    'data/locales.lua',
    'client.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

escrow_ignore {
    'data/*.lua',
    'client.lua'
}