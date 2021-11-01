--[[
    This is where you can add your own apps (WOOOOOOO!) using the scalePhone framework.
    For example, I will add a "Rules" view for you.
]]

--[[  ::  Adding buttons to "More Apps"  ::  ]]--
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Rules", icon = 23, event = "scalePhone.OpenApp", eventParams = 'app_rules'}, false, -1) --icon = 0 means that it wont show at all. Icons are different than the homepage ones.
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Trackify", icon = 0, event = "scalePhone.OpenApp", eventParams = 'app_track'}, false, -1) --icon = 0 means that it wont show at all. Icons are different than the homepage ones.
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Hacking App", icon = 0, event = "scalePhone.OpenApp", eventParams = 'app_hackerman'}, false, -1) --icon = 0 means that it wont show at all. Icons are different than the homepage ones.

-------------------------------------------------

--Rules
TriggerEvent('scalePhone.BuildApp', 'app_rules', "emailList", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_more'})
TriggerEvent('scalePhone.BuildApp', 'app_rules_viewer', "emailView", "Rule", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_rules', to = "", from = "", message = "", title = ""})

appRules = { --you can add more rules here.
    {title = "Section 1", to = "this is deprecated. not actually used by the framework", from = "Server Admins", message = "Section 1 is the first section of the rules.\n\nYou can add general stuff here, like:\n1. Don't be rude.\n2. Don't be weird.\n3. Check rule 1.", event = 'critPhoneApps.OpenRuleView'},
    {title = "Section 2", to = "this is deprecated. not actually used by the framework", from = "Server Admins", message = "You can use section 2 for other stuff, idk\n\n", event = 'critPhoneApps.OpenRuleView'},
    {title = "Section 3", to = "this is deprecated. not actually used by the framework", from = "Server Admins", message = "You really think you would need this many rules?\n\n\nok...", event = 'critPhoneApps.OpenRuleView'},
    {title = "Section 4", to = "this is deprecated. not actually used by the framework", from = "Server Admins", message = "Just my opinion...but I don't think many people will read this..", event = 'critPhoneApps.OpenRuleView'},
}

Citizen.CreateThread(function()
    TriggerEvent('scalePhone.ResetAppButtons', 'app_rules')
    for i,k in pairs(appRules) do --we run through all the appRules, and add them as "emails" in the app_rules app
        local rule = k
        rule.eventParams = k
        TriggerEvent('scalePhone.BuildAppButton', 'app_rules', rule, false, -1)
    end
end)

AddEventHandler('critPhoneApps.OpenRuleView', function(data)
    TriggerEvent('scalePhone.BuildEmailView', data, 'app_rules_viewer')
    TriggerEvent('scalePhone.OpenApp', 'app_rules_viewer', false)
end)
-------

--trackify
local trackPoints = { --setting up an array, to create the initial tracking points
    {coords = vector3(2330.24,2571.88,46.67)--[[XYZ coords on the map]], alwaysOnScreen = true --[[true = will always ping on the app, false = will only show when near it]], eventParams = {ref = "track_point_id_1"--[[we will use this to remove the point, if needed]]}}, -- go here :)
}

TriggerEvent('scalePhone.BuildApp', 'app_track', "trackifyView", "Trackify", 42, 0, "", "scalePhone.GoBackApp", {backApp = 'app_more'}) --building the trackify app

for i,k in pairs(trackPoints) do -- for each point in the array, create a "button", which is a point in the app
    TriggerEvent('scalePhone.BuildAppButton', 'app_track', k, false, -1)
end
------------------

---hackerman
TriggerEvent('scalePhone.BuildApp', 'app_hackerman', 'securoHack', 'SecuroServ H4x0r Client', 57, 0, '', "scalePhone.GoBackApp", {backApp = 'app_more'}) --creating the hacking app

TriggerEvent('scalePhone.BuildAppButton', 'app_hackerman', {coords = vector3(2330.24,2571.88,46.67)--[[coords]], weakSignalDist = 100.0--[[distance from where the app will show WEAK SIGNAL]], strongSignalDist = 8.0--[[distance from where you can start hacking]], hackCompleteMessage = "HACKED LOL"--[[Complete message]], timeNeeded = 5--[[in seconds]], event = "critPhoneApps.HackerClient.Hack"--[[event that will be triggered when hacking is complete]], eventParams = {message = "Test", refID = "hacking_point_1"}--[[unique param]]}, false, -1)
--the button above is the point where you can start the hacking process.

AddEventHandler('critPhoneApps.HackerClient.Hack', function(_data)
    print(_data.message)
    TriggerEvent('scalePhone.RemoveButtonUsingData', {appID = 'app_hackerman', dataSample = _data.refID})
end)]]
-----------------

