-- service class
local UpgradeService = class("UpgradeService")

-- init upgrade class
function UpgradeService:ctor()
	self.onUpgradeBegin = null
	self.onUpgrading    = null
	self.onUpgradeEnd   = null
end

-- on upgrade begin delegate
function UpgradeService:onUpgradeBegin()
	if self.onUpgradeBegin ~= "fuction" then
		self.onUpgradeBegin()
	end
end

-- on upgrading delegate
function UpgradeService:onUpgrading()
	if self.onUpgrading ~= "fuction" then
		self.onUpgrading()
	end
end

-- on upgrade end delegate
function UpgradeService:onUpgradeEnd()
	if self.onUpgradeEnd ~= "fuction" then
		self.onUpgradeEnd()
	end
end

-- upgrade action
function UpgradeService:upgrade()
	local request = network.createHTTPRequest(function(event) self:getRemotePlist(event) end, REMOTE_RES_PLIST, "POST")
	request:start()
end

-- download resource plist file and save plist in local
function UpgradeService:getRemotePlist(event)
	self:onUpgradeBegin()
	local request = event.request

	if not (event.name == "completed") then
		-- display error info
		print(request:getErrorCode(), request:getErrorMessage())
		return
    end

	--local code = request:getResponseStatusCode()
	--if code ~= 200 then
	--   -- 请求结束，但没有返回 200 响应代码
	--    print(code)
	--    return
	---end

	-- local response = request:getResponseString()
	request:saveResponseData(REMOTE_SAV_PLIST)

	-- begin diff resouse plist file
	self:resousePlistDiff()
end

-- diff remote and local plist file
function UpgradeService:resousePlistDiff()

	-- get remote plist string
	local remote_plist = CCFileUtils:sharedFileUtils():getFileData(REMOTE_SAV_PLIST)

	-- if can not analyze plist file
	if not self:remotePlistHasPackageName(PACKAGE_NAME, remote_plist) then
		self:onUpgradeEnd()
		return
	end

	-- set upgrade download url
    local t = {} -- table to store the indices  
    local i = 0
	local s = "[^@].+"
    while true do  
      i = string.find(s, "\n", i+1)    -- find 'next' newline  
      if i == nil then break end  
      table.insert(t, i)
	  print(i)
    end 
end

-- check REMOTE_SAV_PLIST has this application's package name
function UpgradeService:remotePlistHasPackageName(package_name, remote_plist)
	local i,j = remote_plist:find("@package_name.+" .. PACKAGE_NAME)
	if (j==nil) then
		return false
	else
		return true
	end
end

return UpgradeService
