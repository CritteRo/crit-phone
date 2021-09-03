RegisterNetEvent('critPhoneApps.sv.SetSleepMode')


bots = { --want bots on the server? For groups? Or maybe a "Help Desk"? This is where you add them.
    --[0] = {name = "Bot Name", pic = 'CHAR_MP_FM_CONTACT', isBot = true, botEvent = "botEvent", svID = -1},
}

inCall = { -- Every online player MUST HAVE a array here (for calls). I will make sure this happens, don't worry.
    [0] = {
        name = "Console",
        status = 0, --0 = not in call, >=1 = in call
        sleepMode = 0, --sleep mode
        lang = "en", --not used. But keep it here for now.
    }
}

calls = {
    [0] = {caller1 = 0, caller2 = 0, status = "dialing" --[[dialing, connected, completed]]}, --those are "calls". Every time a call is performed. 
}

AddEventHandler('critPhoneApps.sv.GatherContacts', function() --gathering a contact list for ALL CLIENTS.
    local row = 0
    contacts = {}
    for i,k in pairs(bots) do --building bots first
        onlinePlayers[row] = k
        row = row + 1
    end
    for _,player in ipairs(GetPlayers()) do --building online players, from ALL ONLINE PLAYERS. If you can get a contact array, this is where you would want it.
        contacts[row] = {name = GetPlayerName(player), pic = 'CHAR_BLANK_ENTRY', isBot = false, svID = player}
        row = row + 1
    end
    TriggerClientEvent('critPhoneApps.UpdateContacts', -1, contacts) --updating contact list for ALL players.
end)

AddEventHandler('critPhoneApps.sv.SetSleepMode', function(mode) --setting sleep mode for source. Used only in player-made calls and messages. Not affected by emails or bots >:)
    local src = source
    if inCall[src] ~= nil then
        inCall[src].sleepMode = mode
    end
end)


AddEventHandler('playerDropped', function (reason)
    local src = source
    --maybe clear the inCall array? Might break something, so I not doing it, for now. But if you have a big server, you might want to.
    TriggerEvent('critPhoneApps.sv.GatherContacts')
end)

AddEventHandler('playerJoining', function(oldID) --if you have your own way of getting the players, like ESX or whatever, this might not be needed. Instead setup your ESX data, and then create the inCall[playerSource] array.
    local src = source
    print(src)
    inCall[src] = { --making sure we have the goddamn array set.
        name = GetPlayerName(src),
        status = 0,
        sleepMode = 0,
        lang = "en",
    }
    TriggerEvent('critPhoneApps.sv.GatherContacts')
end)