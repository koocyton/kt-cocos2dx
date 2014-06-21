-- scene class
local WelcomeScene = class("WelcomeScene", function()
	return display.newScene("WelcomeScene")
end)

-- scene init
function WelcomeScene:ctor()
	display.newSprite("welcome_bg.jpg"):pos(display.cx, display.cy):addTo(self)
end

-- on enter this scene
function WelcomeScene:onEnter()
	print(123)
end

-- on exit this scene
function WelcomeScene:onExit()
end

-- return scene
return WelcomeScene
