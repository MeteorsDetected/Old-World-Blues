/datum/objective/capture

/datum/objective/capture/find_target()
	target_amount = rand(5,10)
	update_explanation()

/datum/objective/capture/update_explanation()
	explanation_text = "Accumulate [target_amount] capture points."

/datum/objective/capture/get_panel_entry()
	return "Accumulate <a href='?src=\ref[src];switch_amount=Capture points'>[target_amount]</a> capture points."

//Basically runs through all the mobs in the area to determine how much they are worth.
/datum/objective/capture/check_completion()
	var/captured_amount = 0
	var/area/centcom/holding/A = locate()

	// Humans (and subtypes).
	for(var/mob/living/carbon/human/M in A)
		var/worth = M.species.rarity_value
		if(M.stat == DEAD)//Dead folks are worth less.
			worth *= 0.5
		captured_amount += worth

	//Larva are important for research.
	for(var/mob/living/carbon/alien/larva/M in A)
		if(M.stat == DEAD)
			captured_amount += 0.5
		captured_amount += 1

	return (captured_amount >= target_amount)
