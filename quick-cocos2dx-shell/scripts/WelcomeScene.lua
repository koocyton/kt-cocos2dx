local upgradeService = require("UpgradeService")

local WelcomeScene = class("WelcomeScene", function()
	return display.newScene("WelcomeScene")
end)

function WelcomeScene:ctor()
	display.newSprite("welcome_bg.jpg"):pos(display.cx, display.cy):addTo(self)
	-- display.newSprite("update_bg.jpg"):pos(display.cx, display.cy):addTo(self)
end



function WelcomeScene:updateBegin()

	--[[ 启用触摸
	self:setTouchEnabled(true)
	-- 设置触摸模式
	-- self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点（默认模式）
	-- 添加触摸事件处理函数
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	print(111)
	-- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
	return true
	end)

	ui.newTTFLabel({text = "Touch To Star", size = 30, align = ui.TEXT_ALIGN_CENTER})
		:pos(display.cx, display.cy / 3)
		:addTo(self)
	--]]
end

function WelcomeScene:onUpgradeBegin()
	print("onUpgradeBegin")
end

function WelcomeScene:onUpgradeEnd()
	print("onUpgradeEnd")
end

function WelcomeScene:onUpgrading()
	print("onUpgrading")
end

function WelcomeScene:onEnter()
	upgradeService.onUpgradeBegin = self.onUpgradeBegin
	upgradeService.onUpgradeEnd   = self.onUpgradeEnd
	upgradeService.onUpgrading    = self.onUpgrading
	upgradeService:upgrade()
end

function WelcomeScene:onExit()
	-- 关闭事件
	self:removeAllEventListeners();
end

return WelcomeScene
