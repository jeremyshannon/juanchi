local S = ...

local function drink_particles(player)
	local pos = player:get_pos()
	minetest.add_particlespawner({
		amount = 20,
		time = 0.001,
		minpos = pos,
		maxpos = pos,
		minvel = vector.new(-2,-2,-2),
		maxvel = vector.new(2,2,2),
		minacc = {x=0, y=0, z=0},
		maxacc = {x=0, y=0, z=0},
		minexptime = 1.1,
		maxexptime = 1.5,
		minsize = 1,
		maxsize = 2,
		collisiondetection = false,
		vertical = false,
		texture = "bubble.png",
		--playername = player:get_player_name()
	})
end

--The Engine (Potions/Effects) Part!!!

brewing.effects = {}

brewing.effects.phys_override = function(effect_name, description_name, potion_name, sdata, flags)
	local def = {
		on_use = function(itemstack, user, pointed_thing)
			brewing.make_sound("player", user, "brewing_magic_sound")
			drink_particles(user)
			brewing.grant(user, effect_name, potion_name.."_"..flags.type..sdata.type, description_name, sdata.time or 0, flags)
			itemstack:take_item()
			return itemstack
		end,
		potions = {
			speed = 0,
			jump = 0,
			gravity = 0,
			tnt = 0,
			air = 0,
		},
	}
	return def
end

brewing.effects.fixhp = function(sname, name, fname, sdata, flags)
	local def = {
		on_use = function(itemstack, user, pointed_thing)
			brewing.make_sound("player", user, "brewing_magic_sound")
			drink_particles(user)
			for i=0, (sdata.time or 0) do
				minetest.after(i, function()
					local hp = user:get_hp()
					if flags.inv==true then
						hp = hp - (sdata.hp or 3)
					else
						hp = hp + (sdata.hp or 3)
					end
					hp = math.min(20, hp)
					hp = math.max(0, hp)
					user:set_hp(hp)
				end)
			end
			itemstack:take_item()
			return itemstack
		end,
	}
	def.mobs = {
		on_near = def.on_use,
	}
	return def
end

brewing.effects.air = function(sname, name, fname, sdata, flags)
	local def = {
		on_use = function(itemstack, user, pointed_thing)
			brewing.make_sound("player", user, "brewing_magic_sound")
			drink_particles(user)
			local potions_e = brewing.players[user:get_player_name()]
			potions_e.air = potions_e.air + (sdata.time or 0)
			for i=0, (sdata.time or 0) do
				minetest.after(i, function(v_user, v_sdata)
					local br = v_user:get_breath()
					if flags.inv==true then
						br = br - (v_sdata.br or 3)
					else
						br = br + (v_sdata.br or 3)
					end
					br = math.min(11, br)
					br = math.max(0, br)
					v_user:set_breath(br)
					if i==(v_sdata.time or 0) then
						potions_e.air = potions_e.air - (v_sdata.time or 0)
					end
				end, user, sdata)
			end
			itemstack:take_item()
			return itemstack
		end,
	}
	return def
end

brewing.effects.invisibility = function(sname, name, fname, sdata, flags)
	local def = {
		on_use = function(itemstack, user, pointed_thing)
			brewing.make_sound("player", user, "brewing_magic_sound")
			drink_particles(user)
			user:set_nametag_attributes({
				color = {a = 0, r = 255, g = 255, b = 255}
			})
			user:set_properties({
				visual_size = {x = 0, y = 0},
			})
			local user_name = user:get_player_name()
			minetest.chat_send_player(user_name, S("You are invisible thanks to a invisibility potion."))
			minetest.after(sdata.time, function(player, player_name)
				if minetest.get_player_by_name(player_name) then
					player:set_nametag_attributes({
						color = {a = 255, r = 255, g = 255, b = 255}
					})
					player:set_properties({
						visual_size = {x = 1, y = 1},
					})
					minetest.chat_send_player(player_name, S("You are visible again."))
				end
			end, user, user_name)
			itemstack:take_item()
			return itemstack
		end,
	}
	return def
end

brewing.effects.resist_fire = function(sname, name, fname, sdata, flags)
	local def = {
		on_use = function(itemstack, user, pointed_thing)
			brewing.make_sound("player", user, "brewing_magic_sound")
			drink_particles(user)
			local user_name = user:get_player_name()
			brewing.players[user_name]["resist_fire"] = true
			user:get_meta():set_string("brewing:resist_fire", "true")
			minetest.chat_send_player(user_name, S("You are able to resist fire thanks to a Resist Fire Potion."))
			minetest.after(sdata.time, function(player, player_name)
				if minetest.get_player_by_name(player_name) then
					brewing.players[player_name]["resist_fire"] = false
					minetest.chat_send_player(player_name, S("The effect of the Resist Potion has worn off."))
				end
			end, user, user_name)
			itemstack:take_item()
			return itemstack
		end,
	}
	return def
end

brewing.effects.teleport = function(sname, name, fname, sdata, flags)
	local def = {
		on_use = function(itemstack, user, pointed_thing)
			brewing.make_sound("player", user, "brewing_magic_sound")
			local user_name = user:get_player_name()
			local teleport_pos = brewing.players[user_name]["teleport"]
			if not teleport_pos then
				brewing.players[user_name]["teleport"] = user:get_pos()
				brewing.make_sound("player", user, "brewing_magic_sound")
				minetest.chat_send_player(user_name, S("Your position was saved for teleport."))
				drink_particles(user)
				minetest.after(sdata.time, function(player, player_name)
					if minetest.get_player_by_name(player_name) and brewing.players[player_name]["teleport"] then
						brewing.players[player_name]["teleport"] = nil
						minetest.chat_send_player(player_name, S("The effect of the Teleport Potion has worn off."))
					end
				end, user, user_name)
			else
				local teleport_node = minetest.get_node_or_nil(teleport_pos)
				if not teleport_node then
					minetest.get_voxel_manip():read_from_map(teleport_pos, teleport_pos)
					teleport_node = minetest.get_node(teleport_pos)
				end
				if minetest.registered_nodes[teleport_node.name].drawtype == "airlike" then
					user:set_pos(teleport_pos)
					drink_particles(user)
					brewing.make_sound("player", user, "brewing_magic_sound")
				else
					brewing.make_sound("player", user, "brewing_magic_fail")
					minetest.chat_send_player(user_name, S("Failed teleport: The position is ocupied"))
				end
				brewing.players[user_name]["teleport"] = nil
			end
			itemstack:take_item()
			return itemstack
		end,
	}
	return def
end

brewing.grant = function(player, effect_name, potion_name, description_name, time, flags)
	local rootdef = minetest.registered_items[potion_name]
	if rootdef == nil then
		return
	end
	if rootdef.potions == nil then
		return
	end
	local def = {}
	for name, val in pairs(rootdef.potions) do
		def[name] = val
	end
	if flags.inv==true then
		def.gravity = 0 - def.gravity
		def.speed = 0 - def.speed
		def.jump = 0 - def.jump
		def.tnt = 0 - def.tnt
	end
	local player_name = player:get_player_name()
	playerphysics.add_physics_factor(player, effect_name, potion_name, def[effect_name])
	minetest.chat_send_player(player_name, S("You are under the effects of the").." "..description_name.." "..S("potion."))
	minetest.after(time, function()
		if minetest.get_player_by_name(player_name)~=nil then
			playerphysics.remove_physics_factor(player, effect_name, potion_name)
			minetest.chat_send_player(player_name, S("The effects of the").." "..description_name.." "..S("potion have worn off."))
		end
	end)
end
