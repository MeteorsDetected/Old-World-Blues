/datum/objective/heist/salvage
	var/global/targets = list(
		MATERIAL_STEEL = 75,
		MATERIAL_GLASS = 50,
		MATERIAL_PLASTEEL = 25,
		MATERIAL_PHORON = 25,
		MATERIAL_SILVER = 12,
		MATERIAL_GOLD = 5,
		MATERIAL_URANIUM = 5,
		MATERIAL_DIAMOND = 5
	)

/datum/objective/heist/salvage/find_target()
	target = pick(targets)
	target_amount = targets[target]
	update_explanation()

/datum/objective/heist/salvage/update_explanation()
	explanation_text = "Ransack the station and escape with [target_amount] [target]."

/datum/objective/heist/salvage/get_panel_entry()
	return "Steal <a href='src=\ref[src];select_item=1'>[target_amount]</a> \
		<a href='src=\ref[src];set_amount'>[target]</a>."

/datum/objective/heist/salvage/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["select_item"])
		var/new_target = input("Select material for steal", "Target", target) as null|anything in targets
		if(!new_target)
			return
		target = new_target
		target_amount = targets[target]
		owner.edit_memory()


/datum/objective/heist/salvage/check_completion()

	var/total_amount = 0

	for(var/obj/item/O in locate(/area/skipjack_station/start))
		var/obj/item/stack/material/S
		if(istype(O) && O.get_material() == target)
			S = O
			total_amount += S.get_amount()
		for(var/obj/I in O.contents)
			if(ismaterial(I) && I.get_material() == target)
				S = I
				total_amount += S.get_amount()

	for(var/datum/mind/raider in raiders.current_antagonists)
		if(raider.current)
			for(var/obj/item/O in raider.current.get_contents())
				if(ismaterial(O) && O.get_material() == target)
					var/obj/item/stack/material/S = O
					total_amount += S.get_amount()

	return total_amount >= target_amount