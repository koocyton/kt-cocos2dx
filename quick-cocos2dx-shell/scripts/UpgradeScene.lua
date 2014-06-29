-- set upgrade service
local upgradeService = require("UpgradeService")

local process = display.newSprite("res/process.jpg");

-- scene class
local UpgradeScene = class("UpgradeScene", function()
	return display.newScene("UpgradeScene")
end)

-- scene init
function UpgradeScene:ctor()
	process:pos(200, 72):addTo(self)
    display.newSprite("res/logo.png"):pos(display.cx, display.cy):addTo(self)
end

-- begin upgrade
function UpgradeScene:onUpgradeBegin()
	print(" >>>>>>>>>>>> onUpgradeBegin")
end

-- end upgrade
function UpgradeScene:onUpgradeEnd()
	self:onUpgrading(1)
	-- print(" <<<<<<<<<<< onUpgradeEnd")
    -- begin goto welcome scene
    CCFileUtils:sharedFileUtils():addSearchPath(LOCAL_RES_DIR)
    display.replaceScene(require("WelcomeScene").new(), "fade", 0.6, display.COLOR_BLACK)
end

-- upgrading ...
function UpgradeScene:onUpgrading(number)
	-- print("onUpgrading : " .. number)
	processX = 200 + 730 * number
	process:setPosition(processX, 72)
end

-- on enter this scene
function UpgradeScene:onEnter()
	-- set delegate
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
