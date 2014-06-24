-- set upgrade service
local upgradeService = require("UpgradeService")

-- scene class
local UpgradeScene = class("UpgradeScene", function()
	return display.newScene("UpgradeScene")
end)

-- scene init
function UpgradeScene:ctor()
    --CCFileUtils:sharedFileUtils():addSearchPath("scripts/")
	display.newSprite("scripts/logo.jpg"):pos(display.cx, display.cy):addTo(self)
	-- display.newSprite("update_bg.jpg"):pos(display.cx, display.cy):addTo(self)
end

-- begin upgrade
function UpgradeScene:onUpgradeBegin()
	--print(" >>>>>>>>>>>> onUpgradeBegin")
end

-- end upgrade
function UpgradeScene:onUpgradeEnd()
	--print(" <<<<<<<<<<< onUpgradeEnd")
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    -- begin goto welcome scene
    local scene = require("WelcomeScene").new()
    display.replaceScene(scene)
end

-- upgrading ...
function UpgradeScene:onUpgrading(number)
	print("onUpgrading : " .. number)
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
