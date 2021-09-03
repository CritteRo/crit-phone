RegisterNetEvent('critPhoneApps.sv.SetSleepMode')
RegisterNetEvent('critPhoneApps.sv.SendSMS')
RegisterNetEvent('critPhoneApps.sv.SendCall')
RegisterNetEvent('critPhoneApps.sv.SendPost')
RegisterNetEvent('critPhoneApps.sv.SendCallUpdate')


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
        contacts[row] = k
        row = row + 1
    end
    for _,player in ipairs(GetPlayers()) do --building online players, from ALL ONLINE PLAYERS. If you can get a contact array, this is where you would want it.
        contacts[row] = {name = GetPlayerName(player), pic = 'CHAR_BLANK_ENTRY', isBot = false, svID = player}
        row = row + 1
    end
    TriggerClientEvent('critPhoneApps.UpdateContacts', -1, contacts) --updating contact list for ALL players.
end)

RegisterCommand('critgetcontacts', function(source, args)
    local src = source
    if src == 0 then -- only if it's the console
        for i,player in ipairs(GetPlayers()) do
            inCall[player] = { --making sure we have the goddamn array set.
                name = GetPlayerName(player),
                status = 0,
                sleepMode = 0,
                lang = "en",
            }
        end 
        TriggerEvent('critPhoneApps.sv.GatherContacts')
    end
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

--[[  ::  MESSAGING  ::  ]]--
AddEventHandler('critPhoneApps.sv.SendSMS', function(to, message, isBot, svID)
    local src = source
    if isBot ~= nil and isBot == true then --is playerSource trying to message a bot?
        for i,k in pairs(bots) do
            if k.name == to then --if yes, and the bot name matches, then:
                TriggerEvent(k.botEvent, src, message, k) -- triggers the bot's event, with params: playerSource, player's raw message and the bot array.
            end
        end
    else --if not sending to a bot, then:
        local senderid = 0
        if tonumber(svID) ~= nil and GetPlayerPing(tonumber(svID)) ~= 0 then --if svID exists and is a valid player id.
            senderid = tonumber(svID) 
        else
            for _,player in ipairs(GetPlayers()) do -- trying to find the player, from the contact name.
                if GetPlayerName(player) == to then
                    senderid = player
                    break
                end
            end
        end
        if senderid ~= 0 then --if a player id was successfully found.
            if inCall[senderid] ~= nil then
                if inCall[senderid].sleepMode == 0 or inCall[senderid].sleepMode == false then --if sleepMode == false, send the message.
                    TriggerClientEvent('critPhoneApps.ReceiveMessage', src, {contact = GetPlayerName(senderid), message = message}, true) --sending the message back to source, but with a "itsMine" tag.
                    Citizen.Wait(200)
                    TriggerClientEvent('critPhoneApps.ReceiveMessage', senderid, {contact = GetPlayerName(src), message = message}, false) --sending the message to the sender player id.
                else --if sleepMode is active, send "error" message back to source
                    TriggerClientEvent('critPhoneApps.ReceiveMessage', src, {contact = GetPlayerName(senderid), message = "Thank you for reaching out to me!\n\nAt the moment, I do not wish to be contacted via message."}, false) --sending the message back to source, but with a "itsMine" tag.
                end
            else
                TriggerClientEvent('critPhoneApps.ReceiveMessage', src, {contact = GetPlayerName(senderid), message = message}, true) --sending the message back to source, but with a "itsMine" tag.
                Citizen.Wait(200)
                TriggerClientEvent('critPhoneApps.ReceiveMessage', senderid, {contact = GetPlayerName(src), message = message}, false) --sending the message to the sender player id.
            end
            --if you have a notification script, you can plug it here.
        else
            --player not found, trigger a notification here, maybe.
        end
    end
end)


--[[  ::  CALLING  ::  ]]--
AddEventHandler('critPhoneApps.sv.SendCall', function(name, pic, isBot, svID)
    local src = source
    if isBot ~= nil and isBot == true then --is playerSource trying to call a bot?
        TriggerClientEvent('critPhoneApps.ReceiveCall', src, "dialing", name, pic, isBot) -- we keep him in dialing for some time.
        Citizen.Wait(math.random(2,6) * 1000)
        TriggerClientEvent('critPhoneApps.ReceiveCall', src, "hangup", name, pic, isBot) --then hang up.
        --[[for i,k in pairs(bots) do  -- if you want to trigger the bot's event, you can do it here. 
            if k.name == name then
                TriggerEvent(k.botEvent, src, "scalePhone.Internal.BotWasCalled", k)
            end
        end]]
    else -- if not a bot, then:
        local id = nil
        for i,k in pairs(inCall) do --if inCall[playerSource] exists. Told you it was important
            if k.name == name then
                if GetPlayerPing(i) ~= 0 then
                    id = i --we found our player id.
                    break
                end
            end
        end
        if id ~= nil then
            if inCall[id].status == 0 then
                if inCall[id].sleepMode == false or inCall[id].sleepMode == 0 then
                    local row = #calls + 1
                    calls[row] = {caller1 = src, caller2 = id, status = "dialing" --[[dialing, connected, completed]]} --creating a new call id.
                    inCall[src].status = row --setting the call id as status.
                    inCall[id].status = row --setting the call id as status.
                    setPlayerCallChannel(src, row) --check sv_connections.lua to set the correct voice-chat resource.
                    TriggerClientEvent('critPhoneApps.ReceiveCall', src, "dialing", GetPlayerName(id), "CHAR_BLANK_ENTRY", false) --sending 'dialing' call update to source
                    TriggerClientEvent('critPhoneApps.ReceiveCall', id, "calling", GetPlayerName(src), "CHAR_BLANK_ENTRY", false) --sending the call to the called player.
                else
                    --sleep mode is activated for the other caller. Rejecting.
                    TriggerClientEvent('critPhoneApps.ReceiveCall', src, "rejected", name, pic, false)
                end
            else
                --player is already in a call. Rejecting yours.
                TriggerClientEvent('critPhoneApps.ReceiveCall', src, "rejected", name, pic, false)
            end
        else
            --player couldn't be found. Rejecting the call
            TriggerClientEvent('critPhoneApps.ReceiveCall', src, "rejected", name, pic, false)
        end
    end
end)

AddEventHandler('critPhoneApps.sv.SendCallUpdate', function(update)
    local src = source
    if inCall[src] ~= nil and inCall[src].status ~= 0 then
        local foundCall = nil
        for i,k in pairs(calls) do --looking a call id where source is present
            if k.caller1 == src or k.caller2 == src then
                if k.status ~= "completed" then --making sure the call didn't end already.
                    foundCall = i
                end
            end
        end
        if foundCall ~= nil then
            local other = nil
            if calls[foundCall].caller1 == src then --checking if the source if caller1 or caller2 in the call id.
                other = calls[foundCall].caller2
            elseif calls[foundCall].caller2 == src then
                other = calls[foundCall].caller1
            end
            if update == "answer" then
                --this is where you set the Call Channel for caller2
                setPlayerCallChannel(src, foundCall)
                calls[foundCall].status = "connected"
                TriggerClientEvent('critPhoneApps.ReceiveCall', src, "responded", GetPlayerName(other), "CHAR_BLANK_ENTRY", false)
                TriggerClientEvent('critPhoneApps.ReceiveCall', other, "responded", GetPlayerName(src), "CHAR_BLANK_ENTRY", false)
            elseif update == "hangup" then
                --this is where you cancel both calls.
                inCall[src].status = 0
                inCall[other].status = 0
                calls[foundCall].status = "completed"
                setPlayerCallChannel(src, 0)
                setPlayerCallChannel(other, 0)
                TriggerClientEvent('critPhoneApps.ReceiveCall', src, "hangup", GetPlayerName(other), "CHAR_BLANK_ENTRY", false)
                TriggerClientEvent('critPhoneApps.ReceiveCall', other, "hangup", GetPlayerName(src), "CHAR_BLANK_ENTRY", false)
            end
        end
    end
end)


--[[  ::  LIFE INVADER  ::  ]]--
--Keep in mind that life invader posts don't get saved. When a player joins, he won't be able to see past posts.
AddEventHandler('critPhoneApps.sv.SendPost', function(post)
    local src = source
    local Name = GetPlayerName(src) --name that will show to everyone in the post.
    local triggersNotification = true -- if "true", it will add a +1 on the LifeInvader icon on the phone homepage.
    TriggerClientEvent('critPhoneApps.ReceivePost', -1, {name = Name, title = post.title, message = post.message}, triggersNotification) --sends the post to all online players.
    --you might want some notification here. When a post gets created.
end)
