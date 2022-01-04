svrz = {}
local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)
local settings = Settings(modpath .. "/srvz.conf")
svrz.settings = {}
svrz.settings.reserved = tonumber(settings:get("reserved")) or 0

minetest.register_on_prejoinplayer(function(player)
	if minetest.check_player_privs(player, {server = true}) then
		return
	end
	local connected_players = minetest.get_connected_players()
	local max_players = tonumber(minetest.setting_get("max_users"))
	if max_players <= #connected_players + svrz.settings.reserved then
		msg = S("Server full of players! Retry later.")
		return msg
	end
end)
