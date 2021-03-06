fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'A collection of apps for the scalePhone framework.'

dependencies {
    'scalePhone',
}

client_scripts {
    'client/cl_phone_homepage.lua',
    'client/cl_phone_contacts.lua',
    'client/cl_phone_messagesAndEmail.lua',
    'client/cl_phone_lifeinvader.lua',
    'client/cl_phone_moreApps.lua',
}

server_scripts {
    'server/sv_connections.lua',
    'server/sv_phone_main.lua',
}