local UpdateService = class("UpdateService")

function UpdateService:ctor()
	self.onUpgradeBegin = null
	self.onUpgrading    = null
	self.onUpgradeEnd   = null
end

function UpdateService:onUpgradeBegin()
	if self.onUpgradeBegin ~= "fuction" then
		self.onUpgradeBegin()
	end
end

function UpdateService:onUpgrading()
	if self.onUpgrading ~= "fuction" then
		self.onUpgrading()
	end
end

function UpdateService:onUpgradeEnd()
	if self.onUpgradeEnd ~= "fuction" then
		self.onUpgradeEnd()
	end
end

function UpdateService:upgrade()
	local request = network.createHTTPRequest(function(event) self:getRemotePlist(event) end, REMOTE_RES_PLIST, "POST")
	request:start()
end

function UpdateService:getRemotePlist(event)
	local request = event.request
	if not (event.name == "completed") then
		-- display error info
		print(request:getErrorCode(), request:getErrorMessage())
		return
    end
	-- local response = request:getResponseString()
	request:saveResponseData(REMOTE_SAV_PLIST)
end

function UpdateService:updateVersion(launchFunction)
	--
	if launchFunction ~= "fuction" then
	launchFunction()
	end
end

function UpdateService:onGetRemoteVersion(event, onNewVersion, onOldVersion)
	local ok = (event.name == "completed")
	local request = event.request

	if not ok then
		-- 请求失败，显示错误代码和错误消息
		print(request:getErrorCode(), request:getErrorMessage())
		return
    end

	--local code = request:getResponseStatusCode()
	--if code ~= 200 then
	--   -- 请求结束，但没有返回 200 响应代码
	--    print(code)
	--    return
	---end

	-- 请求成功，显示服务端返回的内容
	local response = request:getResponseString()

	-- 
	if onNewVersion ~= "fuction" then
	onNewVersion()
	end

	if onOldVersion ~= "fuction" then
	onOldVersion()
	end
	-- print(response)
end

return UpdateService