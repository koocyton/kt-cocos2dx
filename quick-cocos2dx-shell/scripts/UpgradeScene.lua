-- process sprite
local processSprite = display.newSprite("res/process.jpg")

-- scene class
local UpgradeScene = class("UpgradeScene", function()
	return display.newScene("UpgradeScene")
end)

-- scene init
function UpgradeScene:ctor()
	processSprite:pos(200, 72):addTo(self);
    display.newSprite("res/logo.png"):pos(display.cx, display.cy):addTo(self)
end

-- begin upgrade
function UpgradeScene:onUpgradeBegin()
	print(" >>>>>>>>>>>> onUpgradeBegin")
end

-- end upgrade
function UpgradeScene:onUpgradeEnd()
	-- replace scene
    CCFileUtils:sharedFileUtils():addSearchPath(LOCAL_RES_DIR)
    display.replaceScene(require("WelcomeScene").new(), "fade", 0.6, display.COLOR_BLACK)
end

-- upgrading ...
function UpgradeScene:onUpgrading(number)
	processX = 200 + 730 * number
	processSprite:setPosition(processX, 72)
end

-- on enter this scene
function UpgradeScene:onEnter()
	-- set delegate
	local upgradeService = require("UpgradeService")
	upgradeService.onUpgradeBegin = self.onUpgradeBegin
	upgradeService.onUpgradeEnd   = self.onUpgradeEnd
	upgradeService.onUpgrading    = self.onUpgrading
    upgradeService:upgrade()
end

-- on exit this scene
function UpgradeScene:onExit()
end

-- return scene
return UpgradeScene
