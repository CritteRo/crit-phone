RegisterNetEvent('critPhoneApps.ReceivePost')

TriggerEvent('scalePhone.BuildAppButton', 'app_lifeinvader', {text = "Write post", event = "critPhoneApps.WriteLifeinvaderPost", eventParams = {}}, false, -1) --This is where you can write the post.
TriggerEvent('scalePhone.BuildAppButton', 'app_lifeinvader', {text = "View Posts", event = "scalePhone.OpenApp", eventParams = 'view_posts'}, false, -1) --opens the posts view

TriggerEvent('scalePhone.BuildApp', 'view_posts', "emailList", "LifeInvader", 14, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_lifeinvader'}) --this is the posts view.



AddEventHandler('critPhoneApps.ReceivePost', function(twit, triggerNotification)
    local twot = {title = twit.title, to = "everyone", from = twit.name.."@lifeinvader", message = twit.message, event = 'critPhoneApps.OpenEmail'} --you can modify "@lifeinvader" to your server name...or delete it, idc.
    twot.eventParams = twot
    TriggerEvent('scalePhone.BuildAppButton', 'view_posts', twot, true, -1)
    if triggerNotification then
        TriggerEvent('scalePhone.AddAppNotification', 'app_lifeinvader') --adds a notification to the Life Invader icon on the homepage
    end
end)

AddEventHandler('critPhoneApps.WriteLifeinvaderPost', function(data)
    local post = {title = "", message = ""},
    AddTextEntry('MS_PROMPT_LI1', "New lifeInvader Post: Add Title")
    AddTextEntry('MS_PROMPT_LI2', "New lifeInvader Post: Post")
    DisplayOnscreenKeyboard(1, "MS_PROMPT_LI1", "", "", "", "", "", 50)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        post.title = GetOnscreenKeyboardResult()
        DisplayOnscreenKeyboard(1, "MS_PROMPT_LI2", "", "", "", "", "", 350)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            post.message = GetOnscreenKeyboardResult()
            TriggerServerEvent('critPhoneApps.sv.SendPost', post)
        end
    end
end)
