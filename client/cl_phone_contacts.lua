RegisterNetEvent('critPhoneApps.UpdateContacts')
RegisterNetEvent('critPhoneApps.ReceiveCall')

AddEventHandler('critPhoneApps.UpdateContacts', function(contacts) --we receive contacts from the server-side.
    TriggerEvent('scalePhone.ResetAppButtons', 1) --first. We clear all contacts that we currently have.
    
    for i,k in pairs(contacts) do
        --local idc = {name = k.name, pic = k.pic, isBot = k.isBot, event = "eventName", eventParams = {name = k.name, isBot = k.isBot}}
        local idc = {name = k.name, pic = k.pic, isBot = k.isBot, event = "critPhoneApps.OpenContactView", eventParams = {name = k.name, isBot = k.isBot, pic = k.pic, svID = k.svID}}
        if k.svID ~= nil then --if we got the server ID, or playerSrc, from the server, we include it in the eventParams. WE SHOULD GET IT, BY THE WAY.
            idc.eventParams.svID = k.svID
        end
        TriggerEvent('scalePhone.BuildAppButton', 'app_contacts', idc, k.isBot, -1) --adding the contact. If it's a bot, we add it at the top. 
    end

end)

TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "critPhoneApps.CloseCall", {backApp = 'app_contacts', contact = "unk", pic = "", status = "DIALING", canAnswer = false, selectEvent = ""})
AddEventHandler('critPhoneApps.OpenContactView', function(data) --this is the contact view. Where we have multiple options, like calling or messaging.
    TriggerEvent('scalePhone.BuildApp', 'app_contact_view', "settings", data.name, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_contacts'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Call", icon = 25, event = "critPhoneApps.SendCall", eventParams = data}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Message", icon = 19, event = "critPhoneApps.SendSMS", eventParams = data}, false, -1)
    if tonumber(data.svID) > 0 then --if it's not a bot, add these buttons too.
        --nothing here (yet!)
    end

    TriggerEvent('scalePhone.OpenApp', 'app_contact_view', false) --at the end, we open the app.
end)

AddEventHandler('critPhoneApps.SendCall', function(data)
    TriggerEvent('scalePhone.BuildCallscreenView', {backApp = 'app_contacts', contact = data.name, pic = data.pic, status = "CALLING", canAnswer = false, selectEvent = ""}, 'call_screen')
    TriggerEvent('scalePhone.OpenApp', 'call_screen', false)
    TriggerServerEvent('critPhoneApps.sv.SendCall', data.name, data.pic, data.isBot, data.svID)
end)

AddEventHandler('critPhoneApps.SendSMS', function(data)
    AddTextEntry('MS_PROMPT_SMS', "Send message to "..data.name..":")
    openMessagePrompt(data.name, data.isBot, data.svID)
end)

AddTextEntry('MS_PROMPT_SMS', "Send message:")
function openMessagePrompt(name, isBot, svID)
    Citizen.CreateThread(function()
        DisplayOnscreenKeyboard(1, "MS_PROMPT_SMS", "", "", "", "", "", 150)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            TriggerServerEvent('critPhoneApps.sv.SendSMS', name, result, isBot, svID)
        end
        AddTextEntry('MS_PROMPT_SMS', "Send message: ")
    end)
end

AddEventHandler('critPhoneApps.ReceiveCall', function(status, name, pic, isBot) --receiving a call, or a call update.
    if status == "dialing" then --client IS CALLING someone
        StopPedRingtone(PlayerPedId())
        PlayPedRingtone("Remote_Ring", PlayerPedId(), 1)
    elseif status == 'rejected' then --call gets rejected, or other person is not available / in Sleep Mode / in other call etc.
        StopPedRingtone(PlayerPedId())
        TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "critPhoneApps.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "REJECTED"})
        TriggerEvent('scalePhone.OpenApp', 'call_screen')
        Citizen.Wait(3000)
        if exports.scalePhone:getAppOpen(false) == 'call_screen' then
            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
            ExecuteCommand('phoneback')
        end
    elseif status == 'calling' then --Client gets called by someone.
        StopPedRingtone(PlayerPedId())
        TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "critPhoneApps.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "IS CALLING", canAnswer = true, selectEvent = "critPhoneApps.AnswerCall"})
        TriggerEvent('scalePhone.OpenApp', 'call_screen', true)
        PlayPedRingtone("PHONE_GENERIC_RING_01", PlayerPedId(), 0)
    elseif status == 'responded' then --Call gets answered by other person. You now should be in the Call channel.
        StopPedRingtone(PlayerPedId())
        if exports.scalePhone:getAppOpen(false) == 'call_screen' then
            TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "critPhoneApps.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "CONNECTED"})
            TriggerEvent('scalePhone.OpenApp', 'call_screen')
        end
    elseif status == 'hangup' then --Other persone hanged up the call.
        StopPedRingtone(PlayerPedId())
        if exports.scalePhone:getAppOpen(false) == 'call_screen' then
            TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "critPhoneApps.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "CALL ENDED"})
            TriggerEvent('scalePhone.OpenApp', 'call_screen')
            Citizen.Wait(3000)
            if exports.scalePhone:getAppOpen(false) == 'call_screen' then
                PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
                ExecuteCommand('phoneback')
            end
        end
    end
end)

AddEventHandler('critPhoneApps.AnswerCall', function()
    TriggerServerEvent('critPhoneApps.sv.SendCallUpdate', 'answer')
end)

AddEventHandler('critPhoneApps.CloseCall', function(data)
    TriggerServerEvent('critPhoneApps.sv.SendCallUpdate', 'hangup')
    TriggerEvent('scalePhone.GoBackApp', data)
end)


--[[ IN CASE OF MUMBLE VOIP. PLEASE UPGRADE TO PMA-VOICE INSTEAD.
RegisterNetEvent('critPhoneApps.SetPlayerCallChannel')
AddEventHandler('critPhoneApps.SetPlayerCallChannel', function(channel)
    exports['mumble-voip']:SetCallChannel(tonumber(channel))
end)
]]