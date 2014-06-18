
-- package name
PACKAGE_NAME = "com.koramgame.ios.fysgtw"

-- union ID
PRODUCT_UNION_ID = "1023"

-- union SID
PRODUCT_UNION_SID = "1023"

-- product ID
PRODUCT_ID = "1023"

-- Device ID Post URL
DEVICE_POST_URL = ""

-- Location Application Path
LOCAL_RES_DIR = device.writablePath .. "script/app/"
if (device.platform=="windows") then
	LOCAL_RES_DIR = string.gsub(LOCAL_RES_DIR, "/", "\\")
end

-- device.writablePath .. device.directorySeparator
LOCAL_RES_PLIST = LOCAL_RES_DIR .. "local_version.plist"
LOCAL_TMP_PLIST = LOCAL_RES_DIR .. "remote_version.plist"

-- Remote Application Path
REMOTE_RES_PLIST = "http://gii.doopp.com/upload/last_version.plist"

-- Remote Config URL
REMOTE_CONFIG_URL = ""