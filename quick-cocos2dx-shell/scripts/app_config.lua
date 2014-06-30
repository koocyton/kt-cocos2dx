-- Remote Config URL ( test )
REMOTE_CONFIG_URL = ""

-- Device ID ( test )
DEVICE_UUID = device.getOpenUDID

-- Device ID Post URL ( test )
DEVICE_POST_URL = ""

-- package name ( test )
PACKAGE_NAME = "com.koramgame.ios.fysgtw"

-- union ID ( test )
PRODUCT_UNION_ID = ""

-- union Son ID ( test )
PRODUCT_UNION_SID = ""

-- product ID ( test )
PRODUCT_ID = ""

-- Directory separator
DS = "/";

-- Update Path is a writable path
UPDATE_DIR = device.writablePath .. "update/"
if (device.platform=="windows") then
	DS = "\\"
	UPDATE_DIR = string.gsub(UPDATE_DIR, "/", "\\")
end

-- device.writablePath .. device.directorySeparator
LOCAL_FLIST = UPDATE_DIR .. "local_version.flist"
DOWN_FLIST  = UPDATE_DIR .. "remote_version.flist"

-- for url scheme , upgrade version is last version
UPGRADE_VERSION = "last_version"

-- Remote Application Path
UPDATE_FLIST_URL = "http://static1.kunlun.com/test-game1/com.koramgame.ios.fysgtw/" .. UPGRADE_VERSION .. ".flist"