-- set lfs
local lfs = require("lfs")

-- service class
local UpgradeService = class("UpgradeService")

-- init upgrade class
function UpgradeService:ctor()
	self.onUpgradeBegin = null
	self.onUpgrading    = null
	self.onUpgradeEnd   = null

	self.upgrade_source = {}
	self.upgrade_size   = 0
	self.update_files   = {}
	self.update_rate    = 0
end

-- on upgrade begin delegate
function UpgradeService:upgradeBegin()
	if type(self.onUpgradeBegin) == "function" then
		self:onUpgradeBegin()
	end
end

-- on upgrading delegate
function UpgradeService:upgrading()
	if type(self.onUpgrading) == "function" then
		self:onUpgrading(self.update_rate)
	end
end

-- on upgrade end delegate
function UpgradeService:upgradeEnd()
	self:onUpgrading(1)
	os.remove(LOCAL_FLIST)
	os.rename(DOWN_FLIST, LOCAL_FLIST)
	if type(self.onUpgradeEnd) == "function" then
		self:onUpgradeEnd()
	end
end

-- upgrade action
function UpgradeService:upgrade()
	self.saveHttpResponse(UPDATE_FLIST_URL, DOWN_FLIST, function(response, file_path)
		print(file_path)
	end)
end

-- save a http response
function UpgradeService.saveHttpResponse(request_url, file_path, call_function)

	local request = network.createHTTPRequest(function(event)

		local request = event.request

		if event.name ~= "completed" then
			CCLuaLog("Request Error [:56] - " .. request_url, request:getErrorCode(), request:getErrorMessage())
			if type(call_function) == "function" then
				call_function(nil, nil)
			end
			return nil
		end

		if request:getResponseStatusCode() ~= 200 then
			CCLuaLog("Request Error [:61] - Response Status Code (" .. request:getResponseStatusCode() .. ")")
			if type(call_function) == "function" then
				call_function(nil, nil)
			end
			return nil
		end

		-- check the directory exists
		if (device.platform=="windows") then file_path=string.gsub(file_path, "/", "\\") end
		local _, _, file_dir = string.find(file_path, "(.+)" .. DS .. "[^" .. DS .. "]+")
		UpgradeService.mkDir(file_dir)

		-- save response
		local response = request:getResponseString()
		request:saveResponseData(file_path);

		-- call back
		if type(call_function) == "function" then
			call_function(request:getResponseString(), file_path)
		end

	end, request_url, "GET")

	request:start()
end

-- create Dir
function UpgradeService.mkDir(dir_path)

	local loop_dir = dir_path
	local need_create_dir, ii = {}, 0

	for _ in string.gmatch(dir_path, "([^" .. DS .. "]+)") do
		local dir_attr = lfs.attributes(loop_dir)
		if dir_attr ~= nil and dir_attr.mode == 'directory' then
			break
		end
		ii=ii+1
		need_create_dir[ii] = loop_dir
		_, _, loop_dir = string.find(loop_dir, "(.+)" .. DS .. "[^" .. DS .. "]+")
    end

	for nn=ii,1,-1 do
		lfs.mkdir(need_create_dir[nn])
	end
end

--
return UpgradeService
