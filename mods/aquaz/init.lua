--
-- Aquaz
--

aquaz = {}

local modname = "aquaz"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

local function plant_on_place(itemstack, placer, pointed_thing)
	-- Call on_rightclick if the pointed node defines it
	if pointed_thing.type == "node" and placer and not placer:get_player_control().sneak then
		local node_ptu = minetest.get_node(pointed_thing.under)
		local def_ptu = minetest.registered_nodes[node_ptu.name]
		if def_ptu and def_ptu.on_rightclick then
			return def_ptu.on_rightclick(pointed_thing.under, node_ptu, placer,
				itemstack, pointed_thing)
		end
	end

	local pos = pointed_thing.under
	if minetest.get_node(pos).name ~= "default:sand" then
		return itemstack
	end
	local pos_top = {x = pos.x, y = pos.y + 0.99, z = pos.z}
	local node_top = minetest.get_node(pos_top)
	local def_top = minetest.registered_nodes[node_top.name]
	local player_name = placer:get_player_name()

	if def_top and def_top.liquidtype == "source" and
			minetest.get_item_group(node_top.name, "water") > 0 then
		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pos_top, player_name) then
			minetest.set_node(pos, {name = itemstack:get_name()})
			if not (creative and creative.is_enabled_for
					and creative.is_enabled_for(player_name)) then
				itemstack:take_item()
			end
		else
			minetest.chat_send_player(player_name, S("Node is protected"))
			minetest.record_protection_violation(pos, player_name)
		end
	end
	return itemstack
end

local function algae_on_place(itemstack, placer, pointed_thing)
	-- Call on_rightclick if the pointed node defines it
	if pointed_thing.type == "node" and placer and not placer:get_player_control().sneak then
		local node_ptu = minetest.get_node(pointed_thing.under)
		local def_ptu = minetest.registered_nodes[node_ptu.name]
		if def_ptu and def_ptu.on_rightclick then
			return def_ptu.on_rightclick(pointed_thing.under, node_ptu, placer,
				itemstack, pointed_thing)
		end
	end

	local pos = pointed_thing.under
	if minetest.get_node(pos).name ~= "default:sand" then
		return itemstack
	end

	local height = math.random(4, 6)
	local pos_top = {x = pos.x, y = pos.y + height, z = pos.z}
	local node_top = minetest.get_node(pos_top)
	local def_top = minetest.registered_nodes[node_top.name]
	local player_name = placer:get_player_name()

	if def_top and def_top.liquidtype == "source" and
			minetest.get_item_group(node_top.name, "water") > 0 then
		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pos_top, player_name) then
			minetest.set_node(pos, {name = itemstack:get_name(),
				param2 = height * 16})
			if not (creative and creative.is_enabled_for
					and creative.is_enabled_for(player_name)) then
				itemstack:take_item()
			end
		else
			minetest.chat_send_player(player_name, S("Node is protected"))
			minetest.record_protection_violation(pos, player_name)
		end
	end
	return itemstack
end

--
-- Nodes
--

aquaz.corals = {
	{
	name = "aquaz:rhodophyta",
	description= "Rhodophyta Coral",
	tiles = "aquaz_rhodophyta_base.png",
	special_tiles = "aquaz_rhodophyta_top.png",
	inventory_image = "aquaz_rhodophyta_inv.png",
	},
	{
	name = "aquaz:psammocora",
	description= "Psammocora Coral",
	tiles = "aquaz_psammocora_base.png",
	special_tiles = "aquaz_psammocora_top.png",
	inventory_image = "aquaz_psammocora_inv.png",
	},
	{
	name = "aquaz:sarcophyton",
	description= "Sarcophyton Coral",
	tiles = "aquaz_sarcophyton_base.png",
	special_tiles = "aquaz_sarcophyton_top.png",
	inventory_image = "aquaz_sarcophyton_inv.png",
	},
	{
	name = "aquaz:carnation",
	description= "Carnation Coral",
	tiles = "aquaz_carnation_base.png",
	special_tiles = "aquaz_carnation_top.png",
	inventory_image = "aquaz_carnation_inv.png",
	},
	{
	name = "aquaz:fiery_red",
	description= "Fiery Red Coral",
	tiles = "aquaz_fiery_red_base.png",
	special_tiles = "aquaz_fiery_red_top.png",
	inventory_image = "aquaz_fiery_red_inv.png",
	},
	{
	name = "aquaz:acropora",
	description= "Acropora Coral",
	tiles = "aquaz_acropora_base.png",
	special_tiles = "aquaz_acropora_top.png",
	inventory_image = "aquaz_acropora_inv.png",
	},
}

