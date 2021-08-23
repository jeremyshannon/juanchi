-- Saddlebag API functions

local function free_saddlebag(self)
	mokapi.drop_item(self, ItemStack("petz:saddlebag"))
	--Drop the items from petz inventory
	local inv = self.saddlebag_inventory
	for key, value in pairs(inv) do
		mokapi.drop_item(self, ItemStack(value))
	end
	self.saddlebag = mobkit.remember(self, "saddlebag", false)
	self.saddlebag_inventory = {} --clear inventory
	mokapi.make_sound("object", self.object, "petz_pop_sound", petz.settings.max_hear_distance)
end

local function free_saddle(self)
	mokapi.drop_item(self, ItemStack("petz:saddle"))
	self.saddle = mobkit.remember(self, "saddle", false)
	mokapi.make_sound("object", self.object, "petz_pop_sound", petz.settings.max_hear_distance)
end

function petz.free_saddles(self)
	if self.saddle then -- drop saddle
		free_saddle(self)
	end
	if self.saddlebag then -- drop saddlebag and its content
		free_saddlebag(self)
	end
end
