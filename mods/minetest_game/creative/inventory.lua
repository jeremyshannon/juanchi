-- creative/inventory.lua

-- support for MT game translation.
local S = creative.get_translator

local player_inventory = {}
local inventory_cache = {}

local function init_creative_cache(items)
	inventory_cache[items] = {}
	local i_cache = inventory_cache[items]

	for name, def in pairs(items) do
		if def.groups.not_in_creative_inventory ~= 1 and
				def.description and def.description ~= "" then
			i_cache[name] = def
		end
	end
	table.sort(i_cache)
	return i_cache
end

function creative.init_creative_inventory(player)
	local player_name = player:get_player_name()
	player_inventory[player_name] = {
		size = 0,
		filter = "",
		start_i = 0,
		old_filter = nil, -- use only for caching in update_creative_inventory
		old_content = nil
	}

	minetest.create_detached_inventory("creative_" .. player_name, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player2)
			local name = player2 and player2:get_player_name() or ""
			if not minetest.is_creative_enabled(name) or
					to_list == "main" then
				return 0
			end
			return count
		end,
		allow_put = function(inv, listname, index, stack, player2)
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player2)
			local name = player2 and player2:get_player_name() or ""
			if not minetest.is_creative_enabled(name) then
				return 0
			end
			return -1
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player2)
		end,
		on_take = function(inv, listname, index, stack, player2)
			if stack and stack:get_count() > 0 then
				minetest.log("action", player_name .. " takes " .. stack:get_name().. " from creative inventory")
			end
		end,
	}, player_name)

	return player_inventory[player_name]
end

local NO_MATCH = 999
local function match(s, filter)
	if filter == "" then
		return 0
	end
	if s:lower():find(filter, 1, true) then
		return #s - #filter
	end
	return NO_MATCH
end

local function description(def, lang_code)
	local s = def.description
	if lang_code then
		s = minetest.get_translated_string(lang_code, s)
	end
	return s:gsub("\n.*", "") -- First line only
end

