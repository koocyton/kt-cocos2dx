-- device udid
DEVICE_UUID = device.getOpenUDID

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

DS = "/";

-- Location Application Path
LOCAL_RES_DIR = device.writablePath
if (device.platform=="windows") then
	LOCAL_RES_DIR = device.writablePath .. "res/"
	DS = "\\"
	LOCAL_RES_DIR = string.gsub(LOCAL_RES_DIR, "/", "\\")
end

-- device.writablePath .. device.directorySeparator
LOCAL_RES_PLIST = LOCAL_RES_DIR .. "local_version.flist"
LOCAL_TMP_PLIST = LOCAL_RES_DIR .. "remote_version.flist"

-- Remote Application Path
REMOTE_RES_PLIST = "http://static1.kunlun.com/test-game1/com.koramgame.ios.fysgtw"

-- Remote Config URL
REMOTE_CONFIG_URL = ""