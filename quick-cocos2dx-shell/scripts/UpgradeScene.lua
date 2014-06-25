-- set upgrade service
local upgradeService = require("UpgradeService")

local process = display.newSprite("scripts/process.jpg");

-- scene class
local UpgradeScene = class("UpgradeScene", function()
	return display.newScene("UpgradeScene")
end)

-- scene init
function UpgradeScene:ctor()
    --CCFileUtils:sharedFileUtils():addSearchPath("scripts/")
	process:pos(112, 72):addTo(self)
	display.newSprite("scripts/logo.png"):pos(display.cx, display.cy):addTo(self)
end

-- begin upgrade
function UpgradeScene:onUpgradeBegin()
	--print(" >>>>>>>>>>>> onUpgradeBegin")
end

-- end upgrade
function UpgradeScene:onUpgradeEnd()
	self:onUpgrading(1)
	--print(" <<<<<<<<<<< onUpgradeEnd")
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    -- begin goto welcome scene
    local scene = require("WelcomeScene").new()
    display.replaceScene(scene)
end

-- upgrading ...
function UpgradeScene:onUpgrading(number)
	print("onUpgrading : " .. number)
	processX = 112 + 730 * number
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
