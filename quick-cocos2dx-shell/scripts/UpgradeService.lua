-- set lfs
local lfs = require("lfs")

-- service class
local UpgradeService = class("UpgradeService")

-- init upgrade class
function UpgradeService:ctor()
	self.onUpgradeBegin = null
	self.onUpgrading    = null
	self.onUpgradeEnd   = null

	self.update_source  = {}
	self.update_size    = 0
	self.download_size  = 0

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
function UpgradeService:upgrading(rate)
	print(rate)
	if type(self.onUpgrading) == "function" then
		self:onUpgrading(rate)
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

		-- 如果找不到 package_name
		local _, _, package_name = string.find(response, "@package_name[^\n]+(" .. PACKAGE_NAME .. ")")
		if (package_name==nil) then
			self:upgradeEnd()
		end

		-- 如果找不到 update_source
		local _, _, update_source = string.find(response, "@update_source([^\n]+)")
		if (update_source==nil) then
			return nil
		end
		-- 获取 update source
		local source_url, ii = {}, 1
		for url in string.gmatch(update_source, "(http://[^,]+)") do
			source_url[ii] = trim(url)
			ii = ii + 1
		end
		if (ii==1) then
			return nil
		end
		self.update_source = source_url

		-- get update file list
		local down_flist_md5  = {}
		local down_flist_size = {}
		for file_path, file_md5, file_size in string.gmatch(response, "\n([^@\n ]+) (%w+) (%d+)") do
			down_flist_md5[file_path]  = file_md5
			down_flist_size[file_path] = file_size
		end

		-- two choice
		local local_flist_content = UpgradeService.getLocalFlistContent(UPDATE_DIR)
		-- local local_flist_content = CCFileUtils:sharedFileUtils():getFileData(LOCAL_FLIST)
		-- CCLuaLog("\n >>  local_flist_content  >> \n" .. local_flist_content .. "\n")
		if (local_flist_content==nil) then
			local_flist_content = ""
		end
		local local_flist_data = {}
		for file_path, file_md5 in string.gmatch(local_flist_content, "\n([^@\n ]+) (%w+)") do
			if (down_flist_md5[file_path]==nil) then
				-- delete
				if (device.platform=="windows") then
					file_path = string.gsub(UPDATE_DIR .. file_path, "/", "\\")
				end
				os.remove(file_path)
			elseif (down_flist_md5[file_path]==file_md5) then
				down_flist_size[file_path] = nil
			end
		end

		self.update_files = {}
		self.update_size = 0
		local n = 1
		for file_path, file_size in pairs(down_flist_size) do
			self.update_size = file_size + self.update_size
			self.update_files[n] = file_path
			n = n + 1
		end
		self.update_rate = 0
		self:updateLocalFile(1)

	end)
end

-- get local files path and file`s md5
function UpgradeService.getLocalFlistContent(dir_path, root_length)
	root_length = root_length or string.len(dir_path)+1
    local flist_content = ""
    for file_path in lfs.dir(dir_path) do
        if file_path ~= '.' and file_path ~= '..'  and file_path ~= 'remote_version.flist'  and file_path ~= 'local_version.flist' then
			full_path = dir_path .. file_path
            local file_attr = lfs.attributes(full_path)
            if file_attr.mode == 'directory' then
                flist_content = flist_content .. UpgradeService.getLocalFlistContent(full_path .. DS, root_length)
            else
                flist_content = flist_content .. "\n" .. string.sub(full_path, root_length) .. " " .. crypto.md5file(full_path)
            end
        end
    end
    return string.gsub(flist_content, "\\", "/")
end

-- update the file
function UpgradeService:updateLocalFile(key)
	--
	if (self.update_files[key]==nil) then
		self:upgradeEnd()
		return nil
	end

	local update_file_url  = self.update_source[1] .. "/" .. self.update_files[key]
	local update_file_path = UPDATE_DIR .. self.update_files[key]

	self.saveHttpResponse(update_file_url, update_file_path, function(response, file_path) 
		if (file_path==nil) then
			self:updateLocalFile(key)
		else
			self.update_rate = self.update_rate + string.len(response) / self.update_size
			self:upgrading(self.update_rate)
			self:updateLocalFile(1 + key)
		end
	end)
end

-- save a http response
function UpgradeService.saveHttpResponse(request_url, file_path, call_function)

	local request = network.createHTTPRequest(function(event)

		local request = event.request

		if event.name ~= "completed" then
			CCLuaLog("Request Error [:56] - " .. request_url .. " " .. request:getErrorCode() .. " " .. request:getErrorMessage())
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
