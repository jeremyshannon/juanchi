local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- Register Biomes

minetest.register_biome({
	name = "salt_desert",
	node_top = "saltd:salt_sand",
	depth_top = 1,
	node_filler = "saltd:salt_crystal_block",
	depth_filler = 3,
	node_riverbed = "saltd:salt_sand",
	depth_riverbed = 2,
	node_water = "default:water_source",
	depth_water_top = 5,
	node_water_top = "default:water_source",
	node_stone = "default:stone",
	y_max = 5,
	y_min = 1,
	heat_point = 50,
	humidity_point = 10,
	vertical_blend = 0,
})

-- Register Nodes

minetest.register_node("saltd:salt_sand", {
	description = S("Salt Sand"),
	tiles = {"saltd_salt_sand.png"},
	drop = "saltd:salt 6",
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("saltd:salt_crystal_block", {
	description = S("Salt Crystal Block"),
	drawtype = "glasslike_framed_optional",
	tiles = {"saltd_salt_crystal_block.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	param2 = 255,
	use_texture_alpha = "blend",
	sunlight_propagates = false,
	groups = {cracky = 1},
	sounds = default.node_sound_glass_defaults(),
	walkable = true,
	drop = "saltd:salt_crystals 6"
})

minetest.register_node("saltd:humid_salt_sand", {
	description = S("Humid Salt Sand"),
	tiles = {"saltd_humid_salt_sand.png"},
	drop = "saltd:salt 6",
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("saltd:barren", {
	description = S("Barren"),
	tiles = {"saltd_barren.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("saltd:salt_gem", {
	description = S("Salt Gem"),
	drawtype = "plantlike",
	tiles = {"saltd_salt_gem.png"},
	inventory_image = "saltd_salt_gem.png",
	wield_image = "saltd_salt_gem.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	use_texture_alpha = "blend",
	walkable = true,
	drop = "saltd:salt_crystals",
	collision_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 3 / 16, 3 / 16},
	},
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 3 / 16, 3 / 16},
	},
	groups = {cracky = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craftitem("saltd:salt_crystals", {
    description = S("Salt Crystals"),
    wield_image = "saltd_salt_crystals.png",
    inventory_image = "saltd_salt_crystals.png",
    groups = {salt= 1},
})

minetest.register_craftitem("saltd:salt", {
    description = S("Salt"),
    wield_image = "saltd_salt.png",
    inventory_image = "saltd_salt.png",
    groups = {salt= 1},
})

minetest.register_craft({
	type = "shapeless",
	output = "saltd:salt",
	recipe = {"saltd:salt_crystals"},
})

minetest.register_node("saltd:burnt_bush", {
	description = S("Salt-burnt Bush"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"saltd_burnt_bush.png"},
	inventory_image = "saltd_burnt_bush.png",
	wield_image = "saltd_burnt_bush.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 4,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16},
	},
})

minetest.register_node("saltd:thorny_bush", {
	description = S("Thorny Bush"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"saltd_thorny_bush.png"},
	inventory_image = "saltd_thorny_bush.png",
	wield_image = "saltd_thorny_bush.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 4,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16},
	},
})

minetest.register_node("saltd:burnt_trunk", {
	description = S("Salt-burnt Trunk"),
	tiles = {
		"saltd_burnt_trunk_top.png",
		"saltd_burnt_trunk_top.png",
		"saltd_burnt_trunk.png"
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 1},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
})

minetest.register_node("saltd:burnt_branches", {
	description = S("Burnt Branches"),
	drawtype = "allfaces_optional",
	tiles = {"saltd_burnt_branches.png"},
	inventory_image = "saltd_burnt_branches.png",
	wield_image = "saltd_burnt_branches.png",
	paramtype = "light",
	walkable = true,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("saltd:burnt_grass", {
	description = S("Burnt Grass"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"saltd_burnt_grass.png"},
	inventory_image = "saltd_burnt_grass.png",
	wield_image = "saltd_burnt_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -0.1875, 3 / 16},
	},
})

if mg_name ~= "v6" and mg_name ~= "singlenode" then

	minetest.register_decoration({
		decoration = "saltd:humid_salt_sand",
		deco_type = "simple",
		place_on = "saltd:salt_sand",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"salt_desert"},
		noise_params = {
			offset = 0.5,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		spawn_by = "default:water_source",
		num_spawn_by = 1,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		decoration = "saltd:barren",
		deco_type = "simple",
		place_on = "saltd:salt_sand",
		sidelen = 4,
		biomes = {"salt_desert"},
		noise_params = {
			offset = 1,
			scale = 4,
			spread = {x = 50, y = 50, z = 50},
			seed = 321,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 5,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		decoration = "saltd:burnt_bush",
		deco_type = "simple",
		place_on = {"saltd:barren","saltd:salt_sand"},
		sidelen = 16,
		noise_params = {
			offset = 0.005,
			scale = 0.002,
			spread = {x = 200, y = 200, z = 200},
			seed = 322129,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"salt_desert"},
		y_max = 5,
		y_min = 1,
		param2 = 4,
	})

	minetest.register_decoration({
		decoration = "saltd:thorny_bush",
		deco_type = "simple",
		place_on = {"saltd:barren"},
		sidelen = 16,
		noise_params = {
			offset = 0.005,
			scale = 0.002,
			spread = {x = 200, y = 200, z = 200},
			seed = 523,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"salt_desert"},
		y_max = 5,
		y_min = 1,
		param2 = 4,
	})

	minetest.register_decoration({
		decoration = "saltd:salt_gem",
		deco_type = "simple",
		place_on = "saltd:salt_sand",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"salt_desert"},
		noise_params = {
			offset = 0.008,
			scale = 0.01,
			spread = {x = 250, y = 250, z = 250},
			seed = 534,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 5,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		decoration = "saltd:humid_salt_sand",
		deco_type = "simple",
		place_on = "saltd:salt_sand",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"salt_desert"},
		noise_params = {
			offset = 0.05,
			scale = 0.08,
			spread = {x = 250, y = 250, z = 250},
			seed = 534,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 5,
		spawn_by = "saltd:salt_sand",
		num_spawn_by = 1,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	-- Register Salt-burnt Trees
	local burnt_tree_name
	for i = 1, 3 do
		burnt_tree_name = "salt-burnt_tree_"..tostring(i)
		minetest.register_decoration({
			name = "saltd:"..burnt_tree_name,
			deco_type = "schematic",
			place_on = {"saltd:barren","saltd:salt_sand"},
			sidelen = 16,
			noise_params = {
				offset = 0.0005,
				scale = 0.00005,
				spread = {x = 250, y = 250, z = 250},
				seed = 43 + i,
				octaves = 3,
				persist = 0.66
			},
			biomes = {"salt_desert"},
			y_min = 1,
			y_max = 5,
			place_offset_y = 1,
			schematic = modpath.."/schematics/"..burnt_tree_name..".mts",
			flags = "place_center_x, place_center_z, force_placement",
			rotation = "random",
		})
	end

	minetest.register_decoration({
		name = "saltd:burnt_tree_log",
		deco_type = "schematic",
		place_on = {"saltd:barren","saltd:salt_sand"},
		sidelen = 16,
		noise_params = {
			offset = 0.0005,
			scale = 0.00005,
			spread = {x = 250, y = 250, z = 250},
			seed = 12312,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"salt_desert"},
		y_min = 1,
		y_max = 5,
		schematic = modpath.."/schematics/salt-burnt_tree_log.mts",
		place_offset_y = 1,
		flags = "place_center_x",
		rotation = "random",
	})

	minetest.register_decoration({
		decoration = "saltd:burnt_grass",
		deco_type = "simple",
		place_on = "saltd:barren",
		sidelen = 16,
		biomes = {"salt_desert"},
		noise_params = {
			offset = 0.01,
			scale = 0.01,
			spread = {x = 250, y = 250, z = 250},
			seed = 2434,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 5,
	})
end
