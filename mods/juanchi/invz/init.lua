local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)

local formspec = [[
	image_button[0,0;1,1;invz_day.png;btn_day;]]..S("Day")..[[;;]
	image_button[1,0;1,1;invz_night.png;btn_night;]]..S("Night")..[[;;]
]]

sfinv.register_page("server", {
	title = S("Server"),
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, formspec, false)
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
