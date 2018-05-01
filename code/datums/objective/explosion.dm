/datum/objective/explosion
	explanation_text = "Arrange a terrorist act. Expode at least two of command rooms (Head office, EVA, bridge, etc)"
	target_amount = 2
	var/global/list/command_rooms = list(
		/area/ai_monitored/storage/eva,
		/area/turret_protected/ai,
		/area/turret_protected/ai_upload,
		/area/crew_quarters/heads/hop,
		/area/crew_quarters/heads/hor,
		/area/crew_quarters/heads/chief,
		/area/crew_quarters/heads/hos,
		/area/crew_quarters/heads/cmo,
		/area/crew_quarters/heads/captain,
		/area/security/armoury,
		/area/tcommsat/chamber,
		/area/engineering/engine_room,
		/area/engineering/atmos,
		/area/bridge,
		/area/server
	)

/datum/objective/explosion/check_completion()
	var/ammount = 0
	for(var/item in explosions_log)
		var/datum/log/explosion/E = item
		if(!(E.location in command_rooms))
			continue
		if(E.devastation_range<1)
			continue
		ammount += 1
	return ammount >= target_amount