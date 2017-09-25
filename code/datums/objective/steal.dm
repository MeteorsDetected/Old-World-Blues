/datum/objective/steal
	var/obj/item/steal_target
	var/target_name

	var/global/list/possible_items = list(
		"the captain's antique laser gun" = /obj/item/weapon/gun/energy/captain,
		"a hand teleporter" = /obj/item/weapon/hand_tele,
		"an RCD" = /obj/item/weapon/rcd,
		"a jetpack" = /obj/item/weapon/tank/jetpack,
		"a captain's jumpsuit" = /obj/item/clothing/under/rank/captain,
		"a functional AI" = /obj/item/device/aicard,
		"a pair of magboots" = /obj/item/clothing/shoes/magboots,
		"the station blueprints" = /obj/item/blueprints,
		"a nasa voidsuit" = /obj/item/clothing/suit/space/void,
		"28 moles of phoron (full tank)" = /obj/item/weapon/tank,
		"a sample of slime extract" = /obj/item/slime_extract,
		"a piece of corgi meat" = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
		"a research director's jumpsuit" = /obj/item/clothing/under/rank/research_director,
		"a chief engineer's jumpsuit" = /obj/item/clothing/under/rank/chief_engineer,
		"a chief medical officer's jumpsuit" = /obj/item/clothing/under/rank/chief_medical_officer,
		"a head of security's jumpsuit" = /obj/item/clothing/under/rank/head_of_security,
		"a head of personnel's jumpsuit" = /obj/item/clothing/under/rank/hop,
		"the hypospray" = /obj/item/weapon/reagent_containers/hypospray,
		"the captain's pinpointer" = /obj/item/weapon/pinpointer,
		"an ablative armor vest" = /obj/item/clothing/suit/armor/laserproof,
	)

	var/global/list/possible_items_special = list(
		"nuclear gun" = /obj/item/weapon/gun/energy/gun/nuclear,
		"diamond drill" = /obj/item/weapon/pickaxe/diamonddrill,
		"bag of holding" = /obj/item/storage/backpack/holding,
		"hyper-capacity cell" = /obj/item/weapon/cell/hyper,
		"10 diamonds" = /obj/item/stack/material/diamond,
		"50 gold bars" = /obj/item/stack/material/gold,
		"25 refined uranium bars" = /obj/item/stack/material/uranium,
	)


/datum/objective/steal/proc/set_target(var/item_name)
	target_name = item_name
	steal_target = possible_items[target_name]
	if(!steal_target)
		steal_target = possible_items_special[target_name]
	explanation_text = "Steal [target_name]."
	return steal_target


/datum/objective/steal/find_target()
	return set_target(pick(possible_items))


/datum/objective/steal/proc/select_target(var/mob/user)
	var/list/possible_items_all = possible_items + possible_items_special
	var/new_target = input(user, "Select target:", "Objective target", steal_target) as null|anything in possible_items_all
	if(!new_target)
		return

	set_target(new_target)
	owner.edit_memory()
	return steal_target

/datum/objective/steal/check_completion()
	if(!steal_target || !owner.current)
		return FALSE
	if(!isliving(owner.current))
		return FALSE
	var/list/all_items = owner.current.get_contents()
	switch(target_name)
		if("10 diamonds","50 gold bars","25 refined uranium bars")
			var/target_amount = text2num(target_name)//Non-numbers are ignored.
			var/found_amount = 0.0//Always starts as zero.

			for(var/obj/item/stack/material/M in all_items) //Check for phoron tanks
				if(istype(M, steal_target))
					found_amount += M.amount
			return found_amount >= target_amount

		if("28 moles of phoron (full tank)")
			var/target_amount = text2num(target_name)//Non-numbers are ignored.
			var/found_amount = 0.0//Always starts as zero.

			for(var/obj/item/weapon/tank/T in all_items)
				found_amount += T.air_contents.gas["phoron"]
			return found_amount >= target_amount

		if("50 coins (in bag)")
			var/obj/item/weapon/moneybag/B = locate() in all_items

			if(B)
				var/target = text2num(target_name)
				var/found_amount = 0.0
				for(var/obj/item/weapon/coin/C in B)
					found_amount++
				return found_amount>=target

		if("a functional AI")

			for(var/obj/item/device/aicard/C in all_items) //Check for ai card
				for(var/mob/living/silicon/ai/M in C)
					//See if any AI's are alive inside that card.
					if(isAI(M) && M.stat != DEAD)
						return TRUE

			for(var/mob/living/silicon/ai/ai in mob_list)
				var/area/check_area = get_area(ai)
				if(check_area.is_escape_location)
					return TRUE
		else
			for(var/obj/I in all_items) //Check for items
				if(istype(I, steal_target))
					return TRUE
	return FALSE

/datum/objective/steal/get_panel_entry()
	return "Steal <a href='?src=\ref[src];switch_item=1'>[target_name]</a>."

/datum/objective/steal/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["switch_item"])
		select_target(usr)
