require("config")
require("framework.init")
require("app_config")

function trim(s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

-- begin goto welcome scene
local scene = require("UpgradeScene").new()
display.replaceScene(scene)