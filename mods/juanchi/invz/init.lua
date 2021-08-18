local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)

local frmspc_server = [[
	image_button[0,0;1,1;invz_day.png;btn_day;]]..S("Day")..[[;;]
	image_button[1,0;1,1;invz_night.png;btn_night;]]..S("Night")..[[;;]
]]

local function get_session_time(player)
	return os.difftime(os.time(), player:get_meta():get_int("invz:join_time"))
end

local function get_play_time(player)
	local play_time = player:get_meta():get_int("invz:play_time")
	local session_time = get_session_time(player)
	local total_time = play_time + session_time
	return total_time
end

local function disp_time(time)
  local days = math.floor(time/86400)
  local remaining = time % 86400
  local hours = math.floor(remaining/3600)
  remaining = remaining % 3600
  local minutes = math.floor(remaining/60)
  remaining = remaining % 60
  local seconds = remaining
  if (hours < 10) then
    hours = "0" .. tostring(hours)
  end
  if (minutes < 10) then
    minutes = "0" .. tostring(minutes)
  end
  if (seconds < 10) then
    seconds = "0" .. tostring(seconds)
  end
  local answer = tostring(days)..':'..hours..':'..minutes..':'..seconds
  return answer
end

local function get_frmspc_stats(player)
	local meta = player:get_meta()
	local level = meta:get_int("level")
	local died = meta:get_int("invz:died")
	local died_player = meta:get_int("invz:died_player")
	local died_creature = meta:get_int("invz:died_creature")
	local died_fall = meta:get_int("invz:died_fall")
	local died_drown = meta:get_int("invz:died_drown")
	local died_fire = meta:get_int("invz:died_fire")
	local died_lava = meta:get_int("invz:died_lava")
	local kills = meta:get_int("invz:kills")
	local last_login = os.date('%Y-%m-%d %H:%M:%S', meta:get_int("invz:last_login"))
	local session_time = get_session_time(player)
	local play_time = get_play_time(player)
	return [[
		label[0.25,0.25;]]..S("Level")..": "..tostring(level)..[[]
		label[0.25,1.0;]]..tostring(died).." "..S("times died")..[[]
		label[0.5,1.25;]]..tostring(died_player).." "..S("times died by player")..[[]
		label[0.5,1.5;]]..tostring(died_creature).." "..S("times died by creature")..[[]
		label[0.5,1.75;]]..tostring(died_fall).." "..S("times died by fall")..[[]
		label[0.5,2;]]..tostring(died_drown).." "..S("times drown")..[[]
		label[0.5,2.25;]]..tostring(died_fire).." "..S("times died by fire")..[[]
		label[0.5,2.5;]]..tostring(died_lava).." "..S("times died by lava")..[[]
		label[0.25,3;]]..tostring(kills).." "..S("kills")..[[]
		label[0.25,3.5;]]..S("Last Login")..": "..last_login..[[]
		label[0.25,3.75;]]..S("This Session Time")..": "..disp_time(session_time)..[[]
		label[0.25,4;]]..S("Total Play Time")..": "..disp_time(play_time)..[[]
	]]
end

--Save the stats when an event produced
minetest.register_on_dieplayer(function(player, reason)
	local meta = player:get_meta()
	meta:set_int("invz:died", (meta:get_int("invz:died") + 1))
	if reason.type == "punch" and reason.object then
		if minetest.is_player(reason.object) then
			meta:set_int("invz:died_player", (meta:get_int("invz:died_player") + 1))
			local meta_killer = reason.object:get_meta()
			meta_killer:set_int("invz:kills", (meta_killer:get_int("invz:kills") + 1))
		else
			meta:set_int("invz:died_creature", (meta:get_int("invz:died_creature") + 1))
		end
	elseif reason.type == "fall" then
		meta:set_int("invz:died_fall", (meta:get_int("invz:died_fall") + 1))
	elseif reason.type == "drown" then
		meta:set_int("invz:died_drown", (meta:get_int("invz:died_drown") + 1))
	elseif reason.type == "node_damage" and reason.node then
		if reason.node == "default:lava_source" then
			meta:set_int("invz:died_lava", (meta:get_int("invz:died_lava") + 1))
		elseif reason.node == "fire:basic_flame" or reason.node == "fire:permanent_flame" then
			meta:set_int("invz:died_fire", (meta:get_int("invz:died_fire") + 1))
		end
	end
end)

minetest.register_on_joinplayer(function(player, last_login)
	if last_login then
		player:get_meta():set_int("invz:last_login", last_login)
	end
	player:get_meta():set_int("invz:join_time", os.time())
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	player:get_meta():set_int("invz:play_time", get_play_time(player))
end)

sfinv.register_page("server", {
	title = S("Server"),
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, frmspc_server, false)
	end,
	is_in_nav = function(self, player, context)
		local player_name = player:get_player_name()
		if minetest.check_player_privs(player_name, {server=true}) then
			return true
		else
			return false
		end
	end,
	on_player_receive_fields = function(self, player, context, fields)
		if fields.btn_day then
			minetest.set_timeofday(0.5)
		end
		if fields.btn_night then
			minetest.set_timeofday(0)
		end
	end,
})

sfinv.register_page("stats", {
	title = S("Stats"),
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, get_frmspc_stats(player), false)
	end,
})
