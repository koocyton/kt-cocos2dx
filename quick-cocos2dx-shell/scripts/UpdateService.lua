local UpdateService = class("UpdateService")

function UpdateService:ctor()
end

function UpdateService:getRemoteVersion(launchFunction, onNewFunction, onOldFunction)
	local request = network.createHTTPRequest(function(event)
		self:onGetRemoteVersion(event, onNewFunction, onOldFunction)
	end, REMOTE_RES_PLIST, "POST")
	request:start()
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