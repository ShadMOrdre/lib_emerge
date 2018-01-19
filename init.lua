minetest.register_chatcommand("emerge_area", {
 	params = "x1 y1 z1 x2 y2 z2",
 	description = "Generate map in a square box from pos1(x1,y1,z1) to pos2(x2,y2,z2).",
 	func = function(name, params)
--		local found, _, s_x1, s_y1, s_z1, s_x2, s_y2, s_z2 = params:find("^%s*(%d+)%s*(-?%d*)%s*$")
		local found, _, s_x1, s_y1, s_z1, s_x2, s_y2, s_z2 = params:find("^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)[ ] *([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
	if found == nil then
		minetest.chat_send_player(name, "Usage: /mapgen x1 y1 z1 x2 y2 z2")
		return
	end

	local pos1 = {x=tonumber(s_x1), y=tonumber(s_y1), z=tonumber(s_z1)}
	local pos2 = {x=tonumber(s_x2), y=tonumber(s_y2), z=tonumber(s_z2)}	

	local start_time = minetest.get_us_time()

	minetest.emerge_area(pos1, pos2, function(blockpos, action, remaining)
		local dt = math.floor((minetest.get_us_time() - start_time) / 1000)
		local block = (blockpos.x * 16)..","..(blockpos.y * 16)..","..(blockpos.z * 16)
		local info = "(mapgen-"..remaining.."-"..dt.."ms) "
		if action==core.EMERGE_GENERATED then
			minetest.chat_send_player(name, info.."Generated new block at "..block)
		elseif (action==core.EMERGE_CANCELLED) or (action==core.EMERGE_ERRORED) then
			minetest.chat_send_player(name, info.."Block at "..block.." did not emerge")
		else
			--minetest.chat_send_player(name, "(mapgen-"..remaining.."-"..dt.."s) Visited block at "..(blockpos.x)..","..(blockpos.y)..","..(blockpos.z))
		end
	
		if remaining<=0 then
			minetest.chat_send_player(name, "(mapgen-"..dt.."ms) Generation done.")
		end
	end
	)
end
})


minetest.register_chatcommand("emerge_radius", {
 	params = "radius [max_height]",
 	description = "Generate map in a square box of size 2*radius centered at your current position.",
 	func = function(name, params)
		local found, _, s_radius, s_height = params:find("^%s*(%d+)%s*(-?%d*)%s*$")
	if found == nil then
		minetest.chat_send_player(name, "Usage: /mapgen radius max_height")
		return
	end

	local player = minetest.get_player_by_name(name)
	local pos = player:getpos()

	local radius = tonumber(s_radius)
	local max_height = tonumber(s_height)

	if max_height == nil then
		max_height = pos.y+1
	end

	if radius == 0 then
		radius = 1
	end

	local start_pos = {
		x = pos.x - radius,
		y = pos.y,
		z = pos.z - radius
	}

	local end_pos = {
		x = pos.x + radius,
		y = max_height,
		z = pos.z + radius
	}

	local start_time = minetest.get_us_time()

	minetest.emerge_area(start_pos, end_pos, function(blockpos, action, remaining)
		local dt = math.floor((minetest.get_us_time() - start_time) / 1000)
		local block = (blockpos.x * 16)..","..(blockpos.y * 16)..","..(blockpos.z * 16)
		local info = "(mapgen-"..remaining.."-"..dt.."ms) "
		if action==core.EMERGE_GENERATED then
			minetest.chat_send_player(name, info.."Generated new block at "..block)
		elseif (action==core.EMERGE_CANCELLED) or (action==core.EMERGE_ERRORED) then
			minetest.chat_send_player(name, info.."Block at "..block.." did not emerge")
		else
			--minetest.chat_send_player(name, "(mapgen-"..remaining.."-"..dt.."s) Visited block at "..(blockpos.x)..","..(blockpos.y)..","..(blockpos.z))
		end
	
		if remaining<=0 then
			minetest.chat_send_player(name, "(mapgen-"..dt.."ms) Generation done.")
		end
	end
	)
end
})

