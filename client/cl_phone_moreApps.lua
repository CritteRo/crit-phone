--[[
    This is where you can add your own apps (WOOOOOOO!) using the scalePhone framework.
    For example, I will add a "Rules" view for you.
]]

--[[  ::  Adding buttons to "More Apps"  ::  ]]--
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Rules", icon = 23, event = "scalePhone.OpenApp", eventParams = 'app_rules'}, false, -1) --icon = 0 means that it wont show at all. Icons are different than the homepage ones.
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Trackify", icon = 0, event = "scalePhone.OpenApp", eventParams = 'app_track'}, false, -1) --icon = 0 means that it wont show at all. Icons are different than the homepage ones.

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
local trackPoints = {
    {coords = vector3(2330.24,2571.88,46.67), alwaysOnScreen = true, referenceID = "oxium_123_ref_01"}, -- go here :)
}

TriggerEvent('scalePhone.BuildApp', 'app_track', "trackifyView", "Trackify", 42, 0, "", "scalePhone.GoBackApp", {backApp = 'app_more'})

for i,k in pairs(trackPoints) do
    TriggerEvent('scalePhone.BuildAppButton', 'app_track', k, false, -1)
end
------------------