function creative.update_creative_inventory(player_name, tab_content)
	local inv = player_inventory[player_name] or
			creative.init_creative_inventory(minetest.get_player_by_name(player_name))
	local player_inv = minetest.get_inventory({type = "detached", name = "creative_" .. player_name})

	if inv.filter == inv.old_filter and tab_content == inv.old_content then
		return
	end
	inv.old_filter = inv.filter
	inv.old_content = tab_content

	local items = inventory_cache[tab_content] or init_creative_cache(tab_content)

	local lang
	local player_info = minetest.get_player_information(player_name)
	if player_info and player_info.lang_code ~= "" then
		lang = player_info.lang_code
	end

	local creative_list = {}
	local order = {}
	for name, def in pairs(items) do
		local m = match(description(def), inv.filter)
		if m > 0 then
			m = math.min(m, match(description(def, lang), inv.filter))
		end
		if m > 0 then
			m = math.min(m, match(name, inv.filter))
		end

		if m < NO_MATCH then
			creative_list[#creative_list+1] = name
			-- Sort by match value first so closer matches appear earlier
			order[name] = string.format("%02d", m) .. name
		end
	end

	table.sort(creative_list, function(a, b) return order[a] < order[b] end)

	player_inv:set_size("main", #creative_list)
	player_inv:set_list("main", creative_list)
	inv.size = #creative_list
end

-- Create the trash field
local trash = minetest.create_detached_inventory("trash", {
	-- Allow the stack to be placed and remove it in on_put()
	-- This allows the creative inventory to restore the stack
	allow_put = function(inv, listname, index, stack, player)
		return stack:get_count()
	end,
	on_put = function(inv, listname)
		inv:set_list(listname, {})
	end,
})
trash:set_size("main", 1)

creative.formspec_add = ""

-- Sort registered items
local registered_nodes = {}
local registered_tools = {}
local registered_craftitems = {}

minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		local group = def.groups or {}

		local nogroup = not (group.node or group.tool or group.craftitem)
		if group.node or (nogroup and minetest.registered_nodes[name]) then
			registered_nodes[name] = def
		elseif group.tool or (nogroup and minetest.registered_tools[name]) then
			registered_tools[name] = def
		elseif group.craftitem or (nogroup and minetest.registered_craftitems[name]) then
			registered_craftitems[name] = def
		end
	end
end)

function creative.register_tab(name, title)
	sfinv.register_page("creative:" .. name, {
		title = title,
		is_in_nav = function(self, player, context)
			return minetest.is_creative_enabled(player:get_player_name())
		end,
		get = function(self, player, context)
			local player_name = player:get_player_name()
			local items =  context.items or minetest.registered_items
			creative.update_creative_inventory(player_name, items)
			local inv = player_inventory[player_name]
			local pagenum = math.floor(inv.start_i / (4*8) + 1)
			local pagemax = math.ceil(inv.size / (4*8))
			local esc = minetest.formspec_escape
			return sfinv.make_formspec(player, context,
				"label[6.3,4.15;" .. minetest.colorize("#FFFF00", tostring(pagenum)) .. " / " .. tostring(pagemax) .. "]" ..
				[[
					image[3.08,4.2;0.8,0.8;creative_trash_icon.png]
					listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]
<<<<<<< HEAD:creative/inventory.lua
					list[detached:creative_trash;main;3.02,4.1;1,1;]
=======
					list[detached:trash;main;4.02,4.1;1,1;]
>>>>>>> upstream/master:mods/creative/inventory.lua
					listring[]
					image_button[5.5,4.05;0.8,0.8;creative_prev_icon.png;creative_prev;]
					image_button[7.2,4.05;0.8,0.8;creative_next_icon.png;creative_next;]
					image_button[1.63,4.05;0.8,0.8;creative_search_icon.png;creative_search;]
					image_button[2.25,4.05;0.8,0.8;creative_clear_icon.png;creative_clear;]
					image_button[4,4.05;1,0.5;;items_all;]]..S("All")..[[]
					tooltip[items_nodes;]]..S("Nodes")..[[]
					image_button[5,4.05;0.5,0.5;creative_nodes_icon.png;items_nodes;]
					tooltip[items_tools;]]..S("Tools")..[[]
					image_button[4,4.5;0.5,0.5;creative_tools_icon.png;items_tools;]
					tooltip[items_craftitems;]]..S("Items")..[[]
					image_button[4.5,4.5;1,0.5;;items_craftitems;]]..S("Items")..[[]
				]] ..
				"tooltip[creative_search;" .. esc(S("Search")) .. "]" ..
				"tooltip[creative_clear;" .. esc(S("Reset")) .. "]" ..
				"tooltip[creative_prev;" .. esc(S("Previous page")) .. "]" ..
				"tooltip[creative_next;" .. esc(S("Next page")) .. "]" ..
				"listring[current_player;main]" ..
				"field_close_on_enter[creative_filter;false]" ..
				"field[0.3,4.2;1.8,1.2;creative_filter;;" .. esc(inv.filter) .. "]" ..
				"listring[detached:creative_" .. player_name .. ";main]" ..
				"list[detached:creative_" .. player_name .. ";main;0,0;8,4;" .. tostring(inv.start_i) .. "]" ..
				creative.formspec_add, true)
		end,
		on_enter = function(self, player, context)
			local player_name = player:get_player_name()
			local inv = player_inventory[player_name]
			if inv then
				inv.start_i = 0
			end
		end,
		on_player_receive_fields = function(self, player, context, fields)
			local player_name = player:get_player_name()
			local inv = player_inventory[player_name]
			assert(inv)

			if fields.creative_clear then
				inv.start_i = 0
				inv.filter = ""
				sfinv.set_player_inventory_formspec(player, context)
			elseif fields.creative_search or
					fields.key_enter_field == "creative_filter" then
				inv.start_i = 0
				inv.filter = fields.creative_filter:lower()
				sfinv.set_player_inventory_formspec(player, context)
			elseif fields.items_all then
				context.items = minetest.registered_items
				sfinv.set_player_inventory_formspec(player, context)
			elseif fields.items_nodes then
				context.items = registered_nodes
				sfinv.set_player_inventory_formspec(player, context)
			elseif fields.items_tools then
				context.items = registered_tools
				sfinv.set_player_inventory_formspec(player, context)
			elseif fields.items_craftitems then
				context.items = registered_craftitems
				sfinv.set_player_inventory_formspec(player, context)
			elseif not fields.quit then
				local start_i = inv.start_i or 0

				if fields.creative_prev then
					start_i = start_i - 4*8
					if start_i < 0 then
						start_i = inv.size - (inv.size % (4*8))
						if inv.size == start_i then
							start_i = math.max(0, inv.size - (4*8))
						end
					end
				elseif fields.creative_next then
					start_i = start_i + 4*8
					if start_i >= inv.size then
						start_i = 0
					end
				end

				inv.start_i = start_i
				sfinv.set_player_inventory_formspec(player, context)
			end
		end
	})
end

creative.register_tab("creative", S("Creative"))

local old_homepage_name = sfinv.get_homepage_name
function sfinv.get_homepage_name(player)
	if minetest.is_creative_enabled(player:get_player_name()) then
		return "creative:creative"
	else
		return old_homepage_name(player)
	end
end
