fx_version 'cerulean'
game 'gta5'

author 'Leon2024'
description 'Money Wash Script with Timer, Staff Tiers & Discord Logging'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory'
}
