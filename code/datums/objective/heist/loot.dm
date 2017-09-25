/datum/objective/heist/loot
	var/global/list/targets = list(
		"a complete particle accelerator" = list(/obj/structure/particle_accelerator, 6),
		"a gravitational generator" = list(/obj/machinery/the_singularitygen, 1),
		"four emitters" = list(/obj/machinery/power/emitter, 4),
		"a nuclear bomb" = list(/obj/machinery/nuclearbomb, 1),
		"six guns" = list(/obj/item/weapon/gun, 6),
		"four energy guns" = list(/obj/item/weapon/gun/energy, 4),
		"two laser guns" = list(/obj/item/weapon/gun/energy/laser, 2),
		"an ion gun" = list(/obj/item/weapon/gun/energy/ionrifle, 1)
	)

/datum/objective/heist/loot/find_target()
	target = pick(targets)
	target_amount = targets[target][2]
	update_explanation()

/datum/objective/heist/loot/update_explanation()
	explanation_text = "It's a buyer's market out here. Steal [target] for resale."

/datum/objective/heist/loot/get_panel_entry()
	return "Steal <a href='src=\ref[src];select_item=1'>[target]</a>."

/datum/objective/heist/loot/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["select_item"])
		var/new_target = input("Select new target for steal", "Target", target) as null|anything in targets
		if(!new_target)
			return
		target = new_target
		target_amount = targets[target][2]
		owner.edit_memory()

/datum/objective/heist/loot/check_completion()
	var/total_amount = 0
	var/target_path = targets[target][1]

	for(var/obj/O in locate(/area/skipjack_station/start))
		if(istype(O, target_path))
			total_amount++
		for(var/obj/I in O.contents)
			if(istype(I, target_path))
				total_amount++
		if(total_amount >= target_amount)
			return TRUE

	for(var/datum/mind/raider in raiders.current_antagonists)
		if(raider.current)
			for(var/obj/O in raider.current.get_contents())
				if(istype(O,target_path))
					total_amount++
				if(total_amount >= target_amount)
					return TRUE

	return FALSE