for i = 1, #aquaz.corals do
	minetest.register_node(aquaz.corals[i].name, {
		description = S(aquaz.corals[i].description),
		drawtype = "plantlike_rooted",
		visual_scale = 1.0,
		tiles = {aquaz.corals[i].tiles},
		special_tiles = {
		nil,
		nil,
		aquaz.corals[i].special_tiles,
		aquaz.corals[i].special_tiles,
		aquaz.corals[i].special_tiles,
		aquaz.corals[i].special_tiles
		},
		inventory_image = aquaz.corals[i].inventory_image,
		paramtype = "light",
		walkable = true,
		groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
		sounds = default.node_sound_leaves_defaults(),
		after_place_node = default.after_place_leaves,
	})
end

aquaz.algaes = {
	{
	name = "aquaz:calliarthon_kelp",
	description="Calliarthron Kelp",
	texture = "aquaz_calliarthron_kelp.png"
	},
	{
	name = "aquaz:sea_blade_coral",
	description="Sea Blade Coral",
	texture = "aquaz_sea_blade_coral.png"
	},
}

for i = 1, #aquaz.algaes do
	minetest.register_node(aquaz.algaes[i].name, {
		description = S(aquaz.algaes[i].description),
		drawtype = "plantlike_rooted",
		waving = 1,
		tiles = {"default_sand.png"},
		special_tiles = {{name = aquaz.algaes[i].texture, tileable_vertical = true}},
		inventory_image = aquaz.algaes[i].texture,
		paramtype = "light",
		paramtype2 = "leveled",
		groups = {snappy = 3},
		selection_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
					{-2/16, 0.5, -2/16, 2/16, 3.5, 2/16},
			},
		},
		node_dig_prediction = "default:sand",
		node_placement_prediction = "",
		sounds = default.node_sound_sand_defaults({
			dig = {name = "default_dig_snappy", gain = 0.2},
			dug = {name = "default_grass_footstep", gain = 0.25},
		}),

		on_place = algae_on_place,

		after_destruct  = function(pos, oldnode)
			minetest.set_node(pos, {name = "default:sand"})
		end
	})
end

--
-- Decoration
--

