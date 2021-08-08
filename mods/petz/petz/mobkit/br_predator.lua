--
-- PREDATOR BRAIN
--

function petz.predator_brain(self)

	local pos = self.object:get_pos()

	mobkit.vitals(self)

	if self.hp <= 0 then -- Die Behaviour
		petz.on_die(self)
		return
	end

	petz.check_ground_suffocation(self, pos)

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)

		if prty < 40 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 40)
			return
		end

		local player = mobkit.get_nearby_player(self) --get the player close

		if prty < 30 then
			petz.env_damage(self, pos, 30) --enviromental damage: lava, fire...
		end

		--Follow Behaviour
		if prty < 16 then
			if petz.bh_start_follow(self, pos, player, 16) then
				return
			end
		end

		if prty == 16 then
			if petz.bh_stop_follow(self, player) then
				return
			end
		end

		-- hunt a prey
		if prty < 12 then -- if not busy with anything important
			 petz.bh_hunt(self, 12, false)
		end

		if prty < 10 then
			if player then
				if petz.bh_attack_player(self, pos, 10, player) then
					return
				end
			end
		end

		--Replace nodes by others
		if prty < 6 then
			petz.bh_replace(self)
		end

		if prty < 5 then
			petz.bh_breed(self, pos)
		end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		--Roam default
		if mobkit.is_queue_empty_high(self) and not(self.status) then
			mobkit.hq_roam(self, 0)
		end

	end
end
