-- scene class
local WelcomeScene = class("WelcomeScene", function()
	return display.newScene("WelcomeScene")
end)

-- scene init
function WelcomeScene:ctor()
	-- welcome_bg.jpg welcome_bg.jpg
	display.newSprite("welcome_bg.jpg"):pos(display.cx, display.cy):addTo(self)
end

function WelcomeScene:showTouch()

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

	ui.newTTFLabel({text="Touch me",size=30,align=ui.TEXT_ALIGN_CENTER}):pos(display.cx, display.cy / 3):addTo(self)
end

-- on enter this scene
function WelcomeScene:onEnter()
	print(" \n >>>>>>>>>>>>>>>>>  WelcomeScene:onEnter  >>>>>>>>>>>>>>>>>>>> \n ")
	self:showTouch()
end

-- on exit this scene
function WelcomeScene:onExit()
	-- 关闭事件
	self:removeAllEventListeners();
end

-- return scene
return WelcomeScene
