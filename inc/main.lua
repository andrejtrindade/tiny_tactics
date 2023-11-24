-- main.lua
-- ========

function _init()
	persistence:init()
	sel:init()
	if controls.labels_selected then title:show()
	else controls:show() end
end

function _update()
	screen:update()
end

function _draw()
	screen:draw()
	persistence:draw()
	
	if options.show_fps then 
		local s = tostr(stat(7))
		print(s, 129-(#s*4), 0, c_white)
	end
end
