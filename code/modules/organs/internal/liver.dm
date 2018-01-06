/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	organ_tag = O_LIVER
	parent_organ = BP_GROIN

/obj/item/organ/internal/liver/process()

	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			owner << SPAN_DANG("Your skin itches.")
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	if(owner.life_tick % PROCESS_ACCURACY == 10)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else
				var/obj/item/organ/internal/O = pick(owner.internal_organs)
				if(O)
					O.damage += 0.2  * PROCESS_ACCURACY

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(is_bruised())
			filter_effect -= 1
		if(is_broken())
			filter_effect -= 2

		// Damaged liver means some chemicals are very dangerous
		if(src.damage >= src.min_bruised_damage)
			for(var/datum/reagent/R in owner.reagents.reagent_list)
				// Ethanol and all drinks are bad
				if(istype(R, /datum/reagent/ethanol))
					owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
				// Can't cope with toxins at all
				if(istype(R, /datum/reagent/toxin))
					owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)
