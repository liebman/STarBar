# :star: STarBar :star:
## A Mac Menu Bar App for controlling your SmartThings Hub

:zap: This is a work in progress, thanks for your patience! :zap:

This project makes use of the [homebridge-smartthings](https://github.com/pdlove/homebridge-smartthings) 'JSON Complete API' application for the SmartThings hub. Please follow these instructions to install that:

> Log into your SmartThings account at https://graph.api.smartthings.com/
Goto "My SmartApps"
Click on Settings and add the repository with Owner of "pdlove" and name of "homebridge-smartthings" and branch of "master" and then click save.
Click "Update From Repo" and select "homebridge-smartthings"
You should have json-complete-api in the New section. Check it, check Publish at the bottom and click "Execute Update".

> Click on the app in the list and then click "App Settings"

> Scroll down to the OAuth section and click "Enable OAuth in Smartapp"
Select "Update" at the bottom.

> In the SmartThings App, goto "Marketplace" and select "SmartApps". At the bottom of the list, select "My Apps"

> Select "JSON Complete API" from the list.
Tap the plus next to an appropriate device group and then check off each device you would like to use.
There are several categories because of the way Smartthings assigns capabilities.
Almost all devices contain the Refresh capability and are under the "Most Devices" group
Some sensors don't have a refresh and are under the "Sensor Devices" group.
Some devices, mainly Virtual Switches, only have the Switch Capability and are in the "All Switches".
If you select the same device in multiple categories it will only be shown once in HomeKit, so you can safely check them all in all groups.
If a device isn't listed, let me know by submitting an issue on GitHub.
Tap Done and then Done.

Place the 'app_id' and 'access_token' codes in the Connection Information window of STarBar. To get this information, open SmartThings on your phone, goto "My Home">"SmartApps">"JSON Complete API" and tap on Config.
