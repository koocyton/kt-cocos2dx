-- service class
local UpgradeService = class("UpgradeService")

-- init upgrade class
function UpgradeService:ctor()
	self.onUpgradeBegin = null
	self.onUpgrading    = null
	self.onUpgradeEnd   = null
	self.upgrade_urls   = {}
	self.update_list    = {}
end

-- on upgrade begin delegate
function UpgradeService:onUpgradeBegin()
	if self.onUpgradeBegin == "function" then
		self.onUpgradeBegin()
	end
end

-- on upgrading delegate
function UpgradeService:onUpgrading(number)
	if self.onUpgrading == "function" then
		self.onUpgrading(number)
	end
end

-- on upgrade end delegate
function UpgradeService:onUpgradeEnd()
	if self.onUpgradeEnd == "function" then
		self.onUpgradeEnd()
	end
end

-- upgrade action
function UpgradeService:upgrade()
	local request = network.createHTTPRequest(function(event) self:getRemotePlist(event) end, REMOTE_RES_PLIST, "GET")
	request:start()
end

-- download resource plist file and save plist in local
function UpgradeService:getRemotePlist(event)
	self:onUpgradeBegin()
	local request = event.request

	if not (event.name == "completed") then
		-- display error info
		self:onUpgrading(0.05)
		print("request error : UpgradeService.lua (48)", request:getErrorCode(), request:getErrorMessage())
		return
    end

	--local code = request:getResponseStatusCode()
	--if code ~= 200 then
	--   -- 请求结束，但没有返回 200 响应代码
	--    print(code)
	--    return
	---end

	local response = request:getResponseString()
	request:saveResponseData(LOCAL_TMP_PLIST);
	self:onUpgrading(0.05)

	-- begin diff resouse plist file
	self:resousePlistDiff()
end

-- diff remote and local plist file
function UpgradeService:resousePlistDiff()

	-- get remote plist string
	local remote_plist_content = CCFileUtils:sharedFileUtils():getFileData(LOCAL_TMP_PLIST)

	-- check REMOTE_SAV_PLIST has this application's package name
	if not self:remotePlistHasPackageName(remote_plist_content) then
		self:onUpgradeEnd()
		return
	end

	-- get upgrade all url
	self.upgrade_urls = self:getUpgradeUrl(remote_plist_content)
	if (self.upgrade_urls==nil) then
		self:onUpgradeEnd()
		return
	end
	-- print(self.upgrade_urls[1], self.upgrade_urls[2], self.upgrade_urls[3])

	-- get update file list
	local remote_plist_data = {}
	for f, m in string.gmatch(remote_plist_content, "\n([^@\n ]+) (%w+)") do
		remote_plist_data[f] = m
    end

	-- get local plist string
	-- print("\n >> " .. REMOTE_SAV_PLIST, "\n >> " .. LOCAL_RES_PLIST)
	local local_plist_content = CCFileUtils:sharedFileUtils():getFileData(LOCAL_RES_PLIST)
	local local_plist_data = {}
	for f, m in string.gmatch(local_plist_content, "\n([^@\n ]+) (%w+)") do
		if (remote_plist_data[f]==nil) then
			-- delete f
			print("delete file " .. f)
		elseif (remote_plist_data[f]~=m) then
			-- update f
		else
			-- remove remote_plist_data[f]
			remote_plist_data[f] = nil
		end
    end

	self.update_list = {}
	local n = 1
	for f,m in pairs(remote_plist_data) do
		self.update_list[n] = f
		n = n + 1
	end

	self:onUpgrading(0.10)
	self:UpdateLocalFile(1)
end

-- update the file
function UpgradeService:UpdateLocalFile(key)
	if (self.update_list[key]==nil) then
		self:onUpgradeEnd()
		return
	end
	local remote_file_url = self.upgrade_urls[1] .. self.update_list[key]
	print(remote_file_url)
	local request = network.createHTTPRequest(function(event) self:SaveUpgradeFile(event, self.update_list[key], key) end, remote_file_url, "GET")
	request:start()
end

-- Save Upgrade File
function UpgradeService:SaveUpgradeFile(event, file_path, key)
	--
	local request = event.request
	--
	if not (event.name == "completed") then
		print("request error : UpgradeService.lua (140)", request:getErrorCode(), request:getErrorMessage())
		return
    end

	--
	local code = request:getResponseStatusCode()
	-- print("request code : " .. code)
	if code ~= 200 then
	   -- 请求结束，但没有返回 200 响应代码
	    print(code)
	    return
	end

	-- request:saveResponseData(LOCAL_TMP_PLIST)
	-- local response = request:getResponseString()
	local local_file_path = LOCAL_RES_DIR .. file_path
	print(file_path, #self.update_list, key, local_file_path)
	self:UpdateLocalFile(key+1)
end

-- get upgrade all url
function UpgradeService:getUpgradeUrl(remote_plist)

	-- 如果找不到 @upgrade_url
	local _, _, upgrade_string = string.find(remote_plist, "@upgrade_url([^\n]+)")
	if (upgrade_string==nil) then
		return nil
	end

    local upgrade_url = {}
	local n = 1
    for url in string.gmatch(upgrade_string, "(http://[^,]+)") do
        upgrade_url[n] = trim(url)
		n = n+1
    end

	if (n==1) then
		return nil
	else
		return upgrade_url
	end
end

-- check REMOTE_SAV_PLIST has this application's package name
function UpgradeService:remotePlistHasPackageName(remote_plist)
	local _, _, package_name = string.find(remote_plist, "@package_name[^\n]+(" .. PACKAGE_NAME .. ")")
	if (package_name==nil) then
		return false
	else
		return true
	end
end

--
return UpgradeService
