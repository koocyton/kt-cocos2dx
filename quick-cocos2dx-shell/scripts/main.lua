require("config")
require("framework.init")

LOCAL_RES_PATH = device.writablePath .. LOCAL_RES_PATH

LOCAL_RES_PLIST = LOCAL_RES_PATH .. device.directorySeparator .. LOCAL_RES_PLIST

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

-- begin goto welcome scene
local scene = require("WelcomeScene").new()
display.replaceScene(scene)