
require("config")
require("framework.init")

local welcome = class("welcome", cc.mvc.AppBase)

function welcome:ctor()
    welcome.super.ctor(self)
end

function welcome:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    self:enterScene("MainScene")
end

return welcome
