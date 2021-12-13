RegisterNetEvent('critPhoneApps.ReceiveEmail')
RegisterNetEvent('critPhoneApps.ReceiveMessage')

TriggerEvent('scalePhone.BuildApp', 'app_messageView', "messageView", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_messages', contact = "Contact", message = 'unk', fromme = false, hasPic = "CHAR_BLANK_ENTRY", canOpenMenu = false, selectEvent = ""}) --creating custom app for messages.
TriggerEvent('scalePhone.BuildApp', 'app_emailView', "emailView", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_emails'}) --creating custom app for emails.

AddEventHandler('critPhoneApps.ReceiveEmail', function(email)
    local mails = {title = email.title, to = email.to, from = email.from, message = email.message, event = 'critPhoneApps.OpenEmail', canOpenMenu = false, selectEvent = ""}
    mails.eventParams = mails
    TriggerEvent('scalePhone.BuildAppButton', 'app_email', mails, true, -1)
    TriggerEvent('scalePhone.AddAppNotification', 'app_email')
end)

AddEventHandler('critPhoneApps.ReceiveMessage', function(sms, isMine)
    local mess = {svID = sms.svID, contact = sms.contact, h = GetClockHours(), m = GetClockMinutes(), message = sms.message, event = 'critPhoneApps.OpenMessage', isentthat = isMine, hasPic = sms.hasPic, canOpenMenu = true, selectEvent = "critPhoneApps.OpenMessageOptions"}
    mess.eventParams = mess
    if sms.hasPic ~= nil then
        mess.hasPic = sms.hasPic
    end
    mess.eventParams.identifier = "/"..sms.contact.."/"..sms.message.."/"..tostring(isMine).."/" -- we set up a unique string in the message data, to make sure we can find it at a later stage.
    TriggerEvent('scalePhone.BuildAppButton', 'app_messages', mess, true, -1)
       
    if isMine == false then
        TriggerEvent('scalePhone.AddAppNotification', 'app_messages')
		PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 0)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(sms.message)
		SetNotificationMessage("CHAR_MULTIPLAYER", "CHAR_MULTIPLAYER", true, 1, "<C>" .. sms.contact .. "</C>", nil)
		DrawNotification(false, true)
	else
		SetNotificationTextEntry("STRING")
		AddTextComponentString("Message was sent to <C>" .. sms.contact .. "</C>.")
		DrawNotification(false, true)
	end
end)

AddEventHandler('critPhoneApps.OpenMessage', function(data)
    TriggerEvent('scalePhone.BuildMessageView', data, 'app_messageView')
    TriggerEvent('scalePhone.OpenApp', 'app_messageView', false) -- app '1000' is a prebuilt app for message viewing. It backs out to the last application opened. Doesn't have a menu.
end)

AddEventHandler('critPhoneApps.OpenMessageOptions', function(data)
    TriggerEvent('scalePhone.BuildApp', 'app_message_options', "settings", data.contact, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_messages'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    if tonumber(data.svID) ~= nil and tonumber(data.svID) > 0 then --if it's not a bot, add these buttons too.
        TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Reply", icon = 25, event = "critPhoneApps.SendSMS", eventParams = {name = data.contact, isBot = false, svID = data.svID}}, false, -1) --Send a message back to the other player.
        TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Call "..data.contact, icon = 25, event = "critPhoneApps.SendCall", eventParams = {name = data.contact, pic = data.hasPic, isBot = false, svID = data.svID}}, false, -1) --call the other player directly
    end
    TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Delete Message", icon = 19, event = 'critPhoneApps.DeleteMessage', eventParams = {appID = 'app_messages', dataSample = data.identifier}}, false, -1) --deleting the message

    TriggerEvent('scalePhone.OpenApp', 'app_message_options', false) --at the end, we open the app.
end)

AddEventHandler('critPhoneApps.DeleteMessage', function(data)
    TriggerEvent("scalePhone.RemoveButtonUsingData", data) --deleting the message from framework
    TriggerEvent('scalePhone.GoBackApp', {backApp = 'app_messages'}) --going back to messages list.
end)

AddEventHandler('critPhoneApps.OpenEmail', function(data)
    TriggerEvent('scalePhone.BuildEmailView', data, 'app_emailView')
    TriggerEvent('scalePhone.OpenApp', 'app_emailView', false) -- app '1001' is a prebuilt app for email viewing. It backs out to the last application opened. Doesn't have a menu.
end)
