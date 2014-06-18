
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
-- DS = device.directorySeparator
-- LOCAL_RES_DIR = device.writablePath .. DS .. "script" .. DS .. "app"
LOCAL_RES_DIR = "D:\\Project\\kt-cocos2dx\\quick-cocos2dx-shell\\scripts\\app\\"

-- device.writablePath .. device.directorySeparator
LOCAL_RES_PLIST = LOCAL_RES_DIR .. "local_version.plist"
LOCAL_TMP_PLIST = LOCAL_RES_DIR .. "remote_version.plist"
print(" LOCAL_RES_PLIST : " .. LOCAL_RES_PLIST)
print(" LOCAL_TMP_PLIST : " .. LOCAL_TMP_PLIST)

-- Remote Application Path
REMOTE_RES_PLIST = "http://gii.doopp.com/upload/last_version.plist"

-- Remote Config URL
REMOTE_CONFIG_URL = ""