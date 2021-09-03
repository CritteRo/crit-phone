RegisterNetEvent('critPhoneApps.ReceiveEmail')
RegisterNetEvent('critPhoneApps.ReceiveMessage')

AddEventHandler('critPhoneApps.ReceiveEmail', function(email)
    local mails = {title = email.title, to = email.to, from = email.from, message = email.message, event = 'critPhoneApps.OpenEmail'}
    mails.eventParams = mails
    TriggerEvent('scalePhone.BuildAppButton', 'app_email', mails, true, -1)
    TriggerEvent('scalePhone.AddAppNotification', 'app_email')
end)

AddEventHandler('critPhoneApps.ReceiveMessage', function(sms, isMine)
    local mess = {contact = sms.contact, h = GetClockHours(), m = GetClockMinutes(), message = sms.message, event = 'critPhoneApps.OpenMessage', isentthat = isMine, hasPic = sms.hasPic}
    mess.eventParams = mess
    if sms.hasPic ~= nil then
        mess.hasPic = sms.hasPic
    end
    TriggerEvent('scalePhone.BuildAppButton', 'app_messages', mess, true, -1)
    if isMine == false then
        TriggerEvent('scalePhone.AddAppNotification', 'app_messages')
    end
end)

AddEventHandler('critPhoneApps.OpenMessage', function(data)
    TriggerEvent('scalePhone.BuildMessageView', data)
    TriggerEvent('scalePhone.OpenApp', 1000, false)
end)

AddEventHandler('critPhoneApps.OpenEmail', function(data)
    TriggerEvent('scalePhone.BuildEmailView', data)
    TriggerEvent('scalePhone.OpenApp', 1001, false)
end)