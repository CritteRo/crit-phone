sleepMode = exports.scalePhone:sleepModeStatus()

AddEventHandler('scalePhone.Event.SleepModeChanged', function(state) --premade event. Called whenever Sleep Mode is toggled in the settings.
    sleepMode = state
    TriggerServerEvent('critPhoneApps.sv.SetSleepMode', sleepMode)
end)

--[[  ::  HOMEPAGE APPS  ::  ]]--
-- Order of events matters here. Every event will add a new app with the specified appID, and add the shortcut on the homepage. Only the first 9 apps will show on the homepage.
TriggerEvent('scalePhone.BuildHomepageApp', 'app_contacts', "contacts", "Contacts", 5, 0, "", "scalePhone.GoToHomepage", {}) -- 1
TriggerEvent('scalePhone.BuildHomepageApp', 'app_messages', "messagesList", "Messages", 2, 0, "", "scalePhone.GoToHomepage", {}) -- 2
TriggerEvent('scalePhone.BuildHomepageApp', 'app_emails', "emailList", "Emails", 4, 0, "", "scalePhone.GoToHomepage", {}) -- 3
TriggerEvent('scalePhone.BuildHomepageApp', 'app_lifeinvader', "menu", "LifeInvader", 14, 0, "", "scalePhone.GoToHomepage", {}) -- 4
TriggerEvent('scalePhone.BuildHomepageApp', 'app_numpad', "numpad", "Numpad", 27, 0, "", "scalePhone.GoToHomepage", {}) -- 5
TriggerEvent('scalePhone.BuildHomepageApp', 'app_gps', "gps", "GPS", 58, 0, "", "scalePhone.GoToHomepage", {}) -- 6
TriggerEvent('scalePhone.BuildHomepageApp', 'app_more', "settings", "More Apps", 6, 0, "", "scalePhone.GoToHomepage", {}) -- 7
TriggerEvent('scalePhone.BuildSnapmatic', 'app_snapmatic') -- 8
TriggerEvent('scalePhone.BuildThemeSettings', 'app_settings') -- 9
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--[[  ::  NUMPAD  ::  ]]--
--Here we are building the numpad buttons. This is pretty standard, so it doesn't really need a new file.
local pad = 0
numpadNumber = 0 -- we will use this variable to store our number, when we retrieve it from the framework.
for i=1,9,1 do
    pad = {text = i, event = "scalePhone.NumpadAddNumber", eventParams = {add = i}} --adding digits 1 to 9
    TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)
end
pad = {text = 'RES', event = "scalePhone.NumpadAddNumber", eventParams = {add = 'res'}} -- "res" is predefined in the framework as a reset button. Only change the 'text' param, please.
TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)
pad = {text = 0, event = "scalePhone.NumpadAddNumber", eventParams = {add = 0}} -- digit 0
TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)
pad = {text = 'GO', event = "critPhoneApps.UseNumpadNumber", eventParams = {add = 'go'}} -- 'go' is predefined in the framework as a select button. You use this to trigger the "event" event.
TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)

AddEventHandler('scalePhone.Event.GetNumpadNumber', function(number) --predefined in the framework. Whenever you select a digit, this event will get triggered.
    numpadNumber = number
end)

AddEventHandler('critPhoneApps.UseNumpadNumber', function() --triggered whenever you hit the 'go' button on numpad
    --[[
    if numpadNumber == 123 then
        --do stuff
    end 
    ]]
end)
----------------------------------------------------------------------------------------------------------------
