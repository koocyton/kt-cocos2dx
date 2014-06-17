local UpgradeService = class("UpgradeService")

function UpgradeService:ctor()
	self.onUpgradeBegin = null
	self.onUpgrading    = null
	self.onUpgradeEnd   = null
end

function UpgradeService:onUpgradeBegin()
	if self.onUpgradeBegin ~= "fuction" then
		self.onUpgradeBegin()
	end
end

function UpgradeService:onUpgrading()
	if self.onUpgrading ~= "fuction" then
		self.onUpgrading()
	end
end

function UpgradeService:onUpgradeEnd()
	if self.onUpgradeEnd ~= "fuction" then
		self.onUpgradeEnd()
	end
end

function UpgradeService:upgrade()
	local request = network.createHTTPRequest(function(event) self:getRemotePlist(event) end, REMOTE_RES_PLIST, "POST")
	request:start()
end

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
end

function UpgradeService:resousePlistDiff()

	local upgradePlistInfo = self:getUpgradePlistInfo(LOCAL_RES_PLIST, REMOTE_SAV_PLIST)

	-- if can not analyze plist file
	if not (upgradePlistInfo.status == "completed") then
		self:onUpgradeEnd()
		return
	end

	-- package name check
	if not upgradePlistInfo:hasPackageName(PACKAGE_NAME) then
		self:onUpgradeEnd()
		return
	end

	-- version check

	-- set upgrade download url
	if not remotePlistInfo:hasPackageName(PACKAGE_NAME) then
		self:onUpgradeEnd()
		return
	end
end

return UpgradeService