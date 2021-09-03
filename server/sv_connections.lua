function setPlayerCallChannel(source, callChannel)
    local id = tonumber(source)
    local channel = tonumber(callChannel)
    if id ~= nil and channel ~= nil then
        --This function should be used to set the call channel for your players.
        --If your voip resource requires to set that on the client side...good luck.

        --PMA-VOICE
        exports['pma-voice']:setPlayerCall(id, channel) -- pmaVoice is the resource name. You might have it different.

        --MUMBLE-VOIP (I suggest upgrading to pma-voice instead. You need to uncomment the Event in cl_phone_contacts.lua too)
        --TriggerClientEvent('critPhoneApps.SetPlayerCallChannel', id, channel)
    else
        return 0
    end
end