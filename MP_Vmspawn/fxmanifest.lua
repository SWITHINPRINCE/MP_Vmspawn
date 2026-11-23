fx_version 'cerulean'
game 'gta5'

author 'QBX VMSpawn'
description 'VMSpawn - Fully Upgraded Vehicle Spawner for QBX Core'
version '1.0.0'

dependencies {
    'ox_lib',
    'qbx_core',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/suggestions.lua',
    'client/main.lua',
}

lua54 'yes'
