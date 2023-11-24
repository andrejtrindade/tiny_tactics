-- print.lua
-- =========

function print_controls()
	if controls.key_labels then
		print_line_off(s_up, 17, c_dark_gray, 28)
		print_line_off(s_x, 18, c_dark_gray, 3)
		print_line_off(s_left..s_down..s_right, 18, c_dark_gray, 26)
		print_o_button(44, 108, c_dark_gray)
		print_pause_button(71, 106, c_dark_gray)
		print_line(" shoot    skip    pause    move", 19, c_gray)
	else
		print_line_off(s_up, 17, c_dark_gray, 6)
		print_line_off(s_left.."  "..s_right, 18, c_dark_gray, 4)
		print_line_off(s_o, 18, c_dark_gray, 20)
		print_line_off(s_down, 19, c_dark_gray, 6)
		print_line_off(s_x, 19, c_dark_gray, 20)
		print_pause_button(80, 102, c_dark_gray)
		print_line_off("pause", 17, c_gray, 23)
		print_line_off("move        skip", 18, c_gray, 11)
		print_line_off("shoot", 19, c_gray, 23)
	end
end

function print_lines_color(lines_table, color)
	local c = (color == nil) and c_gray or color
	local line = 1
	while line < #lines_table do
		if lines_table[line+2] == 0 then print_line(lines_table[line+1], lines_table[line], c)
		else                         print_line_off(lines_table[line+1], lines_table[line], c, lines_table[line+2]) end
		line += 3
	end
end

function print_line_off(str, line, color, offset)
	print_line(str, line, color, k_left, offset)
end

function print_line(str, line, color, align, offset)
	color = color or c_gray
	align = align or k_left
	offset = offset or 0
	local x = 0
	local y = line == 20 and 122 or line*6
	if align == k_up or align == k_down then x = 64-(#str+offset)*2
	elseif align == k_right then x = 128-(#str+offset)*4 
	else x = offset*4 end
	print(str, x, y, color)
end

function print_menu_commands(x_comm, o_comm, color, override_key_labels)
	color = color or c_gray
	print(s_x.." "..x_comm, 1, 121, color)
	if o_comm ~= nil then 
		local x = 128-#o_comm*4
		print(o_comm, x, 121, color)
		x -= 12
		print_o_button(x, 121, color, override_key_labels)
	end
end

function print_o_button(x, y, color, override_key_labels)
	if override_key_labels == nil then override_key_labels = controls.key_labels end
	color = color or c_gray
	print(s_o, x, y, color)
	if override_key_labels then
		pset(x+4, y+2, color)
	end
end

function print_pause_button(x, y, color, override_key_labels, color_back)
	if override_key_labels == nil then override_key_labels = controls.key_labels end
	color = color or c_gray
	color_back = color_back or c_black
	if override_key_labels then
		rectfill(x,y, x+20, y+6, color)
		print("enter", x+1, y+1, color_back)
	else
		rect(x+1, y, x+5, y+4, color)
		rect(x, y+1, x+6, y+3, color)
	end
end
