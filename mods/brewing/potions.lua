local S = ...

brewing.register_potion("speed", S("Speed"), "brewing:speed", {
	effect = "phys_override",
	types = {
		{
			type = 1,
			set = {},
			effects = {
				speed = 1,
			},
			time = 60,
		},
		{
			type = 2,
			set = {},
			effects = {
				speed = 2,
			},
			time = 30,
		},
		{
			type = 3,
			set = {},
			effects = {
				speed = 3,
			},
			time = 15,
		},
	}
})

brewing.register_potion("antigrav", S("Anti-Gravity"), "brewing:antigravity", {
	effect = "phys_override",
	types = {
		{
			type = 1,
			set = {},
			effects = {
				gravity = -0.1,
			},
			time = 60,
		},
		{
			type = 2,
			set = {},
			effects = {
				gravity = -0.2,
			},
			time = 30,
		},
		{
			type = 3,
			set = {},
			effects = {
				gravity = -0.3,
			},
			time = 15,
		},
	}
})

brewing.register_potion("jump", S("Jump"), "brewing:jump", {
	effect = "phys_override",
	types = {
		{
			type = 1,
			set = {},
			effects = {
				jump = 1.3,
			},
			time = 60,
		},
		{
			type = 2,
			set = {},
			effects = {
				jump = 1.75,
			},
			time = 30,
		},
		{
			type = 3,
			set = {},
			effects = {
				jump = 2.2,
			},
			time = 15,
		},
	}
})

brewing.register_potion("ouhealth", S("One Use Health"), "brewing:ouhealth", {
	effect = "fixhp",
	types = {
		{
			type = 1,
			hp = 20,
			set = {},
			effects = {
			},
		},
		{
			type = 2,
			hp = 40,
			set = {},
			effects = {
			},
		},
		{
			type = 3,
			hp = 60,
			set = {},
			effects = {
			},
		},
	}
})

brewing.register_potion("health", S("Health"), "brewing:health", {
	effect = "fixhp",
	types = {
		{
			type = 1,
			time = 15,
			set = {},
			effects = {
			},
		},
		{
			type = 2,
			time = 30,
			set = {},
			effects = {
			},
		},
		{
			type = 3,
			time = 60,
			set = {},
			effects = {
			},
		},
	}
})

brewing.register_potion("ouair", S("One Use Air"), "brewing:ouair", {
	effect = "air",
	types = {
		{
			type = 1,
			br = 2,
			set = {},
			effects = {
			},
		},
		{
			type = 2,
			br = 5,
			set = {},
			effects = {
			},
		},
		{
			type = 3,
			br = 10,
			set = {},
			effects = {
			},
		},
	}
})

brewing.register_potion("air", S("Air"), "brewing:air", {
	effect = "air",
	types = {
		{
			type = 1,
			time = 15,
			set = {},
			effects = {
			},
		},
		{
			type = 2,
			time = 30,
			set = {},
			effects = {
			},
		},
		{
			type = 3,
			time = 60,
			set = {},
			effects = {
			},
		},
	}
})

brewing.register_potion("invisibility", S("Invisibility"), "brewing:invisibility", {
	effect = "invisibility",
	types = {
		{
			type = 1,
			set = {},
			effects = {
			},
			time = 15,
		},
		{
			type = 2,
			set = {},
			effects = {
			},
			time = 30,
		},
		{
			type = 3,
			set = {},
			effects = {
			},
			time = 60,
		},
	}
})

brewing.register_potion("resist_fire", S("Resist Fire"), "brewing:resist_fire", {
	effect = "resist_fire",
	types = {
		{
			type = 1,
			set = {},
			effects = {
			},
			time = 15,
		},
		{
			type = 2,
			set = {},
			effects = {
			},
			time = 30,
		},
		{
			type = 3,
			set = {},
			effects = {
			},
			time = 60,
		},
	}
})

brewing.register_potion("teleport", S("Teleport"), "brewing:teleport", {
	effect = "teleport",
	types = {
		{
			type = 1,
			set = {},
			effects = {
			},
			time = 300,
		},
		{
			type = 2,
			set = {},
			effects = {
			},
			time = 1200,
		},
		{
			type = 3,
			set = {},
			effects = {
			},
			time = 3600,
		},
	}
})
