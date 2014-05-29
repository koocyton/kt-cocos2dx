
local WelcomeScene = class("WelcomeScene", function()
    return display.newScene("WelcomeScene")
end)

function WelcomeScene:ctor()
    ui.newTTFLabel({text = "你大爷哈哈", size = 64, align = ui.TEXT_ALIGN_CENTER})
	:pos(display.cx, display.cy)
        :addTo(self)
end

function WelcomeScene:onEnter()
end

function WelcomeScene:onExit()
end

return WelcomeScene
