fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'A collection of apps for the scalePhone framework.'

dependencies {
    'pmaVoice',
    'scalePhone'
}

client_scripts {
    'client/cl_phone_main.lua',
}

server_scripts {
    'server/sv_connections.lua',
    'server/sv_phone_main.lua',
}