if mg_name ~= "v6" and mg_name ~= "singlenode" then
	minetest.register_decoration({
		name = "aquaz:corals",
		decoration = {
			"aquaz:psammocora",
			"aquaz:rhodophyta",
			"aquaz:sarcophyton",
			"aquaz:carnation",
			"aquaz:fiery_red",
			"aquaz:acropora",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.04,
			scale = 0.05,
			spread = {x = 200, y = 200, z = 200},
			seed = 25345,
			octaves = 3,
			persist = 0.7
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -2,
		y_min = -10,
		flags = "force_placement",
	})
end

if mg_name ~= "v6" and mg_name ~= "singlenode" then
	minetest.register_decoration({
		name = "aquaz:kelps",
		decoration = {
			"aquaz:calliarthon_kelp",
			"aquaz:sea_blade_coral"
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.005,
			scale = 0.004,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
end

aquaz.grass= {
	{
	name = "aquaz:grass",
	description= "Aquatic Grass",
	special_tiles = "aquaz_grass.png",
	},
	{
	name = "aquaz:tall_grass",
	description= "Aquatic Tall Grass",
	special_tiles = "aquaz_tall_grass.png",
	},
	{
	name = "aquaz:stars_anemons",
	description= "Grass with Stars and Anemons",
	special_tiles = "aquaz_stars_anemons.png",
	drop = "aquaz:tall_grass"
	},
	{
	name = "aquaz:stars_anemons_2",
	description= "Grass with Stars and Anemons",
	special_tiles = "aquaz_stars_anemons_2.png",
	drop = "aquaz:tall_grass"
	},
	{
	name = "aquaz:aquamarine_coral_branch",
	description= "Aquamarine Coral Branch",
	special_tiles = "aquaz_aquamarine_coral_branch.png",
	},
	{
	name = "aquaz:pink_birdnest_coral",
	description= "Pink Birdnest Coral",
	special_tiles = "aquaz_pink_birdnest_coral.png",
	},
	{
	name = "aquaz:sea_cucumbers",
	description= "Sea Cucumbers",
	special_tiles = "aquaz_sea_cucumbers.png",
	},
	{
	name = "aquaz:sword_plant",
	description= "Aquatic Sword Plant",
	special_tiles = "aquaz_sword_plant.png",
	},
}

for i = 1, #aquaz.grass do
	local drop
	if aquaz.grass[i].drop then
		drop = aquaz.grass[i].drop
	else
		drop = aquaz.grass[i].name
	end
	minetest.register_node(aquaz.grass[i].name, {
		description = S(aquaz.grass[i].description),
		drawtype = "plantlike_rooted",
		waving = 1,
		paramtype = "light",
		tiles = {"default_sand.png"},
		special_tiles = {{name = aquaz.grass[i].special_tiles, tileable_vertical = true}},
		inventory_image = aquaz.grass[i].special_tiles,
		wield_image = aquaz.grass[i].special_tiles,
		drop = drop,
		groups = {snappy = 3},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
				{-4/16, 0.5, -4/16, 4/16, 1.5, 4/16},
			},
		},
		node_dig_prediction = "default:sand",
		node_placement_prediction = "",
		sounds = default.node_sound_stone_defaults({
			dig = {name = "default_dig_snappy", gain = 0.2},
			dug = {name = "default_grass_footstep", gain = 0.25},
		}),

		on_place = plant_on_place,

		after_destruct  = function(pos, oldnode)
			minetest.set_node(pos, {name = "default:sand"})
		end,
	})
end

if mg_name ~= "v6" and mg_name ~= "singlenode" then
	minetest.register_decoration({
		name = "aquaz:grass",
		decoration = {
			"aquaz:grass",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0025,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 23232,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:tall_grass",
		decoration = {
			"aquaz:tall_grass",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.00125,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 2323,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:stars_anemons",
		decoration = {
			"aquaz:stars_anemons",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 343,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:stars_anemons_2",
		decoration = {
			"aquaz:stars_anemons_2",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 733,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:aquamarine_coral_branch",
		decoration = {
			"aquaz:aquamarine_coral_branch",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 82,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:pink_birdnest_coral",
		decoration = {
			"aquaz:pink_birdnest_coral",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 1729,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:sea_cucumbers",
		decoration = {
			"aquaz:sea_cucumbers",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 568,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
	minetest.register_decoration({
		name = "aquaz:sword_plant",
		decoration = {
			"aquaz:sword_plant",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.04,
			spread = {x = 250, y = 250, z = 250},
			seed = 568,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		param2 = 48,
		param2_max = 96,
	})
end

--Wrecked Pillar

aquaz.wrecked_pillar = {
	{
	name = "aquaz:wrecked_pillar_base",
	description= "Wrecked Pillar Base",
	tile = "aquaz_base_pillar.png"
	},
	{
	name = "aquaz:wrecked_pillar_shaft",
	description= "Wrecked Pillar Shaft",
	tile = "aquaz_shaft_pillar.png"
	},
	{
	name = "aquaz:wrecked_pillar_capital",
	description= "Wrecked Pillar Capital",
	tile = "aquaz_capital_pillar.png"
	},
}

for i = 1, #aquaz.wrecked_pillar do
	minetest.register_node(aquaz.wrecked_pillar[i].name, {
		description = S(aquaz.wrecked_pillar[i].description),
		tiles = {
			"aquaz_up_down_pillar.png",
			"aquaz_up_down_pillar.png",
			aquaz.wrecked_pillar[i].tile,
		},
		is_ground_content = false,
		groups = {cracky = 2, stone = 1},
		sounds = default.node_sound_stone_defaults(),
	})
end

aquaz.coral_deco = {
	{
	name = "aquaz:purple_alga",
	description= "Purple Alga Remains",
	tile = "aquaz_purple_alga.png"
	},
	{
	name = "aquaz:orange_alga",
	description= "Orange Alga Remains",
	tile = "aquaz_orange_alga.png"
	},
	{
	name = "aquaz:red_alga",
	description= "Red Alga Remains",
	tile = "aquaz_red_alga.png"
	},
}

for i = 1, #aquaz.coral_deco do
	minetest.register_node(aquaz.coral_deco[i].name, {
		description = S(aquaz.coral_deco[i].description),
		drawtype = "nodebox",
		walkable = true,
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = {aquaz.coral_deco[i].tile},
		use_texture_alpha = true,
		inventory_image = aquaz.coral_deco[i].tile,
		wield_image = aquaz.coral_deco[i].tile,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -0.499, 0.5}
		},
		groups = {
			snappy = 2, flammable = 3, oddly_breakable_by_hand = 3, choppy = 2, carpet = 1, leafdecay = 3, leaves = 1
		},
		sounds = default.node_sound_leaves_defaults(),

		on_use = minetest.item_eat(4),
	})
end

if mg_name ~= "v6" and mg_name ~= "singlenode" then
	minetest.register_decoration({
		name = "aquaz:algaes",
		decoration = {
			"aquaz:purple_alga",
			"aquaz:orange_alga",
			"aquaz:red_alga",
		},
		deco_type = "simple",
		place_on = {"default:sand"},
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.0004,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean"
		},
		y_max = 2,
		y_min = 1,
		flags = "force_placement",
	})
end

minetest.register_decoration({
    deco_type = "schematic",
    place_on = {"default:sand"},
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.0001,
	biomes = {
		"grassland_ocean",
		"coniferous_forest_ocean",
		"deciduous_forest_ocean"
	},
    y_max = -6,
    y_min = -10,
    schematic = modpath .. "/schematics/wrecked_pillar.mts",
    rotation = "random",
    flags = "force_placement, place_center_x, place_center_z",
})
