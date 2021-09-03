fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'A collection of apps for the scalePhone framework.'

dependencies {
    'pma-voice',
    'scalePhone'
}

client_scripts {
    'client/cl_phone_homepage.lua',
    'client/cl_phone_contacts.lua',
    'client/cl_phone_messagesAndEmail.lua',
}

server_scripts {
    'server/sv_connections.lua',
    'server/sv_phone_main.lua',
}